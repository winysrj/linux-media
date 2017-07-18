Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59676 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751431AbdGRSlJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 14:41:09 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/2] staging: greybus: light: Don't leak memory for no gain
Date: Tue, 18 Jul 2017 21:41:06 +0300
Message-Id: <20170718184107.10598-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20170718184107.10598-1-sakari.ailus@linux.intel.com>
References: <20170718184107.10598-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Memory for struct v4l2_flash_config is allocated in
gb_lights_light_v4l2_register() for no gain and yet the allocated memory is
leaked; the struct isn't used outside the function. Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/greybus/light.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/greybus/light.c b/drivers/staging/greybus/light.c
index 129ceed39829..b25c117ec41a 100644
--- a/drivers/staging/greybus/light.c
+++ b/drivers/staging/greybus/light.c
@@ -534,25 +534,21 @@ static int gb_lights_light_v4l2_register(struct gb_light *light)
 {
 	struct gb_connection *connection = get_conn_from_light(light);
 	struct device *dev = &connection->bundle->dev;
-	struct v4l2_flash_config *sd_cfg;
+	struct v4l2_flash_config sd_cfg = { 0 };
 	struct led_classdev_flash *fled;
 	struct led_classdev *iled = NULL;
 	struct gb_channel *channel_torch, *channel_ind, *channel_flash;
 	int ret = 0;
 
-	sd_cfg = kcalloc(1, sizeof(*sd_cfg), GFP_KERNEL);
-	if (!sd_cfg)
-		return -ENOMEM;
-
 	channel_torch = get_channel_from_mode(light, GB_CHANNEL_MODE_TORCH);
 	if (channel_torch)
 		__gb_lights_channel_v4l2_config(&channel_torch->intensity_uA,
-						&sd_cfg->torch_intensity);
+						&sd_cfg.torch_intensity);
 
 	channel_ind = get_channel_from_mode(light, GB_CHANNEL_MODE_INDICATOR);
 	if (channel_ind) {
 		__gb_lights_channel_v4l2_config(&channel_ind->intensity_uA,
-						&sd_cfg->indicator_intensity);
+						&sd_cfg.indicator_intensity);
 		iled = &channel_ind->fled.led_cdev;
 	}
 
@@ -561,17 +557,17 @@ static int gb_lights_light_v4l2_register(struct gb_light *light)
 
 	fled = &channel_flash->fled;
 
-	snprintf(sd_cfg->dev_name, sizeof(sd_cfg->dev_name), "%s", light->name);
+	snprintf(sd_cfg.dev_name, sizeof(sd_cfg.dev_name), "%s", light->name);
 
 	/* Set the possible values to faults, in our case all faults */
-	sd_cfg->flash_faults = LED_FAULT_OVER_VOLTAGE | LED_FAULT_TIMEOUT |
+	sd_cfg.flash_faults = LED_FAULT_OVER_VOLTAGE | LED_FAULT_TIMEOUT |
 		LED_FAULT_OVER_TEMPERATURE | LED_FAULT_SHORT_CIRCUIT |
 		LED_FAULT_OVER_CURRENT | LED_FAULT_INDICATOR |
 		LED_FAULT_UNDER_VOLTAGE | LED_FAULT_INPUT_VOLTAGE |
 		LED_FAULT_LED_OVER_TEMPERATURE;
 
 	light->v4l2_flash = v4l2_flash_init(dev, NULL, fled, iled,
-					    &v4l2_flash_ops, sd_cfg);
+					    &v4l2_flash_ops, &sd_cfg);
 	if (IS_ERR_OR_NULL(light->v4l2_flash)) {
 		ret = PTR_ERR(light->v4l2_flash);
 		goto out_free;
@@ -580,7 +576,6 @@ static int gb_lights_light_v4l2_register(struct gb_light *light)
 	return ret;
 
 out_free:
-	kfree(sd_cfg);
 	return ret;
 }
 
-- 
2.11.0
