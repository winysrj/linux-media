Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39630 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934328AbaDITZO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 15:25:14 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 16C3620EC7
	for <linux-media@vger.kernel.org>; Wed,  9 Apr 2014 22:24:53 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 05/17] smiapp: Use %u for printing u32 value
Date: Wed,  9 Apr 2014 22:24:57 +0300
Message-Id: <1397071509-2071-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 02041cc..3af8df8 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -606,7 +606,7 @@ static int smiapp_get_limits(struct smiapp_sensor *sensor, int const *limit,
 		if (rval)
 			return rval;
 		sensor->limits[limit[i]] = val;
-		dev_dbg(&client->dev, "0x%8.8x \"%s\" = %d, 0x%x\n",
+		dev_dbg(&client->dev, "0x%8.8x \"%s\" = %u, 0x%x\n",
 			smiapp_reg_limits[limit[i]].addr,
 			smiapp_reg_limits[limit[i]].what, val, val);
 	}
-- 
1.8.3.2

