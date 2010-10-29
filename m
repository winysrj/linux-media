Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:52667 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761559Ab0J2TIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 15:08:01 -0400
Subject: [PATCH 1/7] ir-core: dummy patch to base my work on top of Dmitry's
	large scancode work
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@infradead.org
Date: Fri, 29 Oct 2010 21:07:57 +0200
Message-ID: <20101029190757.11982.38471.stgit@localhost.localdomain>
In-Reply-To: <20101029190745.11982.75723.stgit@localhost.localdomain>
References: <20101029190745.11982.75723.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds the changes from Dmitry's large scancode work for the
input subsystem (the patches to the input core and to rc-core which were
accepted upstream). Not to be applied :)

Not-signed-off-by: Anyone
---
 drivers/char/keyboard.c        |   31 ++-
 drivers/input/evdev.c          |  100 ++++++++--
 drivers/input/input.c          |  192 +++++++++++++++-----
 drivers/media/IR/ir-keytable.c |  393 +++++++++++++++++++++++++++-------------
 include/linux/input.h          |   55 ++++--
 include/media/rc-map.h         |    2 
 6 files changed, 555 insertions(+), 218 deletions(-)

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
index 9ddafc3..b9723c7 100644
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
index ab69820..bb24d89 100644
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
diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 5f24cd6..9186b45 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -25,14 +25,56 @@
 #define IR_KEYPRESS_TIMEOUT 250
 
 /**
+ * ir_create_table() - initializes a scancode table
+ * @rc_tab:	the ir_scancode_table to initialize
+ * @name:	name to assign to the table
+ * @ir_type:	ir type to assign to the new table
+ * @size:	initial size of the table
+ * @return:	zero on success or a negative error code
+ *
+ * This routine will initialize the ir_scancode_table and will allocate
+ * memory to hold at least the specified number elements.
+ */
+static int ir_create_table(struct ir_scancode_table *rc_tab,
+			   const char *name, u64 ir_type, size_t size)
+{
+	rc_tab->name = name;
+	rc_tab->ir_type = ir_type;
+	rc_tab->alloc = roundup_pow_of_two(size * sizeof(struct ir_scancode));
+	rc_tab->size = rc_tab->alloc / sizeof(struct ir_scancode);
+	rc_tab->scan = kmalloc(rc_tab->alloc, GFP_KERNEL);
+	if (!rc_tab->scan)
+		return -ENOMEM;
+
+	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
+		   rc_tab->size, rc_tab->alloc);
+	return 0;
+}
+
+/**
+ * ir_free_table() - frees memory allocated by a scancode table
+ * @rc_tab:	the table whose mappings need to be freed
+ *
+ * This routine will free memory alloctaed for key mappings used by given
+ * scancode table.
+ */
+static void ir_free_table(struct ir_scancode_table *rc_tab)
+{
+	rc_tab->size = 0;
+	kfree(rc_tab->scan);
+	rc_tab->scan = NULL;
+}
+
+/**
  * ir_resize_table() - resizes a scancode table if necessary
  * @rc_tab:	the ir_scancode_table to resize
+ * @gfp_flags:	gfp flags to use when allocating memory
  * @return:	zero on success or a negative error code
  *
  * This routine will shrink the ir_scancode_table if it has lots of
  * unused entries and grow it if it is full.
  */
