Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:51236 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab0FGTcm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 15:32:42 -0400
Subject: [PATCH 5/8] ir-core: partially convert bt8xx to not use ir-functions.c
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Date: Mon, 07 Jun 2010 21:32:38 +0200
Message-ID: <20100607193238.21236.72227.stgit@localhost.localdomain>
In-Reply-To: <20100607192830.21236.69701.stgit@localhost.localdomain>
References: <20100607192830.21236.69701.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Partially convert drivers/media/video/bt8xx/bttv-input.c to
not use ir-functions.c.

Since the last user is gone with this patch, also remove a
bunch of code from ir-functions.c.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/IR/ir-functions.c             |   89 +--------------------------
 drivers/media/video/bt8xx/bttv-input.c      |   35 ++---------
 drivers/media/video/bt8xx/bttv.h            |    1 
 drivers/media/video/bt8xx/bttvp.h           |   11 ---
 drivers/media/video/cx23885/cx23885-input.c |   51 +--------------
 drivers/media/video/saa7134/saa7134-input.c |   61 +++----------------
 include/media/ir-common.h                   |   22 -------
 include/media/ir-kbd-i2c.h                  |    1 
 8 files changed, 27 insertions(+), 244 deletions(-)

diff --git a/drivers/media/IR/ir-functions.c b/drivers/media/IR/ir-functions.c
index db591e4..d7f47b2 100644
--- a/drivers/media/IR/ir-functions.c
+++ b/drivers/media/IR/ir-functions.c
@@ -31,67 +31,6 @@
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
 
-static int repeat = 1;
-module_param(repeat, int, 0444);
-MODULE_PARM_DESC(repeat,"auto-repeat for IR keys (default: on)");
-
-/* -------------------------------------------------------------------------- */
-
-static void ir_input_key_event(struct input_dev *dev, struct ir_input_state *ir)
-{
-	if (KEY_RESERVED == ir->keycode) {
-		printk(KERN_INFO "%s: unknown key: key=0x%02x down=%d\n",
-		       dev->name, ir->ir_key, ir->keypressed);
-		return;
-	}
-	IR_dprintk(1,"%s: key event code=%d down=%d\n",
-		dev->name,ir->keycode,ir->keypressed);
-	input_report_key(dev,ir->keycode,ir->keypressed);
-	input_sync(dev);
-}
-
-/* -------------------------------------------------------------------------- */
-
-int ir_input_init(struct input_dev *dev, struct ir_input_state *ir,
-		  const u64 ir_type)
-{
-	ir->ir_type = ir_type;
-
-	if (repeat)
-		set_bit(EV_REP, dev->evbit);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ir_input_init);
-
-
-void ir_input_nokey(struct input_dev *dev, struct ir_input_state *ir)
-{
-	if (ir->keypressed) {
-		ir->keypressed = 0;
-		ir_input_key_event(dev,ir);
-	}
-}
-EXPORT_SYMBOL_GPL(ir_input_nokey);
-
-void ir_input_keydown(struct input_dev *dev, struct ir_input_state *ir,
-		      u32 ir_key)
-{
-	u32 keycode = ir_g_keycode_from_table(dev, ir_key);
-
-	if (ir->keypressed && ir->keycode != keycode) {
-		ir->keypressed = 0;
-		ir_input_key_event(dev,ir);
-	}
-	if (!ir->keypressed) {
-		ir->ir_key  = ir_key;
-		ir->keycode = keycode;
-		ir->keypressed = 1;
-		ir_input_key_event(dev,ir);
-	}
-}
-EXPORT_SYMBOL_GPL(ir_input_keydown);
-
 /* -------------------------------------------------------------------------- */
 /* extract mask bits out of data and pack them into the result */
 u32 ir_extract_bits(u32 data, u32 mask)
