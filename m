Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40331 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbaDCXeJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:34:09 -0400
Subject: [PATCH 34/49] rc-core: add ioctls for adding/removing keytables
 from userspace
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:34:08 +0200
Message-ID: <20140403233407.27099.87278.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As all the basics are now in place, we can finally add the ioctls
for adding/removing keytables from userspace.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-core-priv.h |    2 -
 drivers/media/rc/rc-keytable.c  |    5 ++
 drivers/media/rc/rc-main.c      |   81 ++++++++++++++++++++++++++++++++++++---
 include/media/rc-core.h         |   27 +++++++++++++
 4 files changed, 106 insertions(+), 9 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 02b538c..0159836 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -162,7 +162,7 @@ void rc_keytable_keyup(struct rc_keytable *kt);
 void rc_keytable_repeat(struct rc_keytable *kt);
 void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
 			 u32 scancode, u8 toggle, bool autokeyup);
-struct rc_keytable *rc_keytable_create(struct rc_dev *dev, struct rc_map *rc_map);
+struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *name, struct rc_map *rc_map);
 void rc_keytable_destroy(struct rc_keytable *kt);
 
 /* Only to be used by rc-core and ir-lirc-codec */
diff --git a/drivers/media/rc/rc-keytable.c b/drivers/media/rc/rc-keytable.c
index 412d342..6d04b8f 100644
--- a/drivers/media/rc/rc-keytable.c
+++ b/drivers/media/rc/rc-keytable.c
@@ -825,6 +825,7 @@ static void rc_input_close(struct input_dev *idev)
 /**
  * rc_keytable_create() - create a new keytable
  * @dev:	the struct rc_dev device this keytable should belong to
+ * @name:	the userfriendly name of this keymap
  * @rc_map:	the keymap to use for the new keytable
  * @return:	zero on success or a negative error code
  *
@@ -832,7 +833,8 @@ static void rc_input_close(struct input_dev *idev)
  * keytable and an input device along with some state (whether a key is
  * currently pressed or not, etc).
  */
-struct rc_keytable *rc_keytable_create(struct rc_dev *dev, struct rc_map *rc_map)
+struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *name,
+				       struct rc_map *rc_map)
 {
 	struct rc_keytable *kt;
 	struct input_dev *idev = NULL;
@@ -854,6 +856,7 @@ struct rc_keytable *rc_keytable_create(struct rc_dev *dev, struct rc_map *rc_map
 	kt->dev = dev;
 	spin_lock_init(&kt->keylock);
 	spin_lock_init(&kt->rc_map.lock);
+	snprintf(kt->name, sizeof(*kt->name), name ? name : "undefined");
 	idev->getkeycode = ir_getkeycode;
 	idev->setkeycode = ir_setkeycode;
 	idev->open = rc_input_open;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index bc2d479..ad784c8 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -201,7 +201,8 @@ void rc_repeat(struct rc_dev *dev)
 }
 EXPORT_SYMBOL_GPL(rc_repeat);
 
-static int rc_add_keytable(struct rc_dev *dev, struct rc_map *rc_map)
+static int rc_add_keytable(struct rc_dev *dev, const char *name,
+			   struct rc_map *rc_map)
 {
 	struct rc_keytable *kt;
 	unsigned i;
@@ -219,7 +220,7 @@ static int rc_add_keytable(struct rc_dev *dev, struct rc_map *rc_map)
 	if (i >= ARRAY_SIZE(dev->keytables))
 		return -ENFILE;
 
-	kt = rc_keytable_create(dev, rc_map);
+	kt = rc_keytable_create(dev, name, rc_map);
 	if (IS_ERR(kt))
 		return PTR_ERR(kt);
 
@@ -229,19 +230,24 @@ static int rc_add_keytable(struct rc_dev *dev, struct rc_map *rc_map)
 	return 0;
 }
 
-static void rc_remove_keytable(struct rc_dev *dev, unsigned i)
+static int rc_remove_keytable(struct rc_dev *dev, unsigned i)
 {
 	struct rc_keytable *kt;
 
 	if (i >= ARRAY_SIZE(dev->keytables))
-		return;
+		return -EINVAL;
 
 	kt = dev->keytables[i];
 	rcu_assign_pointer(dev->keytables[i], NULL);
 	if (kt)
 		list_del_rcu(&kt->node);
 	synchronize_rcu();
+
+	if (!kt)
+		return -EINVAL;
+
 	rc_keytable_destroy(kt);
+	return 0;
 }
 
 /* class for /sys/class/rc */
@@ -946,6 +952,8 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 	unsigned int __user *ip = (unsigned int __user *)p;
 	struct rc_ir_rx rx;
 	struct rc_ir_tx tx;
+	struct rc_keytable_ioctl ktio;
+	struct rc_keytable *kt;
 	int error;
 
 	switch (cmd) {
@@ -1007,8 +1015,69 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 			return -EFAULT;
 
 		return 0;
-	}
 
+	case RCIOCADDTABLE:
+		if (copy_from_user(&ktio, p, sizeof(ktio)))
+			return -EFAULT;
+
+		if (ktio.id >= RC_MAX_KEYTABLES)
+			return -EINVAL;
+
+		if (ktio.flags)
+			return -EINVAL;
+
+		ktio.name[sizeof(ktio.name) - 1] = '\0';
+		if (strlen(ktio.name) < 1)
+			return -EINVAL;
+
+		error = rc_add_keytable(dev, ktio.name, NULL);
+		if (error < 0)
+			return error;
+		ktio.id = error;
+
+		if (copy_to_user(p, &ktio, sizeof(ktio)))
+			return -EFAULT;
+
+		return 0;
+
+	case RCIOCGTABLENAME:
+		if (copy_from_user(&ktio, p, sizeof(ktio)))
+			return -EFAULT;
+
+		if (ktio.id >= RC_MAX_KEYTABLES)
+			return -EINVAL;
+
+		if (ktio.flags)
+			return -EINVAL;
+
+		rcu_read_lock();
+		kt = rcu_dereference(dev->keytables[ktio.id]);
+		if (kt) {
+			ktio.name[0] = '\0';
+			strncat(ktio.name, kt->name, sizeof(ktio.name));
+		}
+		rcu_read_unlock();
+
+		if (!kt)
+			return -EINVAL;
+
+		if (copy_to_user(p, &ktio, sizeof(ktio)))
+			return -EFAULT;
+
+		return 0;
+
+	case RCIOCDELTABLE:
+		if (copy_from_user(&ktio, p, sizeof(ktio)))
+			return -EFAULT;
+
+		if (ktio.id >= RC_MAX_KEYTABLES)
+			return -EINVAL;
+
+		if (ktio.flags)
+			return -EINVAL;
+
+		return rc_remove_keytable(dev, ktio.id);
+	}
 	return -EINVAL;
 }
 
