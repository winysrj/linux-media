Return-path: <mchehab@gaivota>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4623 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab0L2VnL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 16:43:11 -0500
Received: from localhost (marune.xs4all.nl [82.95.89.49])
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBTLhApC003744
	for <linux-media@vger.kernel.org>; Wed, 29 Dec 2010 22:43:10 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Message-Id: <090f6f177698b9ae87d15802b1493a588e6e517c.1293657717.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1293657717.git.hverkuil@xs4all.nl>
References: <cover.1293657717.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 29 Dec 2010 22:43:10 +0100
Subject: [PATCH 03/10] [RFC] v4l2-fh: implement v4l2_priority support.
To: linux-media@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-fh.c |    4 ++++
 include/media/v4l2-fh.h       |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
index d78f184..78a1608 100644
--- a/drivers/media/video/v4l2-fh.c
+++ b/drivers/media/video/v4l2-fh.c
@@ -33,6 +33,8 @@ int v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 	fh->vdev = vdev;
 	INIT_LIST_HEAD(&fh->list);
 	set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
+	fh->prio = V4L2_PRIORITY_UNSET;
+	BUG_ON(vdev->prio == NULL);
 
 	/*
 	 * fh->events only needs to be initialized if the driver
@@ -51,6 +53,7 @@ void v4l2_fh_add(struct v4l2_fh *fh)
 {
 	unsigned long flags;
 
+	v4l2_prio_open(fh->vdev->prio, &fh->prio);
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 	list_add(&fh->list, &fh->vdev->fh_list);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
@@ -64,6 +67,7 @@ void v4l2_fh_del(struct v4l2_fh *fh)
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 	list_del_init(&fh->list);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+	v4l2_prio_close(fh->vdev->prio, fh->prio);
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_del);
 
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 1d72dde..5fc5ba9 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -35,6 +35,7 @@ struct v4l2_fh {
 	struct list_head	list;
 	struct video_device	*vdev;
 	struct v4l2_events      *events; /* events, pending and subscribed */
+	enum v4l2_priority	prio;
 };
 
 /*
-- 
1.6.4.2

