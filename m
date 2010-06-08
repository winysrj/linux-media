Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484Ab0FHVKm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jun 2010 17:10:42 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o58LAf2Z015129
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 8 Jun 2010 17:10:42 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o58LAeeH031015
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 8 Jun 2010 17:10:40 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o58LAeSg013150
	for <linux-media@vger.kernel.org>; Tue, 8 Jun 2010 17:10:40 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o58LAdCp013145
	for linux-media@vger.kernel.org; Tue, 8 Jun 2010 17:10:39 -0400
Date: Tue, 8 Jun 2010 17:10:39 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] IR/mceusb: fixups for 1st-gen transceiver
Message-ID: <20100608211039.GA7974@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 1st-gen (Microsoft device ID) MCE transceiver devices are
initialized differently than all others, and their incoming data
buffers look a bit different. We need to strip off the first two
bytes of data on each incoming buffer to get to the real data,
and that wasn't being done in the detailed debug spew routines.

Additionally, the 1st-gen init routine was... ugly. Well, it sill
is, but less so, with fewer magic numbers in it, and a nasty
looking warning about mapping memory from the stack gets eliminated
by switching some temp data buffers from stack to being kmalloc'd.

And finally, the proper default tx blaster bitmask can't be read
from the 1st-gen hardware, it has to be manually set.

All successfully tested on my own 1st-gen mceusb transceiver.

Patch is against v4l/dvb staging/rc tree.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/mceusb.c |   57 ++++++++++++++++++++++++++++++++------------
 1 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index fe15091..b4cef00 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -52,6 +52,8 @@
 
 #define USB_BUFLEN	32	/* USB reception buffer length */
 #define IRBUF_SIZE	256	/* IR work buffer length */
+#define USB_CTRL_MSG_SZ	2	/* Size of usb ctrl msg on gen1 hw */
+#define MCE_G1_INIT_MSGS 40	/* Init messages on gen1 hw to throw out */
 
 /* MCE constants */
 #define MCE_CMDBUF_SIZE	384 /* MCE Command buffer length */
@@ -307,11 +309,13 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
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
@@ -325,10 +329,10 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
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
@@ -346,7 +350,7 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 			else
 				dev_info(dev, "hw/sw rev 0x%02x 0x%02x "
 					 "0x%02x 0x%02x\n", data1, data2,
-					 buf[4], buf[5]);
+					 buf[idx + 4], buf[idx + 5]);
 			break;
 		case 0xaa:
 			dev_info(dev, "Device reset requested\n");
@@ -574,6 +578,13 @@ static void mceusb_set_default_xmit_mask(struct urb *urb)
 	char *buffer = urb->transfer_buffer;
 	u8 cmd, subcmd, def_xmit_mask;
 
+	/* default mask isn't fetchable on gen1, we have to set it */
+	if (ir->flags.microsoft_gen1) {
+		ir->def_tx_mask = MCE_DEFAULT_TX_MASK;
+		ir->tx_mask = MCE_DEFAULT_TX_MASK;
+		return;
+	}
+
 	cmd    = buffer[0] & 0xff;
 	subcmd = buffer[1] & 0xff;
 
@@ -637,27 +648,38 @@ static void mceusb_dev_recv(struct urb *urb, struct pt_regs *regs)
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
@@ -667,11 +689,11 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
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
@@ -694,6 +716,9 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 			      2, USB_TYPE_VENDOR,
 			      0x0000, 0x0100, NULL, 0, HZ * 3);
 	dev_dbg(dev, "%s - retC = %d\n", __func__, ret);
+
+	kfree(data);
+	kfree(junk);
 };
 
 static void mceusb_gen2_init(struct mceusb_dev *ir)
-- 
1.6.5.2

-- 
Jarod Wilson
jarod@redhat.com

