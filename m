Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2h.service.rug.nl ([129.125.60.2]:49910 "EHLO
	smtp2h.service.rug.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbZKPPrO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 10:47:14 -0500
Received: from [129.125.21.104] (f5selfip-4-60.service.rug.nl [129.125.60.248])
	by smtp2h.service.rug.nl (8.14.3/8.14.3) with ESMTP id nAGF1BqT007369
	for <linux-media@vger.kernel.org>; Mon, 16 Nov 2009 16:01:12 +0100
Message-ID: <4B016937.7010906@rug.nl>
Date: Mon, 16 Nov 2009 16:01:11 +0100
From: Sietse Achterop <s.achterop@rug.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: xawtv and v4lctl with usbvision  kernel driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

    Dear all,

Context:
 debian/lenny with usb frame grabber:
     Zoran Co. Personal Media Division (Nogatech) Hauppauge WinTV Pro (PAL/SECAM)
 This uses the usbvision driver.

The problem is that while xawtv works OK with color, v4lctl ONLY shows the frames
in black-and-white.

I understood that the usbvision driver needs some attention, e.g. a command like
"v4lctl setinput 2" is not working, it will keep using setting 0.
Because I need 2 (S-video) I patched the driver to always use 2 by setting
channel=2 in "usbvision_muxsel" to permanently select that channel.
With that usbvision module loaded I am getting pictures, but in BLACK_AND_WHITE,
as mentioned.

When starting "xawtv", it works fine!

With a simple opencv application I do an
	CvCapture* capture = cvCaptureFromCAM( cnum );
                 ...
	cam = (CvCaptureCAM_V4L*)capture;
                 ...
        ioctl(cam->deviceHandle,VIDIOC_G_FMT,&format))
                 ...
and find that the format is YV12, but the picture is black-and-white.
But YV12 is a color format.

The question is, how to get proper color pictures when using v4lctl or other
simple applications with this driver.

  Thanks in advance,
    Sietse Achterop

