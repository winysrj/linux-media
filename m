Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44269 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758759Ab2EWJyt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:49 -0400
Subject: [PATCH 27/43] rc-core: make the keytable of rc_dev an array
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:44:22 +0200
Message-ID: <20120523094422.14474.55566.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
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
 drivers/media/rc/rc-keytable.c |   61 ++++++++++++++++++++++++----------
 drivers/media/rc/rc-main.c     |   71 +++++++++++++++++++++++++++++++++++-----
 include/media/rc-core.h        |    6 +++
 3 files changed, 110 insertions(+), 28 deletions(-)

diff --git a/drivers/media/rc/rc-keytable.c b/drivers/media/rc/rc-keytable.c
index 7096f44..f422a3b 100644
--- a/drivers/media/rc/rc-keytable.c
+++ b/drivers/media/rc/rc-keytable.c
@@ -568,6 +568,35 @@ out:
 	return retval;
 }
 
+static u32 rc_get_keycode(struct rc_keytable *kt,
+			  enum rc_type protocol, u64 scancode)
+{
+	struct rc_map *rc_map;
+	unsigned int keycode = KEY_RESERVED;
+	unsigned int index;
+	unsigned long flags;
+
+	rc_map = &kt->rc_map;
+	if (!rc_map)
+		return KEY_RESERVED;
+
+	spin_lock_irqsave(&rc_map->lock, flags);
+
+	index = ir_lookup_by_scancode(rc_map, protocol, scancode);
+	if (index < rc_map->len)
+		keycode = rc_map->scan[index].keycode;
+
+	spin_unlock_irqrestore(&rc_map->lock, flags);
+
+	if (keycode != KEY_RESERVED)
+		IR_dprintk(1, "%s: protocol 0x%04x scancode 0x%08llx keycode 0x%02x\n",
+			   kt->dev->input_name, protocol,
+			   (unsigned long long)scancode, keycode);
+
+	return keycode;
+}
+
+
 /**
  * rc_g_keycode_from_table() - gets the keycode that corresponds to a scancode
  * @dev:	the struct rc_dev descriptor of the device
@@ -576,30 +605,24 @@ out:
  * @return:	the corresponding keycode, or KEY_RESERVED
  *
  * This routine is used by drivers which need to convert a scancode to a
- * keycode. Normally it should not be used since drivers should have no
- * interest in keycodes.
+ * keycode. It should not be used since drivers should have no
+ * interest in keycodes. (deprecated)
  */
 u32 rc_g_keycode_from_table(struct rc_dev *dev,
 			    enum rc_type protocol, u64 scancode)
 {
-	struct rc_map *rc_map = &dev->kt->rc_map;
-	unsigned int keycode;
-	unsigned int index;
-	unsigned long flags;
-
-	spin_lock_irqsave(&rc_map->lock, flags);
-
-	index = ir_lookup_by_scancode(&dev->kt->rc_map, protocol, scancode);
-	keycode = index < rc_map->len ?
-			rc_map->scan[index].keycode : KEY_RESERVED;
-
-	spin_unlock_irqrestore(&rc_map->lock, flags);
+	struct rc_keytable *kt;
+	unsigned int keycode = KEY_RESERVED;
 
-	if (keycode != KEY_RESERVED)
-		IR_dprintk(1, "%s: protocol 0x%04x scancode 0x%08llx keycode 0x%02x\n",
-			   dev->input_name, protocol,
-			   (unsigned long long)scancode, keycode);
+	/* FIXME: This entire function is a hack. Remove it */
+	rcu_read_lock();
+	kt = rcu_dereference(dev->keytables[0]);
+	if (!kt)
+		goto out;
+	keycode = rc_get_keycode(kt, protocol, scancode);
 
+out:
+	rcu_read_unlock();
 	return keycode;
 }
 EXPORT_SYMBOL_GPL(rc_g_keycode_from_table);
@@ -715,7 +738,7 @@ void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
 
 	spin_lock_irqsave(&kt->keylock, flags);
 
-	keycode = rc_g_keycode_from_table(kt->dev, protocol, scancode);
+	keycode = rc_get_keycode(kt, protocol, scancode);
 	new_event = !kt->keypressed || kt->last_protocol != protocol ||
 		     kt->last_scancode != scancode || kt->last_toggle != toggle;
 
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 620cd8d..47e778b 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -110,7 +110,12 @@ EXPORT_SYMBOL_GPL(rc_event);
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
 
