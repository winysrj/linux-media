Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:47137 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab3LLIgt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 03:36:49 -0500
From: Archit Taneja <archit@ti.com>
To: <linux-media@vger.kernel.org>, <k.debski@samsung.com>,
	<hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>
CC: <linux-omap@vger.kernel.org>, <tomi.valkeinen@ti.com>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH 8/8] v4l: ti-vpe: Add a type specifier to describe vpdma data format type
Date: Thu, 12 Dec 2013 14:06:04 +0530
Message-ID: <1386837364-1264-9-git-send-email-archit@ti.com>
In-Reply-To: <1386837364-1264-1-git-send-email-archit@ti.com>
References: <1386837364-1264-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct vpdma_data_format holds the color format depth and the data_type
value needed to be programmed in the data descriptors. However, it doesn't
tell what type of color format is it, i.e, whether it is RGB, YUV or Misc.

This information is needed when by vpdma library when forming descriptors. We
modify the depth parameter for the chroma portion of the NV12 format. For this,
we check if the data_type value is C420. This isn't sufficient as there are
many YUV and RGB vpdma formats which have the same data_type value. Hence, we
need to hold the type of the color format for the above case, and possibly more
cases in the future.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpdma.c | 36 +++++++++++++++++++++++++++++++++--
 drivers/media/platform/ti-vpe/vpdma.h |  7 +++++++
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index f97253f..a268f68 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -30,38 +30,47 @@
 
 const struct vpdma_data_format vpdma_yuv_fmts[] = {
 	[VPDMA_DATA_FMT_Y444] = {
+		.type		= VPDMA_DATA_FMT_TYPE_YUV,
 		.data_type	= DATA_TYPE_Y444,
 		.depth		= 8,
 	},
 	[VPDMA_DATA_FMT_Y422] = {
+		.type		= VPDMA_DATA_FMT_TYPE_YUV,
 		.data_type	= DATA_TYPE_Y422,
 		.depth		= 8,
 	},
 	[VPDMA_DATA_FMT_Y420] = {
+		.type		= VPDMA_DATA_FMT_TYPE_YUV,
 		.data_type	= DATA_TYPE_Y420,
 		.depth		= 8,
 	},
 	[VPDMA_DATA_FMT_C444] = {
+		.type		= VPDMA_DATA_FMT_TYPE_YUV,
 		.data_type	= DATA_TYPE_C444,
 		.depth		= 8,
 	},
 	[VPDMA_DATA_FMT_C422] = {
+		.type		= VPDMA_DATA_FMT_TYPE_YUV,
 		.data_type	= DATA_TYPE_C422,
 		.depth		= 8,
 	},
 	[VPDMA_DATA_FMT_C420] = {
+		.type		= VPDMA_DATA_FMT_TYPE_YUV,
 		.data_type	= DATA_TYPE_C420,
 		.depth		= 4,
 	},
 	[VPDMA_DATA_FMT_YC422] = {
+		.type		= VPDMA_DATA_FMT_TYPE_YUV,
 		.data_type	= DATA_TYPE_YC422,
 		.depth		= 16,
 	},
 	[VPDMA_DATA_FMT_YC444] = {
+		.type		= VPDMA_DATA_FMT_TYPE_YUV,
 		.data_type	= DATA_TYPE_YC444,
 		.depth		= 24,
 	},
 	[VPDMA_DATA_FMT_CY422] = {
+		.type		= VPDMA_DATA_FMT_TYPE_YUV,
 		.data_type	= DATA_TYPE_CY422,
 		.depth		= 16,
 	},
@@ -69,82 +78,102 @@ const struct vpdma_data_format vpdma_yuv_fmts[] = {
 
 const struct vpdma_data_format vpdma_rgb_fmts[] = {
 	[VPDMA_DATA_FMT_RGB565] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_RGB16_565,
 		.depth		= 16,
 	},
 	[VPDMA_DATA_FMT_ARGB16_1555] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_ARGB_1555,
 		.depth		= 16,
 	},
 	[VPDMA_DATA_FMT_ARGB16] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_ARGB_4444,
 		.depth		= 16,
 	},
 	[VPDMA_DATA_FMT_RGBA16_5551] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_RGBA_5551,
 		.depth		= 16,
 	},
 	[VPDMA_DATA_FMT_RGBA16] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_RGBA_4444,
 		.depth		= 16,
 	},
 	[VPDMA_DATA_FMT_ARGB24] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_ARGB24_6666,
 		.depth		= 24,
 	},
 	[VPDMA_DATA_FMT_RGB24] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_RGB24_888,
 		.depth		= 24,
 	},
 	[VPDMA_DATA_FMT_ARGB32] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_ARGB32_8888,
 		.depth		= 32,
 	},
 	[VPDMA_DATA_FMT_RGBA24] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_RGBA24_6666,
 		.depth		= 24,
 	},
 	[VPDMA_DATA_FMT_RGBA32] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_RGBA32_8888,
 		.depth		= 32,
 	},
 	[VPDMA_DATA_FMT_BGR565] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_BGR16_565,
 		.depth		= 16,
 	},
 	[VPDMA_DATA_FMT_ABGR16_1555] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_ABGR_1555,
 		.depth		= 16,
 	},
 	[VPDMA_DATA_FMT_ABGR16] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_ABGR_4444,
 		.depth		= 16,
 	},
 	[VPDMA_DATA_FMT_BGRA16_5551] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_BGRA_5551,
 		.depth		= 16,
 	},
 	[VPDMA_DATA_FMT_BGRA16] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_BGRA_4444,
 		.depth		= 16,
 	},
 	[VPDMA_DATA_FMT_ABGR24] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_ABGR24_6666,
 		.depth		= 24,
 	},
 	[VPDMA_DATA_FMT_BGR24] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_BGR24_888,
 		.depth		= 24,
 	},
 	[VPDMA_DATA_FMT_ABGR32] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_ABGR32_8888,
 		.depth		= 32,
 	},
 	[VPDMA_DATA_FMT_BGRA24] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_BGRA24_6666,
 		.depth		= 24,
 	},
 	[VPDMA_DATA_FMT_BGRA32] = {
+		.type		= VPDMA_DATA_FMT_TYPE_RGB,
 		.data_type	= DATA_TYPE_BGRA32_8888,
 		.depth		= 32,
 	},
