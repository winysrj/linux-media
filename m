Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36529 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbbGIKKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jul 2015 06:10:35 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <kamil@wypas.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 02/10] [media] coda: fix mvcol buffer for MPEG4 decoding
Date: Thu,  9 Jul 2015 12:10:13 +0200
Message-Id: <1436436621-12291-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1436436621-12291-1-git-send-email-p.zabel@pengutronix.de>
References: <1436436621-12291-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mvcol buffer is allocated at the end of the first internal buffer.
This patch fixes an out of bounds array access.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 9fbff24..47fc2f1 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -384,7 +384,7 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 	/* mvcol buffer for mpeg4 */
 	if ((dev->devtype->product != CODA_DX6) &&
 	    (ctx->codec->src_fourcc == V4L2_PIX_FMT_MPEG4))
-		coda_parabuf_write(ctx, 97, ctx->internal_frames[i].paddr +
+		coda_parabuf_write(ctx, 97, ctx->internal_frames[0].paddr +
 					    ysize + ysize/4 + ysize/4);
 
 	return 0;
-- 
2.1.4

