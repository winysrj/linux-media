Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:35504 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbaCXTcy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:32:54 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so4905159eei.28
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:32:53 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 03/19] em28xx: start moving em28xx-v4l specific data to its own struct
Date: Mon, 24 Mar 2014 20:33:09 +0100
Message-Id: <1395689605-2705-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c |   4 +-
 drivers/media/usb/em28xx/em28xx-video.c  | 160 +++++++++++++++++++++----------
 drivers/media/usb/em28xx/em28xx.h        |   8 +-
 3 files changed, 116 insertions(+), 56 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 505e050..daebef3 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -365,7 +365,7 @@ int em28xx_init_camera(struct em28xx *dev)
 		dev->sensor_xtal = 4300000;
 		pdata.xtal = dev->sensor_xtal;
 		if (NULL ==
-		    v4l2_i2c_new_subdev_board(&dev->v4l2_dev, adap,
+		    v4l2_i2c_new_subdev_board(&dev->v4l2->v4l2_dev, adap,
 					      &mt9v011_info, NULL)) {
 			ret = -ENODEV;
 			break;
@@ -422,7 +422,7 @@ int em28xx_init_camera(struct em28xx *dev)
 		dev->sensor_yres = 480;
 
 		subdev =
-		     v4l2_i2c_new_subdev_board(&dev->v4l2_dev, adap,
+		     v4l2_i2c_new_subdev_board(&dev->v4l2->v4l2_dev, adap,
 					       &ov2640_info, NULL);
 		if (NULL == subdev) {
 			ret = -ENODEV;
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 45ad471..89947db 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -189,10 +189,11 @@ static int em28xx_vbi_supported(struct em28xx *dev)
  */
 static void em28xx_wake_i2c(struct em28xx *dev)
 {
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core,  reset, 0);
-	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
+	struct v4l2_device *v4l2_dev = &dev->v4l2->v4l2_dev;
+	v4l2_device_call_all(v4l2_dev, 0, core,  reset, 0);
+	v4l2_device_call_all(v4l2_dev, 0, video, s_routing,
 			INPUT(dev->ctl_input)->vmux, 0, 0);
-	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
+	v4l2_device_call_all(v4l2_dev, 0, video, s_stream, 0);
 }
 
 static int em28xx_colorlevels_set_default(struct em28xx *dev)
@@ -952,7 +953,8 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 			f.type = V4L2_TUNER_RADIO;
 		else
 			f.type = V4L2_TUNER_ANALOG_TV;
-		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
+		v4l2_device_call_all(&dev->v4l2->v4l2_dev,
+				     0, tuner, s_frequency, &f);
 	}
 
 	dev->streaming_users++;
@@ -1083,6 +1085,7 @@ static int em28xx_vb2_setup(struct em28xx *dev)
 
 static void video_mux(struct em28xx *dev, int index)
 {
+	struct v4l2_device *v4l2_dev = &dev->v4l2->v4l2_dev;
 	dev->ctl_input = index;
 	dev->ctl_ainput = INPUT(index)->amux;
 	dev->ctl_aoutput = INPUT(index)->aout;
@@ -1090,21 +1093,21 @@ static void video_mux(struct em28xx *dev, int index)
 	if (!dev->ctl_aoutput)
 		dev->ctl_aoutput = EM28XX_AOUT_MASTER;
 
-	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
+	v4l2_device_call_all(v4l2_dev, 0, video, s_routing,
 			INPUT(index)->vmux, 0, 0);
 
 	if (dev->board.has_msp34xx) {
 		if (dev->i2s_speed) {
-			v4l2_device_call_all(&dev->v4l2_dev, 0, audio,
+			v4l2_device_call_all(v4l2_dev, 0, audio,
 				s_i2s_clock_freq, dev->i2s_speed);
 		}
 		/* Note: this is msp3400 specific */
-		v4l2_device_call_all(&dev->v4l2_dev, 0, audio, s_routing,
+		v4l2_device_call_all(v4l2_dev, 0, audio, s_routing,
 			 dev->ctl_ainput, MSP_OUTPUT(MSP_SC_IN_DSP_SCART1), 0);
 	}
 
 	if (dev->board.adecoder != EM28XX_NOADECODER) {
-		v4l2_device_call_all(&dev->v4l2_dev, 0, audio, s_routing,
+		v4l2_device_call_all(v4l2_dev, 0, audio, s_routing,
 			dev->ctl_ainput, dev->ctl_aoutput, 0);
 	}
 
@@ -1344,7 +1347,7 @@ static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
 	struct em28xx_fh   *fh  = priv;
 	struct em28xx      *dev = fh->dev;
 
-	v4l2_device_call_all(&dev->v4l2_dev, 0, video, querystd, norm);
+	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, video, querystd, norm);
 
 	return 0;
 }
@@ -1374,7 +1377,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 	size_to_scale(dev, dev->width, dev->height, &dev->hscale, &dev->vscale);
 
 	em28xx_resolution_set(dev);
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
+	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, core, s_std, dev->norm);
 
 	return 0;
 }
@@ -1388,7 +1391,7 @@ static int vidioc_g_parm(struct file *file, void *priv,
 
 	p->parm.capture.readbuffers = EM28XX_MIN_BUF;
 	if (dev->board.is_webcam)
-		rc = v4l2_device_call_until_err(&dev->v4l2_dev, 0,
+		rc = v4l2_device_call_until_err(&dev->v4l2->v4l2_dev, 0,
 						video, g_parm, p);
 	else
 		v4l2_video_std_frame_period(dev->norm,
@@ -1404,7 +1407,8 @@ static int vidioc_s_parm(struct file *file, void *priv,
 	struct em28xx      *dev = fh->dev;
 
 	p->parm.capture.readbuffers = EM28XX_MIN_BUF;
-	return v4l2_device_call_until_err(&dev->v4l2_dev, 0, video, s_parm, p);
+	return v4l2_device_call_until_err(&dev->v4l2->v4l2_dev,
+					  0, video, s_parm, p);
 }
 
 static const char *iname[] = {
@@ -1543,7 +1547,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 
 	strcpy(t->name, "Tuner");
 
-	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner, t);
+	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, tuner, g_tuner, t);
 	return 0;
 }
 
@@ -1556,7 +1560,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	if (0 != t->index)
 		return -EINVAL;
 
-	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_tuner, t);
+	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, tuner, s_tuner, t);
 	return 0;
 }
 
