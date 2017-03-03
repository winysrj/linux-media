Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57811 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751518AbdCCMb6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 07:31:58 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: [PATCH 4/4] [media] coda: disable reordering for baseline profile h.264 streams
Date: Fri,  3 Mar 2017 13:12:50 +0100
Message-Id: <20170303121250.13693-4-p.zabel@pengutronix.de>
In-Reply-To: <20170303121250.13693-1-p.zabel@pengutronix.de>
References: <20170303121250.13693-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With reordering enabled, the sequence init in CODA960 firmware requests an
unreasonable number of internal frames for some baseline profile streams.
Disabling the reordering feature manually if baseline streams are detected
fixes this problem.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 44 ++++++++++++++++++++-
 drivers/media/platform/coda/coda-common.c | 12 ++++++
 drivers/media/platform/coda/coda-h264.c   | 63 +++++++++++++++++++++++++++++++
 drivers/media/platform/coda/coda.h        |  5 +++
 4 files changed, 122 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 89965ca5bd250..403214e00e954 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1548,6 +1548,47 @@ static int coda_decoder_reqbufs(struct coda_ctx *ctx,
 	return 0;
 }
 
+static bool coda_reorder_enable(struct coda_ctx *ctx)
+{
+	const char * const *profile_names;
+	const char * const *level_names;
+	struct coda_dev *dev = ctx->dev;
+	int profile, level;
+
+	if (dev->devtype->product != CODA_7541 &&
+	    dev->devtype->product != CODA_960)
+		return false;
+
+	if (ctx->codec->src_fourcc == V4L2_PIX_FMT_JPEG)
+		return false;
+
+	if (ctx->codec->src_fourcc != V4L2_PIX_FMT_H264)
+		return true;
+
+	profile = coda_h264_profile(ctx->params.h264_profile_idc);
+	if (profile < 0) {
+		v4l2_warn(&dev->v4l2_dev, "Invalid H264 Profile: %d\n",
+			 ctx->params.h264_profile_idc);
+		return false;
+	}
+
+	level = coda_h264_level(ctx->params.h264_level_idc);
+	if (level < 0) {
+		v4l2_warn(&dev->v4l2_dev, "Invalid H264 Level: %d\n",
+			 ctx->params.h264_level_idc);
+		return false;
+	}
+
+	profile_names = v4l2_ctrl_get_menu(V4L2_CID_MPEG_VIDEO_H264_PROFILE);
+	level_names = v4l2_ctrl_get_menu(V4L2_CID_MPEG_VIDEO_H264_LEVEL);
+
+	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "H264 Profile/Level: %s L%s\n",
+		 profile_names[profile], level_names[level]);
+
+	/* Baseline profile does not support reordering */
+	return profile > V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE;
+}
+
 static int __coda_start_decoding(struct coda_ctx *ctx)
 {
 	struct coda_q_data *q_data_src, *q_data_dst;
@@ -1594,8 +1635,7 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	coda_write(dev, bitstream_buf, CODA_CMD_DEC_SEQ_BB_START);
 	coda_write(dev, bitstream_size / 1024, CODA_CMD_DEC_SEQ_BB_SIZE);
 	val = 0;
-	if ((dev->devtype->product == CODA_7541) ||
-	    (dev->devtype->product == CODA_960))
+	if (coda_reorder_enable(ctx))
 		val |= CODA_REORDER_ENABLE;
 	if (ctx->codec->src_fourcc == V4L2_PIX_FMT_JPEG)
 		val |= CODA_NO_INT_ENABLE;
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index f3d4a595bb13a..6fb6402de3a98 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1374,6 +1374,18 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 		 */
 		if (vb2_get_plane_payload(vb, 0) == 0)
 			coda_bit_stream_end_flag(ctx);
+
+		if (q_data->fourcc == V4L2_PIX_FMT_H264) {
+			/*
+			 * Unless already done, try to obtain profile_idc and
+			 * level_idc from the SPS header. This allows to decide
+			 * whether to enable reordering during sequence
+			 * initialization.
+			 */
+			if (!ctx->params.h264_profile_idc)
+				coda_sps_parse_profile(ctx, vb);
+		}
+
 		mutex_lock(&ctx->bitstream_mutex);
 		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 		if (vb2_is_streaming(vb->vb2_queue))
diff --git a/drivers/media/platform/coda/coda-h264.c b/drivers/media/platform/coda/coda-h264.c
index dc137c3fd510b..0e27412e01f54 100644
--- a/drivers/media/platform/coda/coda-h264.c
+++ b/drivers/media/platform/coda/coda-h264.c
@@ -13,10 +13,42 @@
 
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <linux/videodev2.h>
 #include <coda.h>
 
 static const u8 coda_filler_size[8] = { 0, 7, 14, 13, 12, 11, 10, 9 };
 
+static const u8 *coda_find_nal_header(const u8 *buf, const u8 *end)
+{
+	u32 val = 0xffffffff;
+
+	do {
+		val = val << 8 | *buf++;
+		if (buf >= end)
+			return NULL;
+	} while (val != 0x00000001);
+
+	return buf;
+}
+
+int coda_sps_parse_profile(struct coda_ctx *ctx, struct vb2_buffer *vb)
+{
+	const u8 *buf = vb2_plane_vaddr(vb, 0);
+	const u8 *end = buf + vb2_get_plane_payload(vb, 0);
+
+	/* Find SPS header */
+	do {
+		buf = coda_find_nal_header(buf, end);
+		if (!buf)
+			return -EINVAL;
+	} while ((*buf++ & 0x1f) != 0x7);
+
+	ctx->params.h264_profile_idc = buf[0];
+	ctx->params.h264_level_idc = buf[2];
+
+	return 0;
+}
+
 int coda_h264_filler_nal(int size, char *p)
 {
 	if (size < 6)
@@ -48,3 +80,34 @@ int coda_h264_padding(int size, char *p)
 
 	return nal_size;
 }
+
+int coda_h264_profile(int profile_idc)
+{
+	switch (profile_idc) {
+	case 66: return V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE;
+	case 77: return V4L2_MPEG_VIDEO_H264_PROFILE_MAIN;
+	case 88: return V4L2_MPEG_VIDEO_H264_PROFILE_EXTENDED;
+	case 100: return V4L2_MPEG_VIDEO_H264_PROFILE_HIGH;
+	default: return -EINVAL;
+	}
+}
+
+int coda_h264_level(int level_idc)
+{
+	switch (level_idc) {
+	case 10: return V4L2_MPEG_VIDEO_H264_LEVEL_1_0;
+	case 9:  return V4L2_MPEG_VIDEO_H264_LEVEL_1B;
+	case 11: return V4L2_MPEG_VIDEO_H264_LEVEL_1_1;
+	case 12: return V4L2_MPEG_VIDEO_H264_LEVEL_1_2;
+	case 13: return V4L2_MPEG_VIDEO_H264_LEVEL_1_3;
+	case 20: return V4L2_MPEG_VIDEO_H264_LEVEL_2_0;
+	case 21: return V4L2_MPEG_VIDEO_H264_LEVEL_2_1;
+	case 22: return V4L2_MPEG_VIDEO_H264_LEVEL_2_2;
+	case 30: return V4L2_MPEG_VIDEO_H264_LEVEL_3_0;
+	case 31: return V4L2_MPEG_VIDEO_H264_LEVEL_3_1;
+	case 32: return V4L2_MPEG_VIDEO_H264_LEVEL_3_2;
+	case 40: return V4L2_MPEG_VIDEO_H264_LEVEL_4_0;
+	case 41: return V4L2_MPEG_VIDEO_H264_LEVEL_4_1;
+	default: return -EINVAL;
+	}
+}
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index a730bc2a2ff99..5e762f5c533de 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -117,6 +117,8 @@ struct coda_params {
 	u8			h264_deblk_enabled;
 	u8			h264_deblk_alpha;
 	u8			h264_deblk_beta;
+	u8			h264_profile_idc;
+	u8			h264_level_idc;
 	u8			mpeg4_intra_qp;
 	u8			mpeg4_inter_qp;
 	u8			gop_size;
@@ -292,6 +294,9 @@ void coda_m2m_buf_done(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf,
 
 int coda_h264_filler_nal(int size, char *p);
 int coda_h264_padding(int size, char *p);
+int coda_h264_profile(int profile_idc);
+int coda_h264_level(int level_idc);
+int coda_sps_parse_profile(struct coda_ctx *ctx, struct vb2_buffer *vb);
 
 bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_buffer *vb);
 int coda_jpeg_write_tables(struct coda_ctx *ctx);
-- 
2.11.0
