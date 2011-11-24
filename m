Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4642 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1KXNjQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 08:39:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 01/12] v4l2: add VIDIOC_(TRY_)DECODER_CMD.
Date: Thu, 24 Nov 2011 14:38:58 +0100
Message-Id: <07c1a0737016dcf588e866cde0f3bc1a59e35bfb.1322141686.git.hans.verkuil@cisco.com>
In-Reply-To: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

As discussed during the 2011 V4L-DVB workshop, the API in dvb/video.h should
be replaced by a proper V4L2 API. This patch turns the VIDEO_(TRY_)DECODER_CMD
ioctls into proper V4L2 ioctls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |    2 +
 drivers/media/video/v4l2-ioctl.c          |   28 +++++++++++++++
 include/linux/videodev2.h                 |   53 +++++++++++++++++++++++++++++
 include/media/v4l2-ioctl.h                |    4 ++
 4 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index c68531b..ffd9b1e 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -1003,6 +1003,8 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_G_ENC_INDEX:
 	case VIDIOC_ENCODER_CMD:
 	case VIDIOC_TRY_ENCODER_CMD:
+	case VIDIOC_DECODER_CMD:
+	case VIDIOC_TRY_DECODER_CMD:
 	case VIDIOC_DBG_S_REGISTER:
 	case VIDIOC_DBG_G_REGISTER:
 	case VIDIOC_DBG_G_CHIP_IDENT:
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index e1da8fc..2355510 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -258,6 +258,8 @@ static const char *v4l2_ioctls[] = {
 	[_IOC_NR(VIDIOC_ENCODER_CMD)] 	   = "VIDIOC_ENCODER_CMD",
 	[_IOC_NR(VIDIOC_TRY_ENCODER_CMD)]  = "VIDIOC_TRY_ENCODER_CMD",
 
+	[_IOC_NR(VIDIOC_DECODER_CMD)]	   = "VIDIOC_DECODER_CMD",
+	[_IOC_NR(VIDIOC_TRY_DECODER_CMD)]  = "VIDIOC_TRY_DECODER_CMD",
 	[_IOC_NR(VIDIOC_DBG_S_REGISTER)]   = "VIDIOC_DBG_S_REGISTER",
 	[_IOC_NR(VIDIOC_DBG_G_REGISTER)]   = "VIDIOC_DBG_G_REGISTER",
 
@@ -1658,6 +1660,32 @@ static long __video_do_ioctl(struct file *file,
 			dbgarg(cmd, "cmd=%d, flags=%x\n", p->cmd, p->flags);
 		break;
 	}
+	case VIDIOC_DECODER_CMD:
+	{
+		struct v4l2_decoder_cmd *p = arg;
+
+		if (!ops->vidioc_decoder_cmd)
+			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
+		ret = ops->vidioc_decoder_cmd(file, fh, p);
+		if (!ret)
+			dbgarg(cmd, "cmd=%d, flags=%x\n", p->cmd, p->flags);
+		break;
+	}
+	case VIDIOC_TRY_DECODER_CMD:
+	{
+		struct v4l2_decoder_cmd *p = arg;
+
+		if (!ops->vidioc_try_decoder_cmd)
+			break;
+		ret = ops->vidioc_try_decoder_cmd(file, fh, p);
+		if (!ret)
+			dbgarg(cmd, "cmd=%d, flags=%x\n", p->cmd, p->flags);
+		break;
+	}
 	case VIDIOC_G_PARM:
 	{
 		struct v4l2_streamparm *p = arg;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 4b752d5..406f7f7 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1849,6 +1849,54 @@ struct v4l2_encoder_cmd {
 	};
 };
 
+/* Decoder commands */
+#define V4L2_DEC_CMD_START       (0)
+#define V4L2_DEC_CMD_STOP        (1)
+#define V4L2_DEC_CMD_PAUSE       (2)
+#define V4L2_DEC_CMD_RESUME      (3)
+
+/* Flags for V4L2_DEC_CMD_START */
+#define V4L2_DEC_CMD_START_MUTE_AUDIO	(1 << 0)
+
+/* Flags for V4L2_DEC_CMD_PAUSE */
+#define V4L2_DEC_CMD_PAUSE_TO_BLACK	(1 << 0)
+
+/* Flags for V4L2_DEC_CMD_STOP */
+#define V4L2_DEC_CMD_STOP_TO_BLACK	(1 << 0)
+#define V4L2_DEC_CMD_STOP_IMMEDIATELY	(1 << 1)
+
+/* Play format requirements (returned by the driver): */
+
+/* The decoder has no special format requirements */
+#define V4L2_DEC_START_FMT_NONE		(0)
+/* The decoder requires full GOPs */
+#define V4L2_DEC_START_FMT_GOP		(1)
+
+/* The structure must be zeroed before use by the application
+   This ensures it can be extended safely in the future. */
+struct v4l2_decoder_cmd {
+	__u32 cmd;
+	__u32 flags;
+	union {
+		struct {
+			__u64 pts;
+		} stop;
+
+		struct {
+			/* 0 or 1000 specifies normal speed,
+			   1 specifies forward single stepping,
+			   -1 specifies backward single stepping,
+			   >1: playback at speed/1000 of the normal speed,
+			   <-1: reverse playback at (-speed/1000) of the normal speed. */
+			__s32 speed;
+			__u32 format;
+		} start;
+
+		struct {
+			__u32 data[16];
+		} raw;
+	};
+};
 #endif
 
 
@@ -2255,6 +2303,11 @@ struct v4l2_create_buffers {
 #define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
 #define VIDIOC_PREPARE_BUF	_IOWR('V', 93, struct v4l2_buffer)
 
+/* Experimental, these two ioctls may change over the next couple of kernel
+   versions. */
+#define VIDIOC_DECODER_CMD	_IOWR('V', 94, struct v4l2_decoder_cmd)
+#define VIDIOC_TRY_DECODER_CMD	_IOWR('V', 95, struct v4l2_decoder_cmd)
+
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 4d1c74a..46c13ba 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -207,6 +207,10 @@ struct v4l2_ioctl_ops {
 					struct v4l2_encoder_cmd *a);
 	int (*vidioc_try_encoder_cmd)  (struct file *file, void *fh,
 					struct v4l2_encoder_cmd *a);
+	int (*vidioc_decoder_cmd)      (struct file *file, void *fh,
+					struct v4l2_decoder_cmd *a);
+	int (*vidioc_try_decoder_cmd)  (struct file *file, void *fh,
+					struct v4l2_decoder_cmd *a);
 
 	/* Stream type-dependent parameter ioctls */
 	int (*vidioc_g_parm)           (struct file *file, void *fh,
-- 
1.7.7.3

