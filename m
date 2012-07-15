Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:39807 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab2GORiw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jul 2012 13:38:52 -0400
From: Sean Young <sean@mess.org>
To: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Cc: lirc-list@lists.sourceforge.net, Sean Young <sean@mess.org>
Subject: [PATCH] Minor cleanups for MCE USB.
Date: Sun, 15 Jul 2012 18:31:31 +0100
Message-Id: <1342373491-25709-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/mceusb.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index e150a2e..1af0b0c 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -410,14 +410,12 @@ struct mceusb_dev {
 	/* usb */
 	struct usb_device *usbdev;
 	struct urb *urb_in;
-	struct usb_endpoint_descriptor *usb_ep_in;
 	struct usb_endpoint_descriptor *usb_ep_out;
 
 	/* buffers and dma */
 	unsigned char *buf_in;
 	unsigned int len_in;
 	dma_addr_t dma_in;
-	dma_addr_t dma_out;
 
 	enum {
 		CMD_HEADER = 0,
@@ -687,7 +685,7 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 		dev_info(dev, "Raw IR data, %d pulse/space samples\n", ir->rem);
 }
 
-static void mce_async_callback(struct urb *urb, struct pt_regs *regs)
+static void mce_async_callback(struct urb *urb)
 {
 	struct mceusb_dev *ir;
 	int len;
@@ -734,7 +732,7 @@ static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
 		pipe = usb_sndintpipe(ir->usbdev,
 				      ir->usb_ep_out->bEndpointAddress);
 		usb_fill_int_urb(async_urb, ir->usbdev, pipe,
-			async_buf, size, (usb_complete_t)mce_async_callback,
+			async_buf, size, mce_async_callback,
 			ir, ir->usb_ep_out->bInterval);
 		memcpy(async_buf, data, size);
 
@@ -1032,7 +1030,7 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 	ir_raw_event_handle(ir->rc);
 }
 
-static void mceusb_dev_recv(struct urb *urb, struct pt_regs *regs)
+static void mceusb_dev_recv(struct urb *urb)
 {
 	struct mceusb_dev *ir;
 	int buf_len;
@@ -1332,7 +1330,6 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	ir->model = model;
 
 	/* Saving usb interface data for use by the transmitter routine */
-	ir->usb_ep_in = ep_in;
 	ir->usb_ep_out = ep_out;
 
 	if (dev->descriptor.iManufacturer
@@ -1350,8 +1347,8 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 		goto rc_dev_fail;
 
 	/* wire up inbound data handler */
-	usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in,
-		maxp, (usb_complete_t) mceusb_dev_recv, ir, ep_in->bInterval);
+	usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
+				mceusb_dev_recv, ir, ep_in->bInterval);
 	ir->urb_in->transfer_dma = ir->dma_in;
 	ir->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
-- 
1.7.2.5

