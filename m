Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab0GCEC2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Jul 2010 00:02:28 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o6342ShF003644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 3 Jul 2010 00:02:28 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o6342Rwn009180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 3 Jul 2010 00:02:28 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o6342R1n031402
	for <linux-media@vger.kernel.org>; Sat, 3 Jul 2010 00:02:27 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o6342R32031400
	for linux-media@vger.kernel.org; Sat, 3 Jul 2010 00:02:27 -0400
Date: Sat, 3 Jul 2010 00:02:27 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v3] IR/mceusb: kill pinnacle-device-specific nonsense
Message-ID: <20100703040227.GA31255@redhat.com>
References: <20100616201046.GA10000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616201046.GA10000@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have pinnacle hardware now. None of this pinnacle-specific crap is at
all necessary (in fact, some of it needed to be removed to actually make
it work). The only thing unique about this device is that it often
transfers inbound data w/a header of 0x90, meaning 16 bytes of IR data
following it, so I had to make adjustments for that, and now its working
perfectly fine.

v2: stillborn

v3: remove completely unnecessary usb_reset_device() call that only served
to piss off the pinnacle device regularly and unify/simplify some of the
generation-specific device initialization code.

post-mortem: it seems the pinnacle hardware actually still gets pissed off
from time to time, but I can (try) to fix that later (if possible). The
patch is still quite helpful from a code reduction standpoint.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 Makefile                  |    2 +-
 drivers/media/IR/mceusb.c |  110 +++++++++------------------------------------
 2 files changed, 22 insertions(+), 90 deletions(-)

diff --git a/Makefile b/Makefile
index 6e39ec7..0417c74 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 35
-EXTRAVERSION = -rc1
+EXTRAVERSION = -rc1-ir
 NAME = Sheep on Meth
 
 # *DOCUMENTATION*
diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index 756f718..640e2e6 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -68,7 +68,7 @@
 #define MCE_PULSE_BIT	0x80 /* Pulse bit, MSB set == PULSE else SPACE */
 #define MCE_PULSE_MASK	0x7F /* Pulse mask */
 #define MCE_MAX_PULSE_LENGTH 0x7F /* Longest transmittable pulse symbol */
-#define MCE_PACKET_LENGTH_MASK  0xF /* Packet length mask */
+#define MCE_PACKET_LENGTH_MASK  0x1F /* Packet length mask */
 
 
 /* module parameters */
@@ -209,11 +209,6 @@ static struct usb_device_id gen3_list[] = {
 	{}
 };
 
