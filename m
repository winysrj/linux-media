Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44272 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758757Ab2EWJy6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:58 -0400
Subject: [PATCH 25/43] rc-core: prepare for multiple keytables
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:44:11 +0200
Message-ID: <20120523094411.14474.84992.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Introduce struct rc_keytable which essentially maintains an input device
and a table with scancode,protocol <-> keycode mappings. Move the relevant
members from struct rc_dev into struct rc_keytable.

Also, all code related to struct rc_keytable is moved into a separate
file as the rc-main.c one is getting quite large and the rc_keytable
is logically separate code (as will be apparent with the later patches).

This is in preparation for supporting multiple keytables, where each
keytable would correspond to one physical remote controller, each with
its own keymap and input device for reporting events to userspace.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/Makefile       |    2 
 drivers/media/rc/rc-core-priv.h |   10 
 drivers/media/rc/rc-keytable.c  |  890 +++++++++++++++++++++++++++++++++++++++
 drivers/media/rc/rc-main.c      |  887 ++-------------------------------------
 include/media/rc-core.h         |   45 +-
 5 files changed, 982 insertions(+), 852 deletions(-)
 create mode 100644 drivers/media/rc/rc-keytable.c

diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 596060a..f470a3f 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -1,4 +1,4 @@
-rc-core-objs	:= rc-main.o ir-raw.o
+rc-core-objs	:= rc-main.o rc-keytable.o ir-raw.o
 
 obj-y += keymaps/
 
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 8db5bbc..7aaa1bf 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -149,6 +149,16 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
 void ir_raw_init(void);
 
+/*
+ * Methods from rc-keytable.c to be used internally
+ */
+void rc_keytable_keyup(struct rc_keytable *kt);
+void rc_keytable_repeat(struct rc_keytable *kt);
+void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
+			 u64 scancode, u8 toggle, bool autokeyup);
+struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *map_name);
+void rc_keytable_destroy(struct rc_keytable *kt);
+
 /* Only to be used by rc-core and ir-lirc-codec */
 void rc_init_ir_rx(struct rc_dev *dev, struct rc_ir_rx *rx);
 
