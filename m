Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756449Ab0KMTgd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 14:36:33 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oADJaXWR002284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 13 Nov 2010 14:36:33 -0500
Received: from pedra (vpn-229-222.phx2.redhat.com [10.3.229.222])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oADJXRSl018179
	for <linux-media@vger.kernel.org>; Sat, 13 Nov 2010 14:36:32 -0500
Date: Sat, 13 Nov 2010 17:33:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] [media] saa7134: Remove legacy IR decoding logic inside
 the module
Message-ID: <20101113173316.76e5a56d@pedra>
In-Reply-To: <cover.1289676395.git.mchehab@redhat.com>
References: <cover.1289676395.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The only IR left still using the old raw decoders on saa7134 is ENCORE
FM 5.3. As it is now using the standard rc-core raw decoders, lots
of old code can be removed from saa7134.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 4878f46..72562b8 100644
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
@@ -830,8 +771,6 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	ir->mask_keydown = mask_keydown;
 	ir->mask_keyup   = mask_keyup;
 	ir->polling      = polling;
-	ir->rc5_gpio	 = rc5_gpio;
-	ir->nec_gpio	 = nec_gpio;
 	ir->raw_decode	 = raw_decode;
 
 	/* init input device */
@@ -846,11 +785,6 @@ int saa7134_input_init1(struct saa7134_dev *dev)
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
@@ -1024,152 +958,3 @@ static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 
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


