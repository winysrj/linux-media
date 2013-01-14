Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:37213 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533Ab3ANJvr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 04:51:47 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2] [media] iguanair: intermittent initialization failure
Date: Mon, 14 Jan 2013 09:51:44 +0000
Message-Id: <1358157104-3665-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On cold boot the device does not initialize until the first packet is
received, and that packet is not processed.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/iguanair.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index a569c69..8d390a8 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -58,6 +58,7 @@ struct iguanair {
 	char phys[64];
 };
 
+#define CMD_NOP			0x00
 #define CMD_GET_VERSION		0x01
 #define CMD_GET_BUFSIZE		0x11
 #define CMD_GET_FEATURES	0x10
@@ -196,6 +197,10 @@ static void iguanair_irq_out(struct urb *urb)
 
 	if (urb->status)
 		dev_dbg(ir->dev, "Error: out urb status = %d\n", urb->status);
+
+	/* if we sent an nop packet, do not expect a response */
+	if (urb->status == 0 && ir->packet->header.cmd == CMD_NOP)
+		complete(&ir->completion);
 }
 
 static int iguanair_send(struct iguanair *ir, unsigned size)
@@ -219,10 +224,17 @@ static int iguanair_get_features(struct iguanair *ir)
 {
 	int rc;
 
+	/*
+	 * On cold boot, the iguanair initializes on the first packet
+	 * received but does not process that packet. Send an empty
+	 * packet.
+	 */
 	ir->packet->header.start = 0;
 	ir->packet->header.direction = DIR_OUT;
-	ir->packet->header.cmd = CMD_GET_VERSION;
+	ir->packet->header.cmd = CMD_NOP;
+	iguanair_send(ir, sizeof(ir->packet->header));
 
+	ir->packet->header.cmd = CMD_GET_VERSION;
 	rc = iguanair_send(ir, sizeof(ir->packet->header));
 	if (rc) {
 		dev_info(ir->dev, "failed to get version\n");
@@ -255,19 +267,14 @@ static int iguanair_get_features(struct iguanair *ir)
 	ir->packet->header.cmd = CMD_GET_FEATURES;
 
 	rc = iguanair_send(ir, sizeof(ir->packet->header));
-	if (rc) {
+	if (rc)
 		dev_info(ir->dev, "failed to get features\n");
-		goto out;
-	}
-
 out:
 	return rc;
 }
 
 static int iguanair_receiver(struct iguanair *ir, bool enable)
 {
-	int rc;
-
 	ir->packet->header.start = 0;
 	ir->packet->header.direction = DIR_OUT;
 	ir->packet->header.cmd = enable ? CMD_RECEIVER_ON : CMD_RECEIVER_OFF;
@@ -275,9 +282,7 @@ static int iguanair_receiver(struct iguanair *ir, bool enable)
 	if (enable)
 		ir_raw_event_reset(ir->rc);
 
-	rc = iguanair_send(ir, sizeof(ir->packet->header));
-
-	return rc;
+	return iguanair_send(ir, sizeof(ir->packet->header));
 }
 
 /*
-- 
1.7.11.7

