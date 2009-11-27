Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:59189 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZK0BeW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 20:34:22 -0500
Subject: [IR-RFC PATCH v4 2/6] Core IR module
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org
From: Jon Smirl <jonsmirl@gmail.com>
Date: Thu, 26 Nov 2009 20:34:23 -0500
Message-ID: <20091127013423.7671.36546.stgit@terra>
In-Reply-To: <20091127013217.7671.32355.stgit@terra>
References: <20091127013217.7671.32355.stgit@terra>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes to core input subsystem to allow send and receive of IR messages. Encode and decode state machines are provided for common IR porotocols such as Sony, JVC, NEC, Philips, etc.

Received IR messages generate event in the input queue.
IR messages are sent using an input IOCTL.
---
 drivers/input/Kconfig      |    2 
 drivers/input/Makefile     |    1 
 drivers/input/input.c      |    3 
 drivers/input/ir/Kconfig   |   15 +
 drivers/input/ir/Makefile  |    8 
 drivers/input/ir/ir-core.c |  735 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/input/ir/ir.h      |   63 ++++
 include/linux/input.h      |    5 
 8 files changed, 830 insertions(+), 2 deletions(-)
 create mode 100644 drivers/input/ir/Kconfig
 create mode 100644 drivers/input/ir/Makefile
 create mode 100644 drivers/input/ir/ir-core.c
 create mode 100644 drivers/input/ir/ir.h

diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index 816639c..a1e35ee 100644
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -172,6 +172,8 @@ source "drivers/input/touchscreen/Kconfig"
 
 source "drivers/input/misc/Kconfig"
 
+source "drivers/input/ir/Kconfig"
+
 endif
 
 menu "Hardware I/O ports"
diff --git a/drivers/input/Makefile b/drivers/input/Makefile
index 99e2b5e..fec8972 100644
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_INPUT_JOYSTICK)	+= joystick/
 obj-$(CONFIG_INPUT_TABLET)	+= tablet/
 obj-$(CONFIG_INPUT_TOUCHSCREEN)	+= touchscreen/
 obj-$(CONFIG_INPUT_MISC)	+= misc/
+obj-$(CONFIG_INPUT_IR)		+= ir/
 
 obj-$(CONFIG_INPUT_APMPOWER)	+= apm-power.o
 
diff --git a/drivers/input/input.c b/drivers/input/input.c
index a531cf5..2843b84 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -23,6 +23,8 @@
 #include <linux/rcupdate.h>
 #include <linux/smp_lock.h>
 
+#include "ir/ir.h"
+
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@suse.cz>");
 MODULE_DESCRIPTION("Input core");
 MODULE_LICENSE("GPL");
@@ -1167,6 +1169,7 @@ static void input_dev_release(struct device *device)
 	struct input_dev *dev = to_input_dev(device);
 
 	input_ff_destroy(dev);
+	input_ir_destroy(dev);
 	kfree(dev);
 
 	module_put(THIS_MODULE);
