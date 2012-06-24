Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3988 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab2FXL3V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:21 -0400
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
Subject: [RFC PATCH 16/26] sh_vou: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:08 +0200
Message-Id: <806210a569f1cdffff181b960f669d3ca8b969c6.1340536092.git.hans.verkuil@cisco.com>
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
 drivers/media/video/sh_vou.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/sh_vou.c b/drivers/media/video/sh_vou.c
index 8fd1874..9f62fd8 100644
--- a/drivers/media/video/sh_vou.c
+++ b/drivers/media/video/sh_vou.c
@@ -1171,6 +1171,8 @@ static int sh_vou_open(struct file *file)
 
 	file->private_data = vou_file;
 
+	if (mutex_lock_interruptible(&vou_dev->fop_lock))
+		return -ERESTARTSYS;
 	if (atomic_inc_return(&vou_dev->use_count) == 1) {
 		int ret;
 		/* First open */
@@ -1181,6 +1183,7 @@ static int sh_vou_open(struct file *file)
 			atomic_dec(&vou_dev->use_count);
 			pm_runtime_put(vdev->v4l2_dev->dev);
 			vou_dev->status = SH_VOU_IDLE;
+			mutex_unlock(&vou_dev->fop_lock);
 			return ret;
 		}
 	}
@@ -1191,6 +1194,7 @@ static int sh_vou_open(struct file *file)
 				       V4L2_FIELD_NONE,
 				       sizeof(struct videobuf_buffer), vdev,
 				       &vou_dev->fop_lock);
+	mutex_unlock(&vou_dev->fop_lock);
 
 	return 0;
 }
@@ -1204,10 +1208,12 @@ static int sh_vou_release(struct file *file)
 	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
 
 	if (!atomic_dec_return(&vou_dev->use_count)) {
+		mutex_lock(&vou_dev->fop_lock);
 		/* Last close */
 		vou_dev->status = SH_VOU_IDLE;
 		sh_vou_reg_a_set(vou_dev, VOUER, 0, 0x101);
 		pm_runtime_put(vdev->v4l2_dev->dev);
+		mutex_unlock(&vou_dev->fop_lock);
 	}
 
 	file->private_data = NULL;
@@ -1218,20 +1224,31 @@ static int sh_vou_release(struct file *file)
 
 static int sh_vou_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
 	struct sh_vou_file *vou_file = file->private_data;
+	int ret;
 
 	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
 
-	return videobuf_mmap_mapper(&vou_file->vbq, vma);
+	if (mutex_lock_interruptible(&vou_dev->fop_lock))
+		return -ERESTARTSYS;
+	ret = videobuf_mmap_mapper(&vou_file->vbq, vma);
+	mutex_unlock(&vou_dev->fop_lock);
+	return ret;
 }
 
 static unsigned int sh_vou_poll(struct file *file, poll_table *wait)
 {
+	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
 	struct sh_vou_file *vou_file = file->private_data;
+	unsigned int res;
 
 	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
 
-	return videobuf_poll_stream(file, &vou_file->vbq, wait);
+	mutex_lock(&vou_dev->fop_lock);
+	res = videobuf_poll_stream(file, &vou_file->vbq, wait);
+	mutex_unlock(&vou_dev->fop_lock);
+	return res;
 }
 
 static int sh_vou_g_chip_ident(struct file *file, void *fh,
@@ -1390,10 +1407,6 @@ static int __devinit sh_vou_probe(struct platform_device *pdev)
 	vdev->v4l2_dev = &vou_dev->v4l2_dev;
 	vdev->release = video_device_release;
 	vdev->lock = &vou_dev->fop_lock;
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags);
 
 	vou_dev->vdev = vdev;
 	video_set_drvdata(vdev, vou_dev);
-- 
1.7.10

