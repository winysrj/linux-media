Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34912 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbcGaQAa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2016 12:00:30 -0400
Received: by mail-wm0-f67.google.com with SMTP id i5so22830568wmg.2
        for <linux-media@vger.kernel.org>; Sun, 31 Jul 2016 08:59:52 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] media: rc: nuvoton: ignore spurious interrupt when logical
 device is being disabled
Message-ID: <81921cc3-2b49-7c0b-68dd-d3af0cc7dae6@gmail.com>
Date: Sun, 31 Jul 2016 15:42:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When removing module nuvoton-cir I get a fifo overrun warning.
It turned out to be caused by a spurious interrupt when the logical CIR
device is being disabled (although no interrupt source bit being set).
Reading the interrupt status register returns 0xff, therefore the fifo
overrun bit is mistakenly interpreted as being set.

Fix this by ignoring interrupts when interrupt source and status register
reads return 0xff.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 00215f3..0c69536 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -886,6 +886,15 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 	status = nvt_cir_reg_read(nvt, CIR_IRSTS);
 	iren = nvt_cir_reg_read(nvt, CIR_IREN);
 
+	/* At least NCT6779D creates a spurious interrupt when the
+	 * logical device is being disabled.
+	 */
+	if (status == 0xff && iren == 0xff) {
+		spin_unlock_irqrestore(&nvt->nvt_lock, flags);
+		nvt_dbg_verbose("Spurious interrupt detected");
+		return IRQ_HANDLED;
+	}
+
 	/* IRQ may be shared with CIR WAKE, therefore check for each
 	 * status bit whether the related interrupt source is enabled
 	 */
-- 
2.9.0

