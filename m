Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab1GNWJ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 18:09:58 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6EM9wKU010308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2011 18:09:58 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 1/9] [media] mceusb: command/response updates from MS docs
Date: Thu, 14 Jul 2011 18:09:46 -0400
Message-Id: <1310681394-3530-2-git-send-email-jarod@redhat.com>
In-Reply-To: <1310681394-3530-1-git-send-email-jarod@redhat.com>
References: <1310681394-3530-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was recently pointed to the document titled
Windows-Media-Center-RC-IR-Collection-Green-Button-Specification-03-08-2011-V2.pdf
which as of this writing, is publicly available from
download.microsoft.com. It covers a LOT of the gaps in the mceusb
driver, which to this point, was written almost entirely by
reverse-engineering. First up, I'm updating the defines for all the MCE
commands and responses to match their names in the spec. More to come...

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |  293 ++++++++++++++++++++++++++------------------
 1 files changed, 173 insertions(+), 120 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index ec972dc..111bead 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -63,43 +63,90 @@
 #define MCE_PULSE_MASK		0x7f /* Pulse mask */
 #define MCE_MAX_PULSE_LENGTH	0x7f /* Longest transmittable pulse symbol */
 
-#define MCE_HW_CMD_HEADER	0xff	/* MCE hardware command header */
-#define MCE_COMMAND_HEADER	0x9f	/* MCE command header */
-#define MCE_COMMAND_MASK	0xe0	/* Mask out command bits */
-#define MCE_COMMAND_NULL	0x00	/* These show up various places... */
-/* if buf[i] & MCE_COMMAND_MASK == 0x80 and buf[i] != MCE_COMMAND_HEADER,
- * then we're looking at a raw IR data sample */
-#define MCE_COMMAND_IRDATA	0x80
-#define MCE_PACKET_LENGTH_MASK	0x1f /* Packet length mask */
-
-/* Sub-commands, which follow MCE_COMMAND_HEADER or MCE_HW_CMD_HEADER */
+/*
+ * The interface between the host and the IR hardware is command-response
+ * based. All commands and responses have a consistent format, where a lead
+ * byte always identifies the type of data following it. The lead byte has
+ * a port value in the 3 highest bits and a length value in the 5 lowest
+ * bits.
+ *
+ * The length field is overloaded, with a value of 11111 indicating that the
+ * following byte is a command or response code, and the length of the entire
+ * message is determined by the code. If the length field is not 11111, then
+ * it specifies the number of bytes of port data that follow.
+ */
+#define MCE_CMD			0x1f
+#define MCE_PORT_IR		0x4	/* (0x4 << 5) | MCE_CMD = 0x9f */
+#define MCE_PORT_SYS		0x7	/* (0x7 << 5) | MCE_CMD = 0xff */
+#define MCE_PORT_SER		0x6	/* 0xc0 thru 0xdf flush & 0x1f bytes */
+#define MCE_PORT_MASK	0xe0	/* Mask out command bits */
+
+/* Command port headers */
+#define MCE_CMD_PORT_IR		0x9f	/* IR-related cmd/rsp */
+#define MCE_CMD_PORT_SYS	0xff	/* System (non-IR) device cmd/rsp */
+
+/* Commands that set device state  (2-4 bytes in length) */
+#define MCE_CMD_RESET		0xfe	/* Reset device, 2 bytes */
+#define MCE_CMD_RESUME		0xaa	/* Resume device after error, 2 bytes */
+#define MCE_CMD_SETIRCFS	0x06	/* Set tx carrier, 4 bytes */
+#define MCE_CMD_SETIRTIMEOUT	0x0c	/* Set timeout, 4 bytes */
+#define MCE_CMD_SETIRTXPORTS	0x08	/* Set tx ports, 3 bytes */
+#define MCE_CMD_SETIRRXPORTEN	0x14	/* Set rx ports, 3 bytes */
+#define MCE_CMD_FLASHLED	0x23	/* Flash receiver LED, 2 bytes */
+
+/* Commands that query device state (all 2 bytes, unless noted) */
+#define MCE_CMD_GETIRCFS	0x07	/* Get carrier */
+#define MCE_CMD_GETIRTIMEOUT	0x0d	/* Get timeout */
+#define MCE_CMD_GETIRTXPORTS	0x13	/* Get tx ports */
+#define MCE_CMD_GETIRRXPORTEN	0x15	/* Get rx ports */
+#define MCE_CMD_GETPORTSTATUS	0x11	/* Get tx port status, 3 bytes */
+#define MCE_CMD_GETIRNUMPORTS	0x16	/* Get number of ports */
+#define MCE_CMD_GETWAKESOURCE	0x17	/* Get wake source */
+#define MCE_CMD_GETEMVER	0x22	/* Get emulator interface version */
+#define MCE_CMD_GETDEVDETAILS	0x21	/* Get device details (em ver2 only) */
+#define MCE_CMD_GETWAKESUPPORT	0x20	/* Get wake details (em ver2 only) */
+#define MCE_CMD_GETWAKEVERSION	0x18	/* Get wake pattern (em ver2 only) */
+
+/* Misc commands */
+#define MCE_CMD_NOP		0xff	/* No operation */
+
+/* Responses to commands (non-error cases) */
+#define MCE_RSP_EQIRCFS		0x06	/* tx carrier, 4 bytes */
+#define MCE_RSP_EQIRTIMEOUT	0x0c	/* rx timeout, 4 bytes */
+#define MCE_RSP_GETWAKESOURCE	0x17	/* wake source, 3 bytes */
+#define MCE_RSP_EQIRTXPORTS	0x08	/* tx port mask, 3 bytes */
+#define MCE_RSP_EQIRRXPORTEN	0x14	/* rx port mask, 3 bytes */
+#define MCE_RSP_GETPORTSTATUS	0x11	/* tx port status, 7 bytes */
+#define MCE_RSP_EQIRRXCFCNT	0x15	/* rx carrier count, 4 bytes */
+#define MCE_RSP_EQIRNUMPORTS	0x16	/* number of ports, 4 bytes */
+#define MCE_RSP_EQWAKESUPPORT	0x20	/* wake capabilities, 3 bytes */
+#define MCE_RSP_EQWAKEVERSION	0x18	/* wake pattern details, 6 bytes */
+#define MCE_RSP_EQDEVDETAILS	0x21	/* device capabilities, 3 bytes */
+#define MCE_RSP_EQEMVER		0x22	/* emulator interface ver, 3 bytes */
+#define MCE_RSP_FLASHLED	0x23	/* success flashing LED, 2 bytes */
+
+/* Responses to error cases, must send MCE_CMD_RESUME to clear them */
+#define MCE_RSP_CMD_ILLEGAL	0xfe	/* illegal command for port, 2 bytes */
+#define MCE_RSP_TX_TIMEOUT	0x81	/* tx timed out, 2 bytes */
+
+/* Misc commands/responses not defined in the MCE remote/transceiver spec */
 #define MCE_CMD_SIG_END		0x01	/* End of signal */
 #define MCE_CMD_PING		0x03	/* Ping device */
 #define MCE_CMD_UNKNOWN		0x04	/* Unknown */
 #define MCE_CMD_UNKNOWN2	0x05	/* Unknown */
