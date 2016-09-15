Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39652 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933383AbcIOL32 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 07:29:28 -0400
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 529D5600A2
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 14:29:25 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/5] smiapp: Set device for pixel array and binner
Date: Thu, 15 Sep 2016 14:29:18 +0300
Message-Id: <1473938961-16067-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473938961-16067-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473938961-16067-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dev field of the v4l2_subdev was left NULL for the pixel array and
binner sub-devices. Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index bdc5d1b..fe1f738 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2589,6 +2589,7 @@ static void smiapp_create_subdev(struct smiapp_sensor *sensor,
 
 	ssd->sd.internal_ops = &smiapp_internal_ops;
 	ssd->sd.owner = THIS_MODULE;
+	ssd->sd.dev = &client->dev;
 	v4l2_set_subdevdata(&ssd->sd, client);
 }
 
-- 
2.1.4

