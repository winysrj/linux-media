Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1146 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3CROM6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 10:12:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andy Walls <awalls@md.metrocast.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Mike Isely <isely@pobox.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Huang Shijie <shijie8@gmail.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Takashi Iwai <tiwai@suse.de>,
	Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 1/6] v4l2: add const to argument of write-only s_frequency ioctl.
Date: Mon, 18 Mar 2013 15:12:00 +0100
Message-Id: <1363615925-19507-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363615925-19507-1-git-send-email-hverkuil@xs4all.nl>
References: <1363615925-19507-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This ioctl is defined as IOW, so pass the argument as const.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/cx25840/cx25840-core.c         |    2 +-
 drivers/media/i2c/msp3400-driver.c               |    2 +-
 drivers/media/i2c/tvaudio.c                      |    2 +-
 drivers/media/i2c/upd64031a.c                    |    2 +-
 drivers/media/i2c/wm8775.c                       |    2 +-
 drivers/media/pci/bt8xx/bttv-driver.c            |   14 ++++---
 drivers/media/pci/cx18/cx18-av-core.c            |    2 +-
 drivers/media/pci/cx18/cx18-ioctl.c              |    2 +-
 drivers/media/pci/cx18/cx18-ioctl.h              |    2 +-
 drivers/media/pci/cx23885/cx23885-417.c          |    2 +-
 drivers/media/pci/cx23885/cx23885-video.c        |    8 ++--
 drivers/media/pci/cx23885/cx23885.h              |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c        |    4 +-
 drivers/media/pci/cx25821/cx25821-video.h        |    4 +-
 drivers/media/pci/cx88/cx88-blackbird.c          |    2 +-
 drivers/media/pci/cx88/cx88-video.c              |   10 +++--
 drivers/media/pci/cx88/cx88.h                    |    2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c              |    2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.h              |    2 +-
 drivers/media/pci/saa7134/saa7134-video.c        |    2 +-
 drivers/media/pci/saa7146/mxb.c                  |    4 +-
 drivers/media/pci/saa7164/saa7164-encoder.c      |    2 +-
 drivers/media/pci/saa7164/saa7164-vbi.c          |    2 +-
 drivers/media/pci/ttpci/av7110_v4l.c             |    2 +-
 drivers/media/radio/dsbr100.c                    |    2 +-
 drivers/media/radio/radio-cadet.c                |   46 +++++++++++-----------
 drivers/media/radio/radio-isa.c                  |    9 +++--
 drivers/media/radio/radio-keene.c                |   13 +++---
 drivers/media/radio/radio-ma901.c                |    2 +-
 drivers/media/radio/radio-miropcm20.c            |    4 +-
 drivers/media/radio/radio-mr800.c                |    2 +-
 drivers/media/radio/radio-sf16fmi.c              |    2 +-
 drivers/media/radio/radio-si4713.c               |    2 +-
 drivers/media/radio/radio-tea5764.c              |    2 +-
 drivers/media/radio/radio-tea5777.c              |    2 +-
 drivers/media/radio/radio-timb.c                 |    2 +-
 drivers/media/radio/radio-wl1273.c               |    2 +-
 drivers/media/radio/si470x/radio-si470x-common.c |    2 +-
 drivers/media/radio/si4713-i2c.c                 |    5 +--
 drivers/media/radio/tef6862.c                    |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c          |    6 +--
 drivers/media/usb/au0828/au0828-video.c          |    2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c        |    7 ++--
 drivers/media/usb/cx231xx/cx231xx.h              |    2 +-
 drivers/media/usb/em28xx/em28xx-video.c          |    7 ++--
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c         |    2 +-
 drivers/media/usb/tlg2300/pd-radio.c             |    2 +-
 drivers/media/usb/tlg2300/pd-video.c             |    5 ++-
 drivers/media/usb/tm6000/tm6000-video.c          |    2 +-
 drivers/media/usb/usbvision/usbvision-video.c    |    2 +-
 drivers/media/v4l2-core/tuner-core.c             |    2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c             |    2 +-
 drivers/staging/media/go7007/go7007-v4l2.c       |    2 +-
 include/media/v4l2-ioctl.h                       |    2 +-
 include/media/v4l2-subdev.h                      |    2 +-
 sound/i2c/other/tea575x-tuner.c                  |    4 +-
 56 files changed, 119 insertions(+), 111 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index f4149eb..f4339ed 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -1835,7 +1835,7 @@ static int cx25840_s_audio_routing(struct v4l2_subdev *sd,
 	return set_input(client, state->vid_input, input);
 }
 
-static int cx25840_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *freq)
+static int cx25840_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequency *freq)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index 766305f..77053ba 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -445,7 +445,7 @@ static int msp_s_radio(struct v4l2_subdev *sd)
 	return 0;
 }
 
-static int msp_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *freq)
+static int msp_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequency *freq)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index 4c91b35..4b12c51 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -1817,7 +1817,7 @@ static int tvaudio_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	return 0;
 }
 
