Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51484 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157AbaDWTdh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 15:33:37 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id CA2C1207B0
	for <linux-media@vger.kernel.org>; Wed, 23 Apr 2014 22:33:33 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/3] smiapp: Print the index of the format descriptor
Date: Wed, 23 Apr 2014 22:33:57 +0300
Message-Id: <1398281639-15839-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1398281639-15839-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1398281639-15839-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes constructing quirks easier.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 3af8df8..da4422e 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -741,8 +741,8 @@ static int smiapp_get_mbus_formats(struct smiapp_sensor *sensor)
 		if (rval)
 			return rval;
 
-		dev_dbg(&client->dev, "bpp %d, compressed %d\n",
-			fmt >> 8, (u8)fmt);
+		dev_dbg(&client->dev, "%u: bpp %u, compressed %u\n",
+			i, fmt >> 8, (u8)fmt);
 
 		for (j = 0; j < ARRAY_SIZE(smiapp_csi_data_formats); j++) {
 			const struct smiapp_csi_data_format *f =
-- 
1.8.3.2

