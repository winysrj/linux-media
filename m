Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5FDOLST030873
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 09:24:21 -0400
Received: from web52711.mail.re2.yahoo.com (web52711.mail.re2.yahoo.com
	[206.190.48.234])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m5FDO80g029902
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 09:24:08 -0400
Date: Sun, 15 Jun 2008 06:24:02 -0700 (PDT)
From: Hamish <hamish_nospam@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <665273.69605.qm@web52711.mail.re2.yahoo.com>
Subject: Quickcam BW no go
Reply-To: hamish_nospam@yahoo.com
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

Hi folks,

I am trying to revive an old BW Quickcam. In years past I had it working with an older 2.2 kernel or so. If memory serves that was Debian/potato on a Pentium 75..

These days I am running Debian/etch on a P4 with 2.6.24 kernel from debian's backports.org. I had read there was a fix applied to the qcam kernel module before 2.6.24, I had hoped that upgrading would solve my problem.. nope.

It's a parallel port model, details follow:

$ lsmod | head
Module                  Size  Used by
bw_qcam                11432  0 
compat_ioctl32          1440  1 bw_qcam
videodev               26432  1 bw_qcam
v4l2_common            16736  1 videodev
v4l1_compat            13252  1 videodev

$ dmesg | tail
Linux video capture interface: v2.00
Connectix Quickcam on parport0
videodev: "Connectix Quickcam" has no release callback. Please fix your driver for proper sysfs support, see http://lwn.net/Articles/36850/

$ ls -l /dev/video0 
crw-rw---- 1 root video 81, 0 Jun 16 00:23 /dev/video0
 (yes, my user acc't does belong to the "video" group)

$ v4l-conf       
v4l-conf: using X11 display :0.0
dga: version 2.0
mode: 1280x1024, depth=24, bpp=32, bpl=5120, base=0xe8000000
/dev/video0 [v4l2]: ioctl VIDIOC_QUERYCAP: Invalid argument
/dev/video0 [v4l]: no overlay support

$ camorama -D
VIDIOCGCAP
device name = Quickcam
device type = 385
can use mmap()
# of channels = 1
# of audio devices = 0
max width = 320
max height = 240
min width = 80
min height = 60

VIDIOCGWIN
x = 0
y = 0
width = 160
height = 120
chromakey = 0
flags = 0

VIDIOCGWIN
x = 0
y = 0
width = 160
height = 120
chromakey = 0
flags = 0

VIDIOCGPICT:
bright = 51200
hue = 32768
colour = 32768
contrast = 48896
whiteness = 24064
colour depth = 4
VIDIOCGMBF  --  could not set buffer info, exiting...
["Could not connect to video device (/dev/video0).
  Please check connection."]

$ gqcam
[white screen; no pic]
Menu: Camera->Camera info...
============================
Name: Quickcam
Type: 385
	Can capture
	Scalable
	Monochrome only
Channels: 1
Audios: 0
Maxwidth: 320
Maxheight: 240
Minwidth: 80
Minheight: 60
---------
X: 0
Y: 0
Width: 160
Height: 120
Chromakey: 0
Flags: 0
---------
Brightness:	51200 (200)
Hue:		32768 (128)
Color:		32768 (128)
Contrast:	48896 (191)
Whiteness:	24064 (94)
Depth:		4
Palette:	1 - GREY

but then gqcam locks up when I try to quit.
also gqcam segfaults the first time I try and run it, after that it loads ok.


any ideas on how to awake this old beast?



thanks,
Hamish




      

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
