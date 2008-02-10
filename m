Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1AKwpos014144
	for <video4linux-list@redhat.com>; Sun, 10 Feb 2008 15:58:51 -0500
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.183])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1AKwHJA020474
	for <video4linux-list@redhat.com>; Sun, 10 Feb 2008 15:58:17 -0500
Received: by py-out-1112.google.com with SMTP id a29so4617012pyi.0
	for <video4linux-list@redhat.com>; Sun, 10 Feb 2008 12:58:14 -0800 (PST)
Message-ID: <47AF6564.6070602@gmail.com>
Date: Sun, 10 Feb 2008 15:58:12 -0500
From: Christopher Harvey <arbuckle911@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: multipart/mixed; boundary="------------020006090000090106080305"
Subject: select() problems with uvc drivers. 
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a multi-part message in MIME format.
--------------020006090000090106080305
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,
I've created a small c program that uses pure v4l2 code to read from a
webcam on a uvc driver then copy that data into an SDL overlay. I've
posted the code here:
http://basementcode.com/serverMain.html
and I've attached a log file I created from the output of that program.
Overall the program works great except that after a few frames, about 35
(varies each run) in my case, the select() function that is supposed to
block until new data from the webcam is available stops working and
returns right away. This isn't a huge problem because the following
ioctl(fd, VIDIOC_DQBUF, &buf)
call simply fails and sets errno to EAGAIN, then my app simply tries
again and again until it works. I'd rather select worked for the entire
duration of the capture to save cpu time and make sure that I read the
frame asap each time. The relevant function in the code I posted above
is "mainLoop", however I can't be sure the error is actually in that
function. I hope I've posted enough information.
Thanks in advance,
Chris.

--------------020006090000090106080305
Content-Type: text/plain;
 name="log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="log"

//The code for this log can been seen at:
//   http://basementcode.com/serverMain.html

// Commandline =  $./camTest /dev/video0 -w 640 -h 480

Device name: /dev/video0
Requested Width: 640
Requested Height 480
---------Device Capabilities---------
Driver:         uvcvideo
Name:           UVC Camera (046d:08ca)
Bus:            0000:00:02.1
Driver Version: 0.1.0

Video Capture: Yes
Read/write: No
Async IO: No
Streaming: Yes
-------------------------------------
----------Device Connections---------
	Input #0
Name: Camera 1
Type: Camera
Video standard: 0

-------------------------------------
Set to input 0
-------Image format enumeration-----
	Format #0
	MJPEG
Pixel format id: 1196444237
Type: V4L2_BUF_TYPE_VIDEO_CAPTURE
Compressed: Yes
	Format #1
	YUV 4:2:2 (YUYV)
Pixel format id: 1448695129
Type: V4L2_BUF_TYPE_VIDEO_CAPTURE
Compressed: No
-------------------------------------
Default image format locked!

	Current image format:
Width: 640
Height 480
PixelFormat: 1448695129
Bytes per line: 1280
Feild: V4L2_FIELD_NONE
Image code: YUYV
Colorspace: V4L2_COLORSPACE_SRGB

Got 20 buffers for memory map streaming.
OverLay has 1 planes.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Got image.
Again.
Again.
Again.
Again.
Again.
Again.
Got image.
Again.
Again.
Again.
Again.
Again.
Again.
Again.
Again.
Again.
Again.
Again.
Again.
Again.
Again.
Got image.
Again.
Again.
Again.
Again.
Again.
Again.
Again.
Again.
Again.
Again.
Again.
Again.
Again.
Again.
Again.
Got image.

...
...
...
...    This output repeats until the program shuts down.
...
...
...
...

Again.
Again.
Again.
Again.
Again.
Again.
Again.
Got image.
Unmapped all 20 buffers.

--------------020006090000090106080305
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------020006090000090106080305--
