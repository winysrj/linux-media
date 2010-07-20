Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:15850 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757606Ab0GTBXf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 21:23:35 -0400
Subject: [PATCH 14/17] cx23885: Add preliminary IR Rx support for the
 HVR-1250 and TeVii S470
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Kenney Phillisjr <kphillisjr@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Steven Toth <stoth@kernellabs.com>,
	"Igor M.Liplianin" <liplianin@me.by>
In-Reply-To: <cover.1279586511.git.awalls@md.metrocast.net>
References: <cover.1279586511.git.awalls@md.metrocast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 21:23:59 -0400
Message-ID: <1279589039.31145.12.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add initial IR Rx support using the intergrated IR controller in the
A/V core of the CX23885 bridge chip.

This initial support is flawed in that I2C transactions should not
be performed in a hard irq context.  That will be fixed in a
follow on patch.

The TeVii S470 support is reported to generate perptual interrupts
that renders a user' system nearly unusable.  The TeVii S470 IR
will be disabled by default in a follow on patch.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/cx23885/cx23885-cards.c |   52 ++++++++++++++++++++++++--
 drivers/media/video/cx23885/cx23885-core.c  |   22 +++++++++--
 drivers/media/video/cx23885/cx23885-input.c |   46 ++++++++++++++++++++++-
 drivers/media/video/cx23885/cx23885-reg.h   |    1 +
 4 files changed, 111 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index 96da11f..5c11caf 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -922,7 +922,7 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 
 int cx23885_ir_init(struct cx23885_dev *dev)
 {
-	static struct v4l2_subdev_io_pin_config ir_pin_cfg[] = {
+	static struct v4l2_subdev_io_pin_config ir_rxtx_pin_cfg[] = {
 		{
 			.flags	  = V4L2_SUBDEV_IO_PIN_INPUT,
 			.pin	  = CX23885_PIN_IR_RX_GPIO19,
@@ -937,12 +937,22 @@ int cx23885_ir_init(struct cx23885_dev *dev)
 			.strength = CX25840_PIN_DRIVE_MEDIUM,
 		}
 	};
-	const size_t ir_pin_cfg_count = ARRAY_SIZE(ir_pin_cfg);
+	const size_t ir_rxtx_pin_cfg_count = ARRAY_SIZE(ir_rxtx_pin_cfg);
+
+	static struct v4l2_subdev_io_pin_config ir_rx_pin_cfg[] = {
+		{
+			.flags	  = V4L2_SUBDEV_IO_PIN_INPUT,
+			.pin	  = CX23885_PIN_IR_RX_GPIO19,
+			.function = CX23885_PAD_IR_RX,
+			.value	  = 0,
+			.strength = CX25840_PIN_DRIVE_MEDIUM,
+		}
+	};
+	const size_t ir_rx_pin_cfg_count = ARRAY_SIZE(ir_rx_pin_cfg);
 
 	struct v4l2_subdev_ir_parameters params;
 	int ret = 0;
 	switch (dev->board) {
-	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
 	case CX23885_BOARD_HAUPPAUGE_HVR1800:
@@ -961,7 +971,7 @@ int cx23885_ir_init(struct cx23885_dev *dev)
 			break;
 		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_888_IR);
 		v4l2_subdev_call(dev->sd_cx25840, core, s_io_pin_config,
-				 ir_pin_cfg_count, ir_pin_cfg);
+				 ir_rxtx_pin_cfg_count, ir_rxtx_pin_cfg);
 		dev->pci_irqmask |= PCI_MSK_IR;
 		/*
 		 * For these boards we need to invert the Tx output via the
@@ -975,6 +985,26 @@ int cx23885_ir_init(struct cx23885_dev *dev)
 		params.shutdown = true;
 		v4l2_subdev_call(dev->sd_ir, ir, tx_s_parameters, &params);
 		break;
+	case CX23885_BOARD_TEVII_S470:
+		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_AV_CORE);
+		if (dev->sd_ir == NULL) {
+			ret = -ENODEV;
+			break;
+		}
+		v4l2_subdev_call(dev->sd_cx25840, core, s_io_pin_config,
+				 ir_rx_pin_cfg_count, ir_rx_pin_cfg);
+		dev->pci_irqmask |= PCI_MSK_AV_CORE;
+		break;
+	case CX23885_BOARD_HAUPPAUGE_HVR1250:
+		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_AV_CORE);
+		if (dev->sd_ir == NULL) {
+			ret = -ENODEV;
+			break;
+		}
+		v4l2_subdev_call(dev->sd_cx25840, core, s_io_pin_config,
+				 ir_rxtx_pin_cfg_count, ir_rxtx_pin_cfg);
+		dev->pci_irqmask |= PCI_MSK_AV_CORE;
+		break;
 	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
 		request_module("ir-kbd-i2c");
 		break;
@@ -993,6 +1023,13 @@ void cx23885_ir_fini(struct cx23885_dev *dev)
 		cx23888_ir_remove(dev);
 		dev->sd_ir = NULL;
 		break;
+	case CX23885_BOARD_TEVII_S470:
+	case CX23885_BOARD_HAUPPAUGE_HVR1250:
+		dev->pci_irqmask &= ~PCI_MSK_AV_CORE;
+		cx_clear(PCI_INT_MSK, PCI_MSK_AV_CORE);
+		/* sd_ir is a duplicate pointer to the AV Core, just clear it */
+		dev->sd_ir = NULL;
+		break;
 	}
 }
 
