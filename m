Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42486 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752679AbeCBTe6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 14:34:58 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/8] media: em28xx: stop rewriting device's struct
Date: Fri,  2 Mar 2018 16:34:44 -0300
Message-Id: <7f4a0cb2c8af515cf4c3a374db4af6ca49469acb.1520018558.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520018558.git.mchehab@s-opensource.com>
References: <cover.1520018558.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520018558.git.mchehab@s-opensource.com>
References: <cover.1520018558.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Writing at the device's struct is evil, as two em28xx devices
may be using it. So, stop abusing it, storing the values
inside struct em28xx_dev.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 12 +++++++-----
 drivers/media/usb/em28xx/em28xx-core.c  |  4 ++--
 drivers/media/usb/em28xx/em28xx-video.c | 24 ++++++++++++------------
 drivers/media/usb/em28xx/em28xx.h       |  2 ++
 4 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index cbd7a43bd559..91c2198c8a2c 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2696,6 +2696,8 @@ static inline void em28xx_set_xclk_i2c_speed(struct em28xx *dev)
 static inline void em28xx_set_model(struct em28xx *dev)
 {
 	dev->board = em28xx_boards[dev->model];
+	dev->has_msp34xx = dev->board.has_msp34xx;
+	dev->is_webcam = dev->board.is_webcam;
 
 	em28xx_set_xclk_i2c_speed(dev);
 
@@ -2855,7 +2857,7 @@ static int em28xx_hint_board(struct em28xx *dev)
 {
 	int i;
 
-	if (dev->board.is_webcam) {
+	if (dev->is_webcam) {
 		if (dev->em28xx_sensor == EM28XX_MT9V011) {
 			dev->model = EM2820_BOARD_SILVERCREST_WEBCAM;
 		} else if (dev->em28xx_sensor == EM28XX_MT9M001 ||
@@ -2947,11 +2949,11 @@ static void em28xx_card_setup(struct em28xx *dev)
 	 * If the device can be a webcam, seek for a sensor.
 	 * If sensor is not found, then it isn't a webcam.
 	 */
-	if (dev->board.is_webcam) {
+	if (dev->is_webcam) {
 		em28xx_detect_sensor(dev);
 		if (dev->em28xx_sensor == EM28XX_NOSENSOR)
 			/* NOTE: error/unknown sensor/no sensor */
-			dev->board.is_webcam = 0;
+			dev->is_webcam = 0;
 	}
 
 	switch (dev->model) {
@@ -3013,7 +3015,7 @@ static void em28xx_card_setup(struct em28xx *dev)
 
 		if (tv.audio_processor == TVEEPROM_AUDPROC_MSP) {
 			dev->i2s_speed = 2048000;
-			dev->board.has_msp34xx = 1;
+			dev->has_msp34xx = 1;
 		}
 		break;
 	}
@@ -3679,7 +3681,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	}
 
 	if (usb_xfer_mode < 0) {
-		if (dev->board.is_webcam)
+		if (dev->is_webcam)
 			try_bulk = 1;
 		else
 			try_bulk = 0;
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 932ab93a05a6..92c99b0320b3 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -378,7 +378,7 @@ static int em28xx_set_audio_source(struct em28xx *dev)
 			return ret;
 	}
 
-	if (dev->board.has_msp34xx)
+	if (dev->has_msp34xx)
 		input = EM28XX_AUDIO_SRC_TUNER;
 	else {
 		switch (dev->ctl_ainput) {
@@ -651,7 +651,7 @@ int em28xx_capture_start(struct em28xx *dev, int start)
 			return rc;
 
 		if (start) {
-			if (dev->board.is_webcam)
+			if (dev->is_webcam)
 				rc = em28xx_write_reg(dev, 0x13, 0x0c);
 
 			/* Enable video capture */
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index a2ba2d905952..407850d9cae0 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -148,7 +148,7 @@ static inline unsigned int norm_maxw(struct em28xx *dev)
 {
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 
-	if (dev->board.is_webcam)
+	if (dev->is_webcam)
 		return v4l2->sensor_xres;
 
 	if (dev->board.max_range_640_480)
@@ -161,7 +161,7 @@ static inline unsigned int norm_maxh(struct em28xx *dev)
 {
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 
-	if (dev->board.is_webcam)
+	if (dev->is_webcam)
 		return v4l2->sensor_yres;
 
 	if (dev->board.max_range_640_480)
@@ -176,7 +176,7 @@ static int em28xx_vbi_supported(struct em28xx *dev)
 	if (disable_vbi == 1)
 		return 0;
 
-	if (dev->board.is_webcam)
+	if (dev->is_webcam)
 		return 0;
 
 	/* FIXME: check subdevices for VBI support */
@@ -976,7 +976,7 @@ static void em28xx_v4l2_create_entities(struct em28xx *dev)
 	}
 
 	/* Webcams don't have input connectors */
-	if (dev->board.is_webcam)
+	if (dev->is_webcam)
 		return;
 
 	/* Create entities for each input connector */
@@ -1277,7 +1277,7 @@ static void video_mux(struct em28xx *dev, int index)
 	v4l2_device_call_all(v4l2_dev, 0, video, s_routing,
 			     INPUT(index)->vmux, 0, 0);
 
-	if (dev->board.has_msp34xx) {
+	if (dev->has_msp34xx) {
 		if (dev->i2s_speed) {
 			v4l2_device_call_all(v4l2_dev, 0, audio,
 					     s_i2s_clock_freq, dev->i2s_speed);
@@ -1587,7 +1587,7 @@ static int vidioc_g_parm(struct file *file, void *priv,
 	int rc = 0;
 
 	p->parm.capture.readbuffers = EM28XX_MIN_BUF;
-	if (dev->board.is_webcam)
+	if (dev->is_webcam)
 		rc = v4l2_device_call_until_err(&v4l2->v4l2_dev, 0,
 						video, g_parm, p);
 	else
@@ -1629,7 +1629,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 
 	i->std = dev->v4l2->vdev.tvnorms;
 	/* webcams do not have the STD API */
-	if (dev->board.is_webcam)
+	if (dev->is_webcam)
 		i->capabilities = 0;
 
 	return 0;
@@ -2343,7 +2343,7 @@ static void em28xx_vdev_init(struct em28xx *dev,
 	*vfd		= *template;
 	vfd->v4l2_dev	= &dev->v4l2->v4l2_dev;
 	vfd->lock	= &dev->lock;
-	if (dev->board.is_webcam)
+	if (dev->is_webcam)
 		vfd->tvnorms = 0;
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s",
@@ -2458,7 +2458,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	v4l2_ctrl_handler_init(hdl, 8);
 	v4l2->v4l2_dev.ctrl_handler = hdl;
 
-	if (dev->board.is_webcam)
+	if (dev->is_webcam)
 		v4l2->progressive = true;
 
 	/*
@@ -2470,7 +2470,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 
 	/* request some modules */
 
-	if (dev->board.has_msp34xx)
+	if (dev->has_msp34xx)
 		v4l2_i2c_new_subdev(&v4l2->v4l2_dev,
 				    &dev->i2c_adap[dev->def_i2c_bus],
 				    "msp3400", 0, msp3400_addrs);
@@ -2559,7 +2559,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	INIT_LIST_HEAD(&dev->vidq.active);
 	INIT_LIST_HEAD(&dev->vbiq.active);
 
-	if (dev->board.has_msp34xx) {
+	if (dev->has_msp34xx) {
 		/* Send a reset to other chips via gpio */
 		ret = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xf7);
 		if (ret < 0) {
@@ -2653,7 +2653,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	v4l2->vdev.queue->lock = &v4l2->vb_queue_lock;
 
 	/* disable inapplicable ioctls */
-	if (dev->board.is_webcam) {
+	if (dev->is_webcam) {
 		v4l2_disable_ioctl(&v4l2->vdev, VIDIOC_QUERYSTD);
 		v4l2_disable_ioctl(&v4l2->vdev, VIDIOC_G_STD);
 		v4l2_disable_ioctl(&v4l2->vdev, VIDIOC_S_STD);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index bd6eaf642662..d64de57769f0 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -619,6 +619,8 @@ struct em28xx {
 	unsigned char disconnected:1;	/* device has been diconnected */
 	unsigned int has_video:1;
 	unsigned int is_audio_only:1;
+	unsigned int is_webcam:1;
+	unsigned int has_msp34xx:1;
 	enum em28xx_int_audio_type int_audio_type;
 	enum em28xx_usb_audio_type usb_audio_type;
 
-- 
2.14.3
