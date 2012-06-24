Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2787 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab2FXL3J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:09 -0400
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
Subject: [RFC PATCH 12/26] vpbe_display: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:04 +0200
Message-Id: <6f98a3f4ca2270d55892590f0d178a1123a4a244.1340536092.git.hans.verkuil@cisco.com>
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
 drivers/media/video/davinci/vpbe_display.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/davinci/vpbe_display.c b/drivers/media/video/davinci/vpbe_display.c
index e106b72..0f473f6 100644
--- a/drivers/media/video/davinci/vpbe_display.c
+++ b/drivers/media/video/davinci/vpbe_display.c
@@ -1376,10 +1376,15 @@ static int vpbe_display_mmap(struct file *filep, struct vm_area_struct *vma)
 	struct vpbe_fh *fh = filep->private_data;
 	struct vpbe_layer *layer = fh->layer;
 	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	int ret;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_display_mmap\n");
 
-	return videobuf_mmap_mapper(&layer->buffer_queue, vma);
+	if (mutex_lock_interruptible(&layer->opslock))
+		return -ERESTARTSYS;
+	ret = videobuf_mmap_mapper(&layer->buffer_queue, vma);
+	mutex_unlock(&layer->opslock);
+	return ret;
 }
 
 /* vpbe_display_poll(): It is used for select/poll system call
@@ -1392,8 +1397,11 @@ static unsigned int vpbe_display_poll(struct file *filep, poll_table *wait)
 	unsigned int err = 0;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_display_poll\n");
-	if (layer->started)
+	if (layer->started) {
+		mutex_lock(&layer->opslock);
 		err = videobuf_poll_stream(filep, &layer->buffer_queue, wait);
+		mutex_unlock(&layer->opslock);
+	}
 	return err;
 }
 
@@ -1428,10 +1436,12 @@ static int vpbe_display_open(struct file *file)
 	fh->disp_dev = disp_dev;
 
 	if (!layer->usrs) {
-
+		if (mutex_lock_interruptible(&layer->opslock))
+			return -ERESTARTSYS;
 		/* First claim the layer for this device */
 		err = osd_device->ops.request_layer(osd_device,
 						layer->layer_info.id);
+		mutex_unlock(&layer->opslock);
 		if (err < 0) {
 			/* Couldn't get layer */
 			v4l2_err(&vpbe_dev->v4l2_dev,
@@ -1469,6 +1479,7 @@ static int vpbe_display_release(struct file *file)
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_display_release\n");
 
+	mutex_lock(&layer->opslock);
 	/* if this instance is doing IO */
 	if (fh->io_allowed) {
 		/* Reset io_usrs member of layer object */
@@ -1503,6 +1514,7 @@ static int vpbe_display_release(struct file *file)
 	/* Close the priority */
 	v4l2_prio_close(&layer->prio, fh->prio);
 	file->private_data = NULL;
+	mutex_unlock(&layer->opslock);
 
 	/* Free memory allocated to file handle object */
 	kfree(fh);
@@ -1618,10 +1630,6 @@ static __devinit int init_vpbe_layer(int i, struct vpbe_display *disp_dev,
 	vbd->ioctl_ops	= &vpbe_ioctl_ops;
 	vbd->minor	= -1;
 	vbd->v4l2_dev   = &disp_dev->vpbe_dev->v4l2_dev;
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vbd->flags);
 	vbd->lock	= &vpbe_display_layer->opslock;
 
 	if (disp_dev->vpbe_dev->current_timings.timings_type &
-- 
1.7.10

