Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:35358 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab2AGU6p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 15:58:45 -0500
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout2.freenet.de with esmtpa (ID saschasommer@freenet.de) (port 25) (Exim 4.76 #1)
	id 1RjdLf-0003AI-Le
	for linux-media@vger.kernel.org; Sat, 07 Jan 2012 21:58:43 +0100
Received: from localhost ([::1]:34482 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID saschasommer@freenet.de) (Exim 4.76 #1)
	id 1RjdLf-0007cM-Ha
	for linux-media@vger.kernel.org; Sat, 07 Jan 2012 21:58:43 +0100
Received: from [195.4.92.20] (port=41245 helo=10.mx.freenet.de)
	by mjail2.freenet.de with esmtpa (ID saschasommer@freenet.de) (Exim 4.76 #1)
	id 1RjdJE-0007A0-9e
	for linux-media@vger.kernel.org; Sat, 07 Jan 2012 21:56:12 +0100
Received: from p5499e75f.dip.t-dialin.net ([84.153.231.95]:57735 helo=madeira.sommer.dynalias.net)
	by 10.mx.freenet.de with esmtpsa (ID saschasommer@freenet.de) (TLSv1:CAMELLIA256-SHA:256) (port 465) (Exim 4.76 #1)
	id 1RjdJD-0008Kq-UF
	for linux-media@vger.kernel.org; Sat, 07 Jan 2012 21:56:12 +0100
Message-ID: <4F0A0284.2050302@freenet.de>
Date: Sun, 08 Jan 2012 21:54:28 +0100
From: Sascha Sommer <saschasommer@freenet.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] em28xx: increase maxwidth for em2800
Content-Type: multipart/mixed;
 boundary="------------080802060206060702020606"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080802060206060702020606
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

The MaxPacketSize for em2800 based devices is too small to capture at 
full resolution.
Therefore scale down when the maximum frame size is selected.
The previous workaround that simply reduced the X resolution cannot be used
because it crops a part of the input as
the em2800 can only scale down with a factor of 0.5.

Regards

Sascha


--------------080802060206060702020606
Content-Type: text/x-patch;
 name="em28xx_increase_max_width_for_em2800.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="em28xx_increase_max_width_for_em2800.patch"

The MaxPacketSize for em2800 based devices is too small to capture at full resolution.
Therefore scale down when the maximum frame size is selected.
The previous workaround that simply reduced the X resolution cannot be used
because it crops a part of the input as
the em2800 can only scale down with a factor of 0.5. 

reverts
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=1ca31892e3af05ad3a72769e3c922cca3cde4f9d
and
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fb3de0398ab1bf270bc55f66945f82e61e50f6b6

Signed-off-by: Sascha Sommer <saschasommer@freenet.de>

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 9b4557a..613300b 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -1070,6 +1070,10 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		/* the em2800 can only scale down to 50% */
 		height = height > (3 * maxh / 4) ? maxh : maxh / 2;
 		width = width > (3 * maxw / 4) ? maxw : maxw / 2;
+                /* MaxPacketSize for em2800 is too small to capture at full resolution
+                 * use half of maxw as the scaler can only scale to 50% */
+		if (width == maxw && height == maxh)
+			width /= 2;
 	} else {
 		/* width must even because of the YUYV format
 		   height must be even because of interlacing */
@@ -2503,6 +2507,7 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 {
       u8 val;
 	int ret;
+	unsigned int maxw;
 
 	printk(KERN_INFO "%s: v4l2 driver version %s\n",
 		dev->name, EM28XX_VERSION);
@@ -2515,8 +2520,15 @@ int em28xx_register_analog_devices(struct em28xx *dev)
 
 	/* Analog specific initialization */
 	dev->format = &format[0];
+
+	maxw = norm_maxw(dev);
+        /* MaxPacketSize for em2800 is too small to capture at full resolution
+         * use half of maxw as the scaler can only scale to 50% */
+        if (dev->board.is_em2800)
+            maxw /= 2;
+
 	em28xx_set_video_format(dev, format[0].fourcc,
-				norm_maxw(dev), norm_maxh(dev));
+				maxw, norm_maxh(dev));
 
 	video_mux(dev, dev->ctl_input);
 
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 7c3ebe2..22e252b 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -831,7 +831,7 @@ static inline unsigned int norm_maxw(struct em28xx *dev)
 	if (dev->board.is_webcam)
 		return dev->sensor_xres;
 
-	if (dev->board.max_range_640_480 || dev->board.is_em2800)
+	if (dev->board.max_range_640_480)
 		return 640;
 
 	return 720;

--------------080802060206060702020606--
