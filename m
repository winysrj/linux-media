Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:53077 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750740AbeBUHta (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 02:49:30 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv3] media: add tuner standby op, use where needed
Message-ID: <78d2c189-cbe4-18ea-7839-e3cc95eb1aba@xs4all.nl>
Date: Wed, 21 Feb 2018 08:49:25 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_subdev core s_power op was used for two different things: power on/off
sensors or video decoders/encoders and to put a tuner in standby (and only the
tuner!). There is no 'tuner wakeup' op, that's done automatically when the tuner
is accessed.

The danger with calling (s_power, 0) to put a tuner into standby is that it is
usually broadcast for all subdevs. So a video receiver subdev that supports
s_power will also be powered off, and since there is no corresponding (s_power, 1)
they will never be powered on again.

In addition, this is specifically meant for tuners only since they draw the most
current.

This patch adds a new tuner op called 'standby' and replaces all calls to
(core, s_power, 0) by (tuner, standby). This prevents confusion between the two
uses of s_power. Note that there is no overlap: bridge drivers either just want
to put the tuner into standby, or they deal with powering on/off sensors. Never
both.

This also makes it easier to replace s_power for the remaining bridge drivers
with some PM code later.

Whether we want something cleaner for tuners in the future is a separate topic.
There is a lot of legacy code surrounding tuners, and I am very hesitant about
making changes there.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Changes since v2:
- update the tuner_standby documentation
Changes since v1:
- move the standby op to the tuner_ops, which makes much more sense.
---
 drivers/media/pci/cx23885/cx23885-core.c  |  2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c   |  4 ++--
 drivers/media/pci/cx88/cx88-cards.c       |  2 +-
 drivers/media/pci/cx88/cx88-dvb.c         |  4 ++--
 drivers/media/pci/saa7134/saa7134-video.c |  2 +-
 drivers/media/tuners/e4000.c              | 15 +++------------
 drivers/media/tuners/fc2580.c             | 16 +++-------------
 drivers/media/tuners/msi001.c             | 19 +++----------------
 drivers/media/usb/au0828/au0828-video.c   |  4 ++--
 drivers/media/usb/cx231xx/cx231xx-video.c |  2 +-
 drivers/media/usb/em28xx/em28xx-video.c   |  4 ++--
 drivers/media/v4l2-core/tuner-core.c      | 15 +++------------
 include/media/v4l2-subdev.h               |  4 ++++
 13 files changed, 28 insertions(+), 65 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 8f63df1cb418..b8394cdf030b 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -965,7 +965,7 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	cx23885_i2c_register(&dev->i2c_bus[1]);
 	cx23885_i2c_register(&dev->i2c_bus[2]);
 	cx23885_card_setup(dev);
-	call_all(dev, core, s_power, 0);
+	call_all(dev, tuner, standby);
 	cx23885_ir_init(dev);

 	if (dev->board == CX23885_BOARD_VIEWCAST_460E) {
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 700422b538c0..ba5429877d1f 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -2514,8 +2514,8 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe1->dvb.frontend->ops.ts_bus_ctrl = cx23885_dvb_bus_ctrl;
 #endif

-	/* Put the analog decoder in standby to keep it quiet */
-	call_all(dev, core, s_power, 0);
+	/* Put the tuner in standby to keep it quiet */
+	call_all(dev, tuner, standby);

 	if (fe0->dvb.frontend->ops.analog_ops.standby)
 		fe0->dvb.frontend->ops.analog_ops.standby(fe0->dvb.frontend);
diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index 6df21b29ea17..4c92d2388c26 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -3592,7 +3592,7 @@ static void cx88_card_setup(struct cx88_core *core)
 			ctl.fname);
 		call_all(core, tuner, s_config, &xc2028_cfg);
 	}
-	call_all(core, core, s_power, 0);
+	call_all(core, tuner, standby);
 }

 /* ------------------------------------------------------------------ */
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index 49a335f4603e..3abef0b106be 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -1631,8 +1631,8 @@ static int dvb_register(struct cx8802_dev *dev)
 	if (fe1)
 		fe1->dvb.frontend->ops.ts_bus_ctrl = cx88_dvb_bus_ctrl;

-	/* Put the analog decoder in standby to keep it quiet */
-	call_all(core, core, s_power, 0);
+	/* Put the tuner in standby to keep it quiet */
+	call_all(core, tuner, standby);

 	/* register everything */
 	res = vb2_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 1ca6a32ad10e..4f1091a11e91 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1200,7 +1200,7 @@ static int video_release(struct file *file)
 	saa_andorb(SAA7134_OFMT_DATA_A, 0x1f, 0);
 	saa_andorb(SAA7134_OFMT_DATA_B, 0x1f, 0);

-	saa_call_all(dev, core, s_power, 0);
+	saa_call_all(dev, tuner, standby);
 	if (vdev->vfl_type == VFL_TYPE_RADIO)
 		saa_call_all(dev, core, ioctl, SAA6588_CMD_CLOSE, &cmd);
 	mutex_unlock(&dev->lock);
diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 564a000f503e..a17d4853ad40 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -293,28 +293,19 @@ static inline struct e4000_dev *e4000_subdev_to_dev(struct v4l2_subdev *sd)
 	return container_of(sd, struct e4000_dev, sd);
 }

-static int e4000_s_power(struct v4l2_subdev *sd, int on)
+static int e4000_standby(struct v4l2_subdev *sd)
 {
 	struct e4000_dev *dev = e4000_subdev_to_dev(sd);
 	struct i2c_client *client = dev->client;
 	int ret;

-	dev_dbg(&client->dev, "on=%d\n", on);
-
-	if (on)
-		ret = e4000_init(dev);
-	else
-		ret = e4000_sleep(dev);
+	ret = e4000_sleep(dev);
 	if (ret)
 		return ret;

 	return e4000_set_params(dev);
 }

-static const struct v4l2_subdev_core_ops e4000_subdev_core_ops = {
-	.s_power                  = e4000_s_power,
-};
-
 static int e4000_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
 {
 	struct e4000_dev *dev = e4000_subdev_to_dev(sd);
@@ -382,6 +373,7 @@ static int e4000_enum_freq_bands(struct v4l2_subdev *sd,
 }

 static const struct v4l2_subdev_tuner_ops e4000_subdev_tuner_ops = {
+	.standby                  = e4000_standby,
 	.g_tuner                  = e4000_g_tuner,
 	.s_tuner                  = e4000_s_tuner,
 	.g_frequency              = e4000_g_frequency,
@@ -390,7 +382,6 @@ static const struct v4l2_subdev_tuner_ops e4000_subdev_tuner_ops = {
 };

 static const struct v4l2_subdev_ops e4000_subdev_ops = {
-	.core                     = &e4000_subdev_core_ops,
 	.tuner                    = &e4000_subdev_tuner_ops,
 };

diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index f4d4665de168..743184ae0d26 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -386,28 +386,18 @@ static inline struct fc2580_dev *fc2580_subdev_to_dev(struct v4l2_subdev *sd)
 	return container_of(sd, struct fc2580_dev, subdev);
 }

-static int fc2580_s_power(struct v4l2_subdev *sd, int on)
+static int fc2580_standby(struct v4l2_subdev *sd)
 {
 	struct fc2580_dev *dev = fc2580_subdev_to_dev(sd);
-	struct i2c_client *client = dev->client;
 	int ret;

-	dev_dbg(&client->dev, "on=%d\n", on);
-
-	if (on)
-		ret = fc2580_init(dev);
-	else
-		ret = fc2580_sleep(dev);
+	ret = fc2580_sleep(dev);
 	if (ret)
 		return ret;

 	return fc2580_set_params(dev);
 }

-static const struct v4l2_subdev_core_ops fc2580_subdev_core_ops = {
-	.s_power                  = fc2580_s_power,
-};
-
 static int fc2580_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
 {
 	struct fc2580_dev *dev = fc2580_subdev_to_dev(sd);
@@ -475,6 +465,7 @@ static int fc2580_enum_freq_bands(struct v4l2_subdev *sd,
 }

 static const struct v4l2_subdev_tuner_ops fc2580_subdev_tuner_ops = {
+	.standby                  = fc2580_standby,
 	.g_tuner                  = fc2580_g_tuner,
 	.s_tuner                  = fc2580_s_tuner,
 	.g_frequency              = fc2580_g_frequency,
@@ -483,7 +474,6 @@ static const struct v4l2_subdev_tuner_ops fc2580_subdev_tuner_ops = {
 };

 static const struct v4l2_subdev_ops fc2580_subdev_ops = {
-	.core                     = &fc2580_subdev_core_ops,
 	.tuner                    = &fc2580_subdev_tuner_ops,
 };

diff --git a/drivers/media/tuners/msi001.c b/drivers/media/tuners/msi001.c
index 3a12ef35682b..5de6ed728708 100644
--- a/drivers/media/tuners/msi001.c
+++ b/drivers/media/tuners/msi001.c
@@ -291,26 +291,13 @@ static int msi001_set_tuner(struct msi001_dev *dev)
 	return ret;
 }

-static int msi001_s_power(struct v4l2_subdev *sd, int on)
+static int msi001_standby(struct v4l2_subdev *sd)
 {
 	struct msi001_dev *dev = sd_to_msi001_dev(sd);
-	struct spi_device *spi = dev->spi;
-	int ret;
-
-	dev_dbg(&spi->dev, "on=%d\n", on);
-
-	if (on)
-		ret = 0;
-	else
-		ret = msi001_wreg(dev, 0x000000);

-	return ret;
+	return msi001_wreg(dev, 0x000000);
 }

-static const struct v4l2_subdev_core_ops msi001_core_ops = {
-	.s_power                  = msi001_s_power,
-};
-
 static int msi001_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
 {
 	struct msi001_dev *dev = sd_to_msi001_dev(sd);
@@ -386,6 +373,7 @@ static int msi001_enum_freq_bands(struct v4l2_subdev *sd,
 }

 static const struct v4l2_subdev_tuner_ops msi001_tuner_ops = {
+	.standby                  = msi001_standby,
 	.g_tuner                  = msi001_g_tuner,
 	.s_tuner                  = msi001_s_tuner,
 	.g_frequency              = msi001_g_frequency,
@@ -394,7 +382,6 @@ static const struct v4l2_subdev_tuner_ops msi001_tuner_ops = {
 };

 static const struct v4l2_subdev_ops msi001_ops = {
-	.core                     = &msi001_core_ops,
 	.tuner                    = &msi001_tuner_ops,
 };

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index c765d546114d..964cd7bcdd2c 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1091,8 +1091,8 @@ static int au0828_v4l2_close(struct file *filp)
 		*/
 		ret = v4l_enable_media_source(vdev);
 		if (ret == 0)
-			v4l2_device_call_all(&dev->v4l2_dev, 0, core,
-					     s_power, 0);
+			v4l2_device_call_all(&dev->v4l2_dev, 0, tuner,
+					     standby);
 		dev->std_set_in_tuner_core = 0;

 		/* When close the device, set the usb intf0 into alt0 to free
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 5b321b8ada3a..f7fcd733a2ca 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1941,7 +1941,7 @@ static int cx231xx_close(struct file *filp)
 		}

 		/* Save some power by putting tuner to sleep */
-		call_all(dev, core, s_power, 0);
+		call_all(dev, tuner, standby);

 		/* do this before setting alternate! */
 		if (dev->USE_ISO)
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index a2ba2d905952..058162012e2d 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2202,7 +2202,7 @@ static int em28xx_v4l2_close(struct file *filp)
 			goto exit;

 		/* Save some power by putting tuner to sleep */
-		v4l2_device_call_all(&v4l2->v4l2_dev, 0, core, s_power, 0);
+		v4l2_device_call_all(&v4l2->v4l2_dev, 0, tuner, standby);

 		/* do this before setting alternate! */
 		em28xx_set_mode(dev, EM28XX_SUSPEND);
@@ -2749,7 +2749,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 			 video_device_node_name(&v4l2->vbi_dev));

 	/* Save some power by putting tuner to sleep */
-	v4l2_device_call_all(&v4l2->v4l2_dev, 0, core, s_power, 0);
+	v4l2_device_call_all(&v4l2->v4l2_dev, 0, tuner, standby);

 	/* initialize videobuf2 stuff */
 	em28xx_vb2_setup(dev);
diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 82852f23a3b6..7f858c39753c 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -1099,23 +1099,14 @@ static int tuner_s_radio(struct v4l2_subdev *sd)
  */

 /**
- * tuner_s_power - controls the power state of the tuner
+ * tuner_standby - places the tuner in standby mode
  * @sd: pointer to struct v4l2_subdev
- * @on: a zero value puts the tuner to sleep, non-zero wakes it up
  */
-static int tuner_s_power(struct v4l2_subdev *sd, int on)
+static int tuner_standby(struct v4l2_subdev *sd)
 {
 	struct tuner *t = to_tuner(sd);
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;

-	if (on) {
-		if (t->standby && set_mode(t, t->mode) == 0) {
-			dprintk("Waking up tuner\n");
-			set_freq(t, 0);
-		}
-		return 0;
-	}
-
 	dprintk("Putting tuner to sleep\n");
 	t->standby = true;
 	if (analog_ops->standby)
@@ -1328,10 +1319,10 @@ static int tuner_command(struct i2c_client *client, unsigned cmd, void *arg)

 static const struct v4l2_subdev_core_ops tuner_core_ops = {
 	.log_status = tuner_log_status,
-	.s_power = tuner_s_power,
 };

 static const struct v4l2_subdev_tuner_ops tuner_tuner_ops = {
+	.standby = tuner_standby,
 	.s_radio = tuner_s_radio,
 	.g_tuner = tuner_g_tuner,
 	.s_tuner = tuner_s_tuner,
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 980a86c08fce..62429cd89620 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -224,6 +224,9 @@ struct v4l2_subdev_core_ops {
  * struct v4l2_subdev_tuner_ops - Callbacks used when v4l device was opened
  *	in radio mode.
  *
+ * @standby: puts the tuner in standby mode. It will be woken up
+ *	     automatically the next time it is used.
+ *
  * @s_radio: callback that switches the tuner to radio mode.
  *	     drivers should explicitly call it when a tuner ops should
  *	     operate on radio mode, before being able to handle it.
@@ -268,6 +271,7 @@ struct v4l2_subdev_core_ops {
  *	  }
  */
 struct v4l2_subdev_tuner_ops {
+	int (*standby)(struct v4l2_subdev *sd);
 	int (*s_radio)(struct v4l2_subdev *sd);
 	int (*s_frequency)(struct v4l2_subdev *sd, const struct v4l2_frequency *freq);
 	int (*g_frequency)(struct v4l2_subdev *sd, struct v4l2_frequency *freq);
-- 
2.15.1
