Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60816 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbbAWQvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 13/21] [media] coda: issue seq_end_work during stop_streaming
Date: Fri, 23 Jan 2015 17:51:27 +0100
Message-Id: <1422031895-7740-14-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch queues seq_end_work and flushes the queue during stop_streaming
and clears the ctx->initialized flag. This allows to start streaming again
after stopping streaming without releasing the context.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 611d737..6ea7e0a 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1323,6 +1323,10 @@ static void coda_stop_streaming(struct vb2_queue *q)
 	if (!ctx->streamon_out && !ctx->streamon_cap) {
 		struct coda_buffer_meta *meta;
 
+		if (ctx->ops->seq_end_work) {
+			queue_work(dev->workqueue, &ctx->seq_end_work);
+			flush_work(&ctx->seq_end_work);
+		}
 		mutex_lock(&ctx->bitstream_mutex);
 		while (!list_empty(&ctx->buffer_meta_list)) {
 			meta = list_first_entry(&ctx->buffer_meta_list,
@@ -1333,6 +1337,7 @@ static void coda_stop_streaming(struct vb2_queue *q)
 		mutex_unlock(&ctx->bitstream_mutex);
 		kfifo_init(&ctx->bitstream_fifo,
 			ctx->bitstream.vaddr, ctx->bitstream.size);
+		ctx->initialized = 0;
 		ctx->runcounter = 0;
 		ctx->aborting = 0;
 	}
-- 
2.1.4

