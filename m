Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44281 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765Ab2EWJy6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:58 -0400
Subject: [PATCH 42/43] rc-core: move remaining keytable functions
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:45:41 +0200
Message-ID: <20120523094541.14474.25054.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move some more keytable related functionality over to rc-keytable.c which
allows more implementational details to be obscured away.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-core-priv.h |   11 +-
 drivers/media/rc/rc-keytable.c  |  213 +++++++++++++++++++++++++++++++++------
 drivers/media/rc/rc-main.c      |  132 +-----------------------
 include/media/rc-core.h         |   44 --------
 4 files changed, 193 insertions(+), 207 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 376030e..3f056e3 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -156,13 +156,10 @@ void ir_raw_init(void);
 /*
  * Methods from rc-keytable.c to be used internally
  */
-void rc_keytable_keyup(struct rc_keytable *kt);
-void rc_keytable_repeat(struct rc_keytable *kt);
-void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
-			 u64 scancode, u8 toggle, bool autokeyup);
-struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *name,
-				       const char *map_name);
-void rc_keytable_destroy(struct rc_keytable *kt);
+int rc_keytable_add(struct rc_dev *dev, const char *name, const char *map_name);
+int rc_keytable_remove(struct rc_dev *dev, unsigned i);
+int rc_keytable_get_name(struct rc_dev *dev, unsigned i,
+			 char *buf, size_t bufsize);
 
 /* Only to be used by rc-core and ir-lirc-codec */
 void rc_init_ir_rx(struct rc_dev *dev, struct rc_ir_rx *rx);
diff --git a/drivers/media/rc/rc-keytable.c b/drivers/media/rc/rc-keytable.c
index d0777cb..027a703 100644
--- a/drivers/media/rc/rc-keytable.c
+++ b/drivers/media/rc/rc-keytable.c
@@ -29,6 +29,50 @@
 /* FIXME: RC_KEYPRESS_TIMEOUT should be protocol specific */
 #define RC_KEYPRESS_TIMEOUT 250
 
+/**
+ * struct rc_scan - rcu-friendly scancode<->keycode table
+ * @len:        number of elements in the table array
+ * @table:      array of struct rc_map_table elements
+ */
+struct rc_scan {
+	unsigned len;
+	struct rc_map_table table[];
+};
+
+/**
+ * struct rc_keytable - represents one keytable for a rc_dev device
+ * @node:               used to iterate over all keytables for a rc_dev device
+ * @dev:                the rc_dev device this keytable belongs to
+ * @idev:               the input_dev device which belongs to this keytable
+ * @name:               the user-friendly name of this keytable
+ * @scan_mutex:         protects @scan against concurrent writers
+ * @scan:               the current scancode<->keycode table
+ * @key_lock:           protects the key state
+ * @key_pressed:        whether a key is currently pressed or not
+ * @last_keycode:       keycode of the last keypress
+ * @last_protocol:      protocol of the last keypress
+ * @last_scancode:      scancode of the last keypress
+ * @last_toggle:        toggle of the last keypress
+ * @timer_keyup:        responsible for the auto-release of keys
+ * @keyup_jiffies:      when the key should be auto-released
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
+	u64				last_scancode;
+	u8				last_toggle;
+	struct timer_list		timer_keyup;
+	unsigned long			keyup_jiffies;
+};
+
 /* Used to keep track of known keymaps */
 static LIST_HEAD(rc_map_list);
 static DEFINE_SPINLOCK(rc_map_lock);
@@ -557,19 +601,26 @@ static void rc_do_keyup(struct rc_keytable *kt, bool sync)
 
 /**
  * rc_keyup() - signals the release of a keypress
- * @kt:		the struct rc_keytable descriptor of the keytable
+ * @dev:        the struct rc_dev descriptor of the device
  *
  * This routine is used to signal that a key has been released on the
  * remote control.
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
+
 
 /**
  * rc_timer_keyup() - generates a keyup event after a timeout
@@ -601,22 +652,32 @@ static void rc_timer_keyup(unsigned long cookie)
 
 /**
  * rc_repeat() - signals that a key is still pressed
- * @kt:		the struct rc_keytable descriptor of the keytable
+ * @dev:        the struct rc_dev descriptor of the device
  *
- * This routine is used when a repeat message which does not include the
- * necessary bits to reproduce the scancode has been received.
+ * This routine is used by when a repeat message which does
+ * not include the necessary bits to reproduce the scancode has been
+ * received.
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
+			kt->keyup_jiffies = jiffies +
+					msecs_to_jiffies(RC_KEYPRESS_TIMEOUT);
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
@@ -629,8 +690,8 @@ void rc_keytable_repeat(struct rc_keytable *kt)
  *
  * This routine is used to signal that a keypress has been detected.
  */
