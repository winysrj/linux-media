Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:50315 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab0GGLxl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 07:53:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH 1/6] v4l: subdev: Don't require core operations
Date: Wed,  7 Jul 2010 13:53:23 +0200
Message-Id: <1278503608-9126-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no reason to require subdevices to implement the core
operations. Remove the check for non-NULL core operations when
initializing the subdev.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-subdev.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 02c6f4d..6088316 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -437,8 +437,7 @@ static inline void v4l2_subdev_init(struct v4l2_subdev *sd,
 					const struct v4l2_subdev_ops *ops)
 {
 	INIT_LIST_HEAD(&sd->list);
-	/* ops->core MUST be set */
-	BUG_ON(!ops || !ops->core);
+	BUG_ON(!ops);
 	sd->ops = ops;
 	sd->v4l2_dev = NULL;
 	sd->flags = 0;
-- 
1.7.1

