Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40359 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbaDCXfU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:35:20 -0400
Subject: [PATCH 48/49] rc-core: move remaining keytable functions
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:35:19 +0200
Message-ID: <20140403233519.27099.17479.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move some more keytable related functionality over to rc-keytable.c which
allows more implementational details to be obscured away.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-core-priv.h |   54 +++++++++++-
 drivers/media/rc/rc-keytable.c  |  169 +++++++++++++++++++++++++++++++--------
 drivers/media/rc/rc-main.c      |  136 ++-----------------------------
 include/media/rc-core.h         |   44 ----------
 4 files changed, 191 insertions(+), 212 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 4945727..1c6c066 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -168,12 +168,54 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
 /*
  * Methods from rc-keytable.c to be used internally
  */
-void rc_keytable_keyup(struct rc_keytable *kt);
-void rc_keytable_repeat(struct rc_keytable *kt);
-void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
-			 u32 scancode, u8 toggle, bool autokeyup);
-struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *name, struct rc_map *rc_map);
-void rc_keytable_destroy(struct rc_keytable *kt);
+int rc_keytable_add(struct rc_dev *dev, const char *name, struct rc_map *rc_map);
+int rc_keytable_del(struct rc_dev *dev, unsigned i);
+int rc_keytable_get_name(struct rc_dev *dev, unsigned i,
+			 char *buf, size_t bufsize);
+
+/**
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
+ * struct rc_keytable - represents one keytable for a rc_dev device
+ * @node:		used to iterate over all keytables for a rc_dev device
+ * @dev:		the rc_dev device this keytable belongs to
+ * @idev:		the input_dev device which belongs to this keytable
+ * @name:		the user-friendly name of this keytable
+ * @scan_mutex:		protects @scan against concurrent writers
+ * @scan:		the current scancode<->keycode table
+ * @key_lock:		protects the key state
+ * @key_pressed:	whether a key is currently pressed or not
+ * @last_keycode:	keycode of the last keypress
+ * @last_protocol:	protocol of the last keypress
+ * @last_scancode:	scancode of the last keypress
+ * @last_toggle:	toggle of the last keypress
+ * @timer_keyup:	responsible for the auto-release of keys
+ * @keyup_jiffies:	when the key should be auto-released
+ */
+struct rc_keytable {
+	struct list_head		node;
+	struct rc_dev			*dev;
+	struct input_dev		*idev;
+	char				name[RC_KEYTABLE_NAME_SIZE];
+	struct mutex			scan_mutex;
+	struct rc_scan __rcu		*scan;
+	spinlock_t			key_lock;
+	bool				key_pressed;
+	u32				last_keycode;
+	enum rc_type			last_protocol;
+	u32				last_scancode;
+	u8				last_toggle;
+	struct timer_list		timer_keyup;
+	unsigned long			keyup_jiffies;
+};
 
 /* Only to be used by rc-core and ir-lirc-codec */
 void rc_init_ir_rx(struct rc_dev *dev, struct rc_ir_rx *rx);
diff --git a/drivers/media/rc/rc-keytable.c b/drivers/media/rc/rc-keytable.c
index 23a66c7..1dd75e2 100644
--- a/drivers/media/rc/rc-keytable.c
+++ b/drivers/media/rc/rc-keytable.c
@@ -591,19 +591,25 @@ static void rc_do_keyup(struct rc_keytable *kt, bool sync)
 }
 
 /**
- * rc_keytable_keyup() - signals the release of a keypress
- * @kt:		the keytable
+ * rc_keyup() - signals the release of a keypress
+ * @dev:       the struct rc_dev descriptor of the device
  *
- * This routine is used to generate input keyup events.
+ * Report that a key is no longer pressed.
  */
-void rc_keytable_keyup(struct rc_keytable *kt)
+void rc_keyup(struct rc_dev *dev)
 {
+	struct rc_keytable *kt;
 	unsigned long flags;
 
-	spin_lock_irqsave(&kt->key_lock, flags);
-	rc_do_keyup(kt, true);
-	spin_unlock_irqrestore(&kt->key_lock, flags);
+	rcu_read_lock();
+	list_for_each_entry_rcu(kt, &dev->keytable_list, node) {
+		spin_lock_irqsave(&kt->key_lock, flags);
+		rc_do_keyup(kt, true);
+		spin_unlock_irqrestore(&kt->key_lock, flags);
+	}
+	rcu_read_unlock();
 }
