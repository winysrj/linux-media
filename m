Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57669 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaFXO43 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 10:56:29 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 23/29] [media] coda: use prescan_failed variable to stop stream after a timeout
Date: Tue, 24 Jun 2014 16:56:05 +0200
Message-Id: <1403621771-11636-24-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This variable should be renamed to hold instead (temporarily stopping streaming
until new data is fed into the bitstream buffer).

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 4548c84..cded081 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1423,6 +1423,8 @@ static void coda_pic_run_work(struct work_struct *work)
 
 	if (!wait_for_completion_timeout(&ctx->completion, msecs_to_jiffies(1000))) {
 		dev_err(&dev->plat_dev->dev, "CODA PIC_RUN timeout\n");
+
+		ctx->prescan_failed = true;
 	} else if (!ctx->aborting) {
 		if (ctx->inst_type == CODA_INST_DECODER)
 			coda_finish_decode(ctx);
-- 
2.0.0

