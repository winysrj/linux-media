Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab0HACyM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 22:54:12 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o712sCU1012685
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 31 Jul 2010 22:54:12 -0400
Received: from pedra (vpn-10-93.rdu.redhat.com [10.11.10.93])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o712rkwH027490
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 31 Jul 2010 22:54:10 -0400
Date: Sat, 31 Jul 2010 23:54:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/7] V4L/DVB: dvb-usb: add support for rc-core mode
Message-ID: <20100731235405.6eb2c54b@pedra>
In-Reply-To: <cover.1280630041.git.mchehab@redhat.com>
References: <cover.1280630041.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allows dvb-usb drivers to use rc-core, instead of the legacy
implementation.

No driver were ported yet to rc-core, so, some small adjustments
may be needed, when starting to migrate the drivers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
index 7951076..b579fed 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
@@ -8,7 +8,7 @@
 #include "dvb-usb-common.h"
 #include <linux/usb/input.h>
 
-static int dvb_usb_getkeycode(struct input_dev *dev,
+static int legacy_dvb_usb_getkeycode(struct input_dev *dev,
 				unsigned int scancode, unsigned int *keycode)
 {
 	struct dvb_usb_device *d = input_get_drvdata(dev);
@@ -25,7 +25,7 @@ static int dvb_usb_getkeycode(struct input_dev *dev,
 
 	/*
 	 * If is there extra space, returns KEY_RESERVED,
-	 * otherwise, input core won't let dvb_usb_setkeycode
+	 * otherwise, input core won't let legacy_dvb_usb_setkeycode
 	 * to work
 	 */
 	for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++)
@@ -38,7 +38,7 @@ static int dvb_usb_getkeycode(struct input_dev *dev,
 	return -EINVAL;
 }
 
-static int dvb_usb_setkeycode(struct input_dev *dev,
+static int legacy_dvb_usb_setkeycode(struct input_dev *dev,
 				unsigned int scancode, unsigned int keycode)
 {
 	struct dvb_usb_device *d = input_get_drvdata(dev);
@@ -78,7 +78,7 @@ static int dvb_usb_setkeycode(struct input_dev *dev,
  *
  * TODO: Fix the repeat rate of the input device.
  */
-static void dvb_usb_read_remote_control(struct work_struct *work)
+static void legacy_dvb_usb_read_remote_control(struct work_struct *work)
 {
 	struct dvb_usb_device *d =
 		container_of(work, struct dvb_usb_device, rc_query_work.work);
@@ -154,15 +154,114 @@ schedule:
 	schedule_delayed_work(&d->rc_query_work,msecs_to_jiffies(d->props.rc.legacy.rc_interval));
 }
 
+static int legacy_dvb_usb_remote_init(struct dvb_usb_device *d,
+				      struct input_dev *input_dev)
+{
+	int i, err, rc_interval;
+
+	input_dev->getkeycode = legacy_dvb_usb_getkeycode;
+	input_dev->setkeycode = legacy_dvb_usb_setkeycode;
+
+	/* set the bits for the keys */
+	deb_rc("key map size: %d\n", d->props.rc.legacy.rc_key_map_size);
+	for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++) {
+		deb_rc("setting bit for event %d item %d\n",
+			d->props.rc.legacy.rc_key_map[i].keycode, i);
+		set_bit(d->props.rc.legacy.rc_key_map[i].keycode, input_dev->keybit);
+	}
+
+	/* setting these two values to non-zero, we have to manage key repeats */
+	input_dev->rep[REP_PERIOD] = d->props.rc.legacy.rc_interval;
+	input_dev->rep[REP_DELAY]  = d->props.rc.legacy.rc_interval + 150;
+
+	input_set_drvdata(input_dev, d);
+
+	err = input_register_device(input_dev);
+	if (err)
+		input_free_device(input_dev);
+
+	rc_interval = d->props.rc.legacy.rc_interval;
+
+	INIT_DELAYED_WORK(&d->rc_query_work, legacy_dvb_usb_read_remote_control);
+
+	info("schedule remote query interval to %d msecs.", rc_interval);
+	schedule_delayed_work(&d->rc_query_work,
+			      msecs_to_jiffies(rc_interval));
+
+	d->state |= DVB_USB_STATE_REMOTE;
+
+	return err;
+}
+
+/* Remote-control poll function - called every dib->rc_query_interval ms to see
+ * whether the remote control has received anything.
+ *
+ * TODO: Fix the repeat rate of the input device.
+ */
+static void dvb_usb_read_remote_control(struct work_struct *work)
+{
+	struct dvb_usb_device *d =
+		container_of(work, struct dvb_usb_device, rc_query_work.work);
+	int err;
+
+	/* TODO: need a lock here.  We can simply skip checking for the remote control
+	   if we're busy. */
+
+	/* when the parameter has been set to 1 via sysfs while the
+	 * driver was running, or when bulk mode is enabled after IR init
+	 */
+	if (dvb_usb_disable_rc_polling || d->props.rc.core.bulk_mode)
+		return;
+
+	err = d->props.rc.core.rc_query(d);
+	if (err)
+		err("error %d while querying for an remote control event.", err);
+
+	schedule_delayed_work(&d->rc_query_work,
+			      msecs_to_jiffies(d->props.rc.core.rc_interval));
+}
+
+static int rc_core_dvb_usb_remote_init(struct dvb_usb_device *d,
+				       struct input_dev *input_dev)
+{
+	int err, rc_interval;
+
+	d->props.rc.core.rc_props.priv = d;
+	err = ir_input_register(input_dev,
+				 d->props.rc.core.rc_codes,
+				 &d->props.rc.core.rc_props,
+				 d->props.rc.core.module_name);
+	if (err < 0)
+		return err;
+
+	if (!d->props.rc.core.rc_query || d->props.rc.core.bulk_mode)
+		return 0;
+
+	/* Polling mode - initialize a work queue for handling it */
+	INIT_DELAYED_WORK(&d->rc_query_work, dvb_usb_read_remote_control);
+
+	rc_interval = d->props.rc.core.rc_interval;
+
+	info("schedule remote query interval to %d msecs.", rc_interval);
+	schedule_delayed_work(&d->rc_query_work,
+			      msecs_to_jiffies(rc_interval));
+
+	return 0;
+}
+
 int dvb_usb_remote_init(struct dvb_usb_device *d)
 {
 	struct input_dev *input_dev;
-	int i;
 	int err;
 
-	if (d->props.rc.legacy.rc_key_map == NULL ||
-		d->props.rc.legacy.rc_query == NULL ||
-		dvb_usb_disable_rc_polling)
+	if (dvb_usb_disable_rc_polling)
+		return 0;
+
+	if (d->props.rc.legacy.rc_key_map && d->props.rc.legacy.rc_query)
+		d->props.rc.mode = DVB_RC_LEGACY;
+	else if (d->props.rc.core.rc_codes)
+		d->props.rc.mode = DVB_RC_CORE;
+	else
 		return 0;
 
 	usb_make_path(d->udev, d->rc_phys, sizeof(d->rc_phys));
@@ -177,39 +276,19 @@ int dvb_usb_remote_init(struct dvb_usb_device *d)
 	input_dev->phys = d->rc_phys;
 	usb_to_input_id(d->udev, &input_dev->id);
 	input_dev->dev.parent = &d->udev->dev;
-	input_dev->getkeycode = dvb_usb_getkeycode;
-	input_dev->setkeycode = dvb_usb_setkeycode;
-
-	/* set the bits for the keys */
-	deb_rc("key map size: %d\n", d->props.rc.legacy.rc_key_map_size);
-	for (i = 0; i < d->props.rc.legacy.rc_key_map_size; i++) {
-		deb_rc("setting bit for event %d item %d\n",
-			d->props.rc.legacy.rc_key_map[i].keycode, i);
-		set_bit(d->props.rc.legacy.rc_key_map[i].keycode, input_dev->keybit);
-	}
 
 	/* Start the remote-control polling. */
 	if (d->props.rc.legacy.rc_interval < 40)
 		d->props.rc.legacy.rc_interval = 100; /* default */
 
-	/* setting these two values to non-zero, we have to manage key repeats */
-	input_dev->rep[REP_PERIOD] = d->props.rc.legacy.rc_interval;
-	input_dev->rep[REP_DELAY]  = d->props.rc.legacy.rc_interval + 150;
-
-	input_set_drvdata(input_dev, d);
-
-	err = input_register_device(input_dev);
-	if (err) {
-		input_free_device(input_dev);
-		return err;
-	}
-
 	d->rc_input_dev = input_dev;
 
-	INIT_DELAYED_WORK(&d->rc_query_work, dvb_usb_read_remote_control);
-
-	info("schedule remote query interval to %d msecs.", d->props.rc.legacy.rc_interval);
-	schedule_delayed_work(&d->rc_query_work,msecs_to_jiffies(d->props.rc.legacy.rc_interval));
+	if (d->props.rc.mode == DVB_RC_LEGACY)
+		err = legacy_dvb_usb_remote_init(d, input_dev);
+	else
+		err = rc_core_dvb_usb_remote_init(d, input_dev);
+	if (err)
+		return err;
 
 	d->state |= DVB_USB_STATE_REMOTE;
 
@@ -221,7 +300,10 @@ int dvb_usb_remote_exit(struct dvb_usb_device *d)
 	if (d->state & DVB_USB_STATE_REMOTE) {
 		cancel_rearming_delayed_work(&d->rc_query_work);
 		flush_scheduled_work();
-		input_unregister_device(d->rc_input_dev);
+		if (d->props.rc.mode == DVB_RC_LEGACY)
+			input_unregister_device(d->rc_input_dev);
+		else
+			ir_input_unregister(d->rc_input_dev);
 	}
 	d->state &= ~DVB_USB_STATE_REMOTE;
 	return 0;
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 76f9724..bcfbf9a 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -14,7 +14,7 @@
 #include <linux/usb.h>
 #include <linux/firmware.h>
 #include <linux/mutex.h>
-#include <media/rc-map.h>
+#include <media/ir-core.h>
 
 #include "dvb_frontend.h"
 #include "dvb_demux.h"
@@ -177,6 +177,34 @@ struct dvb_rc_legacy {
 };
 
 /**
+ * struct dvb_rc properties of remote controller, using rc-core
+ * @rc_codes: name of rc codes table
+ * @rc_query: called to query an event event.
+ * @rc_interval: time in ms between two queries.
+ * @rc_props: remote controller properties
+ * @bulk_mode: device supports bulk mode for RC (disable polling mode)
+ */
+struct dvb_rc {
+	char *rc_codes;
+	char *module_name;
+	int (*rc_query) (struct dvb_usb_device *d);
+	int rc_interval;
+	struct ir_dev_props rc_props;
+	bool bulk_mode;				/* uses bulk mode */
+};
+
+/**
+ * enum dvb_usb_mode - Specifies if it is using a legacy driver or a new one
+ *		       based on rc-core
+ * This is initialized/used only inside dvb-usb-remote.c.
+ * It shouldn't be set by the drivers.
+ */
+enum dvb_usb_mode {
+	DVB_RC_LEGACY,
+	DVB_RC_CORE,
+};
+
+/**
  * struct dvb_usb_device_properties - properties of a dvb-usb-device
  * @usb_ctrl: which USB device-side controller is in use. Needed for firmware
  *  download.
@@ -238,8 +266,10 @@ struct dvb_usb_device_properties {
 	int (*identify_state)   (struct usb_device *, struct dvb_usb_device_properties *,
 			struct dvb_usb_device_description **, int *);
 
-	union {
+	struct {
+		enum dvb_usb_mode mode;	/* Drivers shouldn't touch on it */
 		struct dvb_rc_legacy legacy;
+		struct dvb_rc core;
 	} rc;
 
 	struct i2c_algorithm *i2c_algo;
-- 
1.7.1


