Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45148 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbbGJNhr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 09:37:47 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <kamil@wypas.org>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: reset CODA960 hardware after sequence end
Date: Fri, 10 Jul 2015 15:37:44 +0200
Message-Id: <1436535464-3452-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On i.MX6, sometimes after decoding a stream, encoding will produce macroblock
errors caused by missing 8-byte sequences in the output stream. Until the cause
for this is found, reset the hardware after sequence end, which seems to help.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 25910cc..bcb9911 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1347,6 +1347,14 @@ static void coda_seq_end_work(struct work_struct *work)
 			 "CODA_COMMAND_SEQ_END failed\n");
 	}
 
+	/*
+	 * FIXME: Sometimes h.264 encoding fails with 8-byte sequences missing
+	 * from the output stream after the h.264 decoder has run. Resetting the
+	 * hardware after the decoder has finished seems to help.
+	 */
+	if (dev->devtype->product == CODA_960)
+		coda_hw_reset(ctx);
+
 	kfifo_init(&ctx->bitstream_fifo,
 		ctx->bitstream.vaddr, ctx->bitstream.size);
 
-- 
2.1.4

