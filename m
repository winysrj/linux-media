Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57200 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbaEOH4V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 May 2014 03:56:21 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 1279C2003E
	for <linux-media@vger.kernel.org>; Thu, 15 May 2014 10:56:19 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] smiapp: I2C address is the last part of the subdev name
Date: Thu, 15 May 2014 10:56:42 +0300
Message-Id: <1400140602-27282-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The I2C address of the sensor device was in the middle of the sub-device
name and not in the end as it should have been. The smiapp sub-device names
will change from e.g. "vs6555 1-0010 pixel array" to "vs6555 pixel array
1-0010".

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
This was already supposed to be fixed by "[media] smiapp: Use I2C adapter ID
and address in the sub-device name" but the I2C address indeed was in the
middle of the sub-device name and not in the end as it should have been.

 drivers/media/i2c/smiapp/smiapp-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index db3d5a6..2413d3c 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2543,9 +2543,9 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 		}
 
 		snprintf(this->sd.name,
-			 sizeof(this->sd.name), "%s %d-%4.4x %s",
-			 sensor->minfo.name, i2c_adapter_id(client->adapter),
-			 client->addr, _this->name);
+			 sizeof(this->sd.name), "%s %s %d-%4.4x",
+			 sensor->minfo.name, _this->name,
+			 i2c_adapter_id(client->adapter), client->addr);
 
 		this->sink_fmt.width =
 			sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
-- 
1.8.3.2

