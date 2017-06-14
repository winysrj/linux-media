Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34358 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752227AbdFNJrb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 05:47:31 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org
Cc: devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org, pavel@ucw.cz
Subject: [PATCH 5/8] v4l2-flash: Flash ops aren't mandatory
Date: Wed, 14 Jun 2017 12:47:16 +0300
Message-Id: <1497433639-13101-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

None of the flash operations are not mandatory and therefore there should
be no need for the flash ops structure either. Accept NULL.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-flash-led-class.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
index 6d69119..fdb79da 100644
--- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
+++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
@@ -18,7 +18,7 @@
 #include <media/v4l2-flash-led-class.h>
 
 #define has_flash_op(v4l2_flash, op)				\
-	(v4l2_flash && v4l2_flash->ops->op)
+	(v4l2_flash && v4l2_flash->ops && v4l2_flash->ops->op)
 
 #define call_flash_op(v4l2_flash, op, arg)			\
 		(has_flash_op(v4l2_flash, op) ?			\
@@ -618,7 +618,7 @@ struct v4l2_flash *v4l2_flash_init(
 	struct v4l2_subdev *sd;
 	int ret;
 
-	if (!fled_cdev || !ops || !config)
+	if (!fled_cdev || !config)
 		return ERR_PTR(-EINVAL);
 
 	led_cdev = &fled_cdev->led_cdev;
-- 
2.1.4