+EXPORT_SYMBOL_GPL(rc_keyup);
 
 /**
  * rc_timer_keyup() - generates a keyup event after a timeout
@@ -634,23 +640,31 @@ static void rc_timer_keyup(unsigned long cookie)
 }
 
 /**
- * rc_keytable_repeat() - signals that a key is still pressed
- * @kt:		the keytable
+ * rc_repeat() - signals that a key is still pressed
+ * @dev:	the struct rc_dev descriptor of the device
  *
  * This routine is used when a repeat message which does not include the
  * necessary bits to reproduce the scancode has been received.
  */
-void rc_keytable_repeat(struct rc_keytable *kt)
+void rc_repeat(struct rc_dev *dev)
 {
+	struct rc_keytable *kt;
 	unsigned long flags;
 
-	spin_lock_irqsave(&kt->key_lock, flags);
-	if (kt->key_pressed) {
-		kt->keyup_jiffies = jiffies + msecs_to_jiffies(RC_KEYPRESS_TIMEOUT);
-		mod_timer(&kt->timer_keyup, kt->keyup_jiffies);
+	rcu_read_lock();
+	list_for_each_entry_rcu(kt, &dev->keytable_list, node) {
+		spin_lock_irqsave(&kt->key_lock, flags);
+		if (kt->key_pressed) {
+			kt->keyup_jiffies = jiffies + msecs_to_jiffies(RC_KEYPRESS_TIMEOUT);
+			mod_timer(&kt->timer_keyup, kt->keyup_jiffies);
+		}
+		spin_unlock_irqrestore(&kt->key_lock, flags);
 	}
-	spin_unlock_irqrestore(&kt->key_lock, flags);
+	rcu_read_unlock();
+
+	rc_event(dev, RC_KEY, RC_KEY_REPEAT, 1);
 }
+EXPORT_SYMBOL_GPL(rc_repeat);
 
 /**
  * rc_keytable_keydown() - generates input event for a key press
@@ -663,8 +677,8 @@ void rc_keytable_repeat(struct rc_keytable *kt)
  *
  * This routine is used to signal that a keypress has been detected.
  */
-void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
-			 u32 scancode, u8 toggle, bool autoup)
+static void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
+				u32 scancode, u8 toggle, bool autoup)
 {
 	struct rc_scan *scan;
 	unsigned index;
@@ -711,6 +725,34 @@ void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
 	spin_unlock_irqrestore(&kt->key_lock, flags);
 }
 