@@ -1576,15 +1580,16 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 static int vidioc_s_frequency(struct file *file, void *priv,
 				const struct v4l2_frequency *f)
 {
-	struct v4l2_frequency new_freq = *f;
-	struct em28xx_fh      *fh  = priv;
-	struct em28xx         *dev = fh->dev;
+	struct v4l2_frequency  new_freq = *f;
+	struct em28xx_fh          *fh   = priv;
+	struct em28xx             *dev  = fh->dev;
+	struct em28xx_v4l2        *v4l2 = dev->v4l2;
 
 	if (0 != f->tuner)
 		return -EINVAL;
 
-	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, f);
-	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_frequency, &new_freq);
+	v4l2_device_call_all(&v4l2->v4l2_dev, 0, tuner, s_frequency, f);
+	v4l2_device_call_all(&v4l2->v4l2_dev, 0, tuner, g_frequency, &new_freq);
 	dev->ctl_freq = new_freq.frequency;
 
 	return 0;
@@ -1602,7 +1607,8 @@ static int vidioc_g_chip_info(struct file *file, void *priv,
 	if (chip->match.addr == 1)
 		strlcpy(chip->name, "ac97", sizeof(chip->name));
 	else
-		strlcpy(chip->name, dev->v4l2_dev.name, sizeof(chip->name));
+		strlcpy(chip->name,
+			dev->v4l2->v4l2_dev.name, sizeof(chip->name));
 	return 0;
 }
 
@@ -1814,7 +1820,7 @@ static int radio_g_tuner(struct file *file, void *priv,
 
 	strcpy(t->name, "Radio");
 
-	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner, t);
+	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, tuner, g_tuner, t);
 
 	return 0;
 }
@@ -1827,12 +1833,26 @@ static int radio_s_tuner(struct file *file, void *priv,
 	if (0 != t->index)
 		return -EINVAL;
 
-	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_tuner, t);
+	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, tuner, s_tuner, t);
 
 	return 0;
 }
 
 /*
+ * em28xx_free_v4l2() - Free struct em28xx_v4l2
+ *
+ * @ref: struct kref for struct em28xx_v4l2
+ *
+ * Called when all users of struct em28xx_v4l2 are gone
+ */
+void em28xx_free_v4l2(struct kref *ref)
+{
+	struct em28xx_v4l2 *v4l2 = container_of(ref, struct em28xx_v4l2, ref);
+
+	kfree(v4l2);
+}
+
+/*
  * em28xx_v4l2_open()
  * inits the device and starts isoc transfer
  */
