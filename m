Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2092 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab2FJK0T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:26:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 23/32] v4l2-dev/ioctl.c: add vb2_queue support to video_device.
Date: Sun, 10 Jun 2012 12:25:45 +0200
Message-Id: <8382aedf61031836918774ab6c0639c78aadb9a5.1339321562.git.hans.verkuil@cisco.com>
In-Reply-To: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
References: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This prepares struct video_device for easier integration with vb2.

It also introduces a new lock that protects the vb2_queue. It is up
to the driver to use it or not.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |   29 +++++++++++++++++++++--------
 include/media/v4l2-dev.h         |    8 ++++++++
 include/media/v4l2-ioctl.h       |    5 +++++
 3 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index c82cf98..dfd5337 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1831,6 +1831,8 @@ struct v4l2_ioctl_info {
 #define INFO_FL_STD	(1 << 2)
 /* This is ioctl has its own function */
 #define INFO_FL_FUNC	(1 << 3)
+/* Queuing ioctl */
+#define INFO_FL_QUEUE	(1 << 4)
 /* Zero struct from after the field to the end */
 #define INFO_FL_CLEAR(v4l2_struct, field)			\
 	((offsetof(struct v4l2_struct, field) +			\
@@ -1860,15 +1862,15 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
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
@@ -1932,8 +1934,8 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
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
@@ -1947,6 +1949,17 @@ bool v4l2_is_known_ioctl(unsigned int cmd)
 	return v4l2_ioctls[_IOC_NR(cmd)].ioctl == cmd;
 }
 
+struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev, unsigned cmd)
+{
+	if (_IOC_NR(cmd) >= V4L2_IOCTLS)
+		return vdev->lock;
+	if (test_bit(_IOC_NR(cmd), vdev->disable_locking))
+		return NULL;
+	if (vdev->queue_lock && (v4l2_ioctls[_IOC_NR(cmd)].flags & INFO_FL_QUEUE))
+		return vdev->queue_lock;
+	return vdev->lock;
+}
+
 /* Common ioctl debug function. This function can be used by
    external ioctl messages as well as internal V4L ioctl */
 void v4l_printk_ioctl(const char *prefix, unsigned int cmd)
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index a056e6e..ea678f2 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -100,6 +100,14 @@ struct video_device
 	/* Control handler associated with this device node. May be NULL. */
 	struct v4l2_ctrl_handler *ctrl_handler;
 
+	/* vb2_queue associated with this device node. May be NULL. */
+	struct vb2_queue *queue;
+	/* The current owner of the queue. May be NULL. */
+	struct v4l2_fh *queue_owner;
+	/* The mutex that protects the queue. May be NULL, in which case the
+	   serialization lock is used. */
+	struct mutex *queue_lock;
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
-- 
1.7.10

