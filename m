Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:61161 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbbIQVU0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2015 17:20:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 5/9] [media] make VIDIOC_DQEVENT work with 64-bit time_t
Date: Thu, 17 Sep 2015 23:19:36 +0200
Message-Id: <1442524780-781677-6-git-send-email-arnd@arndb.de>
In-Reply-To: <1442524780-781677-1-git-send-email-arnd@arndb.de>
References: <1442524780-781677-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2 event queue uses a 'struct timespec' to pass monotonic
timestamps. This is not a problem by itself, but it breaks when user
space redefines timespec to use 'long long' on 32-bit systems.

This is the second approach on fixing the problem, by changing
the kernel to internally use 64-bit members for the timestamps
in struct v4l2_event, and letting user space use either version.

Unfortunately, we cannot use timespec64 here, because that does
not have a well-defined ABI yet, and differs from the 64-bit
version of 'timespec'. Using a pair of __s64 members makes sure
the structure is well-defined and contains no padding that might
leak kernel stack data.

We now need the handling for VIDIOC_DQEVENT32 on both 32-bit
and 64-bit architectures, so the handling for that is moved from
v4l2-compat-ioctl32.c to v4l2-ioctl.c and v4l2-subdev.c.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 35 ------------------
 drivers/media/v4l2-core/v4l2-event.c          | 35 +++++++++++++++---
 drivers/media/v4l2-core/v4l2-ioctl.c          | 53 ++++++++++++++++++++-------
 drivers/media/v4l2-core/v4l2-subdev.c         |  6 +++
 include/media/v4l2-event.h                    |  2 +
 include/uapi/linux/videodev2.h                | 31 ++++++++++++++++
 6 files changed, 107 insertions(+), 55 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index af635430524e..9ffe7302206e 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -735,32 +735,6 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	return 0;
 }
 
-struct v4l2_event32 {
-	__u32				type;
-	union {
-		__u8			data[64];
-	} u;
-	__u32				pending;
-	__u32				sequence;
-	struct compat_timespec		timestamp;
-	__u32				id;
-	__u32				reserved[8];
-};
-
-static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *up)
-{
-	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_event32)) ||
-		put_user(kp->type, &up->type) ||
-		copy_to_user(&up->u, &kp->u, sizeof(kp->u)) ||
-		put_user(kp->pending, &up->pending) ||
-		put_user(kp->sequence, &up->sequence) ||
-		compat_put_timespec(&kp->timestamp, &up->timestamp) ||
-		put_user(kp->id, &up->id) ||
-		copy_to_user(up->reserved, kp->reserved, 8 * sizeof(__u32)))
-			return -EFAULT;
-	return 0;
-}
-
 struct v4l2_edid32 {
 	__u32 pad;
 	__u32 start_block;
@@ -814,7 +788,6 @@ static int put_v4l2_edid32(struct v4l2_edid *kp, struct v4l2_edid32 __user *up)
 #define VIDIOC_G_EXT_CTRLS32    _IOWR('V', 71, struct v4l2_ext_controls32)
 #define VIDIOC_S_EXT_CTRLS32    _IOWR('V', 72, struct v4l2_ext_controls32)
 #define VIDIOC_TRY_EXT_CTRLS32  _IOWR('V', 73, struct v4l2_ext_controls32)
-#define	VIDIOC_DQEVENT32	_IOR ('V', 89, struct v4l2_event32)
 #define VIDIOC_CREATE_BUFS32	_IOWR('V', 92, struct v4l2_create_buffers32)
 #define VIDIOC_PREPARE_BUF32	_IOWR('V', 93, struct v4l2_buffer32)
 
@@ -860,7 +833,6 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_G_EXT_CTRLS32: cmd = VIDIOC_G_EXT_CTRLS; break;
 	case VIDIOC_S_EXT_CTRLS32: cmd = VIDIOC_S_EXT_CTRLS; break;
 	case VIDIOC_TRY_EXT_CTRLS32: cmd = VIDIOC_TRY_EXT_CTRLS; break;
-	case VIDIOC_DQEVENT32: cmd = VIDIOC_DQEVENT; break;
 	case VIDIOC_OVERLAY32: cmd = VIDIOC_OVERLAY; break;
 	case VIDIOC_STREAMON32: cmd = VIDIOC_STREAMON; break;
 	case VIDIOC_STREAMOFF32: cmd = VIDIOC_STREAMOFF; break;
@@ -940,9 +912,6 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		err = get_v4l2_ext_controls32(&karg.v2ecs, up);
 		compatible_arg = 0;
 		break;
-	case VIDIOC_DQEVENT:
-		compatible_arg = 0;
-		break;
 	}
 	if (err)
 		return err;
