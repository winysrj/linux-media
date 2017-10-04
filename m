Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40320 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751326AbdJDVvC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 17:51:02 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v15 28/32] smiapp: Add support for flash and lens devices
Date: Thu,  5 Oct 2017 00:50:47 +0300
Message-Id: <20171004215051.13385-29-sakari.ailus@linux.intel.com>
In-Reply-To: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse async sub-devices related to the sensor by switching the async
sub-device registration function.

These types devices aren't directly related to the sensor, but are
nevertheless handled by the smiapp driver due to the relationship of these
component to the main part of the camera module --- the sensor.

This does not yet address providing the user space with information on how
to associate the sensor or lens devices but the kernel now has the
necessary information to do that.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 700f433261d0..3d9a251ca825 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -3092,7 +3092,7 @@ static int smiapp_probe(struct i2c_client *client,
 	if (rval < 0)
 		goto out_media_entity_cleanup;
 
-	rval = v4l2_async_register_subdev(&sensor->src->sd);
+	rval = v4l2_async_register_subdev_sensor_common(&sensor->src->sd);
 	if (rval < 0)
 		goto out_media_entity_cleanup;
 
-- 
2.11.0
