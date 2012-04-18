Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:65305 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab2DRIAz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 04:00:55 -0400
Date: Wed, 18 Apr 2012 10:00:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] V4L2: mt9m032: use the available subdev pointer, don't
 re-calculate it
Message-ID: <Pine.LNX.4.64.1204181000000.30514@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m032.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
index 7636672..6f1ae54 100644
--- a/drivers/media/video/mt9m032.c
+++ b/drivers/media/video/mt9m032.c
@@ -837,9 +837,9 @@ static int mt9m032_remove(struct i2c_client *client)
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct mt9m032 *sensor = to_mt9m032(subdev);
 
-	v4l2_device_unregister_subdev(&sensor->subdev);
+	v4l2_device_unregister_subdev(subdev);
 	v4l2_ctrl_handler_free(&sensor->ctrls);
-	media_entity_cleanup(&sensor->subdev.entity);
+	media_entity_cleanup(&subdev->entity);
 	mutex_destroy(&sensor->lock);
 	kfree(sensor);
 	return 0;
-- 
1.7.2.5

