Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40335 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbaDCXeU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:34:20 -0400
Subject: [PATCH 36/49] rc-core: make keytable RCU-friendly
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:34:18 +0200
Message-ID: <20140403233418.27099.61408.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change struct rc_keytable to be RCU-friendly by kmalloc():ing an
entire new scancode,protocol <-> keycode table every time the table
is changed (i.e. via EVIOCSKEYCODE(_V2)).

The advantage is that the performance-critical keycode lookup path
can be made entirely lock-free and that GFP_ATOMIC allocations
can be avoided entirely at the cost of a couple of extra kmalloc()
calls when changing a keytable (which is normally done once during
boot).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-keytable.c |  668 +++++++++++++++++++---------------------
 include/media/rc-core.h        |   32 +-
 2 files changed, 332 insertions(+), 368 deletions(-)

diff --git a/drivers/media/rc/rc-keytable.c b/drivers/media/rc/rc-keytable.c
index f4d03d2..89295f3 100644
--- a/drivers/media/rc/rc-keytable.c
+++ b/drivers/media/rc/rc-keytable.c
@@ -25,12 +25,10 @@
 #include <linux/poll.h>
 #include "rc-core-priv.h"
 
-/* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
-#define IR_TAB_MIN_SIZE		256
-#define IR_TAB_MAX_SIZE		8192
+#define RC_TAB_MAX_SIZE		1024 /* entries */
 
-/* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
-#define IR_KEYPRESS_TIMEOUT 250
+/* FIXME: RC_KEYPRESS_TIMEOUT should be protocol specific */
+#define RC_KEYPRESS_TIMEOUT 250
 
 /* Used to keep track of known keymaps */
 static LIST_HEAD(rc_map_list);
@@ -99,237 +97,189 @@ void rc_map_unregister(struct rc_map_list *map)
 EXPORT_SYMBOL_GPL(rc_map_unregister);
 
 /**
- * ir_create_table() - initializes a scancode table
- * @rc_map:	the rc_map to initialize
- * @name:	name to assign to the table
- * @size:	initial size of the table
- * @return:	zero on success or a negative error code
- *
- * This routine will initialize the rc_map and will allocate
- * memory to hold at least the specified number of elements.
+ * rc_scan_size() - determine the necessary size for a rc_scan struct
+ * @len:	the number of keytable entries the struct should hold
+ * @return:	the size of the struct in bytes
  */
-static int ir_create_table(struct rc_map *rc_map,
-			   const char *name, size_t size)
+static inline size_t rc_scan_size(unsigned len)
 {
-	rc_map->name = name;
-	rc_map->alloc = roundup_pow_of_two(size * sizeof(struct rc_map_table));
-	rc_map->size = rc_map->alloc / sizeof(struct rc_map_table);
-	rc_map->scan = kmalloc(rc_map->alloc, GFP_KERNEL);
-	if (!rc_map->scan)
-		return -ENOMEM;
-
-	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
-		   rc_map->size, rc_map->alloc);
-	return 0;
+	return sizeof(struct rc_scan) + len * sizeof(struct rc_map_table);
 }
 
 /**
- * ir_free_table() - frees memory allocated by a scancode table
- * @rc_map:	the table whose mappings need to be freed
+ * rc_keytable_update_entry() - update an existing entry in the keytable
+ * @kt:		the keytable to update
+ * @i:		the index of the entry to update
+ * @entry:	the new values for the entry
+ * @return:	the old rc_scan struct, NULL if memory could not be allocated
  *
- * This routine will free memory alloctaed for key mappings used by given
- * scancode table.
+ * Updates a keytable by replacing an existing entry at the given index.
+ * The old rc_scan struct is returned so that it can be freed at a
+ * later stage.
  */
-void ir_free_table(struct rc_map *rc_map)
+static struct rc_scan *rc_keytable_update_entry(struct rc_keytable *kt,
+						unsigned i,
+						struct rc_map_table *entry)
 {
-	rc_map->size = 0;
-	kfree(rc_map->scan);
-	rc_map->scan = NULL;
-}
+	struct rc_scan *old_scan = kt->scan;
+	struct rc_scan *new_scan = kt->scan;
+	u32 old_keycode;
 
