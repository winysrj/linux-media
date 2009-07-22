Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:56712 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbZGVBYO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 21:24:14 -0400
Subject: [PATCH v2 2/4] ir-kbd-i2c: Allow use of ir-kdb-i2c internal
 get_key funcs and set ir_type
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Mark Lord <lkml@rtr.ca>,
	Jarod Wilson <jarod@redhat.com>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Janne Grunau <j@jannau.net>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 21:25:57 -0400
Message-Id: <1248225957.3191.57.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch augments the init data passed by bridge drivers to
ir-kbd-i2c, so that the ir_type can be set explicitly, and so 
ir-kbd-i2c internal get_key functions can be reused without
requiring symbols from ir-kbd-i2c in the bridge driver.

Signed-off-by: Andy Walls <awalls@radix.net>
Reviewed-by: Jean Delvare <khali@linux-fr.org>


diff -r 6477aa1782d5 linux/drivers/media/video/ir-kbd-i2c.c
--- a/linux/drivers/media/video/ir-kbd-i2c.c	Tue Jul 21 09:17:24 2009 -0300
+++ b/linux/drivers/media/video/ir-kbd-i2c.c	Tue Jul 21 20:55:54 2009 -0400
@@ -478,7 +480,36 @@
 
 		ir_codes = init_data->ir_codes;
 		name = init_data->name;
-		ir->get_key = init_data->get_key;
+		if (init_data->type)
+			ir_type = init_data->type;
+
+		switch (init_data->internal_get_key_func) {
+		case IR_KBD_GET_KEY_CUSTOM:
+			/* The bridge driver provided us its own function */
+			ir->get_key = init_data->get_key;
+			break;
+		case IR_KBD_GET_KEY_PIXELVIEW:
+			ir->get_key = get_key_pixelview;
+			break;
+		case IR_KBD_GET_KEY_PV951:
+			ir->get_key = get_key_pv951;
+			break;
+		case IR_KBD_GET_KEY_HAUP:
+			ir->get_key = get_key_haup;
+			break;
+		case IR_KBD_GET_KEY_KNC1:
+			ir->get_key = get_key_knc1;
+			break;
+		case IR_KBD_GET_KEY_FUSIONHDTV:
+			ir->get_key = get_key_fusionhdtv;
+			break;
+		case IR_KBD_GET_KEY_HAUP_XVR:
+			ir->get_key = get_key_haup_xvr;
+			break;
+		case IR_KBD_GET_KEY_AVERMEDIA_CARDBUS:
+			ir->get_key = get_key_avermedia_cardbus;
+			break;
+		}
 	}
 
 	/* Make sure we are all setup before going on */
diff -r 6477aa1782d5 linux/include/media/ir-kbd-i2c.h
--- a/linux/include/media/ir-kbd-i2c.h	Tue Jul 21 09:17:24 2009 -0300
+++ b/linux/include/media/ir-kbd-i2c.h	Tue Jul 21 20:55:54 2009 -0400
@@ -24,10 +24,27 @@
 	int                    (*get_key)(struct IR_i2c*, u32*, u32*);
 };
 
+enum ir_kbd_get_key_fn {
+	IR_KBD_GET_KEY_CUSTOM = 0,
+	IR_KBD_GET_KEY_PIXELVIEW,
+	IR_KBD_GET_KEY_PV951,
+	IR_KBD_GET_KEY_HAUP,
+	IR_KBD_GET_KEY_KNC1,
+	IR_KBD_GET_KEY_FUSIONHDTV,
+	IR_KBD_GET_KEY_HAUP_XVR,
+	IR_KBD_GET_KEY_AVERMEDIA_CARDBUS,
+};
+
 /* Can be passed when instantiating an ir_video i2c device */
 struct IR_i2c_init_data {
 	IR_KEYTAB_TYPE         *ir_codes;
 	const char             *name;
+	int                    type; /* IR_TYPE_RC5, IR_TYPE_PD, etc */
+	/*
+	 * Specify either a function pointer or a value indicating one of
+	 * ir_kbd_i2c's internal get_key functions
+	 */
 	int                    (*get_key)(struct IR_i2c*, u32*, u32*);
+	enum ir_kbd_get_key_fn internal_get_key_func;
 };
 #endif


