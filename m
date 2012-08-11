Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab2HKKeF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Aug 2012 06:34:05 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Rientjes <rientjes@google.com>,
	linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 4/4] radio-shark2: Only compile led support when CONFIG_LED_CLASS is set
Date: Sat, 11 Aug 2012 12:34:55 +0200
Message-Id: <1344681295-2485-5-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1344681295-2485-1-git-send-email-hdegoede@redhat.com>
References: <1344681295-2485-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/radio/radio-shark2.c | 122 ++++++++++++++++++++++---------------
 1 file changed, 73 insertions(+), 49 deletions(-)

diff --git a/drivers/media/radio/radio-shark2.c b/drivers/media/radio/radio-shark2.c
index 217483c..7b4efdf 100644
--- a/drivers/media/radio/radio-shark2.c
+++ b/drivers/media/radio/radio-shark2.c
@@ -35,6 +35,11 @@
 #include <media/v4l2-device.h>
 #include "radio-tea5777.h"
 
+#if defined(CONFIG_LEDS_CLASS) || \
+    (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_RADIO_SHARK2_MODULE))
+#define SHARK_USE_LEDS 1
+#endif
+
 MODULE_AUTHOR("Hans de Goede <hdegoede@redhat.com>");
 MODULE_DESCRIPTION("Griffin radioSHARK2, USB radio receiver driver");
 MODULE_LICENSE("GPL");
@@ -43,7 +48,6 @@ static int debug;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "Debug level (0-1)");
 
-
 #define SHARK_IN_EP		0x83
 #define SHARK_OUT_EP		0x05
 
@@ -54,36 +58,18 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 
 enum { BLUE_LED, RED_LED, NO_LEDS };
 
-static void shark_led_set_blue(struct led_classdev *led_cdev,
-			       enum led_brightness value);
-static void shark_led_set_red(struct led_classdev *led_cdev,
-			      enum led_brightness value);
-
-static const struct led_classdev shark_led_templates[NO_LEDS] = {
-	[BLUE_LED] = {
-		.name		= "%s:blue:",
-		.brightness	= LED_OFF,
-		.max_brightness = 127,
-		.brightness_set = shark_led_set_blue,
-	},
-	[RED_LED] = {
-		.name		= "%s:red:",
-		.brightness	= LED_OFF,
-		.max_brightness = 1,
-		.brightness_set = shark_led_set_red,
-	},
-};
-
 struct shark_device {
 	struct usb_device *usbdev;
 	struct v4l2_device v4l2_dev;
 	struct radio_tea5777 tea;
 
+#ifdef SHARK_USE_LEDS
 	struct work_struct led_work;
 	struct led_classdev leds[NO_LEDS];
 	char led_names[NO_LEDS][32];
 	atomic_t brightness[NO_LEDS];
 	unsigned long brightness_new;
+#endif
 
 	u8 *transfer_buffer;
 };
@@ -161,6 +147,7 @@ static struct radio_tea5777_ops shark_tea_ops = {
 	.read_reg  = shark_read_reg,
 };
 
