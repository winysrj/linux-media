Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50153 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933687AbcI1VW3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:22:29 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 21/35] media: ti-vpe: vpdma: Corrected YUV422 data type label.
Date: Wed, 28 Sep 2016 16:22:26 -0500
Message-ID: <20160928212226.27265-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The YUV data type definition below are taken from
both the TRM and i839 Errata information.
Use the correct data type considering byte
reordering of components.

Added the 2 missing YUV422 variant.
Also since the single use of "C" in the 422 case
to mean "Cr" (i.e. V component). It was decided
to explicitly label them CR to remove any confusion.
Bear in mind that the type label refer to the memory
packed order (LSB - MSB).

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpdma.c      | 18 ++++++++++++++----
 drivers/media/platform/ti-vpe/vpdma.h      |  6 ++++--
 drivers/media/platform/ti-vpe/vpdma_priv.h | 19 ++++++++++++++++---
 drivers/media/platform/ti-vpe/vpe.c        |  8 ++++----
 4 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index 9f396ff03394..8cf2922c9c6f 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -59,9 +59,9 @@ const struct vpdma_data_format vpdma_yuv_fmts[] = {
 		.data_type	= DATA_TYPE_C420,
 		.depth		= 4,
 	},
-	[VPDMA_DATA_FMT_YC422] = {
+	[VPDMA_DATA_FMT_YCR422] = {
 		.type		= VPDMA_DATA_FMT_TYPE_YUV,
-		.data_type	= DATA_TYPE_YC422,
+		.data_type	= DATA_TYPE_YCR422,
 		.depth		= 16,
 	},
 	[VPDMA_DATA_FMT_YC444] = {
@@ -69,9 +69,19 @@ const struct vpdma_data_format vpdma_yuv_fmts[] = {
 		.data_type	= DATA_TYPE_YC444,
 		.depth		= 24,
 	},
-	[VPDMA_DATA_FMT_CY422] = {
+	[VPDMA_DATA_FMT_CRY422] = {
 		.type		= VPDMA_DATA_FMT_TYPE_YUV,
-		.data_type	= DATA_TYPE_CY422,
+		.data_type	= DATA_TYPE_CRY422,
+		.depth		= 16,
+	},
+	[VPDMA_DATA_FMT_CBY422] = {
+		.type		= VPDMA_DATA_FMT_TYPE_YUV,
+		.data_type	= DATA_TYPE_CBY422,
+		.depth		= 16,
+	},
+	[VPDMA_DATA_FMT_YCB422] = {
+		.type		= VPDMA_DATA_FMT_TYPE_YUV,
+		.data_type	= DATA_TYPE_YCB422,
 		.depth		= 16,
 	},
 };
diff --git a/drivers/media/platform/ti-vpe/vpdma.h b/drivers/media/platform/ti-vpe/vpdma.h
index ccf871ad8800..405a6febc254 100644
--- a/drivers/media/platform/ti-vpe/vpdma.h
+++ b/drivers/media/platform/ti-vpe/vpdma.h
@@ -74,9 +74,11 @@ enum vpdma_yuv_formats {
 	VPDMA_DATA_FMT_C444,
 	VPDMA_DATA_FMT_C422,
 	VPDMA_DATA_FMT_C420,
-	VPDMA_DATA_FMT_YC422,
+	VPDMA_DATA_FMT_YCR422,
 	VPDMA_DATA_FMT_YC444,
-	VPDMA_DATA_FMT_CY422,
+	VPDMA_DATA_FMT_CRY422,
+	VPDMA_DATA_FMT_CBY422,
+	VPDMA_DATA_FMT_YCB422,
 };
 
 enum vpdma_rgb_formats {
diff --git a/drivers/media/platform/ti-vpe/vpdma_priv.h b/drivers/media/platform/ti-vpe/vpdma_priv.h
index 54b6aa866c74..f974a803fa27 100644
--- a/drivers/media/platform/ti-vpe/vpdma_priv.h
+++ b/drivers/media/platform/ti-vpe/vpdma_priv.h
@@ -77,16 +77,29 @@
 #define VPDMA_LIST_TYPE_SHFT		16
 #define VPDMA_LIST_SIZE_MASK		0xffff
 
-/* VPDMA data type values for data formats */
+/*
+ * The YUV data type definition below are taken from
+ * both the TRM and i839 Errata information.
+ * Use the correct data type considering byte
+ * reordering of components.
+ *
+ * Also since the single use of "C" in the 422 case
+ * to mean "Cr" (i.e. V component). It was decided
+ * to explicitly label them CR to remove any confusion.
+ * Bear in mind that the type label refer to the memory
+ * packed order (LSB - MSB).
+ */
 #define DATA_TYPE_Y444				0x0
 #define DATA_TYPE_Y422				0x1
 #define DATA_TYPE_Y420				0x2
 #define DATA_TYPE_C444				0x4
 #define DATA_TYPE_C422				0x5
 #define DATA_TYPE_C420				0x6
-#define DATA_TYPE_YC422				0x7
 #define DATA_TYPE_YC444				0x8
-#define DATA_TYPE_CY422				0x27
+#define DATA_TYPE_YCB422			0x7
+#define DATA_TYPE_YCR422			0x17
+#define DATA_TYPE_CBY422			0x27
+#define DATA_TYPE_CRY422			0x37
 
 #define DATA_TYPE_RGB16_565			0x0
 #define DATA_TYPE_ARGB_1555			0x1
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 57d19ad6d4a5..ee85c68d5771 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -237,7 +237,7 @@ struct vpe_fmt {
 
 static struct vpe_fmt vpe_formats[] = {
 	{
-		.name		= "YUV 422 co-planar",
+		.name		= "NV16 YUV 422 co-planar",
 		.fourcc		= V4L2_PIX_FMT_NV16,
 		.types		= VPE_FMT_TYPE_CAPTURE | VPE_FMT_TYPE_OUTPUT,
 		.coplanar	= 1,
@@ -246,7 +246,7 @@ static struct vpe_fmt vpe_formats[] = {
 				  },
 	},
 	{
-		.name		= "YUV 420 co-planar",
+		.name		= "NV12 YUV 420 co-planar",
 		.fourcc		= V4L2_PIX_FMT_NV12,
 		.types		= VPE_FMT_TYPE_CAPTURE | VPE_FMT_TYPE_OUTPUT,
 		.coplanar	= 1,
@@ -259,7 +259,7 @@ static struct vpe_fmt vpe_formats[] = {
 		.fourcc		= V4L2_PIX_FMT_YUYV,
 		.types		= VPE_FMT_TYPE_CAPTURE | VPE_FMT_TYPE_OUTPUT,
 		.coplanar	= 0,
-		.vpdma_fmt	= { &vpdma_yuv_fmts[VPDMA_DATA_FMT_YC422],
+		.vpdma_fmt	= { &vpdma_yuv_fmts[VPDMA_DATA_FMT_YCB422],
 				  },
 	},
 	{
@@ -267,7 +267,7 @@ static struct vpe_fmt vpe_formats[] = {
 		.fourcc		= V4L2_PIX_FMT_UYVY,
 		.types		= VPE_FMT_TYPE_CAPTURE | VPE_FMT_TYPE_OUTPUT,
 		.coplanar	= 0,
-		.vpdma_fmt	= { &vpdma_yuv_fmts[VPDMA_DATA_FMT_CY422],
+		.vpdma_fmt	= { &vpdma_yuv_fmts[VPDMA_DATA_FMT_CBY422],
 				  },
 	},
 	{
-- 
2.9.0

