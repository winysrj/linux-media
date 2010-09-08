Return-path: <mchehab@pedra>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44146 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622Ab0IHHls (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 03:41:48 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 1/6] Input: add support for large scancodes
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Jiri Kosina <jkosina@suse.cz>, Ville Syrjala <syrjala@sci.fi>
Date: Wed, 08 Sep 2010 00:41:44 -0700
Message-ID: <20100908074144.32365.27232.stgit@hammer.corenet.prv>
In-Reply-To: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

From: Mauro Carvalho Chehab <mchehab@redhat.com>

Several devices use a high number of bits for scancodes. One important
group is the Remote Controllers. Some new protocols like RC-6 define a
scancode space of 64 bits.

The current EVIO[CS]GKEYCODE ioctls allow replace the scancode/keycode
translation tables, but it is limited to up to 32 bits for scancode.

Also, if userspace wants to clean the existing table, replacing it by
a new one, it needs to run a loop calling the ioctls over the entire
sparse scancode space.

To solve those problems, this patch extends the ioctls to allow drivers
handle scancodes up to 32 bytes long (the length could be extended in
the future should such need arise) and allow userspace to query and set
scancode to keycode mappings not only by scancode but also by index.

Compatibility code were also added to handle the old format of
EVIO[CS]GKEYCODE ioctls.

Folded fixes by:
- Dan Carpenter: locking fixes for the original implementation
- Jarod Wilson: fix crash when setting keycode and wiring up get/set
                handlers in original implementation.
- Dmitry Torokhov: rework to consolidate old and new scancode handling,
                   provide options to act either by index or scancode.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/char/keyboard.c |   31 ++++++--
 drivers/input/evdev.c   |  100 ++++++++++++++++++++----
 drivers/input/input.c   |  192 +++++++++++++++++++++++++++++++++++------------
 include/linux/input.h   |   55 +++++++++++--
 4 files changed, 292 insertions(+), 86 deletions(-)

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index a7ca752..e95d787 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -175,8 +175,7 @@ EXPORT_SYMBOL_GPL(unregister_keyboard_notifier);
  */
 
 struct getset_keycode_data {
-	unsigned int scancode;
-	unsigned int keycode;
+	struct input_keymap_entry ke;
 	int error;
 };
 
