Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45512 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753467AbdIRKXx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 06:23:53 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-leds@vger.kernel.org
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        pavel@ucw.cz
Subject: [RESEND PATCH v2 6/6] as3645a: Unregister indicator LED on device unbind
Date: Mon, 18 Sep 2017 13:23:49 +0300
Message-Id: <20170918102349.8935-7-sakari.ailus@linux.intel.com>
In-Reply-To: <20170918102349.8935-1-sakari.ailus@linux.intel.com>
References: <20170918102349.8935-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The indicator LED was registered in probe but was not removed in driver
remove callback. Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/leds/leds-as3645a.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/leds-as3645a.c b/drivers/leds/leds-as3645a.c
index edeb0a499f6c..9494ba26c64b 100644
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
