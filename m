Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:35089 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751392AbeCEPeD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Mar 2018 10:34:03 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/3] Revert "[media] staging: lirc_imon: port remaining usb ids to imon and remove"
Date: Mon,  5 Mar 2018 15:34:00 +0000
Message-Id: <20180305153402.24141-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This code was ported without the necessary hardware to test. There
are multiple problems which are more easily solved by writing a
separate driver.

This reverts commit f41003a23a02dc7299539300f74360c2a932714a.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/imon.c | 135 +++---------------------------------------------
 1 file changed, 7 insertions(+), 128 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 950d068ba806..527920a59d99 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -92,7 +92,6 @@ struct imon_usb_dev_descr {
 	__u16 flags;
 #define IMON_NO_FLAGS 0
 #define IMON_NEED_20MS_PKT_DELAY 1
-#define IMON_IR_RAW 2
 	struct imon_panel_key_table key_table[];
 };
 
@@ -123,12 +122,6 @@ struct imon_context {
 	unsigned char usb_tx_buf[8];
 	unsigned int send_packet_delay;
 
-	struct rx_data {
-		int count;		/* length of 0 or 1 sequence */
-		int prev_bit;		/* logic level of sequence */
-		int initial_space;	/* initial space flag */
-	} rx;
-
 	struct tx_t {
 		unsigned char data_buf[35];	/* user data buffer */
 		struct completion finished;	/* wait for write to finish */
@@ -331,10 +324,6 @@ static const struct imon_usb_dev_descr imon_DH102 = {
 	}
 };
 
-static const struct imon_usb_dev_descr imon_ir_raw = {
-	.flags = IMON_IR_RAW,
-};
-
 /*
  * USB Device ID for iMON USB Control Boards
  *
@@ -418,18 +407,6 @@ static const struct usb_device_id imon_usb_id_table[] = {
 	/* device specifics unknown */
 	{ USB_DEVICE(0x15c2, 0x0046),
 	  .driver_info = (unsigned long)&imon_default_table},
-	/* TriGem iMON (IR only) -- TG_iMON.inf */
-	{ USB_DEVICE(0x0aa8, 0x8001),
-	  .driver_info = (unsigned long)&imon_ir_raw},
-	/* SoundGraph iMON (IR only) -- sg_imon.inf */
-	{ USB_DEVICE(0x04e8, 0xff30),
-	  .driver_info = (unsigned long)&imon_ir_raw},
-	/* SoundGraph iMON VFD (IR & VFD) -- iMON_VFD.inf */
-	{ USB_DEVICE(0x0aa8, 0xffda),
-	  .driver_info = (unsigned long)&imon_ir_raw},
-	/* SoundGraph iMON SS (IR & VFD) -- iMON_SS.inf */
-	{ USB_DEVICE(0x15c2, 0xffda),
-	  .driver_info = (unsigned long)&imon_ir_raw},
 	{}
 };
 
