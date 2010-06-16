Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab0FPUKH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jun 2010 16:10:07 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o5GKA7N0026579
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 16 Jun 2010 16:10:07 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o5GKA5me001466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 16 Jun 2010 16:10:06 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o5GKA5OX009962
	for <linux-media@vger.kernel.org>; Wed, 16 Jun 2010 16:10:05 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o5GKA54Q009960
	for linux-media@vger.kernel.org; Wed, 16 Jun 2010 16:10:05 -0400
Date: Wed, 16 Jun 2010 16:10:05 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] IR/mceusb: misc cleanups and init fixes
Message-ID: <20100616201005.GA9891@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first-gen mceusb device init code, while mostly functional, had a few
issues in it. This patch does the following:

1) removes use of magic numbers
2) eliminates mapping of memory from stack
3) makes debug spew translator functional

Additionally, this clean-up revealed that we cannot read the proper default
tx blaster bitmask from the device, we do actually have to initialize it
ourselves, which requires use of a somewhat gross list-based mask inversion
check.

This patch also removes the entirely unnecessary use of struct ir_input_state.

Also supersedes two earlier patches that also touched on first-gen
cleanup, but were partially botched. This one actually compiles, works,
etc., I swear. ;)

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 drivers/media/IR/mceusb.c |  138 ++++++++++++++++++++++----------------------
 1 files changed, 69 insertions(+), 69 deletions(-)

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index c9dd2f8..756f718 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -52,6 +52,8 @@
 
 #define USB_BUFLEN	32	/* USB reception buffer length */
 #define IRBUF_SIZE	256	/* IR work buffer length */
+#define USB_CTRL_MSG_SZ	2	/* Size of usb ctrl msg on gen1 hw */
+#define MCE_G1_INIT_MSGS 40	/* Init messages on gen1 hw to throw out */
 
 /* MCE constants */
 #define MCE_CMDBUF_SIZE	384 /* MCE Command buffer length */
@@ -217,12 +219,27 @@ static struct usb_device_id microsoft_gen1_list[] = {
 	{}
 };
 
