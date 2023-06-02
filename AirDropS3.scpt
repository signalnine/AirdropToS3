on adding folder items to this_folder after receiving added_items
	set python_script to "import sys
import boto3
import os
import mimetypes
from pathlib import Path
from urllib.parse import urlunsplit
from random_word import RandomWords

aws_access_key_id = 'YOUR ACCESS KEY'
aws_secret_access_key = 'YOUR SECRET KEY'
aws_region = 'us-east-1'

def convert_heic_to_jpeg(heic_path):
    jpeg_path = os.path.splitext(heic_path)[0] + '.jpg'
    os.system(f'sips -s format jpeg {heic_path} --out {jpeg_path} > /dev/null 2>&1')
    return jpeg_path

def upload_to_s3(file_path, bucket_name):
    s3 = boto3.client('s3')
    file_name = generate_random_name(file_path)
    content_type, _ = mimetypes.guess_type(file_name)
    extra_args = {
        'ACL': 'public-read',
        'ContentType': content_type,
    }
    s3.upload_file(file_path, bucket_name, file_name, ExtraArgs=extra_args)
    return urlunsplit(('https', f'{bucket_name}.s3.amazonaws.com', file_name, '', ''))

def generate_random_name(file_path):
    rw = RandomWords()
    random_word1 = rw.get_random_word()
    random_word2 = rw.get_random_word()
    file_name = f'{random_word1}-{random_word2}{Path(file_path).suffix}'
    return file_name
		
def copy_to_clipboard(text):
    os.system(f'echo {text} | pbcopy')
	
bucket_name = 'YOUR BUCKET'
uploaded_urls = []

for item in sys.argv[1:]:
    if item.lower().endswith(('.png', '.jpg', '.jpeg', '.gif')):
        url = upload_to_s3(item, bucket_name)
        uploaded_urls.append(url)
    elif item.lower().endswith('.heic'):
        jpg_path = convert_heic_to_jpeg(item)
        url = upload_to_s3(jpg_path, bucket_name)
        uploaded_urls.append(url)

urls_string = ','.join(uploaded_urls)
print(urls_string)
copy_to_clipboard(urls_string)
"
	
	set the_files to ""
	repeat with an_item in added_items
		set posix_path to POSIX path of an_item
		set file_type to do shell script "file -b --mime-type " & quoted form of posix_path
		if file_type starts with "image/" then
			set the_files to the_files & " " & quoted form of posix_path
			set urls to do shell script "/usr/local/bin/python -c " & quoted form of python_script & " " & the_files
			display dialog urls
		end if
	end repeat
	
end adding folder items to
