Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:40430 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbZD2FGh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2009 01:06:37 -0400
Received: by wf-out-1314.google.com with SMTP id 26so698442wfd.4
        for <linux-media@vger.kernel.org>; Tue, 28 Apr 2009 22:06:36 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 29 Apr 2009 14:06:36 +0900
Message-ID: <5e9665e10904282206n7ecf9a89sf1109aee8156882e@mail.gmail.com>
Subject: [RFC] Expanding VIDIOC_ENUM_FRAMESIZES for encoded data.
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone.

As you know the experimental V4L2 feature VIDIOC_ENUM_FRAMESIZES is
all about frame sizes supported per pixelformat. We can get width and
height sizes supported per every pixelformat.
It's very useful feature to reduce dependency between device driver
and middleware or application. This could be used to make
application/middleware be aware of supported resolutions on runtime.
Very flexible.

(Note : From now every example is based on soc camera interface and mmap method)

But here is the thing.
Most of pixel formats can is based on pixel-line paradigm. VSYNC
representing single frame, HSYNC representing a line and pixel clock
is representing a pixel. So, we can give those informations to sync
interface, like camera interface which could make them expecting
proper pixel and line to sync a image frame. Not so different for
ITU-R.601 format, it also has a sync mechanism. OK, sounds fair
enough.

But how about encoded data like JPEG? JPEG is not pixel-line based,
just a lump of data.Synchronize interface cannot figure out how to
sync JPEG data with VSYNC and HSYNC. According to my experience in
camera device, all we can get from JPEG encoder in camera ISP is about
the maximum data size can be retrieved and actual data size when
encoding job is finished.

So when we want to take a JPEG encoded picture from camera device, we
need to mmap with big enough size for JPEG. But how can we figure out
how big size of memory could be called enough?
Basically if you are using JPEG encoder to encode the exact resolution
of YUV data for preview, you may not need for bigger buffer size I
guess. But for digital camera, we use quite smaller resolution of YUV
image than we are expecting to capture in JPEG, like 640*480 for
preview in YUV and 2560*1920 for still shot in JPEG. It is obvious
that we can't use mmaped buffer for preview to capture JPEG.

So here is my Idea. (Restricted example for digital camera. sorry for that)
Let's assume that we have two thread handling v4l2 device. like thread
A for preview and thread B for still capture.
Here is the procedure that I have in mind.

camera device : video0
YUV thread : thread A
JPEG thread : thread B

=> therad A, thread B open video0 at the same time
=> enum_framesizes
=> thread A gets discrete YUV frame sizes in resolution and thread B
gets byte sized JPEG size
=> thread A S_FMT preview size  with YUV

<snip>

=> thread A STREAMON
=> preview working
=> JPEG capture start issued
=> thread A STREAMOFF
=> thread B S_FMT JPEG size with JPEG

<snip>

=> thread B STREAMON => copy JPEG data
=> thread B STREAMOFF
=> thread A STREAMON
=> preview working


To make that procedure possible, we may have a patch for videodev2.h
You can find them in following patched lines:


@@ -372,6 +378,7 @@
 	V4L2_FRMSIZE_TYPE_DISCRETE	= 1,
 	V4L2_FRMSIZE_TYPE_CONTINUOUS	= 2,
 	V4L2_FRMSIZE_TYPE_STEPWISE	= 3,
+	V4L2_FRMSIZE_TYPE_ENCODED	= 4,
 };

 struct v4l2_frmsize_discrete {
@@ -388,6 +395,12 @@
 	__u32			step_height;	/* Frame height step size [pixel] */
 };

+struct v4l2_frmsize_byte {
+	__u32			width;	/* decoded frame width */
+	__u32			height;	/* decodec frame height */
+	__u32			max_byte;	/* maximum encoded data size in byte */
+};
+
 struct v4l2_frmsizeenum {
 	__u32			index;		/* Frame size number */
 	__u32			pixel_format;	/* Pixel format */
@@ -396,6 +409,7 @@
 	union {					/* Frame size */
 		struct v4l2_frmsize_discrete	discrete;
 		struct v4l2_frmsize_stepwise	stepwise;
+		struct v4l2_frmsize_byte		encoded;
 	};

 	__u32   reserved[2];			/* Reserved space for future use */
@@ -408,6 +422,7 @@
 	V4L2_FRMIVAL_TYPE_DISCRETE	= 1,
 	V4L2_FRMIVAL_TYPE_CONTINUOUS	= 2,
 	V4L2_FRMIVAL_TYPE_STEPWISE	= 3,
+	V4L2_FRMIVAL_TYPE_ENCODED	= 4,
 };

 struct v4l2_frmival_stepwise {
@@ -426,6 +441,7 @@
 	union {					/* Frame interval */
 		struct v4l2_fract		discrete;
 		struct v4l2_frmival_stepwise	stepwise;
+		struct v4l2_fract		encoded;
 	};

 	__u32	reserved[2];			/* Reserved space for future use */



I want to know what do you think about this. I wish I could post my
driver too, but it's not ready yet ;-(
Any comment will be appreciated.
Cheers,

Nate


-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
