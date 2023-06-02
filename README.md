# AirdropToS3
AppleScript / Python to send Airdropped images to S3

1. Enable Folder Actions on the folder you want this to work in (eg, ~/Downloads). Right-click the folder in Finder, Services, Folder Actions Setup, Check Enable Folder Actions and edit script, paste this in.
2. Now, when an image file is placed in the folder, it will be uploaded to S3 with a random two-word filename and the URL will pop up as a dialog box and automatically put into your current clipboard. HEIC images will be converted to JPEG before upload.
