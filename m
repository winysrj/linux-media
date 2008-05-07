Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m47IPpvg018044
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 14:25:51 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m47IPcoG022318
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 14:25:38 -0400
Received: by yw-out-2324.google.com with SMTP id 5so212251ywb.81
	for <video4linux-list@redhat.com>; Wed, 07 May 2008 11:25:31 -0700 (PDT)
Message-ID: <b7b14cbb0805071125p16f7c47bj5b456bd34f38aa52@mail.gmail.com>
Date: Wed, 7 May 2008 20:25:30 +0200
From: "Clinton Taylor" <clintonlee.taylor@gmail.com>
To: "Markus Rechberger" <mrechberger@gmail.com>
In-Reply-To: <d9def9db0805070342m77ba0ce2obf39299e43a1029a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b7b14cbb0805070242s34f6aaf5r39f6226bcdd8af5f@mail.gmail.com>
	<d9def9db0805070342m77ba0ce2obf39299e43a1029a@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: KWorld VS-USB2800D ...
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

>  >  I have a KWorld USB Capture device marked VS-USB2800D.  I'm hoping to
>  > use it along with a few other capture devices to test ZoneMinder and
>  > do a few other video capture things ...
>  >
>  >  I'm running Fedora 8 64bit with Kernel 2.6.24.5-85.fc8 ...
>  >
>  >  When I plug in the device I get ...
>  >
>  > May  7 11:10:06 zeus kernel: usb 1-7: new high speed USB device using
>  > ehci_hcd and address 7
>  > May  7 11:10:06 zeus kernel: usb 1-7: configuration #1 chosen from 1 choice
>  > May  7 11:10:06 zeus kernel: em28xx v4l2 driver version 0.0.1 loaded
>  > May  7 11:10:06 zeus kernel: em28xx new video device (eb1a:2820):
>  > interface 0, class 255
>  > May  7 11:10:06 zeus kernel: em28xx #0: Alternate settings: 8
>  > May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 0, max size= 0
>  > May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 1, max size= 1024
>  > May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 2, max size= 1448
>  > May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 3, max size= 2048
>  > May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 4, max size= 2304
>  > May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 5, max size= 2580
>  > May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 6, max size= 2892
>  > May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 7, max size= 3072
>  > May  7 11:10:06 zeus kernel: saa7115 6-0025: saa7113 found
>  > (1f7113d0e100000) @ 0x4a (em28xx #0)
>  > May  7 11:10:07 zeus kernel: registered VBI
>  > May  7 11:10:07 zeus kernel: em28xx #0: V4L2 device registered as
>  > /dev/video2 and /dev/vbi0
>  > May  7 11:10:07 zeus kernel: em28xx #0: Found MSI VOX USB 2.0
>  > May  7 11:10:07 zeus kernel: usbcore: registered new interface driver em28xx
>  >
>  >  If you see two lines from the bottom, it lists the device as a MSI
>  > VOX USB 2.0 ... I would think this device is a KWorld USB2800, but I'm
>  > able to capture with default settings, but not full frame ...  It
>  > seems that I can only capture 640 of 768 and 480 of 576, which means
>  > part of the image is missing ... If anybody was samples to explain
>  > better, I sure I can send them some ...
>  >
>
Seems I'm having a problem with the following ...
>  could you try
>  $ hg clone http://mcentral.de/~mrec/v4l-dvb-experimental
I get ...
destination directory: v4l-dvb-experimental
abort: HTTP Error 404: Not Found

but if I can it to ...
hg clone http://mcentral.de/~mrec/v4l-dvb-kernel

I get source ...

>  $ cd v4l-dvb-experimental
cd v4l-dvb-kernel
>  $ make
and then sudo make install ... Would of prefered if I did not have to
over write some of my kernel, but I have the rpm to re-install if
there is a problem ... Could this not be made to install in updates or
something?

>  > Is there a bug with the kernel driver or is this a short coming of the
>  > capture device?
>  >
>
>  ya the saa711x chipdriver is very likely broken for some devices.
 Okay ... Did a reboot just to be sure ... and then a modprobe -r
em28xx and modprobe em28xx ...

May  7 19:50:15 zeus kernel: usbcore: deregistering interface driver em28xx
May  7 19:50:15 zeus kernel: em28xx #0: disconnecting em28xx#0 video
May  7 19:50:15 zeus kernel: em28xx #0: V4L2 VIDEO devices /dev/video1
deregistered
May  7 19:50:18 zeus kernel: em28xx v4l2 driver version 0.0.1 loaded
May  7 19:50:18 zeus kernel: em28xx new video device (eb1a:2820):
interface 0, class 255
May  7 19:50:18 zeus kernel: em28xx: device is attached to a USB 2.0 bus
May  7 19:50:18 zeus kernel: em28xx: you're using the
experimental/unstable tree from mcentral.de
May  7 19:50:18 zeus kernel: em28xx: there's also a stable tree
available but which is limited to
May  7 19:50:18 zeus kernel: em28xx: linux <=2.6.19.2
May  7 19:50:18 zeus kernel: em28xx: it's fine to use this driver but
keep in mind that it will move
May  7 19:50:18 zeus kernel: em28xx: to
http://mcentral.de/hg/~mrec/v4l-dvb-kernel as soon as it's
May  7 19:50:18 zeus kernel: em28xx: proved to be stable
May  7 19:50:18 zeus kernel: em28xx #0: Alternate settings: 8
May  7 19:50:18 zeus kernel: em28xx #0: Alternate setting 0, max size= 0
May  7 19:50:18 zeus kernel: em28xx #0: Alternate setting 1, max size= 1024
May  7 19:50:18 zeus kernel: em28xx #0: Alternate setting 2, max size= 1448
May  7 19:50:18 zeus kernel: em28xx #0: Alternate setting 3, max size= 2048
May  7 19:50:18 zeus kernel: em28xx #0: Alternate setting 4, max size= 2304
May  7 19:50:18 zeus kernel: em28xx #0: Alternate setting 5, max size= 2580
May  7 19:50:18 zeus kernel: em28xx #0: Alternate setting 6, max size= 2892
May  7 19:50:18 zeus kernel: em28xx #0: Alternate setting 7, max size= 3072
May  7 19:50:18 zeus kernel: saa7115 3-0025: saa7113 found
(1f7113d0e100000) @ 0x4a (em28xx #0)
May  7 19:50:18 zeus kernel: attach_inform: saa7113 detected.
May  7 19:50:18 zeus kernel: em28xx #0: V4L2 device registered as /dev/video1
May  7 19:50:18 zeus kernel: em28xx #0: Found Gadmei UTV310
May  7 19:50:18 zeus kernel: usbcore: registered new interface driver em28xx

v4l now thinks I have a Found Gadmei UTV310 ... and a simple ...

mencoder tv:// -tv
driver=v4l2:device=/dev/video1:input=2:norm=PAL:alsa:forceaudio:immediatemode=0
\
    -ovc lavc -oac lavc -lavcopts
acodec=ac3:vcodec=mpeg2video:keyint=50:sc_threshold=0:vrc_eq=1:aspect=4/3:vbitrate=1800
\
    -o record.mpg

 Gives me corrupt recording again ...

 So modprobe -r em28xx and then modprobe em28xx card=10

May  7 19:54:03 zeus kernel: em28xx #0: V4L2 VIDEO devices /dev/video1
deregistered
May  7 19:54:05 zeus kernel: em28xx v4l2 driver version 0.0.1 loaded
May  7 19:54:05 zeus kernel: em28xx new video device (eb1a:2820):
interface 0, class 255
May  7 19:54:05 zeus kernel: em28xx: device is attached to a USB 2.0 bus
May  7 19:54:05 zeus kernel: em28xx: you're using the
experimental/unstable tree from mcentral.de
May  7 19:54:05 zeus kernel: em28xx: there's also a stable tree
available but which is limited to
May  7 19:54:05 zeus kernel: em28xx: linux <=2.6.19.2
May  7 19:54:05 zeus kernel: em28xx: it's fine to use this driver but
keep in mind that it will move
May  7 19:54:05 zeus kernel: em28xx: to
http://mcentral.de/hg/~mrec/v4l-dvb-kernel as soon as it's
May  7 19:54:05 zeus kernel: em28xx: proved to be stable
May  7 19:54:05 zeus kernel: em28xx #0: Alternate settings: 8
May  7 19:54:05 zeus kernel: em28xx #0: Alternate setting 0, max size= 0
May  7 19:54:05 zeus kernel: em28xx #0: Alternate setting 1, max size= 1024
May  7 19:54:05 zeus kernel: em28xx #0: Alternate setting 2, max size= 1448
May  7 19:54:05 zeus kernel: em28xx #0: Alternate setting 3, max size= 2048
May  7 19:54:05 zeus kernel: em28xx #0: Alternate setting 4, max size= 2304
May  7 19:54:05 zeus kernel: em28xx #0: Alternate setting 5, max size= 2580
May  7 19:54:05 zeus kernel: em28xx #0: Alternate setting 6, max size= 2892
May  7 19:54:05 zeus kernel: em28xx #0: Alternate setting 7, max size= 3072
May  7 19:54:05 zeus kernel: saa7115 3-0025: saa7113 found
(1f7113d0e100000) @ 0x4a (em28xx #0)
May  7 19:54:05 zeus kernel: attach_inform: saa7113 detected.
May  7 19:54:05 zeus kernel: em28xx #0: V4L2 device registered as /dev/video1
May  7 19:54:05 zeus kernel: em28xx #0: Found MSI VOX USB 2.0
May  7 19:54:05 zeus kernel: usbcore: registered new interface driver em28xx

And record ... Now I get sound and good video expect the video is at
640x480 ... Are these devices only able to capture at 640x480?  This
is an improvement, seeing that my captures with the stock kernel drive
gave me 640x480, but the video seemed to be missing 10% on the right
and buttom side of the video image ... This seems to at least scale
the video from PAL ...

 My DC10+ can capture at PAL 768x576 and basic PAL is 720x576, can USB
capturing devices do this?

Thanks
Mailed
LeeT

P.S. At least I now should be able to run my basic tests with
ZoneMinder and the USB capture device ...
P.S.S. My system seems to be more stable with the update v4l ... Thanks.


>  > What are suggested good USB video capture devices with S-Video/
>  > Composite and build-in audio, not pass-through ... Maybe something
>  > like" HAUPPAUGE WinTV-PVR USB 2.0 External Video Capture Card", but
>  > cheaper ...
>  >
>
>  Haupauge WinTV USB 2.0
>
>  http://geizhals.at/img/pix/3299.jpg
>
>  that device should work, svideo/composite might need some more work I
>  have that device somewhere here.
>
>  Markus
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
