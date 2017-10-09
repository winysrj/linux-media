Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64234 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754091AbdJIKTu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mats Randgaard <matrandg@cisco.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Benoit Parrot <bparrot@ti.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Petr Cvek <petr.cvek@tul.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 04/24] media: v4l2-mediabus: convert flags to enums and document them
Date: Mon,  9 Oct 2017 07:19:10 -0300
Message-Id: <8d351f92fb18148b4d53acdc7f7c8fb0e9f537d9.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a mess with media bus flags: there are two sets of
flags, one used by parallel and ITU-R BT.656 outputs,
and another one for CSI2.

Depending on the type, the same bit has different meanings.

That's very confusing, and counter-intuitive. So, split them
into two sets of flags, inside an enum.

This way, it becomes clearer that there are two separate sets
of flags. It also makes easier if CSI1, CSP, CSI3, etc. would
need a different set of flags.

As a side effect, enums can be documented via kernel-docs,
so there will be an improvement at flags documentation.

Unfortunately, soc_camera and pxa_camera do a mess with
the flags, using either one set of flags without proper
checks about the type. That could be fixed, but, as both drivers
are obsolete and in the process of cleanings, I opted to just
keep the behavior, using an unsigned int inside those two
drivers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/adv7180.c                        |  10 +-
 drivers/media/i2c/ml86v7667.c                      |   5 +-
 drivers/media/i2c/mt9m111.c                        |   8 +-
 drivers/media/i2c/ov6650.c                         |  19 +--
 drivers/media/i2c/soc_camera/imx074.c              |   6 +-
 drivers/media/i2c/soc_camera/mt9m001.c             |  10 +-
 drivers/media/i2c/soc_camera/mt9t031.c             |  11 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |  11 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |  16 ++-
 drivers/media/i2c/soc_camera/ov5642.c              |   5 +-
 drivers/media/i2c/soc_camera/ov772x.c              |  10 +-
 drivers/media/i2c/soc_camera/ov9640.c              |  10 +-
 drivers/media/i2c/soc_camera/ov9740.c              |  10 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |  12 +-
 drivers/media/i2c/soc_camera/tw9910.c              |  13 +-
 drivers/media/i2c/tc358743.c                       |  10 +-
 drivers/media/i2c/tvp5150.c                        |   6 +-
 drivers/media/platform/pxa_camera.c                |   8 +-
 drivers/media/platform/rcar-vin/rcar-core.c        |   4 +-
 drivers/media/platform/rcar-vin/rcar-dma.c         |   4 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   2 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   3 +-
 .../platform/soc_camera/soc_camera_platform.c      |   2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c   |   2 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |   5 +-
 include/media/v4l2-fwnode.h                        |   4 +-
 include/media/v4l2-mediabus.h                      | 144 ++++++++++++++-------
 27 files changed, 217 insertions(+), 133 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 3df28f2f9b38..c220504049de 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -743,16 +743,16 @@ static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
 
 	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
 		cfg->type = V4L2_MBUS_CSI2;
-		cfg->flags = V4L2_MBUS_CSI2_1_LANE |
-				V4L2_MBUS_CSI2_CHANNEL_0 |
-				V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+		cfg->csi2_flags = V4L2_MBUS_CSI2_1_LANE
+				  | V4L2_MBUS_CSI2_CHANNEL_0
+				  | V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
 	} else {
 		/*
 		 * The ADV7180 sensor supports BT.601/656 output modes.
 		 * The BT.656 is default and not yet configurable by s/w.
 		 */
-		cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
-				 V4L2_MBUS_DATA_ACTIVE_HIGH;
+		cfg->pb_flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING
+			        | V4L2_MBUS_DATA_ACTIVE_HIGH;
 		cfg->type = V4L2_MBUS_BT656;
 	}
 
