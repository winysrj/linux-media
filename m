Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:40555 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbcJYTYN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Oct 2016 15:24:13 -0400
Received: by mail-wm0-f66.google.com with SMTP id b80so1900814wme.7
        for <linux-media@vger.kernel.org>; Tue, 25 Oct 2016 12:24:13 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 1/5] media: rc: nuvoton: remove nvt_open and nvt_close
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <07318f26-3d54-d01e-c5eb-880acc0e04a4@gmail.com>
Date: Tue, 25 Oct 2016 21:23:16 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

What is done in nvt_probe was done in nvt_probe already
(in nvt_cir_ldev_init and nvt_cir_regs_init, both called from
nvt_probe). It's the same with nvt_close, it's covered by nvt_remove.
Therefore I don't see any benefit in implementing the open and close
hooks at all and both functions can be removed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 3df3bd9..37fce7b 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -964,39 +964,6 @@ static void nvt_disable_cir(struct nvt_dev *nvt)
 	nvt_disable_logical_dev(nvt, LOGICAL_DEV_CIR);
 }
 
-static int nvt_open(struct rc_dev *dev)
-{
-	struct nvt_dev *nvt = dev->priv;
-	unsigned long flags;
-
-	spin_lock_irqsave(&nvt->nvt_lock, flags);
-
-	/* set function enable flags */
-	nvt_cir_reg_write(nvt, CIR_IRCON_TXEN | CIR_IRCON_RXEN |
-			  CIR_IRCON_RXINV | CIR_IRCON_SAMPLE_PERIOD_SEL,
-			  CIR_IRCON);
-
-	/* clear all pending interrupts */
-	nvt_cir_reg_write(nvt, 0xff, CIR_IRSTS);
-
-	/* enable interrupts */
-	nvt_set_cir_iren(nvt);
-
-	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
-
-	/* enable the CIR logical device */
-	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR);
-
-	return 0;
-}
-
-static void nvt_close(struct rc_dev *dev)
-{
-	struct nvt_dev *nvt = dev->priv;
-
-	nvt_disable_cir(nvt);
-}
-
 /* Allocate memory, probe hardware, and initialize everything */
 static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 {
@@ -1075,8 +1042,6 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	rdev->priv = nvt;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
 	rdev->allowed_protocols = RC_BIT_ALL;
-	rdev->open = nvt_open;
-	rdev->close = nvt_close;
 	rdev->tx_ir = nvt_tx_ir;
 	rdev->s_tx_carrier = nvt_set_tx_carrier;
 	rdev->input_name = "Nuvoton w836x7hg Infrared Remote Transceiver";
-- 
2.10.1

