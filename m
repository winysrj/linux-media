Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42336 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751868AbdIVJcl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 05:32:41 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com
Cc: linux-media@vger.kernel.org, devicetree@kernel.org
Subject: [PATCH v3 4/4] as3645a: Unregister indicator LED on device unbind
Date: Fri, 22 Sep 2017 12:32:38 +0300
Message-Id: <20170922093238.13070-5-sakari.ailus@linux.intel.com>
In-Reply-To: <20170922093238.13070-1-sakari.ailus@linux.intel.com>
References: <20170922093238.13070-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The indicator LED was registered in probe but was not removed in driver
remove callback. Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/leds/leds-as3645a.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/leds-as3645a.c b/drivers/leds/leds-as3645a.c
index 605e0c64e974..9a257f969300 100644
--- a/drivers/leds/leds-as3645a.c
+++ b/drivers/leds/leds-as3645a.c
@@ -743,6 +743,7 @@ static int as3645a_remove(struct i2c_client *client)
 	as3645a_set_control(flash, AS_MODE_EXT_TORCH, false);
 
 	v4l2_flash_release(flash->vf);
+	v4l2_flash_release(flash->vfind);
 
 	led_classdev_flash_unregister(&flash->fled);
 	led_classdev_unregister(&flash->iled_cdev);
-- 
2.11.0
