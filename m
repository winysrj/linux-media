Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp104.plus.mail.re1.yahoo.com ([69.147.102.67]:32581 "HELO
	smtp104.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754966Ab0GGQAG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Jul 2010 12:00:06 -0400
Message-ID: <4C34A2F4.8030307@yahoo.de>
Date: Wed, 07 Jul 2010 17:53:24 +0200
From: Uwe Sauter <uwe.sauter@yahoo.de>
Reply-To: uwe.sauter@yahoo.de
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: libv4lconvert & Logitech Webcam 9000 Pro
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

I have a problem concerning libv4lconvert, Logitech Webcam 9000 Pro and 
perhaps OpenCV.

When I try to run OpenCV's examples that access the webcam they crash 
with the following:

--------------------
libv4lconvert: warning more framesizes then I can handle!
libv4lconvert: warning more framesizes then I can handle!
VIDIOC_QUERYCTRL: Input/output error
mmap: Invalid argument
munmap: Invalid argument
munmap: Invalid argument
munmap: Invalid argument
munmap: Invalid argument
Unable to stop the stream.: Bad file descriptor
munmap: Invalid argument
munmap: Invalid argument
munmap: Invalid argument
munmap: Invalid argument
libv4lconvert: warning more framesizes then I can handle!
libv4lconvert: warning more framesizes then I can handle!
HIGHGUI ERROR: V4L: device /dev/video0: Unable to query number of channels
--------------------

It seems to me that the cam has more framesizes than libv4lconvert 
actually can handle.This error happens on verions 0.6.1, 0.7.91 and 
0.8.0. A quick fix to this:

change in v4l-utils-<version>/lib/libv4lconvert/libv4lconvert-priv.h:

line 32:	#define V4LCONVERT_MAX_FRAMESIZES 16
to:		#define V4LCONVERT_MAX_FRAMESIZES 32
or any other higher number.

I have no idea which implications result from this.

The mmap/munmap/stream/HIGHGUI errors seem to be OpenCV related.

guvcview/luvcview both work BUT they don't link agains libv4lconvert.

I hope you can include this. If I can help testing I'm glad to 
participate. If you need more infos regarding the cam feel free to ask.



Thank you,

	Uwe Sauter





