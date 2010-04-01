Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758731Ab0DAR6P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 13:58:15 -0400
Date: Thu, 1 Apr 2010 14:56:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 04/15] V4L/DVB: ir-core: Add logic to decode IR protocols at
 the IR core
Message-ID: <20100401145632.7b1b98d5@pedra>
In-Reply-To: <cover.1270142346.git.mchehab@redhat.com>
References: <cover.1270142346.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds a method to pass IR raw pulse/code events into ir-core. This is
needed in order to support LIRC. It also helps to move common code
from the drivers into the core.

In order to allow testing, it implements a simple NEC protocol decoder
at ir-nec-decoder.c file. The logic is about the same used at saa7134
driver that handles Avermedia M135A and Encore FM53 boards.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 create mode 100644 drivers/media/IR/ir-nec-decoder.c
 create mode 100644 drivers/media/IR/ir-raw-event.c

diff --git a/drivers/media/IR/Makefile b/drivers/media/IR/Makefile
index 171890e..18794c7 100644
--- a/drivers/media/IR/Makefile
+++ b/drivers/media/IR/Makefile
@@ -1,5 +1,5 @@
 ir-common-objs  := ir-functions.o ir-keymaps.o
-ir-core-objs	:= ir-keytable.o ir-sysfs.o
+ir-core-objs	:= ir-keytable.o ir-sysfs.o ir-raw-event.o ir-nec-decoder.o
 
 obj-$(CONFIG_IR_CORE) += ir-core.o
 obj-$(CONFIG_VIDEO_IR) += ir-common.o
diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
new file mode 100644
index 0000000..16360eb
--- /dev/null
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -0,0 +1,131 @@
+/* ir-raw-event.c - handle IR Pulse/Space event
+ *
+ * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+#include <media/ir-core.h>
+
+/* Start time: 4.5 ms  */
+#define MIN_START_TIME	3900000
+#define MAX_START_TIME	5100000
+
+/* Pulse time: 560 us  */
+#define MIN_PULSE_TIME	460000
+#define MAX_PULSE_TIME	660000
+
+/* Bit 1 space time: 2.25ms-560 us */
+#define MIN_BIT1_TIME	1490000
+#define MAX_BIT1_TIME	1890000
+
+/* Bit 0 space time: 1.12ms-560 us */
+#define MIN_BIT0_TIME	360000
+#define MAX_BIT0_TIME	760000
+
+
+/** Decode NEC pulsecode. This code can take up to 76.5 ms to run.
+	Unfortunately, using IRQ to decode pulse didn't work, since it uses
+	a pulse train of 38KHz. This means one pulse on each 52 us
+*/
+
+int ir_nec_decode(struct input_dev *input_dev,
+		  struct ir_raw_event *evs,
+		  int len)
+{
+	int i, count = -1;
+	int ircode = 0, not_code = 0;
+#if 0
+	/* Needed only after porting the event code to the decoder */
+	struct ir_input_dev *ir = input_get_drvdata(input_dev);
+#endif
+
+	/* Be sure that the first event is an start one and is a pulse */
+	for (i = 0; i < len; i++) {
+		if (evs[i].type & (IR_START_EVENT | IR_PULSE))
+			break;
+	}
+	i++;	/* First event doesn't contain data */
+
+	if (i >= len)
+		return 0;
+
+	/* First space should have 4.5 ms otherwise is not NEC protocol */
+	if ((evs[i].delta.tv_nsec < MIN_START_TIME) |
+	    (evs[i].delta.tv_nsec > MAX_START_TIME) |
+	    (evs[i].type != IR_SPACE))
+		goto err;
+
+	/*
+	 * FIXME: need to implement the repeat sequence
+	 */
+
+	count = 0;
+	for (i++; i < len; i++) {
+		int bit;
+
+		if ((evs[i].delta.tv_nsec < MIN_PULSE_TIME) |
+		    (evs[i].delta.tv_nsec > MAX_PULSE_TIME) |
+		    (evs[i].type != IR_PULSE))
+			goto err;
+
+		if (++i >= len)
+			goto err;
+		if (evs[i].type != IR_SPACE)
+			goto err;
+
+		if ((evs[i].delta.tv_nsec > MIN_BIT1_TIME) &&
+		    (evs[i].delta.tv_nsec < MAX_BIT1_TIME))
+			bit = 1;
+		else if ((evs[i].delta.tv_nsec > MIN_BIT0_TIME) &&
+			 (evs[i].delta.tv_nsec < MAX_BIT0_TIME))
+			bit = 0;
+		else
+			goto err;
+
+		if (bit) {
+			int shift = count;
+			/* Address first, then command */
+			if (shift < 8) {
+				shift += 8;
+				ircode |= 1 << shift;
+			} else if (shift < 16) {
+				not_code |= 1 << shift;
+			} else if (shift < 24) {
+				shift -= 16;
+				ircode |= 1 << shift;
+			} else {
+				shift -= 24;
+				not_code |= 1 << shift;
+			}
+		}
+		if (++count == 32)
+			break;
+	}
+
+	/*
+	 * Fixme: may need to accept Extended NEC protocol?
+	 */
+	if ((ircode & ~not_code) != ircode) {
+		IR_dprintk(1, "NEC checksum error: code 0x%04x, not-code 0x%04x\n",
+			   ircode, not_code);
+		return -EINVAL;
+	}
+
+	IR_dprintk(1, "NEC scancode 0x%04x\n", ircode);
+
+	return ircode;
+err:
+	IR_dprintk(1, "NEC decoded failed at bit %d while decoding %luus time\n",
+		   count, (evs[i].delta.tv_nsec + 500) / 1000);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(ir_nec_decode);
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
new file mode 100644
index 0000000..9c71ac8
--- /dev/null
+++ b/drivers/media/IR/ir-raw-event.c
@@ -0,0 +1,117 @@
+/* ir-raw-event.c - handle IR Pulse/Space event
+ *
+ * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+#include <media/ir-core.h>
+
+/* Define the max number of bit transitions per IR keycode */
+#define MAX_IR_EVENT_SIZE	256
+
+int ir_raw_event_register(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir = input_get_drvdata(input_dev);
+	int rc, size;
+
+	ir->raw = kzalloc(sizeof(*ir->raw), GFP_KERNEL);
+
+	size = sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE * 2;
+	size = roundup_pow_of_two(size);
+
+	rc = kfifo_alloc(&ir->raw->kfifo, size, GFP_KERNEL);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_register);
+
+void ir_raw_event_unregister(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir = input_get_drvdata(input_dev);
+
+	if (!ir->raw)
+		return;
+
+	kfifo_free(&ir->raw->kfifo);
+	kfree(ir->raw);
+	ir->raw = NULL;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_unregister);
+
+int ir_raw_event_store(struct input_dev *input_dev, enum raw_event_type type)
+{
+	struct ir_input_dev	*ir = input_get_drvdata(input_dev);
+	struct timespec		ts;
+	struct ir_raw_event	event;
+	int			rc;
+
+	if (!ir->raw)
+		return -EINVAL;
+
+	event.type = type;
+	event.delta.tv_sec = 0;
+	event.delta.tv_nsec = 0;
+
+	ktime_get_ts(&ts);
+
+	if (timespec_equal(&ir->raw->last_event, &event.delta))
+		event.type |= IR_START_EVENT;
+	else
+		event.delta = timespec_sub(ts, ir->raw->last_event);
+
+	memcpy(&ir->raw->last_event, &ts, sizeof(ts));
+
+	if (event.delta.tv_sec) {
+		event.type |= IR_START_EVENT;
+		event.delta.tv_sec = 0;
+		event.delta.tv_nsec = 0;
+	}
+
+	kfifo_in(&ir->raw->kfifo, &event, sizeof(event));
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_store);
+
+int ir_raw_event_handle(struct input_dev *input_dev)
+{
+	struct ir_input_dev		*ir = input_get_drvdata(input_dev);
+	int				rc;
+	struct ir_raw_event		*evs;
+	int 				len, i;
+
+	/*
+	 * Store the events into a temporary buffer. This allows calling more than
+	 * one decoder to deal with the received data
+	 */
+	len = kfifo_len(&ir->raw->kfifo) / sizeof(*evs);
+	if (!len)
+		return 0;
+	evs = kmalloc(len * sizeof(*evs), GFP_ATOMIC);
+
+	for (i = 0; i < len; i++) {
+		rc = kfifo_out(&ir->raw->kfifo, &evs[i], sizeof(*evs));
+		if (rc != sizeof(*evs)) {
+			IR_dprintk(1, "overflow error: received %d instead of %zd\n",
+				   rc, sizeof(*evs));
+			return -EINVAL;
+		}
+		IR_dprintk(2, "event type %d, time before event: %07luus\n",
+			evs[i].type, (evs[i].delta.tv_nsec + 500) / 1000);
+	}
+
+	rc = ir_nec_decode(input_dev, evs, len);
+
+	kfree(evs);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_handle);
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 8187928..7382995 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -67,6 +67,7 @@ MODULE_PARM_DESC(disable_other_ir, "disable full codes of "
 /* Helper functions for RC5 and NEC decoding at GPIO16 or GPIO18 */
 static int saa7134_rc5_irq(struct saa7134_dev *dev);
 static int saa7134_nec_irq(struct saa7134_dev *dev);
+static int saa7134_raw_decode_irq(struct saa7134_dev *dev);
 static void nec_task(unsigned long data);
 static void saa7134_nec_timer(unsigned long data);
 
@@ -402,10 +403,12 @@ void saa7134_input_irq(struct saa7134_dev *dev)
 
 	if (ir->nec_gpio) {
 		saa7134_nec_irq(dev);
-	} else if (!ir->polling && !ir->rc5_gpio) {
+	} else if (!ir->polling && !ir->rc5_gpio && !ir->raw_decode) {
 		build_key(dev);
 	} else if (ir->rc5_gpio) {
 		saa7134_rc5_irq(dev);
+	} else if (ir->raw_decode) {
+		saa7134_raw_decode_irq(dev);
 	}
 }
 
@@ -418,6 +421,23 @@ static void saa7134_input_timer(unsigned long data)
 	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
 }
 
