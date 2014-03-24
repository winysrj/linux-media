Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:58641 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbaCXTdN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:33:13 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so4842798eek.34
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:33:12 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 16/19] em28xx: move tuner frequency field from struct em28xx to struct v4l2
Date: Mon, 24 Mar 2014 20:33:22 +0100
Message-Id: <1395689605-2705-17-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 16 +++++++++-------
 drivers/media/usb/em28xx/em28xx.h       |  3 ++-
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index aaab111..35bf2b9 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -963,7 +963,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 
 		/* Ask tuner to go to analog or radio mode */
 		memset(&f, 0, sizeof(f));
-		f.frequency = dev->ctl_freq;
+		f.frequency = v4l2->frequency;
 		if (vq->owner && vq->owner->vdev->vfl_type == VFL_TYPE_RADIO)
 			f.type = V4L2_TUNER_RADIO;
 		else
@@ -1597,11 +1597,12 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 {
 	struct em28xx_fh      *fh  = priv;
 	struct em28xx         *dev = fh->dev;
+	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 
 	if (0 != f->tuner)
 		return -EINVAL;
 
-	f->frequency = dev->ctl_freq;
+	f->frequency = v4l2->frequency;
 	return 0;
 }
 
@@ -1618,7 +1619,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 
 	v4l2_device_call_all(&v4l2->v4l2_dev, 0, tuner, s_frequency, f);
 	v4l2_device_call_all(&v4l2->v4l2_dev, 0, tuner, g_frequency, &new_freq);
-	dev->ctl_freq = new_freq.frequency;
+	v4l2->frequency = new_freq.frequency;
 
 	return 0;
 }
@@ -2224,9 +2225,10 @@ static struct video_device *em28xx_vdev_init(struct em28xx *dev,
 
 static void em28xx_tuner_setup(struct em28xx *dev)
 {
-	struct v4l2_device *v4l2_dev = &dev->v4l2->v4l2_dev;
-	struct tuner_setup           tun_setup;
-	struct v4l2_frequency        f;
+	struct em28xx_v4l2      *v4l2 = dev->v4l2;
+	struct v4l2_device      *v4l2_dev = &v4l2->v4l2_dev;
+	struct tuner_setup      tun_setup;
+	struct v4l2_frequency   f;
 
 	if (dev->tuner_type == TUNER_ABSENT)
 		return;
@@ -2281,7 +2283,7 @@ static void em28xx_tuner_setup(struct em28xx *dev)
 	f.tuner = 0;
 	f.type = V4L2_TUNER_ANALOG_TV;
 	f.frequency = 9076;     /* just a magic number */
-	dev->ctl_freq = f.frequency;
+	v4l2->frequency = f.frequency;
 	v4l2_device_call_all(v4l2_dev, 0, tuner, s_frequency, &f);
 }
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 0585217..8a0ed93 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -526,6 +526,8 @@ struct em28xx_v4l2 {
 	int users;		/* user count for exclusive use */
 	int streaming_users;    /* number of actively streaming users */
 
+	u32 frequency;		/* selected tuner frequency */
+
 	struct em28xx_fmt *format;
 	v4l2_std_id norm;	/* selected tv norm */
 
@@ -644,7 +646,6 @@ struct em28xx {
 	struct rt_mutex i2c_bus_lock;
 
 	/* video for linux */
-	int ctl_freq;		/* selected frequency */
 	unsigned int ctl_input;	/* selected input */
 	unsigned int ctl_ainput;/* selected audio input */
 	unsigned int ctl_aoutput;/* selected audio output */
-- 
1.8.4.5

