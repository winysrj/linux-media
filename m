Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1925 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3COK2H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 06:28:07 -0400
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
Subject: [REVIEW PATCH 2/5] v4l2: add const to argument of write-only s_tuner ioctl.
Date: Fri, 15 Mar 2013 11:27:22 +0100
Message-Id: <097e3e28dc8fbe8105fa3b2a489e18a5c5eca7bb.1363342714.git.hans.verkuil@cisco.com>
In-Reply-To: <1363343245-23531-1-git-send-email-hverkuil@xs4all.nl>
References: <1363343245-23531-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9ae3227f74816dbf699bbc8b1ce6202a5de1582f.1363342714.git.hans.verkuil@cisco.com>
References: <9ae3227f74816dbf699bbc8b1ce6202a5de1582f.1363342714.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This ioctl is defined as IOW, so pass the argument as const.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/cx25840/cx25840-core.c         |    2 +-
 drivers/media/i2c/msp3400-driver.c               |    2 +-
 drivers/media/i2c/saa6588.c                      |    2 +-
 drivers/media/i2c/saa717x.c                      |    2 +-
 drivers/media/i2c/tda9840.c                      |    2 +-
 drivers/media/i2c/tvaudio.c                      |    2 +-
 drivers/media/i2c/vp27smpx.c                     |    2 +-
 drivers/media/pci/bt8xx/bttv-driver.c            |   11 +++++++----
 drivers/media/pci/cx18/cx18-av-core.c            |    2 +-
 drivers/media/pci/cx18/cx18-ioctl.c              |    2 +-
 drivers/media/pci/cx23885/cx23885-417.c          |    2 +-
 drivers/media/pci/cx23885/cx23885-video.c        |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c        |    2 +-
 drivers/media/pci/cx25821/cx25821-video.h        |    2 +-
 drivers/media/pci/cx88/cx88-blackbird.c          |    2 +-
 drivers/media/pci/cx88/cx88-video.c              |    9 ++-------
 drivers/media/pci/ivtv/ivtv-gpio.c               |    2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c              |    2 +-
 drivers/media/pci/saa7134/saa7134-video.c        |    4 ++--
 drivers/media/pci/saa7146/mxb.c                  |    2 +-
 drivers/media/pci/saa7164/saa7164-encoder.c      |    2 +-
 drivers/media/pci/saa7164/saa7164-vbi.c          |    2 +-
 drivers/media/pci/ttpci/av7110_v4l.c             |    2 +-
 drivers/media/radio/dsbr100.c                    |    2 +-
 drivers/media/radio/radio-cadet.c                |    2 +-
 drivers/media/radio/radio-isa.c                  |    2 +-
 drivers/media/radio/radio-ma901.c                |    2 +-
 drivers/media/radio/radio-miropcm20.c            |    8 +++++---
 drivers/media/radio/radio-mr800.c                |    2 +-
 drivers/media/radio/radio-sf16fmi.c              |    2 +-
 drivers/media/radio/radio-tea5764.c              |    2 +-
 drivers/media/radio/radio-tea5777.c              |    7 +++----
 drivers/media/radio/radio-timb.c                 |    2 +-
 drivers/media/radio/radio-wl1273.c               |    2 +-
 drivers/media/radio/si470x/radio-si470x-common.c |    2 +-
 drivers/media/radio/tef6862.c                    |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c          |    2 +-
 drivers/media/usb/au0828/au0828-video.c          |    4 +---
 drivers/media/usb/cx231xx/cx231xx-video.c        |    4 ++--
 drivers/media/usb/cx231xx/cx231xx.h              |    2 +-
 drivers/media/usb/em28xx/em28xx-video.c          |    4 ++--
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c         |    2 +-
 drivers/media/usb/tlg2300/pd-radio.c             |    2 +-
 drivers/media/usb/tlg2300/pd-video.c             |    2 +-
 drivers/media/usb/tm6000/tm6000-video.c          |    8 ++------
 drivers/media/usb/usbvision/usbvision-video.c    |    2 +-
 drivers/media/v4l2-core/tuner-core.c             |    2 +-
 drivers/staging/media/go7007/go7007-v4l2.c       |    2 +-
 include/media/v4l2-ioctl.h                       |    2 +-
 include/media/v4l2-subdev.h                      |    2 +-
 sound/i2c/other/tea575x-tuner.c                  |    2 +-
 51 files changed, 68 insertions(+), 75 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index f4339ed..234b7c6 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -1881,7 +1881,7 @@ static int cx25840_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	return 0;
 }
 