@@ -284,12 +223,10 @@ void ir_rc5_timer_end(unsigned long data)
 {
 	struct card_ir *ir = (struct card_ir *)data;
 	struct timeval tv;
-	unsigned long current_jiffies, timeout;
 	u32 gap;
 	u32 rc5 = 0;
 
 	/* get time */
-	current_jiffies = jiffies;
 	do_gettimeofday(&tv);
 
 	/* avoid overflow with gap >1s */
@@ -325,32 +262,10 @@ void ir_rc5_timer_end(unsigned long data)
 			u32 toggle = RC5_TOGGLE(rc5);
 			u32 instr = RC5_INSTR(rc5);
 
-			/* Good code, decide if repeat/repress */
-			if (toggle != RC5_TOGGLE(ir->last_rc5) ||
-			    instr != RC5_INSTR(ir->last_rc5)) {
-				IR_dprintk(1, "ir-common: instruction %x, toggle %x\n", instr,
-					toggle);
-				ir_input_nokey(ir->dev, &ir->ir);
-				ir_input_keydown(ir->dev, &ir->ir, instr);
-			}
-
-			/* Set/reset key-up timer */
-			timeout = current_jiffies +
-				  msecs_to_jiffies(ir->rc5_key_timeout);
-			mod_timer(&ir->timer_keyup, timeout);
-
-			/* Save code for repeat test */
-			ir->last_rc5 = rc5;
+			/* Good code */
+			ir_keydown(ir->dev, instr, toggle);
 		}
 	}
 }
 EXPORT_SYMBOL_GPL(ir_rc5_timer_end);
 
-void ir_rc5_timer_keyup(unsigned long data)
-{
-	struct card_ir *ir = (struct card_ir *)data;
-
-	IR_dprintk(1, "ir-common: key released\n");
-	ir_input_nokey(ir->dev, &ir->ir);
-}
-EXPORT_SYMBOL_GPL(ir_rc5_timer_keyup);
diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index 814fd34..66cdc0d 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -30,10 +30,6 @@
 
 static int ir_debug;
 module_param(ir_debug, int, 0644);
-static int repeat_delay = 500;
-module_param(repeat_delay, int, 0644);
-static int repeat_period = 33;
-module_param(repeat_period, int, 0644);
 
 static int ir_rc5_remote_gap = 885;
 module_param(ir_rc5_remote_gap, int, 0644);
@@ -75,14 +71,11 @@ static void ir_handle_key(struct bttv *btv)
 
 	if ((ir->mask_keydown  &&  (0 != (gpio & ir->mask_keydown))) ||
 	    (ir->mask_keyup    &&  (0 == (gpio & ir->mask_keyup)))) {
-		ir_input_keydown(ir->dev, &ir->ir, data);
-	} else {
+		ir_keydown(ir->dev, data, 0);
+	} else if (btv->c.type == BTTV_BOARD_WINFAST2000) {
 		/* HACK: Probably, ir->mask_keydown is missing
 		   for this board */
-		if (btv->c.type == BTTV_BOARD_WINFAST2000)
-			ir_input_keydown(ir->dev, &ir->ir, data);
-
-		ir_input_nokey(ir->dev,&ir->ir);
+		ir_keydown(ir->dev, data, 0);
 	}
 
 }
@@ -106,9 +99,7 @@ static void ir_enltv_handle_key(struct bttv *btv)
 			gpio, data,
 			(gpio & ir->mask_keyup) ? " up" : "up/down");
 
-		ir_input_keydown(ir->dev, &ir->ir, data);
-		if (keyup)
-			ir_input_nokey(ir->dev, &ir->ir);
+		ir_keydown(ir->dev, data, 0);
 	} else {
 		if ((ir->last_gpio & 1 << 31) == keyup)
 			return;
@@ -117,10 +108,8 @@ static void ir_enltv_handle_key(struct bttv *btv)
 			gpio, data,
 			(gpio & ir->mask_keyup) ? " up" : "down");
 
-		if (keyup)
-			ir_input_nokey(ir->dev, &ir->ir);
-		else
-			ir_input_keydown(ir->dev, &ir->ir, data);
+		if (!keyup)
+			ir_keydown(ir->dev, data, 0);
 	}
 
 	ir->last_gpio = data | keyup;
