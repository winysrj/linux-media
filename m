Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41708 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932136AbZJ3OBM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 10:01:12 -0400
Date: Fri, 30 Oct 2009 15:01:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 6/9] soc-camera: switch drivers and platforms to use .priv
 in struct soc_camera_link
In-Reply-To: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
Message-ID: <Pine.LNX.4.64.0910301437570.4378@axis700.grange>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After this change drivers can be further extended to not fail, if they don't
get platform data, but to use defaults.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 arch/sh/boards/board-ap325rxa.c     |   38 +++++++++++++++++++---------------
 arch/sh/boards/mach-migor/setup.c   |   32 ++++++++++++++++------------
 drivers/media/video/ov772x.c        |    4 +-
 drivers/media/video/tw9910.c        |    6 ++--
 include/media/ov772x.h              |    1 -
 include/media/soc_camera_platform.h |    1 -
 include/media/tw9910.h              |    1 -
 7 files changed, 44 insertions(+), 39 deletions(-)

diff --git a/arch/sh/boards/board-ap325rxa.c b/arch/sh/boards/board-ap325rxa.c
index 2d08073..a3afe43 100644
--- a/arch/sh/boards/board-ap325rxa.c
+++ b/arch/sh/boards/board-ap325rxa.c
@@ -325,12 +325,14 @@ static struct soc_camera_platform_info camera_info = {
 	.bus_param = SOCAM_PCLK_SAMPLE_RISING | SOCAM_HSYNC_ACTIVE_HIGH |
 	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_MASTER | SOCAM_DATAWIDTH_8,
 	.set_capture = camera_set_capture,
-	.link = {
-		.bus_id		= 0,
-		.add_device	= ap325rxa_camera_add,
-		.del_device	= ap325rxa_camera_del,
-		.module_name	= "soc_camera_platform",
-	},
+};
+
+struct soc_camera_link camera_link = {
+	.bus_id		= 0,
+	.add_device	= ap325rxa_camera_add,
+	.del_device	= ap325rxa_camera_del,
+	.module_name	= "soc_camera_platform",
+	.priv		= &camera_info,
 };
 
 static void dummy_release(struct device *dev)
