Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50199 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934106AbcI1VXk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:23:40 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 32/35] media: ti-vpe: vpdma: Add RAW8 and RAW16 data types
Date: Wed, 28 Sep 2016 16:23:37 -0500
Message-ID: <20160928212337.27760-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add RAW8 and RAW16 data type to VPDMA.
To handle RAW format we are re-using the YUV CBY422
vpdma data type so that we use the vpdma to re-order
the incoming bytes, as the VIP parser assumes that the
first byte presented on the bus is the MSB of a 2
bytes value.

RAW8 handles from 1 to 8 bits.
RAW16 handles from 9 to 16 bits.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpdma.c | 23 +++++++++++++++++++++++
 drivers/media/platform/ti-vpe/vpdma.h |  6 ++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index e8ed6bae83ed..422fb0840e6e 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -191,6 +191,29 @@ const struct vpdma_data_format vpdma_rgb_fmts[] = {
 };
 EXPORT_SYMBOL(vpdma_rgb_fmts);
 
+/*
+ * To handle RAW format we are re-using the CBY422
+ * vpdma data type so that we use the vpdma to re-order
+ * the incoming bytes, as the parser assumes that the
+ * first byte presented on the bus is the MSB of a 2
+ * bytes value.
+ * RAW8 handles from 1 to 8 bits
+ * RAW16 handles from 9 to 16 bits
+ */
+const struct vpdma_data_format vpdma_raw_fmts[] = {
+	[VPDMA_DATA_FMT_RAW8] = {
+		.type		= VPDMA_DATA_FMT_TYPE_YUV,
+		.data_type	= DATA_TYPE_CBY422,
+		.depth		= 8,
+	},
+	[VPDMA_DATA_FMT_RAW16] = {
+		.type		= VPDMA_DATA_FMT_TYPE_YUV,
+		.data_type	= DATA_TYPE_CBY422,
+		.depth		= 16,
+	},
+};
+EXPORT_SYMBOL(vpdma_raw_fmts);
+
 const struct vpdma_data_format vpdma_misc_fmts[] = {
 	[VPDMA_DATA_FMT_MV] = {
 		.type		= VPDMA_DATA_FMT_TYPE_MISC,
diff --git a/drivers/media/platform/ti-vpe/vpdma.h b/drivers/media/platform/ti-vpe/vpdma.h
index 0df156b7c1cf..131700c112b2 100644
--- a/drivers/media/platform/ti-vpe/vpdma.h
+++ b/drivers/media/platform/ti-vpe/vpdma.h
@@ -104,12 +104,18 @@ enum vpdma_rgb_formats {
 	VPDMA_DATA_FMT_BGRA32,
 };
 
+enum vpdma_raw_formats {
+	VPDMA_DATA_FMT_RAW8 = 0,
+	VPDMA_DATA_FMT_RAW16,
+};
+
 enum vpdma_misc_formats {
 	VPDMA_DATA_FMT_MV = 0,
 };
 
 extern const struct vpdma_data_format vpdma_yuv_fmts[];
 extern const struct vpdma_data_format vpdma_rgb_fmts[];
+extern const struct vpdma_data_format vpdma_raw_fmts[];
 extern const struct vpdma_data_format vpdma_misc_fmts[];
 
 enum vpdma_frame_start_event {
-- 
2.9.0

