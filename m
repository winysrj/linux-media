Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60840 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbbAWQvr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:47 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 20/21] [media] coda: allocate bitstream ringbuffer only for BIT decoder
Date: Fri, 23 Jan 2015 17:51:34 +0100
Message-Id: <1422031895-7740-21-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The BIT encoder does not use a per-context bitstream ringbuffer as it encodes
directly into the videobuf2 capture queue's buffers. Avoid allocation of the
bitstream ringbuffer for encoder contexts.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 2defa4b..c19f4b7 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1689,7 +1689,8 @@ static int coda_open(struct file *file)
 			v4l2_err(&dev->v4l2_dev, "failed to allocate parabuf");
 			goto err_dma_alloc;
 		}
-
+	}
+	if (ctx->use_bit && ctx->inst_type == CODA_INST_DECODER) {
 		ctx->bitstream.size = CODA_MAX_FRAME_SIZE;
 		ctx->bitstream.vaddr = dma_alloc_writecombine(
 				&dev->plat_dev->dev, ctx->bitstream.size,
-- 
2.1.4