@@ -152,6 +181,7 @@ const struct vpdma_data_format vpdma_rgb_fmts[] = {
 
 const struct vpdma_data_format vpdma_misc_fmts[] = {
 	[VPDMA_DATA_FMT_MV] = {
+		.type		= VPDMA_DATA_FMT_TYPE_MISC,
 		.data_type	= DATA_TYPE_MV,
 		.depth		= 4,
 	},
@@ -599,7 +629,8 @@ void vpdma_add_out_dtd(struct vpdma_desc_list *list, struct v4l2_rect *c_rect,
 
 	channel = next_chan = chan_info[chan].num;
 
-	if (fmt->data_type == DATA_TYPE_C420)
+	if (fmt->type == VPDMA_DATA_FMT_TYPE_YUV &&
+			fmt->data_type == DATA_TYPE_C420)
 		depth = 8;
 
 	stride = ALIGN((depth * c_rect->width) >> 3, VPDMA_STRIDE_ALIGN);
@@ -649,7 +680,8 @@ void vpdma_add_in_dtd(struct vpdma_desc_list *list, int frame_width,
 
 	channel = next_chan = chan_info[chan].num;
 
-	if (fmt->data_type == DATA_TYPE_C420) {
+	if (fmt->type == VPDMA_DATA_FMT_TYPE_YUV &&
+			fmt->data_type == DATA_TYPE_C420) {
 		height >>= 1;
 		frame_height >>= 1;
 		depth = 8;
diff --git a/drivers/media/platform/ti-vpe/vpdma.h b/drivers/media/platform/ti-vpe/vpdma.h
index 62dd143..cf40f11 100644
--- a/drivers/media/platform/ti-vpe/vpdma.h
+++ b/drivers/media/platform/ti-vpe/vpdma.h
@@ -39,7 +39,14 @@ struct vpdma_data {
 	bool ready;
 };
 
+enum vpdma_data_format_type {
+	VPDMA_DATA_FMT_TYPE_YUV,
+	VPDMA_DATA_FMT_TYPE_RGB,
+	VPDMA_DATA_FMT_TYPE_MISC,
+};
+
 struct vpdma_data_format {
+	enum vpdma_data_format_type type;
 	int data_type;
 	u8 depth;
 };
-- 
1.8.3.2

