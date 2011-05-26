Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:29931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab1EZVbm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 17:31:42 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4QLVgTr016832
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 26 May 2011 17:31:42 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] [media] mceusb: add and use mce_dbg printk macro
Date: Thu, 26 May 2011 17:31:37 -0400
Message-Id: <1306445497-17893-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Using dev_dbg is more complexity than many users are able to deal with.
Make it easier to get debug spew feedback from them by adding an mce_dbg
printk macro that spews using dev_info when debug=1 is set for the
mceusb module.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |   44 +++++++++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 124f5af..2f1d0b7 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -108,6 +108,12 @@ static int debug = 1;
 static int debug;
 #endif
 
+#define mce_dbg(dev, fmt, ...)					\
+	do {							\
+		if (debug)					\
+			dev_info(dev, fmt, ## __VA_ARGS__);	\
+	} while (0)
+
 /* general constants */
 #define SEND_FLAG_IN_PROGRESS	1
 #define SEND_FLAG_COMPLETE	2
@@ -606,7 +612,7 @@ static void mce_async_callback(struct urb *urb, struct pt_regs *regs)
 	if (ir) {
 		len = urb->actual_length;
 
-		dev_dbg(ir->dev, "callback called (status=%d len=%d)\n",
+		mce_dbg(ir->dev, "callback called (status=%d len=%d)\n",
 			urb->status, len);
 
 		mceusb_dev_printdata(ir, urb->transfer_buffer, 0, len, true);
@@ -658,17 +664,17 @@ static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
 		return;
 	}
 
-	dev_dbg(dev, "receive request called (size=%#x)\n", size);
+	mce_dbg(dev, "receive request called (size=%#x)\n", size);
 
 	async_urb->transfer_buffer_length = size;
 	async_urb->dev = ir->usbdev;
 
 	res = usb_submit_urb(async_urb, GFP_ATOMIC);
 	if (res) {
-		dev_dbg(dev, "receive request FAILED! (res=%d)\n", res);
+		mce_dbg(dev, "receive request FAILED! (res=%d)\n", res);
 		return;
 	}
-	dev_dbg(dev, "receive request complete (res=%d)\n", res);
+	mce_dbg(dev, "receive request complete (res=%d)\n", res);
 }
 
 static void mce_async_out(struct mceusb_dev *ir, unsigned char *data, int size)
@@ -797,7 +803,7 @@ static int mceusb_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 			ir->carrier = carrier;
 			cmdbuf[2] = MCE_CMD_SIG_END;
 			cmdbuf[3] = MCE_IRDATA_TRAILER;
-			dev_dbg(ir->dev, "%s: disabling carrier "
+			mce_dbg(ir->dev, "%s: disabling carrier "
 				"modulation\n", __func__);
 			mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
 			return carrier;
@@ -809,7 +815,7 @@ static int mceusb_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 				ir->carrier = carrier;
 				cmdbuf[2] = prescaler;
 				cmdbuf[3] = divisor;
-				dev_dbg(ir->dev, "%s: requesting %u HZ "
+				mce_dbg(ir->dev, "%s: requesting %u HZ "
 					"carrier\n", __func__, carrier);
 
 				/* Transmit new carrier to mce device */
@@ -882,7 +888,7 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
 					 * US_TO_NS(MCE_TIME_UNIT);
 
-			dev_dbg(ir->dev, "Storing %s with duration %d\n",
+			mce_dbg(ir->dev, "Storing %s with duration %d\n",
 				rawir.pulse ? "pulse" : "space",
 				rawir.duration);
 
@@ -914,7 +920,7 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 		if (ir->parser_state != CMD_HEADER && !ir->rem)
 			ir->parser_state = CMD_HEADER;
 	}
-	dev_dbg(ir->dev, "processed IR data, calling ir_raw_event_handle\n");
+	mce_dbg(ir->dev, "processed IR data, calling ir_raw_event_handle\n");
 	ir_raw_event_handle(ir->rc);
 }
 
@@ -936,7 +942,7 @@ static void mceusb_dev_recv(struct urb *urb, struct pt_regs *regs)
 
 	if (ir->send_flags == RECV_FLAG_IN_PROGRESS) {
 		ir->send_flags = SEND_FLAG_COMPLETE;
-		dev_dbg(ir->dev, "setup answer received %d bytes\n",
+		mce_dbg(ir->dev, "setup answer received %d bytes\n",
 			buf_len);
 	}
 
@@ -954,7 +960,7 @@ static void mceusb_dev_recv(struct urb *urb, struct pt_regs *regs)
 
 	case -EPIPE:
 	default:
-		dev_dbg(ir->dev, "Error: urb status = %d\n", urb->status);
+		mce_dbg(ir->dev, "Error: urb status = %d\n", urb->status);
 		break;
 	}
 
@@ -981,8 +987,8 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 	ret = usb_control_msg(ir->usbdev, usb_rcvctrlpipe(ir->usbdev, 0),
 			      USB_REQ_SET_ADDRESS, USB_TYPE_VENDOR, 0, 0,
 			      data, USB_CTRL_MSG_SZ, HZ * 3);
-	dev_dbg(dev, "%s - ret = %d\n", __func__, ret);
-	dev_dbg(dev, "%s - data[0] = %d, data[1] = %d\n",
+	mce_dbg(dev, "%s - ret = %d\n", __func__, ret);
+	mce_dbg(dev, "%s - data[0] = %d, data[1] = %d\n",
 		__func__, data[0], data[1]);
 
 	/* set feature: bit rate 38400 bps */
@@ -990,19 +996,19 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 			      USB_REQ_SET_FEATURE, USB_TYPE_VENDOR,
 			      0xc04e, 0x0000, NULL, 0, HZ * 3);
 
-	dev_dbg(dev, "%s - ret = %d\n", __func__, ret);
+	mce_dbg(dev, "%s - ret = %d\n", __func__, ret);
 
 	/* bRequest 4: set char length to 8 bits */
 	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
 			      4, USB_TYPE_VENDOR,
 			      0x0808, 0x0000, NULL, 0, HZ * 3);
-	dev_dbg(dev, "%s - retB = %d\n", __func__, ret);
+	mce_dbg(dev, "%s - retB = %d\n", __func__, ret);
 
 	/* bRequest 2: set handshaking to use DTR/DSR */
 	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
 			      2, USB_TYPE_VENDOR,
 			      0x0000, 0x0100, NULL, 0, HZ * 3);
