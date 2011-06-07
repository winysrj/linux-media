Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3859 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab1FGPFl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 11:05:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 18/18] v4l2-compat-ioctl32: add VIDIOC_DQEVENT support.
Date: Tue,  7 Jun 2011 17:05:23 +0200
Message-Id: <58fbede66b3bc5423d70a4cea7ff2534a4e6c4a5.1307458245.git.hans.verkuil@cisco.com>
In-Reply-To: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
References: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |   37 +++++++++++++++++++++++++++++
 kernel/compat.c                           |    1 +
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 7c26947..61979b7 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -662,6 +662,32 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	return 0;
 }
 
+struct v4l2_event32 {
+	__u32				type;
+	union {
+		__u8			data[64];
+	} u;
+	__u32				pending;
+	__u32				sequence;
+	struct compat_timespec		timestamp;
+	__u32				id;
+	__u32				reserved[8];
+};
+
+static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *up)
+{
+	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_event32)) ||
+		put_user(kp->type, &up->type) ||
+		copy_to_user(&up->u, &kp->u, sizeof(kp->u)) ||
+		put_user(kp->pending, &up->pending) ||
+		put_user(kp->sequence, &up->sequence) ||
+		put_compat_timespec(&kp->timestamp, &up->timestamp) ||
+		put_user(kp->id, &up->id) ||
+		copy_to_user(up->reserved, kp->reserved, 8 * sizeof(__u32)))
+			return -EFAULT;
+	return 0;
+}
+
 #define VIDIOC_G_FMT32		_IOWR('V',  4, struct v4l2_format32)
 #define VIDIOC_S_FMT32		_IOWR('V',  5, struct v4l2_format32)
 #define VIDIOC_QUERYBUF32	_IOWR('V',  9, struct v4l2_buffer32)
@@ -675,6 +701,7 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 #define VIDIOC_G_EXT_CTRLS32    _IOWR('V', 71, struct v4l2_ext_controls32)
 #define VIDIOC_S_EXT_CTRLS32    _IOWR('V', 72, struct v4l2_ext_controls32)
 #define VIDIOC_TRY_EXT_CTRLS32  _IOWR('V', 73, struct v4l2_ext_controls32)
+#define	VIDIOC_DQEVENT32	_IOR ('V', 89, struct v4l2_event32)
 
 #define VIDIOC_OVERLAY32	_IOW ('V', 14, s32)
 #define VIDIOC_STREAMON32	_IOW ('V', 18, s32)
@@ -693,6 +720,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		struct v4l2_input v2i;
 		struct v4l2_standard v2s;
 		struct v4l2_ext_controls v2ecs;
+		struct v4l2_event v2ev;
 		unsigned long vx;
 		int vi;
 	} karg;
@@ -715,6 +743,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_G_EXT_CTRLS32: cmd = VIDIOC_G_EXT_CTRLS; break;
 	case VIDIOC_S_EXT_CTRLS32: cmd = VIDIOC_S_EXT_CTRLS; break;
 	case VIDIOC_TRY_EXT_CTRLS32: cmd = VIDIOC_TRY_EXT_CTRLS; break;
+	case VIDIOC_DQEVENT32: cmd = VIDIOC_DQEVENT; break;
 	case VIDIOC_OVERLAY32: cmd = VIDIOC_OVERLAY; break;
 	case VIDIOC_STREAMON32: cmd = VIDIOC_STREAMON; break;
 	case VIDIOC_STREAMOFF32: cmd = VIDIOC_STREAMOFF; break;
@@ -778,6 +807,9 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		err = get_v4l2_ext_controls32(&karg.v2ecs, up);
 		compatible_arg = 0;
 		break;
+	case VIDIOC_DQEVENT:
+		compatible_arg = 0;
+		break;
 	}
 	if (err)
 		return err;
@@ -818,6 +850,10 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		err = put_v4l2_framebuffer32(&karg.v2fb, up);
 		break;
 
+	case VIDIOC_DQEVENT:
+		err = put_v4l2_event32(&karg.v2ev, up);
+		break;
+
 	case VIDIOC_G_FMT:
 	case VIDIOC_S_FMT:
 	case VIDIOC_TRY_FMT:
@@ -920,6 +956,7 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_S_DV_TIMINGS:
 	case VIDIOC_G_DV_TIMINGS:
 	case VIDIOC_DQEVENT:
+	case VIDIOC_DQEVENT32:
 	case VIDIOC_SUBSCRIBE_EVENT:
 	case VIDIOC_UNSUBSCRIBE_EVENT:
 		ret = do_video_ioctl(file, cmd, arg);
diff --git a/kernel/compat.c b/kernel/compat.c
index fc9eb09..d4abc5b 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -158,6 +158,7 @@ int put_compat_timespec(const struct timespec *ts, struct compat_timespec __user
 			__put_user(ts->tv_sec, &cts->tv_sec) ||
 			__put_user(ts->tv_nsec, &cts->tv_nsec)) ? -EFAULT : 0;
 }
+EXPORT_SYMBOL_GPL(put_compat_timespec);
 
 static long compat_nanosleep_restart(struct restart_block *restart)
 {
-- 
1.7.1

