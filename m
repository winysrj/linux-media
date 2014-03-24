Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:43642 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaCXTdA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:33:00 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so4795709eek.18
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:32:59 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 07/19] em28xx: move videobuf2 related data from struct em28xx to struct v4l2
Date: Mon, 24 Mar 2014 20:33:13 +0100
Message-Id: <1395689605-2705-8-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |  2 --
 drivers/media/usb/em28xx/em28xx-video.c | 15 +++++++++------
 drivers/media/usb/em28xx/em28xx.h       | 12 ++++++------
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index ff19833..a21cce1 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2991,8 +2991,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	const char *chip_name = default_chip_name;
 
 	dev->udev = udev;
-	mutex_init(&dev->vb_queue_lock);
-	mutex_init(&dev->vb_vbi_queue_lock);
 	mutex_init(&dev->ctrl_urb_lock);
 	spin_lock_init(&dev->slock);
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 7252eef..301acef 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1049,9 +1049,10 @@ static int em28xx_vb2_setup(struct em28xx *dev)
 {
 	int rc;
 	struct vb2_queue *q;
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 
 	/* Setup Videobuf2 for Video capture */
-	q = &dev->vb_vidq;
+	q = &v4l2->vb_vidq;
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
@@ -1065,7 +1066,7 @@ static int em28xx_vb2_setup(struct em28xx *dev)
 		return rc;
 
 	/* Setup Videobuf2 for VBI capture */
-	q = &dev->vb_vbiq;
+	q = &v4l2->vb_vbiq;
 	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
 	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
@@ -2483,8 +2484,10 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		ret = -ENODEV;
 		goto unregister_dev;
 	}
-	v4l2->vdev->queue = &dev->vb_vidq;
-	v4l2->vdev->queue->lock = &dev->vb_queue_lock;
+	mutex_init(&v4l2->vb_queue_lock);
+	mutex_init(&v4l2->vb_vbi_queue_lock);
+	v4l2->vdev->queue = &v4l2->vb_vidq;
+	v4l2->vdev->queue->lock = &v4l2->vb_queue_lock;
 
 	/* disable inapplicable ioctls */
 	if (dev->board.is_webcam) {
@@ -2519,8 +2522,8 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		v4l2->vbi_dev = em28xx_vdev_init(dev, &em28xx_video_template,
 						"vbi");
 
-		v4l2->vbi_dev->queue = &dev->vb_vbiq;
-		v4l2->vbi_dev->queue->lock = &dev->vb_vbi_queue_lock;
+		v4l2->vbi_dev->queue = &v4l2->vb_vbiq;
+		v4l2->vbi_dev->queue->lock = &v4l2->vb_vbi_queue_lock;
 
 		/* disable inapplicable ioctls */
 		v4l2_disable_ioctl(v4l2->vdev, VIDIOC_S_PARM);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 88d0589..b02e8b1 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -508,6 +508,12 @@ struct em28xx_v4l2 {
 	struct video_device *vdev;
 	struct video_device *vbi_dev;
 	struct video_device *radio_dev;
+
+	/* Videobuf2 */
+	struct vb2_queue vb_vidq;
+	struct vb2_queue vb_vbiq;
+	struct mutex vb_queue_lock;
+	struct mutex vb_vbi_queue_lock;
 };
 
 struct em28xx_audio {
@@ -649,12 +655,6 @@ struct em28xx {
 	struct mutex lock;
 	struct mutex ctrl_urb_lock;	/* protects urb_buf */
 
-	/* Videobuf2 */
-	struct vb2_queue vb_vidq;
-	struct vb2_queue vb_vbiq;
-	struct mutex vb_queue_lock;
-	struct mutex vb_vbi_queue_lock;
-
 	/* resources in use */
 	unsigned int resources;
 
-- 
1.8.4.5