@@ -1572,91 +1549,8 @@ static int imon_parse_press_type(struct imon_context *ictx,
 /*
  * Process the incoming packet
  */
-/*
- * Convert bit count to time duration (in us) and submit
- * the value to lirc_dev.
- */
-static void submit_data(struct imon_context *context)
-{
-	DEFINE_IR_RAW_EVENT(ev);
-
-	ev.pulse = context->rx.prev_bit;
-	ev.duration = US_TO_NS(context->rx.count * BIT_DURATION);
-	ir_raw_event_store_with_filter(context->rdev, &ev);
-}
-
-/*
- * Process the incoming packet
- */
-static void imon_incoming_ir_raw(struct imon_context *context,
+static void imon_incoming_packet(struct imon_context *ictx,
 				 struct urb *urb, int intf)
-{
-	int len = urb->actual_length;
-	unsigned char *buf = urb->transfer_buffer;
-	struct device *dev = context->dev;
-	int octet, bit;
-	unsigned char mask;
-
-	if (len != 8) {
-		dev_warn(dev, "imon %s: invalid incoming packet size (len = %d, intf%d)\n",
-			 __func__, len, intf);
-		return;
-	}
-
-	if (debug)
-		dev_info(dev, "raw packet: %*ph\n", len, buf);
-	/*
-	 * Translate received data to pulse and space lengths.
-	 * Received data is active low, i.e. pulses are 0 and
-	 * spaces are 1.
-	 *
-	 * My original algorithm was essentially similar to
-	 * Changwoo Ryu's with the exception that he switched
-	 * the incoming bits to active high and also fed an
-	 * initial space to LIRC at the start of a new sequence
-	 * if the previous bit was a pulse.
-	 *
-	 * I've decided to adopt his algorithm.
-	 */
-
-	if (buf[7] == 1 && context->rx.initial_space) {
-		/* LIRC requires a leading space */
-		context->rx.prev_bit = 0;
-		context->rx.count = 4;
-		submit_data(context);
-		context->rx.count = 0;
-	}
-
-	for (octet = 0; octet < 5; ++octet) {
-		mask = 0x80;
-		for (bit = 0; bit < 8; ++bit) {
-			int curr_bit = !(buf[octet] & mask);
-
-			if (curr_bit != context->rx.prev_bit) {
-				if (context->rx.count) {
-					submit_data(context);
-					context->rx.count = 0;
-				}
-				context->rx.prev_bit = curr_bit;
-			}
-			++context->rx.count;
-			mask >>= 1;
-		}
-	}
-
-	if (buf[7] == 10) {
-		if (context->rx.count) {
-			submit_data(context);
-			context->rx.count = 0;
-		}
-		context->rx.initial_space = context->rx.prev_bit;
-	}
-
-	ir_raw_event_handle(context->rdev);
-}
-
-static void imon_incoming_scancode(struct imon_context *ictx,
-				   struct urb *urb, int intf)
 {
 	int len = urb->actual_length;
 	unsigned char *buf = urb->transfer_buffer;
@@ -1839,10 +1733,7 @@ static void usb_rx_callback_intf0(struct urb *urb)
 		break;
 
 	case 0:
-		if (ictx->rdev->driver_type == RC_DRIVER_IR_RAW)
-			imon_incoming_ir_raw(ictx, urb, intfnum);
-		else
-			imon_incoming_scancode(ictx, urb, intfnum);
+		imon_incoming_packet(ictx, urb, intfnum);
 		break;
 
 	default:
@@ -1883,10 +1774,7 @@ static void usb_rx_callback_intf1(struct urb *urb)
 		break;
 
 	case 0:
-		if (ictx->rdev->driver_type == RC_DRIVER_IR_RAW)
-			imon_incoming_ir_raw(ictx, urb, intfnum);
-		else
-			imon_incoming_scancode(ictx, urb, intfnum);
+		imon_incoming_packet(ictx, urb, intfnum);
 		break;
 
 	default:
@@ -2000,14 +1888,11 @@ static void imon_set_display_type(struct imon_context *ictx)
 		case 0x0041:
 		case 0x0042:
 		case 0x0043:
-		case 0x8001:
-		case 0xff30:
 			configured_display_type = IMON_DISPLAY_TYPE_NONE;
 			ictx->display_supported = false;
 			break;
 		case 0x0036:
 		case 0x0044:
-		case 0xffda:
 		default:
 			configured_display_type = IMON_DISPLAY_TYPE_VFD;
 			break;
@@ -2032,8 +1917,7 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 	static const unsigned char fp_packet[] = {
 		0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x88 };
 
-	rdev = rc_allocate_device(ictx->dev_descr->flags & IMON_IR_RAW ?
-				  RC_DRIVER_IR_RAW : RC_DRIVER_SCANCODE);
+	rdev = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!rdev) {
 		dev_err(ictx->dev, "remote control dev allocation failed\n");
 		goto out;
@@ -2051,12 +1935,8 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 	rdev->dev.parent = ictx->dev;
 
 	rdev->priv = ictx;
-	if (ictx->dev_descr->flags & IMON_IR_RAW)
-		rdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
-	else
-		/* iMON PAD or MCE */
-		rdev->allowed_protocols = RC_PROTO_BIT_OTHER |
-					  RC_PROTO_BIT_RC6_MCE;
+	/* iMON PAD or MCE */
+	rdev->allowed_protocols = RC_PROTO_BIT_OTHER | RC_PROTO_BIT_RC6_MCE;
 	rdev->change_protocol = imon_ir_change_protocol;
 	rdev->driver_name = MOD_NAME;
 
@@ -2074,8 +1954,7 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 
 	imon_set_display_type(ictx);
 
-	if (ictx->rc_proto == RC_PROTO_BIT_RC6_MCE ||
-	    ictx->dev_descr->flags & IMON_IR_RAW)
+	if (ictx->rc_proto == RC_PROTO_BIT_RC6_MCE)
 		rdev->map_name = RC_MAP_IMON_MCE;
 	else
 		rdev->map_name = RC_MAP_IMON_PAD;
-- 
2.14.3
