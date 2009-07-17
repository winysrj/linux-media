Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:37826 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340AbZGQUsP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2009 16:48:15 -0400
Subject: [PATCH 3/3] ir-kbd-i2c: Add support for Z8F0811/Hauppage IR
 transceivers
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Mark Lord <lkml@rtr.ca>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>
In-Reply-To: <1247862585.10066.16.camel@palomino.walls.org>
References: <1247862585.10066.16.camel@palomino.walls.org>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 16:49:55 -0400
Message-Id: <1247863795.10066.36.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for Zilog Z8F0811 IR transceiver chips on
CX2341[68] based boards to ir-kbd-i2c for both the old i2c binding model
and the new i2c binding model.

Regards,
Andy

diff -r d754a2d5a376 linux/drivers/media/video/ir-kbd-i2c.c
--- a/linux/drivers/media/video/ir-kbd-i2c.c	Wed Jul 15 07:28:02 2009 -0300
+++ b/linux/drivers/media/video/ir-kbd-i2c.c	Fri Jul 17 16:05:28 2009 -0400
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
@@ -697,7 +726,8 @@
 static const struct i2c_device_id ir_kbd_id[] = {
 	/* Generic entry for any IR receiver */
 	{ "ir_video", 0 },
-	/* IR device specific entries could be added here */
+	/* IR device specific entries should be added here */
+	{ "ir_rx_z8f0811_haup", 0 },
 	{ }
 };
 




