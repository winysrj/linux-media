Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1558 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3CKLrL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:47:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 35/42] go7007: embed struct video_device
Date: Mon, 11 Mar 2013 12:46:13 +0100
Message-Id: <fe6722eb052a3246ae8f24d7ddfd21fdf581223c.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Do not allocate it, but just embed in the go7007 struct.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-driver.c  |    1 -
 drivers/staging/media/go7007/go7007-priv.h    |    2 +-
 drivers/staging/media/go7007/go7007-usb.c     |    2 +-
 drivers/staging/media/go7007/go7007-v4l2.c    |   56 ++++++++++---------------
 drivers/staging/media/go7007/saa7134-go7007.c |    2 +-
 5 files changed, 26 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index 075de4d..0fd3f10 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -639,7 +639,6 @@ struct go7007 *go7007_alloc(struct go7007_board_info *board, struct device *dev)
 	mutex_init(&go->hw_lock);
 	init_waitqueue_head(&go->frame_waitq);
 	spin_lock_init(&go->spinlock);
-	go->video_dev = NULL;
 	go->status = STATUS_INIT;
 	memset(&go->i2c_adapter, 0, sizeof(go->i2c_adapter));
 	go->i2c_adapter_online = 0;
diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index 30148eb..0914fa3 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -156,7 +156,7 @@ struct go7007 {
 	int tuner_type;
 	int channel_number; /* for multi-channel boards like Adlink PCI-MPG24 */
 	char name[64];
-	struct video_device *video_dev;
+	struct video_device vdev;
 	void *boot_fw;
 	unsigned boot_fw_len;
 	struct v4l2_device v4l2_dev;
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index c95538c..2a1cda2 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1324,7 +1324,7 @@ static void go7007_usb_disconnect(struct usb_interface *intf)
 
 	go->status = STATUS_SHUTDOWN;
 	v4l2_device_disconnect(&go->v4l2_dev);
-	video_unregister_device(go->video_dev);
+	video_unregister_device(&go->vdev);
 	mutex_unlock(&go->serialize_lock);
 	mutex_unlock(&go->queue_lock);
 
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 46db491..2e5bc02 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -967,11 +967,6 @@ static int vidioc_s_crop(struct file *file, void *priv, const struct v4l2_crop *
 	}
 #endif
 
-static void go7007_vfl_release(struct video_device *vfd)
-{
-	video_device_release(vfd);
-}
-
 static struct v4l2_file_operations go7007_fops = {
 	.owner		= THIS_MODULE,
 	.open		= v4l2_fh_open,
@@ -1022,7 +1017,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 static struct video_device go7007_template = {
 	.name		= "go7007",
 	.fops		= &go7007_fops,
-	.release	= go7007_vfl_release,
+	.release	= video_device_release_empty,
 	.ioctl_ops	= &video_ioctl_ops,
 	.tvnorms	= V4L2_STD_ALL,
 };
@@ -1062,6 +1057,7 @@ int go7007_v4l2_ctrl_init(struct go7007 *go)
 
 int go7007_v4l2_init(struct go7007 *go)
 {
+	struct video_device *vdev = &go->vdev;
 	int rv;
 
 	mutex_init(&go->serialize_lock);
@@ -1079,22 +1075,19 @@ int go7007_v4l2_init(struct go7007 *go)
 	rv = vb2_queue_init(&go->vidq);
 	if (rv)
 		return rv;
-	go->video_dev = video_device_alloc();
-	if (go->video_dev == NULL)
-		return -ENOMEM;
-	*go->video_dev = go7007_template;
-	go->video_dev->lock = &go->serialize_lock;
-	go->video_dev->queue = &go->vidq;
-	set_bit(V4L2_FL_USE_FH_PRIO, &go->video_dev->flags);
-	video_set_drvdata(go->video_dev, go);
-	go->video_dev->v4l2_dev = &go->v4l2_dev;
+	*vdev = go7007_template;
+	vdev->lock = &go->serialize_lock;
+	vdev->queue = &go->vidq;
+	set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
+	video_set_drvdata(vdev, go);
+	vdev->v4l2_dev = &go->v4l2_dev;
 	if (!v4l2_device_has_op(&go->v4l2_dev, video, querystd))
-		v4l2_disable_ioctl(go->video_dev, VIDIOC_QUERYSTD);
+		v4l2_disable_ioctl(vdev, VIDIOC_QUERYSTD);
 	if (!(go->board_info->flags & GO7007_BOARD_HAS_TUNER)) {
-		v4l2_disable_ioctl(go->video_dev, VIDIOC_S_FREQUENCY);
-		v4l2_disable_ioctl(go->video_dev, VIDIOC_G_FREQUENCY);
-		v4l2_disable_ioctl(go->video_dev, VIDIOC_S_TUNER);
-		v4l2_disable_ioctl(go->video_dev, VIDIOC_G_TUNER);
+		v4l2_disable_ioctl(vdev, VIDIOC_S_FREQUENCY);
+		v4l2_disable_ioctl(vdev, VIDIOC_G_FREQUENCY);
+		v4l2_disable_ioctl(vdev, VIDIOC_S_TUNER);
+		v4l2_disable_ioctl(vdev, VIDIOC_G_TUNER);
 	} else {
 		struct v4l2_frequency f = {
 			.type = V4L2_TUNER_ANALOG_TV,
@@ -1104,16 +1097,16 @@ int go7007_v4l2_init(struct go7007 *go)
 		call_all(&go->v4l2_dev, tuner, s_frequency, &f);
 	}
 	if (!(go->board_info->sensor_flags & GO7007_SENSOR_TV)) {
-		v4l2_disable_ioctl(go->video_dev, VIDIOC_G_STD);
-		v4l2_disable_ioctl(go->video_dev, VIDIOC_S_STD);
-		go->video_dev->tvnorms = 0;
+		v4l2_disable_ioctl(vdev, VIDIOC_G_STD);
+		v4l2_disable_ioctl(vdev, VIDIOC_S_STD);
+		vdev->tvnorms = 0;
 	}
 	if (go->board_info->sensor_flags & GO7007_SENSOR_SCALING)
-		v4l2_disable_ioctl(go->video_dev, VIDIOC_ENUM_FRAMESIZES);
+		v4l2_disable_ioctl(vdev, VIDIOC_ENUM_FRAMESIZES);
 	if (go->board_info->num_aud_inputs == 0) {
-		v4l2_disable_ioctl(go->video_dev, VIDIOC_G_AUDIO);
-		v4l2_disable_ioctl(go->video_dev, VIDIOC_S_AUDIO);
-		v4l2_disable_ioctl(go->video_dev, VIDIOC_ENUMAUDIO);
+		v4l2_disable_ioctl(vdev, VIDIOC_G_AUDIO);
+		v4l2_disable_ioctl(vdev, VIDIOC_S_AUDIO);
+		v4l2_disable_ioctl(vdev, VIDIOC_ENUMAUDIO);
 	}
 	/* Setup correct crystal frequency on this board */
 	if (go->board_info->sensor_flags & GO7007_SENSOR_SAA7115)
@@ -1124,14 +1117,11 @@ int go7007_v4l2_init(struct go7007 *go)
 	go7007_s_input(go);
 	if (go->board_info->sensor_flags & GO7007_SENSOR_TV)
 		go7007_s_std(go);
-	rv = video_register_device(go->video_dev, VFL_TYPE_GRABBER, -1);
-	if (rv < 0) {
-		video_device_release(go->video_dev);
-		go->video_dev = NULL;
+	rv = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+	if (rv < 0)
 		return rv;
-	}
 	dev_info(go->dev, "registered device %s [v4l2]\n",
-		 video_device_node_name(go->video_dev));
+		 video_device_node_name(vdev));
 
 	return 0;
 }
diff --git a/drivers/staging/media/go7007/saa7134-go7007.c b/drivers/staging/media/go7007/saa7134-go7007.c
index fa9de3c..752f1bd 100644
--- a/drivers/staging/media/go7007/saa7134-go7007.c
+++ b/drivers/staging/media/go7007/saa7134-go7007.c
@@ -471,7 +471,7 @@ static int saa7134_go7007_init(struct saa7134_dev *dev)
 	 * V4L2 and ALSA interfaces */
 	if (go7007_register_encoder(go, go->board_info->num_i2c_devs) < 0)
 		goto initfail;
-	dev->empress_dev = go->video_dev;
+	dev->empress_dev = &go->vdev;
 	video_set_drvdata(dev->empress_dev, go);
 
 	go->status = STATUS_ONLINE;
-- 
1.7.10.4

