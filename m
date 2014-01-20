Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:38728 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbaATWKr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 17:10:47 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 4/4] [media] mceusb: improve error logging
Date: Mon, 20 Jan 2014 22:10:44 +0000
Message-Id: <1390255844-21826-2-git-send-email-sean@mess.org>
In-Reply-To: <1390255844-21826-1-git-send-email-sean@mess.org>
References: <1390255844-21826-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A number of recent bug reports involve usb_submit_urb() failing which was
only reported with debug parameter on. In addition, remove custom debug
function.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/mceusb.c | 180 ++++++++++++++++++++++------------------------
 1 file changed, 84 insertions(+), 96 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 3a4f95f..2df5ac0 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -84,7 +84,7 @@
 #define MCE_PORT_IR		0x4	/* (0x4 << 5) | MCE_CMD = 0x9f */
 #define MCE_PORT_SYS		0x7	/* (0x7 << 5) | MCE_CMD = 0xff */
 #define MCE_PORT_SER		0x6	/* 0xc0 thru 0xdf flush & 0x1f bytes */
-#define MCE_PORT_MASK	0xe0	/* Mask out command bits */
+#define MCE_PORT_MASK		0xe0	/* Mask out command bits */
 
 /* Command port headers */
 #define MCE_CMD_PORT_IR		0x9f	/* IR-related cmd/rsp */
@@ -153,19 +153,6 @@
 #define MCE_COMMAND_IRDATA	0x80
 #define MCE_PACKET_LENGTH_MASK	0x1f /* Packet length mask */
 