-void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
-			 u64 scancode, u8 toggle, bool autoup)
+static void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
+				u64 scancode, u8 toggle, bool autoup)
 {
 	struct rc_scan *scan;
 	unsigned index;
@@ -677,6 +738,35 @@ void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
 }
 
 /**
+ * rc_do_keydown() - generates input event for a key press
+ * @dev:        the struct rc_dev descriptor of the device
+ * @protocol:   the protocol for the keypress
+ * @scancode:   the scancode for the keypress
+ * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
+ *              support toggle values, this should be set to zero)
+ * @autoup:     should an automatic keyup event be generated in the future
+ *
+ * This routine is used to signal that a key has been pressed on the
+ * remote control.
+ */
+void rc_do_keydown(struct rc_dev *dev, enum rc_type protocol,
+		   u64 scancode, u8 toggle, bool autoup)
+{
+	struct rc_keytable *kt;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(kt, &dev->keytable_list, node)
+		rc_keytable_keydown(kt, protocol, scancode, toggle, autoup);
+	rcu_read_unlock();
+
+	rc_event(dev, RC_KEY, RC_KEY_PROTOCOL, protocol);
+	rc_event(dev, RC_KEY, RC_KEY_SCANCODE, scancode);
+	rc_event(dev, RC_KEY, RC_KEY_TOGGLE, toggle);
+}
+EXPORT_SYMBOL_GPL(rc_do_keydown);
+
+
+/**
  * rc_input_open() - called on the initial use of the input device
  * @idev:	the struct input_dev corresponding to the given keytable
  * @return:	zero on success, otherwise a negative error code
@@ -755,31 +845,67 @@ static int rc_keytable_init(struct rc_keytable *kt,
 }
 
 /**
- * rc_keytable_create() - creates a new keytable
+ * rc_keytable_get_name() - get the name of a keytable
+ * @dev:
+ * @dev:	the struct rc_dev device the keytable belongs to
+ * @i:		the index of the keytable
+ * @buf:	the buffer to write the name to
+ * @bufsize:	the size of the buffer
+ * @return:	zero on success or negative error code
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
+
+/**
+ * rc_keytable_add() - creates a new keytable
  * @dev:	the struct rc_dev device this keytable should belong to
  * @name:	the userfriendly name of this keymap
  * @map_name:	the name of the keymap to autoload
- * @return:	a new struct rc_keytable pointer or NULL on error
+ * @return:	the index of the new rc_keytable or a negative error number
  *
  * This function creates a new keytable (essentially the combination of a
  * keytable and an input device along with some state (whether a key
  * is currently pressed or not, etc).
  */
