Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56900 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751863AbeDLM3F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 08:29:05 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1001])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 96C1F634C4E
        for <linux-media@vger.kernel.org>; Thu, 12 Apr 2018 15:29:03 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] tda1997x: Use bitwise or for setting subdev flags
Date: Thu, 12 Apr 2018 15:29:03 +0300
Message-Id: <20180412122903.20956-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Assigning subdev flags in probe() after v4l2_i2c_subdev_init() clears the
I2C flag set by that function. Fix this by using bitwise or instead.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/tda1997x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tda1997x.c b/drivers/media/i2c/tda1997x.c
index 3021913c28fa..1c5b5f70866f 100644
--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -2567,7 +2567,7 @@ static int tda1997x_probe(struct i2c_client *client,
 	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x",
 		 id->name, i2c_adapter_id(client->adapter),
 		 client->addr);
-	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 	sd->entity.function = MEDIA_ENT_F_DTV_DECODER;
 	sd->entity.ops = &tda1997x_media_ops;
 
-- 
2.11.0
