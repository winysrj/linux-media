Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36563 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab0B1GNQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 01:13:16 -0500
Date: Sat, 27 Feb 2010 22:13:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jiri Kosina <jkosina@suse.cz>
Cc: Linux Input <linux-input@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Platform Driver x86 <platform-driver-x86@vger.kernel.org>
Subject: [PATCH] Input: scancode in get/set_keycodes should be unsigned
Message-ID: <20100228061310.GA765@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The HID layer has some scan codes of the form 0xffbc0000 for logitech
devices which do not work if scancode is typed as signed int, so we need
to switch to unsigned int instead. While at it keycode being signed does
not make much sense either.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

Guys,

I was originally going to switch all platfrom drivers to use sparse
keymap libary to eliminate at least one subsystem from this patch but
it takes longer than I anticipated so here is mechanical conversion.
I'd really like to make get/set keycodes usable for HID so I'd like
to get this patch in before .34-rc1, could I get some ACKs please?

Thanks!


 drivers/hid/hid-input.c                    |   24 ++++++++++++------------
 drivers/input/evdev.c                      |    2 +-
 drivers/input/input.c                      |   20 +++++++++-----------
 drivers/input/misc/ati_remote2.c           |   14 +++++++-------
 drivers/input/misc/winbond-cir.c           |   12 +++++-------
 drivers/input/sparse-keymap.c              |    6 ++++--
 drivers/media/IR/ir-keytable.c             |    4 ++--
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c |    4 ++--
 drivers/platform/x86/asus-laptop.c         |   15 +++++++--------
 drivers/platform/x86/dell-wmi.c            |   16 +++++++---------
 drivers/platform/x86/hp-wmi.c              |   15 +++++++--------
 drivers/platform/x86/panasonic-laptop.c    |   15 +++++++--------
 drivers/platform/x86/topstar-laptop.c      |   13 ++++++-------
 drivers/platform/x86/toshiba_acpi.c        |   17 +++++++----------
 include/linux/input.h                      |   20 ++++++++++++--------
 15 files changed, 95 insertions(+), 102 deletions(-)


diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 79d9edd..7a0d2e4 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -68,22 +68,25 @@ static const struct {
 #define map_key_clear(c)	hid_map_usage_clear(hidinput, usage, &bit, \
 		&max, EV_KEY, (c))
 
-static inline int match_scancode(int code, int scancode)
+static inline int match_scancode(unsigned int code, unsigned int scancode)
 {
 	if (scancode == 0)
 		return 1;
-	return ((code & (HID_USAGE_PAGE | HID_USAGE)) == scancode);
+
+	return (code & (HID_USAGE_PAGE | HID_USAGE)) == scancode;
 }
 
