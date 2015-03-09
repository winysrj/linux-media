Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:58896 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932362AbbCIP4l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:56:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 26/29] vivid: add new format fields
Date: Mon,  9 Mar 2015 16:44:48 +0100
Message-Id: <1425915891-1017-27-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These fields are necessary to handle the new planar formats.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.h       |  4 +-
 drivers/media/platform/vivid/vivid-vid-cap.c    | 18 ++++--
 drivers/media/platform/vivid/vivid-vid-common.c | 84 ++++++++++++++++++-------
 drivers/media/platform/vivid/vivid-vid-out.c    |  8 +--
 4 files changed, 81 insertions(+), 33 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 191d9b5..bcefd19 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -79,12 +79,14 @@ extern unsigned vivid_debug;
 struct vivid_fmt {
 	const char *name;
 	u32	fourcc;          /* v4l2 format id */
-	u8	depth;
 	bool	is_yuv;
 	bool	can_do_overlay;
+	u8	vdownsampling[TPG_MAX_PLANES];
 	u32	alpha_mask;
 	u8	planes;
+	u8	buffers;
 	u32	data_offset[TPG_MAX_PLANES];
+	u32	bit_depth[TPG_MAX_PLANES];
 };
 
 extern struct vivid_fmt vivid_formats[];
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index d41ac44..4d50961 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -42,20 +42,26 @@ static const struct vivid_fmt formats_ovl[] = {
 	{
 		.name     = "RGB565 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
-		.depth    = 16,
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
 		.planes   = 1,
+		.buffers = 1,
 	},
 	{
 		.name     = "XRGB555 (LE)",
 		.fourcc   = V4L2_PIX_FMT_XRGB555, /* gggbbbbb arrrrrgg */
-		.depth    = 16,
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
 		.planes   = 1,
+		.buffers = 1,
 	},
 	{
 		.name     = "ARGB555 (LE)",
 		.fourcc   = V4L2_PIX_FMT_ARGB555, /* gggbbbbb arrrrrgg */
-		.depth    = 16,
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
 		.planes   = 1,
+		.buffers = 1,
 	},
 };
 
