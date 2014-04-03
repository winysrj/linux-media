Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40325 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbaDCXdz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:33:55 -0400
Subject: [PATCH 31/49] rc-core: split rc-main.c into rc-main.c and
 rc-keytable.c
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:33:52 +0200
Message-ID: <20140403233352.27099.68688.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rc-main.c is getting quite large and contains two distinct parts, one
related to the chardev (fops, sysfs, etc) and one related to all
key functionality. Split off the key functionality to a separate file in
preparation for the coming patches.

I've done the splitting as a separate patch with the absolute minimum changes
(making some methods non-static) because it's nigh impossible to review
code changes and this code of split in the same patch.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/Makefile       |    2 
 drivers/media/rc/rc-core-priv.h |   17 +
 drivers/media/rc/rc-keytable.c  |  851 +++++++++++++++++++++++++++++++++++++++
 drivers/media/rc/rc-main.c      |  853 +--------------------------------------
 4 files changed, 883 insertions(+), 840 deletions(-)
 create mode 100644 drivers/media/rc/rc-keytable.c

diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index d326d4d..de08ee6 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -1,4 +1,4 @@
-rc-core-objs	:= rc-main.o ir-raw.o
+rc-core-objs	:= rc-main.o rc-keytable.o ir-raw.o
 
 obj-y += keymaps/
 
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index aacc192..6da8a0d 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -155,9 +155,26 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_init(void);
 
+/*
+ * Methods from rc-keytable.c to be used internally
+ */
+void ir_timer_keyup(unsigned long cookie);
+int rc_input_open(struct input_dev *idev);
+void rc_input_close(struct input_dev *idev);
+int ir_setkeytable(struct rc_dev *dev, const struct rc_map *from);
+void ir_free_table(struct rc_map *rc_map);
+int ir_getkeycode(struct input_dev *idev,
+		  struct input_keymap_entry *ke);
+int ir_setkeycode(struct input_dev *idev,
+		  const struct input_keymap_entry *ke,
+		  unsigned int *old_keycode);
+
 /* Only to be used by rc-core and ir-lirc-codec */
 void rc_init_ir_rx(struct rc_dev *dev, struct rc_ir_rx *rx);
 
