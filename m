Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57028 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239Ab0IHHmP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 03:42:15 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6/6] Input: media/IR - switch to using new keycode interface
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Jiri Kosina <jkosina@suse.cz>, Ville Syrjala <syrjala@sci.fi>
Date: Wed, 08 Sep 2010 00:42:11 -0700
Message-ID: <20100908074211.32365.78588.stgit@hammer.corenet.prv>
In-Reply-To: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Switch the code to use new style of getkeycode and setkeycode
methods to allow retrieving and setting keycodes not only by
their scancodes but also by index.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/media/IR/ir-keytable.c |  393 +++++++++++++++++++++++++++-------------
 include/media/rc-map.h         |    2 
 2 files changed, 263 insertions(+), 132 deletions(-)

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 7e82a9d..5ca36a4 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -25,14 +25,56 @@
 #define IR_KEYPRESS_TIMEOUT 250
 
 /**
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
  * ir_resize_table() - resizes a scancode table if necessary
  * @rc_tab:	the ir_scancode_table to resize
+ * @gfp_flags:	gfp flags to use when allocating memory
  * @return:	zero on success or a negative error code
  *
  * This routine will shrink the ir_scancode_table if it has lots of
  * unused entries and grow it if it is full.
  */
-static int ir_resize_table(struct ir_scancode_table *rc_tab)
+static int ir_resize_table(struct ir_scancode_table *rc_tab, gfp_t gfp_flags)
 {
 	unsigned int oldalloc = rc_tab->alloc;
 	unsigned int newalloc = oldalloc;
@@ -57,7 +99,7 @@ static int ir_resize_table(struct ir_scancode_table *rc_tab)
 	if (newalloc == oldalloc)
 		return 0;
 
-	newscan = kmalloc(newalloc, GFP_ATOMIC);
+	newscan = kmalloc(newalloc, gfp_flags);
 	if (!newscan) {
 		IR_dprintk(1, "Failed to kmalloc %u bytes\n", newalloc);
 		return -ENOMEM;
@@ -72,26 +114,78 @@ static int ir_resize_table(struct ir_scancode_table *rc_tab)
 }
 
 /**
- * ir_do_setkeycode() - internal function to set a keycode in the
- *			scancode->keycode table
+ * ir_update_mapping() - set a keycode in the scancode->keycode table
  * @dev:	the struct input_dev device descriptor
- * @rc_tab:	the struct ir_scancode_table to set the keycode in
- * @scancode:	the scancode for the ir command
- * @keycode:	the keycode for the ir command
- * @resize:	whether the keytable may be shrunk
- * @return:	-EINVAL if the keycode could not be inserted, otherwise zero.
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
+ * ir_locate_scancode() - set a keycode in the scancode->keycode table
+ * @ir_dev:	the struct ir_input_dev device descriptor
+ * @rc_tab:	scancode table to be searched
+ * @scancode:	the desired scancode
+ * @resize:	controls whether we allowed to resize the table to
+ *		accomodate not yet present scancodes
+ * @return:	index of the mapping containing scancode in question
+ *		or -1U in case of failure.
  *
- * This routine is used internally to manipulate the scancode->keycode table.
- * The caller has to hold @rc_tab->lock.
+ * This routine is used to locate given scancode in ir_scancode_table.
+ * If scancode is not yet present the routine will allocate a new slot
+ * for it.
  */
-static int ir_do_setkeycode(struct input_dev *dev,
-			    struct ir_scancode_table *rc_tab,
-			    unsigned scancode, unsigned keycode,
-			    bool resize)
+static unsigned int ir_establish_scancode(struct ir_input_dev *ir_dev,
+					  struct ir_scancode_table *rc_tab,
+					  unsigned int scancode,
+					  bool resize)
 {
 	unsigned int i;
-	int old_keycode = KEY_RESERVED;
-	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
 
 	/*
 	 * Unfortunately, some hardware-based IR decoders don't provide
@@ -100,65 +194,34 @@ static int ir_do_setkeycode(struct input_dev *dev,
 	 * the provided IR with another one, it is needed to allow loading
 	 * IR tables from other remotes. So,
 	 */
-	if (ir_dev->props && ir_dev->props->scanmask) {
+	if (ir_dev->props && ir_dev->props->scanmask)
 		scancode &= ir_dev->props->scanmask;
-	}
 
 	/* First check if we already have a mapping for this ir command */
 	for (i = 0; i < rc_tab->len; i++) {
+		if (rc_tab->scan[i].scancode == scancode)
+			return i;
+
 		/* Keytable is sorted from lowest to highest scancode */
-		if (rc_tab->scan[i].scancode > scancode)
+		if (rc_tab->scan[i].scancode >= scancode)
 			break;
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
 	}
 
-	if (old_keycode == KEY_RESERVED && keycode != KEY_RESERVED) {
-		/* No previous mapping found, we might need to grow the table */
-		if (resize && ir_resize_table(rc_tab))
-			return -ENOMEM;
-
-		IR_dprintk(1, "#%d: New scan 0x%04x with key 0x%04x\n",
-			   i, scancode, keycode);
+	/* No previous mapping found, we might need to grow the table */
+	if (rc_tab->size == rc_tab->len) {
+		if (!resize || ir_resize_table(rc_tab, GFP_ATOMIC))
+			return -1U;
+	}
 
-		/* i is the proper index to insert our new keycode */
+	/* i is the proper index to insert our new keycode */
+	if (i < rc_tab->len)
 		memmove(&rc_tab->scan[i + 1], &rc_tab->scan[i],
 			(rc_tab->len - i) * sizeof(struct ir_scancode));
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
+	rc_tab->scan[i].scancode = scancode;
+	rc_tab->scan[i].keycode = KEY_RESERVED;
+	rc_tab->len++;
 
-	return 0;
+	return i;
 }
 
 /**
@@ -171,17 +234,41 @@ static int ir_do_setkeycode(struct input_dev *dev,
  * This routine is used to handle evdev EVIOCSKEY ioctl.
  */
 static int ir_setkeycode(struct input_dev *dev,
-			 unsigned int scancode, unsigned int keycode)
+			 const struct input_keymap_entry *ke,
+			 unsigned int *old_keycode)
 {
-	int rc;
-	unsigned long flags;
 	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
 	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
+	unsigned int index;
+	unsigned int scancode;
+	int retval;
+	unsigned long flags;
 
 	spin_lock_irqsave(&rc_tab->lock, flags);
-	rc = ir_do_setkeycode(dev, rc_tab, scancode, keycode, true);
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
 	spin_unlock_irqrestore(&rc_tab->lock, flags);
-	return rc;
+	return retval;
 }
 
 /**
@@ -189,32 +276,73 @@ static int ir_setkeycode(struct input_dev *dev,
  * @dev:	the struct input_dev device descriptor
  * @to:		the struct ir_scancode_table to copy entries to
  * @from:	the struct ir_scancode_table to copy entries from
- * @return:	-EINVAL if all keycodes could not be inserted, otherwise zero.
+ * @return:	-ENOMEM if all keycodes could not be inserted, otherwise zero.
  *
  * This routine is used to handle table initialization.
  */
-static int ir_setkeytable(struct input_dev *dev,
-			  struct ir_scancode_table *to,
+static int ir_setkeytable(struct ir_input_dev *ir_dev,
 			  const struct ir_scancode_table *from)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
 	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
-	unsigned long flags;
-	unsigned int i;
-	int rc = 0;
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
 
-	spin_lock_irqsave(&rc_tab->lock, flags);
 	for (i = 0; i < from->size; i++) {
-		rc = ir_do_setkeycode(dev, to, from->scan[i].scancode,
-				      from->scan[i].keycode, false);
-		if (rc)
+		index = ir_establish_scancode(ir_dev, rc_tab,
+					      from->scan[i].scancode, false);
+		if (index >= rc_tab->len) {
+			rc = -ENOMEM;
 			break;
+		}
+
+		ir_update_mapping(ir_dev->input_dev, rc_tab, index,
+				  from->scan[i].keycode);
 	}
-	spin_unlock_irqrestore(&rc_tab->lock, flags);
+
+	if (rc)
+		ir_free_table(rc_tab);
+
 	return rc;
 }
 
 /**
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
+	unsigned int start = 0;
+	unsigned int end = rc_tab->len - 1;
+	unsigned int mid;
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
  * ir_getkeycode() - get a keycode from the scancode->keycode table
  * @dev:	the struct input_dev device descriptor
  * @scancode:	the desired scancode
@@ -224,36 +352,46 @@ static int ir_setkeytable(struct input_dev *dev,
  * This routine is used to handle evdev EVIOCGKEY ioctl.
  */
 static int ir_getkeycode(struct input_dev *dev,
-			 unsigned int scancode, unsigned int *keycode)
+			 struct input_keymap_entry *ke)
 {
-	int start, end, mid;
-	unsigned long flags;
-	int key = KEY_RESERVED;
 	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
 	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
+	struct ir_scancode *entry;
+	unsigned long flags;
+	unsigned int index;
+	unsigned int scancode;
+	int retval;
 
 	spin_lock_irqsave(&rc_tab->lock, flags);
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
 	}
