Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42951 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3FQO7Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 10:59:24 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?q?Ga=C3=ABtan=20Carlier?= <gcembed@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 3/8] [media] coda: do not allocate maximum number of framebuffers for encoder
Date: Mon, 17 Jun 2013 16:59:14 +0200
Message-Id: <1371481159-27412-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1371481159-27412-1-git-send-email-p.zabel@pengutronix.de>
References: <1371481159-27412-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The encoder only ever needs two buffers, but we'll have to increase
CODA_MAX_FRAMEBUFFERS for the decoder.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index baf0ce8..6d76f1d 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -997,7 +997,6 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx, struct coda_q_data *q_d
 	ysize = round_up(q_data->width, 8) * height;
 
 	/* Allocate frame buffers */
-	ctx->num_internal_frames = CODA_MAX_FRAMEBUFFERS;
 	for (i = 0; i < ctx->num_internal_frames; i++) {
 		ctx->internal_frames[i].size = q_data->sizeimage;
 		if (fourcc == V4L2_PIX_FMT_H264 && dev->devtype->product != CODA_DX6)
@@ -1347,6 +1346,7 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		goto out;
 	}
 
+	ctx->num_internal_frames = 2;
 	ret = coda_alloc_framebuffers(ctx, q_data_src, dst_fourcc);
 	if (ret < 0) {
 		v4l2_err(v4l2_dev, "failed to allocate framebuffers\n");
-- 
1.8.3.1