-#define MCE_CMD_S_CARRIER	0x06	/* Set TX carrier frequency */
-#define MCE_CMD_G_CARRIER	0x07	/* Get TX carrier frequency */
-#define MCE_CMD_S_TXMASK	0x08	/* Set TX port bitmask */
 #define MCE_CMD_UNKNOWN3	0x09	/* Unknown */
 #define MCE_CMD_UNKNOWN4	0x0a	/* Unknown */
 #define MCE_CMD_G_REVISION	0x0b	/* Get hw/sw revision */
-#define MCE_CMD_S_TIMEOUT	0x0c	/* Set RX timeout value */
-#define MCE_CMD_G_TIMEOUT	0x0d	/* Get RX timeout value */
 #define MCE_CMD_UNKNOWN5	0x0e	/* Unknown */
 #define MCE_CMD_UNKNOWN6	0x0f	/* Unknown */
-#define MCE_CMD_G_RXPORTSTS	0x11	/* Get RX port status */
-#define MCE_CMD_G_TXMASK	0x13	/* Set TX port bitmask */
-#define MCE_CMD_S_RXSENSOR	0x14	/* Set RX sensor (std/learning) */
-#define MCE_CMD_G_RXSENSOR	0x15	/* Get RX sensor (std/learning) */
-#define MCE_RSP_PULSE_COUNT	0x15	/* RX pulse count (only if learning) */
-#define MCE_CMD_TX_PORTS	0x16	/* Get number of TX ports */
-#define MCE_CMD_G_WAKESRC	0x17	/* Get wake source */
-#define MCE_CMD_UNKNOWN7	0x18	/* Unknown */
 #define MCE_CMD_UNKNOWN8	0x19	/* Unknown */
 #define MCE_CMD_UNKNOWN9	0x1b	/* Unknown */
