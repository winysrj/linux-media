Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4516 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab2FXL3L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:11 -0400
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
Subject: [RFC PATCH 02/26] saa7146: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:25:54 +0200
Message-Id: <69b55a1bac9833d7dba4d42cf41b3a5be3cd4cfb.1340536092.git.hans.verkuil@cisco.com>
In-Reply-To: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
References: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f854d2a0a932187cd895bf9cd81d2da8343b52c9.1340536092.git.hans.verkuil@cisco.com>
References: <f854d2a0a932187cd895bf9cd81d2da8343b52c9.1340536092.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add proper locking to the file operations, allowing for the removal
of the V4L2_FL_LOCK_ALL_FOPS flag.

I also removed some dead code in the form of the saa7146_devices list and
saa7146_devices_lock mutex: these were used once but that was a long time
ago.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/saa7146_core.c |    8 -----
 drivers/media/common/saa7146_fops.c |   55 +++++++++++++++++++++++++----------
 include/media/saa7146.h             |    4 ---
 3 files changed, 39 insertions(+), 28 deletions(-)

diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index d6b1cf6..bb6ee51 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -23,9 +23,6 @@
 #include <media/saa7146.h>
 #include <linux/module.h>
 
-LIST_HEAD(saa7146_devices);
-DEFINE_MUTEX(saa7146_devices_lock);
-
 static int saa7146_num;
 
 unsigned int saa7146_debug;
@@ -482,8 +479,6 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	   set it explicitly. */
 	pci_set_drvdata(pci, &dev->v4l2_dev);
 
-	INIT_LIST_HEAD(&dev->item);
-	list_add_tail(&dev->item,&saa7146_devices);
 	saa7146_num++;
 
 	err = 0;
@@ -545,7 +540,6 @@ static void saa7146_remove_one(struct pci_dev *pdev)
 
 	iounmap(dev->mem);
 	pci_release_region(pdev, 0);
-	list_del(&dev->item);
 	pci_disable_device(pdev);
 	kfree(dev);
 
@@ -592,8 +586,6 @@ EXPORT_SYMBOL_GPL(saa7146_setgpio);
 EXPORT_SYMBOL_GPL(saa7146_i2c_adapter_prepare);
 
 EXPORT_SYMBOL_GPL(saa7146_debug);
-EXPORT_SYMBOL_GPL(saa7146_devices);
-EXPORT_SYMBOL_GPL(saa7146_devices_lock);
 
 MODULE_AUTHOR("Michael Hunold <michael@mihu.de>");
 MODULE_DESCRIPTION("driver for generic saa7146-based hardware");
diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
index 0cdbd74..b3890bd 100644
--- a/drivers/media/common/saa7146_fops.c
+++ b/drivers/media/common/saa7146_fops.c
@@ -201,7 +201,7 @@ static int fops_open(struct file *file)
 
 	DEB_EE("file:%p, dev:%s\n", file, video_device_node_name(vdev));
 
-	if (mutex_lock_interruptible(&saa7146_devices_lock))
+	if (mutex_lock_interruptible(vdev->lock))
 		return -ERESTARTSYS;
 
 	DEB_D("using: %p\n", dev);
@@ -253,7 +253,7 @@ out:
 		kfree(fh);
 		file->private_data = NULL;
 	}
-	mutex_unlock(&saa7146_devices_lock);
+	mutex_unlock(vdev->lock);
 	return result;
 }
 
@@ -265,7 +265,7 @@ static int fops_release(struct file *file)
 
 	DEB_EE("file:%p\n", file);
 
-	if (mutex_lock_interruptible(&saa7146_devices_lock))
+	if (mutex_lock_interruptible(vdev->lock))
 		return -ERESTARTSYS;
 
 	if (vdev->vfl_type == VFL_TYPE_VBI) {
@@ -283,7 +283,7 @@ static int fops_release(struct file *file)
 	file->private_data = NULL;
 	kfree(fh);
 
-	mutex_unlock(&saa7146_devices_lock);
+	mutex_unlock(vdev->lock);
 
 	return 0;
 }
@@ -293,6 +293,7 @@ static int fops_mmap(struct file *file, struct vm_area_struct * vma)
 	struct video_device *vdev = video_devdata(file);
 	struct saa7146_fh *fh = file->private_data;
 	struct videobuf_queue *q;
+	int res;
 
 	switch (vdev->vfl_type) {
 	case VFL_TYPE_GRABBER: {
@@ -314,10 +315,14 @@ static int fops_mmap(struct file *file, struct vm_area_struct * vma)
 		return 0;
 	}
 
-	return videobuf_mmap_mapper(q,vma);
+	if (mutex_lock_interruptible(vdev->lock))
+		return -ERESTARTSYS;
+	res = videobuf_mmap_mapper(q, vma);
+	mutex_unlock(vdev->lock);
+	return res;
 }
 
