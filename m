Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:32841 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754601Ab3FKKvX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 06:51:23 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: s.nawrocki@samsung.com
Cc: prabhakar.csengg@gmail.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com
Subject: [RFC PATCH 1/2] smiapp: Clean up media entity after unregistering subdev
Date: Tue, 11 Jun 2013 13:50:48 +0300
Message-Id: <1370947849-24314-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20130611105032.GJ3103@valkosipuli.retiisi.org.uk>
References: <20130611105032.GJ3103@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

media_entity_cleanup() frees the links array which will be accessed by
media_entity_remove_links() called by v4l2_device_unregister_subdev().

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index c385454..7ac7580 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2848,8 +2848,8 @@ static int smiapp_remove(struct i2c_client *client)
 		device_remove_file(&client->dev, &dev_attr_nvm);
 
 	for (i = 0; i < sensor->ssds_used; i++) {
-		media_entity_cleanup(&sensor->ssds[i].sd.entity);
 		v4l2_device_unregister_subdev(&sensor->ssds[i].sd);
+		media_entity_cleanup(&sensor->ssds[i].sd.entity);
 	}
 	smiapp_free_controls(sensor);
 
-- 
1.7.10.4

