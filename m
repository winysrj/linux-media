Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:62498 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaCXTdF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:33:05 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so4808237eek.6
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:33:03 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 10/19] em28xx: move TV norm from struct em28xx to struct v4l2
Date: Mon, 24 Mar 2014 20:33:16 +0100
Message-Id: <1395689605-2705-11-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 35 ++++++++++++++++++---------------
 drivers/media/usb/em28xx/em28xx.h       |  3 ++-
 2 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 0676aa4..821d182 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -155,13 +155,15 @@ static inline unsigned int norm_maxw(struct em28xx *dev)
 
 static inline unsigned int norm_maxh(struct em28xx *dev)
 {
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
+
 	if (dev->board.is_webcam)
 		return dev->sensor_yres;
 
 	if (dev->board.max_range_640_480)
 		return 480;
 
-	return (dev->norm & V4L2_STD_625_50) ? 576 : 480;
+	return (v4l2->norm & V4L2_STD_625_50) ? 576 : 480;
 }
 
 static int em28xx_vbi_supported(struct em28xx *dev)
@@ -246,10 +248,10 @@ static int em28xx_set_outfmt(struct em28xx *dev)
 		em28xx_write_reg(dev, EM28XX_R34_VBI_START_H, 0x00);
 		em28xx_write_reg(dev, EM28XX_R36_VBI_WIDTH, v4l2->vbi_width/4);
 		em28xx_write_reg(dev, EM28XX_R37_VBI_HEIGHT, v4l2->vbi_height);
-		if (dev->norm & V4L2_STD_525_60) {
+		if (v4l2->norm & V4L2_STD_525_60) {
 			/* NTSC */
 			em28xx_write_reg(dev, EM28XX_R35_VBI_START_V, 0x09);
-		} else if (dev->norm & V4L2_STD_625_50) {
+		} else if (v4l2->norm & V4L2_STD_625_50) {
 			/* PAL */
 			em28xx_write_reg(dev, EM28XX_R35_VBI_START_V, 0x07);
 		}
@@ -330,7 +332,7 @@ static int em28xx_resolution_set(struct em28xx *dev)
 
 	/* Properly setup VBI */
 	v4l2->vbi_width = 720;
-	if (dev->norm & V4L2_STD_525_60)
+	if (v4l2->norm & V4L2_STD_525_60)
 		v4l2->vbi_height = 12;
 	else
 		v4l2->vbi_height = 18;
@@ -1349,7 +1351,7 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
 	struct em28xx_fh   *fh  = priv;
 	struct em28xx      *dev = fh->dev;
 
-	*norm = dev->norm;
+	*norm = dev->v4l2->norm;
 
 	return 0;
 }
@@ -1371,13 +1373,13 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	struct v4l2_format f;
 
-	if (norm == dev->norm)
+	if (norm == v4l2->norm)
 		return 0;
 
 	if (dev->streaming_users > 0)
 		return -EBUSY;
 
-	dev->norm = norm;
+	v4l2->norm = norm;
 
 	/* Adjusts width/height, if needed */
 	f.fmt.pix.width = 720;
@@ -1391,7 +1393,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 			   &v4l2->hscale, &v4l2->vscale);
 
 	em28xx_resolution_set(dev);
-	v4l2_device_call_all(&v4l2->v4l2_dev, 0, core, s_std, dev->norm);
+	v4l2_device_call_all(&v4l2->v4l2_dev, 0, core, s_std, v4l2->norm);
 
 	return 0;
 }
@@ -1399,16 +1401,17 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 static int vidioc_g_parm(struct file *file, void *priv,
 			 struct v4l2_streamparm *p)
 {
-	struct em28xx_fh   *fh  = priv;
-	struct em28xx      *dev = fh->dev;
+	struct em28xx_fh   *fh   = priv;
+	struct em28xx      *dev  = fh->dev;
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	int rc = 0;
 
 	p->parm.capture.readbuffers = EM28XX_MIN_BUF;
 	if (dev->board.is_webcam)
-		rc = v4l2_device_call_until_err(&dev->v4l2->v4l2_dev, 0,
+		rc = v4l2_device_call_until_err(&v4l2->v4l2_dev, 0,
 						video, g_parm, p);
 	else
-		v4l2_video_std_frame_period(dev->norm,
+		v4l2_video_std_frame_period(v4l2->norm,
 						 &p->parm.capture.timeperframe);
 
 	return rc;
@@ -1809,11 +1812,11 @@ static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
 	memset(format->fmt.vbi.reserved, 0, sizeof(format->fmt.vbi.reserved));
 
 	/* Varies by video standard (NTSC, PAL, etc.) */
-	if (dev->norm & V4L2_STD_525_60) {
+	if (v4l2->norm & V4L2_STD_525_60) {
 		/* NTSC */
 		format->fmt.vbi.start[0] = 10;
 		format->fmt.vbi.start[1] = 273;
-	} else if (dev->norm & V4L2_STD_625_50) {
+	} else if (v4l2->norm & V4L2_STD_625_50) {
 		/* PAL */
 		format->fmt.vbi.start[0] = 6;
 		format->fmt.vbi.start[1] = 318;
@@ -2425,8 +2428,8 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	}
 
 	/* set default norm */
-	dev->norm = V4L2_STD_PAL;
-	v4l2_device_call_all(&v4l2->v4l2_dev, 0, core, s_std, dev->norm);
+	v4l2->norm = V4L2_STD_PAL;
+	v4l2_device_call_all(&v4l2->v4l2_dev, 0, core, s_std, v4l2->norm);
 	dev->interlaced = EM28XX_INTERLACED_DEFAULT;
 
 	/* Analog specific initialization */
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 7ca0ff98..f0b3b8c 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -518,6 +518,8 @@ struct em28xx_v4l2 {
 	u8 vinmode;
 	u8 vinctl;
 
+	v4l2_std_id norm;	/* selected tv norm */
+
 	/* Frame properties */
 	int width;		/* current frame width */
 	int height;		/* current frame height */
@@ -632,7 +634,6 @@ struct em28xx {
 	/* video for linux */
 	int users;		/* user count for exclusive use */
 	int streaming_users;    /* Number of actively streaming users */
-	v4l2_std_id norm;	/* selected tv norm */
 	int ctl_freq;		/* selected frequency */
 	unsigned int ctl_input;	/* selected input */
 	unsigned int ctl_ainput;/* selected audio input */
-- 
1.8.4.5

