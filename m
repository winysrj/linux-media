Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56166 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752167AbeDLKVz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 06:21:55 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH 4/4] ov7740: Set subdev HAS_EVENT flag
Date: Thu, 12 Apr 2018 13:21:50 +0300
Message-Id: <20180412102150.29997-5-sakari.ailus@linux.intel.com>
In-Reply-To: <20180412102150.29997-1-sakari.ailus@linux.intel.com>
References: <20180412102150.29997-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver has event support implemented but fails to set the flag
enabling event support. Set the flag to enable control events.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov7740.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index 0c15b67f3c34..7cba0208b6ee 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -1086,7 +1086,7 @@ static int ov7740_probe(struct i2c_client *client,
 
 #ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 	sd->internal_ops = &ov7740_subdev_internal_ops;
-	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 #endif
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
-- 
2.11.0
