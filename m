Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51432 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726366AbeG3JAF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 05:00:05 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: jacopo@jmondi.org
Subject: [PATCH 1/1] mt9v111: Fix compiler warning by initialising a variable
Date: Mon, 30 Jul 2018 10:26:27 +0300
Message-Id: <20180730072627.32014-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While this isn't a bug, initialise the variable to quash the warning.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/mt9v111.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9v111.c b/drivers/media/i2c/mt9v111.c
index da8f6ab91307..58d5f2224bff 100644
--- a/drivers/media/i2c/mt9v111.c
+++ b/drivers/media/i2c/mt9v111.c
@@ -884,7 +884,7 @@ static int mt9v111_set_format(struct v4l2_subdev *subdev,
 	struct v4l2_mbus_framefmt new_fmt;
 	struct v4l2_mbus_framefmt *__fmt;
 	unsigned int best_fit = ~0L;
-	unsigned int idx;
+	unsigned int idx = 0;
 	unsigned int i;
 
 	mutex_lock(&mt9v111->stream_mutex);
-- 
2.11.0