+/* Only to be used by rc-keytable.c */
+extern struct led_trigger *led_feedback;
+
 /*
  * Decoder initialization code
  *
diff --git a/drivers/media/rc/rc-keytable.c b/drivers/media/rc/rc-keytable.c
new file mode 100644
index 0000000..25faeba
--- /dev/null
+++ b/drivers/media/rc/rc-keytable.c
@@ -0,0 +1,851 @@
+/* rc-keytable.c - Remote Controller keytable handling
+ *
+ * Copyright (C) 2009-2010 by Mauro Carvalho Chehab
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
+#include <media/rc-core.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/leds.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/idr.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/poll.h>
+#include "rc-core-priv.h"
+
+/* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
+#define IR_TAB_MIN_SIZE		256
+#define IR_TAB_MAX_SIZE		8192
+
+/* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
+#define IR_KEYPRESS_TIMEOUT 250
+
+/* Used to keep track of known keymaps */
+static LIST_HEAD(rc_map_list);
+static DEFINE_SPINLOCK(rc_map_lock);
+
+static struct rc_map_list *seek_rc_map(const char *name)
+{
+	struct rc_map_list *map = NULL;
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
+struct rc_map *rc_map_get(const char *name)
+{
+
+	struct rc_map_list *map;
+
+	map = seek_rc_map(name);
+#ifdef MODULE
+	if (!map) {
+		int rc = request_module("%s", name);
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
+EXPORT_SYMBOL_GPL(rc_map_get);
+
+int rc_map_register(struct rc_map_list *map)
+{
+	spin_lock(&rc_map_lock);
+	list_add_tail(&map->list, &rc_map_list);
+	spin_unlock(&rc_map_lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rc_map_register);
+
+void rc_map_unregister(struct rc_map_list *map)
+{
+	spin_lock(&rc_map_lock);
+	list_del(&map->list);
+	spin_unlock(&rc_map_lock);
+}
+EXPORT_SYMBOL_GPL(rc_map_unregister);
+
+/**
+ * ir_create_table() - initializes a scancode table
+ * @rc_map:	the rc_map to initialize
+ * @name:	name to assign to the table
+ * @size:	initial size of the table
+ * @return:	zero on success or a negative error code
+ *
+ * This routine will initialize the rc_map and will allocate
+ * memory to hold at least the specified number of elements.
+ */
+static int ir_create_table(struct rc_map *rc_map,
+			   const char *name, size_t size)
+{
+	rc_map->name = name;
+	rc_map->alloc = roundup_pow_of_two(size * sizeof(struct rc_map_table));
+	rc_map->size = rc_map->alloc / sizeof(struct rc_map_table);
+	rc_map->scan = kmalloc(rc_map->alloc, GFP_KERNEL);
+	if (!rc_map->scan)
+		return -ENOMEM;
+
+	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
+		   rc_map->size, rc_map->alloc);
+	return 0;
+}
+
+/**
+ * ir_free_table() - frees memory allocated by a scancode table
+ * @rc_map:	the table whose mappings need to be freed
+ *
+ * This routine will free memory alloctaed for key mappings used by given
+ * scancode table.
+ */
+void ir_free_table(struct rc_map *rc_map)
+{
+	rc_map->size = 0;
+	kfree(rc_map->scan);
+	rc_map->scan = NULL;
+}
+
+/**
+ * ir_resize_table() - resizes a scancode table if necessary
+ * @rc_map:	the rc_map to resize
+ * @gfp_flags:	gfp flags to use when allocating memory
+ * @return:	zero on success or a negative error code
+ *
+ * This routine will shrink the rc_map if it has lots of
+ * unused entries and grow it if it is full.
+ */
+static int ir_resize_table(struct rc_map *rc_map, gfp_t gfp_flags)
+{
+	unsigned int oldalloc = rc_map->alloc;
+	unsigned int newalloc = oldalloc;
+	struct rc_map_table *oldscan = rc_map->scan;
+	struct rc_map_table *newscan;
+
+	if (rc_map->size == rc_map->len) {
+		/* All entries in use -> grow keytable */
+		if (rc_map->alloc >= IR_TAB_MAX_SIZE)
+			return -ENOMEM;
+
+		newalloc *= 2;
+		IR_dprintk(1, "Growing table to %u bytes\n", newalloc);
+	}
+
+	if ((rc_map->len * 3 < rc_map->size) && (oldalloc > IR_TAB_MIN_SIZE)) {
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
+	memcpy(newscan, rc_map->scan, rc_map->len * sizeof(struct rc_map_table));
+	rc_map->scan = newscan;
+	rc_map->alloc = newalloc;
+	rc_map->size = rc_map->alloc / sizeof(struct rc_map_table);
+	kfree(oldscan);
+	return 0;
+}
+
+/**
+ * ir_update_mapping() - set a keycode in the scancode->keycode table
+ * @dev:	the struct rc_dev device descriptor
+ * @rc_map:	scancode table to be adjusted
+ * @index:	index of the mapping that needs to be updated
+ * @keycode:	the desired keycode
+ * @return:	previous keycode assigned to the mapping
+ *
+ * This routine is used to update scancode->keycode mapping at given
+ * position.
+ */
+static unsigned int ir_update_mapping(struct rc_dev *dev,
+				      struct rc_map *rc_map,
+				      unsigned int index,
+				      unsigned int new_keycode)
+{
+	int old_keycode = rc_map->scan[index].keycode;
+	int i;
+
+	/* Did the user wish to remove the mapping? */
+	if (new_keycode == KEY_RESERVED || new_keycode == KEY_UNKNOWN) {
+		IR_dprintk(1, "#%d: Deleting proto 0x%04x, scan 0x%08llx\n",
+			   index, rc_map->scan[index].protocol,
+			   (unsigned long long)rc_map->scan[index].scancode);
+		rc_map->len--;
+		memmove(&rc_map->scan[index], &rc_map->scan[index+ 1],
+			(rc_map->len - index) * sizeof(struct rc_map_table));
+	} else {
+		IR_dprintk(1, "#%d: %s proto 0x%04x, scan 0x%08llx "
+			   "with key 0x%04x\n",
+			   index,
+			   old_keycode == KEY_RESERVED ? "New" : "Replacing",
+			   rc_map->scan[index].protocol,
+			   (unsigned long long)rc_map->scan[index].scancode,
+			   new_keycode);
+		rc_map->scan[index].keycode = new_keycode;
+		__set_bit(new_keycode, dev->input_dev->keybit);
+	}
+
+	if (old_keycode != KEY_RESERVED) {
+		/* A previous mapping was updated... */
+		__clear_bit(old_keycode, dev->input_dev->keybit);
+		/* ... but another scancode might use the same keycode */
+		for (i = 0; i < rc_map->len; i++) {
+			if (rc_map->scan[i].keycode == old_keycode) {
+				__set_bit(old_keycode, dev->input_dev->keybit);
+				break;
+			}
+		}
+
+		/* Possibly shrink the keytable, failure is not a problem */
+		ir_resize_table(rc_map, GFP_ATOMIC);
+	}
+
+	return old_keycode;
+}
+
+/**
+ * ir_establish_scancode() - set a keycode in the scancode->keycode table
+ * @dev:	the struct rc_dev device descriptor
+ * @rc_map:	scancode table to be searched
+ * @entry:	the entry to be added to the table
+ * @resize:	controls whether we are allowed to resize the table to
+ *		accomodate not yet present scancodes
+ * @return:	index of the mapping containing scancode in question
+ *		or -1U in case of failure.
+ *
+ * This routine is used to locate given scancode in rc_map.
+ * If scancode is not yet present the routine will allocate a new slot
+ * for it.
+ */
+static unsigned int ir_establish_scancode(struct rc_dev *dev,
+					  struct rc_map *rc_map,
+					  struct rc_map_table *entry,
+					  bool resize)
+{
+	unsigned int i;
+
+	/*
+	 * Unfortunately, some hardware-based IR decoders don't provide
+	 * all bits for the complete IR code. In general, they provide only
+	 * the command part of the IR code. Yet, as it is possible to replace
+	 * the provided IR with another one, it is needed to allow loading
+	 * IR tables from other remotes. So, we support specifying a mask to
+	 * indicate the valid bits of the scancodes.
+	 */
+	if (dev->scancode_mask)
+		entry->scancode &= dev->scancode_mask;
+
+	/*
+	 * First check if we already have a mapping for this command.
+	 * Note that the keytable is sorted first on protocol and second
+	 * on scancode (lowest to highest).
+	 */
+	for (i = 0; i < rc_map->len; i++) {
+		if (rc_map->scan[i].protocol < entry->protocol)
+			continue;
+
+		if (rc_map->scan[i].protocol > entry->protocol)
+			break;
+
+		if (rc_map->scan[i].scancode < entry->scancode)
+			continue;
+
+		if (rc_map->scan[i].scancode > entry->scancode)
+			break;
+
+		return i;
+	}
+
+	/* No previous mapping found, we might need to grow the table */
+	if (rc_map->size == rc_map->len) {
+		if (!resize || ir_resize_table(rc_map, GFP_ATOMIC))
+			return -1U;
+	}
+
+	/* i is the proper index to insert our new keycode */
+	if (i < rc_map->len)
+		memmove(&rc_map->scan[i + 1], &rc_map->scan[i],
+			(rc_map->len - i) * sizeof(struct rc_map_table));
+	rc_map->scan[i].scancode = entry->scancode;
+	rc_map->scan[i].protocol = entry->protocol;
+	rc_map->scan[i].keycode = KEY_RESERVED;
+	rc_map->len++;
+
+	return i;
+}
+
+/**
+ * guess_protocol() - heuristics to guess the protocol for a scancode
+ * @rdev:	the struct rc_dev device descriptor
+ * @return:	the guessed RC_TYPE_* protocol
+ *
+ * Internal routine to guess the current IR protocol for legacy ioctls.
+ */
+static inline enum rc_type guess_protocol(struct rc_dev *rdev)
+{
+	struct rc_map *rc_map = &rdev->rc_map;
+
+	if (hweight64(rdev->enabled_protocols) == 1)
+		return rc_bitmap_to_type(rdev->enabled_protocols);
+	else if (hweight64(rdev->allowed_protocols) == 1)
+		return rc_bitmap_to_type(rdev->allowed_protocols);
+	else if (rc_map->len > 0)
+		return rc_map->scan[0].protocol;
+	else
+		return RC_TYPE_OTHER;
+}
+
+/**
+ * to_nec32() - helper function to try to convert misc NEC scancodes to NEC32
+ * @orig:	original scancode
+ * @return:	NEC32 scancode
+ *
+ * This helper routine is used to provide backwards compatibility.
+ */
+static u32 to_nec32(u32 orig)
+{
+	u8 b3 = (u8)(orig >> 16);
+	u8 b2 = (u8)(orig >>  8);
+	u8 b1 = (u8)(orig >>  0);
+
+	if (orig <= 0xffff)
+		/* Plain old NEC */
+		return b2 << 24 | ((u8)~b2) << 16 |  b1 << 8 | ((u8)~b1);
+	else if (orig <= 0xffffff)
+		/* NEC extended */
+		return b3 << 24 | b2 << 16 |  b1 << 8 | ((u8)~b1);
+	else
+		/* NEC32 */
+		return orig;
+}
+
+/**
+ * ir_setkeycode() - set a keycode in the scancode->keycode table
+ * @idev:	the struct input_dev device descriptor
+ * @scancode:	the desired scancode
+ * @keycode:	result
+ * @return:	-EINVAL if the keycode could not be inserted, otherwise zero.
+ *
+ * This routine is used to handle evdev EVIOCSKEY ioctl.
+ */
+int ir_setkeycode(struct input_dev *idev,
+		  const struct input_keymap_entry *ke,
+		  unsigned int *old_keycode)
+{
+	struct rc_dev *rdev = input_get_drvdata(idev);
+	struct rc_map *rc_map = &rdev->rc_map;
+	unsigned int index;
+	struct rc_map_table entry;
+	int retval = 0;
+	unsigned long flags;
+
+	entry.keycode = ke->keycode;
+
+	spin_lock_irqsave(&rc_map->lock, flags);
+
+	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
+		index = ke->index;
+		if (index >= rc_map->len) {
+			retval = -EINVAL;
+			goto out;
+		}
+	} else if (ke->len == sizeof(int)) {
+		/* Legacy EVIOCSKEYCODE ioctl */
+		u32 scancode;
+		retval = input_scancode_to_scalar(ke, &scancode);
+		if (retval)
+			goto out;
+
+		entry.scancode = scancode;
+		entry.protocol = guess_protocol(rdev);
+		if (entry.protocol == RC_TYPE_NEC)
+			entry.scancode = to_nec32(scancode);
+
+		index = ir_establish_scancode(rdev, rc_map, &entry, true);
+		if (index >= rc_map->len) {
+			retval = -ENOMEM;
+			goto out;
+		}
+	} else if (ke->len == sizeof(struct rc_scancode)) {
+		/* New EVIOCSKEYCODE_V2 ioctl */
+		const struct rc_keymap_entry *rke = (struct rc_keymap_entry *)ke;
+		entry.protocol = rke->rc.protocol;
+		entry.scancode = rke->rc.scancode;
+
+		if (rke->rc.reserved[0] || rke->rc.reserved[1] || rke->rc.reserved[2]) {
+			retval = -EINVAL;
+			goto out;
+		}
+
+		index = ir_establish_scancode(rdev, rc_map, &entry, true);
+		if (index >= rc_map->len) {
+			retval = -ENOMEM;
+			goto out;
+		}
+	} else {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	*old_keycode = ir_update_mapping(rdev, rc_map, index, ke->keycode);
+
+out:
+	spin_unlock_irqrestore(&rc_map->lock, flags);
+	return retval;
+}
+
+/**
+ * ir_setkeytable() - sets several entries in the scancode->keycode table
+ * @dev:	the struct rc_dev device descriptor
+ * @to:		the struct rc_map to copy entries to
+ * @from:	the struct rc_map to copy entries from
+ * @return:	-ENOMEM if all keycodes could not be inserted, otherwise zero.
+ *
+ * This routine is used to handle table initialization.
+ */
+int ir_setkeytable(struct rc_dev *dev, const struct rc_map *from)
+{
+	struct rc_map *rc_map = &dev->rc_map;
+	struct rc_map_table entry;
+	unsigned int i, index;
+	int rc;
+
+	rc = ir_create_table(rc_map, from->name, from->size);
+	if (rc)
+		return rc;
+
+	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
+		   rc_map->size, rc_map->alloc);
+
+	for (i = 0; i < from->size; i++) {
+		if (from->rc_type == RC_TYPE_NEC)
+			entry.scancode = to_nec32(from->scan[i].scancode);
+		else
+			entry.scancode = from->scan[i].scancode;
+
+		entry.protocol = from->rc_type;
+		index = ir_establish_scancode(dev, rc_map, &entry, false);
+		if (index >= rc_map->len) {
+			rc = -ENOMEM;
+			break;
+		}
+
+		ir_update_mapping(dev, rc_map, index, from->scan[i].keycode);
+	}
+
+	if (rc)
+		ir_free_table(rc_map);
+
+	return rc;
+}
+
+/**
+ * ir_lookup_by_scancode() - locate mapping by scancode
+ * @rc_map:	the struct rc_map to search
+ * @protocol:	protocol to look for in the table
+ * @scancode:	scancode to look for in the table
+ * @return:	index in the table, -1U if not found
+ *
+ * This routine performs binary search in RC keykeymap table for
+ * given scancode.
+ */
+static unsigned int ir_lookup_by_scancode(const struct rc_map *rc_map,
+					  u16 protocol, u64 scancode)
+{
+	int start = 0;
+	int end = rc_map->len - 1;
+	int mid;
+	struct rc_map_table *m;
+
+	while (start <= end) {
+		mid = (start + end) / 2;
+		m = &rc_map->scan[mid];
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
+ * ir_getkeycode() - get a keycode from the scancode->keycode table
+ * @idev:	the struct input_dev device descriptor
+ * @scancode:	the desired scancode
+ * @keycode:	used to return the keycode, if found, or KEY_RESERVED
+ * @return:	always returns zero.
+ *
+ * This routine is used to handle evdev EVIOCGKEY ioctl.
+ */
+int ir_getkeycode(struct input_dev *idev,
+		  struct input_keymap_entry *ke)
+{
+	struct rc_keymap_entry *rke = (struct rc_keymap_entry *)ke;
+	struct rc_dev *rdev = input_get_drvdata(idev);
+	struct rc_map *rc_map = &rdev->rc_map;
+	struct rc_map_table *entry;
+	unsigned long flags;
+	unsigned int index;
+	int retval;
+
+	spin_lock_irqsave(&rc_map->lock, flags);
+
+	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
+		index = ke->index;
+	} else if (ke->len == sizeof(int)) {
+		/* Legacy EVIOCGKEYCODE ioctl */
+		u32 scancode;
+		u16 protocol;
+
+		retval = input_scancode_to_scalar(ke, &scancode);
+		if (retval)
+			goto out;
+
+		protocol = guess_protocol(rdev);
+		if (protocol == RC_TYPE_NEC)
+			scancode = to_nec32(scancode);
+
+		index = ir_lookup_by_scancode(rc_map, protocol, scancode);
+
+	} else if (ke->len == sizeof(struct rc_scancode)) {
+		/* New EVIOCGKEYCODE_V2 ioctl */
+		if (rke->rc.reserved[0] || rke->rc.reserved[1] || rke->rc.reserved[2]) {
+			retval = -EINVAL;
+			goto out;
+		}
+
+		index = ir_lookup_by_scancode(rc_map,
+					      rke->rc.protocol, rke->rc.scancode);
+
+	} else {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	if (index < rc_map->len) {
+		entry = &rc_map->scan[index];
+		ke->index = index;
+		ke->keycode = entry->keycode;
+		if (ke->len == sizeof(int)) {
+			u32 scancode = entry->scancode;
+			memcpy(ke->scancode, &scancode, sizeof(scancode));
+		} else {
+			ke->len = sizeof(struct rc_scancode);
+			rke->rc.protocol = entry->protocol;
+			rke->rc.scancode = entry->scancode;
+		}
+
+	} else if (!(ke->flags & INPUT_KEYMAP_BY_INDEX)) {
+		/*
+		 * We do not really know the valid range of scancodes
+		 * so let's respond with KEY_RESERVED to anything we
+		 * do not have mapping for [yet].
+		 */
+		ke->index = index;
+		ke->keycode = KEY_RESERVED;
+	} else {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	retval = 0;
+
+out:
+	spin_unlock_irqrestore(&rc_map->lock, flags);
+	return retval;
+}
+
+/**
+ * rc_g_keycode_from_table() - gets the keycode that corresponds to a scancode
+ * @dev:	the struct rc_dev descriptor of the device
+ * @protocol:	the protocol to look for
+ * @scancode:	the scancode to look for
+ * @return:	the corresponding keycode, or KEY_RESERVED
+ *
+ * This routine is used by drivers which need to convert a scancode to a
+ * keycode. Normally it should not be used since drivers should have no
+ * interest in keycodes.
+ */
+u32 rc_g_keycode_from_table(struct rc_dev *dev,
+			    enum rc_type protocol, u64 scancode)
+{
+	struct rc_map *rc_map = &dev->rc_map;
+	unsigned int keycode;
+	unsigned int index;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rc_map->lock, flags);
+
+	index = ir_lookup_by_scancode(rc_map, protocol, scancode);
+	keycode = index < rc_map->len ?
+			rc_map->scan[index].keycode : KEY_RESERVED;
+
+	spin_unlock_irqrestore(&rc_map->lock, flags);
+
+	if (keycode != KEY_RESERVED)
+		IR_dprintk(1, "%s: protocol 0x%04x scancode 0x%08llx keycode 0x%02x\n",
+			   dev->input_name, protocol,
+			   (unsigned long long)scancode, keycode);
+
+	return keycode;
+}
+EXPORT_SYMBOL_GPL(rc_g_keycode_from_table);
+
+/**
+ * ir_do_keyup() - internal function to signal the release of a keypress
+ * @dev:	the struct rc_dev descriptor of the device
+ * @sync:	whether or not to call input_sync
+ *
+ * This function is used internally to release a keypress, it must be
+ * called with keylock held.
+ */
+static void ir_do_keyup(struct rc_dev *dev, bool sync)
+{
+	if (!dev->keypressed)
+		return;
+
+	IR_dprintk(1, "keyup key 0x%04x\n", dev->last_keycode);
+	input_report_key(dev->input_dev, dev->last_keycode, 0);
+	led_trigger_event(led_feedback, LED_OFF);
+	if (sync)
+		input_sync(dev->input_dev);
+	dev->keypressed = false;
+}
+
+/**
+ * rc_keyup() - signals the release of a keypress
+ * @dev:	the struct rc_dev descriptor of the device
+ *
+ * This routine is used to signal that a key has been released on the
+ * remote control.
+ */
+void rc_keyup(struct rc_dev *dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->keylock, flags);
+	ir_do_keyup(dev, true);
+	spin_unlock_irqrestore(&dev->keylock, flags);
+}
+EXPORT_SYMBOL_GPL(rc_keyup);
+
+/**
+ * ir_timer_keyup() - generates a keyup event after a timeout
+ * @cookie:	a pointer to the struct rc_dev for the device
+ *
+ * This routine will generate a keyup event some time after a keydown event
+ * is generated when no further activity has been detected.
+ */
+void ir_timer_keyup(unsigned long cookie)
+{
+	struct rc_dev *dev = (struct rc_dev *)cookie;
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
+	spin_lock_irqsave(&dev->keylock, flags);
+	if (time_is_before_eq_jiffies(dev->keyup_jiffies))
+		ir_do_keyup(dev, true);
+	spin_unlock_irqrestore(&dev->keylock, flags);
+}
+
+/**
+ * rc_repeat() - signals that a key is still pressed
+ * @dev:	the struct rc_dev descriptor of the device
+ *
+ * This routine is used by IR decoders when a repeat message which does
+ * not include the necessary bits to reproduce the scancode has been
+ * received.
+ */
+void rc_repeat(struct rc_dev *dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->keylock, flags);
+
+	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
+	input_sync(dev->input_dev);
+	rc_event(dev, RC_KEY, RC_KEY_REPEAT, 1);
+
+	if (!dev->keypressed)
+		goto out;
+
+	dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+	mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
+
+out:
+	spin_unlock_irqrestore(&dev->keylock, flags);
+}
+EXPORT_SYMBOL_GPL(rc_repeat);
+
+/**
+ * ir_do_keydown() - internal function to process a keypress
+ * @dev:	the struct rc_dev descriptor of the device
+ * @protocol:	the protocol of the keypress
+ * @scancode:   the scancode of the keypress
+ * @keycode:    the keycode of the keypress
+ * @toggle:     the toggle value of the keypress
+ *
+ * This function is used internally to register a keypress, it must be
+ * called with keylock held.
+ */
+static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
+			  u32 scancode, u32 keycode, u8 toggle)
+{
+	bool new_event = (!dev->keypressed		 ||
+			  dev->last_protocol != protocol ||
+			  dev->last_scancode != scancode ||
+			  dev->last_toggle   != toggle);
+
+	if (new_event && dev->keypressed)
+		ir_do_keyup(dev, false);
+
+	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
+	rc_event(dev, RC_KEY, RC_KEY_PROTOCOL, protocol);
+	/*
+	 * NOTE: If we ever get > 32 bit scancodes, we need to break the
+	 *	 scancode into 32 bit pieces and feed them to userspace
+	 *	 as one or more RC_KEY_SCANCODE_PART events followed
+	 *	 by a final RC_KEY_SCANCODE event.
+	 */
+	rc_event(dev, RC_KEY, RC_KEY_SCANCODE, scancode);
+	rc_event(dev, RC_KEY, RC_KEY_TOGGLE, toggle);
+
+	if (new_event && keycode != KEY_RESERVED) {
+		/* Register a keypress */
+		dev->keypressed = true;
+		dev->last_protocol = protocol;
+		dev->last_scancode = scancode;
+		dev->last_toggle = toggle;
+		dev->last_keycode = keycode;
+
+		IR_dprintk(1, "%s: key down event, "
+			   "key 0x%04x, protocol 0x%04x, scancode 0x%08x\n",
+			   dev->input_name, keycode, protocol, scancode);
+		input_report_key(dev->input_dev, keycode, 1);
+
+		led_trigger_event(led_feedback, LED_FULL);
+	}
+
+	input_sync(dev->input_dev);
+}
+
+/**
+ * rc_keydown() - generates input event for a key press
+ * @dev:	the struct rc_dev descriptor of the device
+ * @protocol:	the protocol for the keypress
+ * @scancode:	the scancode for the keypress
+ * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
+ *              support toggle values, this should be set to zero)
+ *
+ * This routine is used to signal that a key has been pressed on the
+ * remote control.
+ */
+void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle)
+{
+	unsigned long flags;
+	u32 keycode = rc_g_keycode_from_table(dev, protocol, scancode);
+
+	spin_lock_irqsave(&dev->keylock, flags);
+	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
+
+	if (dev->keypressed) {
+		dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
+	}
+	spin_unlock_irqrestore(&dev->keylock, flags);
+}
+EXPORT_SYMBOL_GPL(rc_keydown);
+
+/**
+ * rc_keydown_notimeout() - generates input event for a key press without
+ *                          an automatic keyup event at a later time
+ * @dev:	the struct rc_dev descriptor of the device
+ * @protocol:	the protocol for the keypress
+ * @scancode:	the scancode for the keypress
+ * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
+ *              support toggle values, this should be set to zero)
+ *
+ * This routine is used to signal that a key has been pressed on the
+ * remote control. The driver must manually call rc_keyup() at a later stage.
+ */
+void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol,
+			  u32 scancode, u8 toggle)
+{
+	unsigned long flags;
+	u32 keycode = rc_g_keycode_from_table(dev, protocol, scancode);
+
+	spin_lock_irqsave(&dev->keylock, flags);
+	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
+	spin_unlock_irqrestore(&dev->keylock, flags);
+}
+EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
+
+int rc_input_open(struct input_dev *idev)
+{
+	struct rc_dev *rdev = input_get_drvdata(idev);
+
+	return rc_open(rdev);
+}
+
+void rc_input_close(struct input_dev *idev)
+{
+	struct rc_dev *rdev = input_get_drvdata(idev);
+	rc_close(rdev);
+}
+
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index cc2f713..a01fce2 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -25,19 +25,9 @@
 #include <linux/poll.h>
 #include "rc-core-priv.h"
 
