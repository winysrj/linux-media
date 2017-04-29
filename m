Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-ch2-06v.sys.comcast.net ([69.252.207.38]:43724 "EHLO
        resqmta-ch2-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1426098AbdD2QFy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Apr 2017 12:05:54 -0400
From: A Sun <as1033x@comcast.net>
Subject: [PATCH 1/1] [media] mceusb: coding style & comments update for -EPIPE
 error patches
To: Sean Young <sean@mess.org>
References: <58EEC1CB.7030806@comcast.net> <58EF3197.9060707@comcast.net>
 <20170427205424.GA18688@gofer.mess.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Message-ID: <5904B9C2.4000404@comcast.net>
Date: Sat, 29 Apr 2017 12:05:22 -0400
MIME-Version: 1.0
In-Reply-To: <20170427205424.GA18688@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Cosmetic updates to recent code revisions for better compliance with
https://www.kernel.org/doc/html/latest/process/coding-style.html

This patch depends on an earlier (marked accepted) patch:
  [PATCH v2] [media] mceusb: TX -EPIPE (urb status = -32) lockup fix

Signed-off-by: A Sun <as1033x@comcast.net>
---
 drivers/media/rc/mceusb.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index af46860..66d0be5 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -457,8 +457,11 @@ struct mceusb_dev {
 	u8 txports_cabled;	/* bitmask of transmitters with cable */
 	u8 rxports_active;	/* bitmask of active receive sensors */
 
-	/* async error handler mceusb_deferred_kevent() support
-	 * via workqueue kworker (previously keventd) threads */
+	/*
+	 * support for async error handler mceusb_deferred_kevent()
+	 * where usb_clear_halt(), usb_reset_configuration(),
+	 * usb_reset_device(), etc. must be done in process context
+	 */
 	struct work_struct kevent;
 	unsigned long kevent_flags;
 #		define EVENT_TX_HALT	0
@@ -705,11 +708,10 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 static void mceusb_defer_kevent(struct mceusb_dev *ir, int kevent)
 {
 	set_bit(kevent, &ir->kevent_flags);
-	if (!schedule_work(&ir->kevent)) {
+	if (!schedule_work(&ir->kevent))
 		dev_err(ir->dev, "kevent %d may have been dropped", kevent);
-	} else {
+	else
 		dev_dbg(ir->dev, "kevent %d scheduled", kevent);
-	}
 }
 
 static void mce_async_callback(struct urb *urb)
@@ -775,14 +777,13 @@ static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
 	}
 
 	/* outbound data */
-	if (usb_endpoint_xfer_int(ir->usb_ep_out)) {
+	if (usb_endpoint_xfer_int(ir->usb_ep_out))
 		usb_fill_int_urb(async_urb, ir->usbdev, ir->pipe_out,
 				 async_buf, size, mce_async_callback, ir,
 				 ir->usb_ep_out->bInterval);
-	} else {
+	else
 		usb_fill_bulk_urb(async_urb, ir->usbdev, ir->pipe_out,
 				 async_buf, size, mce_async_callback, ir);
-	}
 	memcpy(async_buf, data, size);
 
 	dev_dbg(dev, "send request called (size=%#x)", size);
@@ -1225,13 +1226,12 @@ static void mceusb_deferred_kevent(struct work_struct *work)
 		}
 		clear_bit(EVENT_RX_HALT, &ir->kevent_flags);
 		status = usb_submit_urb(ir->urb_in, GFP_KERNEL);
-		if (status < 0) {
+		if (status < 0)
 			dev_err(ir->dev, "rx unhalt submit urb error %d",
 				status);
-			goto done_rx_halt;
-		}
 	}
 done_rx_halt:
+
 	if (test_bit(EVENT_TX_HALT, &ir->kevent_flags)) {
 		status = usb_clear_halt(ir->usbdev, ir->pipe_out);
 		if (status < 0) {
@@ -1242,6 +1242,7 @@ static void mceusb_deferred_kevent(struct work_struct *work)
 		clear_bit(EVENT_TX_HALT, &ir->kevent_flags);
 	}
 done_tx_halt:
+
 	return;
 }
 
@@ -1397,13 +1398,12 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 
 	/* Saving usb interface data for use by the transmitter routine */
 	ir->usb_ep_out = ep_out;
-	if (usb_endpoint_xfer_int(ir->usb_ep_out)) {
+	if (usb_endpoint_xfer_int(ir->usb_ep_out))
 		ir->pipe_out = usb_sndintpipe(ir->usbdev,
 					ir->usb_ep_out->bEndpointAddress);
-	} else {
+	else
 		ir->pipe_out = usb_sndbulkpipe(ir->usbdev,
 					ir->usb_ep_out->bEndpointAddress);
-	}
 
 	if (dev->descriptor.iManufacturer
 	    && usb_string(dev, dev->descriptor.iManufacturer,
@@ -1415,8 +1415,10 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 		snprintf(name + strlen(name), sizeof(name) - strlen(name),
 			 " %s", buf);
 
-	/* initialize async USB error handler before registering
-	 * or activating any mceusb RX and TX functions */
+	/*
+	 * async USB error handler must initialize before registering
+	 * or activating any mceusb RX or TX functions
+	 */
 	INIT_WORK(&ir->kevent, mceusb_deferred_kevent);
 
 	ir->rc = mceusb_init_rc_dev(ir);
@@ -1424,13 +1426,12 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 		goto rc_dev_fail;
 
 	/* wire up inbound data handler */
-	if (usb_endpoint_xfer_int(ep_in)) {
+	if (usb_endpoint_xfer_int(ep_in))
 		usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
 				mceusb_dev_recv, ir, ep_in->bInterval);
-	} else {
+	else
 		usb_fill_bulk_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
 				mceusb_dev_recv, ir);
-	}
 	ir->urb_in->transfer_dma = ir->dma_in;
 	ir->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
-- 
2.1.4