@@ -983,10 +952,6 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		err = put_v4l2_framebuffer32(&karg.v2fb, up);
 		break;
 
-	case VIDIOC_DQEVENT:
-		err = put_v4l2_event32(&karg.v2ev, up);
-		break;
-
 	case VIDIOC_G_EDID:
 	case VIDIOC_S_EDID:
 		err = put_v4l2_edid32(&karg.v2edid, up);
diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
index 8d3171c6bee8..149342490e91 100644
--- a/drivers/media/v4l2-core/v4l2-event.c
+++ b/drivers/media/v4l2-core/v4l2-event.c
@@ -92,6 +92,28 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
 }
 EXPORT_SYMBOL_GPL(v4l2_event_dequeue);
 
+int v4l2_event_dequeue32(struct v4l2_fh *fh, struct v4l2_event32 *event32,
+		       int nonblocking)
+{
+	struct v4l2_event event64;
+	int ret;
+
+	ret = v4l2_event_dequeue(fh, &event64, nonblocking);
+	if (ret)
+		return ret;
+
+	/* only the timestamp differs, so use memcpy to copy everything else */
+	memcpy(event32, &event64, offsetof(struct v4l2_event32, timestamp));
+	event32->timestamp.tv_sec = (long)event64.timestamp.tv_sec;
+	event32->timestamp.tv_nsec = (long)event64.timestamp.tv_nsec;
+	memcpy(&event32->id, &event64.id,
+	       sizeof(event32->id) + sizeof(event32->reserved));
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_event_dequeue32);
+
+
 /* Caller must hold fh->vdev->fh_lock! */
 static struct v4l2_subscribed_event *v4l2_event_subscribed(
 		struct v4l2_fh *fh, u32 type, u32 id)
@@ -108,7 +130,7 @@ static struct v4l2_subscribed_event *v4l2_event_subscribed(
 }
 
 static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev,
-		const struct timespec *ts)
+		const struct timespec64 *ts)
 {
 	struct v4l2_subscribed_event *sev;
 	struct v4l2_kevent *kev;
@@ -156,7 +178,8 @@ static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *e
 	if (copy_payload)
 		kev->event.u = ev->u;
 	kev->event.id = ev->id;
-	kev->event.timestamp = *ts;
+	kev->event.timestamp.tv_sec = ts->tv_sec;
+	kev->event.timestamp.tv_nsec = ts->tv_nsec;
 	kev->event.sequence = fh->sequence;
 	sev->in_use++;
 	list_add_tail(&kev->list, &fh->available);
@@ -170,12 +193,12 @@ void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
 {
 	struct v4l2_fh *fh;
 	unsigned long flags;
-	struct timespec timestamp;
+	struct timespec64 timestamp;
 
 	if (vdev == NULL)
 		return;
 
-	ktime_get_ts(&timestamp);
+	ktime_get_ts64(&timestamp);
 
 	spin_lock_irqsave(&vdev->fh_lock, flags);
 
@@ -189,9 +212,9 @@ EXPORT_SYMBOL_GPL(v4l2_event_queue);
 void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev)
 {
 	unsigned long flags;
-	struct timespec timestamp;
+	struct timespec64 timestamp;
 
-	ktime_get_ts(&timestamp);
+	ktime_get_ts64(&timestamp);
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 	__v4l2_event_queue_fh(fh, ev, &timestamp);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 4a384fc765b8..7aab18dd2ca5 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -797,22 +797,18 @@ static void v4l_print_frmivalenum(const void *arg, bool write_only)
 	}
 }
 
