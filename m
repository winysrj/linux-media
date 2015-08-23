Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58939 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbbHWUSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:10 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH v7 31/44] [media] s5k5baf: fix subdev type
Date: Sun, 23 Aug 2015 17:17:48 -0300
Message-Id: <cf1471aac91cf46f7c5ea9b60604cafe524e267a.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

X-Patchwork-Delegate: m.chehab@samsung.com
This sensor driver is abusing MEDIA_ENT_T_V4L2_SUBDEV, creating
some subdevs with a non-existing type.

As this is a sensor driver, the proper type is likely
MEDIA_ENT_T_V4L2_SUBDEV_SENSOR.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index d3bff30bcb6f..0513196bd48c 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -1919,7 +1919,7 @@ static int s5k5baf_configure_subdevs(struct s5k5baf *state,
 
 	state->pads[PAD_CIS].flags = MEDIA_PAD_FL_SINK;
 	state->pads[PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
+	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
 	ret = media_entity_init(&sd->entity, NUM_ISP_PADS, state->pads);
 
 	if (!ret)
-- 
2.4.3

