Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37565 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0GaJTm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 05:19:42 -0400
Date: Sat, 31 Jul 2010 02:19:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Subject: Handling of large keycodes
Message-ID: <20100731091936.GA22253@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mauro,

I finally got a chance to review the patches adding handling of large
scancodes to input core and there are a few things with this approach
that I do not like.

First of all I do not think that we should be working with scancode via
a pointer as it requires additional compat handling when running 32-bit
userspace on 64-bit kernel. We can use a static buffer of sufficient
size (lets say 32 bytes) to move scancode around and simply increase its
size if we come upon device that uses even bigger scancodes. As long as
buffer is at the end we can handle this in a compatible way.

The other issue is that interface is notsymmetrical, setting is done by
scancode but retrieval is done by index. I think we should be able to
use both scancode and index in both operations.

The usefulnes of reserved data elements in the structure is doubtful,
since we do not seem to require them being set to a particular value and
so we'll be unable to distinguish betwee legacy and newer users.

I also concerned about the code very messy with regard to using old/new
style interfaces instea dof converting old ones to use new
insfrastructure,

I below is something that addresses these issues and seems to be working
for me. It is on top of your patches and it also depends on a few
changes in my tree that I have not publushed yet but plan on doing that
tomorrow. I am also attaching patches converting sparse keymap and hid
to the new style of getkeycode and setkeycode as examples.

Please take a look and let me know if I missed something important.

Thank you.

-- 
Dmitry


Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/char/keyboard.c |   31 +++-
 drivers/input/evdev.c   |  139 +++++++++++--------
 drivers/input/input.c   |  351 +++++++++++++++--------------------------------
 include/linux/input.h   |   72 +++++-----
 4 files changed, 255 insertions(+), 338 deletions(-)


diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index 54109dc..4dd9fb0 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -175,8 +175,7 @@ EXPORT_SYMBOL_GPL(unregister_keyboard_notifier);
  */
 
 struct getset_keycode_data {
-	unsigned int scancode;
-	unsigned int keycode;
+	struct keymap_entry ke;
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
+			.by_index	= false,
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
+			.by_index	= false,
+			.len		= sizeof(scancode),
+			.keycode	= keycode,
+		},
+		.error	= -ENODEV,
+	};
+
+	memcpy(d.ke.scancode, &scancode, sizeof(scancode));
 
 	input_handler_for_each_handle(&kbd_handler, &d, setkeycode_helper);
 
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 783cdd3..9c7a97b 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -534,6 +534,80 @@ static int handle_eviocgbit(struct input_dev *dev,
 }
 #undef OLD_KEY_MAX
 
