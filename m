Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59270 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935059AbaGYRsK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 13:48:10 -0400
Received: by mail-wi0-f178.google.com with SMTP id hi2so1362614wib.5
        for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 10:48:07 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/4] em28xx-v4l: get rid of struct em28xx_fh
Date: Fri, 25 Jul 2014 19:48:56 +0200
Message-Id: <1406310538-5001-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1406310538-5001-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1406310538-5001-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct em28xx_fh isn't needed anymore because the only used field which is left is struct v4l2_fh fh.
Use struct v4l2_fh directly and remvove struct em28xx_fh.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 83 ++++++++++++---------------------
 drivers/media/usb/em28xx/em28xx.h       |  7 ---
 2 files changed, 29 insertions(+), 61 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 3f8b5aa..4eb4a6a 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1227,8 +1227,7 @@ static void scale_to_size(struct em28xx *dev,
 static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
+	struct em28xx         *dev = video_drvdata(file);
 	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 
 	f->fmt.pix.width = v4l2->width;
@@ -1261,8 +1260,7 @@ static struct em28xx_fmt *format_by_fourcc(unsigned int fourcc)
 static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 			struct v4l2_format *f)
 {
-	struct em28xx_fh      *fh    = priv;
-	struct em28xx         *dev   = fh->dev;
+	struct em28xx         *dev   = video_drvdata(file);
 	struct em28xx_v4l2    *v4l2  = dev->v4l2;
 	unsigned int          width  = f->fmt.pix.width;
 	unsigned int          height = f->fmt.pix.height;
@@ -1355,8 +1353,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 
 static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
 {
-	struct em28xx_fh   *fh  = priv;
-	struct em28xx      *dev = fh->dev;
+	struct em28xx *dev = video_drvdata(file);
 
 	*norm = dev->v4l2->norm;
 
@@ -1365,8 +1362,7 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
 
 static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
 {
-	struct em28xx_fh   *fh  = priv;
-	struct em28xx      *dev = fh->dev;
+	struct em28xx *dev = video_drvdata(file);
 
 	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, video, querystd, norm);
 
@@ -1375,8 +1371,7 @@ static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
 
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 {
-	struct em28xx_fh   *fh   = priv;
-	struct em28xx      *dev  = fh->dev;
+	struct em28xx      *dev  = video_drvdata(file);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	struct v4l2_format f;
 
@@ -1408,8 +1403,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 static int vidioc_g_parm(struct file *file, void *priv,
 			 struct v4l2_streamparm *p)
 {
-	struct em28xx_fh   *fh   = priv;
-	struct em28xx      *dev  = fh->dev;
+	struct em28xx      *dev  = video_drvdata(file);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	int rc = 0;
 
@@ -1427,8 +1421,7 @@ static int vidioc_g_parm(struct file *file, void *priv,
 static int vidioc_s_parm(struct file *file, void *priv,
 			 struct v4l2_streamparm *p)
 {
-	struct em28xx_fh   *fh  = priv;
-	struct em28xx      *dev = fh->dev;
+	struct em28xx *dev = video_drvdata(file);
 
 	p->parm.capture.readbuffers = EM28XX_MIN_BUF;
 	return v4l2_device_call_until_err(&dev->v4l2->v4l2_dev,
@@ -1450,8 +1443,7 @@ static const char *iname[] = {
 static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *i)
 {
-	struct em28xx_fh   *fh  = priv;
-	struct em28xx      *dev = fh->dev;
+	struct em28xx *dev = video_drvdata(file);
 	unsigned int       n;
 
 	n = i->index;
@@ -1479,8 +1471,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 
 static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 {
-	struct em28xx_fh   *fh  = priv;
-	struct em28xx      *dev = fh->dev;
+	struct em28xx *dev = video_drvdata(file);
 
 	*i = dev->ctl_input;
 
@@ -1489,8 +1480,7 @@ static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 
 static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
-	struct em28xx_fh   *fh  = priv;
-	struct em28xx      *dev = fh->dev;
+	struct em28xx *dev = video_drvdata(file);
 
 	if (i >= MAX_EM28XX_INPUT)
 		return -EINVAL;
@@ -1503,8 +1493,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 
 static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
 {
-	struct em28xx_fh   *fh    = priv;
-	struct em28xx      *dev   = fh->dev;
+	struct em28xx *dev = video_drvdata(file);
 
 	switch (a->index) {
 	case EM28XX_AMUX_VIDEO:
@@ -1543,8 +1532,7 @@ static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
 
 static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio *a)
 {
-	struct em28xx_fh   *fh  = priv;
-	struct em28xx      *dev = fh->dev;
+	struct em28xx *dev = video_drvdata(file);
 
 	if (a->index >= MAX_EM28XX_INPUT)
 		return -EINVAL;
@@ -1563,8 +1551,7 @@ static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio
 static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
+	struct em28xx *dev = video_drvdata(file);
 
 	if (0 != t->index)
 		return -EINVAL;
@@ -1578,8 +1565,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 static int vidioc_s_tuner(struct file *file, void *priv,
 				const struct v4l2_tuner *t)
 {
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
+	struct em28xx *dev = video_drvdata(file);
 
 	if (0 != t->index)
 		return -EINVAL;
@@ -1591,8 +1577,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 static int vidioc_g_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
+	struct em28xx         *dev = video_drvdata(file);
 	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 
 	if (0 != f->tuner)
@@ -1606,8 +1591,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 				const struct v4l2_frequency *f)
 {
 	struct v4l2_frequency  new_freq = *f;
-	struct em28xx_fh          *fh   = priv;
-	struct em28xx             *dev  = fh->dev;
+	struct em28xx             *dev  = video_drvdata(file);
 	struct em28xx_v4l2        *v4l2 = dev->v4l2;
 
 	if (0 != f->tuner)
@@ -1624,8 +1608,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 static int vidioc_g_chip_info(struct file *file, void *priv,
 	       struct v4l2_dbg_chip_info *chip)
 {
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
+	struct em28xx *dev = video_drvdata(file);
 
 	if (chip->match.addr > 1)
 		return -EINVAL;
@@ -1652,8 +1635,7 @@ static int em28xx_reg_len(int reg)
 static int vidioc_g_register(struct file *file, void *priv,
 			     struct v4l2_dbg_register *reg)
 {
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
+	struct em28xx *dev = video_drvdata(file);
 	int ret;
 
 	if (reg->match.addr > 1)
@@ -1693,8 +1675,7 @@ static int vidioc_g_register(struct file *file, void *priv,
 static int vidioc_s_register(struct file *file, void *priv,
 			     const struct v4l2_dbg_register *reg)
 {
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
+	struct em28xx *dev = video_drvdata(file);
 	__le16 buf;
 
 	if (reg->match.addr > 1)
@@ -1715,8 +1696,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
 	struct video_device   *vdev = video_devdata(file);
-	struct em28xx_fh      *fh   = priv;
-	struct em28xx         *dev  = fh->dev;
+	struct em28xx         *dev  = video_drvdata(file);
 	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 
 	strlcpy(cap->driver, "em28xx", sizeof(cap->driver));
@@ -1761,8 +1741,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 static int vidioc_enum_framesizes(struct file *file, void *priv,
 				  struct v4l2_frmsizeenum *fsize)
 {
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
+	struct em28xx         *dev = video_drvdata(file);
 	struct em28xx_fmt     *fmt;
 	unsigned int	      maxw = norm_maxw(dev);
 	unsigned int	      maxh = norm_maxh(dev);
@@ -1806,8 +1785,7 @@ static int vidioc_enum_framesizes(struct file *file, void *priv,
 static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
 				struct v4l2_format *format)
 {
-	struct em28xx_fh      *fh   = priv;
-	struct em28xx         *dev  = fh->dev;
+	struct em28xx         *dev  = video_drvdata(file);
 	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 
 	format->fmt.vbi.samples_per_line = v4l2->vbi_width;
@@ -1840,7 +1818,7 @@ static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
 static int radio_g_tuner(struct file *file, void *priv,
 			 struct v4l2_tuner *t)
 {
-	struct em28xx *dev = ((struct em28xx_fh *)priv)->dev;
+	struct em28xx *dev = video_drvdata(file);
 
 	if (unlikely(t->index > 0))
 		return -EINVAL;
@@ -1855,7 +1833,7 @@ static int radio_g_tuner(struct file *file, void *priv,
 static int radio_s_tuner(struct file *file, void *priv,
 			 const struct v4l2_tuner *t)
 {
-	struct em28xx *dev = ((struct em28xx_fh *)priv)->dev;
+	struct em28xx *dev = video_drvdata(file);
 
 	if (0 != t->index)
 		return -EINVAL;
@@ -1890,7 +1868,7 @@ static int em28xx_v4l2_open(struct file *filp)
 	struct em28xx *dev = video_drvdata(filp);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	enum v4l2_buf_type fh_type = 0;
-	struct em28xx_fh *fh;
+	struct v4l2_fh *fh;
 
 	switch (vdev->vfl_type) {
 	case VFL_TYPE_GRABBER:
@@ -1911,15 +1889,13 @@ static int em28xx_v4l2_open(struct file *filp)
 
 	if (mutex_lock_interruptible(&dev->lock))
 		return -ERESTARTSYS;
-	fh = kzalloc(sizeof(struct em28xx_fh), GFP_KERNEL);
+	fh = kzalloc(sizeof(struct v4l2_fh), GFP_KERNEL);
 	if (!fh) {
 		em28xx_errdev("em28xx-video.c: Out of memory?!\n");
 		mutex_unlock(&dev->lock);
 		return -ENOMEM;
 	}
-	v4l2_fh_init(&fh->fh, vdev);
-	fh->dev = dev;
-	fh->type = fh_type;
+	v4l2_fh_init(fh, vdev);
 	filp->private_data = fh;
 
 	if (v4l2->users == 0) {
@@ -1945,7 +1921,7 @@ static int em28xx_v4l2_open(struct file *filp)
 	v4l2->users++;
 
 	mutex_unlock(&dev->lock);
-	v4l2_fh_add(&fh->fh);
+	v4l2_fh_add(fh);
 
 	return 0;
 }
@@ -2046,8 +2022,7 @@ static int em28xx_v4l2_resume(struct em28xx *dev)
  */
 static int em28xx_v4l2_close(struct file *filp)
 {
-	struct em28xx_fh      *fh   = filp->private_data;
-	struct em28xx         *dev  = fh->dev;
+	struct em28xx         *dev  = video_drvdata(filp);
 	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 	int              errCode;
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index b4c837d..4360338 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -576,13 +576,6 @@ struct em28xx_audio {
 
 struct em28xx;
 
-struct em28xx_fh {
-	struct v4l2_fh fh;
-	struct em28xx *dev;
-
-	enum v4l2_buf_type           type;
-};
-
 enum em28xx_i2c_algo_type {
 	EM28XX_I2C_ALGO_EM28XX = 0,
 	EM28XX_I2C_ALGO_EM2800,
-- 
1.8.4.5

