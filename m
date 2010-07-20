Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:33320 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760991Ab0GTB2m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 21:28:42 -0400
Subject: [PATCH 16/17] cx23885: Move AV Core irq handling to a work handler
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Kenney Phillisjr <kphillisjr@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Steven Toth <stoth@kernellabs.com>,
	"Igor M.Liplianin" <liplianin@me.by>
In-Reply-To: <cover.1279586511.git.awalls@md.metrocast.net>
References: <cover.1279586511.git.awalls@md.metrocast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 21:25:40 -0400
Message-ID: <1279589140.31145.14.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Interrupts from the AV Core are best handled by a workqueue handler
since many I2C transactions are required to service the AV Core
interrupt.  The AV_CORE PCI interrupt is disabled by the IRQ handler
and reenabled when the work handler is finished.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/cx23885/Makefile       |    5 ++-
 drivers/media/video/cx23885/cx23885-av.c   |   35 ++++++++++++++++++++++++++++
 drivers/media/video/cx23885/cx23885-av.h   |   27 +++++++++++++++++++++
 drivers/media/video/cx23885/cx23885-core.c |   20 ++++++++-------
 drivers/media/video/cx23885/cx23885-ir.c   |   24 ++++++++++++++++---
 drivers/media/video/cx23885/cx23885.h      |    1 +
 6 files changed, 97 insertions(+), 15 deletions(-)
 create mode 100644 drivers/media/video/cx23885/cx23885-av.c
 create mode 100644 drivers/media/video/cx23885/cx23885-av.h

diff --git a/drivers/media/video/cx23885/Makefile b/drivers/media/video/cx23885/Makefile
index 5787ae2..e2ee95f 100644
--- a/drivers/media/video/cx23885/Makefile
+++ b/drivers/media/video/cx23885/Makefile
@@ -1,7 +1,8 @@
 cx23885-objs	:= cx23885-cards.o cx23885-video.o cx23885-vbi.o \
 		    cx23885-core.o cx23885-i2c.o cx23885-dvb.o cx23885-417.o \
-		    cx23885-ioctl.o cx23885-ir.o cx23885-input.o cx23888-ir.o \
-		    netup-init.o cimax2.o netup-eeprom.o cx23885-f300.o
+		    cx23885-ioctl.o cx23885-ir.o cx23885-av.o cx23885-input.o \
+		    cx23888-ir.o netup-init.o cimax2.o netup-eeprom.o \
+		    cx23885-f300.o
 
 obj-$(CONFIG_VIDEO_CX23885) += cx23885.o
 
diff --git a/drivers/media/video/cx23885/cx23885-av.c b/drivers/media/video/cx23885/cx23885-av.c
new file mode 100644
index 0000000..134ebdd
--- /dev/null
+++ b/drivers/media/video/cx23885/cx23885-av.c
@@ -0,0 +1,35 @@
+/*
+ *  Driver for the Conexant CX23885/7/8 PCIe bridge
+ *
+ *  AV device support routines - non-input, non-vl42_subdev routines
+ *
+ *  Copyright (C) 2010  Andy Walls <awalls@md.metrocast.net>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ *  02110-1301, USA.
+ */
+
+#include "cx23885.h"
+
+void cx23885_av_work_handler(struct work_struct *work)
+{
+	struct cx23885_dev *dev =
+			   container_of(work, struct cx23885_dev, cx25840_work);
+	bool handled;
+
+	v4l2_subdev_call(dev->sd_cx25840, core, interrupt_service_routine,
+			 PCI_MSK_AV_CORE, &handled);
+	cx23885_irq_enable(dev, PCI_MSK_AV_CORE);
+}
diff --git a/drivers/media/video/cx23885/cx23885-av.h b/drivers/media/video/cx23885/cx23885-av.h
new file mode 100644
index 0000000..d2915c3
--- /dev/null
+++ b/drivers/media/video/cx23885/cx23885-av.h
@@ -0,0 +1,27 @@
+/*
+ *  Driver for the Conexant CX23885/7/8 PCIe bridge
+ *
+ *  AV device support routines - non-input, non-vl42_subdev routines
+ *
+ *  Copyright (C) 2010  Andy Walls <awalls@md.metrocast.net>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ *  02110-1301, USA.
+ */
+
+#ifndef _CX23885_AV_H_
+#define _CX23885_AV_H_
+void cx23885_av_work_handler(struct work_struct *work);
+#endif
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index fa2f4b1..4f3cd79 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -34,6 +34,7 @@
 #include "cimax2.h"
 #include "cx23888-ir.h"
 #include "cx23885-ir.h"
+#include "cx23885-av.h"
 #include "cx23885-input.h"
 
 MODULE_DESCRIPTION("Driver for cx23885 based TV cards");
@@ -1856,13 +1857,13 @@ static irqreturn_t cx23885_irq(int irq, void *dev_id)
 			handled++;
 	}
 
