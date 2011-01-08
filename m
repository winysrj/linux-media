Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3710 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab1AHNhC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 08:37:02 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id p08Dalk0015112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 8 Jan 2011 14:37:01 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 03/16] v4l2-fh: implement v4l2_priority support.
Date: Sat,  8 Jan 2011 14:36:28 +0100
Message-Id: <be212d62126afefaf0aaf3702507f239f5fda93e.1294493428.git.hverkuil@xs4all.nl>
In-Reply-To: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
References: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
References: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

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
1.7.0.4