-static int ir_resize_table(struct ir_scancode_table *rc_tab)
+static int ir_resize_table(struct ir_scancode_table *rc_tab, gfp_t gfp_flags)
 {
 	unsigned int oldalloc = rc_tab->alloc;
 	unsigned int newalloc = oldalloc;
@@ -57,7 +99,7 @@ static int ir_resize_table(struct ir_scancode_table *rc_tab)
 	if (newalloc == oldalloc)
 		return 0;
 
-	newscan = kmalloc(newalloc, GFP_ATOMIC);
+	newscan = kmalloc(newalloc, gfp_flags);
 	if (!newscan) {
 		IR_dprintk(1, "Failed to kmalloc %u bytes\n", newalloc);
 		return -ENOMEM;
@@ -72,26 +114,78 @@ static int ir_resize_table(struct ir_scancode_table *rc_tab)
 }
 
 /**
- * ir_do_setkeycode() - internal function to set a keycode in the
- *			scancode->keycode table
+ * ir_update_mapping() - set a keycode in the scancode->keycode table
  * @dev:	the struct input_dev device descriptor
- * @rc_tab:	the struct ir_scancode_table to set the keycode in
- * @scancode:	the scancode for the ir command
- * @keycode:	the keycode for the ir command
- * @resize:	whether the keytable may be shrunk
- * @return:	-EINVAL if the keycode could not be inserted, otherwise zero.
+ * @rc_tab:	scancode table to be adjusted
+ * @index:	index of the mapping that needs to be updated
+ * @keycode:	the desired keycode
+ * @return:	previous keycode assigned to the mapping
+ *
+ * This routine is used to update scancode->keycopde mapping at given
+ * position.
+ */
+static unsigned int ir_update_mapping(struct input_dev *dev,
+				      struct ir_scancode_table *rc_tab,
+				      unsigned int index,
+				      unsigned int new_keycode)
+{
+	int old_keycode = rc_tab->scan[index].keycode;
+	int i;
+
+	/* Did the user wish to remove the mapping? */
+	if (new_keycode == KEY_RESERVED || new_keycode == KEY_UNKNOWN) {
+		IR_dprintk(1, "#%d: Deleting scan 0x%04x\n",
+			   index, rc_tab->scan[index].scancode);
+		rc_tab->len--;
+		memmove(&rc_tab->scan[index], &rc_tab->scan[index+ 1],
+			(rc_tab->len - index) * sizeof(struct ir_scancode));
+	} else {
+		IR_dprintk(1, "#%d: %s scan 0x%04x with key 0x%04x\n",
+			   index,
+			   old_keycode == KEY_RESERVED ? "New" : "Replacing",
+			   rc_tab->scan[index].scancode, new_keycode);
+		rc_tab->scan[index].keycode = new_keycode;
+		__set_bit(new_keycode, dev->keybit);
+	}
+
+	if (old_keycode != KEY_RESERVED) {
+		/* A previous mapping was updated... */
+		__clear_bit(old_keycode, dev->keybit);
+		/* ... but another scancode might use the same keycode */
+		for (i = 0; i < rc_tab->len; i++) {
+			if (rc_tab->scan[i].keycode == old_keycode) {
+				__set_bit(old_keycode, dev->keybit);
+				break;
+			}
+		}
+
+		/* Possibly shrink the keytable, failure is not a problem */
+		ir_resize_table(rc_tab, GFP_ATOMIC);
+	}
+
+	return old_keycode;
+}
+
+/**
+ * ir_locate_scancode() - set a keycode in the scancode->keycode table
+ * @ir_dev:	the struct ir_input_dev device descriptor
+ * @rc_tab:	scancode table to be searched
+ * @scancode:	the desired scancode
+ * @resize:	controls whether we allowed to resize the table to
+ *		accomodate not yet present scancodes
+ * @return:	index of the mapping containing scancode in question
+ *		or -1U in case of failure.
  *
- * This routine is used internally to manipulate the scancode->keycode table.
- * The caller has to hold @rc_tab->lock.
+ * This routine is used to locate given scancode in ir_scancode_table.
+ * If scancode is not yet present the routine will allocate a new slot
+ * for it.
  */
-static int ir_do_setkeycode(struct input_dev *dev,
-			    struct ir_scancode_table *rc_tab,
-			    unsigned scancode, unsigned keycode,
-			    bool resize)
+static unsigned int ir_establish_scancode(struct ir_input_dev *ir_dev,
+					  struct ir_scancode_table *rc_tab,
+					  unsigned int scancode,
+					  bool resize)
 {
 	unsigned int i;
-	int old_keycode = KEY_RESERVED;
-	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
 
 	/*
 	 * Unfortunately, some hardware-based IR decoders don't provide
@@ -100,65 +194,34 @@ static int ir_do_setkeycode(struct input_dev *dev,
 	 * the provided IR with another one, it is needed to allow loading
 	 * IR tables from other remotes. So,
 	 */
-	if (ir_dev->props && ir_dev->props->scanmask) {
+	if (ir_dev->props && ir_dev->props->scanmask)
 		scancode &= ir_dev->props->scanmask;
-	}
 
 	/* First check if we already have a mapping for this ir command */
 	for (i = 0; i < rc_tab->len; i++) {
+		if (rc_tab->scan[i].scancode == scancode)
+			return i;
+
 		/* Keytable is sorted from lowest to highest scancode */
-		if (rc_tab->scan[i].scancode > scancode)
+		if (rc_tab->scan[i].scancode >= scancode)
 			break;
-		else if (rc_tab->scan[i].scancode < scancode)
-			continue;
-
-		old_keycode = rc_tab->scan[i].keycode;
-		rc_tab->scan[i].keycode = keycode;
-
-		/* Did the user wish to remove the mapping? */
-		if (keycode == KEY_RESERVED || keycode == KEY_UNKNOWN) {
-			IR_dprintk(1, "#%d: Deleting scan 0x%04x\n",
-				   i, scancode);
-			rc_tab->len--;
-			memmove(&rc_tab->scan[i], &rc_tab->scan[i + 1],
-				(rc_tab->len - i) * sizeof(struct ir_scancode));
-		}
-
-		/* Possibly shrink the keytable, failure is not a problem */
-		ir_resize_table(rc_tab);
-		break;
 	}
 
-	if (old_keycode == KEY_RESERVED && keycode != KEY_RESERVED) {
-		/* No previous mapping found, we might need to grow the table */
-		if (resize && ir_resize_table(rc_tab))
-			return -ENOMEM;
-
-		IR_dprintk(1, "#%d: New scan 0x%04x with key 0x%04x\n",
-			   i, scancode, keycode);
+	/* No previous mapping found, we might need to grow the table */
+	if (rc_tab->size == rc_tab->len) {
+		if (!resize || ir_resize_table(rc_tab, GFP_ATOMIC))
+			return -1U;
+	}
 
-		/* i is the proper index to insert our new keycode */
+	/* i is the proper index to insert our new keycode */
+	if (i < rc_tab->len)
 		memmove(&rc_tab->scan[i + 1], &rc_tab->scan[i],
 			(rc_tab->len - i) * sizeof(struct ir_scancode));
-		rc_tab->scan[i].scancode = scancode;
-		rc_tab->scan[i].keycode = keycode;
-		rc_tab->len++;
-		set_bit(keycode, dev->keybit);
-	} else {
-		IR_dprintk(1, "#%d: Replacing scan 0x%04x with key 0x%04x\n",
-			   i, scancode, keycode);
-		/* A previous mapping was updated... */
-		clear_bit(old_keycode, dev->keybit);
-		/* ...but another scancode might use the same keycode */
-		for (i = 0; i < rc_tab->len; i++) {
-			if (rc_tab->scan[i].keycode == old_keycode) {
-				set_bit(old_keycode, dev->keybit);
-				break;
-			}
-		}
-	}
+	rc_tab->scan[i].scancode = scancode;
+	rc_tab->scan[i].keycode = KEY_RESERVED;
+	rc_tab->len++;
 
-	return 0;
+	return i;
 }
 
 /**
@@ -171,17 +234,41 @@ static int ir_do_setkeycode(struct input_dev *dev,
  * This routine is used to handle evdev EVIOCSKEY ioctl.
  */
 static int ir_setkeycode(struct input_dev *dev,
-			 unsigned int scancode, unsigned int keycode)
+			 const struct input_keymap_entry *ke,
+			 unsigned int *old_keycode)
 {
-	int rc;
-	unsigned long flags;
 	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
 	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
+	unsigned int index;
+	unsigned int scancode;
+	int retval;
+	unsigned long flags;
 
 	spin_lock_irqsave(&rc_tab->lock, flags);
-	rc = ir_do_setkeycode(dev, rc_tab, scancode, keycode, true);
+
+	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
+		index = ke->index;
+		if (index >= rc_tab->len) {
+			retval = -EINVAL;
+			goto out;
+		}
+	} else {
+		retval = input_scancode_to_scalar(ke, &scancode);
+		if (retval)
+			goto out;
+
+		index = ir_establish_scancode(ir_dev, rc_tab, scancode, true);
+		if (index >= rc_tab->len) {
+			retval = -ENOMEM;
+			goto out;
+		}
+	}
+
+	*old_keycode = ir_update_mapping(dev, rc_tab, index, ke->keycode);
+
+out:
 	spin_unlock_irqrestore(&rc_tab->lock, flags);
