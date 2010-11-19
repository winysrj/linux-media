Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:52213 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab0KSXnA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 18:43:00 -0500
Subject: [PATCH 03/10] saa7134: some minor cleanups
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@infradead.org
Date: Sat, 20 Nov 2010 00:42:51 +0100
Message-ID: <20101119234251.3511.18824.stgit@localhost.localdomain>
In-Reply-To: <20101119233959.3511.91287.stgit@localhost.localdomain>
References: <20101119233959.3511.91287.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Mostly using appropriate data types and constants (e.g. int -> bool).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/video/saa7134/saa7134-input.c |   49 ++++++++++-----------------
 drivers/media/video/saa7134/saa7134.h       |    4 +-
 2 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 10dc9ad..d75c307 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -407,17 +407,16 @@ static int __saa7134_ir_start(void *priv)
 	struct saa7134_dev *dev = priv;
 	struct saa7134_card_ir *ir;
 
-	if (!dev)
+	if (!dev || !dev->remote)
 		return -EINVAL;
 
 	ir  = dev->remote;
-	if (!ir)
-		return -EINVAL;
-
 	if (ir->running)
 		return 0;
 
 	ir->running = true;
+	ir->active = false;
+
 	if (ir->polling) {
 		setup_timer(&ir->timer, saa7134_input_timer,
 			    (unsigned long)dev);
@@ -425,10 +424,8 @@ static int __saa7134_ir_start(void *priv)
 		add_timer(&ir->timer);
 	} else if (ir->raw_decode) {
 		/* set timer_end for code completion */
-		init_timer(&ir->timer_end);
-		ir->timer_end.function = ir_raw_decode_timer_end;
-		ir->timer_end.data = (unsigned long)dev;
-		ir->active = false;
+		setup_timer(&ir->timer_end, ir_raw_decode_timer_end,
+			    (unsigned long)dev);
 	}
 
 	return 0;
@@ -439,22 +436,19 @@ static void __saa7134_ir_stop(void *priv)
 	struct saa7134_dev *dev = priv;
 	struct saa7134_card_ir *ir;
 
-	if (!dev)
+	if (!dev || !dev->remote)
 		return;
 
 	ir  = dev->remote;
-	if (!ir)
-		return;
-
 	if (!ir->running)
 		return;
-	if (dev->remote->polling)
-		del_timer_sync(&dev->remote->timer);
-	else if (ir->raw_decode) {
+
+	if (ir->polling)
+		del_timer_sync(&ir->timer);
+	else if (ir->raw_decode)
 		del_timer_sync(&ir->timer_end);
-		ir->active = false;
-	}
 
+	ir->active = false;
 	ir->running = false;
 
 	return;
@@ -499,8 +493,8 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	u32 mask_keycode = 0;
 	u32 mask_keydown = 0;
 	u32 mask_keyup   = 0;
-	int polling      = 0;
-	int raw_decode   = 0;
+	unsigned polling = 0;
+	bool raw_decode  = false;
 	int err;
 
 	if (dev->has_remote != SAA7134_REMOTE_GPIO)
@@ -565,14 +559,14 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		mask_keydown = 0x0040000;	/* Enable GPIO18 line on both edges */
 		mask_keyup   = 0x0040000;
 		mask_keycode = 0xffff;
-		raw_decode   = 1;
+		raw_decode   = true;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_M733A:
 		ir_codes     = RC_MAP_AVERMEDIA_M733A_RM_K6;
 		mask_keydown = 0x0040000;
 		mask_keyup   = 0x0040000;
 		mask_keycode = 0xffff;
-		raw_decode   = 1;
+		raw_decode   = true;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_777:
 	case SAA7134_BOARD_AVERMEDIA_A16AR:
@@ -679,7 +673,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		mask_keydown = 0x0040000;	/* Enable GPIO18 line on both edges */
 		mask_keyup   = 0x0040000;
 		mask_keycode = 0xffff;
-		raw_decode   = 1;
+		raw_decode   = true;
 		break;
 	case SAA7134_BOARD_ENCORE_ENLTV:
 	case SAA7134_BOARD_ENCORE_ENLTV_FM:
@@ -693,7 +687,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		mask_keydown = 0x0040000;	/* Enable GPIO18 line on both edges */
 		mask_keyup   = 0x0040000;
 		mask_keycode = 0xffff;
-		raw_decode   = 1;
+		raw_decode   = true;
 		break;
 	case SAA7134_BOARD_10MOONSTVMASTER3:
 		ir_codes     = RC_MAP_ENCORE_ENLTV;
@@ -746,8 +740,6 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	ir->dev = rc;
 	dev->remote = ir;
 
-	ir->running = false;
-
 	/* init hardware-specific stuff */
 	ir->mask_keycode = mask_keycode;
 	ir->mask_keydown = mask_keydown;
@@ -809,14 +801,12 @@ void saa7134_input_fini(struct saa7134_dev *dev)
 void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 {
 	struct i2c_board_info info;
-
 	struct i2c_msg msg_msi = {
 		.addr = 0x50,
 		.flags = I2C_M_RD,
 		.len = 0,
 		.buf = NULL,
 	};
-
 	int rc;
 
 	if (disable_ir) {
@@ -916,8 +906,8 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 
 static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 {
-	struct saa7134_card_ir	*ir = dev->remote;
-	unsigned long 	timeout;
+	struct saa7134_card_ir *ir = dev->remote;
+	unsigned long timeout;
 	int space;
 
 	/* Generate initial event */
@@ -926,7 +916,6 @@ static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 	space = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & ir->mask_keydown;
 	ir_raw_event_store_edge(dev->remote->dev, space ? IR_SPACE : IR_PULSE);
 
-
 	/*
 	 * Wait 15 ms from the start of the first IR event before processing
 	 * the event. This time is enough for NEC protocol. May need adjustments
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index 1923f3c..f93951a 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -124,7 +124,7 @@ struct saa7134_card_ir {
 
 	char                    name[32];
 	char                    phys[32];
-	int                     users;
+	unsigned                users;
 
 	u32			polling;
         u32			last_gpio;
@@ -551,7 +551,7 @@ struct saa7134_dev {
 
 	/* infrared remote */
 	int                        has_remote;
-	struct saa7134_card_ir		   *remote;
+	struct saa7134_card_ir     *remote;
 
 	/* pci i/o */
 	char                       name[32];