+/**
+ * rc_do_keydown() - report a key press event
+ * @dev:	the struct rc_dev descriptor of the device
+ * @protocol:	the protocol for the keypress
+ * @scancode:	the scancode for the keypress
+ * @toggle:	the toggle value (protocol dependent, if the protocol doesn't
+ *		support toggle values, this should be set to zero)
+ * @autoup:	whether to automatically generate a keyup event later
+ *
+ * Report that a keypress has been received.
+ */
+void rc_do_keydown(struct rc_dev *dev, enum rc_type protocol,
+		   u32 scancode, u8 toggle, bool autoup)
+{
+	struct rc_keytable *kt;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(kt, &dev->keytable_list, node)
+		rc_keytable_keydown(kt, protocol, scancode, toggle, autoup);
+	rcu_read_unlock();
+
+	led_trigger_event(led_feedback, LED_FULL);
+	rc_event(dev, RC_KEY, RC_KEY_PROTOCOL, protocol);
+	rc_event(dev, RC_KEY, RC_KEY_SCANCODE, scancode);
+	rc_event(dev, RC_KEY, RC_KEY_TOGGLE, toggle);
+}
+EXPORT_SYMBOL_GPL(rc_do_keydown);
+
 static int rc_input_open(struct input_dev *idev)
 {
 	struct rc_keytable *kt = input_get_drvdata(idev);
@@ -762,33 +804,65 @@ static int rc_keytable_init(struct rc_keytable *kt,
 }
 
 /**
- * rc_keytable_create() - create a new keytable
+ * rc_keytable_get_name() - get the name of a keytable
+ * @dev:
+ * @dev:       the struct rc_dev device the keytable belongs to
+ * @i:         the index of the keytable
+ * @buf:       the buffer to write the name to
+ * @bufsize:   the size of the buffer
+ * @return:    zero on success or negative error code
+ *
+ * This function is used to get the userfriendly name of a keytable.
+ */
+int rc_keytable_get_name(struct rc_dev *dev, unsigned i,
+			 char *buf, size_t bufsize)
+{
+	struct rc_keytable *kt;
+
+	rcu_read_lock();
+	kt = rcu_dereference(dev->keytables[i]);
+	if (kt) {
+		buf[0] = '\0';
+		strncat(buf, kt->name, bufsize);
+	}
+	rcu_read_unlock();
+
+	return kt ? 0 : -EINVAL;
+}
+
+/**
+ * rc_keytable_add() - create a new keytable
  * @dev:	the struct rc_dev device this keytable should belong to
  * @name:	the userfriendly name of this keymap
- * @rc_map:	the keymap to use for the new keytable
- * @return:	zero on success or a negative error code
+ * @rc_map:	the keymap to use for the new keytable (if any)
+ * @return:	the index of the new rc_keytable or a negative error code
  *
  * This function creates a new keytable (essentially the combination of a
  * keytable and an input device along with some state (whether a key is
  * currently pressed or not, etc).
  */
-struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *name,
-				       struct rc_map *rc_map)
+int rc_keytable_add(struct rc_dev *dev, const char *name, struct rc_map *rc_map)
 {
 	struct rc_keytable *kt;
+	unsigned i;
 	struct input_dev *idev = NULL;
 	int err;
 
+	for (i = 0; i < ARRAY_SIZE(dev->keytables); i++)
+		if (!dev->keytables[i])
+			break;
+
+	if (i >= ARRAY_SIZE(dev->keytables))
+		return -ENFILE;
+
 	kt = kzalloc(sizeof(*kt), GFP_KERNEL);
-	if (!kt) {
-		err = -ENOMEM;
-		goto out;
-	}
+	if (!kt)
+		return -ENOMEM;
 
 	idev = input_allocate_device();
 	if (!idev) {
 		err = -ENOMEM;
-		goto out;
+		goto out_kt;
 	}
 
 	kt->idev = idev;
@@ -807,7 +881,7 @@ struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *name,
 
 	err = rc_keytable_init(kt, rc_map);
 	if (err)
-		goto out;
+		goto out_idev;
 
 	idev->dev.parent = &dev->dev;
 	memcpy(&idev->id, &dev->input_id, sizeof(dev->input_id));
@@ -816,7 +890,7 @@ struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *name,
 
 	err = input_register_device(idev);
 	if (err)
-		goto out;
+		goto out_scan;
 
 	/*
 	 * Default delay of 250ms is too short for some protocols, especially
@@ -833,29 +907,52 @@ struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *name,
 	 */
 	idev->rep[REP_PERIOD] = 125;
 
-	return kt;
+	rcu_assign_pointer(dev->keytables[i], kt);
+	list_add_rcu(&kt->node, &dev->keytable_list);
+	synchronize_rcu();
+	rc_event(dev, RC_CORE, RC_CORE_KT_ADDED, i);
 
-out:
-	input_free_device(idev);
+	return i;
+
+out_scan:
 	kfree(kt->scan);
+out_idev:
+	input_free_device(idev);
+out_kt:
 	kfree(kt);
-	return ERR_PTR(err);
+	return err;
 }
 
 /**
  * rc_keytable_del() - unregisters and frees a keytable
- * @kt:		the struct rc_keytable to destroy
+ * @dev:       the struct rc_dev device the keytable belongs to
+ * @i:         the index of the keytable
+ * @return:    zero on success or negative error number
  *
  * This function unregisters and deletes an existing keytable.
  */
-void rc_keytable_destroy(struct rc_keytable *kt)
+int rc_keytable_del(struct rc_dev *dev, unsigned i)
 {
+	struct rc_keytable *kt;
+
+	if (i >= ARRAY_SIZE(dev->keytables))
+		return -EINVAL;
+
+	kt = dev->keytables[i];
+	rcu_assign_pointer(dev->keytables[i], NULL);
+	if (kt)
+		list_del_rcu(&kt->node);
+	synchronize_rcu();
+
 	if (!kt)
-		return;
+		return -EINVAL;
 
+	rc_event(dev, RC_CORE, RC_CORE_KT_REMOVED, i);
 	del_timer_sync(&kt->timer_keyup);
 	input_unregister_device(kt->idev);
 	kfree(kt->scan);
 	kfree(kt);
+
+	return 0;
 }
 
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index b3db1dd..12f61ae 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -136,116 +136,6 @@ void rc_close(struct rc_dev *dev)
 }
 EXPORT_SYMBOL_GPL(rc_close);
 
