Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36539 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbbEHBMt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 21:12:49 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 13/18] s5k5baf: fix subdev type
Date: Thu,  7 May 2015 22:12:35 -0300
Message-Id: <d37f5695458429869abaae3f7974d296c3fa8349.1431046915.git.mchehab@osg.samsung.com>
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

diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index fadd48d35a55..8373552847ab 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -1919,7 +1919,7 @@ static int s5k5baf_configure_subdevs(struct s5k5baf *state,
 
 	state->pads[PAD_CIS].flags = MEDIA_PAD_FL_SINK;
 	state->pads[PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
+	sd->entity.type = MEDIA_ENT_T_CAM_SENSOR;
 	ret = media_entity_init(&sd->entity, NUM_ISP_PADS, state->pads, 0);
 
 	if (!ret)
-- 
2.1.0

