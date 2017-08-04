Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:34145 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751304AbdHDLNx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 07:13:53 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] [media] mceusb: do not read data parameters unless required
Date: Fri,  4 Aug 2017 12:13:50 +0100
Message-Id: <20170804111351.16734-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This causes out-of-bounds read on device probe.

BUG: KASAN: slab-out-of-bounds in mceusb_dev_printdata+0xdc/0x830 [mceusb]

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/mceusb.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index d9c7bbd25253..60258889b162 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -538,12 +538,12 @@ static int mceusb_cmd_datasize(u8 cmd, u8 subcmd)
 	return datasize;
 }
 
-static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
-				 int buf_len, int offset, int len, bool out)
+static void mceusb_dev_printdata(struct mceusb_dev *ir, u8 *buf, int buf_len,
+				 int offset, int len, bool out)
 {
 #if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
 	char *inout;
-	u8 cmd, subcmd, data1, data2, data3, data4;
+	u8 cmd, subcmd, *data;
 	struct device *dev = ir->dev;
 	int start, skip = 0;
 	u32 carrier, period;
@@ -564,17 +564,14 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 	start  = offset + skip;
 	cmd    = buf[start] & 0xff;
 	subcmd = buf[start + 1] & 0xff;
-	data1  = buf[start + 2] & 0xff;
-	data2  = buf[start + 3] & 0xff;
-	data3  = buf[start + 4] & 0xff;
-	data4  = buf[start + 5] & 0xff;
+	data = buf + start + 2;
 
 	switch (cmd) {
 	case MCE_CMD_NULL:
 		if (subcmd == MCE_CMD_NULL)
 			break;
 		if ((subcmd == MCE_CMD_PORT_SYS) &&
-		    (data1 == MCE_CMD_RESUME))
+		    (data[0] == MCE_CMD_RESUME))
 			dev_dbg(dev, "Device resume requested");
 		else
 			dev_dbg(dev, "Unknown command 0x%02x 0x%02x",
@@ -585,7 +582,7 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 		case MCE_RSP_EQEMVER:
 			if (!out)
 				dev_dbg(dev, "Emulator interface version %x",
-					 data1);
+					 data[0]);
 			break;
 		case MCE_CMD_G_REVISION:
 			if (len == 2)
@@ -603,13 +600,13 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 		case MCE_RSP_EQWAKEVERSION:
 			if (!out)
 				dev_dbg(dev, "Wake version, proto: 0x%02x, payload: 0x%02x, address: 0x%02x, version: 0x%02x",
-					 data1, data2, data3, data4);
+					data[0], data[1], data[2], data[3]);
 			break;
 		case MCE_RSP_GETPORTSTATUS:
 			if (!out)
 				/* We use data1 + 1 here, to match hw labels */
 				dev_dbg(dev, "TX port %d: blaster is%s connected",
-					 data1 + 1, data4 ? " not" : "");
+					 data[0] + 1, data[3] ? " not" : "");
 			break;
 		case MCE_CMD_FLASHLED:
 			dev_dbg(dev, "Attempting to flash LED");
@@ -630,11 +627,11 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 			break;
 		case MCE_CMD_UNKNOWN:
 			dev_dbg(dev, "Resp to 9f 05 of 0x%02x 0x%02x",
-				 data1, data2);
+				data[0], data[1]);
 			break;
 		case MCE_RSP_EQIRCFS:
-			period = DIV_ROUND_CLOSEST(
-					(1U << data1 * 2) * (data2 + 1), 10);
+			period = DIV_ROUND_CLOSEST((1U << data[0] * 2) *
+						   (data[1] + 1), 10);
 			if (!period)
 				break;
 			carrier = (1000 * 1000) / period;
@@ -646,11 +643,12 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 			break;
 		case MCE_RSP_EQIRTXPORTS:
 			dev_dbg(dev, "%s transmit blaster mask of 0x%02x",
-				 inout, data1);
+				 inout, data[0]);
 			break;
 		case MCE_RSP_EQIRTIMEOUT:
 			/* value is in units of 50us, so x*50/1000 ms */
-			period = ((data1 << 8) | data2) * MCE_TIME_UNIT / 1000;
+			period = ((data[0] << 8) | data[1]) *
+				  MCE_TIME_UNIT / 1000;
 			dev_dbg(dev, "%s receive timeout of %d ms",
 				 inout, period);
 			break;
@@ -662,7 +660,7 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 			break;
 		case MCE_RSP_EQIRRXPORTEN:
 			dev_dbg(dev, "%s %s-range receive sensor in use",
-				 inout, data1 == 0x02 ? "short" : "long");
+				 inout, data[0] == 0x02 ? "short" : "long");
 			break;
 		case MCE_CMD_GETIRRXPORTEN:
 		/* aka MCE_RSP_EQIRRXCFCNT */
@@ -670,13 +668,13 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 				dev_dbg(dev, "Get receive sensor");
 			else if (ir->learning_enabled)
 				dev_dbg(dev, "RX pulse count: %d",
-					 ((data1 << 8) | data2));
+					((data[0] << 8) | data[1]));
 			break;
 		case MCE_RSP_EQIRNUMPORTS:
 			if (out)
 				break;
 			dev_dbg(dev, "Num TX ports: %x, num RX ports: %x",
-				 data1, data2);
+				data[0], data[1]);
 			break;
 		case MCE_RSP_CMD_ILLEGAL:
 			dev_dbg(dev, "Illegal PORT_IR command");
-- 
2.13.3
