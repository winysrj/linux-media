Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:34485 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbZJENtE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2009 09:49:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH] v4l2_subdev: rename tuner s_standby operation to core s_power
Date: Mon,  5 Oct 2009 15:48:17 +0200
Message-Id: <1254750497-13684-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Upcoming I2C v4l2_subdev drivers need a way to control the subdevice
power state from the core. This use case is already partially covered by
the tuner s_standby operation, but no way to explicitly come back from
the standby state is available.

Rename the tuner s_standby operation to core s_power, and fix tuner
drivers accordingly. The tuner core will call s_power(0) instead of
s_standby(). No explicit call to s_power(1) is required for tuners as
they are supposed to wake up from standby automatically.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/au0828/au0828-video.c   |    2 +-
 drivers/media/video/cx231xx/cx231xx-video.c |    2 +-
 drivers/media/video/cx23885/cx23885-core.c  |    2 +-
 drivers/media/video/cx23885/cx23885-dvb.c   |    2 +-
 drivers/media/video/cx88/cx88-cards.c       |    2 +-
 drivers/media/video/cx88/cx88-dvb.c         |    2 +-
 drivers/media/video/cx88/cx88-video.c       |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c   |    2 +-
 drivers/media/video/em28xx/em28xx-video.c   |    2 +-
 drivers/media/video/saa7134/saa7134-core.c  |    2 +-
 drivers/media/video/saa7134/saa7134-video.c |    2 +-
 drivers/media/video/tuner-core.c            |    9 ++++++---
 include/media/v4l2-subdev.h                 |    7 ++++---
 13 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index 51527d7..1485aee 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -830,7 +830,7 @@ static int au0828_v4l2_close(struct file *filp)
 		au0828_uninit_isoc(dev);
 
 		/* Save some power by putting tuner to sleep */
-		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_standby);
+		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
 
 		/* When close the device, set the usb intf0 into alt0 to free
 		   USB bandwidth */
diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
index 609bae6..1d57972 100644
--- a/drivers/media/video/cx231xx/cx231xx-video.c
+++ b/drivers/media/video/cx231xx/cx231xx-video.c
@@ -2106,7 +2106,7 @@ static int cx231xx_v4l2_close(struct file *filp)
 		}
 
 		/* Save some power by putting tuner to sleep */
-		call_all(dev, tuner, s_standby);
+		call_all(dev, core, s_power, 0);
 
 		/* do this before setting alternate! */
 		cx231xx_uninit_isoc(dev);
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index bf7bb1c..c46bae2 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -875,7 +875,7 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	cx23885_i2c_register(&dev->i2c_bus[1]);
 	cx23885_i2c_register(&dev->i2c_bus[2]);
 	cx23885_card_setup(dev);
-	call_all(dev, tuner, s_standby);
+	call_all(dev, core, s_power, 0);
 	cx23885_ir_init(dev);
 
 	if (cx23885_boards[dev->board].porta == CX23885_ANALOG_VIDEO) {
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index 86ac529..a003a3c 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -848,7 +848,7 @@ static int dvb_register(struct cx23885_tsport *port)
 	fe0->dvb.frontend->callback = cx23885_tuner_callback;
 
 	/* Put the analog decoder in standby to keep it quiet */
-	call_all(dev, tuner, s_standby);
+	call_all(dev, core, s_power, 0);
 
 	if (fe0->dvb.frontend->ops.analog_ops.standby)
 		fe0->dvb.frontend->ops.analog_ops.standby(fe0->dvb.frontend);
diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
index 3946530..9e1656c 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -3213,7 +3213,7 @@ static void cx88_card_setup(struct cx88_core *core)
 			    ctl.fname);
 		call_all(core, tuner, s_config, &xc2028_cfg);
 	}
-	call_all(core, tuner, s_standby);
+	call_all(core, core, s_power, 0);
 }
 
 /* ------------------------------------------------------------------ */
diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
index e237b50..dd2769b 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -1170,7 +1170,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		fe1->dvb.frontend->ops.ts_bus_ctrl = cx88_dvb_bus_ctrl;
 
 	/* Put the analog decoder in standby to keep it quiet */
-	call_all(core, tuner, s_standby);
+	call_all(core, core, s_power, 0);
 
 	/* register everything */
 	return videobuf_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 2bb54c3..a57afa0 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -935,7 +935,7 @@ static int video_release(struct file *file)
 
 	mutex_lock(&dev->core->lock);
 	if(atomic_dec_and_test(&dev->core->users))
