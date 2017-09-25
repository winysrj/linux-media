Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49566 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934287AbdIYWZ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 18:25:59 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v14 26/28] ov5670: Add support for flash and lens devices
Date: Tue, 26 Sep 2017 01:25:38 +0300
Message-Id: <20170925222540.371-28-sakari.ailus@linux.intel.com>
In-Reply-To: <20170925222540.371-1-sakari.ailus@linux.intel.com>
References: <20170925222540.371-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse async sub-devices related to the sensor by switching the async
sub-device registration function.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov5670.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5670.c b/drivers/media/i2c/ov5670.c
index 6f7a1d6d2200..0a1723f5a66c 100644
--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -2514,7 +2514,7 @@ static int ov5670_probe(struct i2c_client *client)
 	}
 
 	/* Async register for subdev */
-	ret = v4l2_async_register_subdev(&ov5670->sd);
+	ret = v4l2_async_register_subdev_sensor_common(&ov5670->sd);
 	if (ret < 0) {
 		err_msg = "v4l2_async_register_subdev() error";
 		goto error_entity_cleanup;
-- 
2.11.0
