Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40809 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933129AbaLJVQi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 16:16:38 -0500
Received: from lanttu.localdomain (lanttu.localdomain [192.168.5.64])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id A060560098
	for <linux-media@vger.kernel.org>; Wed, 10 Dec 2014 23:16:34 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 2/7] smiapp: Free control handlers in sub-device cleanup
Date: Wed, 10 Dec 2014 23:16:15 +0200
Message-Id: <1418246180-667-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1418246180-667-1-git-send-email-sakari.ailus@iki.fi>
References: <1418246180-667-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Also call smiapp_cleanup() in smiapp_remove(), replacing code that did the
same than the function.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 4f36be5..72a0de6 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2522,6 +2522,8 @@ static void smiapp_cleanup(struct smiapp_sensor *sensor)
 
 	device_remove_file(&client->dev, &dev_attr_nvm);
 	device_remove_file(&client->dev, &dev_attr_ident);
+
+	smiapp_free_controls(sensor);
 }
 
 static int smiapp_init(struct smiapp_sensor *sensor)
@@ -3124,15 +3126,11 @@ static int smiapp_remove(struct i2c_client *client)
 		sensor->power_count = 0;
 	}
 
-	device_remove_file(&client->dev, &dev_attr_ident);
-	if (sensor->nvm)
-		device_remove_file(&client->dev, &dev_attr_nvm);
-
 	for (i = 0; i < sensor->ssds_used; i++) {
 		v4l2_device_unregister_subdev(&sensor->ssds[i].sd);
 		media_entity_cleanup(&sensor->ssds[i].sd.entity);
 	}
-	smiapp_free_controls(sensor);
+	smiapp_cleanup(sensor);
 
 	return 0;
 }
-- 
1.7.10.4