@@ -1004,6 +1041,11 @@ void cx23885_ir_pci_int_enable(struct cx23885_dev *dev)
 		if (dev->sd_ir && (dev->pci_irqmask & PCI_MSK_IR))
 			cx_set(PCI_INT_MSK, PCI_MSK_IR);
 		break;
+	case CX23885_BOARD_TEVII_S470:
+	case CX23885_BOARD_HAUPPAUGE_HVR1250:
+		if (dev->sd_ir && (dev->pci_irqmask & PCI_MSK_AV_CORE))
+			cx_set(PCI_INT_MSK, PCI_MSK_AV_CORE);
+		break;
 	}
 }
 
@@ -1149,6 +1191,8 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
+	case CX23885_BOARD_TEVII_S470:
+	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", "cx25840", 0x88 >> 1, NULL);
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index ec8baf3..f912be2 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -1650,7 +1650,7 @@ static irqreturn_t cx23885_irq(int irq, void *dev_id)
 	u32 ts1_status, ts1_mask;
 	u32 ts2_status, ts2_mask;
 	int vida_count = 0, ts1_count = 0, ts2_count = 0, handled = 0;
-	bool ir_handled = false;
+	bool subdev_handled;
 
 	pci_status = cx_read(PCI_INT_STAT);
 	pci_mask = cx_read(PCI_INT_MSK);
@@ -1681,7 +1681,7 @@ static irqreturn_t cx23885_irq(int irq, void *dev_id)
 			  PCI_MSK_VID_C   | PCI_MSK_VID_B   | PCI_MSK_VID_A   |
 			  PCI_MSK_AUD_INT | PCI_MSK_AUD_EXT |
 			  PCI_MSK_GPIO0   | PCI_MSK_GPIO1   |