@@ -348,7 +350,7 @@ static struct platform_device camera_device = {
 static int ap325rxa_camera_add(struct soc_camera_link *icl,
 			       struct device *dev)
 {
-	if (icl != &camera_info.link || camera_probe() <= 0)
+	if (icl != &camera_link || camera_probe() <= 0)
 		return -ENODEV;
 
 	camera_info.dev = dev;
@@ -358,7 +360,7 @@ static int ap325rxa_camera_add(struct soc_camera_link *icl,
 
 static void ap325rxa_camera_del(struct soc_camera_link *icl)
 {
-	if (icl != &camera_info.link)
+	if (icl != &camera_link)
 		return;
 
 	platform_device_unregister(&camera_device);
@@ -439,13 +441,15 @@ static struct ov772x_camera_info ov7725_info = {
 	.buswidth	= SOCAM_DATAWIDTH_8,
 	.flags		= OV772X_FLAG_VFLIP | OV772X_FLAG_HFLIP,
 	.edgectrl	= OV772X_AUTO_EDGECTRL(0xf, 0),
-	.link = {
-		.bus_id		= 0,
-		.power		= ov7725_power,
-		.board_info	= &ap325rxa_i2c_camera[0],
-		.i2c_adapter_id	= 0,
-		.module_name	= "ov772x",
-	},
+};
+
+static struct soc_camera_link ov7725_link = {
+	.bus_id		= 0,
+	.power		= ov7725_power,
+	.board_info	= &ap325rxa_i2c_camera[0],
+	.i2c_adapter_id	= 0,
+	.module_name	= "ov772x",
+	.priv		= &ov7725_info,
 };
 
 static struct platform_device ap325rxa_camera[] = {
@@ -453,13 +457,13 @@ static struct platform_device ap325rxa_camera[] = {
 		.name	= "soc-camera-pdrv",
 		.id	= 0,
 		.dev	= {
-			.platform_data = &ov7725_info.link,
+			.platform_data = &ov7725_link,
 		},
 	}, {
 		.name	= "soc-camera-pdrv",
 		.id	= 1,
 		.dev	= {
-			.platform_data = &camera_info.link,
+			.platform_data = &camera_link,
 		},
 	},
 };
diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 6ed1fd3..6145120 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -425,23 +425,27 @@ static struct i2c_board_info migor_i2c_camera[] = {
 
 static struct ov772x_camera_info ov7725_info = {
 	.buswidth	= SOCAM_DATAWIDTH_8,
-	.link = {
-		.power		= ov7725_power,
-		.board_info	= &migor_i2c_camera[0],
-		.i2c_adapter_id	= 0,
-		.module_name	= "ov772x",
-	},
+};
+
+static struct soc_camera_link ov7725_link = {
+	.power		= ov7725_power,
+	.board_info	= &migor_i2c_camera[0],
+	.i2c_adapter_id	= 0,
+	.module_name	= "ov772x",
+	.priv		= &ov7725_info,
 };
 
 static struct tw9910_video_info tw9910_info = {
 	.buswidth	= SOCAM_DATAWIDTH_8,
 	.mpout		= TW9910_MPO_FIELD,
-	.link = {
-		.power		= tw9910_power,
-		.board_info	= &migor_i2c_camera[1],
-		.i2c_adapter_id	= 0,
-		.module_name	= "tw9910",
-	}
+};
+
+static struct soc_camera_link tw9910_link = {
+	.power		= tw9910_power,
+	.board_info	= &migor_i2c_camera[1],
+	.i2c_adapter_id	= 0,
+	.module_name	= "tw9910",
+	.priv		= &tw9910_info,
 };
 
 static struct platform_device migor_camera[] = {
@@ -449,13 +453,13 @@ static struct platform_device migor_camera[] = {
 		.name	= "soc-camera-pdrv",
 		.id	= 0,
 		.dev	= {
-			.platform_data = &ov7725_info.link,
+			.platform_data = &ov7725_link,
 		},
 	}, {
 		.name	= "soc-camera-pdrv",
 		.id	= 1,
 		.dev	= {
-			.platform_data = &tw9910_info.link,
+			.platform_data = &tw9910_link,
 		},
 	},
 };
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index eccb40a..dbaf508 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -1143,10 +1143,10 @@ static int ov772x_probe(struct i2c_client *client,
 	}
 
 	icl = to_soc_camera_link(icd);
-	if (!icl)
+	if (!icl || !icl->priv)
 		return -EINVAL;
 
-	info = container_of(icl, struct ov772x_camera_info, link);
+	info = icl->priv;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_err(&adapter->dev,
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 3cb9ba6..35373d8 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -955,10 +955,10 @@ static int tw9910_probe(struct i2c_client *client,
 	}
 
 	icl = to_soc_camera_link(icd);
-	if (!icl)
+	if (!icl || !icl->priv)
 		return -EINVAL;
 
-	info = container_of(icl, struct tw9910_video_info, link);
+	info = icl->priv;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_err(&client->dev,
@@ -976,7 +976,7 @@ static int tw9910_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(&priv->subdev, client, &tw9910_subdev_ops);
 
 	icd->ops     = &tw9910_ops;
-	icd->iface   = info->link.bus_id;
+	icd->iface   = icl->bus_id;
 
 	ret = tw9910_video_probe(icd, client);
 	if (ret) {
diff --git a/include/media/ov772x.h b/include/media/ov772x.h
index 37bcd09..14c77ef 100644
--- a/include/media/ov772x.h
+++ b/include/media/ov772x.h
@@ -55,7 +55,6 @@ struct ov772x_edge_ctrl {
 struct ov772x_camera_info {
 	unsigned long          buswidth;
 	unsigned long          flags;
-	struct soc_camera_link link;
 	struct ov772x_edge_ctrl edgectrl;
 };
 
diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
index bb70401..88b3b57 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/soc_camera_platform.h
@@ -23,7 +23,6 @@ struct soc_camera_platform_info {
 	unsigned long bus_param;
 	struct device *dev;
 	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
-	struct soc_camera_link link;
 };
 
 #endif /* __SOC_CAMERA_H__ */
diff --git a/include/media/tw9910.h b/include/media/tw9910.h
index 73231e7..5e2895a 100644
--- a/include/media/tw9910.h
+++ b/include/media/tw9910.h
@@ -32,7 +32,6 @@ enum tw9910_mpout_pin {
 struct tw9910_video_info {
 	unsigned long          buswidth;
 	enum tw9910_mpout_pin  mpout;
-	struct soc_camera_link link;
 };
 
 
-- 
1.6.2.4

