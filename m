Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52211 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbaHERAe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 13:00:34 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 05/15] [media] coda: dequeue buffers if start_streaming fails
Date: Tue,  5 Aug 2014 19:00:10 +0200
Message-Id: <1407258020-12078-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
References: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 34 +++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 86fc527..1e93889 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1005,6 +1005,7 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
 	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
 	struct coda_q_data *q_data_src, *q_data_dst;
+	struct vb2_buffer *buf;
 	u32 dst_fourcc;
 	int ret = 0;
 
@@ -1016,17 +1017,23 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 			coda_fill_bitstream(ctx);
 			mutex_unlock(&ctx->bitstream_mutex);
 
-			if (coda_get_bitstream_payload(ctx) < 512)
-				return -EINVAL;
+			if (coda_get_bitstream_payload(ctx) < 512) {
+				ret = -EINVAL;
+				goto err;
+			}
 		} else {
-			if (count < 1)
-				return -EINVAL;
+			if (count < 1) {
+				ret = -EINVAL;
+				goto err;
+			}
 		}
 
 		ctx->streamon_out = 1;
 	} else {
-		if (count < 1)
-			return -EINVAL;
+		if (count < 1) {
+			ret = -EINVAL;
+			goto err;
+		}
 
 		ctx->streamon_cap = 1;
 	}
@@ -1047,7 +1054,8 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 				     q_data_dst->fourcc);
 	if (!ctx->codec) {
 		v4l2_err(v4l2_dev, "couldn't tell instance type.\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	ret = ctx->ops->start_streaming(ctx);
@@ -1055,11 +1063,21 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		if (ret == -EAGAIN)
 			return 0;
 		else if (ret < 0)
-			return ret;
+			goto err;
 	}
 
 	ctx->initialized = 1;
 	return ret;
+
+err:
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		while ((buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
+			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_DEQUEUED);
+	} else {
+		while ((buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx)))
+			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_DEQUEUED);
+	}
+	return ret;
 }
 
 static void coda_stop_streaming(struct vb2_queue *q)
-- 
2.0.1