-/* module parameters */
-#ifdef CONFIG_USB_DEBUG
-static bool debug = 1;
-#else
-static bool debug;
-#endif
-
-#define mce_dbg(dev, fmt, ...)					\
-	do {							\
-		if (debug)					\
-			dev_info(dev, fmt, ## __VA_ARGS__);	\
-	} while (0)
-
 #define VENDOR_PHILIPS		0x0471
 #define VENDOR_SMK		0x0609
 #define VENDOR_TATUNG		0x1460
@@ -531,16 +518,13 @@ static int mceusb_cmd_datasize(u8 cmd, u8 subcmd)
 static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 				 int offset, int len, bool out)
 {
-	char codes[USB_BUFLEN * 3 + 1];
-	char inout[9];
+#if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
+	char *inout;
 	u8 cmd, subcmd, data1, data2, data3, data4;
 	struct device *dev = ir->dev;
-	int i, start, skip = 0;
+	int start, skip = 0;
 	u32 carrier, period;
 
-	if (!debug)
-		return;
-
 	/* skip meaningless 0xb1 0x60 header bytes on orig receiver */
 	if (ir->flags.microsoft_gen1 && !out && !offset)
 		skip = 2;
@@ -548,16 +532,10 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 	if (len <= skip)
 		return;
 
-	for (i = 0; i < len && i < USB_BUFLEN; i++)
-		snprintf(codes + i * 3, 4, "%02x ", buf[i + offset] & 0xff);
-
-	dev_info(dev, "%sx data: %s(length=%d)\n",
-		 (out ? "t" : "r"), codes, len);
+	dev_dbg(dev, "%cx data: %*ph (length=%d)",
+		(out ? 't' : 'r'), min(len, USB_BUFLEN), buf, len);
 
-	if (out)
-		strcpy(inout, "Request\0");
-	else
-		strcpy(inout, "Got\0");
+	inout = out ? "Request" : "Got";
 
 	start  = offset + skip;
 	cmd    = buf[start] & 0xff;
@@ -573,50 +551,50 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 			break;
 		if ((subcmd == MCE_CMD_PORT_SYS) &&
 		    (data1 == MCE_CMD_RESUME))
-			dev_info(dev, "Device resume requested\n");
+			dev_dbg(dev, "Device resume requested");
 		else
-			dev_info(dev, "Unknown command 0x%02x 0x%02x\n",
+			dev_dbg(dev, "Unknown command 0x%02x 0x%02x",
 				 cmd, subcmd);
 		break;
 	case MCE_CMD_PORT_SYS:
 		switch (subcmd) {
 		case MCE_RSP_EQEMVER:
 			if (!out)
-				dev_info(dev, "Emulator interface version %x\n",
+				dev_dbg(dev, "Emulator interface version %x",
 					 data1);
 			break;
 		case MCE_CMD_G_REVISION:
 			if (len == 2)
-				dev_info(dev, "Get hw/sw rev?\n");
+				dev_dbg(dev, "Get hw/sw rev?");
 			else
-				dev_info(dev, "hw/sw rev 0x%02x 0x%02x "
-					 "0x%02x 0x%02x\n", data1, data2,
+				dev_dbg(dev, "hw/sw rev 0x%02x 0x%02x 0x%02x 0x%02x",
+					 data1, data2,
 					 buf[start + 4], buf[start + 5]);
 			break;
 		case MCE_CMD_RESUME:
-			dev_info(dev, "Device resume requested\n");
+			dev_dbg(dev, "Device resume requested");
 			break;
 		case MCE_RSP_CMD_ILLEGAL:
-			dev_info(dev, "Illegal PORT_SYS command\n");
+			dev_dbg(dev, "Illegal PORT_SYS command");
 			break;
 		case MCE_RSP_EQWAKEVERSION:
 			if (!out)
-				dev_info(dev, "Wake version, proto: 0x%02x, "
+				dev_dbg(dev, "Wake version, proto: 0x%02x, "
 					 "payload: 0x%02x, address: 0x%02x, "
-					 "version: 0x%02x\n",
+					 "version: 0x%02x",
 					 data1, data2, data3, data4);
 			break;
 		case MCE_RSP_GETPORTSTATUS:
 			if (!out)
 				/* We use data1 + 1 here, to match hw labels */
-				dev_info(dev, "TX port %d: blaster is%s connected\n",
+				dev_dbg(dev, "TX port %d: blaster is%s connected",
 					 data1 + 1, data4 ? " not" : "");
 			break;
 		case MCE_CMD_FLASHLED:
-			dev_info(dev, "Attempting to flash LED\n");
+			dev_dbg(dev, "Attempting to flash LED");
 			break;
 		default:
-			dev_info(dev, "Unknown command 0x%02x 0x%02x\n",
+			dev_dbg(dev, "Unknown command 0x%02x 0x%02x",
 				 cmd, subcmd);
 			break;
 		}
@@ -624,13 +602,13 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 	case MCE_CMD_PORT_IR:
 		switch (subcmd) {
 		case MCE_CMD_SIG_END:
-			dev_info(dev, "End of signal\n");
+			dev_dbg(dev, "End of signal");
 			break;
 		case MCE_CMD_PING:
-			dev_info(dev, "Ping\n");
+			dev_dbg(dev, "Ping");
 			break;
 		case MCE_CMD_UNKNOWN:
-			dev_info(dev, "Resp to 9f 05 of 0x%02x 0x%02x\n",
+			dev_dbg(dev, "Resp to 9f 05 of 0x%02x 0x%02x",
 				 data1, data2);
 			break;
 		case MCE_RSP_EQIRCFS:
@@ -639,51 +617,51 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 			if (!period)
 				break;
 			carrier = (1000 * 1000) / period;
-			dev_info(dev, "%s carrier of %u Hz (period %uus)\n",
+			dev_dbg(dev, "%s carrier of %u Hz (period %uus)",
 				 inout, carrier, period);
 			break;
 		case MCE_CMD_GETIRCFS:
-			dev_info(dev, "Get carrier mode and freq\n");
+			dev_dbg(dev, "Get carrier mode and freq");
 			break;
 		case MCE_RSP_EQIRTXPORTS:
-			dev_info(dev, "%s transmit blaster mask of 0x%02x\n",
+			dev_dbg(dev, "%s transmit blaster mask of 0x%02x",
 				 inout, data1);
 			break;
 		case MCE_RSP_EQIRTIMEOUT:
 			/* value is in units of 50us, so x*50/1000 ms */
 			period = ((data1 << 8) | data2) * MCE_TIME_UNIT / 1000;
-			dev_info(dev, "%s receive timeout of %d ms\n",
+			dev_dbg(dev, "%s receive timeout of %d ms",
 				 inout, period);
 			break;
 		case MCE_CMD_GETIRTIMEOUT:
-			dev_info(dev, "Get receive timeout\n");
+			dev_dbg(dev, "Get receive timeout");
 			break;
 		case MCE_CMD_GETIRTXPORTS:
-			dev_info(dev, "Get transmit blaster mask\n");
+			dev_dbg(dev, "Get transmit blaster mask");
 			break;
 		case MCE_RSP_EQIRRXPORTEN:
-			dev_info(dev, "%s %s-range receive sensor in use\n",
+			dev_dbg(dev, "%s %s-range receive sensor in use",
 				 inout, data1 == 0x02 ? "short" : "long");
 			break;
 		case MCE_CMD_GETIRRXPORTEN:
 		/* aka MCE_RSP_EQIRRXCFCNT */
 			if (out)
-				dev_info(dev, "Get receive sensor\n");
+				dev_dbg(dev, "Get receive sensor");
 			else if (ir->learning_enabled)
-				dev_info(dev, "RX pulse count: %d\n",
+				dev_dbg(dev, "RX pulse count: %d",
 					 ((data1 << 8) | data2));
 			break;
 		case MCE_RSP_EQIRNUMPORTS:
 			if (out)
 				break;
-			dev_info(dev, "Num TX ports: %x, num RX ports: %x\n",
+			dev_dbg(dev, "Num TX ports: %x, num RX ports: %x",
 				 data1, data2);
 			break;
 		case MCE_RSP_CMD_ILLEGAL:
-			dev_info(dev, "Illegal PORT_IR command\n");
+			dev_dbg(dev, "Illegal PORT_IR command");
 			break;
 		default:
-			dev_info(dev, "Unknown command 0x%02x 0x%02x\n",
+			dev_dbg(dev, "Unknown command 0x%02x 0x%02x",
 				 cmd, subcmd);
 			break;
 		}
@@ -693,10 +671,11 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 	}
 
 	if (cmd == MCE_IRDATA_TRAILER)
-		dev_info(dev, "End of raw IR data\n");
+		dev_dbg(dev, "End of raw IR data");
 	else if ((cmd != MCE_CMD_PORT_IR) &&
 		 ((cmd & MCE_PORT_MASK) == MCE_COMMAND_IRDATA))
-		dev_info(dev, "Raw IR data, %d pulse/space samples\n", ir->rem);
+		dev_dbg(dev, "Raw IR data, %d pulse/space samples", ir->rem);
+#endif
 }
 
 static void mce_async_callback(struct urb *urb)
@@ -708,10 +687,25 @@ static void mce_async_callback(struct urb *urb)
 		return;
 
 	ir = urb->context;
-	if (ir) {
+
+	switch (urb->status) {
+	/* success */
+	case 0:
 		len = urb->actual_length;
 
 		mceusb_dev_printdata(ir, urb->transfer_buffer, 0, len, true);
+		break;
+
+	case -ECONNRESET:
+	case -ENOENT:
+	case -EILSEQ:
+	case -ESHUTDOWN:
+		break;
+
+	case -EPIPE:
+	default:
+		dev_err(ir->dev, "Error: request urb status = %d", urb->status);
+		break;
 	}
 
 	/* the transfer buffer and urb were allocated in mce_request_packet */
@@ -744,17 +738,17 @@ static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
 			mce_async_callback, ir, ir->usb_ep_out->bInterval);
 	memcpy(async_buf, data, size);
 
-	mce_dbg(dev, "receive request called (size=%#x)\n", size);
+	dev_dbg(dev, "receive request called (size=%#x)", size);
 
 	async_urb->transfer_buffer_length = size;
 	async_urb->dev = ir->usbdev;
 
 	res = usb_submit_urb(async_urb, GFP_ATOMIC);
 	if (res) {
-		mce_dbg(dev, "receive request FAILED! (res=%d)\n", res);
+		dev_err(dev, "receive request FAILED! (res=%d)", res);
 		return;
 	}
-	mce_dbg(dev, "receive request complete (res=%d)\n", res);
+	dev_dbg(dev, "receive request complete (res=%d)", res);
 }
 
 static void mce_async_out(struct mceusb_dev *ir, unsigned char *data, int size)
@@ -864,8 +858,7 @@ static int mceusb_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 			ir->carrier = carrier;
 			cmdbuf[2] = MCE_CMD_SIG_END;
 			cmdbuf[3] = MCE_IRDATA_TRAILER;
-			mce_dbg(ir->dev, "%s: disabling carrier "
-				"modulation\n", __func__);
+			dev_dbg(ir->dev, "disabling carrier modulation");
 			mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
 			return carrier;
 		}
@@ -876,8 +869,8 @@ static int mceusb_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 				ir->carrier = carrier;
 				cmdbuf[2] = prescaler;
 				cmdbuf[3] = divisor;
-				mce_dbg(ir->dev, "%s: requesting %u HZ "
-					"carrier\n", __func__, carrier);
+				dev_dbg(ir->dev, "requesting %u HZ carrier",
+								carrier);
 
 				/* Transmit new carrier to mce device */
 				mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
@@ -967,7 +960,7 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
 					 * US_TO_NS(MCE_TIME_UNIT);
 
-			mce_dbg(ir->dev, "Storing %s with duration %d\n",
+			dev_dbg(ir->dev, "Storing %s with duration %d",
 				rawir.pulse ? "pulse" : "space",
 				rawir.duration);
 
@@ -1001,7 +994,7 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			ir->parser_state = CMD_HEADER;
 	}
 	if (event) {
-		mce_dbg(ir->dev, "processed IR data, calling ir_raw_event_handle\n");
+		dev_dbg(ir->dev, "processed IR data");
 		ir_raw_event_handle(ir->rc);
 	}
 }
@@ -1027,13 +1020,14 @@ static void mceusb_dev_recv(struct urb *urb)
 
 	case -ECONNRESET:
 	case -ENOENT:
+	case -EILSEQ:
 	case -ESHUTDOWN:
 		usb_unlink_urb(urb);
 		return;
 
 	case -EPIPE:
 	default:
-		mce_dbg(ir->dev, "Error: urb status = %d\n", urb->status);
+		dev_err(ir->dev, "Error: urb status = %d", urb->status);
 		break;
 	}
 
@@ -1055,7 +1049,7 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 
 	data = kzalloc(USB_CTRL_MSG_SZ, GFP_KERNEL);
 	if (!data) {
-		dev_err(dev, "%s: memory allocation failed!\n", __func__);
+		dev_err(dev, "%s: memory allocation failed!", __func__);
 		return;
 	}
 
@@ -1066,28 +1060,28 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 	ret = usb_control_msg(ir->usbdev, usb_rcvctrlpipe(ir->usbdev, 0),
 			      USB_REQ_SET_ADDRESS, USB_TYPE_VENDOR, 0, 0,
 			      data, USB_CTRL_MSG_SZ, HZ * 3);
-	mce_dbg(dev, "%s - ret = %d\n", __func__, ret);
-	mce_dbg(dev, "%s - data[0] = %d, data[1] = %d\n",
-		__func__, data[0], data[1]);
+	dev_dbg(dev, "set address - ret = %d", ret);
+	dev_dbg(dev, "set address - data[0] = %d, data[1] = %d",
+						data[0], data[1]);
 
 	/* set feature: bit rate 38400 bps */
 	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
 			      USB_REQ_SET_FEATURE, USB_TYPE_VENDOR,
 			      0xc04e, 0x0000, NULL, 0, HZ * 3);
 
-	mce_dbg(dev, "%s - ret = %d\n", __func__, ret);
+	dev_dbg(dev, "set feature - ret = %d", ret);
 
 	/* bRequest 4: set char length to 8 bits */
 	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
 			      4, USB_TYPE_VENDOR,
 			      0x0808, 0x0000, NULL, 0, HZ * 3);
-	mce_dbg(dev, "%s - retB = %d\n", __func__, ret);
+	dev_dbg(dev, "set char length - retB = %d", ret);
 
 	/* bRequest 2: set handshaking to use DTR/DSR */
 	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
 			      2, USB_TYPE_VENDOR,
 			      0x0000, 0x0100, NULL, 0, HZ * 3);
-	mce_dbg(dev, "%s - retC = %d\n", __func__, ret);
+	dev_dbg(dev, "set handshake  - retC = %d", ret);
 
 	/* device resume */
 	mce_async_out(ir, DEVICE_RESUME, sizeof(DEVICE_RESUME));
@@ -1158,7 +1152,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 
 	rc = rc_allocate_device();
 	if (!rc) {
-		dev_err(dev, "remote dev allocation failed\n");
+		dev_err(dev, "remote dev allocation failed");
 		goto out;
 	}
 
@@ -1190,7 +1184,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 
 	ret = rc_register_device(rc);
 	if (ret < 0) {
-		dev_err(dev, "remote dev registration failed\n");
+		dev_err(dev, "remote dev registration failed");
 		goto out;
 	}
 
@@ -1218,7 +1212,7 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 	bool tx_mask_normal;
 	int ir_intfnum;
 
-	mce_dbg(&intf->dev, "%s called\n", __func__);
+	dev_dbg(&intf->dev, "%s called", __func__);
 
 	idesc  = intf->cur_altsetting;
 
@@ -1246,8 +1240,7 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 			ep_in = ep;
 			ep_in->bmAttributes = USB_ENDPOINT_XFER_INT;
 			ep_in->bInterval = 1;
-			mce_dbg(&intf->dev, "acceptable inbound endpoint "
-				"found\n");
+			dev_dbg(&intf->dev, "acceptable inbound endpoint found");
 		}
 
 		if ((ep_out == NULL)
@@ -1261,12 +1254,11 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 			ep_out = ep;
 			ep_out->bmAttributes = USB_ENDPOINT_XFER_INT;
 			ep_out->bInterval = 1;
-			mce_dbg(&intf->dev, "acceptable outbound endpoint "
-				"found\n");
+			dev_dbg(&intf->dev, "acceptable outbound endpoint found");
 		}
 	}
 	if (ep_in == NULL) {
-		mce_dbg(&intf->dev, "inbound and/or endpoint not found\n");
+		dev_dbg(&intf->dev, "inbound and/or endpoint not found");
 		return -ENODEV;
 	}
 
@@ -1314,7 +1306,7 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 
 	res = usb_submit_urb(ir->urb_in, GFP_KERNEL);
 	if (res) {
-		dev_err(&intf->dev, "failed to submit urb: %d\n", res);
+		dev_err(&intf->dev, "failed to submit urb: %d", res);
 		goto usb_submit_fail;
 	}
 
@@ -1344,10 +1336,9 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 	device_set_wakeup_capable(ir->dev, true);
 	device_set_wakeup_enable(ir->dev, true);
 
-	dev_info(&intf->dev, "Registered %s with mce emulator interface "
-		 "version %x\n", name, ir->emver);
-	dev_info(&intf->dev, "%x tx ports (0x%x cabled) and "
-		 "%x rx sensors (0x%x active)\n",
+	dev_info(&intf->dev, "Registered %s with mce emulator interface version %x",
+		name, ir->emver);
+	dev_info(&intf->dev, "%x tx ports (0x%x cabled) and %x rx sensors (0x%x active)",
 		 ir->num_txports, ir->txports_cabled,
 		 ir->num_rxports, ir->rxports_active);
 
@@ -1363,7 +1354,7 @@ urb_in_alloc_fail:
 buf_in_alloc_fail:
 	kfree(ir);
 mem_alloc_fail:
-	dev_err(&intf->dev, "%s: device setup failed!\n", __func__);
+	dev_err(&intf->dev, "%s: device setup failed!", __func__);
 
 	return -ENOMEM;
 }
@@ -1391,7 +1382,7 @@ static void mceusb_dev_disconnect(struct usb_interface *intf)
 static int mceusb_dev_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct mceusb_dev *ir = usb_get_intfdata(intf);
-	dev_info(ir->dev, "suspend\n");
+	dev_info(ir->dev, "suspend");
 	usb_kill_urb(ir->urb_in);
 	return 0;
 }
@@ -1399,7 +1390,7 @@ static int mceusb_dev_suspend(struct usb_interface *intf, pm_message_t message)
 static int mceusb_dev_resume(struct usb_interface *intf)
 {
 	struct mceusb_dev *ir = usb_get_intfdata(intf);
-	dev_info(ir->dev, "resume\n");
+	dev_info(ir->dev, "resume");
 	if (usb_submit_urb(ir->urb_in, GFP_ATOMIC))
 		return -EIO;
 	return 0;
@@ -1421,6 +1412,3 @@ MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(usb, mceusb_dev_table);
-
-module_param(debug, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(debug, "Debug enabled or not");
-- 
1.8.4.2