-	if (pci_status & PCI_MSK_AV_CORE) {
-		subdev_handled = false;
-		v4l2_subdev_call(dev->sd_cx25840,
-				 core, interrupt_service_routine,
-				 pci_status, &subdev_handled);
-		if (subdev_handled)
-			handled++;
+	if ((pci_status & pci_mask) & PCI_MSK_AV_CORE) {
+		cx23885_irq_disable(dev, PCI_MSK_AV_CORE);
+		if (!schedule_work(&dev->cx25840_work))
+			printk(KERN_ERR "%s: failed to set up deferred work for"
+			       " AV Core/IR interrupt. Interrupt is disabled"
+			       " and won't be re-enabled\n", dev->name);
+		handled++;
 	}
 
 	if (handled)
@@ -1882,11 +1883,11 @@ static void cx23885_v4l2_dev_notify(struct v4l2_subdev *sd,
 	dev = to_cx23885(sd->v4l2_dev);
 
 	switch (notification) {
-	case V4L2_SUBDEV_IR_RX_NOTIFY: /* Called in an IRQ context */
+	case V4L2_SUBDEV_IR_RX_NOTIFY: /* Possibly called in an IRQ context */
 		if (sd == dev->sd_ir)
 			cx23885_ir_rx_v4l2_dev_notify(sd, *(u32 *)arg);
 		break;
-	case V4L2_SUBDEV_IR_TX_NOTIFY: /* Called in an IRQ context */
+	case V4L2_SUBDEV_IR_TX_NOTIFY: /* Possibly called in an IRQ context */
 		if (sd == dev->sd_ir)
 			cx23885_ir_tx_v4l2_dev_notify(sd, *(u32 *)arg);
 		break;
@@ -1895,6 +1896,7 @@ static void cx23885_v4l2_dev_notify(struct v4l2_subdev *sd,
 
 static void cx23885_v4l2_dev_notify_init(struct cx23885_dev *dev)
 {
+	INIT_WORK(&dev->cx25840_work, cx23885_av_work_handler);
 	INIT_WORK(&dev->ir_rx_work, cx23885_ir_rx_work_handler);
 	INIT_WORK(&dev->ir_tx_work, cx23885_ir_tx_work_handler);
 	dev->v4l2_dev.notify = cx23885_v4l2_dev_notify;
diff --git a/drivers/media/video/cx23885/cx23885-ir.c b/drivers/media/video/cx23885/cx23885-ir.c
index 6ceabd4..7125247 100644
--- a/drivers/media/video/cx23885/cx23885-ir.c
+++ b/drivers/media/video/cx23885/cx23885-ir.c
@@ -72,7 +72,7 @@ void cx23885_ir_tx_work_handler(struct work_struct *work)
 
 }
 
-/* Called in an IRQ context */
+/* Possibly called in an IRQ context */
 void cx23885_ir_rx_v4l2_dev_notify(struct v4l2_subdev *sd, u32 events)
 {
 	struct cx23885_dev *dev = to_cx23885(sd->v4l2_dev);
@@ -86,10 +86,18 @@ void cx23885_ir_rx_v4l2_dev_notify(struct v4l2_subdev *sd, u32 events)
 		set_bit(CX23885_IR_RX_HW_FIFO_OVERRUN, notifications);
 	if (events & V4L2_SUBDEV_IR_RX_SW_FIFO_OVERRUN)
 		set_bit(CX23885_IR_RX_SW_FIFO_OVERRUN, notifications);
-	schedule_work(&dev->ir_rx_work);
+
+	/*
+	 * For the integrated AV core, we are already in a workqueue context.
+	 * For the CX23888 integrated IR, we are in an interrupt context.
+	 */
+	if (sd == dev->sd_cx25840)
+		cx23885_ir_rx_work_handler(&dev->ir_rx_work);
+	else
+		schedule_work(&dev->ir_rx_work);
 }
 
-/* Called in an IRQ context */
+/* Possibly called in an IRQ context */
 void cx23885_ir_tx_v4l2_dev_notify(struct v4l2_subdev *sd, u32 events)
 {
 	struct cx23885_dev *dev = to_cx23885(sd->v4l2_dev);
@@ -97,5 +105,13 @@ void cx23885_ir_tx_v4l2_dev_notify(struct v4l2_subdev *sd, u32 events)
 
 	if (events & V4L2_SUBDEV_IR_TX_FIFO_SERVICE_REQ)
 		set_bit(CX23885_IR_TX_FIFO_SERVICE_REQ, notifications);
-	schedule_work(&dev->ir_tx_work);
+
+	/*
+	 * For the integrated AV core, we are already in a workqueue context.
+	 * For the CX23888 integrated IR, we are in an interrupt context.
+	 */
+	if (sd == dev->sd_cx25840)
+		cx23885_ir_tx_work_handler(&dev->ir_tx_work);
+	else
+		schedule_work(&dev->ir_tx_work);
 }
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index 5bf6ed0..ed94b17 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -366,6 +366,7 @@ struct cx23885_dev {
 	unsigned char              radio_addr;
 	unsigned int               has_radio;
 	struct v4l2_subdev 	   *sd_cx25840;
+	struct work_struct	   cx25840_work;
 
 	/* Infrared */
 	struct v4l2_subdev         *sd_ir;
-- 
1.7.1.1


