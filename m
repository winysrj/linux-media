Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44818 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbbGIKKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jul 2015 06:10:35 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <kamil@wypas.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 05/10] [media] coda: avoid calling SEQ_END twice
Date: Thu,  9 Jul 2015 12:10:16 +0200
Message-Id: <1436436621-12291-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1436436621-12291-1-git-send-email-p.zabel@pengutronix.de>
References: <1436436621-12291-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow coda_seq_end_work to be called multiple times, move the setting
of ctx->initialized from coda_start/stop_streaming() into
coda_start_encoding/decoding and coda_seq_end_work, respectively,
and skip the SEQ_END command in coda_seq_end_work if the context is
already deinitialized before.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 8 ++++++++
 drivers/media/platform/coda/coda-common.c | 4 +---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 0f8dcea..ac4dcb1 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -999,6 +999,7 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 		ret = -EFAULT;
 		goto out;
 	}
+	ctx->initialized = 1;
 
 	if (dst_fourcc != V4L2_PIX_FMT_JPEG) {
 		if (dev->devtype->product == CODA_960)
@@ -1329,6 +1330,9 @@ static void coda_seq_end_work(struct work_struct *work)
 	mutex_lock(&ctx->buffer_mutex);
 	mutex_lock(&dev->coda_mutex);
 
+	if (ctx->initialized == 0)
+		goto out;
+
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
 		 "%d: %s: sent command 'SEQ_END' to coda\n", ctx->idx,
 		 __func__);
@@ -1342,6 +1346,9 @@ static void coda_seq_end_work(struct work_struct *work)
 
 	coda_free_framebuffers(ctx);
 
+	ctx->initialized = 0;
+
+out:
 	mutex_unlock(&dev->coda_mutex);
 	mutex_unlock(&ctx->buffer_mutex);
 }
@@ -1499,6 +1506,7 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 		coda_write(dev, 0, CODA_REG_BIT_BIT_STREAM_PARAM);
 		return -ETIMEDOUT;
 	}
+	ctx->initialized = 1;
 
 	/* Update kfifo out pointer from coda bitstream read pointer */
 	coda_kfifo_sync_from_device(ctx);
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 3259ea6..de0e245 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1313,7 +1313,6 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 			goto err;
 	}
 
-	ctx->initialized = 1;
 	return ret;
 
 err:
@@ -1376,7 +1375,6 @@ static void coda_stop_streaming(struct vb2_queue *q)
 		mutex_unlock(&ctx->bitstream_mutex);
 		kfifo_init(&ctx->bitstream_fifo,
 			ctx->bitstream.vaddr, ctx->bitstream.size);
-		ctx->initialized = 0;
 		ctx->runcounter = 0;
 		ctx->aborting = 0;
 	}
@@ -1767,7 +1765,7 @@ static int coda_release(struct file *file)
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 
 	/* In case the instance was not running, we still need to call SEQ_END */
-	if (ctx->initialized && ctx->ops->seq_end_work) {
+	if (ctx->ops->seq_end_work) {
 		queue_work(dev->workqueue, &ctx->seq_end_work);
 		flush_work(&ctx->seq_end_work);
 	}
-- 
2.1.4