+static struct usb_device_id std_tx_mask_list[] = {
+	{ USB_DEVICE(VENDOR_MICROSOFT, 0x006d) },
+	{ USB_DEVICE(VENDOR_PHILIPS, 0x060c) },
+	{ USB_DEVICE(VENDOR_SMK, 0x031d) },
+	{ USB_DEVICE(VENDOR_SMK, 0x0322) },
+	{ USB_DEVICE(VENDOR_SMK, 0x0334) },
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0001) },
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0006) },
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0007) },
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0008) },
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x000a) },
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0011) },
+	{ USB_DEVICE(VENDOR_PINNACLE, 0x0225) },
+	{}
+};
+
 /* data structure for each usb transceiver */
 struct mceusb_dev {
 	/* ir-core bits */
 	struct ir_input_dev *irdev;
 	struct ir_dev_props *props;
-	struct ir_input_state *state;
 	struct ir_raw_event rawir;
 
 	/* core device bits */
@@ -245,7 +262,7 @@ struct mceusb_dev {
 
 	struct {
 		u32 connected:1;
-		u32 def_xmit_mask_set:1;
+		u32 tx_mask_inverted:1;
 		u32 microsoft_gen1:1;
 		u32 gen3:1;
 		u32 reserved:28;
@@ -258,8 +275,7 @@ struct mceusb_dev {
 	char name[128];
 	char phys[64];
 
-	unsigned char def_xmit_mask;
-	unsigned char cur_xmit_mask;
+	unsigned char tx_mask;
 };
 
 /*
@@ -307,11 +323,13 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 	int i;
 	u8 cmd, subcmd, data1, data2;
 	struct device *dev = ir->dev;
+	int idx = 0;
 
-	if (len <= 0)
-		return;
+	/* skip meaningless 0xb1 0x60 header bytes on orig receiver */
+	if (ir->flags.microsoft_gen1 && !out)
+		idx = 2;
 
-	if (ir->flags.microsoft_gen1 && len <= 2)
+	if (len <= idx)
 		return;
 
 	for (i = 0; i < len && i < USB_BUFLEN; i++)
@@ -325,10 +343,10 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 	else
 		strcpy(inout, "Got\0");
 
-	cmd    = buf[0] & 0xff;
-	subcmd = buf[1] & 0xff;
-	data1  = buf[2] & 0xff;
-	data2  = buf[3] & 0xff;
+	cmd    = buf[idx] & 0xff;
+	subcmd = buf[idx + 1] & 0xff;
+	data1  = buf[idx + 2] & 0xff;
+	data2  = buf[idx + 3] & 0xff;
 
 	switch (cmd) {
 	case 0x00:
@@ -346,7 +364,7 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 			else
 				dev_info(dev, "hw/sw rev 0x%02x 0x%02x "
 					 "0x%02x 0x%02x\n", data1, data2,
-					 buf[4], buf[5]);
+					 buf[idx + 4], buf[idx + 5]);
 			break;
 		case 0xaa:
 			dev_info(dev, "Device reset requested\n");
@@ -507,6 +525,19 @@ static void mce_sync_in(struct mceusb_dev *ir, unsigned char *data, int size)
 	mce_request_packet(ir, ir->usb_ep_in, data, size, MCEUSB_RX);
 }
 
+/* Sets active IR outputs -- mce devices typically (all?) have two */
+static int mceusb_set_tx_mask(void *priv, u32 mask)
+{
+	struct mceusb_dev *ir = priv;
+
+	if (ir->flags.tx_mask_inverted)
+		ir->tx_mask = (mask != 0x03 ? mask ^ 0x03 : mask) << 1;
+	else
+		ir->tx_mask = mask;
+
+	return 0;
+}
+
 static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 {
 	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
@@ -568,24 +599,6 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 	}
 }
 
-static void mceusb_set_default_xmit_mask(struct urb *urb)
-{
-	struct mceusb_dev *ir = urb->context;
-	char *buffer = urb->transfer_buffer;
-	u8 cmd, subcmd, def_xmit_mask;
-
-	cmd    = buffer[0] & 0xff;
-	subcmd = buffer[1] & 0xff;
-
-	if (cmd == 0x9f && subcmd == 0x08) {
-		def_xmit_mask = buffer[2] & 0xff;
-		dev_dbg(ir->dev, "%s: setting xmit mask to 0x%02x\n",
-			__func__, def_xmit_mask);
-		ir->def_xmit_mask = def_xmit_mask;
-		ir->flags.def_xmit_mask_set = 1;
-	}
-}
-
 static void mceusb_dev_recv(struct urb *urb, struct pt_regs *regs)
 {
 	struct mceusb_dev *ir;
@@ -602,9 +615,6 @@ static void mceusb_dev_recv(struct urb *urb, struct pt_regs *regs)
 
 	buf_len = urb->actual_length;
 
-	if (!ir->flags.def_xmit_mask_set)
-		mceusb_set_default_xmit_mask(urb);
-
 	if (debug)
 		mceusb_dev_printdata(ir, urb->transfer_buffer, buf_len, false);
 
@@ -637,27 +647,38 @@ static void mceusb_dev_recv(struct urb *urb, struct pt_regs *regs)
 static void mceusb_gen1_init(struct mceusb_dev *ir)
 {
 	int i, ret;
-	char junk[64], data[8];
 	int partial = 0;
 	struct device *dev = ir->dev;
+	char *junk, *data;
+
+	junk = kmalloc(2 * USB_BUFLEN, GFP_KERNEL);
+	if (!junk) {
+		dev_err(dev, "%s: memory allocation failed!\n", __func__);
+		return;
+	}
+
+	data = kzalloc(USB_CTRL_MSG_SZ, GFP_KERNEL);
+	if (!data) {
+		dev_err(dev, "%s: memory allocation failed!\n", __func__);
+		kfree(junk);
+		return;
+	}
 
 	/*
 	 * Clear off the first few messages. These look like calibration
 	 * or test data, I can't really tell. This also flushes in case
 	 * we have random ir data queued up.
 	 */
-	for (i = 0; i < 40; i++)
+	for (i = 0; i < MCE_G1_INIT_MSGS; i++)
 		usb_bulk_msg(ir->usbdev,
 			usb_rcvbulkpipe(ir->usbdev,
 				ir->usb_ep_in->bEndpointAddress),
-			junk, 64, &partial, HZ * 10);
-
-	memset(data, 0, 8);
+			junk, sizeof(junk), &partial, HZ * 10);
 
 	/* Get Status */
 	ret = usb_control_msg(ir->usbdev, usb_rcvctrlpipe(ir->usbdev, 0),
 			      USB_REQ_GET_STATUS, USB_DIR_IN,
-			      0, 0, data, 2, HZ * 3);
+			      0, 0, data, USB_CTRL_MSG_SZ, HZ * 3);
 
 	/*    ret = usb_get_status( ir->usbdev, 0, 0, data ); */
 	dev_dbg(dev, "%s - ret = %d status = 0x%x 0x%x\n", __func__,
@@ -667,11 +688,11 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 	 * This is a strange one. They issue a set address to the device
 	 * on the receive control pipe and expect a certain value pair back
 	 */
-	memset(data, 0, 8);
+	memset(data, 0, sizeof(data));
 
 	ret = usb_control_msg(ir->usbdev, usb_rcvctrlpipe(ir->usbdev, 0),
 			      USB_REQ_SET_ADDRESS, USB_TYPE_VENDOR, 0, 0,
-			      data, 2, HZ * 3);
+			      data, USB_CTRL_MSG_SZ, HZ * 3);
 	dev_dbg(dev, "%s - ret = %d\n", __func__, ret);
 	dev_dbg(dev, "%s - data[0] = %d, data[1] = %d\n",
 		__func__, data[0], data[1]);
@@ -694,6 +715,9 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 			      2, USB_TYPE_VENDOR,
 			      0x0000, 0x0100, NULL, 0, HZ * 3);
 	dev_dbg(dev, "%s - retC = %d\n", __func__, ret);
