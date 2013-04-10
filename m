Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:64226 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164Ab3DJGGB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 02:06:01 -0400
Received: from [192.168.43.91] ([89.204.130.18]) by smtp.web.de (mrweb102)
 with ESMTPSA (Nemesis) id 0LylnX-1UcRiC2v8p-015iGb for
 <linux-media@vger.kernel.org>; Wed, 10 Apr 2013 08:06:00 +0200
Message-ID: <51650142.2060404@web.de>
Date: Wed, 10 Apr 2013 08:05:54 +0200
From: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: uvcvideo: Dropping payload (out of sync)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I ran into a problem while trying to get a "Microsoft LifeCam 
Studio(TM)" (045e:0772) to work with uvccapture on a Raspberry PI 
running Kernel 3.6.11 under Debian Wheezy.

I started grabbing a picture with:
/usr/bin/uvccapture -x1920 -y1080 -o/media/ramdisk/webcam.jpg -q80

[1] 
http://ftp.de.debian.org/debian/pool/main/u/uvccapture/uvccapture_0.5.orig.tar.gz
[2] 
http://ftp.de.debian.org/debian/pool/main/u/uvccapture/uvccapture_0.5-2.debian.tar.gz

Grabbing a picture takes between 20 seconds and 1-2 minutes. 
Unfortuantely the captured image is heavily distorted.

Doing a stack trace I see that it always hangs on:

ioctl(3, VIDIOC_STREAMON, 0xbe8f15e4)   = 0
ioctl(3, VIDIOC_DQBUF

So I did an:
echo 0xffff > /sys/module/uvcvideo/parameters/trace

This resulted in a rather lengthy kernel log starting like this:

Apr 10 07:08:11 raspberrypi kernel: [ 5262.503209] uvcvideo: 
uvc_v4l2_ioctl(VIDIOC_G_CTRL)
Apr 10 07:08:11 raspberrypi kernel: [ 5262.509395] uvcvideo: 
uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Apr 10 07:08:11 raspberrypi kernel: [ 5262.509466] uvcvideo: Control 
0x00980913 not found.
Apr 10 07:08:11 raspberrypi kernel: [ 5262.519683] uvcvideo: 
uvc_v4l2_ioctl(VIDIOC_STREAMON)
Apr 10 07:08:11 raspberrypi kernel: [ 5262.524446] uvcvideo: Device 
requested 3072 B/frame bandwidth.
Apr 10 07:08:11 raspberrypi kernel: [ 5262.524481] uvcvideo: Selecting 
alternate setting 24 (3072 B/frame bandwidth).
Apr 10 07:08:11 raspberrypi kernel: [ 5262.534925] uvcvideo: Allocated 5 
URB buffers of 32x3072 bytes each.
Apr 10 07:08:11 raspberrypi kernel: [ 5262.540632] uvcvideo: 
uvc_v4l2_ioctl(VIDIOC_DQBUF)
Apr 10 07:08:12 raspberrypi kernel: [ 5263.014155] uvcvideo: USB 
isochronous frame lost (-63).
Apr 10 07:08:12 raspberrypi kernel: [ 5263.019468] uvcvideo: USB 
isochronous frame lost (-63).
Apr 10 07:08:12 raspberrypi kernel: [ 5263.024473] uvcvideo: USB 
isochronous frame lost (-63).
Apr 10 07:08:12 raspberrypi kernel: [ 5263.068612] uvcvideo: USB 
isochronous frame lost (-63).
Apr 10 07:08:12 raspberrypi kernel: [ 5263.078582] uvcvideo: USB 
isochronous frame lost (-63).
Apr 10 07:08:12 raspberrypi kernel: [ 5263.327576] uvcvideo: USB 
isochronous frame lost (-63).
Apr 10 07:08:12 raspberrypi kernel: [ 5263.366721] uvcvideo: Frame 
complete (overflow).
Apr 10 07:08:12 raspberrypi kernel: [ 5263.366759] uvcvideo: Dropping 
payload (out of sync).

It continued to show over 1Mio lines in 5 minutes with:
Apr 10 07:08:12 raspberrypi kernel: [ 5263.371102] uvcvideo: Dropping 
payload (out of sync).

intermitted by a few:
Apr 10 07:08:12 raspberrypi kernel: [ 5263.388864] uvcvideo: USB 
isochronous frame lost (-63).
After enabling the trace uvccapture was not able to garb an image at 
all. I had to kill the process.

I am at loss here... The whole setup worked flawlessly on my Laptop with 
Debian Wheezy and kernel 3.2 on an Intel Chipset.

I did a few more tests lowering the capture resolution which seemed to 
work a lot better. Up to 800x600 the images were captured almost 
instantly, but they were still distorted. At the resolution of 640x480 
the images were finally clear. But since the camera supports 1920x1080, 
I would also like to be able to capture at this resolution...

Any help is greatly appreciated.

Thanks in advance.
  André
