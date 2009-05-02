Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:61950 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbZEBTit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 May 2009 15:38:49 -0400
Received: by ewy24 with SMTP id 24so2982606ewy.37
        for <linux-media@vger.kernel.org>; Sat, 02 May 2009 12:38:48 -0700 (PDT)
Message-ID: <49FCA147.5050200@gmail.com>
Date: Sat, 02 May 2009 21:38:47 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Subject: [PATCH] V4L/DVB: cleanup redundant tests on unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove redundant tests on unsigned.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
All tests are similar to `if (x < 0 || x > MAX) ...' where x is unsigned.
When x is negative, wrapping occurs. Only the second half is effective.

 drivers/media/dvb/ttpci/av7110_v4l.c            |    2 +-
 drivers/media/dvb/ttpci/budget-av.c             |    2 +-
 drivers/media/video/cpia2/cpia2_v4l.c           |    6 +++---
 drivers/media/video/hexium_gemini.c             |    2 +-
 drivers/media/video/hexium_orion.c              |    2 +-
 drivers/media/video/ivtv/ivtv-ioctl.c           |    2 +-
 drivers/media/video/mxb.c                       |    4 ++--
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c      |    4 ++--
 drivers/media/video/pwc/pwc-v4l.c               |    2 +-
 drivers/media/video/stk-webcam.c                |    4 ++--
 drivers/media/video/usbvision/usbvision-video.c |    2 +-
 drivers/media/video/videobuf-core.c             |    4 ++--
 12 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb/ttpci/av7110_v4l.c b/drivers/media/dvb/ttpci/av7110_v4l.c
index 2210cff..ce64c62 100644
--- a/drivers/media/dvb/ttpci/av7110_v4l.c
+++ b/drivers/media/dvb/ttpci/av7110_v4l.c
@@ -458,7 +458,7 @@ static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
 	dprintk(2, "VIDIOC_ENUMINPUT: %d\n", i->index);
 
 	if (av7110->analog_tuner_flags) {
-		if (i->index < 0 || i->index >= 4)
+		if (i->index >= 4)
 			return -EINVAL;
 	} else {
 		if (i->index != 0)
diff --git a/drivers/media/dvb/ttpci/budget-av.c b/drivers/media/dvb/ttpci/budget-av.c
index 855fe74..8ea9152 100644
--- a/drivers/media/dvb/ttpci/budget-av.c
+++ b/drivers/media/dvb/ttpci/budget-av.c
@@ -1413,7 +1413,7 @@ static struct v4l2_input knc1_inputs[KNC1_INPUTS] = {
 static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
 {
 	dprintk(1, "VIDIOC_ENUMINPUT %d.\n", i->index);
-	if (i->index < 0 || i->index >= KNC1_INPUTS)
+	if (i->index >= KNC1_INPUTS)
 		return -EINVAL;
 	memcpy(i, &knc1_inputs[i->index], sizeof(struct v4l2_input));
 	return 0;
diff --git a/drivers/media/video/cpia2/cpia2_v4l.c b/drivers/media/video/cpia2/cpia2_v4l.c
index d4099f5..0b4a8f3 100644
--- a/drivers/media/video/cpia2/cpia2_v4l.c
+++ b/drivers/media/video/cpia2/cpia2_v4l.c
@@ -1064,7 +1064,7 @@ static int ioctl_querymenu(void *arg,struct camera_data *cam)
 
 	switch(m->id) {
 	case CPIA2_CID_FLICKER_MODE:
-		if(m->index < 0 || m->index >= NUM_FLICKER_CONTROLS)
+		if (m->index >= NUM_FLICKER_CONTROLS)
 			return -EINVAL;
 
 		strcpy(m->name, flicker_controls[m->index].name);
@@ -1082,14 +1082,14 @@ static int ioctl_querymenu(void *arg,struct camera_data *cam)
 					maximum = i;
 			}
 		}
-		if(m->index < 0 || m->index > maximum)
+		if (m->index > maximum)
 			return -EINVAL;
 
 		strcpy(m->name, framerate_controls[m->index].name);
 		break;
 	    }
 	case CPIA2_CID_LIGHTS:
-		if(m->index < 0 || m->index >= NUM_LIGHTS_CONTROLS)
+		if (m->index >= NUM_LIGHTS_CONTROLS)
 			return -EINVAL;
 
 		strcpy(m->name, lights_controls[m->index].name);
diff --git a/drivers/media/video/hexium_gemini.c b/drivers/media/video/hexium_gemini.c
index 8e1463e..71c2114 100644
--- a/drivers/media/video/hexium_gemini.c
+++ b/drivers/media/video/hexium_gemini.c
@@ -224,7 +224,7 @@ static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
 {
 	DEB_EE(("VIDIOC_ENUMINPUT %d.\n", i->index));
 
-	if (i->index < 0 || i->index >= HEXIUM_INPUTS)
+	if (i->index >= HEXIUM_INPUTS)
 		return -EINVAL;
 
 	memcpy(i, &hexium_inputs[i->index], sizeof(struct v4l2_input));
diff --git a/drivers/media/video/hexium_orion.c b/drivers/media/video/hexium_orion.c
index 2bc39f6..39d65ca 100644
--- a/drivers/media/video/hexium_orion.c
+++ b/drivers/media/video/hexium_orion.c
@@ -325,7 +325,7 @@ static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
 {
 	DEB_EE(("VIDIOC_ENUMINPUT %d.\n", i->index));
 
-	if (i->index < 0 || i->index >= HEXIUM_INPUTS)
+	if (i->index >= HEXIUM_INPUTS)
 		return -EINVAL;
 
 	memcpy(i, &hexium_inputs[i->index], sizeof(struct v4l2_input));
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index 4a2d464..e74e2a7 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -709,7 +709,7 @@ static int ivtv_itvc(struct ivtv *itv, unsigned int cmd, void *arg)
 	else if (itv->has_cx23415 && regs->reg >= IVTV_DECODER_OFFSET &&
 			regs->reg < IVTV_DECODER_OFFSET + IVTV_DECODER_SIZE)
 		reg_start = itv->dec_mem - IVTV_DECODER_OFFSET;
-	else if (regs->reg >= 0 && regs->reg < IVTV_ENCODER_SIZE)
+	else if (regs->reg < IVTV_ENCODER_SIZE)
 		reg_start = itv->enc_mem;
 	else
 		return -EINVAL;
diff --git a/drivers/media/video/mxb.c b/drivers/media/video/mxb.c
index 3be5a71..35890e8 100644
--- a/drivers/media/video/mxb.c
+++ b/drivers/media/video/mxb.c
@@ -453,7 +453,7 @@ static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *vc)
 static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
 {
 	DEB_EE(("VIDIOC_ENUMINPUT %d.\n", i->index));
-	if (i->index < 0 || i->index >= MXB_INPUTS)
+	if (i->index >= MXB_INPUTS)
 		return -EINVAL;
 	memcpy(i, &mxb_inputs[i->index], sizeof(struct v4l2_input));
 	return 0;
@@ -616,7 +616,7 @@ static int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *a)
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 	struct mxb *mxb = (struct mxb *)dev->ext_priv;
 
-	if (a->index < 0 || a->index > MXB_INPUTS) {
+	if (a->index > MXB_INPUTS) {
 		DEB_D(("VIDIOC_G_AUDIO %d out of range.\n", a->index));
 		return -EINVAL;
 	}
diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index 9e0f2b0..24b3c1d 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -267,7 +267,7 @@ static long pvr2_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		memset(&tmp,0,sizeof(tmp));
 		tmp.index = vi->index;
 		ret = 0;
-		if ((vi->index < 0) || (vi->index >= fh->input_cnt)) {
+		if (vi->index >= fh->input_cnt) {
 			ret = -EINVAL;
 			break;
 		}
@@ -331,7 +331,7 @@ static long pvr2_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_S_INPUT:
 	{
 		struct v4l2_input *vi = (struct v4l2_input *)arg;
-		if ((vi->index < 0) || (vi->index >= fh->input_cnt)) {
+		if (vi->index >= fh->input_cnt) {
 			ret = -ERANGE;
 			break;
 		}
diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/video/pwc/pwc-v4l.c
index bc0a464..2876ce0 100644
--- a/drivers/media/video/pwc/pwc-v4l.c
+++ b/drivers/media/video/pwc/pwc-v4l.c
@@ -1107,7 +1107,7 @@ long pwc_video_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 				return -EINVAL;
 			if (buf->memory != V4L2_MEMORY_MMAP)
 				return -EINVAL;
-			if (buf->index < 0 || buf->index >= pwc_mbufs)
+			if (buf->index >= pwc_mbufs)
 				return -EINVAL;
 
 			buf->flags |= V4L2_BUF_FLAG_QUEUED;
diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index 1a6d39c..2e59370 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -1137,7 +1137,7 @@ static int stk_vidioc_querybuf(struct file *filp,
 	struct stk_camera *dev = priv;
 	struct stk_sio_buffer *sbuf;
 
-	if (buf->index < 0 || buf->index >= dev->n_sbufs)
+	if (buf->index >= dev->n_sbufs)
 		return -EINVAL;
 	sbuf = dev->sio_bufs + buf->index;
 	*buf = sbuf->v4lbuf;
@@ -1154,7 +1154,7 @@ static int stk_vidioc_qbuf(struct file *filp,
 	if (buf->memory != V4L2_MEMORY_MMAP)
 		return -EINVAL;
 
-	if (buf->index < 0 || buf->index >= dev->n_sbufs)
+	if (buf->index >= dev->n_sbufs)
 		return -EINVAL;
 	sbuf = dev->sio_bufs + buf->index;
 	if (sbuf->v4lbuf.flags & V4L2_BUF_FLAG_QUEUED)
diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index d7056a5..d03e592 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -541,7 +541,7 @@ static int vidioc_enum_input (struct file *file, void *priv,
 	struct usb_usbvision *usbvision = video_drvdata(file);
 	int chan;
 
-	if ((vi->index >= usbvision->video_inputs) || (vi->index < 0) )
+	if (vi->index >= usbvision->video_inputs)
 		return -EINVAL;
 	if (usbvision->have_tuner) {
 		chan = vi->index;
diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index b7b0584..0c0e9fc 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -454,7 +454,7 @@ int videobuf_querybuf(struct videobuf_queue *q, struct v4l2_buffer *b)
 		dprintk(1, "querybuf: Wrong type.\n");
 		goto done;
 	}
-	if (unlikely(b->index < 0 || b->index >= VIDEO_MAX_FRAME)) {
+	if (unlikely(b->index >= VIDEO_MAX_FRAME)) {
 		dprintk(1, "querybuf: index out of range.\n");
 		goto done;
 	}
@@ -495,7 +495,7 @@ int videobuf_qbuf(struct videobuf_queue *q,
 		dprintk(1, "qbuf: Wrong type.\n");
 		goto done;
 	}
-	if (b->index < 0 || b->index >= VIDEO_MAX_FRAME) {
+	if (b->index >= VIDEO_MAX_FRAME) {
 		dprintk(1, "qbuf: index out of range.\n");
 		goto done;
 	}
