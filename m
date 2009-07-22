Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:56547 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318AbZGVBSt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 21:18:49 -0400
Subject: [PATCH v2 1/4] ir-kbd-i2c: Remove superfulous inlines
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Mark Lord <lkml@rtr.ca>,
	Jarod Wilson <jarod@redhat.com>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Janne Grunau <j@jannau.net>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 21:20:32 -0400
Message-Id: <1248225632.3191.51.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(This is a resubmission of a patch by Jean Delvare)

Functions which are referenced by their address can't be inlined by
definition.
 
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andy Walls <awalls@radix.net>


diff -r 6477aa1782d5 linux/drivers/media/video/ir-kbd-i2c.c
--- a/linux/drivers/media/video/ir-kbd-i2c.c	Tue Jul 21 09:17:24 2009 -0300
+++ b/linux/drivers/media/video/ir-kbd-i2c.c	Tue Jul 21 20:55:54 2009 -0400
@@ -127,12 +127,12 @@
 	return 1;
 }
 
-static inline int get_key_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 {
 	return get_key_haup_common (ir, ir_key, ir_raw, 3, 0);
 }
 
-static inline int get_key_haup_xvr(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_haup_xvr(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 {
 	return get_key_haup_common (ir, ir_key, ir_raw, 6, 3);
 }