-	return rc;
+	return retval;
 }
 
 /**
@@ -189,32 +276,73 @@ static int ir_setkeycode(struct input_dev *dev,
  * @dev:	the struct input_dev device descriptor
  * @to:		the struct ir_scancode_table to copy entries to
  * @from:	the struct ir_scancode_table to copy entries from
- * @return:	-EINVAL if all keycodes could not be inserted, otherwise zero.
+ * @return:	-ENOMEM if all keycodes could not be inserted, otherwise zero.
  *
  * This routine is used to handle table initialization.
  */
-static int ir_setkeytable(struct input_dev *dev,
-			  struct ir_scancode_table *to,
+static int ir_setkeytable(struct ir_input_dev *ir_dev,
 			  const struct ir_scancode_table *from)
 {
-	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
 	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
-	unsigned long flags;
-	unsigned int i;
-	int rc = 0;
+	unsigned int i, index;
+	int rc;
+
+	rc = ir_create_table(&ir_dev->rc_tab,
+			     from->name, from->ir_type, from->size);
+	if (rc)
+		return rc;
+
+	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
+		   rc_tab->size, rc_tab->alloc);
 
-	spin_lock_irqsave(&rc_tab->lock, flags);
 	for (i = 0; i < from->size; i++) {
-		rc = ir_do_setkeycode(dev, to, from->scan[i].scancode,
-				      from->scan[i].keycode, false);
-		if (rc)
+		index = ir_establish_scancode(ir_dev, rc_tab,
+					      from->scan[i].scancode, false);
+		if (index >= rc_tab->len) {
+			rc = -ENOMEM;
 			break;
+		}
+
+		ir_update_mapping(ir_dev->input_dev, rc_tab, index,
+				  from->scan[i].keycode);
 	}
-	spin_unlock_irqrestore(&rc_tab->lock, flags);
+
+	if (rc)
+		ir_free_table(rc_tab);
+
 	return rc;
 }
 
 /**
+ * ir_lookup_by_scancode() - locate mapping by scancode
+ * @rc_tab:	the &struct ir_scancode_table to search
+ * @scancode:	scancode to look for in the table
+ * @return:	index in the table, -1U if not found
+ *
+ * This routine performs binary search in RC keykeymap table for
+ * given scancode.
+ */
+static unsigned int ir_lookup_by_scancode(const struct ir_scancode_table *rc_tab,
+					  unsigned int scancode)
+{
+	unsigned int start = 0;
+	unsigned int end = rc_tab->len - 1;
+	unsigned int mid;
+
+	while (start <= end) {
+		mid = (start + end) / 2;
+		if (rc_tab->scan[mid].scancode < scancode)
+			start = mid + 1;
+		else if (rc_tab->scan[mid].scancode > scancode)
+			end = mid - 1;
+		else
+			return mid;
+	}
+
+	return -1U;
+}
+
+/**
  * ir_getkeycode() - get a keycode from the scancode->keycode table
  * @dev:	the struct input_dev device descriptor
  * @scancode:	the desired scancode
@@ -224,36 +352,46 @@ static int ir_setkeytable(struct input_dev *dev,
  * This routine is used to handle evdev EVIOCGKEY ioctl.
  */
 static int ir_getkeycode(struct input_dev *dev,
-			 unsigned int scancode, unsigned int *keycode)
+			 struct input_keymap_entry *ke)
 {
-	int start, end, mid;
-	unsigned long flags;
-	int key = KEY_RESERVED;
 	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
 	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
+	struct ir_scancode *entry;
+	unsigned long flags;
+	unsigned int index;
+	unsigned int scancode;
+	int retval;
 
 	spin_lock_irqsave(&rc_tab->lock, flags);
-	start = 0;
-	end = rc_tab->len - 1;
-	while (start <= end) {
-		mid = (start + end) / 2;
-		if (rc_tab->scan[mid].scancode < scancode)
-			start = mid + 1;
-		else if (rc_tab->scan[mid].scancode > scancode)
-			end = mid - 1;
-		else {
-			key = rc_tab->scan[mid].keycode;
-			break;
-		}
+
+	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
+		index = ke->index;
+	} else {
+		retval = input_scancode_to_scalar(ke, &scancode);
+		if (retval)
+			goto out;
+
+		index = ir_lookup_by_scancode(rc_tab, scancode);
+	}
+
+	if (index >= rc_tab->len) {
+		if (!(ke->flags & INPUT_KEYMAP_BY_INDEX))
+			IR_dprintk(1, "unknown key for scancode 0x%04x\n",
+				   scancode);
+		retval = -EINVAL;
+		goto out;
 	}
-	spin_unlock_irqrestore(&rc_tab->lock, flags);
 
-	if (key == KEY_RESERVED)
-		IR_dprintk(1, "unknown key for scancode 0x%04x\n",
-			   scancode);
+	entry = &rc_tab->scan[index];
 
-	*keycode = key;
-	return 0;
+	ke->index = index;
+	ke->keycode = entry->keycode;
+	ke->len = sizeof(entry->scancode);
+	memcpy(ke->scancode, &entry->scancode, sizeof(entry->scancode));
+
+out:
+	spin_unlock_irqrestore(&rc_tab->lock, flags);
+	return retval;
 }
 
 /**
@@ -268,12 +406,24 @@ static int ir_getkeycode(struct input_dev *dev,
  */
 u32 ir_g_keycode_from_table(struct input_dev *dev, u32 scancode)
 {
-	int keycode;
+	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
+	struct ir_scancode_table *rc_tab = &ir_dev->rc_tab;
+	unsigned int keycode;
+	unsigned int index;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rc_tab->lock, flags);
+
+	index = ir_lookup_by_scancode(rc_tab, scancode);
+	keycode = index < rc_tab->len ?
+			rc_tab->scan[index].keycode : KEY_RESERVED;
+
+	spin_unlock_irqrestore(&rc_tab->lock, flags);
 
