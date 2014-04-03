Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40329 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbaDCXeE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:34:04 -0400
Subject: [PATCH 33/49] rc-core: make the keytable of rc_dev an array
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:34:02 +0200
Message-ID: <20140403233402.27099.4423.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is another step towards allowing multiple keytables per rc_dev.

struct rc_dev is changed to hold an array of keytables (used later for
indexed access to keytables) as well as a list of the same keytables
(used for iteration in fast paths).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-core-priv.h |    4 +-
 drivers/media/rc/rc-keytable.c  |   95 ++++++++++++++++++++++++---------------
 drivers/media/rc/rc-main.c      |   74 ++++++++++++++++++++++++++++--
 include/media/rc-core.h         |    6 ++
 4 files changed, 134 insertions(+), 45 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 7a7770e..02b538c 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -162,8 +162,8 @@ void rc_keytable_keyup(struct rc_keytable *kt);
 void rc_keytable_repeat(struct rc_keytable *kt);
 void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
 			 u32 scancode, u8 toggle, bool autokeyup);
-int rc_keytable_add(struct rc_dev *dev, struct rc_map *rc_map);
-void rc_keytable_del(struct rc_dev *dev);
+struct rc_keytable *rc_keytable_create(struct rc_dev *dev, struct rc_map *rc_map);
+void rc_keytable_destroy(struct rc_keytable *kt);
 
 /* Only to be used by rc-core and ir-lirc-codec */
 void rc_init_ir_rx(struct rc_dev *dev, struct rc_ir_rx *rx);