+
+	kfree(data);
+	kfree(junk);
 };
 
 static void mceusb_gen2_init(struct mceusb_dev *ir)
@@ -748,7 +772,6 @@ static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
 	struct input_dev *idev;
 	struct ir_dev_props *props;
 	struct ir_input_dev *irdev;
-	struct ir_input_state *state;
 	struct device *dev = ir->dev;
 	int ret = -ENODEV;
 
@@ -771,42 +794,22 @@ static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
 		goto ir_dev_alloc_failed;
 	}
 
-	state = kzalloc(sizeof(struct ir_input_state), GFP_KERNEL);
-	if (!state) {
-		dev_err(dev, "remote ir state allocation failed\n");
-		goto ir_state_alloc_failed;
-	}
-
 	snprintf(ir->name, sizeof(ir->name), "Media Center Edition eHome "
 		 "Infrared Remote Transceiver (%04x:%04x)",
 		 le16_to_cpu(ir->usbdev->descriptor.idVendor),
 		 le16_to_cpu(ir->usbdev->descriptor.idProduct));
 
-	ret = ir_input_init(idev, state, IR_TYPE_RC6);
-	if (ret < 0)
-		goto irdev_failed;
-
 	idev->name = ir->name;
-
 	usb_make_path(ir->usbdev, ir->phys, sizeof(ir->phys));
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
 	idev->phys = ir->phys;
 
-	/* FIXME: no EV_REP (yet), we may need our own auto-repeat handling */
-	idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
-
-	idev->keybit[BIT_WORD(BTN_MOUSE)] =
-		BIT_MASK(BTN_LEFT) | BIT_MASK(BTN_RIGHT);
-	idev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y) |
-		BIT_MASK(REL_WHEEL);
-
 	props->priv = ir;
 	props->driver_type = RC_DRIVER_IR_RAW;
 	props->allowed_protos = IR_TYPE_ALL;
 
 	ir->props = props;
 	ir->irdev = irdev;
-	ir->state = state;
 
 	input_set_drvdata(idev, irdev);
 
@@ -819,8 +822,6 @@ static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
 	return idev;
 
 irdev_failed:
-	kfree(state);
-ir_state_alloc_failed:
 	kfree(irdev);
 ir_dev_alloc_failed:
 	kfree(props);
@@ -846,6 +847,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	bool is_gen3;
 	bool is_microsoft_gen1;
 	bool is_pinnacle;
+	bool tx_mask_inverted;
 
 	dev_dbg(&intf->dev, ": %s called\n", __func__);
 
@@ -857,6 +859,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	is_gen3 = usb_match_id(intf, gen3_list) ? 1 : 0;
 	is_microsoft_gen1 = usb_match_id(intf, microsoft_gen1_list) ? 1 : 0;
 	is_pinnacle = usb_match_id(intf, pinnacle_list) ? 1 : 0;
+	tx_mask_inverted = usb_match_id(intf, std_tx_mask_list) ? 0 : 1;
 
 	/* step through the endpoints to find first bulk in and out endpoint */
 	for (i = 0; i < idesc->desc.bNumEndpoints; ++i) {
@@ -933,6 +936,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	ir->len_in = maxp;
 	ir->flags.gen3 = is_gen3;
 	ir->flags.microsoft_gen1 = is_microsoft_gen1;
+	ir->flags.tx_mask_inverted = tx_mask_inverted;
 
 	/* Saving usb interface data for use by the transmitter routine */
 	ir->usb_ep_in = ep_in;
@@ -983,11 +987,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 
 	mce_sync_in(ir, NULL, maxp);
 
-	/* We've already done this on gen3 devices */
-	if (!ir->flags.def_xmit_mask_set) {
-		mce_async_out(ir, GET_TX_BITMASK, sizeof(GET_TX_BITMASK));
-		mce_sync_in(ir, NULL, maxp);
-	}
+	mceusb_set_tx_mask(ir, MCE_DEFAULT_TX_MASK);
 
 	usb_set_intfdata(intf, ir);
 
-- 
Jarod Wilson
jarod@redhat.com