-static struct usb_device_id pinnacle_list[] = {
-	{ USB_DEVICE(VENDOR_PINNACLE, 0x0225) },
-	{}
-};
-
 static struct usb_device_id microsoft_gen1_list[] = {
 	{ USB_DEVICE(VENDOR_MICROSOFT, 0x006d) },
 	{}
@@ -542,6 +537,7 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 {
 	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
 	int i, start_index = 0;
+	u8 hdr = MCE_CONTROL_HEADER;
 
 	/* skip meaningless 0xb1 0x60 header bytes on orig receiver */
 	if (ir->flags.microsoft_gen1)
@@ -551,15 +547,16 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 		if (ir->rem == 0) {
 			/* decode mce packets of the form (84),AA,BB,CC,DD */
 			/* IR data packets can span USB messages - rem */
-			ir->rem = (ir->buf_in[i] & MCE_PACKET_LENGTH_MASK);
-			ir->cmd = (ir->buf_in[i] & ~MCE_PACKET_LENGTH_MASK);
+			hdr = ir->buf_in[i];
+			ir->rem = (hdr & MCE_PACKET_LENGTH_MASK);
+			ir->cmd = (hdr & ~MCE_PACKET_LENGTH_MASK);
 			dev_dbg(ir->dev, "New data. rem: 0x%02x, cmd: 0x%02x\n",
 				ir->rem, ir->cmd);
 			i++;
 		}
 
-		/* Only cmd 0x8<bytes> is IR data, don't process MCE commands */
-		if (ir->cmd != 0x80) {
+		/* don't process MCE commands */
+		if (hdr == MCE_CONTROL_HEADER || hdr == 0xff) {
 			ir->rem = 0;
 			return;
 		}
@@ -649,47 +646,18 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
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
@@ -717,16 +685,12 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
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
@@ -744,8 +708,6 @@ static void mceusb_gen3_init(struct mceusb_dev *ir)
 {
 	int maxp = ir->len_in;
 
-	mce_sync_in(ir, NULL, maxp);
-
 	/* device reset */
 	mce_async_out(ir, DEVICE_RESET, sizeof(DEVICE_RESET));
 	mce_sync_in(ir, NULL, maxp);
@@ -841,24 +803,19 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	struct usb_endpoint_descriptor *ep_out = NULL;
 	struct usb_host_config *config;
 	struct mceusb_dev *ir = NULL;
-	int pipe, maxp;
-	int i, ret;
+	int pipe, maxp, i;
 	char buf[63], name[128] = "";
 	bool is_gen3;
 	bool is_microsoft_gen1;
-	bool is_pinnacle;
 	bool tx_mask_inverted;
 
 	dev_dbg(&intf->dev, ": %s called\n", __func__);
 
-	usb_reset_device(dev);
-
 	config = dev->actconfig;
 	idesc  = intf->cur_altsetting;
 
 	is_gen3 = usb_match_id(intf, gen3_list) ? 1 : 0;
 	is_microsoft_gen1 = usb_match_id(intf, microsoft_gen1_list) ? 1 : 0;
-	is_pinnacle = usb_match_id(intf, pinnacle_list) ? 1 : 0;
 	tx_mask_inverted = usb_match_id(intf, std_tx_mask_list) ? 0 : 1;
 
 	/* step through the endpoints to find first bulk in and out endpoint */
@@ -873,19 +830,11 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 			|| ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
 			    == USB_ENDPOINT_XFER_INT))) {
 
-			dev_dbg(&intf->dev, ": acceptable inbound endpoint "
-				"found\n");
 			ep_in = ep;
 			ep_in->bmAttributes = USB_ENDPOINT_XFER_INT;
-			if (!is_pinnacle)
-				/*
-				 * Ideally, we'd use what the device offers up,
-				 * but that leads to non-functioning first and
-				 * second-gen devices, and many devices have an
-				 * invalid bInterval of 0. Pinnacle devices
-				 * don't work witha  bInterval of 1 though.
-				 */
-				ep_in->bInterval = 1;
+			ep_in->bInterval = 1;
+			dev_dbg(&intf->dev, ": acceptable inbound endpoint "
+				"found\n");
 		}
 
 		if ((ep_out == NULL)
@@ -896,19 +845,11 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 			|| ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
 			    == USB_ENDPOINT_XFER_INT))) {
 
-			dev_dbg(&intf->dev, ": acceptable outbound endpoint "
-				"found\n");
 			ep_out = ep;
 			ep_out->bmAttributes = USB_ENDPOINT_XFER_INT;
-			if (!is_pinnacle)
-				/*
-				 * Ideally, we'd use what the device offers up,
-				 * but that leads to non-functioning first and
-				 * second-gen devices, and many devices have an
-				 * invalid bInterval of 0. Pinnacle devices
-				 * don't work witha  bInterval of 1 though.
-				 */
-				ep_out->bInterval = 1;
+			ep_out->bInterval = 1;
+			dev_dbg(&intf->dev, ": acceptable outbound endpoint "
+				"found\n");
 		}
 	}
 	if (ep_in == NULL) {
@@ -956,25 +897,16 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
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
 	ir->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
-	if (is_pinnacle) {
-		/*
-		 * I have no idea why but this reset seems to be crucial to
-		 * getting the device to do outbound IO correctly - without
-		 * this the device seems to hang, ignoring all input - although
-		 * IR signals are correctly sent from the device, no input is
-		 * interpreted by the device and the host never does the
-		 * completion routine
-		 */
-		ret = usb_reset_configuration(dev);
-		dev_info(&intf->dev, "usb reset config ret %x\n", ret);
-	}
-
 	/* initialize device */
 	if (ir->flags.gen3)
 		mceusb_gen3_init(ir);
-- 
1.7.1


-- 
Jarod Wilson
jarod@redhat.com

