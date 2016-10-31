Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:33503 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S946945AbcJaVNO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 17:13:14 -0400
Date: Mon, 31 Oct 2016 21:13:11 +0000
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, Chris Dodge <chris@redrat.co.uk>
Subject: Re: [PATCH 5/9] [media] redrat3: enable carrier reports using
 wideband receiver
Message-ID: <20161031211311.GA10866@gofer.mess.org>
References: <1477936347-9029-6-git-send-email-sean@mess.org>
 <201611010352.PDUa1g53%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201611010352.PDUa1g53%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The wideband receiver is a little awkward on the redrat3. Data arrives
on a different endpoint, and the learning command must be reissued
every time data is learned.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/redrat3.c | 186 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 140 insertions(+), 46 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index eaf374d..1882712 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -81,6 +81,8 @@
 #define RR3_RC_DET_ENABLE	0xbb
 /* Stop capture with the RC receiver */
 #define RR3_RC_DET_DISABLE	0xbc
+/* Start capture with the wideband receiver */
+#define RR3_MODSIG_CAPTURE     0xb2
 /* Return the status of RC detector capture */
 #define RR3_RC_DET_STATUS	0xbd
 /* Reset redrat */
@@ -105,8 +107,10 @@
 #define RR3_CLK_PER_COUNT	12
 /* (RR3_CLK / RR3_CLK_PER_COUNT) */
 #define RR3_CLK_CONV_FACTOR	2000000
-/* USB bulk-in IR data endpoint address */
-#define RR3_BULK_IN_EP_ADDR	0x82
+/* USB bulk-in wideband IR data endpoint address */
+#define RR3_WIDE_IN_EP_ADDR	0x81
+/* USB bulk-in narrowband IR data endpoint address */
+#define RR3_NARROW_IN_EP_ADDR	0x82
 
 /* Size of the fixed-length portion of the signal */
 #define RR3_DRIVER_MAXLENS	128