@@ -1840,6 +1860,7 @@ static int em28xx_v4l2_open(struct file *filp)
 {
 	struct video_device *vdev = video_devdata(filp);
 	struct em28xx *dev = video_drvdata(filp);
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	enum v4l2_buf_type fh_type = 0;
 	struct em28xx_fh *fh;
 
@@ -1888,10 +1909,11 @@ static int em28xx_v4l2_open(struct file *filp)
 
 	if (vdev->vfl_type == VFL_TYPE_RADIO) {
 		em28xx_videodbg("video_open: setting radio device\n");
-		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_radio);
+		v4l2_device_call_all(&v4l2->v4l2_dev, 0, tuner, s_radio);
 	}
 
 	kref_get(&dev->ref);
+	kref_get(&v4l2->ref);
 	dev->users++;
 
 	mutex_unlock(&dev->lock);
@@ -1907,6 +1929,8 @@ static int em28xx_v4l2_open(struct file *filp)
 */
 static int em28xx_v4l2_fini(struct em28xx *dev)
 {
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
+
 	if (dev->is_audio_only) {
 		/* Shouldn't initialize IR for this interface */
 		return 0;
@@ -1917,11 +1941,14 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 		return 0;
 	}
 
+	if (v4l2 == NULL)
+		return 0;
+
 	em28xx_info("Closing video extension");
 
 	mutex_lock(&dev->lock);
 
-	v4l2_device_disconnect(&dev->v4l2_dev);
+	v4l2_device_disconnect(&v4l2->v4l2_dev);
 
 	em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
 
@@ -1942,14 +1969,17 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 	}
 
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
-	v4l2_device_unregister(&dev->v4l2_dev);
+	v4l2_device_unregister(&v4l2->v4l2_dev);
 
 	if (dev->clk) {
 		v4l2_clk_unregister_fixed(dev->clk);
 		dev->clk = NULL;
 	}
 
+	kref_put(&v4l2->ref, em28xx_free_v4l2);
+
 	mutex_unlock(&dev->lock);
+
 	kref_put(&dev->ref, em28xx_free_device);
 
 	return 0;
@@ -1988,8 +2018,9 @@ static int em28xx_v4l2_resume(struct em28xx *dev)
  */
 static int em28xx_v4l2_close(struct file *filp)
 {
-	struct em28xx_fh *fh  = filp->private_data;
-	struct em28xx    *dev = fh->dev;
+	struct em28xx_fh      *fh   = filp->private_data;
+	struct em28xx         *dev  = fh->dev;
+	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 	int              errCode;
 
 	em28xx_videodbg("users=%d\n", dev->users);
@@ -2003,7 +2034,7 @@ static int em28xx_v4l2_close(struct file *filp)
 			goto exit;
 
 		/* Save some power by putting tuner to sleep */
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
+		v4l2_device_call_all(&v4l2->v4l2_dev, 0, core, s_power, 0);
 
 		/* do this before setting alternate! */
 		em28xx_set_mode(dev, EM28XX_SUSPEND);
@@ -2019,6 +2050,7 @@ static int em28xx_v4l2_close(struct file *filp)
 	}
 
 exit:
+	kref_put(&v4l2->ref, em28xx_free_v4l2);
 	dev->users--;
 	mutex_unlock(&dev->lock);
 	kref_put(&dev->ref, em28xx_free_device);
