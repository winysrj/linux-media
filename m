Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38878 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323AbaLANLb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 08:11:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/4] v4l2 core: improve debug flag handling
Date: Mon,  1 Dec 2014 14:10:44 +0100
Message-Id: <1417439445-34862-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1417439445-34862-1-git-send-email-hverkuil@xs4all.nl>
References: <1417439445-34862-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The old debug field is renamed to dev_debug to ensure that existing drivers
(including out-of-tree drivers) that try to use the old name will no longer
compile. A comment has also been added that makes it explicit that drivers
shouldn't use this field.

Additional bits have been added to the debug flag to be more fine-grained
when debugging, especially when dealing with streaming ioctls and read,
write and poll. You want to enable those explicitly to prevent flooding
the log when streaming unless you actually want to do that.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dev.c   | 28 +++++++++++++++-------------
 drivers/media/v4l2-core/v4l2-ioctl.c | 10 +++++++---
 include/media/v4l2-dev.h             |  3 ++-
 include/media/v4l2-ioctl.h           | 15 ++++++++++++---
 4 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index a13cc61..86bb93f 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -47,15 +47,15 @@ static ssize_t index_show(struct device *cd,
 }
 static DEVICE_ATTR_RO(index);
 
-static ssize_t debug_show(struct device *cd,
+static ssize_t dev_debug_show(struct device *cd,
 			  struct device_attribute *attr, char *buf)
 {
 	struct video_device *vdev = to_video_device(cd);
 
-	return sprintf(buf, "%i\n", vdev->debug);
+	return sprintf(buf, "%i\n", vdev->dev_debug);
 }
 
-static ssize_t debug_store(struct device *cd, struct device_attribute *attr,
+static ssize_t dev_debug_store(struct device *cd, struct device_attribute *attr,
 			  const char *buf, size_t len)
 {
 	struct video_device *vdev = to_video_device(cd);
@@ -66,10 +66,10 @@ static ssize_t debug_store(struct device *cd, struct device_attribute *attr,
 	if (res)
 		return res;
 
-	vdev->debug = value;
+	vdev->dev_debug = value;
 	return len;
 }
-static DEVICE_ATTR_RW(debug);
+static DEVICE_ATTR_RW(dev_debug);
 
 static ssize_t name_show(struct device *cd,
 			 struct device_attribute *attr, char *buf)
@@ -82,7 +82,7 @@ static DEVICE_ATTR_RO(name);
 
 static struct attribute *video_device_attrs[] = {
 	&dev_attr_name.attr,
-	&dev_attr_debug.attr,
+	&dev_attr_dev_debug.attr,
 	&dev_attr_index.attr,
 	NULL,
 };
@@ -304,7 +304,8 @@ static ssize_t v4l2_read(struct file *filp, char __user *buf,
 		return -EINVAL;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->read(filp, buf, sz, off);
-	if (vdev->debug)
+	if ((vdev->dev_debug & V4L2_DEV_DEBUG_FOP) &&
+	    (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING))
 		printk(KERN_DEBUG "%s: read: %zd (%d)\n",
 			video_device_node_name(vdev), sz, ret);
 	return ret;
@@ -320,7 +321,8 @@ static ssize_t v4l2_write(struct file *filp, const char __user *buf,
 		return -EINVAL;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->write(filp, buf, sz, off);
-	if (vdev->debug)
+	if ((vdev->dev_debug & V4L2_DEV_DEBUG_FOP) &&
+	    (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING))
 		printk(KERN_DEBUG "%s: write: %zd (%d)\n",
 			video_device_node_name(vdev), sz, ret);
 	return ret;
@@ -335,7 +337,7 @@ static unsigned int v4l2_poll(struct file *filp, struct poll_table_struct *poll)
 		return DEFAULT_POLLMASK;
 	if (video_is_registered(vdev))
 		res = vdev->fops->poll(filp, poll);
-	if (vdev->debug > 2)
+	if (vdev->dev_debug & V4L2_DEV_DEBUG_POLL)
 		printk(KERN_DEBUG "%s: poll: %08x\n",
 			video_device_node_name(vdev), res);
 	return res;
@@ -404,7 +406,7 @@ static unsigned long v4l2_get_unmapped_area(struct file *filp,
 	if (!video_is_registered(vdev))
 		return -ENODEV;
 	ret = vdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
-	if (vdev->debug)
+	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
 		printk(KERN_DEBUG "%s: get_unmapped_area (%d)\n",
 			video_device_node_name(vdev), ret);
 	return ret;
@@ -420,7 +422,7 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 		return -ENODEV;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->mmap(filp, vm);
-	if (vdev->debug)
+	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
 		printk(KERN_DEBUG "%s: mmap (%d)\n",
 			video_device_node_name(vdev), ret);
 	return ret;
@@ -450,7 +452,7 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 			ret = -ENODEV;
 	}
 
-	if (vdev->debug)
+	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
 		printk(KERN_DEBUG "%s: open (%d)\n",
 			video_device_node_name(vdev), ret);
 	/* decrease the refcount in case of an error */
@@ -467,7 +469,7 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 
 	if (vdev->fops->release)
 		ret = vdev->fops->release(filp);
-	if (vdev->debug)
+	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
 		printk(KERN_DEBUG "%s: release\n",
 			video_device_node_name(vdev));
 
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 1bf84a5..8fc0d98 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2330,7 +2330,7 @@ static long __video_do_ioctl(struct file *file,
 	const struct v4l2_ioctl_info *info;
 	void *fh = file->private_data;
 	struct v4l2_fh *vfh = NULL;
-	int debug = vfd->debug;
+	int dev_debug = vfd->dev_debug;
 	long ret = -ENOTTY;
 
 	if (ops == NULL) {
@@ -2379,11 +2379,15 @@ static long __video_do_ioctl(struct file *file,
 	}
 
 done:
-	if (debug) {
+	if (dev_debug & (V4L2_DEV_DEBUG_IOCTL | V4L2_DEV_DEBUG_IOCTL_ARG)) {
+		if (!(dev_debug & V4L2_DEV_DEBUG_STREAMING) &&
+		    (cmd == VIDIOC_QBUF || cmd == VIDIOC_DQBUF))
+			return ret;
+
 		v4l_printk_ioctl(video_device_node_name(vfd), cmd);
 		if (ret < 0)
 			pr_cont(": error %ld", ret);
-		if (debug == V4L2_DEBUG_IOCTL)
+		if (!(dev_debug & V4L2_DEV_DEBUG_IOCTL_ARG))
 			pr_cont("\n");
 		else if (_IOC_DIR(cmd) == _IOC_NONE)
 			info->debug(arg, write_only);
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index eb76cfd..3e4fddf 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -124,7 +124,8 @@ struct video_device
 	spinlock_t		fh_lock; /* Lock for all v4l2_fhs */
 	struct list_head	fh_list; /* List of struct v4l2_fh */
 
-	int debug;			/* Activates debug level*/
+	/* Internal device debug flags, not for use by drivers */
+	int dev_debug;
 
 	/* Video standard vars */
 	v4l2_std_id tvnorms;		/* Supported tv norms */
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 53605f0..8537983 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -291,9 +291,18 @@ struct v4l2_ioctl_ops {
 
 /* v4l debugging and diagnostics */
 
-/* Debug bitmask flags to be used on V4L2 */
-#define V4L2_DEBUG_IOCTL     0x01
-#define V4L2_DEBUG_IOCTL_ARG 0x02
+/* Device debug flags to be used with the video device debug attribute */
+
+/* Just log the ioctl name + error code */
+#define V4L2_DEV_DEBUG_IOCTL		0x01
+/* Log the ioctl name arguments + error code */
+#define V4L2_DEV_DEBUG_IOCTL_ARG	0x02
+/* Log the file operations open, release, mmap and get_unmapped_area */
+#define V4L2_DEV_DEBUG_FOP		0x04
+/* Log the read and write file operations and the VIDIOC_(D)QBUF ioctls */
+#define V4L2_DEV_DEBUG_STREAMING	0x08
+/* Log poll() */
+#define V4L2_DEV_DEBUG_POLL		0x10
 
 /*  Video standard functions  */
 extern const char *v4l2_norm_to_name(v4l2_std_id id);
-- 
2.1.3

