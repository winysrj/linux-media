Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:49156 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbaGKOEp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 10:04:45 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v4 04/21] leds: Reorder include directives
Date: Fri, 11 Jul 2014 16:04:07 +0200
Message-id: <1405087464-13762-5-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reorder include directives so that they are arranged
in alphabetical order.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/led-class.c |   13 +++++++------
 drivers/leds/led-core.c  |    3 ++-
 include/linux/leds.h     |    2 +-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index da79bbb..0127783 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -9,16 +9,17 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/device.h>
+#include <linux/err.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/leds.h>
 #include <linux/list.h>
+#include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/device.h>
 #include <linux/timer.h>
-#include <linux/err.h>
-#include <linux/ctype.h>
-#include <linux/leds.h>
 #include "leds.h"
 
 static struct class *leds_class;
diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index 0ac06ed..d156fb6 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -12,10 +12,11 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/leds.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/rwsem.h>
-#include <linux/leds.h>
 #include "leds.h"
 
 DECLARE_RWSEM(leds_list_lock);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index e9b025d..1a130cc 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -14,8 +14,8 @@
 
 #include <linux/list.h>
 #include <linux/mutex.h>
-#include <linux/spinlock.h>
 #include <linux/rwsem.h>
+#include <linux/spinlock.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 
-- 
1.7.9.5