-static int cx25840_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
+static int cx25840_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *vt)
 {
 	struct cx25840_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index 77053ba..54a9dd3 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -535,7 +535,7 @@ static int msp_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	return 0;
 }
 
-static int msp_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
+static int msp_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *vt)
 {
 	struct msp_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
diff --git a/drivers/media/i2c/saa6588.c b/drivers/media/i2c/saa6588.c
index 0caac50..b4e1ccb 100644
--- a/drivers/media/i2c/saa6588.c
+++ b/drivers/media/i2c/saa6588.c
@@ -435,7 +435,7 @@ static int saa6588_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	return 0;
 }
 
-static int saa6588_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
+static int saa6588_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *vt)
 {
 	struct saa6588 *s = to_saa6588(sd);
 
diff --git a/drivers/media/i2c/saa717x.c b/drivers/media/i2c/saa717x.c
index 1e84466..5608b93 100644
--- a/drivers/media/i2c/saa717x.c
+++ b/drivers/media/i2c/saa717x.c
@@ -1113,7 +1113,7 @@ static int saa717x_s_stream(struct v4l2_subdev *sd, int enable)
 }
 
 /* change audio mode */
-static int saa717x_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
+static int saa717x_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *vt)
 {
 	struct saa717x_state *decoder = to_state(sd);
 	int audio_mode;
diff --git a/drivers/media/i2c/tda9840.c b/drivers/media/i2c/tda9840.c
index 3d7ddd9..01441e3 100644
--- a/drivers/media/i2c/tda9840.c
+++ b/drivers/media/i2c/tda9840.c
@@ -87,7 +87,7 @@ static int tda9840_status(struct v4l2_subdev *sd)
 	return byte & 0x60;
 }
 
-static int tda9840_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *t)
+static int tda9840_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *t)
 {
 	int stat = tda9840_status(sd);
 	int byte;
diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index 4b12c51..b72a59d 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -1761,7 +1761,7 @@ static int tvaudio_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int tvaudio_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
+static int tvaudio_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *vt)
 {
 	struct CHIPSTATE *chip = to_state(sd);
 	struct CHIPDESC *desc = chip->desc;
diff --git a/drivers/media/i2c/vp27smpx.c b/drivers/media/i2c/vp27smpx.c
index 7cfbc9d..e71f139 100644
--- a/drivers/media/i2c/vp27smpx.c
+++ b/drivers/media/i2c/vp27smpx.c
@@ -90,7 +90,7 @@ static int vp27smpx_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
 	return 0;
 }
 
-static int vp27smpx_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
+static int vp27smpx_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *vt)
 {
 	struct vp27smpx_state *state = to_state(sd);
 
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 7816edc..20db7aa 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1818,7 +1818,7 @@ static int bttv_s_input(struct file *file, void *priv, unsigned int i)
 }
 
 static int bttv_s_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *t)
+					const struct v4l2_tuner *t)
 {
 	struct bttv_fh *fh  = priv;
 	struct bttv *btv = fh->btv;
@@ -1828,8 +1828,11 @@ static int bttv_s_tuner(struct file *file, void *priv,
 
 	bttv_call_all(btv, tuner, s_tuner, t);
 
-	if (btv->audio_mode_gpio)
-		btv->audio_mode_gpio(btv, t, 1);
+	if (btv->audio_mode_gpio) {
+		struct v4l2_tuner copy = *t;
+
+		btv->audio_mode_gpio(btv, &copy, 1);
+	}
 	return 0;
 }
 
@@ -3276,7 +3279,7 @@ static int radio_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 }
 
 static int radio_s_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *t)
