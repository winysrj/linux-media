Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756234Ab0GBDi4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Jul 2010 23:38:56 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o623cugT015049
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 1 Jul 2010 23:38:56 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o623ctVN014719
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 1 Jul 2010 23:38:55 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o623cs0F027515
	for <linux-media@vger.kernel.org>; Thu, 1 Jul 2010 23:38:54 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o623csEM027514
	for linux-media@vger.kernel.org; Thu, 1 Jul 2010 23:38:54 -0400
Date: Thu, 1 Jul 2010 23:38:54 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 2/2] IR/mceusb: add and wire up tx callback functions
Message-ID: <20100702033854.GC27368@redhat.com>
References: <20100702033702.GA27368@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100702033702.GA27368@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v2: userspace buffer copy moved out of driver and into lirc bridge
driver

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/mceusb.c |  148 ++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 138 insertions(+), 10 deletions(-)

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index f3c736c..c6c0375 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -15,10 +15,6 @@
  * Jon Smirl, which included enhancements and simplifications to the
  * incoming IR buffer parsing routines.
  *
- * TODO:
- * - add rc-core transmit support, once available
- * - enable support for forthcoming ir-lirc-codec interface
- *
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -51,7 +47,6 @@
 #define DRIVER_NAME	"mceusb"
 
 #define USB_BUFLEN	32	/* USB reception buffer length */
-#define IRBUF_SIZE	256	/* IR work buffer length */
 #define USB_CTRL_MSG_SZ	2	/* Size of usb ctrl msg on gen1 hw */
 #define MCE_G1_INIT_MSGS 40	/* Init messages on gen1 hw to throw out */
 
@@ -263,14 +258,13 @@ struct mceusb_dev {
 		u32 reserved:28;
 	} flags;
 
-	/* handle sending (init strings) */
+	/* transmit support */
 	int send_flags;
-	int carrier;
+	u32 carrier;
+	unsigned char tx_mask;
 
 	char name[128];
 	char phys[64];
-
-	unsigned char tx_mask;
 };
 
 /*
@@ -520,6 +514,91 @@ static void mce_sync_in(struct mceusb_dev *ir, unsigned char *data, int size)
 	mce_request_packet(ir, ir->usb_ep_in, data, size, MCEUSB_RX);
 }
 
+/* Send data out the IR blaster port(s) */
+static int mceusb_tx_ir(void *priv, int *txbuf, u32 n)
+{
+	struct mceusb_dev *ir = priv;
+	int i, ret = 0;
+	int count, cmdcount = 0;
+	unsigned char *cmdbuf; /* MCE command buffer */
+	long signal_duration = 0; /* Singnal length in us */
+	struct timeval start_time, end_time;
+
+	do_gettimeofday(&start_time);
+
+	count = n / sizeof(int);
+
+	cmdbuf = kzalloc(sizeof(int) * MCE_CMDBUF_SIZE, GFP_KERNEL);
+	if (!cmdbuf)
+		return -ENOMEM;
+
+	/* MCE tx init header */
+	cmdbuf[cmdcount++] = MCE_CONTROL_HEADER;
+	cmdbuf[cmdcount++] = 0x08;
+	cmdbuf[cmdcount++] = ir->tx_mask;
+
+	/* Generate mce packet data */
+	for (i = 0; (i < count) && (cmdcount < MCE_CMDBUF_SIZE); i++) {
+		signal_duration += txbuf[i];
+		txbuf[i] = txbuf[i] / MCE_TIME_UNIT;
+
+		do { /* loop to support long pulses/spaces > 127*50us=6.35ms */
+
+			/* Insert mce packet header every 4th entry */
+			if ((cmdcount < MCE_CMDBUF_SIZE) &&
+			    (cmdcount - MCE_TX_HEADER_LENGTH) %
+			     MCE_CODE_LENGTH == 0)
+				cmdbuf[cmdcount++] = MCE_PACKET_HEADER;
+
+			/* Insert mce packet data */
+			if (cmdcount < MCE_CMDBUF_SIZE)
+				cmdbuf[cmdcount++] =
+					(txbuf[i] < MCE_PULSE_BIT ?
+					 txbuf[i] : MCE_MAX_PULSE_LENGTH) |
+					 (i & 1 ? 0x00 : MCE_PULSE_BIT);
+			else {
+				ret = -EINVAL;
+				goto out;
+			}
+
+		} while ((txbuf[i] > MCE_MAX_PULSE_LENGTH) &&
+			 (txbuf[i] -= MCE_MAX_PULSE_LENGTH));
+	}
+
+	/* Fix packet length in last header */
+	cmdbuf[cmdcount - (cmdcount - MCE_TX_HEADER_LENGTH) % MCE_CODE_LENGTH] =
+		0x80 + (cmdcount - MCE_TX_HEADER_LENGTH) % MCE_CODE_LENGTH - 1;
+
+	/* Check if we have room for the empty packet at the end */
+	if (cmdcount >= MCE_CMDBUF_SIZE) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* All mce commands end with an empty packet (0x80) */
+	cmdbuf[cmdcount++] = 0x80;
+
+	/* Transmit the command to the mce device */
+	mce_async_out(ir, cmdbuf, cmdcount);
+
+	/*
+	 * The lircd gap calculation expects the write function to
+	 * wait the time it takes for the ircommand to be sent before
+	 * it returns.
+	 */
+	do_gettimeofday(&end_time);
+	signal_duration -= (end_time.tv_usec - start_time.tv_usec) +
+			   (end_time.tv_sec - start_time.tv_sec) * 1000000;
+
+	/* delay with the closest number of ticks */
+	set_current_state(TASK_INTERRUPTIBLE);
+	schedule_timeout(usecs_to_jiffies(signal_duration));
+
+out:
+	kfree(cmdbuf);
+	return ret ? ret : n;
+}
+
 /* Sets active IR outputs -- mce devices typically (all?) have two */
 static int mceusb_set_tx_mask(void *priv, u32 mask)
 {
@@ -533,6 +612,49 @@ static int mceusb_set_tx_mask(void *priv, u32 mask)
 	return 0;
 }
 
