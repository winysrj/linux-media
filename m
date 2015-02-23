Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42787 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbbBWPUY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 10:20:24 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Peter Seiderer <ps.report@gmx.net>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 10/12] [media] coda: fail to start streaming if userspace set invalid formats
Date: Mon, 23 Feb 2015 16:20:11 +0100
Message-Id: <1424704813-20792-11-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
References: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index b42ccfc..4441179 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1282,12 +1282,23 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (!(ctx->streamon_out & ctx->streamon_cap))
 		return 0;
 
+	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	if ((q_data_src->width != q_data_dst->width &&
+	     round_up(q_data_src->width, 16) != q_data_dst->width) ||
+	    (q_data_src->height != q_data_dst->height &&
+	     round_up(q_data_src->height, 16) != q_data_dst->height)) {
+		v4l2_err(v4l2_dev, "can't convert %dx%d to %dx%d\n",
+			 q_data_src->width, q_data_src->height,
+			 q_data_dst->width, q_data_dst->height);
+		ret = -EINVAL;
+		goto err;
+	}
+
 	/* Allow BIT decoder device_run with no new buffers queued */
 	if (ctx->inst_type == CODA_INST_DECODER && ctx->use_bit)
 		v4l2_m2m_set_src_buffered(ctx->fh.m2m_ctx, true);
 
 	ctx->gopcounter = ctx->params.gop_size - 1;
-	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 
 	ctx->codec = coda_find_codec(ctx->dev, q_data_src->fourcc,
 				     q_data_dst->fourcc);
-- 
2.1.4

