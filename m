Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33947 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbcFXFkZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 01:40:25 -0400
Received: by mail-wm0-f65.google.com with SMTP id 187so2192884wmz.1
        for <linux-media@vger.kernel.org>; Thu, 23 Jun 2016 22:40:24 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 6/9] media: rc: nuvoton: remove study states
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <8f71f415-d36e-b138-35f8-3b2a135194dd@gmail.com>
Date: Fri, 24 Jun 2016 07:39:45 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Study states have never been used and are not needed. Remove them.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 11 +----------
 drivers/media/rc/nuvoton-cir.h | 13 -------------
 2 files changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 9d9717d..5ce0238 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -865,7 +865,7 @@ static bool nvt_cir_tx_inactive(struct nvt_dev *nvt)
 static irqreturn_t nvt_cir_isr(int irq, void *data)
 {
 	struct nvt_dev *nvt = data;
-	u8 status, iren, cur_state;
+	u8 status, iren;
 	unsigned long flags;
 
 	nvt_dbg_verbose("%s firing", __func__);
@@ -907,7 +907,6 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 		nvt_handle_rx_fifo_overrun(nvt);
 
 	if (status & CIR_IRSTS_RTR) {
-		/* FIXME: add code for study/learn mode */
 		/* We only do rx if not tx'ing */
 		if (nvt_cir_tx_inactive(nvt))
 			nvt_get_rx_ir_data(nvt);
@@ -916,11 +915,6 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 	if (status & CIR_IRSTS_PE) {
 		if (nvt_cir_tx_inactive(nvt))
 			nvt_get_rx_ir_data(nvt);
-
-		cur_state = nvt->study_state;
-
-		if (cur_state == ST_STUDY_NONE)
-			nvt_clear_cir_fifo(nvt);
 	}
 
 	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
@@ -1193,9 +1187,6 @@ static int nvt_suspend(struct pnp_dev *pdev, pm_message_t state)
 
 	spin_lock_irqsave(&nvt->nvt_lock, flags);
 
-	/* zero out misc state tracking */
-	nvt->study_state = ST_STUDY_NONE;
-
 	/* disable all CIR interrupts */
 	nvt_cir_reg_write(nvt, 0, CIR_IREN);
 
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 8bd35bd..65324ef 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -117,23 +117,10 @@ struct nvt_dev {
 	/* rx settings */
 	bool learning_enabled;
 
-	/* for study */
-	u8 study_state;
 	/* carrier period = 1 / frequency */
 	u32 carrier;
 };
 
-/* study states */
-#define ST_STUDY_NONE      0x0
-#define ST_STUDY_START     0x1
-#define ST_STUDY_CARRIER   0x2
-#define ST_STUDY_ALL_RECV  0x4
-
-/* receive states */
-#define ST_RX_WAIT_7F		0x1
-#define ST_RX_WAIT_HEAD		0x2
-#define ST_RX_WAIT_SILENT_END	0x4
-
 /* send states */
 #define ST_TX_NONE	0x0
 #define ST_TX_REQUEST	0x2
-- 
2.9.0

