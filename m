Return-path: <mchehab@gaivota>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1850 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab0L2VnY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 16:43:24 -0500
Received: from localhost (marune.xs4all.nl [82.95.89.49])
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBTLhMoU003808
	for <linux-media@vger.kernel.org>; Wed, 29 Dec 2010 22:43:23 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Message-Id: <6735d7a126365a756c968ba0463c9a16d6cf1c0c.1293657717.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1293657717.git.hverkuil@xs4all.nl>
References: <cover.1293657717.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 29 Dec 2010 22:43:22 +0100
Subject: [PATCH 06/10] [RFC] ivtv: convert to core priority handling.
To: linux-media@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/ivtv/ivtv-driver.h  |    2 -
 drivers/media/video/ivtv/ivtv-fileops.c |    2 -
 drivers/media/video/ivtv/ivtv-ioctl.c   |   56 ++++++++----------------------
 3 files changed, 15 insertions(+), 45 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
index 04bacdb..84bdf0f 100644
--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -383,7 +383,6 @@ struct ivtv_open_id {
 	u32 open_id;                    /* unique ID for this file descriptor */
 	int type;                       /* stream type */
 	int yuv_frames;                 /* 1: started OUT_UDMA_YUV output mode */
-	enum v4l2_priority prio;        /* priority */
 	struct ivtv *itv;
 };
 
@@ -710,7 +709,6 @@ struct ivtv {
 
 	/* Miscellaneous */
 	u32 open_id;			/* incremented each time an open occurs, is >= 1 */
-	struct v4l2_prio_state prio;    /* priority state */
 	int search_pack_header;         /* 1 if ivtv_copy_buf_to_user() is scanning for a pack header (0xba) */
 	int speed;                      /* current playback speed setting */
 	u8 speed_mute_audio;            /* 1 if audio should be muted when fast forward */
diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
index c57a585..4463bf4 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -856,7 +856,6 @@ int ivtv_v4l2_close(struct file *filp)
 
 	IVTV_DEBUG_FILE("close %s\n", s->name);
 
-	v4l2_prio_close(&itv->prio, id->prio);
 	v4l2_fh_del(fh);
 	v4l2_fh_exit(fh);
 
@@ -973,7 +972,6 @@ static int ivtv_serialized_open(struct ivtv_stream *s, struct file *filp)
 	}
 	item->itv = itv;
 	item->type = s->type;
-	v4l2_prio_open(&itv->prio, &item->prio);
 
 	item->open_id = itv->open_id++;
 	filp->private_data = &item->fh;
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index d9386a7..6fb1837 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -750,23 +750,6 @@ static int ivtv_s_register(struct file *file, void *fh, struct v4l2_dbg_register
 }
 #endif
 
-static int ivtv_g_priority(struct file *file, void *fh, enum v4l2_priority *p)
-{
-	struct ivtv *itv = ((struct ivtv_open_id *)fh)->itv;
-
-	*p = v4l2_prio_max(&itv->prio);
-
-	return 0;
-}
-
-static int ivtv_s_priority(struct file *file, void *fh, enum v4l2_priority prio)
-{
-	struct ivtv_open_id *id = fh;
-	struct ivtv *itv = id->itv;
-
-	return v4l2_prio_change(&itv->prio, &id->prio, prio);
-}
-
 static int ivtv_querycap(struct file *file, void *fh, struct v4l2_capability *vcap)
 {
 	struct ivtv *itv = ((struct ivtv_open_id *)fh)->itv;
@@ -1800,6 +1783,21 @@ static long ivtv_default(struct file *file, void *fh, bool valid_prio,
 {
 	struct ivtv *itv = ((struct ivtv_open_id *)fh)->itv;
 
+	if (!valid_prio) {
+		switch (cmd) {
+		case VIDEO_PLAY:
+		case VIDEO_STOP:
+		case VIDEO_FREEZE:
+		case VIDEO_CONTINUE:
+		case VIDEO_COMMAND:
+		case VIDEO_SELECT_SOURCE:
+		case AUDIO_SET_MUTE:
+		case AUDIO_CHANNEL_SELECT:
+		case AUDIO_BILINGUAL_CHANNEL_SELECT:
+			return -EBUSY;
+		}
+	}
+
 	switch (cmd) {
 	case VIDIOC_INT_RESET: {
 		u32 val = *(u32 *)arg;
@@ -1837,30 +1835,8 @@ static long ivtv_serialized_ioctl(struct ivtv *itv, struct file *filp,
 		unsigned int cmd, unsigned long arg)
 {
 	struct video_device *vfd = video_devdata(filp);
-	struct ivtv_open_id *id = fh2id(filp->private_data);
 	long ret;
 
-	/* check priority */
-	switch (cmd) {
-	case VIDIOC_S_CTRL:
-	case VIDIOC_S_STD:
-	case VIDIOC_S_INPUT:
-	case VIDIOC_S_OUTPUT:
-	case VIDIOC_S_TUNER:
-	case VIDIOC_S_FREQUENCY:
-	case VIDIOC_S_FMT:
-	case VIDIOC_S_CROP:
-	case VIDIOC_S_AUDIO:
-	case VIDIOC_S_AUDOUT:
-	case VIDIOC_S_EXT_CTRLS:
-	case VIDIOC_S_FBUF:
-	case VIDIOC_S_PRIORITY:
-	case VIDIOC_OVERLAY:
-		ret = v4l2_prio_check(&itv->prio, id->prio);
-		if (ret)
-			return ret;
-	}
-
 	if (ivtv_debug & IVTV_DBGFLG_IOCTL)
 		vfd->debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
 	ret = video_ioctl2(filp, cmd, arg);
@@ -1885,8 +1861,6 @@ long ivtv_v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 static const struct v4l2_ioctl_ops ivtv_ioctl_ops = {
 	.vidioc_querycap    		    = ivtv_querycap,
-	.vidioc_g_priority  		    = ivtv_g_priority,
-	.vidioc_s_priority  		    = ivtv_s_priority,
 	.vidioc_s_audio     		    = ivtv_s_audio,
 	.vidioc_g_audio     		    = ivtv_g_audio,
 	.vidioc_enumaudio   		    = ivtv_enumaudio,
-- 
1.6.4.2

