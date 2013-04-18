Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:49804 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936478Ab3DRVf7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:59 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 23/24] V4L2: mt9p031: add struct v4l2_subdev_platform_data to platform data
Date: Thu, 18 Apr 2013 23:35:44 +0200
Message-Id: <1366320945-21591-24-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding struct v4l2_subdev_platform_data to mt9p031's platform data allows
the driver to use generic functions to manage sensor power supplies.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/mt9p031.c |    1 +
 include/media/mt9p031.h     |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 70f4525..ca2cc6e 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -1048,6 +1048,7 @@ static int mt9p031_probe(struct i2c_client *client,
 		goto done;
 
 	mt9p031->subdev.dev = &client->dev;
+	mt9p031->subdev.pdata = &pdata->sd_pdata;
 	ret = v4l2_async_register_subdev(&mt9p031->subdev);
 
 done:
diff --git a/include/media/mt9p031.h b/include/media/mt9p031.h
index 0c97b19..7bf7b53 100644
--- a/include/media/mt9p031.h
+++ b/include/media/mt9p031.h
@@ -1,6 +1,8 @@
 #ifndef MT9P031_H
 #define MT9P031_H
 
+#include <media/v4l2-subdev.h>
+
 struct v4l2_subdev;
 
 /*
@@ -15,6 +17,7 @@ struct mt9p031_platform_data {
 	int reset;
 	int ext_freq;
 	int target_freq;
+	struct v4l2_subdev_platform_data sd_pdata;
 };
 
 #endif
-- 
1.7.2.5

