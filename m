Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758759Ab0DAR6Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 13:58:25 -0400
Date: Thu, 1 Apr 2010 14:56:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 15/15] V4L/DVB: input: Add support for EVIO[CS]GKEYCODEBIG
Message-ID: <20100401145631.7a708a06@pedra>
In-Reply-To: <cover.1270142346.git.mchehab@redhat.com>
References: <cover.1270142346.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several devices use a high number of bits for scancodes. One important
group is the Remote Controllers. Some new protocols like RC-6 define a
scancode space of 64 bits.

The current EVIO[CS]GKEYCODE ioctls allow replace the scancode/keycode
translation tables, but it is limited to up to 32 bits for scancode.

Also, if userspace wants to clean the existing table, replacing it by
a new one, it needs to run a loop calling the old ioctls, over the
entire sparsed scancode userspace.

To solve those problems, this patch introduces two new ioctls:
	EVIOCGKEYCODEBIG - reads a scancode from the translation table;
	EVIOSGKEYCODEBIG - writes a scancode into the translation table.

The EVIOSGKEYCODEBIG can also be used to cleanup the translation entries
by associating KEY_RESERVED to a scancode.

EVIOCGKEYCODEBIG uses kt_entry::index field in order to retrieve a keycode
from the table. This field is unused on EVIOSGKEYCODEBIG.

By default, kernel will implement a default handler that will work with
both EVIO[CS]GKEYCODEBIG and the legacy EVIO[CS]GKEYCODE ioctls.

Compatibility code were also added to allow drivers that implement
only the ops handler for EVIO[CS]GKEYCODE to keep working.

Userspace compatibility for EVIO[CS]GKEYCODE is also granted: the evdev/input
ioctl handler will automatically map those ioctls with the new
getkeycodebig()/setkeycodebig() operations to handle a request using the
legacy API.

So, new drivers should only implement the EVIO[CS]GKEYCODEBIG operation
handlers: getkeycodebig()/setkeycodebig().

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 258c639..1730b5b 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -513,6 +513,8 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 	struct input_absinfo abs;
 	struct ff_effect effect;
 	int __user *ip = (int __user *)p;
+	struct keycode_table_entry kt, *kt_p = p;
+	char scancode[16];
 	int i, t, u, v;
 	int error;
 
@@ -567,6 +569,43 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 
 		return input_set_keycode(dev, t, v);
 
+	case EVIOCGKEYCODEBIG:
+		if (copy_from_user(&kt, kt_p, sizeof(kt)))
+			return -EFAULT;
+
+		if (kt.len > sizeof(scancode))
+			return -EINVAL;
+
+		kt.scancode = scancode;
+
+		error = input_get_keycode_big(dev, &kt);
+		if (error)
+			return error;
+
+		if (copy_to_user(kt_p, &kt, sizeof(kt)))
+			return -EFAULT;
+
+		/* FIXME: probably need some compat32 code */
+		if (copy_to_user(kt_p->scancode, kt.scancode, kt.len))
+			return -EFAULT;
+
+		return 0;
+
+	case EVIOCSKEYCODEBIG:
+		if (copy_from_user(&kt, kt_p, sizeof(kt)))
+			return -EFAULT;
+
+		if (kt.len > sizeof(scancode))
+			return -EINVAL;
+
+		kt.scancode = scancode;
+
+		/* FIXME: probably need some compat32 code */
+		if (copy_from_user(kt.scancode, kt_p->scancode, kt.len))
+			return -EFAULT;
+
+		return input_set_keycode_big(dev, &kt);
+
 	case EVIOCRMFF:
 		return input_ff_erase(dev, (int)(unsigned long) p, file);
 
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 86cb2d2..d2bb5b5 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -551,6 +551,11 @@ static void input_disconnect_device(struct input_dev *dev)
 	spin_unlock_irq(&dev->event_lock);
 }
 
+/*
+ * Those routines handle the default case where no [gs]etkeycode() is
+ * defined. In this case, an array indexed by the scancode is used.
+ */
+
 static int input_fetch_keycode(struct input_dev *dev, int scancode)
 {
 	switch (dev->keycodesize) {
@@ -565,25 +570,74 @@ static int input_fetch_keycode(struct input_dev *dev, int scancode)
 	}
 }
 
