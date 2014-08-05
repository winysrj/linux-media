Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52236 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933AbaHERAm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 13:00:42 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 06/15] [media] coda: dequeue buffers on streamoff
Date: Tue,  5 Aug 2014 19:00:11 +0200
Message-Id: <1407258020-12078-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
References: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is needed to decrease the q->owned_by_drv_count to zero before
__vb2_queue_cancel is called, to avoid the WARN_ON therein.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 1e93889..6760e34 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1084,6 +1084,7 @@ static void coda_stop_streaming(struct vb2_queue *q)
 {
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
 	struct coda_dev *dev = ctx->dev;
+	struct vb2_buffer *buf;
 
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
@@ -1091,7 +1092,11 @@ static void coda_stop_streaming(struct vb2_queue *q)
 		ctx->streamon_out = 0;
 
 		coda_bit_stream_end_flag(ctx);
+
 		ctx->isequence = 0;
+
+		while ((buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
+			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_ERROR);
 	} else {
 		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
 			 "%s: capture\n", __func__);
@@ -1099,6 +1104,9 @@ static void coda_stop_streaming(struct vb2_queue *q)
 
 		ctx->osequence = 0;
 		ctx->sequence_offset = 0;
+
+		while ((buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx)))
+			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_ERROR);
 	}
 
 	if (!ctx->streamon_out && !ctx->streamon_cap) {
-- 
2.0.1

