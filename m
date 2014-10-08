Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49387 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaJHQJR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 12:09:17 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: set bitstream end flag in coda_release
Date: Wed,  8 Oct 2014 18:09:11 +0200
Message-Id: <1412784551-11904-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This should fix CODA crashes due to timeouts when stopping
the decoding process with SIGINT.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 151e45b..ffb9944 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1695,6 +1695,9 @@ static int coda_release(struct file *file)
 
 	debugfs_remove_recursive(ctx->debugfs_entry);
 
+	if (ctx->inst_type == CODA_INST_DECODER)
+		coda_bit_stream_end_flag(ctx);
+
 	/* If this instance is running, call .job_abort and wait for it to end */
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 
-- 
2.1.0