+					const struct v4l2_tuner *t)
 {
 	struct bttv_fh *fh = priv;
 	struct bttv *btv = fh->btv;
diff --git a/drivers/media/pci/cx18/cx18-av-core.c b/drivers/media/pci/cx18/cx18-av-core.c
index a2c51e0..c22242b 100644
--- a/drivers/media/pci/cx18/cx18-av-core.c
+++ b/drivers/media/pci/cx18/cx18-av-core.c
@@ -809,7 +809,7 @@ static int cx18_av_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	return 0;
 }
 
-static int cx18_av_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
+static int cx18_av_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *vt)
 {
 	struct cx18_av_state *state = to_cx18_av_state(sd);
 	struct cx18 *cx = v4l2_get_subdevdata(sd);
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index 5cd22e7..173ccd2 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -673,7 +673,7 @@ int cx18_s_std(struct file *file, void *fh, v4l2_std_id *std)
 	return 0;
 }
 
-static int cx18_s_tuner(struct file *file, void *fh, struct v4l2_tuner *vt)
+static int cx18_s_tuner(struct file *file, void *fh, const struct v4l2_tuner *vt)
 {
 	struct cx18_open_id *id = fh2id(fh);
 	struct cx18 *cx = id->cx;
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 84a1b75..812ec5f 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1280,7 +1280,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *t)
+				const struct v4l2_tuner *t)
 {
 	struct cx23885_fh  *fh  = file->private_data;
 	struct cx23885_dev *dev = fh->dev;
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 5ba15b8..2bbda43 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1486,7 +1486,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *t)
+				const struct v4l2_tuner *t)
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
 
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 1219d60..75281c1 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -1397,7 +1397,7 @@ int cx25821_vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	return 0;
 }
 
-int cx25821_vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
+int cx25821_vidioc_s_tuner(struct file *file, void *priv, const struct v4l2_tuner *t)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 	struct cx25821_fh *fh = priv;
diff --git a/drivers/media/pci/cx25821/cx25821-video.h b/drivers/media/pci/cx25821/cx25821-video.h
index 969340c..f0e70ff 100644
--- a/drivers/media/pci/cx25821/cx25821-video.h
+++ b/drivers/media/pci/cx25821/cx25821-video.h
@@ -159,7 +159,7 @@ extern int cx25821_vidioc_s_register(struct file *file, void *fh,
 extern int cx25821_vidioc_g_tuner(struct file *file, void *priv,
 				  struct v4l2_tuner *t);
 extern int cx25821_vidioc_s_tuner(struct file *file, void *priv,
-				  struct v4l2_tuner *t);
+				  const struct v4l2_tuner *t);
 
 extern int cx25821_is_valid_width(u32 width, v4l2_std_id tvnorm);
 extern int cx25821_is_valid_height(u32 height, v4l2_std_id tvnorm);
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 82aa11f..486ca8d 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -918,7 +918,7 @@ static int vidioc_g_tuner (struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner (struct file *file, void *priv,
-				struct v4l2_tuner *t)
+				const struct v4l2_tuner *t)
 {
 	struct cx88_core  *core = ((struct cx8802_fh *)priv)->dev->core;
 
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 4f10875..ede6f13 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1289,7 +1289,7 @@ static int vidioc_g_tuner (struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner (struct file *file, void *priv,
-				struct v4l2_tuner *t)
+				const struct v4l2_tuner *t)
 {
 	struct cx88_core  *core = ((struct cx8800_fh *)priv)->dev->core;
 
@@ -1409,20 +1409,15 @@ static int radio_g_tuner (struct file *file, void *priv,
 	return 0;
 }
 
-/* FIXME: Should add a standard for radio */
-
 static int radio_s_tuner (struct file *file, void *priv,
-				struct v4l2_tuner *t)
+				const struct v4l2_tuner *t)
 {
 	struct cx88_core  *core = ((struct cx8800_fh *)priv)->dev->core;
 
 	if (0 != t->index)
 		return -EINVAL;
-	if (t->audmode > V4L2_TUNER_MODE_STEREO)
-		t->audmode = V4L2_TUNER_MODE_STEREO;
 
 	call_all(core, tuner, s_tuner, t);
-
 	return 0;
 }
 
diff --git a/drivers/media/pci/ivtv/ivtv-gpio.c b/drivers/media/pci/ivtv/ivtv-gpio.c
index 8f0d077..af52def 100644
--- a/drivers/media/pci/ivtv/ivtv-gpio.c
+++ b/drivers/media/pci/ivtv/ivtv-gpio.c
@@ -192,7 +192,7 @@ static int subdev_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	return 0;
 }
 
