Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:49048 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab0DBTDB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 15:03:01 -0400
Message-Id: <20100402190255.469258116@hardeman.nu>
Date: Fri, 02 Apr 2010 20:58:28 +0200
From: david@hardeman.nu
To: mchehab@infradead.org
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: [patch 1/3] [PATCH] drivers/media/IR - improve keytable code
References: <20100402185827.425741206@hardeman.nu>
Content-Disposition: inline; filename=improve-keytable-code.patch
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The attached patch rewrites much of the keytable code in
drivers/media/IR/ir-keytable.c.

The scancodes are now inserted into the array in sorted
order which allows for a binary search on lookup.

The code has also been shrunk by about 150 lines.

In addition it fixes the following bugs:

Any use of ir_seek_table() was racy.

ir_dev->driver_name is leaked between ir_input_register() and
ir_input_unregister().

ir_setkeycode() unconditionally does clear_bit() on dev->keybit
when removing a mapping, but there might be another mapping with
a different scancode and the same keycode.

This version has been updated to incorporate patch feedback from
Mauro Carvalho Chehab.

Signed-off-by: David Härdeman <david@hardeman.nu>

Index: ir/drivers/media/IR/ir-keymaps.c
===================================================================
--- ir.orig/drivers/media/IR/ir-keymaps.c	2010-04-01 17:38:16.777724334 +0200
+++ ir/drivers/media/IR/ir-keymaps.c	2010-04-02 12:23:14.952235145 +0200
@@ -39,6 +39,7 @@
 struct ir_scancode_table tabname ## _table = {			\
 	.scan = tabname,					\
 	.size = ARRAY_SIZE(tabname),				\
+	.len = ARRAY_SIZE(tabname),				\
 	.ir_type = type,					\
 	.name = #irname,					\
 };								\
Index: ir/drivers/media/IR/ir-keytable.c
===================================================================
--- ir.orig/drivers/media/IR/ir-keytable.c	2010-04-01 17:38:16.753724054 +0200
+++ ir/drivers/media/IR/ir-keytable.c	2010-04-02 12:32:13.015233729 +0200
@@ -16,344 +16,214 @@
 #include <linux/input.h>
 #include <media/ir-common.h>
 
-#define IR_TAB_MIN_SIZE	32
-#define IR_TAB_MAX_SIZE	1024
+/* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
+#define IR_TAB_MIN_SIZE	256
+#define IR_TAB_MAX_SIZE	8192
 
 /**
- * ir_seek_table() - returns the element order on the table
- * @rc_tab:	the ir_scancode_table with the keymap to be used
- * @scancode:	the scancode that we're seeking
+ * ir_resize_table() - resizes a scancode table if necessary
+ * @rc_tab:	the ir_scancode_table to resize
+ * @return:	zero on success or a negative error code
  *
- * This routine is used by the input routines when a key is pressed at the
- * IR. The scancode is received and needs to be converted into a keycode.
- * If the key is not found, it returns KEY_UNKNOWN. Otherwise, returns the
- * corresponding keycode from the table.
+ * This routine will shrink the ir_scancode_table if it has lots of
+ * unused entries and grow it if it is full.
  */
-static int ir_seek_table(struct ir_scancode_table *rc_tab, u32 scancode)
+static int ir_resize_table(struct ir_scancode_table *rc_tab)
 {
-	int rc;
-	unsigned long flags;
-	struct ir_scancode *keymap = rc_tab->scan;
-
-	spin_lock_irqsave(&rc_tab->lock, flags);
-
-	/* FIXME: replace it by a binary search */
+	unsigned int oldalloc = rc_tab->alloc;
+	unsigned int newalloc = oldalloc;
+	struct ir_scancode *oldscan = rc_tab->scan;
+	struct ir_scancode *newscan;
 
-	for (rc = 0; rc < rc_tab->size; rc++)
-		if (keymap[rc].scancode == scancode)
-			goto exit;
-
-	/* Not found */
-	rc = -EINVAL;
+	if (rc_tab->size == rc_tab->len) {
+		/* All entries in use -> grow keytable */
+		if (rc_tab->alloc >= IR_TAB_MAX_SIZE)
+			return -ENOMEM;
 
-exit:
-	spin_unlock_irqrestore(&rc_tab->lock, flags);
-	return rc;
-}
+		newalloc *= 2;
+		IR_dprintk(1, "Growing table to %u bytes\n", newalloc);
+	}
 
