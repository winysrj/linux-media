Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48374 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbbH3DHq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:46 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH v8 34/55] [media] s5c73m3: fix subdev type
Date: Sun, 30 Aug 2015 00:06:45 -0300
Message-Id: <9f8845993df848df703f3ab177745ea54c30e828.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This sensor driver is abusing MEDIA_ENT_T_V4L2_SUBDEV, creating
some subdevs with a non-existing type.

As this is a sensor driver, the proper type is likely
MEDIA_ENT_T_CAM_SENSOR.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index c81bfbfea32f..abae37321c0c 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1688,7 +1688,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 
 	state->sensor_pads[S5C73M3_JPEG_PAD].flags = MEDIA_PAD_FL_SOURCE;
 	state->sensor_pads[S5C73M3_ISP_PAD].flags = MEDIA_PAD_FL_SOURCE;
-	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
+	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
 
 	ret = media_entity_init(&sd->entity, S5C73M3_NUM_PADS,
 							state->sensor_pads);
@@ -1704,7 +1704,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 	state->oif_pads[OIF_ISP_PAD].flags = MEDIA_PAD_FL_SINK;
 	state->oif_pads[OIF_JPEG_PAD].flags = MEDIA_PAD_FL_SINK;
 	state->oif_pads[OIF_SOURCE_PAD].flags = MEDIA_PAD_FL_SOURCE;
-	oif_sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
+	oif_sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
 
 	ret = media_entity_init(&oif_sd->entity, OIF_NUM_PADS,
 							state->oif_pads);
-- 
2.4.3

