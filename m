Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:57769 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab3A2MTe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 07:19:34 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: [PATCH 4/5] [media] mceusb: make transmit work on HP transceiver
Date: Tue, 29 Jan 2013 12:19:30 +0000
Message-Id: <1359461971-27492-4-git-send-email-sean@mess.org>
In-Reply-To: <1359461971-27492-1-git-send-email-sean@mess.org>
References: <1359461971-27492-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This transceiver expects the set IR TX ports and IR data as seperate
packets, like the Windows driver does. Remove unnecessary kzalloc.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/mceusb.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 14fea35..bdd1ed8 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -62,7 +62,6 @@
 #define MCE_PACKET_SIZE		4    /* Normal length of packet (without header) */
 #define MCE_IRDATA_HEADER	0x84 /* Actual header format is 0x80 + num_bytes */
 #define MCE_IRDATA_TRAILER	0x80 /* End of IR data */
-#define MCE_TX_HEADER_LENGTH	3    /* # of bytes in the initializing tx header */
 #define MCE_MAX_CHANNELS	2    /* Two transmitters, hardware dependent? */
 #define MCE_DEFAULT_TX_MASK	0x03 /* Vals: TX1=0x01, TX2=0x02, ALL=0x03 */
 #define MCE_PULSE_BIT		0x80 /* Pulse bit, MSB set == PULSE else SPACE */
@@ -366,7 +365,8 @@ static struct usb_device_id mceusb_dev_table[] = {
 	/* Formosa Industrial Computing */
 	{ USB_DEVICE(VENDOR_FORMOSA, 0xe042) },
 	/* Fintek eHome Infrared Transceiver (HP branded) */
-	{ USB_DEVICE(VENDOR_FINTEK, 0x5168) },
+	{ USB_DEVICE(VENDOR_FINTEK, 0x5168),
+	  .driver_info = MCE_GEN2_TX_INV },
 	/* Fintek eHome Infrared Transceiver */
 	{ USB_DEVICE(VENDOR_FINTEK, 0x0602) },
 	/* Fintek eHome Infrared Transceiver (in the AOpen MP45) */
@@ -789,19 +789,19 @@ static void mce_flush_rx_buffer(struct mceusb_dev *ir, int size)
 static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 {
 	struct mceusb_dev *ir = dev->priv;
-	int i, ret = 0;
+	int i, length, ret = 0;
 	int cmdcount = 0;
-	unsigned char *cmdbuf; /* MCE command buffer */
-
-	cmdbuf = kzalloc(sizeof(unsigned) * MCE_CMDBUF_SIZE, GFP_KERNEL);
-	if (!cmdbuf)
-		return -ENOMEM;
+	unsigned char cmdbuf[MCE_CMDBUF_SIZE];
 
 	/* MCE tx init header */
 	cmdbuf[cmdcount++] = MCE_CMD_PORT_IR;
 	cmdbuf[cmdcount++] = MCE_CMD_SETIRTXPORTS;
 	cmdbuf[cmdcount++] = ir->tx_mask;
 
+	/* Send the set TX ports command */
+	mce_async_out(ir, cmdbuf, cmdcount);
+	cmdcount = 0;
+
 	/* Generate mce packet data */
 	for (i = 0; (i < count) && (cmdcount < MCE_CMDBUF_SIZE); i++) {
 		txbuf[i] = txbuf[i] / MCE_TIME_UNIT;
@@ -810,8 +810,7 @@ static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 
 			/* Insert mce packet header every 4th entry */
 			if ((cmdcount < MCE_CMDBUF_SIZE) &&
-			    (cmdcount - MCE_TX_HEADER_LENGTH) %
-			     MCE_CODE_LENGTH == 0)
+			    (cmdcount % MCE_CODE_LENGTH) == 0)
 				cmdbuf[cmdcount++] = MCE_IRDATA_HEADER;
 
 			/* Insert mce packet data */
@@ -830,9 +829,8 @@ static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 	}
 
 	/* Fix packet length in last header */
-	cmdbuf[cmdcount - (cmdcount - MCE_TX_HEADER_LENGTH) % MCE_CODE_LENGTH] =
-		MCE_COMMAND_IRDATA + (cmdcount - MCE_TX_HEADER_LENGTH) %
-		MCE_CODE_LENGTH - 1;
+	length = cmdcount % MCE_CODE_LENGTH;
+	cmdbuf[cmdcount - length] -= MCE_CODE_LENGTH - length;
 
 	/* Check if we have room for the empty packet at the end */
 	if (cmdcount >= MCE_CMDBUF_SIZE) {
@@ -847,7 +845,6 @@ static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 	mce_async_out(ir, cmdbuf, cmdcount);
 
 out:
-	kfree(cmdbuf);
 	return ret ? ret : count;
 }
 
-- 
1.8.1