-			  PCI_MSK_IR)) {
+			  PCI_MSK_AV_CORE | PCI_MSK_IR)) {
 
 		if (pci_status & PCI_MSK_RISC_RD)
 			dprintk(7, " (PCI_MSK_RISC_RD   0x%08x)\n",
@@ -1731,6 +1731,10 @@ static irqreturn_t cx23885_irq(int irq, void *dev_id)
 			dprintk(7, " (PCI_MSK_GPIO1     0x%08x)\n",
 				PCI_MSK_GPIO1);
 
+		if (pci_status & PCI_MSK_AV_CORE)
+			dprintk(7, " (PCI_MSK_AV_CORE   0x%08x)\n",
+				PCI_MSK_AV_CORE);
+
 		if (pci_status & PCI_MSK_IR)
 			dprintk(7, " (PCI_MSK_IR        0x%08x)\n",
 				PCI_MSK_IR);
@@ -1765,9 +1769,19 @@ static irqreturn_t cx23885_irq(int irq, void *dev_id)
 		handled += cx23885_video_irq(dev, vida_status);
 
 	if (pci_status & PCI_MSK_IR) {
+		subdev_handled = false;
 		v4l2_subdev_call(dev->sd_ir, core, interrupt_service_routine,
-				 pci_status, &ir_handled);
-		if (ir_handled)
+				 pci_status, &subdev_handled);
+		if (subdev_handled)
+			handled++;
+	}
+
+	if (pci_status & PCI_MSK_AV_CORE) {
+		subdev_handled = false;
+		v4l2_subdev_call(dev->sd_cx25840,
+				 core, interrupt_service_routine,
+				 pci_status, &subdev_handled);
+		if (subdev_handled)
 			handled++;
 	}
 
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index 496d751..3f924e2 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -99,8 +99,10 @@ void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events)
 	switch (dev->board) {
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
+	case CX23885_BOARD_TEVII_S470:
+	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 		/*
-		 * The only board we handle right now.  However other boards
+		 * The only boards we handle right now.  However other boards
 		 * using the CX2388x integrated IR controller should be similar
 		 */
 		break;
@@ -148,6 +150,7 @@ static int cx23885_input_ir_start(struct cx23885_dev *dev)
 	switch (dev->board) {
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
+	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 		/*
 		 * The IR controller on this board only returns pulse widths.
 		 * Any other mode setting will fail to set up the device.
@@ -172,6 +175,37 @@ static int cx23885_input_ir_start(struct cx23885_dev *dev)
 		 */
 		params.invert_level = true;
 		break;
+	case CX23885_BOARD_TEVII_S470:
+		/*
+		 * The IR controller on this board only returns pulse widths.
+		 * Any other mode setting will fail to set up the device.
+		 */
+		params.mode = V4L2_SUBDEV_IR_MODE_PULSE_WIDTH;
+		params.enable = true;
+		params.interrupt_enable = true;
+		params.shutdown = false;
+
+		/* Setup for a standard NEC protocol */
+		params.carrier_freq = 37917; /* Hz, 455 kHz/12 for NEC */
+		params.carrier_range_lower = 33000; /* Hz */
+		params.carrier_range_upper = 43000; /* Hz */
+		params.duty_cycle = 33; /* percent, 33 percent for NEC */
+
+		/*
+		 * NEC max pulse width: (64/3)/(455 kHz/12) * 16 nec_units
+		 * (64/3)/(455 kHz/12) * 16 nec_units * 1.375 = 12378022 ns
+		 */
+		params.max_pulse_width = 12378022; /* ns */
+
+		/*
+		 * NEC noise filter min width: (64/3)/(455 kHz/12) * 1 nec_unit
+		 * (64/3)/(455 kHz/12) * 1 nec_units * 0.625 = 351648 ns
+		 */
+		params.noise_filter_min_width = 351648; /* ns */
+
+		params.modulation = false;
+		params.invert_level = true;
+		break;
 	}
 	v4l2_subdev_call(dev->sd_ir, ir, rx_s_parameters, &params);
 	return 0;
@@ -244,12 +278,20 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	switch (dev->board) {
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
-		/* Integrated CX23888 IR controller */
+	case CX23885_BOARD_HAUPPAUGE_HVR1250:
+		/* Integrated CX2388[58] IR controller */
 		driver_type = RC_DRIVER_IR_RAW;
 		allowed_protos = IR_TYPE_ALL;
 		/* The grey Hauppauge RC-5 remote */
 		rc_map = RC_MAP_RC5_HAUPPAUGE_NEW;
 		break;
+	case CX23885_BOARD_TEVII_S470:
+		/* Integrated CX23885 IR controller */
+		driver_type = RC_DRIVER_IR_RAW;
+		allowed_protos = IR_TYPE_ALL;
+		/* A guess at the remote */
+		rc_map = RC_MAP_TEVII_NEC;
+		break;
 	default:
 		return -ENODEV;
 	}
diff --git a/drivers/media/video/cx23885/cx23885-reg.h b/drivers/media/video/cx23885/cx23885-reg.h
index c0bc9a0..a28772d 100644
--- a/drivers/media/video/cx23885/cx23885-reg.h
+++ b/drivers/media/video/cx23885/cx23885-reg.h
@@ -213,6 +213,7 @@ Channel manager Data Structure entry = 20 DWORD
 #define DEV_CNTRL2	0x00040000
 
 #define PCI_MSK_IR        (1 << 28)
+#define PCI_MSK_AV_CORE   (1 << 27)
 #define PCI_MSK_GPIO1     (1 << 24)
 #define PCI_MSK_GPIO0     (1 << 23)
 #define PCI_MSK_APB_DMA   (1 << 12)
-- 
1.7.1.1


