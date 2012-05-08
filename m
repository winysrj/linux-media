Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:65482 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556Ab2EHRDT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 13:03:19 -0400
Date: Tue, 8 May 2012 19:03:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Javier Martin <javier.martin@vista-silicon.com>,
	Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] V4L: mx2-camera: avoid overflowing 32-bits
Message-ID: <Pine.LNX.4.64.1205081900540.7085@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In mx2_camera_try_fmt(), when applying i.MX25 restrictions to frame sizes,
the height is checked to be <= 0xffff. But later an integer multiplication
height * 4 * 0x3ffff is performed, which will overflow even for bounded
height values. This patch switches to using 64-bit multiplication and
division to avoid overflowing.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Any objections anyone?

 drivers/media/video/mx2_camera.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 18afaee..ae1420b 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -22,6 +22,7 @@
 #include <linux/gcd.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/mm.h>
 #include <linux/moduleparam.h>
 #include <linux/time.h>
@@ -1367,8 +1368,8 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 		/* Check against the CSIRXCNT limit */
 		if (pix->sizeimage > 4 * 0x3ffff) {
 			/* Adjust geometry, preserve aspect ratio */
-			unsigned int new_height = int_sqrt(4 * 0x3ffff *
-					pix->height / pix->bytesperline);
+			unsigned int new_height = int_sqrt(div_u64(0x3ffffULL *
+					4 * pix->height, pix->bytesperline));
 			pix->width = new_height * pix->width / pix->height;
 			pix->height = new_height;
 			pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
-- 
1.7.2.5