@@ -215,9 +204,6 @@ static void bttv_ir_start(struct bttv *btv, struct card_ir *ir)
 		ir->timer_end.function = ir_rc5_timer_end;
 		ir->timer_end.data = (unsigned long)ir;
 
-		init_timer(&ir->timer_keyup);
-		ir->timer_keyup.function = ir_rc5_timer_keyup;
-		ir->timer_keyup.data = (unsigned long)ir;
 		ir->shift_by = 1;
 		ir->start = 3;
 		ir->addr = 0x0;
@@ -370,10 +356,7 @@ int bttv_input_init(struct bttv *btv)
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0",
 		 pci_name(btv->c.pci));
 
-	err = ir_input_init(input_dev, &ir->ir, ir_type);
-	if (err < 0)
-		goto err_out_free;
-
+	ir->ir_type = ir_type;
 	input_dev->name = ir->name;
 	input_dev->phys = ir->phys;
 	input_dev->id.bustype = BUS_PCI;
@@ -395,10 +378,6 @@ int bttv_input_init(struct bttv *btv)
 	if (err)
 		goto err_out_stop;
 
-	/* the remote isn't as bouncy as a keyboard */
-	ir->dev->rep[REP_DELAY] = repeat_delay;
-	ir->dev->rep[REP_PERIOD] = repeat_period;
-
 	return 0;
 
  err_out_stop:
diff --git a/drivers/media/video/bt8xx/bttv.h b/drivers/media/video/bt8xx/bttv.h
index 3ec2402..33882c8 100644
--- a/drivers/media/video/bt8xx/bttv.h
+++ b/drivers/media/video/bt8xx/bttv.h
@@ -17,6 +17,7 @@
 #include <linux/videodev2.h>
 #include <linux/i2c.h>
 #include <media/v4l2-device.h>
+#include <media/ir-core.h>
 #include <media/ir-common.h>
 #include <media/ir-kbd-i2c.h>
 #include <media/i2c-addr.h>
diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/video/bt8xx/bttvp.h
index 6cccc2a..4b29863 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -41,6 +41,7 @@
 #include <linux/device.h>
 #include <media/videobuf-dma-sg.h>
 #include <media/tveeprom.h>
+#include <media/ir-core.h>
 #include <media/ir-common.h>
 
 
@@ -298,16 +299,6 @@ struct bttv_pll_info {
 	unsigned int pll_current;  /* Currently programmed ofreq */
 };
 
