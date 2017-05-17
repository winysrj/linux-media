Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:34087 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752849AbdEQRc5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 13:32:57 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/5] [media] sir_ir: use dev managed resources
Date: Wed, 17 May 2017 18:32:51 +0100
Message-Id: <ceb4ec40a0ae19a324b172433623727db3fcbdb7.1495035457.git.sean@mess.org>
In-Reply-To: <cover.1495035457.git.sean@mess.org>
References: <cover.1495035457.git.sean@mess.org>
In-Reply-To: <cover.1495035457.git.sean@mess.org>
References: <cover.1495035457.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several error paths do not free up resources. This simplifies the code
and fixes this.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/sir_ir.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/sir_ir.c b/drivers/media/rc/sir_ir.c
index c27d6b4..1ee41adb 100644
--- a/drivers/media/rc/sir_ir.c
+++ b/drivers/media/rc/sir_ir.c
@@ -334,14 +334,13 @@ static int init_port(void)
 	setup_timer(&timerlist, sir_timeout, 0);
 
 	/* get I/O port access and IRQ line */
-	if (!request_region(io, 8, KBUILD_MODNAME)) {
+	if (!devm_request_region(&sir_ir_dev->dev, io, 8, KBUILD_MODNAME)) {
 		pr_err("i/o port 0x%.4x already in use.\n", io);
 		return -EBUSY;
 	}
-	retval = request_irq(irq, sir_interrupt, 0,
-			     KBUILD_MODNAME, NULL);
+	retval = devm_request_irq(&sir_ir_dev->dev, irq, sir_interrupt, 0,
+				  KBUILD_MODNAME, NULL);
 	if (retval < 0) {
-		release_region(io, 8);
 		pr_err("IRQ %d already in use.\n", irq);
 		return retval;
 	}
@@ -352,9 +351,7 @@ static int init_port(void)
 
 static void drop_port(void)
 {
-	free_irq(irq, NULL);
 	del_timer_sync(&timerlist);
-	release_region(io, 8);
 }
 
 static int init_sir_ir(void)
-- 
2.9.4
