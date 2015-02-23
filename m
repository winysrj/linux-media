Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42767 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbbBWPUU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 10:20:20 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Peter Seiderer <ps.report@gmx.net>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 03/12] [media] coda: free decoder bitstream buffer
Date: Mon, 23 Feb 2015 16:20:04 +0100
Message-Id: <1424704813-20792-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
References: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Seiderer <ps.report@gmx.net>

Fixes resource leak preventing repeatedly decoding.

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 856b542..3801a37 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -36,6 +36,8 @@
 #define CODA_DEFAULT_GAMMA	4096
 #define CODA9_DEFAULT_GAMMA	24576	/* 0.75 * 32768 */
 
+static void coda_free_bitstream_buffer(struct coda_ctx *ctx);
+
 static inline int coda_is_initialized(struct coda_dev *dev)
 {
 	return coda_read(dev, CODA_REG_BIT_CUR_PC) != 0;
@@ -1322,6 +1324,7 @@ static void coda_bit_release(struct coda_ctx *ctx)
 	mutex_lock(&ctx->buffer_mutex);
 	coda_free_framebuffers(ctx);
 	coda_free_context_buffers(ctx);
+	coda_free_bitstream_buffer(ctx);
 	mutex_unlock(&ctx->buffer_mutex);
 }
 
-- 
2.1.4

