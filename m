Return-path: <mchehab@pedra>
Received: from mx3.wp.pl ([212.77.101.7]:62284 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab1CBRci (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2011 12:32:38 -0500
Received: from dnx210.neoplus.adsl.tpnet.pl (HELO [192.168.2.5]) (laurentp@[83.24.105.210])
          (envelope-sender <laurentp@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES256-SHA encrypted SMTP
          for <linux-media@vger.kernel.org>; 2 Mar 2011 18:32:34 +0100
Message-ID: <4D6E7F2F.4050905@wp.pl>
Date: Wed, 02 Mar 2011 18:32:31 +0100
From: "W.P." <laurentp@wp.pl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Big ptoblem with small webcam
References: <4D6E68D1.6050209@wp.pl>
In-Reply-To: <4D6E68D1.6050209@wp.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Użytkownik W.P. napisał:
> Hi there,
> I just got an Creative VGA (640x480) USB Live Webcam, VF0520.
>
> lsusb (partial):
>
> Bus 003 Device 007: ID 041e:406c Creative Technology, Ltd
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass          239 Miscellaneous Device
>   bDeviceSubClass         2 ?
>   bDeviceProtocol         1 Interface Association
>   bMaxPacketSize0        64
>   idVendor           0x041e Creative Technology, Ltd
>   idProduct          0x406c
>   bcdDevice           10.19
>   iManufacturer           1 Creative Labs
>   iProduct                3 VF0520 Live! Cam Sync
>   iSerial                 0
>   bNumConfigurations      1
>
> lsmod | grep vid:
> uvcvideo               50184  0
> compat_ioctl32          5120  1 uvcvideo
> videodev               32000  1 uvcvideo
> v4l1_compat            15876  2 uvcvideo,videodev
>
> uname -a (kernel from Fedora 10):
> [root@laurent-home ~]# uname -a
> Linux laurent-home 2.6.27.5-117.fc10.i686 #1 SMP Tue Nov 18 12:19:59 EST
> 2008 i686 athlon i386 GNU/Linux
>
> Problem: device nodes are created, but NO video in gmplayer, tvtime
> complains: can't open /dev/video0.
>
> Only trace in syslog is:
>
> Mar  2 16:26:56 laurent-home kernel: uvcvideo: Failed to submit URB 0 (-28).
>
> Webcam is connected to VIA USB 2.0 controller through a USB 2.0 hub.
>
> What is strange, two days ago I tried apparently the same (model VFxxxx)
> with SUCCESS.
> Device seems working in Windoze (Ekiga).
>
> What should I check/ do?
>   

[added]
syslog with modprobe trace=65535:

Mar  2 18:24:00 laurent-home kernel: uvcvideo: Found UVC 1.00 device
VF0520 Liv
e! Cam Sync (041e:406c)
Mar  2 18:24:00 laurent-home kernel: uvcvideo: Found a valid video chain
(1 ->
2).
Mar  2 18:24:00 laurent-home kernel: usbcore: registered new interface
driver u
vcvideo
Mar  2 18:24:23 laurent-home kernel: VIDIOC_QUERYCAP<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_G_STD<7>uvcvideo:
Unsupported ioctl
 0x80085617
Mar  2 18:24:23 laurent-home kernel: VIDIOC_G_PARM<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_ENUMSTD<7>uvcvideo:
Unsupported ioc
tl 0xc0405619
Mar  2 18:24:23 laurent-home kernel: VIDIOC_ENUMINPUT<7>uvcvideo:
uvc_v4l2_ioct
l
Mar  2 18:24:23 laurent-home kernel: VIDIOC_ENUMINPUT<7>uvcvideo:
uvc_v4l2_ioct
l
Mar  2 18:24:23 laurent-home kernel: VIDIOC_G_INPUT<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_ENUM_FMT<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_ENUM_FMT<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x4
7504a4d (MJPG): 640x480.
Mar  2 18:24:23 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x3
2315659 (YV12): 640x480.
Mar  2 18:24:23 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x3
2315559 (YU12): 640x480.
Mar  2 18:24:23 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x5
9565955 (UYVY): 640x480.
Mar  2 18:24:23 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x5
6595559 (YUYV): 640x480.
Mar  2 18:24:23 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x3
4424752 (RGB4): 640x480.
Mar  2 18:24:23 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x3
3424752 (RGB3): 640x480.
Mar  2 18:24:23 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x5
2474210 (BGR): 640x480.
Mar  2 18:24:23 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x5
247420f (BGR): 640x480.
Mar  2 18:24:23 laurent-home kernel: VIDIOC_ENUMINPUT<7>uvcvideo:
uvc_v4l2_ioct
l
Mar  2 18:24:23 laurent-home kernel: VIDIOC_S_INPUT<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_ENUMSTD<7>uvcvideo:
Unsupported ioc
tl 0xc0405619
Mar  2 18:24:23 laurent-home kernel: VIDIOC_ENUMSTD<7>uvcvideo:
Unsupported ioc
tl 0xc0405619
Mar  2 18:24:23 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_REQBUFS<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_QUERYBUF<7>uvcvideo:
uvc_v4l2_mmap
Mar  2 18:24:23 laurent-home kernel: VIDIOC_QBUF<7>uvcvideo: Queuing
buffer 0.
Mar  2 18:24:23 laurent-home kernel: VIDIOC_QUERYBUF<7>uvcvideo:
uvc_v4l2_mmap
Mar  2 18:24:23 laurent-home kernel: VIDIOC_QBUF<7>uvcvideo: Queuing
buffer 1.
Mar  2 18:24:23 laurent-home kernel: VIDIOC_S_CTRL<7>uvcvideo: Control
0x009809
09 not found.
Mar  2 18:24:23 laurent-home kernel: VIDIOC_QUERYCTRL<7>uvcvideo:
uvc_v4l2_ioct
l
Mar  2 18:24:23 laurent-home kernel: VIDIOC_S_CTRL<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_QUERYCTRL<7>uvcvideo:
uvc_v4l2_ioct
l
Mar  2 18:24:23 laurent-home kernel: VIDIOC_S_CTRL<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_QUERYCTRL<7>uvcvideo:
uvc_v4l2_ioct
l
Mar  2 18:24:23 laurent-home kernel: VIDIOC_S_CTRL<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_QUERYCTRL<7>uvcvideo:
uvc_v4l2_ioct
l
Mar  2 18:24:23 laurent-home kernel: VIDIOC_S_CTRL<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:23 laurent-home kernel: VIDIOC_S_CTRL<7>uvcvideo: Control
0x009809
09 not found.
Mar  2 18:24:24 laurent-home kernel: VIDIOC_QUERYCAP<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_G_STD<7>uvcvideo:
Unsupported ioctl
 0x80085617
Mar  2 18:24:24 laurent-home kernel: VIDIOC_G_PARM<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_ENUMSTD<7>uvcvideo:
Unsupported ioc
tl 0xc0405619
Mar  2 18:24:24 laurent-home kernel: VIDIOC_ENUMINPUT<7>uvcvideo:
uvc_v4l2_ioct
l
Mar  2 18:24:24 laurent-home kernel: VIDIOC_ENUMINPUT<7>uvcvideo:
uvc_v4l2_ioct
Mar  2 18:24:24 laurent-home kernel: VIDIOC_G_INPUT<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_ENUM_FMT<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_ENUM_FMT<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x4
7504a4d (MJPG): 640x480.
Mar  2 18:24:24 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x3
2315659 (YV12): 640x480.
Mar  2 18:24:24 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x3
2315559 (YU12): 640x480.
Mar  2 18:24:24 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x5
9565955 (UYVY): 640x480.
Mar  2 18:24:24 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x5
6595559 (YUYV): 640x480.
Mar  2 18:24:24 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x3
4424752 (RGB4): 640x480.
Mar  2 18:24:24 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x3
3424752 (RGB3): 640x480.
Mar  2 18:24:24 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x5
2474210 (BGR): 640x480.
Mar  2 18:24:24 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_S_FMT<7>uvcvideo: Trying
format 0x5
247420f (BGR): 640x480.
Mar  2 18:24:24 laurent-home kernel: VIDIOC_ENUMINPUT<7>uvcvideo:
uvc_v4l2_ioct
l
Mar  2 18:24:24 laurent-home kernel: VIDIOC_S_INPUT<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_ENUMSTD<7>uvcvideo:
Unsupported ioc
tl 0xc0405619
Mar  2 18:24:24 laurent-home kernel: VIDIOC_ENUMSTD<7>uvcvideo:
Unsupported ioc
tl 0xc0405619
Mar  2 18:24:24 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_G_FMT<7>uvcvideo: uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_REQBUFS<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_QUERYBUF<7>uvcvideo:
uvc_v4l2_mmap
Mar  2 18:24:24 laurent-home kernel: VIDIOC_QBUF<7>uvcvideo: Queuing
buffer 0.
Mar  2 18:24:24 laurent-home kernel: VIDIOC_QUERYBUF<7>uvcvideo:
uvc_v4l2_mmap
Mar  2 18:24:24 laurent-home kernel: VIDIOC_QBUF<7>uvcvideo: Queuing
buffer 1.
Mar  2 18:24:24 laurent-home kernel: VIDIOC_S_CTRL<7>uvcvideo: Control
0x009809
09 not found.
Mar  2 18:24:24 laurent-home kernel: VIDIOC_QUERYCTRL<7>uvcvideo:
uvc_v4l2_ioct
l
Mar  2 18:24:24 laurent-home kernel: VIDIOC_S_CTRL<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_QUERYCTRL<7>uvcvideo:
uvc_v4l2_ioct
l
Mar  2 18:24:24 laurent-home kernel: VIDIOC_S_CTRL<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_QUERYCTRL<7>uvcvideo:
uvc_v4l2_ioct
l
Mar  2 18:24:24 laurent-home kernel: VIDIOC_S_CTRL<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_QUERYCTRL<7>uvcvideo:
uvc_v4l2_ioct
l
Mar  2 18:24:24 laurent-home kernel: VIDIOC_S_CTRL<7>uvcvideo:
uvc_v4l2_ioctl
Mar  2 18:24:24 laurent-home kernel: VIDIOC_STREAMON<3>uvcvideo: Failed
to subm
it URB 0 (-28).

Same on another hub (also another port of controller).

W.P.