+void ir_raw_decode_timer_end(unsigned long data)
+{
+	struct saa7134_dev *dev = (struct saa7134_dev *)data;
+	struct card_ir *ir = dev->remote;
+	int rc;
+
+	/*
+	 * FIXME: the IR key handling code should be called by the decoder,
+	 * after implementing the repeat mode
+	 */
+	rc = ir_raw_event_handle(dev->remote->dev);
+	if (rc >= 0) {
+		ir_input_keydown(ir->dev, &ir->ir, rc);
+		ir_input_nokey(ir->dev, &ir->ir);
+	}
+}
+
 void saa7134_ir_start(struct saa7134_dev *dev, struct card_ir *ir)
 {
 	if (ir->running)
@@ -446,6 +466,11 @@ void saa7134_ir_start(struct saa7134_dev *dev, struct card_ir *ir)
 		setup_timer(&ir->timer_keyup, saa7134_nec_timer,
 			    (unsigned long)dev);
 		tasklet_init(&ir->tlet, nec_task, (unsigned long)dev);
+	} else if (ir->raw_decode) {
+		/* set timer_end for code completion */
+		init_timer(&ir->timer_end);
+		ir->timer_end.function = ir_raw_decode_timer_end;
+		ir->timer_end.data = (unsigned long)dev;
 	}
 }
 
@@ -461,6 +486,9 @@ void saa7134_ir_stop(struct saa7134_dev *dev)
 		del_timer_sync(&ir->timer_end);
 	else if (ir->nec_gpio)
 		tasklet_kill(&ir->tlet);
+	else if (ir->raw_decode)
+		del_timer_sync(&ir->timer_end);
+
 	ir->running = 0;
 }
 
@@ -508,6 +536,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	int polling      = 0;
 	int rc5_gpio	 = 0;
 	int nec_gpio	 = 0;
+	int raw_decode   = 0;
 	u64 ir_type = IR_TYPE_OTHER;
 	int err;
 
@@ -573,7 +602,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		ir_codes     = &ir_codes_avermedia_m135a_rm_jx_table;
 		mask_keydown = 0x0040000;
 		mask_keycode = 0xffff;
-		nec_gpio     = 1;
+		raw_decode   = 1;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_777:
 	case SAA7134_BOARD_AVERMEDIA_A16AR:
@@ -754,6 +783,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	ir->polling      = polling;
 	ir->rc5_gpio	 = rc5_gpio;
 	ir->nec_gpio	 = nec_gpio;
+	ir->raw_decode	 = raw_decode;
 
 	/* init input device */
 	snprintf(ir->name, sizeof(ir->name), "saa7134 IR (%s)",
@@ -761,7 +791,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0",
 		 pci_name(dev->pci));
 