-/**
- * ir_resize_table() - resizes a scancode table if necessary
- * @rc_map:	the rc_map to resize
- * @gfp_flags:	gfp flags to use when allocating memory
- * @return:	zero on success or a negative error code
- *
- * This routine will shrink the rc_map if it has lots of
- * unused entries and grow it if it is full.
- */
-static int ir_resize_table(struct rc_map *rc_map, gfp_t gfp_flags)
-{
-	unsigned int oldalloc = rc_map->alloc;
-	unsigned int newalloc = oldalloc;
-	struct rc_map_table *oldscan = rc_map->scan;
-	struct rc_map_table *newscan;
-
-	if (rc_map->size == rc_map->len) {
-		/* All entries in use -> grow keytable */
-		if (rc_map->alloc >= IR_TAB_MAX_SIZE)
-			return -ENOMEM;
-
-		newalloc *= 2;
-		IR_dprintk(1, "Growing table to %u bytes\n", newalloc);
-	}
+	if (i >= old_scan->len)
+		return NULL;
 
-	if ((rc_map->len * 3 < rc_map->size) && (oldalloc > IR_TAB_MIN_SIZE)) {
-		/* Less than 1/3 of entries in use -> shrink keytable */
-		newalloc /= 2;
-		IR_dprintk(1, "Shrinking table to %u bytes\n", newalloc);
-	}
+	new_scan = kmalloc(rc_scan_size(old_scan->len), GFP_KERNEL);
+	if (!new_scan)
+		return NULL;
+	memcpy(new_scan, old_scan, rc_scan_size(old_scan->len));
 
-	if (newalloc == oldalloc)
-		return 0;
+	IR_dprintk(1, "#%d: New keycode 0x%04x\n", i, entry->keycode);
+	new_scan->table[i].keycode = entry->keycode;
 
-	newscan = kmalloc(newalloc, gfp_flags);
-	if (!newscan) {
-		IR_dprintk(1, "Failed to kmalloc %u bytes\n", newalloc);
-		return -ENOMEM;
-	}
+	/* Another scancode might use the old keycode... */
+	__set_bit(entry->keycode, kt->idev->keybit);
+	old_keycode = old_scan->table[i].keycode;
+	for (i = 0; i < new_scan->len; i++)
+		if (new_scan->table[i].keycode == old_keycode)
+			break;
 
-	memcpy(newscan, rc_map->scan, rc_map->len * sizeof(struct rc_map_table));
-	rc_map->scan = newscan;
-	rc_map->alloc = newalloc;
-	rc_map->size = rc_map->alloc / sizeof(struct rc_map_table);
-	kfree(oldscan);
-	return 0;
+	if (i >= new_scan->len)
+		/* ...nope */
+		__clear_bit(old_keycode, kt->idev->keybit);
+
+	rcu_assign_pointer(kt->scan, new_scan);
+	return old_scan;
 }
 
 /**
- * ir_update_mapping() - set a keycode in the scancode->keycode table
- * @kt:		the struct rc_keytable
- * @rc_map:	scancode table to be adjusted
- * @index:	index of the mapping that needs to be updated
- * @keycode:	the desired keycode
- * @return:	previous keycode assigned to the mapping
+ * rc_keytable_remove_entry() - remove an existing entry in the keytable
+ * @kt:		the keytable to update
+ * @i:		the index of the entry to remove
+ * @return:	the old rc_scan struct, NULL if memory could not be allocated
  *
- * This routine is used to update scancode->keycode mapping at given
- * position.
+ * Updates a keytable by removing an existing entry at the given index.
+ * The old rc_scan struct is returned so that it can be freed at a
+ * later stage.
  */
-static unsigned int ir_update_mapping(struct rc_keytable *kt,
-				      struct rc_map *rc_map,
-				      unsigned int index,
-				      unsigned int new_keycode)
+static struct rc_scan *rc_keytable_remove_entry(struct rc_keytable *kt,
+						unsigned i)
 {
-	int old_keycode = rc_map->scan[index].keycode;
-	int i;
-
-	/* Did the user wish to remove the mapping? */
-	if (new_keycode == KEY_RESERVED || new_keycode == KEY_UNKNOWN) {
-		IR_dprintk(1, "#%d: Deleting proto 0x%04x, scan 0x%08llx\n",
-			   index, rc_map->scan[index].protocol,
-			   (unsigned long long)rc_map->scan[index].scancode);
-		rc_map->len--;
-		memmove(&rc_map->scan[index], &rc_map->scan[index+ 1],
-			(rc_map->len - index) * sizeof(struct rc_map_table));
-	} else {
-		IR_dprintk(1, "#%d: %s proto 0x%04x, scan 0x%08llx "
-			   "with key 0x%04x\n",
-			   index,
-			   old_keycode == KEY_RESERVED ? "New" : "Replacing",
-			   rc_map->scan[index].protocol,
-			   (unsigned long long)rc_map->scan[index].scancode,
-			   new_keycode);
-		rc_map->scan[index].keycode = new_keycode;
-		__set_bit(new_keycode, kt->idev->keybit);
-	}
+	struct rc_scan *old_scan = kt->scan;
+	struct rc_scan *new_scan = kt->scan;
+	u32 old_keycode;
 
-	if (old_keycode != KEY_RESERVED) {
-		/* A previous mapping was updated... */
-		__clear_bit(old_keycode, kt->idev->keybit);
-		/* ... but another scancode might use the same keycode */
-		for (i = 0; i < rc_map->len; i++) {
-			if (rc_map->scan[i].keycode == old_keycode) {
-				__set_bit(old_keycode, kt->idev->keybit);
-				break;
-			}
-		}
+	if (i >= old_scan->len)
+		return NULL;
 
-		/* Possibly shrink the keytable, failure is not a problem */
-		ir_resize_table(rc_map, GFP_ATOMIC);
-	}
+	new_scan = kmalloc(rc_scan_size(old_scan->len - 1), GFP_ATOMIC);
+	if (!new_scan)
+		return NULL;
+	new_scan->len = old_scan->len - 1;
+	memcpy(&new_scan->table[0], &old_scan->table[0],
+	       i * sizeof(struct rc_map_table));
+	memcpy(&new_scan->table[i], &old_scan->table[i + 1],
+	       (new_scan->len - i) * sizeof(struct rc_map_table));
+	IR_dprintk(1, "#%d: Deleted\n", i);
+
+	/* Another scancode might use the removed keycode... */
+	old_keycode = old_scan->table[i].keycode;
+	for (i = 0; i < new_scan->len; i++)
+		if (new_scan->table[i].keycode == old_keycode)
+			break;
+
+	if (i >= new_scan->len)
+		/* ...nope */
+		__clear_bit(old_keycode, kt->idev->keybit);
 
-	return old_keycode;
+	rcu_assign_pointer(kt->scan, new_scan);
+	return old_scan;
 }
 
 /**
- * ir_establish_scancode() - set a keycode in the scancode->keycode table
- * @kt:		the struct rc_keytable descriptor
- * @rc_map:	scancode table to be searched
- * @entry:	the entry to be added to the table
- * @resize:	controls whether we are allowed to resize the table to
- *		accomodate not yet present scancodes
- * @return:	index of the mapping containing scancode in question
- *		or -1U in case of failure.
+ * rc_keytable_add_entry() - add an existing entry in the keytable
+ * @kt:		the keytable to update
+ * @entry:	the new entry to insert
+ * @init:	whether the keytable is being initialized for the first time
+ * @return:	the old rc_scan struct, NULL if memory could not be allocated
  *
- * This routine is used to locate given scancode in rc_map.
- * If scancode is not yet present the routine will allocate a new slot
- * for it.
+ * Updates a keytable by inserting an entry at the proper index. Unless @init is
+ * %true, the old rc_scan struct is returned so that it can be freed at a
+ * later stage.
  */
