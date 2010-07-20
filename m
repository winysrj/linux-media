Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:29129 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757606Ab0GTBUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 21:20:25 -0400
Subject: [PATCH 11/17] v4l2_subdev: Move interrupt_service_routine ptr to
 v4l2_subdev_core_ops
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Kenney Phillisjr <kphillisjr@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Steven Toth <stoth@kernellabs.com>
In-Reply-To: <cover.1279586511.git.awalls@md.metrocast.net>
References: <cover.1279586511.git.awalls@md.metrocast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 21:20:49 -0400
Message-ID: <1279588849.31145.7.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CX2584x and related cores are multifunction subdevices with a number
of internal blocks that act as interrupt sources.  Move the v4L2_subdev
interrupt_service_routine callback from v4l_subdev_ir_ops to
v4l2_subdev_core_ops, as the video and audio blocks of a CX2584x and
related cores can generate interrupts along with the IR block.  This
change also makes sense for other subdev's that generate interrupts and
do not have an IR block.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/cx23885/cx23885-core.c |    2 +-
 drivers/media/video/cx23885/cx23888-ir.c   |    3 +--
 include/media/v4l2-subdev.h                |   16 +++++++---------
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index 161ae73..ec8baf3 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -1765,7 +1765,7 @@ static irqreturn_t cx23885_irq(int irq, void *dev_id)
 		handled += cx23885_video_irq(dev, vida_status);
 
 	if (pci_status & PCI_MSK_IR) {
-		v4l2_subdev_call(dev->sd_ir, ir, interrupt_service_routine,
+		v4l2_subdev_call(dev->sd_ir, core, interrupt_service_routine,
 				 pci_status, &ir_handled);
 		if (ir_handled)
 			handled++;
diff --git a/drivers/media/video/cx23885/cx23888-ir.c b/drivers/media/video/cx23885/cx23888-ir.c
index 28ca90f..51f2163 100644
--- a/drivers/media/video/cx23885/cx23888-ir.c
+++ b/drivers/media/video/cx23885/cx23888-ir.c
@@ -1126,11 +1126,10 @@ static const struct v4l2_subdev_core_ops cx23888_ir_core_ops = {
 	.g_register = cx23888_ir_g_register,
 	.s_register = cx23888_ir_s_register,
 #endif
+	.interrupt_service_routine = cx23888_ir_irq_handler,
 };
 
 static const struct v4l2_subdev_ir_ops cx23888_ir_ir_ops = {
-	.interrupt_service_routine = cx23888_ir_irq_handler,
-
 	.rx_read = cx23888_ir_rx_read,
 	.rx_g_parameters = cx23888_ir_rx_g_parameters,
 	.rx_s_parameters = cx23888_ir_rx_s_parameters,
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index a780cca..bacd525 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -131,6 +131,11 @@ struct v4l2_subdev_io_pin_config {
 
    s_power: puts subdevice in power saving mode (on == 0) or normal operation
 	mode (on == 1).
+
+   interrupt_service_routine: Called by the bridge chip's interrupt service
+	handler, when an interrupt status has be raised due to this subdev,
+	so that this subdev can handle the details.  It may schedule work to be
+	performed later.  It must not sleep.  *Called from an IRQ context*.
  */
 struct v4l2_subdev_core_ops {
 	int (*g_chip_ident)(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip);
@@ -156,6 +161,8 @@ struct v4l2_subdev_core_ops {
 	int (*s_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg);
 #endif
 	int (*s_power)(struct v4l2_subdev *sd, int on);
+	int (*interrupt_service_routine)(struct v4l2_subdev *sd,
+						u32 status, bool *handled);
 };
 
 /* s_mode: switch the tuner to a specific tuner mode. Replacement of s_radio.
@@ -330,11 +337,6 @@ struct v4l2_subdev_sensor_ops {
 };
 
 /*
-   interrupt_service_routine: Called by the bridge chip's interrupt service
-	handler, when an IR interrupt status has be raised due to this subdev,
-	so that this subdev can handle the details.  It may schedule work to be
-	performed later.  It must not sleep.  *Called from an IRQ context*.
-
    [rt]x_g_parameters: Get the current operating parameters and state of the
 	the IR receiver or transmitter.
 
@@ -392,10 +394,6 @@ struct v4l2_subdev_ir_parameters {
 };
 
 struct v4l2_subdev_ir_ops {
-	/* Common to receiver and transmitter */
-	int (*interrupt_service_routine)(struct v4l2_subdev *sd,
-						u32 status, bool *handled);
-
 	/* Receiver */
 	int (*rx_read)(struct v4l2_subdev *sd, u8 *buf, size_t count,
 				ssize_t *num);
-- 
1.7.1.1


