Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:56941 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbZGVBcH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 21:32:07 -0400
Subject: [PATCH v2 4/4] ir-kbd-i2c: Add support for Z8F0811/Hauppage IR
 transceivers
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Mark Lord <lkml@rtr.ca>,
	Jarod Wilson <jarod@redhat.com>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Janne Grunau <j@jannau.net>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 21:33:50 -0400
Message-Id: <1248226430.3191.65.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for Zilog Z8F0811 IR transceiver chips on
CX2341[68] based boards to ir-kbd-i2c for both the old i2c binding model
and the new i2c binding model.

Signed-off-by: Andy Walls <awalls@radix.net>
Reviewed-by: Jean Delvare <khali@linux-fr.org>

 

diff -r 6477aa1782d5 linux/drivers/media/video/ir-kbd-i2c.c
--- a/linux/drivers/media/video/ir-kbd-i2c.c	Tue Jul 21 09:17:24 2009 -0300
+++ b/linux/drivers/media/video/ir-kbd-i2c.c	Tue Jul 21 20:55:54 2009 -0400
@@ -442,9 +442,11 @@
 	case 0x47:
 	case 0x71:
 	case 0x2d:
-		if (adap->id == I2C_HW_B_CX2388x) {
+		if (adap->id == I2C_HW_B_CX2388x ||
+		    adap->id == I2C_HW_B_CX2341X) {
 			/* Handled by cx88-input */
-			name        = "CX2388x remote";
+			name = adap->id == I2C_HW_B_CX2341X ? "CX2341x remote"
+							    : "CX2388x remote";
 			ir_type     = IR_TYPE_RC5;
 			ir->get_key = get_key_haup_xvr;
 			if (hauppauge == 1) {
@@ -697,7 +728,8 @@
 static const struct i2c_device_id ir_kbd_id[] = {
 	/* Generic entry for any IR receiver */
 	{ "ir_video", 0 },
-	/* IR device specific entries could be added here */
+	/* IR device specific entries should be added here */
+	{ "ir_rx_z8f0811_haup", 0 },
 	{ }
 };
 


