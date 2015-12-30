Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36231 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbbL3QrA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 11:47:00 -0500
Received: by mail-wm0-f46.google.com with SMTP id l65so64883831wmf.1
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 08:46:59 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 15/16] media: rc: nuvoton-cir: fix interrupt handling
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56840A3F.7030102@gmail.com>
Date: Wed, 30 Dec 2015 17:45:51 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only handle an interrupt if at least one combination of event bit
and related interrupt bit is set.
Previously it was just checked that at least one event bit and
at least one interrupt bit are set.

This fixes issues like the following which was caused by
interrupt sharing:
An interrupt intended for nvt_cir_isr was handled by nvt_cir_wake_isr
first and because status bit CIR_WAKE_IRSTS_IR_PENDING was set
the wake fifo was accidently cleared.

This patch also fixes the bug that nvt_cir_wake_isr returned IRQ_HANDLED
even if it detected that the (shared) interrupt was meant for another
handler.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index c3294fb..c0bee1e 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -825,9 +825,13 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 	 *   0: CIR_IRSTS_GH  - Min Length Detected
 	 */
 	status = nvt_cir_reg_read(nvt, CIR_IRSTS);
-	if (!status) {
+	iren = nvt_cir_reg_read(nvt, CIR_IREN);
+
+	/* IRQ may be shared with CIR WAKE, therefore check for each
+	 * status bit whether the related interrupt source is enabled
+	 */
+	if (!(status & iren)) {
 		nvt_dbg_verbose("%s exiting, IRSTS 0x0", __func__);
-		nvt_cir_reg_write(nvt, 0xff, CIR_IRSTS);
 		return IRQ_NONE;
 	}
 
@@ -835,13 +839,6 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 	nvt_cir_reg_write(nvt, status, CIR_IRSTS);
 	nvt_cir_reg_write(nvt, 0, CIR_IRSTS);
 
-	/* Interrupt may be shared with CIR Wake, bail if CIR not enabled */
-	iren = nvt_cir_reg_read(nvt, CIR_IREN);
-	if (!iren) {
-		nvt_dbg_verbose("%s exiting, CIR not enabled", __func__);
-		return IRQ_NONE;
-	}
-
 	nvt_cir_log_irqs(status, iren);
 
 	if (status & CIR_IRSTS_RTR) {
@@ -914,7 +911,12 @@ static irqreturn_t nvt_cir_wake_isr(int irq, void *data)
 	nvt_dbg_wake("%s firing", __func__);
 
 	status = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRSTS);
-	if (!status)
+	iren = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IREN);
+
+	/* IRQ may be shared with CIR, therefore check for each
+	 * status bit whether the related interrupt source is enabled
+	 */
+	if (!(status & iren))
 		return IRQ_NONE;
 
 	if (status & CIR_WAKE_IRSTS_IR_PENDING)
@@ -923,13 +925,6 @@ static irqreturn_t nvt_cir_wake_isr(int irq, void *data)
 	nvt_cir_wake_reg_write(nvt, status, CIR_WAKE_IRSTS);
 	nvt_cir_wake_reg_write(nvt, 0, CIR_WAKE_IRSTS);
 
-	/* Interrupt may be shared with CIR, bail if Wake not enabled */
-	iren = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IREN);
-	if (!iren) {
-		nvt_dbg_wake("%s exiting, wake not enabled", __func__);
-		return IRQ_HANDLED;
-	}
-
 	if ((status & CIR_WAKE_IRSTS_PE) &&
 	    (nvt->wake_state == ST_WAKE_START)) {
 		while (nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY_IDX)) {
-- 
2.6.4