@@ -2162,7 +2194,7 @@ static struct video_device *em28xx_vdev_init(struct em28xx *dev,
 		return NULL;
 
 	*vfd		= *template;
-	vfd->v4l2_dev	= &dev->v4l2_dev;
+	vfd->v4l2_dev	= &dev->v4l2->v4l2_dev;
 	vfd->debug	= video_debug;
 	vfd->lock	= &dev->lock;
 	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
@@ -2178,6 +2210,7 @@ static struct video_device *em28xx_vdev_init(struct em28xx *dev,
 
 static void em28xx_tuner_setup(struct em28xx *dev)
 {
+	struct v4l2_device *v4l2_dev = &dev->v4l2->v4l2_dev;
 	struct tuner_setup           tun_setup;
 	struct v4l2_frequency        f;
 
@@ -2193,14 +2226,16 @@ static void em28xx_tuner_setup(struct em28xx *dev)
 		tun_setup.type = dev->board.radio.type;
 		tun_setup.addr = dev->board.radio_addr;
 
-		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_type_addr, &tun_setup);
+		v4l2_device_call_all(v4l2_dev,
+				     0, tuner, s_type_addr, &tun_setup);
 	}
 
 	if ((dev->tuner_type != TUNER_ABSENT) && (dev->tuner_type)) {
 		tun_setup.type   = dev->tuner_type;
 		tun_setup.addr   = dev->tuner_addr;
 
-		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_type_addr, &tun_setup);
+		v4l2_device_call_all(v4l2_dev,
+				     0, tuner, s_type_addr, &tun_setup);
 	}
 
 	if (dev->tda9887_conf) {
@@ -2209,7 +2244,8 @@ static void em28xx_tuner_setup(struct em28xx *dev)
 		tda9887_cfg.tuner = TUNER_TDA9887;
 		tda9887_cfg.priv = &dev->tda9887_conf;
 
-		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_config, &tda9887_cfg);
+		v4l2_device_call_all(v4l2_dev,
+				     0, tuner, s_config, &tda9887_cfg);
 	}
 
 	if (dev->tuner_type == TUNER_XC2028) {
@@ -2224,7 +2260,7 @@ static void em28xx_tuner_setup(struct em28xx *dev)
 		xc2028_cfg.tuner = TUNER_XC2028;
 		xc2028_cfg.priv  = &ctl;
 
-		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_config, &xc2028_cfg);
+		v4l2_device_call_all(v4l2_dev, 0, tuner, s_config, &xc2028_cfg);
 	}
 
 	/* configure tuner */
@@ -2232,7 +2268,7 @@ static void em28xx_tuner_setup(struct em28xx *dev)
 	f.type = V4L2_TUNER_ANALOG_TV;
 	f.frequency = 9076;     /* just a magic number */
 	dev->ctl_freq = f.frequency;
-	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
+	v4l2_device_call_all(v4l2_dev, 0, tuner, s_frequency, &f);
 }
 
 static int em28xx_v4l2_init(struct em28xx *dev)
@@ -2241,6 +2277,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	int ret;
 	unsigned int maxw;
 	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
+	struct em28xx_v4l2 *v4l2;
 
 	if (dev->is_audio_only) {
 		/* Shouldn't initialize IR for this interface */
@@ -2256,14 +2293,23 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 
 	mutex_lock(&dev->lock);
 
-	ret = v4l2_device_register(&dev->udev->dev, &dev->v4l2_dev);
+	v4l2 = kzalloc(sizeof(struct em28xx_v4l2), GFP_KERNEL);
+	if (v4l2 == NULL) {
+		em28xx_info("em28xx_v4l: memory allocation failed\n");
+		mutex_unlock(&dev->lock);
+		return -ENOMEM;
+	}
+	kref_init(&v4l2->ref);
+	dev->v4l2 = v4l2;
+
+	ret = v4l2_device_register(&dev->udev->dev, &v4l2->v4l2_dev);
 	if (ret < 0) {
 		em28xx_errdev("Call to v4l2_device_register() failed!\n");
 		goto err;
 	}
 
 	v4l2_ctrl_handler_init(hdl, 8);
-	dev->v4l2_dev.ctrl_handler = hdl;
+	v4l2->v4l2_dev.ctrl_handler = hdl;
 
 	/*
 	 * Default format, used for tvp5150 or saa711x output formats
@@ -2275,20 +2321,24 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/* request some modules */
 
 	if (dev->board.has_msp34xx)
-		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-			"msp3400", 0, msp3400_addrs);
+		v4l2_i2c_new_subdev(&v4l2->v4l2_dev,
+				    &dev->i2c_adap[dev->def_i2c_bus],
+				    "msp3400", 0, msp3400_addrs);
 
 	if (dev->board.decoder == EM28XX_SAA711X)
-		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-			"saa7115_auto", 0, saa711x_addrs);
+		v4l2_i2c_new_subdev(&v4l2->v4l2_dev,
+				    &dev->i2c_adap[dev->def_i2c_bus],
+				    "saa7115_auto", 0, saa711x_addrs);
 
 	if (dev->board.decoder == EM28XX_TVP5150)