-/* for gpio-connected remote control */
-struct bttv_input {
-	struct input_dev      *dev;
-	struct ir_input_state ir;
-	char                  name[32];
-	char                  phys[32];
-	u32                   mask_keycode;
-	u32                   mask_keydown;
-};
-
 struct bttv_suspend_state {
 	u32  gpio_enable;
 	u32  gpio_data;
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index f7d0ad6..faf097d 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -36,6 +36,7 @@
  */
 
 #include <linux/input.h>
+#include <media/ir-core.h>
 #include <media/ir-common.h>
 #include <media/v4l2-subdev.h>
 
@@ -88,21 +89,8 @@ static void cx23885_input_process_raw_rc5(struct cx23885_dev *dev)
 	if (ir_input->addr != RC5_ADDR(rc5))
 		return;
 
-	/* Don't generate a keypress for RC-5 auto-repeated keypresses */
 	command = rc5_command(rc5);
-	if (RC5_TOGGLE(rc5) != RC5_TOGGLE(ir_input->last_rc5) ||
-	    command != rc5_command(ir_input->last_rc5) ||
-	    /* Catch T == 0, CMD == 0 (e.g. '0') as first keypress after init */
-	    RC5_START(ir_input->last_rc5) == 0) {
-		/* This keypress is differnet: not an auto repeat */
-		ir_input_nokey(ir_input->dev, &ir_input->ir);
-		ir_input_keydown(ir_input->dev, &ir_input->ir, command);
-	}
-	ir_input->last_rc5 = rc5;
-
-	/* Schedule when we should do the key up event: ir_input_nokey() */
-	mod_timer(&ir_input->timer_keyup,
-		  jiffies + msecs_to_jiffies(ir_input->rc5_key_timeout));
+	ir_keydown(ir_input->dev, command, RC5_TOGGLE(rc5));
 }
 
 static void cx23885_input_next_pulse_width_rc5(struct cx23885_dev *dev,
@@ -166,7 +154,6 @@ static void cx23885_input_process_pulse_widths_rc5(struct cx23885_dev *dev,
 						   bool add_eom)
 {
 	struct card_ir *ir_input = dev->ir_input;
-	struct ir_input_state *ir_input_state = &ir_input->ir;
 
 	u32 ns_pulse[RC5_HALF_BITS+1];
 	ssize_t num = 0;
@@ -185,7 +172,7 @@ static void cx23885_input_process_pulse_widths_rc5(struct cx23885_dev *dev,
 		}
 
 		/* Just drain the Rx FIFO, if we're called, but not RC-5 */
-		if (ir_input_state->ir_type != IR_TYPE_RC5)
+		if (ir_input->ir_type != IR_TYPE_RC5)
 			continue;
 
 		for (i = 0; i < count; i++)
@@ -242,8 +229,6 @@ void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events)
 
 static void cx23885_input_ir_start(struct cx23885_dev *dev)
 {
-	struct card_ir *ir_input = dev->ir_input;
-	struct ir_input_state *ir_input_state = &ir_input->ir;
 	struct v4l2_subdev_ir_parameters params;
 
 	if (dev->sd_ir == NULL)
@@ -251,23 +236,6 @@ static void cx23885_input_ir_start(struct cx23885_dev *dev)
 
 	atomic_set(&dev->ir_input_stopping, 0);
 
-	/* keyup timer set up, if needed */
-	switch (dev->board) {
-	case CX23885_BOARD_HAUPPAUGE_HVR1850:
-	case CX23885_BOARD_HAUPPAUGE_HVR1290:
-		setup_timer(&ir_input->timer_keyup,
-			    ir_rc5_timer_keyup,	/* Not actually RC-5 specific */
-			    (unsigned long) ir_input);
-		if (ir_input_state->ir_type == IR_TYPE_RC5) {
-			/*
-			 * RC-5 repeats a held key every
-			 * 64 bits * (2 * 32/36000) sec/bit = 113.778 ms
-			 */
-			ir_input->rc5_key_timeout = 115;
-		}
-		break;
-	}
-
 	v4l2_subdev_call(dev->sd_ir, ir, rx_g_parameters, &params);
 	switch (dev->board) {
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
@@ -302,7 +270,6 @@ static void cx23885_input_ir_start(struct cx23885_dev *dev)
 
 static void cx23885_input_ir_stop(struct cx23885_dev *dev)
 {
-	struct card_ir *ir_input = dev->ir_input;
 	struct v4l2_subdev_ir_parameters params;
 
 	if (dev->sd_ir == NULL)
@@ -326,13 +293,6 @@ static void cx23885_input_ir_stop(struct cx23885_dev *dev)
 	}
 
 	flush_scheduled_work();
-
-	switch (dev->board) {
-	case CX23885_BOARD_HAUPPAUGE_HVR1850:
-	case CX23885_BOARD_HAUPPAUGE_HVR1290:
-		del_timer_sync(&ir_input->timer_keyup);
-		break;
-	}
 }
 
 int cx23885_input_init(struct cx23885_dev *dev)
@@ -379,10 +339,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 		 cx23885_boards[dev->board].name);
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0", pci_name(dev->pci));
 
-	ret = ir_input_init(input_dev, &ir->ir, ir_type);
-	if (ret < 0)
-		goto err_out_free;
-
+	ir->ir_type = ir_type;
 	input_dev->name = ir->name;
 	input_dev->phys = ir->phys;
 	input_dev->id.bustype = BUS_PCI;
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 28c230d..562a514 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -46,14 +46,6 @@ module_param(ir_rc5_remote_gap, int, 0644);
 static int ir_rc5_key_timeout = 115;
 module_param(ir_rc5_key_timeout, int, 0644);
 
-static int repeat_delay = 500;
-module_param(repeat_delay, int, 0644);
-MODULE_PARM_DESC(repeat_delay, "delay before key repeat started");
-static int repeat_period = 33;
-module_param(repeat_period, int, 0644);
-MODULE_PARM_DESC(repeat_period, "repeat period between "
-    "keypresses when key is down");
-
 static unsigned int disable_other_ir;
 module_param(disable_other_ir, int, 0644);
 MODULE_PARM_DESC(disable_other_ir, "disable full codes of "
@@ -69,7 +61,6 @@ static int saa7134_rc5_irq(struct saa7134_dev *dev);
 static int saa7134_nec_irq(struct saa7134_dev *dev);
 static int saa7134_raw_decode_irq(struct saa7134_dev *dev);
 static void nec_task(unsigned long data);
-static void saa7134_nec_timer(unsigned long data);
 
 /* -------------------- GPIO generic keycode builder -------------------- */
 
@@ -102,27 +93,20 @@ static int build_key(struct saa7134_dev *dev)
 
 	switch (dev->board) {
 	case SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG:
-		if (data == ir->mask_keycode)
-			ir_input_nokey(ir->dev, &ir->ir);
-		else
-			ir_input_keydown(ir->dev, &ir->ir, data);
+		if (data != ir->mask_keycode)
+			ir_keydown(ir->dev, data, 0);
 		return 0;
 	}
 
 	if (ir->polling) {
 		if ((ir->mask_keydown  &&  (0 != (gpio & ir->mask_keydown))) ||
-		    (ir->mask_keyup    &&  (0 == (gpio & ir->mask_keyup)))) {
-			ir_input_keydown(ir->dev, &ir->ir, data);
-		} else {
-			ir_input_nokey(ir->dev, &ir->ir);
-		}
+		    (ir->mask_keyup    &&  (0 == (gpio & ir->mask_keyup))))
+			ir_keydown(ir->dev, data, 0);
 	}
 	else {	/* IRQ driven mode - handle key press and release in one go */
 		if ((ir->mask_keydown  &&  (0 != (gpio & ir->mask_keydown))) ||
-		    (ir->mask_keyup    &&  (0 == (gpio & ir->mask_keyup)))) {
-			ir_input_keydown(ir->dev, &ir->ir, data);
-			ir_input_nokey(ir->dev, &ir->ir);
-		}
+		    (ir->mask_keyup    &&  (0 == (gpio & ir->mask_keyup))))
+			ir_keydown(ir->dev, data, 0);
 	}
 
 	return 0;
