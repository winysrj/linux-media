Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:41699 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754248AbeCGLzd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 06:55:33 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] media: imon: rename protocol from other to imon
Date: Wed,  7 Mar 2018 11:55:32 +0000
Message-Id: <20180307115532.8196-2-sean@mess.org>
In-Reply-To: <20180307115532.8196-1-sean@mess.org>
References: <20180307115532.8196-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This renames the protocol for the imon rc driver from other to imon,
since it is now an known protocol. Although different name will show up
in the sysfs protocol file, loading a keymap using existing ir-keytable
versions still works.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/imon.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 527920a59d99..1041c056854d 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1110,18 +1110,18 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_proto)
 		dev_dbg(dev, "Configuring IR receiver for MCE protocol\n");
 		ir_proto_packet[0] = 0x01;
 		*rc_proto = RC_PROTO_BIT_RC6_MCE;
-	} else if (*rc_proto & RC_PROTO_BIT_OTHER) {
+	} else if (*rc_proto & RC_PROTO_BIT_IMON) {
 		dev_dbg(dev, "Configuring IR receiver for iMON protocol\n");
 		if (!pad_stabilize)
 			dev_dbg(dev, "PAD stabilize functionality disabled\n");
 		/* ir_proto_packet[0] = 0x00; // already the default */
-		*rc_proto = RC_PROTO_BIT_OTHER;
+		*rc_proto = RC_PROTO_BIT_IMON;
 	} else {
 		dev_warn(dev, "Unsupported IR protocol specified, overriding to iMON IR protocol\n");
 		if (!pad_stabilize)
 			dev_dbg(dev, "PAD stabilize functionality disabled\n");
 		/* ir_proto_packet[0] = 0x00; // already the default */
-		*rc_proto = RC_PROTO_BIT_OTHER;
+		*rc_proto = RC_PROTO_BIT_IMON;
 	}
 
 	memcpy(ictx->usb_tx_buf, &ir_proto_packet, sizeof(ir_proto_packet));
@@ -1388,7 +1388,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 		rel_x = buf[2];
 		rel_y = buf[3];
 
-		if (ictx->rc_proto == RC_PROTO_BIT_OTHER && pad_stabilize) {
+		if (ictx->rc_proto == RC_PROTO_BIT_IMON && pad_stabilize) {
 			if ((buf[1] == 0) && ((rel_x != 0) || (rel_y != 0))) {
 				dir = stabilize((int)rel_x, (int)rel_y,
 						timeout, threshold);
@@ -1455,7 +1455,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 		buf[0] = 0x01;
 		buf[1] = buf[4] = buf[5] = buf[6] = buf[7] = 0;
 
-		if (ictx->rc_proto == RC_PROTO_BIT_OTHER && pad_stabilize) {
+		if (ictx->rc_proto == RC_PROTO_BIT_IMON && pad_stabilize) {
 			dir = stabilize((int)rel_x, (int)rel_y,
 					timeout, threshold);
 			if (!dir) {
@@ -1639,11 +1639,18 @@ static void imon_incoming_packet(struct imon_context *ictx,
 		if (press_type == 0)
 			rc_keyup(ictx->rdev);
 		else {
-			if (ictx->rc_proto == RC_PROTO_BIT_RC6_MCE ||
-			    ictx->rc_proto == RC_PROTO_BIT_OTHER)
-				rc_keydown(ictx->rdev,
-					   ictx->rc_proto == RC_PROTO_BIT_RC6_MCE ? RC_PROTO_RC6_MCE : RC_PROTO_OTHER,
-					   ictx->rc_scancode, ictx->rc_toggle);
+			enum rc_proto proto;
+
+			if (ictx->rc_proto == RC_PROTO_BIT_RC6_MCE)
+				proto = RC_PROTO_RC6_MCE;
+			else if (ictx->rc_proto == RC_PROTO_BIT_IMON)
+				proto = RC_PROTO_IMON;
+			else
+				return;
+
+			rc_keydown(ictx->rdev, proto, ictx->rc_scancode,
+				   ictx->rc_toggle);
+
 			spin_lock_irqsave(&ictx->kc_lock, flags);
 			ictx->last_keycode = ictx->kc;
 			spin_unlock_irqrestore(&ictx->kc_lock, flags);
@@ -1800,7 +1807,7 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 {
 	u8 ffdc_cfg_byte = ictx->usb_rx_buf[6];
 	u8 detected_display_type = IMON_DISPLAY_TYPE_NONE;
-	u64 allowed_protos = RC_PROTO_BIT_OTHER;
+	u64 allowed_protos = RC_PROTO_BIT_IMON;
 
 	switch (ffdc_cfg_byte) {
 	/* iMON Knob, no display, iMON IR + vol knob */
@@ -1848,8 +1855,10 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 	default:
 		dev_info(ictx->dev, "Unknown 0xffdc device, defaulting to VFD and iMON IR");
 		detected_display_type = IMON_DISPLAY_TYPE_VFD;
-		/* We don't know which one it is, allow user to set the
-		 * RC6 one from userspace if OTHER wasn't correct. */
+		/*
+		 * We don't know which one it is, allow user to set the
+		 * RC6 one from userspace if IMON wasn't correct.
+		 */
 		allowed_protos |= RC_PROTO_BIT_RC6_MCE;
 		break;
 	}
@@ -1936,7 +1945,7 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 
 	rdev->priv = ictx;
 	/* iMON PAD or MCE */
-	rdev->allowed_protocols = RC_PROTO_BIT_OTHER | RC_PROTO_BIT_RC6_MCE;
+	rdev->allowed_protocols = RC_PROTO_BIT_IMON | RC_PROTO_BIT_RC6_MCE;
 	rdev->change_protocol = imon_ir_change_protocol;
 	rdev->driver_name = MOD_NAME;
 
-- 
2.14.3
