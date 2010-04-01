Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758694Ab0DAR6G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 13:58:06 -0400
Date: Thu, 1 Apr 2010 14:56:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 07/15] V4L/DVB: saa7134: don't wait too much to generate an
 IR event on raw_decode
Message-ID: <20100401145632.5d708551@pedra>
In-Reply-To: <cover.1270142346.git.mchehab@redhat.com>
References: <cover.1270142346.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At raw_decode mode, the key is processed after the end of a timer. The
previous code resets the timer every time something is received at the IR
port. While this works fine with IR's that don't implement repeat, like
Avermedia RM-JX IR, it keeps waiting until keydown, on IR's that implement
NEC repeat command, like the Terratec yellow.

The solution is to change the behaviour to do the timeout after the first
received data.

The timeout is currently set to 15 ms, as it works fine with NEC protcocol.
It may need some adjustments to support other protocols and to better handle
spurious detections that may happen with some IR sensors.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index ab60730..f25193c 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -404,6 +404,7 @@ void ir_keyup(struct input_dev *dev)
 	if (!ir->keypressed)
 		return;
 
+	IR_dprintk(1, "keyup key 0x%04x\n", ir->keycode);
 	input_report_key(dev, ir->keycode, 0);
 	input_sync(dev);
 	ir->keypressed = 0;
diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index a58c717..104482a 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -14,21 +14,51 @@
 
 #include <media/ir-core.h>
 
-/* Start time: 4.5 ms  */
-#define MIN_START_TIME	3900000
-#define MAX_START_TIME	5100000
+/* Start time: 4.5 ms + 560 us of the next pulse */
+#define MIN_START_TIME	(3900000 + 560000)
+#define MAX_START_TIME	(5100000 + 560000)
 
-/* Pulse time: 560 us  */
-#define MIN_PULSE_TIME	460000
-#define MAX_PULSE_TIME	660000
+/* Bit 1 time: 2.25ms us */
+#define MIN_BIT1_TIME	2050000
+#define MAX_BIT1_TIME	2450000
 
-/* Bit 1 space time: 2.25ms-560 us */
-#define MIN_BIT1_TIME	1490000
-#define MAX_BIT1_TIME	1890000
+/* Bit 0 time: 1.12ms us */
+#define MIN_BIT0_TIME	920000
+#define MAX_BIT0_TIME	1320000
 
-/* Bit 0 space time: 1.12ms-560 us */
-#define MIN_BIT0_TIME	360000
-#define MAX_BIT0_TIME	760000
+/* Total IR code is 110 ms, including the 9 ms for the start pulse */
+#define MAX_NEC_TIME	4000000
+
+/* Total IR code is 110 ms, including the 9 ms for the start pulse */
+#define MIN_REPEAT_TIME	99000000
+#define MAX_REPEAT_TIME	112000000
+
+/* Repeat time: 2.25ms us */
+#define MIN_REPEAT_START_TIME	2050000
+#define MAX_REPEAT_START_TIME	3000000
+
+#define REPEAT_TIME	240 /* ms */
+
+/** is_repeat - Check if it is a NEC repeat event
+ * @input_dev:	the struct input_dev descriptor of the device
+ * @pos:	the position of the first event
+ * @len:	the length of the buffer
+ */
+static int is_repeat(struct ir_raw_event *evs, int len, int pos)
+{
+	if ((evs[pos].delta.tv_nsec < MIN_REPEAT_START_TIME) ||
+	    (evs[pos].delta.tv_nsec > MAX_REPEAT_START_TIME))
+		return 0;
+
+	if (++pos >= len)
+		return 0;
+
+	if ((evs[pos].delta.tv_nsec < MIN_REPEAT_TIME) ||
+	    (evs[pos].delta.tv_nsec > MAX_REPEAT_TIME))
+		return 0;
+
+	return 1;
+}
 
 /**
  * __ir_nec_decode() - Decode one NEC pulsecode
@@ -36,49 +66,59 @@
  * @evs:	event array with type/duration of pulse/space
  * @len:	length of the array
  * @pos:	position to start seeking for a code
- * This function returns the decoded ircode or -EINVAL if no pulse got decoded
+ * This function returns -EINVAL if no pulse got decoded,
+ * 0 if buffer is empty and 1 if one keycode were handled.
  */
 static int __ir_nec_decode(struct input_dev *input_dev,
 			   struct ir_raw_event *evs,
 			   int len, int *pos)
 {
+	struct ir_input_dev *ir = input_get_drvdata(input_dev);
 	int count = -1;
 	int ircode = 0, not_code = 0;
 
 	/* Be sure that the first event is an start one and is a pulse */
 	for (; *pos < len; (*pos)++) {
-		if (evs[*pos].type & (IR_START_EVENT | IR_PULSE))
+		/* Very long delays are considered as start events */
+		if (evs[*pos].delta.tv_nsec > MAX_NEC_TIME)
 			break;
-	}
-	(*pos)++;	/* First event doesn't contain data */
+		if (evs[*pos].type & IR_START_EVENT)
+			break;
+		IR_dprintk(1, "%luus: Spurious NEC %s\n",
+			   (evs[*pos].delta.tv_nsec + 500) / 1000,
+			   (evs[*pos].type & IR_SPACE) ? "space" : "pulse");
 
+	}
 	if (*pos >= len)
 		return 0;
 