-static int tvaudio_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *freq)
+static int tvaudio_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequency *freq)
 {
 	struct CHIPSTATE *chip = to_state(sd);
 	struct CHIPDESC *desc = chip->desc;
diff --git a/drivers/media/i2c/upd64031a.c b/drivers/media/i2c/upd64031a.c
index 1e74465..d15cfd9 100644
--- a/drivers/media/i2c/upd64031a.c
+++ b/drivers/media/i2c/upd64031a.c
@@ -111,7 +111,7 @@ static void upd64031a_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 /* ------------------------------------------------------------------------ */
 
 /* The input changed due to new input or channel changed */
-static int upd64031a_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *freq)
+static int upd64031a_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequency *freq)
 {
 	struct upd64031a_state *state = to_state(sd);
 	u8 reg = state->regs[R00];
diff --git a/drivers/media/i2c/wm8775.c b/drivers/media/i2c/wm8775.c
index bee77ea..27c27b4 100644
--- a/drivers/media/i2c/wm8775.c
+++ b/drivers/media/i2c/wm8775.c
@@ -174,7 +174,7 @@ static int wm8775_log_status(struct v4l2_subdev *sd)
 	return 0;
 }
 
-static int wm8775_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *freq)
+static int wm8775_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequency *freq)
 {
 	wm8775_set_audio(sd, 0);
 	return 0;
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 8610b6a..7816edc 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1850,24 +1850,26 @@ static int bttv_g_frequency(struct file *file, void *priv,
 	return 0;
 }
 
-static void bttv_set_frequency(struct bttv *btv, struct v4l2_frequency *f)
+static void bttv_set_frequency(struct bttv *btv, const struct v4l2_frequency *f)
 {
+	struct v4l2_frequency new_freq = *f;
+
 	bttv_call_all(btv, tuner, s_frequency, f);
 	/* s_frequency may clamp the frequency, so get the actual
 	   frequency before assigning radio/tv_freq. */
-	bttv_call_all(btv, tuner, g_frequency, f);
-	if (f->type == V4L2_TUNER_RADIO) {
+	bttv_call_all(btv, tuner, g_frequency, &new_freq);
+	if (new_freq.type == V4L2_TUNER_RADIO) {
 		radio_enable(btv);
-		btv->radio_freq = f->frequency;
+		btv->radio_freq = new_freq.frequency;
 		if (btv->has_matchbox)
 			tea5757_set_freq(btv, btv->radio_freq);
 	} else {
-		btv->tv_freq = f->frequency;
+		btv->tv_freq = new_freq.frequency;
 	}
 }
 
 static int bttv_s_frequency(struct file *file, void *priv,
-					struct v4l2_frequency *f)
+					const struct v4l2_frequency *f)
 {
 	struct bttv_fh *fh  = priv;
 	struct bttv *btv = fh->btv;
diff --git a/drivers/media/pci/cx18/cx18-av-core.c b/drivers/media/pci/cx18/cx18-av-core.c
index f164b7f..a2c51e0 100644
--- a/drivers/media/pci/cx18/cx18-av-core.c
+++ b/drivers/media/pci/cx18/cx18-av-core.c
@@ -576,7 +576,7 @@ static void input_change(struct cx18 *cx)
 }
 
 static int cx18_av_s_frequency(struct v4l2_subdev *sd,
-			       struct v4l2_frequency *freq)
+			       const struct v4l2_frequency *freq)
 {
 	struct cx18 *cx = v4l2_get_subdevdata(sd);
 	input_change(cx);
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index cd8d2c2..5cd22e7 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -614,7 +614,7 @@ static int cx18_g_frequency(struct file *file, void *fh,
 	return 0;
 }
 
-int cx18_s_frequency(struct file *file, void *fh, struct v4l2_frequency *vf)
+int cx18_s_frequency(struct file *file, void *fh, const struct v4l2_frequency *vf)
 {
 	struct cx18_open_id *id = fh2id(fh);
 	struct cx18 *cx = id->cx;
diff --git a/drivers/media/pci/cx18/cx18-ioctl.h b/drivers/media/pci/cx18/cx18-ioctl.h
index 2f9dd59..aa9b44a 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.h
+++ b/drivers/media/pci/cx18/cx18-ioctl.h
@@ -27,5 +27,5 @@ void cx18_expand_service_set(struct v4l2_sliced_vbi_format *fmt, int is_pal);
 u16 cx18_get_service_set(struct v4l2_sliced_vbi_format *fmt);
 void cx18_set_funcs(struct video_device *vdev);
 int cx18_s_std(struct file *file, void *fh, v4l2_std_id *std);
-int cx18_s_frequency(struct file *file, void *fh, struct v4l2_frequency *vf);
+int cx18_s_frequency(struct file *file, void *fh, const struct v4l2_frequency *vf);
 int cx18_s_input(struct file *file, void *fh, unsigned int inp);
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 5d5052d..84a1b75 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1311,7 +1311,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-	struct v4l2_frequency *f)
+	const struct v4l2_frequency *f)
 {
 	return cx23885_set_frequency(file, priv, f);
 }
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 5991bc8..5ba15b8 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1518,7 +1518,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	return 0;
 }
 
