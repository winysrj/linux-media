Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46387 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab3I3NfA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 09:35:00 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 02/10] [media] coda: only set buffered input queue for decoder
Date: Mon, 30 Sep 2013 15:34:45 +0200
Message-Id: <1380548093-22313-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
References: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 2805538..945c539 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1928,8 +1928,9 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (!(ctx->streamon_out & ctx->streamon_cap))
 		return 0;
 
-	/* Allow device_run with no buffers queued and after streamoff */
-	v4l2_m2m_set_src_buffered(ctx->m2m_ctx, true);
+	/* Allow decoder device_run with no new buffers queued */
+	if (ctx->inst_type == CODA_INST_DECODER)
+		v4l2_m2m_set_src_buffered(ctx->m2m_ctx, true);
 
 	ctx->gopcounter = ctx->params.gop_size - 1;
 	buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
-- 
1.8.4.rc3