-	spin_unlock_irqrestore(&rc_tab->lock, flags);
 
-	if (key == KEY_RESERVED)
-		IR_dprintk(1, "unknown key for scancode 0x%04x\n",
-			   scancode);
+	entry = &rc_tab->scan[index];
 
-	*keycode = key;
-	return 0;
+	ke->index = index;
+	ke->keycode = entry->keycode;
+	ke->len = sizeof(entry->scancode);
+	memcpy(ke->scancode, &entry->scancode, sizeof(entry->scancode));
+
+out:
+	spin_unlock_irqrestore(&rc_tab->lock, flags);
+	return retval;
 }
 
 /**
@@ -268,12 +406,24 @@ static int ir_getkeycode(struct input_dev *dev,
  */
 u32 ir_g_keycode_from_table(struct input_dev *dev, u32 scancode)
 {
-	int keycode;
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
 
-	ir_getkeycode(dev, scancode, &keycode);
 	if (keycode != KEY_RESERVED)
 		IR_dprintk(1, "%s: scancode 0x%04x keycode 0x%02x\n",
 			   dev->name, scancode, keycode);
+
 	return keycode;
 }
 EXPORT_SYMBOL_GPL(ir_g_keycode_from_table);
@@ -453,8 +603,8 @@ int __ir_input_register(struct input_dev *input_dev,
 		goto out_dev;
 	}
 