+/* Sets the send carrier frequency and mode */
+static int mceusb_set_tx_carrier(void *priv, u32 carrier)
+{
+	struct mceusb_dev *ir = priv;
+	int clk = 10000000;
+	int prescaler = 0, divisor = 0;
+	unsigned char cmdbuf[4] = { 0x9f, 0x06, 0x00, 0x00 };
+
+	/* Carrier has changed */
+	if (ir->carrier != carrier) {
+
+		if (carrier == 0) {
+			ir->carrier = carrier;
+			cmdbuf[2] = 0x01;
+			cmdbuf[3] = 0x80;
+			dev_dbg(ir->dev, "%s: disabling carrier "
+				"modulation\n", __func__);
+			mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
+			return carrier;
+		}
+
+		for (prescaler = 0; prescaler < 4; ++prescaler) {
+			divisor = (clk >> (2 * prescaler)) / carrier;
+			if (divisor <= 0xFF) {
+				ir->carrier = carrier;
+				cmdbuf[2] = prescaler;
+				cmdbuf[3] = divisor;
+				dev_dbg(ir->dev, "%s: requesting %u HZ "
+					"carrier\n", __func__, carrier);
+
+				/* Transmit new carrier to mce device */
+				mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
+				return carrier;
+			}
+		}
+
+		return -EINVAL;
+
+	}
+
+	return carrier;
+}
+
 static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 {
 	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
@@ -752,6 +874,9 @@ static void mceusb_gen3_init(struct mceusb_dev *ir)
 	mce_sync_in(ir, NULL, maxp);
 	mce_sync_in(ir, NULL, maxp);
 
+	set_current_state(TASK_INTERRUPTIBLE);
+	schedule_timeout(msecs_to_jiffies(100));
+
 	/* device reset */
 	mce_async_out(ir, DEVICE_RESET, sizeof(DEVICE_RESET));
 	mce_sync_in(ir, NULL, maxp);
@@ -804,7 +929,7 @@ static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
 		goto ir_dev_alloc_failed;
 	}
 
-	snprintf(ir->name, sizeof(ir->name), "Media Center Edition eHome "
+	snprintf(ir->name, sizeof(ir->name), "Media Center Ed. eHome "
 		 "Infrared Remote Transceiver (%04x:%04x)",
 		 le16_to_cpu(ir->usbdev->descriptor.idVendor),
 		 le16_to_cpu(ir->usbdev->descriptor.idProduct));
@@ -817,6 +942,9 @@ static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
 	props->priv = ir;
 	props->driver_type = RC_DRIVER_IR_RAW;
 	props->allowed_protos = IR_TYPE_ALL;
+	props->s_tx_mask = mceusb_set_tx_mask;
+	props->s_tx_carrier = mceusb_set_tx_carrier;
+	props->tx_ir = mceusb_tx_ir;
 
 	ir->props = props;
 	ir->irdev = irdev;
-- 
1.7.0.1


-- 
Jarod Wilson
jarod@redhat.com

