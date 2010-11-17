Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934924Ab0KQTXP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 14:23:15 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJNEIL028414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:23:14 -0500
Received: from pedra (vpn-230-120.phx2.redhat.com [10.3.230.120])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJC5xQ007699
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:23:09 -0500
Date: Wed, 17 Nov 2010 17:08:25 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 02/10] [media] rc: Remove ir-common.h
Message-ID: <20101117170825.470a928e@pedra>
In-Reply-To: <cover.1290020731.git.mchehab@redhat.com>
References: <cover.1290020731.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 delete mode 100644 include/media/ir-common.h

diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index e8f60ab..e4df7f8 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -147,6 +147,11 @@ static void bttv_input_timer(unsigned long data)
  * testing.
  */
 
+#define RC5_START(x)	(((x) >> 12) & 3)
+#define RC5_TOGGLE(x)	(((x) >> 11) & 1)
+#define RC5_ADDR(x)	(((x) >> 6) & 31)
+#define RC5_INSTR(x)	((x) & 63)
+
 /* decode raw bit pattern to RC5 code */
 static u32 bttv_rc5_decode(unsigned int code)
 {
diff --git a/drivers/media/video/bt8xx/bttv.h b/drivers/media/video/bt8xx/bttv.h
index 6fd2a8e..fd62bf1 100644
--- a/drivers/media/video/bt8xx/bttv.h
+++ b/drivers/media/video/bt8xx/bttv.h
@@ -17,7 +17,6 @@
 #include <linux/videodev2.h>
 #include <linux/i2c.h>
 #include <media/v4l2-device.h>
-#include <media/ir-common.h>
 #include <media/i2c-addr.h>
 #include <media/tuner.h>
 
diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/video/bt8xx/bttvp.h
index 157285b..0bbdd48 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -41,7 +41,7 @@
 #include <linux/device.h>
 #include <media/videobuf-dma-sg.h>
 #include <media/tveeprom.h>
-#include <media/ir-common.h>
+#include <media/ir-core.h>
 #include <media/ir-kbd-i2c.h>
 
 #include "bt848.h"
@@ -120,6 +120,47 @@ struct bttv_format {
 	int  hshift,vshift;   /* for planar modes   */
 };
 
+struct card_ir {
+	struct rc_dev           *dev;
+
+	char                    name[32];
+	char                    phys[32];
+#if 0
+	int                     users;
+	u32                     running:1;
+#endif
+	/* Usual gpio signalling */
+	u32                     mask_keycode;
+	u32                     mask_keydown;
+	u32                     mask_keyup;
+	u32                     polling;
+	u32                     last_gpio;
+	int                     shift_by;
+	int                     start; // What should RC5_START() be
+	int                     addr; // What RC5_ADDR() should be.
+	int                     rc5_remote_gap;
+	struct work_struct      work;
+	struct timer_list       timer;
+
+	/* RC5 gpio */
+	u32 rc5_gpio;
+	struct timer_list timer_end;    /* timer_end for code completion */
+	u32 last_bit;                   /* last raw bit seen */
+	u32 code;                       /* raw code under construction */
+	struct timeval base_time;       /* time of last seen code */
+	int active;                     /* building raw code */
+
+#if 0
+	/* NEC decoding */
+	u32                     nec_gpio;
+	struct tasklet_struct   tlet;
+
+	/* IR core raw decoding */
+	u32                     raw_decode;
+#endif
+};
+
+
 /* ---------------------------------------------------------- */
 
 struct bttv_geometry {
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 72562b8..900e798 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -61,7 +61,7 @@ static int saa7134_raw_decode_irq(struct saa7134_dev *dev);
 
 static int build_key(struct saa7134_dev *dev)
 {
-	struct card_ir *ir = dev->remote;
+	struct saa7134_card_ir *ir = dev->remote;
 	u32 gpio, data;
 
 	/* here comes the additional handshake steps for some cards */
@@ -385,7 +385,7 @@ static int get_key_pinnacle_color(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 
 void saa7134_input_irq(struct saa7134_dev *dev)
 {
-	struct card_ir *ir;
+	struct saa7134_card_ir *ir;
 
 	if (!dev || !dev->remote)
 		return;
@@ -404,7 +404,7 @@ void saa7134_input_irq(struct saa7134_dev *dev)
 static void saa7134_input_timer(unsigned long data)
 {
 	struct saa7134_dev *dev = (struct saa7134_dev *)data;
-	struct card_ir *ir = dev->remote;
+	struct saa7134_card_ir *ir = dev->remote;
 
 	build_key(dev);
 	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
@@ -413,17 +413,17 @@ static void saa7134_input_timer(unsigned long data)
 static void ir_raw_decode_timer_end(unsigned long data)
 {
 	struct saa7134_dev *dev = (struct saa7134_dev *)data;
-	struct card_ir *ir = dev->remote;
+	struct saa7134_card_ir *ir = dev->remote;
 
 	ir_raw_event_handle(dev->remote->dev);
 
-	ir->active = 0;
+	ir->active = false;
 }
 
 static int __saa7134_ir_start(void *priv)
 {
 	struct saa7134_dev *dev = priv;
-	struct card_ir *ir;
+	struct saa7134_card_ir *ir;
 
 	if (!dev)
 		return -EINVAL;
@@ -435,7 +435,7 @@ static int __saa7134_ir_start(void *priv)
 	if (ir->running)
 		return 0;
 
-	ir->running = 1;
+	ir->running = true;
 	if (ir->polling) {
 		setup_timer(&ir->timer, saa7134_input_timer,
 			    (unsigned long)dev);
@@ -446,7 +446,7 @@ static int __saa7134_ir_start(void *priv)
 		init_timer(&ir->timer_end);
 		ir->timer_end.function = ir_raw_decode_timer_end;
 		ir->timer_end.data = (unsigned long)dev;
-		ir->active = 0;
+		ir->active = false;
 	}
 
 	return 0;
@@ -455,7 +455,7 @@ static int __saa7134_ir_start(void *priv)
 static void __saa7134_ir_stop(void *priv)
 {
 	struct saa7134_dev *dev = priv;
-	struct card_ir *ir;
+	struct saa7134_card_ir *ir;
 
 	if (!dev)
 		return;
@@ -470,10 +470,10 @@ static void __saa7134_ir_stop(void *priv)
 		del_timer_sync(&dev->remote->timer);
 	else if (ir->raw_decode) {
 		del_timer_sync(&ir->timer_end);
-		ir->active = 0;
+		ir->active = false;
 	}
 
-	ir->running = 0;
+	ir->running = false;
 
 	return;
 }
@@ -511,7 +511,7 @@ static void saa7134_ir_close(struct rc_dev *rc)
 
 int saa7134_input_init1(struct saa7134_dev *dev)
 {
-	struct card_ir *ir;
+	struct saa7134_card_ir *ir;
 	struct rc_dev *rc;
 	char *ir_codes = NULL;
 	u32 mask_keycode = 0;
@@ -764,7 +764,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	ir->dev = rc;
 	dev->remote = ir;
 
-	ir->running = 0;
+	ir->running = false;
 
 	/* init hardware-specific stuff */
 	ir->mask_keycode = mask_keycode;
@@ -934,7 +934,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 
 static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 {
-	struct card_ir	*ir = dev->remote;
+	struct saa7134_card_ir	*ir = dev->remote;
 	unsigned long 	timeout;
 	int space;
 
@@ -953,7 +953,7 @@ static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 	if (!ir->active) {
 		timeout = jiffies + jiffies_to_msecs(15);
 		mod_timer(&ir->timer_end, timeout);
-		ir->active = 1;
+		ir->active = true;
 	}
 
 	return 1;
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index a6c726f..c6ef95e 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -119,6 +119,27 @@ struct saa7134_format {
 	unsigned int   uvswap:1;
 };
 
+struct saa7134_card_ir {
+	struct rc_dev		*dev;
+
+	char                    name[32];
+	char                    phys[32];
+	int                     users;
+
+	u32			polling;
+        u32			last_gpio;
+        u32			mask_keycode, mask_keydown, mask_keyup;
+
+	bool                    running;
+	bool			active;
+
+	struct timer_list       timer;
+	struct timer_list	timer_end;    /* timer_end for code completion */
+
+	/* IR core raw decoding */
+	u32                     raw_decode;
+};
+
 /* ----------------------------------------------------------- */
 /* card configuration                                          */
 
@@ -530,7 +551,7 @@ struct saa7134_dev {
 
 	/* infrared remote */
 	int                        has_remote;
-	struct card_ir		   *remote;
+	struct saa7134_card_ir		   *remote;
 
 	/* pci i/o */
 	char                       name[32];
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
deleted file mode 100644
index 41fefd9..0000000
--- a/include/media/ir-common.h
+++ /dev/null
@@ -1,77 +0,0 @@
-/*
- * some common functions to handle infrared remote protocol decoding for
- * drivers which have not yet been (or can't be) converted to use the
- * regular protocol decoders...
- *
- * (c) 2003 Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#ifndef _IR_COMMON
-#define _IR_COMMON
-
-#include <linux/input.h>
-#include <linux/workqueue.h>
-#include <linux/interrupt.h>
-#include <media/ir-core.h>
-
-#define RC5_START(x)	(((x)>>12)&3)
-#define RC5_TOGGLE(x)	(((x)>>11)&1)
-#define RC5_ADDR(x)	(((x)>>6)&31)
-#define RC5_INSTR(x)	((x)&63)
-
-/* this was saa7134_ir and bttv_ir, moved here for
- * rc5 decoding. */
-struct card_ir {
-	struct rc_dev		*dev;
-	char                    name[32];
-	char                    phys[32];
-	int			users;
-	u32			running:1;
-
-	/* Usual gpio signalling */
-	u32                     mask_keycode;
-	u32                     mask_keydown;
-	u32                     mask_keyup;
-	u32                     polling;
-	u32                     last_gpio;
-	int			shift_by;
-	int			start; // What should RC5_START() be
-	int			addr; // What RC5_ADDR() should be.
-	int			rc5_remote_gap;
-	struct work_struct      work;
-	struct timer_list       timer;
-
-	/* RC5 gpio */
-	u32 rc5_gpio;
-	struct timer_list timer_end;	/* timer_end for code completion */
-	u32 last_bit;			/* last raw bit seen */
-	u32 code;			/* raw code under construction */
-	struct timeval base_time;	/* time of last seen code */
-	int active;			/* building raw code */
-
-	/* NEC decoding */
-	u32			nec_gpio;
-	struct tasklet_struct   tlet;
-
-	/* IR core raw decoding */
-	u32			raw_decode;
-};
-
-/* Routines from ir-functions.c */
-void ir_rc5_timer_end(unsigned long data);
-
-#endif
diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
index aca015e..d27505f 100644
--- a/include/media/ir-kbd-i2c.h
+++ b/include/media/ir-kbd-i2c.h
@@ -1,7 +1,7 @@
 #ifndef _IR_I2C
 #define _IR_I2C
 
-#include <media/ir-common.h>
+#include <media/ir-core.h>
 
 #define DEFAULT_POLLING_INTERVAL	100	/* ms */
 
-- 
1.7.1


