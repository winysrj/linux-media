Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58555 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab3EHNqv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 09:46:51 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.146.12])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2BEBB35A4E
	for <linux-media@vger.kernel.org>; Wed,  8 May 2013 15:46:24 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH RESEND 1/9] mt9v032: Free control handler in cleanup paths
Date: Wed,  8 May 2013 15:46:26 +0200
Message-Id: <1368020794-21264-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The control handler must be freed in the probe error path and in the
remove handler.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9v032.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 3f356cb..24ea6fd 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -830,8 +830,11 @@ static int mt9v032_probe(struct i2c_client *client,
 
 	mt9v032->pad.flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_init(&mt9v032->subdev.entity, 1, &mt9v032->pad, 0);
-	if (ret < 0)
+
+	if (ret < 0) {
+		v4l2_ctrl_handler_free(&mt9v032->ctrls);
 		kfree(mt9v032);
+	}
 
 	return ret;
 }
@@ -841,9 +844,11 @@ static int mt9v032_remove(struct i2c_client *client)
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
 
+	v4l2_ctrl_handler_free(&mt9v032->ctrls);
 	v4l2_device_unregister_subdev(subdev);
 	media_entity_cleanup(&subdev->entity);
 	kfree(mt9v032);
+
 	return 0;
 }
 
-- 
1.8.1.5

