Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41256 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbaDNJA6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 05:00:58 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id A0AFE209A7
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:00:53 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 05/21] smiapp: Use I2C adapter ID and address in the sub-device name
Date: Mon, 14 Apr 2014 11:58:30 +0300
Message-Id: <1397465926-29724-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
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

