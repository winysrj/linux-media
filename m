Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:54204 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab1FFRMh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 13:12:37 -0400
Date: Mon, 6 Jun 2011 19:12:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Baruch Siach <baruch@tkos.co.il>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] V4L: mx2_camera: .try_fmt shouldn't fail
Message-ID: <Pine.LNX.4.64.1106061902500.11169@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

If the user is requesting too large a frame, instead of failing
select an acceptable geometry, preserving the requested aspect ratio.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Attention: completely untested! Please, give it a spin on an i.MX25, 
specifically, please, try to force a TRY_FMT with too large a frame to 
test this path. Maybe you'll need to use some debugging printk().

 drivers/media/video/mx2_camera.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 4eab1c6..8e073a3 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -974,11 +974,16 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 		if (pix->bytesperline < 0)
 			return pix->bytesperline;
 		pix->sizeimage = pix->height * pix->bytesperline;
-		if (pix->sizeimage > (4 * 0x3ffff)) { /* CSIRXCNT limit */
-			dev_warn(icd->dev.parent,
-					"Image size (%u) above limit\n",
-					pix->sizeimage);
-			return -EINVAL;
+		/* Check against the CSIRXCNT limit */
+		if (pix->sizeimage > 4 * 0x3ffff) {
+			/* Adjust geometry, preserve aspect ratio */
+			unsigned int new_height = int_sqrt(4 * 0x3ffff *
+					pix->height / pix->bytesperline);
+			pix->width = new_height * pix->width / pix->height;
+			pix->height = new_height;
+			pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
+							xlate->host_fmt);
+			BUG_ON(pix->bytesperline < 0);
 		}
 	}
 
-- 
1.7.2.5

