Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:39627 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbeH0XrU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 19:47:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: y2038@lists.linaro.org, awalls@md.metrocast.net,
        hans.verkuil@cisco.com, mchehab@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/5] media: dvb: move compat handlers into drivers
Date: Mon, 27 Aug 2018 21:56:25 +0200
Message-Id: <20180827195649.4170969-5-arnd@arndb.de>
In-Reply-To: <20180827195649.4170969-1-arnd@arndb.de>
References: <20180827195649.4170969-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VIDEO_STILLPICTURE is only implemented by one driver, while
VIDEO_GET_EVENT has two users in tree. In both cases, it is fairly
easy to handle the compat ioctls in the native handler rather
than relying on translation in fs/compat_ioctls.

In effect, this means that now the drivers implement both structure
layouts in both native and compat mode, but I don't see anything
wrong with that.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/pci/ivtv/ivtv-ioctl.c | 34 ++++++++++++-
 drivers/media/pci/ttpci/av7110_av.c | 56 ++++++++++++++++++++-
 fs/compat_ioctl.c                   | 78 -----------------------------
 3 files changed, 87 insertions(+), 81 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 4cdc6d2be85d..785dbd4be420 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -36,6 +36,7 @@
 #include <media/tveeprom.h>
 #include <media/v4l2-event.h>
 #ifdef CONFIG_VIDEO_IVTV_DEPRECATED_IOCTLS
+#include <linux/compat.h>
 #include <linux/dvb/audio.h>
 #include <linux/dvb/video.h>
 #endif
@@ -1627,6 +1628,21 @@ static __inline__ void warn_deprecated_ioctl(const char *name)
 	pr_warn_once("warning: the %s ioctl is deprecated. Don't use it, as it will be removed soon\n",
 		     name);
 }
+
+#ifdef CONFIG_COMPAT
+struct compat_video_event {
+        __s32 type;
+        /* unused, make sure to use atomic time for y2038 if it ever gets used */
+        compat_long_t timestamp;
+        union {
+                video_size_t size;
+                unsigned int frame_rate;        /* in frames per 1000sec */
+                unsigned char vsync_field;      /* unknown/odd/even/progressive */
+        } u;
+};
+#define VIDEO_GET_EVENT32 _IOR('o', 28, struct compat_video_event)
+#endif
+
 #endif
 
 static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
@@ -1749,7 +1765,13 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 		return ivtv_video_command(itv, id, dc, try);
 	}
 
