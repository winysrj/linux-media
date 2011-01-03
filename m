Return-path: <mchehab@gaivota>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3635 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab1ACNyu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 08:54:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: David Ellingsworth <david@identd.dyndns.org>
Subject: [RFC PATCH 1/4] v4l2-device: add kref and a release function
Date: Mon,  3 Jan 2011 14:54:29 +0100
Message-Id: <adec9ffda2cd47023cde5d0beda01fc84bd867f6.1294062751.git.hverkuil@xs4all.nl>
In-Reply-To: <1294062872-8312-1-git-send-email-hverkuil@xs4all.nl>
References: <1294062872-8312-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The video_device struct has proper ref counting and its release function
will be called when the last user releases it. But no such support was
available for struct v4l2_device. This made it hard to determine when a
USB driver can release the device if it has multiple device nodes.

With one device node it is easy of course, since when the device node is
released, the whole device can be released.

This patch adds refcounting to v4l2_device. When registering device nodes
the v4l2_device refcount will be increased, when releasing device nodes
it will be decreased. The (optional) release function will be called when
the last device node was released.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-dev.c    |    8 ++++++++
 drivers/media/video/v4l2-device.c |   15 +++++++++++++++
 include/media/v4l2-device.h       |   11 +++++++++++
 3 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 359e232..ff3aa90 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -143,6 +143,7 @@ static inline void video_put(struct video_device *vdev)
 static void v4l2_device_release(struct device *cd)
 {
 	struct video_device *vdev = to_video_device(cd);
+	struct v4l2_device *v4l2_dev = vdev->v4l2_dev;
 
 	mutex_lock(&videodev_lock);
 	if (video_device[vdev->minor] != vdev) {
@@ -169,6 +170,10 @@ static void v4l2_device_release(struct device *cd)
 	/* Release video_device and perform other
 	   cleanups as needed. */
 	vdev->release(vdev);
+
+	/* Decrease v4l2_device refcount */
+	if (v4l2_dev)
+		v4l2_device_put(v4l2_dev);
 }
 
 static struct class video_class = {
@@ -581,6 +586,9 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 		printk(KERN_WARNING "%s: requested %s%d, got %s\n", __func__,
 			name_base, nr, video_device_node_name(vdev));
 
+	/* Increase v4l2_device refcount */
+	if (vdev->v4l2_dev)
+		v4l2_device_get(vdev->v4l2_dev);
 	/* Part 5: Activate this minor. The char device can now be used. */
 	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
 	mutex_lock(&videodev_lock);
diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index 7fe6f92..031ddbc 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -54,6 +54,21 @@ int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
 }
 EXPORT_SYMBOL_GPL(v4l2_device_register);
 
+static void v4l2_device_release(struct kref *ref)
+{
+	struct v4l2_device *v4l2_dev =
+		container_of(ref, struct v4l2_device, ref);
+
+	if (v4l2_dev->release)
+		v4l2_dev->release(v4l2_dev);
+}
+
+int v4l2_device_put(struct v4l2_device *v4l2_dev)
+{
+	return kref_put(&v4l2_dev->ref, v4l2_device_release);
+}
+EXPORT_SYMBOL_GPL(v4l2_device_put);
+
 int v4l2_device_set_name(struct v4l2_device *v4l2_dev, const char *basename,
 						atomic_t *instance)
 {
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index b16f307..7279fa6 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -53,8 +53,19 @@ struct v4l2_device {
 	struct v4l2_ctrl_handler *ctrl_handler;
 	/* BKL replacement mutex. Temporary solution only. */
 	struct mutex ioctl_lock;
+	/* Keep track of the references to this struct. */
+	struct kref ref;
+	/* Release function that is called when the ref count goes to 0. */
+	void (*release)(struct v4l2_device *v4l2_dev);
 };
 
+static inline void v4l2_device_get(struct v4l2_device *v4l2_dev)
+{
+	kref_get(&v4l2_dev->ref);
+}
+
+int v4l2_device_put(struct v4l2_device *v4l2_dev);
+
 /* Initialize v4l2_dev and make dev->driver_data point to v4l2_dev.
    dev may be NULL in rare cases (ISA devices). In that case you
    must fill in the v4l2_dev->name field before calling this function. */
-- 
1.7.0.4

