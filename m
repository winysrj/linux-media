Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27693 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757918AbaDWTeK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 15:34:10 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id E5139207B5
	for <linux-media@vger.kernel.org>; Wed, 23 Apr 2014 22:33:33 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] smiapp: Scaling goodness is signed
Date: Wed, 23 Apr 2014 22:33:59 +0300
Message-Id: <1398281639-15839-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1398281639-15839-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1398281639-15839-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "best" value was unsigned however, leading to signed-to-unsigned
comparison and wrong results. Possibly only on a newer GCC. Fix this by
making the best value signed as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 0a74e14..db3d5a6 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1766,7 +1766,7 @@ static void smiapp_set_compose_binner(struct v4l2_subdev *subdev,
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
 	unsigned int i;
 	unsigned int binh = 1, binv = 1;
-	unsigned int best = scaling_goodness(
+	int best = scaling_goodness(
 		subdev,
 		crops[SMIAPP_PAD_SINK]->width, sel->r.width,
 		crops[SMIAPP_PAD_SINK]->height, sel->r.height, sel->flags);
-- 
1.8.3.2

