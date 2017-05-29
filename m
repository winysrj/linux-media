Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42572 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750946AbdE2JWj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 05:22:39 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 1/1] v4l: fwnode: Use correct argument type for nop v4l2_flash_init()
Date: Mon, 29 May 2017 12:22:33 +0300
Message-Id: <1496049753-16833-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The device_node -> fwnode change didn't reach the nop implementation of
v4l2_flash_init(), do that change now.

Fixes: ("v4l: flash led class: Use fwnode_handle instead of device_node in init")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/v4l2-flash-led-class.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/v4l2-flash-led-class.h b/include/media/v4l2-flash-led-class.h
index 5695853..f9dcd54 100644
--- a/include/media/v4l2-flash-led-class.h
+++ b/include/media/v4l2-flash-led-class.h
@@ -138,7 +138,7 @@ void v4l2_flash_release(struct v4l2_flash *v4l2_flash);
 
 #else
 static inline struct v4l2_flash *v4l2_flash_init(
-	struct device *dev, struct device_node *of_node,
+	struct device *dev, struct fwnode_handle *fwn,
 	struct led_classdev_flash *fled_cdev,
 	struct led_classdev_flash *iled_cdev,
 	const struct v4l2_flash_ops *ops,
-- 
2.1.4