-static int subdev_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
+static int subdev_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *vt)
 {
 	struct ivtv *itv = sd_to_ivtv(sd);
 	u16 mask, data;
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index e6258b6..852f11e 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -1196,7 +1196,7 @@ static int ivtv_s_std(struct file *file, void *fh, v4l2_std_id *std)
 	return 0;
 }
 
-static int ivtv_s_tuner(struct file *file, void *fh, struct v4l2_tuner *vt)
+static int ivtv_s_tuner(struct file *file, void *fh, const struct v4l2_tuner *vt)
 {
 	struct ivtv_open_id *id = fh2id(fh);
 	struct ivtv *itv = id->itv;
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 6c619d1..1e23547 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2023,7 +2023,7 @@ static int saa7134_g_tuner(struct file *file, void *priv,
 }
 
 static int saa7134_s_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *t)
+					const struct v4l2_tuner *t)
 {
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
@@ -2347,7 +2347,7 @@ static int radio_g_tuner(struct file *file, void *priv,
 	return 0;
 }
 static int radio_s_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *t)
+					const struct v4l2_tuner *t)
 {
 	struct saa7134_fh *fh = file->private_data;
 	struct saa7134_dev *dev = fh->dev;
diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 27dc49b..9dd044b 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -560,7 +560,7 @@ static int vidioc_g_tuner(struct file *file, void *fh, struct v4l2_tuner *t)
 	return call_all(dev, tuner, g_tuner, t);
 }
 
-static int vidioc_s_tuner(struct file *file, void *fh, struct v4l2_tuner *t)
+static int vidioc_s_tuner(struct file *file, void *fh, const struct v4l2_tuner *t)
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 	struct mxb *mxb = (struct mxb *)dev->ext_priv;
diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 34f700d..e7fbd03 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -318,7 +318,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-	struct v4l2_tuner *t)
+	const struct v4l2_tuner *t)
 {
 	/* Update the A/V core */
 	return 0;
diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index 5a8a6ad..bfc8cec 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -290,7 +290,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-	struct v4l2_tuner *t)
+	const struct v4l2_tuner *t)
 {
 	/* Update the A/V core */
 	return 0;
diff --git a/drivers/media/pci/ttpci/av7110_v4l.c b/drivers/media/pci/ttpci/av7110_v4l.c
index 65adaa7..6c4076a 100644
--- a/drivers/media/pci/ttpci/av7110_v4l.c
+++ b/drivers/media/pci/ttpci/av7110_v4l.c
@@ -366,7 +366,7 @@ static int vidioc_g_tuner(struct file *file, void *fh, struct v4l2_tuner *t)
 	return 0;
 }
 
-static int vidioc_s_tuner(struct file *file, void *fh, struct v4l2_tuner *t)
+static int vidioc_s_tuner(struct file *file, void *fh, const struct v4l2_tuner *t)
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 	struct av7110 *av7110 = (struct av7110 *)dev->ext_priv;
diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index e140a72..142c2ee 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -208,7 +208,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *v)
+				const struct v4l2_tuner *v)
 {
 	return v->index ? -EINVAL : 0;
 }
diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index 59be293..545c04c 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -390,7 +390,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *v)
+				const struct v4l2_tuner *v)
 {
 	return v->index ? -EINVAL : 0;
 }
diff --git a/drivers/media/radio/radio-isa.c b/drivers/media/radio/radio-isa.c
index 0c1e27b..6ff3508 100644
--- a/drivers/media/radio/radio-isa.c
+++ b/drivers/media/radio/radio-isa.c
@@ -87,7 +87,7 @@ static int radio_isa_g_tuner(struct file *file, void *priv,
 }
 
 static int radio_isa_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *v)