-		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-			"tvp5150", 0, tvp5150_addrs);
+		v4l2_i2c_new_subdev(&v4l2->v4l2_dev,
+				    &dev->i2c_adap[dev->def_i2c_bus],
+				    "tvp5150", 0, tvp5150_addrs);
 
 	if (dev->board.adecoder == EM28XX_TVAUDIO)
-		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-			"tvaudio", dev->board.tvaudio_addr, NULL);
+		v4l2_i2c_new_subdev(&v4l2->v4l2_dev,
+				    &dev->i2c_adap[dev->def_i2c_bus],
+				    "tvaudio", dev->board.tvaudio_addr, NULL);
 
 	/* Initialize tuner and camera */
 
@@ -2296,11 +2346,12 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		int has_demod = (dev->tda9887_conf & TDA9887_PRESENT);
 
 		if (dev->board.radio.type)
-			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-				"tuner", dev->board.radio_addr, NULL);
+			v4l2_i2c_new_subdev(&v4l2->v4l2_dev,
+					  &dev->i2c_adap[dev->def_i2c_bus],
+					  "tuner", dev->board.radio_addr, NULL);
 
 		if (has_demod)
-			v4l2_i2c_new_subdev(&dev->v4l2_dev,
+			v4l2_i2c_new_subdev(&v4l2->v4l2_dev,
 				&dev->i2c_adap[dev->def_i2c_bus], "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
 		if (dev->tuner_addr == 0) {
@@ -2308,15 +2359,16 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 				has_demod ? ADDRS_TV_WITH_DEMOD : ADDRS_TV;
 			struct v4l2_subdev *sd;
 
-			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
+			sd = v4l2_i2c_new_subdev(&v4l2->v4l2_dev,
 				&dev->i2c_adap[dev->def_i2c_bus], "tuner",
 				0, v4l2_i2c_tuner_addrs(type));
 
 			if (sd)
 				dev->tuner_addr = v4l2_i2c_subdev_addr(sd);
 		} else {
-			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-				"tuner", dev->tuner_addr, NULL);
+			v4l2_i2c_new_subdev(&v4l2->v4l2_dev,
+					    &dev->i2c_adap[dev->def_i2c_bus],
+					    "tuner", dev->tuner_addr, NULL);
 		}
 	}
 
@@ -2372,7 +2424,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 
 	/* set default norm */
 	dev->norm = V4L2_STD_PAL;
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
+	v4l2_device_call_all(&v4l2->v4l2_dev, 0, core, s_std, dev->norm);
 	dev->interlaced = EM28XX_INTERLACED_DEFAULT;
 
 	/* Analog specific initialization */
@@ -2529,7 +2581,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 			    video_device_node_name(dev->vbi_dev));
 
 	/* Save some power by putting tuner to sleep */
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
+	v4l2_device_call_all(&v4l2->v4l2_dev, 0, core, s_power, 0);
 
 	/* initialize videobuf2 stuff */
 	em28xx_vb2_setup(dev);
@@ -2543,8 +2595,10 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 
 unregister_dev:
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
-	v4l2_device_unregister(&dev->v4l2_dev);
+	v4l2_device_unregister(&v4l2->v4l2_dev);
 err:
+	dev->v4l2 = NULL;
+	kref_put(&v4l2->ref, em28xx_free_v4l2);
 	mutex_unlock(&dev->lock);
 	return ret;
 }
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 9a3c496..b18b968 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -497,6 +497,12 @@ struct em28xx_eeprom {
 #define EM28XX_RESOURCE_VIDEO 0x01
 #define EM28XX_RESOURCE_VBI   0x02
 
+struct em28xx_v4l2 {
+	struct kref ref;
+
+	struct v4l2_device v4l2_dev;
+};
+
 struct em28xx_audio {
 	char name[50];
 	unsigned num_urb;
@@ -542,6 +548,7 @@ struct em28xx {
 	struct kref ref;
 
 	/* Sub-module data */
+	struct em28xx_v4l2 *v4l2;
 	struct em28xx_dvb *dvb;
 	struct em28xx_audio adev;
 	struct em28xx_IR *ir;
@@ -559,7 +566,6 @@ struct em28xx {
 	unsigned int has_alsa_audio:1;
 	unsigned int is_audio_only:1;
 
-	struct v4l2_device v4l2_dev;
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_clk *clk;
 	struct em28xx_board board;
-- 
1.8.4.5