@@ -207,15 +211,22 @@ struct redrat3_dev {
 	struct urb *flash_urb;
 	u8 flash_in_buf;
 
+	/* learning */
+	bool wideband;
+	struct usb_ctrlrequest learn_control;
+	struct urb *learn_urb;
+	u8 learn_buf;
+
 	/* save off the usb device pointer */
 	struct usb_device *udev;
 
 	/* the receive endpoint */
-	struct usb_endpoint_descriptor *ep_in;
+	struct usb_endpoint_descriptor *ep_narrow;
 	/* the buffer to receive data */
 	void *bulk_in_buf;
 	/* urb used to read ir data */
-	struct urb *read_urb;
+	struct urb *narrow_urb;
+	struct urb *wide_urb;
 
 	/* the send endpoint */
 	struct usb_endpoint_descriptor *ep_out;
@@ -236,23 +247,6 @@ struct redrat3_dev {
 	char phys[64];
 };
 
-/*
- * redrat3_issue_async
- *
- *  Issues an async read to the ir data in port..
- *  sets the callback to be redrat3_handle_async
- */
-static void redrat3_issue_async(struct redrat3_dev *rr3)
-{
-	int res;
-
-	res = usb_submit_urb(rr3->read_urb, GFP_ATOMIC);
-	if (res)
-		dev_dbg(rr3->dev,
-			"%s: receive request FAILED! (res %d, len %d)\n",
-			__func__, res, rr3->read_urb->transfer_buffer_length);
-}
-
 static void redrat3_dump_fw_error(struct redrat3_dev *rr3, int code)
 {
 	if (!rr3->transmitting && (code != 0x40))
@@ -367,6 +361,14 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 
 	mod_freq = redrat3_val_to_mod_freq(&rr3->irdata);
 	dev_dbg(dev, "Got mod_freq of %u\n", mod_freq);
+	if (mod_freq && rr3->wideband) {
+		DEFINE_IR_RAW_EVENT(ev);
+
+		ev.carrier_report = 1;
+		ev.carrier = mod_freq;
+
+		ir_raw_event_store(rr3->rc, &ev);
+	}
 
 	/* process each rr3 encoded byte into an int */
 	sig_size = be16_to_cpu(rr3->irdata.sig_size);
@@ -449,19 +451,31 @@ static int redrat3_enable_detector(struct redrat3_dev *rr3)
 		return -EIO;
 	}
 
-	redrat3_issue_async(rr3);
+	ret = usb_submit_urb(rr3->narrow_urb, GFP_KERNEL);
+	if (ret) {
+		dev_err(rr3->dev, "narrow band urb failed: %d", ret);
+		return ret;
+	}
 
-	return 0;
+	ret = usb_submit_urb(rr3->wide_urb, GFP_KERNEL);
+	if (ret)
+		dev_err(rr3->dev, "wide band urb failed: %d", ret);
+
+	return ret;
 }
 
 static inline void redrat3_delete(struct redrat3_dev *rr3,
 				  struct usb_device *udev)
 {
-	usb_kill_urb(rr3->read_urb);
+	usb_kill_urb(rr3->narrow_urb);
+	usb_kill_urb(rr3->wide_urb);
 	usb_kill_urb(rr3->flash_urb);
-	usb_free_urb(rr3->read_urb);
+	usb_kill_urb(rr3->learn_urb);
+	usb_free_urb(rr3->narrow_urb);
+	usb_free_urb(rr3->wide_urb);
 	usb_free_urb(rr3->flash_urb);
-	usb_free_coherent(udev, le16_to_cpu(rr3->ep_in->wMaxPacketSize),
+	usb_free_urb(rr3->learn_urb);
+	usb_free_coherent(udev, le16_to_cpu(rr3->ep_narrow->wMaxPacketSize),
 			  rr3->bulk_in_buf, rr3->dma_in);
 
 	kfree(rr3);
@@ -694,9 +708,19 @@ static void redrat3_handle_async(struct urb *urb)
 	switch (urb->status) {
 	case 0:
 		ret = redrat3_get_ir_data(rr3, urb->actual_length);
+		if (!ret && rr3->wideband && !rr3->learn_urb->hcpriv) {
+			ret = usb_submit_urb(rr3->learn_urb, GFP_ATOMIC);
+			if (ret)
+				dev_err(rr3->dev, "Failed to submit learning urb: %d",
+									ret);
+		}
+
 		if (!ret) {
 			/* no error, prepare to read more */
-			redrat3_issue_async(rr3);
+			ret = usb_submit_urb(urb, GFP_ATOMIC);
+			if (ret)
+				dev_err(rr3->dev, "Failed to resubmit urb: %d",
+									ret);
 		}
 		break;
 
@@ -856,6 +880,42 @@ static void redrat3_brightness_set(struct led_classdev *led_dev, enum
 	}
 }
 
+static int redrat3_wideband_receiver(struct rc_dev *rcdev, int enable)
+{
+	struct redrat3_dev *rr3 = rcdev->priv;
+	int ret = 0;
+
+	rr3->wideband = enable != 0;
+
+	if (enable) {
+		ret = usb_submit_urb(rr3->learn_urb, GFP_KERNEL);
+		if (ret)
+			dev_err(rr3->dev, "Failed to submit learning urb: %d",
+									ret);
+	}
+
+	return ret;
+}
+
+static void redrat3_learn_complete(struct urb *urb)
+{
+	struct redrat3_dev *rr3 = urb->context;
+
+	switch (urb->status) {
+	case 0:
+		break;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		usb_unlink_urb(urb);
+		return;
+	case -EPIPE:
+	default:
+		dev_err(rr3->dev, "Error: learn urb status = %d", urb->status);
+		break;
+	}
+}
+
 static void redrat3_led_complete(struct urb *urb)
 {
 	struct redrat3_dev *rr3 = urb->context;
@@ -910,6 +970,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 	rc->s_timeout = redrat3_set_timeout;
 	rc->tx_ir = redrat3_transmit_ir;
 	rc->s_tx_carrier = redrat3_set_tx_carrier;
+	rc->s_carrier_report = redrat3_wideband_receiver;
 	rc->driver_name = DRIVER_NAME;
 	rc->rx_resolution = US_TO_NS(2);
 	rc->map_name = RC_MAP_HAUPPAUGE;
@@ -935,7 +996,8 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 	struct usb_host_interface *uhi;
 	struct redrat3_dev *rr3;
 	struct usb_endpoint_descriptor *ep;
-	struct usb_endpoint_descriptor *ep_in = NULL;
+	struct usb_endpoint_descriptor *ep_narrow = NULL;
+	struct usb_endpoint_descriptor *ep_wide = NULL;
 	struct usb_endpoint_descriptor *ep_out = NULL;
 	u8 addr, attrs;
 	int pipe, i;
@@ -949,15 +1011,16 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 		addr = ep->bEndpointAddress;
 		attrs = ep->bmAttributes;
 
-		if ((ep_in == NULL) &&
-		    ((addr & USB_ENDPOINT_DIR_MASK) == USB_DIR_IN) &&
+		if (((addr & USB_ENDPOINT_DIR_MASK) == USB_DIR_IN) &&
 		    ((attrs & USB_ENDPOINT_XFERTYPE_MASK) ==
 		     USB_ENDPOINT_XFER_BULK)) {
 			dev_dbg(dev, "found bulk-in endpoint at 0x%02x\n",
 				ep->bEndpointAddress);
-			/* data comes in on 0x82, 0x81 is for other data... */
-			if (ep->bEndpointAddress == RR3_BULK_IN_EP_ADDR)
-				ep_in = ep;
+			/* data comes in on 0x82, 0x81 is for learning */
+			if (ep->bEndpointAddress == RR3_NARROW_IN_EP_ADDR)
+				ep_narrow = ep;
+			if (ep->bEndpointAddress == RR3_WIDE_IN_EP_ADDR)
+				ep_wide = ep;
 		}
 
 		if ((ep_out == NULL) &&
@@ -970,8 +1033,8 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 		}
 	}
 
-	if (!ep_in || !ep_out) {
-		dev_err(dev, "Couldn't find both in and out endpoints\n");
+	if (!ep_narrow || !ep_out || !ep_wide) {
+		dev_err(dev, "Couldn't find all endpoints\n");
 		retval = -ENODEV;
 		goto no_endpoints;
 	}
@@ -982,25 +1045,38 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 		goto no_endpoints;
 
 	rr3->dev = &intf->dev;
-	rr3->ep_in = ep_in;
+	rr3->ep_narrow = ep_narrow;
 	rr3->ep_out = ep_out;
 	rr3->udev = udev;
 
 	/* set up bulk-in endpoint */
-	rr3->read_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!rr3->read_urb)
+	rr3->narrow_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!rr3->narrow_urb)
+		goto redrat_free;
+
+	rr3->wide_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!rr3->wide_urb)
 		goto redrat_free;
 
 	rr3->bulk_in_buf = usb_alloc_coherent(udev,
-		le16_to_cpu(ep_in->wMaxPacketSize), GFP_KERNEL, &rr3->dma_in);
+		le16_to_cpu(ep_narrow->wMaxPacketSize),
+		GFP_KERNEL, &rr3->dma_in);
 	if (!rr3->bulk_in_buf)
 		goto redrat_free;
 
