Return-path: <linux-media-owner@vger.kernel.org>
Received: from bubo.tul.cz ([147.230.16.1]:50440 "EHLO bubo.tul.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1423576AbdEAETk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 00:19:40 -0400
From: Petr Cvek <petr.cvek@tul.cz>
Subject: [PATCH 1/4] [media] pxa_camera: Add remaining Bayer 8 formats
To: robert.jarzmik@free.fr
References: <cover.1493612057.git.petr.cvek@tul.cz>
Cc: linux-media@vger.kernel.org
Message-ID: <c2961fbe-c4dd-718c-75b6-bb5fad5c7b1e@tul.cz>
Date: Mon, 1 May 2017 06:20:45 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1493612057.git.petr.cvek@tul.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds Bayer 8 GBRG and RGGB support and move GRBG definition
close to BGGR (so all Bayer 8 variants are together). No other changes are
needed as the driver handles them as RAW data stream.

The RGGB variant was tested in a modified OV9640 driver.

Signed-off-by: Petr Cvek <petr.cvek@tul.cz>
---
 drivers/media/platform/pxa_camera.c | 40 +++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 6615f80fe059..5f007713417e 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -345,6 +345,36 @@ static const struct pxa_mbus_lookup mbus_fmt[] = {
 		.layout			= PXA_MBUS_LAYOUT_PACKED,
 	},
 }, {
+	.code = MEDIA_BUS_FMT_SGBRG8_1X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SGBRG8,
+		.name			= "Bayer 8 GBRG",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_NONE,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_SGRBG8_1X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SGRBG8,
+		.name			= "Bayer 8 GRBG",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_NONE,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
+	.code = MEDIA_BUS_FMT_SRGGB8_1X8,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_SRGGB8,
+		.name			= "Bayer 8 RGGB",
+		.bits_per_sample	= 8,
+		.packing		= PXA_MBUS_PACKING_NONE,
+		.order			= PXA_MBUS_ORDER_LE,
+		.layout			= PXA_MBUS_LAYOUT_PACKED,
+	},
+}, {
 	.code = MEDIA_BUS_FMT_SBGGR10_1X10,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR10,
@@ -445,16 +475,6 @@ static const struct pxa_mbus_lookup mbus_fmt[] = {
 		.layout			= PXA_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = MEDIA_BUS_FMT_SGRBG8_1X8,
-	.fmt = {
-		.fourcc			= V4L2_PIX_FMT_SGRBG8,
-		.name			= "Bayer 8 GRBG",
-		.bits_per_sample	= 8,
-		.packing		= PXA_MBUS_PACKING_NONE,
-		.order			= PXA_MBUS_ORDER_LE,
-		.layout			= PXA_MBUS_LAYOUT_PACKED,
-	},
-}, {
 	.code = MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SGRBG10DPCM8,
-- 
2.11.0
