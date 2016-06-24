Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33777 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbcFXFk0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 01:40:26 -0400
Received: by mail-wm0-f66.google.com with SMTP id r201so2203001wme.0
        for <linux-media@vger.kernel.org>; Thu, 23 Jun 2016 22:40:25 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 7/9] media: rc: nuvoton: simplify interrupt handling code
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <0dc7ab35-7fef-b1df-8890-a204077b3683@gmail.com>
Date: Fri, 24 Jun 2016 07:39:51 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify interupt handling code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 5ce0238..180f589 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -906,17 +906,12 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 	if (status & CIR_IRSTS_RFO)
 		nvt_handle_rx_fifo_overrun(nvt);
 
-	if (status & CIR_IRSTS_RTR) {
+	else if (status & (CIR_IRSTS_RTR | CIR_IRSTS_PE)) {
 		/* We only do rx if not tx'ing */
 		if (nvt_cir_tx_inactive(nvt))
 			nvt_get_rx_ir_data(nvt);
 	}
 
-	if (status & CIR_IRSTS_PE) {
-		if (nvt_cir_tx_inactive(nvt))
-			nvt_get_rx_ir_data(nvt);
-	}
-
 	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 
 	if (status & CIR_IRSTS_TE)
-- 
2.9.0

