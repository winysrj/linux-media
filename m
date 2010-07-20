Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:13494 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757606Ab0GTBT0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 21:19:26 -0400
Subject: [PATCH 10/17] cx23885: For CX23888 IR, configure the IO pin mux IR
 pins explcitly
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Kenney Phillisjr <kphillisjr@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Steven Toth <stoth@kernellabs.com>
In-Reply-To: <cover.1279586511.git.awalls@md.metrocast.net>
References: <cover.1279586511.git.awalls@md.metrocast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 21:19:40 -0400
Message-ID: <1279588780.31145.5.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Explicitly configure the IR Tx and IR Rx pins to be driven by the
IR Rx and Tx pads from the AV core for CX23888 IR.

For the HVR-1850 and HVR-1290 configure the IR Tx level inversion,
so the Tx LED is off when idle.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/cx23885/cx23885-cards.c |   31 +++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index 093de84..191bda0 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -922,6 +922,24 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 
 int cx23885_ir_init(struct cx23885_dev *dev)
 {
+	static struct v4l2_subdev_io_pin_config ir_pin_cfg[] = {
+		{
+			.flags	  = V4L2_SUBDEV_IO_PIN_INPUT,
+			.pin	  = CX23885_PIN_IR_RX_GPIO19,
+			.function = CX23885_PAD_IR_RX,
+			.value	  = 0,
+			.strength = CX25840_PIN_DRIVE_MEDIUM,
+		}, {
+			.flags	  = V4L2_SUBDEV_IO_PIN_OUTPUT,
+			.pin	  = CX23885_PIN_IR_TX_GPIO20,
+			.function = CX23885_PAD_IR_TX,
+			.value	  = 0,
+			.strength = CX25840_PIN_DRIVE_MEDIUM,
+		}
+	};
+	const size_t ir_pin_cfg_count = ARRAY_SIZE(ir_pin_cfg);
+
+	struct v4l2_subdev_ir_parameters params;
 	int ret = 0;
 	switch (dev->board) {
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
@@ -942,7 +960,20 @@ int cx23885_ir_init(struct cx23885_dev *dev)
 		if (ret)
 			break;
 		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_888_IR);
+		v4l2_subdev_call(dev->sd_cx25840, core, s_io_pin_config,
+				 ir_pin_cfg_count, ir_pin_cfg);
 		dev->pci_irqmask |= PCI_MSK_IR;
+		/*
+		 * For these boards we need to invert the Tx output via the
+		 * IR controller to have the LED off while idle
+		 */
+		v4l2_subdev_call(dev->sd_ir, ir, tx_g_parameters, &params);
+		params.enable = false;
+		params.shutdown = false;
+		params.invert_level = true;
+		v4l2_subdev_call(dev->sd_ir, ir, tx_s_parameters, &params);
+		params.shutdown = true;
+		v4l2_subdev_call(dev->sd_ir, ir, tx_s_parameters, &params);
 		break;
 	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
 		request_module("ir-kbd-i2c");
-- 
1.7.1.1


