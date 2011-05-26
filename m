Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:20431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab1EZVcU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 17:32:20 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4QLWKUH010074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 26 May 2011 17:32:20 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] [media] mceusb: mce_sync_in is brain-dead
Date: Thu, 26 May 2011 17:32:16 -0400
Message-Id: <1306445536-17991-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Aside from the initial "hey, lets make sure we've flushed any
pre-existing data on the device" call to mce_sync_in, every other one of
the calls was entirely superfluous. Ergo, remove them all, and rename
the one and only (questionably) useful one to reflect what it really
does. Verified on both gen2 and gen3 hardware to make zero difference.
Well, except that you no longer get a bunch of urb submit failures from
the unneeded mce_sync_in calls. Oh. And move that flush to a point
*after* we've wired up the inbound urb, or it won't do squat. I have
half a mind to just remove it entirely, but someone thought it was
necessary at some point, and it doesn't seem to hurt, so lets leave it
for the time being.

This excercise took place due to insightful questions asked by Hans
Petter Selasky, about the possible reuse of the inbound urb before it
was actually availble by mce_sync_in, so thanks to him for motivating
this cleanup.

Reported-by: Hans Petter Selasky <hselasky@c2i.net>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |   30 +++++++-----------------------
 1 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 3c4fb7d..06dfe09 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -685,9 +685,9 @@ static void mce_async_out(struct mceusb_dev *ir, unsigned char *data, int size)
 	mce_request_packet(ir, data, size, MCEUSB_TX);
 }
 
-static void mce_sync_in(struct mceusb_dev *ir, unsigned char *data, int size)
+static void mce_flush_rx_buffer(struct mceusb_dev *ir, int size)
 {
-	mce_request_packet(ir, data, size, MCEUSB_RX);
+	mce_request_packet(ir, NULL, size, MCEUSB_RX);
 }
 
 /* Send data out the IR blaster port(s) */
@@ -973,7 +973,6 @@ static void mceusb_dev_recv(struct urb *urb, struct pt_regs *regs)
 static void mceusb_gen1_init(struct mceusb_dev *ir)
 {
 	int ret;
-	int maxp = ir->len_in;
 	struct device *dev = ir->dev;
 	char *data;
 
@@ -1015,55 +1014,40 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 
 	/* device reset */
 	mce_async_out(ir, DEVICE_RESET, sizeof(DEVICE_RESET));
-	mce_sync_in(ir, NULL, maxp);
 
 	/* get hw/sw revision? */
 	mce_async_out(ir, GET_REVISION, sizeof(GET_REVISION));
-	mce_sync_in(ir, NULL, maxp);
 
 	kfree(data);
 };
 
 static void mceusb_gen2_init(struct mceusb_dev *ir)
 {
-	int maxp = ir->len_in;
-
 	/* device reset */
 	mce_async_out(ir, DEVICE_RESET, sizeof(DEVICE_RESET));
-	mce_sync_in(ir, NULL, maxp);
 
 	/* get hw/sw revision? */
 	mce_async_out(ir, GET_REVISION, sizeof(GET_REVISION));
-	mce_sync_in(ir, NULL, maxp);
 
 	/* unknown what the next two actually return... */
 	mce_async_out(ir, GET_UNKNOWN, sizeof(GET_UNKNOWN));
-	mce_sync_in(ir, NULL, maxp);
 	mce_async_out(ir, GET_UNKNOWN2, sizeof(GET_UNKNOWN2));
-	mce_sync_in(ir, NULL, maxp);
 }
 
 static void mceusb_get_parameters(struct mceusb_dev *ir)
 {
-	int maxp = ir->len_in;
-
 	/* get the carrier and frequency */
 	mce_async_out(ir, GET_CARRIER_FREQ, sizeof(GET_CARRIER_FREQ));
-	mce_sync_in(ir, NULL, maxp);
 
-	if (!ir->flags.no_tx) {
+	if (!ir->flags.no_tx)
 		/* get the transmitter bitmask */
 		mce_async_out(ir, GET_TX_BITMASK, sizeof(GET_TX_BITMASK));
-		mce_sync_in(ir, NULL, maxp);
-	}
 
 	/* get receiver timeout value */
 	mce_async_out(ir, GET_RX_TIMEOUT, sizeof(GET_RX_TIMEOUT));
-	mce_sync_in(ir, NULL, maxp);
 
 	/* get receiver sensor setting */
 	mce_async_out(ir, GET_RX_SENSOR, sizeof(GET_RX_SENSOR));
-	mce_sync_in(ir, NULL, maxp);
 }
 
 static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
@@ -1227,16 +1211,16 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	if (!ir->rc)
 		goto rc_dev_fail;
 
-	/* flush buffers on the device */
-	mce_sync_in(ir, NULL, maxp);
-	mce_sync_in(ir, NULL, maxp);
-
 	/* wire up inbound data handler */
 	usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in,
 		maxp, (usb_complete_t) mceusb_dev_recv, ir, ep_in->bInterval);
 	ir->urb_in->transfer_dma = ir->dma_in;
 	ir->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
+	/* flush buffers on the device */
+	mce_dbg(&intf->dev, "Flushing receive buffers\n");
+	mce_flush_rx_buffer(ir, maxp);
+
 	/* initialize device */
 	if (ir->flags.microsoft_gen1)
 		mceusb_gen1_init(ir);
-- 
1.7.1

