Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35546 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161313Ab3FUHzk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 03:55:40 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?q?Ga=C3=ABtan=20Carlier?= <gcembed@gmail.com>,
	Wei Yongjun <weiyj.lk@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 1/8] [media] coda: use vb2_set_plane_payload instead of setting v4l2_planes[0].bytesused directly
Date: Fri, 21 Jun 2013 09:55:27 +0200
Message-Id: <1371801334-22324-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1371801334-22324-1-git-send-email-p.zabel@pengutronix.de>
References: <1371801334-22324-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index c4566c4..90f3386 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1662,12 +1662,12 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 	wr_ptr = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx));
 	/* Calculate bytesused field */
 	if (dst_buf->v4l2_buf.sequence == 0) {
-		dst_buf->v4l2_planes[0].bytesused = (wr_ptr - start_ptr) +
-						ctx->vpu_header_size[0] +
-						ctx->vpu_header_size[1] +
-						ctx->vpu_header_size[2];
+		vb2_set_plane_payload(dst_buf, 0, wr_ptr - start_ptr +
+					ctx->vpu_header_size[0] +
+					ctx->vpu_header_size[1] +
+					ctx->vpu_header_size[2]);
 	} else {
-		dst_buf->v4l2_planes[0].bytesused = (wr_ptr - start_ptr);
+		vb2_set_plane_payload(dst_buf, 0, wr_ptr - start_ptr);
 	}
 
 	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "frame size = %u\n",
-- 
1.8.3.1