@@ -464,17 +448,12 @@ static int __saa7134_ir_start(void *priv)
 		init_timer(&ir->timer_end);
 		ir->timer_end.function = ir_rc5_timer_end;
 		ir->timer_end.data = (unsigned long)ir;
-		init_timer(&ir->timer_keyup);
-		ir->timer_keyup.function = ir_rc5_timer_keyup;
-		ir->timer_keyup.data = (unsigned long)ir;
 		ir->shift_by = 2;
 		ir->start = 0x2;
 		ir->addr = 0x17;
 		ir->rc5_key_timeout = ir_rc5_key_timeout;
 		ir->rc5_remote_gap = ir_rc5_remote_gap;
 	} else if (ir->nec_gpio) {
-		setup_timer(&ir->timer_keyup, saa7134_nec_timer,
-			    (unsigned long)dev);
 		tasklet_init(&ir->tlet, nec_task, (unsigned long)dev);
 	} else if (ir->raw_decode) {
 		/* set timer_end for code completion */
@@ -862,10 +841,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		ir->props.change_protocol = saa7134_ir_change_protocol;
 	}
 
-	err = ir_input_init(input_dev, &ir->ir, ir_type);
-	if (err < 0)
-		goto err_out_free;
-
+	ir->ir_type = ir_type;
 	input_dev->name = ir->name;
 	input_dev->phys = ir->phys;
 	input_dev->id.bustype = BUS_PCI;
@@ -883,10 +859,6 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	if (err)
 		goto err_out_free;
 
