Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41622 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbeITWDb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 18:03:31 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 1/4] [media] ad5820: Define entity function
Date: Thu, 20 Sep 2018 18:19:09 +0200
Message-Id: <20180920161912.17063-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without this patch, media_device_register_entity throws a warning:

dev_warn(mdev->dev,
	 "Entity type for entity %s was not initialized!\n",
	 entity->name);

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/i2c/ad5820.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index 907323f0ca3b..22759aaa2dba 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -317,6 +317,7 @@ static int ad5820_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(&coil->subdev, client, &ad5820_ops);
 	coil->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	coil->subdev.internal_ops = &ad5820_internal_ops;
+	coil->subdev.entity.function = MEDIA_ENT_F_LENS;
 	strscpy(coil->subdev.name, "ad5820 focus", sizeof(coil->subdev.name));
 
 	ret = media_entity_pads_init(&coil->subdev.entity, 0, NULL);
-- 
2.18.0