-static unsigned int fops_poll(struct file *file, struct poll_table_struct *wait)
+static unsigned int __fops_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct saa7146_fh *fh = file->private_data;
@@ -356,10 +361,22 @@ static unsigned int fops_poll(struct file *file, struct poll_table_struct *wait)
 	return res;
 }
 
+static unsigned int fops_poll(struct file *file, struct poll_table_struct *wait)
+{
+	struct video_device *vdev = video_devdata(file);
+	unsigned int res;
+
+	mutex_lock(vdev->lock);
+	res = __fops_poll(file, wait);
+	mutex_unlock(vdev->lock);
+	return res;
+}
+
 static ssize_t fops_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct saa7146_fh *fh = file->private_data;
+	int ret;
 
 	switch (vdev->vfl_type) {
 	case VFL_TYPE_GRABBER:
@@ -373,8 +390,13 @@ static ssize_t fops_read(struct file *file, char __user *data, size_t count, lof
 		DEB_EE("V4L2_BUF_TYPE_VBI_CAPTURE: file:%p, data:%p, count:%lu\n",
 		       file, data, (unsigned long)count);
 */
-		if (fh->dev->ext_vv_data->capabilities & V4L2_CAP_VBI_CAPTURE)
-			return saa7146_vbi_uops.read(file,data,count,ppos);
+		if (fh->dev->ext_vv_data->capabilities & V4L2_CAP_VBI_CAPTURE) {
+			if (mutex_lock_interruptible(vdev->lock))
+				return -ERESTARTSYS;
+			ret = saa7146_vbi_uops.read(file, data, count, ppos);
+			mutex_unlock(vdev->lock);
+			return ret;
+		}
 		return -EINVAL;
 	default:
 		BUG();
@@ -386,15 +408,20 @@ static ssize_t fops_write(struct file *file, const char __user *data, size_t cou
 {
 	struct video_device *vdev = video_devdata(file);
 	struct saa7146_fh *fh = file->private_data;
+	int ret;
 
 	switch (vdev->vfl_type) {
 	case VFL_TYPE_GRABBER:
 		return -EINVAL;
 	case VFL_TYPE_VBI:
-		if (fh->dev->ext_vv_data->vbi_fops.write)
-			return fh->dev->ext_vv_data->vbi_fops.write(file, data, count, ppos);
-		else
-			return -EINVAL;
+		if (fh->dev->ext_vv_data->vbi_fops.write) {
+			if (mutex_lock_interruptible(vdev->lock))
+				return -ERESTARTSYS;
+			ret = fh->dev->ext_vv_data->vbi_fops.write(file, data, count, ppos);
+			mutex_unlock(vdev->lock);
+			return ret;
+		}
+		return -EINVAL;
 	default:
 		BUG();
 		return -EINVAL;
@@ -584,10 +611,6 @@ int saa7146_register_device(struct video_device **vid, struct saa7146_dev* dev,
 	else
 		vfd->ioctl_ops = &dev->ext_vv_data->vbi_ops;
 	vfd->release = video_device_release;
-	/* Locking in file operations other than ioctl should be done by
-	   the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 	vfd->lock = &dev->v4l2_lock;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	vfd->tvnorms = 0;
diff --git a/include/media/saa7146.h b/include/media/saa7146.h
index 773e527..96058a5 100644
--- a/include/media/saa7146.h
+++ b/include/media/saa7146.h
@@ -117,8 +117,6 @@ struct saa7146_dev
 {
 	struct module			*module;
 
-	struct list_head		item;
-
 	struct v4l2_device 		v4l2_dev;
 	struct v4l2_ctrl_handler	ctrl_handler;
 
@@ -166,8 +164,6 @@ static inline struct saa7146_dev *to_saa7146_dev(struct v4l2_device *v4l2_dev)
 int saa7146_i2c_adapter_prepare(struct saa7146_dev *dev, struct i2c_adapter *i2c_adapter, u32 bitrate);
 
 /* from saa7146_core.c */
-extern struct list_head saa7146_devices;
-extern struct mutex saa7146_devices_lock;
 int saa7146_register_extension(struct saa7146_extension*);
 int saa7146_unregister_extension(struct saa7146_extension*);
 struct saa7146_format* saa7146_format_by_fourcc(struct saa7146_dev *dev, int fourcc);
-- 
1.7.10

