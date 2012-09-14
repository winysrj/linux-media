Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:45677 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab2INK6K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:58:10 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q8EAvqBu013688
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:57:59 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv3 API PATCH 25/31] v4l2: make vidioc_s_modulator const.
Date: Fri, 14 Sep 2012 12:57:40 +0200
Message-Id: <5aa6575923a8453a336cc67cc0ca66df6e70d83f.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
References: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Write-only ioctls should have a const argument in the ioctl op.

Do this conversion for vidioc_s_modulator.

Adding const for write-only ioctls was decided during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-keene.c       |    2 +-
 drivers/media/radio/radio-si4713.c      |    2 +-
 drivers/media/radio/radio-wl1273.c      |    2 +-
 drivers/media/radio/si4713-i2c.c        |    4 ++--
 drivers/media/radio/wl128x/fmdrv_v4l2.c |    2 +-
 include/media/v4l2-ioctl.h              |    2 +-
 include/media/v4l2-subdev.h             |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
index 79adf3e..e10e525 100644
--- a/drivers/media/radio/radio-keene.c
+++ b/drivers/media/radio/radio-keene.c
@@ -203,7 +203,7 @@ static int vidioc_g_modulator(struct file *file, void *priv,
 }
 
 static int vidioc_s_modulator(struct file *file, void *priv,
-				struct v4l2_modulator *v)
+				const struct v4l2_modulator *v)
 {
 	struct keene_device *radio = video_drvdata(file);
 
diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 1e04101..a082e40 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -200,7 +200,7 @@ static int radio_si4713_g_modulator(struct file *file, void *p,
 }
 
 static int radio_si4713_s_modulator(struct file *file, void *p,
-						struct v4l2_modulator *vm)
+						const struct v4l2_modulator *vm)
 {
 	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, tuner,
 							s_modulator, vm);
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 2d93354..b53ecbc 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1715,7 +1715,7 @@ out:
 }
 
 static int wl1273_fm_vidioc_s_modulator(struct file *file, void *priv,
-					struct v4l2_modulator *modulator)
+					const struct v4l2_modulator *modulator)
 {
 	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
 	struct wl1273_core *core = radio->core;
diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
index b898c89..a9e6d17 100644
--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -1213,7 +1213,7 @@ exit:
 }
 
 static int si4713_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f);
-static int si4713_s_modulator(struct v4l2_subdev *sd, struct v4l2_modulator *);
+static int si4713_s_modulator(struct v4l2_subdev *sd, const struct v4l2_modulator *);
 /*
  * si4713_setup - Sets the device up with current configuration.
  * @sdev: si4713_device structure for the device we are communicating
@@ -1873,7 +1873,7 @@ exit:
 }
 
 /* si4713_s_modulator - set modulator attributes */
-static int si4713_s_modulator(struct v4l2_subdev *sd, struct v4l2_modulator *vm)
+static int si4713_s_modulator(struct v4l2_subdev *sd, const struct v4l2_modulator *vm)
 {
 	struct si4713_device *sdev = to_si4713_device(sd);
 	int rval = 0;
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 09585a9..8a672a3 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -448,7 +448,7 @@ static int fm_v4l2_vidioc_g_modulator(struct file *file, void *priv,
 
 /* Set modulator attributes. If mode is not TX, set to TX. */
 static int fm_v4l2_vidioc_s_modulator(struct file *file, void *priv,
-		struct v4l2_modulator *mod)
+		const struct v4l2_modulator *mod)
 {
 	struct fmdev *fmdev = video_drvdata(file);
 	u8 rds_mode;
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index d4c7729..fbeb00e 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -179,7 +179,7 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_g_modulator)      (struct file *file, void *fh,
 					struct v4l2_modulator *a);
 	int (*vidioc_s_modulator)      (struct file *file, void *fh,
-					struct v4l2_modulator *a);
+					const struct v4l2_modulator *a);
 	/* Crop ioctls */
 	int (*vidioc_cropcap)          (struct file *file, void *fh,
 					struct v4l2_cropcap *a);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 22ab09e..e698f2c 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -194,7 +194,7 @@ struct v4l2_subdev_tuner_ops {
 	int (*g_tuner)(struct v4l2_subdev *sd, struct v4l2_tuner *vt);
 	int (*s_tuner)(struct v4l2_subdev *sd, struct v4l2_tuner *vt);
 	int (*g_modulator)(struct v4l2_subdev *sd, struct v4l2_modulator *vm);
-	int (*s_modulator)(struct v4l2_subdev *sd, struct v4l2_modulator *vm);
+	int (*s_modulator)(struct v4l2_subdev *sd, const struct v4l2_modulator *vm);
 	int (*s_type_addr)(struct v4l2_subdev *sd, struct tuner_setup *type);
 	int (*s_config)(struct v4l2_subdev *sd, const struct v4l2_priv_tun_config *config);
 };
-- 
1.7.10.4

