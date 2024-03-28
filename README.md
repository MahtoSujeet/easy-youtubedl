# Easy Youtube-dl

Script for running youtube-dl with basic options using bash shell.
Allows automatic download options, as well as manually choosing the formats.
This project is a port of [ThioJoe](https://github.com/ThioJoe/youtube-dl-easy)'s project but for Linux bash terminal.

## Features

- Download options for automatic best quality or manually chosen video and audio formats to combine
- Download option for only audio or video
- Optional use of command line arguments to override hard-coded variables
- Support for downloading entire playlists
- Update the downloader program from within the script

## REQUIREMENTS

- This is NOT a standalone script. It requires the youtube-dl program, which should be put in the same directory as this script. Download YouTube-dl here: https://yt-dl.org/

- Alternatively, you can use this script with a fork of youtube-dl called "yt-dlp", which has more features and may work better. It is found here: https://github.com/yt-dlp/yt-dlp

- Some download methods will require ffmpeg to be installed: https://ffmpeg.org/

## Screenshot Preview

![Script Screenshot1](/assets/ss1.png)
![Script Screenshot2](/assets/ss2.png)

## youtube-dl Links

- YouTube-dl documentation: https://github.com/ytdl-org/youtube-dl/blob/master/README.md#readme
- Supported sites for Downloading: https://ytdl-org.github.io/youtube-dl/supportedsites.html
- Direct link to latest youtube-dl executable: https://yt-dl.org/latest/youtube-dl.exe

## Script / Code Parameters

You may wish/need to change certain parameters in the script code, located in the section called "PARAMETERS YOU MAY NEED/WISH TO CHANGE". This includes the location of the ffmpeg file, the output directory (default is 'outputs' folder in current directory) and filename, and options. See YouTube-dl documentation for more parameters.

## Command Line Arguments

The script supports the following command line arguments:

- `-exe <string>`: Set the name of the YouTube downloader executable (default: "yt-dlp.exe")
- `-desktop`: Place the 'Outputs' folder on the desktop instead of the current directory
- `-options <string>`: Manually set additional parameters for the YouTube downloader executable (default: "--no-mtime --add-metadata")
- `-debug`: Display potentially helpful info for debugging, including resulting variable values


### Troubleshooting

If you come across weird errors, the first thing to try should be updating the youtube-dl program. You can do this using option # 7. YouTube-dl is updated pretty frequently, and they usually fix issues quickly when YouTube.com makes breaking changes.

If you encounter issues, you can use the `-debug` command line argument to display helpful information for troubleshooting.

## Credits
- `@ThioJoe` : Heavly inspired by this project by ThioJoe.
