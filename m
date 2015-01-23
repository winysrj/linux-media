Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60811 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbbAWQvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 10/21] [media] coda: clear RET_DEC_PIC_SUCCESS flag in prepare_decode
Date: Fri, 23 Jan 2015 17:51:24 +0100
Message-Id: <1422031895-7740-11-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To make sure a set RET_DEC_PIC_SUCCESS flag is not a leftover from
a previous successful run, clear it in prepare_decode.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 6b00a45..d81635d 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1666,6 +1666,9 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 
 	coda_kfifo_sync_to_device_full(ctx);
 
+	/* Clear decode success flag */
+	coda_write(dev, 0, CODA_RET_DEC_PIC_SUCCESS);
+
 	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
 
 	return 0;
-- 
2.1.4

