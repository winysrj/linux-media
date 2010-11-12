Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:25820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757572Ab0KLWtF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 17:49:05 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oACMn5P2012778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 12 Nov 2010 17:49:05 -0500
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oACMn4ms000779
	for <linux-media@vger.kernel.org>; Fri, 12 Nov 2010 17:49:05 -0500
Date: Fri, 12 Nov 2010 17:49:04 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2] mceusb: fix keybouce issue after parser simplification
Message-ID: <20101112224904.GC8205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101112223945.GB8205@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Something I failed to notice while testing the mceusb RLE buffer
decoding simplification patches was that we were getting an extra event
from the previously pressed key.

As was pointed out to me on irc by Maxim, this is actually due to using
ir_raw_event_store_with_filter without having set up a timeout value.
The hardware has a timeout value we're now reading and storing, which
properly enables the transition to idle in the raw event storage
process, and makes IR decode behave correctly w/o keybounce.

Also remove no-longer-used ir_raw_event struct from mceusb_dev struct
and add as-yet-unused enable flags for carrier reports and learning
mode, which I'll hopefully start wiring up sooner than later. While
looking into that, found evidence that 0x9f 0x15 responses are only
non-zero when the short-range learning sensor is used, so correct the
debug spew message, and then suppress it when using the standard
long-range sensor.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---

v2: fix flub w/duplicate case select values and really test the
final product this time...

 drivers/media/rc/mceusb.c |   56 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index bb89992..968cf1f 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -47,6 +47,7 @@
 #define USB_BUFLEN		32 /* USB reception buffer length */
 #define USB_CTRL_MSG_SZ		2  /* Size of usb ctrl msg on gen1 hw */
 #define MCE_G1_INIT_MSGS	40 /* Init messages on gen1 hw to throw out */
+#define MS_TO_NS(msec)		((msec) * 1000)
 
 /* MCE constants */
 #define MCE_CMDBUF_SIZE		384  /* MCE Command buffer length */
@@ -90,6 +91,7 @@
 #define MCE_CMD_G_TXMASK	0x13	/* Set TX port bitmask */
 #define MCE_CMD_S_RXSENSOR	0x14	/* Set RX sensor (std/learning) */
 #define MCE_CMD_G_RXSENSOR	0x15	/* Get RX sensor (std/learning) */
+#define MCE_RSP_PULSE_COUNT	0x15	/* RX pulse count (only if learning) */
 #define MCE_CMD_TX_PORTS	0x16	/* Get number of TX ports */
 #define MCE_CMD_G_WAKESRC	0x17	/* Get wake source */
 #define MCE_CMD_UNKNOWN7	0x18	/* Unknown */
@@ -312,7 +314,10 @@ static struct usb_device_id mceusb_dev_table[] = {
 struct mceusb_dev {
 	/* ir-core bits */
 	struct rc_dev *rc;
-	struct ir_raw_event rawir;
+
+	/* optional features we can enable */
+	bool carrier_report_enabled;
+	bool learning_enabled;
 
 	/* core device bits */
 	struct device *dev;
@@ -326,6 +331,8 @@ struct mceusb_dev {
 	/* buffers and dma */
 	unsigned char *buf_in;
 	unsigned int len_in;
+	dma_addr_t dma_in;
+	dma_addr_t dma_out;
 
 	enum {
 		CMD_HEADER = 0,
@@ -333,10 +340,8 @@ struct mceusb_dev {
 		CMD_DATA,
 		PARSE_IRDATA,
 	} parser_state;
-	u8 cmd, rem;		/* Remaining IR data bytes in packet */
 
-	dma_addr_t dma_in;
-	dma_addr_t dma_out;
+	u8 cmd, rem;		/* Remaining IR data bytes in packet */
 
 	struct {
 		u32 connected:1;
@@ -417,7 +422,7 @@ static int mceusb_cmdsize(u8 cmd, u8 subcmd)
 		case MCE_CMD_UNKNOWN:
 		case MCE_CMD_S_CARRIER:
 		case MCE_CMD_S_TIMEOUT:
-		case MCE_CMD_G_RXSENSOR:
+		case MCE_RSP_PULSE_COUNT:
 			datasize = 2;
 			break;
 		case MCE_CMD_SIG_END:
@@ -538,10 +543,11 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 				 inout, data1 == 0x02 ? "short" : "long");
 			break;
 		case MCE_CMD_G_RXSENSOR:
-			if (len == 2)
+		/* aka MCE_RSP_PULSE_COUNT */
+			if (out)
 				dev_info(dev, "Get receive sensor\n");
-			else
-				dev_info(dev, "Remaining pulse count is %d\n",
+			else if (ir->learning_enabled)
+				dev_info(dev, "RX pulse count: %d\n",
 					 ((data1 << 8) | data2));
 			break;
 		case MCE_RSP_CMD_INVALID:
@@ -795,6 +801,34 @@ static int mceusb_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 	return carrier;
 }
 
+/*
+ * We don't do anything but print debug spew for many of the command bits
+ * we receive from the hardware, but some of them are useful information
+ * we want to store so that we can use them.
+ */
+static void mceusb_handle_command(struct mceusb_dev *ir, int index)
+{
+	u8 hi = ir->buf_in[index + 1] & 0xff;
+	u8 lo = ir->buf_in[index + 2] & 0xff;
+
+	switch (ir->buf_in[index]) {
+	/* 2-byte return value commands */
+	case MCE_CMD_S_TIMEOUT:
+		ir->rc->timeout = MS_TO_NS((hi << 8 | lo) / 2);
+		break;
+
+	/* 1-byte return value commands */
+	case MCE_CMD_S_TXMASK:
+		ir->tx_mask = hi;
+		break;
+	case MCE_CMD_S_RXSENSOR:
+		ir->learning_enabled = (hi == 0x02);
+		break;
+	default:
+		break;
+	}
+}
+
 static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 {
 	DEFINE_IR_RAW_EVENT(rawir);
@@ -814,13 +848,14 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			ir->rem = mceusb_cmdsize(ir->cmd, ir->buf_in[i]);
 			mceusb_dev_printdata(ir, ir->buf_in, i - 1,
 					     ir->rem + 2, false);
+			mceusb_handle_command(ir, i);
 			ir->parser_state = CMD_DATA;
 			break;
 		case PARSE_IRDATA:
 			ir->rem--;
 			rawir.pulse = ((ir->buf_in[i] & MCE_PULSE_BIT) != 0);
 			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
-					 * MCE_TIME_UNIT * 1000;
+					 * MS_TO_NS(MCE_TIME_UNIT);
 
 			dev_dbg(ir->dev, "Storing %s with duration %d\n",
 				rawir.pulse ? "pulse" : "space",
@@ -842,7 +877,8 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 				continue;
 			}
 			ir->rem = (ir->cmd & MCE_PACKET_LENGTH_MASK);
-			mceusb_dev_printdata(ir, ir->buf_in, i, ir->rem + 1, false);
+			mceusb_dev_printdata(ir, ir->buf_in,
+					     i, ir->rem + 1, false);
 			if (ir->rem)
 				ir->parser_state = PARSE_IRDATA;
 			break;
-- 
1.7.1


-- 
Jarod Wilson
jarod@redhat.com