-		call_all(dev->core, tuner, s_standby);
+		call_all(dev->core, core, s_power, 0);
 	mutex_unlock(&dev->core->lock);
 
 	return 0;
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index ed281f5..af469da 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2566,7 +2566,7 @@ static int em28xx_init_dev(struct em28xx **devhandle, struct usb_device *udev,
 	em28xx_init_extension(dev);
 
 	/* Save some power by putting tuner to sleep */
-	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_standby);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
 
 	return 0;
 
diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index ab079d9..042ab43 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -1800,7 +1800,7 @@ static int em28xx_v4l2_close(struct file *filp)
 		}
 
 		/* Save some power by putting tuner to sleep */
-		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_standby);
+		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
 
 		/* do this before setting alternate! */
 		em28xx_uninit_isoc(dev);
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 94a023a..22afe8d 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -1030,7 +1030,7 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 	saa7134_irq_video_signalchange(dev);
 
 	if (TUNER_ABSENT != dev->tuner_type)
-		saa_call_all(dev, tuner, s_standby);
+		saa_call_all(dev, core, s_power, 0);
 
 	/* register v4l devices */
 	if (saa7134_no_overlay > 0)
diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index ba87128..abd135e 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -1500,7 +1500,7 @@ static int video_release(struct file *file)
 	saa_andorb(SAA7134_OFMT_DATA_A, 0x1f, 0);
 	saa_andorb(SAA7134_OFMT_DATA_B, 0x1f, 0);
 
-	saa_call_all(dev, tuner, s_standby);
+	saa_call_all(dev, core, s_power, 0);
 	if (fh->radio)
 		saa_call_all(dev, core, ioctl, RDS_CMD_CLOSE, &cmd);
 
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 5375942..89049ca 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -740,14 +740,17 @@ static int tuner_s_radio(struct v4l2_subdev *sd)
 	return 0;
 }
 
-static int tuner_s_standby(struct v4l2_subdev *sd)
+static int tuner_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct tuner *t = to_tuner(sd);
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 
+	if (on)
+	    return 0;
+
 	tuner_dbg("Putting tuner to sleep\n");
 
-	if (check_mode(t, "s_standby") == -EINVAL)
+	if (check_mode(t, "s_power") == -EINVAL)
 		return 0;
 	t->mode = T_STANDBY;
 	if (analog_ops->standby)
@@ -949,6 +952,7 @@ static int tuner_command(struct i2c_client *client, unsigned cmd, void *arg)
 static const struct v4l2_subdev_core_ops tuner_core_ops = {
 	.log_status = tuner_log_status,
 	.s_std = tuner_s_std,
+	.s_power = tuner_s_power,
 };
 
 static const struct v4l2_subdev_tuner_ops tuner_tuner_ops = {
@@ -959,7 +963,6 @@ static const struct v4l2_subdev_tuner_ops tuner_tuner_ops = {
 	.g_frequency = tuner_g_frequency,
 	.s_type_addr = tuner_s_type_addr,
 	.s_config = tuner_s_config,
-	.s_standby = tuner_s_standby,
 };
 
 static const struct v4l2_subdev_ops tuner_ops = {
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 5dcb367..3e16bfd 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -96,6 +96,9 @@ struct v4l2_decode_vbi_line {
 
    s_gpio: set GPIO pins. Very simple right now, might need to be extended with
 	a direction argument if needed.
+
+   s_power: puts subdevice in power saving mode (on == 0) or normal operation
+   	mode (on == 1).
  */
 struct v4l2_subdev_core_ops {
 	int (*g_chip_ident)(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip);
@@ -118,6 +121,7 @@ struct v4l2_subdev_core_ops {
 	int (*g_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg);
 	int (*s_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg);
 #endif
+	int (*s_power)(struct v4l2_subdev *sd, int on);
 };
 
 /* s_mode: switch the tuner to a specific tuner mode. Replacement of s_radio.
@@ -127,8 +131,6 @@ struct v4l2_subdev_core_ops {
    s_type_addr: sets tuner type and its I2C addr.
 
    s_config: sets tda9887 specific stuff, like port1, port2 and qss
-
-   s_standby: puts tuner on powersaving state, disabling it, except for i2c.
  */
 struct v4l2_subdev_tuner_ops {
 	int (*s_mode)(struct v4l2_subdev *sd, enum v4l2_tuner_type);
@@ -139,7 +141,6 @@ struct v4l2_subdev_tuner_ops {
 	int (*s_tuner)(struct v4l2_subdev *sd, struct v4l2_tuner *vt);
 	int (*s_type_addr)(struct v4l2_subdev *sd, struct tuner_setup *type);
 	int (*s_config)(struct v4l2_subdev *sd, const struct v4l2_priv_tun_config *config);
-	int (*s_standby)(struct v4l2_subdev *sd);
 };
 
 /* s_clock_freq: set the frequency (in Hz) of the audio clock output.
-- 
1.6.4.4

