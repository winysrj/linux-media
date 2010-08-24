Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:50469 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933408Ab0HXXCI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:08 -0400
Subject: [PATCH 1/3] merge rc-core
To: mchehab@infradead.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@redhat.com, linux-media@vger.kernel.org
Date: Wed, 25 Aug 2010 01:02:02 +0200
Message-ID: <20100824230202.13006.19319.stgit@localhost.localdomain>
In-Reply-To: <20100824225427.13006.57226.stgit@localhost.localdomain>
References: <20100824225427.13006.57226.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

This patch merges the files which makes up ir-core and renames the
resulting module to rc-core. IMHO this makes it much easier to hack
on the core module since all code is in one file.

This also allows some simplification of ir-core-priv.h as less internal
functions need to be exposed.
---
 drivers/media/IR/Makefile       |    3 
 drivers/media/IR/ir-core-priv.h |   16 -
 drivers/media/IR/ir-keytable.c  |  552 ------------------
 drivers/media/IR/ir-raw-event.c |  270 ---------
 drivers/media/IR/ir-sysfs.c     |  354 -----------
 drivers/media/IR/rc-core.c      | 1206 +++++++++++++++++++++++++++++++++++++++
 drivers/media/IR/rc-map.c       |   84 ---
 include/media/ir-core.h         |    3 
 8 files changed, 1207 insertions(+), 1281 deletions(-)
 delete mode 100644 drivers/media/IR/ir-keytable.c
 delete mode 100644 drivers/media/IR/ir-raw-event.c
 delete mode 100644 drivers/media/IR/ir-sysfs.c
 create mode 100644 drivers/media/IR/rc-core.c
 delete mode 100644 drivers/media/IR/rc-map.c

diff --git a/drivers/media/IR/Makefile b/drivers/media/IR/Makefile
index 2ae4f3a..1464ce0 100644
--- a/drivers/media/IR/Makefile
+++ b/drivers/media/IR/Makefile
@@ -1,9 +1,8 @@
 ir-common-objs  := ir-functions.o
-ir-core-objs	:= ir-keytable.o ir-sysfs.o ir-raw-event.o rc-map.o
 
 obj-y += keymaps/
 
-obj-$(CONFIG_IR_CORE) += ir-core.o
+obj-$(CONFIG_IR_CORE) += rc-core.o
 obj-$(CONFIG_VIDEO_IR) += ir-common.o
 obj-$(CONFIG_LIRC) += lirc_dev.o
 obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index babd520..64a90b4 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -108,24 +108,8 @@ static inline void decrease_duration(struct ir_raw_event *ev, unsigned duration)
 #define TO_STR(is_pulse)		((is_pulse) ? "pulse" : "space")
 #define IS_RESET(ev)			(ev.duration == 0)
 
-/*
- * Routines from ir-sysfs.c - Meant to be called only internally inside
- * ir-core
- */
-
-int ir_register_class(struct input_dev *input_dev);
-void ir_unregister_class(struct input_dev *input_dev);
-
-/*
- * Routines from ir-raw-event.c to be used internally and by decoders
- */
-u64 ir_raw_get_allowed_protocols(void);
-int ir_raw_event_register(struct input_dev *input_dev);
-void ir_raw_event_unregister(struct input_dev *input_dev);
 int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
