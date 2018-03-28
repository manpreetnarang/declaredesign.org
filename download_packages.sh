#!/bin/bash
set -x
temporary_directory=$(mktemp --directory)
pushd "$temporary_directory"

pwd

URLS=$'https://api.github.com/repos/DeclareDesign/DeclareDesign/tarball
https://api.github.com/repos/DeclareDesign/randomizr/tarball
https://api.github.com/repos/DeclareDesign/fabricatr/tarball
https://api.github.com/repos/DeclareDesign/estimatr/tarball'
echo "$URLS" | tr '\n' '\0' | xargs --max-args=1 --max-procs=8 --null wget # Passes the URLs to wget one at a time (--max-args=1). Runs a maximum of 8 wgets in parallel (--max-procs=8).

for tar_file in tarball*; do
  tar xf "$tar_file"
done

for package in {DeclareDesign,randomizr,fabricatr,estimatr}; do
  mv  DeclareDesign-${package}* "${package}_github"
done

popd

pwd

Rscript 'R/superBuild.R' "$temporary_directory"


find ./public -type f -name 'readme.html'
find ./public -type f -name 'readme.html' -execdir mv '{}' 'index.html' ';'
mv ./public/blog.html ./public/blog/index.html # By hand adjustments
rm ./public/categories.html ./public/conduct.html ./public/idea.html ./public/library.html ./public/r.html # By hand adjustments
mkdir -p ./public/r/estimatr/vignettes && cp ./public/r/estimatr/articles/lm_speed.png ./public/r/estimatr/articles/lm_speed_covars.png ./public/r/estimatr/vignettes # By hand adjustments
cp '_redirects' './public/_redirects'