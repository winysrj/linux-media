Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:46325 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbaDWPFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 11:05:24 -0400
Received: by mail-oa0-f54.google.com with SMTP id i7so1166784oag.27
        for <linux-media@vger.kernel.org>; Wed, 23 Apr 2014 08:05:24 -0700 (PDT)
Message-ID: <5357D6A4.4070008@gmail.com>
Date: Wed, 23 Apr 2014 10:05:08 -0500
From: Matt DeVillier <matt.devillier@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: [PATCH  v2] fix mceusb endpoint type identification/handling
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Matt DeVillier <matt.devillier@gmail.com>

Change the I/O endpoint handling of the mceusb driver to respect the endpoint 
type reported by device (bulk/interrupt), rather than treating all endpoints 
as type interrupt, which breaks devices using bulk endpoints when connected 
to a xhci controller.  Accordingly, change the function calls to initialize 
an endpoint's transfer pipe and urb handlers to use the correct function based 
on the endpoint type.

Signed-off-by: Matt DeVillier <matt.devillier@gmail.com>
Tested-by: Sean Young <sean@mess.org>
---
This is a continuation of the work started in patch #21648
Patch compiled and tested against linux-media git master. Backported and tested 
against 3.14.1 stable as well.
v2 corrects some formatting issues (both with the patch itself and MUA), and 
removes a small bug fix not relevant to the core patch functionality.
---
diff -up mceusb.c{.orig,}
--- mceusb.c.orig	2014-04-22 13:48:51.186259472 -0500
+++ mceusb.c	2014-04-23 09:51:50.060107612 -0500
@@ -747,11 +747,19 @@ static void mce_request_packet(struct mc
		}

		/* outbound data */
-		pipe = usb_sndintpipe(ir->usbdev,
-				      ir->usb_ep_out->bEndpointAddress);
-		usb_fill_int_urb(async_urb, ir->usbdev, pipe,
-			async_buf, size, mce_async_callback,
-			ir, ir->usb_ep_out->bInterval);
+		if ((ir->usb_ep_out->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+			== USB_ENDPOINT_XFER_INT) {
+			pipe = usb_sndintpipe(ir->usbdev,
+					 ir->usb_ep_out->bEndpointAddress);
+			usb_fill_int_urb(async_urb, ir->usbdev, pipe, async_buf,
+					 size, mce_async_callback, ir,
+					 ir->usb_ep_out->bInterval);
+		} else {
+			pipe = usb_sndbulkpipe(ir->usbdev,
+					 ir->usb_ep_out->bEndpointAddress);
+			usb_fill_bulk_urb(async_urb, ir->usbdev, pipe, async_buf,
+					 size, mce_async_callback, ir);
+		}
		memcpy(async_buf, data, size);

	} else if (urb_type == MCEUSB_RX) {
@@ -1271,38 +1279,47 @@ static int mceusb_dev_probe(struct usb_i

		if ((ep_in == NULL)
			&& ((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
-			    == USB_DIR_IN)
-			&& (((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
-			    == USB_ENDPOINT_XFER_BULK)
-			|| ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
-			    == USB_ENDPOINT_XFER_INT))) {
-
-			ep_in = ep;
-			ep_in->bmAttributes = USB_ENDPOINT_XFER_INT;
-			ep_in->bInterval = 1;
-			dev_dbg(&intf->dev, "acceptable inbound endpoint found");
+			== USB_DIR_IN)) {
+
+			if ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+				== USB_ENDPOINT_XFER_BULK) {
+
+				ep_in = ep;
+				mce_dbg(&intf->dev, "acceptable bulk inbound endpoint found\n");
+			} else if ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+				== USB_ENDPOINT_XFER_INT) {
+
+				ep_in = ep;
+				ep_in->bInterval = 1;
+				mce_dbg(&intf->dev, "acceptable interrupt inbound endpoint found\n");
+			}
		}

		if ((ep_out == NULL)
			&& ((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
-			    == USB_DIR_OUT)
-			&& (((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
-			    == USB_ENDPOINT_XFER_BULK)
-			|| ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
-			    == USB_ENDPOINT_XFER_INT))) {
-
-			ep_out = ep;
-			ep_out->bmAttributes = USB_ENDPOINT_XFER_INT;
-			ep_out->bInterval = 1;
-			dev_dbg(&intf->dev, "acceptable outbound endpoint found");
+			== USB_DIR_OUT)) {
+			if ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+				== USB_ENDPOINT_XFER_BULK) {
+				ep_out = ep;
+				mce_dbg(&intf->dev, "acceptable bulk outbound endpoint found\n");
+			} else if ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+				== USB_ENDPOINT_XFER_INT) {
+				ep_out = ep;
+				ep_out->bInterval = 1;
+				mce_dbg(&intf->dev, "acceptable interrupt outbound endpoint found\n");
+			}
		}
-	}
	if (ep_in == NULL) {
		dev_dbg(&intf->dev, "inbound and/or endpoint not found");
		return -ENODEV;
	}

-	pipe = usb_rcvintpipe(dev, ep_in->bEndpointAddress);
+	if ((ep_in->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+		== USB_ENDPOINT_XFER_INT) {
+		pipe = usb_rcvintpipe(dev, ep_in->bEndpointAddress);
+	} else {
+		pipe = usb_rcvbulkpipe(dev, ep_in->bEndpointAddress);
+	}
	maxp = usb_maxpacket(dev, pipe, usb_pipeout(pipe));

	ir = kzalloc(sizeof(struct mceusb_dev), GFP_KERNEL);
@@ -1343,8 +1360,14 @@ static int mceusb_dev_probe(struct usb_i
		goto rc_dev_fail;

	/* wire up inbound data handler */
-	usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
-				mceusb_dev_recv, ir, ep_in->bInterval);
+	if ((ep_in->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+		== USB_ENDPOINT_XFER_INT) {
+		usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
+				 mceusb_dev_recv, ir, ep_in->bInterval);
+	} else {
+		usb_fill_bulk_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
+				 mceusb_dev_recv, ir);
+	}
	ir->urb_in->transfer_dma = ir->dma_in;
	ir->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;


