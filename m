Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:36151 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753472AbeC1OBr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 10:01:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 26/29] vim2m: use workqueue
Date: Wed, 28 Mar 2018 16:01:37 +0200
Message-Id: <20180328140140.42096-10-hverkuil@xs4all.nl>
In-Reply-To: <20180328140140.42096-1-hverkuil@xs4all.nl>
References: <20180328140140.42096-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l2_ctrl uses mutexes, so we can't setup a ctrl_handler in
interrupt context. Switch to a workqueue instead.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vim2m.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index ef970434af13..9b18b32c255d 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -150,6 +150,7 @@ struct vim2m_dev {
 	spinlock_t		irqlock;
 
 	struct timer_list	timer;
+	struct work_struct	work_run;
 
 	struct v4l2_m2m_dev	*m2m_dev;
 };
@@ -392,9 +393,10 @@ static void device_run(void *priv)
 	schedule_irq(dev, ctx->transtime);
 }
 
-static void device_isr(struct timer_list *t)
+static void device_work(struct work_struct *w)
 {
-	struct vim2m_dev *vim2m_dev = from_timer(vim2m_dev, t, timer);
+	struct vim2m_dev *vim2m_dev =
+		container_of(w, struct vim2m_dev, work_run);
 	struct vim2m_ctx *curr_ctx;
 	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	unsigned long flags;
@@ -426,6 +428,13 @@ static void device_isr(struct timer_list *t)
 	}
 }
 
+static void device_isr(struct timer_list *t)
+{
+	struct vim2m_dev *vim2m_dev = from_timer(vim2m_dev, t, timer);
+
+	schedule_work(&vim2m_dev->work_run);
+}
+
 /*
  * video ioctls
  */
@@ -806,6 +815,7 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
 	struct vb2_v4l2_buffer *vbuf;
 	unsigned long flags;
 
+	flush_scheduled_work();
 	for (;;) {
 		if (V4L2_TYPE_IS_OUTPUT(q->type))
 			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
@@ -1011,6 +1021,7 @@ static int vim2m_probe(struct platform_device *pdev)
 	vfd = &dev->vfd;
 	vfd->lock = &dev->dev_mutex;
 	vfd->v4l2_dev = &dev->v4l2_dev;
+	INIT_WORK(&dev->work_run, device_work);
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 	dev->mdev.dev = &pdev->dev;
-- 
2.15.1