-#define MCE_CMD_DEVICE_RESET	0xaa	/* Reset the hardware */
-#define MCE_RSP_CMD_INVALID	0xfe	/* Invalid command issued */
+#define MCE_CMD_NULL		0x00	/* These show up various places... */
 
+/* if buf[i] & MCE_PORT_MASK == 0x80 and buf[i] != MCE_CMD_PORT_IR,
+ * then we're looking at a raw IR data sample */
+#define MCE_COMMAND_IRDATA	0x80
+#define MCE_PACKET_LENGTH_MASK	0x1f /* Packet length mask */
 
 /* module parameters */
 #ifdef CONFIG_USB_DEBUG
@@ -390,46 +437,25 @@ struct mceusb_dev {
 	enum mceusb_model_type model;
 };
 
-/*
- * MCE Device Command Strings
- * Device command responses vary from device to device...
- * - DEVICE_RESET resets the hardware to its default state
- * - GET_REVISION fetches the hardware/software revision, common
- *   replies are ff 0b 45 ff 1b 08 and ff 0b 50 ff 1b 42
- * - GET_CARRIER_FREQ gets the carrier mode and frequency of the
- *   device, with replies in the form of 9f 06 MM FF, where MM is 0-3,
- *   meaning clk of 10000000, 2500000, 625000 or 156250, and FF is
- *   ((clk / frequency) - 1)
- * - GET_RX_TIMEOUT fetches the receiver timeout in units of 50us,
- *   response in the form of 9f 0c msb lsb
- * - GET_TX_BITMASK fetches the transmitter bitmask, replies in
- *   the form of 9f 08 bm, where bm is the bitmask
- * - GET_RX_SENSOR fetches the RX sensor setting -- long-range
- *   general use one or short-range learning one, in the form of
- *   9f 14 ss, where ss is either 01 for long-range or 02 for short
- * - SET_CARRIER_FREQ sets a new carrier mode and frequency
- * - SET_TX_BITMASK sets the transmitter bitmask
- * - SET_RX_TIMEOUT sets the receiver timeout
- * - SET_RX_SENSOR sets which receiver sensor to use
- */
-static char DEVICE_RESET[]	= {MCE_COMMAND_NULL, MCE_HW_CMD_HEADER,
-				   MCE_CMD_DEVICE_RESET};
-static char GET_REVISION[]	= {MCE_HW_CMD_HEADER, MCE_CMD_G_REVISION};
-static char GET_UNKNOWN[]	= {MCE_HW_CMD_HEADER, MCE_CMD_UNKNOWN7};
-static char GET_UNKNOWN2[]	= {MCE_COMMAND_HEADER, MCE_CMD_UNKNOWN2};
-static char GET_CARRIER_FREQ[]	= {MCE_COMMAND_HEADER, MCE_CMD_G_CARRIER};
-static char GET_RX_TIMEOUT[]	= {MCE_COMMAND_HEADER, MCE_CMD_G_TIMEOUT};
-static char GET_TX_BITMASK[]	= {MCE_COMMAND_HEADER, MCE_CMD_G_TXMASK};
-static char GET_RX_SENSOR[]	= {MCE_COMMAND_HEADER, MCE_CMD_G_RXSENSOR};
+/* MCE Device Command Strings, generally a port and command pair */
+static char DEVICE_RESUME[]	= {MCE_CMD_NULL, MCE_CMD_PORT_SYS,
+				   MCE_CMD_RESUME};
+static char GET_REVISION[]	= {MCE_CMD_PORT_SYS, MCE_CMD_G_REVISION};
+static char GET_WAKEVERSION[]	= {MCE_CMD_PORT_SYS, MCE_CMD_GETWAKEVERSION};
+static char GET_UNKNOWN2[]	= {MCE_CMD_PORT_IR, MCE_CMD_UNKNOWN2};
+static char GET_CARRIER_FREQ[]	= {MCE_CMD_PORT_IR, MCE_CMD_GETIRCFS};
+static char GET_RX_TIMEOUT[]	= {MCE_CMD_PORT_IR, MCE_CMD_GETIRTIMEOUT};
+static char GET_TX_BITMASK[]	= {MCE_CMD_PORT_IR, MCE_CMD_GETIRTXPORTS};
+static char GET_RX_SENSOR[]	= {MCE_CMD_PORT_IR, MCE_CMD_GETIRRXPORTEN};
 /* sub in desired values in lower byte or bytes for full command */
 /* FIXME: make use of these for transmit.
-static char SET_CARRIER_FREQ[]	= {MCE_COMMAND_HEADER,
-				   MCE_CMD_S_CARRIER, 0x00, 0x00};
-static char SET_TX_BITMASK[]	= {MCE_COMMAND_HEADER, MCE_CMD_S_TXMASK, 0x00};
-static char SET_RX_TIMEOUT[]	= {MCE_COMMAND_HEADER,
-				   MCE_CMD_S_TIMEOUT, 0x00, 0x00};
-static char SET_RX_SENSOR[]	= {MCE_COMMAND_HEADER,
-				   MCE_CMD_S_RXSENSOR, 0x00};
+static char SET_CARRIER_FREQ[]	= {MCE_CMD_PORT_IR,
+				   MCE_CMD_SETIRCFS, 0x00, 0x00};
+static char SET_TX_BITMASK[]	= {MCE_CMD_PORT_IR, MCE_CMD_SETIRTXPORTS, 0x00};
+static char SET_RX_TIMEOUT[]	= {MCE_CMD_PORT_IR,
+				   MCE_CMD_SETIRTIMEOUT, 0x00, 0x00};
+static char SET_RX_SENSOR[]	= {MCE_CMD_PORT_IR,
+				   MCE_RSP_EQIRRXPORTEN, 0x00};
 */
 
 static int mceusb_cmdsize(u8 cmd, u8 subcmd)
