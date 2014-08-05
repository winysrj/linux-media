Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52177 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbaHERA0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 13:00:26 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 11/15] [media] coda: improve allocation error messages
Date: Tue,  5 Aug 2014 19:00:16 +0200
Message-Id: <1407258020-12078-12-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
References: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Produce some error messages when internal buffer allocation
fails, for example because the CMA region is too small.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 4 +++-
 drivers/media/platform/coda/coda-common.c | 6 +++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index fddd10d..529cc3e 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1378,8 +1378,10 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	}
 
 	ret = coda_alloc_framebuffers(ctx, q_data_dst, src_fourcc);
-	if (ret < 0)
+	if (ret < 0) {
+		v4l2_err(&dev->v4l2_dev, "failed to allocate framebuffers\n");
 		return ret;
+	}
 
 	/* Tell the decoder how many frame buffers we allocated. */
 	coda_write(dev, ctx->num_internal_frames, CODA_CMD_SET_FRAME_BUF_NUM);
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 7311452..0f8a2c9 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -971,8 +971,12 @@ int coda_alloc_aux_buf(struct coda_dev *dev, struct coda_aux_buf *buf,
 {
 	buf->vaddr = dma_alloc_coherent(&dev->plat_dev->dev, size, &buf->paddr,
 					GFP_KERNEL);
-	if (!buf->vaddr)
+	if (!buf->vaddr) {
+		v4l2_err(&dev->v4l2_dev,
+			 "Failed to allocate %s buffer of size %u\n",
+			 name, size);
 		return -ENOMEM;
+	}
 
 	buf->size = size;
 
-- 
2.0.1

