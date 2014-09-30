Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45532 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaI3J5p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 05:57:45 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 01/10] [media] coda: add support for planar YCbCr 4:2:2 (YUV422P) format
Date: Tue, 30 Sep 2014 11:57:02 +0200
Message-Id: <1412071031-32016-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>
References: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the three-plane YUV422P format with one luma plane
and two horizontally subsampled chroma planes.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 14 +++++++++++++-
 drivers/media/platform/coda/coda-common.c | 13 +++++++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index fde7775..746a615 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1591,6 +1591,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	struct coda_q_data *q_data_dst;
 	struct vb2_buffer *dst_buf;
 	struct coda_timestamp *ts;
+	unsigned long payload;
 	int width, height;
 	int decoded_idx;
 	int display_idx;
@@ -1776,7 +1777,18 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		dst_buf->v4l2_buf.timecode = ts->timecode;
 		dst_buf->v4l2_buf.timestamp = ts->timestamp;
 
-		vb2_set_plane_payload(dst_buf, 0, width * height * 3 / 2);
+		switch (q_data_dst->fourcc) {
+		case V4L2_PIX_FMT_YUV420:
+		case V4L2_PIX_FMT_YVU420:
+		case V4L2_PIX_FMT_NV12:
+		default:
+			payload = width * height * 3 / 2;
+			break;
+		case V4L2_PIX_FMT_YUV422P:
+			payload = width * height * 2;
+			break;
+		}
+		vb2_set_plane_payload(dst_buf, 0, payload);
 
 		v4l2_m2m_buf_done(dst_buf, ctx->frame_errors[display_idx] ?
 				  VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 02d47fa..48be973 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -100,6 +100,9 @@ void coda_write_base(struct coda_ctx *ctx, struct coda_q_data *q_data,
 		base_cb = base_y + q_data->bytesperline * q_data->height;
 		base_cr = base_cb + q_data->bytesperline * q_data->height / 4;
 		break;
+	case V4L2_PIX_FMT_YUV422P:
+		base_cb = base_y + q_data->bytesperline * q_data->height;
+		base_cr = base_cb + q_data->bytesperline * q_data->height / 2;
 	}
 
 	coda_write(ctx->dev, base_y, reg_y);
@@ -124,6 +127,10 @@ static const struct coda_fmt coda_formats[] = {
 		.fourcc = V4L2_PIX_FMT_NV12,
 	},
 	{
+		.name = "YUV 4:2:2 Planar, YCbCr",
+		.fourcc = V4L2_PIX_FMT_YUV422P,
+	},
+	{
 		.name = "H264 Encoded Stream",
 		.fourcc = V4L2_PIX_FMT_H264,
 	},
@@ -168,6 +175,7 @@ static bool coda_format_is_yuv(u32 fourcc)
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
 	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_YUV422P:
 		return true;
 	default:
 		return false;
@@ -393,6 +401,11 @@ static int coda_try_fmt(struct coda_ctx *ctx, const struct coda_codec *codec,
 		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
 					f->fmt.pix.height * 3 / 2;
 		break;
+	case V4L2_PIX_FMT_YUV422P:
+		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 16);
+		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
+					f->fmt.pix.height * 2;
+		break;
 	case V4L2_PIX_FMT_H264:
 	case V4L2_PIX_FMT_MPEG4:
 	case V4L2_PIX_FMT_JPEG:
-- 
2.1.0

