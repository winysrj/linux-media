Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46558 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754885AbeFNM3n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 08:29:43 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org
Subject: [PATCH v3 2/2] smiapp: Support the "rotation" property
Date: Thu, 14 Jun 2018 15:29:39 +0300
Message-Id: <20180614122939.21257-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20180614122939.21257-1-sakari.ailus@linux.intel.com>
References: <20180614122939.21257-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the "rotation" property to tell that the sensor is mounted upside
down. This reverses the behaviour of the VFLIP and HFLIP controls as well
as the pixel order.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index e1f8208581aa..e9e0f21efc2a 100644
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
 
+	rval = fwnode_property_read_u32(fwnode, "rotation", &rotation);
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
