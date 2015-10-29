Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:33796 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531AbbJ2VXn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 17:23:43 -0400
Received: by wmff134 with SMTP id f134so32384368wmf.1
        for <linux-media@vger.kernel.org>; Thu, 29 Oct 2015 14:23:42 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 7/9] media: rc: nuvoton-cir: simplify debug code
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56328E21.3080006@gmail.com>
Date: Thu, 29 Oct 2015 22:22:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of explicitely checking debug use nvt_dbg like in other parts
of the driver thus simplifying the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index ff874fc..ee1b14e 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -716,7 +716,7 @@ static void nvt_get_rx_ir_data(struct nvt_dev *nvt)
 
 static void nvt_cir_log_irqs(u8 status, u8 iren)
 {
-	nvt_pr(KERN_INFO, "IRQ 0x%02x (IREN 0x%02x) :%s%s%s%s%s%s%s%s%s",
+	nvt_dbg("IRQ 0x%02x (IREN 0x%02x) :%s%s%s%s%s%s%s%s%s",
 		status, iren,
 		status & CIR_IRSTS_RDR	? " RDR"	: "",
 		status & CIR_IRSTS_RTR	? " RTR"	: "",
@@ -790,8 +790,7 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 		return IRQ_NONE;
 	}
 
-	if (debug)
-		nvt_cir_log_irqs(status, iren);
+	nvt_cir_log_irqs(status, iren);
 
 	if (status & CIR_IRSTS_RTR) {
 		/* FIXME: add code for study/learn mode */
-- 
2.6.2


