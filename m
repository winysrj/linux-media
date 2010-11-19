Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:33755 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757515Ab0KSXoo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 18:44:44 -0500
Subject: [PATCH 07/10] bttv: rename struct card_ir to bttv_ir
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@infradead.org
Date: Sat, 20 Nov 2010 00:43:12 +0100
Message-ID: <20101119234312.3511.8906.stgit@localhost.localdomain>
In-Reply-To: <20101119233959.3511.91287.stgit@localhost.localdomain>
References: <20101119233959.3511.91287.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

bttv_ir is more consistent with all other structs used in the same driver.
Also, clean up the struct to remove commented out members and the work_struct
which is unused.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/video/bt8xx/bttv-input.c |   27 +++++++++++++--------------
 drivers/media/video/bt8xx/bttvp.h      |   31 +++++++++----------------------
 2 files changed, 22 insertions(+), 36 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index 773ee6a..c8bf423 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -49,7 +49,7 @@ module_param(ir_rc5_remote_gap, int, 0644);
 
 static void ir_handle_key(struct bttv *btv)
 {
-	struct card_ir *ir = btv->remote;
+	struct bttv_ir *ir = btv->remote;
 	u32 gpio,data;
 
 	/* read gpio value */
@@ -83,7 +83,7 @@ static void ir_handle_key(struct bttv *btv)
 
 static void ir_enltv_handle_key(struct bttv *btv)
 {
-	struct card_ir *ir = btv->remote;
+	struct bttv_ir *ir = btv->remote;
 	u32 gpio, data, keyup;
 
 	/* read gpio value */
@@ -122,7 +122,7 @@ static void ir_enltv_handle_key(struct bttv *btv)
 
 void bttv_input_irq(struct bttv *btv)
 {
-	struct card_ir *ir = btv->remote;
+	struct bttv_ir *ir = btv->remote;
 
 	if (!ir->polling)
 		ir_handle_key(btv);
@@ -131,7 +131,7 @@ void bttv_input_irq(struct bttv *btv)
 static void bttv_input_timer(unsigned long data)
 {
 	struct bttv *btv = (struct bttv*)data;
-	struct card_ir *ir = btv->remote;
+	struct bttv_ir *ir = btv->remote;
 
 	if (btv->c.type == BTTV_BOARD_ENLTV_FM_2)
 		ir_enltv_handle_key(btv);
@@ -185,9 +185,9 @@ static u32 bttv_rc5_decode(unsigned int code)
 	return rc5;
 }
 
-void bttv_rc5_timer_end(unsigned long data)
+static void bttv_rc5_timer_end(unsigned long data)
 {
-	struct card_ir *ir = (struct card_ir *)data;
+	struct bttv_ir *ir = (struct card_ir *)data;
 	struct timeval tv;
 	unsigned long current_jiffies;
 	u32 gap;
@@ -206,7 +206,7 @@ void bttv_rc5_timer_end(unsigned long data)
 	}
 
 	/* signal we're ready to start a new code */
-	ir->active = 0;
+	ir->active = false;
 
 	/* Allow some timer jitter (RC5 is ~24ms anyway so this is ok) */
 	if (gap < 28000) {
@@ -242,7 +242,7 @@ void bttv_rc5_timer_end(unsigned long data)
 
 static int bttv_rc5_irq(struct bttv *btv)
 {
-	struct card_ir *ir = btv->remote;
+	struct bttv_ir *ir = btv->remote;
 	struct timeval tv;
 	u32 gpio;
 	u32 gap;
@@ -278,7 +278,7 @@ static int bttv_rc5_irq(struct bttv *btv)
 		}
 		/* starting new code */
 	} else {
-		ir->active = 1;
+		ir->active = true;
 		ir->code = 0;
 		ir->base_time = tv;
 		ir->last_bit = 0;
@@ -295,7 +295,7 @@ static int bttv_rc5_irq(struct bttv *btv)
 
 /* ---------------------------------------------------------------------- */
 
-static void bttv_ir_start(struct bttv *btv, struct card_ir *ir)
+static void bttv_ir_start(struct bttv *btv, struct bttv_ir *ir)
 {
 	if (ir->polling) {
 		setup_timer(&ir->timer, bttv_input_timer, (unsigned long)btv);
@@ -303,9 +303,8 @@ static void bttv_ir_start(struct bttv *btv, struct card_ir *ir)
 		add_timer(&ir->timer);
 	} else if (ir->rc5_gpio) {
 		/* set timer_end for code completion */
-		init_timer(&ir->timer_end);
-		ir->timer_end.function = bttv_rc5_timer_end;
-		ir->timer_end.data = (unsigned long)ir;
+		setup_timer(&ir->timer_end, bttv_rc5_timer_end,
+			    (unsigned long)ir);
 		ir->shift_by = 1;
 		ir->start = 3;
 		ir->addr = 0x0;
@@ -409,7 +408,7 @@ int __devexit fini_bttv_i2c(struct bttv *btv)
 
 int bttv_input_init(struct bttv *btv)
 {
-	struct card_ir *ir;
+	struct bttv_ir *ir;
 	char *ir_codes = NULL;
 	struct rc_dev *rc;
 	int err = -ENOMEM;
diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/video/bt8xx/bttvp.h
index b71d04d..3d5b2bc 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -120,15 +120,12 @@ struct bttv_format {
 	int  hshift,vshift;   /* for planar modes   */
 };
 
-struct card_ir {
+struct bttv_ir {
 	struct rc_dev           *dev;
 
 	char                    name[32];
 	char                    phys[32];
-#if 0
-	int                     users;
-	u32                     running:1;
-#endif
+
 	/* Usual gpio signalling */
 	u32                     mask_keycode;
 	u32                     mask_keydown;
@@ -139,25 +136,15 @@ struct card_ir {
 	int                     start; // What should RC5_START() be
 	int                     addr; // What RC5_ADDR() should be.
 	int                     rc5_remote_gap;
-	struct work_struct      work;
 	struct timer_list       timer;
 
 	/* RC5 gpio */
-	u32 rc5_gpio;
-	struct timer_list timer_end;    /* timer_end for code completion */
-	u32 last_bit;                   /* last raw bit seen */
-	u32 code;                       /* raw code under construction */
-	struct timeval base_time;       /* time of last seen code */
-	int active;                     /* building raw code */
-
-#if 0
-	/* NEC decoding */
-	u32                     nec_gpio;
-	struct tasklet_struct   tlet;
-
-	/* IR core raw decoding */
-	u32                     raw_decode;
-#endif
+	u32                     rc5_gpio;
+	struct timer_list       timer_end;  /* timer_end for code completion */
+	u32                     last_bit;   /* last raw bit seen */
+	u32                     code;       /* raw code under construction */
+	struct timeval          base_time;  /* time of last seen code */
+	bool                    active;     /* building raw code */
 };
 
 
@@ -408,7 +395,7 @@ struct bttv {
 
 	/* infrared remote */
 	int has_remote;
-	struct card_ir *remote;
+	struct bttv_ir *remote;
 
 	/* I2C remote data */
 	struct IR_i2c_init_data    init_data;

