Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:60036 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648Ab1EROL3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 10:11:29 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id A9D9A189B66
	for <linux-media@vger.kernel.org>; Wed, 18 May 2011 16:11:27 +0200 (CEST)
Date: Wed, 18 May 2011 16:11:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/5] V4L: soc-camera: avoid huge arrays, caused by changed
 format codes
In-Reply-To: <Pine.LNX.4.64.1105181558440.16324@axis700.grange>
Message-ID: <Pine.LNX.4.64.1105181605200.16324@axis700.grange>
References: <Pine.LNX.4.64.1105181558440.16324@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Recently mediabus pixel format codes have become a part of the user-
space API, at which time their values also have been changed from
contiguous numbers, running from 0 to sparse numbers with values
around 0x1000, 0x2000, 0x3000... This made them unsuitable for the
use as array indices. This patch switches soc-camera internal format
look-ups to not depend on values of those macros.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Yes, this violates the coding style, I've chosen to do that to minimize 
the patch to simplify its verification. We can reformat it in the future 
if desired.

 drivers/media/video/soc_mediabus.c |   89 ++++++++++++++++++++++++++---------
 include/media/soc_mediabus.h       |   14 ++++++
 2 files changed, 80 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
index ed77aa0..505b586 100644
--- a/drivers/media/video/soc_mediabus.c
+++ b/drivers/media/video/soc_mediabus.c
@@ -15,121 +15,152 @@
 #include <media/v4l2-mediabus.h>
 #include <media/soc_mediabus.h>
 
-#define MBUS_IDX(f) (V4L2_MBUS_FMT_ ## f - V4L2_MBUS_FMT_FIXED - 1)
-
-static const struct soc_mbus_pixelfmt mbus_fmt[] = {
-	[MBUS_IDX(YUYV8_2X8)] = {
+static const struct soc_mbus_lookup mbus_fmt[] = {
+{
+	.code = V4L2_MBUS_FMT_YUYV8_2X8,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_YUYV,
 		.name			= "YUYV",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(YVYU8_2X8)] = {
+}, {
+	.code = V4L2_MBUS_FMT_YVYU8_2X8,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_YVYU,
 		.name			= "YVYU",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(UYVY8_2X8)] = {
+}, {
+	.code = V4L2_MBUS_FMT_UYVY8_2X8,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_UYVY,
 		.name			= "UYVY",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(VYUY8_2X8)] = {
+}, {
+	.code = V4L2_MBUS_FMT_VYUY8_2X8,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_VYUY,
 		.name			= "VYUY",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(RGB555_2X8_PADHI_LE)] = {
+}, {
+	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB555,
 		.name			= "RGB555",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(RGB555_2X8_PADHI_BE)] = {
+}, {
+	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB555X,
 		.name			= "RGB555X",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(RGB565_2X8_LE)] = {
+}, {
+	.code = V4L2_MBUS_FMT_RGB565_2X8_LE,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB565,
 		.name			= "RGB565",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(RGB565_2X8_BE)] = {
+}, {
+	.code = V4L2_MBUS_FMT_RGB565_2X8_BE,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB565X,
 		.name			= "RGB565X",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(SBGGR8_1X8)] = {
+}, {
+	.code = V4L2_MBUS_FMT_SBGGR8_1X8,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR8,
 		.name			= "Bayer 8 BGGR",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_NONE,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(SBGGR10_1X10)] = {
+}, {
+	.code = V4L2_MBUS_FMT_SBGGR10_1X10,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR10,
 		.name			= "Bayer 10 BGGR",
 		.bits_per_sample	= 10,
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(Y8_1X8)] = {
+}, {
+	.code = V4L2_MBUS_FMT_Y8_1X8,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_GREY,
 		.name			= "Grey",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_NONE,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(Y10_1X10)] = {
+}, {
+	.code = V4L2_MBUS_FMT_Y10_1X10,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_Y10,
 		.name			= "Grey 10bit",
 		.bits_per_sample	= 10,
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(SBGGR10_2X8_PADHI_LE)] = {
+}, {
+	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR10,
 		.name			= "Bayer 10 BGGR",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(SBGGR10_2X8_PADLO_LE)] = {
+}, {
+	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR10,
 		.name			= "Bayer 10 BGGR",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADLO,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(SBGGR10_2X8_PADHI_BE)] = {
+}, {
+	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR10,
 		.name			= "Bayer 10 BGGR",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
 	},
-	[MBUS_IDX(SBGGR10_2X8_PADLO_BE)] = {
+}, {
+	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR10,
 		.name			= "Bayer 10 BGGR",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADLO,
 		.order			= SOC_MBUS_ORDER_BE,
 	},
+},
 };
 
 int soc_mbus_samples_per_pixel(const struct soc_mbus_pixelfmt *mf)
@@ -160,13 +191,25 @@ s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf)
 }
 EXPORT_SYMBOL(soc_mbus_bytes_per_line);
 
+const struct soc_mbus_pixelfmt *soc_mbus_find_fmtdesc(
+	enum v4l2_mbus_pixelcode code,
+	const struct soc_mbus_lookup *lookup,
+	int n)
+{
+	int i;
+
+	for (i = 0; i < n; i++)
+		if (lookup[i].code == code)
+			return &lookup[i].fmt;
+
+	return NULL;
+}
+EXPORT_SYMBOL(soc_mbus_find_fmtdesc);
+
 const struct soc_mbus_pixelfmt *soc_mbus_get_fmtdesc(
 	enum v4l2_mbus_pixelcode code)
 {
-	if (code - V4L2_MBUS_FMT_FIXED > ARRAY_SIZE(mbus_fmt) ||
-	    code <= V4L2_MBUS_FMT_FIXED)
-		return NULL;
-	return mbus_fmt + code - V4L2_MBUS_FMT_FIXED - 1;
+	return soc_mbus_find_fmtdesc(code, mbus_fmt, ARRAY_SIZE(mbus_fmt));
 }
 EXPORT_SYMBOL(soc_mbus_get_fmtdesc);
 
diff --git a/include/media/soc_mediabus.h b/include/media/soc_mediabus.h
index b338108..91b41d6 100644
--- a/include/media/soc_mediabus.h
+++ b/include/media/soc_mediabus.h
@@ -57,6 +57,20 @@ struct soc_mbus_pixelfmt {
 	u8			bits_per_sample;
 };
 
+/**
+ * struct soc_mbus_lookup - Lookup FOURCC IDs by mediabus codes for pass-through
+ * @code:	mediabus pixel-code
+ * @fmt:	pixel format description
+ */
+struct soc_mbus_lookup {
+	enum v4l2_mbus_pixelcode	code;
+	struct soc_mbus_pixelfmt	fmt;
+};
+
+const struct soc_mbus_pixelfmt *soc_mbus_find_fmtdesc(
+	enum v4l2_mbus_pixelcode code,
+	const struct soc_mbus_lookup *lookup,
+	int n);
 const struct soc_mbus_pixelfmt *soc_mbus_get_fmtdesc(
 	enum v4l2_mbus_pixelcode code);
 s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf);
-- 
1.7.2.5

