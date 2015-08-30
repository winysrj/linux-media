Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48436 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbbH3DHu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Markus Elfring <elfring@users.sourceforge.net>,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v8 29/55] [media] replace all occurrences of MEDIA_ENT_T_DEVNODE_V4L
Date: Sun, 30 Aug 2015 00:06:40 -0300
Message-Id: <553c4e697dee72bbdf3d73a4d428118e10e18720.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that interfaces and entities are distinct, it makes no sense
of keeping something named as MEDIA_ENT_T_DEVNODE.

This change was done with this script:

	for i in $(git grep -l MEDIA_ENT_T|grep -v uapi/linux/media.h); do sed s,MEDIA_ENT_T_DEVNODE_V4L,MEDIA_ENT_T_V4L2_VIDEO, <$i >a && mv a $i; done

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index 5872f8bbf774..910243d4edb8 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -183,7 +183,7 @@
 	    <entry>Unknown device node</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_V4L</constant></entry>
+	    <entry><constant>MEDIA_ENT_T_V4L2_VIDEO</constant></entry>
 	    <entry>V4L video, radio or vbi device node</entry>
 	  </row>
 	  <row>
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 92e8116dc28f..88cd789cdaf7 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -193,7 +193,7 @@ static int xvip_pipeline_validate(struct xvip_pipeline *pipe,
 	while ((entity = media_entity_graph_walk_next(&graph))) {
 		struct xvip_dma *dma;
 
-		if (entity->type != MEDIA_ENT_T_DEVNODE_V4L)
+		if (entity->type != MEDIA_ENT_T_V4L2_VIDEO)
 			continue;
 
 		dma = to_xvip_dma(media_entity_to_video_device(entity));
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 71a1b93b0790..44b330589787 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -912,7 +912,7 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 	/* Part 5: Register the entity. */
 	if (vdev->v4l2_dev->mdev &&
 	    vdev->vfl_type != VFL_TYPE_SUBDEV) {
-		vdev->entity.type = MEDIA_ENT_T_DEVNODE_V4L;
+		vdev->entity.type = MEDIA_ENT_T_V4L2_VIDEO;
 		vdev->entity.name = vdev->name;
 		vdev->entity.info.dev.major = VIDEO_MAJOR;
 		vdev->entity.info.dev.minor = vdev->minor;
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 83615b8fb46a..e6e1115d8215 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -535,7 +535,7 @@ v4l2_subdev_link_validate_get_format(struct media_pad *pad,
 		return v4l2_subdev_call(sd, pad, get_fmt, NULL, fmt);
 	}
 
-	WARN(pad->entity->type != MEDIA_ENT_T_DEVNODE_V4L,
+	WARN(pad->entity->type != MEDIA_ENT_T_V4L2_VIDEO,
 	     "Driver bug! Wrong media entity type 0x%08x, entity %s\n",
 	     pad->entity->type, pad->entity->name);
 
-- 
2.4.3

