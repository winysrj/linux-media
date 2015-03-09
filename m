Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:55543 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932241AbbCIQea (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:34:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 01/19] ivtv: embed video_device
Date: Mon,  9 Mar 2015 17:33:55 +0100
Message-Id: <1425918853-12371-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/pci/ivtv/ivtv-alsa-main.c |   2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c  |   2 +-
 drivers/media/pci/ivtv/ivtv-driver.c    |   4 +-
 drivers/media/pci/ivtv/ivtv-driver.h    |   2 +-
 drivers/media/pci/ivtv/ivtv-fileops.c   |   2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c     |   8 +--
 drivers/media/pci/ivtv/ivtv-irq.c       |   8 +--
 drivers/media/pci/ivtv/ivtv-streams.c   | 107 ++++++++++++++------------------
 drivers/media/pci/ivtv/ivtv-streams.h   |   2 +-
 9 files changed, 61 insertions(+), 76 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-alsa-main.c b/drivers/media/pci/ivtv/ivtv-alsa-main.c
index 39b5292..41fa215 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-main.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-main.c
@@ -224,7 +224,7 @@ static int ivtv_alsa_load(struct ivtv *itv)
 	}
 
 	s = &itv->streams[IVTV_ENC_STREAM_TYPE_PCM];
-	if (s->vdev == NULL) {
+	if (s->vdev.v4l2_dev == NULL) {
 		IVTV_DEBUG_ALSA_INFO("%s: PCM stream for card is disabled - "
 				     "skipping\n", __func__);
 		return 0;
diff --git a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
index 7bf9cbc..f198b98 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
@@ -167,7 +167,7 @@ static int snd_ivtv_pcm_capture_open(struct snd_pcm_substream *substream)
 
 	s = &itv->streams[IVTV_ENC_STREAM_TYPE_PCM];
 
-	v4l2_fh_init(&item.fh, s->vdev);
+	v4l2_fh_init(&item.fh, &s->vdev);
 	item.itv = itv;
 	item.type = s->type;
 
diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index 802642d..c2e60b4 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -1284,7 +1284,7 @@ static int ivtv_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 	return 0;
 
 free_streams:
-	ivtv_streams_cleanup(itv, 1);
+	ivtv_streams_cleanup(itv);
 free_irq:
 	free_irq(itv->pdev->irq, (void *)itv);
 free_i2c:
@@ -1444,7 +1444,7 @@ static void ivtv_remove(struct pci_dev *pdev)
 	flush_kthread_worker(&itv->irq_worker);
 	kthread_stop(itv->irq_worker_task);
 
-	ivtv_streams_cleanup(itv, 1);
+	ivtv_streams_cleanup(itv);
 	ivtv_udma_free(itv);
 
 	v4l2_ctrl_handler_free(&itv->cxhdl.hdl);
diff --git a/drivers/media/pci/ivtv/ivtv-driver.h b/drivers/media/pci/ivtv/ivtv-driver.h
index bc309f42c..e8b6c7a 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.h
+++ b/drivers/media/pci/ivtv/ivtv-driver.h
@@ -327,7 +327,7 @@ struct ivtv;				/* forward reference */
 struct ivtv_stream {
 	/* These first four fields are always set, even if the stream
 	   is not actually created. */
-	struct video_device *vdev;	/* NULL when stream not created */
+	struct video_device vdev;	/* vdev.v4l2_dev is NULL if there is no device */
 	struct ivtv *itv; 		/* for ease of use */
 	const char *name;		/* name of the stream */
 	int type;			/* stream type */
diff --git a/drivers/media/pci/ivtv/ivtv-fileops.c b/drivers/media/pci/ivtv/ivtv-fileops.c
index e5ff627..605d280 100644
--- a/drivers/media/pci/ivtv/ivtv-fileops.c
+++ b/drivers/media/pci/ivtv/ivtv-fileops.c
@@ -995,7 +995,7 @@ static int ivtv_open(struct file *filp)
 		IVTV_DEBUG_WARN("nomem on v4l2 open\n");
 		return -ENOMEM;
 	}
-	v4l2_fh_init(&item->fh, s->vdev);
+	v4l2_fh_init(&item->fh, &s->vdev);
 	item->itv = itv;
 	item->type = s->type;
 
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 4d8ee18..fa87565 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -987,7 +987,7 @@ int ivtv_s_input(struct file *file, void *fh, unsigned int inp)
 	else
 		std = V4L2_STD_ALL;
 	for (i = 0; i <= IVTV_ENC_STREAM_TYPE_VBI; i++)
-		itv->streams[i].vdev->tvnorms = std;
+		itv->streams[i].vdev.tvnorms = std;
 
 	/* prevent others from messing with the streams until
 	   we're finished changing inputs. */
@@ -1038,7 +1038,7 @@ static int ivtv_g_frequency(struct file *file, void *fh, struct v4l2_frequency *
 	struct ivtv *itv = fh2id(fh)->itv;
 	struct ivtv_stream *s = &itv->streams[fh2id(fh)->type];
 
-	if (s->vdev->vfl_dir)
+	if (s->vdev.vfl_dir)
 		return -ENOTTY;
 	if (vf->tuner != 0)
 		return -EINVAL;
@@ -1052,7 +1052,7 @@ int ivtv_s_frequency(struct file *file, void *fh, const struct v4l2_frequency *v
 	struct ivtv *itv = fh2id(fh)->itv;
 	struct ivtv_stream *s = &itv->streams[fh2id(fh)->type];
 
-	if (s->vdev->vfl_dir)
+	if (s->vdev.vfl_dir)
 		return -ENOTTY;
 	if (vf->tuner != 0)
 		return -EINVAL;
@@ -1547,7 +1547,7 @@ static int ivtv_log_status(struct file *file, void *fh)
 	for (i = 0; i < IVTV_MAX_STREAMS; i++) {
 		struct ivtv_stream *s = &itv->streams[i];
 
-		if (s->vdev == NULL || s->buffers == 0)
+		if (s->vdev.v4l2_dev == NULL || s->buffers == 0)
 			continue;
 		IVTV_INFO("Stream %s: status 0x%04lx, %d%% of %d KiB (%d buffers) in use\n", s->name, s->s_flags,
 				(s->buffers - s->q_free.buffers) * 100 / s->buffers,
diff --git a/drivers/media/pci/ivtv/ivtv-irq.c b/drivers/media/pci/ivtv/ivtv-irq.c
index e7d7017..36ca2d6 100644
--- a/drivers/media/pci/ivtv/ivtv-irq.c
+++ b/drivers/media/pci/ivtv/ivtv-irq.c
@@ -75,7 +75,7 @@ static void ivtv_pio_work_handler(struct ivtv *itv)
 
 	IVTV_DEBUG_HI_DMA("ivtv_pio_work_handler\n");
 	if (itv->cur_pio_stream < 0 || itv->cur_pio_stream >= IVTV_MAX_STREAMS ||
-			s->vdev == NULL || !ivtv_use_pio(s)) {
+			s->vdev.v4l2_dev == NULL || !ivtv_use_pio(s)) {
 		itv->cur_pio_stream = -1;
 		/* trigger PIO complete user interrupt */
 		write_reg(IVTV_IRQ_ENC_PIO_COMPLETE, 0x44);
@@ -132,7 +132,7 @@ static int stream_enc_dma_append(struct ivtv_stream *s, u32 data[CX2341X_MBOX_MA
 	int rc;
 
 	/* sanity checks */
-	if (s->vdev == NULL) {
+	if (s->vdev.v4l2_dev == NULL) {
 		IVTV_DEBUG_WARN("Stream %s not started\n", s->name);
 		return -1;
 	}
@@ -890,8 +890,8 @@ static void ivtv_irq_vsync(struct ivtv *itv)
 			if (s)
 				wake_up(&s->waitq);
 		}
-		if (s && s->vdev)
-			v4l2_event_queue(s->vdev, frame ? &evtop : &evbottom);
+		if (s && s->vdev.v4l2_dev)
+			v4l2_event_queue(&s->vdev, frame ? &evtop : &evbottom);
 		wake_up(&itv->vsync_waitq);
 
 		/* Send VBI to saa7127 */
diff --git a/drivers/media/pci/ivtv/ivtv-streams.c b/drivers/media/pci/ivtv/ivtv-streams.c
index f0a1cc4..cfb61f2 100644
--- a/drivers/media/pci/ivtv/ivtv-streams.c
+++ b/drivers/media/pci/ivtv/ivtv-streams.c
@@ -159,11 +159,9 @@ static struct {
 static void ivtv_stream_init(struct ivtv *itv, int type)
 {
 	struct ivtv_stream *s = &itv->streams[type];
-	struct video_device *vdev = s->vdev;
 
 	/* we need to keep vdev, so restore it afterwards */
 	memset(s, 0, sizeof(*s));
-	s->vdev = vdev;
 
 	/* initialize ivtv_stream fields */
 	s->itv = itv;
@@ -194,10 +192,10 @@ static int ivtv_prep_dev(struct ivtv *itv, int type)
 	int num_offset = ivtv_stream_info[type].num_offset;
 	int num = itv->instance + ivtv_first_minor + num_offset;
 
-	/* These four fields are always initialized. If vdev == NULL, then
+	/* These four fields are always initialized. If vdev.v4l2_dev == NULL, then
 	   this stream is not in use. In that case no other fields but these
 	   four can be used. */
-	s->vdev = NULL;
+	s->vdev.v4l2_dev = NULL;
 	s->itv = itv;
 	s->type = type;
 	s->name = ivtv_stream_info[type].name;
@@ -218,40 +216,33 @@ static int ivtv_prep_dev(struct ivtv *itv, int type)
 
 	ivtv_stream_init(itv, type);
 
-	/* allocate and initialize the v4l2 video device structure */
-	s->vdev = video_device_alloc();
-	if (s->vdev == NULL) {
-		IVTV_ERR("Couldn't allocate v4l2 video_device for %s\n", s->name);
-		return -ENOMEM;
-	}
-
-	snprintf(s->vdev->name, sizeof(s->vdev->name), "%s %s",
+	snprintf(s->vdev.name, sizeof(s->vdev.name), "%s %s",
 			itv->v4l2_dev.name, s->name);
 
-	s->vdev->num = num;
-	s->vdev->v4l2_dev = &itv->v4l2_dev;
+	s->vdev.num = num;
+	s->vdev.v4l2_dev = &itv->v4l2_dev;
 	if (ivtv_stream_info[type].v4l2_caps &
 			(V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_SLICED_VBI_OUTPUT))
-		s->vdev->vfl_dir = VFL_DIR_TX;
-	s->vdev->fops = ivtv_stream_info[type].fops;
-	s->vdev->ctrl_handler = itv->v4l2_dev.ctrl_handler;
-	s->vdev->release = video_device_release;
-	s->vdev->tvnorms = V4L2_STD_ALL;
-	s->vdev->lock = &itv->serialize_lock;
+		s->vdev.vfl_dir = VFL_DIR_TX;
+	s->vdev.fops = ivtv_stream_info[type].fops;
+	s->vdev.ctrl_handler = itv->v4l2_dev.ctrl_handler;
+	s->vdev.release = video_device_release_empty;
+	s->vdev.tvnorms = V4L2_STD_ALL;
+	s->vdev.lock = &itv->serialize_lock;
 	if (s->type == IVTV_DEC_STREAM_TYPE_VBI) {
-		v4l2_disable_ioctl(s->vdev, VIDIOC_S_AUDIO);
-		v4l2_disable_ioctl(s->vdev, VIDIOC_G_AUDIO);
-		v4l2_disable_ioctl(s->vdev, VIDIOC_ENUMAUDIO);
-		v4l2_disable_ioctl(s->vdev, VIDIOC_ENUMINPUT);
-		v4l2_disable_ioctl(s->vdev, VIDIOC_S_INPUT);
-		v4l2_disable_ioctl(s->vdev, VIDIOC_G_INPUT);
-		v4l2_disable_ioctl(s->vdev, VIDIOC_S_FREQUENCY);
-		v4l2_disable_ioctl(s->vdev, VIDIOC_G_FREQUENCY);
-		v4l2_disable_ioctl(s->vdev, VIDIOC_S_TUNER);
-		v4l2_disable_ioctl(s->vdev, VIDIOC_G_TUNER);
-		v4l2_disable_ioctl(s->vdev, VIDIOC_S_STD);
+		v4l2_disable_ioctl(&s->vdev, VIDIOC_S_AUDIO);
+		v4l2_disable_ioctl(&s->vdev, VIDIOC_G_AUDIO);
+		v4l2_disable_ioctl(&s->vdev, VIDIOC_ENUMAUDIO);
+		v4l2_disable_ioctl(&s->vdev, VIDIOC_ENUMINPUT);
+		v4l2_disable_ioctl(&s->vdev, VIDIOC_S_INPUT);
+		v4l2_disable_ioctl(&s->vdev, VIDIOC_G_INPUT);
+		v4l2_disable_ioctl(&s->vdev, VIDIOC_S_FREQUENCY);
+		v4l2_disable_ioctl(&s->vdev, VIDIOC_G_FREQUENCY);
+		v4l2_disable_ioctl(&s->vdev, VIDIOC_S_TUNER);
+		v4l2_disable_ioctl(&s->vdev, VIDIOC_G_TUNER);
+		v4l2_disable_ioctl(&s->vdev, VIDIOC_S_STD);
 	}
-	ivtv_set_funcs(s->vdev);
+	ivtv_set_funcs(&s->vdev);
 	return 0;
 }
 
@@ -266,7 +257,7 @@ int ivtv_streams_setup(struct ivtv *itv)
 		if (ivtv_prep_dev(itv, type))
 			break;
 
-		if (itv->streams[type].vdev == NULL)
+		if (itv->streams[type].vdev.v4l2_dev == NULL)
 			continue;
 
 		/* Allocate Stream */
@@ -277,7 +268,7 @@ int ivtv_streams_setup(struct ivtv *itv)
 		return 0;
 
 	/* One or more streams could not be initialized. Clean 'em all up. */
-	ivtv_streams_cleanup(itv, 0);
+	ivtv_streams_cleanup(itv);
 	return -ENOMEM;
 }
 
@@ -288,28 +279,26 @@ static int ivtv_reg_dev(struct ivtv *itv, int type)
 	const char *name;
 	int num;
 
-	if (s->vdev == NULL)
+	if (s->vdev.v4l2_dev == NULL)
 		return 0;
 
-	num = s->vdev->num;
+	num = s->vdev.num;
 	/* card number + user defined offset + device offset */
 	if (type != IVTV_ENC_STREAM_TYPE_MPG) {
 		struct ivtv_stream *s_mpg = &itv->streams[IVTV_ENC_STREAM_TYPE_MPG];
 
-		if (s_mpg->vdev)
-			num = s_mpg->vdev->num + ivtv_stream_info[type].num_offset;
+		if (s_mpg->vdev.v4l2_dev)
+			num = s_mpg->vdev.num + ivtv_stream_info[type].num_offset;
 	}
-	video_set_drvdata(s->vdev, s);
+	video_set_drvdata(&s->vdev, s);
 
 	/* Register device. First try the desired minor, then any free one. */
-	if (video_register_device_no_warn(s->vdev, vfl_type, num)) {
+	if (video_register_device_no_warn(&s->vdev, vfl_type, num)) {
 		IVTV_ERR("Couldn't register v4l2 device for %s (device node number %d)\n",
 				s->name, num);
-		video_device_release(s->vdev);
-		s->vdev = NULL;
 		return -ENOMEM;
 	}
-	name = video_device_node_name(s->vdev);
+	name = video_device_node_name(&s->vdev);
 
 	switch (vfl_type) {
 	case VFL_TYPE_GRABBER:
@@ -346,29 +335,25 @@ int ivtv_streams_register(struct ivtv *itv)
 		return 0;
 
 	/* One or more streams could not be initialized. Clean 'em all up. */
-	ivtv_streams_cleanup(itv, 1);
+	ivtv_streams_cleanup(itv);
 	return -ENOMEM;
 }
 
 /* Unregister v4l2 devices */
-void ivtv_streams_cleanup(struct ivtv *itv, int unregister)
+void ivtv_streams_cleanup(struct ivtv *itv)
 {
 	int type;
 
 	/* Teardown all streams */
 	for (type = 0; type < IVTV_MAX_STREAMS; type++) {
-		struct video_device *vdev = itv->streams[type].vdev;
+		struct video_device *vdev = &itv->streams[type].vdev;
 
-		itv->streams[type].vdev = NULL;
-		if (vdev == NULL)
+		if (vdev->v4l2_dev == NULL)
 			continue;
 
+		video_unregister_device(vdev);
 		ivtv_stream_free(&itv->streams[type]);
-		/* Unregister or release device */
-		if (unregister)
-			video_unregister_device(vdev);
-		else
-			video_device_release(vdev);
+		itv->streams[type].vdev.v4l2_dev = NULL;
 	}
 }
 
@@ -492,7 +477,7 @@ int ivtv_start_v4l2_encode_stream(struct ivtv_stream *s)
 	int captype = 0, subtype = 0;
 	int enable_passthrough = 0;
 
-	if (s->vdev == NULL)
+	if (s->vdev.v4l2_dev == NULL)
 		return -EINVAL;
 
 	IVTV_DEBUG_INFO("Start encoder stream %s\n", s->name);
@@ -661,7 +646,7 @@ static int ivtv_setup_v4l2_decode_stream(struct ivtv_stream *s)
 	u16 width;
 	u16 height;
 
-	if (s->vdev == NULL)
+	if (s->vdev.v4l2_dev == NULL)
 		return -EINVAL;
 
 	IVTV_DEBUG_INFO("Setting some initial decoder settings\n");
@@ -723,7 +708,7 @@ int ivtv_start_v4l2_decode_stream(struct ivtv_stream *s, int gop_offset)
 	struct ivtv *itv = s->itv;
 	int rc;
 
-	if (s->vdev == NULL)
+	if (s->vdev.v4l2_dev == NULL)
 		return -EINVAL;
 
 	if (test_and_set_bit(IVTV_F_S_STREAMING, &s->s_flags))
@@ -778,7 +763,7 @@ void ivtv_stop_all_captures(struct ivtv *itv)
 	for (i = IVTV_MAX_STREAMS - 1; i >= 0; i--) {
 		struct ivtv_stream *s = &itv->streams[i];
 
-		if (s->vdev == NULL)
+		if (s->vdev.v4l2_dev == NULL)
 			continue;
 		if (test_bit(IVTV_F_S_STREAMING, &s->s_flags)) {
 			ivtv_stop_v4l2_encode_stream(s, 0);
@@ -793,7 +778,7 @@ int ivtv_stop_v4l2_encode_stream(struct ivtv_stream *s, int gop_end)
 	int cap_type;
 	int stopmode;
 
-	if (s->vdev == NULL)
+	if (s->vdev.v4l2_dev == NULL)
 		return -EINVAL;
 
 	/* This function assumes that you are allowed to stop the capture
@@ -917,7 +902,7 @@ int ivtv_stop_v4l2_decode_stream(struct ivtv_stream *s, int flags, u64 pts)
 	};
 	struct ivtv *itv = s->itv;
 
-	if (s->vdev == NULL)
+	if (s->vdev.v4l2_dev == NULL)
 		return -EINVAL;
 
 	if (s->type != IVTV_DEC_STREAM_TYPE_YUV && s->type != IVTV_DEC_STREAM_TYPE_MPG)
@@ -969,7 +954,7 @@ int ivtv_stop_v4l2_decode_stream(struct ivtv_stream *s, int flags, u64 pts)
 
 	set_bit(IVTV_F_I_EV_DEC_STOPPED, &itv->i_flags);
 	wake_up(&itv->event_waitq);
-	v4l2_event_queue(s->vdev, &ev);
+	v4l2_event_queue(&s->vdev, &ev);
 
 	/* wake up wait queues */
 	wake_up(&s->waitq);
@@ -982,7 +967,7 @@ int ivtv_passthrough_mode(struct ivtv *itv, int enable)
 	struct ivtv_stream *yuv_stream = &itv->streams[IVTV_ENC_STREAM_TYPE_YUV];
 	struct ivtv_stream *dec_stream = &itv->streams[IVTV_DEC_STREAM_TYPE_YUV];
 
-	if (yuv_stream->vdev == NULL || dec_stream->vdev == NULL)
+	if (yuv_stream->vdev.v4l2_dev == NULL || dec_stream->vdev.v4l2_dev == NULL)
 		return -EINVAL;
 
 	IVTV_DEBUG_INFO("ivtv ioctl: Select passthrough mode\n");
diff --git a/drivers/media/pci/ivtv/ivtv-streams.h b/drivers/media/pci/ivtv/ivtv-streams.h
index a653a51..3d76a41 100644
--- a/drivers/media/pci/ivtv/ivtv-streams.h
+++ b/drivers/media/pci/ivtv/ivtv-streams.h
@@ -23,7 +23,7 @@
 
 int ivtv_streams_setup(struct ivtv *itv);
 int ivtv_streams_register(struct ivtv *itv);
-void ivtv_streams_cleanup(struct ivtv *itv, int unregister);
+void ivtv_streams_cleanup(struct ivtv *itv);
 
 /* Capture related */
 int ivtv_start_v4l2_encode_stream(struct ivtv_stream *s);
-- 
2.1.4