-/**
- * rc_do_keydown() - report a key press event
- * @dev:	the struct rc_dev descriptor of the device
- * @protocol:	the protocol for the keypress
- * @scancode:	the scancode for the keypress
- * @toggle:	the toggle value (protocol dependent, if the protocol doesn't
- *		support toggle values, this should be set to zero)
- * @autoup:	whether to automatically generate a keyup event later
- *
- * Report that a keypress has been received.
- */
-void rc_do_keydown(struct rc_dev *dev, enum rc_type protocol,
-		   u32 scancode, u8 toggle, bool autoup)
-{
-	struct rc_keytable *kt;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(kt, &dev->keytable_list, node)
-		rc_keytable_keydown(kt, protocol, scancode, toggle, autoup);
-	rcu_read_unlock();
-
-	led_trigger_event(led_feedback, LED_FULL);
-	rc_event(dev, RC_KEY, RC_KEY_PROTOCOL, protocol);
-	rc_event(dev, RC_KEY, RC_KEY_SCANCODE, scancode);
-	rc_event(dev, RC_KEY, RC_KEY_TOGGLE, toggle);
-}
-EXPORT_SYMBOL_GPL(rc_do_keydown);
-
-/**
- * rc_keyup() - signals the release of a keypress
- * @dev:       the struct rc_dev descriptor of the device
- *
- * Report that a key is no longer pressed.
- */
-void rc_keyup(struct rc_dev *dev)
-{
-	struct rc_keytable *kt;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(kt, &dev->keytable_list, node)
-		rc_keytable_keyup(kt);
-	rcu_read_unlock();
-}
-EXPORT_SYMBOL_GPL(rc_keyup);
-
-/**
- * rc_repeat() - report that a key is still pressed
- * @dev:	the struct rc_dev descriptor of the device
- *
- * Report that a repeat message (which does not include the necessary bits to
- * reproduce the scancode) has been received.
- */
-void rc_repeat(struct rc_dev *dev)
-{
-	struct rc_keytable *kt;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(kt, &dev->keytable_list, node)
-		rc_keytable_repeat(kt);
-	rcu_read_unlock();
-
-	rc_event(dev, RC_KEY, RC_KEY_REPEAT, 1);
-}
-EXPORT_SYMBOL_GPL(rc_repeat);
-
-static int rc_add_keytable(struct rc_dev *dev, const char *name,
-			   struct rc_map *rc_map)
-{
-	struct rc_keytable *kt;
-	unsigned i;
-
-	for (i = 0; i < ARRAY_SIZE(dev->keytables); i++)
-		if (!dev->keytables[i])
-			break;
-
-	if (i >= ARRAY_SIZE(dev->keytables))
-		return -ENFILE;
-
-	kt = rc_keytable_create(dev, name, rc_map);
-	if (IS_ERR(kt))
-		return PTR_ERR(kt);
-
-	rcu_assign_pointer(dev->keytables[i], kt);
-	list_add_rcu(&kt->node, &dev->keytable_list);
-	synchronize_rcu();
-	rc_event(dev, RC_CORE, RC_CORE_KT_ADDED, i);
-	return 0;
-}
-
-static int rc_remove_keytable(struct rc_dev *dev, unsigned i)
-{
-	struct rc_keytable *kt;
-
-	if (i >= ARRAY_SIZE(dev->keytables))
-		return -EINVAL;
-
-	kt = dev->keytables[i];
-	rcu_assign_pointer(dev->keytables[i], NULL);
-	if (kt)
-		list_del_rcu(&kt->node);
-	synchronize_rcu();
-
-	if (!kt)
-		return -EINVAL;
-
-	rc_keytable_destroy(kt);
-	rc_event(dev, RC_CORE, RC_CORE_KT_REMOVED, i);
-	return 0;
-}
-
 /* class for /sys/class/rc */
 static char *rc_devnode(struct device *dev, umode_t *mode)
 {
@@ -943,7 +833,6 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 	struct rc_ir_rx rx;
 	struct rc_ir_tx tx;
 	struct rc_keytable_ioctl ktio;
-	struct rc_keytable *kt;
 	int error;
 
 	switch (cmd) {
@@ -1020,7 +909,7 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 		if (strlen(ktio.name) < 1)
 			return -EINVAL;
 
-		error = rc_add_keytable(dev, ktio.name, NULL);
+		error = rc_keytable_add(dev, ktio.name, NULL);
 		if (error < 0)
 			return error;
 		ktio.id = error;
@@ -1040,16 +929,10 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 		if (ktio.flags)
 			return -EINVAL;
 
-		rcu_read_lock();
-		kt = rcu_dereference(dev->keytables[ktio.id]);
-		if (kt) {
-			ktio.name[0] = '\0';
-			strncat(ktio.name, kt->name, sizeof(ktio.name));
-		}
-		rcu_read_unlock();
-
-		if (!kt)
-			return -EINVAL;
+		error = rc_keytable_get_name(dev, ktio.id,
+					     ktio.name, sizeof(ktio.name));
+		if (error)
+			return error;
 
 		if (copy_to_user(p, &ktio, sizeof(ktio)))
 			return -EFAULT;
@@ -1066,7 +949,7 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 		if (ktio.flags)
 			return -EINVAL;
 
-		return rc_remove_keytable(dev, ktio.id);
+		return rc_keytable_del(dev, ktio.id);
 	}
 	return -EINVAL;
 }