-static void v4l_print_event(const void *arg, bool write_only)
+static void v4l_print_event_data(const void *arg, bool write_only, u32 type)
 {
-	const struct v4l2_event *p = arg;
-	const struct v4l2_event_ctrl *c;
+	const struct v4l2_event_vsync *vsync = arg;
+	const struct v4l2_event_ctrl *c = arg;
+	const struct v4l2_event_frame_sync *frame_sync = arg;
 
-	pr_cont("type=0x%x, pending=%u, sequence=%u, id=%u, "
-		"timestamp=%lu.%9.9lu\n",
-			p->type, p->pending, p->sequence, p->id,
-			p->timestamp.tv_sec, p->timestamp.tv_nsec);
-	switch (p->type) {
+	switch (type) {
 	case V4L2_EVENT_VSYNC:
 		printk(KERN_DEBUG "field=%s\n",
-			prt_names(p->u.vsync.field, v4l2_field_names));
+			prt_names(vsync->field, v4l2_field_names));
 		break;
 	case V4L2_EVENT_CTRL:
-		c = &p->u.ctrl;
 		printk(KERN_DEBUG "changes=0x%x, type=%u, ",
 			c->changes, c->type);
 		if (c->type == V4L2_CTRL_TYPE_INTEGER64)
@@ -825,12 +821,34 @@ static void v4l_print_event(const void *arg, bool write_only)
 			c->step, c->default_value);
 		break;
 	case V4L2_EVENT_FRAME_SYNC:
-		pr_cont("frame_sequence=%u\n",
-			p->u.frame_sync.frame_sequence);
+		pr_cont("frame_sequence=%u\n", frame_sync->frame_sequence);
 		break;
 	}
 }
 
+static void v4l_print_event32(const void *arg, bool write_only)
+{
+	const struct v4l2_event32 *p = arg;
+	pr_cont("type=0x%x, pending=%u, sequence=%u, id=%u, "
+			"timestamp=%d.%9.9u\n",
+			p->type, p->pending, p->sequence, p->id,
+			p->timestamp.tv_sec, p->timestamp.tv_nsec);
+
+	return v4l_print_event_data(&p->u, write_only, p->type);
+}
+
+static void v4l_print_event64(const void *arg, bool write_only)
+{
+	const struct v4l2_event *p = arg;
+
+	pr_cont("type=0x%x, pending=%u, sequence=%u, id=%u, "
+			"timestamp=%lld.%9.9llu\n",
+			p->type, p->pending, p->sequence, p->id,
+			p->timestamp.tv_sec, p->timestamp.tv_nsec);
+
+	return v4l_print_event_data(&p->u, write_only, p->type);
+}
+
 static void v4l_print_event_subscription(const void *arg, bool write_only)
 {
 	const struct v4l2_event_subscription *p = arg;
@@ -2235,12 +2253,18 @@ static int v4l_dbg_g_chip_info(const struct v4l2_ioctl_ops *ops,
 #endif
 }
 
-static int v4l_dqevent(const struct v4l2_ioctl_ops *ops,
+static int v4l_dqevent64(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	return v4l2_event_dequeue(fh, arg, file->f_flags & O_NONBLOCK);
 }
 
+static int v4l_dqevent32(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	return v4l2_event_dequeue32(fh, arg, file->f_flags & O_NONBLOCK);
+}
+
 static int v4l_subscribe_event(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -2449,7 +2473,8 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_S_HW_FREQ_SEEK, v4l_s_hw_freq_seek, v4l_print_hw_freq_seek, INFO_FL_PRIO),
 	IOCTL_INFO_STD(VIDIOC_S_DV_TIMINGS, vidioc_s_dv_timings, v4l_print_dv_timings, INFO_FL_PRIO),
 	IOCTL_INFO_STD(VIDIOC_G_DV_TIMINGS, vidioc_g_dv_timings, v4l_print_dv_timings, 0),
-	IOCTL_INFO_FNC(VIDIOC_DQEVENT, v4l_dqevent, v4l_print_event, 0),
+	IOCTL_INFO_FNC(VIDIOC_DQEVENT, v4l_dqevent64, v4l_print_event64, 0),
+	IOCTL_INFO_FNC(VIDIOC_DQEVENT32, v4l_dqevent32, v4l_print_event32, 0),
 	IOCTL_INFO_FNC(VIDIOC_SUBSCRIBE_EVENT, v4l_subscribe_event, v4l_print_event_subscription, 0),
 	IOCTL_INFO_FNC(VIDIOC_UNSUBSCRIBE_EVENT, v4l_unsubscribe_event, v4l_print_event_subscription, 0),
 	IOCTL_INFO_FNC(VIDIOC_CREATE_BUFS, v4l_create_bufs, v4l_print_create_buffers, INFO_FL_PRIO | INFO_FL_QUEUE),
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 83615b8fb46a..9b0cde143c6c 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -211,6 +211,12 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_TRY_EXT_CTRLS:
 		return v4l2_try_ext_ctrls(vfh->ctrl_handler, arg);
 
+	case VIDIOC_DQEVENT32:
+		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS))
+			return -ENOIOCTLCMD;
+
+		return v4l2_event_dequeue32(vfh, arg, file->f_flags & O_NONBLOCK);
+
 	case VIDIOC_DQEVENT:
 		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS))
 			return -ENOIOCTLCMD;
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 9792f906423b..5e8ce27a0671 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -124,6 +124,8 @@ struct v4l2_subscribed_event {
 
 int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
 		       int nonblocking);