+	(*pos)++;	/* First event doesn't contain data */
+
+	if (evs[*pos].type != IR_PULSE)
+		goto err;
+
+	/* Check if it is a NEC repeat event */
+	if (is_repeat(evs, len, *pos)) {
+		*pos += 2;
+		if (ir->keypressed) {
+			mod_timer(&ir->raw->timer_keyup,
+				jiffies + msecs_to_jiffies(REPEAT_TIME));
+			IR_dprintk(1, "NEC repeat event\n");
+			return 1;
+		} else {
+			IR_dprintk(1, "missing NEC repeat event\n");
+			return 0;
+		}
+	}
+
 	/* First space should have 4.5 ms otherwise is not NEC protocol */
-	if ((evs[*pos].delta.tv_nsec < MIN_START_TIME) |
-	    (evs[*pos].delta.tv_nsec > MAX_START_TIME) |
-	    (evs[*pos].type != IR_SPACE))
+	if ((evs[*pos].delta.tv_nsec < MIN_START_TIME) ||
+	    (evs[*pos].delta.tv_nsec > MAX_START_TIME))
 		goto err;
 
-	/*
-	 * FIXME: need to implement the repeat sequence
-	 */
-
 	count = 0;
 	for ((*pos)++; *pos < len; (*pos)++) {
 		int bit;
-
-		if ((evs[*pos].delta.tv_nsec < MIN_PULSE_TIME) |
-		    (evs[*pos].delta.tv_nsec > MAX_PULSE_TIME) |
-		    (evs[*pos].type != IR_PULSE))
-			goto err;
-
-		if (++*pos >= len)
-			goto err;
-		if (evs[*pos].type != IR_SPACE)
-			goto err;
-
 		if ((evs[*pos].delta.tv_nsec > MIN_BIT1_TIME) &&
 		    (evs[*pos].delta.tv_nsec < MAX_BIT1_TIME))
 			bit = 1;
@@ -107,6 +147,7 @@ static int __ir_nec_decode(struct input_dev *input_dev,
 		if (++count == 32)
 			break;
 	}
+	*pos++;
 
 	/*
 	 * Fixme: may need to accept Extended NEC protocol?
@@ -119,12 +160,15 @@ static int __ir_nec_decode(struct input_dev *input_dev,
 
 	IR_dprintk(1, "NEC scancode 0x%04x\n", ircode);
 	ir_keydown(input_dev, ircode);
-	ir_keyup(input_dev);
+	mod_timer(&ir->raw->timer_keyup,
+		  jiffies + msecs_to_jiffies(REPEAT_TIME));
 
-	return ircode;
+	return 1;
 err:
-	IR_dprintk(1, "NEC decoded failed at bit %d while decoding %luus time\n",
-		   count, (evs[*pos].delta.tv_nsec + 500) / 1000);
+	IR_dprintk(1, "NEC decoded failed at bit %d (%s) while decoding %luus time\n",
+		   count,
+		   (evs[*pos].type & IR_SPACE) ? "space" : "pulse",
+		   (evs[*pos].delta.tv_nsec + 500) / 1000);
 
 	return -EINVAL;
 }
@@ -145,7 +189,7 @@ int ir_nec_decode(struct input_dev *input_dev,
 	int rc = 0;
 
 	while (pos < len) {
-		if (__ir_nec_decode(input_dev, evs, len, &pos) >= 0)
+		if (__ir_nec_decode(input_dev, evs, len, &pos) > 0)
 			rc++;
 	}
 
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 9c71ac8..0ae5543 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -17,6 +17,13 @@
 /* Define the max number of bit transitions per IR keycode */
 #define MAX_IR_EVENT_SIZE	256
 
+static void ir_keyup_timer(unsigned long data)
+{
+	struct input_dev *input_dev = (struct input_dev *)data;
+
+	ir_keyup(input_dev);
+}
+
 int ir_raw_event_register(struct input_dev *input_dev)
 {
 	struct ir_input_dev *ir = input_get_drvdata(input_dev);
@@ -27,6 +34,11 @@ int ir_raw_event_register(struct input_dev *input_dev)
 	size = sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE * 2;
 	size = roundup_pow_of_two(size);
 
+	init_timer(&ir->raw->timer_keyup);
+	ir->raw->timer_keyup.function = ir_keyup_timer;
+	ir->raw->timer_keyup.data = (unsigned long)input_dev;
+	set_bit(EV_REP, input_dev->evbit);
+
 	rc = kfifo_alloc(&ir->raw->kfifo, size, GFP_KERNEL);
 
 	return rc;
@@ -40,6 +52,8 @@ void ir_raw_event_unregister(struct input_dev *input_dev)
 	if (!ir->raw)
 		return;
 
+	del_timer_sync(&ir->raw->timer_keyup);
+
 	kfifo_free(&ir->raw->kfifo);
 	kfree(ir->raw);
 	ir->raw = NULL;
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 740adb3..38f60e4 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -424,8 +424,11 @@ static void saa7134_input_timer(unsigned long data)
 void ir_raw_decode_timer_end(unsigned long data)
 {
 	struct saa7134_dev *dev = (struct saa7134_dev *)data;
+	struct card_ir *ir = dev->remote;
 
 	ir_raw_event_handle(dev->remote->dev);
+
+	ir->active = 0;
 }
 
 void saa7134_ir_start(struct saa7134_dev *dev, struct card_ir *ir)
@@ -461,6 +464,7 @@ void saa7134_ir_start(struct saa7134_dev *dev, struct card_ir *ir)
 		init_timer(&ir->timer_end);
 		ir->timer_end.function = ir_raw_decode_timer_end;
 		ir->timer_end.data = (unsigned long)dev;
+		ir->active = 0;
 	}
 }
 