-	dev_dbg(dev, "%s - retC = %d\n", __func__, ret);
+	mce_dbg(dev, "%s - retC = %d\n", __func__, ret);
 
 	/* device reset */
 	mce_async_out(ir, DEVICE_RESET, sizeof(DEVICE_RESET));
@@ -1125,7 +1131,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	bool tx_mask_normal;
 	int ir_intfnum;
 
-	dev_dbg(&intf->dev, "%s called\n", __func__);
+	mce_dbg(&intf->dev, "%s called\n", __func__);
 
 	idesc  = intf->cur_altsetting;
 
@@ -1153,7 +1159,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 			ep_in = ep;
 			ep_in->bmAttributes = USB_ENDPOINT_XFER_INT;
 			ep_in->bInterval = 1;
-			dev_dbg(&intf->dev, "acceptable inbound endpoint "
+			mce_dbg(&intf->dev, "acceptable inbound endpoint "
 				"found\n");
 		}
 
@@ -1168,12 +1174,12 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 			ep_out = ep;
 			ep_out->bmAttributes = USB_ENDPOINT_XFER_INT;
 			ep_out->bInterval = 1;
-			dev_dbg(&intf->dev, "acceptable outbound endpoint "
+			mce_dbg(&intf->dev, "acceptable outbound endpoint "
 				"found\n");
 		}
 	}
 	if (ep_in == NULL) {
-		dev_dbg(&intf->dev, "inbound and/or endpoint not found\n");
+		mce_dbg(&intf->dev, "inbound and/or endpoint not found\n");
 		return -ENODEV;
 	}
 
-- 
1.7.1