@@ -124,7 +129,13 @@ EXPORT_SYMBOL_GPL(rc_keyup);
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
@@ -144,7 +155,13 @@ EXPORT_SYMBOL_GPL(rc_repeat);
 void rc_do_keydown(struct rc_dev *dev, enum rc_type protocol,
 		   u64 scancode, u8 toggle, bool autoup)
 {
-	rc_keytable_keydown(dev->kt, protocol, scancode, toggle, autoup);
+	struct rc_keytable *kt;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(kt, &dev->keytable_list, node)
+		rc_keytable_keydown(kt, protocol, scancode, toggle, autoup);
+	rcu_read_unlock();
+
 	rc_event(dev, RC_KEY, RC_KEY_PROTOCOL, protocol);
 	rc_event(dev, RC_KEY, RC_KEY_SCANCODE, scancode);
 	rc_event(dev, RC_KEY, RC_KEY_TOGGLE, toggle);
@@ -447,6 +464,7 @@ struct rc_dev *rc_allocate_device(void)
 
 	INIT_LIST_HEAD(&dev->client_list);
 	spin_lock_init(&dev->client_lock);
+	INIT_LIST_HEAD(&dev->keytable_list);
 	INIT_KFIFO(dev->txfifo);
 	spin_lock_init(&dev->txlock);
 	init_waitqueue_head(&dev->rxwait);
@@ -478,6 +496,43 @@ void rc_free_device(struct rc_dev *dev)
 }
 EXPORT_SYMBOL_GPL(rc_free_device);
 
+static int rc_add_keytable(struct rc_dev *dev, const char *map_name)
+{
+	struct rc_keytable *kt;
+	unsigned i;
+
+	for (i = 0; i < ARRAY_SIZE(dev->keytables); i++)
+		if (!dev->keytables[i])
+			break;
+
+	if (i >= ARRAY_SIZE(dev->keytables))
+		return -ENFILE;
+
+	kt = rc_keytable_create(dev, map_name);
+	if (!kt)
+		return -ENOMEM;
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
 int rc_register_device(struct rc_dev *dev)
 {
 	static bool raw_init = false; /* raw decoders loaded? */
@@ -538,11 +593,9 @@ int rc_register_device(struct rc_dev *dev)
 	if (rc)
 		goto out_chardev;
 
-	dev->kt = rc_keytable_create(dev, dev->map_name);
-	if (!dev->kt) {
-		rc = -ENOMEM;
+	rc = rc_add_keytable(dev, dev->map_name);
+	if (rc < 0)
 		goto out_device;
-	}
 
 	mutex_unlock(&rc_dev_table_mutex);
 
@@ -573,12 +626,15 @@ EXPORT_SYMBOL_GPL(rc_register_device);
 void rc_unregister_device(struct rc_dev *dev)
 {
 	struct rc_client *client;
+	unsigned i;
 
 	if (!dev)
 		return;
 
 	mutex_lock(&dev->lock);
 	dev->exist = false;
+	for (i = 0; i < ARRAY_SIZE(dev->keytables); i++)
+		rc_remove_keytable(dev, i);
 	mutex_unlock(&dev->lock);
 
 	mutex_lock(&rc_dev_table_mutex);
@@ -595,7 +651,6 @@ void rc_unregister_device(struct rc_dev *dev)
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		ir_raw_event_unregister(dev);
 
-	rc_keytable_destroy(dev->kt);
 	device_unregister(&dev->dev);
 }
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index e34815b..0844e17 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -254,6 +254,7 @@ struct ir_raw_event {
  * @get_ir_tx: allow driver to provide tx settings
  * @set_ir_tx: allow driver to change tx settings
  */
+#define RC_MAX_KEYTABLES		1
 struct rc_dev {
 	struct device			dev;
 	const char			*input_name;
@@ -261,7 +262,8 @@ struct rc_dev {
 	struct input_id			input_id;
 	char				*driver_name;
 	const char			*map_name;
-	struct rc_keytable		*kt;
+	struct rc_keytable		*keytables[RC_MAX_KEYTABLES];
+	struct list_head		keytable_list;
 	struct mutex			lock;
 	unsigned int			minor;
 	bool				exist;
@@ -303,6 +305,7 @@ struct rc_dev {
 
 /**
  * struct rc_keytable - represents one keytable for a rc_dev device
+ * @node:		used to iterate over all keytables for a rc_dev device
  * @dev:		the rc_dev device this keytable belongs to
  * @idev:		the input_dev device which belongs to this keytable
  * @rc_map:		holds the scancode <-> keycode mappings
@@ -316,6 +319,7 @@ struct rc_dev {
  * @last_toggle:	toggle of the last keypress
  */
 struct rc_keytable {
+	struct list_head		node;
 	struct rc_dev			*dev;
 	struct input_dev		*idev;
 	struct rc_map			rc_map;

