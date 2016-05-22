Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32985 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbcEVNnu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2016 09:43:50 -0400
Received: by mail-wm0-f65.google.com with SMTP id 67so8282714wmg.0
        for <linux-media@vger.kernel.org>; Sun, 22 May 2016 06:43:49 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] media: rc: nuvoton: fix rx fifo overrun handling
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <313c796c-6d51-5ff3-f7aa-806fd54c9b02@gmail.com>
Date: Sun, 22 May 2016 15:43:40 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To detect a rx fifo overrun it's checked whether the number of elements
in the chip fifo exceeds the fifo size. This check can never return true
and is wrong.
Instead we should generate an interrupt if the fifo overruns.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 028574b..74a8de2 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -525,7 +525,7 @@ static void nvt_set_cir_iren(struct nvt_dev *nvt)
 {
 	u8 iren;
 
-	iren = CIR_IREN_RTR | CIR_IREN_PE;
+	iren = CIR_IREN_RTR | CIR_IREN_PE | CIR_IREN_RFO;
 	nvt_cir_reg_write(nvt, iren, CIR_IREN);
 }
 
@@ -833,7 +833,6 @@ static void nvt_get_rx_ir_data(struct nvt_dev *nvt)
 {
 	u8 fifocount, val;
 	unsigned int b_idx;
-	bool overrun = false;
 	int i;
 
 	/* Get count of how many bytes to read from RX FIFO */
@@ -841,11 +840,6 @@ static void nvt_get_rx_ir_data(struct nvt_dev *nvt)
 	/* if we get 0xff, probably means the logical dev is disabled */
 	if (fifocount == 0xff)
 		return;
-	/* watch out for a fifo overrun condition */
-	else if (fifocount > RX_BUF_LEN) {
-		overrun = true;
-		fifocount = RX_BUF_LEN;
-	}
 
 	nvt_dbg("attempting to fetch %u bytes from hw rx fifo", fifocount);
 
@@ -867,9 +861,6 @@ static void nvt_get_rx_ir_data(struct nvt_dev *nvt)
 	nvt_dbg("%s: pkts now %d", __func__, nvt->pkts);
 
 	nvt_process_rx_ir_data(nvt);
-
-	if (overrun)
-		nvt_handle_rx_fifo_overrun(nvt);
 }
 
 static void nvt_cir_log_irqs(u8 status, u8 iren)
@@ -943,6 +934,9 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 
 	nvt_cir_log_irqs(status, iren);
 
+	if (status & CIR_IRSTS_RFO)
+		nvt_handle_rx_fifo_overrun(nvt);
+
 	if (status & CIR_IRSTS_RTR) {
 		/* FIXME: add code for study/learn mode */
 		/* We only do rx if not tx'ing */
-- 
2.8.2

