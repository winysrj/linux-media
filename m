Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60824 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667AbbAWQvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:40 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 18/21] [media] coda: free context buffers under buffer mutex
Date: Fri, 23 Jan 2015 17:51:32 +0100
Message-Id: <1422031895-7740-19-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure the buffer_mutex lock is taken in coda_bit_release
while coda_free_framebuffers and coda_free_context_buffers
are called.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 7cdddd5..856b542 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1319,8 +1319,10 @@ static void coda_seq_end_work(struct work_struct *work)
 
 static void coda_bit_release(struct coda_ctx *ctx)
 {
+	mutex_lock(&ctx->buffer_mutex);
 	coda_free_framebuffers(ctx);
 	coda_free_context_buffers(ctx);
+	mutex_unlock(&ctx->buffer_mutex);
 }
 
 const struct coda_context_ops coda_bit_encode_ops = {
-- 
2.1.4

