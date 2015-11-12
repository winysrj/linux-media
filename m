Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34564 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903AbbKLJCG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 04:02:06 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Tommi Franttila <tommi.franttila@intel.com>
Subject: [PATCH v2 1/1] v4l2-device: Don't unregister ACPI/Device Tree based devices
Date: Thu, 12 Nov 2015 11:01:07 +0200
Message-Id: <1447318867-20537-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <564348C1.1050503@xs4all.nl>
References: <564348C1.1050503@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tommi Franttila <tommi.franttila@intel.com>

When a V4L2 sub-device backed by a DT or ACPI based device was removed,
the device was unregistered as well which certainly was not intentional,
as the client device would not be re-created by simply reinstating the
V4L2 sub-device (indeed the device would have to be there first!).

Skip unregistering the device in case it has non-NULL of_node or fwnode.

Signed-off-by: Tommi Franttila <tommi.franttila@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---

Hi Hans,

Thanks for the comment! How about this one?

Regards,
Sakari

 drivers/media/v4l2-core/v4l2-device.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 5b0a30b..7129e43 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -118,11 +118,20 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev)
 		if (sd->flags & V4L2_SUBDEV_FL_IS_I2C) {
 			struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-			/* We need to unregister the i2c client explicitly.
-			   We cannot rely on i2c_del_adapter to always
-			   unregister clients for us, since if the i2c bus
-			   is a platform bus, then it is never deleted. */
-			if (client)
+			/*
+			 * We need to unregister the i2c client
+			 * explicitly. We cannot rely on
+			 * i2c_del_adapter to always unregister
+			 * clients for us, since if the i2c bus is a
+			 * platform bus, then it is never deleted.
+			 *
+			 * Device tree or ACPI based devices must not
+			 * be unregistered as they have not been
+			 * registered by us, and would not be
+			 * re-created by just probing the V4L2 driver.
+			 */
+			if (client &&
+			    !client->dev.of_node && !client->dev.fwnode)
 				i2c_unregister_device(client);
 			continue;
 		}
@@ -131,7 +140,7 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev)
 		if (sd->flags & V4L2_SUBDEV_FL_IS_SPI) {
 			struct spi_device *spi = v4l2_get_subdevdata(sd);
 
-			if (spi)
+			if (spi && !spi->dev.of_node && !spi->dev.fwnode)
 				spi_unregister_device(spi);
 			continue;
 		}
-- 
2.1.0.231.g7484e3b