-static int cx23885_set_freq(struct cx23885_dev *dev, struct v4l2_frequency *f)
+static int cx23885_set_freq(struct cx23885_dev *dev, const struct v4l2_frequency *f)
 {
 	struct v4l2_control ctrl;
 
@@ -1550,7 +1550,7 @@ static int cx23885_set_freq(struct cx23885_dev *dev, struct v4l2_frequency *f)
 }
 
 static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
-	struct v4l2_frequency *f)
+	const struct v4l2_frequency *f)
 {
 	struct v4l2_control ctrl;
 	struct videobuf_dvb_frontend *vfe;
@@ -1608,7 +1608,7 @@ static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
 }
 
 int cx23885_set_frequency(struct file *file, void *priv,
-	struct v4l2_frequency *f)
+	const struct v4l2_frequency *f)
 {
 	struct cx23885_fh *fh = priv;
 	struct cx23885_dev *dev = fh->dev;
@@ -1628,7 +1628,7 @@ int cx23885_set_frequency(struct file *file, void *priv,
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-	struct v4l2_frequency *f)
+	const struct v4l2_frequency *f)
 {
 	return cx23885_set_frequency(file, priv, f);
 }
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 59c322d..5687d3f 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -587,7 +587,7 @@ extern void cx23885_video_wakeup(struct cx23885_dev *dev,
 int cx23885_enum_input(struct cx23885_dev *dev, struct v4l2_input *i);
 int cx23885_set_input(struct file *file, void *priv, unsigned int i);
 int cx23885_get_input(struct file *file, void *priv, unsigned int *i);
-int cx23885_set_frequency(struct file *file, void *priv, struct v4l2_frequency *f);
+int cx23885_set_frequency(struct file *file, void *priv, const struct v4l2_frequency *f);
 int cx23885_set_control(struct cx23885_dev *dev, struct v4l2_control *ctl);
 int cx23885_get_control(struct cx23885_dev *dev, struct v4l2_control *ctl);
 int cx23885_set_tvnorm(struct cx23885_dev *dev, v4l2_std_id norm);
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index d4de021..1219d60 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -1312,7 +1312,7 @@ int cx25821_vidioc_g_frequency(struct file *file, void *priv,
 	return 0;
 }
 
-int cx25821_set_freq(struct cx25821_dev *dev, struct v4l2_frequency *f)
+int cx25821_set_freq(struct cx25821_dev *dev, const struct v4l2_frequency *f)
 {
 	mutex_lock(&dev->lock);
 	dev->freq = f->frequency;
@@ -1328,7 +1328,7 @@ int cx25821_set_freq(struct cx25821_dev *dev, struct v4l2_frequency *f)
 }
 
 int cx25821_vidioc_s_frequency(struct file *file, void *priv,
-			       struct v4l2_frequency *f)
+			       const struct v4l2_frequency *f)
 {
 	struct cx25821_fh *fh = priv;
 	struct cx25821_dev *dev;
diff --git a/drivers/media/pci/cx25821/cx25821-video.h b/drivers/media/pci/cx25821/cx25821-video.h
index c265e35..969340c 100644
--- a/drivers/media/pci/cx25821/cx25821-video.h
+++ b/drivers/media/pci/cx25821/cx25821-video.h
@@ -149,9 +149,9 @@ extern int cx25821_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f);
 extern int cx25821_vidioc_g_frequency(struct file *file, void *priv,
 				      struct v4l2_frequency *f);
