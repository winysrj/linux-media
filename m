Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44267 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765Ab2EWJyt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:49 -0400
Subject: [PATCH 28/43] rc-core: add ioctls for adding/removing keytables from
 userspace
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:44:27 +0200
Message-ID: <20120523094427.14474.61028.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As all the basics are now in place, we can finally add the ioctls
for adding/removing keytables from userspace.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-core-priv.h |    3 +
 drivers/media/rc/rc-keytable.c  |    6 ++-
 drivers/media/rc/rc-main.c      |   82 +++++++++++++++++++++++++++++++++++----
 include/media/rc-core.h         |   27 ++++++++++++-
 4 files changed, 107 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 7aaa1bf..8006c2e 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -156,7 +156,8 @@ void rc_keytable_keyup(struct rc_keytable *kt);
 void rc_keytable_repeat(struct rc_keytable *kt);
 void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
 			 u64 scancode, u8 toggle, bool autokeyup);
-struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *map_name);
+struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *name,
+				       const char *map_name);
 void rc_keytable_destroy(struct rc_keytable *kt);
 
 /* Only to be used by rc-core and ir-lirc-codec */
diff --git a/drivers/media/rc/rc-keytable.c b/drivers/media/rc/rc-keytable.c
index f422a3b..bdb60f4 100644
--- a/drivers/media/rc/rc-keytable.c
+++ b/drivers/media/rc/rc-keytable.c
@@ -818,6 +818,7 @@ static void rc_input_close(struct input_dev *idev)
 /**
  * rc_keytable_create() - creates a new keytable
  * @dev:	the struct rc_dev device this keytable should belong to
+ * @name:	the userfriendly name of this keymap
  * @map_name:	the name of the keymap to autoload
  * @return:	a new struct rc_keytable pointer or NULL on error
  *
@@ -825,7 +826,9 @@ static void rc_input_close(struct input_dev *idev)
  * keytable and an input device along with some state (whether a key
  * is currently pressed or not, etc).
  */
-struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *map_name)
+struct rc_keytable *rc_keytable_create(struct rc_dev *dev,
+				       const char *name,
+				       const char *map_name)
 {
 	struct rc_keytable *kt;
 	struct input_dev *idev = NULL;
@@ -842,6 +845,7 @@ struct rc_keytable *rc_keytable_create(struct rc_dev *dev, const char *map_name)
 
 	kt->idev = idev;
 	kt->dev = dev;
+	snprintf(kt->name, sizeof(*kt->name), name ? name : "undefined");
 	idev->getkeycode = ir_getkeycode;
 	idev->setkeycode = ir_setkeycode;
 	idev->open = rc_input_open;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 47e778b..a9c7226 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -496,7 +496,8 @@ void rc_free_device(struct rc_dev *dev)
 }
 EXPORT_SYMBOL_GPL(rc_free_device);
 
-static int rc_add_keytable(struct rc_dev *dev, const char *map_name)
+static int rc_add_keytable(struct rc_dev *dev, const char *name,
+			   const char *map_name)
 {
 	struct rc_keytable *kt;
 	unsigned i;
@@ -508,7 +509,7 @@ static int rc_add_keytable(struct rc_dev *dev, const char *map_name)
 	if (i >= ARRAY_SIZE(dev->keytables))
 		return -ENFILE;
 
-	kt = rc_keytable_create(dev, map_name);
+	kt = rc_keytable_create(dev, name, map_name);
 	if (!kt)
 		return -ENOMEM;
 
@@ -518,19 +519,21 @@ static int rc_add_keytable(struct rc_dev *dev, const char *map_name)
 	return 0;
 }
 
-static void rc_remove_keytable(struct rc_dev *dev, unsigned i)
+static int rc_remove_keytable(struct rc_dev *dev, unsigned i)
 {
 	struct rc_keytable *kt;
 
-	if (i >= ARRAY_SIZE(dev->keytables))
-		return;
-
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
 
 int rc_register_device(struct rc_dev *dev)
@@ -593,7 +596,7 @@ int rc_register_device(struct rc_dev *dev)
 	if (rc)
 		goto out_chardev;
 
-	rc = rc_add_keytable(dev, dev->map_name);
+	rc = rc_add_keytable(dev, dev->map_name, dev->map_name);
 	if (rc < 0)
 		goto out_device;
 
@@ -938,6 +941,8 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 	unsigned int __user *ip = (unsigned int __user *)p;
 	struct rc_ir_rx rx;
 	struct rc_ir_tx tx;
+	struct rc_keytable_ioctl ktio;
+	struct rc_keytable *kt;
 	int error;
 
 	switch (cmd) {
@@ -999,8 +1004,69 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
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
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 0844e17..1852b47 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -152,6 +152,29 @@ struct rc_ir_tx {
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
@@ -254,7 +277,7 @@ struct ir_raw_event {
  * @get_ir_tx: allow driver to provide tx settings
  * @set_ir_tx: allow driver to change tx settings
  */
-#define RC_MAX_KEYTABLES		1
+#define RC_MAX_KEYTABLES		32
 struct rc_dev {
 	struct device			dev;
 	const char			*input_name;
@@ -308,6 +331,7 @@ struct rc_dev {
  * @node:		used to iterate over all keytables for a rc_dev device
  * @dev:		the rc_dev device this keytable belongs to
  * @idev:		the input_dev device which belongs to this keytable
+ * @name:		the user-friendly name of this keytable
  * @rc_map:		holds the scancode <-> keycode mappings
  * @keypressed:		whether a key is currently pressed or not
  * @keyup_jiffies:	when the key should be auto-released
@@ -322,6 +346,7 @@ struct rc_keytable {
 	struct list_head		node;
 	struct rc_dev			*dev;
 	struct input_dev		*idev;
+	char				name[RC_KEYTABLE_NAME_SIZE];
 	struct rc_map			rc_map;
 	bool				keypressed;
 	unsigned long			keyup_jiffies;

