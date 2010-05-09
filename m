Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4415 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab0EIT1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 15:27:39 -0400
Received: from localhost (cm-84.208.87.21.getinternet.no [84.208.87.21])
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id o49JRaFQ030330
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 9 May 2010 21:27:37 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Message-Id: <32e22cd465fb61e524a4906dfd77f58645ef3ff9.1273432986.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1273432986.git.hverkuil@xs4all.nl>
References: <cover.1273432986.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 09 May 2010 21:29:12 +0200
Subject: [PATCH 3/7] [RFC] v4l2-fh: implement v4l2_priority support.
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-fh.c |    4 ++++
 include/media/v4l2-fh.h       |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
index d78f184..d57908a 100644
--- a/drivers/media/video/v4l2-fh.c
+++ b/drivers/media/video/v4l2-fh.c
@@ -27,12 +27,14 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
 
 int v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 {
 	fh->vdev = vdev;
 	INIT_LIST_HEAD(&fh->list);
 	set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
+	fh->prio = V4L2_PRIORITY_UNSET;
 
 	/*
 	 * fh->events only needs to be initialized if the driver
@@ -51,6 +53,7 @@ void v4l2_fh_add(struct v4l2_fh *fh)
 {
 	unsigned long flags;
 
+	v4l2_prio_open(&fh->vdev->v4l2_dev->prio, &fh->prio);
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 	list_add(&fh->list, &fh->vdev->fh_list);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
@@ -64,6 +67,7 @@ void v4l2_fh_del(struct v4l2_fh *fh)
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 	list_del_init(&fh->list);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+	v4l2_prio_close(&fh->vdev->v4l2_dev->prio, fh->prio);
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_del);
 
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 1d72dde..ff513fe 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -35,6 +35,7 @@ struct v4l2_fh {
 	struct list_head	list;
 	struct video_device	*vdev;
 	struct v4l2_events      *events; /* events, pending and subscribed */
+	enum v4l2_priority 	prio;
 };
 
 /*
-- 
1.6.4.2