-extern int cx25821_set_freq(struct cx25821_dev *dev, struct v4l2_frequency *f);
+extern int cx25821_set_freq(struct cx25821_dev *dev, const struct v4l2_frequency *f);
 extern int cx25821_vidioc_s_frequency(struct file *file, void *priv,
-				      struct v4l2_frequency *f);
+				      const struct v4l2_frequency *f);
 extern int cx25821_vidioc_g_register(struct file *file, void *fh,
 				     struct v4l2_dbg_register *reg);
 extern int cx25821_vidioc_s_register(struct file *file, void *fh,
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index a6ff8a6..82aa11f 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -815,7 +815,7 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 }
 
 static int vidioc_s_frequency (struct file *file, void *priv,
-				struct v4l2_frequency *f)
+				const struct v4l2_frequency *f)
 {
 	struct cx8802_fh  *fh   = priv;
 	struct cx8802_dev *dev  = fh->dev;
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index bc78354..4f10875 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1321,8 +1321,10 @@ static int vidioc_g_frequency (struct file *file, void *priv,
 }
 
 int cx88_set_freq (struct cx88_core  *core,
-				struct v4l2_frequency *f)
+				const struct v4l2_frequency *f)
 {
+	struct v4l2_frequency new_freq = *f;
+
 	if (unlikely(UNSET == core->board.tuner_type))
 		return -EINVAL;
 	if (unlikely(f->tuner != 0))
@@ -1331,8 +1333,8 @@ int cx88_set_freq (struct cx88_core  *core,
 	mutex_lock(&core->lock);
 	cx88_newstation(core);
 	call_all(core, tuner, s_frequency, f);
-	call_all(core, tuner, g_frequency, f);
-	core->freq = f->frequency;
+	call_all(core, tuner, g_frequency, &new_freq);
+	core->freq = new_freq.frequency;
 
 	/* When changing channels it is required to reset TVAUDIO */
 	msleep (10);
@@ -1345,7 +1347,7 @@ int cx88_set_freq (struct cx88_core  *core,
 EXPORT_SYMBOL(cx88_set_freq);
 
 static int vidioc_s_frequency (struct file *file, void *priv,
-				struct v4l2_frequency *f)
+				const struct v4l2_frequency *f)
 {
 	struct cx8800_fh  *fh   = priv;
 	struct cx88_core  *core = fh->dev->core;
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index feff53c..eca02c2 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -740,7 +740,7 @@ void cx8802_cancel_buffers(struct cx8802_dev *dev);
 /* ----------------------------------------------------------- */
 /* cx88-video.c*/
 int cx88_enum_input (struct cx88_core  *core,struct v4l2_input *i);
-int cx88_set_freq (struct cx88_core  *core,struct v4l2_frequency *f);
+int cx88_set_freq(struct cx88_core  *core, const struct v4l2_frequency *f);
 int cx88_video_mux(struct cx88_core *core, unsigned int input);
 void cx88_querycap(struct file *file, struct cx88_core *core,
 		struct v4l2_capability *cap);
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 7a8b0d0..e6258b6 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -1078,7 +1078,7 @@ static int ivtv_g_frequency(struct file *file, void *fh, struct v4l2_frequency *
 	return 0;
 }
 
-int ivtv_s_frequency(struct file *file, void *fh, struct v4l2_frequency *vf)
+int ivtv_s_frequency(struct file *file, void *fh, const struct v4l2_frequency *vf)
 {
 	struct ivtv *itv = fh2id(fh)->itv;
 	struct ivtv_stream *s = &itv->streams[fh2id(fh)->type];
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.h b/drivers/media/pci/ivtv/ivtv-ioctl.h
index 7c553d1..34c6bc1 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.h
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.h
@@ -29,7 +29,7 @@ int ivtv_set_speed(struct ivtv *itv, int speed);
 void ivtv_set_funcs(struct video_device *vdev);
 void ivtv_s_std_enc(struct ivtv *itv, v4l2_std_id *std);
 void ivtv_s_std_dec(struct ivtv *itv, v4l2_std_id *std);
-int ivtv_s_frequency(struct file *file, void *fh, struct v4l2_frequency *vf);
+int ivtv_s_frequency(struct file *file, void *fh, const struct v4l2_frequency *vf);
 int ivtv_s_input(struct file *file, void *fh, unsigned int inp);
 
 #endif
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 7c503fb..6c619d1 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2057,7 +2057,7 @@ static int saa7134_g_frequency(struct file *file, void *priv,
 }
 
 static int saa7134_s_frequency(struct file *file, void *priv,
-					struct v4l2_frequency *f)
+					const struct v4l2_frequency *f)
 {
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 91369da..27dc49b 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -595,7 +595,7 @@ static int vidioc_g_frequency(struct file *file, void *fh, struct v4l2_frequency
 	return 0;
 }
 
-static int vidioc_s_frequency(struct file *file, void *fh, struct v4l2_frequency *f)
+static int vidioc_s_frequency(struct file *file, void *fh, const struct v4l2_frequency *f)
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 	struct mxb *mxb = (struct mxb *)dev->ext_priv;
@@ -612,8 +612,8 @@ static int vidioc_s_frequency(struct file *file, void *fh, struct v4l2_frequency
 	/* tune in desired frequency */
 	tuner_call(mxb, tuner, s_frequency, f);
 	/* let the tuner subdev clamp the frequency to the tuner range */
-	tuner_call(mxb, tuner, g_frequency, f);
 	mxb->cur_freq = *f;
+	tuner_call(mxb, tuner, g_frequency, &mxb->cur_freq);
 	if (mxb->cur_audinput == 0)
 		mxb_update_audmode(mxb);
 
diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 9bb0903..34f700d 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -337,7 +337,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-	struct v4l2_frequency *f)
+	const struct v4l2_frequency *f)
 {
 	struct saa7164_encoder_fh *fh = file->private_data;
 	struct saa7164_port *port = fh->port;
diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index b453229..5a8a6ad 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -309,7 +309,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-	struct v4l2_frequency *f)
+	const struct v4l2_frequency *f)
 {
 	struct saa7164_vbi_fh *fh = file->private_data;
 	struct saa7164_port *port = fh->port;
diff --git a/drivers/media/pci/ttpci/av7110_v4l.c b/drivers/media/pci/ttpci/av7110_v4l.c
index 730e906..65adaa7 100644
--- a/drivers/media/pci/ttpci/av7110_v4l.c
+++ b/drivers/media/pci/ttpci/av7110_v4l.c
@@ -426,7 +426,7 @@ static int vidioc_g_frequency(struct file *file, void *fh, struct v4l2_frequency
 	return 0;
 }
 
-static int vidioc_s_frequency(struct file *file, void *fh, struct v4l2_frequency *f)
+static int vidioc_s_frequency(struct file *file, void *fh, const struct v4l2_frequency *f)
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 	struct av7110 *av7110 = (struct av7110 *)dev->ext_priv;
diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index 63b112b..e140a72 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -214,7 +214,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+				const struct v4l2_frequency *f)
 {
 	struct dsbr100_device *radio = video_drvdata(file);
 
diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index 643d80a..59be293 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -90,6 +90,26 @@ static u16 sigtable[2][4] = {
 	{ 2185, 4369, 13107, 65535 },
 };
 
+static const struct v4l2_frequency_band bands[] = {
+	{
+		.index = 0,
+		.type = V4L2_TUNER_RADIO,
+		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow = 8320,      /* 520 kHz */
+		.rangehigh = 26400,    /* 1650 kHz */
+		.modulation = V4L2_BAND_MODULATION_AM,
+	}, {
+		.index = 1,
+		.type = V4L2_TUNER_RADIO,
+		.capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS |
+			V4L2_TUNER_CAP_RDS_BLOCK_IO | V4L2_TUNER_CAP_LOW |
+			V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow = 1400000,   /* 87.5 MHz */
+		.rangehigh = 1728000,  /* 108.0 MHz */
+		.modulation = V4L2_BAND_MODULATION_FM,
+	},
+};
+
 
 static int cadet_getstereo(struct cadet *dev)
 {
@@ -196,6 +216,8 @@ static void cadet_setfreq(struct cadet *dev, unsigned freq)
 	int i, j, test;
 	int curvol;
 
+	freq = clamp(freq, bands[dev->is_fm_band].rangelow,
+			   bands[dev->is_fm_band].rangehigh);
 	dev->curfreq = freq;
 	/*
 	 * Formulate a fifo command
@@ -337,26 +359,6 @@ static int vidioc_querycap(struct file *file, void *priv,
 	return 0;
 }
 
-static const struct v4l2_frequency_band bands[] = {
-	{
-		.index = 0,
-		.type = V4L2_TUNER_RADIO,
-		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS,
-		.rangelow = 8320,      /* 520 kHz */
-		.rangehigh = 26400,    /* 1650 kHz */
-		.modulation = V4L2_BAND_MODULATION_AM,
-	}, {
-		.index = 1,
-		.type = V4L2_TUNER_RADIO,
-		.capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS |
-			V4L2_TUNER_CAP_RDS_BLOCK_IO | V4L2_TUNER_CAP_LOW |
-			V4L2_TUNER_CAP_FREQ_BANDS,
-		.rangelow = 1400000,   /* 87.5 MHz */
-		.rangehigh = 1728000,  /* 108.0 MHz */
-		.modulation = V4L2_BAND_MODULATION_FM,
-	},
-};
-
 static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *v)
 {
@@ -418,7 +420,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+				const struct v4l2_frequency *f)
 {
 	struct cadet *dev = video_drvdata(file);
 
@@ -426,8 +428,6 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 		return -EINVAL;
 	dev->is_fm_band =
 		f->frequency >= (bands[0].rangehigh + bands[1].rangelow) / 2;
-	clamp(f->frequency, bands[dev->is_fm_band].rangelow,
-			    bands[dev->is_fm_band].rangehigh);
 	cadet_setfreq(dev, f->frequency);
 	return 0;
 }
diff --git a/drivers/media/radio/radio-isa.c b/drivers/media/radio/radio-isa.c
index fe0a4f8..0c1e27b 100644
--- a/drivers/media/radio/radio-isa.c
+++ b/drivers/media/radio/radio-isa.c
@@ -102,17 +102,18 @@ static int radio_isa_s_tuner(struct file *file, void *priv,
 }
 
 static int radio_isa_s_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+				const struct v4l2_frequency *f)
 {
 	struct radio_isa_card *isa = video_drvdata(file);
+	u32 freq = f->frequency;
 	int res;
 
 	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
 		return -EINVAL;
-	f->frequency = clamp(f->frequency, FREQ_LOW, FREQ_HIGH);
-	res = isa->drv->ops->s_frequency(isa, f->frequency);
+	freq = clamp(freq, FREQ_LOW, FREQ_HIGH);
+	res = isa->drv->ops->s_frequency(isa, freq);
 	if (res == 0)
-		isa->freq = f->frequency;
+		isa->freq = freq;
 	return res;
 }
 
diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
index 296941a..a598852 100644
--- a/drivers/media/radio/radio-keene.c
+++ b/drivers/media/radio/radio-keene.c
@@ -82,9 +82,12 @@ static inline struct keene_device *to_keene_dev(struct v4l2_device *v4l2_dev)
 /* Set frequency (if non-0), PA, mute and turn on/off the FM transmitter. */
 static int keene_cmd_main(struct keene_device *radio, unsigned freq, bool play)
 {
-	unsigned short freq_send = freq ? (freq - 76 * 16000) / 800 : 0;
+	unsigned short freq_send;
 	int ret;
 
+	if (freq)
+		freq = clamp(freq, FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);
+	freq_send = freq ? (freq - 76 * 16000) / 800 : 0;
 	radio->buffer[0] = 0x00;
 	radio->buffer[1] = 0x50;
 	radio->buffer[2] = (freq_send >> 8) & 0xff;
@@ -215,15 +218,15 @@ static int vidioc_s_modulator(struct file *file, void *priv,
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+				const struct v4l2_frequency *f)
 {
 	struct keene_device *radio = video_drvdata(file);
 
 	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
 		return -EINVAL;
-	f->frequency = clamp(f->frequency,
-			FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);
-	return keene_cmd_main(radio, f->frequency, true);
+	/* Take care: keene_cmd_main handles a frequency of 0 as a
+	 * special case, so make sure we never give that from here. */
+	return keene_cmd_main(radio, f->frequency ? f->frequency : 1, true);
 }
 
 static int vidioc_g_frequency(struct file *file, void *priv,
diff --git a/drivers/media/radio/radio-ma901.c b/drivers/media/radio/radio-ma901.c
index c61f590..7f85c6f 100644
--- a/drivers/media/radio/radio-ma901.c
+++ b/drivers/media/radio/radio-ma901.c
@@ -257,7 +257,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 
 /* vidioc_s_frequency - set tuner radio frequency */
 static int vidioc_s_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+				const struct v4l2_frequency *f)
 {
 	struct ma901radio_device *radio = video_drvdata(file);
 
diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
index 3d0ff44..2b8d31d 100644
--- a/drivers/media/radio/radio-miropcm20.c
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -131,14 +131,14 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+				const struct v4l2_frequency *f)
 {
 	struct pcm20 *dev = video_drvdata(file);
 
 	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
 		return -EINVAL;
 
-	dev->freq = clamp(f->frequency, 87 * 16000U, 108 * 16000U);
+	dev->freq = clamp_t(u32, f->frequency, 87 * 16000U, 108 * 16000U);
 	pcm20_setfreq(dev, dev->freq);
 	return 0;
 }
diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 9c5a267..f9cdd8b 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -323,7 +323,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 
 /* vidioc_s_frequency - set tuner radio frequency */
 static int vidioc_s_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+				const struct v4l2_frequency *f)
 {
 	struct amradio_device *radio = video_drvdata(file);
 
diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index 637a555..6142b5b 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -151,7 +151,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-					struct v4l2_frequency *f)
+					const struct v4l2_frequency *f)
 {
 	struct fmi *fmi = video_drvdata(file);
 
diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 1507c9d..c1a0879 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -214,7 +214,7 @@ static int radio_si4713_g_frequency(struct file *file, void *p,
 }
 
 static int radio_si4713_s_frequency(struct file *file, void *p,
-						struct v4l2_frequency *vf)
+						const struct v4l2_frequency *vf)
 {
 	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, tuner,
 							s_frequency, vf);
diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 1978516..8938428 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -351,7 +351,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+				const struct v4l2_frequency *f)
 {
 	struct tea5764_device *radio = video_drvdata(file);
 
diff --git a/drivers/media/radio/radio-tea5777.c b/drivers/media/radio/radio-tea5777.c
index 4b5190d..fcd7c19 100644
--- a/drivers/media/radio/radio-tea5777.c
+++ b/drivers/media/radio/radio-tea5777.c
@@ -368,7 +368,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-					struct v4l2_frequency *f)
+					const struct v4l2_frequency *f)
 {
 	struct radio_tea5777 *tea = video_drvdata(file);
 
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index b87effe..1712c05 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -91,7 +91,7 @@ static int timbradio_vidioc_s_audio(struct file *file, void *priv,
 }
 
 static int timbradio_vidioc_s_frequency(struct file *file, void *priv,
-	struct v4l2_frequency *f)
+	const struct v4l2_frequency *f)
 {
 	struct timbradio *tr = video_drvdata(file);
 	return v4l2_subdev_call(tr->sd_tuner, tuner, s_frequency, f);
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 02151e0..9a02fee 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1640,7 +1640,7 @@ static int wl1273_fm_vidioc_g_frequency(struct file *file, void *priv,
 }
 
 static int wl1273_fm_vidioc_s_frequency(struct file *file, void *priv,
-					struct v4l2_frequency *freq)
+					const struct v4l2_frequency *freq)
 {
 	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
 	struct wl1273_core *core = radio->core;
diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 1898938..5708633 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -678,7 +678,7 @@ static int si470x_vidioc_g_frequency(struct file *file, void *priv,
  * si470x_vidioc_s_frequency - set tuner or modulator radio frequency
  */
 static int si470x_vidioc_s_frequency(struct file *file, void *priv,
-		struct v4l2_frequency *freq)
+		const struct v4l2_frequency *freq)
 {
 	struct si470x_device *radio = video_drvdata(file);
 	int retval;
diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
index bd61b3b..e305c14 100644
--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -1212,7 +1212,7 @@ exit:
 	return rval;
 }
 
-static int si4713_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f);
+static int si4713_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequency *f);
 static int si4713_s_modulator(struct v4l2_subdev *sd, const struct v4l2_modulator *);
 /*
  * si4713_setup - Sets the device up with current configuration.
@@ -1950,7 +1950,7 @@ unlock:
 }
 
 /* si4713_s_frequency - set tuner or modulator radio frequency */
