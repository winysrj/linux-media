Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:39937 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S945226AbcJaRwb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 13:52:31 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 3/9] [media] redrat3: remove dead code and pointless messages
Date: Mon, 31 Oct 2016 17:52:21 +0000
Message-Id: <1477936347-9029-4-git-send-email-sean@mess.org>
In-Reply-To: <1477936347-9029-1-git-send-email-sean@mess.org>
References: <1477936347-9029-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No need to log kmalloc failures.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/redrat3.c | 42 ++++++------------------------------------
 1 file changed, 6 insertions(+), 36 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index de40e58..23180ec 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -363,11 +363,6 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 	unsigned int i, sig_size, single_len, offset, val;
 	u32 mod_freq;
 
-	if (!rr3) {
-		pr_err("%s called with no context!\n", __func__);
-		return;
-	}
-
 	dev = rr3->dev;
 
 	mod_freq = redrat3_val_to_mod_freq(&rr3->irdata);
@@ -480,10 +475,8 @@ static u32 redrat3_get_timeout(struct redrat3_dev *rr3)
 
 	len = sizeof(*tmp);
 	tmp = kzalloc(len, GFP_KERNEL);
-	if (!tmp) {
-		dev_warn(rr3->dev, "Memory allocation faillure\n");
+	if (!tmp)
 		return timeout;
-	}
 
 	pipe = usb_rcvctrlpipe(rr3->udev, 0);
 	ret = usb_control_msg(rr3->udev, pipe, RR3_GET_IR_PARAM,
@@ -544,10 +537,8 @@ static void redrat3_reset(struct redrat3_dev *rr3)
 	txpipe = usb_sndctrlpipe(udev, 0);
 
 	val = kmalloc(len, GFP_KERNEL);
-	if (!val) {
-		dev_err(dev, "Memory allocation failure\n");
+	if (!val)
 		return;
-	}
 
 	*val = 0x01;
 	rc = usb_control_msg(udev, rxpipe, RR3_RESET,
@@ -589,10 +580,8 @@ static void redrat3_get_firmware_rev(struct redrat3_dev *rr3)
 	char *buffer;
 
 	buffer = kzalloc(sizeof(char) * (RR3_FW_VERSION_LEN + 1), GFP_KERNEL);
-	if (!buffer) {
-		dev_err(rr3->dev, "Memory allocation failure\n");
+	if (!buffer)
 		return;
-	}
 
 	rc = usb_control_msg(rr3->udev, usb_rcvctrlpipe(rr3->udev, 0),
 			     RR3_FW_VERSION,
@@ -699,19 +688,9 @@ static int redrat3_get_ir_data(struct redrat3_dev *rr3, unsigned len)
 /* callback function from USB when async USB request has completed */
 static void redrat3_handle_async(struct urb *urb)
 {
-	struct redrat3_dev *rr3;
+	struct redrat3_dev *rr3 = urb->context;
 	int ret;
 
-	if (!urb)
-		return;
-
-	rr3 = urb->context;
-	if (!rr3) {
-		pr_err("%s called with invalid context!\n", __func__);
-		usb_unlink_urb(urb);
-		return;
-	}
-
 	switch (urb->status) {
 	case 0:
 		ret = redrat3_get_ir_data(rr3, urb->actual_length);
@@ -999,10 +978,8 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 
 	/* allocate memory for our device state and initialize it */
 	rr3 = kzalloc(sizeof(*rr3), GFP_KERNEL);
-	if (rr3 == NULL) {
-		dev_err(dev, "Memory allocation failure\n");
+	if (rr3 == NULL)
 		goto no_endpoints;
-	}
 
 	rr3->dev = &intf->dev;
 
@@ -1014,10 +991,8 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 	rr3->ep_in = ep_in;
 	rr3->bulk_in_buf = usb_alloc_coherent(udev,
 		le16_to_cpu(ep_in->wMaxPacketSize), GFP_KERNEL, &rr3->dma_in);
-	if (!rr3->bulk_in_buf) {
-		dev_err(dev, "Read buffer allocation failure\n");
+	if (!rr3->bulk_in_buf)
 		goto error;
-	}
 
 	pipe = usb_rcvbulkpipe(udev, ep_in->bEndpointAddress);
 	usb_fill_bulk_urb(rr3->read_urb, udev, pipe, rr3->bulk_in_buf,
@@ -1081,8 +1056,6 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 	redrat3_delete(rr3, rr3->udev);
 
 no_endpoints:
-	dev_err(dev, "%s: retval = %x", __func__, retval);
-
 	return retval;
 }
 
@@ -1091,9 +1064,6 @@ static void redrat3_dev_disconnect(struct usb_interface *intf)
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct redrat3_dev *rr3 = usb_get_intfdata(intf);
 
-	if (!rr3)
-		return;
-
 	usb_set_intfdata(intf, NULL);
 	rc_unregister_device(rr3->rc);
 	led_classdev_unregister(&rr3->led);
-- 
2.7.4