+int v4l2_event_dequeue32(struct v4l2_fh *fh, struct v4l2_event32 *event,
+		       int nonblocking);
 void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev);
 void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev);
 int v4l2_event_pending(struct v4l2_fh *fh);
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 3228fbebcd63..3e2c497c31fd 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -2082,10 +2082,40 @@ struct v4l2_event {
 	} u;
 	__u32				pending;
 	__u32				sequence;
+#ifdef __KERNEL__
+	struct {
+		__s64			tv_sec;
+		__s64			tv_nsec;
+	} timestamp;
+#else
 	struct timespec			timestamp;
+#endif
+	__u32				id;
+	__u32				reserved[8];
+};
+
+#ifdef __KERNEL__
+/*
+ * User space will see either 64-bit or 32-bit time_t, which changes
+ * the v4l2_event layout. Both are y2038 safe because the timestamps
+ * are in monotonic time, but the kernel has to handle both cases.
+ */
+struct v4l2_event32 {
+	__u32				type;
+	union {
+		__u8			data[64];
+	} u;
+	__u32				pending;
+	__u32				sequence;
+	struct {
+		__s32			tv_sec;
+		__s32			tv_nsec;
+	}				timestamp;
+
 	__u32				id;
 	__u32				reserved[8];
 };
+#endif
 
 #define V4L2_EVENT_SUB_FL_SEND_INITIAL		(1 << 0)
 #define V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK	(1 << 1)
@@ -2237,6 +2267,7 @@ struct v4l2_create_buffers {
 #define	VIDIOC_S_DV_TIMINGS	_IOWR('V', 87, struct v4l2_dv_timings)
 #define	VIDIOC_G_DV_TIMINGS	_IOWR('V', 88, struct v4l2_dv_timings)
 #define	VIDIOC_DQEVENT		 _IOR('V', 89, struct v4l2_event)
+#define	VIDIOC_DQEVENT32	 _IOR('V', 89, struct v4l2_event32)
 #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct v4l2_event_subscription)
 #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct v4l2_event_subscription)
 
-- 
2.1.0.rc2

