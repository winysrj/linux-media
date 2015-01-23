Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60814 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbbAWQvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 12/21] [media] coda: remove unused isequence, reset qsequence in stop_streaming
Date: Fri, 23 Jan 2015 17:51:26 +0100
Message-Id: <1422031895-7740-13-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The isequence counter is never used, qsequence counts the buffers queued into
the bit decoder bitstream ringbuffer. It needs to be reset in stop_streaming.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 2 +-
 drivers/media/platform/coda/coda.h        | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 5386b2c..611d737 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1304,7 +1304,7 @@ static void coda_stop_streaming(struct vb2_queue *q)
 
 		coda_bit_stream_end_flag(ctx);
 
-		ctx->isequence = 0;
+		ctx->qsequence = 0;
 
 		while ((buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
 			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_ERROR);
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 5dd47e5..2ddfe51 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -198,7 +198,6 @@ struct coda_ctx {
 	int				initialized;
 	int				streamon_out;
 	int				streamon_cap;
-	u32				isequence;
 	u32				qsequence;
 	u32				osequence;
 	u32				sequence_offset;
-- 
2.1.4

