Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:55220 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966799AbeFRJMr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 05:12:47 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media/i2c: add missing entity functions
Message-ID: <ca8b3893-78ed-07bb-a954-099c9b28830c@xs4all.nl>
Date: Mon, 18 Jun 2018 11:12:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several drivers in media/i2c do not set the entity function.
Correct this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c              | 1 +
 drivers/media/i2c/adv7842.c              | 1 +
 drivers/media/i2c/et8ek8/et8ek8_driver.c | 1 +
 drivers/media/i2c/mt9m032.c              | 1 +
 drivers/media/i2c/mt9p031.c              | 1 +
 drivers/media/i2c/mt9t001.c              | 1 +
 drivers/media/i2c/mt9v032.c              | 1 +
 7 files changed, 7 insertions(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index cac2081e876e..f2df509e34f0 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3502,6 +3502,7 @@ static int adv76xx_probe(struct i2c_client *client,
 	for (i = 0; i < state->source_pad; ++i)
 		state->pads[i].flags = MEDIA_PAD_FL_SINK;
 	state->pads[state->source_pad].flags = MEDIA_PAD_FL_SOURCE;
+	sd->entity.function = MEDIA_ENT_F_DTV_DECODER;

 	err = media_entity_pads_init(&sd->entity, state->source_pad + 1,
 				state->pads);
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index fddac32e5051..56da071f99cb 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -3541,6 +3541,7 @@ static int adv7842_probe(struct i2c_client *client,
 	INIT_DELAYED_WORK(&state->delayed_work_enable_hotplug,
 			adv7842_delayed_work_enable_hotplug);

+	sd->entity.function = MEDIA_ENT_F_DTV_DECODER;
 	state->pad.flags = MEDIA_PAD_FL_SOURCE;
 	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
 	if (err)
diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/et8ek8/et8ek8_driver.c
index e9eff9039ef5..37ef38947e01 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -1446,6 +1446,7 @@ static int et8ek8_probe(struct i2c_client *client,
 	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	sensor->subdev.internal_ops = &et8ek8_internal_ops;

+	sensor->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
 	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_pads_init(&sensor->subdev.entity, 1, &sensor->pad);
 	if (ret < 0) {
diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
index 6a9e068462fd..b385f2b632ad 100644
--- a/drivers/media/i2c/mt9m032.c
+++ b/drivers/media/i2c/mt9m032.c
@@ -793,6 +793,7 @@ static int mt9m032_probe(struct i2c_client *client,
 	v4l2_ctrl_cluster(2, &sensor->hflip);

 	sensor->subdev.ctrl_handler = &sensor->ctrls;
+	sensor->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
 	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_pads_init(&sensor->subdev.entity, 1, &sensor->pad);
 	if (ret < 0)
diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 91d822fc4443..715be3632b01 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -1111,6 +1111,7 @@ static int mt9p031_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(&mt9p031->subdev, client, &mt9p031_subdev_ops);
 	mt9p031->subdev.internal_ops = &mt9p031_subdev_internal_ops;

+	mt9p031->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
 	mt9p031->pad.flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_pads_init(&mt9p031->subdev.entity, 1, &mt9p031->pad);
 	if (ret < 0)
diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
index 9d981d9f5686..f683d2cb0486 100644
--- a/drivers/media/i2c/mt9t001.c
+++ b/drivers/media/i2c/mt9t001.c
@@ -943,6 +943,7 @@ static int mt9t001_probe(struct i2c_client *client,
 	mt9t001->subdev.internal_ops = &mt9t001_subdev_internal_ops;
 	mt9t001->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;

+	mt9t001->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
 	mt9t001->pad.flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_pads_init(&mt9t001->subdev.entity, 1, &mt9t001->pad);

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 4de63b2df334..f74730d24d8f 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -1162,6 +1162,7 @@ static int mt9v032_probe(struct i2c_client *client,
 	mt9v032->subdev.internal_ops = &mt9v032_subdev_internal_ops;
 	mt9v032->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;

+	mt9v032->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
 	mt9v032->pad.flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_pads_init(&mt9v032->subdev.entity, 1, &mt9v032->pad);
 	if (ret < 0)
-- 
2.17.0
