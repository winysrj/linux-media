Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47117 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735AbbCYQpY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 12:45:24 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Ian Molton <imolton@ad-holdings.co.uk>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: drop dma_sync_single_for_device in coda_bitstream_queue
Date: Wed, 25 Mar 2015 17:45:09 +0100
Message-Id: <1427301909-17640-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Issuing a cache flush for the whole bitstream buffer is not optimal in the first
place when only a part of it was written. But given that the buffer is mapped in
writecombine mode, it is not needed at all.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index d39789d..d336cb6 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -181,10 +181,6 @@ static int coda_bitstream_queue(struct coda_ctx *ctx,
 	if (n < src_size)
 		return -ENOSPC;
 
-	dma_sync_single_for_device(&ctx->dev->plat_dev->dev,
-				   ctx->bitstream.paddr, ctx->bitstream.size,
-				   DMA_TO_DEVICE);
-
 	src_buf->v4l2_buf.sequence = ctx->qsequence++;
 
 	return 0;
-- 
2.1.4

