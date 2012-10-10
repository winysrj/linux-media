Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42014 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab2JJDdq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 23:33:46 -0400
Received: by mail-gg0-f174.google.com with SMTP id k5so17093ggd.19
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2012 20:33:45 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: mchehab@infradead.org
Cc: javier.martin@vista-silicon.com, linux-media@vger.kernel.org,
	tj@kernel.org, kernel@pengutronix.de,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] [media] coda: Do not use __cancel_delayed_work()
Date: Wed, 10 Oct 2012 00:33:29 -0300
Message-Id: <1349840009-14014-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 136b5721d (workqueue: deprecate __cancel_delayed_work()) made 
__cancel_delayed_work deprecated. Use cancel_delayed_work instead and get rid of
the following warning: 

drivers/media/platform/coda.c:1543: warning: '__cancel_delayed_work' is deprecated (declared at include/linux/workqueue.h:437)

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/platform/coda.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index cd04ae2..7640505 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1540,7 +1540,7 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 	u32 wr_ptr, start_ptr;
 	struct coda_ctx *ctx;
 
-	__cancel_delayed_work(&dev->timeout);
+	cancel_delayed_work(&dev->timeout);
 
 	/* read status register to attend the IRQ */
 	coda_read(dev, CODA_REG_BIT_INT_STATUS);
-- 
1.7.9.5

