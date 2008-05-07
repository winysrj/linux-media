Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m479gp02016233
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 05:42:51 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m479gfRE017428
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 05:42:41 -0400
Received: by yw-out-2324.google.com with SMTP id 5so102491ywb.81
	for <video4linux-list@redhat.com>; Wed, 07 May 2008 02:42:33 -0700 (PDT)
Message-ID: <b7b14cbb0805070242s34f6aaf5r39f6226bcdd8af5f@mail.gmail.com>
Date: Wed, 7 May 2008 11:42:33 +0200
From: "Clinton Taylor" <clintonlee.taylor@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: KWorld VS-USB2800D ...
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

Greetings ...

 Been lurking on the list for about two weeks and hoping that maybe
somebody can help me ...

 I have a KWorld USB Capture device marked VS-USB2800D.  I'm hoping to
use it along with a few other capture devices to test ZoneMinder and
do a few other video capture things ...

 I'm running Fedora 8 64bit with Kernel 2.6.24.5-85.fc8 ...

 When I plug in the device I get ...

May  7 11:10:06 zeus kernel: usb 1-7: new high speed USB device using
ehci_hcd and address 7
May  7 11:10:06 zeus kernel: usb 1-7: configuration #1 chosen from 1 choice
May  7 11:10:06 zeus kernel: em28xx v4l2 driver version 0.0.1 loaded
May  7 11:10:06 zeus kernel: em28xx new video device (eb1a:2820):
interface 0, class 255
May  7 11:10:06 zeus kernel: em28xx #0: Alternate settings: 8
May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 0, max size= 0
May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 1, max size= 1024
May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 2, max size= 1448
May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 3, max size= 2048
May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 4, max size= 2304
May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 5, max size= 2580
May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 6, max size= 2892
May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 7, max size= 3072
May  7 11:10:06 zeus kernel: saa7115 6-0025: saa7113 found
(1f7113d0e100000) @ 0x4a (em28xx #0)
May  7 11:10:07 zeus kernel: registered VBI
May  7 11:10:07 zeus kernel: em28xx #0: V4L2 device registered as
/dev/video2 and /dev/vbi0
May  7 11:10:07 zeus kernel: em28xx #0: Found MSI VOX USB 2.0
May  7 11:10:07 zeus kernel: usbcore: registered new interface driver em28xx

 If you see two lines from the bottom, it lists the device as a MSI
VOX USB 2.0 ... I would think this device is a KWorld USB2800, but I'm
able to capture with default settings, but not full frame ...  It
seems that I can only capture 640 of 768 and 480 of 576, which means
part of the image is missing ... If anybody was samples to explain
better, I sure I can send them some ...

If I modprobe -r em28xx and force as KWorld USB2800 with modprobe
em28xx i2c_scan=1 card=8 ...

May  7 11:20:57 zeus kernel: em28xx v4l2 driver version 0.0.1 loaded
May  7 11:20:57 zeus kernel: em28xx new video device (eb1a:2820):
interface 0, class 255
May  7 11:20:57 zeus kernel: em28xx #0: Alternate settings: 8
May  7 11:20:57 zeus kernel: em28xx #0: Alternate setting 0, max size= 0
May  7 11:20:57 zeus kernel: em28xx #0: Alternate setting 1, max size= 1024
May  7 11:20:57 zeus kernel: em28xx #0: Alternate setting 2, max size= 1448
May  7 11:20:57 zeus kernel: em28xx #0: Alternate setting 3, max size= 2048
May  7 11:20:57 zeus kernel: em28xx #0: Alternate setting 4, max size= 2304
May  7 11:20:57 zeus kernel: em28xx #0: Alternate setting 5, max size= 2580
May  7 11:20:57 zeus kernel: em28xx #0: Alternate setting 6, max size= 2892
May  7 11:20:57 zeus kernel: em28xx #0: Alternate setting 7, max size= 3072
May  7 11:21:03 zeus kernel: registered VBI
May  7 11:21:03 zeus kernel: em28xx #0: V4L2 device registered as
/dev/video2 and /dev/vbi0
May  7 11:21:03 zeus kernel: em28xx #0: Found Kworld USB2800
May  7 11:21:03 zeus kernel: usbcore: registered new interface driver em28xx

But then the captures are all current with just black and white fuzzy lines ...

Is there a bug with the kernel driver or is this a short coming of the
capture device?

What are suggested good USB video capture devices with S-Video/
Composite and build-in audio, not pass-through ... Maybe something
like" HAUPPAUGE WinTV-PVR USB 2.0 External Video Capture Card", but
cheaper ...

Thanks
Mailed
LeeT

P.S. Not sure if the following with help any, if not, sorry for the
extra noise ...

 v4l-info /dev/video2
...
### video4linux device info [/dev/video2] ###
general info
    VIDIOCGCAP
        name                    : "MSI VOX USB 2.0"
        type                    : 0x3 [CAPTURE,TUNER]
        channels                : 3
        audios                  : 0
        maxwidth                : 640
        maxheight               : 480
        minwidth                : 48
        minheight               : 32
...


v4l-info /dev/video2
...
### video4linux device info [/dev/video2] ###
general info
    VIDIOCGCAP
        name                    : "Kworld USB2800"
        type                    : 0x3 [CAPTURE,TUNER]
        channels                : 3
        audios                  : 0
        maxwidth                : 360
        maxheight               : 576
        minwidth                : 48
        minheight               : 32
...

sudo v4l-info /dev/video0
...
### video4linux device info [/dev/video0] ###
general info
    VIDIOCGCAP
        name                    : "DC10plus[0]"
        type                    : 0x30e9
[CAPTURE,OVERLAY,CLIPPING,FRAMERAM,SCALES,MJPEG_DECODER,MJPEG_ENCODER]
        channels                : 3
        audios                  : 0
        maxwidth                : 768
        maxheight               : 576
        minwidth                : 32
        minheight               : 24
...

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
