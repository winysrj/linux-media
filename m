Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40077 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaI2MyQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 08:54:16 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/6] [media] coda: clear aborting flag in stop_streaming
Date: Mon, 29 Sep 2014 14:53:42 +0200
Message-Id: <1411995227-3623-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1411995227-3623-1-git-send-email-p.zabel@pengutronix.de>
References: <1411995227-3623-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clearing the aborting flag in stop_streaming is necessary if we want to start
streaming again without having to closing and reopening the device. Also,
do not explicitly set it in default_params; the context is zeroed by
kzalloc anyway.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index ced4760..3f8a04f 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -880,7 +880,6 @@ static void set_default_params(struct coda_ctx *ctx)
 	ctx->params.codec_mode = ctx->codec->mode;
 	ctx->colorspace = V4L2_COLORSPACE_REC709;
 	ctx->params.framerate = 30;
-	ctx->aborting = 0;
 
 	/* Default formats for output and input queues */
 	ctx->q_data[V4L2_M2M_SRC].fourcc = ctx->codec->src_fourcc;
@@ -1144,6 +1143,7 @@ static void coda_stop_streaming(struct vb2_queue *q)
 		kfifo_init(&ctx->bitstream_fifo,
 			ctx->bitstream.vaddr, ctx->bitstream.size);
 		ctx->runcounter = 0;
+		ctx->aborting = 0;
 	}
 }
 
-- 
2.1.0