-struct rc_keytable *rc_keytable_create(struct rc_dev *dev,
-				       const char *name,
-				       const char *map_name)
+int rc_keytable_add(struct rc_dev *dev, const char *name, const char *map_name)
 {
 	struct rc_keytable *kt;
+	unsigned i;
 	struct input_dev *idev = NULL;
 	int error;
 
+	for (i = 0; i < ARRAY_SIZE(dev->keytables); i++)
+		if (!dev->keytables[i])
+			break;
+
+	if (i >= ARRAY_SIZE(dev->keytables))
+		return -ENFILE;
+
 	kt = kzalloc(sizeof(*kt), GFP_KERNEL);
 	if (!kt)
-		return NULL;
+		return -ENOMEM;
 
 	idev = input_allocate_device();
-	if (!idev)
-		goto out;
+	if (!idev) {
+		error = -ENOMEM;
+		goto out_kt;
+	}
 
 	kt->idev = idev;
 	kt->dev = dev;
@@ -795,7 +921,7 @@ struct rc_keytable *rc_keytable_create(struct rc_dev *dev,
 
 	error = rc_keytable_init(kt, rc_map_get(map_name));
 	if (error)
-		goto out;
+		goto out_idev;
 
 	idev->dev.parent = &dev->dev;
 	memcpy(&idev->id, &dev->input_id, sizeof(dev->input_id));
@@ -822,26 +948,49 @@ struct rc_keytable *rc_keytable_create(struct rc_dev *dev,
 
 	spin_lock_init(&kt->key_lock);
 	mutex_init(&kt->scan_mutex);
-	return kt;
+
+	rcu_assign_pointer(dev->keytables[i], kt);
+	list_add_rcu(&kt->node, &dev->keytable_list);
+	synchronize_rcu();
+	rc_event(dev, RC_CORE, RC_CORE_KT_ADDED, i);
+
+	return i;
 
 out_table:
 	kfree(kt->scan);
-out:
+out_idev:
 	input_free_device(idev);
+out_kt:
 	kfree(kt);
-	return NULL;
+	return error;
 }
 
 /**
- * rc_keytable_destroy() - destroys a keytable
- * @dev:	the struct rc_keytable to destroy
+ * rc_keytable_remove() - removes a keytable
+ * @dev:	the struct rc_dev device the keytable belongs to
+ * @i:		the index of the keytable
+ * @return:	zero on success or negative error number
  *
- * This function destroys an existing keytable.
+ * This function removes an existing keytable.
  */
-void rc_keytable_destroy(struct rc_keytable *kt)
+int rc_keytable_remove(struct rc_dev *dev, unsigned i)
 {
+	struct rc_keytable *kt;
+
+	kt = dev->keytables[i];
+	rcu_assign_pointer(dev->keytables[i], NULL);
+	if (kt)
+		list_del_rcu(&kt->node);
+	synchronize_rcu();
+
+	if (!kt)
+		return -EINVAL;
+
+	rc_event(dev, RC_CORE, RC_CORE_KT_REMOVED, i);
 	del_timer_sync(&kt->timer_keyup);
 	input_unregister_device(kt->idev);
 	kfree(kt->scan);
 	kfree(kt);
+
+	return 0;
 }
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index b16dbf4..e2aa7b1 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -101,73 +101,6 @@ void rc_event(struct rc_dev *dev, u16 type, u16 code, u64 val)
 }
 EXPORT_SYMBOL_GPL(rc_event);
 
-/**
- * rc_keyup() - signals the release of a keypress
- * @dev:	the struct rc_dev descriptor of the device
- *
- * This routine is used to signal that a key has been released on the
- * remote control.
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
- * rc_repeat() - signals that a key is still pressed
- * @dev:	the struct rc_dev descriptor of the device
- *
- * This routine is used by IR decoders when a repeat message which does
- * not include the necessary bits to reproduce the scancode has been
- * received.
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
-/**
- * rc_do_keydown() - generates input event for a key press
- * @dev:	the struct rc_dev descriptor of the device
- * @protocol:	the protocol for the keypress
- * @scancode:   the scancode for the keypress
- * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
- *              support toggle values, this should be set to zero)
- * @autoup:	should an automatic keyup event be generated in the future
- *
- * This routine is used to signal that a key has been pressed on the
- * remote control.
- */
-void rc_do_keydown(struct rc_dev *dev, enum rc_type protocol,
-		   u64 scancode, u8 toggle, bool autoup)
-{
-	struct rc_keytable *kt;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(kt, &dev->keytable_list, node)
-		rc_keytable_keydown(kt, protocol, scancode, toggle, autoup);
-	rcu_read_unlock();
-
-	rc_event(dev, RC_KEY, RC_KEY_PROTOCOL, protocol);
-	rc_event(dev, RC_KEY, RC_KEY_SCANCODE, scancode);
-	rc_event(dev, RC_KEY, RC_KEY_TOGGLE, toggle);
-}
-EXPORT_SYMBOL_GPL(rc_do_keydown);
-
 /* class for /sys/class/rc */
 static char *rc_devnode(struct device *dev, umode_t *mode)
 {
@@ -493,48 +426,6 @@ void rc_free_device(struct rc_dev *dev)
 }
 EXPORT_SYMBOL_GPL(rc_free_device);
 
-static int rc_add_keytable(struct rc_dev *dev, const char *name,
-			   const char *map_name)
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
-	kt = rc_keytable_create(dev, name, map_name);
-	if (!kt)
-		return -ENOMEM;
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
 static u64 rc_get_allowed_protocols(struct rc_dev *dev)
 {
 	return dev ? dev->allowed_protos : 0x0;
@@ -590,7 +481,7 @@ int rc_register_device(struct rc_dev *dev)
 	if (rc)
 		goto out_chardev;
 
-	rc = rc_add_keytable(dev, dev->map_name, dev->map_name);
+	rc = rc_keytable_add(dev, dev->map_name, dev->map_name);
 	if (rc < 0)
 		goto out_device;
 
@@ -628,7 +519,7 @@ void rc_unregister_device(struct rc_dev *dev)
 	mutex_lock(&dev->mutex);
 	dev->exist = false;
 	for (i = 0; i < ARRAY_SIZE(dev->keytables); i++)
-		rc_remove_keytable(dev, i);
+		rc_keytable_remove(dev, i);
 	mutex_unlock(&dev->mutex);
 
 	mutex_lock(&rc_dev_table_mutex);
@@ -923,7 +814,6 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 	struct rc_ir_rx rx;
 	struct rc_ir_tx tx;
 	struct rc_keytable_ioctl ktio;
-	struct rc_keytable *kt;
 	int error;
 
 	switch (cmd) {
@@ -1000,7 +890,7 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 		if (strlen(ktio.name) < 1)
 			return -EINVAL;
 
-		error = rc_add_keytable(dev, ktio.name, NULL);
+		error = rc_keytable_add(dev, ktio.name, NULL);
 		if (error < 0)
 			return error;
 		ktio.id = error;
@@ -1020,16 +910,10 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
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
@@ -1046,7 +930,7 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 		if (ktio.flags)
 			return -EINVAL;
 
-		return rc_remove_keytable(dev, ktio.id);
+		return rc_keytable_remove(dev, ktio.id);
 	}
 	return -EINVAL;
 }
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 056275a..e311242 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -351,50 +351,6 @@ struct rc_dev {
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
-	u64				last_scancode;
-	u8				last_toggle;
-	struct timer_list		timer_keyup;
-	unsigned long			keyup_jiffies;
-};
-
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)
 
 /*