diff --git a/drivers/input/ir/Kconfig b/drivers/input/ir/Kconfig
new file mode 100644
index 0000000..a6f3f25
--- /dev/null
+++ b/drivers/input/ir/Kconfig
@@ -0,0 +1,15 @@
+#
+# LIRC driver(s) configuration
+#
+menuconfig INPUT_IR
+	select CONFIGFS_FS
+	tristate "Infrared Remote (IR) receiver/transmitter drivers"
+	default n
+	help
+	  Say Y here, and all supported Infrared Remote Control IR
+	  receiver and transmitter drivers will be displayed. The receiver drivers
+	  allow control of your Linux system via remote control.
+
+if INPUT_IR
+
+endif
diff --git a/drivers/input/ir/Makefile b/drivers/input/ir/Makefile
new file mode 100644
index 0000000..6acb665
--- /dev/null
+++ b/drivers/input/ir/Makefile
@@ -0,0 +1,8 @@
+# Makefile for the ir drivers.
+#
+
+# Each configuration option enables a list of files.
+
+obj-$(CONFIG_INPUT_IR)		+= ir.o
+ir-objs := ir-core.o
+
diff --git a/drivers/input/ir/ir-core.c b/drivers/input/ir/ir-core.c
new file mode 100644
index 0000000..85adfcb
--- /dev/null
+++ b/drivers/input/ir/ir-core.c
@@ -0,0 +1,735 @@
+/*
+ * Core routines for IR support
+ *
+ * Copyright (C) 2008 Jon Smirl <jonsmirl@gmail.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/input.h>
+
+#include "ir.h"
+
+void input_ir_translate(struct input_dev *dev, int protocol, int device, int command)
+{
+	/* generate the IR format event */
+	input_report_ir(dev, IR_PROTOCOL, protocol);
+	input_report_ir(dev, IR_DEVICE, device);
+	input_report_ir(dev, IR_COMMAND, command);
+	input_sync(dev);
+}
+
+static int encode_sony(struct ir_device *ir, struct ir_command *command)
+{
+	/* Sony SIRC IR code */
+	/* http://www.sbprojects.com/knowledge/ir/sirc.htm */
+	int i, bit, dev, cmd, total;
+
+	ir->send.count = 0;
+	switch (command->protocol) {
+	case IR_PROTOCOL_SONY_20:
+		dev = 10; cmd = 10; break;
+	case IR_PROTOCOL_SONY_15:
+		dev = 8; cmd = 7; break;
+	default:
+	case IR_PROTOCOL_SONY_12:
+		dev = 5; cmd = 7; break;
+	}
+	ir->send.buffer[ir->send.count++] = 2400;
+	ir->send.buffer[ir->send.count++] = 600;
+
+	for (i = 0; i < cmd; i++) {
+		bit = command->command & 1;
+		command->command >>= 1;
+		ir->send.buffer[ir->send.count++] = (bit ? 1200 : 600);
+		ir->send.buffer[ir->send.count++] = 600;
+	}
+	for (i = 0; i < dev; i++) {
+		bit = command->device & 1;
+		command->device >>= 1;
+		ir->send.buffer[ir->send.count++] = (bit ? 1200 : 600);
+		ir->send.buffer[ir->send.count++] = 600;
+	}
+	total = 0;
+	for (i = 0; i < ir->send.count; i++)
+		total += ir->send.buffer[i];
+	ir->send.buffer[ir->send.count++] = 45000 - total;
+
+	memcpy(&ir->send.buffer[ir->send.count], &ir->send.buffer[0], ir->send.count * sizeof ir->send.buffer[0]);
+	ir->send.count += ir->send.count;
+	memcpy(&ir->send.buffer[ir->send.count], &ir->send.buffer[0], ir->send.count * sizeof ir->send.buffer[0]);
+	ir->send.count += ir->send.count;
+
+	return 0;
+}
+
+static int decode_sony(struct input_dev *dev, struct ir_protocol *sony, unsigned int d, unsigned int bit)
+{
+	/* Sony SIRC IR code */
+	/* http://www.sbprojects.com/knowledge/ir/sirc.htm */
+	/* based on a 600us cadence */
+	int ret = 0, delta = d;
+	int protocol, device, command;
+
+	delta = (delta + 300) / 600;
+
+	if ((bit == 0) && (delta > 22)) {
+		PDEBUG("SIRC state 1\n");
+		if ((sony->state == 26) || (sony->state == 32) || (sony->state == 42)) {
+			if (sony->good && (sony->good == sony->code)) {
+
+				protocol = (sony->state == 26) ? IR_PROTOCOL_SONY_12 :
+					(sony->state == 32) ? IR_PROTOCOL_SONY_15 : IR_PROTOCOL_SONY_20;
+
+				if (sony->state == 26) {
+					device = sony->code & 0x1F;
+					command = sony->code >> 5;
+				} else {
+					device = sony->code & 0xFF;
+					command = sony->code >> 8;
+				}
+				input_ir_translate(dev, protocol, device, command);
+				sony->good = 0;
+				ret = 1;
+			} else {
+				PDEBUG("SIRC - Saving %d bit %05x\n", (sony->state - 2) / 2, sony->code);
+				sony->good = sony->code;
+			}
+		}
+		sony->state = 1;
+		sony->code = 0;
+		return ret;
+	}
+	if ((sony->state == 1) && (bit == 1) && (delta == 4)) {
+		sony->state = 2;
+		PDEBUG("SIRC state 2\n");
+		return 0;
+	}
+	if ((sony->state == 2) && (bit == 0) && (delta == 1)) {
+		sony->state = 3;
+		PDEBUG("SIRC state 3\n");
+		return 0;
+	}
+	if ((sony->state >= 3) && (sony->state & 1) && (bit == 1) && ((delta == 1) || (delta == 2))) {
+		sony->state++;
+		sony->code |= ((delta - 1) << ((sony->state - 4) / 2));
+		PDEBUG("SIRC state %d bit %d\n", sony->state, delta - 1);
+		return 0;
+	}
+	if ((sony->state >= 3) && !(sony->state & 1) && (bit == 0) && (delta == 1)) {
+		sony->state++;
+		PDEBUG("SIRC state %d\n", sony-> state);
+		return 0;
+	}
+	sony->state = 0;
+	return 0;
+}
+
+
+static int encode_jvc(struct ir_device *ir, struct ir_command *command)
+{
+	/* JVC IR code */
+	/* http://www.sbprojects.com/knowledge/ir/jvc.htm */
+	int i, bit, total;
+
+	ir->send.count = 0;
+
+	ir->send.buffer[ir->send.count++] = 8400;
+	ir->send.buffer[ir->send.count++] = 4200;
+
+	for (i = 0; i < 8; i++) {
+		bit = command->device & 1;
+		command->device >>= 1;
+		ir->send.buffer[ir->send.count++] = 525;
+		ir->send.buffer[ir->send.count++] = (bit ? 1575 : 525);
+	}
+	for (i = 0; i < 8; i++) {
+		bit = command->command & 1;
+		command->command >>= 1;
+		ir->send.buffer[ir->send.count++] = 525;
+		ir->send.buffer[ir->send.count++] = (bit ? 1575 : 525);
+	}
+	ir->send.buffer[ir->send.count++] = 525;
+
+	total = 0;
+	for (i = 0; i < ir->send.count; i++)
+		total += ir->send.buffer[i];
+	ir->send.buffer[ir->send.count] = 55000 - total;
+
+	return 0;
+}
+
+static int decode_jvc(struct input_dev *dev, struct ir_protocol *jvc, unsigned int d, unsigned int bit)
+{
+	/* JVC IR code */
+	/* http://www.sbprojects.com/knowledge/ir/jvc.htm */
+	/* based on a 525us cadence */
+	int ret = 0, delta = d;
+
+	delta = (delta + 263) / 525;
+
+	if ((bit == 0) && (delta > 22)) {
+		PDEBUG("JVC state 1\n");
+		jvc->state = 1;
+		jvc->code = 0;
+		return ret;
+	}
+	if ((jvc->state == 1) && (bit == 1) && (delta == 16)) {
+		jvc->state = 2;
+		PDEBUG("JVC state 2\n");
+		return 0;
+	}
+	if ((jvc->state == 2) && (bit == 0) && (delta == 8)) {
+		jvc->state = 3;
+		PDEBUG("JVC state 3\n");
+		return 0;
+	}
+	if ((jvc->state >= 3) && (jvc->state & 1) && (bit == 1) && (delta == 1)) {
+		jvc->state++;
+		PDEBUG("JVC state %d\n", jvc-> state);
+		return 0;
+	}
+	if ((jvc->state >= 3) && !(jvc->state & 1) && (bit == 0) && ((delta == 1) || (delta == 3))) {
+		if (delta == 3)
+			jvc->code |= 1 << ((jvc->state - 4) / 2);
+		jvc->state++;
+		PDEBUG("JVC state %d bit %d\n", jvc->state, delta - 1);
+		if (jvc->state == 34) {
+			jvc->state = 3;
+			if (jvc->good && (jvc->good == jvc->code)) {
+				input_ir_translate(dev, IR_PROTOCOL_JVC, jvc->code >> 8, jvc->code & 0xFF);
+				jvc->good = 0;
+				ret = 1;
+			} else {
+				PDEBUG("JVC - Saving 16 bit %05x\n", jvc->code);
+				jvc->good = jvc->code;
+			}
+			jvc->code = 0;
+		}
+		return 0;
+	}
+	jvc->state = 0;
+	return 0;
+}
+
+
+static int encode_nec(struct ir_device *ir, struct ir_command *command)
+{
+	/* NEC IR code */
+	/* http://www.sbprojects.com/knowledge/ir/nec.htm */
+	int i, bit, total;
+
+	ir->send.count = 0;
+
+	ir->send.buffer[ir->send.count++] = 9000;
+	ir->send.buffer[ir->send.count++] = 4500;
+
+	for (i = 0; i < 8; i++) {
+		bit = command->device & 1;
+		command->device >>= 1;
+		ir->send.buffer[ir->send.count++] = 563;
+		ir->send.buffer[ir->send.count++] = (bit ? 1687 : 562);
+	}
+	for (i = 0; i < 8; i++) {
+		bit = command->command & 1;
+		command->command >>= 1;
+		ir->send.buffer[ir->send.count++] = 563;
+		ir->send.buffer[ir->send.count++] = (bit ? 1687 : 562);
+	}
+	ir->send.buffer[ir->send.count++] = 562;
+
+	total = 0;
+	for (i = 0; i < ir->send.count; i++)
+		total += ir->send.buffer[i];
+	ir->send.buffer[ir->send.count] = 110000 - total;
+
+	return 0;
+}
+
+static int decode_nec(struct input_dev *dev, struct ir_protocol *nec, unsigned int d, unsigned int bit)
+{
+	/* NEC IR code */
+	/* http://www.sbprojects.com/knowledge/ir/nec.htm */
+	/* based on a 560us cadence */
+	int delta = d;
+
+	delta = (delta + 280) / 560;
+
+	if ((bit == 0) && (delta > 22)) {
+		PDEBUG("nec state 1\n");
+		nec->state = 1;
+		nec->code = 0;
+		return 0;
+	}
+	if ((nec->state == 1) && (bit == 1) && (delta == 16)) {
+		nec->state = 2;
+		PDEBUG("nec state 2\n");
+		return 0;
+	}
+	if ((nec->state == 2) && (bit == 0) && (delta == 8)) {
+		nec->state = 3;
+		PDEBUG("nec state 3\n");
+		return 0;
+	}
+	if ((nec->state >= 3) && (nec->state & 1) && (bit == 1) && (delta == 1)) {
+		nec->state++;
+		PDEBUG("nec state %d\n", nec-> state);
+		if (nec->state == 68) {
+			input_ir_translate(dev, IR_PROTOCOL_NEC, nec->code >> 16, nec->code & 0xFFFF);
+			return 1;
+		}
+		return 0;
+	}
+	if ((nec->state >= 3) && !(nec->state & 1) && (bit == 0) && ((delta == 1) || (delta == 3))) {
+		if (delta == 3)
+			nec->code |= 1 << ((nec->state - 4) / 2);
+		nec->state++;
+		PDEBUG("nec state %d bit %d\n", nec->state, delta - 1);
+		return 0;
+	}
+	nec->state = 0;
+	nec->code = 0;
+	return 0;
+}
+
+
+static int encode_rc5(struct ir_device *ir, struct ir_command *command)
+{
+	/* Philips RC-5 IR code */
+	/* http://www.sbprojects.com/knowledge/ir/rc5.htm */
+	return 0;
+}
+
+static int decode_rc5(struct input_dev *dev, struct ir_protocol *rc5, unsigned int d, unsigned int bit)
+{
+	/* Philips RC-5 IR code */
+	/* http://www.sbprojects.com/knowledge/ir/rc5.htm */
+	/* based on a 889us cadence */
+	int delta = d;
+
+	delta = (delta + 444) / 889;
+
+	return 0;
+}
+
+
+static int encode_rc6(struct ir_device *ir, struct ir_command *command)
+{
+	/* Philips RC-6 IR code */
+	/* http://www.sbprojects.com/knowledge/ir/rc6.htm */
+	int i, bit, last;
+
+	ir->send.count = 0;
+
+	ir->send.buffer[ir->send.count++] = 2666;
+	ir->send.buffer[ir->send.count++] = 889;
+
+	ir->send.buffer[ir->send.count++] = 444;
+	ir->send.buffer[ir->send.count++] = 444;
+
+	last = 1;
+	for (i = 0; i < 8; i++) {
+		bit = command->device & 1;
+		command->device >>= 1;
+
+		if (last != bit)
+			ir->send.buffer[ir->send.count - 1] += 444;
+		else
+			ir->send.buffer[ir->send.count++] = 444;
+		ir->send.buffer[ir->send.count++] = 444;
+		last = bit;
+	}
+	for (i = 0; i < 8; i++) {
+		bit = command->command & 1;
+		command->command >>= 1;
+
+		if (last != bit)
+			ir->send.buffer[ir->send.count - 1] += 444;
+		else
+			ir->send.buffer[ir->send.count++] = 444;
+		ir->send.buffer[ir->send.count++] = 444;
+		last = bit;
+	}
+	ir->send.buffer[ir->send.count] = 2666;
+
+	return 0;
+}
+
+static void decode_rc6_bit(struct input_dev *dev, struct ir_protocol *rc6, unsigned int bit)
+{
+	/* bits come in one at a time */
+	/* when two are collected look for a symbol */
+	/* rc6->bits == 1 is a zero symbol */
+	/* rc6->bits == 2 is a one symbol */
+	rc6->count++;
+	rc6->bits <<= 1;
+	rc6->bits |= bit;
+	if (rc6->count == 2) {
+		if ((rc6->bits == 0) || (rc6->bits == 3)) {
+			rc6->mode = rc6->code;
+			rc6->code = 0;
+		} else {
+			rc6->code <<= 1;
+			if (rc6->bits == 2)
+				rc6->code |= 1;
+		}
+		rc6->count = 0;
+		if (rc6->state == 23) {
+			input_ir_translate(dev, IR_PROTOCOL_PHILIPS_RC6, rc6->code >> 8, rc6->code & 0xFF);
+			rc6->state = 0;
+		} else
+			rc6->state++;
+		PDEBUG("rc6 state %d bit %d\n", rc6->state, rc6->bits == 2);
+		rc6->bits = 0;
+	}
+}
+
+static int decode_rc6(struct input_dev *dev, struct ir_protocol *rc6, unsigned int d, unsigned int bit)
+{
+	/* Philips RC-6 IR code */
+	/* http://www.sbprojects.com/knowledge/ir/rc6.htm */
+	/* based on a 444us cadence */
+
+	int delta = d;
+
+	delta = (delta + 222) / 444;
+
+	if ((bit == 0) && (delta > 19)) {
+		rc6->count = 0;
+		rc6->bits = 0;
+		rc6->state = 1;
+		rc6->code = 0;
+		PDEBUG("rc6 state 1\n");
+		return 0;
+	}
+	if ((rc6->state == 1) && (bit == 1) && (delta == 6)) {
+		rc6->state = 2;
+		PDEBUG("rc6 state 2\n");
+		return 0;
+	}
+	if ((rc6->state == 2) && (bit == 0) && (delta == 2)) {
+		rc6->state = 3;
+		PDEBUG("rc6 state 3\n");
+		return 0;
+	}
+	if (rc6->state >= 3) {
+		if ((delta >= 1) || (delta <= 3)) {
+			while (delta-- >= 1)
+				decode_rc6_bit(dev, rc6, bit);
+			return 0;
+		}
+	}
+	rc6->state = 0;
+	rc6->code = 0;
+	return 0;
+}
+
+static void record_raw(struct input_dev *dev, int sample)
+{
+	int head = dev->ir->raw.head;
+
+	head += 1;
+	if (head > ARRAY_SIZE(dev->ir->raw.buffer))
+		head = 0;
+
+	if (head != dev->ir->raw.tail) {
+		dev->ir->raw.buffer[dev->ir->raw.head] = sample;
+		dev->ir->raw.head = head;
+	}
+}
+
+void input_ir_decode(struct input_dev *dev, int sample)
+{
+	int delta, bit;
+
+	record_raw(dev, sample);
+
+	if (sample < 0) {
+		delta = -sample;
+		bit = 1;
+	} else {
+		delta = sample;
+		bit = 0;
+	}
+	PDEBUG("IR bit %d %d\n", delta, bit);
+
+	decode_sony(dev, &dev->ir->sony, delta, bit);
+	decode_jvc(dev, &dev->ir->jvc, delta, bit);
+	decode_nec(dev, &dev->ir->nec, delta, bit);
+	decode_rc5(dev, &dev->ir->rc5, delta, bit);
+	decode_rc6(dev, &dev->ir->rc6, delta, bit);
+}
+EXPORT_SYMBOL_GPL(input_ir_decode);
+
+static void ir_event(struct work_struct *work)
+{
+	unsigned long flags;
+	unsigned int sample;
+	struct ir_device *ir_dev = container_of(work, struct ir_device, work);
+	struct input_dev *dev = ir_dev->input;
+
+	while (1) {
+		spin_lock_irqsave(dev->ir->queue.lock, flags);
+		if (dev->ir->queue.tail == dev->ir->queue.head) {
+			spin_unlock_irqrestore(dev->ir->queue.lock, flags);
+			break;
+		}
+		sample = dev->ir->queue.samples[dev->ir->queue.tail];
+
+		dev->ir->queue.tail++;
+		if (dev->ir->queue.tail >= MAX_SAMPLES)
+			dev->ir->queue.tail = 0;
+
+		spin_unlock_irqrestore(dev->ir->queue.lock, flags);
+
+		input_ir_decode(dev->ir->input, sample);
+	}
+}
+
+void input_ir_queue(struct input_dev *dev, int sample)
+{
+	unsigned int next;
+
+	spin_lock(dev->ir->queue.lock);
+	dev->ir->queue.samples[dev->ir->queue.head] = sample;
+	next = dev->ir->queue.head + 1;
+	dev->ir->queue.head = (next >= MAX_SAMPLES ? 0 : next);
+	spin_unlock(dev->ir->queue.lock);
+
+	schedule_work(&dev->ir->work);
+}
+EXPORT_SYMBOL_GPL(input_ir_queue);
+
+
+int input_ir_send(struct input_dev *dev, struct ir_command *ir_command, struct file *file)
+{
+	unsigned freq, xmit = 0;
+	int ret;
+
+	mutex_lock(&dev->ir->lock);
+
+	switch (ir_command->protocol) {
+	case IR_PROTOCOL_PHILIPS_RC5:
+		freq = 36000;
+		encode_rc5(dev->ir, ir_command);
+		break;
+	case IR_PROTOCOL_PHILIPS_RC6:
+		freq = 36000;
+		encode_rc6(dev->ir, ir_command);
+		break;
+	case IR_PROTOCOL_PHILIPS_RCMM:
+		freq = 36000;
+		encode_rc5(dev->ir, ir_command);
+		break;
+	case IR_PROTOCOL_JVC:
+		freq = 38000;
+		encode_jvc(dev->ir, ir_command);
+		break;
+	case IR_PROTOCOL_NEC:
+		freq = 38000;
+		encode_nec(dev->ir, ir_command);
+		break;
+	case IR_PROTOCOL_NOKIA:
+	case IR_PROTOCOL_SHARP:
+	case IR_PROTOCOL_PHILIPS_RECS80:
+		freq = 38000;
+		break;
+	case IR_PROTOCOL_SONY_12:
+	case IR_PROTOCOL_SONY_15:
+	case IR_PROTOCOL_SONY_20:
+		encode_sony(dev->ir, ir_command);
+		freq = 40000;
+		break;
+	case IR_PROTOCOL_RCA:
+		freq = 56000;
+		break;
+	case IR_PROTOCOL_ITT:
+		freq = 0;
+		break;
+	default:
+		ret = -ENODEV;
+		goto exit;
+	}
+
+	if (dev->ir && dev->ir->xmit)
+		ret = dev->ir->xmit(dev->ir->private, dev->ir->send.buffer, dev->ir->send.count, freq, xmit);
+	else
+		ret = -ENODEV;
+
+exit:
+	mutex_unlock(&dev->ir->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(input_ir_send);
+
+static ssize_t ir_raw_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct input_dev *input_dev = to_input_dev(dev);
+	unsigned int i, count = 0;
+
+	for (i = input_dev->ir->raw.tail; i != input_dev->ir->raw.head; ) {
+
+		count += snprintf(&buf[count], PAGE_SIZE - 1, "%i\n", input_dev->ir->raw.buffer[i++]);
+		if (i > ARRAY_SIZE(input_dev->ir->raw.buffer))
+			i = 0;
+		if (count >= PAGE_SIZE - 1) {
+			input_dev->ir->raw.tail = i;
+			return PAGE_SIZE - 1;
+		}
+	}
+	input_dev->ir->raw.tail = i;
+	return count;
+}
+
+static ssize_t ir_raw_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf,
+				  size_t count)
+{
+	struct ir_device *ir = to_input_dev(dev)->ir;
+	long delta;
+	int i = count;
+	int first = 0;
+
+	if (!ir->xmit)
+		return count;
+	ir->send.count = 0;
+
+	while (i > 0) {
+		i -= strict_strtoul(&buf[i], i, &delta);
+		while ((buf[i] != '\n') && (i > 0))
+			i--;
+		i--;
+		/* skip leading zeros */
+		if ((delta > 0) && !first)
+			continue;
+
+		ir->send.buffer[ir->send.count++] = abs(delta);
+	}
+
+	ir->xmit(ir->private, ir->send.buffer, ir->send.count, ir->raw.carrier, ir->raw.xmitter);
+
+	return count;
+}
+
+static ssize_t ir_carrier_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct ir_device *ir = to_input_dev(dev)->ir;
+
+	return sprintf(buf, "%i\n", ir->raw.carrier);
+}
+
+static ssize_t ir_carrier_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf,
+				  size_t count)
+{
+	struct ir_device *ir = to_input_dev(dev)->ir;
+
+	ir->raw.carrier = simple_strtoul(buf, NULL, 0);
+	return count;
+}
+
+static ssize_t ir_xmitter_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct ir_device *ir = to_input_dev(dev)->ir;
+
+	return sprintf(buf, "%i\n", ir->raw.xmitter);
+}
+
+static ssize_t ir_xmitter_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf,
+				  size_t count)
+{
+	struct ir_device *ir = to_input_dev(dev)->ir;
+
+	ir->raw.xmitter = simple_strtoul(buf, NULL, 0);
+	return count;
+}
+
+static ssize_t ir_debug_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct ir_device *ir = to_input_dev(dev)->ir;
+
+	return sprintf(buf, "%i\n", ir->raw.xmitter);
+}
+
+static ssize_t ir_debug_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf,
+				  size_t count)
+{
+	struct ir_device *ir = to_input_dev(dev)->ir;
+
+	ir->raw.xmitter = simple_strtoul(buf, NULL, 0);
+	return count;
+}
+
+static DEVICE_ATTR(raw, S_IRUGO | S_IWUSR, ir_raw_show, ir_raw_store);
+static DEVICE_ATTR(carrier, S_IRUGO | S_IWUSR, ir_carrier_show, ir_carrier_store);
+static DEVICE_ATTR(xmitter, S_IRUGO | S_IWUSR, ir_xmitter_show, ir_xmitter_store);
+static DEVICE_ATTR(debug, S_IRUGO | S_IWUSR, ir_debug_show, ir_debug_store);
+
+static struct attribute *input_ir_attrs[] = {
+		&dev_attr_raw.attr,
+		&dev_attr_carrier.attr,
+		&dev_attr_xmitter.attr,
+		&dev_attr_debug.attr,
+		NULL
+	};
+
+static struct attribute_group input_ir_group = {
+	.name	= "ir",
+	.attrs	= input_ir_attrs,
+};
+
+int input_ir_register(struct input_dev *dev)
+{
+	if (!dev->ir)
+		return 0;
+
+	return sysfs_create_group(&dev->dev.kobj, &input_ir_group);
+}
+
+int input_ir_create(struct input_dev *dev, void *private, send_func xmit)
+{
+	dev->ir = kzalloc(sizeof(struct ir_device), GFP_KERNEL);
+	if (!dev->ir)
+		return -ENOMEM;
+
+	dev->evbit[0] = BIT_MASK(EV_IR);
+	dev->ir->private = private;
+	dev->ir->xmit = xmit;
+	dev->ir->input = dev;
+
+	spin_lock_init(&dev->ir->queue.lock);
+	INIT_WORK(&dev->ir->work, ir_event);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(input_ir_create);
+
+void input_ir_destroy(struct input_dev *dev)
+{
+	if (dev->ir) {
+		kfree(dev->ir);
+		dev->ir = NULL;
+		sysfs_remove_group(&dev->dev.kobj, &input_ir_group);
+	}
+}
+
+static int __init input_ir_init(void)
+{
+	return 0;
+}
+module_init(input_ir_init);
+
+static void __exit input_ir_exit(void)
+{
+}
+module_exit(input_ir_exit);
diff --git a/drivers/input/ir/ir.h b/drivers/input/ir/ir.h
new file mode 100644
index 0000000..d0cdc9e
--- /dev/null
+++ b/drivers/input/ir/ir.h
@@ -0,0 +1,63 @@
+/*
+ * Private defines for IR support
+ *
+ * Copyright (C) 2008 Jon Smirl <jonsmirl@gmail.com>
+ */
+
+#include <linux/configfs.h>
+
+#undef IR_PROTOCOL_DEBUG
+#ifdef IR_PROTOCOL_DEBUG
+#define PDEBUG( format, arg... ) \
+	printk(KERN_DEBUG format , ## arg);
+#else
+#define PDEBUG(format, arg...) \
+	({ if (0) printk(KERN_DEBUG format , ## arg); 0; })
+#endif
+
+struct ir_protocol {
+	unsigned int state, code, good, count, bits, mode;
+};
+
+#define MAX_SAMPLES 200
+
+struct ir_device {
+	struct ir_protocol sony;
+	struct ir_protocol jvc;
+	struct ir_protocol nec;
+	struct ir_protocol rc5;
+	struct ir_protocol rc6;
+	struct mutex lock;
+	void *private;
+	send_func xmit;
+	struct input_dev *input;
+	struct {
+		unsigned int buffer[MAX_SAMPLES];
+		unsigned int count;
+	} send;
+	struct {
+		int buffer[MAX_SAMPLES];
+		unsigned int head;
+		unsigned int tail;
+		unsigned int carrier;
+		unsigned int xmitter;
+	} raw;
+	struct {
+		spinlock_t lock;
+		int head, tail;
+		unsigned int samples[MAX_SAMPLES];
+	} queue;
+	struct work_struct work;
+};
+
+extern struct configfs_subsystem input_ir_remotes;
+void input_ir_translate(struct input_dev *dev, int protocol, int device, int command);
+
+#ifdef CONFIG_INPUT_IR
+void input_ir_destroy(struct input_dev *dev);
+#else
+static inline void input_ir_destroy(struct input_dev *dev) {}
+#endif
+
+
+
diff --git a/include/linux/input.h b/include/linux/input.h
index 159a99d..08f7bda 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1480,9 +1480,10 @@ typedef int (*send_func)(void *private, unsigned int *buffer, unsigned int count
 		unsigned int frequency, unsigned int xmitters);
 
 int input_ir_create(struct input_dev *dev, void *private, send_func send);
-void input_ir_destroy(struct input_dev *dev);
 
-void input_ir_decode(struct input_dev *dev, unsigned int delta, unsigned int bit);
+void input_ir_decode(struct input_dev *dev, int sample);
+void input_ir_queue(struct input_dev *dev, int sample);
+
 int input_ir_send(struct input_dev *dev, struct ir_command *ir_command, struct file *file);
 int input_ir_register(struct input_dev *dev);
 