-	if (ir_codes->ir_type != IR_TYPE_OTHER) {
+	if (ir_codes->ir_type != IR_TYPE_OTHER && !raw_decode) {
 		ir->props.allowed_protos = IR_TYPE_RC5 | IR_TYPE_NEC;
 		ir->props.priv = dev;
 		ir->props.change_protocol = saa7134_ir_change_protocol;
@@ -789,6 +819,11 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	err = ir_input_register(ir->dev, ir_codes, &ir->props, MODULE_NAME);
 	if (err)
 		goto err_out_stop;
+	if (ir_codes->ir_type != IR_TYPE_OTHER) {
+		err = ir_raw_event_register(ir->dev);
+		if (err)
+			goto err_out_stop;
+	}
 
 	saa7134_ir_start(dev, ir);
 
@@ -812,6 +847,7 @@ void saa7134_input_fini(struct saa7134_dev *dev)
 		return;
 
 	saa7134_ir_stop(dev);
+	ir_raw_event_unregister(dev->remote->dev);
 	ir_input_unregister(dev->remote->dev);
 	kfree(dev->remote);
 	dev->remote = NULL;
@@ -918,6 +954,48 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 	i2c_new_device(&dev->i2c_adap, &info);
 }
 
+static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
+{
+	struct card_ir	*ir = dev->remote;
+	unsigned long 	timeout;
+	int count, pulse, oldpulse;
+
+	/* Disable IR IRQ line */
+	saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18);
+
+	/* Generate initial event */
+	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+	pulse = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & ir->mask_keydown;
+	ir_raw_event_store(dev->remote->dev, pulse? IR_PULSE : IR_SPACE);
+
+#if 1
+	/* Wait up to 10 ms for event change */
+	oldpulse = pulse;
+	for (count = 0; count < 1000; count++)  {
+		udelay(10);
+		/* rising SAA7134_GPIO_GPRESCAN reads the status */
+		saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+		saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+		pulse = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2)
+			& ir->mask_keydown;
+		if (pulse != oldpulse)
+			break;
+	}
+
+	/* Store final event */
+	ir_raw_event_store(dev->remote->dev, pulse? IR_PULSE : IR_SPACE);
+#endif
+	/* Wait 15 ms before deciding to do something else */
+	timeout = jiffies + jiffies_to_msecs(15);
+	mod_timer(&ir->timer_end, timeout);
+
+	/* Enable IR IRQ line */
+	saa_setl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18);
+
+	return 1;
+}
+
 static int saa7134_rc5_irq(struct saa7134_dev *dev)
 {
 	struct card_ir *ir = dev->remote;
@@ -960,7 +1038,6 @@ static int saa7134_rc5_irq(struct saa7134_dev *dev)
 	return 1;
 }
 
-
 /* On NEC protocol, One has 2.25 ms, and zero has 1.125 ms
    The first pulse (start) has 9 + 4.5 ms
  */
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index 41469b7..87f2ec7 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -82,6 +82,9 @@ struct card_ir {
 	/* NEC decoding */
 	u32			nec_gpio;
 	struct tasklet_struct   tlet;
+
+	/* IR core raw decoding */
+	u32			raw_decode;
 };
 
 /* Routines from ir-functions.c */
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 1eae72d..369969d 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -16,6 +16,8 @@
 
 #include <linux/input.h>
 #include <linux/spinlock.h>
+#include <linux/kfifo.h>
+#include <linux/time.h>
 
 extern int ir_core_debug;
 #define IR_dprintk(level, fmt, arg...)	if (ir_core_debug >= level) \
@@ -27,6 +29,13 @@ extern int ir_core_debug;
 #define IR_TYPE_NEC	(1  << 2)
 #define IR_TYPE_OTHER	(((u64)1) << 63l)
 
+enum raw_event_type {
+	IR_SPACE	= (1 << 0),
+	IR_PULSE	= (1 << 1),
+	IR_START_EVENT	= (1 << 2),
+	IR_STOP_EVENT	= (1 << 3),
+};
+
 struct ir_scancode {
 	u16	scancode;
 	u32	keycode;
@@ -46,6 +55,15 @@ struct ir_dev_props {
 	int (*change_protocol)(void *priv, u64 ir_type);
 };
 
+struct ir_raw_event {
+	struct timespec		delta;	/* Time spent before event */
+	enum raw_event_type	type;	/* event type */
+};
+
+struct ir_raw_event_ctrl {
+	struct kfifo			kfifo;		/* fifo for the pulse/space events */
+	struct timespec			last_event;	/* when last event occurred */
+};
 
 struct ir_input_dev {
 	struct device			dev;		/* device */
@@ -53,7 +71,9 @@ struct ir_input_dev {
 	struct ir_scancode_table	rc_tab;		/* scan/key table */
 	unsigned long			devno;		/* device number */
 	const struct ir_dev_props	*props;		/* Device properties */
+	struct ir_raw_event_ctrl	*raw;		/* for raw pulse/space events */
 };
+
 #define to_ir_input_dev(_attr) container_of(_attr, struct ir_input_dev, attr)
 
 /* Routines from ir-keytable.c */
@@ -72,4 +92,16 @@ void ir_input_unregister(struct input_dev *input_dev);
 int ir_register_class(struct input_dev *input_dev);
 void ir_unregister_class(struct input_dev *input_dev);
 
+/* Routines from ir-raw-event.c */
+int ir_raw_event_register(struct input_dev *input_dev);
+void ir_raw_event_unregister(struct input_dev *input_dev);
+int ir_raw_event_store(struct input_dev *input_dev, enum raw_event_type type);
+int ir_raw_event_handle(struct input_dev *input_dev);
+
+/* from ir-nec-decoder.c */
+int ir_nec_decode(struct input_dev *input_dev,
+		  struct ir_raw_event *evs,
+		  int len);
+
+
 #endif
-- 
1.6.6.1


