Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:43276 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753104AbeENL4N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 07:56:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@pobox.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [RFC PATCH 6/6] v4l2-ioctl.c: assume queue->lock is always set
Date: Mon, 14 May 2018 13:56:02 +0200
Message-Id: <20180514115602.9791-7-hverkuil@xs4all.nl>
In-Reply-To: <20180514115602.9791-1-hverkuil@xs4all.nl>
References: <20180514115602.9791-1-hverkuil@xs4all.nl>
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
index b871b8fe5105..15bfbc6ce6c0 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2681,12 +2681,11 @@ static struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev,
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
2.17.0
