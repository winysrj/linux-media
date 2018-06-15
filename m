Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35918 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965052AbeFOTIU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 15:08:20 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH v4 16/17] v4l2-ioctl.c: assume queue->lock is always set
Date: Fri, 15 Jun 2018 16:07:36 -0300
Message-Id: <20180615190737.24139-17-ezequiel@collabora.com>
In-Reply-To: <20180615190737.24139-1-ezequiel@collabora.com>
References: <20180615190737.24139-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

vb2_queue now expects a valid lock pointer, so drop the checks for
that in v4l2-ioctl.c.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index db835578e21f..c3da0f9a86e4 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2715,12 +2715,11 @@ static struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev,
 		struct v4l2_m2m_queue_ctx *ctx = is_output ?
 			&vfh->m2m_ctx->out_q_ctx : &vfh->m2m_ctx->cap_q_ctx;
 
-		if (ctx->q.lock)
-			return ctx->q.lock;
+		return ctx->q.lock;
 	}
 #endif
-	if (vdev->queue && vdev->queue->lock &&
-			(v4l2_ioctls[_IOC_NR(cmd)].flags & INFO_FL_QUEUE))
+	if (vdev->queue &&
+	    (v4l2_ioctls[_IOC_NR(cmd)].flags & INFO_FL_QUEUE))
 		return vdev->queue->lock;
 	return vdev->lock;
 }
-- 
2.17.1
