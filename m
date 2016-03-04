Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48677 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759044AbcCDUTa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 15:19:30 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH v4 1/4] v4l: vsp1: Check if an entity is a subdev with the right function
Date: Fri,  4 Mar 2016 22:18:48 +0200
Message-Id: <1457122731-22558-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1457122731-22558-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1457122731-22558-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use is_media_entity_v4l2_subdev() instead of is_media_entity_v4l2_io()
to check whether the entity is a subdev.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 61ee0f92c1e5..72cc7d3729f8 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -289,7 +289,7 @@ static int vsp1_video_pipeline_validate(struct vsp1_pipeline *pipe,
 		struct vsp1_rwpf *rwpf;
 		struct vsp1_entity *e;
 
-		if (is_media_entity_v4l2_io(entity))
+		if (!is_media_entity_v4l2_subdev(entity))
 			continue;
 
 		subdev = media_entity_to_v4l2_subdev(entity);
-- 
2.4.10

