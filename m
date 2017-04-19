Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59241
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1762654AbdDSLud (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 07:50:33 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] ov2640: make GPIOLIB an optional dependency
Date: Wed, 19 Apr 2017 08:49:54 -0300
Message-Id: <a463ea990d2138ca93027b006be96a0324b77fe4.1492602584.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by kbuild test robot:
	warning: (VIDEO_EM28XX_V4L2) selects VIDEO_OV2640 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_V4L2 && I2C && GPIOLIB && MEDIA_CAMERA_SUPPORT)

The em28xx driver can use ov2640, but it doesn't depend
(or use) the GPIOLIB in order to power off/on the sensor.

So, as we want to allow both usages with and without
GPIOLIB, make its dependency optional.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/Kconfig  | 2 +-
 drivers/media/i2c/ov2640.c | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 40bb4bdc51da..fd181c99ce11 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -519,7 +519,7 @@ config VIDEO_SMIAPP_PLL
 
 config VIDEO_OV2640
 	tristate "OmniVision OV2640 sensor support"
-	depends on VIDEO_V4L2 && I2C && GPIOLIB
+	depends on VIDEO_V4L2 && I2C
 	depends on MEDIA_CAMERA_SUPPORT
 	help
 	  This is a Video4Linux2 sensor-level driver for the OmniVision
diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index d55ca37dc12f..9c00ed3543f8 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -743,13 +743,16 @@ static int ov2640_s_power(struct v4l2_subdev *sd, int on)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov2640_priv *priv = to_ov2640(client);
 
-	gpiod_direction_output(priv->pwdn_gpio, !on);
+#ifdef CONFIG_GPIOLIB
+	if (priv->pwdn_gpio)
+		gpiod_direction_output(priv->pwdn_gpio, !on);
 	if (on && priv->resetb_gpio) {
 		/* Active the resetb pin to perform a reset pulse */
 		gpiod_direction_output(priv->resetb_gpio, 1);
 		usleep_range(3000, 5000);
 		gpiod_direction_output(priv->resetb_gpio, 0);
 	}
+#endif
 	return 0;
 }
 
-- 
2.9.3
