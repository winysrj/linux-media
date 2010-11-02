Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:47833 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0KBUSG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 16:18:06 -0400
Subject: [PATCH 4/6] ir-core: merge and rename to rc-core
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@infradead.org
Date: Tue, 02 Nov 2010 21:17:59 +0100
Message-ID: <20101102201759.12010.74318.stgit@localhost.localdomain>
In-Reply-To: <20101102201733.12010.30019.stgit@localhost.localdomain>
References: <20101102201733.12010.30019.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This patch merges the files which makes up ir-core and renames the
resulting module to rc-core. ir-raw-event.c is still kept as a separate
file (but renamed to rc-raw.c) as suggested by Mauro.

Signed-off-by: David Härdeman <david@hardeman.nu>
Acked-by: Jarod Wilson <jarod@redhat.com>
Tested-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/Makefile       |    4 
 drivers/media/IR/ir-core-priv.h |   10 
 drivers/media/IR/ir-keytable.c  |  766 -------------------------
 drivers/media/IR/ir-raw-event.c |  382 ------------
 drivers/media/IR/ir-sysfs.c     |  362 ------------
 drivers/media/IR/rc-main.c      | 1199 +++++++++++++++++++++++++++++++++++++++
 drivers/media/IR/rc-map.c       |  107 ---
 drivers/media/IR/rc-raw.c       |  382 ++++++++++++
 include/media/ir-core.h         |    2 
 9 files changed, 1583 insertions(+), 1631 deletions(-)
 delete mode 100644 drivers/media/IR/ir-keytable.c
 delete mode 100644 drivers/media/IR/ir-raw-event.c
 delete mode 100644 drivers/media/IR/ir-sysfs.c
 create mode 100644 drivers/media/IR/rc-main.c
 delete mode 100644 drivers/media/IR/rc-map.c
 create mode 100644 drivers/media/IR/rc-raw.c

diff --git a/drivers/media/IR/Makefile b/drivers/media/IR/Makefile
index 38873cf..1eb24e6 100644
--- a/drivers/media/IR/Makefile
+++ b/drivers/media/IR/Makefile
@@ -1,9 +1,9 @@
 ir-common-objs  := ir-functions.o
-ir-core-objs	:= ir-keytable.o ir-sysfs.o ir-raw-event.o rc-map.o
+rc-core-objs	:= rc-main.o rc-raw.o
 
 obj-y += keymaps/
 
-obj-$(CONFIG_IR_CORE) += ir-core.o
+obj-$(CONFIG_IR_CORE) += rc-core.o
 obj-$(CONFIG_IR_LEGACY) += ir-common.o
 obj-$(CONFIG_LIRC) += lirc_dev.o
 obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index 81c936b..4be0757 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -129,14 +129,6 @@ static inline bool is_timing_event(struct ir_raw_event ev)
 
 #define TO_US(duration)			DIV_ROUND_CLOSEST((duration), 1000)
 #define TO_STR(is_pulse)		((is_pulse) ? "pulse" : "space")