diff --git a/drivers/media/rc/rc-keytable.c b/drivers/media/rc/rc-keytable.c
index 0f1b817..412d342 100644
--- a/drivers/media/rc/rc-keytable.c
+++ b/drivers/media/rc/rc-keytable.c
@@ -322,7 +322,7 @@ static unsigned int ir_establish_scancode(struct rc_keytable *kt,
  */
 static inline enum rc_type guess_protocol(struct rc_dev *rdev)
 {
-	struct rc_map *rc_map = &rdev->kt->rc_map;
+	struct rc_map *rc_map = &rdev->keytables[0]->rc_map;
 
 	if (hweight64(rdev->enabled_protocols) == 1)
 		return rc_bitmap_to_type(rdev->enabled_protocols);
@@ -604,40 +604,63 @@ out:
 	return retval;
 }
 
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
+static u32 rc_get_keycode(struct rc_keytable *kt,
+			  enum rc_type protocol, u64 scancode)
 {
-	struct rc_map *rc_map = &dev->kt->rc_map;
-	unsigned int keycode;
+	struct rc_map *rc_map;
+	unsigned int keycode = KEY_RESERVED;
 	unsigned int index;
 	unsigned long flags;
 
+	rc_map = &kt->rc_map;
+	if (!rc_map)
+		return KEY_RESERVED;
+
 	spin_lock_irqsave(&rc_map->lock, flags);
 
 	index = ir_lookup_by_scancode(rc_map, protocol, scancode);
-	keycode = index < rc_map->len ?
-			rc_map->scan[index].keycode : KEY_RESERVED;
+	if (index < rc_map->len)
+		keycode = rc_map->scan[index].keycode;
 
 	spin_unlock_irqrestore(&rc_map->lock, flags);
 
 	if (keycode != KEY_RESERVED)
 		IR_dprintk(1, "%s: protocol 0x%04x scancode 0x%08llx keycode 0x%02x\n",
-			   dev->input_name, protocol,
+			   kt->dev->input_name, protocol,
 			   (unsigned long long)scancode, keycode);
 
 	return keycode;
 }
+
+
+/**
+ * rc_g_keycode_from_table() - gets the keycode that corresponds to a scancode
+ * @dev:	the struct rc_dev descriptor of the device
+ * @protocol:	the protocol to look for
+ * @scancode:	the scancode to look for
+ * @return:	the corresponding keycode, or KEY_RESERVED
+ *
+ * This routine is used by drivers which need to convert a scancode to a
+ * keycode. It should not be used since drivers should have no
+ * interest in keycodes. (deprecated)
+ */
+u32 rc_g_keycode_from_table(struct rc_dev *dev,
+			    enum rc_type protocol, u64 scancode)
+{
+	struct rc_keytable *kt;
+	unsigned int keycode = KEY_RESERVED;
+
+	/* FIXME: This entire function is a hack. Remove it */
+	rcu_read_lock();
+	kt = rcu_dereference(dev->keytables[0]);
+	if (!kt)
+		goto out;
+	keycode = rc_get_keycode(kt, protocol, scancode);
+
+out:
+	rcu_read_unlock();
+	return keycode;
+}
 EXPORT_SYMBOL_GPL(rc_g_keycode_from_table);
 
 /**
@@ -751,7 +774,7 @@ void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
 
 	spin_lock_irqsave(&kt->keylock, flags);
 
-	keycode = rc_g_keycode_from_table(kt->dev, protocol, scancode);
+	keycode = rc_get_keycode(kt, protocol, scancode);
 	new_event = (!kt->keypressed ||
 		     kt->last_protocol != protocol ||
 		     kt->last_scancode != scancode ||
@@ -800,16 +823,16 @@ static void rc_input_close(struct input_dev *idev)
 }
 
 /**
- * rc_keytable_add() - adds a new keytable
+ * rc_keytable_create() - create a new keytable
  * @dev:	the struct rc_dev device this keytable should belong to
  * @rc_map:	the keymap to use for the new keytable
  * @return:	zero on success or a negative error code
  *
- * This function add a new keytable (essentially the combination of a keytable
- * and an input device along with some state (whether a key is currently
- * pressed or not, etc).
+ * This function creates a new keytable (essentially the combination of a
+ * keytable and an input device along with some state (whether a key is
+ * currently pressed or not, etc).
  */
-int rc_keytable_add(struct rc_dev *dev, struct rc_map *rc_map)
+struct rc_keytable *rc_keytable_create(struct rc_dev *dev, struct rc_map *rc_map)
 {
 	struct rc_keytable *kt;
 	struct input_dev *idev = NULL;
@@ -870,31 +893,29 @@ int rc_keytable_add(struct rc_dev *dev, struct rc_map *rc_map)
 	 */
 	idev->rep[REP_PERIOD] = 125;
 
-	dev->kt = kt;
-	return 0;
+	return kt;
 
 out:
 	ir_free_table(&kt->rc_map);
 	input_free_device(idev);
 	kfree(kt);
-	return err;
+	return ERR_PTR(err);
 }
 
 /**
- * rc_keytable_del() - unregisters and deletes a keytable
- * @dev:       the struct rc_dev device with the keytable
+ * rc_keytable_del() - unregisters and frees a keytable
+ * @kt:		the struct rc_keytable to destroy
  *
  * This function unregisters and deletes an existing keytable.
  */
-void rc_keytable_del(struct rc_dev *dev)
+void rc_keytable_destroy(struct rc_keytable *kt)
 {
-	if (!dev->kt)
+	if (!kt)
 		return;
 
-	del_timer_sync(&dev->kt->timer_keyup);
-	ir_free_table(&dev->kt->rc_map);
-	input_unregister_device(dev->kt->idev);
-	kfree(dev->kt);
-	dev->kt = NULL;
+	del_timer_sync(&kt->timer_keyup);
+	ir_free_table(&kt->rc_map);
+	input_unregister_device(kt->idev);
+	kfree(kt);
 }
 
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 23a6701..bc2d479 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -150,8 +150,14 @@ EXPORT_SYMBOL_GPL(rc_close);
 void rc_do_keydown(struct rc_dev *dev, enum rc_type protocol,
 		   u32 scancode, u8 toggle, bool autoup)
 {
+	struct rc_keytable *kt;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(kt, &dev->keytable_list, node)
+		rc_keytable_keydown(kt, protocol, scancode, toggle, autoup);
+	rcu_read_unlock();
+
 	led_trigger_event(led_feedback, LED_FULL);
-	rc_keytable_keydown(dev->kt, protocol, scancode, toggle, autoup);
 	rc_event(dev, RC_KEY, RC_KEY_PROTOCOL, protocol);
 	rc_event(dev, RC_KEY, RC_KEY_SCANCODE, scancode);
 	rc_event(dev, RC_KEY, RC_KEY_TOGGLE, toggle);
@@ -166,7 +172,12 @@ EXPORT_SYMBOL_GPL(rc_do_keydown);
  */
 void rc_keyup(struct rc_dev *dev)
 {
-	rc_keytable_keyup(dev->kt);
+	struct rc_keytable *kt;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(kt, &dev->keytable_list, node)
+		rc_keytable_keyup(kt);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(rc_keyup);
 
@@ -179,11 +190,60 @@ EXPORT_SYMBOL_GPL(rc_keyup);
  */
 void rc_repeat(struct rc_dev *dev)
 {
-	rc_keytable_repeat(dev->kt);
+	struct rc_keytable *kt;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(kt, &dev->keytable_list, node)
+		rc_keytable_repeat(kt);
+	rcu_read_unlock();
+
 	rc_event(dev, RC_KEY, RC_KEY_REPEAT, 1);
 }
 EXPORT_SYMBOL_GPL(rc_repeat);
 
+static int rc_add_keytable(struct rc_dev *dev, struct rc_map *rc_map)
+{
+	struct rc_keytable *kt;
+	unsigned i;
+
+	if (!rc_map)
+		rc_map = rc_map_get(RC_MAP_EMPTY);
+
+	if (!rc_map)
+		return -EFAULT;
+
+	for (i = 0; i < ARRAY_SIZE(dev->keytables); i++)
+		if (!dev->keytables[i])
+			break;
+
+	if (i >= ARRAY_SIZE(dev->keytables))
+		return -ENFILE;
+
+	kt = rc_keytable_create(dev, rc_map);
+	if (IS_ERR(kt))
+		return PTR_ERR(kt);
+
+	rcu_assign_pointer(dev->keytables[i], kt);
+	list_add_rcu(&kt->node, &dev->keytable_list);
+	synchronize_rcu();
+	return 0;
+}
+
+static void rc_remove_keytable(struct rc_dev *dev, unsigned i)
+{
+	struct rc_keytable *kt;
+
+	if (i >= ARRAY_SIZE(dev->keytables))
+		return;
+
+	kt = dev->keytables[i];
+	rcu_assign_pointer(dev->keytables[i], NULL);
+	if (kt)
+		list_del_rcu(&kt->node);
+	synchronize_rcu();
+	rc_keytable_destroy(kt);
+}
+
 /* class for /sys/class/rc */
 static char *rc_devnode(struct device *dev, umode_t *mode)
 {
@@ -1108,6 +1168,7 @@ struct rc_dev *rc_allocate_device(void)
 
 	INIT_LIST_HEAD(&dev->client_list);
 	spin_lock_init(&dev->client_lock);
+	INIT_LIST_HEAD(&dev->keytable_list);
 	mutex_init(&dev->txmutex);
 	init_waitqueue_head(&dev->txwait);
 	init_waitqueue_head(&dev->rxwait);
@@ -1215,7 +1276,7 @@ int rc_register_device(struct rc_dev *dev)
 	if (rc)
 		goto out_cdev;
 
-	rc = rc_keytable_add(dev, rc_map);
+	rc = rc_add_keytable(dev, rc_map);
 	if (rc)
 		goto out_dev;
 
@@ -1243,6 +1304,7 @@ EXPORT_SYMBOL_GPL(rc_register_device);
 void rc_unregister_device(struct rc_dev *dev)
 {
 	struct rc_client *client;
+	unsigned i;
 
 	if (!dev)
 		return;
@@ -1263,7 +1325,8 @@ void rc_unregister_device(struct rc_dev *dev)
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		ir_raw_event_unregister(dev);
 
-	rc_keytable_del(dev);
+	for (i = 0; i < ARRAY_SIZE(dev->keytables); i++)
+		rc_remove_keytable(dev, i);
 
 	/* dev is marked as dead so no one changes dev->users */
 	if (dev->users && dev->close)
@@ -1329,3 +1392,4 @@ module_param_named(debug, rc_core_debug, int, 0644);
 
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_LICENSE("GPL");
+
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index e64d47c..f48d5cd 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -303,6 +303,7 @@ enum rc_filter_type {
  * @get_ir_tx: allow driver to provide tx settings
  * @set_ir_tx: allow driver to change tx settings
  */
+#define RC_MAX_KEYTABLES		1
 struct rc_dev {
 	struct device			dev;
 	struct cdev			cdev;
@@ -312,7 +313,8 @@ struct rc_dev {
 	struct input_id			input_id;
 	char				*driver_name;
 	const char			*map_name;
-	struct rc_keytable		*kt;
+	struct rc_keytable		*keytables[RC_MAX_KEYTABLES];
+	struct list_head		keytable_list;
 	struct mutex			lock;
 	bool				dead;
 	struct list_head		client_list;
@@ -362,6 +364,7 @@ struct rc_dev {
 
 /**
  * struct rc_keytable - represents one keytable for a rc_dev device
+ * @node:		used to iterate over all keytables for a rc_dev device
  * @dev:		the rc_dev device this keytable belongs to
  * @idev:		the input_dev device which belongs to this keytable
  * @rc_map:		holds the scancode <-> keycode mappings
@@ -375,6 +378,7 @@ struct rc_dev {
  * @last_toggle:	toggle of the last keypress
  */
 struct rc_keytable {
+	struct list_head		node;
 	struct rc_dev			*dev;
 	struct input_dev		*idev;
 	struct rc_map			rc_map;