diff --git a/drivers/media/rc/rc-keytable.c b/drivers/media/rc/rc-keytable.c
new file mode 100644
index 0000000..7096f44
--- /dev/null
+++ b/drivers/media/rc/rc-keytable.c
@@ -0,0 +1,890 @@
+/*
+ * rc-keytable.c - Remote Controller keytable handling
+ *
+ * Copyright (C) 2009-2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
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
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/poll.h>
+#include "rc-core-priv.h"
+
+/* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
+#define RC_TAB_MIN_SIZE	256
+#define RC_TAB_MAX_SIZE	8192
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
+static void ir_free_table(struct rc_map *rc_map)
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
+		if (rc_map->alloc >= RC_TAB_MAX_SIZE)
+			return -ENOMEM;
+
+		newalloc *= 2;
+		IR_dprintk(1, "Growing table to %u bytes\n", newalloc);
+	}
+
+	if ((rc_map->len * 3 < rc_map->size) && (oldalloc > RC_TAB_MIN_SIZE)) {
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
+ * @kt:		the struct rc_keytable descriptor
+ * @rc_map:	scancode table to be adjusted
+ * @index:	index of the mapping that needs to be updated
+ * @keycode:	the desired keycode
+ * @return:	previous keycode assigned to the mapping
+ *
+ * This routine is used to update scancode->keycode mapping at given
+ * position.
+ */
+static unsigned int ir_update_mapping(struct rc_keytable *kt,
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
+		memmove(&rc_map->scan[index], &rc_map->scan[index + 1],
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
+		__set_bit(new_keycode, kt->idev->keybit);
+	}
+
+	if (old_keycode != KEY_RESERVED) {
+		/* A previous mapping was updated... */
+		__clear_bit(old_keycode, kt->idev->keybit);
+		/* ... but another scancode might use the same keycode */
+		for (i = 0; i < rc_map->len; i++) {
+			if (rc_map->scan[i].keycode == old_keycode) {
+				__set_bit(old_keycode, kt->idev->keybit);
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
+ * @kt:		the struct rc_keytable descriptor
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
+static unsigned int ir_establish_scancode(struct rc_keytable *kt,
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
+	if (kt->dev->scanmask)
+		entry->scancode &= kt->dev->scanmask;
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
+ * ir_setkeycode() - set a keycode in the scancode->keycode table
+ * @idev:	the struct input_dev device descriptor
+ * @scancode:	the desired scancode
+ * @keycode:	result
+ * @return:	-EINVAL if the keycode could not be inserted, otherwise zero.
+ *
+ * This routine is used to handle evdev EVIOCSKEY ioctl.
+ */
+static int ir_setkeycode(struct input_dev *idev,
+			 const struct input_keymap_entry *ke,
+			 unsigned int *old_keycode)
+{
+	struct rc_keytable *kt = input_get_drvdata(idev);
+	struct rc_dev *rdev = kt->dev;
+	struct rc_map *rc_map = &kt->rc_map;
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
+		entry.scancode = scancode;
+
+		/* Some heuristics to guess the correct protocol */
+		if (hweight64(rdev->enabled_protocols) == 1)
+			entry.protocol = rdev->enabled_protocols;
+		else if (hweight64(rdev->allowed_protos) == 1)
+			entry.protocol = rdev->allowed_protos;
+		else if (rc_map->len > 0)
+			entry.protocol = rc_map->scan[0].protocol;
+		else
+			entry.protocol = RC_TYPE_OTHER;
+
+		index = ir_establish_scancode(kt, rc_map, &entry, true);
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
+		if (rke->rc.reserved[0] || rke->rc.reserved[1] || rke->rc.reserved[1]) {
+			retval = -EINVAL;
+			goto out;
+		}
+
+		index = ir_establish_scancode(kt, rc_map, &entry, true);
+		if (index >= rc_map->len) {
+			retval = -ENOMEM;
+			goto out;
+		}
+	} else {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	if (retval == 0)
+		*old_keycode = ir_update_mapping(kt, rc_map, index, ke->keycode);
+
+out:
+	spin_unlock_irqrestore(&rc_map->lock, flags);
+	return retval;
+}
+
+/**
+ * rc_setkeytable() - sets several entries in the scancode->keycode table
+ * @dev:	the struct rc_dev device descriptor
+ * @to:		the struct rc_map to copy entries to
+ * @from:	the struct rc_map to copy entries from
+ * @return:	-ENOMEM if all keycodes could not be inserted, otherwise zero.
+ *
+ * This routine is used to handle table initialization.
+ */
+static int rc_setkeytable(struct rc_keytable *kt,
+			  const struct rc_map *from)
+{
+	struct rc_map *rc_map = &kt->rc_map;
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
+		entry.protocol = from->scan[i].protocol;
+		entry.scancode = from->scan[i].scancode;
+		index = ir_establish_scancode(kt, rc_map, &entry, false);
+		if (index >= rc_map->len) {
+			rc = -ENOMEM;
+			break;
+		}
+
+		ir_update_mapping(kt, rc_map, index, from->scan[i].keycode);
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
+static int ir_getkeycode(struct input_dev *idev,
+			 struct input_keymap_entry *ke)
+{
+	struct rc_keymap_entry *rke = (struct rc_keymap_entry *)ke;
+	struct rc_keytable *kt = input_get_drvdata(idev);
+	struct rc_dev *rdev = kt->dev;
+	struct rc_map *rc_map = &kt->rc_map;
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
+		/* Some heuristics to guess the correct protocol */
+		if (hweight64(rdev->enabled_protocols) == 1)
+			protocol = rdev->enabled_protocols;
+		else if (hweight64(rdev->allowed_protos) == 1)
+			protocol = rdev->allowed_protos;
+		else if (rc_map->len > 0)
+			protocol = rc_map->scan[0].protocol;
+		else
+			protocol = RC_TYPE_OTHER;
+
+		index = ir_lookup_by_scancode(rc_map, protocol, scancode);
+
+	} else if (ke->len == sizeof(struct rc_scancode)) {
+		/* New EVIOCGKEYCODE_V2 ioctl */
+		if (rke->rc.reserved[0] || rke->rc.reserved[1] || rke->rc.reserved[1]) {
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
+	struct rc_map *rc_map = &dev->kt->rc_map;
+	unsigned int keycode;
+	unsigned int index;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rc_map->lock, flags);
+
+	index = ir_lookup_by_scancode(&dev->kt->rc_map, protocol, scancode);
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
+static void rc_do_keyup(struct rc_keytable *kt, bool sync)
+{
+	if (!kt->keypressed)
+		return;
+
+	IR_dprintk(1, "keyup key 0x%04x\n", kt->last_keycode);
+	input_report_key(kt->idev, kt->last_keycode, 0);
+	if (sync)
+		input_sync(kt->idev);
+	kt->keypressed = false;
+}
+
+/**
+ * rc_keyup() - signals the release of a keypress
+ * @dev:	the struct rc_dev descriptor of the device
+ *
+ * This routine is used to signal that a key has been released on the
+ * remote control.
+ */
+void rc_keytable_keyup(struct rc_keytable *kt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&kt->keylock, flags);
+	rc_do_keyup(kt, true);
+	spin_unlock_irqrestore(&kt->keylock, flags);
+}
+
+/**
+ * rc_keytable_timer_keyup() - generates a keyup event after a timeout
+ * @cookie:	a pointer to the struct rc_dev for the device
+ *
+ * This routine will generate a keyup event some time after a keydown event
+ * is generated when no further activity has been detected.
+ */
+static void rc_timer_keyup(unsigned long cookie)
+{
+	struct rc_keytable *kt = (struct rc_keytable *)cookie;
+	unsigned long flags;
+
+	/*
+	 * keyup_jiffies is used to prevent a race condition if a
+	 * hardware interrupt occurs at this point and the keyup timer
+	 * event is moved further into the future as a result.
+	 *
+	 * The timer will then be reactivated and this function called
+	 * again in the future. We need to exit gracefully in that case
+	 * to allow the input subsystem to do its auto-repeat magic or
+	 * a keyup event might follow immediately after the keydown.
+	 */
+	spin_lock_irqsave(&kt->keylock, flags);
+	if (time_is_before_eq_jiffies(kt->keyup_jiffies))
+		rc_do_keyup(kt, true);
+	spin_unlock_irqrestore(&kt->keylock, flags);
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
+void rc_keytable_repeat(struct rc_keytable *kt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&kt->keylock, flags);
+
+	input_event(kt->idev, EV_MSC, MSC_SCAN, kt->last_scancode);
+	input_sync(kt->idev);
+
+	if (!kt->keypressed)
+		goto out;
+
+	kt->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+	mod_timer(&kt->timer_keyup, kt->keyup_jiffies);
+
+out:
+	spin_unlock_irqrestore(&kt->keylock, flags);
+}
+
+/**
+ * rc_keytable_keydown() - generates input event for a key press
+ * @kt:		the struct rc_keytable descriptor of the keytable
+ * @protocol:	the protocol for the keypress
+ * @scancode:   the scancode for the keypress
+ * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
+ *              support toggle values, this should be set to zero)
+ * @autoup:	should an automatic keyup event be generated in the future
+ *
+ * This routine is used to signal that a keypress has been detected.
+ */
+void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
+			 u64 scancode, u8 toggle, bool autoup)
+{
+	unsigned long flags;
+	u32 keycode;
+	bool new_event;
+
+	spin_lock_irqsave(&kt->keylock, flags);
+
+	keycode = rc_g_keycode_from_table(kt->dev, protocol, scancode);
+	new_event = !kt->keypressed || kt->last_protocol != protocol ||
+		     kt->last_scancode != scancode || kt->last_toggle != toggle;
+
+	if (new_event && kt->keypressed)
+		rc_do_keyup(kt, false);
+
+	input_event(kt->idev, EV_MSC, MSC_SCAN, scancode);
+
+	if (new_event && keycode != KEY_RESERVED) {
+		/* Register a keypress */
+		kt->keypressed = true;
+		kt->last_protocol = protocol;
+		kt->last_scancode = scancode;
+		kt->last_toggle = toggle;
+		kt->last_keycode = keycode;
+
+		IR_dprintk(1, "%s: key down event, "
+			   "key 0x%04x, protocol 0x%04x, scancode 0x%08llx\n",
+			   kt->dev->input_name, keycode, protocol,
+			   (long long unsigned)scancode);
+		input_report_key(kt->idev, keycode, 1);
+	}
+	input_sync(kt->idev);
+
+	if (autoup && kt->keypressed) {
+		kt->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
+		mod_timer(&kt->timer_keyup, kt->keyup_jiffies);
+	}
+	spin_unlock_irqrestore(&kt->keylock, flags);
+}
+
+/**
+ * rc_input_open() - called on the initial use of the input device
+ * @idev:	the struct input_dev corresponding to the given keytable
+ * @return:	zero on success, otherwise a negative error code
+ *
+ * This function is used by input core to signal that the input device has been
+ * opened for the first time.
+ */
+static int rc_input_open(struct input_dev *idev)
+{
+	int error;
+	struct rc_keytable *kt = input_get_drvdata(idev);
+	struct rc_dev *dev = kt->dev;
+
+	error = mutex_lock_interruptible(&dev->lock);
+	if (error)
+		return error;
+
+	if (dev->users++ == 0 && dev->open)
+		error = dev->open(dev);
+
+	mutex_unlock(&dev->lock);
+	return error;
+}
+
+/**
+ * rc_input_close() - called on the last use of the input device
+ * @idev:	the struct input_dev corresponding to the given keytable
+ *
+ * This function is used by input core to signal that the last user has closed
+ * the input device.
+ */
+static void rc_input_close(struct input_dev *idev)
+{
+	struct rc_keytable *kt = input_get_drvdata(idev);
+	struct rc_dev *dev = kt->dev;
+
+	mutex_lock(&dev->lock);
+
+	if (--dev->users == 0 && dev->close)
+		dev->close(dev);
+
+	mutex_unlock(&dev->lock);
+}
+
+/**
+ * rc_keytable_create() - creates a new keytable
+ * @dev:	the struct rc_dev device this keytable should belong to
+ * @map_name:	the name of the keymap to autoload
+ * @return:	a new struct rc_keytable pointer or NULL on error
+ *
+ * This function creates a new keytable (essentially the combination of a
+ * keytable and an input device along with some state (whether a key
+ * is currently pressed or not, etc).
+ */
+struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *map_name)
+{
+	struct rc_keytable *kt;
+	struct input_dev *idev = NULL;
+	struct rc_map *rc_map = NULL;
+	int error;
+
+	kt = kzalloc(sizeof(*kt), GFP_KERNEL);
+	if (!kt)
+		return NULL;
+
+	idev = input_allocate_device();
+	if (!idev)
+		goto out;
+
+	kt->idev = idev;
+	kt->dev = dev;
+	idev->getkeycode = ir_getkeycode;
+	idev->setkeycode = ir_setkeycode;
+	idev->open = rc_input_open;
+	idev->close = rc_input_close;
+	set_bit(EV_KEY, idev->evbit);
+	set_bit(EV_REP, idev->evbit);
+	set_bit(EV_MSC, idev->evbit);
+	set_bit(MSC_SCAN, idev->mscbit);
+	input_set_drvdata(idev, kt);
+	setup_timer(&kt->timer_keyup, rc_timer_keyup, (unsigned long)kt);
+
+	if (map_name)
+		rc_map = rc_map_get(map_name);
+	if (!rc_map)
+		rc_map = rc_map_get(RC_MAP_EMPTY);
+	if (!rc_map || !rc_map->scan || rc_map->size == 0)
+		goto out;
+
+	error = rc_setkeytable(kt, rc_map);
+	if (error)
+		goto out;
+
+	idev->dev.parent = &dev->dev;
+	memcpy(&idev->id, &dev->input_id, sizeof(dev->input_id));
+	idev->phys = dev->input_phys;
+	idev->name = dev->input_name;
+	error = input_register_device(idev);
+	if (error)
+		goto out;
+
+	/*
+	 * Default delay of 250ms is too short for some protocols, especially
+	 * since the timeout is currently set to 250ms. Increase it to 500ms,
+	 * to avoid wrong repetition of the keycodes. Note that this must be
+	 * set after the call to input_register_device().
+	 */
+	idev->rep[REP_DELAY] = 500;
+
+	/*
+	 * As a repeat event on protocols like RC-5 and NEC take as long as
+	 * 110/114ms, using 33ms as a repeat period is not the right thing
+	 * to do.
+	 */
+	idev->rep[REP_PERIOD] = 125;
+
+	spin_lock_init(&kt->rc_map.lock);
+	spin_lock_init(&kt->keylock);
+	return kt;
+
+out:
+	input_free_device(idev);
+	kfree(kt);
+	return NULL;
+}
+
+/**
+ * rc_keytable_destroy() - destroys a keytable
+ * @dev:	the struct rc_keytable to destroy
+ *
+ * This function destroys an existing keytable.
+ */
+void rc_keytable_destroy(struct rc_keytable *kt)
+{
+	del_timer_sync(&kt->timer_keyup);
+	/* Freeing the table should also call the stop callback */
+	ir_free_table(&kt->rc_map);
+	input_unregister_device(kt->idev);
+	kfree(kt);
+}
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index f8a63e2..83ea507 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -15,7 +15,6 @@
 #include <media/rc-core.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
-#include <linux/input.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/device.h>
@@ -23,20 +22,9 @@
 #include <linux/poll.h>
 #include "rc-core-priv.h"
 
-/* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
-#define IR_TAB_MIN_SIZE	256
-#define IR_TAB_MAX_SIZE	8192
-#define RC_DEV_MAX	32
-#define RC_RX_BUFFER_SIZE 1024
-
-/* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
-#define IR_KEYPRESS_TIMEOUT 250
-
-/* Used to keep track of known keymaps */
-static LIST_HEAD(rc_map_list);
-static DEFINE_SPINLOCK(rc_map_lock);
-
 /* Various bits and pieces to keep track of rc devices */
+#define RC_DEV_MAX		32
+#define RC_RX_BUFFER_SIZE	1024
 static unsigned int rc_major;
 static struct rc_dev *rc_dev_table[RC_DEV_MAX];
 static DEFINE_MUTEX(rc_dev_table_mutex);
@@ -113,607 +101,6 @@ void rc_event(struct rc_dev *dev, u16 type, u16 code, u64 val)
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
-	if (dev->scanmask)
-		entry->scancode &= dev->scanmask;
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
-		entry.scancode = scancode;
-
-		/* Some heuristics to guess the correct protocol */
-		if (hweight64(rdev->enabled_protocols) == 1)
-			entry.protocol = rdev->enabled_protocols;
-		else if (hweight64(rdev->allowed_protos) == 1)
-			entry.protocol = rdev->allowed_protos;
-		else if (rc_map->len > 0)
-			entry.protocol = rc_map->scan[0].protocol;
-		else
-			entry.protocol = RC_TYPE_OTHER;
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
-		if (rke->rc.reserved[0] || rke->rc.reserved[1] || rke->rc.reserved[1]) {
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
-	if (retval == 0)
-		*old_keycode = ir_update_mapping(rdev, rc_map, index, ke->keycode);
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
-		entry.protocol = from->scan[i].protocol;
-		entry.scancode = from->scan[i].scancode;
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
-		/* Some heuristics to guess the correct protocol */
-		if (hweight64(rdev->enabled_protocols) == 1)
-			protocol = rdev->enabled_protocols;
-		else if (hweight64(rdev->allowed_protos) == 1)
-			protocol = rdev->allowed_protos;
-		else if (rc_map->len > 0)
-			protocol = rc_map->scan[0].protocol;
-		else
-			protocol = RC_TYPE_OTHER;
-
-		index = ir_lookup_by_scancode(rc_map, protocol, scancode);
-
-	} else if (ke->len == sizeof(struct rc_scancode)) {
-		/* New EVIOCGKEYCODE_V2 ioctl */
-		if (rke->rc.reserved[0] || rke->rc.reserved[1] || rke->rc.reserved[1]) {
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
-	if (sync)
-		input_sync(dev->input_dev);
-	dev->keypressed = false;
-}
-
 /**
  * rc_keyup() - signals the release of a keypress
  * @dev:	the struct rc_dev descriptor of the device
@@ -723,43 +110,11 @@ static void ir_do_keyup(struct rc_dev *dev, bool sync)
  */
 void rc_keyup(struct rc_dev *dev)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->keylock, flags);
-	ir_do_keyup(dev, true);
-	spin_unlock_irqrestore(&dev->keylock, flags);
+	rc_keytable_keyup(dev->kt);
 }
 EXPORT_SYMBOL_GPL(rc_keyup);
 
 /**
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
  * rc_repeat() - signals that a key is still pressed
  * @dev:	the struct rc_dev descriptor of the device
  *
@@ -769,135 +124,32 @@ static void ir_timer_keyup(unsigned long cookie)
  */
 void rc_repeat(struct rc_dev *dev)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->keylock, flags);
-
-	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
-	input_sync(dev->input_dev);
+	rc_keytable_repeat(dev->kt);
 	rc_event(dev, RC_KEY, RC_KEY_REPEAT, 1);
-
-	if (!dev->keypressed)
-		goto out;
-
-	dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
-	mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
-
-out:
-	spin_unlock_irqrestore(&dev->keylock, flags);
 }
 EXPORT_SYMBOL_GPL(rc_repeat);
 
 /**
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
-static void ir_do_keydown(struct rc_dev *dev, u16 protocol,
-			  u64 scancode, u32 keycode, u8 toggle)
-{
-	bool new_event = !dev->keypressed ||
-			 dev->last_protocol != protocol ||
-			 dev->last_scancode != scancode ||
-			 dev->last_toggle != toggle;
-
-	if (new_event && dev->keypressed)
-		ir_do_keyup(dev, false);
-
-	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
-	rc_event(dev, RC_KEY, RC_KEY_PROTOCOL, protocol);
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
-			   "key 0x%04x, protocol 0x%04x, scancode 0x%08llx\n",
-			   dev->input_name, keycode, protocol,
-			   (long long unsigned)scancode);
-		input_report_key(dev->input_dev, keycode, 1);
-	}
-	input_sync(dev->input_dev);
-}
-
-/**
- * rc_keydown() - generates input event for a key press
+ * rc_do_keydown() - generates input event for a key press
  * @dev:	the struct rc_dev descriptor of the device
  * @protocol:	the protocol for the keypress
  * @scancode:   the scancode for the keypress
  * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
  *              support toggle values, this should be set to zero)
+ * @autoup:	should an automatic keyup event be generated in the future
  *
  * This routine is used to signal that a key has been pressed on the
  * remote control.
  */
-void rc_keydown(struct rc_dev *dev, enum rc_type protocol,
-		u64 scancode, u8 toggle)
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
- * @scancode:   the scancode that we're seeking
- * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
- *              support toggle values, this should be set to zero)
- *
- * This routine is used to signal that a key has been pressed on the
- * remote control. The driver must manually call rc_keyup() at a later stage.
- */
-void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol,
-			  u64 scancode, u8 toggle)
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
-static int ir_open(struct input_dev *idev)
-{
-	struct rc_dev *rdev = input_get_drvdata(idev);
-
-	return rdev->open(rdev);
-}
-
-static void ir_close(struct input_dev *idev)
+void rc_do_keydown(struct rc_dev *dev, enum rc_type protocol,
+		   u64 scancode, u8 toggle, bool autoup)
 {
-	struct rc_dev *rdev = input_get_drvdata(idev);
-
-	 if (rdev)
-		rdev->close(rdev);
+	rc_keytable_keydown(dev->kt, protocol, scancode, toggle, autoup);
+	rc_event(dev, RC_KEY, RC_KEY_PROTOCOL, protocol);
+	rc_event(dev, RC_KEY, RC_KEY_SCANCODE, scancode);
+	rc_event(dev, RC_KEY, RC_KEY_TOGGLE, toggle);
 }
