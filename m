Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:36496 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754011AbeBGOjp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 09:39:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 1/7] media: v4l2-compat-ioctl32.c: make ctrl_is_pointer work for subdevs
Date: Wed,  7 Feb 2018 15:39:33 +0100
Message-Id: <20180207143939.29491-2-hverkuil@xs4all.nl>
In-Reply-To: <20180207143939.29491-1-hverkuil@xs4all.nl>
References: <20180207143939.29491-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

If the device is of type VFL_TYPE_SUBDEV then vdev->ioctl_ops
is NULL so the 'if (!ops->vidioc_query_ext_ctrl)' check would crash.
Add a test for !ops to the condition.

All sub-devices that have controls will use the control framework,
so they do not have an equivalent to ops->vidioc_query_ext_ctrl.
Returning false if ops is NULL is the correct thing to do here.

Fixes: b8c601e8af ("v4l2-compat-ioctl32.c: fix ctrl_is_pointer")

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: <stable@vger.kernel.org>      # for v4.15 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index bdb5c226d01c..5198c9eeb348 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -770,7 +770,7 @@ static inline bool ctrl_is_pointer(struct file *file, u32 id)
 		return ctrl && ctrl->is_ptr;
 	}
 
-	if (!ops->vidioc_query_ext_ctrl)
+	if (!ops || !ops->vidioc_query_ext_ctrl)
 		return false;
 
 	return !ops->vidioc_query_ext_ctrl(file, fh, &qec) &&
-- 
2.15.1
