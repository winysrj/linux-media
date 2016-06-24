Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33720 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbcFXFkU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 01:40:20 -0400
Received: by mail-wm0-f66.google.com with SMTP id r201so2202631wme.0
        for <linux-media@vger.kernel.org>; Thu, 23 Jun 2016 22:40:19 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 2/9] media: rc: nuvoton: clean up initialization of wakeup
 registers
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <4bc6b760-553d-5687-f71e-2f7b331818ec@gmail.com>
Date: Fri, 24 Jun 2016 07:39:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The registers defining wakeup sequence handling are set when the
wakeup sequence is set via sysfs. There's no need to initialize them
otherwise.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index b32f3bf..c8999cc 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -564,34 +564,15 @@ static void nvt_cir_regs_init(struct nvt_dev *nvt)
 
 static void nvt_cir_wake_regs_init(struct nvt_dev *nvt)
 {
-	/* set number of bytes needed for wake from s3 (default 65) */
-	nvt_cir_wake_reg_write(nvt, CIR_WAKE_FIFO_CMP_BYTES,
-			       CIR_WAKE_FIFO_CMP_DEEP);
-
-	/* set tolerance/variance allowed per byte during wake compare */
-	nvt_cir_wake_reg_write(nvt, CIR_WAKE_CMP_TOLERANCE,
-			       CIR_WAKE_FIFO_CMP_TOL);
-
-	/* set sample limit count (PE interrupt raised when reached) */
-	nvt_cir_wake_reg_write(nvt, CIR_RX_LIMIT_COUNT >> 8, CIR_WAKE_SLCH);
-	nvt_cir_wake_reg_write(nvt, CIR_RX_LIMIT_COUNT & 0xff, CIR_WAKE_SLCL);
-
-	/* set cir wake fifo rx trigger level (currently 67) */
-	nvt_cir_wake_reg_write(nvt, CIR_WAKE_FIFOCON_RX_TRIGGER_LEV,
-			       CIR_WAKE_FIFOCON);
-
 	/*
-	 * Enable TX and RX, specific carrier on = low, off = high, and set
-	 * sample period (currently 50us)
+	 * Disable RX, set specific carrier on = low, off = high,
+	 * and sample period (currently 50us)
 	 */
-	nvt_cir_wake_reg_write(nvt, CIR_WAKE_IRCON_MODE0 | CIR_WAKE_IRCON_RXEN |
+	nvt_cir_wake_reg_write(nvt, CIR_WAKE_IRCON_MODE0 |
 			       CIR_WAKE_IRCON_R | CIR_WAKE_IRCON_RXINV |
 			       CIR_WAKE_IRCON_SAMPLE_PERIOD_SEL,
 			       CIR_WAKE_IRCON);
 
-	/* clear cir wake rx fifo */
-	nvt_clear_cir_wake_fifo(nvt);
-
 	/* clear any and all stray interrupts */
 	nvt_cir_wake_reg_write(nvt, 0xff, CIR_WAKE_IRSTS);
 
-- 
2.9.0

