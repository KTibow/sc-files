#!/usr/bin/fish

function repack_file
  set input_file_path $argv[1]
  set input_ext (string match -r '\.\w+$' $input_file_path)
  set input_no_ext (string replace $input_ext '' -- $input_file_path)
  set output_file_path (path resolve {$input_no_ext}_compressed$input_ext)
  set temp_dir /tmp/f

  # Unzip to /tmp/f
  rm -rf $temp_dir
  mkdir -p $temp_dir
  unzip $input_file_path -d $temp_dir

  # Remove unwanted files recursively
  # (macos, windows' ds_store)
  rm -rf $temp_dir/**/.DS_Store
  rm -rf $temp_dir/**/Thumbs.db
  rm -rf $temp_dir/__MACOSX
  find $temp_dir -type d -empty -exec rmdir {} \;

  # Optimize PNG files
  find $temp_dir -type f -name "*.png" -exec optipng {} \;

  # Rezip with max compression
  pushd $temp_dir
  7z a -mm=Deflate -mx=9 -mfb=258 -mpass=15 -mtc=off $output_file_path .
  popd

  chown kendell $output_file_path
  stripzip $output_file_path

  # Cleanup
  rm -rf $temp_dir
end

repack_file $argv
