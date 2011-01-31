Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:32966 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab1AaI4r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 03:56:47 -0500
Date: Mon, 31 Jan 2011 00:56:40 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linux Input <linux-input@vger.kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH] Input: switch completely over to the new versions of
 get/setkeycode
Message-ID: <20110131085640.GB30343@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Input: switch completely over to the new versions of get/setkeycode

All users of old style get/setkeycode methids have been converted so
it is time to retire them.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

Jiri, Mauro,

There is not a good way to avoid crossing multiple subsystems but the
changes are minimal, so if you are OK with the patch I'd like to move it
through my tree for .39.

Thanks!

 drivers/hid/hid-input.c                    |    4 +-
 drivers/input/input.c                      |   55 ++++------------------------
 drivers/input/misc/ati_remote2.c           |    4 +-
 drivers/input/sparse-keymap.c              |    4 +-
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c |    4 +-
 drivers/media/rc/rc-main.c                 |    4 +-
 include/linux/input.h                      |   12 ++----
 7 files changed, 20 insertions(+), 67 deletions(-)


diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 7f552bf..ba2aeea 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -888,8 +888,8 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 					hid->ll_driver->hidinput_input_event;
 				input_dev->open = hidinput_open;
 				input_dev->close = hidinput_close;
-				input_dev->setkeycode_new = hidinput_setkeycode;
-				input_dev->getkeycode_new = hidinput_getkeycode;
+				input_dev->setkeycode = hidinput_setkeycode;
+				input_dev->getkeycode = hidinput_getkeycode;
 
 				input_dev->name = hid->name;
 				input_dev->phys = hid->phys;
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 11905b6..d6e8bd8 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -791,22 +791,9 @@ int input_get_keycode(struct input_dev *dev, struct input_keymap_entry *ke)
 	int retval;
 
 	spin_lock_irqsave(&dev->event_lock, flags);
-
-	if (dev->getkeycode) {
-		/*
-		 * Support for legacy drivers, that don't implement the new
-		 * ioctls
-		 */
-		u32 scancode = ke->index;
-
-		memcpy(ke->scancode, &scancode, sizeof(scancode));
-		ke->len = sizeof(scancode);
-		retval = dev->getkeycode(dev, scancode, &ke->keycode);
-	} else {
-		retval = dev->getkeycode_new(dev, ke);
-	}
-
+	retval = dev->getkeycode(dev, ke);
 	spin_unlock_irqrestore(&dev->event_lock, flags);
+
 	return retval;
 }
 EXPORT_SYMBOL(input_get_keycode);
@@ -831,35 +818,7 @@ int input_set_keycode(struct input_dev *dev,
 
 	spin_lock_irqsave(&dev->event_lock, flags);
 
-	if (dev->setkeycode) {
-		/*
-		 * Support for legacy drivers, that don't implement the new
-		 * ioctls
-		 */
-		unsigned int scancode;
-
-		retval = input_scancode_to_scalar(ke, &scancode);
-		if (retval)
-			goto out;
-
-		/*
-		 * We need to know the old scancode, in order to generate a
-		 * keyup effect, if the set operation happens successfully
-		 */
-		if (!dev->getkeycode) {
-			retval = -EINVAL;
-			goto out;
-		}
-
-		retval = dev->getkeycode(dev, scancode, &old_keycode);
-		if (retval)
-			goto out;
-
-		retval = dev->setkeycode(dev, scancode, ke->keycode);
-	} else {
-		retval = dev->setkeycode_new(dev, ke, &old_keycode);
-	}
-
+	retval = dev->setkeycode(dev, ke, &old_keycode);
 	if (retval)
 		goto out;
 
@@ -1846,11 +1805,11 @@ int input_register_device(struct input_dev *dev)
 		dev->rep[REP_PERIOD] = 33;
 	}
 
-	if (!dev->getkeycode && !dev->getkeycode_new)
-		dev->getkeycode_new = input_default_getkeycode;
+	if (!dev->getkeycode)
+		dev->getkeycode = input_default_getkeycode;
 
-	if (!dev->setkeycode && !dev->setkeycode_new)
-		dev->setkeycode_new = input_default_setkeycode;
+	if (!dev->setkeycode)
+		dev->setkeycode = input_default_setkeycode;
 
 	dev_set_name(&dev->dev, "input%ld",
 		     (unsigned long) atomic_inc_return(&input_no) - 1);
