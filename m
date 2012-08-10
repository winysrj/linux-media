Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013Ab2HJT5g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 15:57:36 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Rientjes <rientjes@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/2] radio-shark2: Only compile led support when CONFIG_LED_CLASS is set
Date: Fri, 10 Aug 2012 21:58:06 +0200
Message-Id: <1344628686-10482-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1344628686-10482-1-git-send-email-hdegoede@redhat.com>
References: <1344628686-10482-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported-by: Dadiv Rientjes <rientjes@google.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/radio/radio-shark2.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/media/radio/radio-shark2.c b/drivers/media/radio/radio-shark2.c
index b9575de..e593d5a 100644
--- a/drivers/media/radio/radio-shark2.c
+++ b/drivers/media/radio/radio-shark2.c
@@ -27,7 +27,6 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/leds.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
@@ -35,6 +34,12 @@
 #include <media/v4l2-device.h>
 #include "radio-tea5777.h"
 
+#if defined(CONFIG_LEDS_CLASS) || \
+    (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_RADIO_SHARK2_MODULE))
+#include <linux/leds.h>
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
 
@@ -52,6 +56,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 
 #define v4l2_dev_to_shark(d) container_of(d, struct shark_device, v4l2_dev)
 
+#ifdef SHARK_USE_LEDS
 enum { BLUE_LED, RED_LED, NO_LEDS };
 
 static void shark_led_set_blue(struct led_classdev *led_cdev,
@@ -73,17 +78,20 @@ static const struct led_classdev shark_led_templates[NO_LEDS] = {
 		.brightness_set = shark_led_set_red,
 	},
 };
+#endif
 
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
@@ -161,6 +169,7 @@ static struct radio_tea5777_ops shark_tea_ops = {
 	.read_reg  = shark_read_reg,
 };
 
+#ifdef SHARK_USE_LEDS
 static void shark_led_work(struct work_struct *work)
 {
 	struct shark_device *shark =
@@ -216,20 +225,25 @@ static void shark_led_set_red(struct led_classdev *led_cdev,
 	set_bit(RED_LED, &shark->brightness_new);
 	schedule_work(&shark->led_work);
 }
+#endif
 
 static void usb_shark_disconnect(struct usb_interface *intf)
 {
 	struct v4l2_device *v4l2_dev = usb_get_intfdata(intf);
 	struct shark_device *shark = v4l2_dev_to_shark(v4l2_dev);
+#ifdef SHARK_USE_LEDS
 	int i;
+#endif
 
 	mutex_lock(&shark->tea.mutex);
 	v4l2_device_disconnect(&shark->v4l2_dev);
 	radio_tea5777_exit(&shark->tea);
 	mutex_unlock(&shark->tea.mutex);
 
+#ifdef SHARK_USE_LEDS
 	for (i = 0; i < NO_LEDS; i++)
 		led_classdev_unregister(&shark->leds[i]);
+#endif
 
 	v4l2_device_put(&shark->v4l2_dev);
 }
@@ -238,7 +252,9 @@ static void usb_shark_release(struct v4l2_device *v4l2_dev)
 {
 	struct shark_device *shark = v4l2_dev_to_shark(v4l2_dev);
 
+#ifdef SHARK_USE_LEDS
 	cancel_work_sync(&shark->led_work);
+#endif
 	v4l2_device_unregister(&shark->v4l2_dev);
 	kfree(shark->transfer_buffer);
 	kfree(shark);
@@ -248,7 +264,10 @@ static int usb_shark_probe(struct usb_interface *intf,
 			   const struct usb_device_id *id)
 {
 	struct shark_device *shark;
-	int i, retval = -ENOMEM;
+	int retval = -ENOMEM;
+#ifdef SHARK_USE_LEDS
+	int i;
+#endif
 
 	shark = kzalloc(sizeof(struct shark_device), GFP_KERNEL);
 	if (!shark)
@@ -292,6 +311,7 @@ static int usb_shark_probe(struct usb_interface *intf,
 		goto err_init_tea;
 	}
 
+#ifdef SHARK_USE_LEDS
 	INIT_WORK(&shark->led_work, shark_led_work);
 	for (i = 0; i < NO_LEDS; i++) {
 		shark->leds[i] = shark_led_templates[i];
@@ -312,6 +332,7 @@ static int usb_shark_probe(struct usb_interface *intf,
 				 "couldn't register led: %s\n",
 				 shark->led_names[i]);
 	}
+#endif
 
 	return 0;
 
-- 
1.7.11.4