@@ -1276,7 +1345,7 @@ int rc_register_device(struct rc_dev *dev)
 	if (rc)
 		goto out_cdev;
 
-	rc = rc_add_keytable(dev, rc_map);
+	rc = rc_add_keytable(dev, dev->map_name, rc_map);
 	if (rc)
 		goto out_dev;
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index f48d5cd..6f282e6 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -153,6 +153,29 @@ struct rc_ir_tx {
 	__u32 reserved[9];
 } __packed;
 
+/* add a keytable */
+#define RCIOCADDTABLE	_IOC(_IOC_READ | _IOC_WRITE, RC_IOC_MAGIC, 0x06, sizeof(struct rc_keytable_ioctl))
+
+/* get the name of a keytable */
+#define RCIOCGTABLENAME	_IOC(_IOC_READ, RC_IOC_MAGIC, 0x06, sizeof(struct rc_keytable_ioctl))
+
+/* remove a keytable */
+#define RCIOCDELTABLE	_IOC(_IOC_WRITE, RC_IOC_MAGIC, 0x06, sizeof(struct rc_keytable_ioctl))
+
+/**
+ * struct rc_keytable_ioctl - used to alter keytables
+ * @id: the id of the keytable
+ * @flags: flags for the keytable
+ * @reserved: for future use, set to zero
+ * @name: a user-friendly name for the keytable
+ */
+#define RC_KEYTABLE_NAME_SIZE	128
+struct rc_keytable_ioctl {
+	__u32 id;
+	__u32 flags;
+	__u32 reserved[4];
+	char name[RC_KEYTABLE_NAME_SIZE];
+} __packed;
 
 enum rc_driver_type {
 	RC_DRIVER_SCANCODE = 0,	/* Driver or hardware generates a scancode */
@@ -303,7 +326,7 @@ enum rc_filter_type {
  * @get_ir_tx: allow driver to provide tx settings
  * @set_ir_tx: allow driver to change tx settings
  */
-#define RC_MAX_KEYTABLES		1
+#define RC_MAX_KEYTABLES		32
 struct rc_dev {
 	struct device			dev;
 	struct cdev			cdev;
@@ -367,6 +390,7 @@ struct rc_dev {
  * @node:		used to iterate over all keytables for a rc_dev device
  * @dev:		the rc_dev device this keytable belongs to
  * @idev:		the input_dev device which belongs to this keytable
+ * @name:		the user-friendly name of this keytable
  * @rc_map:		holds the scancode <-> keycode mappings
  * @keypressed:		whether a key is currently pressed or not
  * @keyup_jiffies:	when the key should be auto-released
@@ -381,6 +405,7 @@ struct rc_keytable {
 	struct list_head		node;
 	struct rc_dev			*dev;
 	struct input_dev		*idev;
+	char				name[RC_KEYTABLE_NAME_SIZE];
 	struct rc_map			rc_map;
 	bool				keypressed;
 	unsigned long			keyup_jiffies;

