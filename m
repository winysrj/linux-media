Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35804 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751294AbeEBVbR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 17:31:17 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, andy.yeh@intel.com
Subject: [PATCH 2/2] smiapp: Support the "upside-down" property
Date: Thu,  3 May 2018 00:31:15 +0300
Message-Id: <20180502213115.24000-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20180502213115.24000-1-sakari.ailus@linux.intel.com>
References: <20180502213115.24000-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the "upside-down" property to tell that the sensor is mounted upside
down. This reverses the behaviour of the VFLIP and HFLIP controls as well
as the pixel order.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/devicetree/bindings/media/i2c/nokia,smia.txt | 2 ++
 drivers/media/i2c/smiapp/smiapp-core.c                     | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
index 33f10a94c381..c824cd7025b3 100644
--- a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
+++ b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
@@ -29,6 +29,8 @@ Optional properties
 - reset-gpios: XSHUTDOWN GPIO
 - flash-leds: See ../video-interfaces.txt
 - lens-focus: See ../video-interfaces.txt
+- upside-down: A boolean property. Tells that the sensor is mounted upside
+  down.
 
 
 Endpoint node mandatory properties
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 3b7ace395ee6..5bc91b5a5998 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2801,6 +2801,9 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 
 	dev_dbg(dev, "lanes %u\n", hwcfg->lanes);
 
+	if (fwnode_property_read_bool(fwnode, "upside-down"))
+		hwcfg->module_board_orient = SMIAPP_MODULE_BOARD_ORIENT_180;
+
 	/* NVM size is not mandatory */
 	fwnode_property_read_u32(fwnode, "nokia,nvm-size", &hwcfg->nvm_size);
 
-- 
2.11.0
