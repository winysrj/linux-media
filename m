Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40155 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaC1P32 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 11:29:28 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com,
	kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v2 2/8] leds: Improve and export led_update_brightness
 function
Date: Fri, 28 Mar 2014 16:28:59 +0100
Message-id: <1396020545-15727-3-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1396020545-15727-1-git-send-email-j.anaszewski@samsung.com>
References: <1396020545-15727-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

led_update_brightness helper function used to be exploited
only locally in the led-class.c module, where its result was
being passed to the brightness_show sysfs callback. With the
introduction of v4l2-flash subdevice the same functionality
became required for reading current brightness from a LED
device. This patch adds checking brightness_get callback
error code and adds the function to the LED subsystem
public API.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/led-class.c |    6 ------
 drivers/leds/led-core.c  |   17 +++++++++++++++++
 include/linux/leds.h     |   10 ++++++++++
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 5bac140..efe6812 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -25,12 +25,6 @@
 
 static struct class *leds_class;
 
-static void led_update_brightness(struct led_classdev *led_cdev)
-{
-	if (led_cdev->brightness_get)
-		led_cdev->brightness = led_cdev->brightness_get(led_cdev);
-}
-
 static ssize_t brightness_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index 71b40d3..41f2a6a 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -126,3 +126,20 @@ void led_set_brightness(struct led_classdev *led_cdev,
 	__led_set_brightness(led_cdev, brightness);
 }
 EXPORT_SYMBOL(led_set_brightness);
+
+int led_update_brightness(struct led_classdev *led_cdev)
+{
+	int ret;
+
+	if (led_cdev->brightness_get == NULL)
+		return -EINVAL;
+
+	ret = led_cdev->brightness_get(led_cdev);
+	if (ret >= 0) {
+		led_cdev->brightness = ret;
+		return 0;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(led_update_brightness);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 596555a..c02dd7b 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -148,6 +148,16 @@ extern void led_blink_set_oneshot(struct led_classdev *led_cdev,
  */
 extern void led_set_brightness(struct led_classdev *led_cdev,
 			       enum led_brightness brightness);
+/**
+ * led_update_brightness - update LED brightness
+ * @led_cdev: the LED to query
+ *
+ * Get an LED's current brightness and update led_cdev->brightness
+ * member with the obtained value.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_update_brightness(struct led_classdev *led_cdev);
 
 /**
  * led_sysfs_is_locked
-- 
1.7.9.5

