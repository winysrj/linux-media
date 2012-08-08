Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47911 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab2HHPas (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2012 11:30:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH] omap3isp: Mark the resizer output video node as the default video node
Date: Wed,  8 Aug 2012 17:30:57 +0200
Message-Id: <1344439857-7858-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The resizer can output YUYV and UYVY in a wide range of sizes, making it
the best video node for regular V4L2 applications.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispresizer.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispresizer.c b/drivers/media/video/omap3isp/ispresizer.c
index ae17d91..a9bfd0a 100644
--- a/drivers/media/video/omap3isp/ispresizer.c
+++ b/drivers/media/video/omap3isp/ispresizer.c
@@ -1730,6 +1730,8 @@ static int resizer_init_entities(struct isp_res_device *res)
 	if (ret < 0)
 		goto error_video_out;
 
+	res->video_out.video.entity.flags |= MEDIA_ENT_FL_DEFAULT;
+
 	/* Connect the video nodes to the resizer subdev. */
 	ret = media_entity_create_link(&res->video_in.video.entity, 0,
 			&res->subdev.entity, RESZ_PAD_SINK, 0);
-- 
Regards,

Laurent Pinchart

