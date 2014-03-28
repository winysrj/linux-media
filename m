Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23406 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbaC1Ofq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 10:35:46 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id D3D4B20305
	for <linux-media@vger.kernel.org>; Fri, 28 Mar 2014 16:35:43 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/3] smiapp: Use I2C adapter ID and address in the sub-device name
Date: Fri, 28 Mar 2014 16:35:11 +0200
Message-Id: <1396017313-3990-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1396017313-3990-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1396017313-3990-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sub-device names should be unique. Should two identical sensors be
present in the same media device they would be indistinguishable. The names
will change e.g. from "vs6555 pixel array" to "vs6555 1-0010 pixel array".

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 8741cae..69c11ec 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2543,8 +2543,9 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 		}
 
 		snprintf(this->sd.name,
-			 sizeof(this->sd.name), "%s %s",
-			 sensor->minfo.name, _this->name);
+			 sizeof(this->sd.name), "%s %d-%4.4x %s",
+			 sensor->minfo.name, i2c_adapter_id(client->adapter),
+			 client->addr, _this->name);
 
 		this->sink_fmt.width =
 			sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
-- 
1.8.3.2

