Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2236 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab2FVMVu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 08:21:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 32/34] v4l2-dev.c: also add debug support for the fops.
Date: Fri, 22 Jun 2012 14:21:26 +0200
Message-Id: <b4bdccc87fa1e14e3605c28468a67ebdf290ff83.1340366355.git.hans.verkuil@cisco.com>
In-Reply-To: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
References: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-dev.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 1b34360..b51bee9 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -305,6 +305,9 @@ static ssize_t v4l2_read(struct file *filp, char __user *buf,
 		ret = vdev->fops->read(filp, buf, sz, off);
 	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
 		mutex_unlock(vdev->lock);
+	if (vdev->debug)
+		printk(KERN_DEBUG "%s: read: %zd (%d)\n",
+			video_device_node_name(vdev), sz, ret);
 	return ret;
 }
 
@@ -323,6 +326,9 @@ static ssize_t v4l2_write(struct file *filp, const char __user *buf,
 		ret = vdev->fops->write(filp, buf, sz, off);
 	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
 		mutex_unlock(vdev->lock);
+	if (vdev->debug)
+		printk(KERN_DEBUG "%s: write: %zd (%d)\n",
+			video_device_node_name(vdev), sz, ret);
 	return ret;
 }
 
@@ -339,6 +345,9 @@ static unsigned int v4l2_poll(struct file *filp, struct poll_table_struct *poll)
 		ret = vdev->fops->poll(filp, poll);
 	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
 		mutex_unlock(vdev->lock);
+	if (vdev->debug)
+		printk(KERN_DEBUG "%s: poll: %08x\n",
+			video_device_node_name(vdev), ret);
 	return ret;
 }
 
@@ -403,12 +412,17 @@ static unsigned long v4l2_get_unmapped_area(struct file *filp,
 		unsigned long flags)
 {
 	struct video_device *vdev = video_devdata(filp);
+	int ret;
 
 	if (!vdev->fops->get_unmapped_area)
 		return -ENOSYS;
 	if (!video_is_registered(vdev))
 		return -ENODEV;
-	return vdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
+	ret = vdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
+	if (vdev->debug)
+		printk(KERN_DEBUG "%s: get_unmapped_area (%d)\n",
+			video_device_node_name(vdev), ret);
+	return ret;
 }
 #endif
 
@@ -426,6 +440,9 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 		ret = vdev->fops->mmap(filp, vm);
 	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
 		mutex_unlock(vdev->lock);
+	if (vdev->debug)
+		printk(KERN_DEBUG "%s: mmap (%d)\n",
+			video_device_node_name(vdev), ret);
 	return ret;
 }
 
@@ -464,6 +481,9 @@ err:
 	/* decrease the refcount in case of an error */
 	if (ret)
 		video_put(vdev);
+	if (vdev->debug)
+		printk(KERN_DEBUG "%s: open (%d)\n",
+			video_device_node_name(vdev), ret);
 	return ret;
 }
 
@@ -483,6 +503,9 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
 	video_put(vdev);
+	if (vdev->debug)
+		printk(KERN_DEBUG "%s: release\n",
+			video_device_node_name(vdev));
 	return ret;
 }
 
-- 
1.7.10

