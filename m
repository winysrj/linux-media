Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:45023 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753724AbaLDJzw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Dec 2014 04:55:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/8] v4l2-subdev: drop unused op enum_mbus_fmt
Date: Thu,  4 Dec 2014 10:54:54 +0100
Message-Id: <1417686899-30149-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl>
References: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Weird, this op isn't used at all. Seems to be orphaned code.
Remove it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/v4l2-subdev.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index b052184..5beeb87 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -342,8 +342,6 @@ struct v4l2_subdev_video_ops {
 			struct v4l2_dv_timings *timings);
 	int (*enum_mbus_fmt)(struct v4l2_subdev *sd, unsigned int index,
 			     u32 *code);
-	int (*enum_mbus_fsizes)(struct v4l2_subdev *sd,
-			     struct v4l2_frmsizeenum *fsize);
 	int (*g_mbus_fmt)(struct v4l2_subdev *sd,
 			  struct v4l2_mbus_framefmt *fmt);
 	int (*try_mbus_fmt)(struct v4l2_subdev *sd,
-- 
2.1.3

