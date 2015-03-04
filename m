Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:13665 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043AbbCDQPx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 11:15:53 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v12 01/19] leds: flash: Remove synchronized flash strobe
 feature
Date: Wed, 04 Mar 2015 17:14:22 +0100
Message-id: <1425485680-8417-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
References: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Synchronized flash strobe feature has been considered not fitting
for LED subsystem sysfs interface and thus is being removed.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/led-class-flash.c  |   82 ---------------------------------------
 include/linux/led-class-flash.h |   14 -------
 include/linux/leds.h            |    1 -
 3 files changed, 97 deletions(-)

diff --git a/drivers/leds/led-class-flash.c b/drivers/leds/led-class-flash.c
index 4a19fd4..3b25734 100644
--- a/drivers/leds/led-class-flash.c
+++ b/drivers/leds/led-class-flash.c
@@ -216,75 +216,6 @@ static ssize_t flash_fault_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(flash_fault);
 
-static ssize_t available_sync_leds_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
-	char *pbuf = buf;
-	int i, buf_len;
-
-	buf_len = sprintf(pbuf, "[0: none] ");
-	pbuf += buf_len;
-
-	for (i = 0; i < fled_cdev->num_sync_leds; ++i) {
-		buf_len = sprintf(pbuf, "[%d: %s] ", i + 1,
-				  fled_cdev->sync_leds[i]->led_cdev.name);
-		pbuf += buf_len;
-	}
-
-	return sprintf(buf, "%s\n", buf);
-}
-static DEVICE_ATTR_RO(available_sync_leds);
-
-static ssize_t flash_sync_strobe_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t size)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
-	unsigned long led_id;
-	ssize_t ret;
-
-	mutex_lock(&led_cdev->led_access);
-
-	if (led_sysfs_is_disabled(led_cdev)) {
-		ret = -EBUSY;
-		goto unlock;
-	}
-
-	ret = kstrtoul(buf, 10, &led_id);
-	if (ret)
-		goto unlock;
-
-	if (led_id > fled_cdev->num_sync_leds) {
-		ret = -ERANGE;
-		goto unlock;
-	}
-
-	fled_cdev->sync_led_id = led_id;
-
-	ret = size;
-unlock:
-	mutex_unlock(&led_cdev->led_access);
-	return ret;
-}
-
-static ssize_t flash_sync_strobe_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
-	int sled_id = fled_cdev->sync_led_id;
-	char *sync_led_name = "none";
-
-	if (fled_cdev->sync_led_id > 0)
-		sync_led_name = (char *)
-			fled_cdev->sync_leds[sled_id - 1]->led_cdev.name;
-
-	return sprintf(buf, "[%d: %s]\n", sled_id, sync_led_name);
-}
-static DEVICE_ATTR_RW(flash_sync_strobe);
-
 static struct attribute *led_flash_strobe_attrs[] = {
 	&dev_attr_flash_strobe.attr,
 	NULL,
@@ -307,12 +238,6 @@ static struct attribute *led_flash_fault_attrs[] = {
 	NULL,
 };
 
-static struct attribute *led_flash_sync_strobe_attrs[] = {
-	&dev_attr_available_sync_leds.attr,
-	&dev_attr_flash_sync_strobe.attr,
-	NULL,
-};
-
 static const struct attribute_group led_flash_strobe_group = {
 	.attrs = led_flash_strobe_attrs,
 };
@@ -329,10 +254,6 @@ static const struct attribute_group led_flash_fault_group = {
 	.attrs = led_flash_fault_attrs,
 };
 
-static const struct attribute_group led_flash_sync_strobe_group = {
-	.attrs = led_flash_sync_strobe_attrs,
-};
-
 static void led_flash_resume(struct led_classdev *led_cdev)
 {
 	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
@@ -361,9 +282,6 @@ static void led_flash_init_sysfs_groups(struct led_classdev_flash *fled_cdev)
 	if (ops->fault_get)
 		flash_groups[num_sysfs_groups++] = &led_flash_fault_group;
 
-	if (led_cdev->flags & LED_DEV_CAP_SYNC_STROBE)
-		flash_groups[num_sysfs_groups++] = &led_flash_sync_strobe_group;
-
 	led_cdev->groups = flash_groups;
 }
 
diff --git a/include/linux/led-class-flash.h b/include/linux/led-class-flash.h
index 3b5b964..21ec91e 100644
--- a/include/linux/led-class-flash.h
+++ b/include/linux/led-class-flash.h
@@ -81,20 +81,6 @@ struct led_classdev_flash {
 
 	/* LED Flash class sysfs groups */
 	const struct attribute_group *sysfs_groups[LED_FLASH_MAX_SYSFS_GROUPS];
-
-	/* LEDs available for flash strobe synchronization */
-	struct led_classdev_flash **sync_leds;
-
-	/* Number of LEDs available for flash strobe synchronization */
-	int num_sync_leds;
-
-	/*
-	 * The identifier of the sub-led to synchronize the flash strobe with.
-	 * Identifiers start from 1, which reflects the first element from the
-	 * sync_leds array. 0 means that the flash strobe should not be
-	 * synchronized.
-	 */
-	u32 sync_led_id;
 };
 
 static inline struct led_classdev_flash *lcdev_to_flcdev(
diff --git a/include/linux/leds.h b/include/linux/leds.h
index f70f84f..351bba5 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -47,7 +47,6 @@ struct led_classdev {
 #define SET_BRIGHTNESS_ASYNC	(1 << 21)
 #define SET_BRIGHTNESS_SYNC	(1 << 22)
 #define LED_DEV_CAP_FLASH	(1 << 23)
-#define LED_DEV_CAP_SYNC_STROBE	(1 << 24)
 
 	/* Set LED brightness level */
 	/* Must not sleep, use a workqueue if needed */
-- 
1.7.9.5