+static int evdev_handle_get_keycode(struct input_dev *dev,
+				    void __user *p, size_t size)
+{
+	struct keymap_entry ke;
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
+		ke.by_index = false;
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
+	struct keymap_entry ke;
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
+		ke.by_index = false;
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
@@ -543,8 +617,6 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 	struct input_absinfo abs;
 	struct ff_effect effect;
 	int __user *ip = (int __user *)p;
-	struct keycode_table_entry kt, *kt_p = p;
-	char scancode[16];
 	unsigned int i, t, u, v;
 	unsigned int size;
 	int error;
@@ -582,62 +654,6 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 
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
-	case EVIOCGKEYCODEBIG:
-		if (copy_from_user(&kt, kt_p, sizeof(kt)))
-			return -EFAULT;
-
-		if (kt.len > sizeof(scancode))
-			return -EINVAL;
-
-		kt.scancode = scancode;
-
-		error = input_get_keycode_big(dev, &kt);
-		if (error)
-			return error;
-
-		if (copy_to_user(kt_p, &kt, sizeof(kt)))
-			return -EFAULT;
-
-		/* FIXME: probably need some compat32 code */
-		if (copy_to_user(kt_p->scancode, kt.scancode, kt.len))
-			return -EFAULT;
-
-		return 0;
-
-	case EVIOCSKEYCODEBIG:
-		if (copy_from_user(&kt, kt_p, sizeof(kt)))
-			return -EFAULT;
-
-		if (kt.len > sizeof(scancode))
-			return -EINVAL;
-
-		kt.scancode = scancode;
-
-		/* FIXME: probably need some compat32 code */
-		if (copy_from_user(kt.scancode, kt_p->scancode, kt.len))
-			return -EFAULT;
-
-		return input_set_keycode_big(dev, &kt);
-
 	case EVIOCRMFF:
 		return input_ff_erase(dev, (int)(unsigned long) p, file);
 
@@ -659,7 +675,6 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 
 	/* Now check variable-length commands */
 #define EVIOC_MASK_SIZE(nr)	((nr) & ~(_IOC_SIZEMASK << _IOC_SIZESHIFT))
-
 	switch (EVIOC_MASK_SIZE(cmd)) {
 
 	case EVIOCGKEY(0):
@@ -693,6 +708,12 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
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
index bbb95c1..4408913 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -634,131 +634,141 @@ static void input_disconnect_device(struct input_dev *dev)
 	spin_unlock_irq(&dev->event_lock);
 }
 
-/*
- * Those routines handle the default case where no [gs]etkeycode() is
- * defined. In this case, an array indexed by the scancode is used.
+/**
+ * input_scancode_to_scalar() - converts scancode in &struct keymap_entry
+ * @ke: keymap entry containing scancode to be converted.
+ * @scancode: pointer to the location where converted scancode should
+ *	be stored.
+ *
+ * This function is used to convert scancode stored in &struct keymap_entry
+ * into scalar form understood by legacy keymap handling methods. These
+ * methods expect scancodes to be represented as 'unsigned int'.
  */
-
-static int input_fetch_keycode(struct input_dev *dev, int scancode)
+int input_scancode_to_scalar(const struct keymap_entry *ke,
+			     unsigned int *scancode)
 {
-	switch (dev->keycodesize) {
-		case 1:
-			return ((u8 *)dev->keycode)[scancode];
+	switch (ke->len) {
+	case 1:
+		*scancode = *((u8 *)ke->scancode);
+		break;
 
-		case 2:
-			return ((u16 *)dev->keycode)[scancode];
+	case 2:
+		*scancode = *((u16 *)ke->scancode);
+		break;
+
+	case 4:
+		*scancode = *((u32 *)ke->scancode);
+		break;
 
-		default:
-			return ((u32 *)dev->keycode)[scancode];
+	default:
+		return -EINVAL;
 	}
+
+	return 0;
 }
+EXPORT_SYMBOL(input_scancode_to_scalar);
 
 /*
- * Supports only 8, 16 and 32 bit scancodes. It wouldn't be that
- * hard to write some machine-endian logic to support 24 bit scancodes,
- * but it seemed overkill. It should also be noticed that, since there
- * are, in general, less than 256 scancodes sparsed into the scancode
- * space, even with 16 bits, the codespace is sparsed, with leads into
- * memory and code ineficiency, when retrieving the entire scancode
- * space.
- * So, it is highly recommended to implement getkeycodebig/setkeycodebig
- * instead of using a normal table approach, when more than 8 bits is
- * needed for the scancode.
+ * Those routines handle the default case where no [gs]etkeycode() is
+ * defined. In this case, an array indexed by the scancode is used.
  */
-static int input_fetch_scancode(struct keycode_table_entry *kt_entry,
-				u32 *scancode)
+
+static unsigned int input_fetch_keycode(struct input_dev *dev,
+					unsigned int index)
 {
-	switch (kt_entry->len) {
+	switch (dev->keycodesize) {
 	case 1:
-		*scancode = *((u8 *)kt_entry->scancode);
-		break;
+		return ((u8 *)dev->keycode)[index];
+
 	case 2:
-		*scancode = *((u16 *)kt_entry->scancode);
-		break;
-	case 4:
-		*scancode = *((u32 *)kt_entry->scancode);
-		break;
+		return ((u16 *)dev->keycode)[index];
+
 	default:
-		return -EINVAL;
+		return ((u32 *)dev->keycode)[index];
 	}
-	return 0;
 }
 
-
-static int input_default_getkeycode_from_index(struct input_dev *dev,
-				    struct keycode_table_entry *kt_entry)
+static int input_default_getkeycode(struct input_dev *dev,
+				    struct keymap_entry *ke)
 {
-	u32 scancode = kt_entry->index;
+	unsigned int index;
+	int error;
 
 	if (!dev->keycodesize)
 		return -EINVAL;
 
-	if (scancode >= dev->keycodemax)
+	if (ke->by_index)
+		index = ke->index;
+	else {
+		error = input_scancode_to_scalar(ke, &index);
+		if (error)
+			return error;
+	}
+
+	if (index >= dev->keycodemax)
 		return -EINVAL;
 
-	kt_entry->keycode = input_fetch_keycode(dev, scancode);
-	memcpy(kt_entry->scancode, &scancode, 4);
+	ke->keycode = input_fetch_keycode(dev, index);
+	ke->index = index;
+	ke->len = sizeof(index);
+	memcpy(ke->scancode, &index, sizeof(index));
 
 	return 0;
 }
 
-static int input_default_getkeycode_from_scancode(struct input_dev *dev,
-				    struct keycode_table_entry *kt_entry)
-{
-	if (input_fetch_scancode(kt_entry, &kt_entry->index))
-		return -EINVAL;
-
-	return input_default_getkeycode_from_index(dev, kt_entry);
-}
-
-
 static int input_default_setkeycode(struct input_dev *dev,
-				    struct keycode_table_entry *kt_entry)
+				    const struct keymap_entry *ke,
+				    unsigned int *old_keycode)
 {
-	u32 old_keycode;
+	unsigned int index;
+	int error;
 	int i;
-	u32 scancode;
 
-	if (input_fetch_scancode(kt_entry, &scancode))
+	if (!dev->keycodesize)
 		return -EINVAL;
 
-	if (scancode >= dev->keycodemax)
-		return -EINVAL;
+	if (ke->by_index) {
+		index = ke->index;
+	} else {
+		error = input_scancode_to_scalar(ke, &index);
+		if (error)
+			return error;
+	}
 
-	if (!dev->keycodesize)
+	if (index >= dev->keycodemax)
 		return -EINVAL;
 
 	if (dev->keycodesize < sizeof(dev->keycode) &&
-	    (kt_entry->keycode >> (dev->keycodesize * 8)))
+			(ke->keycode >> (dev->keycodesize * 8)))
 		return -EINVAL;
 
 	switch (dev->keycodesize) {
 		case 1: {
 			u8 *k = (u8 *)dev->keycode;
-			old_keycode = k[scancode];
-			k[scancode] = kt_entry->keycode;
+			*old_keycode = k[index];
+			k[index] = ke->keycode;
 			break;
 		}
 		case 2: {
 			u16 *k = (u16 *)dev->keycode;
-			old_keycode = k[scancode];
-			k[scancode] = kt_entry->keycode;
+			*old_keycode = k[index];
+			k[index] = ke->keycode;
 			break;
 		}
 		default: {
 			u32 *k = (u32 *)dev->keycode;
-			old_keycode = k[scancode];
-			k[scancode] = kt_entry->keycode;
+			*old_keycode = k[index];
+			k[index] = ke->keycode;
 			break;
 		}
 	}
 
-	__clear_bit(old_keycode, dev->keybit);
-	__set_bit(kt_entry->keycode, dev->keybit);
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
@@ -767,215 +777,90 @@ static int input_default_setkeycode(struct input_dev *dev,
 }
 
 /**
- * input_get_keycode_big - retrieve keycode currently mapped to a given scancode
+ * input_get_keycode - retrieve keycode currently mapped to a given scancode
  * @dev: input device which keymap is being queried
- * @kt_entry: keytable entry
+ * @ke: keymap entry
  *
  * This function should be called by anyone interested in retrieving current
  * keymap. Presently evdev handlers use it.
  */
-int input_get_keycode_big(struct input_dev *dev,
-			  struct keycode_table_entry *kt_entry)
-{
-	if (dev->getkeycode) {
-		u32 scancode = kt_entry->index;
-
-		/*
-		 * Support for legacy drivers, that don't implement the new
-		 * ioctls
-		 */
-		memcpy(kt_entry->scancode, &scancode, 4);
-		return dev->getkeycode(dev, scancode,
-				       &kt_entry->keycode);
-	} else
-		return dev->getkeycodebig_from_index(dev, kt_entry);
-}
-EXPORT_SYMBOL(input_get_keycode_big);
-
-/**
- * input_set_keycode_big - attribute a keycode to a given scancode
- * @dev: input device which keymap is being queried
- * @kt_entry: keytable entry
- *
- * This function should be called by anyone needing to update current
- * keymap. Presently keyboard and evdev handlers use it.
- */
-int input_set_keycode_big(struct input_dev *dev,
-			  struct keycode_table_entry *kt_entry)
+int input_get_keycode(struct input_dev *dev, struct keymap_entry *ke)
 {
 	unsigned long flags;
-	int old_keycode;
-	int retval = -EINVAL;
-	u32 uninitialized_var(scancode);
-
-	if (kt_entry->keycode < 0 || kt_entry->keycode > KEY_MAX)
-		return -EINVAL;
+	int retval;
 
 	spin_lock_irqsave(&dev->event_lock, flags);
 
-	/*
-	 * We need to know the old scancode, in order to generate a
-	 * keyup effect, if the set operation happens successfully
-	 */
 	if (dev->getkeycode) {
 		/*
 		 * Support for legacy drivers, that don't implement the new
 		 * ioctls
 		 */
-		if (!dev->setkeycode)
-			goto out;
-
-		retval = input_fetch_scancode(kt_entry, &scancode);
-		if (retval)
-			goto out;
+		u32 scancode = ke->index;
 
-		retval = dev->getkeycode(dev, scancode,
-					 &old_keycode);
+		memcpy(ke->scancode, &scancode, sizeof(scancode));
+		ke->len = sizeof(scancode);
+		retval = dev->getkeycode(dev, scancode, &ke->keycode);
 	} else {
-		int new_keycode = kt_entry->keycode;
-
-		retval = dev->getkeycodebig_from_scancode(dev, kt_entry);
-		old_keycode = kt_entry->keycode;
-		kt_entry->keycode = new_keycode;
+		retval = dev->getkeycode_new(dev, ke);
 	}
 
-	if (retval)
-		goto out;
-
-	if (dev->getkeycode)
-		retval = dev->setkeycode(dev, scancode,
-					 kt_entry->keycode);
-	else
-		retval = dev->setkeycodebig(dev, kt_entry);
-	if (retval)
-		goto out;
-
-	/*
-	 * Simulate keyup event if keycode is not present
-	 * in the keymap anymore
-	 */
-	if (test_bit(EV_KEY, dev->evbit) &&
-	    !is_event_supported(old_keycode, dev->keybit, KEY_MAX) &&
-	    __test_and_clear_bit(old_keycode, dev->key)) {
-
-		input_pass_event(dev, EV_KEY, old_keycode, 0);
-		if (dev->sync)
-			input_pass_event(dev, EV_SYN, SYN_REPORT, 1);
-	}
-
- out:
 	spin_unlock_irqrestore(&dev->event_lock, flags);
-
 	return retval;
 }
-EXPORT_SYMBOL(input_set_keycode_big);
-
-/**
- * input_get_keycode - retrieve keycode currently mapped to a given scancode
- * @dev: input device which keymap is being queried
- * @scancode: scancode (or its equivalent for device in question) for which
- *	keycode is needed
- * @keycode: result
- *
- * This function should be called by anyone interested in retrieving current
- * keymap. Presently keyboard and evdev handlers use it.
- */
-int input_get_keycode(struct input_dev *dev,
-		      unsigned int scancode, unsigned int *keycode)
-{
-	unsigned long flags;
-
-	if (dev->getkeycode) {
-		/*
-		 * Use the legacy calls
-		 */
-		return dev->getkeycode(dev, scancode, keycode);
-	} else {
-		int retval;
-		struct keycode_table_entry kt_entry;
-
-		/*
-		 * Userspace is using a legacy call with a driver ported
-		 * to the new way. This is a bad idea with long sparsed
-		 * tables, since lots of the retrieved values will be in
-		 * blank. Also, it makes sense only if the table size is
-		 * lower than 2^32.
-		 */
-		memset(&kt_entry, 0, sizeof(kt_entry));
-		kt_entry.len = 4;
-		kt_entry.index = scancode;
-		kt_entry.scancode = (char *)&scancode;
-
-		spin_lock_irqsave(&dev->event_lock, flags);
-		retval = dev->getkeycodebig_from_index(dev, &kt_entry);
-		spin_unlock_irqrestore(&dev->event_lock, flags);
-
-		*keycode = kt_entry.keycode;
-		return retval;
-	}
-}
 EXPORT_SYMBOL(input_get_keycode);
 
 /**
- * input_get_keycode - assign new keycode to a given scancode
- * @dev: input device which keymap is being updated
- * @scancode: scancode (or its equivalent for device in question)
- * @keycode: new keycode to be assigned to the scancode
+ * input_set_keycode - attribute a keycode to a given scancode
+ * @dev: input device which keymap is being queried
+ * @ke: keymap entry
+ * @old_keycode: keycode previously assigned to the scancode
  *
  * This function should be called by anyone needing to update current
  * keymap. Presently keyboard and evdev handlers use it.
  */
-int input_set_keycode(struct input_dev *dev,
-		      unsigned int scancode, unsigned int keycode)
+int input_set_keycode(struct input_dev *dev, const struct keymap_entry *ke)
 {
 	unsigned long flags;
 	unsigned int old_keycode;
 	int retval;
 
-	if (keycode > KEY_MAX)
+	if (ke->keycode > KEY_MAX)
 		return -EINVAL;
 
 	spin_lock_irqsave(&dev->event_lock, flags);
 
-	if (dev->getkeycode) {
+	if (dev->setkeycode) {
 		/*
-		 * Use the legacy calls
+		 * Support for legacy drivers, that don't implement the new
+		 * ioctls
 		 */
-		retval = dev->getkeycode(dev, scancode, &old_keycode);
-		if (retval)
-			goto out;
+		unsigned int scancode;
 
-		retval = dev->setkeycode(dev, scancode, keycode);
+		retval = input_scancode_to_scalar(ke, &scancode);
 		if (retval)
 			goto out;
-	} else {
-		struct keycode_table_entry kt_entry;
 
 		/*
-		 * Userspace is using a legacy call with a driver ported
-		 * to the new way. This is a bad idea with long sparsed
-		 * tables, since lots of the retrieved values will be in
-		 * blank. Also, it makes sense only if the table size is
-		 * lower than 2^32.
+		 * We need to know the old scancode, in order to generate a
+		 * keyup effect, if the set operation happens successfully
 		 */
-		memset(&kt_entry, 0, sizeof(kt_entry));
-		kt_entry.len = 4;
-		kt_entry.scancode = (char *)&scancode;
-
-		retval = dev->getkeycodebig_from_scancode(dev, &kt_entry);
-		if (retval)
+		if (!dev->getkeycode) {
+			retval = -EINVAL;
 			goto out;
+		}
 
-		old_keycode = kt_entry.keycode;
-		kt_entry.keycode = keycode;
-
-		retval = dev->setkeycodebig(dev, &kt_entry);
+		retval = dev->getkeycode(dev, scancode, &old_keycode);
 		if (retval)
 			goto out;
+
+		retval = dev->setkeycode(dev, scancode, ke->keycode);
+	} else {
+		retval = dev->setkeycode_new(dev, ke, &old_keycode);
 	}
 
-	/* Make sure KEY_RESERVED did not get enabled. */
-	__clear_bit(KEY_RESERVED, dev->keybit);
+	if (retval)
+		goto out;
 
 	/*
 	 * Simulate keyup event if keycode is not present
@@ -1960,17 +1845,11 @@ int input_register_device(struct input_dev *dev)
 		dev->rep[REP_PERIOD] = 33;
 	}
 
-	if (!dev->getkeycode) {
-		if (!dev->getkeycodebig_from_index)
-			dev->getkeycodebig_from_index = input_default_getkeycode_from_index;
-		if (!dev->getkeycodebig_from_scancode)
-			dev->getkeycodebig_from_scancode = input_default_getkeycode_from_scancode;
-	}
+	if (!dev->getkeycode && !dev->getkeycode_new)
+		dev->getkeycode_new = input_default_getkeycode;
 
-	if (!dev->setkeycode) {
-		if (!dev->setkeycodebig)
-			dev->setkeycodebig = input_default_setkeycode;
-	}
+	if (!dev->setkeycode && !dev->setkeycode_new)
+		dev->setkeycode_new = input_default_setkeycode;
 
 	dev_set_name(&dev->dev, "input%ld",
 		     (unsigned long) atomic_inc_return(&input_no) - 1);
diff --git a/include/linux/input.h b/include/linux/input.h
index 8d6de8c..e090169 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -56,22 +56,35 @@ struct input_absinfo {
 	__s32 resolution;
 };
 
-struct keycode_table_entry {
-	__u32 keycode;		/* e.g. KEY_A */
-	__u32 index;            /* Index for the given scan/key table, on EVIOCGKEYCODEBIG */
-	__u32 len;		/* Length of the scancode */
-	__u32 reserved[2];	/* Reserved for future usage */
-	char *scancode;		/* scancode, in machine-endian */
+/**
+ * struct keymap_entry - used by EVIOCGKEYCODE/EVIOCSKEYCODE ioctls
+ * @scancode: scancode represented in machine-endian form.
+ * @len: length of the scancode that resides in @scancode buffer.
+ * @index: index in the keymap, may be used instead of scancode
+ * @by_index: boolean value indicating that kernel should perform
+ *	lookup in keymap by @index instead of @scancode
+ * @keycode: key code assigned to this scancode
+ *
+ * The structure is used to retrieve and modify keymap data. Users have
+ * of performing lookup either by @scancode itself or by @index in
+ * keymap entry. EVIOCGKEYCODE will also return scancode or index
+ * (depending on which element was used to perform lookup).
+ */
+struct keymap_entry {
+	__u8  len;
+	__u8  by_index;
+	__u16 index;
+	__u32 keycode;
+	__u8  scancode[32];
 };
 
 #define EVIOCGVERSION		_IOR('E', 0x01, int)			/* get driver version */
 #define EVIOCGID		_IOR('E', 0x02, struct input_id)	/* get device ID */
 #define EVIOCGREP		_IOR('E', 0x03, unsigned int[2])	/* get repeat settings */
 #define EVIOCSREP		_IOW('E', 0x03, unsigned int[2])	/* set repeat settings */
-#define EVIOCGKEYCODE		_IOR('E', 0x04, unsigned int[2])	/* get keycode */
-#define EVIOCSKEYCODE		_IOW('E', 0x04, unsigned int[2])	/* set keycode */
-#define EVIOCGKEYCODEBIG	_IOR('E', 0x04, struct keycode_table_entry) /* get keycode */
-#define EVIOCSKEYCODEBIG	_IOW('E', 0x04, struct keycode_table_entry) /* set keycode */
+
+#define EVIOCGKEYCODE		_IOR('E', 0x04, struct keymap_entry)	/* get keycode */
+#define EVIOCSKEYCODE		_IOW('E', 0x04, struct keymap_entry)	/* set keycode */
 
 #define EVIOCGNAME(len)		_IOC(_IOC_READ, 'E', 0x06, len)		/* get device name */
 #define EVIOCGPHYS(len)		_IOC(_IOC_READ, 'E', 0x07, len)		/* get physical location */
@@ -1098,22 +1111,13 @@ struct input_mt_slot {
  * @keycodemax: size of keycode table
  * @keycodesize: size of elements in keycode table
  * @keycode: map of scancodes to keycodes for this device
- * @setkeycode: optional legacy method to alter current keymap, used to
- *	implement sparse keymaps. Shouldn't be used in new drivers
  * @getkeycode: optional legacy method to retrieve current keymap.
- *	Shouldn't be used on new drivers.
- * @setkeycodebig: optional method to alter current keymap, used to implement
+ * @setkeycode: optional method to alter current keymap, used to implement
  *	sparse keymaps. If not supplied default mechanism will be used.
  *	The method is being called while holding event_lock and thus must
  *	not sleep
- * @getkeycodebig_from_index: optional method to retrieve current keymap from
- *	an array index. If not supplied default mechanism will be used.
- *	The method is being called while holding event_lock and thus must
- *	not sleep
- * @getkeycodebig_from_scancode: optional method to retrieve current keymap
- *	from an scancode. If not supplied default mechanism will be used.
- *	The method is being called while holding event_lock and thus must
- *	not sleep
+ * @getkeycode_new: transition method
+ * @setkeycode_new: transition method
  * @ff: force feedback structure associated with the device if device
  *	supports force feedback effects
  * @repeat_key: stores key code of the last key pressed; used to implement
@@ -1187,16 +1191,15 @@ struct input_dev {
 	unsigned int keycodemax;
 	unsigned int keycodesize;
 	void *keycode;
+
 	int (*setkeycode)(struct input_dev *dev,
 			  unsigned int scancode, unsigned int keycode);
 	int (*getkeycode)(struct input_dev *dev,
 			  unsigned int scancode, unsigned int *keycode);
-	int (*setkeycodebig)(struct input_dev *dev,
-			     struct keycode_table_entry *kt_entry);
-	int (*getkeycodebig_from_index)(struct input_dev *dev,
-			     struct keycode_table_entry *kt_entry);
-	int (*getkeycodebig_from_scancode)(struct input_dev *dev,
-			     struct keycode_table_entry *kt_entry);
+	int (*setkeycode_new)(struct input_dev *dev,
+			      const struct keymap_entry *ke,
+			      unsigned int *old_keycode);
+	int (*getkeycode_new)(struct input_dev *dev, struct keymap_entry *ke);
 
 	struct ff_device *ff;
 
@@ -1503,14 +1506,11 @@ INPUT_GENERATE_ABS_ACCESSORS(fuzz, fuzz)
 INPUT_GENERATE_ABS_ACCESSORS(flat, flat)
 INPUT_GENERATE_ABS_ACCESSORS(res, resolution)
 
-int input_get_keycode(struct input_dev *dev,
-		      unsigned int scancode, unsigned int *keycode);
-int input_set_keycode(struct input_dev *dev,
-		      unsigned int scancode, unsigned int keycode);
-int input_get_keycode_big(struct input_dev *dev,
-			  struct keycode_table_entry *kt_entry);
-int input_set_keycode_big(struct input_dev *dev,
-			  struct keycode_table_entry *kt_entry);
+int input_scancode_to_scalar(const struct keymap_entry *ke,
+			     unsigned int *scancode);
+
+int input_get_keycode(struct input_dev *dev, struct keymap_entry *ke);
+int input_set_keycode(struct input_dev *dev, const struct keymap_entry *ke);
 
 extern struct class input_class;
 

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sparse-keymap-to-big-keycodes.patch"

Input: sparse-keymap - switch to using new keycode interface

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Switch sparse keymap library to use new style of getkeycode and
setkeycode methods to allow retrieving and setting keycodes not
only by their scancodes but also by index.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/sparse-keymap.c |   81 +++++++++++++++++++++++++++++++++--------
 1 files changed, 65 insertions(+), 16 deletions(-)


diff --git a/drivers/input/sparse-keymap.c b/drivers/input/sparse-keymap.c
index 0142483..2c12bff 100644
--- a/drivers/input/sparse-keymap.c
+++ b/drivers/input/sparse-keymap.c
@@ -22,6 +22,37 @@ MODULE_DESCRIPTION("Generic support for sparse keymaps");
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION("0.1");
 
+static unsigned int sparse_keymap_get_key_index(struct input_dev *dev,
+						const struct key_entry *k)
+{
+	struct key_entry *key;
+	unsigned int idx = 0;
+
+	for (key = dev->keycode; key->type != KE_END; key++) {
+		if (key->type == KE_KEY) {
+			if (key == k)
+				break;
+			idx++;
+		}
+	}
+
+	return idx;
+}
+
+static struct key_entry *sparse_keymap_entry_by_index(struct input_dev *dev,
+						      unsigned int index)
+{
+	struct key_entry *key;
+	unsigned int key_cnt = 0;
+
+	for (key = dev->keycode; key->type != KE_END; key++)
+		if (key->type == KE_KEY)
+			if (key_cnt++ == index)
+				return key;
+
+	return NULL;
+}
+
 /**
  * sparse_keymap_entry_from_scancode - perform sparse keymap lookup
  * @dev: Input device using sparse keymap
@@ -64,16 +95,36 @@ struct key_entry *sparse_keymap_entry_from_keycode(struct input_dev *dev,
 }
 EXPORT_SYMBOL(sparse_keymap_entry_from_keycode);
 
+static struct key_entry *sparse_keymap_locate(struct input_dev *dev,
+					      const struct keymap_entry *ke)
+{
+	struct key_entry *key;
+	unsigned int scancode;
+
+	if (ke->by_index)
+		key = sparse_keymap_entry_by_index(dev, ke->index);
+	else if (input_scancode_to_scalar(ke, &scancode) == 0)
+		key = sparse_keymap_entry_from_scancode(dev, scancode);
+	else
+		key = NULL;
+
+	return key;
+}
+
 static int sparse_keymap_getkeycode(struct input_dev *dev,
-				    unsigned int scancode,
-				    unsigned int *keycode)
+				    struct keymap_entry *ke)
 {
 	const struct key_entry *key;
 
 	if (dev->keycode) {
-		key = sparse_keymap_entry_from_scancode(dev, scancode);
+		key = sparse_keymap_locate(dev, ke);
 		if (key && key->type == KE_KEY) {
-			*keycode = key->keycode;
+			ke->keycode = key->keycode;
+			if (!ke->by_index)
+				ke->index =
+					sparse_keymap_get_key_index(dev, key);
+			ke->len = sizeof(key->code);
+			memcpy(ke->scancode, &key->code, sizeof(key->code));
 			return 0;
 		}
 	}
@@ -82,20 +133,19 @@ static int sparse_keymap_getkeycode(struct input_dev *dev,
 }
 
 static int sparse_keymap_setkeycode(struct input_dev *dev,
-				    unsigned int scancode,
-				    unsigned int keycode)
+				    const struct keymap_entry *ke,
+				    unsigned int *old_keycode)
 {
 	struct key_entry *key;
-	int old_keycode;
 
 	if (dev->keycode) {
-		key = sparse_keymap_entry_from_scancode(dev, scancode);
+		key = sparse_keymap_locate(dev, ke);
 		if (key && key->type == KE_KEY) {
-			old_keycode = key->keycode;
-			key->keycode = keycode;
-			set_bit(keycode, dev->keybit);
-			if (!sparse_keymap_entry_from_keycode(dev, old_keycode))
-				clear_bit(old_keycode, dev->keybit);
+			*old_keycode = key->keycode;
+			key->keycode = ke->keycode;
+			set_bit(ke->keycode, dev->keybit);
+			if (!sparse_keymap_entry_from_keycode(dev, *old_keycode))
+				clear_bit(*old_keycode, dev->keybit);
 			return 0;
 		}
 	}
@@ -159,15 +209,14 @@ int sparse_keymap_setup(struct input_dev *dev,
 
 	dev->keycode = map;
 	dev->keycodemax = map_size;
-	dev->getkeycode = sparse_keymap_getkeycode;
-	dev->setkeycode = sparse_keymap_setkeycode;
+	dev->getkeycode_new = sparse_keymap_getkeycode;
+	dev->setkeycode_new = sparse_keymap_setkeycode;
 
 	return 0;
 
  err_out:
 	kfree(map);
 	return error;
-
 }
 EXPORT_SYMBOL(sparse_keymap_setup);
 

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="hid-use-new-keycode.patch"

Input: hid-input - switch to using new keycode interface

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Switch HID code to use new style of getkeycode and setkeycode
methods to allow retrieving and setting keycodes not only by
their scancodes but also by index.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/hid/hid-input.c |  104 ++++++++++++++++++++++++++++++++---------------
 1 files changed, 70 insertions(+), 34 deletions(-)


diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 69d152e..8cb3f27 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -68,39 +68,49 @@ static const struct {
 #define map_key_clear(c)	hid_map_usage_clear(hidinput, usage, &bit, \
 		&max, EV_KEY, (c))
 
-static inline int match_scancode(unsigned int code, unsigned int scancode)
+static bool match_scancode(struct hid_usage *usage,
+			   unsigned int cur_idx, unsigned int scancode)
 {
-	if (scancode == 0)
-		return 1;
-
-	return (code & (HID_USAGE_PAGE | HID_USAGE)) == scancode;
+	return (usage->hid & (HID_USAGE_PAGE | HID_USAGE)) == scancode;
 }
 
-static inline int match_keycode(unsigned int code, unsigned int keycode)
+static bool match_keycode(struct hid_usage *usage,
+			  unsigned int cur_idx, unsigned int keycode)
 {
-	if (keycode == 0)
-		return 1;
+	return usage->code == keycode;
+}
 
-	return code == keycode;
+static bool match_index(struct hid_usage *usage,
+			unsigned int cur_idx, unsigned int idx)
+{
+	return cur_idx == idx;
 }
 
+typedef bool (*hid_usage_cmp_t)(struct hid_usage *usage,
+				unsigned int cur_idx, unsigned int val);
+
 static struct hid_usage *hidinput_find_key(struct hid_device *hid,
-					   unsigned int scancode,
-					   unsigned int keycode)
+					   hid_usage_cmp_t match,
+					   unsigned int value,
+					   unsigned int *usage_idx)
 {
-	int i, j, k;
+	unsigned int i, j, k, cur_idx = 0;
 	struct hid_report *report;
 	struct hid_usage *usage;
 
 	for (k = HID_INPUT_REPORT; k <= HID_OUTPUT_REPORT; k++) {
 		list_for_each_entry(report, &hid->report_enum[k].report_list, list) {
 			for (i = 0; i < report->maxfield; i++) {
-				for ( j = 0; j < report->field[i]->maxusage; j++) {
+				for (j = 0; j < report->field[i]->maxusage; j++) {
 					usage = report->field[i]->usage + j;
-					if (usage->type == EV_KEY &&
-						match_scancode(usage->hid, scancode) &&
-						match_keycode(usage->code, keycode))
-						return usage;
+					if (usage->type == EV_KEY) {
+						if (match(usage, cur_idx, value)) {
+							if (usage_idx)
+								*usage_idx = cur_idx;
+							return usage;
+						}
+						cur_idx++;
+					}
 				}
 			}
 		}
@@ -108,39 +118,65 @@ static struct hid_usage *hidinput_find_key(struct hid_device *hid,
 	return NULL;
 }
 
-static int hidinput_getkeycode(struct input_dev *dev,
-			       unsigned int scancode, unsigned int *keycode)
+static struct hid_usage *hidinput_locate_usage(struct hid_device *hid,
+					       const struct keymap_entry *ke,
+					       unsigned int *index)
+{
+	struct hid_usage *usage;
+	unsigned int scancode;
+
+	if (ke->by_index)
+		usage = hidinput_find_key(hid, match_index, ke->index, index);
+	else if (input_scancode_to_scalar(ke, &scancode) == 0)
+		usage = hidinput_find_key(hid, match_scancode, scancode, index);
+	else
+		usage = NULL;
+
+	return usage;
+}
+
+static int hidinput_getkeycode(struct input_dev *dev, struct keymap_entry *ke)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct hid_usage *usage;
+	unsigned int scancode, index;
 
-	usage = hidinput_find_key(hid, scancode, 0);
+	usage = hidinput_locate_usage(hid, ke, &index);
 	if (usage) {
-		*keycode = usage->code;
+		ke->keycode = usage->code;
+		ke->index = index;
+		scancode = usage->hid & (HID_USAGE_PAGE | HID_USAGE);
+		ke->len = sizeof(scancode);
+		memcpy(ke->scancode, &scancode, sizeof(scancode));
 		return 0;
 	}
+
 	return -EINVAL;
 }
 
 static int hidinput_setkeycode(struct input_dev *dev,
-			       unsigned int scancode, unsigned int keycode)
+			       const struct keymap_entry *ke,
+			       unsigned int *old_keycode)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct hid_usage *usage;
-	int old_keycode;
 
-	usage = hidinput_find_key(hid, scancode, 0);
+	usage = hidinput_locate_usage(hid, ke, NULL);
 	if (usage) {
-		old_keycode = usage->code;
-		usage->code = keycode;
+		*old_keycode = usage->code;
+		usage->code = ke->keycode;
 
-		clear_bit(old_keycode, dev->keybit);
+		clear_bit(*old_keycode, dev->keybit);
 		set_bit(usage->code, dev->keybit);
-		dbg_hid(KERN_DEBUG "Assigned keycode %d to HID usage code %x\n", keycode, scancode);
-		/* Set the keybit for the old keycode if the old keycode is used
-		 * by another key */
-		if (hidinput_find_key (hid, 0, old_keycode))
-			set_bit(old_keycode, dev->keybit);
+		dbg_hid(KERN_DEBUG "Assigned keycode %d to HID usage code %x\n",
+			usage->code, usage->hid);
+
+		/*
+		 * Set the keybit for the old keycode if the old keycode is used
+		 * by another key
+		 */
+		if (hidinput_find_key(hid, match_keycode, *old_keycode, NULL))
+			set_bit(*old_keycode, dev->keybit);
 
 		return 0;
 	}
@@ -745,8 +781,8 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 					hid->ll_driver->hidinput_input_event;
 				input_dev->open = hidinput_open;
 				input_dev->close = hidinput_close;
-				input_dev->setkeycode = hidinput_setkeycode;
-				input_dev->getkeycode = hidinput_getkeycode;
+				input_dev->setkeycode_new = hidinput_setkeycode;
+				input_dev->getkeycode_new = hidinput_getkeycode;
 
 				input_dev->name = hid->name;
 				input_dev->phys = hid->phys;

--wRRV7LY7NUeQGEoC--