-	pipe = usb_rcvbulkpipe(udev, ep_in->bEndpointAddress);
-	usb_fill_bulk_urb(rr3->read_urb, udev, pipe, rr3->bulk_in_buf,
-		le16_to_cpu(ep_in->wMaxPacketSize), redrat3_handle_async, rr3);
-	rr3->read_urb->transfer_dma = rr3->dma_in;
-	rr3->read_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+	pipe = usb_rcvbulkpipe(udev, ep_narrow->bEndpointAddress);
+	usb_fill_bulk_urb(rr3->narrow_urb, udev, pipe, rr3->bulk_in_buf,
+		le16_to_cpu(ep_narrow->wMaxPacketSize),
+		redrat3_handle_async, rr3);
+	rr3->narrow_urb->transfer_dma = rr3->dma_in;
+	rr3->narrow_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
+	pipe = usb_rcvbulkpipe(udev, ep_wide->bEndpointAddress);
+	usb_fill_bulk_urb(rr3->wide_urb, udev, pipe, rr3->bulk_in_buf,
+		le16_to_cpu(ep_narrow->wMaxPacketSize),
+		redrat3_handle_async, rr3);
+	rr3->wide_urb->transfer_dma = rr3->dma_in;
+	rr3->wide_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
 	redrat3_reset(rr3);
 	redrat3_get_firmware_rev(rr3);
@@ -1013,6 +1089,21 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 	if (!rr3->flash_urb)
 		goto redrat_free;
 
+	/* learn urb */
+	rr3->learn_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!rr3->learn_urb)
+		goto redrat_free;
+
+	/* setup packet is 'c0 b2 0000 0000 0001' */
+	rr3->learn_control.bRequestType = 0xc0;
+	rr3->learn_control.bRequest = RR3_MODSIG_CAPTURE;
+	rr3->learn_control.wLength = cpu_to_le16(1);
+
+	usb_fill_control_urb(rr3->learn_urb, udev, usb_rcvctrlpipe(udev, 0),
+			(unsigned char *)&rr3->learn_control,
+			&rr3->learn_buf, sizeof(rr3->learn_buf),
+			redrat3_learn_complete, rr3);
+
 	/* setup packet is 'c0 b9 0000 0000 0001' */
 	rr3->flash_control.bRequestType = 0xc0;
 	rr3->flash_control.bRequest = RR3_BLINK_LED;
@@ -1072,7 +1163,8 @@ static int redrat3_dev_suspend(struct usb_interface *intf, pm_message_t message)
 	struct redrat3_dev *rr3 = usb_get_intfdata(intf);
 
 	led_classdev_suspend(&rr3->led);
-	usb_kill_urb(rr3->read_urb);
+	usb_kill_urb(rr3->narrow_urb);
+	usb_kill_urb(rr3->wide_urb);
 	usb_kill_urb(rr3->flash_urb);
 	return 0;
 }
@@ -1081,7 +1173,9 @@ static int redrat3_dev_resume(struct usb_interface *intf)
 {
 	struct redrat3_dev *rr3 = usb_get_intfdata(intf);
 
-	if (usb_submit_urb(rr3->read_urb, GFP_ATOMIC))
+	if (usb_submit_urb(rr3->narrow_urb, GFP_ATOMIC))
+		return -EIO;
+	if (usb_submit_urb(rr3->wide_urb, GFP_ATOMIC))
 		return -EIO;
 	led_classdev_resume(&rr3->led);
 	return 0;
-- 
2.7.4

