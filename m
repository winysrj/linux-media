Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39434 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752049AbdJZHzK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 03:55:10 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v16 30/32] ov5670: Add support for flash and lens devices
Date: Thu, 26 Oct 2017 10:53:40 +0300
Message-Id: <20171026075342.5760-31-sakari.ailus@linux.intel.com>
In-Reply-To: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse async sub-devices related to the sensor by switching the async
sub-device registration function.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ov5670.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5670.c b/drivers/media/i2c/ov5670.c
index a65469f88e36..9f9196568eb8 100644
--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -2529,7 +2529,7 @@ static int ov5670_probe(struct i2c_client *client)
 	}
 
 	/* Async register for subdev */
-	ret = v4l2_async_register_subdev(&ov5670->sd);
+	ret = v4l2_async_register_subdev_sensor_common(&ov5670->sd);
 	if (ret < 0) {
 		err_msg = "v4l2_async_register_subdev() error";
 		goto error_entity_cleanup;
-- 
2.11.0
