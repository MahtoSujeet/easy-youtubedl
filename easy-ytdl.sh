#!/bin/bash

# Script Author: Sujeet Mahto
# GitHub.com/MahtoSujeet

# Version: 0.1

# IMPORTANT STUFF
# THIS SCRIPT REQUIRES the "youtube-dl" program: https://yt-dl.org/
# Direct link to latest youtube-dl executable: https://yt-dl.org/latest/youtube-dl
# YouTube-dl documentation: https://github.com/ytdl-org/youtube-dl/blob/master/README.md#readme
# Supported sites for Downloading: https://ytdl-org.github.io/youtube-dl/supportedsites.html
# See this script's Readme for more details

# Command Line Arguments
exe="yt-dlp"  # Default downloader executable
desktop=false  # Default output location
options="--no-mtime --add-metadata"  # Default download options
debug=true  # Display debug information

# Process command-line arguments (if any)
while getopts ":e:d:o:" opt; do
  case $opt in
    e) exe="$OPTARG" ;;
    d) desktop=true ;;
    o) options="$OPTARG" ;;
    ?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

# Set ffmpeg location (modify as needed)
ffmpeg_location="ffmpeg"  # Assuming ffmpeg is in the same directory

# Output location and filename format
if [[ $desktop == true ]]; then
  output_location="$HOME/Desktop/%(title)s.%(ext)s"
else
  output_location=".%(title)s.%(ext)s"
fi

# Final options string with ffmpeg and output location
full_options="$options --ffmpeg-location $ffmpeg_location --output $output_location"

# Debug information
if [[ $debug == true ]]; then
  echo "Debug Information:"
  echo "=================="
  echo "Downloader Executable: $exe"
  echo "FFmpeg Location: $ffmpeg_location"
  echo "Output Location: $output_location"
  echo "Other Options: $options"
  echo "Final Options string: $full_options"
  echo "=================="
fi

# Main program functions

# Function to format path for youtube-dl
# format_path() {
#   if [[ ! "<span class="math-inline">1" \=\~ ^"\.\*"</span> ]]; then
#     echo '"\"<span class="math-inline">1\\"'
# else
# echo "</span>{1//\"/\\\"}"
#   fi
# }

# Function to choose format based on user input
set_format() {
  case $choice in
    1) echo "";;  # Automatic default (best video+audio muxed)
    2) echo "-f best" ;;
    3) echo "-f bestvideo+bestaudio/best --merge-output-format mp4" ;;
    4)
      read -p "Video Format Code: " video_format
      read -p "Audio Format Code: " audio_format
      echo "<span class="math-inline">video\_format\+</span>{audio_format}"
      ;;
    5)
      read -p "Format Code (audio or video): " chosen_format
      echo "-f $chosen_format"
      ;;
    6)
      read -p "Format Code (single audio+video): " chosen_format
      echo "-f $chosen_format"
      ;;
    *) echo "Invalid choice." >&2; exit 1 ;;
  esac
}

# Function to preview format and get user confirmation
check_format() {
  if [[ $format == "" ]]; then
    echo "Best format Selected."
  else
    $exe -f "$format" "$URL" --get-format
  fi
  read -p "Ok? (Y/N)" confirm
  # [[ "<span class="math-inline">confirm" \=\~ ^\[Yy\]</span> ]] || exit 1
}

# Function to handle playlist URLs
is_playlist_url() {
  echo "in playlist url"
  # check if youtube url is playlist usrl
  [[ "$URL" =~ "list=" ]]
}

is_dual_url() {
  [[ "$URL" =~ "list=" ]] && [[ "$URL" =~ "v=" ]]
}

remove_playlist_from_url() {
  if [[ $URL =~ "list=" ]]; then
    URL=$(echo "$URL" | sed -E 's/(&list=[^"'\'']+)//')
  fi
  echo $URL
}

get_playlist_id() {
  local playlistId=$(echo "$URL" | sed -E 's/.*list=([^&]+).*/\1/')
}

# Start of the main program

echo
echo '--------------------------------- Video Downloader Script ---------------------------------'

read -p "Enter URL: " URL
# Check if the URL is a regular playlist
#
if (is_dual_url $URL) ; then
  # Handle the dual URL case
  playlistId=$(get_playlist_id "$URL")
  echo "The provided URL contains both a video ID and a playlist ID."
  read -p "Do you want to download only the video or the entire playlist? (Enter 'v' for video or 'p' for playlist): " choice
  if [[ $choice == "p" ]]; then
    isPlaylist="true"
    URL="https://www.youtube.com/playlist?list=$playlistId"
    echo "Will downloading playlist..."
  else
    isPlaylist="false"
    URL=$(remove_playlist_from_url $URL)
    echo "Will download video..."
    $exe --list-formats $URL
  fi

elif (is_playlist_url "$URL") ; then
  echo "Regular playlist URL detected. Skipping to format selection..."
  isPlaylist="true"
else
  isPlaylist="false"
  echo ""
  $exe --list-formats "$URL"
fi

# Loop to get user confirmation on format selection
while [[ $confirm != "y" ]]; do
  echo ""
  echo "---------------------------------------------------------------------------"
  echo "Options:"
  echo "1. Download automatically (default is best video + audio muxed)"
  echo "2. Download the best quality audio+video single file, no mux"
  echo "3. Download the highest quality audio + video formats, attempt merge to mp4"
  echo "4. Let me individually choose the video and audio formats to combine"
  echo "5. Download ONLY audio or video"
  echo "6. Download a specific audio+video single file, no mux"
  # echo "7. -UPDATE PROGRAM- (Admin May Be Required)"
  echo ""

  read -p "Type your choice number: " choice

  # Call custom format function if user chooses options 4, 5, or 6
  if [[ $choice -eq 4 || $choice -eq 5 || $choice -eq 6 ]]; then
    format=$(custom_formats)
  fi

  # Call format selection function based on user choice
  format=$(set_format)
  echo "format $format"

  # Check format for single video download, skip for playlists
  if [[ $isPlaylist == "false" ]]; then
    check_format
  else
    echo "Skipping format list for playlist..."
    read -p "Proceed and download playlist videos? (Enter Y/N): " confirm
  fi
done

# Final command to run youtube-dl
echo ""
echo "Running Command: $exe $format $URL $options"
$exe $format $URL $options