-	ir_getkeycode(dev, scancode, &keycode);
 	if (keycode != KEY_RESERVED)
 		IR_dprintk(1, "%s: scancode 0x%04x keycode 0x%02x\n",
 			   dev->name, scancode, keycode);
+
 	return keycode;
 }
 EXPORT_SYMBOL_GPL(ir_g_keycode_from_table);
@@ -454,8 +604,8 @@ int __ir_input_register(struct input_dev *input_dev,
 		goto out_dev;
 	}
 
-	input_dev->getkeycode = ir_getkeycode;
-	input_dev->setkeycode = ir_setkeycode;
+	input_dev->getkeycode_new = ir_getkeycode;
+	input_dev->setkeycode_new = ir_setkeycode;
 	input_set_drvdata(input_dev, ir_dev);
 	ir_dev->input_dev = input_dev;
 
@@ -463,12 +613,6 @@ int __ir_input_register(struct input_dev *input_dev,
 	spin_lock_init(&ir_dev->keylock);
 	setup_timer(&ir_dev->timer_keyup, ir_timer_keyup, (unsigned long)ir_dev);
 
-	ir_dev->rc_tab.name = rc_tab->name;
-	ir_dev->rc_tab.ir_type = rc_tab->ir_type;
-	ir_dev->rc_tab.alloc = roundup_pow_of_two(rc_tab->size *
-						  sizeof(struct ir_scancode));
-	ir_dev->rc_tab.scan = kmalloc(ir_dev->rc_tab.alloc, GFP_KERNEL);
-	ir_dev->rc_tab.size = ir_dev->rc_tab.alloc / sizeof(struct ir_scancode);
 	if (props) {
 		ir_dev->props = props;
 		if (props->open)
@@ -477,23 +621,14 @@ int __ir_input_register(struct input_dev *input_dev,
 			input_dev->close = ir_close;
 	}
 
-	if (!ir_dev->rc_tab.scan) {
-		rc = -ENOMEM;
-		goto out_name;
-	}
-
-	IR_dprintk(1, "Allocated space for %u keycode entries (%u bytes)\n",
-		   ir_dev->rc_tab.size, ir_dev->rc_tab.alloc);
-
 	set_bit(EV_KEY, input_dev->evbit);
 	set_bit(EV_REP, input_dev->evbit);
 	set_bit(EV_MSC, input_dev->evbit);
 	set_bit(MSC_SCAN, input_dev->mscbit);
 
-	if (ir_setkeytable(input_dev, &ir_dev->rc_tab, rc_tab)) {
-		rc = -ENOMEM;
-		goto out_table;
-	}
+	rc = ir_setkeytable(ir_dev, rc_tab);
+	if (rc)
+		goto out_name;
 
 	rc = ir_register_class(input_dev);
 	if (rc < 0)
@@ -527,7 +662,7 @@ int __ir_input_register(struct input_dev *input_dev,
 out_event:
 	ir_unregister_class(input_dev);
 out_table:
-	kfree(ir_dev->rc_tab.scan);
+	ir_free_table(&ir_dev->rc_tab);
 out_name:
 	kfree(ir_dev->driver_name);
 out_dev:
@@ -545,7 +680,6 @@ EXPORT_SYMBOL_GPL(__ir_input_register);
 void ir_input_unregister(struct input_dev *input_dev)
 {
 	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
-	struct ir_scancode_table *rc_tab;
 
 	if (!ir_dev)
 		return;
@@ -557,10 +691,7 @@ void ir_input_unregister(struct input_dev *input_dev)
 		if (ir_dev->props->driver_type == RC_DRIVER_IR_RAW)
 			ir_raw_event_unregister(input_dev);
 
-	rc_tab = &ir_dev->rc_tab;
-	rc_tab->size = 0;
-	kfree(rc_tab->scan);
-	rc_tab->scan = NULL;
+	ir_free_table(&ir_dev->rc_tab);
 
 	ir_unregister_class(input_dev);
 
diff --git a/include/linux/input.h b/include/linux/input.h
index 896a922..64cf0eb 100644
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
 
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 25883cf..e0f17ed 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -36,7 +36,7 @@ struct ir_scancode_table {
 	unsigned int		len;	/* Used number of entries */
 	unsigned int		alloc;	/* Size of *scan in bytes */
 	u64			ir_type;
-	char			*name;
+	const char		*name;
 	spinlock_t		lock;
 };
 

