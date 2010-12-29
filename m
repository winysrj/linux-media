Return-path: <mchehab@gaivota>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3396 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab0L2Vn3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 16:43:29 -0500
Received: from localhost (marune.xs4all.nl [82.95.89.49])
	by smtp-vbr18.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBTLhRAp006059
	for <linux-media@vger.kernel.org>; Wed, 29 Dec 2010 22:43:27 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Message-Id: <0b6483d4f8be5ef13aced07821281a5e1a932170.1293657717.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1293657717.git.hverkuil@xs4all.nl>
References: <cover.1293657717.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 29 Dec 2010 22:43:27 +0100
Subject: [PATCH 09/10] [RFC] v4l2-device: add kref and a release function
To: linux-media@vger.kernel.org
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
index 96ec954..c83d8a9 100644
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
@@ -670,6 +675,9 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 		printk(KERN_WARNING "%s: requested %s%d, got %s\n", __func__,
 			name_base, nr, video_device_node_name(vdev));
 
+	/* Increase v4l2_device refcount */
+	if (vdev->v4l2_dev)
+		v4l2_device_get(vdev->v4l2_dev);
 	/* Part 5: Activate this minor. The char device can now be used. */
 	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
 	mutex_lock(&videodev_lock);
diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index e12844c..4124016 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -55,6 +55,21 @@ int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
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
index fd5d450..44763bc 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -56,8 +56,19 @@ struct v4l2_device {
 	struct v4l2_prio_state prio;
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
1.6.4.2

