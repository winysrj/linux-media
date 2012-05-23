Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44276 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052Ab2EWJyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:52 -0400
Subject: [PATCH 29/43] rc-core: remove redundant spinlock
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:44:32 +0200
Message-ID: <20120523094432.14474.21656.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove a redundant spinlock from struct rc_map.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-keytable.c |   43 +++++++++++++++++-----------------------
 include/media/rc-core.h        |    4 ++--
 include/media/rc-map.h         |    1 -
 3 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/media/rc/rc-keytable.c b/drivers/media/rc/rc-keytable.c
index bdb60f4..eb48358 100644
--- a/drivers/media/rc/rc-keytable.c
+++ b/drivers/media/rc/rc-keytable.c
@@ -335,7 +335,7 @@ static int ir_setkeycode(struct input_dev *idev,
 
 	entry.keycode = ke->keycode;
 
-	spin_lock_irqsave(&rc_map->lock, flags);
+	spin_lock_irqsave(&kt->lock, flags);
 
 	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
 		index = ke->index;
@@ -391,7 +391,7 @@ static int ir_setkeycode(struct input_dev *idev,
 		*old_keycode = ir_update_mapping(kt, rc_map, index, ke->keycode);
 
 out:
-	spin_unlock_irqrestore(&rc_map->lock, flags);
+	spin_unlock_irqrestore(&kt->lock, flags);
 	return retval;
 }
 
@@ -495,7 +495,7 @@ static int ir_getkeycode(struct input_dev *idev,
 	unsigned int index;
 	int retval;
 
-	spin_lock_irqsave(&rc_map->lock, flags);
+	spin_lock_irqsave(&kt->lock, flags);
 
 	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
 		index = ke->index;
@@ -564,7 +564,7 @@ static int ir_getkeycode(struct input_dev *idev,
 	retval = 0;
 
 out:
-	spin_unlock_irqrestore(&rc_map->lock, flags);
+	spin_unlock_irqrestore(&kt->lock, flags);
 	return retval;
 }
 
@@ -574,25 +574,15 @@ static u32 rc_get_keycode(struct rc_keytable *kt,
 	struct rc_map *rc_map;
 	unsigned int keycode = KEY_RESERVED;
 	unsigned int index;
-	unsigned long flags;
 
 	rc_map = &kt->rc_map;
 	if (!rc_map)
 		return KEY_RESERVED;
 
-	spin_lock_irqsave(&rc_map->lock, flags);
-
 	index = ir_lookup_by_scancode(rc_map, protocol, scancode);
 	if (index < rc_map->len)
 		keycode = rc_map->scan[index].keycode;
 
-	spin_unlock_irqrestore(&rc_map->lock, flags);
-
-	if (keycode != KEY_RESERVED)
-		IR_dprintk(1, "%s: protocol 0x%04x scancode 0x%08llx keycode 0x%02x\n",
-			   kt->dev->input_name, protocol,
-			   (unsigned long long)scancode, keycode);
-
 	return keycode;
 }
 
@@ -613,13 +603,17 @@ u32 rc_g_keycode_from_table(struct rc_dev *dev,
 {
 	struct rc_keytable *kt;
 	unsigned int keycode = KEY_RESERVED;
+	unsigned long flags;
 
 	/* FIXME: This entire function is a hack. Remove it */
 	rcu_read_lock();
 	kt = rcu_dereference(dev->keytables[0]);
 	if (!kt)
 		goto out;
+
+	spin_lock_irqsave(&kt->lock, flags);
 	keycode = rc_get_keycode(kt, protocol, scancode);
+	spin_unlock_irqrestore(&kt->lock, flags);
 
 out:
 	rcu_read_unlock();
@@ -633,7 +627,7 @@ EXPORT_SYMBOL_GPL(rc_g_keycode_from_table);
  * @sync:	whether or not to call input_sync
  *
  * This function is used internally to release a keypress, it must be
- * called with keylock held.
+ * called with kt->lock held.
  */
 static void rc_do_keyup(struct rc_keytable *kt, bool sync)
 {
@@ -658,9 +652,9 @@ void rc_keytable_keyup(struct rc_keytable *kt)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&kt->keylock, flags);
+	spin_lock_irqsave(&kt->lock, flags);
 	rc_do_keyup(kt, true);
-	spin_unlock_irqrestore(&kt->keylock, flags);
+	spin_unlock_irqrestore(&kt->lock, flags);
 }
 
 /**
@@ -685,10 +679,10 @@ static void rc_timer_keyup(unsigned long cookie)
 	 * to allow the input subsystem to do its auto-repeat magic or
 	 * a keyup event might follow immediately after the keydown.
 	 */
-	spin_lock_irqsave(&kt->keylock, flags);
+	spin_lock_irqsave(&kt->lock, flags);
 	if (time_is_before_eq_jiffies(kt->keyup_jiffies))
 		rc_do_keyup(kt, true);
-	spin_unlock_irqrestore(&kt->keylock, flags);
+	spin_unlock_irqrestore(&kt->lock, flags);
 }
 
 /**
@@ -703,7 +697,7 @@ void rc_keytable_repeat(struct rc_keytable *kt)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&kt->keylock, flags);
+	spin_lock_irqsave(&kt->lock, flags);
 
 	input_event(kt->idev, EV_MSC, MSC_SCAN, kt->last_scancode);
 	input_sync(kt->idev);
@@ -715,7 +709,7 @@ void rc_keytable_repeat(struct rc_keytable *kt)
 	mod_timer(&kt->timer_keyup, kt->keyup_jiffies);
 
 out:
-	spin_unlock_irqrestore(&kt->keylock, flags);
+	spin_unlock_irqrestore(&kt->lock, flags);
 }
 
 /**
@@ -736,7 +730,7 @@ void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
 	u32 keycode;
 	bool new_event;
 
-	spin_lock_irqsave(&kt->keylock, flags);
+	spin_lock_irqsave(&kt->lock, flags);
 
 	keycode = rc_get_keycode(kt, protocol, scancode);
 	new_event = !kt->keypressed || kt->last_protocol != protocol ||
@@ -767,7 +761,7 @@ void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
 		kt->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
 		mod_timer(&kt->timer_keyup, kt->keyup_jiffies);
 	}
-	spin_unlock_irqrestore(&kt->keylock, flags);
+	spin_unlock_irqrestore(&kt->lock, flags);
 }
 
 /**
@@ -891,8 +885,7 @@ struct rc_keytable *rc_keytable_create(struct rc_dev *dev,
 	 */
 	idev->rep[REP_PERIOD] = 125;
 
-	spin_lock_init(&kt->rc_map.lock);
-	spin_lock_init(&kt->keylock);
+	spin_lock_init(&kt->lock);
 	return kt;
 
 out:
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 1852b47..cd93623 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -336,7 +336,7 @@ struct rc_dev {
  * @keypressed:		whether a key is currently pressed or not
  * @keyup_jiffies:	when the key should be auto-released
  * @timer_keyup:	responsible for the auto-release of keys
- * @keylock:		protects the key state
+ * @lock:		protects the key state
  * @last_keycode:	keycode of the last keypress
  * @last_protocol:	protocol of the last keypress
  * @last_scancode:	scancode of the last keypress
@@ -351,7 +351,7 @@ struct rc_keytable {
 	bool				keypressed;
 	unsigned long			keyup_jiffies;
 	struct timer_list		timer_keyup;
-	spinlock_t			keylock;
+	spinlock_t			lock;
 	u32				last_keycode;
 	enum rc_type			last_protocol;
 	u64				last_scancode;
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 7de8215..5737c65 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -90,7 +90,6 @@ struct rc_map {
 	unsigned int		alloc;	/* Size of *scan in bytes */
 	enum rc_type		rc_type; /* For in-kernel keymaps */
 	const char		*name;
-	spinlock_t		lock;
 };
 
 struct rc_map_list {

