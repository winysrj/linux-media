Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38106 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbbL3Qqt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 11:46:49 -0500
Received: by mail-wm0-f44.google.com with SMTP id b14so55520596wmb.1
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 08:46:48 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 06/16] media: rc: nuvoton-cir: fix clearing wake fifo
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <5684090F.9070303@gmail.com>
Date: Wed, 30 Dec 2015 17:40:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At least on NVT6779D clearing the wake fifo works in learning mode only
(although this condition is not mentioned in the chip spec).
Setting the clear fifo bit has no effect in wake up mode.
Even if clearing the wake fifo should work in wake up mode on other
chips this workaround doesn't hurt.
If needed the caller of nvt_clear_cir_wake_fifo has to take care
of locking.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 8ed8011..f624851 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -379,11 +379,19 @@ static void nvt_clear_cir_fifo(struct nvt_dev *nvt)
 /* clear out the hardware's cir wake rx fifo */
 static void nvt_clear_cir_wake_fifo(struct nvt_dev *nvt)
 {
-	u8 val;
+	u8 val, config;
+
+	config = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRCON);
+
+	/* clearing wake fifo works in learning mode only */
+	nvt_cir_wake_reg_write(nvt, config & ~CIR_WAKE_IRCON_MODE0,
+			       CIR_WAKE_IRCON);
 
 	val = nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFOCON);
 	nvt_cir_wake_reg_write(nvt, val | CIR_WAKE_FIFOCON_RXFIFOCLR,
 			       CIR_WAKE_FIFOCON);
+
+	nvt_cir_wake_reg_write(nvt, config, CIR_WAKE_IRCON);
 }
 
 /* clear out the hardware's cir tx fifo */
-- 
2.6.4