+				const struct v4l2_tuner *v)
 {
 	struct radio_isa_card *isa = video_drvdata(file);
 	const struct radio_isa_ops *ops = isa->drv->ops;
diff --git a/drivers/media/radio/radio-ma901.c b/drivers/media/radio/radio-ma901.c
index 7f85c6f..18320c2 100644
--- a/drivers/media/radio/radio-ma901.c
+++ b/drivers/media/radio/radio-ma901.c
@@ -239,7 +239,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 
 /* vidioc_s_tuner - set tuner attributes */
 static int vidioc_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *v)
+				const struct v4l2_tuner *v)
 {
 	struct ma901radio_device *radio = video_drvdata(file);
 
diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
index 2b8d31d..a7e93d7 100644
--- a/drivers/media/radio/radio-miropcm20.c
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -103,16 +103,18 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *v)
+				const struct v4l2_tuner *v)
 {
 	struct pcm20 *dev = video_drvdata(file);
 
 	if (v->index)
 		return -EINVAL;
 	if (v->audmode > V4L2_TUNER_MODE_STEREO)
-		v->audmode = V4L2_TUNER_MODE_STEREO;
+		dev->audmode = V4L2_TUNER_MODE_STEREO;
+	else
+		dev->audmode = v->audmode;
 	snd_aci_cmd(dev->aci, ACI_SET_TUNERMONO,
-			v->audmode == V4L2_TUNER_MODE_MONO, -1);
+			dev->audmode == V4L2_TUNER_MODE_MONO, -1);
 	return 0;
 }
 
diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index f9cdd8b..2ce75d1 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -305,7 +305,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 
 /* vidioc_s_tuner - set tuner attributes */
 static int vidioc_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *v)
+				const struct v4l2_tuner *v)
 {
 	struct amradio_device *radio = video_drvdata(file);
 
diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index 6142b5b..adfcc61 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -145,7 +145,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *v)
+					const struct v4l2_tuner *v)
 {
 	return v->index ? -EINVAL : 0;
 }
diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 8938428..38d563d 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -339,7 +339,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *v)
+				const struct v4l2_tuner *v)
 {
 	struct tea5764_device *radio = video_drvdata(file);
 
diff --git a/drivers/media/radio/radio-tea5777.c b/drivers/media/radio/radio-tea5777.c
index fcd7c19..e245597 100644
--- a/drivers/media/radio/radio-tea5777.c
+++ b/drivers/media/radio/radio-tea5777.c
@@ -336,7 +336,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *v)
+					const struct v4l2_tuner *v)
 {
 	struct radio_tea5777 *tea = video_drvdata(file);
 	u32 orig_audmode = tea->audmode;
@@ -344,10 +344,9 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	if (v->index)
 		return -EINVAL;
 
-	if (v->audmode > V4L2_TUNER_MODE_STEREO)
-		v->audmode = V4L2_TUNER_MODE_STEREO;
-
 	tea->audmode = v->audmode;
+	if (tea->audmode > V4L2_TUNER_MODE_STEREO)
+		tea->audmode = V4L2_TUNER_MODE_STEREO;
 
 	if (tea->audmode != orig_audmode && tea->band == BAND_FM)
 		return radio_tea5777_set_freq(tea);
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index 1712c05..bb7b143 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -56,7 +56,7 @@ static int timbradio_vidioc_g_tuner(struct file *file, void *priv,
 }
 
 static int timbradio_vidioc_s_tuner(struct file *file, void *priv,
-	struct v4l2_tuner *v)
+	const struct v4l2_tuner *v)
 {
 	struct timbradio *tr = video_drvdata(file);
 	return v4l2_subdev_call(tr->sd_tuner, tuner, s_tuner, v);
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 9a02fee..97c2c18 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1559,7 +1559,7 @@ out:
 }
 
 static int wl1273_fm_vidioc_s_tuner(struct file *file, void *priv,
-				    struct v4l2_tuner *tuner)
+				    const struct v4l2_tuner *tuner)
 {
 	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
 	struct wl1273_core *core = radio->core;
diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 5708633..5c57e5b 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -636,7 +636,7 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
  * si470x_vidioc_s_tuner - set tuner attributes
  */
 static int si470x_vidioc_s_tuner(struct file *file, void *priv,
-		struct v4l2_tuner *tuner)
+		const struct v4l2_tuner *tuner)
 {
 	struct si470x_device *radio = video_drvdata(file);
 
diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
index 8673955..82c6c94 100644
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -96,7 +96,7 @@ static int tef6862_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
 	return 0;
 }
 