-static int si4713_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
+static int si4713_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequency *f)
 {
 	struct si4713_device *sdev = to_si4713_device(sd);
 	int rval = 0;
@@ -1970,7 +1970,6 @@ static int si4713_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 		rval = 0;
 	}
 	sdev->frequency = frequency;
-	f->frequency = si4713_to_v4l2(frequency);
 
 unlock:
 	mutex_unlock(&sdev->mutex);
diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
index b18c2dc..8673955 100644
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -101,7 +101,7 @@ static int tef6862_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
 	return v->index ? -EINVAL : 0;
 }
 
-static int tef6862_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
+static int tef6862_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequency *f)
 {
 	struct tef6862_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 0a8ee8f..0183956 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -388,7 +388,7 @@ static int fm_v4l2_vidioc_g_freq(struct file *file, void *priv,
 
 /* Set tuner or modulator radio frequency */
 static int fm_v4l2_vidioc_s_freq(struct file *file, void *priv,
-		struct v4l2_frequency *freq)
+		const struct v4l2_frequency *freq)
 {
 	struct fmdev *fmdev = video_drvdata(file);
 
@@ -396,9 +396,7 @@ static int fm_v4l2_vidioc_s_freq(struct file *file, void *priv,
 	 * As V4L2_TUNER_CAP_LOW is set 1 user sends the frequency
 	 * in units of 62.5 Hz.
 	 */
-	freq->frequency = (u32)(freq->frequency / 16);
-
-	return fmc_set_freq(fmdev, freq->frequency);
+	return fmc_set_freq(fmdev, freq->frequency / 16);
 }
 
 /* Set hardware frequency seek. If current mode is NOT RX, set it RX. */
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 8b9e826..b1d6b03 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1545,7 +1545,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *freq)
+				const struct v4l2_frequency *freq)
 {
 	struct au0828_fh *fh = priv;
 	struct au0828_dev *dev = fh->dev;
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index ac62008..96f6531 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1172,10 +1172,11 @@ int cx231xx_g_frequency(struct file *file, void *priv,
 }
 
 int cx231xx_s_frequency(struct file *file, void *priv,
-			      struct v4l2_frequency *f)
+			      const struct v4l2_frequency *f)
 {
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
+	struct v4l2_frequency new_freq = *f;
 	int rc;
 	u32 if_frequency = 5400000;
 
@@ -1194,8 +1195,8 @@ int cx231xx_s_frequency(struct file *file, void *priv,
 	rc = cx231xx_tuner_pre_channel_change(dev);
 
 	call_all(dev, tuner, s_frequency, f);
-	call_all(dev, tuner, g_frequency, f);
-	dev->ctl_freq = f->frequency;
+	call_all(dev, tuner, g_frequency, &new_freq);
+	dev->ctl_freq = new_freq.frequency;
 
 	/* set post channel change settings in DIF first */
 	rc = cx231xx_tuner_post_channel_change(dev);
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index a8e50d2..0a6071b 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -939,7 +939,7 @@ int cx231xx_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t);
 int cx231xx_g_frequency(struct file *file, void *priv,
 			      struct v4l2_frequency *f);
 int cx231xx_s_frequency(struct file *file, void *priv,
-			      struct v4l2_frequency *f);
+			      const struct v4l2_frequency *f);
 int cx231xx_enum_input(struct file *file, void *priv,
 			     struct v4l2_input *i);
 int cx231xx_g_input(struct file *file, void *priv, unsigned int *i);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 93fc620..42173d9 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1219,8 +1219,9 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+				const struct v4l2_frequency *f)
 {
+	struct v4l2_frequency new_freq = *f;
 	struct em28xx_fh      *fh  = priv;
 	struct em28xx         *dev = fh->dev;
 
@@ -1228,8 +1229,8 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 		return -EINVAL;
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, f);
-	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_frequency, f);
-	dev->ctl_freq = f->frequency;
+	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_frequency, &new_freq);
+	dev->ctl_freq = new_freq.frequency;
 
 	return 0;
 }
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 34c3b6e..75657c6 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -365,7 +365,7 @@ static int pvr2_s_tuner(struct file *file, void *priv, struct v4l2_tuner *vt)
 			vt->audmode);
 }
 
