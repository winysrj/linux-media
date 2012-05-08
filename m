Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:57787 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab2EHVB3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 17:01:29 -0400
Date: Tue, 8 May 2012 23:01:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Qing Xu <qingx@marvell.com>
Subject: [PATCH 2/2] V4L: remove unused .enum_mbus_fsizes() subdev video
 operation
In-Reply-To: <Pine.LNX.4.64.1205082259390.7085@axis700.grange>
Message-ID: <Pine.LNX.4.64.1205082300510.7085@axis700.grange>
References: <Pine.LNX.4.64.1205082259390.7085@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

.enum_mbus_fsizes() subdev video operation is a duplicate of
.enum_framesizes() and is unused. Remove it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Qing Xu <qingx@marvell.com>
---
 include/media/v4l2-subdev.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index f0f3358..9e68464 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -309,8 +309,6 @@ struct v4l2_subdev_video_ops {
 			struct v4l2_dv_timings *timings);
 	int (*enum_mbus_fmt)(struct v4l2_subdev *sd, unsigned int index,
 			     enum v4l2_mbus_pixelcode *code);
-	int (*enum_mbus_fsizes)(struct v4l2_subdev *sd,
-			     struct v4l2_frmsizeenum *fsize);
 	int (*g_mbus_fmt)(struct v4l2_subdev *sd,
 			  struct v4l2_mbus_framefmt *fmt);
 	int (*try_mbus_fmt)(struct v4l2_subdev *sd,
-- 
1.7.2.5

