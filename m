Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2563 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932803Ab2FVMVr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 08:21:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 26/34] v4l2-dev/ioctl.c: add vb2_queue support to video_device.
Date: Fri, 22 Jun 2012 14:21:20 +0200
Message-Id: <4c65650972fb636f9a38c6a1847f730b657a2d37.1340366355.git.hans.verkuil@cisco.com>
In-Reply-To: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
References: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This prepares struct video_device for easier integration with vb2.

It also introduces a new lock that protects the vb2_queue. It is up
to the driver to use it or not. And the driver can associate an owner
filehandle with the queue to check whether queuing requests are
permitted for the calling filehandle.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-dev.c   |   16 +++++-----------
 drivers/media/video/v4l2-ioctl.c |   31 +++++++++++++++++++++++--------
 include/media/v4l2-dev.h         |    3 +++
 include/media/v4l2-ioctl.h       |    5 +++++
 include/media/videobuf2-core.h   |   13 +++++++++++++
 5 files changed, 49 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 5c0bb18..1b34360 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -348,20 +348,14 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	int ret = -ENODEV;
 
 	if (vdev->fops->unlocked_ioctl) {
-		bool locked = false;
+		struct mutex *lock = v4l2_ioctl_get_lock(vdev, cmd);
 
-		if (vdev->lock) {
-			/* always lock unless the cmd is marked as "don't use lock" */
-			locked = !v4l2_is_known_ioctl(cmd) ||
-				 !test_bit(_IOC_NR(cmd), vdev->disable_locking);
-
-			if (locked && mutex_lock_interruptible(vdev->lock))
-				return -ERESTARTSYS;
-		}
+		if (lock && mutex_lock_interruptible(lock))
+			return -ERESTARTSYS;
 		if (video_is_registered(vdev))
 			ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
-		if (locked)
-			mutex_unlock(vdev->lock);
+		if (lock)
+			mutex_unlock(lock);
 	} else if (vdev->fops->ioctl) {
 		/* This code path is a replacement for the BKL. It is a major
 		 * hack but it will have to do for those drivers that are not
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index efbb3db..95c9df0 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -27,6 +27,7 @@
 #include <media/v4l2-event.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/videobuf2-core.h>
 
 /* Zero out the end of the struct pointed to by p.  Everything after, but
  * not including, the specified field is cleared. */
@@ -1816,6 +1817,8 @@ struct v4l2_ioctl_info {
 #define INFO_FL_STD	(1 << 2)
 /* This is ioctl has its own function */
 #define INFO_FL_FUNC	(1 << 3)
+/* Queuing ioctl */
+#define INFO_FL_QUEUE	(1 << 4)
 /* Zero struct from after the field to the end */
 #define INFO_FL_CLEAR(v4l2_struct, field)			\
 	((offsetof(struct v4l2_struct, field) +			\
@@ -1845,15 +1848,15 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_ENUM_FMT, v4l_enum_fmt, v4l_print_fmtdesc, INFO_FL_CLEAR(v4l2_fmtdesc, type)),
 	IOCTL_INFO_FNC(VIDIOC_G_FMT, v4l_g_fmt, v4l_print_format, INFO_FL_CLEAR(v4l2_format, type)),
 	IOCTL_INFO_FNC(VIDIOC_S_FMT, v4l_s_fmt, v4l_print_format, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_REQBUFS, v4l_reqbufs, v4l_print_requestbuffers, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_QUERYBUF, v4l_querybuf, v4l_print_buffer, INFO_FL_CLEAR(v4l2_buffer, length)),
+	IOCTL_INFO_FNC(VIDIOC_REQBUFS, v4l_reqbufs, v4l_print_requestbuffers, INFO_FL_PRIO | INFO_FL_QUEUE),
+	IOCTL_INFO_FNC(VIDIOC_QUERYBUF, v4l_querybuf, v4l_print_buffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_buffer, length)),
 	IOCTL_INFO_STD(VIDIOC_G_FBUF, vidioc_g_fbuf, v4l_print_framebuffer, 0),
 	IOCTL_INFO_STD(VIDIOC_S_FBUF, vidioc_s_fbuf, v4l_print_framebuffer, INFO_FL_PRIO),
 	IOCTL_INFO_STD(VIDIOC_OVERLAY, vidioc_overlay, v4l_print_u32, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_QBUF, v4l_qbuf, v4l_print_buffer, 0),
-	IOCTL_INFO_FNC(VIDIOC_DQBUF, v4l_dqbuf, v4l_print_buffer, 0),
-	IOCTL_INFO_FNC(VIDIOC_STREAMON, v4l_streamon, v4l_print_buftype, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_STREAMOFF, v4l_streamoff, v4l_print_buftype, INFO_FL_PRIO),
+	IOCTL_INFO_FNC(VIDIOC_QBUF, v4l_qbuf, v4l_print_buffer, INFO_FL_QUEUE),
+	IOCTL_INFO_FNC(VIDIOC_DQBUF, v4l_dqbuf, v4l_print_buffer, INFO_FL_QUEUE),
+	IOCTL_INFO_FNC(VIDIOC_STREAMON, v4l_streamon, v4l_print_buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
+	IOCTL_INFO_FNC(VIDIOC_STREAMOFF, v4l_streamoff, v4l_print_buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
 	IOCTL_INFO_FNC(VIDIOC_G_PARM, v4l_g_parm, v4l_print_streamparm, INFO_FL_CLEAR(v4l2_streamparm, type)),
 	IOCTL_INFO_FNC(VIDIOC_S_PARM, v4l_s_parm, v4l_print_streamparm, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_G_STD, v4l_g_std, v4l_print_std, 0),
@@ -1917,8 +1920,8 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_DQEVENT, v4l_dqevent, v4l_print_event, 0),
 	IOCTL_INFO_FNC(VIDIOC_SUBSCRIBE_EVENT, v4l_subscribe_event, v4l_print_event_subscription, 0),
 	IOCTL_INFO_FNC(VIDIOC_UNSUBSCRIBE_EVENT, v4l_unsubscribe_event, v4l_print_event_subscription, 0),
-	IOCTL_INFO_FNC(VIDIOC_CREATE_BUFS, v4l_create_bufs, v4l_print_create_buffers, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_PREPARE_BUF, v4l_prepare_buf, v4l_print_buffer, 0),
+	IOCTL_INFO_FNC(VIDIOC_CREATE_BUFS, v4l_create_bufs, v4l_print_create_buffers, INFO_FL_PRIO | INFO_FL_QUEUE),
+	IOCTL_INFO_FNC(VIDIOC_PREPARE_BUF, v4l_prepare_buf, v4l_print_buffer, INFO_FL_QUEUE),
 	IOCTL_INFO_STD(VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings, v4l_print_enum_dv_timings, 0),
 	IOCTL_INFO_STD(VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings, v4l_print_dv_timings, 0),
 	IOCTL_INFO_STD(VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap, v4l_print_dv_timings_cap, 0),
@@ -1932,6 +1935,18 @@ bool v4l2_is_known_ioctl(unsigned int cmd)
 	return v4l2_ioctls[_IOC_NR(cmd)].ioctl == cmd;
 }
 
+struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev, unsigned cmd)
+{
+	if (_IOC_NR(cmd) >= V4L2_IOCTLS)
+		return vdev->lock;
+	if (test_bit(_IOC_NR(cmd), vdev->disable_locking))
+		return NULL;
+	if (vdev->queue && vdev->queue->lock &&
+			(v4l2_ioctls[_IOC_NR(cmd)].flags & INFO_FL_QUEUE))
+		return vdev->queue->lock;
+	return vdev->lock;
+}
+
 /* Common ioctl debug function. This function can be used by
    external ioctl messages as well as internal V4L ioctl */
 void v4l_printk_ioctl(const char *prefix, unsigned int cmd)
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index a056e6e..5c416cd 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -100,6 +100,9 @@ struct video_device
 	/* Control handler associated with this device node. May be NULL. */
 	struct v4l2_ctrl_handler *ctrl_handler;
 
+	/* vb2_queue associated with this device node. May be NULL. */
+	struct vb2_queue *queue;
+
 	/* Priority state. If NULL, then v4l2_dev->prio will be used. */
 	struct v4l2_prio_state *prio;
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index dfd984f..19e9352 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -304,6 +304,11 @@ extern int v4l2_video_std_construct(struct v4l2_standard *vs,
    then do printk(KERN_DEBUG "%s: ", prefix) first. */
 extern void v4l_printk_ioctl(const char *prefix, unsigned int cmd);
 
+/* Internal use only: get the mutex (if any) that we need to lock for the
+   given command. */
+struct video_device;
+extern struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev, unsigned cmd);
+
 /* names for fancy debug output */
 extern const char *v4l2_field_names[];
 extern const char *v4l2_type_names[];
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index a15d1f1..924e95e 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -244,12 +244,23 @@ struct vb2_ops {
 	void (*buf_queue)(struct vb2_buffer *vb);
 };
 
+struct v4l2_fh;
+
 /**
  * struct vb2_queue - a videobuf queue
  *
  * @type:	queue type (see V4L2_BUF_TYPE_* in linux/videodev2.h
  * @io_modes:	supported io methods (see vb2_io_modes enum)
  * @io_flags:	additional io flags (see vb2_fileio_flags enum)
+ * @lock:	pointer to a mutex that protects the vb2_queue struct. The
+ *		driver can set this to a mutex to let the v4l2 core serialize
+ *		the queuing ioctls. If the driver wants to handle locking
+ *		itself, then this should be set to NULL. This lock is not used
+ *		by the videobuf2 core API.
+ * @owner:	The filehandle that 'owns' the buffers, i.e. the filehandle
+ *		that called reqbufs, create_buffers or started fileio.
+ *		This field is not used by the videobuf2 core API, but it allows
+ *		drivers to easily associate an owner filehandle with the queue.
  * @ops:	driver-specific callbacks
  * @mem_ops:	memory allocator specific callbacks
  * @drv_priv:	driver private data
@@ -273,6 +284,8 @@ struct vb2_queue {
 	enum v4l2_buf_type		type;
 	unsigned int			io_modes;
 	unsigned int			io_flags;
+	struct mutex			*lock;
+	struct v4l2_fh			*owner;
 
 	const struct vb2_ops		*ops;
 	const struct vb2_mem_ops	*mem_ops;
-- 
1.7.10

