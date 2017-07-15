Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33421 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdGOVNd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 17:13:33 -0400
Received: by mail-wm0-f67.google.com with SMTP id j85so16538058wmj.0
        for <linux-media@vger.kernel.org>; Sat, 15 Jul 2017 14:13:32 -0700 (PDT)
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, Sean Young <sean@mess.org>
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] media: rc: nuvoton: remove rudimentary transmit functionality
Message-ID: <0d58eb0e-3d16-5c3e-92c8-4fb5d76c6415@gmail.com>
Date: Sat, 15 Jul 2017 23:13:14 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Transmit support in this driver was never tested and based on the code
it can't work. Just one example:
The buffer provided to nvt_tx_ir holds unsigned int values in
micro seconds: First value is for a pulse, second for a pause, etc.
Bytes in this buffer are copied as-is to the chip FIFO what can't work
as the chip-internal format is totally different. See also conversion
done in nvt_process_rx_ir_data.

Even if we would try to fix this we have the issue that we can't test
it. There seems to be no device on the market using IR transmit with
one of the chips supported by this driver.

To facilitate maintenance of the driver I'd propose to remove the
rudimentary transmit support.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 114 ++---------------------------------------
 drivers/media/rc/nuvoton-cir.h |  24 ---------
 2 files changed, 3 insertions(+), 135 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index ec4b25bd..7651975b 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -727,70 +727,6 @@ static int nvt_ir_raw_set_wakeup_filter(struct rc_dev *dev,
 	return ret;
 }
 
-/*
- * nvt_tx_ir
- *
- * 1) clean TX fifo first (handled by AP)
- * 2) copy data from user space
- * 3) disable RX interrupts, enable TX interrupts: TTR & TFU
- * 4) send 9 packets to TX FIFO to open TTR
- * in interrupt_handler:
- * 5) send all data out
- * go back to write():
- * 6) disable TX interrupts, re-enable RX interupts
- *
- * The key problem of this function is user space data may larger than
- * driver's data buf length. So nvt_tx_ir() will only copy TX_BUF_LEN data to
- * buf, and keep current copied data buf num in cur_buf_num. But driver's buf
- * number may larger than TXFCONT (0xff). So in interrupt_handler, it has to
- * set TXFCONT as 0xff, until buf_count less than 0xff.
- */
-static int nvt_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned n)
-{
-	struct nvt_dev *nvt = dev->priv;
-	unsigned long flags;
-	unsigned int i;
-	u8 iren;
-	int ret;
-
-	spin_lock_irqsave(&nvt->lock, flags);
-
-	ret = min((unsigned)(TX_BUF_LEN / sizeof(unsigned)), n);
-	nvt->tx.buf_count = (ret * sizeof(unsigned));
-
-	memcpy(nvt->tx.buf, txbuf, nvt->tx.buf_count);
-
-	nvt->tx.cur_buf_num = 0;
-
-	/* save currently enabled interrupts */
-	iren = nvt_cir_reg_read(nvt, CIR_IREN);
-
-	/* now disable all interrupts, save TFU & TTR */
-	nvt_cir_reg_write(nvt, CIR_IREN_TFU | CIR_IREN_TTR, CIR_IREN);
-
-	nvt->tx.tx_state = ST_TX_REPLY;
-
-	nvt_cir_reg_write(nvt, CIR_FIFOCON_TX_TRIGGER_LEV_8 |
-			  CIR_FIFOCON_RXFIFOCLR, CIR_FIFOCON);
-
-	/* trigger TTR interrupt by writing out ones, (yes, it's ugly) */
-	for (i = 0; i < 9; i++)
-		nvt_cir_reg_write(nvt, 0x01, CIR_STXFIFO);
-
-	spin_unlock_irqrestore(&nvt->lock, flags);
-
-	wait_event(nvt->tx.queue, nvt->tx.tx_state == ST_TX_REQUEST);
-
-	spin_lock_irqsave(&nvt->lock, flags);
-	nvt->tx.tx_state = ST_TX_NONE;
-	spin_unlock_irqrestore(&nvt->lock, flags);
-
-	/* restore enabled interrupts to prior state */
-	nvt_cir_reg_write(nvt, iren, CIR_IREN);
-
-	return ret;
-}
-
 /* dump contents of the last rx buffer we got from the hw rx fifo */
 static void nvt_dump_rx_buf(struct nvt_dev *nvt)
 {
@@ -895,11 +831,6 @@ static void nvt_cir_log_irqs(u8 status, u8 iren)
 			   CIR_IRSTS_TFU | CIR_IRSTS_GH) ? " ?" : "");
 }
 
