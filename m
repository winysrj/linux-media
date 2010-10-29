Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:17375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106Ab0J2DIL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 23:08:11 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9T38BMa005163
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 23:08:11 -0400
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id o9T38Bjk030994
	for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 23:08:11 -0400
Date: Thu, 28 Oct 2010 23:08:10 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/3] mceusb: fix up reporting of trailing space
Message-ID: <20101029030810.GC17238@redhat.com>
References: <20101029030545.GA17238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029030545.GA17238@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

We were storing a bunch of spaces at the end of each signal, rather than
a single long space. The in-kernel decoders were actually okay with
this, but lirc isn't. Both are happy again with this change, which
starts accumulating data upon seeing an 0x7f space, and then stores it
when we see the next non-space, non-0x7f space, or an 0x80 end of signal
command. To get to that final 0x80 properly, we also need to support
proper parsing of 0x9f 0x01 commands, support for which is also added.

Also remove an obsolete include, some stray colon-space pairs from
prior to conversion to dev_foo printk macros and a magic number.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/mceusb.c |   39 +++++++++++++++++++++++----------------
 1 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index e453c6b..a05dec7 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -38,7 +38,6 @@
 #include <linux/usb.h>
 #include <linux/input.h>
 #include <media/ir-core.h>
-#include <media/ir-common.h>
 
 #define DRIVER_VERSION	"1.91"
 #define DRIVER_AUTHOR	"Jarod Wilson <jarod@wilsonet.com>"
@@ -74,6 +73,7 @@
 #define MCE_PACKET_LENGTH_MASK	0x1f /* Packet length mask */
 
 /* Sub-commands, which follow MCE_COMMAND_HEADER or MCE_HW_CMD_HEADER */
+#define MCE_CMD_SIG_END		0x01	/* End of signal */
 #define MCE_CMD_PING		0x03	/* Ping device */
 #define MCE_CMD_UNKNOWN		0x04	/* Unknown */
 #define MCE_CMD_UNKNOWN2	0x05	/* Unknown */
@@ -422,6 +422,7 @@ static int mceusb_cmdsize(u8 cmd, u8 subcmd)
 		case MCE_CMD_G_RXSENSOR:
 			datasize = 2;
 			break;
+		case MCE_CMD_SIG_END:
 		case MCE_CMD_S_TXMASK:
 		case MCE_CMD_S_RXSENSOR:
 			datasize = 1;
@@ -502,6 +503,9 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 		break;
 	case MCE_COMMAND_HEADER:
 		switch (subcmd) {
+		case MCE_CMD_SIG_END:
+			dev_info(dev, "End of signal\n");
+			break;
 		case MCE_CMD_PING:
 			dev_info(dev, "Ping\n");
 			break;
@@ -539,7 +543,7 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 			if (len == 2)
 				dev_info(dev, "Get receive sensor\n");
 			else
-				dev_info(dev, "Received pulse count is %d\n",
+				dev_info(dev, "Remaining pulse count is %d\n",
 					 ((data1 << 8) | data2));
 			break;
 		case MCE_RSP_CMD_INVALID:
@@ -763,7 +767,7 @@ static int mceusb_set_tx_carrier(void *priv, u32 carrier)
 
 		if (carrier == 0) {
 			ir->carrier = carrier;
-			cmdbuf[2] = 0x01;
+			cmdbuf[2] = MCE_CMD_SIG_END;
 			cmdbuf[3] = MCE_IRDATA_TRAILER;
 			dev_dbg(ir->dev, "%s: disabling carrier "
 				"modulation\n", __func__);
@@ -823,8 +827,11 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 					ir->rawir.duration = rawir.duration;
 					ir->rawir.pulse = rawir.pulse;
 				}
-				if (ir->rem)
-					break;
+				if (!ir->rem)
+					ir->parser_state = CMD_HEADER;
+				dev_dbg(ir->dev, "Accumulating %d worth of "
+					"space\n", rawir.duration);
+				break;
 			}
 			rawir.duration += ir->rawir.duration;
 			ir->rawir.duration = 0;
@@ -853,14 +860,14 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			mceusb_dev_printdata(ir, ir->buf_in, i, ir->rem + 1, false);
 			if (ir->rem) {
 				ir->parser_state = PARSE_IRDATA;
-				break;
+			} else if (ir->rawir.duration) {
+				/* this means we've encounter an 0x80 pkt,
+				 * which means "end of signal" */
+				dev_dbg(ir->dev, "Storing final space with "
+					"duration %d\n", ir->rawir.duration);
+				ir_raw_event_store(ir->idev, &ir->rawir);
+				ir->rawir.duration = 0;
 			}
-			/*
-			 * a package with len=0 (e. g. 0x80) means end of
-			 * data. We could use it to do the call to
-			 * ir_raw_event_handle(). For now, we don't need to
-			 * use it.
-			 */
 			break;
 		}
 
@@ -1092,7 +1099,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	bool tx_mask_inverted;
 	bool is_polaris;
 
-	dev_dbg(&intf->dev, ": %s called\n", __func__);
+	dev_dbg(&intf->dev, "%s called\n", __func__);
 
 	idesc  = intf->cur_altsetting;
 
@@ -1122,7 +1129,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 			ep_in = ep;
 			ep_in->bmAttributes = USB_ENDPOINT_XFER_INT;
 			ep_in->bInterval = 1;
-			dev_dbg(&intf->dev, ": acceptable inbound endpoint "
+			dev_dbg(&intf->dev, "acceptable inbound endpoint "
 				"found\n");
 		}
 
@@ -1137,12 +1144,12 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
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
 
-- 
1.7.1


-- 
Jarod Wilson
jarod@redhat.com

