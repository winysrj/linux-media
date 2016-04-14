Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:43611 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbcDNUmx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 16:42:53 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/2] [media] mceusb: remove pointless mce_flush_rx_buffer function
Date: Thu, 14 Apr 2016 21:42:50 +0100
Message-Id: <1460666570-26776-2-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function just submits the urb much like mceusb_dev_resume; removing
it simplifies mce_request_packet.

Also add missing usb_kill_urb to mce_dev_probe.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/mceusb.c | 77 +++++++++++++++++++----------------------------
 1 file changed, 31 insertions(+), 46 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 85823e8..18a6e6c 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -153,9 +153,6 @@
 #define MCE_COMMAND_IRDATA	0x80
 #define MCE_PACKET_LENGTH_MASK	0x1f /* Packet length mask */
 
-#define MCEUSB_RX		1
-#define MCEUSB_TX		2
-
 #define VENDOR_PHILIPS		0x0471
 #define VENDOR_SMK		0x0609
 #define VENDOR_TATUNG		0x1460
@@ -726,50 +723,40 @@ static void mce_async_callback(struct urb *urb)
 
 /* request incoming or send outgoing usb packet - used to initialize remote */
 static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
-			       int size, int urb_type)
+								int size)
 {
 	int res, pipe;
 	struct urb *async_urb;
 	struct device *dev = ir->dev;
 	unsigned char *async_buf;
 
-	if (urb_type == MCEUSB_TX) {
-		async_urb = usb_alloc_urb(0, GFP_KERNEL);
-		if (unlikely(!async_urb)) {
-			dev_err(dev, "Error, couldn't allocate urb!\n");
-			return;
-		}
-
-		async_buf = kzalloc(size, GFP_KERNEL);
-		if (!async_buf) {
-			dev_err(dev, "Error, couldn't allocate buf!\n");
-			usb_free_urb(async_urb);
-			return;
-		}
+	async_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (unlikely(!async_urb)) {
+		dev_err(dev, "Error, couldn't allocate urb!\n");
+		return;
+	}
 
-		/* outbound data */
-		if (usb_endpoint_xfer_int(ir->usb_ep_out)) {
-			pipe = usb_sndintpipe(ir->usbdev,
-					 ir->usb_ep_out->bEndpointAddress);
-			usb_fill_int_urb(async_urb, ir->usbdev, pipe, async_buf,
-					 size, mce_async_callback, ir,
-					 ir->usb_ep_out->bInterval);
-		} else {
-			pipe = usb_sndbulkpipe(ir->usbdev,
-					 ir->usb_ep_out->bEndpointAddress);
-			usb_fill_bulk_urb(async_urb, ir->usbdev, pipe,
-					 async_buf, size, mce_async_callback,
-					 ir);
-		}
-		memcpy(async_buf, data, size);
+	async_buf = kmalloc(size, GFP_KERNEL);
+	if (!async_buf) {
+		usb_free_urb(async_urb);
+		return;
+	}
 
-	} else if (urb_type == MCEUSB_RX) {
-		/* standard request */
-		async_urb = ir->urb_in;
+	/* outbound data */
+	if (usb_endpoint_xfer_int(ir->usb_ep_out)) {
+		pipe = usb_sndintpipe(ir->usbdev,
+				 ir->usb_ep_out->bEndpointAddress);
+		usb_fill_int_urb(async_urb, ir->usbdev, pipe, async_buf,
+				 size, mce_async_callback, ir,
+				 ir->usb_ep_out->bInterval);
 	} else {
-		dev_err(dev, "Error! Unknown urb type %d\n", urb_type);
-		return;
+		pipe = usb_sndbulkpipe(ir->usbdev,
+				 ir->usb_ep_out->bEndpointAddress);
+		usb_fill_bulk_urb(async_urb, ir->usbdev, pipe,
+				 async_buf, size, mce_async_callback,
+				 ir);
 	}
+	memcpy(async_buf, data, size);
 
 	dev_dbg(dev, "receive request called (size=%#x)", size);
 
@@ -790,19 +777,14 @@ static void mce_async_out(struct mceusb_dev *ir, unsigned char *data, int size)
 
 	if (ir->need_reset) {
 		ir->need_reset = false;
-		mce_request_packet(ir, DEVICE_RESUME, rsize, MCEUSB_TX);
+		mce_request_packet(ir, DEVICE_RESUME, rsize);
 		msleep(10);
 	}
 
-	mce_request_packet(ir, data, size, MCEUSB_TX);
+	mce_request_packet(ir, data, size);
 	msleep(10);
 }
 
-static void mce_flush_rx_buffer(struct mceusb_dev *ir, int size)
-{
-	mce_request_packet(ir, NULL, size, MCEUSB_RX);
-}
-
 /* Send data out the IR blaster port(s) */
 static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 {
@@ -1254,7 +1236,7 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 	struct usb_endpoint_descriptor *ep_in = NULL;
 	struct usb_endpoint_descriptor *ep_out = NULL;
 	struct mceusb_dev *ir = NULL;
-	int pipe, maxp, i;
+	int pipe, maxp, i, res;
 	char buf[63], name[128] = "";
 	enum mceusb_model_type model = id->driver_info;
 	bool is_gen3;
@@ -1357,7 +1339,9 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 
 	/* flush buffers on the device */
 	dev_dbg(&intf->dev, "Flushing receive buffers\n");
-	mce_flush_rx_buffer(ir, maxp);
+	res = usb_submit_urb(ir->urb_in, GFP_KERNEL);
+	if (res)
+		dev_err(&intf->dev, "failed to flush buffers: %d\n", res);
 
 	/* figure out which firmware/emulator version this hardware has */
 	mceusb_get_emulator_version(ir);
@@ -1392,6 +1376,7 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 	/* Error-handling path */
 rc_dev_fail:
 	usb_put_dev(ir->usbdev);
+	usb_kill_urb(ir->urb_in);
 	usb_free_urb(ir->urb_in);
 urb_in_alloc_fail:
 	usb_free_coherent(dev, maxp, ir->buf_in, ir->dma_in);
-- 
2.5.5