@@ -437,27 +463,33 @@ static int mceusb_cmdsize(u8 cmd, u8 subcmd)
 	int datasize = 0;
 
 	switch (cmd) {
-	case MCE_COMMAND_NULL:
-		if (subcmd == MCE_HW_CMD_HEADER)
+	case MCE_CMD_NULL:
+		if (subcmd == MCE_CMD_PORT_SYS)
 			datasize = 1;
 		break;
-	case MCE_HW_CMD_HEADER:
+	case MCE_CMD_PORT_SYS:
 		switch (subcmd) {
+		case MCE_RSP_EQWAKEVERSION:
+			datasize = 4;
+			break;
 		case MCE_CMD_G_REVISION:
 			datasize = 2;
 			break;
+		case MCE_RSP_EQWAKESUPPORT:
+			datasize = 1;
+			break;
 		}
-	case MCE_COMMAND_HEADER:
+	case MCE_CMD_PORT_IR:
 		switch (subcmd) {
 		case MCE_CMD_UNKNOWN:
-		case MCE_CMD_S_CARRIER:
-		case MCE_CMD_S_TIMEOUT:
-		case MCE_RSP_PULSE_COUNT:
+		case MCE_RSP_EQIRCFS:
+		case MCE_RSP_EQIRTIMEOUT:
+		case MCE_RSP_EQIRRXCFCNT:
 			datasize = 2;
 			break;
 		case MCE_CMD_SIG_END:
-		case MCE_CMD_S_TXMASK:
-		case MCE_CMD_S_RXSENSOR:
+		case MCE_RSP_EQIRTXPORTS:
+		case MCE_RSP_EQIRRXPORTEN:
 			datasize = 1;
 			break;
 		}
@@ -470,7 +502,7 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 {
 	char codes[USB_BUFLEN * 3 + 1];
 	char inout[9];
-	u8 cmd, subcmd, data1, data2;
+	u8 cmd, subcmd, data1, data2, data3, data4, data5;
 	struct device *dev = ir->dev;
 	int i, start, skip = 0;
 
@@ -500,18 +532,26 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 	subcmd = buf[start + 1] & 0xff;
 	data1  = buf[start + 2] & 0xff;
 	data2  = buf[start + 3] & 0xff;
+	data3  = buf[start + 4] & 0xff;
+	data4  = buf[start + 5] & 0xff;
+	data5  = buf[start + 6] & 0xff;
 
 	switch (cmd) {
-	case MCE_COMMAND_NULL:
-		if ((subcmd == MCE_HW_CMD_HEADER) &&
-		    (data1 == MCE_CMD_DEVICE_RESET))
-			dev_info(dev, "Device reset requested\n");
+	case MCE_CMD_NULL:
+		if ((subcmd == MCE_CMD_PORT_SYS) &&
+		    (data1 == MCE_CMD_RESUME))
+			dev_info(dev, "Device resume requested\n");
 		else
 			dev_info(dev, "Unknown command 0x%02x 0x%02x\n",
 				 cmd, subcmd);
 		break;
-	case MCE_HW_CMD_HEADER:
+	case MCE_CMD_PORT_SYS:
 		switch (subcmd) {
+		case MCE_RSP_EQEMVER:
+			if (!out)
+				dev_info(dev, "Emulator interface version %x\n",
+					 data1);
+			break;
 		case MCE_CMD_G_REVISION:
 			if (len == 2)
 				dev_info(dev, "Get hw/sw rev?\n");
@@ -520,21 +560,32 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 					 "0x%02x 0x%02x\n", data1, data2,
 					 buf[start + 4], buf[start + 5]);
 			break;
-		case MCE_CMD_DEVICE_RESET:
-			dev_info(dev, "Device reset requested\n");
+		case MCE_CMD_RESUME:
+			dev_info(dev, "Device resume requested\n");
+			break;
+		case MCE_RSP_CMD_ILLEGAL:
+			dev_info(dev, "Illegal PORT_SYS command\n");
+			break;
+		case MCE_RSP_EQWAKEVERSION:
+			if (!out)
+				dev_info(dev, "Wake version, proto: 0x%02x, "
+					 "payload: 0x%02x, address: 0x%02x, "
+					 "version: 0x%02x\n",
+					 data1, data2, data3, data4);
 			break;
-		case MCE_RSP_CMD_INVALID:
-			dev_info(dev, "Previous command not supported\n");
+		case MCE_RSP_GETPORTSTATUS:
+			if (!out)
+				/* We use data1 + 1 here, to match hw labels */
+				dev_info(dev, "TX port %d: blaster is%s connected\n",
+					 data1 + 1, data4 ? " not" : "");
 			break;
-		case MCE_CMD_UNKNOWN7:
-		case MCE_CMD_UNKNOWN9:
 		default:
 			dev_info(dev, "Unknown command 0x%02x 0x%02x\n",
 				 cmd, subcmd);
 			break;
 		}
 		break;
-	case MCE_COMMAND_HEADER:
+	case MCE_CMD_PORT_IR:
 		switch (subcmd) {
 		case MCE_CMD_SIG_END:
 			dev_info(dev, "End of signal\n");
@@ -546,47 +597,50 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 			dev_info(dev, "Resp to 9f 05 of 0x%02x 0x%02x\n",
 				 data1, data2);
 			break;
-		case MCE_CMD_S_CARRIER:
+		case MCE_CMD_SETIRCFS:
 			dev_info(dev, "%s carrier mode and freq of "
 				 "0x%02x 0x%02x\n", inout, data1, data2);
 			break;
-		case MCE_CMD_G_CARRIER:
+		case MCE_CMD_GETIRCFS:
 			dev_info(dev, "Get carrier mode and freq\n");
 			break;
-		case MCE_CMD_S_TXMASK:
+		case MCE_RSP_EQIRTXPORTS:
 			dev_info(dev, "%s transmit blaster mask of 0x%02x\n",
 				 inout, data1);
 			break;
-		case MCE_CMD_S_TIMEOUT:
+		case MCE_RSP_EQIRTIMEOUT:
 			/* value is in units of 50us, so x*50/1000 ms */
 			dev_info(dev, "%s receive timeout of %d ms\n",
 				 inout,
 				 ((data1 << 8) | data2) * MCE_TIME_UNIT / 1000);
 			break;
-		case MCE_CMD_G_TIMEOUT:
+		case MCE_CMD_GETIRTIMEOUT:
 			dev_info(dev, "Get receive timeout\n");
 			break;
-		case MCE_CMD_G_TXMASK:
+		case MCE_CMD_GETIRTXPORTS:
 			dev_info(dev, "Get transmit blaster mask\n");
 			break;
-		case MCE_CMD_S_RXSENSOR:
+		case MCE_RSP_EQIRRXPORTEN:
 			dev_info(dev, "%s %s-range receive sensor in use\n",
 				 inout, data1 == 0x02 ? "short" : "long");
 			break;
-		case MCE_CMD_G_RXSENSOR:
-		/* aka MCE_RSP_PULSE_COUNT */
+		case MCE_CMD_GETIRRXPORTEN:
+		/* aka MCE_RSP_EQIRRXCFCNT */
 			if (out)
 				dev_info(dev, "Get receive sensor\n");
 			else if (ir->learning_enabled)
 				dev_info(dev, "RX pulse count: %d\n",
 					 ((data1 << 8) | data2));
 			break;
-		case MCE_RSP_CMD_INVALID:
-			dev_info(dev, "Error! Hardware is likely wedged...\n");
+		case MCE_RSP_EQIRNUMPORTS:
+			if (out)
+				break;
+			dev_info(dev, "Num TX ports: %x, num RX ports: %x\n",
+				 data1, data2);
+			break;
+		case MCE_RSP_CMD_ILLEGAL:
+			dev_info(dev, "Illegal PORT_IR command\n");
 			break;
-		case MCE_CMD_UNKNOWN2:
-		case MCE_CMD_UNKNOWN3:
-		case MCE_CMD_UNKNOWN5:
 		default:
 			dev_info(dev, "Unknown command 0x%02x 0x%02x\n",
 				 cmd, subcmd);
@@ -599,8 +653,8 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 
 	if (cmd == MCE_IRDATA_TRAILER)
 		dev_info(dev, "End of raw IR data\n");
-	else if ((cmd != MCE_COMMAND_HEADER) &&
-		 ((cmd & MCE_COMMAND_MASK) == MCE_COMMAND_IRDATA))
+	else if ((cmd != MCE_CMD_PORT_IR) &&
+		 ((cmd & MCE_PORT_MASK) == MCE_COMMAND_IRDATA))
 		dev_info(dev, "Raw IR data, %d pulse/space samples\n", ir->rem);
 }
 
@@ -616,9 +670,6 @@ static void mce_async_callback(struct urb *urb, struct pt_regs *regs)
 	if (ir) {
 		len = urb->actual_length;
 
-		mce_dbg(ir->dev, "callback called (status=%d len=%d)\n",
-			urb->status, len);
-
 		mceusb_dev_printdata(ir, urb->transfer_buffer, 0, len, true);
 	}
 
@@ -710,8 +761,8 @@ static int mceusb_tx_ir(struct rc_dev *dev, int *txbuf, u32 n)
 		return -ENOMEM;
 
 	/* MCE tx init header */
-	cmdbuf[cmdcount++] = MCE_COMMAND_HEADER;
-	cmdbuf[cmdcount++] = MCE_CMD_S_TXMASK;
+	cmdbuf[cmdcount++] = MCE_CMD_PORT_IR;
+	cmdbuf[cmdcount++] = MCE_CMD_SETIRTXPORTS;
 	cmdbuf[cmdcount++] = ir->tx_mask;
 
 	/* Generate mce packet data */
@@ -797,8 +848,8 @@ static int mceusb_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 	struct mceusb_dev *ir = dev->priv;
 	int clk = 10000000;
 	int prescaler = 0, divisor = 0;
-	unsigned char cmdbuf[4] = { MCE_COMMAND_HEADER,
-				    MCE_CMD_S_CARRIER, 0x00, 0x00 };
+	unsigned char cmdbuf[4] = { MCE_CMD_PORT_IR,
+				    MCE_CMD_SETIRCFS, 0x00, 0x00 };
 
 	/* Carrier has changed */
 	if (ir->carrier != carrier) {
@@ -847,16 +898,16 @@ static void mceusb_handle_command(struct mceusb_dev *ir, int index)
 
 	switch (ir->buf_in[index]) {
 	/* 2-byte return value commands */
-	case MCE_CMD_S_TIMEOUT:
+	case MCE_RSP_EQIRTIMEOUT:
 		ir->rc->timeout = US_TO_NS((hi << 8 | lo) * MCE_TIME_UNIT);
 		break;
 
 	/* 1-byte return value commands */
-	case MCE_CMD_S_TXMASK:
+	case MCE_RSP_EQIRTXPORTS:
 		ir->tx_mask = hi;
 		break;
-	case MCE_CMD_S_RXSENSOR:
-		ir->learning_enabled = (hi == 0x02);
+	case MCE_RSP_EQIRRXPORTEN:
+		ir->learning_enabled = ((hi & 0x02) == 0x02);
 		break;
 	default:
 		break;
@@ -905,8 +956,8 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			/* decode mce packets of the form (84),AA,BB,CC,DD */
 			/* IR data packets can span USB messages - rem */
 			ir->cmd = ir->buf_in[i];
-			if ((ir->cmd == MCE_COMMAND_HEADER) ||
-			    ((ir->cmd & MCE_COMMAND_MASK) !=
+			if ((ir->cmd == MCE_CMD_PORT_IR) ||
+			    ((ir->cmd & MCE_PORT_MASK) !=
 			     MCE_COMMAND_IRDATA)) {
 				ir->parser_state = SUBCMD;
 				continue;
@@ -1013,8 +1064,8 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 			      0x0000, 0x0100, NULL, 0, HZ * 3);
 	mce_dbg(dev, "%s - retC = %d\n", __func__, ret);
 
-	/* device reset */
-	mce_async_out(ir, DEVICE_RESET, sizeof(DEVICE_RESET));
+	/* device resume */
+	mce_async_out(ir, DEVICE_RESUME, sizeof(DEVICE_RESUME));
 
 	/* get hw/sw revision? */
 	mce_async_out(ir, GET_REVISION, sizeof(GET_REVISION));
@@ -1024,14 +1075,16 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 
 static void mceusb_gen2_init(struct mceusb_dev *ir)
 {
-	/* device reset */
-	mce_async_out(ir, DEVICE_RESET, sizeof(DEVICE_RESET));
+	/* device resume */
+	mce_async_out(ir, DEVICE_RESUME, sizeof(DEVICE_RESUME));
 
 	/* get hw/sw revision? */
 	mce_async_out(ir, GET_REVISION, sizeof(GET_REVISION));
 
-	/* unknown what the next two actually return... */
-	mce_async_out(ir, GET_UNKNOWN, sizeof(GET_UNKNOWN));
+	/* get wake version (protocol, key, address) */
+	mce_async_out(ir, GET_WAKEVERSION, sizeof(GET_WAKEVERSION));
+
+	/* unknown what this one actually returns... */
 	mce_async_out(ir, GET_UNKNOWN2, sizeof(GET_UNKNOWN2));
 }
 
-- 
1.7.1

