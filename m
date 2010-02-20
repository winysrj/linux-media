Return-path: <linux-media-owner@vger.kernel.org>
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:63430 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756959Ab0BTXvY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Feb 2010 18:51:24 -0500
Received: from sleepie.demon.co.uk ([80.176.231.188] helo=[192.168.1.5])
	by lon1-post-1.mail.demon.net with esmtp (Exim 4.69)
	id 1Niz6Z-0000th-YC
	for linux-media@vger.kernel.org; Sat, 20 Feb 2010 23:51:23 +0000
Message-ID: <4B80757B.5070804@sleepie.demon.co.uk>
Date: Sat, 20 Feb 2010 23:51:23 +0000
From: Richard Hirst <richard@sleepie.demon.co.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] v4lconvert_rotate90() leaves bytesperline wrong
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a cheap webcam (ID 093a:262a Pixart Imaging, Inc.), and Ubuntu 9.10 64 bit, Skype 2.1.0.81, and lib32v4l-0 version 0.6.0-1.  I start skype with LD_PRELOAD=/usr/lib32/libv4l/v4l1compat.so, and the video image is garbled.  I believe the problem is that the webcam image starts off at 480x640 and skype asks for YU12 at 320x240 for a test image.  This results in v4lconvert_rotate90() being called to rotate the image, and then v4lconvert_reduceandcrop_yuv420() being called to down-size the image from 640x480 to 320x240.  Unfortunately v4lconvert_reduceandcrop_yuv420() relies on src_fmt->fmt.pix.bytesperline for the source image, and that is still 480 (should be 640, since the image has been rotated).

This fixes it for me:

--- ori/libv4lconvert/libv4lconvert.c	2010-02-20 22:44:28.000000000 +0000
+++ libv4l-0.6.0/libv4lconvert/libv4lconvert.c	2010-02-20 23:01:12.000000000 +0000
@@ -1088,8 +1088,10 @@
       v4lprocessing_processing(data->processing, convert2_dest, &my_src_fmt);
   }
 
-  if (rotate90)
+  if (rotate90) {
     v4lconvert_rotate90(rotate90_src, rotate90_dest, &my_src_fmt);
+    v4lconvert_fixup_fmt(&my_src_fmt);
+  }
 
   if (hflip || vflip)
     v4lconvert_flip(flip_src, flip_dest, &my_src_fmt, hflip, vflip);



I didn't look closely at the latest source, so it is possible this already fixed some other way.

Richard