+#ifdef CONFIG_COMPAT
+	case VIDEO_GET_EVENT32:
+#endif
 	case VIDEO_GET_EVENT: {
+#ifdef CONFIG_COMPAT
+		struct compat_video_event *ev32 = arg;
+#endif
 		struct video_event *ev = arg;
 		DEFINE_WAIT(wait);
 
@@ -1763,14 +1785,22 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 			if (test_and_clear_bit(IVTV_F_I_EV_DEC_STOPPED, &itv->i_flags))
 				ev->type = VIDEO_EVENT_DECODER_STOPPED;
 			else if (test_and_clear_bit(IVTV_F_I_EV_VSYNC, &itv->i_flags)) {
+				unsigned char vsync_field;
+
 				ev->type = VIDEO_EVENT_VSYNC;
-				ev->u.vsync_field = test_bit(IVTV_F_I_EV_VSYNC_FIELD, &itv->i_flags) ?
+				vsync_field = test_bit(IVTV_F_I_EV_VSYNC_FIELD, &itv->i_flags) ?
 					VIDEO_VSYNC_FIELD_ODD : VIDEO_VSYNC_FIELD_EVEN;
 				if (itv->output_mode == OUT_UDMA_YUV &&
 					(itv->yuv_info.lace_mode & IVTV_YUV_MODE_MASK) ==
 								IVTV_YUV_MODE_PROGRESSIVE) {
-					ev->u.vsync_field = VIDEO_VSYNC_FIELD_PROGRESSIVE;
+					vsync_field = VIDEO_VSYNC_FIELD_PROGRESSIVE;
 				}
+#ifdef CONFIG_COMPAT
+				if (cmd == VIDEO_GET_EVENT32)
+					ev32->u.vsync_field = vsync_field;
+				else
+#endif
+					ev->u.vsync_field = vsync_field;
 			}
 			if (ev->type)
 				return 0;
diff --git a/drivers/media/pci/ttpci/av7110_av.c b/drivers/media/pci/ttpci/av7110_av.c
index e738b2cef6f6..fd49ee5a380a 100644
--- a/drivers/media/pci/ttpci/av7110_av.c
+++ b/drivers/media/pci/ttpci/av7110_av.c
@@ -932,7 +932,6 @@ static int dvb_video_get_event (struct av7110 *av7110, struct video_event *event
 	return 0;
 }
 
-
 /******************************************************************************
  * DVB device file operations
  ******************************************************************************/
@@ -1095,6 +1094,42 @@ static int play_iframe(struct av7110 *av7110, char __user *buf, unsigned int len
 		return 0;
 }
 
+#ifdef CONFIG_COMPAT
+struct compat_video_still_picture {
+        compat_uptr_t iFrame;
+        int32_t size;
+};
+#define VIDEO_STILLPICTURE32 _IOW('o', 30, struct compat_video_still_picture)
+
+struct compat_video_event {
+        __s32 type;
+        /* unused, make sure to use atomic time for y2038 if it ever gets used */
+        compat_long_t timestamp;
+        union {
+                video_size_t size;
+                unsigned int frame_rate;        /* in frames per 1000sec */
+                unsigned char vsync_field;      /* unknown/odd/even/progressive */
+        } u;
+};
+#define VIDEO_GET_EVENT32 _IOR('o', 28, struct compat_video_event)
+
+static int dvb_compat_video_get_event(struct av7110 *av7110,
+				      struct compat_video_event *event, int flags)
+{
+	struct video_event ev;
+	int ret;
+
+	ret = dvb_video_get_event(av7110, &ev, flags);
+
+	*event = (struct compat_video_event) {
+		.type = ev.type,
+		.timestamp = ev.timestamp,
+		.u.size = ev.u.size,
+	};
+
+	return ret;
+}
+#endif
 
 static int dvb_video_ioctl(struct file *file,
 			   unsigned int cmd, void *parg)
@@ -1184,6 +1219,12 @@ static int dvb_video_ioctl(struct file *file,
 		memcpy(parg, &av7110->videostate, sizeof(struct video_status));
 		break;
 
+#ifdef CONFIG_COMPAT
+	case VIDEO_GET_EVENT32:
+		ret = dvb_compat_video_get_event(av7110, parg, file->f_flags);
+		break;
+#endif
+
 	case VIDEO_GET_EVENT:
 		ret = dvb_video_get_event(av7110, parg, file->f_flags);
 		break;
@@ -1226,6 +1267,19 @@ static int dvb_video_ioctl(struct file *file,
 				    1, (u16) arg);
 		break;
 
+#ifdef CONFIG_COMPAT
+	case VIDEO_STILLPICTURE32:
+	{
+		struct compat_video_still_picture *pic =
+			(struct compat_video_still_picture *) parg;
+		av7110->videostate.stream_source = VIDEO_SOURCE_MEMORY;
+		dvb_ringbuffer_flush_spinlock_wakeup(&av7110->avout);
+		ret = play_iframe(av7110, compat_ptr(pic->iFrame),
+				  pic->size, file->f_flags & O_NONBLOCK);
+		break;
+	}
+#endif
+
 	case VIDEO_STILLPICTURE:
 	{
 		struct video_still_picture *pic =
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 7a1fac9cd1c2..5b2e22e7a316 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -103,11 +103,6 @@
 
 #include <linux/hiddev.h>
 
-#define __DVB_CORE__
-#include <linux/dvb/audio.h>
-#include <linux/dvb/dmx.h>
-#include <linux/dvb/frontend.h>
-#include <linux/dvb/video.h>
 
 #include <linux/sort.h>
 
@@ -133,73 +128,6 @@ static int do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return vfs_ioctl(file, cmd, arg);
 }
 
-struct compat_video_event {
-	int32_t		type;
-	compat_time_t	timestamp;
-	union {
-	        video_size_t size;
-		unsigned int frame_rate;
-	} u;
-};
-#define VIDEO_GET_EVENT32 _IOR('o', 28, struct compat_video_event)
-
-static int do_video_get_event(struct file *file,
-		unsigned int cmd, struct compat_video_event __user *up)
-{
-	struct video_event __user *kevent =
-		compat_alloc_user_space(sizeof(*kevent));
-	int err;
-
-	if (kevent == NULL)
-		return -EFAULT;
-
-	err = do_ioctl(file, VIDEO_GET_EVENT, (unsigned long)kevent);
-	if (!err) {
-		err  = convert_in_user(&kevent->type, &up->type);
-		err |= convert_in_user(&kevent->timestamp, &up->timestamp);
-		err |= convert_in_user(&kevent->u.size.w, &up->u.size.w);
-		err |= convert_in_user(&kevent->u.size.h, &up->u.size.h);
-		err |= convert_in_user(&kevent->u.size.aspect_ratio,
-				&up->u.size.aspect_ratio);
-		if (err)
-			err = -EFAULT;
-	}
-
-	return err;
-}
-
-struct compat_video_still_picture {
-        compat_uptr_t iFrame;
-        int32_t size;
-};
-#define VIDEO_STILLPICTURE32 _IOW('o', 30, struct compat_video_still_picture)
-
-static int do_video_stillpicture(struct file *file,
-		unsigned int cmd, struct compat_video_still_picture __user *up)
-{
-	struct video_still_picture __user *up_native;
-	compat_uptr_t fp;
-	int32_t size;
-	int err;
-
-	err  = get_user(fp, &up->iFrame);
-	err |= get_user(size, &up->size);
-	if (err)
-		return -EFAULT;
-
-	up_native =
-		compat_alloc_user_space(sizeof(struct video_still_picture));
-
-	err =  put_user(compat_ptr(fp), &up_native->iFrame);
-	err |= put_user(size, &up_native->size);
-	if (err)
-		return -EFAULT;
-
-	err = do_ioctl(file, VIDEO_STILLPICTURE, (unsigned long) up_native);
-
-	return err;
-}
-
 #ifdef CONFIG_BLOCK
 typedef struct sg_io_hdr32 {
 	compat_int_t interface_id;	/* [i] 'S' for SCSI generic (required) */
@@ -1250,12 +1178,6 @@ static long do_ioctl_trans(unsigned int cmd,
 	case RTC_EPOCH_READ32:
 	case RTC_EPOCH_SET32:
 		return rtc_ioctl(file, cmd, argp);
-
-	/* dvb */
-	case VIDEO_GET_EVENT32:
-		return do_video_get_event(file, cmd, argp);
-	case VIDEO_STILLPICTURE32:
-		return do_video_stillpicture(file, cmd, argp);
 	}
 
 	/*
-- 
2.18.0
