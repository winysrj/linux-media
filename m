Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44033 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881Ab0JXQEi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Oct 2010 12:04:38 -0400
Received: by qwk3 with SMTP id 3so819641qwk.19
        for <linux-media@vger.kernel.org>; Sun, 24 Oct 2010 09:04:38 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 24 Oct 2010 18:04:36 +0200
Message-ID: <AANLkTi=iP7rUtv4Fu76CGmzoOBnQXDtKYJeRipcdoZ0u@mail.gmail.com>
Subject: To slow libv4l MJPEG decoding with HD cameras
From: Mitar <mmitar@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi!

Logitech HD Pro Webcam C910 supports 2592x1944 at 10 FPS MJPEG stream.
This is really great but the problem is that libv4l decoding of MJPEG
is too slow for real-time on the fly decoding at this framerate. I use
2.6.36-rc6-amd64 and Intel(R) Core(TM)2 Quad CPU Q9400 @ 2.66GHz and
0.8.1 v4l-utils.

For example, with libv4l decoding of one pixel of MJPEG to BGR24 takes
around 0.025 microseconds on my machine. This is nothing important
with for example 640x480 resolution, it takes around 7680
microseconds, that is 8 milliseconds. But with 2592x1944 this becomes
around 125 milliseconds. So it is impossible to decode stream on the
fly in real-time with 10 FPS.

In comparison YUYV decoding takes 0.005 microseconds per pixel on
average. Those measurements per pixel (both for MJPEG and YUYV) are
quite consistent even for different framerates and frame sizes.

So maybe there is some room for improvement here? For example by using
ffmpeg MJPEG decoder instead of tinyjpeg? They argue (not really
kindly) that it has better performance:

https://roundup.ffmpeg.org/issue1816

Has anybody tried to improve MJPEG support in libv4l? With newer
cameras this becomes important.

And by the way, it would be useful to increase those hardcoded limits
in ib/libv4lconvert/tinyjpeg-internal.h to for example:

#define JPEG_MAX_WIDTH     4096
#define JPEG_MAX_HEIGHT    2048

Now we have affordable cameras which have bigger frame sizes than
those currently hardcoded. ;-)


Mitar