diff --git a/drivers/media/i2c/ml86v7667.c b/drivers/media/i2c/ml86v7667.c
index 57ef901edb06..a25114d0c31f 100644
--- a/drivers/media/i2c/ml86v7667.c
+++ b/drivers/media/i2c/ml86v7667.c
@@ -226,8 +226,9 @@ static int ml86v7667_fill_fmt(struct v4l2_subdev *sd,
 static int ml86v7667_g_mbus_config(struct v4l2_subdev *sd,
 				   struct v4l2_mbus_config *cfg)
 {
-	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
-		     V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->pb_flags = V4L2_MBUS_MASTER
+			| V4L2_MBUS_PCLK_SAMPLE_RISING
+			| V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_BT656;
 
 	return 0;
diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index 99b992e46702..53c406f87aa7 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -857,9 +857,11 @@ static int mt9m111_enum_mbus_code(struct v4l2_subdev *sd,
 static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
-	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
-		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
-		V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->pb_flags = V4L2_MBUS_MASTER
+		        | V4L2_MBUS_PCLK_SAMPLE_RISING
+		        | V4L2_MBUS_HSYNC_ACTIVE_HIGH
+		        | V4L2_MBUS_VSYNC_ACTIVE_HIGH
+		        | V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
 
 	return 0;
diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index 768f2950ea36..9f6ddb804cc1 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -880,11 +880,14 @@ static int ov6650_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 
-	cfg->flags = V4L2_MBUS_MASTER |
-		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING |
-		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_LOW |
-		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW |
-		V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->pb_flags = V4L2_MBUS_MASTER
+			| V4L2_MBUS_PCLK_SAMPLE_RISING
+			| V4L2_MBUS_PCLK_SAMPLE_FALLING
+			| V4L2_MBUS_HSYNC_ACTIVE_HIGH
+			| V4L2_MBUS_HSYNC_ACTIVE_LOW
+			| V4L2_MBUS_VSYNC_ACTIVE_HIGH
+			| V4L2_MBUS_VSYNC_ACTIVE_LOW
+			| V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
 
 	return 0;
@@ -897,21 +900,21 @@ static int ov6650_s_mbus_config(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret;
 
-	if (cfg->flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
+	if (cfg->pb_flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
 		ret = ov6650_reg_rmw(client, REG_COMJ, COMJ_PCLK_RISING, 0);
 	else
 		ret = ov6650_reg_rmw(client, REG_COMJ, 0, COMJ_PCLK_RISING);
 	if (ret)
 		return ret;
 
-	if (cfg->flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
+	if (cfg->pb_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
 		ret = ov6650_reg_rmw(client, REG_COMF, COMF_HREF_LOW, 0);
 	else
 		ret = ov6650_reg_rmw(client, REG_COMF, 0, COMF_HREF_LOW);
 	if (ret)
 		return ret;
 
-	if (cfg->flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
+	if (cfg->pb_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
 		ret = ov6650_reg_rmw(client, REG_COMJ, COMJ_VSYNC_HIGH, 0);
 	else
 		ret = ov6650_reg_rmw(client, REG_COMJ, 0, COMJ_VSYNC_HIGH);
diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index 77f1e0243d6e..f52d64e31975 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -264,9 +264,9 @@ static int imx074_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	cfg->type = V4L2_MBUS_CSI2;
-	cfg->flags = V4L2_MBUS_CSI2_2_LANE |
-		V4L2_MBUS_CSI2_CHANNEL_0 |
-		V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+	cfg->csi2_flags = V4L2_MBUS_CSI2_2_LANE
+			  | V4L2_MBUS_CSI2_CHANNEL_0
+			  | V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
 
 	return 0;
 }
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index 1bfb0d53059e..91545e8160b7 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -603,11 +603,13 @@ static int mt9m001_g_mbus_config(struct v4l2_subdev *sd,
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	/* MT9M001 has all capture_format parameters fixed */
-	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_FALLING |
-		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
-		V4L2_MBUS_DATA_ACTIVE_HIGH | V4L2_MBUS_MASTER;
+	cfg->pb_flags = V4L2_MBUS_PCLK_SAMPLE_FALLING
+		        | V4L2_MBUS_HSYNC_ACTIVE_HIGH
+			| V4L2_MBUS_VSYNC_ACTIVE_HIGH
+			| V4L2_MBUS_DATA_ACTIVE_HIGH
+			| V4L2_MBUS_MASTER;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
+	cfg->pb_flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index 4802d30e47de..c3c531cd5caa 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -704,11 +704,14 @@ static int mt9t031_g_mbus_config(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
-		V4L2_MBUS_PCLK_SAMPLE_FALLING | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
-		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->pb_flags = V4L2_MBUS_MASTER
+			| V4L2_MBUS_PCLK_SAMPLE_RISING
+			| V4L2_MBUS_PCLK_SAMPLE_FALLING
+			| V4L2_MBUS_HSYNC_ACTIVE_HIGH
+			| V4L2_MBUS_VSYNC_ACTIVE_HIGH
+			| V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
+	cfg->pb_flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index 297d22ebcb18..4fa761693872 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -1009,11 +1009,14 @@ static int mt9t112_g_mbus_config(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
-		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_DATA_ACTIVE_HIGH |
-		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING;
+	cfg->pb_flags = V4L2_MBUS_MASTER
+			| V4L2_MBUS_VSYNC_ACTIVE_HIGH
+			| V4L2_MBUS_HSYNC_ACTIVE_HIGH
+			| V4L2_MBUS_DATA_ACTIVE_HIGH
+			| V4L2_MBUS_PCLK_SAMPLE_RISING
+			| V4L2_MBUS_PCLK_SAMPLE_FALLING;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
+	cfg->pb_flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index 762f06919329..8297dfdad4e9 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -798,13 +798,17 @@ static int mt9v022_g_mbus_config(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_SLAVE |
-		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING |
-		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_LOW |
-		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW |
-		V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->pb_flags = V4L2_MBUS_MASTER
+			| V4L2_MBUS_SLAVE
+			| V4L2_MBUS_PCLK_SAMPLE_RISING
+			| V4L2_MBUS_PCLK_SAMPLE_FALLING
+			| V4L2_MBUS_HSYNC_ACTIVE_HIGH
+			| V4L2_MBUS_HSYNC_ACTIVE_LOW
+			| V4L2_MBUS_VSYNC_ACTIVE_HIGH
+			| V4L2_MBUS_VSYNC_ACTIVE_LOW
+			| V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
+	cfg->pb_flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index 39f420db9c70..629370d8feaa 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -914,8 +914,9 @@ static int ov5642_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
 	cfg->type = V4L2_MBUS_CSI2;
-	cfg->flags = V4L2_MBUS_CSI2_2_LANE | V4L2_MBUS_CSI2_CHANNEL_0 |
-					V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+	cfg->csi2_flags = V4L2_MBUS_CSI2_2_LANE
+			  | V4L2_MBUS_CSI2_CHANNEL_0
+			  | V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
 
 	return 0;
 }
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index 806383500313..7e1391460393 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -1003,11 +1003,13 @@ static int ov772x_g_mbus_config(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
-		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
-		V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->pb_flags = V4L2_MBUS_PCLK_SAMPLE_RISING
+			| V4L2_MBUS_MASTER
+			| V4L2_MBUS_VSYNC_ACTIVE_HIGH
+			| V4L2_MBUS_HSYNC_ACTIVE_HIGH
+			| V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
+	cfg->pb_flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index 0146d1f7aacb..905e8e251b7b 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -634,11 +634,13 @@ static int ov9640_g_mbus_config(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
-		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
-		V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->pb_flags = V4L2_MBUS_PCLK_SAMPLE_RISING
+		        | V4L2_MBUS_MASTER
+		        | V4L2_MBUS_VSYNC_ACTIVE_HIGH
+		        | V4L2_MBUS_HSYNC_ACTIVE_HIGH
+		        | V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
+	cfg->pb_flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index cc07b7ae5407..f6ab060d4af0 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -882,11 +882,13 @@ static int ov9740_g_mbus_config(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
-		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
-		V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->pb_flags = V4L2_MBUS_PCLK_SAMPLE_RISING
+			| V4L2_MBUS_MASTER
+			| V4L2_MBUS_VSYNC_ACTIVE_HIGH
+			| V4L2_MBUS_HSYNC_ACTIVE_HIGH
+			| V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
+	cfg->pb_flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index 02398d0bc649..f1d36f6a72b7 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -1227,12 +1227,14 @@ static int rj54n1_g_mbus_config(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	cfg->flags =
-		V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING |
-		V4L2_MBUS_MASTER | V4L2_MBUS_DATA_ACTIVE_HIGH |
-		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH;
+	cfg->pb_flags = V4L2_MBUS_PCLK_SAMPLE_RISING
+			| V4L2_MBUS_PCLK_SAMPLE_FALLING
+			| V4L2_MBUS_MASTER
+			| V4L2_MBUS_DATA_ACTIVE_HIGH
+			| V4L2_MBUS_HSYNC_ACTIVE_HIGH
+			| V4L2_MBUS_VSYNC_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
+	cfg->pb_flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index bdb5e0a431e9..aa64bea2ef9f 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -862,12 +862,15 @@ static int tw9910_g_mbus_config(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
-		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW |
-		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_LOW |
-		V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->pb_flags = V4L2_MBUS_PCLK_SAMPLE_RISING
+			| V4L2_MBUS_MASTER
+			| V4L2_MBUS_VSYNC_ACTIVE_HIGH
+			| V4L2_MBUS_VSYNC_ACTIVE_LOW
+			| V4L2_MBUS_HSYNC_ACTIVE_HIGH
+			| V4L2_MBUS_HSYNC_ACTIVE_LOW
+			| V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
+	cfg->pb_flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index e6f5c363ccab..bdd2b492e93c 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1462,20 +1462,20 @@ static int tc358743_g_mbus_config(struct v4l2_subdev *sd,
 	cfg->type = V4L2_MBUS_CSI2;
 
 	/* Support for non-continuous CSI-2 clock is missing in the driver */
-	cfg->flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+	cfg->csi2_flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
 
 	switch (state->csi_lanes_in_use) {
 	case 1:
-		cfg->flags |= V4L2_MBUS_CSI2_1_LANE;
+		cfg->csi2_flags |= V4L2_MBUS_CSI2_1_LANE;
 		break;
 	case 2:
-		cfg->flags |= V4L2_MBUS_CSI2_2_LANE;
+		cfg->csi2_flags |= V4L2_MBUS_CSI2_2_LANE;
 		break;
 	case 3:
-		cfg->flags |= V4L2_MBUS_CSI2_3_LANE;
+		cfg->csi2_flags |= V4L2_MBUS_CSI2_3_LANE;
 		break;
 	case 4:
-		cfg->flags |= V4L2_MBUS_CSI2_4_LANE;
+		cfg->csi2_flags |= V4L2_MBUS_CSI2_4_LANE;
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 7b79a7498751..2078a12c46bf 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -977,8 +977,10 @@ static int tvp5150_g_mbus_config(struct v4l2_subdev *sd,
 	struct tvp5150 *decoder = to_tvp5150(sd);
 
 	cfg->type = decoder->mbus_type;
-	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING
-		   | V4L2_MBUS_FIELD_EVEN_LOW | V4L2_MBUS_DATA_ACTIVE_HIGH;
+	cfg->pb_flags = V4L2_MBUS_MASTER
+			| V4L2_MBUS_PCLK_SAMPLE_RISING
+			| V4L2_MBUS_FIELD_EVEN_LOW
+			| V4L2_MBUS_DATA_ACTIVE_HIGH;
 
 	return 0;
 }
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 4a23a60f3418..2a3fdb87be4b 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -616,7 +616,7 @@ static unsigned int pxa_mbus_config_compatible(const struct v4l2_mbus_config *cf
 	bool hsync = true, vsync = true, pclk, data, mode;
 	bool mipi_lanes, mipi_clock;
 
-	common_flags = cfg->flags & flags;
+	common_flags = cfg->flag & flags;
 
 	switch (cfg->type) {
 	case V4L2_MBUS_PARALLEL:
@@ -1619,7 +1619,7 @@ static int pxa_camera_set_bus_param(struct pxa_camera_dev *pcdev)
 		if (!common_flags) {
 			dev_warn(pcdev_to_dev(pcdev),
 				 "Flags incompatible: camera 0x%x, host 0x%lx\n",
-				 cfg.flags, bus_flags);
+				 cfg.flag, bus_flags);
 			return -EINVAL;
 		}
 	} else if (ret != -ENOIOCTLCMD) {
@@ -1655,7 +1655,7 @@ static int pxa_camera_set_bus_param(struct pxa_camera_dev *pcdev)
 			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_FALLING;
 	}
 
-	cfg.flags = common_flags;
+	cfg.flag = common_flags;
 	ret = sensor_call(pcdev, video, s_mbus_config, &cfg);
 	if (ret < 0 && ret != -ENOIOCTLCMD) {
 		dev_dbg(pcdev_to_dev(pcdev),
@@ -1686,7 +1686,7 @@ static int pxa_camera_try_bus_param(struct pxa_camera_dev *pcdev,
 		if (!common_flags) {
 			dev_warn(pcdev_to_dev(pcdev),
 				 "Flags incompatible: camera 0x%x, host 0x%lx\n",
-				 cfg.flags, bus_flags);
+				 cfg.flag, bus_flags);
 			return -EINVAL;
 		}
 	} else if (ret == -ENOIOCTLCMD) {
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 3835a2fa0cb7..95fccabc924c 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -152,11 +152,11 @@ static int rvin_digitial_parse_v4l2(struct rvin_dev *vin,
 	switch (mbus_cfg->type) {
 	case V4L2_MBUS_PARALLEL:
 		vin_dbg(vin, "Found PARALLEL media bus\n");
-		mbus_cfg->flags = v4l2_ep.bus.parallel.flags;
+		mbus_cfg->pb_flags = v4l2_ep.bus.parallel.flags;
 		break;
 	case V4L2_MBUS_BT656:
 		vin_dbg(vin, "Found BT656 media bus\n");
-		mbus_cfg->flags = 0;
+		mbus_cfg->pb_flags = 0;
 		break;
 	default:
 		vin_err(vin, "Unknown media bus type\n");
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index b136844499f6..16759a19c928 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -212,11 +212,11 @@ static int rvin_setup(struct rvin_dev *vin)
 	dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
 
 	/* Hsync Signal Polarity Select */
-	if (!(vin->digital.mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
+	if (!(vin->digital.mbus_cfg.pb_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_HPS;
 
 	/* Vsync Signal Polarity Select */
-	if (!(vin->digital.mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
+	if (!(vin->digital.mbus_cfg.pb_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_VPS;
 
 	/*
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 36762ec954e7..b2d053ee6686 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -744,7 +744,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd)
 			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_LOW;
 	}
 
-	cfg.flags = common_flags;
+	cfg.flag = common_flags;
 	ret = v4l2_subdev_call(sd, video, s_mbus_config, &cfg);
 	if (ret < 0 && ret != -ENOIOCTLCMD)
 		return ret;
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 1bef3ebb49ee..befa6ac80269 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -217,7 +217,8 @@ EXPORT_SYMBOL(soc_camera_xlate_by_fourcc);
 unsigned long soc_camera_apply_board_flags(struct soc_camera_subdev_desc *ssdd,
 					   const struct v4l2_mbus_config *cfg)
 {
-	unsigned long f, flags = cfg->flags;
+	unsigned long f;
+	enum v4l2_mbus_parallel_and_bt656_flags flags = cfg->pb_flags;
 
 	/* If only one of the two polarities is supported, switch to the opposite */
 	if (ssdd->flags & SOCAM_SENSOR_INVERT_HSYNC) {
diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index cb4986b8f798..ba5f91207dc0 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -104,7 +104,7 @@ static int soc_camera_platform_g_mbus_config(struct v4l2_subdev *sd,
 {
 	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
 
-	cfg->flags = p->mbus_param;
+	cfg->flag = p->mbus_param;
 	cfg->type = p->mbus_type;
 
 	return 0;
diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
index 0ad4b28266e4..9ee9f550b477 100644
--- a/drivers/media/platform/soc_camera/soc_mediabus.c
+++ b/drivers/media/platform/soc_camera/soc_mediabus.c
@@ -486,7 +486,7 @@ unsigned int soc_mbus_config_compatible(const struct v4l2_mbus_config *cfg,
 	bool hsync = true, vsync = true, pclk, data, mode;
 	bool mipi_lanes, mipi_clock;
 
-	common_flags = cfg->flags & flags;
+	common_flags = cfg->flag & flags;
 
 	switch (cfg->type) {
 	case V4L2_MBUS_PARALLEL:
diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 40b2fbfe8865..b38fc5f930ac 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -41,7 +41,8 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 {
 	struct v4l2_fwnode_bus_mipi_csi2 *bus = &vep->bus.mipi_csi2;
 	bool have_clk_lane = false;
-	unsigned int flags = 0, lanes_used = 0;
+	unsigned int lanes_used = 0;
+	enum v4l2_mbus_csi2_flags flags = 0;
 	unsigned int i;
 	u32 v;
 	int rval;
@@ -109,7 +110,7 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 	struct fwnode_handle *fwnode, struct v4l2_fwnode_endpoint *vep)
 {
 	struct v4l2_fwnode_bus_parallel *bus = &vep->bus.parallel;
-	unsigned int flags = 0;
+	enum v4l2_mbus_parallel_and_bt656_flags flags = 0;
 	u32 v;
 
 	if (!fwnode_property_read_u32(fwnode, "hsync-active", &v))
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index 5f4716f967d0..3429400601a8 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -30,7 +30,7 @@ struct fwnode_handle;
 
 /**
  * struct v4l2_fwnode_bus_mipi_csi2 - MIPI CSI-2 bus data structure
- * @flags: media bus (V4L2_MBUS_*) flags
+ * @flags: media bus CSI flags, as defined by &enum v4l2_mbus_csi2_flags
  * @data_lanes: an array of physical data lane indexes
  * @clock_lane: physical lane index of the clock lane
  * @num_data_lanes: number of data lanes
@@ -38,7 +38,7 @@ struct fwnode_handle;
  *		   the physical lanes.
  */
 struct v4l2_fwnode_bus_mipi_csi2 {
-	unsigned int flags;
+	enum v4l2_mbus_csi2_flags flags;
 	unsigned char data_lanes[V4L2_FWNODE_CSI2_MAX_DATA_LANES];
 	unsigned char clock_lane;
 	unsigned short num_data_lanes;
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index e5281e1086c4..47adb1608d98 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -15,51 +15,90 @@
 #include <linux/bitops.h>
 
 
-/* Parallel flags */
-/*
- * Can the client run in master or in slave mode. By "Master mode" an operation
- * mode is meant, when the client (e.g., a camera sensor) is producing
- * horizontal and vertical synchronisation. In "Slave mode" the host is
- * providing these signals to the slave.
+/**
+ * enum v4l2_mbus_flags - Media bus parallel and polarity flags
+ *
+ * @V4L2_MBUS_MASTER:			the client runs on parallel master mode;
+ * @V4L2_MBUS_SLAVE:			the client runs on parallel slave mode.
+ * @V4L2_MBUS_HSYNC_ACTIVE_HIGH:	horizontal sync active on high level
+ * @V4L2_MBUS_HSYNC_ACTIVE_LOW:		horizontal sync active on low level
+ * @V4L2_MBUS_VSYNC_ACTIVE_HIGH:	vertical sync active on high level
+ * @V4L2_MBUS_VSYNC_ACTIVE_LOW:		vertical sync active on low level
+ * @V4L2_MBUS_PCLK_SAMPLE_RISING:	pixel clock sample on level rising
+ * @V4L2_MBUS_PCLK_SAMPLE_FALLING:	pixel clock sample on level falling
+ * @V4L2_MBUS_DATA_ACTIVE_HIGH:		data active on high level
+ * @V4L2_MBUS_DATA_ACTIVE_LOW:		data active on low level
+ * @V4L2_MBUS_FIELD_EVEN_HIGH:		FIELD = 0/1 - Field1 (odd)/Field2 (even)
+ * @V4L2_MBUS_FIELD_EVEN_LOW:		FIELD = 1/0 - Field1 (odd)/Field2 (even)
+ * @V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH:	Sync-on-green (SoG) signal active
+ *					on high level
+ * @V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW:	Sync-on-green (SoG) signal active
+ *					on low level
+ *
+ * Those flags are used when the bus is in %V4L2_MBUS_PARALLEL or
+ * %V4L2_MBUS_BT656 mode.
+ *
+ * .. note::
+ *
+ *    #) @V4L2_MBUS_MASTER and @V4L2_MBUS_SLAVE are only valid if the bus
+ *       is in %V4L2_MBUS_PARALLEL mode. They are used to specify if the
+ *       client runs in master or in slave mode.
+ *
+ *       In "Master mode" (@V4L2_MBUS_MASTER), the client (e.g., a camera
+ *       sensor) is producing horizontal and vertical synchronization.
+ *
+ *       In "Slave mode" (@V4L2_MBUS_SLAVE) the host is providing these signals
+ *       to the slave.
+ *    #) in %V4L2_MBUS_BT656 mode, ``V4L2_MBUS_HSYNC_*``, ``V4L2_MBUS_VSYNC_*``
+ *       and ``V4L2_MBUS_FIELD_*`` flags are unused.
+ *    #) ``V4L2_MBUS_[HV]SYNC*`` flags should be also used for specifying
+ *       configuration of hardware that uses [HV]REF signals
  */
-#define V4L2_MBUS_MASTER			BIT(0)
-#define V4L2_MBUS_SLAVE				BIT(1)
-/*
- * Signal polarity flags
- * Note: in BT.656 mode HSYNC, FIELD, and VSYNC are unused
- * V4L2_MBUS_[HV]SYNC* flags should be also used for specifying
- * configuration of hardware that uses [HV]REF signals
- */
-#define V4L2_MBUS_HSYNC_ACTIVE_HIGH		BIT(2)
-#define V4L2_MBUS_HSYNC_ACTIVE_LOW		BIT(3)
-#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		BIT(4)
-#define V4L2_MBUS_VSYNC_ACTIVE_LOW		BIT(5)
-#define V4L2_MBUS_PCLK_SAMPLE_RISING		BIT(6)
-#define V4L2_MBUS_PCLK_SAMPLE_FALLING		BIT(7)
-#define V4L2_MBUS_DATA_ACTIVE_HIGH		BIT(8)
-#define V4L2_MBUS_DATA_ACTIVE_LOW		BIT(9)
-/* FIELD = 0/1 - Field1 (odd)/Field2 (even) */
-#define V4L2_MBUS_FIELD_EVEN_HIGH		BIT(10)
-/* FIELD = 1/0 - Field1 (odd)/Field2 (even) */
-#define V4L2_MBUS_FIELD_EVEN_LOW		BIT(11)
-/* Active state of Sync-on-green (SoG) signal, 0/1 for LOW/HIGH respectively. */
-#define V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH		BIT(12)
-#define V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW		BIT(13)
+enum v4l2_mbus_parallel_and_bt656_flags {
+	V4L2_MBUS_MASTER		= BIT(0),
+	V4L2_MBUS_SLAVE			= BIT(1),
+	V4L2_MBUS_HSYNC_ACTIVE_HIGH	= BIT(2),
+	V4L2_MBUS_HSYNC_ACTIVE_LOW	= BIT(3),
+	V4L2_MBUS_VSYNC_ACTIVE_HIGH	= BIT(4),
+	V4L2_MBUS_VSYNC_ACTIVE_LOW	= BIT(5),
+	V4L2_MBUS_PCLK_SAMPLE_RISING	= BIT(6),
+	V4L2_MBUS_PCLK_SAMPLE_FALLING	= BIT(7),
+	V4L2_MBUS_DATA_ACTIVE_HIGH	= BIT(8),
+	V4L2_MBUS_DATA_ACTIVE_LOW	= BIT(9),
+	V4L2_MBUS_FIELD_EVEN_HIGH	= BIT(10),
+	V4L2_MBUS_FIELD_EVEN_LOW	= BIT(11),
+	V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH	= BIT(12),
+	V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW	= BIT(13),
+};
 
-/* Serial flags */
-/* How many lanes the client can use */
-#define V4L2_MBUS_CSI2_1_LANE			BIT(0)
-#define V4L2_MBUS_CSI2_2_LANE			BIT(1)
-#define V4L2_MBUS_CSI2_3_LANE			BIT(2)
-#define V4L2_MBUS_CSI2_4_LANE			BIT(3)
-/* On which channels it can send video data */
-#define V4L2_MBUS_CSI2_CHANNEL_0		BIT(4)
-#define V4L2_MBUS_CSI2_CHANNEL_1		BIT(5)
-#define V4L2_MBUS_CSI2_CHANNEL_2		BIT(6)
-#define V4L2_MBUS_CSI2_CHANNEL_3		BIT(7)
-/* Does it support only continuous or also non-continuous clock mode */
-#define V4L2_MBUS_CSI2_CONTINUOUS_CLOCK		BIT(8)
-#define V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK	BIT(9)
+/**
+ * enum v4l2_mbus_csi2_flags - Media bus serial flags
+ *
+ * @V4L2_MBUS_CSI2_1_LANE:		One lane in use
+ * @V4L2_MBUS_CSI2_2_LANE:		Two lanes in use
+ * @V4L2_MBUS_CSI2_3_LANE:		Three lanes in use
+ * @V4L2_MBUS_CSI2_4_LANE:		Four lanes in use
+ * @V4L2_MBUS_CSI2_CHANNEL_0:		Channel 0 can send video data
+ * @V4L2_MBUS_CSI2_CHANNEL_1:		Channel 1 can send video data
+ * @V4L2_MBUS_CSI2_CHANNEL_2:		Channel 2 can send video data
+ * @V4L2_MBUS_CSI2_CHANNEL_3:		Channel 3 can send video data
+ * @V4L2_MBUS_CSI2_CONTINUOUS_CLOCK:	Supports continuous clock mode
+ * @V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK:	Supports non-continuous clock mode
+ *
+ * Used only when the bus type is MIPI CSI-2.
+ */
+enum v4l2_mbus_csi2_flags {
+	V4L2_MBUS_CSI2_1_LANE			= BIT(0),
+	V4L2_MBUS_CSI2_2_LANE			= BIT(1),
+	V4L2_MBUS_CSI2_3_LANE			= BIT(2),
+	V4L2_MBUS_CSI2_4_LANE			= BIT(3),
+	V4L2_MBUS_CSI2_CHANNEL_0		= BIT(4),
+	V4L2_MBUS_CSI2_CHANNEL_1		= BIT(5),
+	V4L2_MBUS_CSI2_CHANNEL_2		= BIT(6),
+	V4L2_MBUS_CSI2_CHANNEL_3		= BIT(7),
+	V4L2_MBUS_CSI2_CONTINUOUS_CLOCK		= BIT(8),
+	V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK	= BIT(9),
+};
 
 #define V4L2_MBUS_CSI2_LANES		(V4L2_MBUS_CSI2_1_LANE | V4L2_MBUS_CSI2_2_LANE | \
 					 V4L2_MBUS_CSI2_3_LANE | V4L2_MBUS_CSI2_4_LANE)
@@ -69,8 +108,8 @@
 /**
  * enum v4l2_mbus_type - media bus type
  * @V4L2_MBUS_PARALLEL:	parallel interface with hsync and vsync
- * @V4L2_MBUS_BT656:	parallel interface with embedded synchronisation, can
- *			also be used for BT.1120
+ * @V4L2_MBUS_BT656:	parallel interface with embedded synchronization using ITU-R BT.656
+ * 			signaling. Can also be used for ISO-R BT.1120 signaling.
  * @V4L2_MBUS_CSI1:	MIPI CSI-1 serial interface
  * @V4L2_MBUS_CCP2:	CCP2 (Compact Camera Port 2)
  * @V4L2_MBUS_CSI2:	MIPI CSI-2 serial interface
@@ -86,11 +125,22 @@ enum v4l2_mbus_type {
 /**
  * struct v4l2_mbus_config - media bus configuration
  * @type:	in: interface type
- * @flags:	in / out: configuration flags, depending on @type
+ * @pb_flags:	in / out: configuration flags, if @type is
+ *		%V4L2_MBUS_PARALLEL or %V4L2_MBUS_BT656.
+ * @csi2_flags:	in / out: configuration flags, if @type is
+ *		%V4L2_MBUS_CSI2.
+ * @flag:	access flags, no matter the @type.
+ *		Used just to avoid needing to rewrite the logic inside
+ *		soc_camera and pxa_camera drivers. Don't use on newer
+ * 		drivers!
  */
 struct v4l2_mbus_config {
 	enum v4l2_mbus_type type;
-	unsigned int flags;
+	union {
+		enum v4l2_mbus_parallel_and_bt656_flags	pb_flags;
+		enum v4l2_mbus_csi2_flags		csi2_flags;
+		unsigned int				flag;
+	};
 };
 
 static inline void v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
-- 
2.13.6
