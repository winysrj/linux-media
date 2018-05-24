Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56708 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161263AbeEXUhU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 16:37:20 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Abylay Ospan <aospan@netup.ru>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 16/20] stk1160: Set the vb2_queue lock before calling vb2_queue_init
Date: Thu, 24 May 2018 17:35:16 -0300
Message-Id: <20180524203520.1598-17-ezequiel@collabora.com>
In-Reply-To: <20180524203520.1598-1-ezequiel@collabora.com>
References: <20180524203520.1598-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vb2_queue will soon be mandatory. The videobuf2 core
will throw a verbose warning if it's not set.

The stk1160 driver is setting the queue lock, but after
the vb2_queue_init call. Avoid the warning by setting
the lock before the queue initialization.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/usb/stk1160/stk1160-v4l.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 77b759a0bcd9..504e413edcd2 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -802,6 +802,7 @@ int stk1160_vb2_setup(struct stk1160 *dev)
 	q->buf_struct_size = sizeof(struct stk1160_buffer);
 	q->ops = &stk1160_video_qops;
 	q->mem_ops = &vb2_vmalloc_memops;
+	q->lock = &dev->vb_queue_lock;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 
 	rc = vb2_queue_init(q);
@@ -827,7 +828,6 @@ int stk1160_video_register(struct stk1160 *dev)
 	 * It will be used to protect *only* v4l2 ioctls.
 	 */
 	dev->vdev.lock = &dev->v4l_lock;
-	dev->vdev.queue->lock = &dev->vb_queue_lock;
 
 	/* This will be used to set video_device parent */
 	dev->vdev.v4l2_dev = &dev->v4l2_dev;
-- 
2.16.3