@@ -184,32 +183,50 @@ static int getkeycode_helper(struct input_handle *handle, void *data)
 {
 	struct getset_keycode_data *d = data;
 
-	d->error = input_get_keycode(handle->dev, d->scancode, &d->keycode);
+	d->error = input_get_keycode(handle->dev, &d->ke);
 
 	return d->error == 0; /* stop as soon as we successfully get one */
 }
 
 int getkeycode(unsigned int scancode)
 {
-	struct getset_keycode_data d = { scancode, 0, -ENODEV };
+	struct getset_keycode_data d = {
+		.ke	= {
+			.flags		= 0,
+			.len		= sizeof(scancode),
+			.keycode	= 0,
+		},
+		.error	= -ENODEV,
+	};
+
+	memcpy(d.ke.scancode, &scancode, sizeof(scancode));
 
 	input_handler_for_each_handle(&kbd_handler, &d, getkeycode_helper);
 
-	return d.error ?: d.keycode;
+	return d.error ?: d.ke.keycode;
 }
 
 static int setkeycode_helper(struct input_handle *handle, void *data)
 {
 	struct getset_keycode_data *d = data;
 
-	d->error = input_set_keycode(handle->dev, d->scancode, d->keycode);
+	d->error = input_set_keycode(handle->dev, &d->ke);
 
 	return d->error == 0; /* stop as soon as we successfully set one */
 }
 
 int setkeycode(unsigned int scancode, unsigned int keycode)
 {
-	struct getset_keycode_data d = { scancode, keycode, -ENODEV };
+	struct getset_keycode_data d = {
+		.ke	= {
+			.flags		= 0,
+			.len		= sizeof(scancode),
+			.keycode	= keycode,
+		},
+		.error	= -ENODEV,
+	};
+
+	memcpy(d.ke.scancode, &scancode, sizeof(scancode));
 
 	input_handler_for_each_handle(&kbd_handler, &d, setkeycode_helper);
 
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index c908c5f..1ce9bf6 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -534,6 +534,80 @@ static int handle_eviocgbit(struct input_dev *dev,
 }
 #undef OLD_KEY_MAX
 
+static int evdev_handle_get_keycode(struct input_dev *dev,
+				    void __user *p, size_t size)
+{
+	struct input_keymap_entry ke;
+	int error;
+
+	memset(&ke, 0, sizeof(ke));
+
+	if (size == sizeof(unsigned int[2])) {
+		/* legacy case */
+		int __user *ip = (int __user *)p;
+
+		if (copy_from_user(ke.scancode, p, sizeof(unsigned int)))
+			return -EFAULT;
+
+		ke.len = sizeof(unsigned int);
+		ke.flags = 0;
+
+		error = input_get_keycode(dev, &ke);
+		if (error)
+			return error;
+
+		if (put_user(ke.keycode, ip + 1))
+			return -EFAULT;
+
+	} else {
+		size = min(size, sizeof(ke));
+
+		if (copy_from_user(&ke, p, size))
+			return -EFAULT;
+
+		error = input_get_keycode(dev, &ke);
+		if (error)
+			return error;
+
+		if (copy_to_user(p, &ke, size))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+static int evdev_handle_set_keycode(struct input_dev *dev,
+				    void __user *p, size_t size)
+{
+	struct input_keymap_entry ke;
+
+	memset(&ke, 0, sizeof(ke));
+
+	if (size == sizeof(unsigned int[2])) {
+		/* legacy case */
+		int __user *ip = (int __user *)p;
+
+		if (copy_from_user(ke.scancode, p, sizeof(unsigned int)))
+			return -EFAULT;
+
+		if (get_user(ke.keycode, ip + 1))
+			return -EFAULT;
+
+		ke.len = sizeof(unsigned int);
+		ke.flags = 0;
+
+	} else {
+		size = min(size, sizeof(ke));
+
+		if (copy_from_user(&ke, p, size))
+			return -EFAULT;
+
+		if (ke.len > sizeof(ke.scancode))
+			return -EINVAL;
+	}
+
+	return input_set_keycode(dev, &ke);
+}
+
 static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 			   void __user *p, int compat_mode)
 {
@@ -580,25 +654,6 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 
 		return 0;
 
-	case EVIOCGKEYCODE:
-		if (get_user(t, ip))
-			return -EFAULT;
-
-		error = input_get_keycode(dev, t, &v);
-		if (error)
-			return error;
-
-		if (put_user(v, ip + 1))
-			return -EFAULT;
-
-		return 0;
-
-	case EVIOCSKEYCODE:
-		if (get_user(t, ip) || get_user(v, ip + 1))
-			return -EFAULT;
-
-		return input_set_keycode(dev, t, v);
-
 	case EVIOCRMFF:
 		return input_ff_erase(dev, (int)(unsigned long) p, file);
 
@@ -620,7 +675,6 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 
 	/* Now check variable-length commands */
 #define EVIOC_MASK_SIZE(nr)	((nr) & ~(_IOC_SIZEMASK << _IOC_SIZESHIFT))
-
 	switch (EVIOC_MASK_SIZE(cmd)) {
 
 	case EVIOCGKEY(0):
@@ -654,6 +708,12 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 			return -EFAULT;
 
 		return error;
+
+	case EVIOC_MASK_SIZE(EVIOCGKEYCODE):
+		return evdev_handle_get_keycode(dev, p, size);
+
+	case EVIOC_MASK_SIZE(EVIOCSKEYCODE):
+		return evdev_handle_set_keycode(dev, p, size);
 	}
 
 	/* Multi-number variable-length handlers */
diff --git a/drivers/input/input.c b/drivers/input/input.c
index acb3c80..832771e 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -634,78 +634,141 @@ static void input_disconnect_device(struct input_dev *dev)
 	spin_unlock_irq(&dev->event_lock);
 }
 
-static int input_fetch_keycode(struct input_dev *dev, int scancode)
+/**
+ * input_scancode_to_scalar() - converts scancode in &struct input_keymap_entry
+ * @ke: keymap entry containing scancode to be converted.
+ * @scancode: pointer to the location where converted scancode should
+ *	be stored.
+ *
+ * This function is used to convert scancode stored in &struct keymap_entry
+ * into scalar form understood by legacy keymap handling methods. These
+ * methods expect scancodes to be represented as 'unsigned int'.
+ */
+int input_scancode_to_scalar(const struct input_keymap_entry *ke,
+			     unsigned int *scancode)
+{
+	switch (ke->len) {
+	case 1:
+		*scancode = *((u8 *)ke->scancode);
+		break;
+
+	case 2:
+		*scancode = *((u16 *)ke->scancode);
+		break;
+
+	case 4:
+		*scancode = *((u32 *)ke->scancode);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(input_scancode_to_scalar);
+
+/*
+ * Those routines handle the default case where no [gs]etkeycode() is
+ * defined. In this case, an array indexed by the scancode is used.
+ */
+
+static unsigned int input_fetch_keycode(struct input_dev *dev,
+					unsigned int index)
 {
 	switch (dev->keycodesize) {
-		case 1:
-			return ((u8 *)dev->keycode)[scancode];
+	case 1:
+		return ((u8 *)dev->keycode)[index];
 
-		case 2:
-			return ((u16 *)dev->keycode)[scancode];
+	case 2:
+		return ((u16 *)dev->keycode)[index];
 
-		default:
-			return ((u32 *)dev->keycode)[scancode];
+	default:
+		return ((u32 *)dev->keycode)[index];
 	}
 }
 
 static int input_default_getkeycode(struct input_dev *dev,
-				    unsigned int scancode,
-				    unsigned int *keycode)
+				    struct input_keymap_entry *ke)
 {
+	unsigned int index;
+	int error;
+
 	if (!dev->keycodesize)
 		return -EINVAL;
 
-	if (scancode >= dev->keycodemax)
+	if (ke->flags & INPUT_KEYMAP_BY_INDEX)
+		index = ke->index;
+	else {
+		error = input_scancode_to_scalar(ke, &index);
+		if (error)
+			return error;
+	}
+
+	if (index >= dev->keycodemax)
 		return -EINVAL;
 
-	*keycode = input_fetch_keycode(dev, scancode);
+	ke->keycode = input_fetch_keycode(dev, index);
+	ke->index = index;
+	ke->len = sizeof(index);
+	memcpy(ke->scancode, &index, sizeof(index));
 
 	return 0;
 }
 
 static int input_default_setkeycode(struct input_dev *dev,
-				    unsigned int scancode,
-				    unsigned int keycode)
+				    const struct input_keymap_entry *ke,
+				    unsigned int *old_keycode)
 {
-	int old_keycode;
+	unsigned int index;
+	int error;
 	int i;
 
-	if (scancode >= dev->keycodemax)
+	if (!dev->keycodesize)
 		return -EINVAL;
 
-	if (!dev->keycodesize)
+	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
+		index = ke->index;
+	} else {
+		error = input_scancode_to_scalar(ke, &index);
+		if (error)
+			return error;
+	}
+
+	if (index >= dev->keycodemax)
 		return -EINVAL;
 
-	if (dev->keycodesize < sizeof(keycode) && (keycode >> (dev->keycodesize * 8)))
+	if (dev->keycodesize < sizeof(dev->keycode) &&
+			(ke->keycode >> (dev->keycodesize * 8)))
 		return -EINVAL;
 
 	switch (dev->keycodesize) {
 		case 1: {
 			u8 *k = (u8 *)dev->keycode;
-			old_keycode = k[scancode];
-			k[scancode] = keycode;
+			*old_keycode = k[index];
+			k[index] = ke->keycode;
 			break;
 		}
 		case 2: {
 			u16 *k = (u16 *)dev->keycode;
-			old_keycode = k[scancode];
-			k[scancode] = keycode;
+			*old_keycode = k[index];
+			k[index] = ke->keycode;
 			break;
 		}
 		default: {
 			u32 *k = (u32 *)dev->keycode;
-			old_keycode = k[scancode];
-			k[scancode] = keycode;
+			*old_keycode = k[index];
+			k[index] = ke->keycode;
 			break;
 		}
 	}
 
-	__clear_bit(old_keycode, dev->keybit);
-	__set_bit(keycode, dev->keybit);
+	__clear_bit(*old_keycode, dev->keybit);
+	__set_bit(ke->keycode, dev->keybit);
 
 	for (i = 0; i < dev->keycodemax; i++) {
-		if (input_fetch_keycode(dev, i) == old_keycode) {
-			__set_bit(old_keycode, dev->keybit);
+		if (input_fetch_keycode(dev, i) == *old_keycode) {
+			__set_bit(*old_keycode, dev->keybit);
 			break; /* Setting the bit twice is useless, so break */
 		}
 	}
@@ -716,53 +779,86 @@ static int input_default_setkeycode(struct input_dev *dev,
 /**
  * input_get_keycode - retrieve keycode currently mapped to a given scancode
  * @dev: input device which keymap is being queried
- * @scancode: scancode (or its equivalent for device in question) for which
- *	keycode is needed
- * @keycode: result
+ * @ke: keymap entry
  *
  * This function should be called by anyone interested in retrieving current
- * keymap. Presently keyboard and evdev handlers use it.
+ * keymap. Presently evdev handlers use it.
  */
-int input_get_keycode(struct input_dev *dev,
-		      unsigned int scancode, unsigned int *keycode)
+int input_get_keycode(struct input_dev *dev, struct input_keymap_entry *ke)
 {
 	unsigned long flags;
 	int retval;
 
 	spin_lock_irqsave(&dev->event_lock, flags);
-	retval = dev->getkeycode(dev, scancode, keycode);
-	spin_unlock_irqrestore(&dev->event_lock, flags);
 
+	if (dev->getkeycode) {
+		/*
+		 * Support for legacy drivers, that don't implement the new
+		 * ioctls
+		 */
+		u32 scancode = ke->index;
+
+		memcpy(ke->scancode, &scancode, sizeof(scancode));
+		ke->len = sizeof(scancode);
+		retval = dev->getkeycode(dev, scancode, &ke->keycode);
+	} else {
+		retval = dev->getkeycode_new(dev, ke);
+	}
+
+	spin_unlock_irqrestore(&dev->event_lock, flags);
 	return retval;
 }
 EXPORT_SYMBOL(input_get_keycode);
 
 /**
- * input_get_keycode - assign new keycode to a given scancode
+ * input_set_keycode - attribute a keycode to a given scancode
  * @dev: input device which keymap is being updated
- * @scancode: scancode (or its equivalent for device in question)
- * @keycode: new keycode to be assigned to the scancode
+ * @ke: new keymap entry
  *
  * This function should be called by anyone needing to update current
  * keymap. Presently keyboard and evdev handlers use it.
  */
 int input_set_keycode(struct input_dev *dev,
-		      unsigned int scancode, unsigned int keycode)
+		      const struct input_keymap_entry *ke)
 {
 	unsigned long flags;
 	unsigned int old_keycode;
 	int retval;
 
-	if (keycode > KEY_MAX)
+	if (ke->keycode > KEY_MAX)
 		return -EINVAL;
 
 	spin_lock_irqsave(&dev->event_lock, flags);
 
-	retval = dev->getkeycode(dev, scancode, &old_keycode);
-	if (retval)
-		goto out;
+	if (dev->setkeycode) {
+		/*
+		 * Support for legacy drivers, that don't implement the new
+		 * ioctls
+		 */
+		unsigned int scancode;
+
+		retval = input_scancode_to_scalar(ke, &scancode);
+		if (retval)
+			goto out;
+
+		/*
+		 * We need to know the old scancode, in order to generate a
+		 * keyup effect, if the set operation happens successfully
+		 */
+		if (!dev->getkeycode) {
+			retval = -EINVAL;
+			goto out;
+		}
+
+		retval = dev->getkeycode(dev, scancode, &old_keycode);
+		if (retval)
+			goto out;
+
+		retval = dev->setkeycode(dev, scancode, ke->keycode);
+	} else {
+		retval = dev->setkeycode_new(dev, ke, &old_keycode);
+	}
 
-	retval = dev->setkeycode(dev, scancode, keycode);
 	if (retval)
 		goto out;
 
@@ -1759,11 +1855,11 @@ int input_register_device(struct input_dev *dev)
 		dev->rep[REP_PERIOD] = 33;
 	}
 
-	if (!dev->getkeycode)
-		dev->getkeycode = input_default_getkeycode;
+	if (!dev->getkeycode && !dev->getkeycode_new)
+		dev->getkeycode_new = input_default_getkeycode;
 
-	if (!dev->setkeycode)
-		dev->setkeycode = input_default_setkeycode;
+	if (!dev->setkeycode && !dev->setkeycode_new)
+		dev->setkeycode_new = input_default_setkeycode;
 
 	dev_set_name(&dev->dev, "input%ld",
 		     (unsigned long) atomic_inc_return(&input_no) - 1);
diff --git a/include/linux/input.h b/include/linux/input.h
index 7892651..0057698 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -34,7 +34,7 @@ struct input_event {
  * Protocol version.
  */
 
-#define EV_VERSION		0x010000
+#define EV_VERSION		0x010001
 
 /*
  * IOCTLs (0x00 - 0x7f)
@@ -56,12 +56,37 @@ struct input_absinfo {
 	__s32 resolution;
 };
 
+/**
+ * struct input_keymap_entry - used by EVIOCGKEYCODE/EVIOCSKEYCODE ioctls
+ * @scancode: scancode represented in machine-endian form.
+ * @len: length of the scancode that resides in @scancode buffer.
+ * @index: index in the keymap, may be used instead of scancode
+ * @flags: allows to specify how kernel should handle the request. For
+ *	example, setting INPUT_KEYMAP_BY_INDEX flag indicates that kernel
+ *	should perform lookup in keymap by @index instead of @scancode
+ * @keycode: key code assigned to this scancode
+ *
+ * The structure is used to retrieve and modify keymap data. Users have
+ * option of performing lookup either by @scancode itself or by @index
+ * in keymap entry. EVIOCGKEYCODE will also return scancode or index
+ * (depending on which element was used to perform lookup).
+ */
+struct input_keymap_entry {
+#define INPUT_KEYMAP_BY_INDEX	(1 << 0)
+	__u8  flags;
+	__u8  len;
+	__u16 index;
+	__u32 keycode;
+	__u8  scancode[32];
+};
+
 #define EVIOCGVERSION		_IOR('E', 0x01, int)			/* get driver version */
 #define EVIOCGID		_IOR('E', 0x02, struct input_id)	/* get device ID */
 #define EVIOCGREP		_IOR('E', 0x03, unsigned int[2])	/* get repeat settings */
 #define EVIOCSREP		_IOW('E', 0x03, unsigned int[2])	/* set repeat settings */
-#define EVIOCGKEYCODE		_IOR('E', 0x04, unsigned int[2])	/* get keycode */
-#define EVIOCSKEYCODE		_IOW('E', 0x04, unsigned int[2])	/* set keycode */
+
+#define EVIOCGKEYCODE		_IOR('E', 0x04, struct input_keymap_entry)	/* get keycode */
+#define EVIOCSKEYCODE		_IOW('E', 0x04, struct input_keymap_entry)	/* set keycode */
 
 #define EVIOCGNAME(len)		_IOC(_IOC_READ, 'E', 0x06, len)		/* get device name */
 #define EVIOCGPHYS(len)		_IOC(_IOC_READ, 'E', 0x07, len)		/* get physical location */
@@ -73,8 +98,8 @@ struct input_absinfo {
 #define EVIOCGSW(len)		_IOC(_IOC_READ, 'E', 0x1b, len)		/* get all switch states */
 
 #define EVIOCGBIT(ev,len)	_IOC(_IOC_READ, 'E', 0x20 + ev, len)	/* get event bits */
-#define EVIOCGABS(abs)		_IOR('E', 0x40 + abs, struct input_absinfo)		/* get abs value/limits */
-#define EVIOCSABS(abs)		_IOW('E', 0xc0 + abs, struct input_absinfo)		/* set abs value/limits */
+#define EVIOCGABS(abs)		_IOR('E', 0x40 + abs, struct input_absinfo)	/* get abs value/limits */
+#define EVIOCSABS(abs)		_IOW('E', 0xc0 + abs, struct input_absinfo)	/* set abs value/limits */
 
 #define EVIOCSFF		_IOC(_IOC_WRITE, 'E', 0x80, sizeof(struct ff_effect))	/* send a force effect to a force feedback device */
 #define EVIOCRMFF		_IOW('E', 0x81, int)			/* Erase a force effect */
@@ -1088,13 +1113,13 @@ struct input_mt_slot {
  * @keycodemax: size of keycode table
  * @keycodesize: size of elements in keycode table
  * @keycode: map of scancodes to keycodes for this device
+ * @getkeycode: optional legacy method to retrieve current keymap.
  * @setkeycode: optional method to alter current keymap, used to implement
  *	sparse keymaps. If not supplied default mechanism will be used.
  *	The method is being called while holding event_lock and thus must
  *	not sleep
- * @getkeycode: optional method to retrieve current keymap. If not supplied
- *	default mechanism will be used. The method is being called while
- *	holding event_lock and thus must not sleep
+ * @getkeycode_new: transition method
+ * @setkeycode_new: transition method
  * @ff: force feedback structure associated with the device if device
  *	supports force feedback effects
  * @repeat_key: stores key code of the last key pressed; used to implement
@@ -1168,10 +1193,16 @@ struct input_dev {
 	unsigned int keycodemax;
 	unsigned int keycodesize;
 	void *keycode;
+
 	int (*setkeycode)(struct input_dev *dev,
 			  unsigned int scancode, unsigned int keycode);
 	int (*getkeycode)(struct input_dev *dev,
 			  unsigned int scancode, unsigned int *keycode);
+	int (*setkeycode_new)(struct input_dev *dev,
+			      const struct input_keymap_entry *ke,
+			      unsigned int *old_keycode);
+	int (*getkeycode_new)(struct input_dev *dev,
+			      struct input_keymap_entry *ke);
 
 	struct ff_device *ff;
 
@@ -1478,10 +1509,12 @@ INPUT_GENERATE_ABS_ACCESSORS(fuzz, fuzz)
 INPUT_GENERATE_ABS_ACCESSORS(flat, flat)
 INPUT_GENERATE_ABS_ACCESSORS(res, resolution)
 
-int input_get_keycode(struct input_dev *dev,
-		      unsigned int scancode, unsigned int *keycode);
+int input_scancode_to_scalar(const struct input_keymap_entry *ke,
+			     unsigned int *scancode);
+
+int input_get_keycode(struct input_dev *dev, struct input_keymap_entry *ke);
 int input_set_keycode(struct input_dev *dev,
-		      unsigned int scancode, unsigned int keycode);
+		      const struct input_keymap_entry *ke);
 
 extern struct class input_class;
 

