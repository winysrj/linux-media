Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39650 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933613AbcIOL32 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 07:29:28 -0400
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 23190600A1
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 14:29:25 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/5] smiapp: Drop BUG_ON() in suspend path
Date: Thu, 15 Sep 2016 14:29:17 +0300
Message-Id: <1473938961-16067-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473938961-16067-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473938961-16067-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Checking that the mutex is not acquired is unnecessary for user processes
are stopped by this point. Drop the check.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 61827fd..bdc5d1b 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2687,8 +2687,6 @@ static int smiapp_suspend(struct device *dev)
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
 	bool streaming;
 
-	BUG_ON(mutex_is_locked(&sensor->mutex));
-
 	if (sensor->power_count == 0)
 		return 0;
 
-- 
2.1.4

