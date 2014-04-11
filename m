Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:13604 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbaDKO53 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 10:57:29 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com,
	kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v3 1/5] leds: Add sysfs and kernel internal API for flash
 LEDs
Date: Fri, 11 Apr 2014 16:56:52 +0200
Message-id: <1397228216-6657-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
References: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some LED devices support two operation modes - torch and
flash. This patch provides support for flash LED devices
in the LED subsystem by introducing new sysfs attributes
and kernel internal interface. The attributes being
introduced are: flash_brightness, flash_strobe, flash_timeout,
max_flash_timeout, max_flash_brightness, flash_fault and
optional external_strobe, indicator_brightness and
max_indicator_btightness. All the flash related features
are placed in a separate module.
The modifications aim to be compatible with V4L2 framework
requirements related to the flash devices management. The
design assumes that V4L2 sub-device can take of the LED class
device control and communicate with it through the kernel
internal interface. When V4L2 Flash sub-device file is
opened, the LED class device sysfs interface is made
unavailable.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/Kconfig        |    8 +
 drivers/leds/Makefile       |    1 +
 drivers/leds/led-class.c    |   36 ++-
 drivers/leds/led-flash.c    |  627 +++++++++++++++++++++++++++++++++++++++++++
 drivers/leds/led-triggers.c |   16 +-
 drivers/leds/leds.h         |    6 +
 include/linux/leds.h        |   50 +++-
 include/linux/leds_flash.h  |  252 +++++++++++++++++
 8 files changed, 982 insertions(+), 14 deletions(-)
 create mode 100644 drivers/leds/led-flash.c
 create mode 100644 include/linux/leds_flash.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 2062682..1e1c81f 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -19,6 +19,14 @@ config LEDS_CLASS
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
 
+config LEDS_CLASS_FLASH
+	tristate "Flash LEDs Support"
+	depends on LEDS_CLASS
+	help
+	  This option enables support for flash LED devices. Say Y if you
+	  want to use flash specific features of a LED device, if they
+	  are supported.
+
 comment "LED drivers"
 
 config LEDS_88PM860X
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 3cd76db..8861b86 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -2,6 +2,7 @@
 # LED Core
 obj-$(CONFIG_NEW_LEDS)			+= led-core.o
 obj-$(CONFIG_LEDS_CLASS)		+= led-class.o
+obj-$(CONFIG_LEDS_CLASS_FLASH)		+= led-flash.o
 obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
 
 # LED Platform Drivers
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index f37d63c..58f16c3 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -9,15 +9,16 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/device.h>
+#include <linux/err.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/device.h>
 #include <linux/timer.h>
-#include <linux/err.h>
-#include <linux/ctype.h>
 #include <linux/leds.h>
 #include "leds.h"
 
@@ -45,28 +46,38 @@ static ssize_t brightness_store(struct device *dev,
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	unsigned long state;
-	ssize_t ret = -EINVAL;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
 
 	ret = kstrtoul(buf, 10, &state);
 	if (ret)
-		return ret;
+		goto unlock;
 
 	if (state == LED_OFF)
 		led_trigger_remove(led_cdev);
 	__led_set_brightness(led_cdev, state);
+	ret = size;
 
-	return size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
 }
 static DEVICE_ATTR_RW(brightness);
 
-static ssize_t led_max_brightness_show(struct device *dev,
+static ssize_t max_brightness_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%u\n", led_cdev->max_brightness);
 }
-static DEVICE_ATTR(max_brightness, 0444, led_max_brightness_show, NULL);
+static DEVICE_ATTR_RO(max_brightness);
 
 #ifdef CONFIG_LEDS_TRIGGERS
 static DEVICE_ATTR(trigger, 0644, led_trigger_show, led_trigger_store);
@@ -174,6 +185,8 @@ EXPORT_SYMBOL_GPL(led_classdev_suspend);
 void led_classdev_resume(struct led_classdev *led_cdev)
 {
 	led_cdev->brightness_set(led_cdev, led_cdev->brightness);
+	if (led_cdev->flash_resume)
+		led_cdev->flash_resume(led_cdev);
 	led_cdev->flags &= ~LED_SUSPENDED;
 }
 EXPORT_SYMBOL_GPL(led_classdev_resume);
