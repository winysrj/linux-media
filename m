Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:36480 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755976AbbCDJt1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2015 04:49:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 8/8] v4l2-subdev: remove enum_framesizes/intervals
Date: Wed,  4 Mar 2015 10:48:01 +0100
Message-Id: <1425462481-8200-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425462481-8200-1-git-send-email-hverkuil@xs4all.nl>
References: <1425462481-8200-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The video and pad ops are duplicates, so get rid of the more limited video op.

The whole point of the subdev API is to allow reuse of subdev drivers by
bridge drivers. Having duplicate ops makes that much harder. We should never
have allowed duplicate ops in the first place. A lesson for the future.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-subdev.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 0c43546..922f063 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -332,8 +332,6 @@ struct v4l2_subdev_video_ops {
 				struct v4l2_subdev_frame_interval *interval);
 	int (*s_frame_interval)(struct v4l2_subdev *sd,
 				struct v4l2_subdev_frame_interval *interval);
-	int (*enum_framesizes)(struct v4l2_subdev *sd, struct v4l2_frmsizeenum *fsize);
-	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct v4l2_frmivalenum *fival);
 	int (*s_dv_timings)(struct v4l2_subdev *sd,
 			struct v4l2_dv_timings *timings);
 	int (*g_dv_timings)(struct v4l2_subdev *sd,
-- 
2.1.4