-/* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
-#define IR_TAB_MIN_SIZE		256
-#define IR_TAB_MAX_SIZE		8192
 #define RC_DEV_MAX		256
 #define RC_RX_BUFFER_SIZE	1024
-
-/* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
-#define IR_KEYPRESS_TIMEOUT 250
-
-/* Used to keep track of known keymaps */
-static LIST_HEAD(rc_map_list);
-static DEFINE_SPINLOCK(rc_map_lock);
-static struct led_trigger *led_feedback;
+struct led_trigger *led_feedback;
 
 /* Used to keep track of rc devices */
 static DEFINE_IDA(rc_ida);
@@ -115,821 +105,6 @@ void rc_event(struct rc_dev *dev, u16 type, u16 code, u32 val)
 }
 EXPORT_SYMBOL_GPL(rc_event);
 
-static struct rc_map_list *seek_rc_map(const char *name)
-{
-	struct rc_map_list *map = NULL;
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
-struct rc_map *rc_map_get(const char *name)
-{
-
-	struct rc_map_list *map;
-
-	map = seek_rc_map(name);
-#ifdef MODULE
-	if (!map) {
-		int rc = request_module("%s", name);
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
-EXPORT_SYMBOL_GPL(rc_map_get);
-
-int rc_map_register(struct rc_map_list *map)
-{
-	spin_lock(&rc_map_lock);
-	list_add_tail(&map->list, &rc_map_list);
-	spin_unlock(&rc_map_lock);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rc_map_register);
-
-void rc_map_unregister(struct rc_map_list *map)
-{
-	spin_lock(&rc_map_lock);
-	list_del(&map->list);
-	spin_unlock(&rc_map_lock);
-}
-EXPORT_SYMBOL_GPL(rc_map_unregister);
-
-
-static struct rc_map_table empty[] = {
-	{ RC_TYPE_OTHER, 0x2a, KEY_COFFEE },
-};
-
-static struct rc_map_list empty_map = {
-	.map = {
-		.scan    = empty,
-		.size    = ARRAY_SIZE(empty),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_EMPTY,
-	}
-};
-
-/**
- * ir_create_table() - initializes a scancode table
- * @rc_map:	the rc_map to initialize
- * @name:	name to assign to the table
- * @size:	initial size of the table
- * @return:	zero on success or a negative error code
- *
- * This routine will initialize the rc_map and will allocate
- * memory to hold at least the specified number of elements.
- */
-static int ir_create_table(struct rc_map *rc_map,
-			   const char *name, size_t size)
-{
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
-}
-
-/**
- * ir_free_table() - frees memory allocated by a scancode table
- * @rc_map:	the table whose mappings need to be freed
- *
- * This routine will free memory alloctaed for key mappings used by given
- * scancode table.
- */
-static void ir_free_table(struct rc_map *rc_map)
-{
-	rc_map->size = 0;
-	kfree(rc_map->scan);
-	rc_map->scan = NULL;
-}
-
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
-
-	if ((rc_map->len * 3 < rc_map->size) && (oldalloc > IR_TAB_MIN_SIZE)) {
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
-	memcpy(newscan, rc_map->scan, rc_map->len * sizeof(struct rc_map_table));
-	rc_map->scan = newscan;
-	rc_map->alloc = newalloc;
-	rc_map->size = rc_map->alloc / sizeof(struct rc_map_table);
-	kfree(oldscan);
-	return 0;
-}
-
-/**
- * ir_update_mapping() - set a keycode in the scancode->keycode table
- * @dev:	the struct rc_dev device descriptor
- * @rc_map:	scancode table to be adjusted
- * @index:	index of the mapping that needs to be updated
- * @keycode:	the desired keycode
- * @return:	previous keycode assigned to the mapping
- *
- * This routine is used to update scancode->keycode mapping at given
- * position.
- */
-static unsigned int ir_update_mapping(struct rc_dev *dev,
-				      struct rc_map *rc_map,
-				      unsigned int index,
-				      unsigned int new_keycode)
-{
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
-		__set_bit(new_keycode, dev->input_dev->keybit);
-	}
-
-	if (old_keycode != KEY_RESERVED) {
-		/* A previous mapping was updated... */
-		__clear_bit(old_keycode, dev->input_dev->keybit);
-		/* ... but another scancode might use the same keycode */
-		for (i = 0; i < rc_map->len; i++) {
-			if (rc_map->scan[i].keycode == old_keycode) {
-				__set_bit(old_keycode, dev->input_dev->keybit);
-				break;
-			}
-		}
-
-		/* Possibly shrink the keytable, failure is not a problem */
-		ir_resize_table(rc_map, GFP_ATOMIC);
-	}
-
-	return old_keycode;
-}
-
-/**
- * ir_establish_scancode() - set a keycode in the scancode->keycode table
- * @dev:	the struct rc_dev device descriptor
- * @rc_map:	scancode table to be searched
- * @entry:	the entry to be added to the table
- * @resize:	controls whether we are allowed to resize the table to
- *		accomodate not yet present scancodes
- * @return:	index of the mapping containing scancode in question
- *		or -1U in case of failure.
- *
- * This routine is used to locate given scancode in rc_map.
- * If scancode is not yet present the routine will allocate a new slot
- * for it.
- */
-static unsigned int ir_establish_scancode(struct rc_dev *dev,
-					  struct rc_map *rc_map,
-					  struct rc_map_table *entry,
-					  bool resize)
-{
-	unsigned int i;
-
-	/*
-	 * Unfortunately, some hardware-based IR decoders don't provide
-	 * all bits for the complete IR code. In general, they provide only
-	 * the command part of the IR code. Yet, as it is possible to replace
-	 * the provided IR with another one, it is needed to allow loading
-	 * IR tables from other remotes. So, we support specifying a mask to
-	 * indicate the valid bits of the scancodes.
-	 */
-	if (dev->scancode_mask)
-		entry->scancode &= dev->scancode_mask;
-
-	/*
-	 * First check if we already have a mapping for this command.
-	 * Note that the keytable is sorted first on protocol and second
-	 * on scancode (lowest to highest).
-	 */
-	for (i = 0; i < rc_map->len; i++) {
-		if (rc_map->scan[i].protocol < entry->protocol)
-			continue;
-
-		if (rc_map->scan[i].protocol > entry->protocol)
-			break;
-
-		if (rc_map->scan[i].scancode < entry->scancode)
-			continue;
-
-		if (rc_map->scan[i].scancode > entry->scancode)
-			break;
-
-		return i;
-	}
-
-	/* No previous mapping found, we might need to grow the table */
-	if (rc_map->size == rc_map->len) {
-		if (!resize || ir_resize_table(rc_map, GFP_ATOMIC))
-			return -1U;
-	}
-
-	/* i is the proper index to insert our new keycode */
-	if (i < rc_map->len)
-		memmove(&rc_map->scan[i + 1], &rc_map->scan[i],
-			(rc_map->len - i) * sizeof(struct rc_map_table));
-	rc_map->scan[i].scancode = entry->scancode;
-	rc_map->scan[i].protocol = entry->protocol;
-	rc_map->scan[i].keycode = KEY_RESERVED;
-	rc_map->len++;
-
-	return i;
-}
-
-/**
- * guess_protocol() - heuristics to guess the protocol for a scancode
- * @rdev:	the struct rc_dev device descriptor
- * @return:	the guessed RC_TYPE_* protocol
- *
- * Internal routine to guess the current IR protocol for legacy ioctls.
- */
-static inline enum rc_type guess_protocol(struct rc_dev *rdev)
-{
-	struct rc_map *rc_map = &rdev->rc_map;
-
-	if (hweight64(rdev->enabled_protocols) == 1)
-		return rc_bitmap_to_type(rdev->enabled_protocols);
-	else if (hweight64(rdev->allowed_protocols) == 1)
-		return rc_bitmap_to_type(rdev->allowed_protocols);
-	else if (rc_map->len > 0)
-		return rc_map->scan[0].protocol;
-	else
-		return RC_TYPE_OTHER;
-}
-
-/**
- * to_nec32() - helper function to try to convert misc NEC scancodes to NEC32
- * @orig:	original scancode
- * @return:	NEC32 scancode
- *
- * This helper routine is used to provide backwards compatibility.
- */
-static u32 to_nec32(u32 orig)
-{
-	u8 b3 = (u8)(orig >> 16);
-	u8 b2 = (u8)(orig >>  8);
-	u8 b1 = (u8)(orig >>  0);
-
-	if (orig <= 0xffff)
-		/* Plain old NEC */
-		return b2 << 24 | ((u8)~b2) << 16 |  b1 << 8 | ((u8)~b1);
-	else if (orig <= 0xffffff)
-		/* NEC extended */
-		return b3 << 24 | b2 << 16 |  b1 << 8 | ((u8)~b1);
-	else
-		/* NEC32 */
-		return orig;
-}
-
-/**
- * ir_setkeycode() - set a keycode in the scancode->keycode table
- * @idev:	the struct input_dev device descriptor
- * @scancode:	the desired scancode
- * @keycode:	result
- * @return:	-EINVAL if the keycode could not be inserted, otherwise zero.
- *
- * This routine is used to handle evdev EVIOCSKEY ioctl.
- */
-static int ir_setkeycode(struct input_dev *idev,
-			 const struct input_keymap_entry *ke,
-			 unsigned int *old_keycode)
-{
-	struct rc_dev *rdev = input_get_drvdata(idev);
-	struct rc_map *rc_map = &rdev->rc_map;
-	unsigned int index;
-	struct rc_map_table entry;
-	int retval = 0;
-	unsigned long flags;
-
-	entry.keycode = ke->keycode;
-
-	spin_lock_irqsave(&rc_map->lock, flags);
-
-	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
-		index = ke->index;
-		if (index >= rc_map->len) {
-			retval = -EINVAL;
-			goto out;
-		}
-	} else if (ke->len == sizeof(int)) {
-		/* Legacy EVIOCSKEYCODE ioctl */
-		u32 scancode;
-		retval = input_scancode_to_scalar(ke, &scancode);
-		if (retval)
-			goto out;
-
-		entry.scancode = scancode;
-		entry.protocol = guess_protocol(rdev);
-		if (entry.protocol == RC_TYPE_NEC)
-			entry.scancode = to_nec32(scancode);
-
-		index = ir_establish_scancode(rdev, rc_map, &entry, true);
-		if (index >= rc_map->len) {
-			retval = -ENOMEM;
-			goto out;
-		}
-	} else if (ke->len == sizeof(struct rc_scancode)) {
-		/* New EVIOCSKEYCODE_V2 ioctl */
-		const struct rc_keymap_entry *rke = (struct rc_keymap_entry *)ke;
-		entry.protocol = rke->rc.protocol;
-		entry.scancode = rke->rc.scancode;
-
-		if (rke->rc.reserved[0] || rke->rc.reserved[1] || rke->rc.reserved[2]) {
-			retval = -EINVAL;
-			goto out;
-		}
-
-		index = ir_establish_scancode(rdev, rc_map, &entry, true);
-		if (index >= rc_map->len) {
-			retval = -ENOMEM;
-			goto out;
-		}
-	} else {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	*old_keycode = ir_update_mapping(rdev, rc_map, index, ke->keycode);
-
-out:
-	spin_unlock_irqrestore(&rc_map->lock, flags);
-	return retval;
-}
-
-/**
- * ir_setkeytable() - sets several entries in the scancode->keycode table
- * @dev:	the struct rc_dev device descriptor
- * @to:		the struct rc_map to copy entries to
- * @from:	the struct rc_map to copy entries from
- * @return:	-ENOMEM if all keycodes could not be inserted, otherwise zero.
- *
- * This routine is used to handle table initialization.
- */
-static int ir_setkeytable(struct rc_dev *dev,
-			  const struct rc_map *from)
-{
-	struct rc_map *rc_map = &dev->rc_map;
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
-		else
-			entry.scancode = from->scan[i].scancode;
-
-		entry.protocol = from->rc_type;
-		index = ir_establish_scancode(dev, rc_map, &entry, false);
-		if (index >= rc_map->len) {
-			rc = -ENOMEM;
-			break;
-		}
-
-		ir_update_mapping(dev, rc_map, index, from->scan[i].keycode);
-	}
-
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
-	}
-
-	return -1U;
-}
-
-/**
- * ir_getkeycode() - get a keycode from the scancode->keycode table
- * @idev:	the struct input_dev device descriptor
- * @scancode:	the desired scancode
- * @keycode:	used to return the keycode, if found, or KEY_RESERVED
- * @return:	always returns zero.
- *
- * This routine is used to handle evdev EVIOCGKEY ioctl.
- */
-static int ir_getkeycode(struct input_dev *idev,
-			 struct input_keymap_entry *ke)
-{
-	struct rc_keymap_entry *rke = (struct rc_keymap_entry *)ke;
-	struct rc_dev *rdev = input_get_drvdata(idev);
-	struct rc_map *rc_map = &rdev->rc_map;
-	struct rc_map_table *entry;
-	unsigned long flags;
-	unsigned int index;
-	int retval;
-
-	spin_lock_irqsave(&rc_map->lock, flags);
-
-	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
-		index = ke->index;
-	} else if (ke->len == sizeof(int)) {
-		/* Legacy EVIOCGKEYCODE ioctl */
-		u32 scancode;
-		u16 protocol;
-
-		retval = input_scancode_to_scalar(ke, &scancode);
-		if (retval)
-			goto out;
-
-		protocol = guess_protocol(rdev);
-		if (protocol == RC_TYPE_NEC)
-			scancode = to_nec32(scancode);
-
-		index = ir_lookup_by_scancode(rc_map, protocol, scancode);
-
-	} else if (ke->len == sizeof(struct rc_scancode)) {
-		/* New EVIOCGKEYCODE_V2 ioctl */
-		if (rke->rc.reserved[0] || rke->rc.reserved[1] || rke->rc.reserved[2]) {
-			retval = -EINVAL;
-			goto out;
-		}
-
-		index = ir_lookup_by_scancode(rc_map,
-					      rke->rc.protocol, rke->rc.scancode);
-
-	} else {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	if (index < rc_map->len) {
-		entry = &rc_map->scan[index];
-		ke->index = index;
-		ke->keycode = entry->keycode;
-		if (ke->len == sizeof(int)) {
-			u32 scancode = entry->scancode;
-			memcpy(ke->scancode, &scancode, sizeof(scancode));
-		} else {
-			ke->len = sizeof(struct rc_scancode);
-			rke->rc.protocol = entry->protocol;
-			rke->rc.scancode = entry->scancode;
-		}
-
-	} else if (!(ke->flags & INPUT_KEYMAP_BY_INDEX)) {
-		/*
-		 * We do not really know the valid range of scancodes
-		 * so let's respond with KEY_RESERVED to anything we
-		 * do not have mapping for [yet].
-		 */
-		ke->index = index;
-		ke->keycode = KEY_RESERVED;
-	} else {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	retval = 0;
-
-out:
-	spin_unlock_irqrestore(&rc_map->lock, flags);
-	return retval;
-}
-
-/**
- * rc_g_keycode_from_table() - gets the keycode that corresponds to a scancode
- * @dev:	the struct rc_dev descriptor of the device
- * @protocol:	the protocol to look for
- * @scancode:	the scancode to look for
- * @return:	the corresponding keycode, or KEY_RESERVED
- *
- * This routine is used by drivers which need to convert a scancode to a
- * keycode. Normally it should not be used since drivers should have no
- * interest in keycodes.
- */
-u32 rc_g_keycode_from_table(struct rc_dev *dev,
-			    enum rc_type protocol, u64 scancode)
-{
-	struct rc_map *rc_map = &dev->rc_map;
-	unsigned int keycode;
-	unsigned int index;
-	unsigned long flags;
-
-	spin_lock_irqsave(&rc_map->lock, flags);
-
-	index = ir_lookup_by_scancode(rc_map, protocol, scancode);
-	keycode = index < rc_map->len ?
-			rc_map->scan[index].keycode : KEY_RESERVED;
-
-	spin_unlock_irqrestore(&rc_map->lock, flags);
-
-	if (keycode != KEY_RESERVED)
-		IR_dprintk(1, "%s: protocol 0x%04x scancode 0x%08llx keycode 0x%02x\n",
-			   dev->input_name, protocol,
-			   (unsigned long long)scancode, keycode);
-
-	return keycode;
-}
-EXPORT_SYMBOL_GPL(rc_g_keycode_from_table);
-
-/**
- * ir_do_keyup() - internal function to signal the release of a keypress
- * @dev:	the struct rc_dev descriptor of the device
- * @sync:	whether or not to call input_sync
- *
- * This function is used internally to release a keypress, it must be
- * called with keylock held.
- */
-static void ir_do_keyup(struct rc_dev *dev, bool sync)
-{
-	if (!dev->keypressed)
-		return;
-
-	IR_dprintk(1, "keyup key 0x%04x\n", dev->last_keycode);
-	input_report_key(dev->input_dev, dev->last_keycode, 0);
-	led_trigger_event(led_feedback, LED_OFF);
-	if (sync)
-		input_sync(dev->input_dev);
-	dev->keypressed = false;
-}
-
-/**
- * rc_keyup() - signals the release of a keypress
- * @dev:	the struct rc_dev descriptor of the device
- *
- * This routine is used to signal that a key has been released on the
- * remote control.
- */
-void rc_keyup(struct rc_dev *dev)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->keylock, flags);
-	ir_do_keyup(dev, true);
-	spin_unlock_irqrestore(&dev->keylock, flags);
-}
-EXPORT_SYMBOL_GPL(rc_keyup);
-
-/**
- * ir_timer_keyup() - generates a keyup event after a timeout
- * @cookie:	a pointer to the struct rc_dev for the device
- *
- * This routine will generate a keyup event some time after a keydown event
- * is generated when no further activity has been detected.
- */
-static void ir_timer_keyup(unsigned long cookie)
-{
-	struct rc_dev *dev = (struct rc_dev *)cookie;
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
-	spin_lock_irqsave(&dev->keylock, flags);
-	if (time_is_before_eq_jiffies(dev->keyup_jiffies))
-		ir_do_keyup(dev, true);
-	spin_unlock_irqrestore(&dev->keylock, flags);
-}
-
-/**
- * rc_repeat() - signals that a key is still pressed
- * @dev:	the struct rc_dev descriptor of the device
- *
- * This routine is used by IR decoders when a repeat message which does
- * not include the necessary bits to reproduce the scancode has been
- * received.
- */
-void rc_repeat(struct rc_dev *dev)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->keylock, flags);
-
-	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
-	input_sync(dev->input_dev);
-	rc_event(dev, RC_KEY, RC_KEY_REPEAT, 1);
-
-	if (!dev->keypressed)
-		goto out;
-
-	dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
-	mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
-
-out:
-	spin_unlock_irqrestore(&dev->keylock, flags);
-}
-EXPORT_SYMBOL_GPL(rc_repeat);
-
-/**
- * ir_do_keydown() - internal function to process a keypress
- * @dev:	the struct rc_dev descriptor of the device
- * @protocol:	the protocol of the keypress
- * @scancode:   the scancode of the keypress
- * @keycode:    the keycode of the keypress
- * @toggle:     the toggle value of the keypress
- *
- * This function is used internally to register a keypress, it must be
- * called with keylock held.
- */
-static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
-			  u32 scancode, u32 keycode, u8 toggle)
-{
-	bool new_event = (!dev->keypressed		 ||
-			  dev->last_protocol != protocol ||
-			  dev->last_scancode != scancode ||
-			  dev->last_toggle   != toggle);
-
-	if (new_event && dev->keypressed)
-		ir_do_keyup(dev, false);
-
-	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
-	rc_event(dev, RC_KEY, RC_KEY_PROTOCOL, protocol);
-	/*
-	 * NOTE: If we ever get > 32 bit scancodes, we need to break the
-	 *	 scancode into 32 bit pieces and feed them to userspace
-	 *	 as one or more RC_KEY_SCANCODE_PART events followed
-	 *	 by a final RC_KEY_SCANCODE event.
-	 */
-	rc_event(dev, RC_KEY, RC_KEY_SCANCODE, scancode);
-	rc_event(dev, RC_KEY, RC_KEY_TOGGLE, toggle);
-
-	if (new_event && keycode != KEY_RESERVED) {
-		/* Register a keypress */
-		dev->keypressed = true;
-		dev->last_protocol = protocol;
-		dev->last_scancode = scancode;
-		dev->last_toggle = toggle;
-		dev->last_keycode = keycode;
-
-		IR_dprintk(1, "%s: key down event, "
-			   "key 0x%04x, protocol 0x%04x, scancode 0x%08x\n",
-			   dev->input_name, keycode, protocol, scancode);
-		input_report_key(dev->input_dev, keycode, 1);
-
-		led_trigger_event(led_feedback, LED_FULL);
-	}
-
-	input_sync(dev->input_dev);
-}
-
-/**
- * rc_keydown() - generates input event for a key press
- * @dev:	the struct rc_dev descriptor of the device
- * @protocol:	the protocol for the keypress
- * @scancode:	the scancode for the keypress
- * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
- *              support toggle values, this should be set to zero)
- *
- * This routine is used to signal that a key has been pressed on the
- * remote control.
- */
-void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle)
-{
-	unsigned long flags;
-	u32 keycode = rc_g_keycode_from_table(dev, protocol, scancode);
-
-	spin_lock_irqsave(&dev->keylock, flags);
-	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
-
-	if (dev->keypressed) {
-		dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
-		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
-	}
-	spin_unlock_irqrestore(&dev->keylock, flags);
-}
-EXPORT_SYMBOL_GPL(rc_keydown);
-
-/**
- * rc_keydown_notimeout() - generates input event for a key press without
- *                          an automatic keyup event at a later time
- * @dev:	the struct rc_dev descriptor of the device
- * @protocol:	the protocol for the keypress
- * @scancode:	the scancode for the keypress
- * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
- *              support toggle values, this should be set to zero)
- *
- * This routine is used to signal that a key has been pressed on the
- * remote control. The driver must manually call rc_keyup() at a later stage.
- */
-void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol,
-			  u32 scancode, u8 toggle)
-{
-	unsigned long flags;
-	u32 keycode = rc_g_keycode_from_table(dev, protocol, scancode);
-
-	spin_lock_irqsave(&dev->keylock, flags);
-	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
-	spin_unlock_irqrestore(&dev->keylock, flags);
-}
-EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
-
 int rc_open(struct rc_dev *dev)
 {
 	int err = 0;
@@ -950,13 +125,6 @@ int rc_open(struct rc_dev *dev)
 }
 EXPORT_SYMBOL_GPL(rc_open);
 