@@ -597,9 +603,9 @@ int vivid_try_fmt_vid_cap(struct file *file, void *priv,
 	/* This driver supports custom bytesperline values */
 
 	/* Calculate the minimum supported bytesperline value */
-	bytesperline = (mp->width * fmt->depth) >> 3;
+	bytesperline = (mp->width * fmt->bit_depth[0]) >> 3;
 	/* Calculate the maximum supported bytesperline value */
-	max_bpl = (MAX_ZOOM * MAX_WIDTH * fmt->depth) >> 3;
+	max_bpl = (MAX_ZOOM * MAX_WIDTH * fmt->bit_depth[0]) >> 3;
 	mp->num_planes = fmt->planes;
 	for (p = 0; p < mp->num_planes; p++) {
 		if (pfmt[p].bytesperline > max_bpl)
@@ -1224,7 +1230,7 @@ int vivid_vid_cap_s_fbuf(struct file *file, void *fh,
 	fmt = vivid_get_format(dev, a->fmt.pixelformat);
 	if (!fmt || !fmt->can_do_overlay)
 		return -EINVAL;
-	if (a->fmt.bytesperline < (a->fmt.width * fmt->depth) / 8)
+	if (a->fmt.bytesperline < (a->fmt.width * fmt->bit_depth[0]) / 8)
 		return -EINVAL;
 	if (a->fmt.height * a->fmt.bytesperline < a->fmt.sizeimage)
 		return -EINVAL;
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 49c9bc6..7a02aef 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -46,139 +46,179 @@ struct vivid_fmt vivid_formats[] = {
 	{
 		.name     = "4:2:2, packed, YUYV",
 		.fourcc   = V4L2_PIX_FMT_YUYV,
-		.depth    = 16,
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
 		.is_yuv   = true,
 		.planes   = 1,
+		.buffers = 1,
 		.data_offset = { PLANE0_DATA_OFFSET, 0 },
 	},
 	{
 		.name     = "4:2:2, packed, UYVY",
 		.fourcc   = V4L2_PIX_FMT_UYVY,
-		.depth    = 16,
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
 		.is_yuv   = true,
 		.planes   = 1,
+		.buffers = 1,
 	},
 	{
 		.name     = "4:2:2, packed, YVYU",
 		.fourcc   = V4L2_PIX_FMT_YVYU,
-		.depth    = 16,
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
 		.is_yuv   = true,
 		.planes   = 1,
+		.buffers = 1,
 	},
 	{
 		.name     = "4:2:2, packed, VYUY",
 		.fourcc   = V4L2_PIX_FMT_VYUY,
-		.depth    = 16,
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
 		.is_yuv   = true,
 		.planes   = 1,
+		.buffers = 1,
 	},
 	{
 		.name     = "RGB565 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
-		.depth    = 16,
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
 		.planes   = 1,
+		.buffers = 1,
 		.can_do_overlay = true,
 	},
 	{
 		.name     = "RGB565 (BE)",
 		.fourcc   = V4L2_PIX_FMT_RGB565X, /* rrrrrggg gggbbbbb */
-		.depth    = 16,
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
 		.planes   = 1,
+		.buffers = 1,
 		.can_do_overlay = true,
 	},
 	{
 		.name     = "RGB555 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB555, /* gggbbbbb arrrrrgg */
-		.depth    = 16,
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
 		.planes   = 1,
+		.buffers = 1,
 		.can_do_overlay = true,
 	},
 	{
 		.name     = "XRGB555 (LE)",
 		.fourcc   = V4L2_PIX_FMT_XRGB555, /* gggbbbbb arrrrrgg */
-		.depth    = 16,
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
 		.planes   = 1,
+		.buffers = 1,
 		.can_do_overlay = true,
 	},
 	{
 		.name     = "ARGB555 (LE)",
 		.fourcc   = V4L2_PIX_FMT_ARGB555, /* gggbbbbb arrrrrgg */
-		.depth    = 16,
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
 		.planes   = 1,
+		.buffers = 1,
 		.can_do_overlay = true,
 		.alpha_mask = 0x8000,
 	},
 	{
 		.name     = "RGB555 (BE)",
 		.fourcc   = V4L2_PIX_FMT_RGB555X, /* arrrrrgg gggbbbbb */
-		.depth    = 16,
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
 		.planes   = 1,
+		.buffers = 1,
 		.can_do_overlay = true,
 	},
 	{
 		.name     = "RGB24 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB24, /* rgb */
-		.depth    = 24,
+		.vdownsampling = { 1 },
+		.bit_depth = { 24 },
 		.planes   = 1,
+		.buffers = 1,
 	},
 	{
 		.name     = "RGB24 (BE)",
 		.fourcc   = V4L2_PIX_FMT_BGR24, /* bgr */
-		.depth    = 24,
+		.vdownsampling = { 1 },
+		.bit_depth = { 24 },
 		.planes   = 1,
+		.buffers = 1,
 	},
 	{
 		.name     = "RGB32 (LE)",
 		.fourcc   = V4L2_PIX_FMT_RGB32, /* argb */
-		.depth    = 32,
+		.vdownsampling = { 1 },
+		.bit_depth = { 32 },
 		.planes   = 1,
+		.buffers = 1,
 	},
 	{
 		.name     = "RGB32 (BE)",
 		.fourcc   = V4L2_PIX_FMT_BGR32, /* bgra */
-		.depth    = 32,
+		.vdownsampling = { 1 },
+		.bit_depth = { 32 },
 		.planes   = 1,
+		.buffers = 1,
 	},
 	{
 		.name     = "XRGB32 (LE)",
 		.fourcc   = V4L2_PIX_FMT_XRGB32, /* argb */
-		.depth    = 32,
+		.vdownsampling = { 1 },
+		.bit_depth = { 32 },
 		.planes   = 1,
+		.buffers = 1,
 	},
 	{
 		.name     = "XRGB32 (BE)",
 		.fourcc   = V4L2_PIX_FMT_XBGR32, /* bgra */
-		.depth    = 32,
+		.vdownsampling = { 1 },
+		.bit_depth = { 32 },
 		.planes   = 1,
+		.buffers = 1,
 	},
 	{
 		.name     = "ARGB32 (LE)",
 		.fourcc   = V4L2_PIX_FMT_ARGB32, /* argb */
-		.depth    = 32,
+		.vdownsampling = { 1 },
+		.bit_depth = { 32 },
 		.planes   = 1,
+		.buffers = 1,
 		.alpha_mask = 0x000000ff,
 	},
 	{
 		.name     = "ARGB32 (BE)",
 		.fourcc   = V4L2_PIX_FMT_ABGR32, /* bgra */
-		.depth    = 32,
+		.vdownsampling = { 1 },
+		.bit_depth = { 32 },
 		.planes   = 1,
+		.buffers = 1,
 		.alpha_mask = 0xff000000,
 	},
 	{
-		.name     = "4:2:2, planar, YUV",
+		.name     = "4:2:2, biplanar, YUV",
 		.fourcc   = V4L2_PIX_FMT_NV16M,
-		.depth    = 8,
+		.vdownsampling = { 1, 1 },
+		.bit_depth = { 8, 8 },
 		.is_yuv   = true,
 		.planes   = 2,
+		.buffers = 2,
 		.data_offset = { PLANE0_DATA_OFFSET, 0 },
 	},
 	{
-		.name     = "4:2:2, planar, YVU",
+		.name     = "4:2:2, biplanar, YVU",
 		.fourcc   = V4L2_PIX_FMT_NV61M,
-		.depth    = 8,
+		.vdownsampling = { 1, 1 },
+		.bit_depth = { 8, 8 },
 		.is_yuv   = true,
 		.planes   = 2,
+		.buffers = 2,
 		.data_offset = { 0, PLANE0_DATA_OFFSET },
 	},
 };
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 39ff79f..17b026b 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -267,9 +267,9 @@ void vivid_update_format_out(struct vivid_dev *dev)
 	if (V4L2_FIELD_HAS_T_OR_B(dev->field_out))
 		dev->crop_out.height /= 2;
 	dev->fmt_out_rect = dev->crop_out;
-	dev->bytesperline_out[0] = (dev->sink_rect.width * dev->fmt_out->depth) / 8;
+	dev->bytesperline_out[0] = (dev->sink_rect.width * dev->fmt_out->bit_depth[0]) / 8;
 	if (dev->fmt_out->planes == 2)
-		dev->bytesperline_out[1] = (dev->sink_rect.width * dev->fmt_out->depth) / 8;
+		dev->bytesperline_out[1] = (dev->sink_rect.width * dev->fmt_out->bit_depth[0]) / 8;
 }
 
 /* Map the field to something that is valid for the current output */
@@ -386,9 +386,9 @@ int vivid_try_fmt_vid_out(struct file *file, void *priv,
 	/* This driver supports custom bytesperline values */
 
 	/* Calculate the minimum supported bytesperline value */
-	bytesperline = (mp->width * fmt->depth) >> 3;
+	bytesperline = (mp->width * fmt->bit_depth[0]) >> 3;
 	/* Calculate the maximum supported bytesperline value */
-	max_bpl = (MAX_ZOOM * MAX_WIDTH * fmt->depth) >> 3;
+	max_bpl = (MAX_ZOOM * MAX_WIDTH * fmt->bit_depth[0]) >> 3;
 	mp->num_planes = fmt->planes;
 	for (p = 0; p < mp->num_planes; p++) {
 		if (pfmt[p].bytesperline > max_bpl)
-- 
2.1.4

