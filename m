Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:41374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934924Ab0KQTWJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 14:22:09 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJM8Qe019208
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:22:09 -0500
Received: from pedra (vpn-230-120.phx2.redhat.com [10.3.230.120])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJC5xP007699
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:22:02 -0500
Date: Wed, 17 Nov 2010 17:08:24 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 01/10] [media] rc: remove ir-common module
Message-ID: <20101117170824.1449f117@pedra>
In-Reply-To: <cover.1290020731.git.mchehab@redhat.com>
References: <cover.1290020731.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Something weird happened with commit 740069e6e043403199dbe2b42256722fb814f6ae.
Instead of dong the right thing, it got somehow corrupted and reverted the
rc changes.

Thanks to David Härdeman for pointing me about the problem.

This patch should be merged with 740069e6e04 before sending upstream.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 delete mode 100644 drivers/media/rc/ir-functions.c

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 2d15468..ef19375 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -10,11 +10,6 @@ menuconfig IR_CORE
 	  if you don't need IR, as otherwise, you may not be able to
 	  compile the driver for your adapter.
 
-config IR_LEGACY
-	tristate
-	depends on IR_CORE
-	default IR_CORE
-
 if IR_CORE
 
 config LIRC
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 859c12c..8c0e4cb 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -1,10 +1,8 @@
-ir-common-objs  := ir-functions.o
 rc-core-objs	:= rc-main.o rc-raw.o
 
 obj-y += keymaps/
 
 obj-$(CONFIG_IR_CORE) += rc-core.o
-obj-$(CONFIG_IR_LEGACY) += ir-common.o
 obj-$(CONFIG_LIRC) += lirc_dev.o
 obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
 obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
diff --git a/drivers/media/rc/ir-functions.c b/drivers/media/rc/ir-functions.c
deleted file mode 100644
index 14397d0..0000000
--- a/drivers/media/rc/ir-functions.c
+++ /dev/null
@@ -1,120 +0,0 @@
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
-#include <linux/module.h>
-#include <linux/string.h>
-#include <linux/jiffies.h>
-#include <media/ir-common.h>
-#include "rc-core-priv.h"
-
-/* -------------------------------------------------------------------------- */
-
-MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
-MODULE_LICENSE("GPL");
-
-/* RC5 decoding stuff, moved from bttv-input.c to share it with
- * saa7134 */
-
-/* decode raw bit pattern to RC5 code */
-static u32 ir_rc5_decode(unsigned int code)
-{
-	unsigned int org_code = code;
-	unsigned int pair;
-	unsigned int rc5 = 0;
-	int i;
-
-	for (i = 0; i < 14; ++i) {
-		pair = code & 0x3;
-		code >>= 2;
-
-		rc5 <<= 1;
-		switch (pair) {
-		case 0:
-		case 2:
-			break;
-		case 1:
-			rc5 |= 1;
-			break;
-		case 3:
-			IR_dprintk(1, "ir-common: ir_rc5_decode(%x) bad code\n", org_code);
-			return 0;
-		}
-	}
-	IR_dprintk(1, "ir-common: code=%x, rc5=%x, start=%x, toggle=%x, address=%x, "
-		"instr=%x\n", rc5, org_code, RC5_START(rc5),
-		RC5_TOGGLE(rc5), RC5_ADDR(rc5), RC5_INSTR(rc5));
-	return rc5;
-}
-
-void ir_rc5_timer_end(unsigned long data)
-{
-	struct card_ir *ir = (struct card_ir *)data;
-	struct timeval tv;
-	unsigned long current_jiffies;
-	u32 gap;
-	u32 rc5 = 0;
-
-	/* get time */
-	current_jiffies = jiffies;
-	do_gettimeofday(&tv);
-
-	/* avoid overflow with gap >1s */
-	if (tv.tv_sec - ir->base_time.tv_sec > 1) {
-		gap = 200000;
-	} else {
-		gap = 1000000 * (tv.tv_sec - ir->base_time.tv_sec) +
-		    tv.tv_usec - ir->base_time.tv_usec;
-	}
-
-	/* signal we're ready to start a new code */
-	ir->active = 0;
-
-	/* Allow some timer jitter (RC5 is ~24ms anyway so this is ok) */
-	if (gap < 28000) {
-		IR_dprintk(1, "ir-common: spurious timer_end\n");
-		return;
-	}
-
-	if (ir->last_bit < 20) {
-		/* ignore spurious codes (caused by light/other remotes) */
-		IR_dprintk(1, "ir-common: short code: %x\n", ir->code);
-	} else {
-		ir->code = (ir->code << ir->shift_by) | 1;
-		rc5 = ir_rc5_decode(ir->code);
-
-		/* two start bits? */
-		if (RC5_START(rc5) != ir->start) {
-			IR_dprintk(1, "ir-common: rc5 start bits invalid: %u\n", RC5_START(rc5));
-
-			/* right address? */
-		} else if (RC5_ADDR(rc5) == ir->addr) {
-			u32 toggle = RC5_TOGGLE(rc5);
-			u32 instr = RC5_INSTR(rc5);
-
-			/* Good code */
-			ir_keydown(ir->dev, instr, toggle);
-			IR_dprintk(1, "ir-common: instruction %x, toggle %x\n",
-				   instr, toggle);
-		}
-	}
-}
-EXPORT_SYMBOL_GPL(ir_rc5_timer_end);
diff --git a/drivers/media/video/bt8xx/Kconfig b/drivers/media/video/bt8xx/Kconfig
index 659e448..3c7c0a5 100644
--- a/drivers/media/video/bt8xx/Kconfig
+++ b/drivers/media/video/bt8xx/Kconfig
@@ -4,7 +4,7 @@ config VIDEO_BT848
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEOBUF_DMA_SG
-	depends on IR_LEGACY
+	depends on IR_CORE
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_MSP3400 if VIDEO_HELPER_CHIPS_AUTO
diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index 4b4f613..e8f60ab 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -140,7 +140,100 @@ static void bttv_input_timer(unsigned long data)
 	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
 }
 
