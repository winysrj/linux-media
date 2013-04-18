Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:51191 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936477Ab3DRVf7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:59 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 19/24] V4L2: add struct v4l2_subdev_try_buf
Date: Thu, 18 Apr 2013 23:35:40 +0200
Message-Id: <1366320945-21591-20-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds struct v4l2_subdev_try_buf, used as a temporary buffer for
"try" pad configuration data. Defining such a struct will simplify memory
allocation for such buffers.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/media/v4l2-subdev.h |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index b15c6e0..4424a7c 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -618,14 +618,16 @@ static inline struct v4l2_subdev *v4l2_async_to_subdev(
 /*
  * Used for storing subdev information per file handle
  */
+struct v4l2_subdev_try_buf {
+	struct v4l2_mbus_framefmt try_fmt;
+	struct v4l2_rect try_crop;
+	struct v4l2_rect try_compose;
+};
+
 struct v4l2_subdev_fh {
 	struct v4l2_fh vfh;
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
-	struct {
-		struct v4l2_mbus_framefmt try_fmt;
-		struct v4l2_rect try_crop;
-		struct v4l2_rect try_compose;
-	} *pad;
+	struct v4l2_subdev_try_buf *pad;
 #endif
 };
 
-- 
1.7.2.5

