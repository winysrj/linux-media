Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:57608 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933040Ab1EROLi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 10:11:38 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id C1177189B66
	for <linux-media@vger.kernel.org>; Wed, 18 May 2011 16:11:36 +0200 (CEST)
Date: Wed, 18 May 2011 16:11:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/5] V4L: soc-camera: add more format look-up entries
In-Reply-To: <Pine.LNX.4.64.1105181558440.16324@axis700.grange>
Message-ID: <Pine.LNX.4.64.1105181609010.16324@axis700.grange>
References: <Pine.LNX.4.64.1105181558440.16324@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add new look-up entries for all mediabus codes, for which respective
fourcc codes exist.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_mediabus.c |  144 ++++++++++++++++++++++++++++++++++++
 1 files changed, 144 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
index 5090ec5..3a5bf01 100644
--- a/drivers/media/video/soc_mediabus.c
+++ b/drivers/media/video/soc_mediabus.c
@@ -160,6 +160,150 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.packing		= SOC_MBUS_PACKING_2X8_PADLO,
 		.order			= SOC_MBUS_ORDER_BE,
 	},
+}, {
+	.code = V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_RGB444,
+		.name			= "RGB444",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
+		.order			= SOC_MBUS_ORDER_BE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_YUYV8_1_5X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_YUV420,
+		.name			= "YUYV 4:2:0",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_1_5X8,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_YVYU8_1_5X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_YVU420,
+		.name			= "YVYU 4:2:0",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_1_5X8,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_UYVY8_1X16,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_UYVY,
+		.name			= "UYVY 16bit",
+		.bits_per_sample	= 16,
+		.packing		= SOC_MBUS_PACKING_EXTEND16,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_VYUY8_1X16,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_VYUY,
+		.name			= "VYUY 16bit",
+		.bits_per_sample	= 16,
+		.packing		= SOC_MBUS_PACKING_EXTEND16,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_YUYV8_1X16,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_YUYV,
+		.name			= "YUYV 16bit",
+		.bits_per_sample	= 16,
+		.packing		= SOC_MBUS_PACKING_EXTEND16,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_YVYU8_1X16,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_YVYU,
+		.name			= "YVYU 16bit",
+		.bits_per_sample	= 16,
+		.packing		= SOC_MBUS_PACKING_EXTEND16,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_SGRBG8_1X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SGRBG8,
+		.name			= "Bayer 8 GRBG",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_NONE,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SGRBG10DPCM8,
+		.name			= "Bayer 10 BGGR DPCM 8",
+		.bits_per_sample	= 8,
+		.packing		= SOC_MBUS_PACKING_NONE,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_SGBRG10_1X10,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SGBRG10,
+		.name			= "Bayer 10 GBRG",
+		.bits_per_sample	= 10,
+		.packing		= SOC_MBUS_PACKING_EXTEND16,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_SGRBG10_1X10,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SGRBG10,
+		.name			= "Bayer 10 GRBG",
+		.bits_per_sample	= 10,
+		.packing		= SOC_MBUS_PACKING_EXTEND16,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_SRGGB10_1X10,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SRGGB10,
+		.name			= "Bayer 10 RGGB",
+		.bits_per_sample	= 10,
+		.packing		= SOC_MBUS_PACKING_EXTEND16,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_SBGGR12_1X12,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR12,
+		.name			= "Bayer 12 BGGR",
+		.bits_per_sample	= 12,
+		.packing		= SOC_MBUS_PACKING_EXTEND16,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_SGBRG12_1X12,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SGBRG12,
+		.name			= "Bayer 12 GBRG",
+		.bits_per_sample	= 12,
+		.packing		= SOC_MBUS_PACKING_EXTEND16,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_SGRBG12_1X12,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SGRBG12,
+		.name			= "Bayer 12 GRBG",
+		.bits_per_sample	= 12,
+		.packing		= SOC_MBUS_PACKING_EXTEND16,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_SRGGB12_1X12,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SRGGB12,
+		.name			= "Bayer 12 RGGB",
+		.bits_per_sample	= 12,
+		.packing		= SOC_MBUS_PACKING_EXTEND16,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
 },
 };
 
-- 
1.7.2.5

