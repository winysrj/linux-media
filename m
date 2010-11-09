Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172Ab0KIVlG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 16:41:06 -0500
Date: Tue, 9 Nov 2010 16:41:03 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Subject: [PATCH 1/3 v2] mceusb: fix up reporting of trailing space
Message-ID: <20101109214103.GE11073@redhat.com>
References: <20101109213921.GD11073@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101109213921.GD11073@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

We were storing a bunch of spaces at the end of each signal, rather than
a single long space. The in-kernel decoders were actually okay with
this, but lirc isn't. As suggested by David Härdeman, switch to storing
samples using ir_raw_event_store_with_filter, which auto-merges the
consecutive space samples for us. This also allows us to bypass having
to store rawir samples in our device struct, further simplifying the
buffer parsing state machine. Both in-kernel decoders and lirc are happy
again with this change.

Also included in this patch is proper parsing of 0x9f 0x01 commands, the
removal of some magic number usage and some printk spew fixups.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/mceusb.c |   45 +++++++++++++--------------------------------
 1 files changed, 13 insertions(+), 32 deletions(-)

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index e453c6b..1811098 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -74,6 +74,7 @@
 #define MCE_PACKET_LENGTH_MASK	0x1f /* Packet length mask */
 
 /* Sub-commands, which follow MCE_COMMAND_HEADER or MCE_HW_CMD_HEADER */
+#define MCE_CMD_SIG_END		0x01	/* End of signal */
 #define MCE_CMD_PING		0x03	/* Ping device */
 #define MCE_CMD_UNKNOWN		0x04	/* Unknown */
 #define MCE_CMD_UNKNOWN2	0x05	/* Unknown */
@@ -422,6 +423,7 @@ static int mceusb_cmdsize(u8 cmd, u8 subcmd)
 		case MCE_CMD_G_RXSENSOR:
 			datasize = 2;
 			break;
+		case MCE_CMD_SIG_END:
 		case MCE_CMD_S_TXMASK:
 		case MCE_CMD_S_RXSENSOR:
 			datasize = 1;
@@ -502,6 +504,9 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 		break;
 	case MCE_COMMAND_HEADER:
 		switch (subcmd) {
+		case MCE_CMD_SIG_END:
+			dev_info(dev, "End of signal\n");
+			break;
 		case MCE_CMD_PING:
 			dev_info(dev, "Ping\n");
 			break;
@@ -539,7 +544,7 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 			if (len == 2)
 				dev_info(dev, "Get receive sensor\n");
 			else
-				dev_info(dev, "Received pulse count is %d\n",
+				dev_info(dev, "Remaining pulse count is %d\n",
 					 ((data1 << 8) | data2));
 			break;
 		case MCE_RSP_CMD_INVALID:
@@ -763,7 +768,7 @@ static int mceusb_set_tx_carrier(void *priv, u32 carrier)
 
 		if (carrier == 0) {
 			ir->carrier = carrier;
-			cmdbuf[2] = 0x01;
+			cmdbuf[2] = MCE_CMD_SIG_END;
 			cmdbuf[3] = MCE_IRDATA_TRAILER;
 			dev_dbg(ir->dev, "%s: disabling carrier "
 				"modulation\n", __func__);
@@ -816,25 +821,11 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
 					 * MCE_TIME_UNIT * 1000;
 
-			if ((ir->buf_in[i] & MCE_PULSE_MASK) == 0x7f) {
-				if (ir->rawir.pulse == rawir.pulse) {
-					ir->rawir.duration += rawir.duration;
-				} else {
-					ir->rawir.duration = rawir.duration;
-					ir->rawir.pulse = rawir.pulse;
-				}
-				if (ir->rem)
-					break;
-			}
-			rawir.duration += ir->rawir.duration;
-			ir->rawir.duration = 0;
-			ir->rawir.pulse = rawir.pulse;
-
 			dev_dbg(ir->dev, "Storing %s with duration %d\n",
 				rawir.pulse ? "pulse" : "space",
 				rawir.duration);
 
-			ir_raw_event_store(ir->idev, &rawir);
+			ir_raw_event_store_with_filter(ir->idev, &rawir);
 			break;
 		case CMD_DATA:
 			ir->rem--;
@@ -851,16 +842,8 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			}
 			ir->rem = (ir->cmd & MCE_PACKET_LENGTH_MASK);
 			mceusb_dev_printdata(ir, ir->buf_in, i, ir->rem + 1, false);
-			if (ir->rem) {
+			if (ir->rem)
 				ir->parser_state = PARSE_IRDATA;
-				break;
-			}
-			/*
-			 * a package with len=0 (e. g. 0x80) means end of
-			 * data. We could use it to do the call to
-			 * ir_raw_event_handle(). For now, we don't need to
-			 * use it.
-			 */
 			break;
 		}
 
@@ -1092,7 +1075,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	bool tx_mask_inverted;
 	bool is_polaris;
 
-	dev_dbg(&intf->dev, ": %s called\n", __func__);
+	dev_dbg(&intf->dev, "%s called\n", __func__);
 
 	idesc  = intf->cur_altsetting;
 
@@ -1122,7 +1105,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 			ep_in = ep;
 			ep_in->bmAttributes = USB_ENDPOINT_XFER_INT;
 			ep_in->bInterval = 1;
-			dev_dbg(&intf->dev, ": acceptable inbound endpoint "
+			dev_dbg(&intf->dev, "acceptable inbound endpoint "
 				"found\n");
 		}
 
@@ -1137,12 +1120,12 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 			ep_out = ep;
 			ep_out->bmAttributes = USB_ENDPOINT_XFER_INT;
 			ep_out->bInterval = 1;
-			dev_dbg(&intf->dev, ": acceptable outbound endpoint "
+			dev_dbg(&intf->dev, "acceptable outbound endpoint "
 				"found\n");
 		}
 	}
 	if (ep_in == NULL) {
-		dev_dbg(&intf->dev, ": inbound and/or endpoint not found\n");
+		dev_dbg(&intf->dev, "inbound and/or endpoint not found\n");
 		return -ENODEV;
 	}
 
@@ -1169,8 +1152,6 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	ir->flags.no_tx = mceusb_model[model].no_tx;
 	ir->model = model;
 
-	init_ir_raw_event(&ir->rawir);
-
 	/* Saving usb interface data for use by the transmitter routine */
 	ir->usb_ep_in = ep_in;
 	ir->usb_ep_out = ep_out;
-- 
1.7.1


-- 
Jarod Wilson
jarod@redhat.com