-/*
- * Routines from ir-sysfs.c - Meant to be called only internally inside
- * ir-core
- */
-int ir_register_input(struct input_dev *input_dev);
-
-int ir_register_class(struct input_dev *input_dev);
-void ir_unregister_class(struct input_dev *input_dev);
 
 /*
  * Routines from ir-raw-event.c to be used internally and by decoders
@@ -148,8 +140,6 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_init(void);
 
-int ir_rcmap_init(void);
-void ir_rcmap_cleanup(void);
 /*
  * Decoder initialization code
  *
diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
deleted file mode 100644
index 8039110..0000000
--- a/drivers/media/IR/ir-keytable.c
+++ /dev/null
@@ -1,766 +0,0 @@
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
- * ir_create_table() - initializes a scancode table
- * @rc_tab:	the ir_scancode_table to initialize
- * @name:	name to assign to the table
- * @ir_type:	ir type to assign to the new table
- * @size:	initial size of the table
- * @return:	zero on success or a negative error code
- *
- * This routine will initialize the ir_scancode_table and will allocate
- * memory to hold at least the specified number elements.
- */
-static int ir_create_table(struct ir_scancode_table *rc_tab,
-			   const char *name, u64 ir_type, size_t size)
-{
-	rc_tab->name = name;
-	rc_tab->ir_type = ir_type;
-	rc_tab->alloc = roundup_pow_of_two(size * sizeof(struct ir_scancode));
-	rc_tab->size = rc_tab->alloc / sizeof(struct ir_scancode);
-	rc_tab->scan = kmalloc(rc_tab->alloc, GFP_KERNEL);
-	if (!rc_tab->scan)
-		return -ENOMEM;
-
-	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
-		   rc_tab->size, rc_tab->alloc);
-	return 0;
-}
-
-/**
- * ir_free_table() - frees memory allocated by a scancode table
- * @rc_tab:	the table whose mappings need to be freed
- *
- * This routine will free memory alloctaed for key mappings used by given
- * scancode table.
- */
-static void ir_free_table(struct ir_scancode_table *rc_tab)
-{
-	rc_tab->size = 0;
-	kfree(rc_tab->scan);
-	rc_tab->scan = NULL;
-}
-
-/**
- * ir_resize_table() - resizes a scancode table if necessary
- * @rc_tab:	the ir_scancode_table to resize
- * @gfp_flags:	gfp flags to use when allocating memory
- * @return:	zero on success or a negative error code
- *
- * This routine will shrink the ir_scancode_table if it has lots of
- * unused entries and grow it if it is full.
- */
-static int ir_resize_table(struct ir_scancode_table *rc_tab, gfp_t gfp_flags)
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
-	newscan = kmalloc(newalloc, gfp_flags);
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
- * ir_update_mapping() - set a keycode in the scancode->keycode table
- * @dev:	the struct input_dev device descriptor
- * @rc_tab:	scancode table to be adjusted
- * @index:	index of the mapping that needs to be updated
- * @keycode:	the desired keycode
- * @return:	previous keycode assigned to the mapping
- *
- * This routine is used to update scancode->keycopde mapping at given
- * position.
- */
-static unsigned int ir_update_mapping(struct input_dev *dev,
-				      struct ir_scancode_table *rc_tab,
-				      unsigned int index,
-				      unsigned int new_keycode)
-{
-	int old_keycode = rc_tab->scan[index].keycode;
-	int i;
-
-	/* Did the user wish to remove the mapping? */
-	if (new_keycode == KEY_RESERVED || new_keycode == KEY_UNKNOWN) {
-		IR_dprintk(1, "#%d: Deleting scan 0x%04x\n",
-			   index, rc_tab->scan[index].scancode);
-		rc_tab->len--;
-		memmove(&rc_tab->scan[index], &rc_tab->scan[index+ 1],
-			(rc_tab->len - index) * sizeof(struct ir_scancode));
-	} else {
-		IR_dprintk(1, "#%d: %s scan 0x%04x with key 0x%04x\n",
-			   index,
-			   old_keycode == KEY_RESERVED ? "New" : "Replacing",
-			   rc_tab->scan[index].scancode, new_keycode);
-		rc_tab->scan[index].keycode = new_keycode;
-		__set_bit(new_keycode, dev->keybit);
-	}
-
-	if (old_keycode != KEY_RESERVED) {
-		/* A previous mapping was updated... */
-		__clear_bit(old_keycode, dev->keybit);
-		/* ... but another scancode might use the same keycode */
-		for (i = 0; i < rc_tab->len; i++) {
-			if (rc_tab->scan[i].keycode == old_keycode) {
-				__set_bit(old_keycode, dev->keybit);
-				break;
-			}
-		}
-
-		/* Possibly shrink the keytable, failure is not a problem */
-		ir_resize_table(rc_tab, GFP_ATOMIC);
-	}
-
-	return old_keycode;
-}
-
-/**
- * ir_locate_scancode() - set a keycode in the scancode->keycode table
- * @ir_dev:	the struct ir_input_dev device descriptor
- * @rc_tab:	scancode table to be searched
- * @scancode:	the desired scancode
- * @resize:	controls whether we allowed to resize the table to
- *		accomodate not yet present scancodes
- * @return:	index of the mapping containing scancode in question
- *		or -1U in case of failure.
- *
- * This routine is used to locate given scancode in ir_scancode_table.
- * If scancode is not yet present the routine will allocate a new slot
- * for it.
- */
-static unsigned int ir_establish_scancode(struct ir_input_dev *ir_dev,
-					  struct ir_scancode_table *rc_tab,
-					  unsigned int scancode,
-					  bool resize)
-{
-	unsigned int i;
-
-	/*
-	 * Unfortunately, some hardware-based IR decoders don't provide
-	 * all bits for the complete IR code. In general, they provide only
-	 * the command part of the IR code. Yet, as it is possible to replace
-	 * the provided IR with another one, it is needed to allow loading
-	 * IR tables from other remotes. So,
-	 */
-	if (ir_dev->props && ir_dev->props->scanmask)
-		scancode &= ir_dev->props->scanmask;
-
-	/* First check if we already have a mapping for this ir command */
-	for (i = 0; i < rc_tab->len; i++) {
-		if (rc_tab->scan[i].scancode == scancode)
-			return i;
-
-		/* Keytable is sorted from lowest to highest scancode */
-		if (rc_tab->scan[i].scancode >= scancode)
-			break;
-	}
-
-	/* No previous mapping found, we might need to grow the table */
-	if (rc_tab->size == rc_tab->len) {
-		if (!resize || ir_resize_table(rc_tab, GFP_ATOMIC))
-			return -1U;
-	}
-
-	/* i is the proper index to insert our new keycode */
-	if (i < rc_tab->len)
-		memmove(&rc_tab->scan[i + 1], &rc_tab->scan[i],
-			(rc_tab->len - i) * sizeof(struct ir_scancode));
-	rc_tab->scan[i].scancode = scancode;
-	rc_tab->scan[i].keycode = KEY_RESERVED;
-	rc_tab->len++;
-
-	return i;
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
-			 const struct input_keymap_entry *ke,
-			 unsigned int *old_keycode)
-{
-	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
-	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
-	unsigned int index;
-	unsigned int scancode;
-	int retval;
-	unsigned long flags;
-
-	spin_lock_irqsave(&rc_tab->lock, flags);
-
-	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
-		index = ke->index;
-		if (index >= rc_tab->len) {
-			retval = -EINVAL;
-			goto out;
-		}
-	} else {
-		retval = input_scancode_to_scalar(ke, &scancode);
-		if (retval)
-			goto out;
-
-		index = ir_establish_scancode(ir_dev, rc_tab, scancode, true);
-		if (index >= rc_tab->len) {
-			retval = -ENOMEM;
-			goto out;
-		}
-	}
-
-	*old_keycode = ir_update_mapping(dev, rc_tab, index, ke->keycode);
-
-out:
-	spin_unlock_irqrestore(&rc_tab->lock, flags);
-	return retval;
-}
-
-/**
- * ir_setkeytable() - sets several entries in the scancode->keycode table
- * @dev:	the struct input_dev device descriptor
- * @to:		the struct ir_scancode_table to copy entries to
- * @from:	the struct ir_scancode_table to copy entries from
- * @return:	-ENOMEM if all keycodes could not be inserted, otherwise zero.
- *
- * This routine is used to handle table initialization.
- */
-static int ir_setkeytable(struct ir_input_dev *ir_dev,
-			  const struct ir_scancode_table *from)
-{
-	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
-	unsigned int i, index;
-	int rc;
-
-	rc = ir_create_table(&ir_dev->rc_tab,
-			     from->name, from->ir_type, from->size);
-	if (rc)
-		return rc;
-
-	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
-		   rc_tab->size, rc_tab->alloc);
-
-	for (i = 0; i < from->size; i++) {
-		index = ir_establish_scancode(ir_dev, rc_tab,
-					      from->scan[i].scancode, false);
-		if (index >= rc_tab->len) {
-			rc = -ENOMEM;
-			break;
-		}
-
-		ir_update_mapping(ir_dev->input_dev, rc_tab, index,
-				  from->scan[i].keycode);
-	}
-
-	if (rc)
-		ir_free_table(rc_tab);
-
-	return rc;
-}
-
-/**
- * ir_lookup_by_scancode() - locate mapping by scancode
- * @rc_tab:	the &struct ir_scancode_table to search
- * @scancode:	scancode to look for in the table
- * @return:	index in the table, -1U if not found
- *
- * This routine performs binary search in RC keykeymap table for
- * given scancode.
- */
-static unsigned int ir_lookup_by_scancode(const struct ir_scancode_table *rc_tab,
-					  unsigned int scancode)
-{
-	int start = 0;
-	int end = rc_tab->len - 1;
-	int mid;
-
-	while (start <= end) {
-		mid = (start + end) / 2;
-		if (rc_tab->scan[mid].scancode < scancode)
-			start = mid + 1;
-		else if (rc_tab->scan[mid].scancode > scancode)
-			end = mid - 1;
-		else
-			return mid;
-	}
-
-	return -1U;
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
-			 struct input_keymap_entry *ke)
-{
-	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
-	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
-	struct ir_scancode *entry;
-	unsigned long flags;
-	unsigned int index;
-	unsigned int scancode;
-	int retval;
-
-	spin_lock_irqsave(&rc_tab->lock, flags);
-
-	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
-		index = ke->index;
-	} else {
-		retval = input_scancode_to_scalar(ke, &scancode);
-		if (retval)
-			goto out;
-
-		index = ir_lookup_by_scancode(rc_tab, scancode);
-	}
-
-	if (index >= rc_tab->len) {
-		if (!(ke->flags & INPUT_KEYMAP_BY_INDEX))
-			IR_dprintk(1, "unknown key for scancode 0x%04x\n",
-				   scancode);
-		retval = -EINVAL;
-		goto out;
-	}
-
-	entry = &rc_tab->scan[index];
-
-	ke->index = index;
-	ke->keycode = entry->keycode;
-	ke->len = sizeof(entry->scancode);
-	memcpy(ke->scancode, &entry->scancode, sizeof(entry->scancode));
-
-	retval = 0;
-
-out:
-	spin_unlock_irqrestore(&rc_tab->lock, flags);
-	return retval;
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
-	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
-	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
-	unsigned int keycode;
-	unsigned int index;
-	unsigned long flags;
-
-	spin_lock_irqsave(&rc_tab->lock, flags);
-
-	index = ir_lookup_by_scancode(rc_tab, scancode);
-	keycode = index < rc_tab->len ?
-			rc_tab->scan[index].keycode : KEY_RESERVED;
-
-	spin_unlock_irqrestore(&rc_tab->lock, flags);
-
-	if (keycode != KEY_RESERVED)
-		IR_dprintk(1, "%s: scancode 0x%04x keycode 0x%02x\n",
-			   dev->name, scancode, keycode);
-
-	return keycode;
-}
-EXPORT_SYMBOL_GPL(ir_g_keycode_from_table);
-
-/**
- * ir_do_keyup() - internal function to signal the release of a keypress
- * @ir:         the struct ir_input_dev descriptor of the device
- *
- * This function is used internally to release a keypress, it must be
- * called with keylock held.
- */
-static void ir_do_keyup(struct ir_input_dev *ir)
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
- * ir_keyup() - generates input event to signal the release of a keypress
- * @dev:        the struct input_dev descriptor of the device
- *
- * This routine is used to signal that a key has been released on the
- * remote control.
- */
-void ir_keyup(struct input_dev *dev)
-{
-	unsigned long flags;
-	struct ir_input_dev *ir = input_get_drvdata(dev);
-
-	spin_lock_irqsave(&ir->keylock, flags);
-	ir_do_keyup(ir);
-	spin_unlock_irqrestore(&ir->keylock, flags);
-}
-EXPORT_SYMBOL_GPL(ir_keyup);
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
-	if (time_is_before_eq_jiffies(ir->keyup_jiffies))
-		ir_do_keyup(ir);
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
-	input_event(dev, EV_MSC, MSC_SCAN, ir->last_scancode);
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
- * ir_do_keydown() - internal function to process a keypress
- * @dev:        the struct input_dev descriptor of the device
- * @scancode:   the scancode of the keypress
- * @keycode:    the keycode of the keypress
- * @toggle:     the toggle value of the keypress
- *
- * This function is used internally to register a keypress, it must be
- * called with keylock held.
- */
-static void ir_do_keydown(struct input_dev *dev, int scancode,
-			  u32 keycode, u8 toggle)
-{
-	struct ir_input_dev *ir = input_get_drvdata(dev);
-
-	input_event(dev, EV_MSC, MSC_SCAN, scancode);
-
-	/* Repeat event? */
-	if (ir->keypressed &&
-	    ir->last_scancode == scancode &&
-	    ir->last_toggle == toggle)
-		return;
-
-	/* Release old keypress */
-	ir_do_keyup(ir);
-
-	ir->last_scancode = scancode;
-	ir->last_toggle = toggle;
-	ir->last_keycode = keycode;
-
-	if (keycode == KEY_RESERVED)
-		return;
-
-	/* Register a keypress */
-	ir->keypressed = true;
-	IR_dprintk(1, "%s: key down event, key 0x%04x, scancode 0x%04x\n",
-		   dev->name, keycode, scancode);
-	input_report_key(dev, ir->last_keycode, 1);
-	input_sync(dev);
-}
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
-	u32 keycode = ir_g_keycode_from_table(dev, scancode);
-
-	spin_lock_irqsave(&ir->keylock, flags);
-	ir_do_keydown(dev, scancode, keycode, toggle);
-
-	if (ir->keypressed) {
-		ir->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
-		mod_timer(&ir->timer_keyup, ir->keyup_jiffies);
-	}
-	spin_unlock_irqrestore(&ir->keylock, flags);
-}
-EXPORT_SYMBOL_GPL(ir_keydown);
-
-/**
- * ir_keydown_notimeout() - generates input event for a key press without
- *                          an automatic keyup event at a later time
- * @dev:        the struct input_dev descriptor of the device
- * @scancode:   the scancode that we're seeking
- * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
- *              support toggle values, this should be set to zero)
- *
- * This routine is used by the input routines when a key is pressed at the
- * IR. It gets the keycode for a scancode and reports an input event via
- * input_report_key(). The driver must manually call ir_keyup() at a later
- * stage.
- */
-void ir_keydown_notimeout(struct input_dev *dev, int scancode, u8 toggle)
-{
-	unsigned long flags;
-	struct ir_input_dev *ir = input_get_drvdata(dev);
-	u32 keycode = ir_g_keycode_from_table(dev, scancode);
-
-	spin_lock_irqsave(&ir->keylock, flags);
-	ir_do_keydown(dev, scancode, keycode, toggle);
-	spin_unlock_irqrestore(&ir->keylock, flags);
-}
-EXPORT_SYMBOL_GPL(ir_keydown_notimeout);
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
-		      struct ir_dev_props *props,
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
-	input_dev->getkeycode_new = ir_getkeycode;
-	input_dev->setkeycode_new = ir_setkeycode;
-	input_set_drvdata(input_dev, ir_dev);
-	ir_dev->input_dev = input_dev;
-
-	spin_lock_init(&ir_dev->rc_tab.lock);
-	spin_lock_init(&ir_dev->keylock);
-	setup_timer(&ir_dev->timer_keyup, ir_timer_keyup, (unsigned long)ir_dev);
-
-	if (props) {
-		ir_dev->props = props;
-		if (props->open)
-			input_dev->open = ir_open;
-		if (props->close)
-			input_dev->close = ir_close;
-	}
-
-	set_bit(EV_KEY, input_dev->evbit);
-	set_bit(EV_REP, input_dev->evbit);
-	set_bit(EV_MSC, input_dev->evbit);
-	set_bit(MSC_SCAN, input_dev->mscbit);
-
-	rc = ir_setkeytable(ir_dev, rc_tab);
-	if (rc)
-		goto out_name;
-
-	rc = ir_register_class(input_dev);
-	if (rc < 0)
-		goto out_table;
-
-	if (ir_dev->props)
-		if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW) {
-			rc = ir_raw_event_register(input_dev);
-			if (rc < 0)
-				goto out_event;
-		}
-
-	rc = ir_register_input(input_dev);
-	if (rc < 0)
-		goto out_event;
-
-	IR_dprintk(1, "Registered input device on %s for %s remote%s.\n",
-		   driver_name, rc_tab->name,
-		   (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_IR_RAW) ?
-			" in raw mode" : "");
-
-	/*
-	 * Default delay of 250ms is too short for some protocols, expecially
-	 * since the timeout is currently set to 250ms. Increase it to 500ms,
-	 * to avoid wrong repetition of the keycodes.
-	 */
-	input_dev->rep[REP_DELAY] = 500;
-
-	return 0;
-
-out_event:
-	ir_unregister_class(input_dev);
-out_table:
-	ir_free_table(&ir_dev->rc_tab);
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
-
-	if (!ir_dev)
-		return;
-
-	IR_dprintk(1, "Freed keycode table\n");
-
-	del_timer_sync(&ir_dev->timer_keyup);
-	if (ir_dev->props)
-		if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW)
-			ir_raw_event_unregister(input_dev);
-
-	ir_free_table(&ir_dev->rc_tab);
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
index a06a07e..0000000
--- a/drivers/media/IR/ir-raw-event.c
+++ /dev/null
@@ -1,382 +0,0 @@
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
-#include <linux/kthread.h>
-#include <linux/mutex.h>
-#include <linux/sched.h>
-#include <linux/freezer.h>
-#include "ir-core-priv.h"
-
-/* Define the max number of pulse/space transitions to buffer */
-#define MAX_IR_EVENT_SIZE      512
-
-/* Used to keep track of IR raw clients, protected by ir_raw_handler_lock */
-static LIST_HEAD(ir_raw_client_list);
-
-/* Used to handle IR raw handler extensions */
-static DEFINE_MUTEX(ir_raw_handler_lock);
-static LIST_HEAD(ir_raw_handler_list);
-static u64 available_protocols;
-
-#ifdef MODULE
-/* Used to load the decoders */
-static struct work_struct wq_load;
-#endif
-
-static int ir_raw_event_thread(void *data)
-{
-	struct ir_raw_event ev;
-	struct ir_raw_handler *handler;
-	struct ir_raw_event_ctrl *raw = (struct ir_raw_event_ctrl *)data;
-	int retval;
-
-	while (!kthread_should_stop()) {
-
-		spin_lock_irq(&raw->lock);
-		retval = kfifo_out(&raw->kfifo, &ev, sizeof(ev));
-
-		if (!retval) {
-			set_current_state(TASK_INTERRUPTIBLE);
-
-			if (kthread_should_stop())
-				set_current_state(TASK_RUNNING);
-
-			spin_unlock_irq(&raw->lock);
-			schedule();
-			continue;
-		}
-
-		spin_unlock_irq(&raw->lock);
-
-
-		BUG_ON(retval != sizeof(ev));
-
-		mutex_lock(&ir_raw_handler_lock);
-		list_for_each_entry(handler, &ir_raw_handler_list, list)
-			handler->decode(raw->input_dev, ev);
-		raw->prev_ev = ev;
-		mutex_unlock(&ir_raw_handler_lock);
-	}
-
-	return 0;
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
-	IR_dprintk(2, "sample: (%05dus %s)\n",
-		TO_US(ev->duration), TO_STR(ev->pulse));
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
- * ir_raw_event_store_with_filter() - pass next pulse/space to decoders with some processing
- * @input_dev:	the struct input_dev device descriptor
- * @type:	the type of the event that has occurred
- *
- * This routine (which may be called from an interrupt context) works
- * in similiar manner to ir_raw_event_store_edge.
- * This routine is intended for devices with limited internal buffer
- * It automerges samples of same type, and handles timeouts
- */
-int ir_raw_event_store_with_filter(struct input_dev *input_dev,
-						struct ir_raw_event *ev)
-{
-	struct ir_input_dev *ir = input_get_drvdata(input_dev);
-	struct ir_raw_event_ctrl *raw = ir->raw;
-
-	if (!raw || !ir->props)
-		return -EINVAL;
-
-	/* Ignore spaces in idle mode */
-	if (ir->idle && !ev->pulse)
-		return 0;
-	else if (ir->idle)
-		ir_raw_event_set_idle(input_dev, false);
-
-	if (!raw->this_ev.duration) {
-		raw->this_ev = *ev;
-	} else if (ev->pulse == raw->this_ev.pulse) {
-		raw->this_ev.duration += ev->duration;
-	} else {
-		ir_raw_event_store(input_dev, &raw->this_ev);
-		raw->this_ev = *ev;
-	}
-
-	/* Enter idle mode if nessesary */
-	if (!ev->pulse && ir->props->timeout &&
-		raw->this_ev.duration >= ir->props->timeout) {
-		ir_raw_event_set_idle(input_dev, true);
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
-
-/**
- * ir_raw_event_set_idle() - hint the ir core if device is receiving
- * IR data or not
- * @input_dev: the struct input_dev device descriptor
- * @idle: the hint value
- */
-void ir_raw_event_set_idle(struct input_dev *input_dev, bool idle)
-{
-	struct ir_input_dev *ir = input_get_drvdata(input_dev);
-	struct ir_raw_event_ctrl *raw = ir->raw;
-
-	if (!ir->props || !ir->raw)
-		return;
-
-	IR_dprintk(2, "%s idle mode\n", idle ? "enter" : "leave");
-
-	if (idle) {
-		raw->this_ev.timeout = true;
-		ir_raw_event_store(input_dev, &raw->this_ev);
-		init_ir_raw_event(&raw->this_ev);
-	}
-
-	if (ir->props->s_idle)
-		ir->props->s_idle(ir->props->priv, idle);
-	ir->idle = idle;
-}
-EXPORT_SYMBOL_GPL(ir_raw_event_set_idle);
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
-	unsigned long flags;
-
-	if (!ir->raw)
-		return;
-
-	spin_lock_irqsave(&ir->raw->lock, flags);
-	wake_up_process(ir->raw->thread);
-	spin_unlock_irqrestore(&ir->raw->lock, flags);
-}
-EXPORT_SYMBOL_GPL(ir_raw_event_handle);
-
-/* used internally by the sysfs interface */
-u64
-ir_raw_get_allowed_protocols()
-{
-	u64 protocols;
-	mutex_lock(&ir_raw_handler_lock);
-	protocols = available_protocols;
-	mutex_unlock(&ir_raw_handler_lock);
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
-
-	ir->raw->enabled_protocols = ~0;
-	rc = kfifo_alloc(&ir->raw->kfifo, sizeof(s64) * MAX_IR_EVENT_SIZE,
-			 GFP_KERNEL);
-	if (rc < 0) {
-		kfree(ir->raw);
-		ir->raw = NULL;
-		return rc;
-	}
-
-	spin_lock_init(&ir->raw->lock);
-	ir->raw->thread = kthread_run(ir_raw_event_thread, ir->raw,
-			"rc%u",  (unsigned int)ir->devno);
-
-	if (IS_ERR(ir->raw->thread)) {
-		int ret = PTR_ERR(ir->raw->thread);
-
-		kfree(ir->raw);
-		ir->raw = NULL;
-		return ret;
-	}
-
-	mutex_lock(&ir_raw_handler_lock);
-	list_add_tail(&ir->raw->list, &ir_raw_client_list);
-	list_for_each_entry(handler, &ir_raw_handler_list, list)
-		if (handler->raw_register)
-			handler->raw_register(ir->raw->input_dev);
-	mutex_unlock(&ir_raw_handler_lock);
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
-	kthread_stop(ir->raw->thread);
-
-	mutex_lock(&ir_raw_handler_lock);
-	list_del(&ir->raw->list);
-	list_for_each_entry(handler, &ir_raw_handler_list, list)
-		if (handler->raw_unregister)
-			handler->raw_unregister(ir->raw->input_dev);
-	mutex_unlock(&ir_raw_handler_lock);
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
-	mutex_lock(&ir_raw_handler_lock);
-	list_add_tail(&ir_raw_handler->list, &ir_raw_handler_list);
-	if (ir_raw_handler->raw_register)
-		list_for_each_entry(raw, &ir_raw_client_list, list)
-			ir_raw_handler->raw_register(raw->input_dev);
-	available_protocols |= ir_raw_handler->protocols;
-	mutex_unlock(&ir_raw_handler_lock);
-
-	return 0;
-}
-EXPORT_SYMBOL(ir_raw_handler_register);
-
-void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
-{
-	struct ir_raw_event_ctrl *raw;
-
-	mutex_lock(&ir_raw_handler_lock);
-	list_del(&ir_raw_handler->list);
-	if (ir_raw_handler->raw_unregister)
-		list_for_each_entry(raw, &ir_raw_client_list, list)
-			ir_raw_handler->raw_unregister(raw->input_dev);
-	available_protocols &= ~ir_raw_handler->protocols;
-	mutex_unlock(&ir_raw_handler_lock);
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
index 38423a8..0000000
--- a/drivers/media/IR/ir-sysfs.c
+++ /dev/null
@@ -1,362 +0,0 @@
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
-static struct {
-	u64	type;
-	char	*name;
-} proto_names[] = {
-	{ IR_TYPE_UNKNOWN,	"unknown"	},
-	{ IR_TYPE_RC5,		"rc-5"		},
-	{ IR_TYPE_NEC,		"nec"		},
-	{ IR_TYPE_RC6,		"rc-6"		},
-	{ IR_TYPE_JVC,		"jvc"		},
-	{ IR_TYPE_SONY,		"sony"		},
-	{ IR_TYPE_RC5_SZ,	"rc-5-sz"	},
-	{ IR_TYPE_LIRC,		"lirc"		},
-};
-
-#define PROTO_NONE	"none"
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
-	int i;
-
-	/* Device is being removed */
-	if (!ir_dev)
-		return -EINVAL;
-
-	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
-		enabled = ir_dev->rc_tab.ir_type;
-		allowed = ir_dev->props->allowed_protos;
-	} else if (ir_dev->raw) {
-		enabled = ir_dev->raw->enabled_protocols;
-		allowed = ir_raw_get_allowed_protocols();
-	} else
-		return sprintf(tmp, "[builtin]\n");
-
-	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
-		   (long long)allowed,
-		   (long long)enabled);
-
-	for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
-		if (allowed & enabled & proto_names[i].type)
-			tmp += sprintf(tmp, "[%s] ", proto_names[i].name);
-		else if (allowed & proto_names[i].type)
-			tmp += sprintf(tmp, "%s ", proto_names[i].name);
-	}
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
- * Writing "none" will disable all protocols.
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
-	int rc, i, count = 0;
-	unsigned long flags;
-
-	/* Device is being removed */
-	if (!ir_dev)
-		return -EINVAL;
-
-	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
-		type = ir_dev->rc_tab.ir_type;
-	else if (ir_dev->raw)
-		type = ir_dev->raw->enabled_protocols;
-	else {
-		IR_dprintk(1, "Protocol switching not supported\n");
-		return -EINVAL;
-	}
-
-	while ((tmp = strsep((char **) &data, " \n")) != NULL) {
-		if (!*tmp)
-			break;
-
-		if (*tmp == '+') {
-			enable = true;
-			disable = false;
-			tmp++;
-		} else if (*tmp == '-') {
-			enable = false;
-			disable = true;
-			tmp++;
-		} else {
-			enable = false;
-			disable = false;
-		}
-
-		if (!enable && !disable && !strncasecmp(tmp, PROTO_NONE, sizeof(PROTO_NONE))) {
-			tmp += sizeof(PROTO_NONE);
-			mask = 0;
-			count++;
-		} else {
-			for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
-				if (!strncasecmp(tmp, proto_names[i].name, strlen(proto_names[i].name))) {
-					tmp += strlen(proto_names[i].name);
-					mask = proto_names[i].type;
-					break;
-				}
-			}
-			if (i == ARRAY_SIZE(proto_names)) {
-				IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
-				return -EINVAL;
-			}
-			count++;
-		}
-
-		if (enable)
-			type |= mask;
-		else if (disable)
-			type &= ~mask;
-		else
-			type = mask;
-	}
-
-	if (!count) {
-		IR_dprintk(1, "Protocol not specified\n");
-		return -EINVAL;
-	}
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
-	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
-		spin_lock_irqsave(&ir_dev->rc_tab.lock, flags);
-		ir_dev->rc_tab.ir_type = type;
-		spin_unlock_irqrestore(&ir_dev->rc_tab.lock, flags);
-	} else {
-		ir_dev->raw->enabled_protocols = type;
-	}
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
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	int devno = find_first_zero_bit(&ir_core_dev_number,
-					IRRCV_NUM_DEVICES);
-
-	if (unlikely(devno < 0))
-		return devno;
-
-	ir_dev->dev.type = &rc_dev_type;
-	ir_dev->devno = devno;
-
-	ir_dev->dev.class = &ir_input_class;
-	ir_dev->dev.parent = input_dev->dev.parent;
-	input_dev->dev.parent = &ir_dev->dev;
-	dev_set_name(&ir_dev->dev, "rc%d", devno);
-	dev_set_drvdata(&ir_dev->dev, ir_dev);
-	return  device_register(&ir_dev->dev);
-};
-
-/**
- * ir_register_input - registers ir input device with input subsystem
- * @input_dev:	the struct input_dev descriptor of the device
- */
-
-int ir_register_input(struct input_dev *input_dev)
-{
-	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	int rc;
-	const char *path;
-
-
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
-	set_bit(ir_dev->devno, &ir_core_dev_number);
-	return 0;
-}
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
-	input_set_drvdata(input_dev, NULL);
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
-	ir_rcmap_init();
-
-	return 0;
-}
-
-static void __exit ir_core_exit(void)
-{
-	class_unregister(&ir_input_class);
-	ir_rcmap_cleanup();
-}
-
-module_init(ir_core_init);
-module_exit(ir_core_exit);
diff --git a/drivers/media/IR/rc-main.c b/drivers/media/IR/rc-main.c
new file mode 100644
index 0000000..6cba4b5
--- /dev/null
+++ b/drivers/media/IR/rc-main.c
@@ -0,0 +1,1199 @@
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
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include "ir-core-priv.h"
+
+#define IRRCV_NUM_DEVICES	256
+
+/* bit array to represent IR sysfs device number */
+static unsigned long ir_core_dev_number;
+
+/* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
+#define IR_TAB_MIN_SIZE	256
+#define IR_TAB_MAX_SIZE	8192
+
+/* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
+#define IR_KEYPRESS_TIMEOUT 250
+
+/* Used to keep track of known keymaps */
+static LIST_HEAD(rc_map_list);
+static DEFINE_SPINLOCK(rc_map_lock);
+
+/* Forward declarations */
+static int ir_register_class(struct input_dev *input_dev);
+static void ir_unregister_class(struct input_dev *input_dev);
+static int ir_register_input(struct input_dev *input_dev)
+
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
+
+static struct ir_scancode empty[] = {
+	{ 0x2a, KEY_COFFEE },
+};
+
+static struct rc_keymap empty_map = {
+	.map = {
+		.scan    = empty,
+		.size    = ARRAY_SIZE(empty),
+		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.name    = RC_MAP_EMPTY,
+	}
+};
+
+/**
+ * ir_create_table() - initializes a scancode table
+ * @rc_tab:	the ir_scancode_table to initialize
+ * @name:	name to assign to the table
+ * @ir_type:	ir type to assign to the new table
+ * @size:	initial size of the table
+ * @return:	zero on success or a negative error code
+ *
+ * This routine will initialize the ir_scancode_table and will allocate
+ * memory to hold at least the specified number elements.
+ */
+static int ir_create_table(struct ir_scancode_table *rc_tab,
+			   const char *name, u64 ir_type, size_t size)
+{
+	rc_tab->name = name;
+	rc_tab->ir_type = ir_type;
+	rc_tab->alloc = roundup_pow_of_two(size * sizeof(struct ir_scancode));
+	rc_tab->size = rc_tab->alloc / sizeof(struct ir_scancode);
+	rc_tab->scan = kmalloc(rc_tab->alloc, GFP_KERNEL);
+	if (!rc_tab->scan)
+		return -ENOMEM;
+
+	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
+		   rc_tab->size, rc_tab->alloc);
+	return 0;
+}
+
+/**
+ * ir_free_table() - frees memory allocated by a scancode table
+ * @rc_tab:	the table whose mappings need to be freed
+ *
+ * This routine will free memory alloctaed for key mappings used by given
+ * scancode table.
+ */
+static void ir_free_table(struct ir_scancode_table *rc_tab)
+{
+	rc_tab->size = 0;
+	kfree(rc_tab->scan);
+	rc_tab->scan = NULL;
+}
+
+/**
+ * ir_resize_table() - resizes a scancode table if necessary
+ * @rc_tab:	the ir_scancode_table to resize
+ * @gfp_flags:	gfp flags to use when allocating memory
+ * @return:	zero on success or a negative error code
+ *
+ * This routine will shrink the ir_scancode_table if it has lots of
+ * unused entries and grow it if it is full.
+ */
+static int ir_resize_table(struct ir_scancode_table *rc_tab, gfp_t gfp_flags)
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
+	newscan = kmalloc(newalloc, gfp_flags);
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
+ * ir_update_mapping() - set a keycode in the scancode->keycode table
+ * @dev:	the struct input_dev device descriptor
+ * @rc_tab:	scancode table to be adjusted
+ * @index:	index of the mapping that needs to be updated
+ * @keycode:	the desired keycode
+ * @return:	previous keycode assigned to the mapping
+ *
+ * This routine is used to update scancode->keycopde mapping at given
+ * position.
+ */
+static unsigned int ir_update_mapping(struct input_dev *dev,
+				      struct ir_scancode_table *rc_tab,
+				      unsigned int index,
+				      unsigned int new_keycode)
+{
+	int old_keycode = rc_tab->scan[index].keycode;
+	int i;
+
+	/* Did the user wish to remove the mapping? */
+	if (new_keycode == KEY_RESERVED || new_keycode == KEY_UNKNOWN) {
+		IR_dprintk(1, "#%d: Deleting scan 0x%04x\n",
+			   index, rc_tab->scan[index].scancode);
+		rc_tab->len--;
+		memmove(&rc_tab->scan[index], &rc_tab->scan[index+ 1],
+			(rc_tab->len - index) * sizeof(struct ir_scancode));
+	} else {
+		IR_dprintk(1, "#%d: %s scan 0x%04x with key 0x%04x\n",
+			   index,
+			   old_keycode == KEY_RESERVED ? "New" : "Replacing",
+			   rc_tab->scan[index].scancode, new_keycode);
+		rc_tab->scan[index].keycode = new_keycode;
+		__set_bit(new_keycode, dev->keybit);
+	}
+
+	if (old_keycode != KEY_RESERVED) {
+		/* A previous mapping was updated... */
+		__clear_bit(old_keycode, dev->keybit);
+		/* ... but another scancode might use the same keycode */
+		for (i = 0; i < rc_tab->len; i++) {
+			if (rc_tab->scan[i].keycode == old_keycode) {
+				__set_bit(old_keycode, dev->keybit);
+				break;
+			}
+		}
+
+		/* Possibly shrink the keytable, failure is not a problem */
+		ir_resize_table(rc_tab, GFP_ATOMIC);
+	}
+
+	return old_keycode;
+}
+
+/**
+ * ir_establish_scancode() - set a keycode in the scancode->keycode table
+ * @ir_dev:	the struct ir_input_dev device descriptor
+ * @rc_tab:	scancode table to be searched
+ * @scancode:	the desired scancode
+ * @resize:	controls whether we allowed to resize the table to
+ *		accomodate not yet present scancodes
+ * @return:	index of the mapping containing scancode in question
+ *		or -1U in case of failure.
+ *
+ * This routine is used to locate given scancode in ir_scancode_table.
+ * If scancode is not yet present the routine will allocate a new slot
+ * for it.
+ */
+static unsigned int ir_establish_scancode(struct ir_input_dev *ir_dev,
+					  struct ir_scancode_table *rc_tab,
+					  unsigned int scancode,
+					  bool resize)
+{
+	unsigned int i;
+
+	/*
+	 * Unfortunately, some hardware-based IR decoders don't provide
+	 * all bits for the complete IR code. In general, they provide only
+	 * the command part of the IR code. Yet, as it is possible to replace
+	 * the provided IR with another one, it is needed to allow loading
+	 * IR tables from other remotes. So,
+	 */
+	if (ir_dev->props && ir_dev->props->scanmask)
+		scancode &= ir_dev->props->scanmask;
+
+	/* First check if we already have a mapping for this ir command */
+	for (i = 0; i < rc_tab->len; i++) {
+		if (rc_tab->scan[i].scancode == scancode)
+			return i;
+
+		/* Keytable is sorted from lowest to highest scancode */
+		if (rc_tab->scan[i].scancode >= scancode)
+			break;
+	}
+
+	/* No previous mapping found, we might need to grow the table */
+	if (rc_tab->size == rc_tab->len) {
+		if (!resize || ir_resize_table(rc_tab, GFP_ATOMIC))
+			return -1U;
+	}
+
+	/* i is the proper index to insert our new keycode */
+	if (i < rc_tab->len)
+		memmove(&rc_tab->scan[i + 1], &rc_tab->scan[i],
+			(rc_tab->len - i) * sizeof(struct ir_scancode));
+	rc_tab->scan[i].scancode = scancode;
+	rc_tab->scan[i].keycode = KEY_RESERVED;
+	rc_tab->len++;
+
+	return i;
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
+			 const struct input_keymap_entry *ke,
+			 unsigned int *old_keycode)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
+	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
+	unsigned int index;
+	unsigned int scancode;
+	int retval;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rc_tab->lock, flags);
+
+	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
+		index = ke->index;
+		if (index >= rc_tab->len) {
+			retval = -EINVAL;
+			goto out;
+		}
+	} else {
+		retval = input_scancode_to_scalar(ke, &scancode);
+		if (retval)
+			goto out;
+
+		index = ir_establish_scancode(ir_dev, rc_tab, scancode, true);
+		if (index >= rc_tab->len) {
+			retval = -ENOMEM;
+			goto out;
+		}
+	}
+
+	*old_keycode = ir_update_mapping(dev, rc_tab, index, ke->keycode);
+
+out:
+	spin_unlock_irqrestore(&rc_tab->lock, flags);
+	return retval;
+}
+
+/**
+ * ir_setkeytable() - sets several entries in the scancode->keycode table
+ * @dev:	the struct input_dev device descriptor
+ * @to:		the struct ir_scancode_table to copy entries to
+ * @from:	the struct ir_scancode_table to copy entries from
+ * @return:	-ENOMEM if all keycodes could not be inserted, otherwise zero.
+ *
+ * This routine is used to handle table initialization.
+ */
+static int ir_setkeytable(struct ir_input_dev *ir_dev,
+			  const struct ir_scancode_table *from)
+{
+	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
+	unsigned int i, index;
+	int rc;
+
+	rc = ir_create_table(&ir_dev->rc_tab,
+			     from->name, from->ir_type, from->size);
+	if (rc)
+		return rc;
+
+	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
+		   rc_tab->size, rc_tab->alloc);
+
+	for (i = 0; i < from->size; i++) {
+		index = ir_establish_scancode(ir_dev, rc_tab,
+					      from->scan[i].scancode, false);
+		if (index >= rc_tab->len) {
+			rc = -ENOMEM;
+			break;
+		}
+
+		ir_update_mapping(ir_dev->input_dev, rc_tab, index,
+				  from->scan[i].keycode);
+	}
+
+	if (rc)
+		ir_free_table(rc_tab);
+
+	return rc;
+}
+
+/**
+ * ir_lookup_by_scancode() - locate mapping by scancode
+ * @rc_tab:	the &struct ir_scancode_table to search
+ * @scancode:	scancode to look for in the table
+ * @return:	index in the table, -1U if not found
+ *
+ * This routine performs binary search in RC keykeymap table for
+ * given scancode.
+ */
+static unsigned int ir_lookup_by_scancode(const struct ir_scancode_table *rc_tab,
+					  unsigned int scancode)
+{
+	int start = 0;
+	int end = rc_tab->len - 1;
+	int mid;
+
+	while (start <= end) {
+		mid = (start + end) / 2;
+		if (rc_tab->scan[mid].scancode < scancode)
+			start = mid + 1;
+		else if (rc_tab->scan[mid].scancode > scancode)
+			end = mid - 1;
+		else
+			return mid;
+	}
+
+	return -1U;
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
+			 struct input_keymap_entry *ke)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
+	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
+	struct ir_scancode *entry;
+	unsigned long flags;
+	unsigned int index;
+	unsigned int scancode;
+	int retval;
+
+	spin_lock_irqsave(&rc_tab->lock, flags);
+
+	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
+		index = ke->index;
+	} else {
+		retval = input_scancode_to_scalar(ke, &scancode);
+		if (retval)
+			goto out;
+
+		index = ir_lookup_by_scancode(rc_tab, scancode);
+	}
+
+	if (index >= rc_tab->len) {
+		if (!(ke->flags & INPUT_KEYMAP_BY_INDEX))
+			IR_dprintk(1, "unknown key for scancode 0x%04x\n",
+				   scancode);
+		retval = -EINVAL;
+		goto out;
+	}
+
+	entry = &rc_tab->scan[index];
+
+	ke->index = index;
+	ke->keycode = entry->keycode;
+	ke->len = sizeof(entry->scancode);
+	memcpy(ke->scancode, &entry->scancode, sizeof(entry->scancode));
+
+	retval = 0;
+
+out:
+	spin_unlock_irqrestore(&rc_tab->lock, flags);
+	return retval;
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
+	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
+	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
+	unsigned int keycode;
+	unsigned int index;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rc_tab->lock, flags);
+
+	index = ir_lookup_by_scancode(rc_tab, scancode);
+	keycode = index < rc_tab->len ?
+			rc_tab->scan[index].keycode : KEY_RESERVED;
+
+	spin_unlock_irqrestore(&rc_tab->lock, flags);
+
+	if (keycode != KEY_RESERVED)
+		IR_dprintk(1, "%s: scancode 0x%04x keycode 0x%02x\n",
+			   dev->name, scancode, keycode);
+
+	return keycode;
+}
+EXPORT_SYMBOL_GPL(ir_g_keycode_from_table);
+
+/**
+ * ir_do_keyup() - internal function to signal the release of a keypress
+ * @ir:         the struct ir_input_dev descriptor of the device
+ *
+ * This function is used internally to release a keypress, it must be
+ * called with keylock held.
+ */
+static void ir_do_keyup(struct ir_input_dev *ir)
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
+ * ir_keyup() - generates input event to signal the release of a keypress
+ * @dev:        the struct input_dev descriptor of the device
+ *
+ * This routine is used to signal that a key has been released on the
+ * remote control.
+ */
+void ir_keyup(struct input_dev *dev)
+{
+	unsigned long flags;
+	struct ir_input_dev *ir = input_get_drvdata(dev);
+
+	spin_lock_irqsave(&ir->keylock, flags);
+	ir_do_keyup(ir);
+	spin_unlock_irqrestore(&ir->keylock, flags);
+}
+EXPORT_SYMBOL_GPL(ir_keyup);
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
+	if (time_is_before_eq_jiffies(ir->keyup_jiffies))
+		ir_do_keyup(ir);
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
+	input_event(dev, EV_MSC, MSC_SCAN, ir->last_scancode);
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
+ * ir_do_keydown() - internal function to process a keypress
+ * @dev:        the struct input_dev descriptor of the device
+ * @scancode:   the scancode of the keypress
+ * @keycode:    the keycode of the keypress
+ * @toggle:     the toggle value of the keypress
+ *
+ * This function is used internally to register a keypress, it must be
+ * called with keylock held.
+ */
+static void ir_do_keydown(struct input_dev *dev, int scancode,
+			  u32 keycode, u8 toggle)
+{
+	struct ir_input_dev *ir = input_get_drvdata(dev);
+
+	input_event(dev, EV_MSC, MSC_SCAN, scancode);
+
+	/* Repeat event? */
+	if (ir->keypressed &&
+	    ir->last_scancode == scancode &&
+	    ir->last_toggle == toggle)
+		return;
+
+	/* Release old keypress */
+	ir_do_keyup(ir);
+
+	ir->last_scancode = scancode;
+	ir->last_toggle = toggle;
+	ir->last_keycode = keycode;
+
+	if (keycode == KEY_RESERVED)
+		return;
+
+	/* Register a keypress */
+	ir->keypressed = true;
+	IR_dprintk(1, "%s: key down event, key 0x%04x, scancode 0x%04x\n",
+		   dev->name, keycode, scancode);
+	input_report_key(dev, ir->last_keycode, 1);
+	input_sync(dev);
+}
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
+	u32 keycode = ir_g_keycode_from_table(dev, scancode);
+
+	spin_lock_irqsave(&ir->keylock, flags);
+	ir_do_keydown(dev, scancode, keycode, toggle);
+
+	if (ir->keypressed) {
+		ir->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+		mod_timer(&ir->timer_keyup, ir->keyup_jiffies);
+	}
+	spin_unlock_irqrestore(&ir->keylock, flags);
+}
+EXPORT_SYMBOL_GPL(ir_keydown);
+
+/**
+ * ir_keydown_notimeout() - generates input event for a key press without
+ *                          an automatic keyup event at a later time
+ * @dev:        the struct input_dev descriptor of the device
+ * @scancode:   the scancode that we're seeking
+ * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
+ *              support toggle values, this should be set to zero)
+ *
+ * This routine is used by the input routines when a key is pressed at the
+ * IR. It gets the keycode for a scancode and reports an input event via
+ * input_report_key(). The driver must manually call ir_keyup() at a later
+ * stage.
+ */
+void ir_keydown_notimeout(struct input_dev *dev, int scancode, u8 toggle)
+{
+	unsigned long flags;
+	struct ir_input_dev *ir = input_get_drvdata(dev);
+	u32 keycode = ir_g_keycode_from_table(dev, scancode);
+
+	spin_lock_irqsave(&ir->keylock, flags);
+	ir_do_keydown(dev, scancode, keycode, toggle);
+	spin_unlock_irqrestore(&ir->keylock, flags);
+}
+EXPORT_SYMBOL_GPL(ir_keydown_notimeout);
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
+		      struct ir_dev_props *props,
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
+	input_dev->getkeycode_new = ir_getkeycode;
+	input_dev->setkeycode_new = ir_setkeycode;
+	input_set_drvdata(input_dev, ir_dev);
+	ir_dev->input_dev = input_dev;
+
+	spin_lock_init(&ir_dev->rc_tab.lock);
+	spin_lock_init(&ir_dev->keylock);
+	setup_timer(&ir_dev->timer_keyup, ir_timer_keyup, (unsigned long)ir_dev);
+
+	if (props) {
+		ir_dev->props = props;
+		if (props->open)
+			input_dev->open = ir_open;
+		if (props->close)
+			input_dev->close = ir_close;
+	}
+
+	set_bit(EV_KEY, input_dev->evbit);
+	set_bit(EV_REP, input_dev->evbit);
+	set_bit(EV_MSC, input_dev->evbit);
+	set_bit(MSC_SCAN, input_dev->mscbit);
+
+	rc = ir_setkeytable(ir_dev, rc_tab);
+	if (rc)
+		goto out_name;
+
+	rc = ir_register_class(input_dev);
+	if (rc < 0)
+		goto out_table;
+
+	if (ir_dev->props)
+		if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW) {
+			rc = ir_raw_event_register(input_dev);
+			if (rc < 0)
+				goto out_event;
+		}
+
+	rc = ir_register_input(input_dev);
+	if (rc < 0)
+		goto out_event;
+
+	IR_dprintk(1, "Registered input device on %s for %s remote%s.\n",
+		   driver_name, rc_tab->name,
+		   (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_IR_RAW) ?
+			" in raw mode" : "");
+
+	/*
+	 * Default delay of 250ms is too short for some protocols, expecially
+	 * since the timeout is currently set to 250ms. Increase it to 500ms,
+	 * to avoid wrong repetition of the keycodes.
+	 */
+	input_dev->rep[REP_DELAY] = 500;
+
+	return 0;
+
+out_event:
+	ir_unregister_class(input_dev);
+out_table:
+	ir_free_table(&ir_dev->rc_tab);
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
+
+	if (!ir_dev)
+		return;
+
+	IR_dprintk(1, "Freed keycode table\n");
+
+	del_timer_sync(&ir_dev->timer_keyup);
+	if (ir_dev->props)
+		if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW)
+			ir_raw_event_unregister(input_dev);
+
+	ir_free_table(&ir_dev->rc_tab);
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
+static struct {
+	u64	type;
+	char	*name;
+} proto_names[] = {
+	{ IR_TYPE_UNKNOWN,	"unknown"	},
+	{ IR_TYPE_RC5,		"rc-5"		},
+	{ IR_TYPE_NEC,		"nec"		},
+	{ IR_TYPE_RC6,		"rc-6"		},
+	{ IR_TYPE_JVC,		"jvc"		},
+	{ IR_TYPE_SONY,		"sony"		},
+	{ IR_TYPE_RC5_SZ,	"rc-5-sz"	},
+	{ IR_TYPE_LIRC,		"lirc"		},
+};
+
+#define PROTO_NONE	"none"
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
+	int i;
+
+	/* Device is being removed */
+	if (!ir_dev)
+		return -EINVAL;
+
+	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
+		enabled = ir_dev->rc_tab.ir_type;
+		allowed = ir_dev->props->allowed_protos;
+	} else if (ir_dev->raw) {
+		enabled = ir_dev->raw->enabled_protocols;
+		allowed = ir_raw_get_allowed_protocols();
+	} else
+		return sprintf(tmp, "[builtin]\n");
+
+	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
+		   (long long)allowed,
+		   (long long)enabled);
+
+	for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
+		if (allowed & enabled & proto_names[i].type)
+			tmp += sprintf(tmp, "[%s] ", proto_names[i].name);
+		else if (allowed & proto_names[i].type)
+			tmp += sprintf(tmp, "%s ", proto_names[i].name);
+	}
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
+ * Writing "none" will disable all protocols.
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
+	int rc, i, count = 0;
+	unsigned long flags;
+
+	/* Device is being removed */
+	if (!ir_dev)
+		return -EINVAL;
+
+	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE)
+		type = ir_dev->rc_tab.ir_type;
+	else if (ir_dev->raw)
+		type = ir_dev->raw->enabled_protocols;
+	else {
+		IR_dprintk(1, "Protocol switching not supported\n");
+		return -EINVAL;
+	}
+
+	while ((tmp = strsep((char **) &data, " \n")) != NULL) {
+		if (!*tmp)
+			break;
+
+		if (*tmp == '+') {
+			enable = true;
+			disable = false;
+			tmp++;
+		} else if (*tmp == '-') {
+			enable = false;
+			disable = true;
+			tmp++;
+		} else {
+			enable = false;
+			disable = false;
+		}
+
+		if (!enable && !disable && !strncasecmp(tmp, PROTO_NONE, sizeof(PROTO_NONE))) {
+			tmp += sizeof(PROTO_NONE);
+			mask = 0;
+			count++;
+		} else {
+			for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
+				if (!strncasecmp(tmp, proto_names[i].name, strlen(proto_names[i].name))) {
+					tmp += strlen(proto_names[i].name);
+					mask = proto_names[i].type;
+					break;
+				}
+			}
+			if (i == ARRAY_SIZE(proto_names)) {
+				IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
+				return -EINVAL;
+			}
+			count++;
+		}
+
+		if (enable)
+			type |= mask;
+		else if (disable)
+			type &= ~mask;
+		else
+			type = mask;
+	}
+
+	if (!count) {
+		IR_dprintk(1, "Protocol not specified\n");
+		return -EINVAL;
+	}
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
+	if (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_SCANCODE) {
+		spin_lock_irqsave(&ir_dev->rc_tab.lock, flags);
+		ir_dev->rc_tab.ir_type = type;
+		spin_unlock_irqrestore(&ir_dev->rc_tab.lock, flags);
+	} else {
+		ir_dev->raw->enabled_protocols = type;
+	}
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
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	int devno = find_first_zero_bit(&ir_core_dev_number,
+					IRRCV_NUM_DEVICES);
+
+	if (unlikely(devno < 0))
+		return devno;
+
+	ir_dev->dev.type = &rc_dev_type;
+	ir_dev->devno = devno;
+
+	ir_dev->dev.class = &ir_input_class;
+	ir_dev->dev.parent = input_dev->dev.parent;
+	input_dev->dev.parent = &ir_dev->dev;
+	dev_set_name(&ir_dev->dev, "rc%d", devno);
+	dev_set_drvdata(&ir_dev->dev, ir_dev);
+	return  device_register(&ir_dev->dev);
+};
+
+/**
+ * ir_register_input - registers ir input device with input subsystem
+ * @input_dev:	the struct input_dev descriptor of the device
+ */
+
+static int ir_register_input(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	int rc;
+	const char *path;
+
+
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
+	set_bit(ir_dev->devno, &ir_core_dev_number);
+	return 0;
+}
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
+	input_set_drvdata(input_dev, NULL);
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
+	ir_register_map(&empty_map);
+
+	return 0;
+}
+
+static void __exit ir_core_exit(void)
+{
+	class_unregister(&ir_input_class);
+	ir_unregister_map(&empty_map);
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
index 689143f..0000000
--- a/drivers/media/IR/rc-map.c
+++ /dev/null
@@ -1,107 +0,0 @@
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
-
-static struct ir_scancode empty[] = {
-	{ 0x2a, KEY_COFFEE },
-};
-
-static struct rc_keymap empty_map = {
-	.map = {
-		.scan    = empty,
-		.size    = ARRAY_SIZE(empty),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_EMPTY,
-	}
-};
-
-int ir_rcmap_init(void)
-{
-	return ir_register_map(&empty_map);
-}
-
-void ir_rcmap_cleanup(void)
-{
-	ir_unregister_map(&empty_map);
-}
diff --git a/drivers/media/IR/rc-raw.c b/drivers/media/IR/rc-raw.c
new file mode 100644
index 0000000..a06a07e
--- /dev/null
+++ b/drivers/media/IR/rc-raw.c
@@ -0,0 +1,382 @@
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
+#include <linux/kthread.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/freezer.h>
+#include "ir-core-priv.h"
+
+/* Define the max number of pulse/space transitions to buffer */
+#define MAX_IR_EVENT_SIZE      512
+
+/* Used to keep track of IR raw clients, protected by ir_raw_handler_lock */
+static LIST_HEAD(ir_raw_client_list);
+
+/* Used to handle IR raw handler extensions */
+static DEFINE_MUTEX(ir_raw_handler_lock);
+static LIST_HEAD(ir_raw_handler_list);
+static u64 available_protocols;
+
+#ifdef MODULE
+/* Used to load the decoders */
+static struct work_struct wq_load;
+#endif
+
+static int ir_raw_event_thread(void *data)
+{
+	struct ir_raw_event ev;
+	struct ir_raw_handler *handler;
+	struct ir_raw_event_ctrl *raw = (struct ir_raw_event_ctrl *)data;
+	int retval;
+
+	while (!kthread_should_stop()) {
+
+		spin_lock_irq(&raw->lock);
+		retval = kfifo_out(&raw->kfifo, &ev, sizeof(ev));
+
+		if (!retval) {
+			set_current_state(TASK_INTERRUPTIBLE);
+
+			if (kthread_should_stop())
+				set_current_state(TASK_RUNNING);
+
+			spin_unlock_irq(&raw->lock);
+			schedule();
+			continue;
+		}
+
+		spin_unlock_irq(&raw->lock);
+
+
+		BUG_ON(retval != sizeof(ev));
+
+		mutex_lock(&ir_raw_handler_lock);
+		list_for_each_entry(handler, &ir_raw_handler_list, list)
+			handler->decode(raw->input_dev, ev);
+		raw->prev_ev = ev;
+		mutex_unlock(&ir_raw_handler_lock);
+	}
+
+	return 0;
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
+	IR_dprintk(2, "sample: (%05dus %s)\n",
+		TO_US(ev->duration), TO_STR(ev->pulse));
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
+ * ir_raw_event_store_with_filter() - pass next pulse/space to decoders with some processing
+ * @input_dev:	the struct input_dev device descriptor
+ * @type:	the type of the event that has occurred
+ *
+ * This routine (which may be called from an interrupt context) works
+ * in similiar manner to ir_raw_event_store_edge.
+ * This routine is intended for devices with limited internal buffer
+ * It automerges samples of same type, and handles timeouts
+ */
+int ir_raw_event_store_with_filter(struct input_dev *input_dev,
+						struct ir_raw_event *ev)
+{
+	struct ir_input_dev *ir = input_get_drvdata(input_dev);
+	struct ir_raw_event_ctrl *raw = ir->raw;
+
+	if (!raw || !ir->props)
+		return -EINVAL;
+
+	/* Ignore spaces in idle mode */
+	if (ir->idle && !ev->pulse)
+		return 0;
+	else if (ir->idle)
+		ir_raw_event_set_idle(input_dev, false);
+
+	if (!raw->this_ev.duration) {
+		raw->this_ev = *ev;
+	} else if (ev->pulse == raw->this_ev.pulse) {
+		raw->this_ev.duration += ev->duration;
+	} else {
+		ir_raw_event_store(input_dev, &raw->this_ev);
+		raw->this_ev = *ev;
+	}
+
+	/* Enter idle mode if nessesary */
+	if (!ev->pulse && ir->props->timeout &&
+		raw->this_ev.duration >= ir->props->timeout) {
+		ir_raw_event_set_idle(input_dev, true);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
+
+/**
+ * ir_raw_event_set_idle() - hint the ir core if device is receiving
+ * IR data or not
+ * @input_dev: the struct input_dev device descriptor
+ * @idle: the hint value
+ */
+void ir_raw_event_set_idle(struct input_dev *input_dev, bool idle)
+{
+	struct ir_input_dev *ir = input_get_drvdata(input_dev);
+	struct ir_raw_event_ctrl *raw = ir->raw;
+
+	if (!ir->props || !ir->raw)
+		return;
+
+	IR_dprintk(2, "%s idle mode\n", idle ? "enter" : "leave");
+
+	if (idle) {
+		raw->this_ev.timeout = true;
+		ir_raw_event_store(input_dev, &raw->this_ev);
+		init_ir_raw_event(&raw->this_ev);
+	}
+
+	if (ir->props->s_idle)
+		ir->props->s_idle(ir->props->priv, idle);
+	ir->idle = idle;
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_set_idle);
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
+	unsigned long flags;
+
+	if (!ir->raw)
+		return;
+
+	spin_lock_irqsave(&ir->raw->lock, flags);
+	wake_up_process(ir->raw->thread);
+	spin_unlock_irqrestore(&ir->raw->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_handle);
+
+/* used internally by the sysfs interface */
+u64
+ir_raw_get_allowed_protocols()
+{
+	u64 protocols;
+	mutex_lock(&ir_raw_handler_lock);
+	protocols = available_protocols;
+	mutex_unlock(&ir_raw_handler_lock);
+	return protocols;
+}
+
+/*
+ * Used to (un)register raw event clients
+ */
+int ir_raw_event_register(struct input_dev *input_dev)
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
+
+	ir->raw->enabled_protocols = ~0;
+	rc = kfifo_alloc(&ir->raw->kfifo, sizeof(s64) * MAX_IR_EVENT_SIZE,
+			 GFP_KERNEL);
+	if (rc < 0) {
+		kfree(ir->raw);
+		ir->raw = NULL;
+		return rc;
+	}
+
+	spin_lock_init(&ir->raw->lock);
+	ir->raw->thread = kthread_run(ir_raw_event_thread, ir->raw,
+			"rc%u",  (unsigned int)ir->devno);
+
+	if (IS_ERR(ir->raw->thread)) {
+		int ret = PTR_ERR(ir->raw->thread);
+
+		kfree(ir->raw);
+		ir->raw = NULL;
+		return ret;
+	}
+
+	mutex_lock(&ir_raw_handler_lock);
+	list_add_tail(&ir->raw->list, &ir_raw_client_list);
+	list_for_each_entry(handler, &ir_raw_handler_list, list)
+		if (handler->raw_register)
+			handler->raw_register(ir->raw->input_dev);
+	mutex_unlock(&ir_raw_handler_lock);
+
+	return 0;
+}
+
+void ir_raw_event_unregister(struct input_dev *input_dev)
+{
+	struct ir_input_dev *ir = input_get_drvdata(input_dev);
+	struct ir_raw_handler *handler;
+
+	if (!ir->raw)
+		return;
+
+	kthread_stop(ir->raw->thread);
+
+	mutex_lock(&ir_raw_handler_lock);
+	list_del(&ir->raw->list);
+	list_for_each_entry(handler, &ir_raw_handler_list, list)
+		if (handler->raw_unregister)
+			handler->raw_unregister(ir->raw->input_dev);
+	mutex_unlock(&ir_raw_handler_lock);
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
+	mutex_lock(&ir_raw_handler_lock);
+	list_add_tail(&ir_raw_handler->list, &ir_raw_handler_list);
+	if (ir_raw_handler->raw_register)
+		list_for_each_entry(raw, &ir_raw_client_list, list)
+			ir_raw_handler->raw_register(raw->input_dev);
+	available_protocols |= ir_raw_handler->protocols;
+	mutex_unlock(&ir_raw_handler_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(ir_raw_handler_register);
+
+void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
+{
+	struct ir_raw_event_ctrl *raw;
+
+	mutex_lock(&ir_raw_handler_lock);
+	list_del(&ir_raw_handler->list);
+	if (ir_raw_handler->raw_unregister)
+		list_for_each_entry(raw, &ir_raw_client_list, list)
+			ir_raw_handler->raw_unregister(raw->input_dev);
+	available_protocols &= ~ir_raw_handler->protocols;
+	mutex_unlock(&ir_raw_handler_lock);
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
+void ir_raw_init(void)
+{
+#ifdef MODULE
+	INIT_WORK(&wq_load, init_decoders);
+	schedule_work(&wq_load);
+#endif
+}
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 53048a2..d41502d 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -117,7 +117,6 @@ enum raw_event_type {
 
 #define to_ir_input_dev(_attr) container_of(_attr, struct ir_input_dev, attr)
 
-/* From ir-keytable.c */
 int __ir_input_register(struct input_dev *dev,
 		      const struct ir_scancode_table *ir_codes,
 		      struct ir_dev_props *props,
@@ -164,7 +163,6 @@ void ir_keyup(struct input_dev *dev);
 u32 ir_g_keycode_from_table(struct input_dev *input_dev, u32 scancode);
 
 /* From ir-raw-event.c */
-
 struct ir_raw_event {
 	union {
 		u32             duration;