-	/* the remote isn't as bouncy as a keyboard */
-	ir->dev->rep[REP_DELAY] = repeat_delay;
-	ir->dev->rep[REP_PERIOD] = repeat_period;
-
 	return 0;
 
 err_out_free:
@@ -1082,16 +1054,6 @@ static int saa7134_rc5_irq(struct saa7134_dev *dev)
    The first pulse (start) has 9 + 4.5 ms
  */
 
-static void saa7134_nec_timer(unsigned long data)
-{
-	struct saa7134_dev *dev = (struct saa7134_dev *) data;
-	struct card_ir *ir = dev->remote;
-
-	dprintk("Cancel key repeat\n");
-
-	ir_input_nokey(ir->dev, &ir->ir);
-}
-
 static void nec_task(unsigned long data)
 {
 	struct saa7134_dev *dev = (struct saa7134_dev *) data;
@@ -1180,12 +1142,11 @@ static void nec_task(unsigned long data)
 		dprintk("scancode = 0x%02x (code = 0x%02x, notcode= 0x%02x)\n",
 			 ir->code, ircode, not_code);
 
-		ir_input_keydown(ir->dev, &ir->ir, ir->code);
-	} else
+		ir_keydown(ir->dev, ir->code, 0);
+	} else {
 		dprintk("Repeat last key\n");
-
-	/* Keep repeating the last key */
-	mod_timer(&ir->timer_keyup, jiffies + msecs_to_jiffies(150));
+		ir_repeat(ir->dev);
+	}
 
 	saa_setl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18_P);
 }
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index 528050e..8043a53 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -33,21 +33,11 @@
 #define RC5_ADDR(x)	(((x)>>6)&31)
 #define RC5_INSTR(x)	((x)&63)
 
-struct ir_input_state {
-	/* configuration */
-	u64      ir_type;
-
-	/* key info */
-	u32                ir_key;      /* ir scancode */
-	u32                keycode;     /* linux key code */
-	int                keypressed;  /* current state */
-};
-
 /* this was saa7134_ir and bttv_ir, moved here for
  * rc5 decoding. */
 struct card_ir {
 	struct input_dev        *dev;
-	struct ir_input_state   ir;
+	u64			ir_type;
 	char                    name[32];
 	char                    phys[32];
 	int			users;
@@ -73,8 +63,6 @@ struct card_ir {
 	/* RC5 gpio */
 	u32 rc5_gpio;
 	struct timer_list timer_end;	/* timer_end for code completion */
-	struct timer_list timer_keyup;	/* timer_end for key release */
-	u32 last_rc5;			/* last good rc5 code */
 	u32 last_bit;			/* last raw bit seen */
 	u32 code;			/* raw code under construction */
 	struct timeval base_time;	/* time of last seen code */
@@ -89,19 +77,11 @@ struct card_ir {
 };
 
 /* Routines from ir-functions.c */
-
-int ir_input_init(struct input_dev *dev, struct ir_input_state *ir,
-		   const u64 ir_type);
-void ir_input_nokey(struct input_dev *dev, struct ir_input_state *ir);
-void ir_input_keydown(struct input_dev *dev, struct ir_input_state *ir,
-		      u32 ir_key);
 u32  ir_extract_bits(u32 data, u32 mask);
 int  ir_dump_samples(u32 *samples, int count);
 int  ir_decode_biphase(u32 *samples, int count, int low, int high);
 int  ir_decode_pulsedistance(u32 *samples, int count, int low, int high);
 u32  ir_rc5_decode(unsigned int code);
-
 void ir_rc5_timer_end(unsigned long data);
-void ir_rc5_timer_keyup(unsigned long data);
 
 #endif
diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
index 5e96d7a..13ea2aa 100644
--- a/include/media/ir-kbd-i2c.h
+++ b/include/media/ir-kbd-i2c.h
@@ -10,7 +10,6 @@ struct IR_i2c {
 
 	struct i2c_client      *c;
 	struct input_dev       *input;
-	struct ir_input_state  ir;
 	u64                    ir_type;
 	/* Used to avoid fast repeating */
 	unsigned char          old;