+EXPORT_SYMBOL_GPL(rc_do_keydown);
 
 /* class for /sys/class/rc */
 static char *rc_devnode(struct device *dev, umode_t *mode)
@@ -1132,9 +384,6 @@ static void rc_dev_release(struct device *device)
 {
 	struct rc_dev *dev = to_rc_dev(device);
 
-	if (dev->input_dev)
-		input_free_device(dev->input_dev);
-
 	kfifo_free(&dev->txfifo);
 	kfree(dev);
 	module_put(THIS_MODULE);
@@ -1151,11 +400,11 @@ static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 {
 	struct rc_dev *dev = to_rc_dev(device);
 
-	if (!dev || !dev->input_dev)
+	if (!dev)
 		return -ENODEV;
 
-	if (dev->rc_map.name)
-		ADD_HOTPLUG_VAR("NAME=%s", dev->rc_map.name);
+	if (dev->map_name)
+		ADD_HOTPLUG_VAR("NAME=%s", dev->map_name);
 	if (dev->driver_name)
 		ADD_HOTPLUG_VAR("DRV_NAME=%s", dev->driver_name);
 
@@ -1196,26 +445,14 @@ struct rc_dev *rc_allocate_device(void)
 	if (!dev)
 		return NULL;
 
-	dev->input_dev = input_allocate_device();
-	if (!dev->input_dev) {
-		kfree(dev);
-		return NULL;
-	}
-
-	dev->input_dev->getkeycode = ir_getkeycode;
-	dev->input_dev->setkeycode = ir_setkeycode;
-	input_set_drvdata(dev->input_dev, dev);
-
 	INIT_LIST_HEAD(&dev->client_list);
 	spin_lock_init(&dev->client_lock);
 	INIT_KFIFO(dev->txfifo);
 	spin_lock_init(&dev->txlock);
 	init_waitqueue_head(&dev->rxwait);
 	init_waitqueue_head(&dev->txwait);
-	spin_lock_init(&dev->rc_map.lock);
-	spin_lock_init(&dev->keylock);
+	spin_lock_init(&dev->txlock);
 	mutex_init(&dev->lock);
-	setup_timer(&dev->timer_keyup, ir_timer_keyup, (unsigned long)dev);
 
 	dev->dev.type = &rc_dev_type;
 	dev->dev.class = &rc_class;
@@ -1244,7 +481,6 @@ EXPORT_SYMBOL_GPL(rc_free_device);
 int rc_register_device(struct rc_dev *dev)
 {
 	static bool raw_init = false; /* raw decoders loaded? */
-	struct rc_map *rc_map;
 	const char *path;
 	int rc;
 	unsigned int i;
@@ -1252,21 +488,6 @@ int rc_register_device(struct rc_dev *dev)
 	if (!dev || !dev->map_name)
 		return -EINVAL;
 
-	rc_map = rc_map_get(dev->map_name);
-	if (!rc_map)
-		rc_map = rc_map_get(RC_MAP_EMPTY);
-	if (!rc_map || !rc_map->scan || rc_map->size == 0)
-		return -EINVAL;
-
-	set_bit(EV_KEY, dev->input_dev->evbit);
-	set_bit(EV_REP, dev->input_dev->evbit);
-	set_bit(EV_MSC, dev->input_dev->evbit);
-	set_bit(MSC_SCAN, dev->input_dev->mscbit);
-	if (dev->open)
-		dev->input_dev->open = ir_open;
-	if (dev->close)
-		dev->input_dev->close = ir_close;
-
 	rc = mutex_lock_interruptible(&rc_dev_table_mutex);
 	if (rc)
 		return rc;
@@ -1303,36 +524,15 @@ int rc_register_device(struct rc_dev *dev)
 	 */
 	mutex_lock(&dev->lock);
 
-	rc = device_add(&dev->dev);
-	if (rc)
+	dev->kt = rc_keytable_create(dev, dev->map_name);
+	if (!dev->kt) {
+		rc = -ENOMEM;
 		goto out_unlock;
+	}
 
-	rc = ir_setkeytable(dev, rc_map);
-	if (rc)
-		goto out_dev;
-
-	dev->input_dev->dev.parent = &dev->dev;
-	memcpy(&dev->input_dev->id, &dev->input_id, sizeof(dev->input_id));
-	dev->input_dev->phys = dev->input_phys;
-	dev->input_dev->name = dev->input_name;
-	rc = input_register_device(dev->input_dev);
+	rc = device_add(&dev->dev);
 	if (rc)
-		goto out_table;
-
-	/*
-	 * Default delay of 250ms is too short for some protocols, especially
-	 * since the timeout is currently set to 250ms. Increase it to 500ms,
-	 * to avoid wrong repetition of the keycodes. Note that this must be
-	 * set after the call to input_register_device().
-	 */
-	dev->input_dev->rep[REP_DELAY] = 500;
-
-	/*
-	 * As a repeat event on protocols like RC-5 and NEC take as long as
-	 * 110/114ms, using 33ms as a repeat period is not the right thing
-	 * to do.
-	 */
-	dev->input_dev->rep[REP_PERIOD] = 125;
+		goto out_keytable;
 
 	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
 	printk(KERN_INFO "%s: %s as %s\n",
@@ -1350,7 +550,7 @@ int rc_register_device(struct rc_dev *dev)
 		}
 		rc = ir_raw_event_register(dev);
 		if (rc < 0)
-			goto out_input;
+			goto out_dev;
 	}
 
 	if (dev->change_protocol) {
@@ -1365,7 +565,7 @@ int rc_register_device(struct rc_dev *dev)
 	IR_dprintk(1, "Registered rc%u (driver: %s, remote: %s, mode %s)\n",
 		   dev->minor,
 		   dev->driver_name ? dev->driver_name : "unknown",
-		   rc_map->name ? rc_map->name : "unknown",
+		   dev->map_name ? dev->map_name : "unknown",
 		   dev->driver_type == RC_DRIVER_IR_RAW ? "raw" : "cooked");
 
 	return 0;
@@ -1373,13 +573,10 @@ int rc_register_device(struct rc_dev *dev)
 out_raw:
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		ir_raw_event_unregister(dev);
-out_input:
-	input_unregister_device(dev->input_dev);
-	dev->input_dev = NULL;
-out_table:
-	ir_free_table(&dev->rc_map);
 out_dev:
 	device_del(&dev->dev);
+out_keytable:
+	rc_keytable_destroy(dev->kt);
 out_unlock:
 	mutex_unlock(&dev->lock);
 out_minor:
@@ -1412,18 +609,10 @@ void rc_unregister_device(struct rc_dev *dev)
 	wake_up_interruptible_all(&dev->rxwait);
 	wake_up_interruptible_all(&dev->txwait);
 
-	del_timer_sync(&dev->timer_keyup);
-
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		ir_raw_event_unregister(dev);
 
-	/* Freeing the table should also call the stop callback */
-	ir_free_table(&dev->rc_map);
-	IR_dprintk(1, "Freed keycode table\n");
-
-	input_unregister_device(dev->input_dev);
-	dev->input_dev = NULL;
-
+	rc_keytable_destroy(dev->kt);
 	device_unregister(&dev->dev);
 }
 
@@ -1480,6 +669,9 @@ static int rc_open(struct inode *inode, struct file *file)
 	file->private_data = client;
 	nonseekable_open(inode, file);
 
+	if (dev->users++ == 0 && dev->open)
+		dev->open(dev);
+
 	IR_dprintk(2, "Device %u opened\n", iminor(inode));
 	return 0;
 
@@ -1507,6 +699,10 @@ static int rc_release(struct inode *inode, struct file *file)
 	spin_unlock(&dev->client_lock);
 	synchronize_rcu();
 	kfree(client);
+
+	if (--dev->users == 0 && dev->close)
+		dev->close(dev);
+
 	put_device(&dev->dev);
 
 	IR_dprintk(2, "Device %u closed\n", iminor(inode));
@@ -1819,6 +1015,19 @@ static const struct file_operations rc_fops = {
 #endif
 };
 
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
 	int ret;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 843f363..20bd1ce 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -262,32 +262,24 @@ struct rc_dev {
 	struct input_id			input_id;
 	char				*driver_name;
 	const char			*map_name;
-	struct rc_map			rc_map;
+	struct rc_keytable		*kt;
 	struct mutex			lock;
 	unsigned int			minor;
 	bool				exist;
 	struct list_head		client_list;
 	spinlock_t			client_lock;
+	unsigned			users;
 	DECLARE_KFIFO_PTR(txfifo, struct ir_raw_event);
 	spinlock_t			txlock;
 	wait_queue_head_t		txwait;
 	wait_queue_head_t		rxwait;
 	struct ir_raw_event_ctrl	*raw;
-	struct input_dev		*input_dev;
 	enum rc_driver_type		driver_type;
 	bool				idle;
 	u64				allowed_protos;
 	u64				enabled_protocols;
 	u32				scanmask;
 	void				*priv;
-	spinlock_t			keylock;
-	bool				keypressed;
-	unsigned long			keyup_jiffies;
-	struct timer_list		timer_keyup;
-	u32				last_keycode;
-	enum rc_type			last_protocol;
-	u64				last_scancode;
-	u8				last_toggle;
 	u32				timeout;
 	u32				min_timeout;
 	u32				max_timeout;
@@ -310,6 +302,34 @@ struct rc_dev {
 	int				(*set_ir_tx)(struct rc_dev *dev, struct rc_ir_tx *tx);
 };
 
+/**
+ * struct rc_keytable - represents one keytable for a rc_dev device
+ * @dev:		the rc_dev device this keytable belongs to
+ * @idev:		the input_dev device which belongs to this keytable
+ * @rc_map:		holds the scancode <-> keycode mappings
+ * @keypressed:		whether a key is currently pressed or not
+ * @keyup_jiffies:	when the key should be auto-released
+ * @timer_keyup:	responsible for the auto-release of keys
+ * @keylock:		protects the key state
+ * @last_keycode:	keycode of the last keypress
+ * @last_protocol:	protocol of the last keypress
+ * @last_scancode:	scancode of the last keypress
+ * @last_toggle:	toggle of the last keypress
+ */
+struct rc_keytable {
+	struct rc_dev			*dev;
+	struct input_dev		*idev;
+	struct rc_map			rc_map;
+	bool				keypressed;
+	unsigned long			keyup_jiffies;
+	struct timer_list		timer_keyup;
+	spinlock_t			keylock;
+	u32				last_keycode;
+	enum rc_type			last_protocol;
+	u64				last_scancode;
+	u8				last_toggle;
+};
+
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)
 
 /* rc_event.type value */
@@ -354,9 +374,10 @@ void rc_unregister_device(struct rc_dev *dev);
 void rc_event(struct rc_dev *dev, u16 type, u16 code, u64 val);
 
 void rc_repeat(struct rc_dev *dev);
-void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u64 scancode, u8 toggle);
-void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol, u64 scancode, u8 toggle);
 void rc_keyup(struct rc_dev *dev);
+void rc_do_keydown(struct rc_dev *dev, enum rc_type protocol, u64 scancode, u8 toggle, bool autoup);
+#define rc_keydown(dev, proto, scan, toggle) rc_do_keydown(dev, proto, scan, toggle, true)
+#define rc_keydown_notimeout(dev, proto, scan, toggle) rc_do_keydown(dev, proto, scan, toggle, false)
 u32 rc_g_keycode_from_table(struct rc_dev *dev, enum rc_type protocol, u64 scancode);
 
 /*

