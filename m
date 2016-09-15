Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39276 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756136AbcIOLWo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 07:22:44 -0400
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id BF287600AE
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 14:22:36 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 16/17] smiapp: Drop a debug print on frame size and bit depth
Date: Thu, 15 Sep 2016 14:22:30 +0300
Message-Id: <1473938551-14503-17-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first time the sensor is powered on, the information is not yet
available.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 521afc0..61827fd 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -922,12 +922,6 @@ static int smiapp_update_mode(struct smiapp_sensor *sensor)
 	unsigned int binning_mode;
 	int rval;
 
-	dev_dbg(&client->dev, "frame size: %dx%d\n",
-		sensor->src->crop[SMIAPP_PAD_SRC].width,
-		sensor->src->crop[SMIAPP_PAD_SRC].height);
-	dev_dbg(&client->dev, "csi format width: %d\n",
-		sensor->csi_format->width);
-
 	/* Binning has to be set up here; it affects limits */
 	if (sensor->binning_horizontal == 1 &&
 	    sensor->binning_vertical == 1) {
-- 
2.1.4

