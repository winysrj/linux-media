Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758961Ab0JHTVV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Oct 2010 15:21:21 -0400
Date: Fri, 8 Oct 2010 15:21:09 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: lirc-list@lists.sourceforge.net, lcchen@nuvoton.com
Subject: [PATCH] nuvoton-cir: add proper rx fifo overrun handling
Message-ID: <20101008192109.GD5165@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Per discussion with Andy Walls on irc, rx fifo overruns are not all that
uncommon on a busy system, and the initial posting of the nuvoton-cir
driver doesn't handle them well enough. With this addition, we'll drain
the hw fifo, attempt to process any ir pulse trains completed with that
flush, then we'll issue a hw rx fifo clear and reset the raw ir sample
kfifo and start over collecting raw ir data.

Also slightly refactors the cir interrupt enabling so that we always get
consistent flags set and only have to modify them in one place, should
they need to be altered.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/nuvoton-cir.c |   37 +++++++++++++++++++++++++++++--------
 1 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/media/IR/nuvoton-cir.c b/drivers/media/IR/nuvoton-cir.c
index 1ce9359..fdb280e 100644
--- a/drivers/media/IR/nuvoton-cir.c
+++ b/drivers/media/IR/nuvoton-cir.c
@@ -339,6 +339,15 @@ static void nvt_clear_tx_fifo(struct nvt_dev *nvt)
 	nvt_cir_reg_write(nvt, val | CIR_FIFOCON_TXFIFOCLR, CIR_FIFOCON);
 }
 
+/* enable RX Trigger Level Reach and Packet End interrupts */
+static void nvt_set_cir_iren(struct nvt_dev *nvt)
+{
+	u8 iren;
+
+	iren = CIR_IREN_RTR | CIR_IREN_PE;
+	nvt_cir_reg_write(nvt, iren, CIR_IREN);
+}
+
 static void nvt_cir_regs_init(struct nvt_dev *nvt)
 {
 	/* set sample limit count (PE interrupt raised when reached) */
@@ -363,8 +372,8 @@ static void nvt_cir_regs_init(struct nvt_dev *nvt)
 	/* clear any and all stray interrupts */
 	nvt_cir_reg_write(nvt, 0xff, CIR_IRSTS);
 
-	/* and finally, enable RX Trigger Level Read and Packet End interrupts */
-	nvt_cir_reg_write(nvt, CIR_IREN_RTR | CIR_IREN_PE, CIR_IREN);
+	/* and finally, enable interrupts */
+	nvt_set_cir_iren(nvt);
 }
 
 static void nvt_cir_wake_regs_init(struct nvt_dev *nvt)
@@ -639,12 +648,22 @@ static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 	nvt_dbg_verbose("%s done", __func__);
 }
 
+static void nvt_handle_rx_fifo_overrun(struct nvt_dev *nvt)
+{
+	nvt_pr(KERN_WARNING, "RX FIFO overrun detected, flushing data!");
+
+	nvt->pkts = 0;
+	nvt_clear_cir_fifo(nvt);
+	ir_raw_event_reset(nvt->rdev);
+}
+
 /* copy data from hardware rx fifo into driver buffer */
 static void nvt_get_rx_ir_data(struct nvt_dev *nvt)
 {
 	unsigned long flags;
 	u8 fifocount, val;
 	unsigned int b_idx;
+	bool overrun = false;
 	int i;
 
 	/* Get count of how many bytes to read from RX FIFO */
@@ -652,11 +671,10 @@ static void nvt_get_rx_ir_data(struct nvt_dev *nvt)
 	/* if we get 0xff, probably means the logical dev is disabled */
 	if (fifocount == 0xff)
 		return;
-	/* this would suggest a fifo overrun, not good... */
+	/* watch out for a fifo overrun condition */
 	else if (fifocount > RX_BUF_LEN) {
-		nvt_pr(KERN_WARNING, "fifocount %d over fifo len (%d)!",
-		       fifocount, RX_BUF_LEN);
-		return;
+		overrun = true;
+		fifocount = RX_BUF_LEN;
 	}
 
 	nvt_dbg("attempting to fetch %u bytes from hw rx fifo", fifocount);
@@ -682,6 +700,9 @@ static void nvt_get_rx_ir_data(struct nvt_dev *nvt)
 
 	nvt_process_rx_ir_data(nvt);
 
+	if (overrun)
+		nvt_handle_rx_fifo_overrun(nvt);
+
 	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 }
 
@@ -886,7 +907,7 @@ static void nvt_enable_cir(struct nvt_dev *nvt)
 	nvt_cir_reg_write(nvt, 0xff, CIR_IRSTS);
 
 	/* enable interrupts */
-	nvt_cir_reg_write(nvt, CIR_IREN_RTR | CIR_IREN_PE, CIR_IREN);
+	nvt_set_cir_iren(nvt);
 }
 
 static void nvt_disable_cir(struct nvt_dev *nvt)
@@ -1155,7 +1176,7 @@ static int nvt_resume(struct pnp_dev *pdev)
 	nvt_dbg("%s called", __func__);
 
 	/* open interrupt */
-	nvt_cir_reg_write(nvt, CIR_IREN_RTR | CIR_IREN_PE, CIR_IREN);
+	nvt_set_cir_iren(nvt);
 
 	/* Enable CIR logical device */
 	nvt_efm_enable(nvt);
-- 
1.7.1

-- 
Jarod Wilson
jarod@redhat.com

