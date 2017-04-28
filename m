Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:33053 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1422821AbdD1RBw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 13:01:52 -0400
Subject: [PATCH] rc-core: add protocol to EVIOC[GS]KEYCODE_V2 ioctl
 (alternative approach)
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Fri, 28 Apr 2017 19:01:49 +0200
Message-ID: <149339890920.12120.16652364964704705650.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is currently impossible to distinguish between scancodes which have
been generated using different protocols (and scancodes can, and will,
overlap).

For example:
RC5 message to address 0x00, command 0x03 has scancode 0x00000503
JVC message to address 0x00, command 0x03 has scancode 0x00000503

It is only possible to distinguish (and parse) scancodes by knowing the
scancode *and* the protocol.

Setting and getting keycodes in the input subsystem used to be done via
the EVIOC[GS]KEYCODE ioctl and "unsigned int[2]" (one int for scancode
and one for the keycode).

The interface has now been extended to use the EVIOC[GS]KEYCODE_V2 ioctl
which uses the following struct:

struct input_keymap_entry {
	__u8  flags;
	__u8  len;
	__u16 index;
	__u32 keycode;
	__u8  scancode[32];
};

(scancode can of course be even bigger, thanks to the len member).

This patch changes how the "input_keymap_entry" struct is interpreted
by rc-core by casting it to "rc_keymap_entry":

struct rc_scancode {
	__u16 protocol;
	__u16 reserved[3];
	__u64 scancode;
}

struct rc_keymap_entry {
	__u8  flags;
	__u8  len;
	__u16 index;
	__u32 keycode;
	union {
		struct rc_scancode rc;
		__u8 raw[32];
	};
};

The u64 scancode member is large enough for all current protocols and it
would be possible to extend it in the future should it be necessary for
some exotic protocol.

The main advantage with this change is that the protocol is made explicit,
which means that we're not throwing away data (the protocol type).

This also means that struct rc_map no longer hardcodes the protocol, meaning
that keytables with mixed entries are possible.

Heuristics are also added to hopefully do the right thing with older
ioctls in order to preserve backwards compatibility.

This is an alternative approach to the other one that I posted here:
http://www.spinics.net/lists/linux-media/msg114898.html

It replaces patches 4-6 of that patchset.

The difference is that RC_TYPE_UNKNOWN is repurposed to serve as a marker
for ioctl() requests and keytable entries which lack protocol information.

ioctl():s which lack a protocol will match on any matching scancode,
regardless of protocol. Keytable entries of type RC_TYPE_UNKNOWN
will match on any protocol.

Note that these heuristics are also not 100% guaranteed to get things
right. For example, consider the following sequence of events:

EVIOCSKEYCODE_V2: <RC_TYPE_RC5, 0x01fe> = KEY_NUMERIC_1
EVIOCSKEYCODE_V2: <RC_TYPE_SANYO, 0x01fe> = KEY_NUMERIC_2
EVIOCGKEYCODE: <0x01fe> = ?
EVIOCSKEYCODE: <0x01fe> = KEY_RESERVED
EVIOCGKEYCODE_V2: <RC_TYPE_RC5, 0x01fe> = ?
EVIOCGKEYCODE_V2: <RC_TYPE_SANYO, 0x01fe> = ?

However, mixing and matching ioctl() types is a pretty pathological
case.

Also, that is somewhat mitigated by the fact that the "only"
userspace binary which might need to change is ir-keytable. Userspace
programs which simply consume input events (i.e. the vast majority)
won't have to change.

