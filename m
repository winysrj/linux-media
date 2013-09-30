Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46377 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab3I3Ne7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 09:34:59 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 06/10] [media] coda: use picture type returned from hardware
Date: Mon, 30 Sep 2013 15:34:49 +0200
Message-Id: <1380548093-22313-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
References: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of copying v4l2_buf.flags from the source buffer, set
the destination buffer flags as reported by the hardware codec.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index e70a272..82049f8 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -2744,7 +2744,6 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 
 	/* Get results from the coda */
-	coda_read(dev, CODA_RET_ENC_PIC_TYPE);
 	start_ptr = coda_read(dev, CODA_CMD_ENC_PIC_BB_START);
 	wr_ptr = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->reg_idx));
 
@@ -2764,7 +2763,7 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 	coda_read(dev, CODA_RET_ENC_PIC_SLICE_NUM);
 	coda_read(dev, CODA_RET_ENC_PIC_FLAG);
 
-	if (src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) {
+	if (coda_read(dev, CODA_RET_ENC_PIC_TYPE) == 0) {
 		dst_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
 		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_PFRAME;
 	} else {
-- 
1.8.4.rc3

