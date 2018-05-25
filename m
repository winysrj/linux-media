Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52870 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933110AbeEYNlD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 09:41:03 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, andy.yeh@intel.com,
        sebastian.reichel@collabora.co.uk
Subject: [PATCH v2.1 2/2] smiapp: Support the "rotation" property
Date: Fri, 25 May 2018 16:40:55 +0300
Message-Id: <20180525134055.11121-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20180525122726.3409-3-sakari.ailus@linux.intel.com>
References: <20180525122726.3409-3-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the "rotation" property to tell that the sensor is mounted upside
down. This reverses the behaviour of the VFLIP and HFLIP controls as well
as the pixel order.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
since v2:

- Fix the property name in the commit message

 .../devicetree/bindings/media/i2c/nokia,smia.txt         |  2 ++
 drivers/media/i2c/smiapp/smiapp-core.c                   | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
index 33f10a94c381..6f509657470e 100644
--- a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
+++ b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
@@ -29,6 +29,8 @@ Optional properties
 - reset-gpios: XSHUTDOWN GPIO
 - flash-leds: See ../video-interfaces.txt
 - lens-focus: See ../video-interfaces.txt
+- rotation: Integer property; valid values are 0 (sensor mounted upright)
+	    and 180 (sensor mounted upside down).
 
 
 Endpoint node mandatory properties
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index e1f8208581aa..32286df6ab43 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2764,6 +2764,7 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 	struct v4l2_fwnode_endpoint *bus_cfg;
 	struct fwnode_handle *ep;
 	struct fwnode_handle *fwnode = dev_fwnode(dev);
+	u32 rotation;
 	int i;
 	int rval;
 
@@ -2800,6 +2801,21 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 
 	dev_dbg(dev, "lanes %u\n", hwcfg->lanes);
 
+	rval = fwnode_property_read_u32(fwnode, "upside-down", &rotation);
+	if (!rval) {
+		switch (rotation) {
+		case 180:
+			hwcfg->module_board_orient =
+				SMIAPP_MODULE_BOARD_ORIENT_180;
+			/* Fall through */
+		case 0:
+			break;
+		default:
+			dev_err(dev, "invalid rotation %u\n", rotation);
+			goto out_err;
+		}
+	}
+
 	/* NVM size is not mandatory */
 	fwnode_property_read_u32(fwnode, "nokia,nvm-size", &hwcfg->nvm_size);
 
-- 
2.11.0
