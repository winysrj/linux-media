Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34661 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752035AbcLLOAL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 09:00:11 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, g.liakhovetski@gmx.de, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] media: i2c: soc_camera: constify v4l2_subdev_* structures
Date: Mon, 12 Dec 2016 19:29:42 +0530
Message-Id: <1481551182-9163-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_subdev_{core/video}_ops structures are stored in the
fields of the v4l2_subdev_ops structure which are of type const.
Also, v4l2_subdev_ops structure is passed to a function
having its argument of type const. As these structures are never
modified, so declare them as const.
Done using Coccinelle: (One of the scripts used)

@r1 disable optional_qualifier @
identifier i;
position p;
@@
static struct v4l2_subdev_video_ops i@p = {...};

@ok1@
identifier r1.i;
position p;
struct v4l2_subdev_ops obj;
@@
obj.video=&i@p;

@bad@
position p!={r1.p,ok1.p};
identifier r1.i;
@@
i@p

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
+const
struct v4l2_subdev_video_ops i;

File sizes before and after the changes:
   text	   data	    bss	    dec	    hex	filename

   3459	    696	      0	   4155	   103b	/media/i2c/soc_camera/imx074.o
   3835	    320	      0	   4155	   103b	/media/i2c/soc_camera/imx074.o

   4749	   1048	      8	   5805	   16ad	/media/i2c/soc_camera/mt9m001.o
   5133	    672	      8	   5813	   16b5	/media/i2c/soc_camera/mt9m001.o

   5658	   1112	      8	   6778	   1a7a	/media/i2c/soc_camera/mt9t031.o
   6042	    728	      8	   6778	   1a7a	/media/i2c/soc_camera/mt9t031.o

   6726	    784	      0	   7510	   1d56	/media/i2c/soc_camera/mt9t112.o
   7110	    408	      0	   7518	   1d5e	/media/i2c/soc_camera/mt9t112.o

   6700	    960	     16	   7676	   1dfc	/media/i2c/soc_camera/mt9v022.o
   7084	    584	     16	   7684	   1e04	/media/i2c/soc_camera/mt9v022.o

   5569	   1576	      8	   7153	   1bf1	/media/i2c/soc_camera/ov2640.o
   5953	   1200	      8	   7161	   1bf9	/media/i2c/soc_camera/ov2640.o

   3018	   2736	      0	   5754	   167a	/media/i2c/soc_camera/ov5642.o
   3394	   2352	      0	   5746	   1672	/media/i2c/soc_camera/ov5642.o

   8348	   2104	      8	  10460	   28dc	/media/i2c/soc_camera/ov6650.o
   8716	   1728	      8	  10452	   28d4	/media/i2c/soc_camera/ov6650.o

   4165	    696	      8	   4869	   1305	/media/i2c/soc_camera/ov772x.o
   4549	    320	      8	   4877	   130d	/media/i2c/soc_camera/ov772x.o

   4033	    608	      8	   4649	   1229	/media/i2c/soc_camera/ov9640.o
   4417	    232	      8	   4657	   1231	/media/i2c/soc_camera/ov9640.o

   4983	    784	      8	   5775	   168f	/media/i2c/soc_camera/ov9740.o
   5367	    408	      8	   5783	   1697	/media/i2c/soc_camera/ov9740.o

   8578	   1312	      8	   9898	   26aa i2c/soc_camera/rj54n1cb0c.o
   8962	    936	      8	   9906	   26b2 i2c/soc_camera/rj54n1cb0c.o

   3886	    696	      0	   4582	   11e6	/media/i2c/soc_camera/tw9910.o
   4270	    320	      0	   4590	   11ee	/media/i2c/soc_camera/tw9910.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/i2c/soc_camera/imx074.c     | 6 +++---
 drivers/media/i2c/soc_camera/mt9m001.c    | 6 +++---
 drivers/media/i2c/soc_camera/mt9t031.c    | 6 +++---
 drivers/media/i2c/soc_camera/mt9t112.c    | 6 +++---
 drivers/media/i2c/soc_camera/mt9v022.c    | 6 +++---
 drivers/media/i2c/soc_camera/ov2640.c     | 6 +++---
 drivers/media/i2c/soc_camera/ov5642.c     | 6 +++---
 drivers/media/i2c/soc_camera/ov6650.c     | 6 +++---
 drivers/media/i2c/soc_camera/ov772x.c     | 6 +++---
 drivers/media/i2c/soc_camera/ov9640.c     | 6 +++---
 drivers/media/i2c/soc_camera/ov9740.c     | 6 +++---
 drivers/media/i2c/soc_camera/rj54n1cb0c.c | 6 +++---
 drivers/media/i2c/soc_camera/tw9910.c     | 6 +++---
 13 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index 05b55cf..9b0f0d0 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -271,12 +271,12 @@ static int imx074_g_mbus_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static struct v4l2_subdev_video_ops imx074_subdev_video_ops = {
+static const struct v4l2_subdev_video_ops imx074_subdev_video_ops = {
 	.s_stream	= imx074_s_stream,
 	.g_mbus_config	= imx074_g_mbus_config,
 };
 
-static struct v4l2_subdev_core_ops imx074_subdev_core_ops = {
+static const struct v4l2_subdev_core_ops imx074_subdev_core_ops = {
 	.s_power	= imx074_s_power,
 };
 
@@ -287,7 +287,7 @@ static int imx074_g_mbus_config(struct v4l2_subdev *sd,
 	.set_fmt	= imx074_set_fmt,
 };
 
-static struct v4l2_subdev_ops imx074_subdev_ops = {
+static const struct v4l2_subdev_ops imx074_subdev_ops = {
 	.core	= &imx074_subdev_core_ops,
 	.video	= &imx074_subdev_video_ops,
 	.pad	= &imx074_subdev_pad_ops,
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index 3d6378d..6d1782b 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -574,7 +574,7 @@ static int mt9m001_g_skip_top_lines(struct v4l2_subdev *sd, u32 *lines)
 	.s_ctrl = mt9m001_s_ctrl,
 };
 
-static struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
+static const struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9m001_g_register,
 	.s_register	= mt9m001_s_register,
@@ -630,7 +630,7 @@ static int mt9m001_s_mbus_config(struct v4l2_subdev *sd,
 	return bps == 10 ? 0 : -EINVAL;
 }
 
-static struct v4l2_subdev_video_ops mt9m001_subdev_video_ops = {
+static const struct v4l2_subdev_video_ops mt9m001_subdev_video_ops = {
 	.s_stream	= mt9m001_s_stream,
 	.g_mbus_config	= mt9m001_g_mbus_config,
 	.s_mbus_config	= mt9m001_s_mbus_config,
@@ -648,7 +648,7 @@ static int mt9m001_s_mbus_config(struct v4l2_subdev *sd,
 	.set_fmt	= mt9m001_set_fmt,
 };
 
-static struct v4l2_subdev_ops mt9m001_subdev_ops = {
+static const struct v4l2_subdev_ops mt9m001_subdev_ops = {
 	.core	= &mt9m001_subdev_core_ops,
 	.video	= &mt9m001_subdev_video_ops,
 	.sensor	= &mt9m001_subdev_sensor_ops,
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index 3aa5569..714fb35 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -679,7 +679,7 @@ static int mt9t031_g_skip_top_lines(struct v4l2_subdev *sd, u32 *lines)
 	.s_ctrl = mt9t031_s_ctrl,
 };
 
-static struct v4l2_subdev_core_ops mt9t031_subdev_core_ops = {
+static const struct v4l2_subdev_core_ops mt9t031_subdev_core_ops = {
 	.s_power	= mt9t031_s_power,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9t031_g_register,
@@ -726,7 +726,7 @@ static int mt9t031_s_mbus_config(struct v4l2_subdev *sd,
 		return reg_set(client, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
 }
 
-static struct v4l2_subdev_video_ops mt9t031_subdev_video_ops = {
+static const struct v4l2_subdev_video_ops mt9t031_subdev_video_ops = {
 	.s_stream	= mt9t031_s_stream,
 	.g_mbus_config	= mt9t031_g_mbus_config,
 	.s_mbus_config	= mt9t031_s_mbus_config,
@@ -744,7 +744,7 @@ static int mt9t031_s_mbus_config(struct v4l2_subdev *sd,
 	.set_fmt	= mt9t031_set_fmt,
 };
 
-static struct v4l2_subdev_ops mt9t031_subdev_ops = {
+static const struct v4l2_subdev_ops mt9t031_subdev_ops = {
 	.core	= &mt9t031_subdev_core_ops,
 	.video	= &mt9t031_subdev_video_ops,
 	.sensor	= &mt9t031_subdev_sensor_ops,
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index 2ef2224..297d22e 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -773,7 +773,7 @@ static int mt9t112_s_power(struct v4l2_subdev *sd, int on)
 	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
 }
 
-static struct v4l2_subdev_core_ops mt9t112_subdev_core_ops = {
+static const struct v4l2_subdev_core_ops mt9t112_subdev_core_ops = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9t112_g_register,
 	.s_register	= mt9t112_s_register,
@@ -1031,7 +1031,7 @@ static int mt9t112_s_mbus_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static struct v4l2_subdev_video_ops mt9t112_subdev_video_ops = {
+static const struct v4l2_subdev_video_ops mt9t112_subdev_video_ops = {
 	.s_stream	= mt9t112_s_stream,
 	.g_mbus_config	= mt9t112_g_mbus_config,
 	.s_mbus_config	= mt9t112_s_mbus_config,
@@ -1048,7 +1048,7 @@ static int mt9t112_s_mbus_config(struct v4l2_subdev *sd,
 /************************************************************************
 			i2c driver
 ************************************************************************/
-static struct v4l2_subdev_ops mt9t112_subdev_ops = {
+static const struct v4l2_subdev_ops mt9t112_subdev_ops = {
 	.core	= &mt9t112_subdev_core_ops,
 	.video	= &mt9t112_subdev_video_ops,
 	.pad	= &mt9t112_subdev_pad_ops,
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index 6a14ab5..f3b5cf4 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -770,7 +770,7 @@ static int mt9v022_g_skip_top_lines(struct v4l2_subdev *sd, u32 *lines)
 	.s_ctrl = mt9v022_s_ctrl,
 };
 
-static struct v4l2_subdev_core_ops mt9v022_subdev_core_ops = {
+static const struct v4l2_subdev_core_ops mt9v022_subdev_core_ops = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9v022_g_register,
 	.s_register	= mt9v022_s_register,
@@ -858,7 +858,7 @@ static int mt9v022_s_mbus_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static struct v4l2_subdev_video_ops mt9v022_subdev_video_ops = {
+static const struct v4l2_subdev_video_ops mt9v022_subdev_video_ops = {
 	.s_stream	= mt9v022_s_stream,
 	.g_mbus_config	= mt9v022_g_mbus_config,
 	.s_mbus_config	= mt9v022_s_mbus_config,
@@ -876,7 +876,7 @@ static int mt9v022_s_mbus_config(struct v4l2_subdev *sd,
 	.set_fmt	= mt9v022_set_fmt,
 };
 
-static struct v4l2_subdev_ops mt9v022_subdev_ops = {
+static const struct v4l2_subdev_ops mt9v022_subdev_ops = {
 	.core	= &mt9v022_subdev_core_ops,
 	.video	= &mt9v022_subdev_video_ops,
 	.sensor	= &mt9v022_subdev_sensor_ops,
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 56de182..e0c08c0 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -995,7 +995,7 @@ static int ov2640_video_probe(struct i2c_client *client)
 	.s_ctrl = ov2640_s_ctrl,
 };
 
-static struct v4l2_subdev_core_ops ov2640_subdev_core_ops = {
+static const struct v4l2_subdev_core_ops ov2640_subdev_core_ops = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= ov2640_g_register,
 	.s_register	= ov2640_s_register,
@@ -1018,7 +1018,7 @@ static int ov2640_g_mbus_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static struct v4l2_subdev_video_ops ov2640_subdev_video_ops = {
+static const struct v4l2_subdev_video_ops ov2640_subdev_video_ops = {
 	.s_stream	= ov2640_s_stream,
 	.g_mbus_config	= ov2640_g_mbus_config,
 };
@@ -1030,7 +1030,7 @@ static int ov2640_g_mbus_config(struct v4l2_subdev *sd,
 	.set_fmt	= ov2640_set_fmt,
 };
 
-static struct v4l2_subdev_ops ov2640_subdev_ops = {
+static const struct v4l2_subdev_ops ov2640_subdev_ops = {
 	.core	= &ov2640_subdev_core_ops,
 	.video	= &ov2640_subdev_video_ops,
 	.pad	= &ov2640_subdev_pad_ops,
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index 3d185bd..8094846 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -943,7 +943,7 @@ static int ov5642_s_power(struct v4l2_subdev *sd, int on)
 	return ret;
 }
 
-static struct v4l2_subdev_video_ops ov5642_subdev_video_ops = {
+static const struct v4l2_subdev_video_ops ov5642_subdev_video_ops = {
 	.g_mbus_config	= ov5642_g_mbus_config,
 };
 
@@ -955,7 +955,7 @@ static int ov5642_s_power(struct v4l2_subdev *sd, int on)
 	.set_fmt	= ov5642_set_fmt,
 };
 
-static struct v4l2_subdev_core_ops ov5642_subdev_core_ops = {
+static const struct v4l2_subdev_core_ops ov5642_subdev_core_ops = {
 	.s_power	= ov5642_s_power,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= ov5642_get_register,
@@ -963,7 +963,7 @@ static int ov5642_s_power(struct v4l2_subdev *sd, int on)
 #endif
 };
 
-static struct v4l2_subdev_ops ov5642_subdev_ops = {
+static const struct v4l2_subdev_ops ov5642_subdev_ops = {
 	.core	= &ov5642_subdev_core_ops,
 	.video	= &ov5642_subdev_video_ops,
 	.pad	= &ov5642_subdev_pad_ops,
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index 4bf2995..38443d3 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -885,7 +885,7 @@ static int ov6650_video_probe(struct i2c_client *client)
 	.s_ctrl = ov6550_s_ctrl,
 };
 
-static struct v4l2_subdev_core_ops ov6650_core_ops = {
+static const struct v4l2_subdev_core_ops ov6650_core_ops = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register		= ov6650_get_register,
 	.s_register		= ov6650_set_register,
@@ -942,7 +942,7 @@ static int ov6650_s_mbus_config(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static struct v4l2_subdev_video_ops ov6650_video_ops = {
+static const struct v4l2_subdev_video_ops ov6650_video_ops = {
 	.s_stream	= ov6650_s_stream,
 	.g_parm		= ov6650_g_parm,
 	.s_parm		= ov6650_s_parm,
@@ -958,7 +958,7 @@ static int ov6650_s_mbus_config(struct v4l2_subdev *sd,
 	.set_fmt	= ov6650_set_fmt,
 };
 
-static struct v4l2_subdev_ops ov6650_subdev_ops = {
+static const struct v4l2_subdev_ops ov6650_subdev_ops = {
 	.core	= &ov6650_core_ops,
 	.video	= &ov6650_video_ops,
 	.pad	= &ov6650_pad_ops,
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index 7e68762..47ac402 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -993,7 +993,7 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
 	.s_ctrl = ov772x_s_ctrl,
 };
 
-static struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
+static const struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= ov772x_g_register,
 	.s_register	= ov772x_s_register,
@@ -1027,7 +1027,7 @@ static int ov772x_g_mbus_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
+static const struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
 	.s_stream	= ov772x_s_stream,
 	.g_mbus_config	= ov772x_g_mbus_config,
 };
@@ -1039,7 +1039,7 @@ static int ov772x_g_mbus_config(struct v4l2_subdev *sd,
 	.set_fmt	= ov772x_set_fmt,
 };
 
-static struct v4l2_subdev_ops ov772x_subdev_ops = {
+static const struct v4l2_subdev_ops ov772x_subdev_ops = {
 	.core	= &ov772x_subdev_core_ops,
 	.video	= &ov772x_subdev_video_ops,
 	.pad	= &ov772x_subdev_pad_ops,
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index 8c93c57..1dbaacf 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -637,7 +637,7 @@ static int ov9640_video_probe(struct i2c_client *client)
 	.s_ctrl = ov9640_s_ctrl,
 };
 
-static struct v4l2_subdev_core_ops ov9640_core_ops = {
+static const struct v4l2_subdev_core_ops ov9640_core_ops = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register		= ov9640_get_register,
 	.s_register		= ov9640_set_register,
@@ -661,7 +661,7 @@ static int ov9640_g_mbus_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static struct v4l2_subdev_video_ops ov9640_video_ops = {
+static const struct v4l2_subdev_video_ops ov9640_video_ops = {
 	.s_stream	= ov9640_s_stream,
 	.g_mbus_config	= ov9640_g_mbus_config,
 };
@@ -672,7 +672,7 @@ static int ov9640_g_mbus_config(struct v4l2_subdev *sd,
 	.set_fmt	= ov9640_set_fmt,
 };
 
-static struct v4l2_subdev_ops ov9640_subdev_ops = {
+static const struct v4l2_subdev_ops ov9640_subdev_ops = {
 	.core	= &ov9640_core_ops,
 	.video	= &ov9640_video_ops,
 	.pad	= &ov9640_pad_ops,
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index 0da632d..005e039 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -908,12 +908,12 @@ static int ov9740_g_mbus_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static struct v4l2_subdev_video_ops ov9740_video_ops = {
+static const struct v4l2_subdev_video_ops ov9740_video_ops = {
 	.s_stream	= ov9740_s_stream,
 	.g_mbus_config	= ov9740_g_mbus_config,
 };
 
-static struct v4l2_subdev_core_ops ov9740_core_ops = {
+static const struct v4l2_subdev_core_ops ov9740_core_ops = {
 	.s_power		= ov9740_s_power,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register		= ov9740_get_register,
@@ -927,7 +927,7 @@ static int ov9740_g_mbus_config(struct v4l2_subdev *sd,
 	.set_fmt	= ov9740_set_fmt,
 };
 
-static struct v4l2_subdev_ops ov9740_subdev_ops = {
+static const struct v4l2_subdev_ops ov9740_subdev_ops = {
 	.core	= &ov9740_core_ops,
 	.video	= &ov9740_video_ops,
 	.pad	= &ov9740_pad_ops,
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index bc8ec59..02398d0 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -1213,7 +1213,7 @@ static int rj54n1_s_ctrl(struct v4l2_ctrl *ctrl)
 	.s_ctrl = rj54n1_s_ctrl,
 };
 
-static struct v4l2_subdev_core_ops rj54n1_subdev_core_ops = {
+static const struct v4l2_subdev_core_ops rj54n1_subdev_core_ops = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= rj54n1_g_register,
 	.s_register	= rj54n1_s_register,
@@ -1251,7 +1251,7 @@ static int rj54n1_s_mbus_config(struct v4l2_subdev *sd,
 		return reg_write(client, RJ54N1_OUT_SIGPO, 0);
 }
 
-static struct v4l2_subdev_video_ops rj54n1_subdev_video_ops = {
+static const struct v4l2_subdev_video_ops rj54n1_subdev_video_ops = {
 	.s_stream	= rj54n1_s_stream,
 	.g_mbus_config	= rj54n1_g_mbus_config,
 	.s_mbus_config	= rj54n1_s_mbus_config,
@@ -1265,7 +1265,7 @@ static int rj54n1_s_mbus_config(struct v4l2_subdev *sd,
 	.set_fmt	= rj54n1_set_fmt,
 };
 
-static struct v4l2_subdev_ops rj54n1_subdev_ops = {
+static const struct v4l2_subdev_ops rj54n1_subdev_ops = {
 	.core	= &rj54n1_subdev_core_ops,
 	.video	= &rj54n1_subdev_video_ops,
 	.pad	= &rj54n1_subdev_pad_ops,
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index 4002c07..5be65cc 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -837,7 +837,7 @@ static int tw9910_video_probe(struct i2c_client *client)
 	return ret;
 }
 
-static struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
+static const struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= tw9910_g_register,
 	.s_register	= tw9910_s_register,
@@ -901,7 +901,7 @@ static int tw9910_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *norm)
 	return 0;
 }
 
-static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
+static const struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
 	.s_std		= tw9910_s_std,
 	.g_std		= tw9910_g_std,
 	.s_stream	= tw9910_s_stream,
@@ -917,7 +917,7 @@ static int tw9910_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *norm)
 	.set_fmt	= tw9910_set_fmt,
 };
 
-static struct v4l2_subdev_ops tw9910_subdev_ops = {
+static const struct v4l2_subdev_ops tw9910_subdev_ops = {
 	.core	= &tw9910_subdev_core_ops,
 	.video	= &tw9910_subdev_video_ops,
 	.pad	= &tw9910_subdev_pad_ops,
-- 
1.9.1

