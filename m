Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50777 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933033AbeF1PrS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 11:47:18 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: [PATCH 1/2] media: coda: add read-only h.264 decoder profile/level controls
Date: Thu, 28 Jun 2018 17:47:08 +0200
Message-Id: <20180628154709.29953-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The decoder profile/level controls initially can be used to determine
supported profiles and levels. The values are set for a given stream
once the headers are parsed.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 115 +++++++++++++++++++++-
 drivers/media/platform/coda/coda.h        |   2 +
 2 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index c7631e117dd3..f9d787a3c9ad 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1413,6 +1413,72 @@ static int coda_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
+static void coda_update_menu_ctrl(struct v4l2_ctrl *ctrl, int value)
+{
+	if (!ctrl)
+		return;
+
+	v4l2_ctrl_lock(ctrl);
+
+	/*
+	 * Extend the control range if the parsed stream contains a known but
+	 * unsupported value or level.
+	 */
+	if (value > ctrl->maximum) {
+		__v4l2_ctrl_modify_range(ctrl, ctrl->minimum, value,
+			ctrl->menu_skip_mask & ~(1 << value),
+			ctrl->default_value);
+	} else if (value < ctrl->minimum) {
+		__v4l2_ctrl_modify_range(ctrl, value, ctrl->maximum,
+			ctrl->menu_skip_mask & ~(1 << value),
+			ctrl->default_value);
+	}
+
+	__v4l2_ctrl_s_ctrl(ctrl, value);
+
+	v4l2_ctrl_unlock(ctrl);
+}
+
+static void coda_update_h264_profile_ctrl(struct coda_ctx *ctx)
+{
+	const char * const *profile_names;
+	int profile;
+
+	profile = coda_h264_profile(ctx->params.h264_profile_idc);
+	if (profile < 0) {
+		v4l2_warn(&ctx->dev->v4l2_dev, "Invalid H264 Profile: %u\n",
+			  ctx->params.h264_profile_idc);
+		return;
+	}
+
+	coda_update_menu_ctrl(ctx->h264_profile_ctrl, profile);
+
+	profile_names = v4l2_ctrl_get_menu(V4L2_CID_MPEG_VIDEO_H264_PROFILE);
+
+	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "Parsed H264 Profile: %s\n",
+		 profile_names[profile]);
+}
+
+static void coda_update_h264_level_ctrl(struct coda_ctx *ctx)
+{
+	const char * const *level_names;
+	int level;
+
+	level = coda_h264_level(ctx->params.h264_level_idc);
+	if (level < 0) {
+		v4l2_warn(&ctx->dev->v4l2_dev, "Invalid H264 Level: %u\n",
+			  ctx->params.h264_level_idc);
+		return;
+	}
+
+	coda_update_menu_ctrl(ctx->h264_level_ctrl, level);
+
+	level_names = v4l2_ctrl_get_menu(V4L2_CID_MPEG_VIDEO_H264_LEVEL);
+
+	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "Parsed H264 Level: %s\n",
+		 level_names[level]);
+}
+
 static void coda_buf_queue(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
@@ -1441,8 +1507,11 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 			 * whether to enable reordering during sequence
 			 * initialization.
 			 */
-			if (!ctx->params.h264_profile_idc)
+			if (!ctx->params.h264_profile_idc) {
 				coda_sps_parse_profile(ctx, vb);
+				coda_update_h264_profile_ctrl(ctx);
+				coda_update_h264_level_ctrl(ctx);
+			}
 		}
 
 		mutex_lock(&ctx->bitstream_mutex);
@@ -1880,6 +1949,47 @@ static void coda_jpeg_encode_ctrls(struct coda_ctx *ctx)
 		V4L2_CID_JPEG_RESTART_INTERVAL, 0, 100, 1, 0);
 }
 
+static void coda_decode_ctrls(struct coda_ctx *ctx)
+{
+	u64 mask;
+	u8 max;
+
+	ctx->h264_profile_ctrl = v4l2_ctrl_new_std_menu(&ctx->ctrls,
+		&coda_ctrl_ops, V4L2_CID_MPEG_VIDEO_H264_PROFILE,
+		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH,
+		~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE) |
+		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_MAIN) |
+		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_HIGH)),
+		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH);
+	if (ctx->h264_profile_ctrl)
+		ctx->h264_profile_ctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+
+	if (ctx->dev->devtype->product == CODA_HX4 ||
+	    ctx->dev->devtype->product == CODA_7541) {
+		max = V4L2_MPEG_VIDEO_H264_LEVEL_4_0;
+		mask = ~((1 << V4L2_MPEG_VIDEO_H264_LEVEL_2_0) |
+			 (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_0) |
+			 (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_1) |
+			 (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_2) |
+			 (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_0));
+	} else if (ctx->dev->devtype->product == CODA_960) {
+		max = V4L2_MPEG_VIDEO_H264_LEVEL_4_1;
+		mask = ~((1 << V4L2_MPEG_VIDEO_H264_LEVEL_2_0) |
+			 (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_0) |
+			 (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_1) |
+			 (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_2) |
+			 (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_0) |
+			 (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_1));
+	} else {
+		return;
+	}
+	ctx->h264_level_ctrl = v4l2_ctrl_new_std_menu(&ctx->ctrls,
+		&coda_ctrl_ops, V4L2_CID_MPEG_VIDEO_H264_LEVEL, max, mask,
+		max);
+	if (ctx->h264_level_ctrl)
+		ctx->h264_level_ctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+}
+
 static int coda_ctrls_setup(struct coda_ctx *ctx)
 {
 	v4l2_ctrl_handler_init(&ctx->ctrls, 2);
@@ -1893,6 +2003,9 @@ static int coda_ctrls_setup(struct coda_ctx *ctx)
 			coda_jpeg_encode_ctrls(ctx);
 		else
 			coda_encode_ctrls(ctx);
+	} else {
+		if (ctx->cvd->src_formats[0] == V4L2_PIX_FMT_H264)
+			coda_decode_ctrls(ctx);
 	}
 
 	if (ctx->ctrls.error) {
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index c70cfab2433f..9f57f73161d6 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -214,6 +214,8 @@ struct coda_ctx {
 	enum v4l2_quantization		quantization;
 	struct coda_params		params;
 	struct v4l2_ctrl_handler	ctrls;
+	struct v4l2_ctrl		*h264_profile_ctrl;
+	struct v4l2_ctrl		*h264_level_ctrl;
 	struct v4l2_fh			fh;
 	int				gopcounter;
 	int				runcounter;
-- 
2.17.1