-static int rc_input_open(struct input_dev *idev)
-{
-	struct rc_dev *rdev = input_get_drvdata(idev);
-
-	return rc_open(rdev);
-}
-
 void rc_close(struct rc_dev *dev)
 {
 	mutex_lock(&dev->lock);
@@ -968,12 +136,6 @@ void rc_close(struct rc_dev *dev)
 }
 EXPORT_SYMBOL_GPL(rc_close);
 
-static void rc_input_close(struct input_dev *idev)
-{
-	struct rc_dev *rdev = input_get_drvdata(idev);
-	rc_close(rdev);
-}
-
 /* class for /sys/class/rc */
 static char *rc_devnode(struct device *dev, umode_t *mode)
 {
@@ -2143,6 +1305,19 @@ void rc_unregister_device(struct rc_dev *dev)
 }
 EXPORT_SYMBOL_GPL(rc_unregister_device);
 
+static struct rc_map_table empty[] = {
+	{ RC_TYPE_OTHER, 0x2a, KEY_COFFEE },
+};
+
+static struct rc_map_list empty_map = {
+	.map = {
+		.scan    = empty,
+		.size    = ARRAY_SIZE(empty),
+		.rc_type = RC_TYPE_UNKNOWN,     /* Legacy IR type */
+		.name    = RC_MAP_EMPTY,
+	}
+};
+
 static int __init rc_core_init(void)
 {
 	int err;

