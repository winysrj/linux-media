Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48727 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbaCJXOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:14:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 39/48] v4l: subdev: Remove deprecated video-level DV timings operations
Date: Tue, 11 Mar 2014 00:15:50 +0100
Message-Id: <1394493359-14115-40-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings and dv_timings_cap operations are deprecated
and unused. Remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/v4l2-subdev.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 2b5ec32..ab2b59d 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -330,12 +330,8 @@ struct v4l2_subdev_video_ops {
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

