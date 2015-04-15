Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:25631 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbbDOGtM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2015 02:49:12 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v5 01/10] leds: unify the location of led-trigger API
Date: Wed, 15 Apr 2015 08:48:31 +0200
Message-id: <1429080520-10687-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1429080520-10687-1-git-send-email-j.anaszewski@samsung.com>
References: <1429080520-10687-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Part of led-trigger API was in the private drivers/leds/leds.h header.
Move it to the include/linux/leds.h header to unify the API location
and announce it as public. It has been already exported from
led-triggers.c with EXPORT_SYMBOL_GPL macro. The no-op definitions are
changed from macros to inline to match the style of the surrounding code.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/leds.h  |   24 ------------------------
 include/linux/leds.h |   25 +++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
index 79efe57..bc89d7a 100644
--- a/drivers/leds/leds.h
+++ b/drivers/leds/leds.h
@@ -13,7 +13,6 @@
 #ifndef __LEDS_H_INCLUDED
 #define __LEDS_H_INCLUDED
 
-#include <linux/device.h>
 #include <linux/rwsem.h>
 #include <linux/leds.h>
 
@@ -50,27 +49,4 @@ void led_stop_software_blink(struct led_classdev *led_cdev);
 extern struct rw_semaphore leds_list_lock;
 extern struct list_head leds_list;
 
-#ifdef CONFIG_LEDS_TRIGGERS
-void led_trigger_set_default(struct led_classdev *led_cdev);
-void led_trigger_set(struct led_classdev *led_cdev,
-			struct led_trigger *trigger);
-void led_trigger_remove(struct led_classdev *led_cdev);
-
-static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
-{
-	return led_cdev->trigger_data;
-}
-
-#else
-#define led_trigger_set_default(x) do {} while (0)
-#define led_trigger_set(x, y) do {} while (0)
-#define led_trigger_remove(x) do {} while (0)
-#define led_get_trigger_data(x) (NULL)
-#endif
-
-ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
-			const char *buf, size_t count);
-ssize_t led_trigger_show(struct device *dev, struct device_attribute *attr,
-			char *buf);
-
 #endif	/* __LEDS_H_INCLUDED */
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 9a2b000..b122eea 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -12,6 +12,7 @@
 #ifndef __LINUX_LEDS_H_INCLUDED
 #define __LINUX_LEDS_H_INCLUDED
 
+#include <linux/device.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
@@ -222,6 +223,11 @@ struct led_trigger {
 	struct list_head  next_trig;
 };
 
+ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count);
+ssize_t led_trigger_show(struct device *dev, struct device_attribute *attr,
+			char *buf);
+
 /* Registration functions for complex triggers */
 extern int led_trigger_register(struct led_trigger *trigger);
 extern void led_trigger_unregister(struct led_trigger *trigger);
@@ -238,6 +244,16 @@ extern void led_trigger_blink_oneshot(struct led_trigger *trigger,
 				      unsigned long *delay_on,
 				      unsigned long *delay_off,
 				      int invert);
+extern void led_trigger_set_default(struct led_classdev *led_cdev);
+extern void led_trigger_set(struct led_classdev *led_cdev,
+			struct led_trigger *trigger);
+extern void led_trigger_remove(struct led_classdev *led_cdev);
+
+static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
+{
+	return led_cdev->trigger_data;
+}
+
 /**
  * led_trigger_rename_static - rename a trigger
  * @name: the new trigger name
@@ -267,6 +283,15 @@ static inline void led_trigger_register_simple(const char *name,
 static inline void led_trigger_unregister_simple(struct led_trigger *trigger) {}
 static inline void led_trigger_event(struct led_trigger *trigger,
 				enum led_brightness event) {}
+static inline void led_trigger_set_default(struct led_classdev *led_cdev) {}
+static inline void led_trigger_set(struct led_classdev *led_cdev,
+				struct led_trigger *trigger) {}
+static inline void led_trigger_remove(struct led_classdev *led_cdev) {}
+static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_LEDS_TRIGGERS */
 
 /* Trigger specific functions */
-- 
1.7.9.5

