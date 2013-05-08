Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58556 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab3EHNqz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 09:46:55 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.146.12])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 0443135A54
	for <linux-media@vger.kernel.org>; Wed,  8 May 2013 15:46:24 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH RESEND 6/9] media: i2c: Convert to devm_regulator_bulk_get()
Date: Wed,  8 May 2013 15:46:31 +0200
Message-Id: <1368020794-21264-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the managed function the regulator_bulk_put() calls can be removed
from the probe error path and the remove handler.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/i2c/m5mols/m5mols_core.c | 8 +++-----
 drivers/media/i2c/noon010pc30.c        | 8 ++------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index f870d50..11f6f87 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -966,7 +966,8 @@ static int m5mols_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	ret = regulator_bulk_get(&client->dev, ARRAY_SIZE(supplies), supplies);
+	ret = devm_regulator_bulk_get(&client->dev, ARRAY_SIZE(supplies),
+				      supplies);
 	if (ret) {
 		dev_err(&client->dev, "Failed to get regulators: %d\n", ret);
 		return ret;
@@ -981,7 +982,7 @@ static int m5mols_probe(struct i2c_client *client,
 	info->pad.flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_init(&sd->entity, 1, &info->pad, 0);
 	if (ret < 0)
-		goto out_reg;
+		return ret;
 	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
 
 	init_waitqueue_head(&info->irq_waitq);
@@ -1012,8 +1013,6 @@ out_irq:
 	free_irq(client->irq, sd);
 out_me:
 	media_entity_cleanup(&sd->entity);
-out_reg:
-	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
 	return ret;
 }
 
@@ -1025,7 +1024,6 @@ static int m5mols_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	free_irq(client->irq, sd);
 
-	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
 	media_entity_cleanup(&sd->entity);
 
 	return 0;
diff --git a/drivers/media/i2c/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
index 6f81b99..2284b02 100644
--- a/drivers/media/i2c/noon010pc30.c
+++ b/drivers/media/i2c/noon010pc30.c
@@ -772,7 +772,7 @@ static int noon010_probe(struct i2c_client *client,
 	for (i = 0; i < NOON010_NUM_SUPPLIES; i++)
 		info->supply[i].supply = noon010_supply_name[i];
 
-	ret = regulator_bulk_get(&client->dev, NOON010_NUM_SUPPLIES,
+	ret = devm_regulator_bulk_get(&client->dev, NOON010_NUM_SUPPLIES,
 				 info->supply);
 	if (ret)
 		goto np_err;
@@ -781,14 +781,12 @@ static int noon010_probe(struct i2c_client *client,
 	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
 	ret = media_entity_init(&sd->entity, 1, &info->pad, 0);
 	if (ret < 0)
-		goto np_me_err;
+		goto np_err;
 
 	ret = noon010_detect(client, info);
 	if (!ret)
 		return 0;
 
-np_me_err:
-	regulator_bulk_free(NOON010_NUM_SUPPLIES, info->supply);
 np_err:
 	v4l2_ctrl_handler_free(&info->hdl);
 	v4l2_device_unregister_subdev(sd);
@@ -802,8 +800,6 @@ static int noon010_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&info->hdl);
-
-	regulator_bulk_free(NOON010_NUM_SUPPLIES, info->supply);
 	media_entity_cleanup(&sd->entity);
 
 	return 0;
-- 
1.8.1.5