-	input_dev->getkeycode = ir_getkeycode;
-	input_dev->setkeycode = ir_setkeycode;
+	input_dev->getkeycode_new = ir_getkeycode;
+	input_dev->setkeycode_new = ir_setkeycode;
 	input_set_drvdata(input_dev, ir_dev);
 	ir_dev->input_dev = input_dev;
 
@@ -462,12 +612,6 @@ int __ir_input_register(struct input_dev *input_dev,
 	spin_lock_init(&ir_dev->keylock);
 	setup_timer(&ir_dev->timer_keyup, ir_timer_keyup, (unsigned long)ir_dev);
 
-	ir_dev->rc_tab.name = rc_tab->name;
-	ir_dev->rc_tab.ir_type = rc_tab->ir_type;
-	ir_dev->rc_tab.alloc = roundup_pow_of_two(rc_tab->size *
-						  sizeof(struct ir_scancode));
-	ir_dev->rc_tab.scan = kmalloc(ir_dev->rc_tab.alloc, GFP_KERNEL);
-	ir_dev->rc_tab.size = ir_dev->rc_tab.alloc / sizeof(struct ir_scancode);
 	if (props) {
 		ir_dev->props = props;
 		if (props->open)
@@ -476,23 +620,14 @@ int __ir_input_register(struct input_dev *input_dev,
 			input_dev->close = ir_close;
 	}
 
-	if (!ir_dev->rc_tab.scan) {
-		rc = -ENOMEM;
-		goto out_name;
-	}
-
-	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
-		   ir_dev->rc_tab.size, ir_dev->rc_tab.alloc);
-
 	set_bit(EV_KEY, input_dev->evbit);
 	set_bit(EV_REP, input_dev->evbit);
 	set_bit(EV_MSC, input_dev->evbit);
 	set_bit(MSC_SCAN, input_dev->mscbit);
 
-	if (ir_setkeytable(input_dev, &ir_dev->rc_tab, rc_tab)) {
-		rc = -ENOMEM;
-		goto out_table;
-	}
+	rc = ir_setkeytable(ir_dev, rc_tab);
+	if (rc)
+		goto out_name;
 
 	rc = ir_register_class(input_dev);
 	if (rc < 0)
@@ -515,7 +650,7 @@ int __ir_input_register(struct input_dev *input_dev,
 out_event:
 	ir_unregister_class(input_dev);
 out_table:
-	kfree(ir_dev->rc_tab.scan);
+	ir_free_table(&ir_dev->rc_tab);
 out_name:
 	kfree(ir_dev->driver_name);
 out_dev:
@@ -533,7 +668,6 @@ EXPORT_SYMBOL_GPL(__ir_input_register);
 void ir_input_unregister(struct input_dev *input_dev)
 {
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	struct ir_scancode_table *rc_tab;
 
 	if (!ir_dev)
 		return;
@@ -545,10 +679,7 @@ void ir_input_unregister(struct input_dev *input_dev)
 		if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW)
 			ir_raw_event_unregister(input_dev);
 
-	rc_tab = &ir_dev->rc_tab;
-	rc_tab->size = 0;
-	kfree(rc_tab->scan);
-	rc_tab->scan = NULL;
+	ir_free_table(&ir_dev->rc_tab);
 
 	ir_unregister_class(input_dev);
 
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index a9c041d..9b201ec 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -35,7 +35,7 @@ struct ir_scancode_table {
 	unsigned int		len;	/* Used number of entries */
 	unsigned int		alloc;	/* Size of *scan in bytes */
 	u64			ir_type;
-	char			*name;
+	const char		*name;
 	spinlock_t		lock;
 };
 

