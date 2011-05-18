Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:63711 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab1EROLf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 10:11:35 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id D093A189B66
	for <linux-media@vger.kernel.org>; Wed, 18 May 2011 16:11:33 +0200 (CEST)
Date: Wed, 18 May 2011 16:11:33 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/5] V4L: soc-camera: add a new packing for YUV 4:2:0 type
 formats
In-Reply-To: <Pine.LNX.4.64.1105181558440.16324@axis700.grange>
Message-ID: <Pine.LNX.4.64.1105181608240.16324@axis700.grange>
References: <Pine.LNX.4.64.1105181558440.16324@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

12-bit formats, similar to YUV 4:2:0 occupy 3 bytes for each two pixels
and cannot be described by any of the existing SOC_MBUS_PACKING_* macros.
This patch adds a new one SOC_MBUS_PACKING_1_5X8 to describe such
formats and extends soc_mbus_samples_per_pixel() to support it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mx3_camera.c   |    6 ++++--
 drivers/media/video/soc_mediabus.c |   17 ++++++++++++++---
 include/media/soc_mediabus.h       |    9 +++++++--
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 502e2a4..f6063be 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -726,8 +726,10 @@ static void configure_geometry(struct mx3_camera_dev *mx3_cam,
 		 * the width parameter count the number of samples to
 		 * capture to complete the whole image width.
 		 */
-		width *= soc_mbus_samples_per_pixel(fmt);
-		BUG_ON(width < 0);
+		unsigned int num, den;
+		int ret = soc_mbus_samples_per_pixel(fmt, &num, &den);
+		BUG_ON(ret < 0);
+		width = width * num / den;
 	}
 
 	/* Setup frame size - this cannot be changed on-the-fly... */
diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
index 505b586..5090ec5 100644
--- a/drivers/media/video/soc_mediabus.c
+++ b/drivers/media/video/soc_mediabus.c
@@ -163,15 +163,24 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 },
 };
 
-int soc_mbus_samples_per_pixel(const struct soc_mbus_pixelfmt *mf)
+int soc_mbus_samples_per_pixel(const struct soc_mbus_pixelfmt *mf,
+			unsigned int *numerator, unsigned int *denominator)
 {
 	switch (mf->packing) {
 	case SOC_MBUS_PACKING_NONE:
 	case SOC_MBUS_PACKING_EXTEND16:
-		return 1;
+		*numerator = 1;
+		*denominator = 1;
+		return 0;
 	case SOC_MBUS_PACKING_2X8_PADHI:
 	case SOC_MBUS_PACKING_2X8_PADLO:
-		return 2;
+		*numerator = 2;
+		*denominator = 1;
+		return 0;
+	case SOC_MBUS_PACKING_1_5X8:
+		*numerator = 3;
+		*denominator = 2;
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -186,6 +195,8 @@ s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf)
 	case SOC_MBUS_PACKING_2X8_PADLO:
 	case SOC_MBUS_PACKING_EXTEND16:
 		return width * 2;
+	case SOC_MBUS_PACKING_1_5X8:
+		return width * 3 / 2;
 	}
 	return -EINVAL;
 }
diff --git a/include/media/soc_mediabus.h b/include/media/soc_mediabus.h
index 91b41d6..7e1ffd0 100644
--- a/include/media/soc_mediabus.h
+++ b/include/media/soc_mediabus.h
@@ -16,18 +16,22 @@
 
 /**
  * enum soc_mbus_packing - data packing types on the media-bus
- * @SOC_MBUS_PACKING_NONE:	no packing, bit-for-bit transfer to RAM
+ * @SOC_MBUS_PACKING_NONE:	no packing, bit-for-bit transfer to RAM, one
+ *				sample represents one pixel
  * @SOC_MBUS_PACKING_2X8_PADHI:	16 bits transferred in 2 8-bit samples, in the
  *				possibly incomplete byte high bits are padding
  * @SOC_MBUS_PACKING_2X8_PADLO:	as above, but low bits are padding
  * @SOC_MBUS_PACKING_EXTEND16:	sample width (e.g., 10 bits) has to be extended
  *				to 16 bits
+ * @SOC_MBUS_PACKING_1_5X8:	used for packed YUV 4:2:0 formats, where 4
+ *				pixels occupy 6 bytes in RAM
  */
 enum soc_mbus_packing {
 	SOC_MBUS_PACKING_NONE,
 	SOC_MBUS_PACKING_2X8_PADHI,
 	SOC_MBUS_PACKING_2X8_PADLO,
 	SOC_MBUS_PACKING_EXTEND16,
+	SOC_MBUS_PACKING_1_5X8,
 };
 
 /**
@@ -74,6 +78,7 @@ const struct soc_mbus_pixelfmt *soc_mbus_find_fmtdesc(
 const struct soc_mbus_pixelfmt *soc_mbus_get_fmtdesc(
 	enum v4l2_mbus_pixelcode code);
 s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf);
-int soc_mbus_samples_per_pixel(const struct soc_mbus_pixelfmt *mf);
+int soc_mbus_samples_per_pixel(const struct soc_mbus_pixelfmt *mf,
+			unsigned int *numerator, unsigned int *denominator);
 
 #endif
-- 
1.7.2.5

