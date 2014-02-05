Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59504 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaBEQl5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:41:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 25/47] v4l: subdev: Remove deprecated video-level DV timings operations
Date: Wed,  5 Feb 2014 17:42:16 +0100
Message-Id: <1391618558-5580-26-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings and dv_timings_cap operations are deprecated
and unused. Remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-subdev.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 2c7355a..ddea899 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -326,12 +326,8 @@ struct v4l2_subdev_video_ops {
 			struct v4l2_dv_timings *timings);
 	int (*g_dv_timings)(struct v4l2_subdev *sd,
 			struct v4l2_dv_timings *timings);
-	int (*enum_dv_timings)(struct v4l2_subdev *sd,
-			struct v4l2_enum_dv_timings *timings);
 	int (*query_dv_timings)(struct v4l2_subdev *sd,
 			struct v4l2_dv_timings *timings);
-	int (*dv_timings_cap)(struct v4l2_subdev *sd,
-			struct v4l2_dv_timings_cap *cap);
 	int (*enum_mbus_fmt)(struct v4l2_subdev *sd, unsigned int index,
 			     enum v4l2_mbus_pixelcode *code);
 	int (*enum_mbus_fsizes)(struct v4l2_subdev *sd,
-- 
1.8.3.2

