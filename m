Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2572 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab3BPJ3I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 04:29:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 15/18] v4l2-subdev: remove obsolete dv_preset ops.
Date: Sat, 16 Feb 2013 10:28:18 +0100
Message-Id: <36652e5ccf5783e5609d1be76d22606698df85be.1361006882.git.hans.verkuil@cisco.com>
In-Reply-To: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
References: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
References: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These ops are no longer used, so it's time to remove them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/v4l2-subdev.h |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index b137a5e..34ce1a2 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -279,14 +279,6 @@ struct v4l2_mbus_frame_desc {
    s_routing: see s_routing in audio_ops, except this version is for video
 	devices.
 
-   s_dv_preset: set dv (Digital Video) preset in the sub device. Similar to
-	s_std()
-
-   g_dv_preset: get current dv (Digital Video) preset in the sub device.
-
-   query_dv_preset: query dv preset in the sub device. This is similar to
-	querystd()
-
    s_dv_timings(): Set custom dv timings in the sub device. This is used
 	when sub device is capable of setting detailed timing information
 	in the hardware to generate/detect the video signal.
@@ -331,14 +323,6 @@ struct v4l2_subdev_video_ops {
 				struct v4l2_subdev_frame_interval *interval);
 	int (*enum_framesizes)(struct v4l2_subdev *sd, struct v4l2_frmsizeenum *fsize);
 	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct v4l2_frmivalenum *fival);
-	int (*enum_dv_presets) (struct v4l2_subdev *sd,
-			struct v4l2_dv_enum_preset *preset);
-	int (*s_dv_preset)(struct v4l2_subdev *sd,
-			struct v4l2_dv_preset *preset);
-	int (*g_dv_preset)(struct v4l2_subdev *sd,
-			struct v4l2_dv_preset *preset);
-	int (*query_dv_preset)(struct v4l2_subdev *sd,
-			struct v4l2_dv_preset *preset);
 	int (*s_dv_timings)(struct v4l2_subdev *sd,
 			struct v4l2_dv_timings *timings);
 	int (*g_dv_timings)(struct v4l2_subdev *sd,
-- 
1.7.10.4