-static bool nvt_cir_tx_inactive(struct nvt_dev *nvt)
-{
-	return nvt->tx.tx_state == ST_TX_NONE;
-}
-
 /* interrupt service routine for incoming and outgoing CIR data */
 static irqreturn_t nvt_cir_isr(int irq, void *data)
 {
@@ -952,40 +883,8 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 
 	if (status & CIR_IRSTS_RFO)
 		nvt_handle_rx_fifo_overrun(nvt);
-
-	else if (status & (CIR_IRSTS_RTR | CIR_IRSTS_PE)) {
-		/* We only do rx if not tx'ing */
-		if (nvt_cir_tx_inactive(nvt))
-			nvt_get_rx_ir_data(nvt);
-	}
-
-	if (status & CIR_IRSTS_TE)
-		nvt_clear_tx_fifo(nvt);
-
-	if (status & CIR_IRSTS_TTR) {
-		unsigned int pos, count;
-		u8 tmp;
-
-		pos = nvt->tx.cur_buf_num;
-		count = nvt->tx.buf_count;
-
-		/* Write data into the hardware tx fifo while pos < count */
-		if (pos < count) {
-			nvt_cir_reg_write(nvt, nvt->tx.buf[pos], CIR_STXFIFO);
-			nvt->tx.cur_buf_num++;
-		/* Disable TX FIFO Trigger Level Reach (TTR) interrupt */
-		} else {
-			tmp = nvt_cir_reg_read(nvt, CIR_IREN);
-			nvt_cir_reg_write(nvt, tmp & ~CIR_IREN_TTR, CIR_IREN);
-		}
-	}
-
-	if (status & CIR_IRSTS_TFU) {
-		if (nvt->tx.tx_state == ST_TX_REPLY) {
-			nvt->tx.tx_state = ST_TX_REQUEST;
-			wake_up(&nvt->tx.queue);
-		}
-	}
+	else if (status & (CIR_IRSTS_RTR | CIR_IRSTS_PE))
+		nvt_get_rx_ir_data(nvt);
 
 	spin_unlock(&nvt->lock);
 
@@ -1062,7 +961,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	if (!nvt)
 		return -ENOMEM;
 
-	/* input device for IR remote (and tx) */
+	/* input device for IR remote */
 	nvt->rdev = devm_rc_allocate_device(&pdev->dev, RC_DRIVER_IR_RAW);
 	if (!nvt->rdev)
 		return -ENOMEM;
@@ -1105,8 +1004,6 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 
 	pnp_set_drvdata(pdev, nvt);
 
-	init_waitqueue_head(&nvt->tx.queue);
-
 	ret = nvt_hw_detect(nvt);
 	if (ret)
 		return ret;
@@ -1131,7 +1028,6 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	rdev->encode_wakeup = true;
 	rdev->open = nvt_open;
 	rdev->close = nvt_close;
-	rdev->tx_ir = nvt_tx_ir;
 	rdev->s_tx_carrier = nvt_set_tx_carrier;
 	rdev->s_wakeup_filter = nvt_ir_raw_set_wakeup_filter;
 	rdev->input_name = "Nuvoton w836x7hg Infrared Remote Transceiver";
@@ -1148,8 +1044,6 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 #if 0
 	rdev->min_timeout = XYZ;
 	rdev->max_timeout = XYZ;
-	/* tx bits */
-	rdev->tx_resolution = XYZ;
 #endif
 	ret = devm_rc_register_device(&pdev->dev, rdev);
 	if (ret)
@@ -1205,8 +1099,6 @@ static int nvt_suspend(struct pnp_dev *pdev, pm_message_t state)
 
 	spin_lock_irqsave(&nvt->lock, flags);
 
-	nvt->tx.tx_state = ST_TX_NONE;
-
 	/* disable all CIR interrupts */
 	nvt_cir_reg_write(nvt, 0, CIR_IREN);
 
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 88a29df3..0737c27f 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -46,14 +46,6 @@ static int debug;
 			KBUILD_MODNAME ": " text "\n" , ## __VA_ARGS__)
 
 
-/*
- * Original lirc driver said min value of 76, and recommended value of 256
- * for the buffer length, but then used 2048. Never mind that the size of the
- * RX FIFO is 32 bytes... So I'm using 32 for RX and 256 for TX atm, but I'm
- * not sure if maybe that TX value is off by a factor of 8 (bits vs. bytes),
- * and I don't have TX-capable hardware to test/debug on...
- */
-#define TX_BUF_LEN 256
 #define RX_BUF_LEN 32
 
 #define SIO_ID_MASK 0xfff0
@@ -81,14 +73,6 @@ struct nvt_dev {
 	u8 buf[RX_BUF_LEN];
 	unsigned int pkts;
 
-	struct {
-		u8 buf[TX_BUF_LEN];
-		unsigned int buf_count;
-		unsigned int cur_buf_num;
-		wait_queue_head_t queue;
-		u8 tx_state;
-	} tx;
-
 	/* EFER Config register index/data pair */
 	u32 cr_efir;
 	u32 cr_efdr;
@@ -103,18 +87,10 @@ struct nvt_dev {
 	u8 chip_major;
 	u8 chip_minor;
 
-	/* hardware features */
-	bool hw_tx_capable;
-
 	/* carrier period = 1 / frequency */
 	u32 carrier;
 };
 
-/* send states */
-#define ST_TX_NONE	0x0
-#define ST_TX_REQUEST	0x2
-#define ST_TX_REPLY	0x4
-
 /* buffer packet constants */
 #define BUF_PULSE_BIT	0x80
 #define BUF_LEN_MASK	0x7f
-- 
2.13.2
