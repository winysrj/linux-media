Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59545 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938733AbcKXLBc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 06:01:32 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 3/3] [media] ivtv: mark DVB "borrowed" ioctls as deprecated
Date: Thu, 24 Nov 2016 09:01:22 -0200
Message-Id: <326db540103d3cd8619de0a39256b2de361eece8.1479985277.git.mchehab@s-opensource.com>
In-Reply-To: <8e39e8122c8a4d3b5fb0a71ec51e0896a6953b66.1479985277.git.mchehab@s-opensource.com>
References: <8e39e8122c8a4d3b5fb0a71ec51e0896a6953b66.1479985277.git.mchehab@s-opensource.com>
In-Reply-To: <8e39e8122c8a4d3b5fb0a71ec51e0896a6953b66.1479985277.git.mchehab@s-opensource.com>
References: <8e39e8122c8a4d3b5fb0a71ec51e0896a6953b66.1479985277.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset da8ec560e3b4 ("[media] ivtv: implement new decoder command
ioctls") implemented proper support for mpeg audio and video control
at V4L2 API. Since then, the usage of the the DVB APIs is deprecated.

However, we never actually marked it as deprecated nor provided any
way to disable it. Let's do it now.

This patch prepares for the removal of this bad usage on a couple
of Kernel versions.

Fixes: da8ec560e3b4 ("[media] ivtv: implement new decoder command ioctls")
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/ivtv/Kconfig       | 13 ++++++++++
 drivers/media/pci/ivtv/ivtv-driver.h |  2 --
 drivers/media/pci/ivtv/ivtv-ioctl.c  | 49 ++++++++++++++++++++++++------------
 3 files changed, 46 insertions(+), 18 deletions(-)

diff --git a/drivers/media/pci/ivtv/Kconfig b/drivers/media/pci/ivtv/Kconfig
index 6e5867c57305..c72cbbd2d40c 100644
--- a/drivers/media/pci/ivtv/Kconfig
+++ b/drivers/media/pci/ivtv/Kconfig
@@ -28,6 +28,19 @@ config VIDEO_IVTV
 	  To compile this driver as a module, choose M here: the
 	  module will be called ivtv.
 
+config VIDEO_IVTV_DEPRECATED_IOCTLS
+	bool "enable the DVB ioctls abuse on ivtv driver"
+	depends on VIDEO_IVTV
+	default n
+	---help---
+	  Enable the usage of the a DVB set of ioctls that were abused by
+	  IVTV driver for a while.
+
+	  Those ioctls were not needed for a long time, as IVTV implements
+	  the proper V4L2 ioctls since kernel 3.3.
+
+	  If unsure, say N.
+
 config VIDEO_IVTV_ALSA
 	tristate "Conexant cx23415/cx23416 ALSA interface for PCM audio capture"
 	depends on VIDEO_IVTV && SND
diff --git a/drivers/media/pci/ivtv/ivtv-driver.h b/drivers/media/pci/ivtv/ivtv-driver.h
index b2b0fa27b1a7..ab1fb48d5629 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.h
+++ b/drivers/media/pci/ivtv/ivtv-driver.h
@@ -42,8 +42,6 @@
 #include <asm/uaccess.h>
 #include <linux/delay.h>
 #include <linux/device.h>
-#include <linux/dvb/audio.h>
-#include <linux/dvb/video.h>
 #include <linux/fs.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 2dc4b20f3ac0..e5e53a09537e 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -35,7 +35,10 @@
 #include <media/i2c/saa7127.h>
 #include <media/tveeprom.h>
 #include <media/v4l2-event.h>
+#ifdef CONFIG_VIDEO_IVTV_DEPRECATED_IOCTLS
 #include <linux/dvb/audio.h>
+#include <linux/dvb/video.h>
+#endif
 
 u16 ivtv_service2vbi(int type)
 {
@@ -1620,13 +1623,23 @@ static int ivtv_try_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder
 	return ivtv_video_command(itv, id, dec, true);
 }
 
+#ifdef CONFIG_VIDEO_IVTV_DEPRECATED_IOCTLS
+static __inline__ void warn_deprecated_ioctl(char *name)
+{
+	pr_warn_once("warning: the %s ioctl is deprecated. Don't use it, as it will be removed soon\n",
+		     name);
+}
+#endif
+
 static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 {
 	struct ivtv_open_id *id = fh2id(filp->private_data);
 	struct ivtv *itv = id->itv;
+	struct ivtv_stream *s = &itv->streams[id->type];
+#ifdef CONFIG_VIDEO_IVTV_DEPRECATED_IOCTLS
 	int nonblocking = filp->f_flags & O_NONBLOCK;
-	struct ivtv_stream *s = &itv->streams[id->type];
 	unsigned long iarg = (unsigned long)arg;
+#endif
 
 	switch (cmd) {
 	case IVTV_IOC_DMA_FRAME: {
@@ -1658,12 +1671,12 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 		if (!(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT))
 			return -EINVAL;
 		return ivtv_passthrough_mode(itv, *(int *)arg != 0);
-
+#ifdef CONFIG_VIDEO_IVTV_DEPRECATED_IOCTLS
 	case VIDEO_GET_PTS: {
 		s64 *pts = arg;
 		s64 frame;
 
-		IVTV_DEBUG_IOCTL("VIDEO_GET_PTS\n");
+		warn_deprecated_ioctl("VIDEO_GET_PTS");
 		if (s->type < IVTV_DEC_STREAM_TYPE_MPG) {
 			*pts = s->dma_pts;
 			break;
@@ -1677,7 +1690,7 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 		s64 *frame = arg;
 		s64 pts;
 
-		IVTV_DEBUG_IOCTL("VIDEO_GET_FRAME_COUNT\n");
+		warn_deprecated_ioctl("VIDEO_GET_FRAME_COUNT");
 		if (s->type < IVTV_DEC_STREAM_TYPE_MPG) {
 			*frame = 0;
 			break;
@@ -1690,7 +1703,7 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 	case VIDEO_PLAY: {
 		struct v4l2_decoder_cmd dc;
 
-		IVTV_DEBUG_IOCTL("VIDEO_PLAY\n");
+		warn_deprecated_ioctl("VIDEO_PLAY");
 		memset(&dc, 0, sizeof(dc));
 		dc.cmd = V4L2_DEC_CMD_START;
 		return ivtv_video_command(itv, id, &dc, 0);
@@ -1699,7 +1712,7 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 	case VIDEO_STOP: {
 		struct v4l2_decoder_cmd dc;
 
-		IVTV_DEBUG_IOCTL("VIDEO_STOP\n");
+		warn_deprecated_ioctl("VIDEO_STOP");
 		memset(&dc, 0, sizeof(dc));
 		dc.cmd = V4L2_DEC_CMD_STOP;
 		dc.flags = V4L2_DEC_CMD_STOP_TO_BLACK | V4L2_DEC_CMD_STOP_IMMEDIATELY;
@@ -1709,7 +1722,7 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 	case VIDEO_FREEZE: {
 		struct v4l2_decoder_cmd dc;
 
-		IVTV_DEBUG_IOCTL("VIDEO_FREEZE\n");
+		warn_deprecated_ioctl("VIDEO_FREEZE");
 		memset(&dc, 0, sizeof(dc));
 		dc.cmd = V4L2_DEC_CMD_PAUSE;
 		return ivtv_video_command(itv, id, &dc, 0);
@@ -1718,7 +1731,7 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 	case VIDEO_CONTINUE: {
 		struct v4l2_decoder_cmd dc;
 
-		IVTV_DEBUG_IOCTL("VIDEO_CONTINUE\n");
+		warn_deprecated_ioctl("VIDEO_CONTINUE");
 		memset(&dc, 0, sizeof(dc));
 		dc.cmd = V4L2_DEC_CMD_RESUME;
 		return ivtv_video_command(itv, id, &dc, 0);
@@ -1732,9 +1745,9 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 		int try = (cmd == VIDEO_TRY_COMMAND);
 
 		if (try)
-			IVTV_DEBUG_IOCTL("VIDEO_TRY_COMMAND %d\n", dc->cmd);
+			warn_deprecated_ioctl("VIDEO_TRY_COMMAND");
 		else
-			IVTV_DEBUG_IOCTL("VIDEO_COMMAND %d\n", dc->cmd);
+			warn_deprecated_ioctl("VIDEO_COMMAND");
 		return ivtv_video_command(itv, id, dc, try);
 	}
 
@@ -1742,7 +1755,7 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 		struct video_event *ev = arg;
 		DEFINE_WAIT(wait);
 
-		IVTV_DEBUG_IOCTL("VIDEO_GET_EVENT\n");
+		warn_deprecated_ioctl("VIDEO_GET_EVENT");
 		if (!(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT))
 			return -EINVAL;
 		memset(ev, 0, sizeof(*ev));
@@ -1785,28 +1798,28 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
 	}
 
 	case VIDEO_SELECT_SOURCE:
-		IVTV_DEBUG_IOCTL("VIDEO_SELECT_SOURCE\n");
+		warn_deprecated_ioctl("VIDEO_SELECT_SOURCE");
 		if (!(itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT))
 			return -EINVAL;
 		return ivtv_passthrough_mode(itv, iarg == VIDEO_SOURCE_DEMUX);
 
 	case AUDIO_SET_MUTE:
-		IVTV_DEBUG_IOCTL("AUDIO_SET_MUTE\n");
+		warn_deprecated_ioctl("AUDIO_SET_MUTE");
 		itv->speed_mute_audio = iarg;
 		return 0;
 
 	case AUDIO_CHANNEL_SELECT:
-		IVTV_DEBUG_IOCTL("AUDIO_CHANNEL_SELECT\n");
+		warn_deprecated_ioctl("AUDIO_CHANNEL_SELECTn");
 		if (iarg > AUDIO_STEREO_SWAPPED)
 			return -EINVAL;
 		return v4l2_ctrl_s_ctrl(itv->ctrl_audio_playback, iarg + 1);
 
 	case AUDIO_BILINGUAL_CHANNEL_SELECT:
-		IVTV_DEBUG_IOCTL("AUDIO_BILINGUAL_CHANNEL_SELECT\n");
+		warn_deprecated_ioctl("AUDIO_BILINGUAL_CHANNEL_SELECT");
 		if (iarg > AUDIO_STEREO_SWAPPED)
 			return -EINVAL;
 		return v4l2_ctrl_s_ctrl(itv->ctrl_audio_multilingual_playback, iarg + 1);
-
+#endif
 	default:
 		return -EINVAL;
 	}
@@ -1821,6 +1834,7 @@ static long ivtv_default(struct file *file, void *fh, bool valid_prio,
 	if (!valid_prio) {
 		switch (cmd) {
 		case IVTV_IOC_PASSTHROUGH_MODE:
+#ifdef CONFIG_VIDEO_IVTV_DEPRECATED_IOCTLS
 		case VIDEO_PLAY:
 		case VIDEO_STOP:
 		case VIDEO_FREEZE:
@@ -1830,6 +1844,7 @@ static long ivtv_default(struct file *file, void *fh, bool valid_prio,
 		case AUDIO_SET_MUTE:
 		case AUDIO_CHANNEL_SELECT:
 		case AUDIO_BILINGUAL_CHANNEL_SELECT:
+#endif
 			return -EBUSY;
 		}
 	}
@@ -1847,6 +1862,7 @@ static long ivtv_default(struct file *file, void *fh, bool valid_prio,
 
 	case IVTV_IOC_DMA_FRAME:
 	case IVTV_IOC_PASSTHROUGH_MODE:
+#ifdef CONFIG_VIDEO_IVTV_DEPRECATED_IOCTLS
 	case VIDEO_GET_PTS:
 	case VIDEO_GET_FRAME_COUNT:
 	case VIDEO_GET_EVENT:
@@ -1860,6 +1876,7 @@ static long ivtv_default(struct file *file, void *fh, bool valid_prio,
 	case AUDIO_SET_MUTE:
 	case AUDIO_CHANNEL_SELECT:
 	case AUDIO_BILINGUAL_CHANNEL_SELECT:
+#endif
 		return ivtv_decoder_ioctls(file, cmd, (void *)arg);
 
 	default:
-- 
2.9.3

