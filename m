Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34110 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750946AbZLXNMM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Dec 2009 08:12:12 -0500
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1NNnUF-0001Zx-1w
	for linux-media@vger.kernel.org; Thu, 24 Dec 2009 14:12:15 +0100
Date: Thu, 24 Dec 2009 14:12:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] soc-camera: adjust coding style to match V4L preferences
Message-ID: <Pine.LNX.4.64.0912241409420.5167@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_mediabus.c |   45 ++++++++++++++++++++++++------------
 1 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
index f8d5c87..0149290 100644
--- a/drivers/media/video/soc_mediabus.c
+++ b/drivers/media/video/soc_mediabus.c
@@ -24,91 +24,106 @@ static const struct soc_mbus_pixelfmt mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
-	}, [MBUS_IDX(YVYU8_2X8_LE)] = {
+	},
+	[MBUS_IDX(YVYU8_2X8_LE)] = {
 		.fourcc			= V4L2_PIX_FMT_YVYU,
 		.name			= "YVYU",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
-	}, [MBUS_IDX(YUYV8_2X8_BE)] = {
+	},
+	[MBUS_IDX(YUYV8_2X8_BE)] = {
 		.fourcc			= V4L2_PIX_FMT_UYVY,
 		.name			= "UYVY",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
-	}, [MBUS_IDX(YVYU8_2X8_BE)] = {
+	},
+	[MBUS_IDX(YVYU8_2X8_BE)] = {
 		.fourcc			= V4L2_PIX_FMT_VYUY,
 		.name			= "VYUY",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
-	}, [MBUS_IDX(RGB555_2X8_PADHI_LE)] = {
+	},
+	[MBUS_IDX(RGB555_2X8_PADHI_LE)] = {
 		.fourcc			= V4L2_PIX_FMT_RGB555,
 		.name			= "RGB555",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
-	}, [MBUS_IDX(RGB555_2X8_PADHI_BE)] = {
+	},
+	[MBUS_IDX(RGB555_2X8_PADHI_BE)] = {
 		.fourcc			= V4L2_PIX_FMT_RGB555X,
 		.name			= "RGB555X",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
-	}, [MBUS_IDX(RGB565_2X8_LE)] = {
+	},
+	[MBUS_IDX(RGB565_2X8_LE)] = {
 		.fourcc			= V4L2_PIX_FMT_RGB565,
 		.name			= "RGB565",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
-	}, [MBUS_IDX(RGB565_2X8_BE)] = {
+	},
+	[MBUS_IDX(RGB565_2X8_BE)] = {
 		.fourcc			= V4L2_PIX_FMT_RGB565X,
 		.name			= "RGB565X",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
-	}, [MBUS_IDX(SBGGR8_1X8)] = {
+	},
+	[MBUS_IDX(SBGGR8_1X8)] = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR8,
 		.name			= "Bayer 8 BGGR",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_NONE,
 		.order			= SOC_MBUS_ORDER_LE,
-	}, [MBUS_IDX(SBGGR10_1X10)] = {
+	},
+	[MBUS_IDX(SBGGR10_1X10)] = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR10,
 		.name			= "Bayer 10 BGGR",
 		.bits_per_sample	= 10,
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
-	}, [MBUS_IDX(GREY8_1X8)] = {
+	},
+	[MBUS_IDX(GREY8_1X8)] = {
 		.fourcc			= V4L2_PIX_FMT_GREY,
 		.name			= "Grey",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_NONE,
 		.order			= SOC_MBUS_ORDER_LE,
-	}, [MBUS_IDX(Y10_1X10)] = {
+	},
+	[MBUS_IDX(Y10_1X10)] = {
 		.fourcc			= V4L2_PIX_FMT_Y10,
 		.name			= "Grey 10bit",
 		.bits_per_sample	= 10,
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
-	}, [MBUS_IDX(SBGGR10_2X8_PADHI_LE)] = {
+	},
+	[MBUS_IDX(SBGGR10_2X8_PADHI_LE)] = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR10,
 		.name			= "Bayer 10 BGGR",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
-	}, [MBUS_IDX(SBGGR10_2X8_PADLO_LE)] = {
+	},
+	[MBUS_IDX(SBGGR10_2X8_PADLO_LE)] = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR10,
 		.name			= "Bayer 10 BGGR",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADLO,
 		.order			= SOC_MBUS_ORDER_LE,
-	}, [MBUS_IDX(SBGGR10_2X8_PADHI_BE)] = {
+	},
+	[MBUS_IDX(SBGGR10_2X8_PADHI_BE)] = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR10,
 		.name			= "Bayer 10 BGGR",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
-	}, [MBUS_IDX(SBGGR10_2X8_PADLO_BE)] = {
+	},
+	[MBUS_IDX(SBGGR10_2X8_PADLO_BE)] = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR10,
 		.name			= "Bayer 10 BGGR",
 		.bits_per_sample	= 8,
-- 
1.6.2.4

