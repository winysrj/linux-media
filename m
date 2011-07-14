Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217Ab1GNWKD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 18:10:03 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6EMA3tM029111
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2011 18:10:03 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 6/9] [media] mceusb: get misc port data from hardware
Date: Thu, 14 Jul 2011 18:09:51 -0400
Message-Id: <1310681394-3530-7-git-send-email-jarod@redhat.com>
In-Reply-To: <1310681394-3530-1-git-send-email-jarod@redhat.com>
References: <1310681394-3530-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the specs, you can read the number of tx ports, number of
rx sensors, which tx ports have cables plugged into them, and which rx
sensors are active. In practice, most of my devices do seem to report
sane values for tx ports and rx sensors (but not all -- one without any
tx ports reports having them), and most report the active sensor
correctly, but only one of eight reports cabled tx ports correctly. So
for the most part, this is just for informational purposes.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |   51 ++++++++++++++++++++++++++++++++++++++------
 1 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 114fb13..e4171f7 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -440,6 +440,10 @@ struct mceusb_dev {
 
 	bool need_reset;	/* flag to issue a device resume cmd */
 	u8 emver;		/* emulator interface version */
+	u8 num_txports;		/* number of transmit ports */
+	u8 num_rxports;		/* number of receive sensors */
+	u8 txports_cabled;	/* bitmask of transmitters with cable */
+	u8 rxports_active;	/* bitmask of active receive sensors */
 };
 
 /* MCE Device Command Strings, generally a port and command pair */
@@ -451,6 +455,7 @@ static char GET_WAKEVERSION[]	= {MCE_CMD_PORT_SYS, MCE_CMD_GETWAKEVERSION};
 static char GET_UNKNOWN2[]	= {MCE_CMD_PORT_IR, MCE_CMD_UNKNOWN2};
 static char GET_CARRIER_FREQ[]	= {MCE_CMD_PORT_IR, MCE_CMD_GETIRCFS};
 static char GET_RX_TIMEOUT[]	= {MCE_CMD_PORT_IR, MCE_CMD_GETIRTIMEOUT};
+static char GET_NUM_PORTS[]	= {MCE_CMD_PORT_IR, MCE_CMD_GETIRNUMPORTS};
 static char GET_TX_BITMASK[]	= {MCE_CMD_PORT_IR, MCE_CMD_GETIRTXPORTS};
 static char GET_RX_SENSOR[]	= {MCE_CMD_PORT_IR, MCE_CMD_GETIRRXPORTEN};
 /* sub in desired values in lower byte or bytes for full command */
@@ -544,6 +549,8 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 
 	switch (cmd) {
 	case MCE_CMD_NULL:
+		if (subcmd == MCE_CMD_NULL)
+			break;
 		if ((subcmd == MCE_CMD_PORT_SYS) &&
 		    (data1 == MCE_CMD_RESUME))
 			dev_info(dev, "Device resume requested\n");
@@ -912,10 +919,20 @@ static void mceusb_handle_command(struct mceusb_dev *ir, int index)
 	u8 lo = ir->buf_in[index + 2] & 0xff;
 
 	switch (ir->buf_in[index]) {
+	/* the one and only 5-byte return value command */
+	case MCE_RSP_GETPORTSTATUS:
+		if ((ir->buf_in[index + 4] & 0xff) == 0x00)
+			ir->txports_cabled |= 1 << hi;
+		break;
+
 	/* 2-byte return value commands */
 	case MCE_RSP_EQIRTIMEOUT:
 		ir->rc->timeout = US_TO_NS((hi << 8 | lo) * MCE_TIME_UNIT);
 		break;
+	case MCE_RSP_EQIRNUMPORTS:
+		ir->num_txports = hi;
+		ir->num_rxports = lo;
+		break;
 
 	/* 1-byte return value commands */
 	case MCE_RSP_EQEMVER:
@@ -926,6 +943,7 @@ static void mceusb_handle_command(struct mceusb_dev *ir, int index)
 		break;
 	case MCE_RSP_EQIRRXPORTEN:
 		ir->learning_enabled = ((hi & 0x02) == 0x02);
+		ir->rxports_active = hi;
 		break;
 	case MCE_RSP_CMD_ILLEGAL:
 		ir->need_reset = true;
@@ -1118,10 +1136,21 @@ static void mceusb_gen2_init(struct mceusb_dev *ir)
 
 static void mceusb_get_parameters(struct mceusb_dev *ir)
 {
+	int i;
+	unsigned char cmdbuf[3] = { MCE_CMD_PORT_SYS,
+				    MCE_CMD_GETPORTSTATUS, 0x00 };
+
+	/* defaults, if the hardware doesn't support querying */
+	ir->num_txports = 2;
+	ir->num_rxports = 2;
+
+	/* get number of tx and rx ports */
+	mce_async_out(ir, GET_NUM_PORTS, sizeof(GET_NUM_PORTS));
+
 	/* get the carrier and frequency */
 	mce_async_out(ir, GET_CARRIER_FREQ, sizeof(GET_CARRIER_FREQ));
 
-	if (!ir->flags.no_tx)
+	if (ir->num_txports && !ir->flags.no_tx)
 		/* get the transmitter bitmask */
 		mce_async_out(ir, GET_TX_BITMASK, sizeof(GET_TX_BITMASK));
 
@@ -1130,6 +1159,11 @@ static void mceusb_get_parameters(struct mceusb_dev *ir)
 
 	/* get receiver sensor setting */
 	mce_async_out(ir, GET_RX_SENSOR, sizeof(GET_RX_SENSOR));
+
+	for (i = 0; i < ir->num_txports; i++) {
+		cmdbuf[2] = i;
+		mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
+	}
 }
 
 static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
@@ -1161,11 +1195,6 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->allowed_protos = RC_TYPE_ALL;
 	rc->timeout = MS_TO_NS(100);
-	if (!ir->flags.no_tx) {
-		rc->s_tx_mask = mceusb_set_tx_mask;
-		rc->s_tx_carrier = mceusb_set_tx_carrier;
-		rc->tx_ir = mceusb_tx_ir;
-	}
 	rc->driver_name = DRIVER_NAME;
 	rc->map_name = mceusb_model[ir->model].rc_map ?
 			mceusb_model[ir->model].rc_map : RC_MAP_RC6_MCE;
@@ -1314,8 +1343,12 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 
 	mceusb_get_parameters(ir);
 
-	if (!ir->flags.no_tx)
+	if (ir->num_txports && !ir->flags.no_tx) {
+		ir->rc->s_tx_mask = mceusb_set_tx_mask;
+		ir->rc->s_tx_carrier = mceusb_set_tx_carrier;
+		ir->rc->tx_ir = mceusb_tx_ir;
 		mceusb_set_tx_mask(ir->rc, MCE_DEFAULT_TX_MASK);
+	}
 
 	usb_set_intfdata(intf, ir);
 
@@ -1325,6 +1358,10 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 
 	dev_info(&intf->dev, "Registered %s with mce emulator interface "
 		 "version %x\n", name, ir->emver);
+	dev_info(&intf->dev, "%x tx ports (0x%x cabled) and "
+		 "%x rx sensors (0x%x active)\n",
+		 ir->num_txports, ir->txports_cabled,
+		 ir->num_rxports, ir->rxports_active);
 
 	return 0;
 
-- 
1.7.1

