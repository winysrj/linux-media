Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:35955 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752921AbdEQRc5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 13:32:57 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/5] [media] sir_ir: remove init_chrdev and init_sir_ir functions
Date: Wed, 17 May 2017 18:32:53 +0100
Message-Id: <8acf606d7db3d9dbe23215fdf68725f1ef80d8ce.1495035457.git.sean@mess.org>
In-Reply-To: <cover.1495035457.git.sean@mess.org>
References: <cover.1495035457.git.sean@mess.org>
In-Reply-To: <cover.1495035457.git.sean@mess.org>
References: <cover.1495035457.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Inlining these functions into the probe function makes it much
more readable.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/sir_ir.c | 58 ++++++++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 36 deletions(-)

diff --git a/drivers/media/rc/sir_ir.c b/drivers/media/rc/sir_ir.c
index fdac570..5ee3a23 100644
--- a/drivers/media/rc/sir_ir.c
+++ b/drivers/media/rc/sir_ir.c
@@ -53,7 +53,6 @@ static DEFINE_SPINLOCK(hardware_lock);
 
 /* Communication with user-space */
 static void add_read_queue(int flag, unsigned long val);
-static int init_chrdev(void);
 /* Hardware */
 static irqreturn_t sir_interrupt(int irq, void *dev_id);
 static void send_space(unsigned long len);
@@ -120,28 +119,6 @@ static void add_read_queue(int flag, unsigned long val)
 	ir_raw_event_store_with_filter(rcdev, &ev);
 }
 
-static int init_chrdev(void)
-{
-	rcdev = devm_rc_allocate_device(&sir_ir_dev->dev, RC_DRIVER_IR_RAW);
-	if (!rcdev)
-		return -ENOMEM;
-
-	rcdev->input_name = "SIR IrDA port";
-	rcdev->input_phys = KBUILD_MODNAME "/input0";
-	rcdev->input_id.bustype = BUS_HOST;
-	rcdev->input_id.vendor = 0x0001;
-	rcdev->input_id.product = 0x0001;
-	rcdev->input_id.version = 0x0100;
-	rcdev->tx_ir = sir_tx_ir;
-	rcdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
-	rcdev->driver_name = KBUILD_MODNAME;
-	rcdev->map_name = RC_MAP_RC6_MCE;
-	rcdev->timeout = IR_DEFAULT_TIMEOUT;
-	rcdev->dev.parent = &sir_ir_dev->dev;
-
-	return devm_rc_register_device(&sir_ir_dev->dev, rcdev);
-}
-
 /* SECTION: Hardware */
 static void sir_timeout(unsigned long data)
 {
@@ -323,11 +300,27 @@ static void drop_hardware(void)
 }
 
 /* SECTION: Initialisation */
-
-static int init_sir_ir(void)
+static int sir_ir_probe(struct platform_device *dev)
 {
 	int retval;
 
+	rcdev = devm_rc_allocate_device(&sir_ir_dev->dev, RC_DRIVER_IR_RAW);
+	if (!rcdev)
+		return -ENOMEM;
+
+	rcdev->input_name = "SIR IrDA port";
+	rcdev->input_phys = KBUILD_MODNAME "/input0";
+	rcdev->input_id.bustype = BUS_HOST;
+	rcdev->input_id.vendor = 0x0001;
+	rcdev->input_id.product = 0x0001;
+	rcdev->input_id.version = 0x0100;
+	rcdev->tx_ir = sir_tx_ir;
+	rcdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rcdev->driver_name = KBUILD_MODNAME;
+	rcdev->map_name = RC_MAP_RC6_MCE;
+	rcdev->timeout = IR_DEFAULT_TIMEOUT;
+	rcdev->dev.parent = &sir_ir_dev->dev;
+
 	setup_timer(&timerlist, sir_timeout, 0);
 
 	/* get I/O port access and IRQ line */
@@ -343,20 +336,13 @@ static int init_sir_ir(void)
 	}
 	pr_info("I/O port 0x%.4x, IRQ %d.\n", io, irq);
 
-	init_hardware();
-
-	return 0;
-}
-
-static int sir_ir_probe(struct platform_device *dev)
-{
-	int retval;
-
-	retval = init_chrdev();
+	retval = devm_rc_register_device(&sir_ir_dev->dev, rcdev);
 	if (retval < 0)
 		return retval;
 
-	return init_sir_ir();
+	init_hardware();
+
+	return 0;
 }
 
 static int sir_ir_remove(struct platform_device *dev)
-- 
2.9.4
