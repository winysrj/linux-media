Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57708 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbaFXO4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 10:56:31 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 04/29] [media] coda: fix internal framebuffer allocation size
Date: Tue, 24 Jun 2014 16:55:46 +0200
Message-Id: <1403621771-11636-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This error was introduced by 5677e3b04d3b3961200aa2bb9cc715e709eafeb9
"[media] coda: update CODA7541 to firmware 1.4.50".

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 10e1d98..e3dddcb 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1527,10 +1527,10 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx, struct coda_q_data *q_d
 	for (i = 0; i < ctx->num_internal_frames; i++) {
 		size_t size;
 
-		size = q_data->sizeimage;
+		size = ysize + ysize / 2;
 		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 &&
 		    dev->devtype->product != CODA_DX6)
-			ctx->internal_frames[i].size += ysize/4;
+			size += ysize / 4;
 		ret = coda_alloc_context_buf(ctx, &ctx->internal_frames[i], size);
 		if (ret < 0) {
 			coda_free_framebuffers(ctx);
-- 
2.0.0

