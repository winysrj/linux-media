Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:55952 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbaCXTdL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:33:11 -0400
Received: by mail-ee0-f43.google.com with SMTP id e53so4843284eek.30
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:33:10 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 15/19] em28xx: move v4l2 user counting fields from struct em28xx to struct v4l2
Date: Mon, 24 Mar 2014 20:33:21 +0100
Message-Id: <1395689605-2705-16-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 27 +++++++++++++++------------
 drivers/media/usb/em28xx/em28xx.h       |  5 +++--
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 496dcef..aaab111 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -934,7 +934,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 	if (rc)
 		return rc;
 
-	if (dev->streaming_users == 0) {
+	if (v4l2->streaming_users == 0) {
 		/* First active streaming user, so allocate all the URBs */
 
 		/* Allocate the USB bandwidth */
@@ -972,7 +972,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 				     0, tuner, s_frequency, &f);
 	}
 
-	dev->streaming_users++;
+	v4l2->streaming_users++;
 
 	return rc;
 }
@@ -980,6 +980,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 static int em28xx_stop_streaming(struct vb2_queue *vq)
 {
 	struct em28xx *dev = vb2_get_drv_priv(vq);
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	struct em28xx_dmaqueue *vidq = &dev->vidq;
 	unsigned long flags = 0;
 
@@ -987,7 +988,7 @@ static int em28xx_stop_streaming(struct vb2_queue *vq)
 
 	res_free(dev, vq->type);
 
-	if (dev->streaming_users-- == 1) {
+	if (v4l2->streaming_users-- == 1) {
 		/* Last active user, so shutdown all the URBS */
 		em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
 	}
@@ -1008,6 +1009,7 @@ static int em28xx_stop_streaming(struct vb2_queue *vq)
 int em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 {
 	struct em28xx *dev = vb2_get_drv_priv(vq);
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	struct em28xx_dmaqueue *vbiq = &dev->vbiq;
 	unsigned long flags = 0;
 
@@ -1015,7 +1017,7 @@ int em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 
 	res_free(dev, vq->type);
 
-	if (dev->streaming_users-- == 1) {
+	if (v4l2->streaming_users-- == 1) {
 		/* Last active user, so shutdown all the URBS */
 		em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
 	}
@@ -1344,8 +1346,9 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 			struct v4l2_format *f)
 {
 	struct em28xx *dev = video_drvdata(file);
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 
-	if (dev->streaming_users > 0)
+	if (v4l2->streaming_users > 0)
 		return -EBUSY;
 
 	vidioc_try_fmt_vid_cap(file, priv, f);
@@ -1384,7 +1387,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 	if (norm == v4l2->norm)
 		return 0;
 
-	if (dev->streaming_users > 0)
+	if (v4l2->streaming_users > 0)
 		return -EBUSY;
 
 	v4l2->norm = norm;
@@ -1907,7 +1910,7 @@ static int em28xx_v4l2_open(struct file *filp)
 
 	em28xx_videodbg("open dev=%s type=%s users=%d\n",
 			video_device_node_name(vdev), v4l2_type_names[fh_type],
-			dev->users);
+			v4l2->users);
 
 	if (mutex_lock_interruptible(&dev->lock))
 		return -ERESTARTSYS;
@@ -1922,7 +1925,7 @@ static int em28xx_v4l2_open(struct file *filp)
 	fh->type = fh_type;
 	filp->private_data = fh;
 
-	if (dev->users == 0) {
+	if (v4l2->users == 0) {
 		em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
 
 		if (vdev->vfl_type != VFL_TYPE_RADIO)
@@ -1942,7 +1945,7 @@ static int em28xx_v4l2_open(struct file *filp)
 
 	kref_get(&dev->ref);
 	kref_get(&v4l2->ref);
-	dev->users++;
+	v4l2->users++;
 
 	mutex_unlock(&dev->lock);
 	v4l2_fh_add(&fh->fh);
@@ -2051,12 +2054,12 @@ static int em28xx_v4l2_close(struct file *filp)
 	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 	int              errCode;
 
-	em28xx_videodbg("users=%d\n", dev->users);
+	em28xx_videodbg("users=%d\n", v4l2->users);
 
 	vb2_fop_release(filp);
 	mutex_lock(&dev->lock);
 
-	if (dev->users == 1) {
+	if (v4l2->users == 1) {
 		/* No sense to try to write to the device */
 		if (dev->disconnected)
 			goto exit;
@@ -2078,8 +2081,8 @@ static int em28xx_v4l2_close(struct file *filp)
 	}
 
 exit:
+	v4l2->users--;
 	kref_put(&v4l2->ref, em28xx_free_v4l2);
-	dev->users--;
 	mutex_unlock(&dev->lock);
 	kref_put(&dev->ref, em28xx_free_device);
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 91bb624..0585217 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -523,6 +523,9 @@ struct em28xx_v4l2 {
 	int sensor_yres;
 	int sensor_xtal;
 
+	int users;		/* user count for exclusive use */
+	int streaming_users;    /* number of actively streaming users */
+
 	struct em28xx_fmt *format;
 	v4l2_std_id norm;	/* selected tv norm */
 
@@ -641,8 +644,6 @@ struct em28xx {
 	struct rt_mutex i2c_bus_lock;
 
 	/* video for linux */
-	int users;		/* user count for exclusive use */
-	int streaming_users;    /* Number of actively streaming users */
 	int ctl_freq;		/* selected frequency */
 	unsigned int ctl_input;	/* selected input */
 	unsigned int ctl_ainput;/* selected audio input */
-- 
1.8.4.5