-/* ---------------------------------------------------------------*/
+/*
+ * FIXME: Nebula digi uses the legacy way to decode RC5, instead of relying
+ * on the rc-core way. As we need to be sure that both IRQ transitions are
+ * properly triggered, Better to touch it only with this hardware for
+ * testing.
+ */
+
+/* decode raw bit pattern to RC5 code */
+static u32 bttv_rc5_decode(unsigned int code)
+{
+	unsigned int org_code = code;
+	unsigned int pair;
+	unsigned int rc5 = 0;
+	int i;
+
+	for (i = 0; i < 14; ++i) {
+		pair = code & 0x3;
+		code >>= 2;
+
+		rc5 <<= 1;
+		switch (pair) {
+		case 0:
+		case 2:
+			break;
+		case 1:
+			rc5 |= 1;
+		break;
+		case 3:
+			dprintk(KERN_INFO DEVNAME ":rc5_decode(%x) bad code\n",
+				org_code);
+			return 0;
+		}
+	}
+	dprintk(KERN_INFO DEVNAME ":"
+		"code=%x, rc5=%x, start=%x, toggle=%x, address=%x, "
+		"instr=%x\n", rc5, org_code, RC5_START(rc5),
+		RC5_TOGGLE(rc5), RC5_ADDR(rc5), RC5_INSTR(rc5));
+	return rc5;
+}
+
+void bttv_rc5_timer_end(unsigned long data)
+{
+	struct card_ir *ir = (struct card_ir *)data;
+	struct timeval tv;
+	unsigned long current_jiffies;
+	u32 gap;
+	u32 rc5 = 0;
+
+	/* get time */
+	current_jiffies = jiffies;
+	do_gettimeofday(&tv);
+
+	/* avoid overflow with gap >1s */
+	if (tv.tv_sec - ir->base_time.tv_sec > 1) {
+		gap = 200000;
+	} else {
+		gap = 1000000 * (tv.tv_sec - ir->base_time.tv_sec) +
+		    tv.tv_usec - ir->base_time.tv_usec;
+	}
+
+	/* signal we're ready to start a new code */
+	ir->active = 0;
+
+	/* Allow some timer jitter (RC5 is ~24ms anyway so this is ok) */
+	if (gap < 28000) {
+		dprintk(KERN_INFO DEVNAME ": spurious timer_end\n");
+		return;
+	}
+
+	if (ir->last_bit < 20) {
+		/* ignore spurious codes (caused by light/other remotes) */
+		dprintk(KERN_INFO DEVNAME ": short code: %x\n", ir->code);
+	} else {
+		ir->code = (ir->code << ir->shift_by) | 1;
+		rc5 = bttv_rc5_decode(ir->code);
+
+		/* two start bits? */
+		if (RC5_START(rc5) != ir->start) {
+			printk(KERN_INFO DEVNAME ":"
+			       " rc5 start bits invalid: %u\n", RC5_START(rc5));
+
+			/* right address? */
+		} else if (RC5_ADDR(rc5) == ir->addr) {
+			u32 toggle = RC5_TOGGLE(rc5);
+			u32 instr = RC5_INSTR(rc5);
+
+			/* Good code */
+			ir_keydown(ir->dev, instr, toggle);
+			dprintk(KERN_INFO DEVNAME ":"
+				" instruction %x, toggle %x\n",
+				instr, toggle);
+		}
+	}
+}
 
 static int bttv_rc5_irq(struct bttv *btv)
 {
@@ -206,7 +299,7 @@ static void bttv_ir_start(struct bttv *btv, struct card_ir *ir)
 	} else if (ir->rc5_gpio) {
 		/* set timer_end for code completion */
 		init_timer(&ir->timer_end);
-		ir->timer_end.function = ir_rc5_timer_end;
+		ir->timer_end.function = bttv_rc5_timer_end;
 		ir->timer_end.data = (unsigned long)ir;
 		ir->shift_by = 1;
 		ir->start = 3;
@@ -283,10 +376,10 @@ void __devinit init_bttv_i2c_ir(struct bttv *btv)
 	default:
 		/*
 		 * The external IR receiver is at i2c address 0x34 (0x35 for
-                 * reads).  Future Hauppauge cards will have an internal
-                 * receiver at 0x30 (0x31 for reads).  In theory, both can be
-                 * fitted, and Hauppauge suggest an external overrides an
-                 * internal.
+		 * reads).  Future Hauppauge cards will have an internal
+		 * receiver at 0x30 (0x31 for reads).  In theory, both can be
+		 * fitted, and Hauppauge suggest an external overrides an
+		 * internal.
 		 * That's why we probe 0x1a (~0x34) first. CB
 		 */
 
diff --git a/drivers/media/video/saa7134/Kconfig b/drivers/media/video/saa7134/Kconfig
index 32a95a2..e03bff9 100644
--- a/drivers/media/video/saa7134/Kconfig
+++ b/drivers/media/video/saa7134/Kconfig
@@ -26,7 +26,7 @@ config VIDEO_SAA7134_ALSA
 
 config VIDEO_SAA7134_RC
 	bool "Philips SAA7134 Remote Controller support"
-	depends on IR_LEGACY
+	depends on IR_CORE
 	depends on VIDEO_SAA7134
 	default y
 	---help---
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index fbb2ff1..72562b8 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -54,11 +54,8 @@ MODULE_PARM_DESC(disable_other_ir, "disable full codes of "
 #define i2cdprintk(fmt, arg...)    if (ir_debug) \
 	printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg)
 
-/* Helper functions for RC5 and NEC decoding at GPIO16 or GPIO18 */
-static int saa7134_rc5_irq(struct saa7134_dev *dev);
-static int saa7134_nec_irq(struct saa7134_dev *dev);
+/* Helper function for raw decoding at GPIO16 or GPIO18 */
 static int saa7134_raw_decode_irq(struct saa7134_dev *dev);
-static void nec_task(unsigned long data);
 
 /* -------------------- GPIO generic keycode builder -------------------- */
 
@@ -397,12 +394,8 @@ void saa7134_input_irq(struct saa7134_dev *dev)
 	if (!ir->running)
 		return;
 
-	if (ir->nec_gpio) {
-		saa7134_nec_irq(dev);
-	} else if (!ir->polling && !ir->rc5_gpio && !ir->raw_decode) {
+	if (!ir->polling && !ir->raw_decode) {
 		build_key(dev);
-	} else if (ir->rc5_gpio) {
-		saa7134_rc5_irq(dev);
 	} else if (ir->raw_decode) {
 		saa7134_raw_decode_irq(dev);
 	}
@@ -448,17 +441,6 @@ static int __saa7134_ir_start(void *priv)
 			    (unsigned long)dev);
 		ir->timer.expires  = jiffies + HZ;
 		add_timer(&ir->timer);
-	} else if (ir->rc5_gpio) {
-		/* set timer_end for code completion */
-		init_timer(&ir->timer_end);
-		ir->timer_end.function = ir_rc5_timer_end;
-		ir->timer_end.data = (unsigned long)ir;
-		ir->shift_by = 2;
-		ir->start = 0x2;
-		ir->addr = 0x17;
-		ir->rc5_remote_gap = ir_rc5_remote_gap;
-	} else if (ir->nec_gpio) {
-		tasklet_init(&ir->tlet, nec_task, (unsigned long)dev);
 	} else if (ir->raw_decode) {
 		/* set timer_end for code completion */
 		init_timer(&ir->timer_end);
@@ -486,10 +468,6 @@ static void __saa7134_ir_stop(void *priv)
 		return;
 	if (dev->remote->polling)
 		del_timer_sync(&dev->remote->timer);
-	else if (ir->rc5_gpio)
-		del_timer_sync(&ir->timer_end);
-	else if (ir->nec_gpio)
-		tasklet_kill(&ir->tlet);
 	else if (ir->raw_decode) {
 		del_timer_sync(&ir->timer_end);
 		ir->active = 0;
@@ -531,40 +509,6 @@ static void saa7134_ir_close(struct rc_dev *rc)
 		__saa7134_ir_stop(dev);
 }
 
-
-static int saa7134_ir_change_protocol(struct rc_dev *rc, u64 ir_type)
-{
-	struct saa7134_dev *dev = rc->priv;
-	struct card_ir *ir = dev->remote;
-	u32 nec_gpio, rc5_gpio;
-
-	if (ir_type == IR_TYPE_RC5) {
-		dprintk("Changing protocol to RC5\n");
-		nec_gpio = 0;
-		rc5_gpio = 1;
-	} else if (ir_type == IR_TYPE_NEC) {
-		dprintk("Changing protocol to NEC\n");
-		nec_gpio = 1;
-		rc5_gpio = 0;
-	} else {
-		dprintk("IR protocol type %ud is not supported\n",
-			(unsigned)ir_type);
-		return -EINVAL;
-	}
-
-	if (ir->running) {
-		saa7134_ir_stop(dev);
-		ir->nec_gpio = nec_gpio;
-		ir->rc5_gpio = rc5_gpio;
-		saa7134_ir_start(dev);
-	} else {
-		ir->nec_gpio = nec_gpio;
-		ir->rc5_gpio = rc5_gpio;
-	}
-
-	return 0;
-}
-
 int saa7134_input_init1(struct saa7134_dev *dev)
 {
 	struct card_ir *ir;
@@ -574,10 +518,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	u32 mask_keydown = 0;
 	u32 mask_keyup   = 0;
 	int polling      = 0;
-	int rc5_gpio	 = 0;
-	int nec_gpio	 = 0;
 	int raw_decode   = 0;
-	int allow_protocol_change = 0;
 	int err;
 
 	if (dev->has_remote != SAA7134_REMOTE_GPIO)
@@ -767,9 +708,10 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		break;
 	case SAA7134_BOARD_ENCORE_ENLTV_FM53:
 		ir_codes     = RC_MAP_ENCORE_ENLTV_FM53;
-		mask_keydown = 0x0040000;
-		mask_keycode = 0x00007f;
-		nec_gpio = 1;
+		mask_keydown = 0x0040000;	/* Enable GPIO18 line on both edges */
+		mask_keyup   = 0x0040000;
+		mask_keycode = 0xffff;
+		raw_decode   = 1;
 		break;
 	case SAA7134_BOARD_10MOONSTVMASTER3:
 		ir_codes     = RC_MAP_ENCORE_ENLTV;
@@ -829,8 +771,6 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	ir->mask_keydown = mask_keydown;
 	ir->mask_keyup   = mask_keyup;
 	ir->polling      = polling;
-	ir->rc5_gpio	 = rc5_gpio;
-	ir->nec_gpio	 = nec_gpio;
 	ir->raw_decode	 = raw_decode;
 
 	/* init input device */
@@ -845,11 +785,6 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	if (raw_decode)
 		rc->driver_type = RC_DRIVER_IR_RAW;
 
-	if (!raw_decode && allow_protocol_change) {
-		rc->allowed_protos = IR_TYPE_RC5 | IR_TYPE_NEC;
-		rc->change_protocol = saa7134_ir_change_protocol;
-	}
-
 	rc->input_name = ir->name;
 	rc->input_phys = ir->phys;
 	rc->input_id.bustype = BUS_PCI;
@@ -1023,152 +958,3 @@ static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 
 	return 1;
 }
-
-static int saa7134_rc5_irq(struct saa7134_dev *dev)
-{
-	struct card_ir *ir = dev->remote;
-	struct timeval tv;
-	u32 gap;
-	unsigned long current_jiffies, timeout;
-
-	/* get time of bit */
-	current_jiffies = jiffies;
-	do_gettimeofday(&tv);
-
-	/* avoid overflow with gap >1s */
-	if (tv.tv_sec - ir->base_time.tv_sec > 1) {
-		gap = 200000;
-	} else {
-		gap = 1000000 * (tv.tv_sec - ir->base_time.tv_sec) +
-		    tv.tv_usec - ir->base_time.tv_usec;
-	}
-
-	/* active code => add bit */
-	if (ir->active) {
-		/* only if in the code (otherwise spurious IRQ or timer
-		   late) */
-		if (ir->last_bit < 28) {
-			ir->last_bit = (gap - ir_rc5_remote_gap / 2) /
-			    ir_rc5_remote_gap;
-			ir->code |= 1 << ir->last_bit;
-		}
-		/* starting new code */
-	} else {
-		ir->active = 1;
-		ir->code = 0;
-		ir->base_time = tv;
-		ir->last_bit = 0;
-
-		timeout = current_jiffies + (500 + 30 * HZ) / 1000;
-		mod_timer(&ir->timer_end, timeout);
-	}
-
-	return 1;
-}
-
-static void nec_task(unsigned long data)
-{
-	struct saa7134_dev *dev = (struct saa7134_dev *) data;
-	struct card_ir *ir;
-	struct timeval tv;
-	int count, pulse, oldpulse, gap;
-	u32 ircode = 0, not_code = 0;
-	int ngap = 0;
-
-	if (!data) {
-		printk(KERN_ERR "saa713x/ir: Can't recover dev struct\n");
-		/* GPIO will be kept disabled */
-		return;
-	}
-
-	ir = dev->remote;
-
-	/* rising SAA7134_GPIO_GPRESCAN reads the status */
-	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
-	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
-
-	oldpulse = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & ir->mask_keydown;
-	pulse = oldpulse;
-
-	do_gettimeofday(&tv);
-	ir->base_time = tv;
-
-	/* Decode NEC pulsecode. This code can take up to 76.5 ms to run.
-	   Unfortunately, using IRQ to decode pulse didn't work, since it uses
-	   a pulse train of 38KHz. This means one pulse on each 52 us
-	 */
-	do {
-		/* Wait until the end of pulse/space or 5 ms */
-		for (count = 0; count < 500; count++)  {
-			udelay(10);
-			/* rising SAA7134_GPIO_GPRESCAN reads the status */
-			saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
-			saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
-			pulse = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2)
-				& ir->mask_keydown;
-			if (pulse != oldpulse)
-				break;
-		}
-
-		do_gettimeofday(&tv);
-		gap = 1000000 * (tv.tv_sec - ir->base_time.tv_sec) +
-				tv.tv_usec - ir->base_time.tv_usec;
-
-		if (!pulse) {
-			/* Bit 0 has 560 us, while bit 1 has 1120 us.
-			   Do something only if bit == 1
-			 */
-			if (ngap && (gap > 560 + 280)) {
-				unsigned int shift = ngap - 1;
-
-				/* Address first, then command */
-				if (shift < 8) {
-					shift += 8;
-					ircode |= 1 << shift;
-				} else if (shift < 16) {
-					not_code |= 1 << shift;
-				} else if (shift < 24) {
-					shift -= 16;
-					ircode |= 1 << shift;
-				} else {
-					shift -= 24;
-					not_code |= 1 << shift;
-				}
-			}
-			ngap++;
-		}
-
-
-		ir->base_time = tv;
-
-		/* TIMEOUT - Long pulse */
-		if (gap >= 5000)
-			break;
-		oldpulse = pulse;
-	} while (ngap < 32);
-
-	if (ngap == 32) {
-		/* FIXME: should check if not_code == ~ircode */
-		ir->code = ir_extract_bits(ircode, ir->mask_keycode);
-
-		dprintk("scancode = 0x%02x (code = 0x%02x, notcode= 0x%02x)\n",
-			 ir->code, ircode, not_code);
-
-		ir_keydown(ir->dev, ir->code, 0);
-	} else {
-		dprintk("Repeat last key\n");
-		ir_repeat(ir->dev);
-	}
-
-	saa_setl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18_P);
-}
-
-static int saa7134_nec_irq(struct saa7134_dev *dev)
-{
-	struct card_ir *ir = dev->remote;
-
-	saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18_P);
-	tasklet_schedule(&ir->tlet);
-
-	return 1;
-}
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index 4e37b8b..a6c726f 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -37,7 +37,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/tuner.h>
-#include <media/ir-common.h>
+#include <media/ir-core.h>
 #include <media/ir-kbd-i2c.h>
 #include <media/videobuf-dma-sg.h>
 #include <sound/core.h>
-- 
1.7.1


