Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56732 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161272AbeEXUh0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 16:37:26 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Abylay Ospan <aospan@netup.ru>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 19/20] v4l2-ioctl.c: assume queue->lock is always set
Date: Thu, 24 May 2018 17:35:19 -0300
Message-Id: <20180524203520.1598-20-ezequiel@collabora.com>
In-Reply-To: <20180524203520.1598-1-ezequiel@collabora.com>
References: <20180524203520.1598-1-ezequiel@collabora.com>
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
index ee1eec136e55..834e3de69992 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2694,12 +2694,11 @@ static struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev,
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
2.16.3