+#ifdef SHARK_USE_LEDS
 static void shark_led_work(struct work_struct *work)
 {
 	struct shark_device *shark =
@@ -208,21 +195,72 @@ static void shark_led_set_red(struct led_classdev *led_cdev,
 	schedule_work(&shark->led_work);
 }
 
+static const struct led_classdev shark_led_templates[NO_LEDS] = {
+	[BLUE_LED] = {
+		.name		= "%s:blue:",
+		.brightness	= LED_OFF,
+		.max_brightness = 127,
+		.brightness_set = shark_led_set_blue,
+	},
+	[RED_LED] = {
+		.name		= "%s:red:",
+		.brightness	= LED_OFF,
+		.max_brightness = 1,
+		.brightness_set = shark_led_set_red,
+	},
+};
+
+static int shark_register_leds(struct shark_device *shark, struct device *dev)
+{
+	int i, retval;
+
+	INIT_WORK(&shark->led_work, shark_led_work);
+	for (i = 0; i < NO_LEDS; i++) {
+		shark->leds[i] = shark_led_templates[i];
+		snprintf(shark->led_names[i], sizeof(shark->led_names[0]),
+			 shark->leds[i].name, shark->v4l2_dev.name);
+		shark->leds[i].name = shark->led_names[i];
+		retval = led_classdev_register(dev, &shark->leds[i]);
+		if (retval) {
+			v4l2_err(&shark->v4l2_dev,
+				 "couldn't register led: %s\n",
+				 shark->led_names[i]);
+			return retval;
+		}
+	}
+	return 0;
+}
+
+static void shark_unregister_leds(struct shark_device *shark)
+{
+	int i;
+
+	for (i = 0; i < NO_LEDS; i++)
+		led_classdev_unregister(&shark->leds[i]);
+
+	cancel_work_sync(&shark->led_work);
+}
+#else
+static int shark_register_leds(struct shark_device *shark, struct device *dev)
+{
+	v4l2_warn(&shark->v4l2_dev,
+		  "CONFIG_LED_CLASS not enabled, LED support disabled\n");
+	return 0;
+}
+static inline void shark_unregister_leds(struct shark_device *shark) { }
+#endif
+
 static void usb_shark_disconnect(struct usb_interface *intf)
 {
 	struct v4l2_device *v4l2_dev = usb_get_intfdata(intf);
 	struct shark_device *shark = v4l2_dev_to_shark(v4l2_dev);
-	int i;
 
 	mutex_lock(&shark->tea.mutex);
 	v4l2_device_disconnect(&shark->v4l2_dev);
 	radio_tea5777_exit(&shark->tea);
 	mutex_unlock(&shark->tea.mutex);
 
-	for (i = 0; i < NO_LEDS; i++)
-		led_classdev_unregister(&shark->leds[i]);
-
-	cancel_work_sync(&shark->led_work);
+	shark_unregister_leds(shark);
 
 	v4l2_device_put(&shark->v4l2_dev);
 }
@@ -240,7 +278,7 @@ static int usb_shark_probe(struct usb_interface *intf,
 			   const struct usb_device_id *id)
 {
 	struct shark_device *shark;
-	int i, retval = -ENOMEM;
+	int retval = -ENOMEM;
 
 	shark = kzalloc(sizeof(struct shark_device), GFP_KERNEL);
 	if (!shark)
@@ -250,8 +288,13 @@ static int usb_shark_probe(struct usb_interface *intf,
 	if (!shark->transfer_buffer)
 		goto err_alloc_buffer;
 
-	shark->v4l2_dev.release = usb_shark_release;
 	v4l2_device_set_name(&shark->v4l2_dev, DRV_NAME, &shark_instance);
+
+	retval = shark_register_leds(shark, &intf->dev);
+	if (retval)
+		goto err_reg_leds;
+
+	shark->v4l2_dev.release = usb_shark_release;
 	retval = v4l2_device_register(&intf->dev, &shark->v4l2_dev);
 	if (retval) {
 		v4l2_err(&shark->v4l2_dev, "couldn't register v4l2_device\n");
@@ -275,32 +318,13 @@ static int usb_shark_probe(struct usb_interface *intf,
 		goto err_init_tea;
 	}
 
-	INIT_WORK(&shark->led_work, shark_led_work);
-	for (i = 0; i < NO_LEDS; i++) {
-		shark->leds[i] = shark_led_templates[i];
-		snprintf(shark->led_names[i], sizeof(shark->led_names[0]),
-			 shark->leds[i].name, shark->v4l2_dev.name);
-		shark->leds[i].name = shark->led_names[i];
-		/*
-		 * We don't fail the probe if we fail to register the leds,
-		 * because once we've called radio_tea5777_init, the /dev/radio0
-		 * node may be opened from userspace holding a reference to us!
-		 *
-		 * Note we cannot register the leds first instead as
-		 * shark_led_work depends on the v4l2 mutex and registered bit.
-		 */
-		retval = led_classdev_register(&intf->dev, &shark->leds[i]);
-		if (retval)
-			v4l2_err(&shark->v4l2_dev,
-				 "couldn't register led: %s\n",
-				 shark->led_names[i]);
-	}
-
 	return 0;
 
 err_init_tea:
 	v4l2_device_unregister(&shark->v4l2_dev);
 err_reg_dev:
+	shark_unregister_leds(shark);
+err_reg_leds:
 	kfree(shark->transfer_buffer);
 err_alloc_buffer:
 	kfree(shark);
-- 
1.7.11.4

