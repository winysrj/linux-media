Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53626 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936231Ab3DRVf4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:56 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 01/24] V4L2: (cosmetic) remove redundant use of unlikely()
Date: Thu, 18 Apr 2013 23:35:22 +0200
Message-Id: <1366320945-21591-2-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

BUG*() and WARN*() macros specify their conditions as unlikely, using
BUG_ON(unlikely(condition)) is redundant, remove it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/media/v4l2-subdev.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 21174af..eb91366 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -625,8 +625,8 @@ struct v4l2_subdev_fh {
 	v4l2_subdev_get_try_##fun_name(struct v4l2_subdev_fh *fh,	\
 				       unsigned int pad)		\
 	{								\
-		BUG_ON(unlikely(pad >= vdev_to_v4l2_subdev(		\
-					fh->vfh.vdev)->entity.num_pads)); \
+		BUG_ON(pad >= vdev_to_v4l2_subdev(			\
+					fh->vfh.vdev)->entity.num_pads); \
 		return &fh->pad[pad].field_name;			\
 	}
 
-- 
1.7.2.5

