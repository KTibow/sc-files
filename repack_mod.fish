#!/usr/bin/fish

function repack_file
  set input_file_path (path resolve $argv[1])
  set temp_dir /tmp/f

  # Unzip to /tmp/f
  rm -rf $temp_dir
  mkdir -p $temp_dir
  unzip $input_file_path -d $temp_dir

  # Rezip with max compression
  pushd $temp_dir
  7z a -mm=Deflate -mx=9 -mfb=258 -mpass=15 -mtc=off $input_file_path .
  popd

  chown kendell "$input_file_path"

  # Cleanup
  rm -rf $temp_dir
end

repack_file $argv