@@ -476,8 +480,10 @@ void saa7134_ir_stop(struct saa7134_dev *dev)
 		del_timer_sync(&ir->timer_end);
 	else if (ir->nec_gpio)
 		tasklet_kill(&ir->tlet);
-	else if (ir->raw_decode)
+	else if (ir->raw_decode) {
 		del_timer_sync(&ir->timer_end);
+		ir->active = 0;
+	}
 
 	ir->running = 0;
 }
@@ -950,39 +956,24 @@ static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 	unsigned long 	timeout;
 	int count, pulse, oldpulse;
 
-	/* Disable IR IRQ line */
-	saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18);
-
 	/* Generate initial event */
 	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
 	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
 	pulse = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & ir->mask_keydown;
 	ir_raw_event_store(dev->remote->dev, pulse? IR_PULSE : IR_SPACE);
 
-#if 1
-	/* Wait up to 10 ms for event change */
-	oldpulse = pulse;
-	for (count = 0; count < 1000; count++)  {
-		udelay(10);
-		/* rising SAA7134_GPIO_GPRESCAN reads the status */
-		saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
-		saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
-		pulse = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2)
-			& ir->mask_keydown;
-		if (pulse != oldpulse)
-			break;
+
+	/*
+	 * Wait 15 ms from the start of the first IR event before processing
+	 * the event. This time is enough for NEC protocol. May need adjustments
+	 * to work with other protocols.
+	 */
+	if (!ir->active) {
+		timeout = jiffies + jiffies_to_msecs(15);
+		mod_timer(&ir->timer_end, timeout);
+		ir->active = 1;
 	}
 
-	/* Store final event */
-	ir_raw_event_store(dev->remote->dev, pulse? IR_PULSE : IR_SPACE);
-#endif
-	/* Wait 15 ms before deciding to do something else */
-	timeout = jiffies + jiffies_to_msecs(15);
-	mod_timer(&ir->timer_end, timeout);
-
-	/* Enable IR IRQ line */
-	saa_setl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18);
-
 	return 1;
 }
 
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 9e03528..8d8ed7e 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -18,6 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/kfifo.h>
 #include <linux/time.h>
+#include <linux/timer.h>
 
 extern int ir_core_debug;
 #define IR_dprintk(level, fmt, arg...)	if (ir_core_debug >= level) \
@@ -63,6 +64,7 @@ struct ir_raw_event {
 struct ir_raw_event_ctrl {
 	struct kfifo			kfifo;		/* fifo for the pulse/space events */
 	struct timespec			last_event;	/* when last event occurred */
+	struct timer_list		timer_keyup;	/* timer for key release */
 };
 
 struct ir_input_dev {
-- 
1.6.6.1


