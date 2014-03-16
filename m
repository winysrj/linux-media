Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56474 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaCPV4d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Mar 2014 17:56:33 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH] e4000: make VIDEO_V4L2 dependency optional
Date: Sun, 16 Mar 2014 23:56:26 +0200
Message-Id: <1395006986-5233-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That tuner driver is mainly for DVB API, but there is some V4L2 API
controls for SDR usage. Make driver compile conditional so that V4L2
is not mandatory. Without the V4L2 support driver is build as a DVB
only, without SDR controls.

Fixes following errors reported by kbuild test robot:
ERROR: "v4l2_ctrl_auto_cluster" [drivers/media/tuners/e4000.ko] undefined!
ERROR: "v4l2_ctrl_new_std" [drivers/media/tuners/e4000.ko] undefined!
ERROR: "v4l2_ctrl_handler_init_class" [drivers/media/tuners/e4000.ko] undefined!
ERROR: "v4l2_ctrl_handler_free" [drivers/media/tuners/e4000.ko] undefined!

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/Kconfig | 2 +-
 drivers/media/tuners/e4000.c | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index 85c0d96..a128488 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -203,7 +203,7 @@ config MEDIA_TUNER_TDA18212
 
 config MEDIA_TUNER_E4000
 	tristate "Elonics E4000 silicon tuner"
-	depends on MEDIA_SUPPORT && I2C && VIDEO_V4L2
+	depends on MEDIA_SUPPORT && I2C
 	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 67ecf1b..90d9334 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -269,6 +269,7 @@ static int e4000_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_VIDEO_V4L2)
 static int e4000_set_lna_gain(struct dvb_frontend *fe)
 {
 	struct e4000 *s = fe->tuner_priv;
@@ -456,6 +457,7 @@ static const struct v4l2_ctrl_ops e4000_ctrl_ops = {
 	.g_volatile_ctrl = e4000_g_volatile_ctrl,
 	.s_ctrl = e4000_s_ctrl,
 };
+#endif
 
 static const struct dvb_tuner_ops e4000_tuner_ops = {
 	.info = {
@@ -522,6 +524,7 @@ static int e4000_probe(struct i2c_client *client,
 	if (ret)
 		goto err;
 
+#if IS_ENABLED(CONFIG_VIDEO_V4L2)
 	/* Register controls */
 	v4l2_ctrl_handler_init(&s->hdl, 9);
 	s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, &e4000_ctrl_ops,
@@ -554,6 +557,7 @@ static int e4000_probe(struct i2c_client *client,
 	}
 
 	s->sd.ctrl_handler = &s->hdl;
+#endif
 
 	dev_info(&s->client->dev,
 			"%s: Elonics E4000 successfully identified\n",
@@ -584,7 +588,9 @@ static int e4000_remove(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "%s:\n", __func__);
 
+#if IS_ENABLED(CONFIG_VIDEO_V4L2)
 	v4l2_ctrl_handler_free(&s->hdl);
+#endif
 	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = NULL;
 	kfree(s);
-- 
1.8.5.3

