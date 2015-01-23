Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60801 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbbAWQvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>
Subject: [PATCH 05/21] [media] coda: adjust sequence offset after unexpected decoded frame
Date: Fri, 23 Jan 2015 17:51:19 +0100
Message-Id: <1422031895-7740-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lucas Stach <l.stach@pengutronix.de>

If userspace doesn't properly separate the bitstream input into
individual frames (which may happen for example on slightly
corrupted streams) the CODA hardware may decode more frames
than we expect. We already log an error in this case, but it's
also necessary to adjust the sequence offset. Otherwise we
spam the log with a sequence number mismatch on every frame
frame after the unexpected one.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index f6cf337..6b00a45 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1822,6 +1822,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 			memset(&ctx->frame_metas[decoded_idx], 0,
 			       sizeof(struct coda_buffer_meta));
 			ctx->frame_metas[decoded_idx].sequence = val;
+			ctx->sequence_offset++;
 		}
 		mutex_unlock(&ctx->bitstream_mutex);
 
-- 
2.1.4