diff --git a/drivers/input/misc/ati_remote2.c b/drivers/input/misc/ati_remote2.c
index 0b0e9be..9ccdb82 100644
--- a/drivers/input/misc/ati_remote2.c
+++ b/drivers/input/misc/ati_remote2.c
@@ -612,8 +612,8 @@ static int ati_remote2_input_init(struct ati_remote2 *ar2)
 	idev->open = ati_remote2_open;
 	idev->close = ati_remote2_close;
 
-	idev->getkeycode_new = ati_remote2_getkeycode;
-	idev->setkeycode_new = ati_remote2_setkeycode;
+	idev->getkeycode = ati_remote2_getkeycode;
+	idev->setkeycode = ati_remote2_setkeycode;
 
 	idev->name = ar2->name;
 	idev->phys = ar2->phys;
diff --git a/drivers/input/sparse-keymap.c b/drivers/input/sparse-keymap.c
index 7729e54..337bf51 100644
--- a/drivers/input/sparse-keymap.c
+++ b/drivers/input/sparse-keymap.c
@@ -210,8 +210,8 @@ int sparse_keymap_setup(struct input_dev *dev,
 
 	dev->keycode = map;
 	dev->keycodemax = map_size;
-	dev->getkeycode_new = sparse_keymap_getkeycode;
-	dev->setkeycode_new = sparse_keymap_setkeycode;
+	dev->getkeycode = sparse_keymap_getkeycode;
+	dev->setkeycode = sparse_keymap_setkeycode;
 
 	return 0;
 
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
index 347fbd4..b2b9415 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
@@ -198,8 +198,8 @@ static int legacy_dvb_usb_remote_init(struct dvb_usb_device *d)
 	d->input_dev = input_dev;
 	d->rc_dev = NULL;
 
-	input_dev->getkeycode_new = legacy_dvb_usb_getkeycode;
-	input_dev->setkeycode_new = legacy_dvb_usb_setkeycode;
+	input_dev->getkeycode = legacy_dvb_usb_getkeycode;
+	input_dev->setkeycode = legacy_dvb_usb_setkeycode;
 
 	/* set the bits for the keys */
 	deb_rc("key map size: %d\n", d->props.rc.legacy.rc_map_size);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 512a2f4..c376928 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -966,8 +966,8 @@ struct rc_dev *rc_allocate_device(void)
 		return NULL;
 	}
 
-	dev->input_dev->getkeycode_new = ir_getkeycode;
-	dev->input_dev->setkeycode_new = ir_setkeycode;
+	dev->input_dev->getkeycode = ir_getkeycode;
+	dev->input_dev->setkeycode = ir_setkeycode;
 	input_set_drvdata(dev->input_dev, dev);
 
 	spin_lock_init(&dev->rc_map.lock);
diff --git a/include/linux/input.h b/include/linux/input.h
index e428382..056ae8a 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1154,8 +1154,6 @@ struct ff_effect {
  *	sparse keymaps. If not supplied default mechanism will be used.
  *	The method is being called while holding event_lock and thus must
  *	not sleep
- * @getkeycode_new: transition method
- * @setkeycode_new: transition method
  * @ff: force feedback structure associated with the device if device
  *	supports force feedback effects
  * @repeat_key: stores key code of the last key pressed; used to implement
@@ -1234,14 +1232,10 @@ struct input_dev {
 	void *keycode;
 
 	int (*setkeycode)(struct input_dev *dev,
-			  unsigned int scancode, unsigned int keycode);
+			  const struct input_keymap_entry *ke,
+			  unsigned int *old_keycode);
 	int (*getkeycode)(struct input_dev *dev,
-			  unsigned int scancode, unsigned int *keycode);
-	int (*setkeycode_new)(struct input_dev *dev,
-			      const struct input_keymap_entry *ke,
-			      unsigned int *old_keycode);
-	int (*getkeycode_new)(struct input_dev *dev,
-			      struct input_keymap_entry *ke);
+			  struct input_keymap_entry *ke);
 
 	struct ff_device *ff;
 
-- 
Dmitry
