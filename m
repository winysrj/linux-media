Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35314 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753435AbcISWDO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:03:14 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v3 17/18] smiapp: Drop a debug print on frame size and bit depth
Date: Tue, 20 Sep 2016 01:02:50 +0300
Message-Id: <1474322571-20290-18-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first time the sensor is powered on, the information is not yet
available.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 5f4680d..8f9690e 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -926,12 +926,6 @@ static int smiapp_update_mode(struct smiapp_sensor *sensor)
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

