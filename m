Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1446 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab2FXL3M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Manjunatha Halli <manjunatha_halli@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Anatolij Gustschin <agust@denx.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sensoray Linux Development <linux-dev@sensoray.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	mitov@issp.bas.bg, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 13/26] vpif_capture: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:05 +0200
Message-Id: <079f72ea0066cd7b4d73f08861903b8899d6cc2b.1340536092.git.hans.verkuil@cisco.com>
In-Reply-To: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
References: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f854d2a0a932187cd895bf9cd81d2da8343b52c9.1340536092.git.hans.verkuil@cisco.com>
References: <f854d2a0a932187cd895bf9cd81d2da8343b52c9.1340536092.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add proper locking to the file operations, allowing for the removal
of the V4L2_FL_LOCK_ALL_FOPS flag.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/davinci/vpif_capture.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 9604695..425f6d8 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -713,10 +713,15 @@ static int vpif_mmap(struct file *filep, struct vm_area_struct *vma)
 	struct vpif_fh *fh = filep->private_data;
 	struct channel_obj *ch = fh->channel;
 	struct common_obj *common = &(ch->common[VPIF_VIDEO_INDEX]);
+	int ret;
 
 	vpif_dbg(2, debug, "vpif_mmap\n");
 
-	return videobuf_mmap_mapper(&common->buffer_queue, vma);
+	if (mutex_lock_interruptible(&common->lock))
+		return -ERESTARTSYS;
+	ret = videobuf_mmap_mapper(&common->buffer_queue, vma);
+	mutex_unlock(&common->lock);
+	return ret;
 }
 
 /**
@@ -729,12 +734,16 @@ static unsigned int vpif_poll(struct file *filep, poll_table * wait)
 	struct vpif_fh *fh = filep->private_data;
 	struct channel_obj *channel = fh->channel;
 	struct common_obj *common = &(channel->common[VPIF_VIDEO_INDEX]);
+	unsigned int res = 0;
 
 	vpif_dbg(2, debug, "vpif_poll\n");
 
-	if (common->started)
-		return videobuf_poll_stream(filep, &common->buffer_queue, wait);
-	return 0;
+	if (common->started) {
+		mutex_lock(&common->lock);
+		res = videobuf_poll_stream(filep, &common->buffer_queue, wait);
+		mutex_unlock(&common->lock);
+	}
+	return res;
 }
 
 /**
@@ -788,6 +797,10 @@ static int vpif_open(struct file *filep)
 		return -ENOMEM;
 	}
 
+	if (mutex_lock_interruptible(&common->lock)) {
+		kfree(fh);
+		return -ERESTARTSYS;
+	}
 	/* store pointer to fh in private_data member of filep */
 	filep->private_data = fh;
 	fh->channel = ch;
@@ -805,6 +818,7 @@ static int vpif_open(struct file *filep)
 	/* Initialize priority of this instance to default priority */
 	fh->prio = V4L2_PRIORITY_UNSET;
 	v4l2_prio_open(&ch->prio, &fh->prio);
+	mutex_unlock(&common->lock);
 	return 0;
 }
 
@@ -825,6 +839,7 @@ static int vpif_release(struct file *filep)
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
+	mutex_lock(&common->lock);
 	/* if this instance is doing IO */
 	if (fh->io_allowed[VPIF_VIDEO_INDEX]) {
 		/* Reset io_usrs member of channel object */
@@ -854,6 +869,7 @@ static int vpif_release(struct file *filep)
 	if (fh->initialized)
 		ch->initialized = 0;
 
+	mutex_unlock(&common->lock);
 	filep->private_data = NULL;
 	kfree(fh);
 	return 0;
@@ -2228,10 +2244,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 		common = &(ch->common[VPIF_VIDEO_INDEX]);
 		spin_lock_init(&common->irqlock);
 		mutex_init(&common->lock);
-		/* Locking in file operations other than ioctl should be done
-		   by the driver, not the V4L2 core.
-		   This driver needs auditing so that this flag can be removed. */
-		set_bit(V4L2_FL_LOCK_ALL_FOPS, &ch->video_dev->flags);
 		ch->video_dev->lock = &common->lock;
 		/* Initialize prio member of channel object */
 		v4l2_prio_init(&ch->prio);
-- 
1.7.10