@@ -1295,6 +1178,7 @@ int rc_register_device(struct rc_dev *dev)
 	if (dev->map_name)
 		rc_map = rc_map_get(dev->map_name);
 
+	/* FIXME: kind of a hack...the driver should probably do this */
 	if (dev->change_protocol && rc_map && rc_map->len > 0) {
 		u64 rc_type = (1 << rc_map->scan[0].protocol);
 		rc = dev->change_protocol(dev, &rc_type);
@@ -1311,8 +1195,8 @@ int rc_register_device(struct rc_dev *dev)
 	if (rc)
 		goto out_cdev;
 
-	rc = rc_add_keytable(dev, dev->map_name, rc_map);
-	if (rc)
+	rc = rc_keytable_add(dev, dev->map_name, rc_map);
+	if (rc < 0)
 		goto out_dev;
 
 	IR_dprintk(1, "Registered %s (driver: %s, remote: %s, mode %s)\n",
@@ -1355,7 +1239,7 @@ void rc_unregister_device(struct rc_dev *dev)
 	cdev_del(&dev->cdev);
 
 	for (i = 0; i < ARRAY_SIZE(dev->keytables); i++)
-		rc_remove_keytable(dev, i);
+		rc_keytable_del(dev, i);
 
 	/* dev is marked as dead so no one changes dev->users */
 	if (dev->users && dev->close)
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index a7354b7..aff3bdd 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -383,50 +383,6 @@ struct rc_dev {
 	int				(*set_ir_tx)(struct rc_dev *dev, struct rc_ir_tx *tx);
 };
 
-/**
- * struct rc_scan - rcu-friendly scancode<->keycode table
- * @len:	number of elements in the table array
- * @table:	array of struct rc_map_table elements
- */
-struct rc_scan {
-	unsigned len;
-	struct rc_map_table table[];
-};
-
-/**
- * struct rc_keytable - represents one keytable for a rc_dev device
- * @node:		used to iterate over all keytables for a rc_dev device
- * @dev:		the rc_dev device this keytable belongs to
- * @idev:		the input_dev device which belongs to this keytable
- * @name:		the user-friendly name of this keytable
- * @scan_mutex:		protects @scan against concurrent writers
- * @scan:		the current scancode<->keycode table
- * @key_lock:		protects the key state
- * @key_pressed:	whether a key is currently pressed or not
- * @last_keycode:	keycode of the last keypress
- * @last_protocol:	protocol of the last keypress
- * @last_scancode:	scancode of the last keypress
- * @last_toggle:	toggle of the last keypress
- * @timer_keyup:	responsible for the auto-release of keys
- * @keyup_jiffies:	when the key should be auto-released
- */
-struct rc_keytable {
-	struct list_head		node;
-	struct rc_dev			*dev;
-	struct input_dev		*idev;
-	char				name[RC_KEYTABLE_NAME_SIZE];
-	struct mutex			scan_mutex;
-	struct rc_scan __rcu		*scan;
-	spinlock_t			key_lock;
-	bool				key_pressed;
-	u32				last_keycode;
-	enum rc_type			last_protocol;
-	u32				last_scancode;
-	u8				last_toggle;
-	struct timer_list		timer_keyup;
-	unsigned long			keyup_jiffies;
-};
-
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)
 
 /*