-static int pvr2_s_frequency(struct file *file, void *priv, struct v4l2_frequency *vf)
+static int pvr2_s_frequency(struct file *file, void *priv, const struct v4l2_frequency *vf)
 {
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
index 0f958f7..8b1daf1 100644
--- a/drivers/media/usb/tlg2300/pd-radio.c
+++ b/drivers/media/usb/tlg2300/pd-radio.c
@@ -252,7 +252,7 @@ error:
 }
 
 static int fm_set_freq(struct file *file, void *priv,
-		       struct v4l2_frequency *argp)
+		       const struct v4l2_frequency *argp)
 {
 	struct poseidon *p = video_drvdata(file);
 
diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
index dab0ca3..8ef7c8c 100644
--- a/drivers/media/usb/tlg2300/pd-video.c
+++ b/drivers/media/usb/tlg2300/pd-video.c
@@ -1079,10 +1079,11 @@ static int set_frequency(struct poseidon *pd, u32 *frequency)
 }
 
 static int vidioc_s_frequency(struct file *file, void *fh,
-				struct v4l2_frequency *freq)
+				const struct v4l2_frequency *freq)
 {
 	struct front_face *front = fh;
 	struct poseidon *pd = front->pd;
+	u32 frequency = freq->frequency;
 
 	if (freq->tuner)
 		return -EINVAL;
@@ -1090,7 +1091,7 @@ static int vidioc_s_frequency(struct file *file, void *fh,
 	pd->pm_suspend = pm_video_suspend;
 	pd->pm_resume = pm_video_resume;
 #endif
-	return set_frequency(pd, &freq->frequency);
+	return set_frequency(pd, &frequency);
 }
 
 static int vidioc_reqbufs(struct file *file, void *fh,
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 1a68579..49df753 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1255,7 +1255,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+				const struct v4l2_frequency *f)
 {
 	struct tm6000_fh   *fh  = priv;
 	struct tm6000_core *dev = fh->dev;
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index cd1fe78..b668445 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -657,7 +657,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *freq)
+				const struct v4l2_frequency *freq)
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
 
diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index b5a8aac..279f65e 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -1134,7 +1134,7 @@ static int tuner_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	return 0;
 }
 
-static int tuner_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
+static int tuner_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequency *f)
 {
 	struct tuner *t = to_tuner(sd);
 
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index aa6e7c7..8ec8abe 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1316,7 +1316,7 @@ static int v4l_s_frequency(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct video_device *vfd = video_devdata(file);
-	struct v4l2_frequency *p = arg;
+	const struct v4l2_frequency *p = arg;
 	enum v4l2_tuner_type type;
 
 	type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index cb9fe33..1288f1c 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -1281,7 +1281,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+				const struct v4l2_frequency *f)
 {
 	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 4118ad1..f06436d 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -223,7 +223,7 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_g_frequency)      (struct file *file, void *fh,
 					struct v4l2_frequency *a);
 	int (*vidioc_s_frequency)      (struct file *file, void *fh,
-					struct v4l2_frequency *a);
+					const struct v4l2_frequency *a);
 	int (*vidioc_enum_freq_bands) (struct file *file, void *fh,
 				    struct v4l2_frequency_band *band);
 
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index b137a5e..1a82a50 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -191,7 +191,7 @@ struct v4l2_subdev_core_ops {
  */
 struct v4l2_subdev_tuner_ops {
 	int (*s_radio)(struct v4l2_subdev *sd);
-	int (*s_frequency)(struct v4l2_subdev *sd, struct v4l2_frequency *freq);
+	int (*s_frequency)(struct v4l2_subdev *sd, const struct v4l2_frequency *freq);
 	int (*g_frequency)(struct v4l2_subdev *sd, struct v4l2_frequency *freq);
 	int (*g_tuner)(struct v4l2_subdev *sd, struct v4l2_tuner *vt);
 	int (*s_tuner)(struct v4l2_subdev *sd, struct v4l2_tuner *vt);
diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index 3c6c1e3..738c5ad 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -336,7 +336,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
-					struct v4l2_frequency *f)
+					const struct v4l2_frequency *f)
 {
 	struct snd_tea575x *tea = video_drvdata(file);
 
@@ -350,7 +350,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	else
 		tea->band = BAND_FM;
 
-	tea->freq = clamp(f->frequency, bands[tea->band].rangelow,
+	tea->freq = clamp_t(u32, f->frequency, bands[tea->band].rangelow,
 					bands[tea->band].rangehigh);
 	snd_tea575x_set_freq(tea);
 	return 0;
-- 
1.7.10.4

