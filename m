Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58892 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758025Ab0IHHmE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 03:42:04 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4/6] Input: winbond-cir - switch to using new keycode interface
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Jiri Kosina <jkosina@suse.cz>, Ville Syrjala <syrjala@sci.fi>
Date: Wed, 08 Sep 2010 00:42:00 -0700
Message-ID: <20100908074200.32365.98120.stgit@hammer.corenet.prv>
In-Reply-To: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Switch the code to use new style of getkeycode and setkeycode
methods to allow retrieving and setting keycodes not only by
their scancodes but also by index.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/misc/winbond-cir.c |  248 +++++++++++++++++++++++++-------------
 1 files changed, 163 insertions(+), 85 deletions(-)

diff --git a/drivers/input/misc/winbond-cir.c b/drivers/input/misc/winbond-cir.c
index 64f1de7..6a69067 100644
--- a/drivers/input/misc/winbond-cir.c
+++ b/drivers/input/misc/winbond-cir.c
@@ -172,7 +172,6 @@ enum wbcir_protocol {
 #define WBCIR_MAX_IDLE_BYTES       10
 
 static DEFINE_SPINLOCK(wbcir_lock);
-static DEFINE_RWLOCK(keytable_lock);
 
 struct wbcir_key {
 	u32 scancode;
@@ -184,7 +183,7 @@ struct wbcir_keyentry {
 	struct list_head list;
 };
 
-static struct wbcir_key rc6_def_keymap[] = {
+static const struct wbcir_key rc6_def_keymap[] = {
 	{ 0x800F0400, KEY_NUMERIC_0		},
 	{ 0x800F0401, KEY_NUMERIC_1		},
 	{ 0x800F0402, KEY_NUMERIC_2		},
@@ -365,88 +364,152 @@ wbcir_to_rc6cells(u8 val)
  *
  *****************************************************************************/
 
-static unsigned int
-wbcir_do_getkeycode(struct wbcir_data *data, u32 scancode)
+static struct wbcir_keyentry *
+wbcir_keyentry_by_scancode(struct wbcir_data *data, u32 scancode)
 {
 	struct wbcir_keyentry *keyentry;
-	unsigned int keycode = KEY_RESERVED;
-	unsigned long flags;
 
-	read_lock_irqsave(&keytable_lock, flags);
+	list_for_each_entry(keyentry, &data->keytable, list)
+		if (keyentry->key.scancode == scancode)
+			return keyentry;
+
+	return NULL;
+}
+
+static struct wbcir_keyentry *
+wbcir_keyentry_by_index(struct wbcir_data *data, unsigned int index)
+{
+	struct wbcir_keyentry *keyentry;
+	unsigned int cur_idx = 0;
+
+	list_for_each_entry(keyentry, &data->keytable, list)
+		if (cur_idx++ == index)
+			return keyentry;
+
+	return NULL;
+}
+
+static struct wbcir_keyentry *
+wbcir_lookup_keyentry(struct wbcir_data *data,
+		      const struct input_keymap_entry *ke)
+{
+	struct wbcir_keyentry *keyentry;
+	unsigned int scancode;
+
+	if (ke->flags & INPUT_KEYMAP_BY_INDEX)
+		keyentry = wbcir_keyentry_by_index(data, ke->index);
+	else if (input_scancode_to_scalar(ke, &scancode) == 0)
+		keyentry = wbcir_keyentry_by_scancode(data, scancode);
+	else
+		keyentry = NULL;
+
+	return keyentry;
+
+}
+
+static unsigned int
+wbcir_keyentry_get_index(struct wbcir_data *data,
+			 const struct wbcir_keyentry *keyentry)
+{
+	struct wbcir_keyentry *k;
+	int idx = 0;
 
-	list_for_each_entry(keyentry, &data->keytable, list) {
-		if (keyentry->key.scancode == scancode) {
-			keycode = keyentry->key.keycode;
+	list_for_each_entry(k, &data->keytable, list) {
+		if (k == keyentry)
 			break;
-		}
+		idx++;
 	}
 
-	read_unlock_irqrestore(&keytable_lock, flags);
-	return keycode;
+	return idx;
 }
 
 static int
-wbcir_getkeycode(struct input_dev *dev,
-		 unsigned int scancode, unsigned int *keycode)
+wbcir_getkeycode(struct input_dev *dev, struct input_keymap_entry *ke)
 {
 	struct wbcir_data *data = input_get_drvdata(dev);
+	const struct wbcir_keyentry *keyentry;
+
+	keyentry = wbcir_lookup_keyentry(data, ke);
+	if (keyentry) {
+		ke->keycode = keyentry->key.keycode;
+		if (!(ke->flags & INPUT_KEYMAP_BY_INDEX))
+			ke->index = wbcir_keyentry_get_index(data, keyentry);
+		ke->len = sizeof(keyentry->key.scancode);
+		memcpy(ke->scancode, &keyentry->key.scancode,
+			sizeof(keyentry->key.scancode));
+
+		return 0;
+	}
 
-	*keycode = wbcir_do_getkeycode(data, scancode);
-	return 0;
+	return -EINVAL;
 }
 
 static int
 wbcir_setkeycode(struct input_dev *dev,
-		 unsigned int scancode, unsigned int keycode)
+		 const struct input_keymap_entry *ke,
+		 unsigned int *old_keycode)
 {
 	struct wbcir_data *data = input_get_drvdata(dev);
 	struct wbcir_keyentry *keyentry;
-	struct wbcir_keyentry *new_keyentry;
-	unsigned long flags;
-	unsigned int old_keycode = KEY_RESERVED;
-
-	new_keyentry = kmalloc(sizeof(*new_keyentry), GFP_KERNEL);
-	if (!new_keyentry)
-		return -ENOMEM;
+	unsigned int scancode;
 
-	write_lock_irqsave(&keytable_lock, flags);
+	*old_keycode = KEY_RESERVED;
 
-	list_for_each_entry(keyentry, &data->keytable, list) {
-		if (keyentry->key.scancode != scancode)
-			continue;
+	if (input_scancode_to_scalar(ke, &scancode))
+		return -EINVAL;
 
-		old_keycode = keyentry->key.keycode;
-		keyentry->key.keycode = keycode;
+	keyentry = wbcir_lookup_keyentry(data, ke);
+	if (keyentry) {
+		*old_keycode = keyentry->key.keycode;
+		clear_bit(*old_keycode, dev->keybit);
+	} else {
+		if (ke->flags & INPUT_KEYMAP_BY_INDEX)
+			return -EINVAL;
 
-		if (keyentry->key.keycode == KEY_RESERVED) {
-			list_del(&keyentry->list);
-			kfree(keyentry);
-		}
+		keyentry = kmalloc(sizeof(*keyentry), GFP_ATOMIC);
+		if (!keyentry)
+			return -ENOMEM;
 
-		break;
+		list_add_tail(&keyentry->list, &data->keytable);
 	}
 
-	set_bit(keycode, dev->keybit);
+	keyentry->key.keycode = ke->keycode;
+	keyentry->key.scancode = scancode;
 
-	if (old_keycode == KEY_RESERVED) {
-		new_keyentry->key.scancode = scancode;
-		new_keyentry->key.keycode = keycode;
-		list_add(&new_keyentry->list, &data->keytable);
+	if (keyentry->key.keycode == KEY_RESERVED) {
+		list_del(&keyentry->list);
+		kfree(keyentry);
 	} else {
-		kfree(new_keyentry);
-		clear_bit(old_keycode, dev->keybit);
+		set_bit(ke->keycode, dev->keybit);
 		list_for_each_entry(keyentry, &data->keytable, list) {
-			if (keyentry->key.keycode == old_keycode) {
-				set_bit(old_keycode, dev->keybit);
+			if (keyentry->key.keycode == *old_keycode) {
+				set_bit(*old_keycode, dev->keybit);
 				break;
 			}
 		}
 	}
 
-	write_unlock_irqrestore(&keytable_lock, flags);
 	return 0;
 }
 
+static unsigned int
+wbcir_fetch_keycode(struct wbcir_data *data, u32 scancode)
+{
+	struct input_dev *input = data->input_dev;
+	const struct wbcir_keyentry *keyentry;
+	unsigned int keycode;
+	unsigned long flags;
+
+	/* Take event lock to prevent race with setkeycode */
+	spin_lock_irqsave(&input->event_lock, flags);
+
+	keyentry = wbcir_keyentry_by_scancode(data, scancode);
+	keycode = keyentry ? keyentry->key.keycode : KEY_RESERVED;
+
+	spin_unlock_irqrestore(&input->event_lock, flags);
+	return keycode;
+}
+
 /*
  * Timer function to report keyup event some time after keydown is
  * reported by the ISR.
@@ -503,7 +566,7 @@ wbcir_keydown(struct wbcir_data *data, u32 scancode, u8 toggle)
 	input_event(data->input_dev, EV_MSC, MSC_SCAN, (int)scancode);
 
 	/* Do we know this scancode? */
-	keycode = wbcir_do_getkeycode(data, scancode);
+	keycode = wbcir_fetch_keycode(data, scancode);
 	if (keycode == KEY_RESERVED)
 		goto set_timer;
 
@@ -1247,7 +1310,7 @@ wbcir_init_hw(struct wbcir_data *data)
 
 	/*
 	 * Clear IR LED, set SP3 clock to 24Mhz
-	 * set SP3_IRRX_SW to binary 01, helpfully not documented
+	;* set SP3_IRRX_SW to binary 01, helpfully not documented
 	 */
 	outb(0x10, data->ebase + WBCIR_REG_ECEIR_CTS);
 
@@ -1339,6 +1402,41 @@ wbcir_resume(struct pnp_dev *device)
 	return 0;
 }
 
+static void
+wbcir_free_keymap(struct wbcir_data *data)
+{
+	struct wbcir_keyentry *key, *next;
+
+	list_for_each_entry_safe(key, next, &data->keytable, list) {
+		list_del(&key->list);
+		kfree(key);
+	}
+}
+
+static int
+wbcir_load_keymap(struct wbcir_data *data,
+		  const struct wbcir_key *keymap, unsigned int keymap_size)
+{
+	struct wbcir_keyentry *keyentry;
+	int i;
+
+	for (i = 0; i < keymap_size; i++) {
+		if (keymap[i].keycode != KEY_RESERVED) {
+			keyentry = kmalloc(sizeof(*keyentry), GFP_KERNEL);
+			if (!keyentry) {
+				wbcir_free_keymap(data);
+				return -ENOMEM;
+			}
+
+			keyentry->key.keycode = keymap[i].keycode;
+			keyentry->key.scancode = keymap[i].scancode;
+			list_add_tail(&keyentry->list, &data->keytable);
+		}
+	}
+
+	return 0;
+}
+
 static int __devinit
 wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 {
@@ -1359,6 +1457,10 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 		goto exit;
 	}
 
+	data->last_scancode = INVALID_SCANCODE;
+	INIT_LIST_HEAD(&data->keytable);
+	setup_timer(&data->timer_keyup, wbcir_keyup, (unsigned long)data);
+
 	pnp_set_drvdata(device, data);
 
 	data->ebase = pnp_port_start(device, 0);
@@ -1439,50 +1541,31 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->input_dev->id.vendor  = PCI_VENDOR_ID_WINBOND;
 	data->input_dev->id.product = WBCIR_ID_FAMILY;
 	data->input_dev->id.version = WBCIR_ID_CHIP;
-	data->input_dev->getkeycode = wbcir_getkeycode;
-	data->input_dev->setkeycode = wbcir_setkeycode;
+	data->input_dev->getkeycode_new = wbcir_getkeycode;
+	data->input_dev->setkeycode_new = wbcir_setkeycode;
 	input_set_capability(data->input_dev, EV_MSC, MSC_SCAN);
 	input_set_drvdata(data->input_dev, data);
 
-	err = input_register_device(data->input_dev);
-	if (err)
-		goto exit_free_input;
-
-	data->last_scancode = INVALID_SCANCODE;
-	INIT_LIST_HEAD(&data->keytable);
-	setup_timer(&data->timer_keyup, wbcir_keyup, (unsigned long)data);
-
 	/* Load default keymaps */
 	if (protocol == IR_PROTOCOL_RC6) {
-		int i;
-		for (i = 0; i < ARRAY_SIZE(rc6_def_keymap); i++) {
-			err = wbcir_setkeycode(data->input_dev,
-					       (int)rc6_def_keymap[i].scancode,
-					       (int)rc6_def_keymap[i].keycode);
-			if (err)
-				goto exit_unregister_keys;
-		}
+		err = wbcir_load_keymap(data, rc6_def_keymap,
+					ARRAY_SIZE(rc6_def_keymap));
+		if (err)
+			goto exit_free_input;
 	}
 
+	err = input_register_device(data->input_dev);
+	if (err)
+		goto exit_free_keymap;
+
 	device_init_wakeup(&device->dev, 1);
 
 	wbcir_init_hw(data);
 
 	return 0;
 
-exit_unregister_keys:
-	if (!list_empty(&data->keytable)) {
-		struct wbcir_keyentry *key;
-		struct wbcir_keyentry *keytmp;
-
-		list_for_each_entry_safe(key, keytmp, &data->keytable, list) {
-			list_del(&key->list);
-			kfree(key);
-		}
-	}
-	input_unregister_device(data->input_dev);
-	/* Can't call input_free_device on an unregistered device */
-	data->input_dev = NULL;
+exit_free_keymap:
+	wbcir_free_keymap(data);
 exit_free_input:
 	input_free_device(data->input_dev);
 exit_unregister_led:
@@ -1510,8 +1593,6 @@ static void __devexit
 wbcir_remove(struct pnp_dev *device)
 {
 	struct wbcir_data *data = pnp_get_drvdata(device);
-	struct wbcir_keyentry *key;
-	struct wbcir_keyentry *keytmp;
 
 	/* Disable interrupts */
 	wbcir_select_bank(data, WBCIR_BANK_0);
@@ -1544,10 +1625,7 @@ wbcir_remove(struct pnp_dev *device)
 	release_region(data->ebase, EHFUNC_IOMEM_LEN);
 	release_region(data->sbase, SP_IOMEM_LEN);
 
-	list_for_each_entry_safe(key, keytmp, &data->keytable, list) {
-		list_del(&key->list);
-		kfree(key);
-	}
+	wbcir_free_keymap(data);
 
 	kfree(data);
 

