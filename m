Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2015 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab2FXL3K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:10 -0400
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
Subject: [RFC PATCH 14/26] vpif_display: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:06 +0200
Message-Id: <e0912d8977422112d37fa7e6151a07ca9ec890cc.1340536092.git.hans.verkuil@cisco.com>
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
 drivers/media/video/davinci/vpif_display.c |   34 +++++++++++++++++++---------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index e6488ee..43e818a 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -580,10 +580,15 @@ static int vpif_mmap(struct file *filep, struct vm_area_struct *vma)
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
 
 /*
@@ -594,11 +599,15 @@ static unsigned int vpif_poll(struct file *filep, poll_table *wait)
 	struct vpif_fh *fh = filep->private_data;
 	struct channel_obj *ch = fh->channel;
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
+	unsigned int res = 0;
 
-	if (common->started)
-		return videobuf_poll_stream(filep, &common->buffer_queue, wait);
+	if (common->started) {
+		mutex_lock(&common->lock);
+		res = videobuf_poll_stream(filep, &common->buffer_queue, wait);
+		mutex_unlock(&common->lock);
+	}
 
-	return 0;
+	return res;
 }
 
 /*
@@ -608,10 +617,10 @@ static unsigned int vpif_poll(struct file *filep, poll_table *wait)
 static int vpif_open(struct file *filep)
 {
 	struct video_device *vdev = video_devdata(filep);
-	struct channel_obj *ch = NULL;
-	struct vpif_fh *fh = NULL;
+	struct channel_obj *ch = video_get_drvdata(vdev);
+	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
+	struct vpif_fh *fh;
 
-	ch = video_get_drvdata(vdev);
 	/* Allocate memory for the file handle object */
 	fh = kzalloc(sizeof(struct vpif_fh), GFP_KERNEL);
 	if (fh == NULL) {
@@ -619,6 +628,10 @@ static int vpif_open(struct file *filep)
 		return -ENOMEM;
 	}
 
+	if (mutex_lock_interruptible(&common->lock)) {
+		kfree(fh);
+		return -ERESTARTSYS;
+	}
 	/* store pointer to fh in private_data member of filep */
 	filep->private_data = fh;
 	fh->channel = ch;
@@ -636,6 +649,7 @@ static int vpif_open(struct file *filep)
 	/* Initialize priority of this instance to default priority */
 	fh->prio = V4L2_PRIORITY_UNSET;
 	v4l2_prio_open(&ch->prio, &fh->prio);
+	mutex_unlock(&common->lock);
 
 	return 0;
 }
@@ -650,6 +664,7 @@ static int vpif_release(struct file *filep)
 	struct channel_obj *ch = fh->channel;
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
+	mutex_lock(&common->lock);
 	/* if this instance is doing IO */
 	if (fh->io_allowed[VPIF_VIDEO_INDEX]) {
 		/* Reset io_usrs member of channel object */
@@ -682,6 +697,7 @@ static int vpif_release(struct file *filep)
 	v4l2_prio_close(&ch->prio, fh->prio);
 	filep->private_data = NULL;
 	fh->initialized = 0;
+	mutex_unlock(&common->lock);
 	kfree(fh);
 
 	return 0;
@@ -1778,10 +1794,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 		v4l2_prio_init(&ch->prio);
 		ch->common[VPIF_VIDEO_INDEX].fmt.type =
 						V4L2_BUF_TYPE_VIDEO_OUTPUT;
-		/* Locking in file operations other than ioctl should be done
-		   by the driver, not the V4L2 core.
-		   This driver needs auditing so that this flag can be removed. */
-		set_bit(V4L2_FL_LOCK_ALL_FOPS, &ch->video_dev->flags);
 		ch->video_dev->lock = &common->lock;
 
 		/* register video device */
-- 
1.7.10

