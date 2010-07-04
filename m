Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522Ab0GDBmQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Jul 2010 21:42:16 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o641gF4D022784
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 3 Jul 2010 21:42:16 -0400
Date: Sat, 3 Jul 2010 21:42:14 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] IR/mceusb: unify and simplify different gen device init
Message-ID: <20100704014214.GD17081@redhat.com>
References: <20100616201046.GA10000@redhat.com>
 <20100703040227.GA31255@redhat.com>
 <4C2FB6E8.5090001@redhat.com>
 <AANLkTimbfm9nGxtNyCnpNFz3WhP1g6CzMQvRP0lJe9Dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimbfm9nGxtNyCnpNFz3WhP1g6CzMQvRP0lJe9Dc@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Started out as an effort to try to tackle the last remaining issue I'm
having with this damned pinnacle device getting wedged the first time
its plugged in after an indeterminate length of not being plugged in.
Didn't get that solved yet, but did streamline the init code a bit more
and remove some superfluous gunk. Nukes a completely unneeded call to
usb_device_init() and several lines of overly complex crap in the gen1
device init path.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/mceusb.c |   47 ++++++--------------------------------------
 1 files changed, 7 insertions(+), 40 deletions(-)

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index aaa40d8..46de9bc 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -766,47 +766,18 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 	int i, ret;
 	int partial = 0;
 	struct device *dev = ir->dev;
-	char *junk, *data;
-
-	junk = kmalloc(2 * USB_BUFLEN, GFP_KERNEL);
-	if (!junk) {
-		dev_err(dev, "%s: memory allocation failed!\n", __func__);
-		return;
-	}
+	char *data;
 
 	data = kzalloc(USB_CTRL_MSG_SZ, GFP_KERNEL);
 	if (!data) {
 		dev_err(dev, "%s: memory allocation failed!\n", __func__);
-		kfree(junk);
 		return;
 	}
 
 	/*
-	 * Clear off the first few messages. These look like calibration
-	 * or test data, I can't really tell. This also flushes in case
-	 * we have random ir data queued up.
-	 */
-	for (i = 0; i < MCE_G1_INIT_MSGS; i++)
-		usb_bulk_msg(ir->usbdev,
-			usb_rcvbulkpipe(ir->usbdev,
-				ir->usb_ep_in->bEndpointAddress),
-			junk, sizeof(junk), &partial, HZ * 10);
-
-	/* Get Status */
-	ret = usb_control_msg(ir->usbdev, usb_rcvctrlpipe(ir->usbdev, 0),
-			      USB_REQ_GET_STATUS, USB_DIR_IN,
-			      0, 0, data, USB_CTRL_MSG_SZ, HZ * 3);
-
-	/*    ret = usb_get_status( ir->usbdev, 0, 0, data ); */
-	dev_dbg(dev, "%s - ret = %d status = 0x%x 0x%x\n", __func__,
-		ret, data[0], data[1]);
-
-	/*
-	 * This is a strange one. They issue a set address to the device
+	 * This is a strange one. Windows issues a set address to the device
 	 * on the receive control pipe and expect a certain value pair back
 	 */
-	memset(data, 0, sizeof(data));
-
 	ret = usb_control_msg(ir->usbdev, usb_rcvctrlpipe(ir->usbdev, 0),
 			      USB_REQ_SET_ADDRESS, USB_TYPE_VENDOR, 0, 0,
 			      data, USB_CTRL_MSG_SZ, HZ * 3);
@@ -834,16 +805,12 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 	dev_dbg(dev, "%s - retC = %d\n", __func__, ret);
 
 	kfree(data);
-	kfree(junk);
 };
 
 static void mceusb_gen2_init(struct mceusb_dev *ir)
 {
 	int maxp = ir->len_in;
 
-	mce_sync_in(ir, NULL, maxp);
-	mce_sync_in(ir, NULL, maxp);
-
 	/* device reset */
 	mce_async_out(ir, DEVICE_RESET, sizeof(DEVICE_RESET));
 	mce_sync_in(ir, NULL, maxp);
@@ -861,8 +828,6 @@ static void mceusb_gen3_init(struct mceusb_dev *ir)
 {
 	int maxp = ir->len_in;
 
-	mce_sync_in(ir, NULL, maxp);
-
 	/* device reset */
 	mce_async_out(ir, DEVICE_RESET, sizeof(DEVICE_RESET));
 	mce_sync_in(ir, NULL, maxp);
@@ -969,8 +934,6 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 
 	dev_dbg(&intf->dev, ": %s called\n", __func__);
 
-	usb_reset_device(dev);
-
 	config = dev->actconfig;
 	idesc  = intf->cur_altsetting;
 
@@ -1057,7 +1020,11 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	if (!ir->idev)
 		goto input_dev_fail;
 
-	/* inbound data */
+	/* flush buffers on the device */
+	mce_sync_in(ir, NULL, maxp);
+	mce_sync_in(ir, NULL, maxp);
+
+	/* wire up inbound data handler */
 	usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in,
 		maxp, (usb_complete_t) mceusb_dev_recv, ir, ep_in->bInterval);
 	ir->urb_in->transfer_dma = ir->dma_in;
-- 
1.7.1


-- 
Jarod Wilson
jarod@redhat.com