-void ir_raw_init(void);
-
 
 /*
  * Decoder initialization code
diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
deleted file mode 100644
index 9374a00..0000000
--- a/drivers/media/IR/ir-keytable.c
+++ /dev/null
@@ -1,552 +0,0 @@
-/* ir-keytable.c - handle IR scancode->keycode tables
- *
- * Copyright (C) 2009 by Mauro Carvalho Chehab <mchehab@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
-
-
-#include <linux/input.h>
-#include <linux/slab.h>
-#include "ir-core-priv.h"
-
-/* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
-#define IR_TAB_MIN_SIZE	256
-#define IR_TAB_MAX_SIZE	8192
-
-/* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
-#define IR_KEYPRESS_TIMEOUT 250
-
-/**
- * ir_resize_table() - resizes a scancode table if necessary
- * @rc_tab:	the ir_scancode_table to resize
- * @return:	zero on success or a negative error code
- *
- * This routine will shrink the ir_scancode_table if it has lots of
- * unused entries and grow it if it is full.
- */
-static int ir_resize_table(struct ir_scancode_table *rc_tab)
-{
-	unsigned int oldalloc = rc_tab->alloc;
-	unsigned int newalloc = oldalloc;
-	struct ir_scancode *oldscan = rc_tab->scan;
-	struct ir_scancode *newscan;
-
-	if (rc_tab->size == rc_tab->len) {
-		/* All entries in use -> grow keytable */
-		if (rc_tab->alloc >= IR_TAB_MAX_SIZE)
-			return -ENOMEM;
-
-		newalloc *= 2;
-		IR_dprintk(1, "Growing table to %u bytes\n", newalloc);
-	}
-
-	if ((rc_tab->len * 3 < rc_tab->size) && (oldalloc > IR_TAB_MIN_SIZE)) {
-		/* Less than 1/3 of entries in use -> shrink keytable */
-		newalloc /= 2;
-		IR_dprintk(1, "Shrinking table to %u bytes\n", newalloc);
-	}
-
-	if (newalloc == oldalloc)
-		return 0;
-
-	newscan = kmalloc(newalloc, GFP_ATOMIC);
-	if (!newscan) {
-		IR_dprintk(1, "Failed to kmalloc %u bytes\n", newalloc);
-		return -ENOMEM;
-	}
-
-	memcpy(newscan, rc_tab->scan, rc_tab->len * sizeof(struct ir_scancode));
-	rc_tab->scan = newscan;
-	rc_tab->alloc = newalloc;
-	rc_tab->size = rc_tab->alloc / sizeof(struct ir_scancode);
-	kfree(oldscan);
-	return 0;
-}
-
-/**
- * ir_do_setkeycode() - internal function to set a keycode in the
- *			scancode->keycode table
- * @dev:	the struct input_dev device descriptor
- * @rc_tab:	the struct ir_scancode_table to set the keycode in
- * @scancode:	the scancode for the ir command
- * @keycode:	the keycode for the ir command
- * @resize:	whether the keytable may be shrunk
- * @return:	-EINVAL if the keycode could not be inserted, otherwise zero.
- *
- * This routine is used internally to manipulate the scancode->keycode table.
- * The caller has to hold @rc_tab->lock.
- */
-static int ir_do_setkeycode(struct input_dev *dev,
-			    struct ir_scancode_table *rc_tab,
-			    unsigned scancode, unsigned keycode,
-			    bool resize)
-{
-	unsigned int i;
-	int old_keycode = KEY_RESERVED;
-	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
-
-	/*
-	 * Unfortunately, some hardware-based IR decoders don't provide
-	 * all bits for the complete IR code. In general, they provide only
-	 * the command part of the IR code. Yet, as it is possible to replace
-	 * the provided IR with another one, it is needed to allow loading
-	 * IR tables from other remotes. So,
-	 */
-	if (ir_dev->props && ir_dev->props->scanmask) {
-		scancode &= ir_dev->props->scanmask;
-	}
-
-	/* First check if we already have a mapping for this ir command */
-	for (i = 0; i < rc_tab->len; i++) {
-		/* Keytable is sorted from lowest to highest scancode */
-		if (rc_tab->scan[i].scancode > scancode)
-			break;
-		else if (rc_tab->scan[i].scancode < scancode)
-			continue;
-
-		old_keycode = rc_tab->scan[i].keycode;
-		rc_tab->scan[i].keycode = keycode;
-
-		/* Did the user wish to remove the mapping? */
-		if (keycode == KEY_RESERVED || keycode == KEY_UNKNOWN) {
-			IR_dprintk(1, "#%d: Deleting scan 0x%04x\n",
-				   i, scancode);
-			rc_tab->len--;
-			memmove(&rc_tab->scan[i], &rc_tab->scan[i + 1],
-				(rc_tab->len - i) * sizeof(struct ir_scancode));
-		}
-
-		/* Possibly shrink the keytable, failure is not a problem */
-		ir_resize_table(rc_tab);
-		break;
-	}
-
-	if (old_keycode == KEY_RESERVED && keycode != KEY_RESERVED) {
-		/* No previous mapping found, we might need to grow the table */
-		if (resize && ir_resize_table(rc_tab))
-			return -ENOMEM;
-
-		IR_dprintk(1, "#%d: New scan 0x%04x with key 0x%04x\n",
-			   i, scancode, keycode);
-
-		/* i is the proper index to insert our new keycode */
-		memmove(&rc_tab->scan[i + 1], &rc_tab->scan[i],
-			(rc_tab->len - i) * sizeof(struct ir_scancode));
-		rc_tab->scan[i].scancode = scancode;
-		rc_tab->scan[i].keycode = keycode;
-		rc_tab->len++;
-		set_bit(keycode, dev->keybit);
-	} else {
-		IR_dprintk(1, "#%d: Replacing scan 0x%04x with key 0x%04x\n",
-			   i, scancode, keycode);
-		/* A previous mapping was updated... */
-		clear_bit(old_keycode, dev->keybit);
-		/* ...but another scancode might use the same keycode */
-		for (i = 0; i < rc_tab->len; i++) {
-			if (rc_tab->scan[i].keycode == old_keycode) {
-				set_bit(old_keycode, dev->keybit);
-				break;
-			}
-		}
-	}
-
-	return 0;
-}
-
-/**
- * ir_setkeycode() - set a keycode in the scancode->keycode table
- * @dev:	the struct input_dev device descriptor
- * @scancode:	the desired scancode
- * @keycode:	result
- * @return:	-EINVAL if the keycode could not be inserted, otherwise zero.
- *
- * This routine is used to handle evdev EVIOCSKEY ioctl.
- */
-static int ir_setkeycode(struct input_dev *dev,
-			 unsigned int scancode, unsigned int keycode)
-{
-	int rc;
-	unsigned long flags;
-	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
-	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
-
-	spin_lock_irqsave(&rc_tab->lock, flags);
-	rc = ir_do_setkeycode(dev, rc_tab, scancode, keycode, true);
-	spin_unlock_irqrestore(&rc_tab->lock, flags);
-	return rc;
-}
-
-/**
- * ir_setkeytable() - sets several entries in the scancode->keycode table
- * @dev:	the struct input_dev device descriptor
- * @to:		the struct ir_scancode_table to copy entries to
- * @from:	the struct ir_scancode_table to copy entries from
- * @return:	-EINVAL if all keycodes could not be inserted, otherwise zero.
- *
- * This routine is used to handle table initialization.
- */
-static int ir_setkeytable(struct input_dev *dev,
-			  struct ir_scancode_table *to,
-			  const struct ir_scancode_table *from)
-{
-	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
-	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
-	unsigned long flags;
-	unsigned int i;
-	int rc = 0;
-
-	spin_lock_irqsave(&rc_tab->lock, flags);
-	for (i = 0; i < from->size; i++) {
-		rc = ir_do_setkeycode(dev, to, from->scan[i].scancode,
-				      from->scan[i].keycode, false);
-		if (rc)
-			break;
-	}
-	spin_unlock_irqrestore(&rc_tab->lock, flags);
-	return rc;
-}
-
-/**
- * ir_getkeycode() - get a keycode from the scancode->keycode table
- * @dev:	the struct input_dev device descriptor
- * @scancode:	the desired scancode
- * @keycode:	used to return the keycode, if found, or KEY_RESERVED
- * @return:	always returns zero.
- *
- * This routine is used to handle evdev EVIOCGKEY ioctl.
- */
-static int ir_getkeycode(struct input_dev *dev,
-			 unsigned int scancode, unsigned int *keycode)
-{
-	int start, end, mid;
-	unsigned long flags;
-	int key = KEY_RESERVED;
-	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
-	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
-
-	spin_lock_irqsave(&rc_tab->lock, flags);
-	start = 0;
-	end = rc_tab->len - 1;
-	while (start <= end) {
-		mid = (start + end) / 2;
-		if (rc_tab->scan[mid].scancode < scancode)
-			start = mid + 1;
-		else if (rc_tab->scan[mid].scancode > scancode)
-			end = mid - 1;
-		else {
-			key = rc_tab->scan[mid].keycode;
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&rc_tab->lock, flags);
-
-	if (key == KEY_RESERVED)
-		IR_dprintk(1, "unknown key for scancode 0x%04x\n",
-			   scancode);
-
-	*keycode = key;
-	return 0;
-}
-
-/**
- * ir_g_keycode_from_table() - gets the keycode that corresponds to a scancode
- * @input_dev:	the struct input_dev descriptor of the device
- * @scancode:	the scancode that we're seeking
- *
- * This routine is used by the input routines when a key is pressed at the
- * IR. The scancode is received and needs to be converted into a keycode.
- * If the key is not found, it returns KEY_RESERVED. Otherwise, returns the
- * corresponding keycode from the table.
- */
-u32 ir_g_keycode_from_table(struct input_dev *dev, u32 scancode)
-{
-	int keycode;
-
-	ir_getkeycode(dev, scancode, &keycode);
-	if (keycode != KEY_RESERVED)
-		IR_dprintk(1, "%s: scancode 0x%04x keycode 0x%02x\n",
-			   dev->name, scancode, keycode);
-	return keycode;
-}
-EXPORT_SYMBOL_GPL(ir_g_keycode_from_table);
-
-/**
- * ir_keyup() - generates input event to cleanup a key press
- * @ir:         the struct ir_input_dev descriptor of the device
- *
- * This routine is used to signal that a key has been released on the
- * remote control. It reports a keyup input event via input_report_key().
- */
-static void ir_keyup(struct ir_input_dev *ir)
-{
-	if (!ir->keypressed)
-		return;
-
-	IR_dprintk(1, "keyup key 0x%04x\n", ir->last_keycode);
-	input_report_key(ir->input_dev, ir->last_keycode, 0);
-	input_sync(ir->input_dev);
-	ir->keypressed = false;
-}
-
-/**
- * ir_timer_keyup() - generates a keyup event after a timeout
- * @cookie:     a pointer to struct ir_input_dev passed to setup_timer()
- *
- * This routine will generate a keyup event some time after a keydown event
- * is generated when no further activity has been detected.
- */
-static void ir_timer_keyup(unsigned long cookie)
-{
-	struct ir_input_dev *ir = (struct ir_input_dev *)cookie;
-	unsigned long flags;
-
-	/*
-	 * ir->keyup_jiffies is used to prevent a race condition if a
-	 * hardware interrupt occurs at this point and the keyup timer
-	 * event is moved further into the future as a result.
-	 *
-	 * The timer will then be reactivated and this function called
-	 * again in the future. We need to exit gracefully in that case
-	 * to allow the input subsystem to do its auto-repeat magic or
-	 * a keyup event might follow immediately after the keydown.
-	 */
-	spin_lock_irqsave(&ir->keylock, flags);
-	if (time_is_after_eq_jiffies(ir->keyup_jiffies))
-		ir_keyup(ir);
-	spin_unlock_irqrestore(&ir->keylock, flags);
-}
-
-/**
- * ir_repeat() - notifies the IR core that a key is still pressed
- * @dev:        the struct input_dev descriptor of the device
- *
- * This routine is used by IR decoders when a repeat message which does
- * not include the necessary bits to reproduce the scancode has been
- * received.
- */
-void ir_repeat(struct input_dev *dev)
-{
-	unsigned long flags;
-	struct ir_input_dev *ir = input_get_drvdata(dev);
-
-	spin_lock_irqsave(&ir->keylock, flags);
-
-	if (!ir->keypressed)
-		goto out;
-
-	ir->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
-	mod_timer(&ir->timer_keyup, ir->keyup_jiffies);
-
-out:
-	spin_unlock_irqrestore(&ir->keylock, flags);
-}
-EXPORT_SYMBOL_GPL(ir_repeat);
-
-/**
- * ir_keydown() - generates input event for a key press
- * @dev:        the struct input_dev descriptor of the device
- * @scancode:   the scancode that we're seeking
- * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
- *              support toggle values, this should be set to zero)
- *
- * This routine is used by the input routines when a key is pressed at the
- * IR. It gets the keycode for a scancode and reports an input event via
- * input_report_key().
- */
-void ir_keydown(struct input_dev *dev, int scancode, u8 toggle)
-{
-	unsigned long flags;
-	struct ir_input_dev *ir = input_get_drvdata(dev);
-
-	u32 keycode = ir_g_keycode_from_table(dev, scancode);
-
-	spin_lock_irqsave(&ir->keylock, flags);
-
-	/* Repeat event? */
-	if (ir->keypressed &&
-	    ir->last_scancode == scancode &&
-	    ir->last_toggle == toggle)
-		goto set_timer;
-
-	/* Release old keypress */
-	ir_keyup(ir);
-
-	ir->last_scancode = scancode;
-	ir->last_toggle = toggle;
-	ir->last_keycode = keycode;
-
-	if (keycode == KEY_RESERVED)
-		goto out;
-
-	/* Register a keypress */
-	ir->keypressed = true;
-	IR_dprintk(1, "%s: key down event, key 0x%04x, scancode 0x%04x\n",
-		   dev->name, keycode, scancode);
-	input_report_key(dev, ir->last_keycode, 1);
-	input_sync(dev);
-
-set_timer:
-	ir->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
-	mod_timer(&ir->timer_keyup, ir->keyup_jiffies);
-out:
-	spin_unlock_irqrestore(&ir->keylock, flags);
-}
-EXPORT_SYMBOL_GPL(ir_keydown);
-
-static int ir_open(struct input_dev *input_dev)
-{
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-
-	return ir_dev->props->open(ir_dev->props->priv);
-}
-
-static void ir_close(struct input_dev *input_dev)
-{
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-
-	ir_dev->props->close(ir_dev->props->priv);
-}
-
-/**
- * __ir_input_register() - sets the IR keycode table and add the handlers
- *			    for keymap table get/set
- * @input_dev:	the struct input_dev descriptor of the device
- * @rc_tab:	the struct ir_scancode_table table of scancode/keymap
- *
- * This routine is used to initialize the input infrastructure
- * to work with an IR.
- * It will register the input/evdev interface for the device and
- * register the syfs code for IR class
- */
-int __ir_input_register(struct input_dev *input_dev,
-		      const struct ir_scancode_table *rc_tab,
-		      const struct ir_dev_props *props,
-		      const char *driver_name)
-{
-	struct ir_input_dev *ir_dev;
-	int rc;
-
-	if (rc_tab->scan == NULL || !rc_tab->size)
-		return -EINVAL;
-
-	ir_dev = kzalloc(sizeof(*ir_dev), GFP_KERNEL);
-	if (!ir_dev)
-		return -ENOMEM;
-
-	ir_dev->driver_name = kasprintf(GFP_KERNEL, "%s", driver_name);
-	if (!ir_dev->driver_name) {
-		rc = -ENOMEM;
-		goto out_dev;
-	}
-
-	input_dev->getkeycode = ir_getkeycode;
-	input_dev->setkeycode = ir_setkeycode;
-	input_set_drvdata(input_dev, ir_dev);
-	ir_dev->input_dev = input_dev;
-
-	spin_lock_init(&ir_dev->rc_tab.lock);
-	spin_lock_init(&ir_dev->keylock);
-	setup_timer(&ir_dev->timer_keyup, ir_timer_keyup, (unsigned long)ir_dev);
-
-	ir_dev->rc_tab.name = rc_tab->name;
-	ir_dev->rc_tab.ir_type = rc_tab->ir_type;
-	ir_dev->rc_tab.alloc = roundup_pow_of_two(rc_tab->size *
-						  sizeof(struct ir_scancode));
-	ir_dev->rc_tab.scan = kmalloc(ir_dev->rc_tab.alloc, GFP_KERNEL);
-	ir_dev->rc_tab.size = ir_dev->rc_tab.alloc / sizeof(struct ir_scancode);
-	if (props) {
-		ir_dev->props = props;
-		if (props->open)
-			input_dev->open = ir_open;
-		if (props->close)
-			input_dev->close = ir_close;
-	}
-
-	if (!ir_dev->rc_tab.scan) {
-		rc = -ENOMEM;
-		goto out_name;
-	}
-
-	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
-		   ir_dev->rc_tab.size, ir_dev->rc_tab.alloc);
-
-	set_bit(EV_KEY, input_dev->evbit);
-	set_bit(EV_REP, input_dev->evbit);
-
-	if (ir_setkeytable(input_dev, &ir_dev->rc_tab, rc_tab)) {
-		rc = -ENOMEM;
-		goto out_table;
-	}
-
-	rc = ir_register_class(input_dev);
-	if (rc < 0)
-		goto out_table;
-
-	if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW) {
-		rc = ir_raw_event_register(input_dev);
-		if (rc < 0)
-			goto out_event;
-	}
-
-	IR_dprintk(1, "Registered input device on %s for %s remote.\n",
-		   driver_name, rc_tab->name);
-
-	return 0;
-
-out_event:
-	ir_unregister_class(input_dev);
-out_table:
-	kfree(ir_dev->rc_tab.scan);
-out_name:
-	kfree(ir_dev->driver_name);
-out_dev:
-	kfree(ir_dev);
-	return rc;
-}
-EXPORT_SYMBOL_GPL(__ir_input_register);
-
-/**
- * ir_input_unregister() - unregisters IR and frees resources
- * @input_dev:	the struct input_dev descriptor of the device
-
- * This routine is used to free memory and de-register interfaces.
- */
-void ir_input_unregister(struct input_dev *input_dev)
-{
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	struct ir_scancode_table *rc_tab;
-
-	if (!ir_dev)
-		return;
-
-	IR_dprintk(1, "Freed keycode table\n");
-
-	del_timer_sync(&ir_dev->timer_keyup);
-	if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW)
-		ir_raw_event_unregister(input_dev);
-	rc_tab = &ir_dev->rc_tab;
-	rc_tab->size = 0;
-	kfree(rc_tab->scan);
-	rc_tab->scan = NULL;
-
-	ir_unregister_class(input_dev);
-
-	kfree(ir_dev->driver_name);
-	kfree(ir_dev);
-}
-EXPORT_SYMBOL_GPL(ir_input_unregister);
-
-int ir_core_debug;    /* ir_debug level (0,1,2) */
-EXPORT_SYMBOL_GPL(ir_core_debug);
-module_param_named(debug, ir_core_debug, int, 0644);
-
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
-MODULE_LICENSE("GPL");
diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
deleted file mode 100644
index 6f192ef..0000000
--- a/drivers/media/IR/ir-raw-event.c
+++ /dev/null
@@ -1,270 +0,0 @@
-/* ir-raw-event.c - handle IR Pulse/Space event
- *
- * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
-
-#include <linux/workqueue.h>
-#include <linux/spinlock.h>
-#include <linux/sched.h>
-#include "ir-core-priv.h"
-
-/* Define the max number of pulse/space transitions to buffer */
-#define MAX_IR_EVENT_SIZE      512
-
-/* Used to keep track of IR raw clients, protected by ir_raw_handler_lock */
-static LIST_HEAD(ir_raw_client_list);
-
-/* Used to handle IR raw handler extensions */
-static DEFINE_SPINLOCK(ir_raw_handler_lock);
-static LIST_HEAD(ir_raw_handler_list);
-static u64 available_protocols;
-
-#ifdef MODULE
-/* Used to load the decoders */
-static struct work_struct wq_load;
-#endif
-
-static void ir_raw_event_work(struct work_struct *work)
-{
-	struct ir_raw_event ev;
-	struct ir_raw_handler *handler;
-	struct ir_raw_event_ctrl *raw =
-		container_of(work, struct ir_raw_event_ctrl, rx_work);
-
-	while (kfifo_out(&raw->kfifo, &ev, sizeof(ev)) == sizeof(ev)) {
-		spin_lock(&ir_raw_handler_lock);
-		list_for_each_entry(handler, &ir_raw_handler_list, list)
-			handler->decode(raw->input_dev, ev);
-		spin_unlock(&ir_raw_handler_lock);
-		raw->prev_ev = ev;
-	}
-}
-
-/**
- * ir_raw_event_store() - pass a pulse/space duration to the raw ir decoders
- * @input_dev:	the struct input_dev device descriptor
- * @ev:		the struct ir_raw_event descriptor of the pulse/space
- *
- * This routine (which may be called from an interrupt context) stores a
- * pulse/space duration for the raw ir decoding state machines. Pulses are
- * signalled as positive values and spaces as negative values. A zero value
- * will reset the decoding state machines.
- */
-int ir_raw_event_store(struct input_dev *input_dev, struct ir_raw_event *ev)
-{
-	struct ir_input_dev *ir = input_get_drvdata(input_dev);
-
-	if (!ir->raw)
-		return -EINVAL;
-
-	if (kfifo_in(&ir->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
-		return -ENOMEM;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ir_raw_event_store);
-
-/**
- * ir_raw_event_store_edge() - notify raw ir decoders of the start of a pulse/space
- * @input_dev:	the struct input_dev device descriptor
- * @type:	the type of the event that has occurred
- *
- * This routine (which may be called from an interrupt context) is used to
- * store the beginning of an ir pulse or space (or the start/end of ir
- * reception) for the raw ir decoding state machines. This is used by
- * hardware which does not provide durations directly but only interrupts
- * (or similar events) on state change.
- */
-int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type type)
-{
-	struct ir_input_dev	*ir = input_get_drvdata(input_dev);
-	ktime_t			now;
-	s64			delta; /* ns */
-	struct ir_raw_event	ev;
-	int			rc = 0;
-
-	if (!ir->raw)
-		return -EINVAL;
-
-	now = ktime_get();
-	delta = ktime_to_ns(ktime_sub(now, ir->raw->last_event));
-
-	/* Check for a long duration since last event or if we're
-	 * being called for the first time, note that delta can't
-	 * possibly be negative.
-	 */
-	ev.duration = 0;
-	if (delta > IR_MAX_DURATION || !ir->raw->last_type)
-		type |= IR_START_EVENT;
-	else
-		ev.duration = delta;
-
-	if (type & IR_START_EVENT)
-		ir_raw_event_reset(input_dev);
-	else if (ir->raw->last_type & IR_SPACE) {
-		ev.pulse = false;
-		rc = ir_raw_event_store(input_dev, &ev);
-	} else if (ir->raw->last_type & IR_PULSE) {
-		ev.pulse = true;
-		rc = ir_raw_event_store(input_dev, &ev);
-	} else
-		return 0;
-
-	ir->raw->last_event = now;
-	ir->raw->last_type = type;
-	return rc;
-}
-EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
-
-/**
- * ir_raw_event_handle() - schedules the decoding of stored ir data
- * @input_dev:	the struct input_dev device descriptor
- *
- * This routine will signal the workqueue to start decoding stored ir data.
- */
-void ir_raw_event_handle(struct input_dev *input_dev)
-{
-	struct ir_input_dev *ir = input_get_drvdata(input_dev);
-
-	if (!ir->raw)
-		return;
-
-	schedule_work(&ir->raw->rx_work);
-}
-EXPORT_SYMBOL_GPL(ir_raw_event_handle);
-
-/* used internally by the sysfs interface */
-u64
-ir_raw_get_allowed_protocols()
-{
-	u64 protocols;
-	spin_lock(&ir_raw_handler_lock);
-	protocols = available_protocols;
-	spin_unlock(&ir_raw_handler_lock);
-	return protocols;
-}
-
-/*
- * Used to (un)register raw event clients
- */
-int ir_raw_event_register(struct input_dev *input_dev)
-{
-	struct ir_input_dev *ir = input_get_drvdata(input_dev);
-	int rc;
-	struct ir_raw_handler *handler;
-
-	ir->raw = kzalloc(sizeof(*ir->raw), GFP_KERNEL);
-	if (!ir->raw)
-		return -ENOMEM;
-
-	ir->raw->input_dev = input_dev;
-	INIT_WORK(&ir->raw->rx_work, ir_raw_event_work);
-	ir->raw->enabled_protocols = ~0;
-	rc = kfifo_alloc(&ir->raw->kfifo, sizeof(s64) * MAX_IR_EVENT_SIZE,
-			 GFP_KERNEL);
-	if (rc < 0) {
-		kfree(ir->raw);
-		ir->raw = NULL;
-		return rc;
-	}
-
-	spin_lock(&ir_raw_handler_lock);
-	list_add_tail(&ir->raw->list, &ir_raw_client_list);
-	list_for_each_entry(handler, &ir_raw_handler_list, list)
-		if (handler->raw_register)
-			handler->raw_register(ir->raw->input_dev);
-	spin_unlock(&ir_raw_handler_lock);
-
-	return 0;
-}
-
-void ir_raw_event_unregister(struct input_dev *input_dev)
-{
-	struct ir_input_dev *ir = input_get_drvdata(input_dev);
-	struct ir_raw_handler *handler;
-
-	if (!ir->raw)
-		return;
-
-	cancel_work_sync(&ir->raw->rx_work);
-
-	spin_lock(&ir_raw_handler_lock);
-	list_del(&ir->raw->list);
-	list_for_each_entry(handler, &ir_raw_handler_list, list)
-		if (handler->raw_unregister)
-			handler->raw_unregister(ir->raw->input_dev);
-	spin_unlock(&ir_raw_handler_lock);
-
-	kfifo_free(&ir->raw->kfifo);
-	kfree(ir->raw);
-	ir->raw = NULL;
-}
-
-/*
- * Extension interface - used to register the IR decoders
- */
-
-int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
-{
-	struct ir_raw_event_ctrl *raw;
-
-	spin_lock(&ir_raw_handler_lock);
-	list_add_tail(&ir_raw_handler->list, &ir_raw_handler_list);
-	if (ir_raw_handler->raw_register)
-		list_for_each_entry(raw, &ir_raw_client_list, list)
-			ir_raw_handler->raw_register(raw->input_dev);
-	available_protocols |= ir_raw_handler->protocols;
-	spin_unlock(&ir_raw_handler_lock);
-
-	return 0;
-}
-EXPORT_SYMBOL(ir_raw_handler_register);
-
-void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
-{
-	struct ir_raw_event_ctrl *raw;
-
-	spin_lock(&ir_raw_handler_lock);
-	list_del(&ir_raw_handler->list);
-	if (ir_raw_handler->raw_unregister)
-		list_for_each_entry(raw, &ir_raw_client_list, list)
-			ir_raw_handler->raw_unregister(raw->input_dev);
-	available_protocols &= ~ir_raw_handler->protocols;
-	spin_unlock(&ir_raw_handler_lock);
-}
-EXPORT_SYMBOL(ir_raw_handler_unregister);
-
-#ifdef MODULE
-static void init_decoders(struct work_struct *work)
-{
-	/* Load the decoder modules */
-
-	load_nec_decode();
-	load_rc5_decode();
-	load_rc6_decode();
-	load_jvc_decode();
-	load_sony_decode();
-	load_lirc_codec();
-
-	/* If needed, we may later add some init code. In this case,
-	   it is needed to change the CONFIG_MODULE test at ir-core.h
-	 */
-}
-#endif
-
-void ir_raw_init(void)
-{
-#ifdef MODULE
-	INIT_WORK(&wq_load, init_decoders);
-	schedule_work(&wq_load);
-#endif
-}
diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
deleted file mode 100644
index a841e51..0000000
--- a/drivers/media/IR/ir-sysfs.c
+++ /dev/null
@@ -1,354 +0,0 @@
-/* ir-sysfs.c - sysfs interface for RC devices (/sys/class/rc)
- *
- * Copyright (C) 2009-2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
-
-#include <linux/slab.h>
-#include <linux/input.h>
-#include <linux/device.h>
-#include "ir-core-priv.h"
-
-#define IRRCV_NUM_DEVICES	256
-
-/* bit array to represent IR sysfs device number */
-static unsigned long ir_core_dev_number;
-
-/* class for /sys/class/rc */
-static char *ir_devnode(struct device *dev, mode_t *mode)
-{
-	return kasprintf(GFP_KERNEL, "rc/%s", dev_name(dev));
-}
-
-static struct class ir_input_class = {
-	.name		= "rc",
-	.devnode	= ir_devnode,
-};
-
-/**
- * show_protocols() - shows the current IR protocol(s)
- * @d:		the device descriptor
- * @mattr:	the device attribute struct (unused)
- * @buf:	a pointer to the output buffer
- *
- * This routine is a callback routine for input read the IR protocol type(s).
- * it is trigged by reading /sys/class/rc/rc?/protocols.
- * It returns the protocol names of supported protocols.
- * Enabled protocols are printed in brackets.
- */
-static ssize_t show_protocols(struct device *d,
-			      struct device_attribute *mattr, char *buf)
-{
-	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
-	u64 allowed, enabled;
-	char *tmp = buf;
-
-	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
-		enabled = ir_dev->rc_tab.ir_type;
-		allowed = ir_dev->props->allowed_protos;
-	} else {
-		enabled = ir_dev->raw->enabled_protocols;
-		allowed = ir_raw_get_allowed_protocols();
-	}
-
-	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
-		   (long long)allowed,
-		   (long long)enabled);
-
-	if (allowed & enabled & IR_TYPE_UNKNOWN)
-		tmp += sprintf(tmp, "[unknown] ");
-	else if (allowed & IR_TYPE_UNKNOWN)
-		tmp += sprintf(tmp, "unknown ");
-
-	if (allowed & enabled & IR_TYPE_RC5)
-		tmp += sprintf(tmp, "[rc5] ");
-	else if (allowed & IR_TYPE_RC5)
-		tmp += sprintf(tmp, "rc5 ");
-
-	if (allowed & enabled & IR_TYPE_NEC)
-		tmp += sprintf(tmp, "[nec] ");
-	else if (allowed & IR_TYPE_NEC)
-		tmp += sprintf(tmp, "nec ");
-
-	if (allowed & enabled & IR_TYPE_RC6)
-		tmp += sprintf(tmp, "[rc6] ");
-	else if (allowed & IR_TYPE_RC6)
-		tmp += sprintf(tmp, "rc6 ");
-
-	if (allowed & enabled & IR_TYPE_JVC)
-		tmp += sprintf(tmp, "[jvc] ");
-	else if (allowed & IR_TYPE_JVC)
-		tmp += sprintf(tmp, "jvc ");
-
-	if (allowed & enabled & IR_TYPE_SONY)
-		tmp += sprintf(tmp, "[sony] ");
-	else if (allowed & IR_TYPE_SONY)
-		tmp += sprintf(tmp, "sony ");
-
-	if (allowed & enabled & IR_TYPE_LIRC)
-		tmp += sprintf(tmp, "[lirc] ");
-	else if (allowed & IR_TYPE_LIRC)
-		tmp += sprintf(tmp, "lirc ");
-
-	if (tmp != buf)
-		tmp--;
-	*tmp = '\n';
-	return tmp + 1 - buf;
-}
-
-/**
- * store_protocols() - changes the current IR protocol(s)
- * @d:		the device descriptor
- * @mattr:	the device attribute struct (unused)
- * @buf:	a pointer to the input buffer
- * @len:	length of the input buffer
- *
- * This routine is a callback routine for changing the IR protocol type.
- * It is trigged by writing to /sys/class/rc/rc?/protocols.
- * Writing "+proto" will add a protocol to the list of enabled protocols.
- * Writing "-proto" will remove a protocol from the list of enabled protocols.
- * Writing "proto" will enable only "proto".
- * Returns -EINVAL if an invalid protocol combination or unknown protocol name
- * is used, otherwise @len.
- */
-static ssize_t store_protocols(struct device *d,
-			       struct device_attribute *mattr,
-			       const char *data,
-			       size_t len)
-{
-	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
-	bool enable, disable;
-	const char *tmp;
-	u64 type;
-	u64 mask;
-	int rc;
-	unsigned long flags;
-
-	tmp = skip_spaces(data);
-
-	if (*tmp == '+') {
-		enable = true;
-		disable = false;
-		tmp++;
-	} else if (*tmp == '-') {
-		enable = false;
-		disable = true;
-		tmp++;
-	} else {
-		enable = false;
-		disable = false;
-	}
-
-	if (!strncasecmp(tmp, "unknown", 7)) {
-		tmp += 7;
-		mask = IR_TYPE_UNKNOWN;
-	} else if (!strncasecmp(tmp, "rc5", 3)) {
-		tmp += 3;
-		mask = IR_TYPE_RC5;
-	} else if (!strncasecmp(tmp, "nec", 3)) {
-		tmp += 3;
-		mask = IR_TYPE_NEC;
-	} else if (!strncasecmp(tmp, "rc6", 3)) {
-		tmp += 3;
-		mask = IR_TYPE_RC6;
-	} else if (!strncasecmp(tmp, "jvc", 3)) {
-		tmp += 3;
-		mask = IR_TYPE_JVC;
-	} else if (!strncasecmp(tmp, "sony", 4)) {
-		tmp += 4;
-		mask = IR_TYPE_SONY;
-	} else if (!strncasecmp(tmp, "lirc", 4)) {
-		tmp += 4;
-		mask = IR_TYPE_LIRC;
-	} else {
-		IR_dprintk(1, "Unknown protocol\n");
-		return -EINVAL;
-	}
-
-	tmp = skip_spaces(tmp);
-	if (*tmp != '\0') {
-		IR_dprintk(1, "Invalid trailing characters\n");
-		return -EINVAL;
-	}
-
-	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
-		type = ir_dev->rc_tab.ir_type;
-	else
-		type = ir_dev->raw->enabled_protocols;
-
-	if (enable)
-		type |= mask;
-	else if (disable)
-		type &= ~mask;
-	else
-		type = mask;
-
-	if (ir_dev->props && ir_dev->props->change_protocol) {
-		rc = ir_dev->props->change_protocol(ir_dev->props->priv,
-						    type);
-		if (rc < 0) {
-			IR_dprintk(1, "Error setting protocols to 0x%llx\n",
-				   (long long)type);
-			return -EINVAL;
-		}
-	}
-
-	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
-		spin_lock_irqsave(&ir_dev->rc_tab.lock, flags);
-		ir_dev->rc_tab.ir_type = type;
-		spin_unlock_irqrestore(&ir_dev->rc_tab.lock, flags);
-	} else {
-		ir_dev->raw->enabled_protocols = type;
-	}
-
-
-	IR_dprintk(1, "Current protocol(s): 0x%llx\n",
-		   (long long)type);
-
-	return len;
-}
-
-#define ADD_HOTPLUG_VAR(fmt, val...)					\
-	do {								\
-		int err = add_uevent_var(env, fmt, val);		\
-		if (err)						\
-			return err;					\
-	} while (0)
-
-static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
-{
-	struct ir_input_dev *ir_dev = dev_get_drvdata(device);
-
-	if (ir_dev->rc_tab.name)
-		ADD_HOTPLUG_VAR("NAME=%s", ir_dev->rc_tab.name);
-	if (ir_dev->driver_name)
-		ADD_HOTPLUG_VAR("DRV_NAME=%s", ir_dev->driver_name);
-
-	return 0;
-}
-
-/*
- * Static device attribute struct with the sysfs attributes for IR's
- */
-static DEVICE_ATTR(protocols, S_IRUGO | S_IWUSR,
-		   show_protocols, store_protocols);
-
-static struct attribute *rc_dev_attrs[] = {
-	&dev_attr_protocols.attr,
-	NULL,
-};
-
-static struct attribute_group rc_dev_attr_grp = {
-	.attrs	= rc_dev_attrs,
-};
-
-static const struct attribute_group *rc_dev_attr_groups[] = {
-	&rc_dev_attr_grp,
-	NULL
-};
-
-static struct device_type rc_dev_type = {
-	.groups		= rc_dev_attr_groups,
-	.uevent		= rc_dev_uevent,
-};
-
-/**
- * ir_register_class() - creates the sysfs for /sys/class/rc/rc?
- * @input_dev:	the struct input_dev descriptor of the device
- *
- * This routine is used to register the syfs code for IR class
- */
-int ir_register_class(struct input_dev *input_dev)
-{
-	int rc;
-	const char *path;
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	int devno = find_first_zero_bit(&ir_core_dev_number,
-					IRRCV_NUM_DEVICES);
-
-	if (unlikely(devno < 0))
-		return devno;
-
-	ir_dev->dev.type = &rc_dev_type;
-	ir_dev->dev.class = &ir_input_class;
-	ir_dev->dev.parent = input_dev->dev.parent;
-	dev_set_name(&ir_dev->dev, "rc%d", devno);
-	dev_set_drvdata(&ir_dev->dev, ir_dev);
-	rc = device_register(&ir_dev->dev);
-	if (rc)
-		return rc;
-
-
-	input_dev->dev.parent = &ir_dev->dev;
-	rc = input_register_device(input_dev);
-	if (rc < 0) {
-		device_del(&ir_dev->dev);
-		return rc;
-	}
-
-	__module_get(THIS_MODULE);
-
-	path = kobject_get_path(&ir_dev->dev.kobj, GFP_KERNEL);
-	printk(KERN_INFO "%s: %s as %s\n",
-		dev_name(&ir_dev->dev),
-		input_dev->name ? input_dev->name : "Unspecified device",
-		path ? path : "N/A");
-	kfree(path);
-
-	ir_dev->devno = devno;
-	set_bit(devno, &ir_core_dev_number);
-
-	return 0;
-};
-
-/**
- * ir_unregister_class() - removes the sysfs for sysfs for
- *			   /sys/class/rc/rc?
- * @input_dev:	the struct input_dev descriptor of the device
- *
- * This routine is used to unregister the syfs code for IR class
- */
-void ir_unregister_class(struct input_dev *input_dev)
-{
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-
-	clear_bit(ir_dev->devno, &ir_core_dev_number);
-	input_unregister_device(input_dev);
-	device_del(&ir_dev->dev);
-
-	module_put(THIS_MODULE);
-}
-
-/*
- * Init/exit code for the module. Basically, creates/removes /sys/class/rc
- */
-
-static int __init ir_core_init(void)
-{
-	int rc = class_register(&ir_input_class);
-	if (rc) {
-		printk(KERN_ERR "ir_core: unable to register rc class\n");
-		return rc;
-	}
-
-	/* Initialize/load the decoders/keymap code that will be used */
-	ir_raw_init();
-
-	return 0;
-}
-
-static void __exit ir_core_exit(void)
-{
-	class_unregister(&ir_input_class);
-}
-
-module_init(ir_core_init);
-module_exit(ir_core_exit);
diff --git a/drivers/media/IR/rc-core.c b/drivers/media/IR/rc-core.c
new file mode 100644
index 0000000..0d67933
--- /dev/null
+++ b/drivers/media/IR/rc-core.c
@@ -0,0 +1,1206 @@
+/* rc-core.c - Remote Control core module
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
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/workqueue.h>
+#include <linux/sched.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include "ir-core-priv.h"
+
+/* Define the max number of pulse/space transitions to buffer */
+#define MAX_IR_EVENT_SIZE      512
+
+/* Used to keep track of IR raw clients, protected by ir_raw_handler_lock */
+static LIST_HEAD(ir_raw_client_list);
+
+/* Used to handle IR raw handler extensions */
+static DEFINE_SPINLOCK(ir_raw_handler_lock);
+static LIST_HEAD(ir_raw_handler_list);
+static u64 available_protocols;
+
+/* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
+#define IR_TAB_MIN_SIZE	256
+#define IR_TAB_MAX_SIZE	8192
+
+/* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
+#define IR_KEYPRESS_TIMEOUT 250
+
+#define IRRCV_NUM_DEVICES 256
+
+/* bit array to represent IR sysfs device number */
+static unsigned long ir_core_dev_number;
+
+#ifdef MODULE
+/* Used to load the decoders */
+static struct work_struct wq_load;
+#endif
+
+/* Used to handle IR raw handler extensions */
+static LIST_HEAD(rc_map_list);
+static DEFINE_SPINLOCK(rc_map_lock);
+
+/* Forward declarations */
+static int ir_register_class(struct input_dev *input_dev);
+static void ir_unregister_class(struct input_dev *input_dev);
+
+static struct rc_keymap *seek_rc_map(const char *name)
+{
+	struct rc_keymap *map = NULL;
+
+	spin_lock(&rc_map_lock);
+	list_for_each_entry(map, &rc_map_list, list) {
+		if (!strcmp(name, map->map.name)) {
+			spin_unlock(&rc_map_lock);
+			return map;
+		}
+	}
+	spin_unlock(&rc_map_lock);
+
+	return NULL;
+}
+
+struct ir_scancode_table *get_rc_map(const char *name)
+{
+
+	struct rc_keymap *map;
+
+	map = seek_rc_map(name);
+#ifdef MODULE
+	if (!map) {
+		int rc = request_module(name);
+		if (rc < 0) {
+			printk(KERN_ERR "Couldn't load IR keymap %s\n", name);
+			return NULL;
+		}
+		msleep(20);	/* Give some time for IR to register */
+
+		map = seek_rc_map(name);
+	}
+#endif
+	if (!map) {
+		printk(KERN_ERR "IR keymap %s not found\n", name);
+		return NULL;
+	}
+
+	printk(KERN_INFO "Registered IR keymap %s\n", map->map.name);
+
+	return &map->map;
+}
+EXPORT_SYMBOL_GPL(get_rc_map);
+
+int ir_register_map(struct rc_keymap *map)
+{
+	spin_lock(&rc_map_lock);
+	list_add_tail(&map->list, &rc_map_list);
+	spin_unlock(&rc_map_lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ir_register_map);
+
+void ir_unregister_map(struct rc_keymap *map)
+{
+	spin_lock(&rc_map_lock);
+	list_del(&map->list);
+	spin_unlock(&rc_map_lock);
+}
+EXPORT_SYMBOL_GPL(ir_unregister_map);
+
+static void ir_raw_event_work(struct work_struct *work)
+{
+	struct ir_raw_event ev;
+	struct ir_raw_handler *handler;
+	struct ir_raw_event_ctrl *raw =
+		container_of(work, struct ir_raw_event_ctrl, rx_work);
+
+	while (kfifo_out(&raw->kfifo, &ev, sizeof(ev)) == sizeof(ev)) {
+		spin_lock(&ir_raw_handler_lock);
+		list_for_each_entry(handler, &ir_raw_handler_list, list)
+			handler->decode(raw->input_dev, ev);
+		spin_unlock(&ir_raw_handler_lock);
+		raw->prev_ev = ev;
+	}
+}
+
+/**
+ * ir_raw_event_store() - pass a pulse/space duration to the raw ir decoders
+ * @input_dev:	the struct input_dev device descriptor
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
+ *
+ * This routine (which may be called from an interrupt context) stores a
+ * pulse/space duration for the raw ir decoding state machines. Pulses are
+ * signalled as positive values and spaces as negative values. A zero value
+ * will reset the decoding state machines.
+ */
+int ir_raw_event_store(struct input_dev *input_dev, struct ir_raw_event *ev)
+{
+	struct ir_input_dev *ir = input_get_drvdata(input_dev);
+
+	if (!ir->raw)
+		return -EINVAL;
+
+	if (kfifo_in(&ir->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_store);
+
+/**
+ * ir_raw_event_store_edge() - notify raw ir decoders of the start of a pulse/space
+ * @input_dev:	the struct input_dev device descriptor
+ * @type:	the type of the event that has occurred
+ *
+ * This routine (which may be called from an interrupt context) is used to
+ * store the beginning of an ir pulse or space (or the start/end of ir
+ * reception) for the raw ir decoding state machines. This is used by
+ * hardware which does not provide durations directly but only interrupts
+ * (or similar events) on state change.
+ */
+int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type type)
+{
+	struct ir_input_dev	*ir = input_get_drvdata(input_dev);
+	ktime_t			now;
+	s64			delta; /* ns */
+	struct ir_raw_event	ev;
+	int			rc = 0;
+
+	if (!ir->raw)
+		return -EINVAL;
+
+	now = ktime_get();
+	delta = ktime_to_ns(ktime_sub(now, ir->raw->last_event));
+
+	/* Check for a long duration since last event or if we're
+	 * being called for the first time, note that delta can't
+	 * possibly be negative.
+	 */
+	ev.duration = 0;
+	if (delta > IR_MAX_DURATION || !ir->raw->last_type)
+		type |= IR_START_EVENT;
+	else
+		ev.duration = delta;
+
+	if (type & IR_START_EVENT)
+		ir_raw_event_reset(input_dev);
+	else if (ir->raw->last_type & IR_SPACE) {
+		ev.pulse = false;
+		rc = ir_raw_event_store(input_dev, &ev);
+	} else if (ir->raw->last_type & IR_PULSE) {
+		ev.pulse = true;
+		rc = ir_raw_event_store(input_dev, &ev);
+	} else
+		return 0;
+
+	ir->raw->last_event = now;
+	ir->raw->last_type = type;
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
+
+/**
+ * ir_raw_event_handle() - schedules the decoding of stored ir data
+ * @input_dev:	the struct input_dev device descriptor
+ *
+ * This routine will signal the workqueue to start decoding stored ir data.
+ */
+void ir_raw_event_handle(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir = input_get_drvdata(input_dev);
+
+	if (!ir->raw)
+		return;
+
+	schedule_work(&ir->raw->rx_work);
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_handle);
+
+/*
+ * Used to (un)register raw event clients
+ */
+static int ir_raw_event_register(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir = input_get_drvdata(input_dev);
+	int rc;
+	struct ir_raw_handler *handler;
+
+	ir->raw = kzalloc(sizeof(*ir->raw), GFP_KERNEL);
+	if (!ir->raw)
+		return -ENOMEM;
+
+	ir->raw->input_dev = input_dev;
+	INIT_WORK(&ir->raw->rx_work, ir_raw_event_work);
+	ir->raw->enabled_protocols = ~0;
+	rc = kfifo_alloc(&ir->raw->kfifo, sizeof(s64) * MAX_IR_EVENT_SIZE,
+			 GFP_KERNEL);
+	if (rc < 0) {
+		kfree(ir->raw);
+		ir->raw = NULL;
+		return rc;
+	}
+
+	spin_lock(&ir_raw_handler_lock);
+	list_add_tail(&ir->raw->list, &ir_raw_client_list);
+	list_for_each_entry(handler, &ir_raw_handler_list, list)
+		if (handler->raw_register)
+			handler->raw_register(ir->raw->input_dev);
+	spin_unlock(&ir_raw_handler_lock);
+
+	return 0;
+}
+
+static void ir_raw_event_unregister(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir = input_get_drvdata(input_dev);
+	struct ir_raw_handler *handler;
+
+	if (!ir->raw)
+		return;
+
+	cancel_work_sync(&ir->raw->rx_work);
+
+	spin_lock(&ir_raw_handler_lock);
+	list_del(&ir->raw->list);
+	list_for_each_entry(handler, &ir_raw_handler_list, list)
+		if (handler->raw_unregister)
+			handler->raw_unregister(ir->raw->input_dev);
+	spin_unlock(&ir_raw_handler_lock);
+
+	kfifo_free(&ir->raw->kfifo);
+	kfree(ir->raw);
+	ir->raw = NULL;
+}
+
+/*
+ * Extension interface - used to register the IR decoders
+ */
+
+int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
+{
+	struct ir_raw_event_ctrl *raw;
+
+	spin_lock(&ir_raw_handler_lock);
+	list_add_tail(&ir_raw_handler->list, &ir_raw_handler_list);
+	if (ir_raw_handler->raw_register)
+		list_for_each_entry(raw, &ir_raw_client_list, list)
+			ir_raw_handler->raw_register(raw->input_dev);
+	available_protocols |= ir_raw_handler->protocols;
+	spin_unlock(&ir_raw_handler_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(ir_raw_handler_register);
+
+void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
+{
+	struct ir_raw_event_ctrl *raw;
+
+	spin_lock(&ir_raw_handler_lock);
+	list_del(&ir_raw_handler->list);
+	if (ir_raw_handler->raw_unregister)
+		list_for_each_entry(raw, &ir_raw_client_list, list)
+			ir_raw_handler->raw_unregister(raw->input_dev);
+	available_protocols &= ~ir_raw_handler->protocols;
+	spin_unlock(&ir_raw_handler_lock);
+}
+EXPORT_SYMBOL(ir_raw_handler_unregister);
+
+#ifdef MODULE
+static void init_decoders(struct work_struct *work)
+{
+	/* Load the decoder modules */
+
+	load_nec_decode();
+	load_rc5_decode();
+	load_rc6_decode();
+	load_jvc_decode();
+	load_sony_decode();
+	load_lirc_codec();
+
+	/* If needed, we may later add some init code. In this case,
+	   it is needed to change the CONFIG_MODULE test at ir-core.h
+	 */
+}
+#endif
+
+static void ir_raw_init(void)
+{
+#ifdef MODULE
+	INIT_WORK(&wq_load, init_decoders);
+	schedule_work(&wq_load);
+#endif
+}
+
+/**
+ * ir_resize_table() - resizes a scancode table if necessary
+ * @rc_tab:	the ir_scancode_table to resize
+ * @return:	zero on success or a negative error code
+ *
+ * This routine will shrink the ir_scancode_table if it has lots of
+ * unused entries and grow it if it is full.
+ */
+static int ir_resize_table(struct ir_scancode_table *rc_tab)
+{
+	unsigned int oldalloc = rc_tab->alloc;
+	unsigned int newalloc = oldalloc;
+	struct ir_scancode *oldscan = rc_tab->scan;
+	struct ir_scancode *newscan;
+
+	if (rc_tab->size == rc_tab->len) {
+		/* All entries in use -> grow keytable */
+		if (rc_tab->alloc >= IR_TAB_MAX_SIZE)
+			return -ENOMEM;
+
+		newalloc *= 2;
+		IR_dprintk(1, "Growing table to %u bytes\n", newalloc);
+	}
+
+	if ((rc_tab->len * 3 < rc_tab->size) && (oldalloc > IR_TAB_MIN_SIZE)) {
+		/* Less than 1/3 of entries in use -> shrink keytable */
+		newalloc /= 2;
+		IR_dprintk(1, "Shrinking table to %u bytes\n", newalloc);
+	}
+
+	if (newalloc == oldalloc)
+		return 0;
+
+	newscan = kmalloc(newalloc, GFP_ATOMIC);
+	if (!newscan) {
+		IR_dprintk(1, "Failed to kmalloc %u bytes\n", newalloc);
+		return -ENOMEM;
+	}
+
+	memcpy(newscan, rc_tab->scan, rc_tab->len * sizeof(struct ir_scancode));
+	rc_tab->scan = newscan;
+	rc_tab->alloc = newalloc;
+	rc_tab->size = rc_tab->alloc / sizeof(struct ir_scancode);
+	kfree(oldscan);
+	return 0;
+}
+
+/**
+ * ir_do_setkeycode() - internal function to set a keycode in the
+ *			scancode->keycode table
+ * @dev:	the struct input_dev device descriptor
+ * @rc_tab:	the struct ir_scancode_table to set the keycode in
+ * @scancode:	the scancode for the ir command
+ * @keycode:	the keycode for the ir command
+ * @resize:	whether the keytable may be shrunk
+ * @return:	-EINVAL if the keycode could not be inserted, otherwise zero.
+ *
+ * This routine is used internally to manipulate the scancode->keycode table.
+ * The caller has to hold @rc_tab->lock.
+ */
+static int ir_do_setkeycode(struct input_dev *dev,
+			    struct ir_scancode_table *rc_tab,
+			    unsigned scancode, unsigned keycode,
+			    bool resize)
+{
+	unsigned int i;
+	int old_keycode = KEY_RESERVED;
+	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
+
+	/*
+	 * Unfortunately, some hardware-based IR decoders don't provide
+	 * all bits for the complete IR code. In general, they provide only
+	 * the command part of the IR code. Yet, as it is possible to replace
+	 * the provided IR with another one, it is needed to allow loading
+	 * IR tables from other remotes. So,
+	 */
+	if (ir_dev->props && ir_dev->props->scanmask) {
+		scancode &= ir_dev->props->scanmask;
+	}
+
+	/* First check if we already have a mapping for this ir command */
+	for (i = 0; i < rc_tab->len; i++) {
+		/* Keytable is sorted from lowest to highest scancode */
+		if (rc_tab->scan[i].scancode > scancode)
+			break;
+		else if (rc_tab->scan[i].scancode < scancode)
+			continue;
+
+		old_keycode = rc_tab->scan[i].keycode;
+		rc_tab->scan[i].keycode = keycode;
+
+		/* Did the user wish to remove the mapping? */
+		if (keycode == KEY_RESERVED || keycode == KEY_UNKNOWN) {
+			IR_dprintk(1, "#%d: Deleting scan 0x%04x\n",
+				   i, scancode);
+			rc_tab->len--;
+			memmove(&rc_tab->scan[i], &rc_tab->scan[i + 1],
+				(rc_tab->len - i) * sizeof(struct ir_scancode));
+		}
+
+		/* Possibly shrink the keytable, failure is not a problem */
+		ir_resize_table(rc_tab);
+		break;
+	}
+
+	if (old_keycode == KEY_RESERVED && keycode != KEY_RESERVED) {
+		/* No previous mapping found, we might need to grow the table */
+		if (resize && ir_resize_table(rc_tab))
+			return -ENOMEM;
+
+		IR_dprintk(1, "#%d: New scan 0x%04x with key 0x%04x\n",
+			   i, scancode, keycode);
+
+		/* i is the proper index to insert our new keycode */
+		memmove(&rc_tab->scan[i + 1], &rc_tab->scan[i],
+			(rc_tab->len - i) * sizeof(struct ir_scancode));
+		rc_tab->scan[i].scancode = scancode;
+		rc_tab->scan[i].keycode = keycode;
+		rc_tab->len++;
+		set_bit(keycode, dev->keybit);
+	} else {
+		IR_dprintk(1, "#%d: Replacing scan 0x%04x with key 0x%04x\n",
+			   i, scancode, keycode);
+		/* A previous mapping was updated... */
+		clear_bit(old_keycode, dev->keybit);
+		/* ...but another scancode might use the same keycode */
+		for (i = 0; i < rc_tab->len; i++) {
+			if (rc_tab->scan[i].keycode == old_keycode) {
+				set_bit(old_keycode, dev->keybit);
+				break;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * ir_setkeycode() - set a keycode in the scancode->keycode table
+ * @dev:	the struct input_dev device descriptor
+ * @scancode:	the desired scancode
+ * @keycode:	result
+ * @return:	-EINVAL if the keycode could not be inserted, otherwise zero.
+ *
+ * This routine is used to handle evdev EVIOCSKEY ioctl.
+ */
+static int ir_setkeycode(struct input_dev *dev,
+			 unsigned int scancode, unsigned int keycode)
+{
+	int rc;
+	unsigned long flags;
+	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
+	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
+
+	spin_lock_irqsave(&rc_tab->lock, flags);
+	rc = ir_do_setkeycode(dev, rc_tab, scancode, keycode, true);
+	spin_unlock_irqrestore(&rc_tab->lock, flags);
+	return rc;
+}
+
+/**
+ * ir_setkeytable() - sets several entries in the scancode->keycode table
+ * @dev:	the struct input_dev device descriptor
+ * @to:		the struct ir_scancode_table to copy entries to
+ * @from:	the struct ir_scancode_table to copy entries from
+ * @return:	-EINVAL if all keycodes could not be inserted, otherwise zero.
+ *
+ * This routine is used to handle table initialization.
+ */
+static int ir_setkeytable(struct input_dev *dev,
+			  struct ir_scancode_table *to,
+			  const struct ir_scancode_table *from)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
+	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
+	unsigned long flags;
+	unsigned int i;
+	int rc = 0;
+
+	spin_lock_irqsave(&rc_tab->lock, flags);
+	for (i = 0; i < from->size; i++) {
+		rc = ir_do_setkeycode(dev, to, from->scan[i].scancode,
+				      from->scan[i].keycode, false);
+		if (rc)
+			break;
+	}
+	spin_unlock_irqrestore(&rc_tab->lock, flags);
+	return rc;
+}
+
+/**
+ * ir_getkeycode() - get a keycode from the scancode->keycode table
+ * @dev:	the struct input_dev device descriptor
+ * @scancode:	the desired scancode
+ * @keycode:	used to return the keycode, if found, or KEY_RESERVED
+ * @return:	always returns zero.
+ *
+ * This routine is used to handle evdev EVIOCGKEY ioctl.
+ */
+static int ir_getkeycode(struct input_dev *dev,
+			 unsigned int scancode, unsigned int *keycode)
+{
+	int start, end, mid;
+	unsigned long flags;
+	int key = KEY_RESERVED;
+	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
+	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
+
+	spin_lock_irqsave(&rc_tab->lock, flags);
+	start = 0;
+	end = rc_tab->len - 1;
+	while (start <= end) {
+		mid = (start + end) / 2;
+		if (rc_tab->scan[mid].scancode < scancode)
+			start = mid + 1;
+		else if (rc_tab->scan[mid].scancode > scancode)
+			end = mid - 1;
+		else {
+			key = rc_tab->scan[mid].keycode;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&rc_tab->lock, flags);
+
+	if (key == KEY_RESERVED)
+		IR_dprintk(1, "unknown key for scancode 0x%04x\n",
+			   scancode);
+
+	*keycode = key;
+	return 0;
+}
+
+/**
+ * ir_g_keycode_from_table() - gets the keycode that corresponds to a scancode
+ * @input_dev:	the struct input_dev descriptor of the device
+ * @scancode:	the scancode that we're seeking
+ *
+ * This routine is used by the input routines when a key is pressed at the
+ * IR. The scancode is received and needs to be converted into a keycode.
+ * If the key is not found, it returns KEY_RESERVED. Otherwise, returns the
+ * corresponding keycode from the table.
+ */
+u32 ir_g_keycode_from_table(struct input_dev *dev, u32 scancode)
+{
+	int keycode;
+
+	ir_getkeycode(dev, scancode, &keycode);
+	if (keycode != KEY_RESERVED)
+		IR_dprintk(1, "%s: scancode 0x%04x keycode 0x%02x\n",
+			   dev->name, scancode, keycode);
+	return keycode;
+}
+EXPORT_SYMBOL_GPL(ir_g_keycode_from_table);
+
+/**
+ * ir_keyup() - generates input event to cleanup a key press
+ * @ir:         the struct ir_input_dev descriptor of the device
+ *
+ * This routine is used to signal that a key has been released on the
+ * remote control. It reports a keyup input event via input_report_key().
+ */
+static void ir_keyup(struct ir_input_dev *ir)
+{
+	if (!ir->keypressed)
+		return;
+
+	IR_dprintk(1, "keyup key 0x%04x\n", ir->last_keycode);
+	input_report_key(ir->input_dev, ir->last_keycode, 0);
+	input_sync(ir->input_dev);
+	ir->keypressed = false;
+}
+
+/**
+ * ir_timer_keyup() - generates a keyup event after a timeout
+ * @cookie:     a pointer to struct ir_input_dev passed to setup_timer()
+ *
+ * This routine will generate a keyup event some time after a keydown event
+ * is generated when no further activity has been detected.
+ */
+static void ir_timer_keyup(unsigned long cookie)
+{
+	struct ir_input_dev *ir = (struct ir_input_dev *)cookie;
+	unsigned long flags;
+
+	/*
+	 * ir->keyup_jiffies is used to prevent a race condition if a
+	 * hardware interrupt occurs at this point and the keyup timer
+	 * event is moved further into the future as a result.
+	 *
+	 * The timer will then be reactivated and this function called
+	 * again in the future. We need to exit gracefully in that case
+	 * to allow the input subsystem to do its auto-repeat magic or
+	 * a keyup event might follow immediately after the keydown.
+	 */
+	spin_lock_irqsave(&ir->keylock, flags);
+	if (time_is_after_eq_jiffies(ir->keyup_jiffies))
+		ir_keyup(ir);
+	spin_unlock_irqrestore(&ir->keylock, flags);
+}
+
+/**
+ * ir_repeat() - notifies the IR core that a key is still pressed
+ * @dev:        the struct input_dev descriptor of the device
+ *
+ * This routine is used by IR decoders when a repeat message which does
+ * not include the necessary bits to reproduce the scancode has been
+ * received.
+ */
+void ir_repeat(struct input_dev *dev)
+{
+	unsigned long flags;
+	struct ir_input_dev *ir = input_get_drvdata(dev);
+
+	spin_lock_irqsave(&ir->keylock, flags);
+
+	if (!ir->keypressed)
+		goto out;
+
+	ir->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+	mod_timer(&ir->timer_keyup, ir->keyup_jiffies);
+
+out:
+	spin_unlock_irqrestore(&ir->keylock, flags);
+}
+EXPORT_SYMBOL_GPL(ir_repeat);
+
+/**
+ * ir_keydown() - generates input event for a key press
+ * @dev:        the struct input_dev descriptor of the device
+ * @scancode:   the scancode that we're seeking
+ * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
+ *              support toggle values, this should be set to zero)
+ *
+ * This routine is used by the input routines when a key is pressed at the
+ * IR. It gets the keycode for a scancode and reports an input event via
+ * input_report_key().
+ */
+void ir_keydown(struct input_dev *dev, int scancode, u8 toggle)
+{
+	unsigned long flags;
+	struct ir_input_dev *ir = input_get_drvdata(dev);
+
+	u32 keycode = ir_g_keycode_from_table(dev, scancode);
+
+	spin_lock_irqsave(&ir->keylock, flags);
+
+	/* Repeat event? */
+	if (ir->keypressed &&
+	    ir->last_scancode == scancode &&
+	    ir->last_toggle == toggle)
+		goto set_timer;
+
+	/* Release old keypress */
+	ir_keyup(ir);
+
+	ir->last_scancode = scancode;
+	ir->last_toggle = toggle;
+	ir->last_keycode = keycode;
+
+	if (keycode == KEY_RESERVED)
+		goto out;
+
+	/* Register a keypress */
+	ir->keypressed = true;
+	IR_dprintk(1, "%s: key down event, key 0x%04x, scancode 0x%04x\n",
+		   dev->name, keycode, scancode);
+	input_report_key(dev, ir->last_keycode, 1);
+	input_sync(dev);
+
+set_timer:
+	ir->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+	mod_timer(&ir->timer_keyup, ir->keyup_jiffies);
+out:
+	spin_unlock_irqrestore(&ir->keylock, flags);
+}
+EXPORT_SYMBOL_GPL(ir_keydown);
+
+static int ir_open(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+
+	return ir_dev->props->open(ir_dev->props->priv);
+}
+
+static void ir_close(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+
+	ir_dev->props->close(ir_dev->props->priv);
+}
+
+/**
+ * __ir_input_register() - sets the IR keycode table and add the handlers
+ *			    for keymap table get/set
+ * @input_dev:	the struct input_dev descriptor of the device
+ * @rc_tab:	the struct ir_scancode_table table of scancode/keymap
+ *
+ * This routine is used to initialize the input infrastructure
+ * to work with an IR.
+ * It will register the input/evdev interface for the device and
+ * register the syfs code for IR class
+ */
+int __ir_input_register(struct input_dev *input_dev,
+		      const struct ir_scancode_table *rc_tab,
+		      const struct ir_dev_props *props,
+		      const char *driver_name)
+{
+	struct ir_input_dev *ir_dev;
+	int rc;
+
+	if (rc_tab->scan == NULL || !rc_tab->size)
+		return -EINVAL;
+
+	ir_dev = kzalloc(sizeof(*ir_dev), GFP_KERNEL);
+	if (!ir_dev)
+		return -ENOMEM;
+
+	ir_dev->driver_name = kasprintf(GFP_KERNEL, "%s", driver_name);
+	if (!ir_dev->driver_name) {
+		rc = -ENOMEM;
+		goto out_dev;
+	}
+
+	input_dev->getkeycode = ir_getkeycode;
+	input_dev->setkeycode = ir_setkeycode;
+	input_set_drvdata(input_dev, ir_dev);
+	ir_dev->input_dev = input_dev;
+
+	spin_lock_init(&ir_dev->rc_tab.lock);
+	spin_lock_init(&ir_dev->keylock);
+	setup_timer(&ir_dev->timer_keyup, ir_timer_keyup, (unsigned long)ir_dev);
+
+	ir_dev->rc_tab.name = rc_tab->name;
+	ir_dev->rc_tab.ir_type = rc_tab->ir_type;
+	ir_dev->rc_tab.alloc = roundup_pow_of_two(rc_tab->size *
+						  sizeof(struct ir_scancode));
+	ir_dev->rc_tab.scan = kmalloc(ir_dev->rc_tab.alloc, GFP_KERNEL);
+	ir_dev->rc_tab.size = ir_dev->rc_tab.alloc / sizeof(struct ir_scancode);
+	if (props) {
+		ir_dev->props = props;
+		if (props->open)
+			input_dev->open = ir_open;
+		if (props->close)
+			input_dev->close = ir_close;
+	}
+
+	if (!ir_dev->rc_tab.scan) {
+		rc = -ENOMEM;
+		goto out_name;
+	}
+
+	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
+		   ir_dev->rc_tab.size, ir_dev->rc_tab.alloc);
+
+	set_bit(EV_KEY, input_dev->evbit);
+	set_bit(EV_REP, input_dev->evbit);
+
+	if (ir_setkeytable(input_dev, &ir_dev->rc_tab, rc_tab)) {
+		rc = -ENOMEM;
+		goto out_table;
+	}
+
+	rc = ir_register_class(input_dev);
+	if (rc < 0)
+		goto out_table;
+
+	if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW) {
+		rc = ir_raw_event_register(input_dev);
+		if (rc < 0)
+			goto out_event;
+	}
+
+	IR_dprintk(1, "Registered input device on %s for %s remote.\n",
+		   driver_name, rc_tab->name);
+
+	return 0;
+
+out_event:
+	ir_unregister_class(input_dev);
+out_table:
+	kfree(ir_dev->rc_tab.scan);
+out_name:
+	kfree(ir_dev->driver_name);
+out_dev:
+	kfree(ir_dev);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(__ir_input_register);
+
+/**
+ * ir_input_unregister() - unregisters IR and frees resources
+ * @input_dev:	the struct input_dev descriptor of the device
+
+ * This routine is used to free memory and de-register interfaces.
+ */
+void ir_input_unregister(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	struct ir_scancode_table *rc_tab;
+
+	if (!ir_dev)
+		return;
+
+	IR_dprintk(1, "Freed keycode table\n");
+
+	del_timer_sync(&ir_dev->timer_keyup);
+	if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW)
+		ir_raw_event_unregister(input_dev);
+	rc_tab = &ir_dev->rc_tab;
+	rc_tab->size = 0;
+	kfree(rc_tab->scan);
+	rc_tab->scan = NULL;
+
+	ir_unregister_class(input_dev);
+
+	kfree(ir_dev->driver_name);
+	kfree(ir_dev);
+}
+EXPORT_SYMBOL_GPL(ir_input_unregister);
+
+/* class for /sys/class/rc */
+static char *ir_devnode(struct device *dev, mode_t *mode)
+{
+	return kasprintf(GFP_KERNEL, "rc/%s", dev_name(dev));
+}
+
+static struct class ir_input_class = {
+	.name		= "rc",
+	.devnode	= ir_devnode,
+};
+
+/**
+ * show_protocols() - shows the current IR protocol(s)
+ * @d:		the device descriptor
+ * @mattr:	the device attribute struct (unused)
+ * @buf:	a pointer to the output buffer
+ *
+ * This routine is a callback routine for input read the IR protocol type(s).
+ * it is trigged by reading /sys/class/rc/rc?/protocols.
+ * It returns the protocol names of supported protocols.
+ * Enabled protocols are printed in brackets.
+ */
+static ssize_t show_protocols(struct device *d,
+			      struct device_attribute *mattr, char *buf)
+{
+	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
+	u64 allowed, enabled;
+	char *tmp = buf;
+
+	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
+		enabled = ir_dev->rc_tab.ir_type;
+		allowed = ir_dev->props->allowed_protos;
+	} else {
+		enabled = ir_dev->raw->enabled_protocols;
+		spin_lock(&ir_raw_handler_lock);
+		allowed = available_protocols;
+		spin_unlock(&ir_raw_handler_lock);
+	}
+
+	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
+		   (long long)allowed,
+		   (long long)enabled);
+
+	if (allowed & enabled & IR_TYPE_UNKNOWN)
+		tmp += sprintf(tmp, "[unknown] ");
+	else if (allowed & IR_TYPE_UNKNOWN)
+		tmp += sprintf(tmp, "unknown ");
+
+	if (allowed & enabled & IR_TYPE_RC5)
+		tmp += sprintf(tmp, "[rc5] ");
+	else if (allowed & IR_TYPE_RC5)
+		tmp += sprintf(tmp, "rc5 ");
+
+	if (allowed & enabled & IR_TYPE_NEC)
+		tmp += sprintf(tmp, "[nec] ");
+	else if (allowed & IR_TYPE_NEC)
+		tmp += sprintf(tmp, "nec ");
+
+	if (allowed & enabled & IR_TYPE_RC6)
+		tmp += sprintf(tmp, "[rc6] ");
+	else if (allowed & IR_TYPE_RC6)
+		tmp += sprintf(tmp, "rc6 ");
+
+	if (allowed & enabled & IR_TYPE_JVC)
+		tmp += sprintf(tmp, "[jvc] ");
+	else if (allowed & IR_TYPE_JVC)
+		tmp += sprintf(tmp, "jvc ");
+
+	if (allowed & enabled & IR_TYPE_SONY)
+		tmp += sprintf(tmp, "[sony] ");
+	else if (allowed & IR_TYPE_SONY)
+		tmp += sprintf(tmp, "sony ");
+
+	if (allowed & enabled & IR_TYPE_LIRC)
+		tmp += sprintf(tmp, "[lirc] ");
+	else if (allowed & IR_TYPE_LIRC)
+		tmp += sprintf(tmp, "lirc ");
+
+	if (tmp != buf)
+		tmp--;
+	*tmp = '\n';
+	return tmp + 1 - buf;
+}
+
+/**
+ * store_protocols() - changes the current IR protocol(s)
+ * @d:		the device descriptor
+ * @mattr:	the device attribute struct (unused)
+ * @buf:	a pointer to the input buffer
+ * @len:	length of the input buffer
+ *
+ * This routine is a callback routine for changing the IR protocol type.
+ * It is trigged by writing to /sys/class/rc/rc?/protocols.
+ * Writing "+proto" will add a protocol to the list of enabled protocols.
+ * Writing "-proto" will remove a protocol from the list of enabled protocols.
+ * Writing "proto" will enable only "proto".
+ * Returns -EINVAL if an invalid protocol combination or unknown protocol name
+ * is used, otherwise @len.
+ */
+static ssize_t store_protocols(struct device *d,
+			       struct device_attribute *mattr,
+			       const char *data,
+			       size_t len)
+{
+	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
+	bool enable, disable;
+	const char *tmp;
+	u64 type;
+	u64 mask;
+	int rc;
+	unsigned long flags;
+
+	tmp = skip_spaces(data);
+
+	if (*tmp == '+') {
+		enable = true;
+		disable = false;
+		tmp++;
+	} else if (*tmp == '-') {
+		enable = false;
+		disable = true;
+		tmp++;
+	} else {
+		enable = false;
+		disable = false;
+	}
+
+	if (!strncasecmp(tmp, "unknown", 7)) {
+		tmp += 7;
+		mask = IR_TYPE_UNKNOWN;
+	} else if (!strncasecmp(tmp, "rc5", 3)) {
+		tmp += 3;
+		mask = IR_TYPE_RC5;
+	} else if (!strncasecmp(tmp, "nec", 3)) {
+		tmp += 3;
+		mask = IR_TYPE_NEC;
+	} else if (!strncasecmp(tmp, "rc6", 3)) {
+		tmp += 3;
+		mask = IR_TYPE_RC6;
+	} else if (!strncasecmp(tmp, "jvc", 3)) {
+		tmp += 3;
+		mask = IR_TYPE_JVC;
+	} else if (!strncasecmp(tmp, "sony", 4)) {
+		tmp += 4;
+		mask = IR_TYPE_SONY;
+	} else if (!strncasecmp(tmp, "lirc", 4)) {
+		tmp += 4;
+		mask = IR_TYPE_LIRC;
+	} else {
+		IR_dprintk(1, "Unknown protocol\n");
+		return -EINVAL;
+	}
+
+	tmp = skip_spaces(tmp);
+	if (*tmp != '\0') {
+		IR_dprintk(1, "Invalid trailing characters\n");
+		return -EINVAL;
+	}
+
+	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
+		type = ir_dev->rc_tab.ir_type;
+	else
+		type = ir_dev->raw->enabled_protocols;
+
+	if (enable)
+		type |= mask;
+	else if (disable)
+		type &= ~mask;
+	else
+		type = mask;
+
+	if (ir_dev->props && ir_dev->props->change_protocol) {
+		rc = ir_dev->props->change_protocol(ir_dev->props->priv,
+						    type);
+		if (rc < 0) {
+			IR_dprintk(1, "Error setting protocols to 0x%llx\n",
+				   (long long)type);
+			return -EINVAL;
+		}
+	}
+
+	if (ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
+		spin_lock_irqsave(&ir_dev->rc_tab.lock, flags);
+		ir_dev->rc_tab.ir_type = type;
+		spin_unlock_irqrestore(&ir_dev->rc_tab.lock, flags);
+	} else {
+		ir_dev->raw->enabled_protocols = type;
+	}
+
+
+	IR_dprintk(1, "Current protocol(s): 0x%llx\n",
+		   (long long)type);
+
+	return len;
+}
+
+#define ADD_HOTPLUG_VAR(fmt, val...)					\
+	do {								\
+		int err = add_uevent_var(env, fmt, val);		\
+		if (err)						\
+			return err;					\
+	} while (0)
+
+static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
+{
+	struct ir_input_dev *ir_dev = dev_get_drvdata(device);
+
+	if (ir_dev->rc_tab.name)
+		ADD_HOTPLUG_VAR("NAME=%s", ir_dev->rc_tab.name);
+	if (ir_dev->driver_name)
+		ADD_HOTPLUG_VAR("DRV_NAME=%s", ir_dev->driver_name);
+
+	return 0;
+}
+
+/*
+ * Static device attribute struct with the sysfs attributes for IR's
+ */
+static DEVICE_ATTR(protocols, S_IRUGO | S_IWUSR,
+		   show_protocols, store_protocols);
+
+static struct attribute *rc_dev_attrs[] = {
+	&dev_attr_protocols.attr,
+	NULL,
+};
+
+static struct attribute_group rc_dev_attr_grp = {
+	.attrs	= rc_dev_attrs,
+};
+
+static const struct attribute_group *rc_dev_attr_groups[] = {
+	&rc_dev_attr_grp,
+	NULL
+};
+
+static struct device_type rc_dev_type = {
+	.groups		= rc_dev_attr_groups,
+	.uevent		= rc_dev_uevent,
+};
+
+/**
+ * ir_register_class() - creates the sysfs for /sys/class/rc/rc?
+ * @input_dev:	the struct input_dev descriptor of the device
+ *
+ * This routine is used to register the syfs code for IR class
+ */
+static int ir_register_class(struct input_dev *input_dev)
+{
+	int rc;
+	const char *path;
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	int devno = find_first_zero_bit(&ir_core_dev_number,
+					IRRCV_NUM_DEVICES);
+
+	if (unlikely(devno < 0))
+		return devno;
+
+	ir_dev->dev.type = &rc_dev_type;
+	ir_dev->dev.class = &ir_input_class;
+	ir_dev->dev.parent = input_dev->dev.parent;
+	dev_set_name(&ir_dev->dev, "rc%d", devno);
+	dev_set_drvdata(&ir_dev->dev, ir_dev);
+	rc = device_register(&ir_dev->dev);
+	if (rc)
+		return rc;
+
+
+	input_dev->dev.parent = &ir_dev->dev;
+	rc = input_register_device(input_dev);
+	if (rc < 0) {
+		device_del(&ir_dev->dev);
+		return rc;
+	}
+
+	__module_get(THIS_MODULE);
+
+	path = kobject_get_path(&ir_dev->dev.kobj, GFP_KERNEL);
+	printk(KERN_INFO "%s: %s as %s\n",
+		dev_name(&ir_dev->dev),
+		input_dev->name ? input_dev->name : "Unspecified device",
+		path ? path : "N/A");
+	kfree(path);
+
+	ir_dev->devno = devno;
+	set_bit(devno, &ir_core_dev_number);
+
+	return 0;
+};
+
+/**
+ * ir_unregister_class() - removes the sysfs for sysfs for
+ *			   /sys/class/rc/rc?
+ * @input_dev:	the struct input_dev descriptor of the device
+ *
+ * This routine is used to unregister the syfs code for IR class
+ */
+static void ir_unregister_class(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+
+	clear_bit(ir_dev->devno, &ir_core_dev_number);
+	input_unregister_device(input_dev);
+	device_del(&ir_dev->dev);
+
+	module_put(THIS_MODULE);
+}
+
+/*
+ * Init/exit code for the module. Basically, creates/removes /sys/class/rc
+ */
+
+static int __init ir_core_init(void)
+{
+	int rc = class_register(&ir_input_class);
+	if (rc) {
+		printk(KERN_ERR "ir_core: unable to register rc class\n");
+		return rc;
+	}
+
+	/* Initialize/load the decoders/keymap code that will be used */
+	ir_raw_init();
+
+	return 0;
+}
+
+static void __exit ir_core_exit(void)
+{
+	class_unregister(&ir_input_class);
+}
+
+module_init(ir_core_init);
+module_exit(ir_core_exit);
+
+int ir_core_debug;    /* ir_debug level (0,1,2) */
+EXPORT_SYMBOL_GPL(ir_core_debug);
+module_param_named(debug, ir_core_debug, int, 0644);
+
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/IR/rc-map.c b/drivers/media/IR/rc-map.c
deleted file mode 100644
index 46a8f15..0000000
--- a/drivers/media/IR/rc-map.c
+++ /dev/null
@@ -1,84 +0,0 @@
-/* ir-raw-event.c - handle IR Pulse/Space event
- *
- * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
-
-#include <media/ir-core.h>
-#include <linux/spinlock.h>
-#include <linux/delay.h>
-
-/* Used to handle IR raw handler extensions */
-static LIST_HEAD(rc_map_list);
-static DEFINE_SPINLOCK(rc_map_lock);
-
-static struct rc_keymap *seek_rc_map(const char *name)
-{
-	struct rc_keymap *map = NULL;
-
-	spin_lock(&rc_map_lock);
-	list_for_each_entry(map, &rc_map_list, list) {
-		if (!strcmp(name, map->map.name)) {
-			spin_unlock(&rc_map_lock);
-			return map;
-		}
-	}
-	spin_unlock(&rc_map_lock);
-
-	return NULL;
-}
-
-struct ir_scancode_table *get_rc_map(const char *name)
-{
-
-	struct rc_keymap *map;
-
-	map = seek_rc_map(name);
-#ifdef MODULE
-	if (!map) {
-		int rc = request_module(name);
-		if (rc < 0) {
-			printk(KERN_ERR "Couldn't load IR keymap %s\n", name);
-			return NULL;
-		}
-		msleep(20);	/* Give some time for IR to register */
-
-		map = seek_rc_map(name);
-	}
-#endif
-	if (!map) {
-		printk(KERN_ERR "IR keymap %s not found\n", name);
-		return NULL;
-	}
-
-	printk(KERN_INFO "Registered IR keymap %s\n", map->map.name);
-
-	return &map->map;
-}
-EXPORT_SYMBOL_GPL(get_rc_map);
-
-int ir_register_map(struct rc_keymap *map)
-{
-	spin_lock(&rc_map_lock);
-	list_add_tail(&map->list, &rc_map_list);
-	spin_unlock(&rc_map_lock);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ir_register_map);
-
-void ir_unregister_map(struct rc_keymap *map)
-{
-	spin_lock(&rc_map_lock);
-	list_del(&map->list);
-	spin_unlock(&rc_map_lock);
-}
-EXPORT_SYMBOL_GPL(ir_unregister_map);
-
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 9b957af..27ad6a2 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -92,7 +92,6 @@ enum raw_event_type {
 
 #define to_ir_input_dev(_attr) container_of(_attr, struct ir_input_dev, attr)
 
-/* From ir-keytable.c */
 int __ir_input_register(struct input_dev *dev,
 		      const struct ir_scancode_table *ir_codes,
 		      const struct ir_dev_props *props,
@@ -132,8 +131,6 @@ void ir_repeat(struct input_dev *dev);
 void ir_keydown(struct input_dev *dev, int scancode, u8 toggle);
 u32 ir_g_keycode_from_table(struct input_dev *input_dev, u32 scancode);
 
-/* From ir-raw-event.c */
-
 struct ir_raw_event {
 	unsigned                        pulse:1;
 	unsigned                        duration:31;

