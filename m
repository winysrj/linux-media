Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58885 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbbHWUSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:08 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH v7 02/44] [media] staging: omap4iss: get entity ID using media_entity_id()
Date: Sun, 23 Aug 2015 17:17:19 -0300
Message-Id: <89b52db55e6ab0ad54e2ed0e760ba0ca3f54dec8.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Javier Martinez Canillas <javier@osg.samsung.com>

The struct media_entity does not have an .id field anymore since
now the entity ID is stored in the embedded struct media_gobj.

This caused the omap4iss driver fail to build. Fix by using the
media_entity_id() macro to obtain the entity ID.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 9bfb725b9986..e54a7afd31de 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -607,7 +607,7 @@ static int iss_pipeline_disable(struct iss_pipeline *pipe,
 			 * crashed. Mark it as such, the ISS will be reset when
 			 * applications will release it.
 			 */
-			iss->crashed |= 1U << subdev->entity.id;
+			iss->crashed |= 1U << media_entity_id(&subdev->entity);
 			failure = -ETIMEDOUT;
 		}
 	}
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index bae67742706f..25e9e7a6b99d 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -784,7 +784,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	entity = &video->video.entity;
 	media_entity_graph_walk_start(&graph, entity);
 	while ((entity = media_entity_graph_walk_next(&graph)))
-		pipe->entities |= 1 << entity->id;
+		pipe->entities |= 1 << media_entity_id(entity);
 
 	/* Verify that the currently configured format matches the output of
 	 * the connected subdev.
-- 
2.4.3