-static int input_default_getkeycode(struct input_dev *dev,
-				    int scancode, int *keycode)
+/*
+ * Supports only 8, 16 and 32 bit scancodes. It wouldn't be that
+ * hard to write some machine-endian logic to support 24 bit scancodes,
+ * but it seemed overkill. It should also be noticed that, since there
+ * are, in general, less than 256 scancodes sparsed into the scancode
+ * space, even with 16 bits, the codespace is sparsed, with leads into
+ * memory and code ineficiency, when retrieving the entire scancode
+ * space.
+ * So, it is highly recommended to implement getkeycodebig/setkeycodebig
+ * instead of using a normal table approach, when more than 8 bits is
+ * needed for the scancode.
+ */
+static int input_fetch_scancode(struct keycode_table_entry *kt_entry,
+				u32 *scancode)
 {
+	switch (kt_entry->len) {
+	case 1:
+		*scancode = *((u8 *)kt_entry->scancode);
+		break;
+	case 2:
+		*scancode = *((u16 *)kt_entry->scancode);
+		break;
+	case 4:
+		*scancode = *((u32 *)kt_entry->scancode);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+
+static int input_default_getkeycode_from_index(struct input_dev *dev,
+				    struct keycode_table_entry *kt_entry)
+{
+	u32 scancode = kt_entry->index;
+
 	if (!dev->keycodesize)
 		return -EINVAL;
 
 	if (scancode >= dev->keycodemax)
 		return -EINVAL;
 
-	*keycode = input_fetch_keycode(dev, scancode);
+	kt_entry->keycode = input_fetch_keycode(dev, scancode);
+	memcpy(kt_entry->scancode, &scancode, 4);
 
 	return 0;
 }
 
+static int input_default_getkeycode_from_scancode(struct input_dev *dev,
+				    struct keycode_table_entry *kt_entry)
+{
+	if (input_fetch_scancode(kt_entry, &kt_entry->index))
+		return -EINVAL;
+
+	return input_default_getkeycode_from_index(dev, kt_entry);
+}
+
+
 static int input_default_setkeycode(struct input_dev *dev,
-				    int scancode, int keycode)
+				    struct keycode_table_entry *kt_entry)
 {
 	int old_keycode;
 	int i;
+	u32 scancode;
+
+	if (input_fetch_scancode(kt_entry, &scancode))
+		return -EINVAL;
 
 	if (scancode >= dev->keycodemax)
 		return -EINVAL;
@@ -591,32 +645,33 @@ static int input_default_setkeycode(struct input_dev *dev,
 	if (!dev->keycodesize)
 		return -EINVAL;
 
-	if (dev->keycodesize < sizeof(keycode) && (keycode >> (dev->keycodesize * 8)))
+	if (dev->keycodesize < sizeof(dev->keycode) &&
+	    (kt_entry->keycode >> (dev->keycodesize * 8)))
 		return -EINVAL;
 
 	switch (dev->keycodesize) {
 		case 1: {
 			u8 *k = (u8 *)dev->keycode;
 			old_keycode = k[scancode];
-			k[scancode] = keycode;
+			k[scancode] = kt_entry->keycode;
 			break;
 		}
 		case 2: {
 			u16 *k = (u16 *)dev->keycode;
 			old_keycode = k[scancode];
-			k[scancode] = keycode;
+			k[scancode] = kt_entry->keycode;
 			break;
 		}
 		default: {
 			u32 *k = (u32 *)dev->keycode;
 			old_keycode = k[scancode];
-			k[scancode] = keycode;
+			k[scancode] = kt_entry->keycode;
 			break;
 		}
 	}
 
 	clear_bit(old_keycode, dev->keybit);
-	set_bit(keycode, dev->keybit);
+	set_bit(kt_entry->keycode, dev->keybit);
 
 	for (i = 0; i < dev->keycodemax; i++) {
 		if (input_fetch_keycode(dev, i) == old_keycode) {
@@ -629,6 +684,109 @@ static int input_default_setkeycode(struct input_dev *dev,
 }
 
 /**
+ * input_get_keycode_big - retrieve keycode currently mapped to a given scancode
+ * @dev: input device which keymap is being queried
+ * @kt_entry: keytable entry
+ *
+ * This function should be called by anyone interested in retrieving current
+ * keymap. Presently evdev handlers use it.
+ */
+int input_get_keycode_big(struct input_dev *dev,
+			  struct keycode_table_entry *kt_entry)
+{
+	if (dev->getkeycode) {
+		u32 scancode = kt_entry->index;
+
+		/*
+		 * Support for legacy drivers, that don't implement the new
+		 * ioctls
+		 */
+		memcpy(kt_entry->scancode, &scancode, 4);
+		return dev->getkeycode(dev, scancode,
+				       &kt_entry->keycode);
+	} else
+		return dev->getkeycodebig_from_index(dev, kt_entry);
+}
+EXPORT_SYMBOL(input_get_keycode_big);
+
+/**
+ * input_set_keycode_big - attribute a keycode to a given scancode
+ * @dev: input device which keymap is being queried
+ * @kt_entry: keytable entry
+ *
+ * This function should be called by anyone needing to update current
+ * keymap. Presently keyboard and evdev handlers use it.
+ */
+int input_set_keycode_big(struct input_dev *dev,
+			  struct keycode_table_entry *kt_entry)
+{
+	unsigned long flags;
+	int old_keycode;
+	int retval = -EINVAL;
+	u32 uninitialized_var(scancode);
+
+	if (kt_entry->keycode < 0 || kt_entry->keycode > KEY_MAX)
+		return -EINVAL;
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+
+	/*
+	 * We need to know the old scancode, in order to generate a
+	 * keyup effect, if the set operation happens successfully
+	 */
+	if (dev->getkeycode) {
+		/*
+		 * Support for legacy drivers, that don't implement the new
+		 * ioctls
+		 */
+		if (!dev->setkeycode)
+			goto out;
+
+		if (input_fetch_scancode(kt_entry, &scancode))
+			return -EINVAL;
+
+		retval = dev->getkeycode(dev, scancode,
+					 &old_keycode);
+	} else {
+		int new_keycode = kt_entry->keycode;
+
+		retval = dev->getkeycodebig_from_scancode(dev, kt_entry);
+		old_keycode = kt_entry->keycode;
+		kt_entry->keycode = new_keycode;
+	}
+
+	if (retval)
+		goto out;
+
+	if (dev->getkeycode)
+		retval = dev->setkeycode(dev, scancode,
+					 kt_entry->keycode);
+	else
+		retval = dev->setkeycodebig(dev, kt_entry);
+	if (retval)
+		goto out;
+
+	/*
+	 * Simulate keyup event if keycode is not present
+	 * in the keymap anymore
+	 */
+	if (test_bit(EV_KEY, dev->evbit) &&
+	    !is_event_supported(old_keycode, dev->keybit, KEY_MAX) &&
+	    __test_and_clear_bit(old_keycode, dev->key)) {
+
+		input_pass_event(dev, EV_KEY, old_keycode, 0);
+		if (dev->sync)
+			input_pass_event(dev, EV_SYN, SYN_REPORT, 1);
+	}
+
+ out:
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+
+	return retval;
+}
+EXPORT_SYMBOL(input_set_keycode_big);
+
+/**
  * input_get_keycode - retrieve keycode currently mapped to a given scancode
  * @dev: input device which keymap is being queried
  * @scancode: scancode (or its equivalent for device in question) for which
@@ -640,10 +798,31 @@ static int input_default_setkeycode(struct input_dev *dev,
  */
 int input_get_keycode(struct input_dev *dev, int scancode, int *keycode)
 {
-	if (scancode < 0)
-		return -EINVAL;
+	if (dev->getkeycode) {
+		/*
+		 * Use the legacy calls
+		 */
+		return dev->getkeycode(dev, scancode, keycode);
+	} else {
+		int retval;
+		struct keycode_table_entry kt_entry;
 
-	return dev->getkeycode(dev, scancode, keycode);
+		/*
+		 * Userspace is using a legacy call with a driver ported
+		 * to the new way. This is a bad idea with long sparsed
+		 * tables, since lots of the retrieved values will be in
+		 * blank. Also, it makes sense only if the table size is
+		 * lower than 2^32.
+		 */
+		memset(&kt_entry, 0, sizeof(kt_entry));
+		kt_entry.len = 4;
+		kt_entry.index = scancode;
+
+		retval = dev->getkeycodebig_from_index(dev, &kt_entry);
+
+		*keycode = kt_entry.keycode;
+		return retval;
+	}
 }
 EXPORT_SYMBOL(input_get_keycode);
 
@@ -662,21 +841,46 @@ int input_set_keycode(struct input_dev *dev, int scancode, int keycode)
 	int old_keycode;
 	int retval;
 
-	if (scancode < 0)
-		return -EINVAL;
-
 	if (keycode < 0 || keycode > KEY_MAX)
 		return -EINVAL;
 
 	spin_lock_irqsave(&dev->event_lock, flags);
 
-	retval = dev->getkeycode(dev, scancode, &old_keycode);
-	if (retval)
-		goto out;
+	if (dev->getkeycode) {
+		/*
+		 * Use the legacy calls
+		 */
+		retval = dev->getkeycode(dev, scancode, &old_keycode);
+		if (retval)
+			goto out;
 
-	retval = dev->setkeycode(dev, scancode, keycode);
-	if (retval)
-		goto out;
+		retval = dev->setkeycode(dev, scancode, keycode);
+		if (retval)
+			goto out;
+	} else {
+		struct keycode_table_entry kt_entry;
+
+		/*
+		 * Userspace is using a legacy call with a driver ported
+		 * to the new way. This is a bad idea with long sparsed
+		 * tables, since lots of the retrieved values will be in
+		 * blank. Also, it makes sense only if the table size is
+		 * lower than 2^32.
+		 */
+		memset(&kt_entry, 0, sizeof(kt_entry));
+		kt_entry.len = 4;
+		kt_entry.scancode = (char *)&scancode;
+
+		retval = dev->getkeycodebig_from_scancode(dev, &kt_entry);
+		if (retval)
+			goto out;
+
+		kt_entry.keycode = keycode;
+
+		retval = dev->setkeycodebig(dev, &kt_entry);
+		if (retval)
+			goto out;
+	}
 
 	/*
 	 * Simulate keyup event if keycode is not present
@@ -1585,11 +1789,17 @@ int input_register_device(struct input_dev *dev)
 		dev->rep[REP_PERIOD] = 33;
 	}
 
-	if (!dev->getkeycode)
-		dev->getkeycode = input_default_getkeycode;
+	if (!dev->getkeycode) {
+		if (!dev->getkeycodebig_from_index)
+			dev->getkeycodebig_from_index = input_default_getkeycode_from_index;
+		if (!dev->getkeycodebig_from_scancode)
+			dev->getkeycodebig_from_scancode = input_default_getkeycode_from_scancode;
+	}
 
-	if (!dev->setkeycode)
-		dev->setkeycode = input_default_setkeycode;
+	if (dev->setkeycode) {
+		if (!dev->setkeycodebig)
+			dev->setkeycodebig = input_default_setkeycode;
+	}
 
 	dev_set_name(&dev->dev, "input%ld",
 		     (unsigned long) atomic_inc_return(&input_no) - 1);
diff --git a/include/linux/input.h b/include/linux/input.h
index 663208a..6445fc9 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -34,7 +34,7 @@ struct input_event {
  * Protocol version.
  */
 
-#define EV_VERSION		0x010000
+#define EV_VERSION		0x010001
 
 /*
  * IOCTLs (0x00 - 0x7f)
@@ -56,12 +56,22 @@ struct input_absinfo {
 	__s32 resolution;
 };
 
+struct keycode_table_entry {
+	__u32 keycode;		/* e.g. KEY_A */
+	__u32 index;            /* Index for the given scan/key table, on EVIOCGKEYCODEBIG */
+	__u32 len;		/* Length of the scancode */
+	__u32 reserved[2];	/* Reserved for future usage */
+	char *scancode;		/* scancode, in machine-endian */
+};
+
 #define EVIOCGVERSION		_IOR('E', 0x01, int)			/* get driver version */
 #define EVIOCGID		_IOR('E', 0x02, struct input_id)	/* get device ID */
 #define EVIOCGREP		_IOR('E', 0x03, int[2])			/* get repeat settings */
 #define EVIOCSREP		_IOW('E', 0x03, int[2])			/* set repeat settings */
 #define EVIOCGKEYCODE		_IOR('E', 0x04, int[2])			/* get keycode */
 #define EVIOCSKEYCODE		_IOW('E', 0x04, int[2])			/* set keycode */
+#define EVIOCGKEYCODEBIG	_IOR('E', 0x04, struct keycode_table_entry) /* get keycode */
+#define EVIOCSKEYCODEBIG	_IOW('E', 0x04, struct keycode_table_entry) /* set keycode */
 
 #define EVIOCGNAME(len)		_IOC(_IOC_READ, 'E', 0x06, len)		/* get device name */
 #define EVIOCGPHYS(len)		_IOC(_IOC_READ, 'E', 0x07, len)		/* get physical location */
@@ -1022,13 +1032,22 @@ struct ff_effect {
  * @keycodemax: size of keycode table
  * @keycodesize: size of elements in keycode table
  * @keycode: map of scancodes to keycodes for this device
- * @setkeycode: optional method to alter current keymap, used to implement
+ * @setkeycode: optional legacy method to alter current keymap, used to
+ *	implement sparse keymaps. Shouldn't be used on new drivers
+ * @getkeycode: optional legacy method to retrieve current keymap.
+ *	Shouldn't be used on new drivers.
+ * @setkeycodebig: optional method to alter current keymap, used to implement
  *	sparse keymaps. If not supplied default mechanism will be used.
  *	The method is being called while holding event_lock and thus must
  *	not sleep
- * @getkeycode: optional method to retrieve current keymap. If not supplied
- *	default mechanism will be used. The method is being called while
- *	holding event_lock and thus must not sleep
+ * @getkeycodebig_from_index: optional method to retrieve current keymap from
+ *      an array index. If not supplied default mechanism will be used.
+ *	The method is being called while holding event_lock and thus must
+ *      not sleep
+ * @getkeycodebig_from_scancode: optional method to retrieve current keymap
+ *	from an scancode. If not supplied default mechanism will be used.
+ *	The method is being called while holding event_lock and thus must
+ *      not sleep
  * @ff: force feedback structure associated with the device if device
  *	supports force feedback effects
  * @repeat_key: stores key code of the last key pressed; used to implement
@@ -1101,6 +1120,12 @@ struct input_dev {
 	void *keycode;
 	int (*setkeycode)(struct input_dev *dev, int scancode, int keycode);
 	int (*getkeycode)(struct input_dev *dev, int scancode, int *keycode);
+	int (*setkeycodebig)(struct input_dev *dev,
+			     struct keycode_table_entry *kt_entry);
+	int (*getkeycodebig_from_index)(struct input_dev *dev,
+			     struct keycode_table_entry *kt_entry);
+	int (*getkeycodebig_from_scancode)(struct input_dev *dev,
+			     struct keycode_table_entry *kt_entry);
 
 	struct ff_device *ff;
 
@@ -1366,6 +1391,11 @@ static inline void input_set_abs_params(struct input_dev *dev, int axis, int min
 
 int input_get_keycode(struct input_dev *dev, int scancode, int *keycode);
 int input_set_keycode(struct input_dev *dev, int scancode, int keycode);
+int input_get_keycode_big(struct input_dev *dev,
+			  struct keycode_table_entry *kt_entry);
+int input_set_keycode_big(struct input_dev *dev,
+			  struct keycode_table_entry *kt_entry);
+
 
 extern struct class input_class;
 
-- 
1.6.6.1

