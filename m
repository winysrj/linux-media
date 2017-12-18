Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63323 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758693AbdLRTyI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 14:54:08 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 2/8] media: v4l2-ioctl.h: convert debug into an enum of bits
Date: Mon, 18 Dec 2017 17:53:56 -0200
Message-Id: <333b63fa1857f6819ce64666beba969c22e2f468.1513625884.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513625884.git.mchehab@s-opensource.com>
References: <cover.1513625884.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513625884.git.mchehab@s-opensource.com>
References: <cover.1513625884.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_DEV_DEBUG_IOCTL macros actually define a bitmask,
but without using Kernel's modern standards. Also,
documentation looks akward.

So, convert them into an enum with valid bits, adding
the correspoinding kernel-doc documentation for it.

In order to avoid possible conflicts, rename them from
V4L2_DEV_DEBUG_foo to V4L2_DEBUG_foo.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-dev.c   | 18 +++++++++---------
 drivers/media/v4l2-core/v4l2-ioctl.c |  7 ++++---
 include/media/v4l2-ioctl.h           | 33 +++++++++++++++++++--------------
 3 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index d5e0e536ef04..ab876ddaa707 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -307,8 +307,8 @@ static ssize_t v4l2_read(struct file *filp, char __user *buf,
 		return -EINVAL;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->read(filp, buf, sz, off);
-	if ((vdev->dev_debug & V4L2_DEV_DEBUG_FOP) &&
-	    (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING))
+	if ((vdev->dev_debug & BIT(V4L2_DEBUG_FOP)) &&
+	    (vdev->dev_debug & BIT(V4L2_DEBUG_STREAMING)))
 		printk(KERN_DEBUG "%s: read: %zd (%d)\n",
 			video_device_node_name(vdev), sz, ret);
 	return ret;
@@ -324,8 +324,8 @@ static ssize_t v4l2_write(struct file *filp, const char __user *buf,
 		return -EINVAL;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->write(filp, buf, sz, off);
-	if ((vdev->dev_debug & V4L2_DEV_DEBUG_FOP) &&
-	    (vdev->dev_debug & V4L2_DEV_DEBUG_STREAMING))
+	if ((vdev->dev_debug & BIT(V4L2_DEBUG_FOP)) &&
+	    (vdev->dev_debug & BIT(V4L2_DEBUG_STREAMING)))
 		printk(KERN_DEBUG "%s: write: %zd (%d)\n",
 			video_device_node_name(vdev), sz, ret);
 	return ret;
@@ -340,7 +340,7 @@ static unsigned int v4l2_poll(struct file *filp, struct poll_table_struct *poll)
 		return DEFAULT_POLLMASK;
 	if (video_is_registered(vdev))
 		res = vdev->fops->poll(filp, poll);
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_POLL)
+	if (vdev->dev_debug & BIT(V4L2_DEBUG_POLL))
 		printk(KERN_DEBUG "%s: poll: %08x\n",
 			video_device_node_name(vdev), res);
 	return res;
@@ -381,7 +381,7 @@ static unsigned long v4l2_get_unmapped_area(struct file *filp,
 	if (!video_is_registered(vdev))
 		return -ENODEV;
 	ret = vdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
+	if (vdev->dev_debug & BIT(V4L2_DEBUG_FOP))
 		printk(KERN_DEBUG "%s: get_unmapped_area (%d)\n",
 			video_device_node_name(vdev), ret);
 	return ret;
@@ -397,7 +397,7 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
 		return -ENODEV;
 	if (video_is_registered(vdev))
 		ret = vdev->fops->mmap(filp, vm);
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
+	if (vdev->dev_debug & BIT(V4L2_DEBUG_FOP))
 		printk(KERN_DEBUG "%s: mmap (%d)\n",
 			video_device_node_name(vdev), ret);
 	return ret;
@@ -427,7 +427,7 @@ static int v4l2_open(struct inode *inode, struct file *filp)
 			ret = -ENODEV;
 	}
 
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
+	if (vdev->dev_debug & BIT(V4L2_DEBUG_FOP))
 		printk(KERN_DEBUG "%s: open (%d)\n",
 			video_device_node_name(vdev), ret);
 	/* decrease the refcount in case of an error */
@@ -444,7 +444,7 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 
 	if (vdev->fops->release)
 		ret = vdev->fops->release(filp);
-	if (vdev->dev_debug & V4L2_DEV_DEBUG_FOP)
+	if (vdev->dev_debug & BIT(V4L2_DEBUG_FOP))
 		printk(KERN_DEBUG "%s: release\n",
 			video_device_node_name(vdev));
 
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 79614992ee21..cdd1e9470dbe 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2760,15 +2760,16 @@ static long __video_do_ioctl(struct file *file,
 	}
 
 done:
-	if (dev_debug & (V4L2_DEV_DEBUG_IOCTL | V4L2_DEV_DEBUG_IOCTL_ARG)) {
-		if (!(dev_debug & V4L2_DEV_DEBUG_STREAMING) &&
+	if (dev_debug & (BIT(V4L2_DEBUG_IOCTL)
+			 | BIT(V4L2_DEBUG_IOCTL_ARG))) {
+		if (!(dev_debug & BIT(V4L2_DEBUG_STREAMING)) &&
 		    (cmd == VIDIOC_QBUF || cmd == VIDIOC_DQBUF))
 			return ret;
 
 		v4l_printk_ioctl(video_device_node_name(vfd), cmd);
 		if (ret < 0)
 			pr_cont(": error %ld", ret);
-		if (!(dev_debug & V4L2_DEV_DEBUG_IOCTL_ARG))
+		if (!(dev_debug & BIT(V4L2_DEBUG_IOCTL_ARG)))
 			pr_cont("\n");
 		else if (_IOC_DIR(cmd) == _IOC_NONE)
 			info->debug(arg, write_only);
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index a7b3f7c75d62..9f8d04ad4bdd 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -589,20 +589,25 @@ struct v4l2_ioctl_ops {
 };
 
 
-/* v4l debugging and diagnostics */
-
-/* Device debug flags to be used with the video device debug attribute */
-
-/* Just log the ioctl name + error code */
-#define V4L2_DEV_DEBUG_IOCTL		0x01
-/* Log the ioctl name arguments + error code */
-#define V4L2_DEV_DEBUG_IOCTL_ARG	0x02
-/* Log the file operations open, release, mmap and get_unmapped_area */
-#define V4L2_DEV_DEBUG_FOP		0x04
-/* Log the read and write file operations and the VIDIOC_(D)QBUF ioctls */
-#define V4L2_DEV_DEBUG_STREAMING	0x08
-/* Log poll() */
-#define V4L2_DEV_DEBUG_POLL		0x10
+/**
+ * enum v4l2_debug_bits - Device debug bits to be used with the video
+ *	device debug attribute
+ *
+ * @V4L2_DEBUG_IOCTL:		Just log the ioctl name + error code.
+ * @V4L2_DEBUG_IOCTL_ARG:	Log the ioctl name arguments + error code.
+ * @V4L2_DEBUG_FOP:		Log the file operations and open, release,
+ *				mmap and get_unmapped_area syscalls.
+ * @V4L2_DEBUG_STREAMING:	Log the read and write syscalls and
+ *				:c:ref:`VIDIOC_[Q|DQ]BUF <VIDIOC_QBUF>` ioctls.
+ * @V4L2_DEBUG_POLL:		Log poll syscalls.
+ */
+enum v4l2_debug_bits {
+	V4L2_DEBUG_IOCTL	= 0,
+	V4L2_DEBUG_IOCTL_ARG	= 1,
+	V4L2_DEBUG_FOP		= 2,
+	V4L2_DEBUG_STREAMING	= 3,
+	V4L2_DEBUG_POLL		= 4,
+};
 
 /*  Video standard functions  */
 
-- 
2.14.3
