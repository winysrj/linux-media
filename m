Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52070 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726858AbeH2Osy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 10:48:54 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 3/3] sr030pc30: Remove redundant setting of sub-device name
Date: Wed, 29 Aug 2018 13:52:33 +0300
Message-Id: <20180829105233.3852-4-sakari.ailus@linux.intel.com>
In-Reply-To: <20180829105233.3852-1-sakari.ailus@linux.intel.com>
References: <20180829105233.3852-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sub-device name is set right after in v4l2_i2c_subdev_init(). Remove
the redundant strcpy() call.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/sr030pc30.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/sr030pc30.c b/drivers/media/i2c/sr030pc30.c
index 2a4882cddc51..3d3fb1cda28c 100644
--- a/drivers/media/i2c/sr030pc30.c
+++ b/drivers/media/i2c/sr030pc30.c
@@ -703,7 +703,6 @@ static int sr030pc30_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	sd = &info->sd;
-	strcpy(sd->name, MODULE_NAME);
 	info->pdata = client->dev.platform_data;
 
 	v4l2_i2c_subdev_init(sd, client, &sr030pc30_ops);
-- 
2.11.0
