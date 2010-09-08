Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57028 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622Ab0IHHlx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 03:41:53 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 2/6] Input: sparse-keymap - switch to using new keycode
	interface
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Jiri Kosina <jkosina@suse.cz>, Ville Syrjala <syrjala@sci.fi>
Date: Wed, 08 Sep 2010 00:41:49 -0700
Message-ID: <20100908074149.32365.21481.stgit@hammer.corenet.prv>
In-Reply-To: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Switch sparse keymap library to use new style of getkeycode and
setkeycode methods to allow retrieving and setting keycodes not
only by their scancodes but also by index.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/sparse-keymap.c |   81 +++++++++++++++++++++++++++++++++--------
 1 files changed, 65 insertions(+), 16 deletions(-)

diff --git a/drivers/input/sparse-keymap.c b/drivers/input/sparse-keymap.c
index 0142483..a29a7812 100644
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
+					const struct input_keymap_entry *ke)
+{
+	struct key_entry *key;
+	unsigned int scancode;
+
+	if (ke->flags & INPUT_KEYMAP_BY_INDEX)
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
+				    struct input_keymap_entry *ke)
 {
 	const struct key_entry *key;
 
 	if (dev->keycode) {
-		key = sparse_keymap_entry_from_scancode(dev, scancode);
+		key = sparse_keymap_locate(dev, ke);
 		if (key && key->type == KE_KEY) {
-			*keycode = key->keycode;
+			ke->keycode = key->keycode;
+			if (!(ke->flags & INPUT_KEYMAP_BY_INDEX))
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
+				    const struct input_keymap_entry *ke,
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
 