-static inline int match_keycode(int code, int keycode)
+static inline int match_keycode(unsigned int code, unsigned int keycode)
 {
 	if (keycode == 0)
 		return 1;
-	return (code == keycode);
+
+	return code == keycode;
 }
 
 static struct hid_usage *hidinput_find_key(struct hid_device *hid,
-		int scancode, int keycode)
+					   unsigned int scancode,
+					   unsigned int keycode)
 {
 	int i, j, k;
 	struct hid_report *report;
@@ -105,8 +108,8 @@ static struct hid_usage *hidinput_find_key(struct hid_device *hid,
 	return NULL;
 }
 
-static int hidinput_getkeycode(struct input_dev *dev, int scancode,
-				int *keycode)
+static int hidinput_getkeycode(struct input_dev *dev,
+			       unsigned int scancode, unsigned int *keycode)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct hid_usage *usage;
@@ -119,16 +122,13 @@ static int hidinput_getkeycode(struct input_dev *dev, int scancode,
 	return -EINVAL;
 }
 
-static int hidinput_setkeycode(struct input_dev *dev, int scancode,
-				int keycode)
+static int hidinput_setkeycode(struct input_dev *dev,
+			       unsigned int scancode, unsigned int keycode)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct hid_usage *usage;
 	int old_keycode;
 
-	if (keycode < 0 || keycode > KEY_MAX)
-		return -EINVAL;
-
 	usage = hidinput_find_key(hid, scancode, 0);
 	if (usage) {
 		old_keycode = usage->code;
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 9f9816b..2ee6c7a 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -515,7 +515,7 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 	struct input_absinfo abs;
 	struct ff_effect effect;
 	int __user *ip = (int __user *)p;
-	int i, t, u, v;
+	unsigned int i, t, u, v;
 	int error;
 
 	switch (cmd) {
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 41168d5..e2dd885 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -582,7 +582,8 @@ static int input_fetch_keycode(struct input_dev *dev, int scancode)
 }
 
 static int input_default_getkeycode(struct input_dev *dev,
-				    int scancode, int *keycode)
+				    unsigned int scancode,
+				    unsigned int *keycode)
 {
 	if (!dev->keycodesize)
 		return -EINVAL;
@@ -596,7 +597,8 @@ static int input_default_getkeycode(struct input_dev *dev,
 }
 
 static int input_default_setkeycode(struct input_dev *dev,
-				    int scancode, int keycode)
+				    unsigned int scancode,
+				    unsigned int keycode)
 {
 	int old_keycode;
 	int i;
@@ -654,11 +656,9 @@ static int input_default_setkeycode(struct input_dev *dev,
  * This function should be called by anyone interested in retrieving current
  * keymap. Presently keyboard and evdev handlers use it.
  */
-int input_get_keycode(struct input_dev *dev, int scancode, int *keycode)
+int input_get_keycode(struct input_dev *dev,
+		      unsigned int scancode, unsigned int *keycode)
 {
-	if (scancode < 0)
-		return -EINVAL;
-
 	return dev->getkeycode(dev, scancode, keycode);
 }
 EXPORT_SYMBOL(input_get_keycode);
@@ -672,16 +672,14 @@ EXPORT_SYMBOL(input_get_keycode);
  * This function should be called by anyone needing to update current
  * keymap. Presently keyboard and evdev handlers use it.
  */
-int input_set_keycode(struct input_dev *dev, int scancode, int keycode)
+int input_set_keycode(struct input_dev *dev,
+		      unsigned int scancode, unsigned int keycode)
 {
 	unsigned long flags;
 	int old_keycode;
 	int retval;
 
-	if (scancode < 0)
-		return -EINVAL;
-
-	if (keycode < 0 || keycode > KEY_MAX)
+	if (keycode > KEY_MAX)
 		return -EINVAL;
 
 	spin_lock_irqsave(&dev->event_lock, flags);
diff --git a/drivers/input/misc/ati_remote2.c b/drivers/input/misc/ati_remote2.c
index 0501f0e..15be543 100644
--- a/drivers/input/misc/ati_remote2.c
+++ b/drivers/input/misc/ati_remote2.c
@@ -474,10 +474,11 @@ static void ati_remote2_complete_key(struct urb *urb)
 }
 
 static int ati_remote2_getkeycode(struct input_dev *idev,
-				  int scancode, int *keycode)
+				  unsigned int scancode, unsigned int *keycode)
 {
 	struct ati_remote2 *ar2 = input_get_drvdata(idev);
-	int index, mode;
+	unsigned int mode;
+	int index;
 
 	mode = scancode >> 8;
 	if (mode > ATI_REMOTE2_PC || !((1 << mode) & ar2->mode_mask))
@@ -491,10 +492,12 @@ static int ati_remote2_getkeycode(struct input_dev *idev,
 	return 0;
 }
 
-static int ati_remote2_setkeycode(struct input_dev *idev, int scancode, int keycode)
+static int ati_remote2_setkeycode(struct input_dev *idev,
+				  unsigned int scancode, unsigned int keycode)
 {
 	struct ati_remote2 *ar2 = input_get_drvdata(idev);
-	int index, mode, old_keycode;
+	unsigned int mode, old_keycode;
+	int index;
 
 	mode = scancode >> 8;
 	if (mode > ATI_REMOTE2_PC || !((1 << mode) & ar2->mode_mask))
@@ -504,9 +507,6 @@ static int ati_remote2_setkeycode(struct input_dev *idev, int scancode, int keyc
 	if (index < 0)
 		return -EINVAL;
 
-	if (keycode < KEY_RESERVED || keycode > KEY_MAX)
-		return -EINVAL;
-
 	old_keycode = ar2->keycode[mode][index];
 	ar2->keycode[mode][index] = keycode;
 	__set_bit(keycode, idev->keybit);
diff --git a/drivers/input/misc/winbond-cir.c b/drivers/input/misc/winbond-cir.c
index cbec3df..9c155a4 100644
--- a/drivers/input/misc/winbond-cir.c
+++ b/drivers/input/misc/winbond-cir.c
@@ -385,26 +385,24 @@ wbcir_do_getkeycode(struct wbcir_data *data, u32 scancode)
 }
 
 static int
-wbcir_getkeycode(struct input_dev *dev, int scancode, int *keycode)
+wbcir_getkeycode(struct input_dev *dev,
+		 unsigned int scancode, unsigned int *keycode)
 {
 	struct wbcir_data *data = input_get_drvdata(dev);
 
-	*keycode = (int)wbcir_do_getkeycode(data, (u32)scancode);
+	*keycode = wbcir_do_getkeycode(data, scancode);
 	return 0;
 }
 
 static int
-wbcir_setkeycode(struct input_dev *dev, int sscancode, int keycode)
+wbcir_setkeycode(struct input_dev *dev,
+		 unsigned int scancode, unsigned int keycode)
 {
 	struct wbcir_data *data = input_get_drvdata(dev);
 	struct wbcir_keyentry *keyentry;
 	struct wbcir_keyentry *new_keyentry;
 	unsigned long flags;
 	unsigned int old_keycode = KEY_RESERVED;
-	u32 scancode = (u32)sscancode;
-
-	if (keycode < 0 || keycode > KEY_MAX)
-		return -EINVAL;
 
 	new_keyentry = kmalloc(sizeof(*new_keyentry), GFP_KERNEL);
 	if (!new_keyentry)
diff --git a/drivers/input/sparse-keymap.c b/drivers/input/sparse-keymap.c
index fbd3987..e6bde55 100644
--- a/drivers/input/sparse-keymap.c
+++ b/drivers/input/sparse-keymap.c
@@ -64,7 +64,8 @@ struct key_entry *sparse_keymap_entry_from_keycode(struct input_dev *dev,
 EXPORT_SYMBOL(sparse_keymap_entry_from_keycode);
 
 static int sparse_keymap_getkeycode(struct input_dev *dev,
-				    int scancode, int *keycode)
+				    unsigned int scancode,
+				    unsigned int *keycode)
 {
 	const struct key_entry *key =
 			sparse_keymap_entry_from_scancode(dev, scancode);
@@ -78,7 +79,8 @@ static int sparse_keymap_getkeycode(struct input_dev *dev,
 }
 
 static int sparse_keymap_setkeycode(struct input_dev *dev,
-				    int scancode, int keycode)
+				    unsigned int scancode,
+				    unsigned int keycode)
 {
 	struct key_entry *key;
 	int old_keycode;
diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 0903f53..0a3b4ed 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -123,7 +123,7 @@ static int ir_copy_table(struct ir_scancode_table *destin,
  * If the key is not found, returns -EINVAL, otherwise, returns 0.
  */
 static int ir_getkeycode(struct input_dev *dev,
-			 int scancode, int *keycode)
+			 unsigned int scancode, unsigned int *keycode)
 {
 	int elem;
 	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
@@ -291,7 +291,7 @@ static int ir_insert_key(struct ir_scancode_table *rc_tab,
  * If the key is not found, returns -EINVAL, otherwise, returns 0.
  */
 static int ir_setkeycode(struct input_dev *dev,
-			 int scancode, int keycode)
+			 unsigned int scancode, unsigned int keycode)
 {
 	int rc = 0;
 	struct ir_input_dev *ir_dev = input_get_drvdata(dev);
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
index a03ef7e..852fe89 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
@@ -9,7 +9,7 @@
 #include <linux/usb/input.h>
 
 static int dvb_usb_getkeycode(struct input_dev *dev,
-				    int scancode, int *keycode)
+				unsigned int scancode, unsigned int *keycode)
 {
 	struct dvb_usb_device *d = input_get_drvdata(dev);
 
@@ -39,7 +39,7 @@ static int dvb_usb_getkeycode(struct input_dev *dev,
 }
 
 static int dvb_usb_setkeycode(struct input_dev *dev,
-				    int scancode, int keycode)
+				unsigned int scancode, unsigned int keycode)
 {
 	struct dvb_usb_device *d = input_get_drvdata(dev);
 
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 61a1c75..1a2161d 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -876,7 +876,7 @@ static ssize_t store_gps(struct device *dev, struct device_attribute *attr,
 /*
  * Hotkey functions
  */
-static struct key_entry *asus_get_entry_by_scancode(int code)
+static struct key_entry *asus_get_entry_by_scancode(unsigned int code)
 {
 	struct key_entry *key;
 
@@ -887,7 +887,7 @@ static struct key_entry *asus_get_entry_by_scancode(int code)
 	return NULL;
 }
 
-static struct key_entry *asus_get_entry_by_keycode(int code)
+static struct key_entry *asus_get_entry_by_keycode(unsigned int code)
 {
 	struct key_entry *key;
 
@@ -898,7 +898,8 @@ static struct key_entry *asus_get_entry_by_keycode(int code)
 	return NULL;
 }
 
-static int asus_getkeycode(struct input_dev *dev, int scancode, int *keycode)
+static int asus_getkeycode(struct input_dev *dev,
+			   unsigned int scancode, unsigned int *keycode)
 {
 	struct key_entry *key = asus_get_entry_by_scancode(scancode);
 
@@ -910,13 +911,11 @@ static int asus_getkeycode(struct input_dev *dev, int scancode, int *keycode)
 	return -EINVAL;
 }
 
-static int asus_setkeycode(struct input_dev *dev, int scancode, int keycode)
+static int asus_setkeycode(struct input_dev *dev,
+			   unsigned int scancode, unsigned int keycode)
 {
 	struct key_entry *key;
-	int old_keycode;
-
-	if (keycode < 0 || keycode > KEY_MAX)
-		return -EINVAL;
+	unsigned int old_keycode;
 
 	key = asus_get_entry_by_scancode(scancode);
 	if (key && key->type == KE_KEY) {
diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 1b1dddb..bed764e 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -142,7 +142,7 @@ static struct key_entry *dell_wmi_keymap = dell_legacy_wmi_keymap;
 
 static struct input_dev *dell_wmi_input_dev;
 
-static struct key_entry *dell_wmi_get_entry_by_scancode(int code)
+static struct key_entry *dell_wmi_get_entry_by_scancode(unsigned int code)
 {
 	struct key_entry *key;
 
@@ -153,7 +153,7 @@ static struct key_entry *dell_wmi_get_entry_by_scancode(int code)
 	return NULL;
 }
 
-static struct key_entry *dell_wmi_get_entry_by_keycode(int keycode)
+static struct key_entry *dell_wmi_get_entry_by_keycode(unsigned int keycode)
 {
 	struct key_entry *key;
 
@@ -164,8 +164,8 @@ static struct key_entry *dell_wmi_get_entry_by_keycode(int keycode)
 	return NULL;
 }
 
-static int dell_wmi_getkeycode(struct input_dev *dev, int scancode,
-			       int *keycode)
+static int dell_wmi_getkeycode(struct input_dev *dev,
+				unsigned int scancode, unsigned int *keycode)
 {
 	struct key_entry *key = dell_wmi_get_entry_by_scancode(scancode);
 
@@ -177,13 +177,11 @@ static int dell_wmi_getkeycode(struct input_dev *dev, int scancode,
 	return -EINVAL;
 }
 
-static int dell_wmi_setkeycode(struct input_dev *dev, int scancode, int keycode)
+static int dell_wmi_setkeycode(struct input_dev *dev,
+				unsigned int scancode, unsigned int keycode)
 {
 	struct key_entry *key;
-	int old_keycode;
-
-	if (keycode < 0 || keycode > KEY_MAX)
-		return -EINVAL;
+	unsigned int old_keycode;
 
 	key = dell_wmi_get_entry_by_scancode(scancode);
 	if (key && key->type == KE_KEY) {
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 3aa57da..3182bd3 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -278,7 +278,7 @@ static DEVICE_ATTR(als, S_IRUGO | S_IWUSR, show_als, set_als);
 static DEVICE_ATTR(dock, S_IRUGO, show_dock, NULL);
 static DEVICE_ATTR(tablet, S_IRUGO, show_tablet, NULL);
 
-static struct key_entry *hp_wmi_get_entry_by_scancode(int code)
+static struct key_entry *hp_wmi_get_entry_by_scancode(unsigned int code)
 {
 	struct key_entry *key;
 
@@ -289,7 +289,7 @@ static struct key_entry *hp_wmi_get_entry_by_scancode(int code)
 	return NULL;
 }
 
-static struct key_entry *hp_wmi_get_entry_by_keycode(int keycode)
+static struct key_entry *hp_wmi_get_entry_by_keycode(unsigned int keycode)
 {
 	struct key_entry *key;
 
@@ -300,7 +300,8 @@ static struct key_entry *hp_wmi_get_entry_by_keycode(int keycode)
 	return NULL;
 }
 
-static int hp_wmi_getkeycode(struct input_dev *dev, int scancode, int *keycode)
+static int hp_wmi_getkeycode(struct input_dev *dev,
+			     unsigned int scancode, unsigned int *keycode)
 {
 	struct key_entry *key = hp_wmi_get_entry_by_scancode(scancode);
 
@@ -312,13 +313,11 @@ static int hp_wmi_getkeycode(struct input_dev *dev, int scancode, int *keycode)
 	return -EINVAL;
 }
 
-static int hp_wmi_setkeycode(struct input_dev *dev, int scancode, int keycode)
+static int hp_wmi_setkeycode(struct input_dev *dev,
+			     unsigned int scancode, unsigned int keycode)
 {
 	struct key_entry *key;
-	int old_keycode;
-
-	if (keycode < 0 || keycode > KEY_MAX)
-		return -EINVAL;
+	unsigned int old_keycode;
 
 	key = hp_wmi_get_entry_by_scancode(scancode);
 	if (key && key->type == KE_KEY) {
diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index fe7cf01..c9fc479 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -200,7 +200,7 @@ static struct acpi_driver acpi_pcc_driver = {
 };
 
 #define KEYMAP_SIZE		11
-static const int initial_keymap[KEYMAP_SIZE] = {
+static const unsigned int initial_keymap[KEYMAP_SIZE] = {
 	/*  0 */ KEY_RESERVED,
 	/*  1 */ KEY_BRIGHTNESSDOWN,
 	/*  2 */ KEY_BRIGHTNESSUP,
@@ -222,7 +222,7 @@ struct pcc_acpi {
 	struct acpi_device	*device;
 	struct input_dev	*input_dev;
 	struct backlight_device	*backlight;
-	int			keymap[KEYMAP_SIZE];
+	unsigned int		keymap[KEYMAP_SIZE];
 };
 
 struct pcc_keyinput {
@@ -445,7 +445,8 @@ static struct attribute_group pcc_attr_group = {
 
 /* hotkey input device driver */
 
-static int pcc_getkeycode(struct input_dev *dev, int scancode, int *keycode)
+static int pcc_getkeycode(struct input_dev *dev,
+			  unsigned int scancode, unsigned int *keycode)
 {
 	struct pcc_acpi *pcc = input_get_drvdata(dev);
 
@@ -457,7 +458,7 @@ static int pcc_getkeycode(struct input_dev *dev, int scancode, int *keycode)
 	return 0;
 }
 
-static int keymap_get_by_keycode(struct pcc_acpi *pcc, int keycode)
+static int keymap_get_by_keycode(struct pcc_acpi *pcc, unsigned int keycode)
 {
 	int i;
 
@@ -469,7 +470,8 @@ static int keymap_get_by_keycode(struct pcc_acpi *pcc, int keycode)
 	return 0;
 }
 
-static int pcc_setkeycode(struct input_dev *dev, int scancode, int keycode)
+static int pcc_setkeycode(struct input_dev *dev,
+			  unsigned int scancode, unsigned int keycode)
 {
 	struct pcc_acpi *pcc = input_get_drvdata(dev);
 	int oldkeycode;
@@ -477,9 +479,6 @@ static int pcc_setkeycode(struct input_dev *dev, int scancode, int keycode)
 	if (scancode >= ARRAY_SIZE(pcc->keymap))
 		return -EINVAL;
 
-	if (keycode < 0 || keycode > KEY_MAX)
-		return -EINVAL;
-
 	oldkeycode = pcc->keymap[scancode];
 	pcc->keymap[scancode] = keycode;
 
diff --git a/drivers/platform/x86/topstar-laptop.c b/drivers/platform/x86/topstar-laptop.c
index 02f3d4e..4d6516f 100644
--- a/drivers/platform/x86/topstar-laptop.c
+++ b/drivers/platform/x86/topstar-laptop.c
@@ -46,7 +46,7 @@ static struct tps_key_entry topstar_keymap[] = {
 	{ }
 };
 
-static struct tps_key_entry *tps_get_key_by_scancode(int code)
+static struct tps_key_entry *tps_get_key_by_scancode(unsigned int code)
 {
 	struct tps_key_entry *key;
 
@@ -57,7 +57,7 @@ static struct tps_key_entry *tps_get_key_by_scancode(int code)
 	return NULL;
 }
 
-static struct tps_key_entry *tps_get_key_by_keycode(int code)
+static struct tps_key_entry *tps_get_key_by_keycode(unsigned int code)
 {
 	struct tps_key_entry *key;
 
@@ -126,7 +126,8 @@ static int acpi_topstar_fncx_switch(struct acpi_device *device, bool state)
 	return 0;
 }
 
-static int topstar_getkeycode(struct input_dev *dev, int scancode, int *keycode)
+static int topstar_getkeycode(struct input_dev *dev,
+				unsigned int scancode, unsigned int *keycode)
 {
 	struct tps_key_entry *key = tps_get_key_by_scancode(scancode);
 
@@ -137,14 +138,12 @@ static int topstar_getkeycode(struct input_dev *dev, int scancode, int *keycode)
 	return 0;
 }
 
-static int topstar_setkeycode(struct input_dev *dev, int scancode, int keycode)
+static int topstar_setkeycode(struct input_dev *dev,
+				unsigned int scancode, unsigned int keycode)
 {
 	struct tps_key_entry *key;
 	int old_keycode;
 
-	if (keycode < 0 || keycode > KEY_MAX)
-		return -EINVAL;
-
 	key = tps_get_key_by_scancode(scancode);
 
 	if (!key)
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 26c2117..726759b 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -745,7 +745,7 @@ static struct backlight_ops toshiba_backlight_data = {
         .update_status  = set_lcd_status,
 };
 
-static struct key_entry *toshiba_acpi_get_entry_by_scancode(int code)
+static struct key_entry *toshiba_acpi_get_entry_by_scancode(unsigned int code)
 {
 	struct key_entry *key;
 
@@ -756,7 +756,7 @@ static struct key_entry *toshiba_acpi_get_entry_by_scancode(int code)
 	return NULL;
 }
 
-static struct key_entry *toshiba_acpi_get_entry_by_keycode(int code)
+static struct key_entry *toshiba_acpi_get_entry_by_keycode(unsigned int code)
 {
 	struct key_entry *key;
 
@@ -767,8 +767,8 @@ static struct key_entry *toshiba_acpi_get_entry_by_keycode(int code)
 	return NULL;
 }
 
-static int toshiba_acpi_getkeycode(struct input_dev *dev, int scancode,
-				   int *keycode)
+static int toshiba_acpi_getkeycode(struct input_dev *dev,
+				   unsigned int scancode, unsigned int *keycode)
 {
 	struct key_entry *key = toshiba_acpi_get_entry_by_scancode(scancode);
 
@@ -780,14 +780,11 @@ static int toshiba_acpi_getkeycode(struct input_dev *dev, int scancode,
 	return -EINVAL;
 }
 
-static int toshiba_acpi_setkeycode(struct input_dev *dev, int scancode,
-				   int keycode)
+static int toshiba_acpi_setkeycode(struct input_dev *dev,
+				   unsigned int scancode, unsigned int keycode)
 {
 	struct key_entry *key;
-	int old_keycode;
-
-	if (keycode < 0 || keycode > KEY_MAX)
-		return -EINVAL;
+	unsigned int old_keycode;
 
 	key = toshiba_acpi_get_entry_by_scancode(scancode);
 	if (key && key->type == KE_KEY) {
diff --git a/include/linux/input.h b/include/linux/input.h
index dc24eff..7ed2251 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -58,10 +58,10 @@ struct input_absinfo {
 
 #define EVIOCGVERSION		_IOR('E', 0x01, int)			/* get driver version */
 #define EVIOCGID		_IOR('E', 0x02, struct input_id)	/* get device ID */
-#define EVIOCGREP		_IOR('E', 0x03, int[2])			/* get repeat settings */
-#define EVIOCSREP		_IOW('E', 0x03, int[2])			/* set repeat settings */
-#define EVIOCGKEYCODE		_IOR('E', 0x04, int[2])			/* get keycode */
-#define EVIOCSKEYCODE		_IOW('E', 0x04, int[2])			/* set keycode */
+#define EVIOCGREP		_IOR('E', 0x03, unsigned int[2])	/* get repeat settings */
+#define EVIOCSREP		_IOW('E', 0x03, unsigned int[2])	/* set repeat settings */
+#define EVIOCGKEYCODE		_IOR('E', 0x04, unsigned int[2])	/* get keycode */
+#define EVIOCSKEYCODE		_IOW('E', 0x04, unsigned int[2])	/* set keycode */
 
 #define EVIOCGNAME(len)		_IOC(_IOC_READ, 'E', 0x06, len)		/* get device name */
 #define EVIOCGPHYS(len)		_IOC(_IOC_READ, 'E', 0x07, len)		/* get physical location */
@@ -1142,8 +1142,10 @@ struct input_dev {
 	unsigned int keycodemax;
 	unsigned int keycodesize;
 	void *keycode;
-	int (*setkeycode)(struct input_dev *dev, int scancode, int keycode);
-	int (*getkeycode)(struct input_dev *dev, int scancode, int *keycode);
+	int (*setkeycode)(struct input_dev *dev,
+			  unsigned int scancode, unsigned int keycode);
+	int (*getkeycode)(struct input_dev *dev,
+			  unsigned int scancode, unsigned int *keycode);
 
 	struct ff_device *ff;
 
@@ -1415,8 +1417,10 @@ static inline void input_set_abs_params(struct input_dev *dev, int axis, int min
 	dev->absbit[BIT_WORD(axis)] |= BIT_MASK(axis);
 }
 
-int input_get_keycode(struct input_dev *dev, int scancode, int *keycode);
-int input_set_keycode(struct input_dev *dev, int scancode, int keycode);
+int input_get_keycode(struct input_dev *dev,
+		      unsigned int scancode, unsigned int *keycode);
+int input_set_keycode(struct input_dev *dev,
+		      unsigned int scancode, unsigned int keycode);
 
 extern struct class input_class;
 
-- 
Dmitry
