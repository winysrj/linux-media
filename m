Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39418 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752021AbdJZHzH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 03:55:07 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v16 29/32] et8ek8: Add support for flash and lens devices
Date: Thu, 26 Oct 2017 10:53:39 +0300
Message-Id: <20171026075342.5760-30-sakari.ailus@linux.intel.com>
In-Reply-To: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse async sub-devices related to the sensor by switching the async
sub-device registration function.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/media/i2c/et8ek8/et8ek8_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/et8ek8/et8ek8_driver.c
index c14f0fd6ded3..e9eff9039ef5 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -1453,7 +1453,7 @@ static int et8ek8_probe(struct i2c_client *client,
 		goto err_mutex;
 	}
 
-	ret = v4l2_async_register_subdev(&sensor->subdev);
+	ret = v4l2_async_register_subdev_sensor_common(&sensor->subdev);
 	if (ret < 0)
 		goto err_entity;
 
-- 
2.11.0