@@ -218,6 +231,7 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 #ifdef CONFIG_LEDS_TRIGGERS
 	init_rwsem(&led_cdev->trigger_lock);
 #endif
+	mutex_init(&led_cdev->led_lock);
 	/* add to the list of leds */
 	down_write(&leds_list_lock);
 	list_add_tail(&led_cdev->node, &leds_list);
@@ -271,6 +285,8 @@ void led_classdev_unregister(struct led_classdev *led_cdev)
 	down_write(&leds_list_lock);
 	list_del(&led_cdev->node);
 	up_write(&leds_list_lock);
+
+	mutex_destroy(&led_cdev->led_lock);
 }
 EXPORT_SYMBOL_GPL(led_classdev_unregister);
 
diff --git a/drivers/leds/led-flash.c b/drivers/leds/led-flash.c
new file mode 100644
index 0000000..9d482a4
--- /dev/null
+++ b/drivers/leds/led-flash.c
@@ -0,0 +1,627 @@
+/*
+ * LED Class Flash interface
+ *
+ * Copyright (C) 2014 Samsung Electronics Co., Ltd.
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/leds.h>
+#include <linux/leds_flash.h>
+#include "leds.h"
+
+static ssize_t flash_brightness_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long state;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		goto unlock;
+
+	ret = led_set_flash_brightness(led_cdev, state);
+	if (ret < 0)
+		goto unlock;
+
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t flash_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_flash *flash = led_cdev->flash;
+
+	/* no lock needed for this */
+	led_update_flash_brightness(led_cdev);
+
+	return sprintf(buf, "%u\n", flash->brightness.val);
+}
+static DEVICE_ATTR_RW(flash_brightness);
+
+static ssize_t max_flash_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_flash *flash = led_cdev->flash;
+
+	return sprintf(buf, "%u\n", flash->brightness.max);
+}
+static DEVICE_ATTR_RO(max_flash_brightness);
+
+static ssize_t indicator_brightness_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long state;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		goto unlock;
+
+	ret = led_set_indicator_brightness(led_cdev, state);
+	if (ret < 0)
+		goto unlock;
+
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t indicator_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_flash *flash = led_cdev->flash;
+
+	/* no lock needed for this */
+	led_update_indicator_brightness(led_cdev);
+
+	return sprintf(buf, "%u\n", flash->indicator_brightness->val);
+}
+static DEVICE_ATTR_RW(indicator_brightness);
+
+static ssize_t max_indicator_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_flash *flash = led_cdev->flash;
+
+	return sprintf(buf, "%u\n", flash->indicator_brightness->max);
+}
+static DEVICE_ATTR_RO(max_indicator_brightness);
+
+static ssize_t flash_strobe_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long state;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		goto unlock;
+
+	if (state < 0 || state > 1)
+		return -EINVAL;
+
+	ret = led_set_flash_strobe(led_cdev, state);
+	if (ret < 0)
+		goto unlock;
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t flash_strobe_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	int ret;
+
+	/* no lock needed for this */
+	ret = led_get_flash_strobe(led_cdev);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%u\n", ret);
+}
+static DEVICE_ATTR_RW(flash_strobe);
+
+static ssize_t flash_timeout_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long flash_timeout;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &flash_timeout);
+	if (ret)
+		goto unlock;
+
+	ret = led_set_flash_timeout(led_cdev, flash_timeout);
+	if (ret < 0)
+		goto unlock;
+
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t flash_timeout_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_flash *flash = led_cdev->flash;
+
+	return sprintf(buf, "%d\n", flash->timeout.val);
+}
+static DEVICE_ATTR_RW(flash_timeout);
+
+static ssize_t max_flash_timeout_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_flash *flash = led_cdev->flash;
+
+	return sprintf(buf, "%d\n", flash->timeout.max);
+}
+static DEVICE_ATTR_RO(max_flash_timeout);
+
+static ssize_t flash_fault_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned int fault;
+	int ret;
+
+	ret = led_get_flash_fault(led_cdev, &fault);
+	if (ret < 0)
+		return -EINVAL;
+
+	return sprintf(buf, "0x%8.8x\n", fault);
+}
+static DEVICE_ATTR_RO(flash_fault);
+
+static ssize_t external_strobe_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long external_strobe;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &external_strobe);
+	if (ret)
+		goto unlock;
+
+	if (external_strobe > 1) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	ret = led_set_external_strobe(led_cdev, external_strobe);
+	if (ret < 0)
+		goto unlock;
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t external_strobe_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u\n", led_cdev->flash->external_strobe);
+}
+static DEVICE_ATTR_RW(external_strobe);
+
+static struct attribute *led_flash_attrs[] = {
+	&dev_attr_flash_brightness.attr,
+	&dev_attr_flash_strobe.attr,
+	&dev_attr_flash_timeout.attr,
+	&dev_attr_max_flash_timeout.attr,
+	&dev_attr_max_flash_brightness.attr,
+	&dev_attr_flash_fault.attr,
+	NULL,
+};
+
+static struct attribute *led_flash_indicator_attrs[] = {
+	&dev_attr_indicator_brightness.attr,
+	&dev_attr_max_indicator_brightness.attr,
+	NULL,
+};
+
+static struct attribute *led_flash_external_strobe_attrs[] = {
+	&dev_attr_external_strobe.attr,
+	NULL,
+};
+
+static struct attribute_group led_flash_group = {
+	.attrs = led_flash_attrs,
+};
+
+static struct attribute_group led_flash_indicator_group = {
+	.attrs = led_flash_indicator_attrs,
+};
+
+static struct attribute_group led_flash_external_strobe_group = {
+	.attrs = led_flash_external_strobe_attrs,
+};
+
+void led_flash_resume(struct led_classdev *led_cdev)
+{
+	struct led_flash *flash = led_cdev->flash;
+
+	call_flash_op(brightness_set, led_cdev,
+				flash->brightness.val);
+	call_flash_op(timeout_set, led_cdev,
+				flash->timeout.val);
+	if (has_flash_op(indicator_brightness_set))
+		call_flash_op(indicator_brightness_set, led_cdev,
+				flash->indicator_brightness->val);
+}
+
+#ifdef CONFIG_V4L2_FLASH
+static const struct v4l2_flash_ops v4l2_flash_ops = {
+	.brightness_set = led_set_brightness,
+	.brightness_update = led_update_brightness,
+	.flash_brightness_set = led_set_flash_brightness,
+	.flash_brightness_update = led_update_flash_brightness,
+	.indicator_brightness_set = led_set_indicator_brightness,
+	.indicator_brightness_update = led_update_indicator_brightness,
+	.strobe_set = led_set_flash_strobe,
+	.strobe_get = led_get_flash_strobe,
+	.timeout_set = led_set_flash_timeout,
+	.external_strobe_set = led_set_external_strobe,
+	.fault_get = led_get_flash_fault,
+	.sysfs_lock = led_sysfs_lock,
+	.sysfs_unlock = led_sysfs_unlock,
+};
+#define V4L2_FLASH_OPS (&v4l2_flash_ops)
+#else
+#define V4L2_FLASH_OPS NULL
+#endif
+
+
+void led_flash_remove_sysfs_groups(struct led_classdev *led_cdev)
+{
+	struct led_flash *flash = led_cdev->flash;
+	int i;
+
+	for (i = 0; i < LED_FLASH_MAX_SYSFS_GROUPS; ++i)
+		if (flash->sysfs_groups[i])
+			sysfs_remove_group(&led_cdev->dev->kobj,
+						flash->sysfs_groups[i]);
+}
+
+int led_flash_create_sysfs_groups(struct led_classdev *led_cdev)
+{
+	struct led_flash *flash = led_cdev->flash;
+	int ret, num_sysfs_groups = 0;
+
+	memset(flash->sysfs_groups, 0, sizeof(*flash->sysfs_groups) *
+						LED_FLASH_MAX_SYSFS_GROUPS);
+
+	ret = sysfs_create_group(&led_cdev->dev->kobj, &led_flash_group);
+	if (ret < 0)
+		goto err_create_group;
+	flash->sysfs_groups[num_sysfs_groups++] = &led_flash_group;
+
+	if (flash->indicator_brightness) {
+		ret = sysfs_create_group(&led_cdev->dev->kobj,
+					&led_flash_indicator_group);
+		if (ret < 0)
+			goto err_create_group;
+		flash->sysfs_groups[num_sysfs_groups++] =
+					&led_flash_indicator_group;
+	}
+	if (flash->has_external_strobe) {
+		ret = sysfs_create_group(&led_cdev->dev->kobj,
+					&led_flash_external_strobe_group);
+		if (ret < 0)
+			goto err_create_group;
+		flash->sysfs_groups[num_sysfs_groups++] =
+					&led_flash_external_strobe_group;
+	}
+
+	return 0;
+
+err_create_group:
+	led_flash_remove_sysfs_groups(led_cdev);
+	return ret;
+}
+
+int led_classdev_flash_register(struct device *parent,
+				struct led_classdev *led_cdev)
+{
+	struct led_flash *flash = led_cdev->flash;
+	const struct led_flash_ops *ops;
+	int ret;
+
+	if (!flash)
+		return -EINVAL;
+
+	/* Register led class device */
+	ret = led_classdev_register(parent, led_cdev);
+	if (ret < 0)
+		return ret;
+
+	if (!flash->has_flash_led)
+		goto exit;
+
+	/* Validate flash related ops */
+	ops = &flash->ops;
+	if (!ops || !ops->brightness_set || !ops->strobe_set || !ops->strobe_get
+		|| !ops->timeout_set || !ops->fault_get)
+		return -EINVAL;
+
+	if (flash->has_external_strobe && !ops->external_strobe_set)
+		return -EINVAL;
+
+	if (flash->indicator_brightness && !ops->indicator_brightness_set)
+		return -EINVAL;
+
+	/* Install resume callback for flash controls */
+	led_cdev->flash_resume = led_flash_resume;
+
+	/* Create flash led specific sysfs attributes */
+	ret = led_flash_create_sysfs_groups(led_cdev);
+	if (ret < 0)
+		goto err_create_groups;
+
+exit:
+	/* This will create V4L2 Flash sub-device if it is enabled */
+	ret = v4l2_flash_init(led_cdev, V4L2_FLASH_OPS);
+	if (ret < 0)
+		goto err_create_groups;
+
+	return 0;
+
+err_create_groups:
+	led_classdev_unregister(led_cdev);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_classdev_flash_register);
+
+void led_classdev_flash_unregister(struct led_classdev *led_cdev)
+{
+	v4l2_flash_release(led_cdev);
+	led_flash_remove_sysfs_groups(led_cdev);
+	led_classdev_unregister(led_cdev);
+}
+EXPORT_SYMBOL_GPL(led_classdev_flash_unregister);
+
+/* Caller must ensure led_cdev->led_lock held */
+void led_sysfs_lock(struct led_classdev *led_cdev)
+{
+	led_cdev->flags |= LED_SYSFS_LOCK;
+}
+EXPORT_SYMBOL(led_sysfs_lock);
+
+/* Caller must ensure led_cdev->led_lock held */
+void led_sysfs_unlock(struct led_classdev *led_cdev)
+{
+	led_cdev->flags &= ~LED_SYSFS_LOCK;
+}
+EXPORT_SYMBOL(led_sysfs_unlock);
+
+int led_set_flash_strobe(struct led_classdev *led_cdev, bool state)
+{
+	if (!has_flash_op(strobe_set))
+		return -EINVAL;
+
+	return call_flash_op(strobe_set, led_cdev, state);
+}
+EXPORT_SYMBOL(led_set_flash_strobe);
+
+int led_get_flash_strobe(struct led_classdev *led_cdev)
+{
+	if (!has_flash_op(strobe_get))
+		return -EINVAL;
+
+	return call_flash_op(strobe_get, led_cdev);
+}
+EXPORT_SYMBOL(led_get_flash_strobe);
+
+void led_clamp_align_val(struct led_ctrl *c)
+{
+	u32 v, offset;
+
+	v = c->val + c->step / 2;
+	v = clamp(v, c->min, c->max);
+	offset = v - c->min;
+	offset = c->step * (offset / c->step);
+	c->val = c->min + offset;
+}
+
+int led_set_flash_timeout(struct led_classdev *led_cdev, u32 timeout)
+{
+	struct led_flash *flash = led_cdev->flash;
+	struct led_ctrl *c = &flash->timeout;
+	int ret = 0;
+
+	if (!has_flash_op(timeout_set))
+		return -EINVAL;
+
+	c->val = timeout;
+	led_clamp_align_val(c);
+
+	if (!(led_cdev->flags & LED_SUSPENDED))
+		ret = call_flash_op(timeout_set, led_cdev, c->val);
+
+	return ret;
+}
+EXPORT_SYMBOL(led_set_flash_timeout);
+
+int led_get_flash_fault(struct led_classdev *led_cdev, u32 *fault)
+{
+	if (!has_flash_op(fault_get))
+		return -EINVAL;
+
+	return call_flash_op(fault_get, led_cdev, fault);
+}
+EXPORT_SYMBOL(led_get_flash_fault);
+
+int led_set_external_strobe(struct led_classdev *led_cdev, bool enable)
+{
+	struct led_flash *flash = led_cdev->flash;
+	int ret;
+
+	if (!has_flash_op(external_strobe_set))
+		return -EINVAL;
+
+	if (flash->has_external_strobe) {
+		ret = call_flash_op(external_strobe_set, led_cdev, enable);
+		if (ret < 0)
+			return -EINVAL;
+		flash->external_strobe = enable;
+	} else if (enable)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(led_set_external_strobe);
+
+int led_set_flash_brightness(struct led_classdev *led_cdev,
+				u32 brightness)
+{
+	struct led_flash *flash = led_cdev->flash;
+	struct led_ctrl *c = &flash->brightness;
+	int ret = 0;
+
+	if (!has_flash_op(brightness_set))
+		return -EINVAL;
+
+	c->val = brightness;
+	led_clamp_align_val(c);
+
+	if (!(led_cdev->flags & LED_SUSPENDED))
+		ret = call_flash_op(brightness_set, led_cdev, c->val);
+	return ret;
+}
+EXPORT_SYMBOL(led_set_flash_brightness);
+
+int led_update_flash_brightness(struct led_classdev *led_cdev)
+{
+	struct led_flash *flash = led_cdev->flash;
+	struct led_ctrl *c = &flash->brightness;
+	u32 brightness;
+	int ret = 0;
+
+	if (has_flash_op(brightness_get)) {
+		ret = call_flash_op(brightness_get, led_cdev, &brightness);
+		if (ret < 0)
+			return ret;
+		c->val = brightness;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(led_update_flash_brightness);
+
+int led_set_indicator_brightness(struct led_classdev *led_cdev,
+					u32 brightness)
+{
+	struct led_flash *flash = led_cdev->flash;
+	struct led_ctrl *c = flash->indicator_brightness;
+	int ret = 0;
+
+	if (!has_flash_op(indicator_brightness_set))
+		return -EINVAL;
+
+	c->val = brightness;
+	led_clamp_align_val(c);
+
+	if (!(led_cdev->flags & LED_SUSPENDED))
+		ret = call_flash_op(indicator_brightness_set, led_cdev, c->val);
+
+	return ret;
+}
+EXPORT_SYMBOL(led_set_indicator_brightness);
+
+int led_update_indicator_brightness(struct led_classdev *led_cdev)
+{
+	struct led_flash *flash = led_cdev->flash;
+	struct led_ctrl *c = flash->indicator_brightness;
+	u32 brightness;
+	int ret = 0;
+
+	if (has_flash_op(indicator_brightness_get)) {
+		ret = call_flash_op(indicator_brightness_get, led_cdev,
+							&brightness);
+		if (ret < 0)
+			return ret;
+		c->val = brightness;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(led_update_indicator_brightness);
+
+static int __init leds_flash_init(void)
+{
+	return 0;
+}
+
+static void __exit leds_flash_exit(void)
+{
+}
+
+subsys_initcall(leds_flash_init);
+module_exit(leds_flash_exit);
+
+MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LED Class Flash Interface");
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index df1a7c1..40e21c0 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -37,6 +37,14 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 	char trigger_name[TRIG_NAME_MAX];
 	struct led_trigger *trig;
 	size_t len;
+	int ret = count;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto exit_unlock;
+	}
 
 	trigger_name[sizeof(trigger_name) - 1] = '\0';
 	strncpy(trigger_name, buf, sizeof(trigger_name) - 1);
@@ -47,7 +55,7 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 
 	if (!strcmp(trigger_name, "none")) {
 		led_trigger_remove(led_cdev);
-		return count;
+		goto exit_unlock;
 	}
 
 	down_read(&triggers_list_lock);
@@ -58,12 +66,14 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 			up_write(&led_cdev->trigger_lock);
 
 			up_read(&triggers_list_lock);
-			return count;
+			goto exit_unlock;
 		}
 	}
 	up_read(&triggers_list_lock);
 
-	return -EINVAL;
+exit_unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(led_trigger_store);
 
diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
index 4c50365..f66a0c3 100644
--- a/drivers/leds/leds.h
+++ b/drivers/leds/leds.h
@@ -17,6 +17,12 @@
 #include <linux/rwsem.h>
 #include <linux/leds.h>
 
+#define call_flash_op(op, args...)		\
+	((led_cdev)->flash->ops.op(args))
+
+#define has_flash_op(op)			\
+	((led_cdev)->flash && (led_cdev)->flash->ops.op)
+
 static inline void __led_set_brightness(struct led_classdev *led_cdev,
 					enum led_brightness value)
 {
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 0287ab2..a794817 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -13,12 +13,14 @@
 #define __LINUX_LEDS_H_INCLUDED
 
 #include <linux/list.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/rwsem.h>
+#include <linux/spinlock.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 
 struct device;
+struct led_flash;
 /*
  * LED Core
  */
@@ -29,6 +31,28 @@ enum led_brightness {
 	LED_FULL	= 255,
 };
 
+/*
+ * This structure is required in two cases:
+ * - it defines allowed levels of flash leds brightness and timeout
+ * - it provides initialization data for V4L2 Flash controls
+ *   when CONFIG_V4L2_FLASH is enabled and allows for proper
+ *   enum led_brightness <-> microamperes conversion for the
+ *   V4L2_CID_FLASH_TORCH_INTENSITY
+ */
+struct led_ctrl {
+	/* maximum allowed value */
+	u32 min;
+	/* maximum allowed value */
+	u32 max;
+	/* step value */
+	u32 step;
+	/*
+	 * Default value for V4L2 controls and for flash leds
+	 * it also serves for caching the value currently set.
+	 */
+	u32 val;
+};
+
 struct led_classdev {
 	const char		*name;
 	int			 brightness;
@@ -42,6 +66,7 @@ struct led_classdev {
 #define LED_BLINK_ONESHOT	(1 << 17)
 #define LED_BLINK_ONESHOT_STOP	(1 << 18)
 #define LED_BLINK_INVERT	(1 << 19)
+#define LED_SYSFS_LOCK		(1 << 21)
 
 	/* Set LED brightness level */
 	/* Must not sleep, use a workqueue if needed */
@@ -69,6 +94,17 @@ struct led_classdev {
 	unsigned long		 blink_delay_on, blink_delay_off;
 	struct timer_list	 blink_timer;
 	int			 blink_brightness;
+	struct led_flash	*flash;
+	void			(*flash_resume)(struct led_classdev *led_cdev);
+#ifdef CONFIG_V4L2_FLASH
+	/* Initialization data for the V4L2_CID_FLASH_TORCH_INTENSITY control */
+	struct led_ctrl		brightness_ctrl;
+#endif
+	/*
+	 * Ensures consistent LED sysfs access and protects
+	 * LED sysfs locking mechanism
+	 */
+	struct mutex		led_lock;
 
 	struct work_struct	set_brightness_work;
 	int			delayed_set_value;
@@ -139,6 +175,18 @@ extern void led_blink_set_oneshot(struct led_classdev *led_cdev,
 extern void led_set_brightness(struct led_classdev *led_cdev,
 			       enum led_brightness brightness);
 
+/**
+ * led_sysfs_is_locked
+ * @led_cdev: the LED to query
+ *
+ * Returns: true if the sysfs interface of the led is disabled,
+ *	    false otherwise
+ */
+static inline bool led_sysfs_is_locked(struct led_classdev *led_cdev)
+{
+	return led_cdev->flags & LED_SYSFS_LOCK;
+}
+
 /*
  * LED Triggers
  */
diff --git a/include/linux/leds_flash.h b/include/linux/leds_flash.h
new file mode 100644
index 0000000..0f885a0
--- /dev/null
+++ b/include/linux/leds_flash.h
@@ -0,0 +1,252 @@
+/*
+ * Flash leds API
+ *
+ * Copyright (C) 2014 Samsung Electronics Co., Ltd.
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#ifndef __LINUX_FLASH_LEDS_H_INCLUDED
+#define __LINUX_FLASH_LEDS_H_INCLUDED
+
+#include <media/v4l2-flash.h>
+#include <linux/leds.h>
+
+/*
+ * Supported led fault bits - must be kept in synch
+ * with V4L2_FLASH_FAULT bits.
+ */
+#define LED_FAULT_OVER_VOLTAGE		(1 << 0)
+#define LED_FAULT_TIMEOUT		(1 << 1)
+#define LED_FAULT_OVER_TEMPERATURE	(1 << 2)
+#define LED_FAULT_SHORT_CIRCUIT		(1 << 3)
+#define LED_FAULT_OVER_CURRENT		(1 << 4)
+#define LED_FAULT_INDICATOR		(1 << 5)
+#define LED_FAULT_UNDER_VOLTAGE		(1 << 6)
+#define LED_FAULT_INPUT_VOLTAGE		(1 << 7)
+#define LED_FAULT_LED_OVER_TEMPERATURE	(1 << 8)
+
+#define LED_FLASH_MAX_SYSFS_GROUPS 3
+
+struct led_flash_ops {
+	/* set flash brightness */
+	int	(*brightness_set)(struct led_classdev *led_cdev,
+					u32 brightness);
+	/* get flash brightness */
+	int (*brightness_get)(struct led_classdev *led_cdev, u32 *brightness);
+	/* set flash indicator brightness */
+	int	(*indicator_brightness_set)(struct led_classdev *led_cdev,
+					u32 brightness);
+	/* get flash indicator brightness */
+	int (*indicator_brightness_get)(struct led_classdev *led_cdev,
+					u32 *brightness);
+	/* setup flash strobe */
+	int	(*strobe_set)(struct led_classdev *led_cdev,
+					bool state);
+	/* get flash strobe state */
+	int	(*strobe_get)(struct led_classdev *led_cdev);
+	/* setup flash timeout */
+	int	(*timeout_set)(struct led_classdev *led_cdev,
+					u32 timeout);
+	/* setup strobing the flash from external source */
+	int	(*external_strobe_set)(struct led_classdev *led_cdev,
+					bool enable);
+	/* get the flash LED fault */
+	int	(*fault_get)(struct led_classdev *led_cdev,
+					u32 *fault);
+};
+
+struct led_flash {
+	/*
+	 * 1 - add support for both flash and torch leds,
+	 * 0 - handle only torch led
+	 */
+	bool		has_flash_led;
+	/* flash led specific ops */
+	const struct	led_flash_ops	ops;
+
+	/* flash sysfs groups */
+	struct	attribute_group *sysfs_groups[LED_FLASH_MAX_SYSFS_GROUPS];
+
+	/* flash brightness value in microamperes along with its constraints */
+	struct led_ctrl brightness;
+
+	/* timeout value in microseconds along with its constraints */
+	struct led_ctrl timeout;
+
+	/*
+	 * Indicator brightness value in microamperes along with
+	 * its constraints - this is an optional control and must
+	 * be allocated by the driver if the device supports privacy
+	 * indicator led.
+	 */
+	struct led_ctrl *indicator_brightness;
+
+	/*
+	 * determines whether device supports external
+	 * flash strobe sources
+	 */
+	bool		has_external_strobe;
+
+	/*
+	 * If true the device doesn't strobe the flash immediately
+	 * after writing 1 to the flash_strobe file, but waits
+	 * for an external signal.
+	 */
+	bool		external_strobe;
+
+#ifdef CONFIG_V4L2_FLASH
+	/* V4L2 Flash sub-device data */
+	struct		v4l2_flash v4l2_flash;
+
+	/* flash fault bits that may be set by the device */
+	u32 fault_flags;
+#endif
+
+};
+
+/**
+ * led_classdev_flash_register - register a new object of led_classdev class
+				 with support for flash LEDs
+ * @parent: the device to register
+ * @led_cdev: the led_classdev structure for this device
+ *
+ * Returns: 0 on success, error code on failure.
+ */
+int led_classdev_flash_register(struct device *parent,
+				struct led_classdev *led_cdev);
+
+/**
+ * led_classdev_flash_unregister - unregisters an object of led_properties class
+				 with support for flash LEDs
+ * @led_cdev: the flash led device to unregister
+ *
+ * Unregisters a previously registered via led_classdev_flash_register object
+ */
+void led_classdev_flash_unregister(struct led_classdev *led_cdev);
+
+/**
+ * led_set_flash_strobe - setup flash strobe
+ * @led_cdev: the flash LED to set strobe on
+ * @state: 1 - strobe flash, 0 - stop flash strobe
+ *
+ * Setup flash strobe - trigger flash strobe
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_set_flash_strobe(struct led_classdev *led_cdev, bool state);
+
+/**
+ * led_get_flash_strobe - get flash strobe status
+ * @led_cdev: the LED to query
+ *
+ * Check whether the flash is strobing at the moment or not.
+ *
+ * Returns: flash strobe status (0 or 1) on success or negative
+ *	    error value on failure.
+ */
+extern int led_get_flash_strobe(struct led_classdev *led_cdev);
+
+/**
+ * led_set_flash_brightness - set flash LED brightness
+ * @led_cdev: the LED to set
+ * @brightness: the brightness to set it to
+ *
+ * Returns: 0 on success, -EINVAL on failure
+ *
+ * Set a flash LED's brightness.
+ */
+extern int led_set_flash_brightness(struct led_classdev *led_cdev,
+					u32 brightness);
+
+/**
+ * led_update_flash_brightness - update flash LED brightness
+ * @led_cdev: the LED to query
+ *
+ * Get a flash LED's current brightness and update led_flash->brightness
+ * member with the obtained value.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_update_flash_brightness(struct led_classdev *led_cdev);
+
+/**
+ * led_set_flash_timeout - set flash LED timeout
+ * @led_cdev: the LED to set
+ * @timeout: the flash timeout to set it to
+ *
+ * Returns: 0 on success, -EINVAL on failure
+ *
+ * Set the flash strobe duration. The duration set by the driver
+ * is returned in the timeout argument and may differ from the
+ * one that was originally passed.
+ */
+extern int led_set_flash_timeout(struct led_classdev *led_cdev,
+					u32 timeout);
+
+/**
+ * led_get_flash_fault - get the flash LED fault
+ * @led_cdev: the LED to query
+ * @fault: bitmask containing flash faults
+ *
+ * Returns: 0 on success, -EINVAL on failure
+ *
+ * Get the flash LED fault.
+ */
+extern int led_get_flash_fault(struct led_classdev *led_cdev,
+					u32 *fault);
+
+/**
+ * led_set_external_strobe - set the flash LED external_strobe mode
+ * @led_cdev: the LED to set
+ * @enable: the state to set it to
+ *
+ * Returns: 0 on success, -EINVAL on failure
+ *
+ * Enable/disable strobing the flash LED with use of external source
+ */
+extern int led_set_external_strobe(struct led_classdev *led_cdev, bool enable);
+
+/**
+ * led_set_indicator_brightness - set indicator LED brightness
+ * @led_cdev: the LED to set
+ * @brightness: the brightness to set it to
+ *
+ * Returns: 0 on success, -EINVAL on failure
+ *
+ * Set a flash LED's brightness.
+ */
+extern int led_set_indicator_brightness(struct led_classdev *led_cdev,
+					u32 led_brightness);
+
+/**
+ * led_update_indicator_brightness - update flash indicator LED brightness
+ * @led_cdev: the LED to query
+ *
+ * Get a flash indicator LED's current brightness and update
+ * led_flash->indicator_brightness member with the obtained value.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_update_indicator_brightness(struct led_classdev *led_cdev);
+
+/**
+ * led_sysfs_lock - lock LED sysfs interface
+ * @led_cdev: the LED to set
+ *
+ * Lock the LED's sysfs interface
+ */
+extern void led_sysfs_lock(struct led_classdev *led_cdev);
+
+/**
+ * led_sysfs_unlock - unlock LED sysfs interface
+ * @led_cdev: the LED to set
+ *
+ * Unlock the LED's sysfs interface
+ */
+extern void led_sysfs_unlock(struct led_classdev *led_cdev);
+
+#endif	/* __LINUX_FLASH_LEDS_H_INCLUDED */
-- 
1.7.9.5

