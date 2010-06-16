Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759658Ab0FPUzy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jun 2010 16:55:54 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o5GKtrUv014195
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 16 Jun 2010 16:55:54 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o5GKtqTO006019
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 16 Jun 2010 16:55:53 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o5GKtqCv018755
	for <linux-media@vger.kernel.org>; Wed, 16 Jun 2010 16:55:52 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o5GKtqYi018754
	for linux-media@vger.kernel.org; Wed, 16 Jun 2010 16:55:52 -0400
Date: Wed, 16 Jun 2010 16:55:52 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] IR/mceusb: add tx callback functions and wire up
Message-ID: <20100616205552.GB18723@redhat.com>
References: <20100616205044.GA18486@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616205044.GA18486@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/mceusb.c |  141 ++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 132 insertions(+), 9 deletions(-)

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index 708a71a..aaa40d8 100644
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
@@ -263,14 +259,13 @@ struct mceusb_dev {
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
@@ -520,6 +515,88 @@ static void mce_sync_in(struct mceusb_dev *ir, unsigned char *data, int size)
 	mce_request_packet(ir, ir->usb_ep_in, data, size, MCEUSB_RX);
 }
 
+/* Send data out the IR blaster port(s) */
+static int mceusb_tx_ir(void *priv, const char *buf, u32 n)
+{
+	struct mceusb_dev *ir = priv;
+	int i, count = 0, cmdcount = 0;
+	int wbuf[IRBUF_SIZE]; /* Workbuffer with values to tx */
+	unsigned char cmdbuf[MCE_CMDBUF_SIZE]; /* MCE command buffer */
+	unsigned long signal_duration = 0; /* Singnal length in us */
+	struct timeval start_time, end_time;
+
+	do_gettimeofday(&start_time);
+
+	if (n % sizeof(int))
+		return -EINVAL;
+	count = n / sizeof(int);
+
+	/* Check if command is within limits */
+	if (count > IRBUF_SIZE || count % 2 == 0)
+		return -EINVAL;
+	if (copy_from_user(wbuf, buf, n))
+		return -EFAULT;
+
+	/* MCE tx init header */
+	cmdbuf[cmdcount++] = MCE_CONTROL_HEADER;
+	cmdbuf[cmdcount++] = 0x08;
+	cmdbuf[cmdcount++] = ir->tx_mask;
+
+	/* Generate mce packet data */
+	for (i = 0; (i < count) && (cmdcount < MCE_CMDBUF_SIZE); i++) {
+		signal_duration += wbuf[i];
+		wbuf[i] = wbuf[i] / MCE_TIME_UNIT;
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
+					(wbuf[i] < MCE_PULSE_BIT ?
+					 wbuf[i] : MCE_MAX_PULSE_LENGTH) |
+					 (i & 1 ? 0x00 : MCE_PULSE_BIT);
+			else
+				return -EINVAL;
+		} while ((wbuf[i] > MCE_MAX_PULSE_LENGTH) &&
+			 (wbuf[i] -= MCE_MAX_PULSE_LENGTH));
+	}
+
+	/* Fix packet length in last header */
+	cmdbuf[cmdcount - (cmdcount - MCE_TX_HEADER_LENGTH) % MCE_CODE_LENGTH] =
+		0x80 + (cmdcount - MCE_TX_HEADER_LENGTH) % MCE_CODE_LENGTH - 1;
+
+	/* Check if we have room for the empty packet at the end */
+	if (cmdcount >= MCE_CMDBUF_SIZE)
+		return -EINVAL;
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
+	return n;
+}
+
 /* Sets active IR outputs -- mce devices typically (all?) have two */
 static int mceusb_set_tx_mask(void *priv, u32 mask)
 {
@@ -533,6 +610,49 @@ static int mceusb_set_tx_mask(void *priv, u32 mask)
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
@@ -791,7 +911,7 @@ static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
 		goto ir_dev_alloc_failed;
 	}
 
-	snprintf(ir->name, sizeof(ir->name), "Media Center Edition eHome "
+	snprintf(ir->name, sizeof(ir->name), "Media Center Ed. eHome "
 		 "Infrared Remote Transceiver (%04x:%04x)",
 		 le16_to_cpu(ir->usbdev->descriptor.idVendor),
 		 le16_to_cpu(ir->usbdev->descriptor.idProduct));
@@ -804,6 +924,9 @@ static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
 	props->priv = ir;
 	props->driver_type = RC_DRIVER_IR_RAW;
 	props->allowed_protos = IR_TYPE_ALL;
+	props->s_tx_mask = mceusb_set_tx_mask;
+	props->s_tx_carrier = mceusb_set_tx_carrier;
+	props->tx_ir = mceusb_tx_ir;
 
 	ir->props = props;
 	ir->irdev = irdev;
-- 
1.6.5.2


-- 
Jarod Wilson
jarod@redhat.com