I haven't tested the patch yet, consider it a basis for discussion.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ati_remote.c |    1 
 drivers/media/rc/imon.c       |    7 +
 drivers/media/rc/rc-main.c    |  219 ++++++++++++++++++++++++++++++++---------
 include/media/rc-core.h       |   26 ++++-
 include/media/rc-map.h        |    5 +
 5 files changed, 202 insertions(+), 56 deletions(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 9cf3e69de16a..cc81b938471f 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -546,6 +546,7 @@ static void ati_remote_input_report(struct urb *urb)
 		 * set, assume this is a scrollwheel up/down event.
 		 */
 		wheel_keycode = rc_g_keycode_from_table(ati_remote->rdev,
+							RC_TYPE_OTHER,
 							scancode & 0x78);
 
 		if (wheel_keycode == KEY_RESERVED) {
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 3489010601b5..c724a1a5e9cd 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1274,14 +1274,15 @@ static u32 imon_remote_key_lookup(struct imon_context *ictx, u32 scancode)
 	bool is_release_code = false;
 
 	/* Look for the initial press of a button */
-	keycode = rc_g_keycode_from_table(ictx->rdev, scancode);
+	keycode = rc_g_keycode_from_table(ictx->rdev, ictx->rc_type, scancode);
 	ictx->rc_toggle = 0x0;
 	ictx->rc_scancode = scancode;
 
 	/* Look for the release of a button */
 	if (keycode == KEY_RESERVED) {
 		release = scancode & ~0x4000;
-		keycode = rc_g_keycode_from_table(ictx->rdev, release);
+		keycode = rc_g_keycode_from_table(ictx->rdev, ictx->rc_type,
+						  release);
 		if (keycode != KEY_RESERVED)
 			is_release_code = true;
 	}
@@ -1310,7 +1311,7 @@ static u32 imon_mce_key_lookup(struct imon_context *ictx, u32 scancode)
 		scancode = scancode | MCE_KEY_MASK | MCE_TOGGLE_BIT;
 
 	ictx->rc_scancode = scancode;
-	keycode = rc_g_keycode_from_table(ictx->rdev, scancode);
+	keycode = rc_g_keycode_from_table(ictx->rdev, ictx->rc_type, scancode);
 
 	/* not used in mce mode, but make sure we know its false */
 	ictx->release_code = false;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 0acc8f27abeb..85f95441b85b 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -105,7 +105,7 @@ EXPORT_SYMBOL_GPL(rc_map_unregister);
 
 
 static struct rc_map_table empty[] = {
-	{ 0x2a, KEY_COFFEE },
+	{ RC_TYPE_UNKNOWN, 0x2a, KEY_COFFEE },
 };
 
 static struct rc_map_list empty_map = {
@@ -234,16 +234,20 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
 
 	/* Did the user wish to remove the mapping? */
 	if (new_keycode == KEY_RESERVED || new_keycode == KEY_UNKNOWN) {
-		IR_dprintk(1, "#%d: Deleting scan 0x%04x\n",
-			   index, rc_map->scan[index].scancode);
+		IR_dprintk(1, "#%d: Deleting proto 0x%04x, scan 0x%08llx\n",
+			   index, rc_map->scan[index].protocol,
+			   (unsigned long long)rc_map->scan[index].scancode);
 		rc_map->len--;
 		memmove(&rc_map->scan[index], &rc_map->scan[index+ 1],
 			(rc_map->len - index) * sizeof(struct rc_map_table));
 	} else {
-		IR_dprintk(1, "#%d: %s scan 0x%04x with key 0x%04x\n",
+		IR_dprintk(1, "#%d: %s proto 0x%04x, scan 0x%08llx "
+			   "with key 0x%04x\n",
 			   index,
 			   old_keycode == KEY_RESERVED ? "New" : "Replacing",
-			   rc_map->scan[index].scancode, new_keycode);
+			   rc_map->scan[index].protocol,
+			   (unsigned long long)rc_map->scan[index].scancode,
+			   new_keycode);
 		rc_map->scan[index].keycode = new_keycode;
 		__set_bit(new_keycode, dev->input_dev->keybit);
 	}
@@ -270,9 +274,9 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
  * ir_establish_scancode() - set a keycode in the scancode->keycode table
  * @dev:	the struct rc_dev device descriptor
  * @rc_map:	scancode table to be searched
- * @scancode:	the desired scancode
- * @resize:	controls whether we allowed to resize the table to
- *		accommodate not yet present scancodes
+ * @entry:	the entry to be added to the table
+ * @resize:	controls whether we are allowed to resize the table to
+ *		accomodate not yet present scancodes
  * @return:	index of the mapping containing scancode in question
  *		or -1U in case of failure.
  *
@@ -282,7 +286,7 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
  */
 static unsigned int ir_establish_scancode(struct rc_dev *dev,
 					  struct rc_map *rc_map,
-					  unsigned int scancode,
+					  struct rc_map_table *entry,
 					  bool resize)
 {
 	unsigned int i;
@@ -296,16 +300,37 @@ static unsigned int ir_establish_scancode(struct rc_dev *dev,
 	 * indicate the valid bits of the scancodes.
 	 */
 	if (dev->scancode_mask)
-		scancode &= dev->scancode_mask;
-
-	/* First check if we already have a mapping for this ir command */
-	for (i = 0; i < rc_map->len; i++) {
-		if (rc_map->scan[i].scancode == scancode)
-			return i;
+		entry->scancode &= dev->scancode_mask;
 
-		/* Keytable is sorted from lowest to highest scancode */
-		if (rc_map->scan[i].scancode >= scancode)
-			break;
+	/*
+	 * First check if we already have a mapping for this command.
+	 * Note that the keytable is sorted first on protocol and second
+	 * on scancode (lowest to highest).
+	 */
+	if (entry->protocol == RC_TYPE_UNKNOWN) {
+		/* RC_TYPE_UNKNOWN = match on scancode only */
+		for (i = 0; i < rc_map->len; i++) {
+			if (rc_map->scan[i].scancode < entry->scancode)
+				continue;
+			else if (rc_map->scan[i].scancode > entry->scancode)
+				break;
+			else
+				return i;
+		}
+	} else {
+		/* Match on protocol and scancode */
+		for (i = 0; i < rc_map->len; i++) {
+			if (rc_map->scan[i].protocol < entry->protocol)
+				continue;
+			else if (rc_map->scan[i].protocol > entry->protocol)
+				break;
+			else if (rc_map->scan[i].scancode < entry->scancode)
+				continue;
+			else if (rc_map->scan[i].scancode > entry->scancode)
+				break;
+			else
+				return i;
+		}
 	}
 
 	/* No previous mapping found, we might need to grow the table */
@@ -314,11 +339,26 @@ static unsigned int ir_establish_scancode(struct rc_dev *dev,
 			return -1U;
 	}
 
-	/* i is the proper index to insert our new keycode */
+	/*
+	 * RC_TYPE_UNKNOWN means that i may not be the proper index to
+	 * insert the new keycode in order to keep the table properly
+	 * sorted.
+	 */
+	if (entry->protocol == RC_TYPE_UNKNOWN) {
+		if (i >= rc_map->len || rc_map->scan[i].protocol != RC_TYPE_UNKNOWN) {
+			for (i = 0; i < rc_map->len; i++) {
+				if (rc_map->scan[i].protocol != RC_TYPE_UNKNOWN)
+					break;
+			}
+		}
+	}
+
+	/* i is now the proper index to insert our new keycode */
 	if (i < rc_map->len)
 		memmove(&rc_map->scan[i + 1], &rc_map->scan[i],
 			(rc_map->len - i) * sizeof(struct rc_map_table));
-	rc_map->scan[i].scancode = scancode;
+	rc_map->scan[i].scancode = entry->scancode;
+	rc_map->scan[i].protocol = entry->protocol;
 	rc_map->scan[i].keycode = KEY_RESERVED;
 	rc_map->len++;
 
@@ -341,10 +381,12 @@ static int ir_setkeycode(struct input_dev *idev,
 	struct rc_dev *rdev = input_get_drvdata(idev);
 	struct rc_map *rc_map = &rdev->rc_map;
 	unsigned int index;
-	unsigned int scancode;
+	struct rc_map_table entry;
 	int retval = 0;
 	unsigned long flags;
 
+	entry.keycode = ke->keycode;
+
 	spin_lock_irqsave(&rc_map->lock, flags);
 
 	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
@@ -353,16 +395,40 @@ static int ir_setkeycode(struct input_dev *idev,
 			retval = -EINVAL;
 			goto out;
 		}
-	} else {
+	} else if (ke->len == sizeof(int)) {
+		/* Old EVIOCSKEYCODE[_V2] ioctl */
+		u32 scancode;
 		retval = input_scancode_to_scalar(ke, &scancode);
 		if (retval)
 			goto out;
 
-		index = ir_establish_scancode(rdev, rc_map, scancode, true);
+		entry.scancode = scancode;
+		entry.protocol = RC_TYPE_UNKNOWN;
+
+		index = ir_establish_scancode(rdev, rc_map, &entry, true);
 		if (index >= rc_map->len) {
 			retval = -ENOMEM;
 			goto out;
 		}
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
 	}
 
 	*old_keycode = ir_update_mapping(rdev, rc_map, index, ke->keycode);
@@ -385,6 +451,7 @@ static int ir_setkeytable(struct rc_dev *dev,
 			  const struct rc_map *from)
 {
 	struct rc_map *rc_map = &dev->rc_map;
+	struct rc_map_table entry;
 	unsigned int i, index;
 	int rc;
 
@@ -397,15 +464,15 @@ static int ir_setkeytable(struct rc_dev *dev,
 		   rc_map->size, rc_map->alloc);
 
 	for (i = 0; i < from->size; i++) {
-		index = ir_establish_scancode(dev, rc_map,
-					      from->scan[i].scancode, false);
+		entry.protocol = from->rc_type;
+		entry.scancode = from->scan[i].scancode;
+		index = ir_establish_scancode(dev, rc_map, &entry, false);
 		if (index >= rc_map->len) {
 			rc = -ENOMEM;
 			break;
 		}
 
-		ir_update_mapping(dev, rc_map, index,
-				  from->scan[i].keycode);
+		ir_update_mapping(dev, rc_map, index, from->scan[i].keycode);
 	}
 
 	if (rc)
@@ -417,6 +484,7 @@ static int ir_setkeytable(struct rc_dev *dev,
 /**
  * ir_lookup_by_scancode() - locate mapping by scancode
  * @rc_map:	the struct rc_map to search
+ * @protocol:	protocol to look for in the table
  * @scancode:	scancode to look for in the table
  * @return:	index in the table, -1U if not found
  *
@@ -424,17 +492,44 @@ static int ir_setkeytable(struct rc_dev *dev,
  * given scancode.
  */
 static unsigned int ir_lookup_by_scancode(const struct rc_map *rc_map,
-					  unsigned int scancode)
+					  u16 protocol, u64 scancode)
 {
-	int start = 0;
-	int end = rc_map->len - 1;
+	int start;
 	int mid;
+	int end = rc_map->len - 1;
+	struct rc_map_table *m;
 
+	/*
+	 * First, check for protocol-less entries. Since the table is
+	 * sorted by protocol, then scancode, these entries (if any)
+	 * are first.
+	 */
+	for (start = 0; start <= end; start++) {
+		m = &rc_map->scan[start];
+		if (m->protocol != RC_TYPE_UNKNOWN)
+			break;
+		if (m->scancode == scancode)
+			return start;
+	}
+
+	/* Then do a binary search through the remaining entries */
 	while (start <= end) {
 		mid = (start + end) / 2;
-		if (rc_map->scan[mid].scancode < scancode)
+		m = &rc_map->scan[mid];
+
+		if (protocol != RC_TYPE_UNKNOWN) {
+			if (m->protocol < protocol) {
+				start = mid + 1;
+				continue;
+			} else if (m->protocol > protocol) {
+				end = mid - 1;
+				continue;
+			}
+		}
+
+		if (m->scancode < scancode)
 			start = mid + 1;
-		else if (rc_map->scan[mid].scancode > scancode)
+		else if (m->scancode > scancode)
 			end = mid - 1;
 		else
 			return mid;
@@ -455,33 +550,56 @@ static unsigned int ir_lookup_by_scancode(const struct rc_map *rc_map,
 static int ir_getkeycode(struct input_dev *idev,
 			 struct input_keymap_entry *ke)
 {
+	struct rc_keymap_entry *rke = (struct rc_keymap_entry *)ke;
 	struct rc_dev *rdev = input_get_drvdata(idev);
 	struct rc_map *rc_map = &rdev->rc_map;
 	struct rc_map_table *entry;
 	unsigned long flags;
 	unsigned int index;
-	unsigned int scancode;
 	int retval;
 
 	spin_lock_irqsave(&rc_map->lock, flags);
 
 	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
 		index = ke->index;
-	} else {
+	} else if (ke->len == sizeof(int)) {
+		/* Legacy EVIOCGKEYCODE ioctl */
+		u32 scancode;
+
 		retval = input_scancode_to_scalar(ke, &scancode);
 		if (retval)
 			goto out;
 
-		index = ir_lookup_by_scancode(rc_map, scancode);
+		index = ir_lookup_by_scancode(rc_map, RC_TYPE_UNKNOWN, scancode);
+
+	} else if (ke->len == sizeof(struct rc_scancode)) {
+		/* New EVIOCGKEYCODE_V2 ioctl */
+		if (rke->rc.reserved[0] || rke->rc.reserved[1] || rke->rc.reserved[2]) {
+			retval = -EINVAL;
+			goto out;
+		}
+
+		index = ir_lookup_by_scancode(rc_map,
+					      rke->rc.protocol,
+					      rke->rc.scancode);
+
+	} else {
+		retval = -EINVAL;
+		goto out;
 	}
 
 	if (index < rc_map->len) {
 		entry = &rc_map->scan[index];
-
 		ke->index = index;
 		ke->keycode = entry->keycode;
-		ke->len = sizeof(entry->scancode);
-		memcpy(ke->scancode, &entry->scancode, sizeof(entry->scancode));
+		if (ke->len == sizeof(int)) {
+			u32 scancode = entry->scancode;
+			memcpy(ke->scancode, &scancode, sizeof(scancode));
+		} else {
+			ke->len = sizeof(struct rc_scancode);
+			rke->rc.protocol = entry->protocol;
+			rke->rc.scancode = entry->scancode;
+		}
 
 	} else if (!(ke->flags & INPUT_KEYMAP_BY_INDEX)) {
 		/*
@@ -506,6 +624,7 @@ static int ir_getkeycode(struct input_dev *idev,
 /**
  * rc_g_keycode_from_table() - gets the keycode that corresponds to a scancode
  * @dev:	the struct rc_dev descriptor of the device
+ * @protocol:	the protocol to look for
  * @scancode:	the scancode to look for
  * @return:	the corresponding keycode, or KEY_RESERVED
  *
@@ -513,7 +632,8 @@ static int ir_getkeycode(struct input_dev *idev,
  * keycode. Normally it should not be used since drivers should have no
  * interest in keycodes.
  */
-u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode)
+u32 rc_g_keycode_from_table(struct rc_dev *dev,
+			    enum rc_type protocol, u64 scancode)
 {
 	struct rc_map *rc_map = &dev->rc_map;
 	unsigned int keycode;
@@ -522,15 +642,16 @@ u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode)
 
 	spin_lock_irqsave(&rc_map->lock, flags);
 
-	index = ir_lookup_by_scancode(rc_map, scancode);
+	index = ir_lookup_by_scancode(rc_map, protocol, scancode);
 	keycode = index < rc_map->len ?
 			rc_map->scan[index].keycode : KEY_RESERVED;
 
 	spin_unlock_irqrestore(&rc_map->lock, flags);
 
 	if (keycode != KEY_RESERVED)
-		IR_dprintk(1, "%s: scancode 0x%04x keycode 0x%02x\n",
-			   dev->input_name, scancode, keycode);
+		IR_dprintk(1, "%s: protocol 0x%04x scancode 0x%08llx keycode 0x%02x\n",
+			   dev->input_name, protocol,
+			   (unsigned long long)scancode, keycode);
 
 	return keycode;
 }
@@ -683,10 +804,11 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
  * This routine is used to signal that a key has been pressed on the
  * remote control.
  */
-void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle)
+void rc_keydown(struct rc_dev *dev, enum rc_type protocol,
+		u64 scancode, u8 toggle)
 {
 	unsigned long flags;
-	u32 keycode = rc_g_keycode_from_table(dev, scancode);
+	u32 keycode = rc_g_keycode_from_table(dev, protocol, scancode);
 
 	spin_lock_irqsave(&dev->keylock, flags);
 	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
@@ -712,10 +834,10 @@ EXPORT_SYMBOL_GPL(rc_keydown);
  * remote control. The driver must manually call rc_keyup() at a later stage.
  */
 void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol,
-			  u32 scancode, u8 toggle)
+			  u64 scancode, u8 toggle)
 {
 	unsigned long flags;
-	u32 keycode = rc_g_keycode_from_table(dev, scancode);
+	u32 keycode = rc_g_keycode_from_table(dev, protocol, scancode);
 
 	spin_lock_irqsave(&dev->keylock, flags);
 	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
@@ -1639,7 +1761,10 @@ static int rc_prepare_rx_device(struct rc_dev *dev)
 	if (rc)
 		return rc;
 
-	rc_type = BIT_ULL(rc_map->rc_type);
+	if (rc_map->len > 0)
+		rc_type = BIT_ULL(rc_map->scan[0].protocol);
+	else
+		rc_type = RC_TYPE_UNKNOWN;
 
 	if (dev->change_protocol) {
 		rc = dev->change_protocol(dev, &rc_type);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 78dea39a9b39..ad0ed23a9194 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -44,6 +44,24 @@ enum rc_driver_type {
 	RC_DRIVER_IR_RAW_TX,
 };
 
+/* This is used for the input EVIOC[SG]KEYCODE_V2 ioctls */
+struct rc_scancode {
+	__u16 protocol;
+	__u16 reserved[3];
+	__u64 scancode;
+};
+
+struct rc_keymap_entry {
+	__u8  flags;
+	__u8  len;
+	__u16 index;
+	__u32 keycode;
+	union {
+		struct rc_scancode rc;
+		__u8 raw[32];
+	};
+};
+
 /**
  * struct rc_scancode_filter - Filter scan codes.
  * @data:	Scancode data to match.
@@ -166,7 +184,7 @@ struct rc_dev {
 	struct timer_list		timer_keyup;
 	u32				last_keycode;
 	enum rc_type			last_protocol;
-	u32				last_scancode;
+	u64				last_scancode;
 	u8				last_toggle;
 	u32				timeout;
 	u32				min_timeout;
@@ -262,10 +280,10 @@ int rc_open(struct rc_dev *rdev);
 void rc_close(struct rc_dev *rdev);
 
 void rc_repeat(struct rc_dev *dev);
-void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle);
-void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle);
+void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u64 scancode, u8 toggle);
+void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol, u64 scancode, u8 toggle);
 void rc_keyup(struct rc_dev *dev);
-u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode);
+u32 rc_g_keycode_from_table(struct rc_dev *dev, enum rc_type protocol, u64 scancode);
 
 /*
  * From rc-raw.c
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 1a815a572fa1..4f7fd2f4c61b 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -137,8 +137,9 @@ enum rc_type {
  * @keycode: Linux input keycode
  */
 struct rc_map_table {
-	u32	scancode;
-	u32	keycode;
+	u64		scancode;
+	u32		keycode;
+	enum rc_type	protocol;
 };
 
 /**