-static unsigned int ir_establish_scancode(struct rc_keytable *kt,
-					  struct rc_map *rc_map,
-					  struct rc_map_table *entry,
-					  bool resize)
+static struct rc_scan *rc_keytable_add_entry(struct rc_keytable *kt,
+					     struct rc_map_table *entry,
+					     bool init)
 {
-	unsigned int i;
+	struct rc_scan *old_scan = kt->scan;
+	struct rc_scan *new_scan = kt->scan;
+	unsigned i;
 
-	/*
-	 * Unfortunately, some hardware-based IR decoders don't provide
-	 * all bits for the complete IR code. In general, they provide only
-	 * the command part of the IR code. Yet, as it is possible to replace
-	 * the provided IR with another one, it is needed to allow loading
-	 * IR tables from other remotes. So, we support specifying a mask to
-	 * indicate the valid bits of the scancodes.
-	 */
-	if (kt->dev->scancode_mask)
-		entry->scancode &= kt->dev->scancode_mask;
+	if (old_scan->len >= RC_TAB_MAX_SIZE)
+		return NULL;
 
-	/*
-	 * First check if we already have a mapping for this command.
-	 * Note that the keytable is sorted first on protocol and second
-	 * on scancode (lowest to highest).
-	 */
-	for (i = 0; i < rc_map->len; i++) {
-		if (rc_map->scan[i].protocol < entry->protocol)
+	/* Find the right index to insert the new entry at */
+	for (i = 0; i < old_scan->len; i++) {
+		if (old_scan->table[i].protocol < entry->protocol)
 			continue;
 
-		if (rc_map->scan[i].protocol > entry->protocol)
+		if (old_scan->table[i].protocol > entry->protocol)
 			break;
 
-		if (rc_map->scan[i].scancode < entry->scancode)
+		if (old_scan->table[i].scancode < entry->scancode)
 			continue;
 
-		if (rc_map->scan[i].scancode > entry->scancode)
+		if (old_scan->table[i].scancode > entry->scancode)
 			break;
 
-		return i;
+		/* BUG: We already have a matching entry */
+		return NULL;
 	}
 
-	/* No previous mapping found, we might need to grow the table */
-	if (rc_map->size == rc_map->len) {
-		if (!resize || ir_resize_table(rc_map, GFP_ATOMIC))
-			return -1U;
+	if (init) {
+		/* The init code already allocates a suitably sized table */
+		memmove(&new_scan->table[i + 1], &new_scan->table[i],
+			(new_scan->len - i) * sizeof(struct rc_map_table));
+		new_scan->len++;
+	} else {
+		new_scan = kmalloc(rc_scan_size(old_scan->len + 1), GFP_ATOMIC);
+		if (!new_scan)
+			return NULL;
+		new_scan->len = old_scan->len + 1;
+		memcpy(&new_scan->table[0], &old_scan->table[0],
+		       i * sizeof(struct rc_map_table));
+		memcpy(&new_scan->table[i + 1], &old_scan->table[i],
+		       (old_scan->len - i) * sizeof(struct rc_map_table));
 	}
 
-	/* i is the proper index to insert our new keycode */
-	if (i < rc_map->len)
-		memmove(&rc_map->scan[i + 1], &rc_map->scan[i],
-			(rc_map->len - i) * sizeof(struct rc_map_table));
-	rc_map->scan[i].scancode = entry->scancode;
-	rc_map->scan[i].protocol = entry->protocol;
-	rc_map->scan[i].keycode = KEY_RESERVED;
-	rc_map->len++;
+	new_scan->table[i].scancode = entry->scancode;
+	new_scan->table[i].protocol = entry->protocol;
+	new_scan->table[i].keycode = entry->keycode;
+	IR_dprintk(1, "#%d: New proto 0x%04x, scan 0x%08llx with key 0x%04x\n",
+		   i, entry->protocol, (unsigned long long)entry->scancode,
+		   entry->keycode);
+	__set_bit(entry->keycode, kt->idev->keybit);
 
-	return i;
+	rcu_assign_pointer(kt->scan, new_scan);
+	return old_scan;
 }
 
 /**
  * guess_protocol() - heuristics to guess the protocol for a scancode
  * @rdev:	the struct rc_dev device descriptor
- * @return:	the guessed RC_TYPE_* protocol
+ * @scan:	the struct rc_scan table to use
+ * @return:     the guessed RC_TYPE_* protocol
  *
  * Internal routine to guess the current IR protocol for legacy ioctls.
  */
-static inline enum rc_type guess_protocol(struct rc_dev *rdev)
+static inline enum rc_type guess_protocol(struct rc_dev *rdev,
+					  struct rc_scan *scan)
 {
-	struct rc_map *rc_map = &rdev->keytables[0]->rc_map;
-
 	if (hweight64(rdev->enabled_protocols) == 1)
 		return rc_bitmap_to_type(rdev->enabled_protocols);
 	else if (hweight64(rdev->allowed_protocols) == 1)
 		return rc_bitmap_to_type(rdev->allowed_protocols);
-	else if (rc_map->len > 0)
-		return rc_map->scan[0].protocol;
+	else if (scan->len > 0)
+		return scan->table[0].protocol;
 	else
 		return RC_TYPE_OTHER;
 }
@@ -359,33 +309,71 @@ static u32 to_nec32(u32 orig)
 }
 
 /**
- * ir_setkeycode() - set a keycode in the scancode->keycode table
+ * rc_scancode_to_index() - locate keytable index by scancode
+ * @rc_scan:	the struct rc_scan to search
+ * @protocol:	protocol to look for in the table
+ * @scancode:	scancode to look for in the table
+ * @return:	index in the table, -1U if not found
+ *
+ * This routine performs a binary search in a keytable for a
+ * given scancode.
+ */
+static unsigned rc_scancode_to_index(struct rc_scan *scan,
+				     u16 protocol, u64 scancode)
+{
+	int start = 0;
+	int end = scan->len - 1;
+	int mid;
+	struct rc_map_table *m;
+
+	while (start <= end) {
+		mid = (start + end) / 2;
+		m = &scan->table[mid];
+
+		if (m->protocol < protocol)
+			start = mid + 1;
+		else if (m->protocol > protocol)
+			end = mid - 1;
+		else if (m->scancode < scancode)
+			start = mid + 1;
+		else if (m->scancode > scancode)
+			end = mid - 1;
+		else
+			return mid;
+	}
+
+	return -1U;
+}
+
+/**
+ * rc_keytable_set() - add/update/remove an entry in the keytable
  * @idev:	the struct input_dev device descriptor
- * @scancode:	the desired scancode
- * @keycode:	result
- * @return:	-EINVAL if the keycode could not be inserted, otherwise zero.
+ * @ke:		the keymap entry to add/update/remove
+ * @old_keycode:used to return the previous keycode for this entry
+ * @return:	zero on success or a negative error code
  *
- * This routine is used to handle evdev EVIOCSKEY ioctl.
+ * This function handles the evdev EVIOCSKEYCODE(_V2) ioctls.
  */
-static int ir_setkeycode(struct input_dev *idev,
-			 const struct input_keymap_entry *ke,
-			 unsigned int *old_keycode)
+static int rc_keytable_set(struct input_dev *idev,
+			   const struct input_keymap_entry *ke,
+			   unsigned int *old_keycode)
 {
 	struct rc_keytable *kt = input_get_drvdata(idev);
 	struct rc_dev *rdev = kt->dev;
-	struct rc_map *rc_map = &kt->rc_map;
+	struct rc_scan *old_scan = NULL;
 	unsigned int index;
 	struct rc_map_table entry;
 	int retval = 0;
-	unsigned long flags;
 
 	entry.keycode = ke->keycode;
 
-	spin_lock_irqsave(&kt->lock, flags);
+	retval = mutex_lock_interruptible(&kt->scan_mutex);
+	if (retval)
+		return retval;
 
 	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
 		index = ke->index;
-		if (index >= rc_map->len) {
+		if (index >= kt->scan->len) {
 			retval = -EINVAL;
 			goto out;
 		}
@@ -397,15 +385,16 @@ static int ir_setkeycode(struct input_dev *idev,
 			goto out;
 
 		entry.scancode = scancode;
-		entry.protocol = guess_protocol(rdev);
+		entry.protocol = guess_protocol(rdev, kt->scan);
 		if (entry.protocol == RC_TYPE_NEC)
 			entry.scancode = to_nec32(scancode);
 
-		index = ir_establish_scancode(kt, rc_map, &entry, true);
-		if (index >= rc_map->len) {
-			retval = -ENOMEM;
-			goto out;
-		}
+		if (kt->dev->scancode_mask)
+			entry.scancode &= kt->dev->scancode_mask;
+
+		index = rc_scancode_to_index(kt->scan, entry.protocol,
+					     entry.scancode);
+
 	} else if (ke->len == sizeof(struct rc_scancode)) {
 		/* New EVIOCSKEYCODE_V2 ioctl */
 		const struct rc_keymap_entry *rke = (struct rc_keymap_entry *)ke;
@@ -417,127 +406,63 @@ static int ir_setkeycode(struct input_dev *idev,
 			goto out;
 		}
 
-		index = ir_establish_scancode(kt, rc_map, &entry, true);
-		if (index >= rc_map->len) {
-			retval = -ENOMEM;
-			goto out;
-		}
+		if (kt->dev->scancode_mask)
+			entry.scancode &= kt->dev->scancode_mask;
+
+		index = rc_scancode_to_index(kt->scan, entry.protocol,
+					     entry.scancode);
+
 	} else {
 		retval = -EINVAL;
 		goto out;
 	}
 
-	*old_keycode = ir_update_mapping(kt, rc_map, index, ke->keycode);
-
-out:
-	spin_unlock_irqrestore(&kt->lock, flags);
-	return retval;
-}
-
-/**
- * ir_setkeytable() - sets several entries in the scancode->keycode table
- * @kt:		the struct rc_keytable descriptor
- * @to:		the struct rc_map to copy entries to
- * @from:	the struct rc_map to copy entries from
- * @return:	-ENOMEM if all keycodes could not be inserted, otherwise zero.
- *
- * This routine is used to handle table initialization.
- */
-int rc_setkeytable(struct rc_keytable *kt, const struct rc_map *from)
-{
-	struct rc_map *rc_map = &kt->rc_map;
-	struct rc_map_table entry;
-	unsigned int i, index;
-	int rc;
-
-	rc = ir_create_table(rc_map, from->name, from->size);
-	if (rc)
-		return rc;
-
-	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
-		   rc_map->size, rc_map->alloc);
-
-	for (i = 0; i < from->size; i++) {
-		if (from->rc_type == RC_TYPE_NEC)
-			entry.scancode = to_nec32(from->scan[i].scancode);
+	if (index >= kt->scan->len) {
+		/* Old entry not found */
+		*old_keycode = KEY_RESERVED;
+		if (ke->keycode == KEY_RESERVED)
+			/* removing a non-existing entry eh? */
+			goto out;
+		old_scan = rc_keytable_add_entry(kt, &entry, false);
+	} else {
+		/* Previous entry found */
+		*old_keycode = kt->scan->table[index].keycode;
+		if (ke->keycode == KEY_RESERVED)
+			old_scan = rc_keytable_remove_entry(kt, index);
 		else
-			entry.scancode = from->scan[i].scancode;
-
-		entry.protocol = from->rc_type;
-		index = ir_establish_scancode(kt, rc_map, &entry, false);
-		if (index >= rc_map->len) {
-			rc = -ENOMEM;
-			break;
-		}
-
-		ir_update_mapping(kt, rc_map, index, from->scan[i].keycode);
+			old_scan = rc_keytable_update_entry(kt, index, &entry);
 	}
 
-	if (rc)
-		ir_free_table(rc_map);
-
-	return rc;
-}
-
-/**
- * ir_lookup_by_scancode() - locate mapping by scancode
- * @rc_map:	the struct rc_map to search
- * @protocol:	protocol to look for in the table
- * @scancode:	scancode to look for in the table
- * @return:	index in the table, -1U if not found
- *
- * This routine performs binary search in RC keykeymap table for
- * given scancode.
- */
-static unsigned int ir_lookup_by_scancode(const struct rc_map *rc_map,
-					  u16 protocol, u64 scancode)
-{
-	int start = 0;
-	int end = rc_map->len - 1;
-	int mid;
-	struct rc_map_table *m;
-
-	while (start <= end) {
-		mid = (start + end) / 2;
-		m = &rc_map->scan[mid];
-
-		if (m->protocol < protocol)
-			start = mid + 1;
-		else if (m->protocol > protocol)
-			end = mid - 1;
-		else if (m->scancode < scancode)
-			start = mid + 1;
-		else if (m->scancode > scancode)
-			end = mid - 1;
-		else
-			return mid;
+out:
+	mutex_unlock(&kt->scan_mutex);
+	if (old_scan) {
+		synchronize_rcu();
+		kfree(old_scan);
 	}
-
-	return -1U;
+	return retval;
 }
 
 /**
- * ir_getkeycode() - get a keycode from the scancode->keycode table
+ * rc_keytable_get() - get an entry from the keytable
  * @idev:	the struct input_dev device descriptor
- * @scancode:	the desired scancode
- * @keycode:	used to return the keycode, if found, or KEY_RESERVED
- * @return:	always returns zero.
+ * @ke:		the requested entry which is filled in by this function
+ * @return:	zero on success, or a negative error code
  *
- * This routine is used to handle evdev EVIOCGKEY ioctl.
+ * This function handles the evdev EVIOCGKEYCODE(_V2) ioctls.
  */
-int ir_getkeycode(struct input_dev *idev,
-		  struct input_keymap_entry *ke)
+static int rc_keytable_get(struct input_dev *idev,
+			   struct input_keymap_entry *ke)
 {
 	struct rc_keymap_entry *rke = (struct rc_keymap_entry *)ke;
 	struct rc_keytable *kt = input_get_drvdata(idev);
 	struct rc_dev *rdev = kt->dev;
-	struct rc_map *rc_map = &kt->rc_map;
+	struct rc_scan *scan;
 	struct rc_map_table *entry;
-	unsigned long flags;
 	unsigned int index;
 	int retval;
 
-	spin_lock_irqsave(&kt->lock, flags);
+	rcu_read_lock();
+	scan = rcu_dereference(kt->scan);
 
 	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
 		index = ke->index;
@@ -550,11 +475,11 @@ int ir_getkeycode(struct input_dev *idev,
 		if (retval)
 			goto out;
 
-		protocol = guess_protocol(rdev);
+		protocol = guess_protocol(rdev, scan);
 		if (protocol == RC_TYPE_NEC)
 			scancode = to_nec32(scancode);
 
-		index = ir_lookup_by_scancode(rc_map, protocol, scancode);
+		index = rc_scancode_to_index(scan, protocol, scancode);
 
 	} else if (ke->len == sizeof(struct rc_scancode)) {
 		/* New EVIOCGKEYCODE_V2 ioctl */
@@ -563,16 +488,17 @@ int ir_getkeycode(struct input_dev *idev,
 			goto out;
 		}
 
-		index = ir_lookup_by_scancode(rc_map,
-					      rke->rc.protocol, rke->rc.scancode);
+		index = rc_scancode_to_index(scan,
+					     rke->rc.protocol,
+					     rke->rc.scancode);
 
 	} else {
 		retval = -EINVAL;
 		goto out;
 	}
 
-	if (index < rc_map->len) {
-		entry = &rc_map->scan[index];
+	if (index < scan->len) {
+		entry = &scan->table[index];
 		ke->index = index;
 		ke->keycode = entry->keycode;
 		if (ke->len == sizeof(int)) {
@@ -600,29 +526,10 @@ int ir_getkeycode(struct input_dev *idev,
 	retval = 0;
 
 out:
-	spin_unlock_irqrestore(&kt->lock, flags);
+	rcu_read_unlock();
 	return retval;
 }
 
-static u32 rc_get_keycode(struct rc_keytable *kt,
-			  enum rc_type protocol, u64 scancode)
-{
-	struct rc_map *rc_map;
-	unsigned int keycode = KEY_RESERVED;
-	unsigned int index;
-
-	rc_map = &kt->rc_map;
-	if (!rc_map)
-		return KEY_RESERVED;
-
-	index = ir_lookup_by_scancode(rc_map, protocol, scancode);
-	if (index < rc_map->len)
-		keycode = rc_map->scan[index].keycode;
-
-	return keycode;
-}
-
-
 /**
  * rc_g_keycode_from_table() - gets the keycode that corresponds to a scancode
  * @dev:	the struct rc_dev descriptor of the device
@@ -638,18 +545,20 @@ u32 rc_g_keycode_from_table(struct rc_dev *dev,
 			    enum rc_type protocol, u64 scancode)
 {
 	struct rc_keytable *kt;
-	unsigned int keycode = KEY_RESERVED;
-	unsigned long flags;
+	struct rc_scan *scan;
+	unsigned keycode = KEY_RESERVED;
+	unsigned index;
 
 	/* FIXME: This entire function is a hack. Remove it */
 	rcu_read_lock();
 	kt = rcu_dereference(dev->keytables[0]);
 	if (!kt)
 		goto out;
+	scan = rcu_dereference(kt->scan);
 
-	spin_lock_irqsave(&kt->lock, flags);
-	keycode = rc_get_keycode(kt, protocol, scancode);
-	spin_unlock_irqrestore(&kt->lock, flags);
+	index = rc_scancode_to_index(scan, protocol, scancode);
+	if (index < scan->len)
+		keycode = scan->table[index].keycode;
 
 out:
 	rcu_read_unlock();
@@ -663,11 +572,11 @@ EXPORT_SYMBOL_GPL(rc_g_keycode_from_table);
  * @sync:	whether or not to call input_sync
  *
  * This function is used internally to release a keypress, it must be
- * called with kt->lock held.
+ * called with kt->key_lock held.
  */
 static void rc_do_keyup(struct rc_keytable *kt, bool sync)
 {
-	if (!kt->keypressed)
+	if (!kt->key_pressed)
 		return;
 
 	IR_dprintk(1, "keyup key 0x%04x\n", kt->last_keycode);
@@ -675,7 +584,7 @@ static void rc_do_keyup(struct rc_keytable *kt, bool sync)
 	led_trigger_event(led_feedback, LED_OFF);
 	if (sync)
 		input_sync(kt->idev);
-	kt->keypressed = false;
+	kt->key_pressed = false;
 }
 
 /**
@@ -688,14 +597,14 @@ void rc_keytable_keyup(struct rc_keytable *kt)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&kt->lock, flags);
+	spin_lock_irqsave(&kt->key_lock, flags);
 	rc_do_keyup(kt, true);
-	spin_unlock_irqrestore(&kt->lock, flags);
+	spin_unlock_irqrestore(&kt->key_lock, flags);
 }
 
 /**
- * ir_timer_keyup() - generates a keyup event after a timeout
- * @cookie:	a pointer to the struct rc_keytable
+ * rc_timer_keyup() - generates a keyup event after a timeout
+ * @cookie:	a pointer to the struct rc_keytable descriptor of the keytable
  *
  * This routine will generate a keyup event some time after a keydown event
  * is generated when no further activity has been detected.
@@ -715,37 +624,36 @@ static void rc_timer_keyup(unsigned long cookie)
 	 * to allow the input subsystem to do its auto-repeat magic or
 	 * a keyup event might follow immediately after the keydown.
 	 */
-	spin_lock_irqsave(&kt->lock, flags);
+	spin_lock_irqsave(&kt->key_lock, flags);
 	if (time_is_before_eq_jiffies(kt->keyup_jiffies))
 		rc_do_keyup(kt, true);
-	spin_unlock_irqrestore(&kt->lock, flags);
+	spin_unlock_irqrestore(&kt->key_lock, flags);
 }
 
 /**
  * rc_keytable_repeat() - signals that a key is still pressed
  * @kt:		the keytable
  *
- * This routine is used by IR decoders when a repeat message which does
- * not include the necessary bits to reproduce the scancode has been
- * received.
+ * This routine is used when a repeat message which does not include the
+ * necessary bits to reproduce the scancode has been received.
  */
 void rc_keytable_repeat(struct rc_keytable *kt)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&kt->lock, flags);
+	spin_lock_irqsave(&kt->key_lock, flags);
 
 	input_event(kt->idev, EV_MSC, MSC_SCAN, kt->last_scancode);
 	input_sync(kt->idev);
 
-	if (!kt->keypressed)
+	if (!kt->key_pressed)
 		goto out;
 
-	kt->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+	kt->keyup_jiffies = jiffies + msecs_to_jiffies(RC_KEYPRESS_TIMEOUT);
 	mod_timer(&kt->timer_keyup, kt->keyup_jiffies);
 
 out:
-	spin_unlock_irqrestore(&kt->lock, flags);
+	spin_unlock_irqrestore(&kt->key_lock, flags);
 }
 
 /**
@@ -762,26 +670,33 @@ out:
 void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
 			 u32 scancode, u8 toggle, bool autoup)
 {
+	struct rc_scan *scan;
+	unsigned index;
+	u32 keycode = KEY_RESERVED;
 	unsigned long flags;
-	u32 keycode;
 	bool new_event;
 
-	spin_lock_irqsave(&kt->lock, flags);
+	rcu_read_lock();
+	scan = rcu_dereference(kt->scan);
+	index = rc_scancode_to_index(scan, protocol, scancode);
+	if (index < scan->len)
+		keycode = scan->table[index].keycode;
+	rcu_read_unlock();
 
-	keycode = rc_get_keycode(kt, protocol, scancode);
-	new_event = (!kt->keypressed ||
+	spin_lock_irqsave(&kt->key_lock, flags);
+	new_event = (!kt->key_pressed ||
 		     kt->last_protocol != protocol ||
 		     kt->last_scancode != scancode ||
 		     kt->last_toggle != toggle);
 
-	if (new_event && kt->keypressed)
+	if (new_event)
 		rc_do_keyup(kt, false);
 
 	input_event(kt->idev, EV_MSC, MSC_SCAN, scancode);
 
 	if (new_event && keycode != KEY_RESERVED) {
 		/* Register a keypress */
-		kt->keypressed = true;
+		kt->key_pressed = true;
 		kt->last_protocol = protocol;
 		kt->last_scancode = scancode;
 		kt->last_toggle = toggle;
@@ -795,11 +710,11 @@ void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
 	}
 	input_sync(kt->idev);
 
-	if (autoup && kt->keypressed) {
-		kt->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+	if (autoup && kt->key_pressed) {
+		kt->keyup_jiffies = jiffies + msecs_to_jiffies(RC_KEYPRESS_TIMEOUT);
 		mod_timer(&kt->timer_keyup, kt->keyup_jiffies);
 	}
-	spin_unlock_irqrestore(&kt->lock, flags);
+	spin_unlock_irqrestore(&kt->key_lock, flags);
 }
 
 static int rc_input_open(struct input_dev *idev)
@@ -817,6 +732,42 @@ static void rc_input_close(struct input_dev *idev)
 }
 
 /**
+ * rc_keytable_init() - performs initial setup of a keytable
+ * @dev:	the struct rc_dev device descriptor
+ * @from:	the struct rc_map to copy entries from
+ * @return:	zero on success, or a negative error code
+ *
+ * This function is used to handle table initialization.
+ */
+static int rc_keytable_init(struct rc_keytable *kt,
+			    const struct rc_map *from)
+{
+	unsigned size;
+	unsigned i;
+	struct rc_map_table entry;
+
+	size = from ? from->size : 0;
+	kt->scan = kmalloc(rc_scan_size(size), GFP_KERNEL);
+	if (!kt->scan)
+		return -ENOMEM;
+
+	kt->scan->len = 0;
+	for (i = 0; i < size; i++) {
+		entry.protocol = from->rc_type;
+		if (entry.protocol == RC_TYPE_NEC)
+			entry.scancode = to_nec32(from->scan[i].scancode);
+		else
+			entry.scancode = from->scan[i].scancode;
+		if (kt->dev->scancode_mask)
+			entry.scancode &= kt->dev->scancode_mask;
+		entry.keycode = from->scan[i].keycode;
+		rc_keytable_add_entry(kt, &entry, true);
+	}
+
+	return 0;
+}
+
+/**
  * rc_keytable_create() - create a new keytable
  * @dev:	the struct rc_dev device this keytable should belong to
  * @name:	the userfriendly name of this keymap
@@ -848,10 +799,11 @@ struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *name,
 
 	kt->idev = idev;
 	kt->dev = dev;
-	spin_lock_init(&kt->lock);
+	spin_lock_init(&kt->key_lock);
+	mutex_init(&kt->scan_mutex);
 	snprintf(kt->name, sizeof(*kt->name), name ? name : "undefined");
-	idev->getkeycode = ir_getkeycode;
-	idev->setkeycode = ir_setkeycode;
+	idev->getkeycode = rc_keytable_get;
+	idev->setkeycode = rc_keytable_set;
 	idev->open = rc_input_open;
 	idev->close = rc_input_close;
 	set_bit(EV_KEY, idev->evbit);
@@ -861,7 +813,7 @@ struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *name,
 	input_set_drvdata(idev, kt);
 	setup_timer(&kt->timer_keyup, rc_timer_keyup, (unsigned long)kt);
 
-	err = rc_setkeytable(kt, rc_map);
+	err = rc_keytable_init(kt, rc_map);
 	if (err)
 		goto out;
 
@@ -892,8 +844,8 @@ struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *name,
 	return kt;
 
 out:
-	ir_free_table(&kt->rc_map);
 	input_free_device(idev);
+	kfree(kt->scan);
 	kfree(kt);
 	return ERR_PTR(err);
 }
@@ -910,8 +862,8 @@ void rc_keytable_destroy(struct rc_keytable *kt)
 		return;
 
 	del_timer_sync(&kt->timer_keyup);
-	ir_free_table(&kt->rc_map);
 	input_unregister_device(kt->idev);
+	kfree(kt->scan);
 	kfree(kt);
 }
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index af63188..228510e 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -386,35 +386,47 @@ struct rc_dev {
 };
 
 /**
+ * struct rc_scan - rcu-friendly scancode<->keycode table
+ * @len:	number of elements in the table array
+ * @table:	array of struct rc_map_table elements
+ */
+struct rc_scan {
+	unsigned len;
+	struct rc_map_table table[];
+};
+
+/**
  * struct rc_keytable - represents one keytable for a rc_dev device
  * @node:		used to iterate over all keytables for a rc_dev device
  * @dev:		the rc_dev device this keytable belongs to
  * @idev:		the input_dev device which belongs to this keytable
  * @name:		the user-friendly name of this keytable
- * @rc_map:		holds the scancode <-> keycode mappings
- * @keypressed:		whether a key is currently pressed or not
- * @keyup_jiffies:	when the key should be auto-released
- * @timer_keyup:	responsible for the auto-release of keys
- * @lock:		protects the key state
+ * @scan_mutex:		protects @scan against concurrent writers
+ * @scan:		the current scancode<->keycode table
+ * @key_lock:		protects the key state
+ * @key_pressed:	whether a key is currently pressed or not
  * @last_keycode:	keycode of the last keypress
  * @last_protocol:	protocol of the last keypress
  * @last_scancode:	scancode of the last keypress
  * @last_toggle:	toggle of the last keypress
+ * @timer_keyup:	responsible for the auto-release of keys
+ * @keyup_jiffies:	when the key should be auto-released
  */
 struct rc_keytable {
 	struct list_head		node;
 	struct rc_dev			*dev;
 	struct input_dev		*idev;
 	char				name[RC_KEYTABLE_NAME_SIZE];
-	struct rc_map			rc_map;
-	bool				keypressed;
-	unsigned long			keyup_jiffies;
-	struct timer_list		timer_keyup;
-	spinlock_t			lock;
+	struct mutex			scan_mutex;
+	struct rc_scan __rcu		*scan;
+	spinlock_t			key_lock;
+	bool				key_pressed;
 	u32				last_keycode;
 	enum rc_type			last_protocol;
 	u32				last_scancode;
 	u8				last_toggle;
+	struct timer_list		timer_keyup;
+	unsigned long			keyup_jiffies;
 };
 
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)

