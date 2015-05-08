Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36552 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbbEHBMt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 21:12:49 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 12/18] s5c73m3: fix subdev type
Date: Thu,  7 May 2015 22:12:34 -0300
Message-Id: <211cf239715e0046c65585b08421d5d82f782356.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This sensor driver is abusing MEDIA_ENT_T_V4L2_SUBDEV, creating
some subdevs with a non-existing type.

As this is a sensor driver, the proper type is likely
MEDIA_ENT_T_CAM_SENSOR.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 53c5ea89f0b9..07bead4ccdb4 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1688,7 +1688,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 
 	state->sensor_pads[S5C73M3_JPEG_PAD].flags = MEDIA_PAD_FL_SOURCE;
 	state->sensor_pads[S5C73M3_ISP_PAD].flags = MEDIA_PAD_FL_SOURCE;
-	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
+	sd->entity.type = MEDIA_ENT_T_CAM_SENSOR;
 
 	ret = media_entity_init(&sd->entity, S5C73M3_NUM_PADS,
 							state->sensor_pads, 0);
@@ -1704,7 +1704,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 	state->oif_pads[OIF_ISP_PAD].flags = MEDIA_PAD_FL_SINK;
 	state->oif_pads[OIF_JPEG_PAD].flags = MEDIA_PAD_FL_SINK;
 	state->oif_pads[OIF_SOURCE_PAD].flags = MEDIA_PAD_FL_SOURCE;
-	oif_sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
+	oif_sd->entity.type = MEDIA_ENT_T_CAM_SENSOR;
 
 	ret = media_entity_init(&oif_sd->entity, OIF_NUM_PADS,
 							state->oif_pads, 0);
-- 
2.1.0

