Return-path: <linux-media-owner@vger.kernel.org>
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:50023 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932688Ab1JZO20 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Oct 2011 10:28:26 -0400
From: Daniel Drake <dsd@laptop.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Cc: corbet@lwn.net
Subject: [PATCH] via-camera: disable RGB mode
Message-Id: <20111026131650.97F529D401E@zog.reactivated.net>
Date: Wed, 26 Oct 2011 14:16:50 +0100 (BST)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RGB mode does not work correctly. It captures fine at 640x480
but whenever the scaling engine is used to produce another resolution,
color corruption occurs (lots of erroneous pink and green).

It is not clear how the scaling engine is supposed to work and how
it knows which pixel format it is dealing with. Work around this
problem by disabling RGB support. YUYV scaling works just fine.

Test case:

	gst-launch v4l2src ! video/x-raw-rgb,bpp=16,width=320,height=240 ! \
	ffmpegcolorspace ! xvimagesink

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/via-camera.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/via-camera.c b/drivers/media/video/via-camera.c
index bb7f17f..e64b571 100644
--- a/drivers/media/video/via-camera.c
+++ b/drivers/media/video/via-camera.c
@@ -156,14 +156,10 @@ static struct via_format {
 		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
 		.bpp		= 2,
 	},
-	{
-		.desc		= "RGB 565",
-		.pixelformat	= V4L2_PIX_FMT_RGB565,
-		.mbus_code	= V4L2_MBUS_FMT_RGB565_2X8_LE,
-		.bpp		= 2,
-	},
 	/* RGB444 and Bayer should be doable, but have never been
-	   tested with this driver. */
+	   tested with this driver. RGB565 seems to work at the default
+	   resolution, but results in color corruption when being scaled by
+	   viacam_set_scaled(), and is disabled as a result. */
 };
 #define N_VIA_FMTS ARRAY_SIZE(via_formats)
 
-- 
1.7.6.4

