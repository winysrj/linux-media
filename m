Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58153 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab1BNMU6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:20:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v7 2/6] v4l: subdev: Don't require core operations
Date: Mon, 14 Feb 2011 13:20:55 +0100
Message-Id: <1297686059-9622-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686059-9622-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686059-9622-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There's no reason to require subdevices to implement the core
operations. Remove the check for non-NULL core operations when
initializing the subdev.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-subdev.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index daf1e57..2f2dea2 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -479,8 +479,7 @@ static inline void v4l2_subdev_init(struct v4l2_subdev *sd,
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
1.7.3.4

