Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:30383 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbbC0NuJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 09:50:09 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v2 02/11] leds: add uapi header file
Date: Fri, 27 Mar 2015 14:49:36 +0100
Message-id: <1427464185-27950-3-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1427464185-27950-1-git-send-email-j.anaszewski@samsung.com>
References: <1427464185-27950-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds header file for LED subsystem definitions and
declarations. The initial need for the header is allowing the
user space to discover the semantics of flash fault bits.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
---
 include/linux/led-class-flash.h |   16 +---------------
 include/uapi/linux/leds.h       |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 15 deletions(-)
 create mode 100644 include/uapi/linux/leds.h

diff --git a/include/linux/led-class-flash.h b/include/linux/led-class-flash.h
index e97966d..3cf58c4 100644
--- a/include/linux/led-class-flash.h
+++ b/include/linux/led-class-flash.h
@@ -13,25 +13,11 @@
 #define __LINUX_FLASH_LEDS_H_INCLUDED
 
 #include <linux/leds.h>
+#include <uapi/linux/leds.h>
 
 struct device_node;
 struct led_classdev_flash;
 
-/*
- * Supported led fault bits - must be kept in synch
- * with V4L2_FLASH_FAULT bits.
- */
-#define LED_FAULT_OVER_VOLTAGE		(1 << 0)
-#define LED_FAULT_TIMEOUT		(1 << 1)
-#define LED_FAULT_OVER_TEMPERATURE	(1 << 2)
-#define LED_FAULT_SHORT_CIRCUIT		(1 << 3)
-#define LED_FAULT_OVER_CURRENT		(1 << 4)
-#define LED_FAULT_INDICATOR		(1 << 5)
-#define LED_FAULT_UNDER_VOLTAGE		(1 << 6)
-#define LED_FAULT_INPUT_VOLTAGE		(1 << 7)
-#define LED_FAULT_LED_OVER_TEMPERATURE	(1 << 8)
-#define LED_NUM_FLASH_FAULTS		9
-
 #define LED_FLASH_SYSFS_GROUPS_SIZE	5
 
 struct led_flash_ops {
diff --git a/include/uapi/linux/leds.h b/include/uapi/linux/leds.h
new file mode 100644
index 0000000..f657f78
--- /dev/null
+++ b/include/uapi/linux/leds.h
@@ -0,0 +1,34 @@
+/*
+ * include/uapi/linux/leds.h
+ *
+ * LED subsystem specific definitions and declarations.
+ *
+ * Copyright (C) 2015 Samsung Electronics Co., Ltd.
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+
+#ifndef __UAPI_LINUX_LEDS_H_
+#define __UAPI_LINUX_LEDS_H_
+
+#define LED_FAULT_OVER_VOLTAGE		(1 << 0)
+#define LED_FAULT_TIMEOUT		(1 << 1)
+#define LED_FAULT_OVER_TEMPERATURE	(1 << 2)
+#define LED_FAULT_SHORT_CIRCUIT		(1 << 3)
+#define LED_FAULT_OVER_CURRENT		(1 << 4)
+#define LED_FAULT_INDICATOR		(1 << 5)
+#define LED_FAULT_UNDER_VOLTAGE		(1 << 6)
+#define LED_FAULT_INPUT_VOLTAGE		(1 << 7)
+#define LED_FAULT_LED_OVER_TEMPERATURE	(1 << 8)
+#define LED_NUM_FLASH_FAULTS		9
+
+#endif /* __UAPI_LINUX_LEDS_H_ */
-- 
1.7.9.5