-static int tef6862_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
+static int tef6862_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *v)
 {
 	return v->index ? -EINVAL : 0;
 }
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 0183956..5dec323 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -331,7 +331,7 @@ static int fm_v4l2_vidioc_g_tuner(struct file *file, void *priv,
  * Should we set other tuner attributes, too?
  */
 static int fm_v4l2_vidioc_s_tuner(struct file *file, void *priv,
-		struct v4l2_tuner *tuner)
+		const struct v4l2_tuner *tuner)
 {
 	struct fmdev *fmdev = video_drvdata(file);
 	u16 aud_mode;
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index b1d6b03..11316f2 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1508,7 +1508,7 @@ static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *t)
+				const struct v4l2_tuner *t)
 {
 	struct au0828_fh *fh = priv;
 	struct au0828_dev *dev = fh->dev;
@@ -1516,8 +1516,6 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	if (t->index != 0)
 		return -EINVAL;
 
-	t->type = V4L2_TUNER_ANALOG_TV;
-
 	if (dev->dvb.frontend && dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl)
 		dev->dvb.frontend->ops.analog_ops.i2c_gate_ctrl(dev->dvb.frontend, 1);
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 96f6531..53020a7 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1139,7 +1139,7 @@ int cx231xx_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	return 0;
 }
 
-int cx231xx_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
+int cx231xx_s_tuner(struct file *file, void *priv, const struct v4l2_tuner *t)
 {
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
@@ -1808,7 +1808,7 @@ static int radio_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 
 	return 0;
 }
-static int radio_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
+static int radio_s_tuner(struct file *file, void *priv, const struct v4l2_tuner *t)
 {
 	struct cx231xx *dev = ((struct cx231xx_fh *)priv)->dev;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 0a6071b..4e37d0f 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -935,7 +935,7 @@ void cx231xx_close_extension(struct cx231xx *dev);
 int cx231xx_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap);
 int cx231xx_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t);
-int cx231xx_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t);
+int cx231xx_s_tuner(struct file *file, void *priv, const struct v4l2_tuner *t);
 int cx231xx_g_frequency(struct file *file, void *priv,
 			      struct v4l2_frequency *f);
 int cx231xx_s_frequency(struct file *file, void *priv,
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 42173d9..1f16904 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1193,7 +1193,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *t)
+				const struct v4l2_tuner *t)
 {
 	struct em28xx_fh      *fh  = priv;
 	struct em28xx         *dev = fh->dev;
@@ -1491,7 +1491,7 @@ static int radio_g_tuner(struct file *file, void *priv,
 }
 
 static int radio_s_tuner(struct file *file, void *priv,
-			 struct v4l2_tuner *t)
+			 const struct v4l2_tuner *t)
 {
 	struct em28xx *dev = ((struct em28xx_fh *)priv)->dev;
 
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 75657c6..0f729c9 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -352,7 +352,7 @@ static int pvr2_g_tuner(struct file *file, void *priv, struct v4l2_tuner *vt)
 	return pvr2_hdw_get_tuner_status(hdw, vt);
 }
 
-static int pvr2_s_tuner(struct file *file, void *priv, struct v4l2_tuner *vt)
+static int pvr2_s_tuner(struct file *file, void *priv, const struct v4l2_tuner *vt)
 {
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
index 8b1daf1..ea6070b 100644
--- a/drivers/media/usb/tlg2300/pd-radio.c
+++ b/drivers/media/usb/tlg2300/pd-radio.c
@@ -283,7 +283,7 @@ static int tlg_fm_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
-static int vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *vt)
+static int vidioc_s_tuner(struct file *file, void *priv, const struct v4l2_tuner *vt)
 {
 	return vt->index > 0 ? -EINVAL : 0;
 }
diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
index 8ef7c8c..9595309 100644
--- a/drivers/media/usb/tlg2300/pd-video.c
+++ b/drivers/media/usb/tlg2300/pd-video.c
@@ -1031,7 +1031,7 @@ static int pd_vidioc_s_tuner(struct poseidon *pd, int index)
 	return ret;
 }
 
-static int vidioc_s_tuner(struct file *file, void *fh, struct v4l2_tuner *a)
+static int vidioc_s_tuner(struct file *file, void *fh, const struct v4l2_tuner *a)
 {
 	struct front_face *front	= fh;
 	struct poseidon *pd		= front->pd;
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 49df753..b4618d7 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1215,7 +1215,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *t)
+				const struct v4l2_tuner *t)
 {
 	struct tm6000_fh   *fh  = priv;
 	struct tm6000_core *dev = fh->dev;
@@ -1293,18 +1293,14 @@ static int radio_g_tuner(struct file *file, void *priv,
 }
 
 static int radio_s_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *t)
+					const struct v4l2_tuner *t)
 {
 	struct tm6000_fh *fh = file->private_data;
 	struct tm6000_core *dev = fh->dev;
 
 	if (0 != t->index)
 		return -EINVAL;
-	if (t->audmode > V4L2_TUNER_MODE_STEREO)
-		t->audmode = V4L2_TUNER_MODE_STEREO;
-
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_tuner, t);
-
 	return 0;
 }
 
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index b668445..874cfec 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -628,7 +628,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *vt)
+				const struct v4l2_tuner *vt)
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
 
diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 279f65e..f775768 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -1233,7 +1233,7 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
  * Note: vt->type should be initialized before calling it.
  * This is done by either video_ioctl2 or by the bridge driver.
  */
-static int tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
+static int tuner_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *vt)
 {
 	struct tuner *t = to_tuner(sd);
 
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 1288f1c..4e477f3 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -1242,7 +1242,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *t)
+				const struct v4l2_tuner *t)
 {
 	struct go7007 *go = ((struct go7007_file *) priv)->go;
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index f06436d..0da8682 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -219,7 +219,7 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_g_tuner)          (struct file *file, void *fh,
 					struct v4l2_tuner *a);
 	int (*vidioc_s_tuner)          (struct file *file, void *fh,
-					struct v4l2_tuner *a);
+					const struct v4l2_tuner *a);
 	int (*vidioc_g_frequency)      (struct file *file, void *fh,
 					struct v4l2_frequency *a);
 	int (*vidioc_s_frequency)      (struct file *file, void *fh,
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 1a82a50..79784fc 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -194,7 +194,7 @@ struct v4l2_subdev_tuner_ops {
 	int (*s_frequency)(struct v4l2_subdev *sd, const struct v4l2_frequency *freq);
 	int (*g_frequency)(struct v4l2_subdev *sd, struct v4l2_frequency *freq);
 	int (*g_tuner)(struct v4l2_subdev *sd, struct v4l2_tuner *vt);
-	int (*s_tuner)(struct v4l2_subdev *sd, struct v4l2_tuner *vt);
+	int (*s_tuner)(struct v4l2_subdev *sd, const struct v4l2_tuner *vt);
 	int (*g_modulator)(struct v4l2_subdev *sd, struct v4l2_modulator *vm);
 	int (*s_modulator)(struct v4l2_subdev *sd, const struct v4l2_modulator *vm);
 	int (*s_type_addr)(struct v4l2_subdev *sd, struct tuner_setup *type);
diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index 738c5ad..8a36a1d 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -306,7 +306,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *v)
+					const struct v4l2_tuner *v)
 {
 	struct snd_tea575x *tea = video_drvdata(file);
 	u32 orig_val = tea->val;
-- 
1.7.10.4