-/**
- * ir_roundup_tablesize() - gets an optimum value for the table size
- * @n_elems:		minimum number of entries to store keycodes
- *
- * This routine is used to choose the keycode table size.
- *
- * In order to have some empty space for new keycodes,
- * and knowing in advance that kmalloc allocates only power of two
- * segments, it optimizes the allocated space to have some spare space
- * for those new keycodes by using the maximum number of entries that
- * will be effectively be allocated by kmalloc.
- * In order to reduce the quantity of table resizes, it has a minimum
- * table size of IR_TAB_MIN_SIZE.
- */
-static int ir_roundup_tablesize(int n_elems)
-{
-	size_t size;
+	if ((rc_tab->len * 3 < rc_tab->size) && (oldalloc > IR_TAB_MIN_SIZE)) {
+		/* Less than 1/3 of entries in use -> shrink keytable */
+		newalloc /= 2;
+		IR_dprintk(1, "Shrinking table to %u bytes\n", newalloc);
+	}
 
-	if (n_elems < IR_TAB_MIN_SIZE)
-		n_elems = IR_TAB_MIN_SIZE;
+	if (newalloc == oldalloc)
+		return 0;
 
-	/*
-	 * As kmalloc only allocates sizes of power of two, get as
-	 * much entries as possible for the allocated memory segment
-	 */
-	size = roundup_pow_of_two(n_elems * sizeof(struct ir_scancode));
-	n_elems = size / sizeof(struct ir_scancode);
+	newscan = kmalloc(newalloc, GFP_ATOMIC);
+	if (!newscan) {
+		IR_dprintk(1, "Failed to kmalloc %u bytes\n", newalloc);
+		return -ENOMEM;
+	}
 
-	return n_elems;
+	memcpy(newscan, rc_tab->scan, rc_tab->len * sizeof(struct ir_scancode));
+	rc_tab->scan = newscan;
+	rc_tab->alloc = newalloc;
+	rc_tab->size = rc_tab->alloc / sizeof(struct ir_scancode);
+	kfree(oldscan);
+	return 0;
 }
 
 /**
- * ir_copy_table() - copies a keytable, discarding the unused entries
- * @destin:	destin table
- * @origin:	origin table
- *
- * Copies all entries where the keycode is not KEY_UNKNOWN/KEY_RESERVED
- * Also copies table size and table protocol.
- * NOTE: It shouldn't copy the lock field
- */
-
-static int ir_copy_table(struct ir_scancode_table *destin,
-		 const struct ir_scancode_table *origin)
-{
-	int i, j = 0;
-
-	for (i = 0; i < origin->size; i++) {
-		if (origin->scan[i].keycode == KEY_UNKNOWN ||
-		   origin->scan[i].keycode == KEY_RESERVED)
+ * ir_do_setkeycode() - internal function to set a keycode in the
+ *			scancode->keycode table
+ * @dev:	the struct input_dev device descriptor
+ * @rc_tab:	the struct ir_scancode_table to set the keycode in
+ * @scancode:	the scancode for the ir command
+ * @keycode:	the keycode for the ir command
+ * @return:	-EINVAL if the keycode could not be inserted, otherwise zero.
+ *
+ * This routine is used internally to manipulate the scancode->keycode table.
+ * The caller has to hold @rc_tab->lock.
+ */
+static int ir_do_setkeycode(struct input_dev *dev,
+			    struct ir_scancode_table *rc_tab,
+			    int scancode, int keycode)
+{
+	unsigned int i;
+	int old_keycode = KEY_RESERVED;
+
+	/* First check if we already have a mapping for this ir command */
+	for (i = 0; i < rc_tab->len; i++) {
+		/* Keytable is sorted from lowest to highest scancode */
+		if (rc_tab->scan[i].scancode > scancode)
+			break;
+		else if (rc_tab->scan[i].scancode < scancode)
 			continue;
 
-		memcpy(&destin->scan[j], &origin->scan[i], sizeof(struct ir_scancode));
-		j++;
+		old_keycode = rc_tab->scan[i].keycode;
+		rc_tab->scan[i].keycode = keycode;
+
+		/* Did the user wish to remove the mapping? */
+		if (keycode == KEY_RESERVED || keycode == KEY_UNKNOWN) {
+			rc_tab->len--;
+			memmove(&rc_tab->scan[i], &rc_tab->scan[i + 1],
+				(rc_tab->len - i) * sizeof(struct ir_scancode));
+		}
+
+		/* Possibly shrink the keytable, failure is not a problem */
+		ir_resize_table(rc_tab);
+		break;
 	}
-	destin->size = j;
-	destin->ir_type = origin->ir_type;
 
-	IR_dprintk(1, "Copied %d scancodes to the new keycode table\n", destin->size);
+	if (old_keycode == KEY_RESERVED) {
+		/* No previous mapping found, we might need to grow the table */
+		if (ir_resize_table(rc_tab))
+			return -ENOMEM;
+
+		/* i is the proper index to insert our new keycode */
+		memmove(&rc_tab->scan[i + 1], &rc_tab->scan[i],
+			(rc_tab->len - i) * sizeof(struct ir_scancode));
+		rc_tab->scan[i].scancode = scancode;
+		rc_tab->scan[i].keycode = keycode;
+		rc_tab->len++;
+		set_bit(keycode, dev->keybit);
+	} else {
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
 
 	return 0;
 }
 
 /**
- * ir_getkeycode() - get a keycode at the evdev scancode ->keycode table
+ * ir_setkeycode() - set a keycode in the scancode->keycode table
  * @dev:	the struct input_dev device descriptor
  * @scancode:	the desired scancode
- * @keycode:	the keycode to be retorned.
+ * @keycode:	result
+ * @return:	-EINVAL if the keycode could not be inserted, otherwise zero.
  *
- * This routine is used to handle evdev EVIOCGKEY ioctl.
- * If the key is not found, returns -EINVAL, otherwise, returns 0.
+ * This routine is used to handle evdev EVIOCSKEY ioctl.
  */
-static int ir_getkeycode(struct input_dev *dev,
-			 int scancode, int *keycode)
+static int ir_setkeycode(struct input_dev *dev,
+			 int scancode, int keycode)
 {
-	int elem;
+	int rc;
+	unsigned long flags;
 	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
 	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
 
-	elem = ir_seek_table(rc_tab, scancode);
-	if (elem >= 0) {
-		*keycode = rc_tab->scan[elem].keycode;
-		return 0;
-	}
-
-	/*
-	 * Scancode not found and table can't be expanded
-	 */
-	if (elem < 0 && rc_tab->size == IR_TAB_MAX_SIZE)
-		return -EINVAL;
-
-	/*
-	 * If is there extra space, returns KEY_RESERVED,
-	 * otherwise, input core won't let ir_setkeycode to work
-	 */
-	*keycode = KEY_RESERVED;
-	return 0;
-}
-
-/**
- * ir_is_resize_needed() - Check if the table needs rezise
- * @table:		keycode table that may need to resize
- * @n_elems:		minimum number of entries to store keycodes
- *
- * Considering that kmalloc uses power of two storage areas, this
- * routine detects if the real alloced size will change. If not, it
- * just returns without doing nothing. Otherwise, it will extend or
- * reduce the table size to meet the new needs.
- *
- * It returns 0 if no resize is needed, 1 otherwise.
- */
-static int ir_is_resize_needed(struct ir_scancode_table *table, int n_elems)
-{
-	int cur_size = ir_roundup_tablesize(table->size);
-	int new_size = ir_roundup_tablesize(n_elems);
-
-	if (cur_size == new_size)
-		return 0;
-
-	/* Resize is needed */
-	return 1;
-}
-
-/**
- * ir_delete_key() - remove a keycode from the table
- * @rc_tab:		keycode table
- * @elem:		element to be removed
- *
- */
-static void ir_delete_key(struct ir_scancode_table *rc_tab, int elem)
-{
-	unsigned long flags = 0;
-	int newsize = rc_tab->size - 1;
-	int resize = ir_is_resize_needed(rc_tab, newsize);
-	struct ir_scancode *oldkeymap = rc_tab->scan;
-	struct ir_scancode *newkeymap = NULL;
-
-	if (resize)
-		newkeymap = kzalloc(ir_roundup_tablesize(newsize) *
-				    sizeof(*newkeymap), GFP_ATOMIC);
-
-	/* There's no memory for resize. Keep the old table */
-	if (!resize || !newkeymap) {
-		newkeymap = oldkeymap;
-
-		/* We'll modify the live table. Lock it */
-		spin_lock_irqsave(&rc_tab->lock, flags);
-	}
-
-	/*
-	 * Copy the elements before the one that will be deleted
-	 * if (!resize), both oldkeymap and newkeymap points
-	 * to the same place, so, there's no need to copy
-	 */
-	if (resize && elem > 0)
-		memcpy(newkeymap, oldkeymap,
-		       elem * sizeof(*newkeymap));
-
-	/*
-	 * Copy the other elements overwriting the element to be removed
-	 * This operation applies to both resize and non-resize case
-	 */
-	if (elem < newsize)
-		memcpy(&newkeymap[elem], &oldkeymap[elem + 1],
-		       (newsize - elem) * sizeof(*newkeymap));
-
-	if (resize) {
-		/*
-		 * As the copy happened to a temporary table, only here
-		 * it needs to lock while replacing the table pointers
-		 * to use the new table
-		 */
-		spin_lock_irqsave(&rc_tab->lock, flags);
-		rc_tab->size = newsize;
-		rc_tab->scan = newkeymap;
-		spin_unlock_irqrestore(&rc_tab->lock, flags);
-
-		/* Frees the old keytable */
-		kfree(oldkeymap);
-	} else {
-		rc_tab->size = newsize;
-		spin_unlock_irqrestore(&rc_tab->lock, flags);
-	}
+	spin_lock_irqsave(&rc_tab->lock, flags);
+	rc = ir_do_setkeycode(dev, rc_tab, scancode, keycode);
+	spin_unlock_irqrestore(&rc_tab->lock, flags);
+	return rc;
 }
 
 /**
- * ir_insert_key() - insert a keycode at the table
- * @rc_tab:		keycode table
- * @scancode:	the desired scancode
- * @keycode:	the keycode to be retorned.
- *
- */
-static int ir_insert_key(struct ir_scancode_table *rc_tab,
-			  int scancode, int keycode)
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
 {
+	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
+	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
 	unsigned long flags;
-	int elem = rc_tab->size;
-	int newsize = rc_tab->size + 1;
-	int resize = ir_is_resize_needed(rc_tab, newsize);
-	struct ir_scancode *oldkeymap = rc_tab->scan;
-	struct ir_scancode *newkeymap;
-
-	if (resize) {
-		newkeymap = kzalloc(ir_roundup_tablesize(newsize) *
-				    sizeof(*newkeymap), GFP_ATOMIC);
-		if (!newkeymap)
-			return -ENOMEM;
-
-		memcpy(newkeymap, oldkeymap,
-		       rc_tab->size * sizeof(*newkeymap));
-	} else
-		newkeymap  = oldkeymap;
-
-	/* Stores the new code at the table */
-	IR_dprintk(1, "#%d: New scan 0x%04x with key 0x%04x\n",
-		   rc_tab->size, scancode, keycode);
+	unsigned int i;
+	int rc = 0;
 
 	spin_lock_irqsave(&rc_tab->lock, flags);
-	rc_tab->size = newsize;
-	if (resize) {
-		rc_tab->scan = newkeymap;
-		kfree(oldkeymap);
+	for (i = 0; i < from->len; i++) {
+		rc = ir_do_setkeycode(dev, to, from->scan[i].scancode,
+				      from->scan[i].keycode);
+		if (rc)
+			break;
 	}
-	newkeymap[elem].scancode = scancode;
-	newkeymap[elem].keycode  = keycode;
 	spin_unlock_irqrestore(&rc_tab->lock, flags);
-
-	return 0;
+	return rc;
 }
 
 /**
- * ir_setkeycode() - set a keycode at the evdev scancode ->keycode table
+ * ir_getkeycode() - get a keycode from the scancode->keycode table
  * @dev:	the struct input_dev device descriptor
  * @scancode:	the desired scancode
- * @keycode:	the keycode to be retorned.
+ * @keycode:	used to return the keycode, if found, or KEY_RESERVED
+ * @return:	always returns zero.
  *
- * This routine is used to handle evdev EVIOCSKEY ioctl.
- * There's one caveat here: how can we increase the size of the table?
- * If the key is not found, returns -EINVAL, otherwise, returns 0.
+ * This routine is used to handle evdev EVIOCGKEY ioctl.
  */
-static int ir_setkeycode(struct input_dev *dev,
-			 int scancode, int keycode)
+static int ir_getkeycode(struct input_dev *dev,
+			 int scancode, int *keycode)
 {
-	int rc = 0;
+	int start, end, mid;
+	unsigned long flags;
+	int key = KEY_RESERVED;
 	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
 	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
-	struct ir_scancode *keymap = rc_tab->scan;
-	unsigned long flags;
-
-	/*
-	 * Handle keycode table deletions
-	 *
-	 * If userspace is adding a KEY_UNKNOWN or KEY_RESERVED,
-	 * deal as a trial to remove an existing scancode attribution
-	 * if table become too big, reduce it to save space
-	 */
-	if (keycode == KEY_UNKNOWN || keycode == KEY_RESERVED) {
-		rc = ir_seek_table(rc_tab, scancode);
-		if (rc < 0)
-			return 0;
-
-		IR_dprintk(1, "#%d: Deleting scan 0x%04x\n", rc, scancode);
-		clear_bit(keymap[rc].keycode, dev->keybit);
-		ir_delete_key(rc_tab, rc);
 
-		return 0;
-	}
-
-	/*
-	 * Handle keycode replacements
-	 *
-	 * If the scancode exists, just replace by the new value
-	 */
-	rc = ir_seek_table(rc_tab, scancode);
-	if (rc >= 0) {
-		IR_dprintk(1, "#%d: Replacing scan 0x%04x with key 0x%04x\n",
-			rc, scancode, keycode);
-
-		clear_bit(keymap[rc].keycode, dev->keybit);
-
-		spin_lock_irqsave(&rc_tab->lock, flags);
-		keymap[rc].keycode = keycode;
-		spin_unlock_irqrestore(&rc_tab->lock, flags);
-
-		set_bit(keycode, dev->keybit);
-
-		return 0;
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
 	}
+	spin_unlock_irqrestore(&rc_tab->lock, flags);
 
-	/*
-	 * Handle new scancode inserts
-	 *
-	 * reallocate table if needed and insert a new keycode
-	 */
-
-	/* Avoid growing the table indefinitely */
-	if (rc_tab->size + 1 > IR_TAB_MAX_SIZE)
-		return -EINVAL;
-
-	rc = ir_insert_key(rc_tab, scancode, keycode);
-	if (rc < 0)
-		return rc;
-	set_bit(keycode, dev->keybit);
-
+	*keycode = key;
 	return 0;
 }
 
@@ -369,24 +239,12 @@
  */
 u32 ir_g_keycode_from_table(struct input_dev *dev, u32 scancode)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
-	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
-	struct ir_scancode *keymap = rc_tab->scan;
-	int elem;
-
-	elem = ir_seek_table(rc_tab, scancode);
-	if (elem >= 0) {
-		IR_dprintk(1, "%s: scancode 0x%04x keycode 0x%02x\n",
-			   dev->name, scancode, keymap[elem].keycode);
+	int keycode;
 
-		return rc_tab->scan[elem].keycode;
-	}
-
-	printk(KERN_INFO "%s: unknown key for scancode 0x%04x\n",
-	       dev->name, scancode);
-
-	/* Reports userspace that an unknown keycode were got */
-	return KEY_RESERVED;
+	ir_getkeycode(dev, scancode, &keycode);
+	IR_dprintk(1, "%s: scancode 0x%04x keycode 0x%02x\n",
+		   dev->name, scancode, keycode);
+	return keycode;
 }
 EXPORT_SYMBOL_GPL(ir_g_keycode_from_table);
 
@@ -476,8 +334,7 @@
 		      const char *driver_name)
 {
 	struct ir_input_dev *ir_dev;
-	struct ir_scancode  *keymap    = rc_tab->scan;
-	int i, rc;
+	int rc;
 
 	if (rc_tab->scan == NULL || !rc_tab->size)
 		return -EINVAL;
@@ -486,55 +343,55 @@
 	if (!ir_dev)
 		return -ENOMEM;
 
-	spin_lock_init(&ir_dev->rc_tab.lock);
+	ir_dev->driver_name = kasprintf(GFP_KERNEL, "%s", driver_name);
+	if (!ir_dev->driver_name) {
+		rc = -ENOMEM;
+		goto out_dev;
+	}
 
-	ir_dev->driver_name = kmalloc(strlen(driver_name) + 1, GFP_KERNEL);
-	if (!ir_dev->driver_name)
-		return -ENOMEM;
-	strcpy(ir_dev->driver_name, driver_name);
+	input_dev->getkeycode = ir_getkeycode;
+	input_dev->setkeycode = ir_setkeycode;
+	input_set_drvdata(input_dev, ir_dev);
+
+	spin_lock_init(&ir_dev->rc_tab.lock);
 	ir_dev->rc_tab.name = rc_tab->name;
-	ir_dev->rc_tab.size = ir_roundup_tablesize(rc_tab->size);
-	ir_dev->rc_tab.scan = kzalloc(ir_dev->rc_tab.size *
-				    sizeof(struct ir_scancode), GFP_KERNEL);
+	ir_dev->rc_tab.ir_type = rc_tab->ir_type;
+	ir_dev->rc_tab.alloc = roundup_pow_of_two(rc_tab->len *
+						  sizeof(struct ir_scancode));
+	ir_dev->rc_tab.scan = kmalloc(ir_dev->rc_tab.alloc, GFP_KERNEL);
+	ir_dev->rc_tab.size = ir_dev->rc_tab.alloc / sizeof(struct ir_scancode);
+
 	if (!ir_dev->rc_tab.scan) {
-		kfree(ir_dev);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto out_name;
 	}
 
-	IR_dprintk(1, "Allocated space for %d keycode entries (%zd bytes)\n",
-		ir_dev->rc_tab.size,
-		ir_dev->rc_tab.size * sizeof(ir_dev->rc_tab.scan));
+	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
+		   ir_dev->rc_tab.size, ir_dev->rc_tab.alloc);
+
+	set_bit(EV_KEY, input_dev->evbit);
+	if (ir_setkeytable(input_dev, &ir_dev->rc_tab, rc_tab)) {
+		rc = -ENOMEM;
+		goto out_table;
+	}
 
-	ir_copy_table(&ir_dev->rc_tab, rc_tab);
 	ir_dev->props = props;
 	if (props && props->open)
 		input_dev->open = ir_open;
 	if (props && props->close)
 		input_dev->close = ir_close;
 
-	/* set the bits for the keys */
-	IR_dprintk(1, "key map size: %d\n", rc_tab->size);
-	for (i = 0; i < rc_tab->size; i++) {
-		IR_dprintk(1, "#%d: setting bit for keycode 0x%04x\n",
-			i, keymap[i].keycode);
-		set_bit(keymap[i].keycode, input_dev->keybit);
-	}
-	clear_bit(0, input_dev->keybit);
-
-	set_bit(EV_KEY, input_dev->evbit);
-
-	input_dev->getkeycode = ir_getkeycode;
-	input_dev->setkeycode = ir_setkeycode;
-	input_set_drvdata(input_dev, ir_dev);
-
 	rc = ir_register_class(input_dev);
 	if (rc < 0)
-		goto err;
+		goto out_table;
 
 	return 0;
 
-err:
-	kfree(rc_tab->scan);
+out_table:
+	kfree(ir_dev->rc_tab.scan);
+out_name:
+	kfree(ir_dev->driver_name);
+out_dev:
 	kfree(ir_dev);
 	return rc;
 }
@@ -563,6 +420,7 @@
 
 	ir_unregister_class(dev);
 
+	kfree(ir_dev->driver_name);
 	kfree(ir_dev);
 }
 EXPORT_SYMBOL_GPL(ir_input_unregister);
Index: ir/include/media/ir-core.h
===================================================================
--- ir.orig/include/media/ir-core.h	2010-04-01 17:38:16.733727686 +0200
+++ ir/include/media/ir-core.h	2010-04-02 12:22:50.836196555 +0200
@@ -46,7 +46,9 @@
 
 struct ir_scancode_table {
 	struct ir_scancode	*scan;
-	int			size;
+	unsigned int		size;	/* Max number of entries */
+	unsigned int		len;	/* Used number of entries */
+	unsigned int		alloc;	/* Size of *scan in bytes */
 	u64			ir_type;
 	char			*name;
 	spinlock_t		lock;

