Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56799 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936199Ab3DRVf6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:58 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 08/24] ARM: update all soc-camera users to new platform data layout
Date: Thu, 18 Apr 2013 23:35:29 +0200
Message-Id: <1366320945-21591-9-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch moves almost all ARM soc-camera users towards re-using subdevice
drivers. Only mach-shmobile/board-mackerel.c will be updated separately,
together with other soc-camera-platform users.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 arch/arm/mach-at91/board-sam9m10g45ek.c        |   19 ++++++----
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c    |   17 ++++++---
 arch/arm/mach-imx/mach-mx27_3ds.c              |   21 +++++++----
 arch/arm/mach-imx/mach-mx31_3ds.c              |   23 ++++++++----
 arch/arm/mach-imx/mach-mx35_3ds.c              |   12 ++++---
 arch/arm/mach-imx/mach-pcm037.c                |   28 ++++++++++-----
 arch/arm/mach-imx/mx31moboard-marxbot.c        |   17 ++++++---
 arch/arm/mach-imx/mx31moboard-smartbot.c       |   17 ++++++---
 arch/arm/mach-omap1/board-ams-delta.c          |   17 ++++++---
 arch/arm/mach-pxa/em-x270.c                    |   15 +++++---
 arch/arm/mach-pxa/ezx.c                        |   36 ++++++++++++-------
 arch/arm/mach-pxa/mioa701.c                    |   11 ++++--
 arch/arm/mach-pxa/palmz72.c                    |   21 +++++++----
 arch/arm/mach-pxa/pcm990-baseboard.c           |   44 ++++++++++++++---------
 arch/arm/mach-shmobile/board-ap4evb.c          |    5 ++-
 arch/arm/mach-shmobile/board-armadillo800eva.c |   17 ++++++---
 16 files changed, 205 insertions(+), 115 deletions(-)

diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index 2a94896..8c768dd 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -200,7 +200,7 @@ static struct isi_platform_data __initdata isi_data = {
  */
 #if defined(CONFIG_SOC_CAMERA_OV2640) || \
 	defined(CONFIG_SOC_CAMERA_OV2640_MODULE)
-static unsigned long isi_camera_query_bus_param(struct soc_camera_link *link)
+static unsigned long isi_camera_query_bus_param(struct soc_camera_subdev_desc *desc)
 {
 	/* ISI board for ek using default 8-bits connection */
 	return SOCAM_DATAWIDTH_8;
@@ -229,12 +229,17 @@ static struct i2c_board_info i2c_camera = {
 	I2C_BOARD_INFO("ov2640", 0x30),
 };
 
-static struct soc_camera_link iclink_ov2640 = {
-	.bus_id			= 0,
-	.board_info		= &i2c_camera,
-	.i2c_adapter_id		= 0,
-	.power			= i2c_camera_power,
-	.query_bus_param	= isi_camera_query_bus_param,
+static struct soc_camera_desc iclink_ov2640 = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv	= &iclink_ov2640,
+		.power			= i2c_camera_power,
+		.query_bus_param	= isi_camera_query_bus_param,
+	},
+	.host_desc	= {
+		.bus_id			= 0,
+		.board_info		= &i2c_camera,
+		.i2c_adapter_id		= 0,
+	},
 };
 
 static struct platform_device isi_ov2640 = {
diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
index 29ac8ee6..686138c 100644
--- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
+++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
@@ -224,12 +224,17 @@ static struct i2c_board_info visstrim_i2c_camera =  {
 	I2C_BOARD_INFO("tvp5150", 0x5d),
 };
 
-static struct soc_camera_link iclink_tvp5150 = {
-	.bus_id         = 0,
-	.board_info     = &visstrim_i2c_camera,
-	.i2c_adapter_id = 0,
-	.power = visstrim_camera_power,
-	.reset = visstrim_camera_reset,
+static struct soc_camera_desc iclink_tvp5150 = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv	= &iclink_tvp5150,
+		.power			= visstrim_camera_power,
+		.reset			= visstrim_camera_reset,
+	},
+	.host_desc	= {
+		.bus_id			= 0,
+		.board_info		= &visstrim_i2c_camera,
+		.i2c_adapter_id		= 0,
+	},
 };
 
 static struct mx2_camera_platform_data visstrim_camera = {
diff --git a/arch/arm/mach-imx/mach-mx27_3ds.c b/arch/arm/mach-imx/mach-mx27_3ds.c
index 25b3e4c..2c7d7e8 100644
--- a/arch/arm/mach-imx/mach-mx27_3ds.c
+++ b/arch/arm/mach-imx/mach-mx27_3ds.c
@@ -397,13 +397,20 @@ static struct regulator_bulk_data mx27_3ds_camera_regs[] = {
 	{ .supply = "cmos_2v8" },
 };
 
-static struct soc_camera_link iclink_ov2640 = {
-	.bus_id		= 0,
-	.board_info	= &mx27_3ds_i2c_camera,
-	.i2c_adapter_id	= 0,
-	.power		= mx27_3ds_camera_power,
-	.regulators	= mx27_3ds_camera_regs,
-	.num_regulators	= ARRAY_SIZE(mx27_3ds_camera_regs),
+static struct soc_camera_desc iclink_ov2640 = {
+	.subdev_desc	= {
+		.power		= mx27_3ds_camera_power,
+		.sd_pdata	= {
+			.regulators	= mx27_3ds_camera_regs,
+			.num_regulators	= ARRAY_SIZE(mx27_3ds_camera_regs),
+			.host_priv	= &iclink_ov2640,
+		},
+	},
+	.host_desc	= {
+		.bus_id		= 0,
+		.i2c_adapter_id	= 0,
+		.board_info	= &mx27_3ds_i2c_camera,
+	},
 };
 
 static struct platform_device mx27_3ds_ov2640 = {
diff --git a/arch/arm/mach-imx/mach-mx31_3ds.c b/arch/arm/mach-imx/mach-mx31_3ds.c
index 1ed9161..d49cde9 100644
--- a/arch/arm/mach-imx/mach-mx31_3ds.c
+++ b/arch/arm/mach-imx/mach-mx31_3ds.c
@@ -235,13 +235,20 @@ static struct regulator_bulk_data mx31_3ds_camera_regs[] = {
 	{ .supply = "cmos_2v8" },
 };
 
-static struct soc_camera_link iclink_ov2640 = {
-	.bus_id		= 0,
-	.board_info	= &mx31_3ds_i2c_camera,
-	.i2c_adapter_id	= 0,
-	.power		= mx31_3ds_camera_power,
-	.regulators	= mx31_3ds_camera_regs,
-	.num_regulators	= ARRAY_SIZE(mx31_3ds_camera_regs),
+static struct soc_camera_desc iclink_ov2640 = {
+	.subdev_desc	= {
+		.power		= mx31_3ds_camera_power,
+		.sd_pdata	= {
+			.regulators	= mx31_3ds_camera_regs,
+			.num_regulators	= ARRAY_SIZE(mx31_3ds_camera_regs),
+			.host_priv	= &iclink_ov2640,
+		},
+	},
+	.host_desc	= {
+		.bus_id		= 0,
+		.board_info	= &mx31_3ds_i2c_camera,
+		.i2c_adapter_id	= 0,
+	},
 };
 
 static struct platform_device mx31_3ds_ov2640 = {
@@ -747,7 +754,7 @@ static void __init mx31_3ds_init(void)
 				 ARRAY_SIZE(mx31_3ds_camera_gpios));
 	if (ret) {
 		pr_err("Failed to request camera gpios");
-		iclink_ov2640.power = NULL;
+		iclink_ov2640.subdev_desc.power = NULL;
 	}
 
 	mx31_3ds_init_camera();
diff --git a/arch/arm/mach-imx/mach-mx35_3ds.c b/arch/arm/mach-imx/mach-mx35_3ds.c
index a42f4f0..958748b 100644
--- a/arch/arm/mach-imx/mach-mx35_3ds.c
+++ b/arch/arm/mach-imx/mach-mx35_3ds.c
@@ -294,11 +294,13 @@ static struct i2c_board_info mx35_3ds_i2c_camera = {
 	I2C_BOARD_INFO("ov2640", 0x30),
 };
 
-static struct soc_camera_link iclink_ov2640 = {
-	.bus_id		= 0,
-	.board_info	= &mx35_3ds_i2c_camera,
-	.i2c_adapter_id	= 0,
-	.power		= NULL,
+static struct soc_camera_desc iclink_ov2640 = {
+	.subdev_desc.sd_pdata.host_priv	= &iclink_ov2640,
+	.host_desc	= {
+		.bus_id		= 0,
+		.board_info	= &mx35_3ds_i2c_camera,
+		.i2c_adapter_id	= 0,
+	},
 };
 
 static struct platform_device mx35_3ds_ov2640 = {
diff --git a/arch/arm/mach-imx/mach-pcm037.c b/arch/arm/mach-imx/mach-pcm037.c
index bc0261e..ef55ac1 100644
--- a/arch/arm/mach-imx/mach-pcm037.c
+++ b/arch/arm/mach-imx/mach-pcm037.c
@@ -303,17 +303,25 @@ static struct i2c_board_info pcm037_i2c_camera[] = {
 	},
 };
 
-static struct soc_camera_link iclink_mt9v022 = {
-	.bus_id		= 0,		/* Must match with the camera ID */
-	.board_info	= &pcm037_i2c_camera[1],
-	.i2c_adapter_id	= 2,
+static struct soc_camera_desc iclink_mt9v022 = {
+	.subdev_desc.sd_pdata.host_priv	= &iclink_mt9v022,
+	.host_desc	= {
+		.bus_id		= 0,		/* Must match with the camera ID */
+		.board_info	= &pcm037_i2c_camera[1],
+		.i2c_adapter_id	= 2,
+	},
 };
 
-static struct soc_camera_link iclink_mt9t031 = {
-	.bus_id		= 0,		/* Must match with the camera ID */
-	.power		= pcm037_camera_power,
-	.board_info	= &pcm037_i2c_camera[0],
-	.i2c_adapter_id	= 2,
+static struct soc_camera_desc iclink_mt9t031 = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &iclink_mt9t031,
+		.power		= pcm037_camera_power,
+	},
+	.host_desc	= {
+		.bus_id		= 0,		/* Must match with the camera ID */
+		.board_info	= &pcm037_i2c_camera[0],
+		.i2c_adapter_id	= 2,
+	},
 };
 
 static struct i2c_board_info pcm037_i2c_devices[] = {
@@ -653,7 +661,7 @@ static void __init pcm037_init(void)
 	if (!ret)
 		gpio_direction_output(IOMUX_TO_GPIO(MX31_PIN_CSI_D5), 1);
 	else
-		iclink_mt9t031.power = NULL;
+		iclink_mt9t031.subdev_desc.power = NULL;
 
 	pcm037_init_camera();
 
diff --git a/arch/arm/mach-imx/mx31moboard-marxbot.c b/arch/arm/mach-imx/mx31moboard-marxbot.c
index a4f43e9..9a1103b 100644
--- a/arch/arm/mach-imx/mx31moboard-marxbot.c
+++ b/arch/arm/mach-imx/mx31moboard-marxbot.c
@@ -168,12 +168,17 @@ static struct i2c_board_info marxbot_i2c_devices[] = {
 	},
 };
 
-static struct soc_camera_link base_iclink = {
-	.bus_id		= 0,		/* Must match with the camera ID */
-	.power		= marxbot_basecam_power,
-	.reset		= marxbot_basecam_reset,
-	.board_info	= &marxbot_i2c_devices[0],
-	.i2c_adapter_id	= 0,
+static struct soc_camera_desc base_iclink = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &base_iclink,
+		.power		= marxbot_basecam_power,
+		.reset		= marxbot_basecam_reset,
+	},
+	.host_desc	= {
+		.bus_id		= 0,		/* Must match with the camera ID */
+		.board_info	= &marxbot_i2c_devices[0],
+		.i2c_adapter_id	= 0,
+	},
 };
 
 static struct platform_device marxbot_camera[] = {
diff --git a/arch/arm/mach-imx/mx31moboard-smartbot.c b/arch/arm/mach-imx/mx31moboard-smartbot.c
index 04ae45d..0656dd5 100644
--- a/arch/arm/mach-imx/mx31moboard-smartbot.c
+++ b/arch/arm/mach-imx/mx31moboard-smartbot.c
@@ -78,12 +78,17 @@ static struct i2c_board_info smartbot_i2c_devices[] = {
 	},
 };
 
-static struct soc_camera_link base_iclink = {
-	.bus_id		= 0,		/* Must match with the camera ID */
-	.power		= smartbot_cam_power,
-	.reset		= smartbot_cam_reset,
-	.board_info	= &smartbot_i2c_devices[0],
-	.i2c_adapter_id	= 0,
+static struct soc_camera_desc base_iclink = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &base_iclink,
+		.power		= smartbot_cam_power,
+		.reset		= smartbot_cam_reset,
+	},
+	.host_desc	= {
+		.bus_id		= 0,		/* Must match with the camera ID */
+		.board_info	= &smartbot_i2c_devices[0],
+		.i2c_adapter_id	= 0,
+	},
 };
 
 static struct platform_device smartbot_camera[] = {
diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index 2aab761..019c62e 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -423,12 +423,17 @@ static int ams_delta_camera_power(struct device *dev, int power)
 #define ams_delta_camera_power	NULL
 #endif
 
-static struct soc_camera_link ams_delta_iclink = {
-	.bus_id         = 0,	/* OMAP1 SoC camera bus */
-	.i2c_adapter_id = 1,
-	.board_info     = &ams_delta_camera_board_info[0],
-	.module_name    = "ov6650",
-	.power		= ams_delta_camera_power,
+static struct soc_camera_desc ams_delta_iclink = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &ams_delta_iclink,
+		.power		= ams_delta_camera_power,
+	},
+	.host_desc	= {
+		.bus_id         = 0,	/* OMAP1 SoC camera bus */
+		.i2c_adapter_id = 1,
+		.board_info     = &ams_delta_camera_board_info[0],
+		.module_name    = "ov6650",
+	},
 };
 
 static struct platform_device ams_delta_camera_device = {
diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
index 446563a..4df154e 100644
--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -1007,11 +1007,16 @@ static struct i2c_board_info em_x270_i2c_cam_info[] = {
 	},
 };
 
-static struct soc_camera_link iclink = {
-	.bus_id		= 0,
-	.power		= em_x270_sensor_power,
-	.board_info	= &em_x270_i2c_cam_info[0],
-	.i2c_adapter_id	= 0,
+static struct soc_camera_desc iclink = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &iclink,
+		.power		= em_x270_sensor_power,
+	},
+	.host_desc	= {
+		.bus_id		= 0,
+		.board_info	= &em_x270_i2c_cam_info[0],
+		.i2c_adapter_id	= 0,
+	},
 };
 
 static struct platform_device em_x270_camera = {
diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
index dca1070..607cf6c 100644
--- a/arch/arm/mach-pxa/ezx.c
+++ b/arch/arm/mach-pxa/ezx.c
@@ -750,13 +750,18 @@ static struct i2c_board_info a780_camera_i2c_board_info = {
 	I2C_BOARD_INFO("mt9m111", 0x5d),
 };
 
-static struct soc_camera_link a780_iclink = {
-	.bus_id         = 0,
-	.flags          = SOCAM_SENSOR_INVERT_PCLK,
-	.i2c_adapter_id = 0,
-	.board_info     = &a780_camera_i2c_board_info,
-	.power          = a780_camera_power,
-	.reset          = a780_camera_reset,
+static struct soc_camera_desc a780_iclink = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &a780_iclink,
+		.flags          = SOCAM_SENSOR_INVERT_PCLK,
+		.power          = a780_camera_power,
+		.reset          = a780_camera_reset,
+	},
+	.host_desc	= {
+		.bus_id         = 0,
+		.i2c_adapter_id = 0,
+		.board_info     = &a780_camera_i2c_board_info,
+	},
 };
 
 static struct platform_device a780_camera = {
@@ -1025,12 +1030,17 @@ static struct i2c_board_info a910_camera_i2c_board_info = {
 	I2C_BOARD_INFO("mt9m111", 0x5d),
 };
 
-static struct soc_camera_link a910_iclink = {
-	.bus_id         = 0,
-	.i2c_adapter_id = 0,
-	.board_info     = &a910_camera_i2c_board_info,
-	.power          = a910_camera_power,
-	.reset          = a910_camera_reset,
+static struct soc_camera_desc a910_iclink = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &a910_iclink,
+		.power          = a910_camera_power,
+		.reset          = a910_camera_reset,
+	},
+	.host_desc	= {
+		.bus_id         = 0,
+		.i2c_adapter_id = 0,
+		.board_info     = &a910_camera_i2c_board_info,
+	},
 };
 
 static struct platform_device a910_camera = {
diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
index f8979b9..2e140ab 100644
--- a/arch/arm/mach-pxa/mioa701.c
+++ b/arch/arm/mach-pxa/mioa701.c
@@ -631,10 +631,13 @@ static struct i2c_board_info mioa701_i2c_devices[] = {
 	},
 };
 
-static struct soc_camera_link iclink = {
-	.bus_id		= 0, /* Match id in pxa27x_device_camera in device.c */
-	.board_info	= &mioa701_i2c_devices[0],
-	.i2c_adapter_id	= 0,
+static struct soc_camera_desc iclink = {
+	.subdev_desc.sd_pdata.host_priv = &iclink,
+	.host_desc	= {
+		.bus_id		= 0, /* Match id in pxa27x_device_camera in device.c */
+		.board_info	= &mioa701_i2c_devices[0],
+		.i2c_adapter_id	= 0,
+	},
 };
 
 struct i2c_pxa_platform_data i2c_pdata = {
diff --git a/arch/arm/mach-pxa/palmz72.c b/arch/arm/mach-pxa/palmz72.c
index 18b7fcd..32858fa 100644
--- a/arch/arm/mach-pxa/palmz72.c
+++ b/arch/arm/mach-pxa/palmz72.c
@@ -306,14 +306,19 @@ static int palmz72_camera_reset(struct device *dev)
 	return 0;
 }
 
-static struct soc_camera_link palmz72_iclink = {
-	.bus_id		= 0, /* Match id in pxa27x_device_camera in device.c */
-	.board_info	= &palmz72_i2c_device[0],
-	.i2c_adapter_id	= 0,
-	.module_name	= "ov96xx",
-	.power		= &palmz72_camera_power,
-	.reset		= &palmz72_camera_reset,
-	.flags		= SOCAM_DATAWIDTH_8,
+static struct soc_camera_desc palmz72_iclink = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &palmz72_iclink,
+		.power		= &palmz72_camera_power,
+		.reset		= &palmz72_camera_reset,
+		.flags		= SOCAM_DATAWIDTH_8,
+	},
+	.host_desc	= {
+		.bus_id		= 0, /* Match id in pxa27x_device_camera in device.c */
+		.board_info	= &palmz72_i2c_device[0],
+		.i2c_adapter_id	= 0,
+		.module_name	= "ov96xx",
+	},
 };
 
 static struct i2c_gpio_platform_data palmz72_i2c_bus_data = {
diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index fb7f1d1..ab299f0 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -415,7 +415,7 @@ static struct pca953x_platform_data pca9536_data = {
 
 static int gpio_bus_switch = -EINVAL;
 
-static int pcm990_camera_set_bus_param(struct soc_camera_link *link,
+static int pcm990_camera_set_bus_param(struct soc_camera_subdev_desc *desc,
 				       unsigned long flags)
 {
 	if (gpio_bus_switch < 0) {
@@ -433,7 +433,7 @@ static int pcm990_camera_set_bus_param(struct soc_camera_link *link,
 	return 0;
 }
 
-static unsigned long pcm990_camera_query_bus_param(struct soc_camera_link *link)
+static unsigned long pcm990_camera_query_bus_param(struct soc_camera_subdev_desc *desc)
 {
 	int ret;
 
@@ -451,7 +451,7 @@ static unsigned long pcm990_camera_query_bus_param(struct soc_camera_link *link)
 		return SOCAM_DATAWIDTH_10;
 }
 
-static void pcm990_camera_free_bus(struct soc_camera_link *link)
+static void pcm990_camera_free_bus(struct soc_camera_subdev_desc *desc)
 {
 	if (gpio_bus_switch < 0)
 		return;
@@ -481,22 +481,32 @@ static struct i2c_board_info pcm990_camera_i2c[] = {
 	},
 };
 
-static struct soc_camera_link iclink[] = {
+static struct soc_camera_desc iclink[] = {
 	{
-		.bus_id			= 0, /* Must match with the camera ID */
-		.board_info		= &pcm990_camera_i2c[0],
-		.priv			= &mt9v022_pdata,
-		.i2c_adapter_id		= 0,
-		.query_bus_param	= pcm990_camera_query_bus_param,
-		.set_bus_param		= pcm990_camera_set_bus_param,
-		.free_bus		= pcm990_camera_free_bus,
+		.subdev_desc	= {
+			.sd_pdata.host_priv	= &iclink[0],
+			.query_bus_param	= pcm990_camera_query_bus_param,
+			.set_bus_param		= pcm990_camera_set_bus_param,
+			.free_bus		= pcm990_camera_free_bus,
+			.drv_priv		= &mt9v022_pdata,
+		},
+		.host_desc	= {
+			.bus_id			= 0, /* Must match with the camera ID */
+			.board_info		= &pcm990_camera_i2c[0],
+			.i2c_adapter_id		= 0,
+		},
 	}, {
-		.bus_id			= 0, /* Must match with the camera ID */
-		.board_info		= &pcm990_camera_i2c[1],
-		.i2c_adapter_id		= 0,
-		.query_bus_param	= pcm990_camera_query_bus_param,
-		.set_bus_param		= pcm990_camera_set_bus_param,
-		.free_bus		= pcm990_camera_free_bus,
+		.subdev_desc	= {
+			.sd_pdata.host_priv	= &iclink[1],
+			.query_bus_param	= pcm990_camera_query_bus_param,
+			.set_bus_param		= pcm990_camera_set_bus_param,
+			.free_bus		= pcm990_camera_free_bus,
+		},
+		.host_desc	= {
+			.bus_id			= 0, /* Must match with the camera ID */
+			.board_info		= &pcm990_camera_i2c[1],
+			.i2c_adapter_id		= 0,
+		},
 	},
 };
 
diff --git a/arch/arm/mach-shmobile/board-ap4evb.c b/arch/arm/mach-shmobile/board-ap4evb.c
index 450e06b..3fcfa77 100644
--- a/arch/arm/mach-shmobile/board-ap4evb.c
+++ b/arch/arm/mach-shmobile/board-ap4evb.c
@@ -873,7 +873,10 @@ static struct platform_device leds_device = {
 };
 
 /* I2C */
-static struct soc_camera_subdev_desc imx074_desc;
+static struct soc_camera_subdev_desc imx074_desc = {
+	.sd_pdata.host_priv = &imx074_desc,
+};
+
 static struct i2c_board_info i2c0_devices[] = {
 	{
 		I2C_BOARD_INFO("ak4643", 0x13),
diff --git a/arch/arm/mach-shmobile/board-armadillo800eva.c b/arch/arm/mach-shmobile/board-armadillo800eva.c
index f2ec077..247e945 100644
--- a/arch/arm/mach-shmobile/board-armadillo800eva.c
+++ b/arch/arm/mach-shmobile/board-armadillo800eva.c
@@ -727,12 +727,17 @@ static struct mt9t112_camera_info mt9t111_info = {
 	.divider = { 16, 0, 0, 7, 0, 10, 14, 7, 7 },
 };
 
-static struct soc_camera_link mt9t111_link = {
-	.i2c_adapter_id	= 0,
-	.bus_id		= 0,
-	.board_info	= &i2c_camera_mt9t111,
-	.power		= mt9t111_power,
-	.priv		= &mt9t111_info,
+static struct soc_camera_desc mt9t111_link = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &mt9t111_link,
+		.power		= mt9t111_power,
+		.drv_priv	= &mt9t111_info,
+	},
+	.host_desc	= {
+		.i2c_adapter_id	= 0,
+		.bus_id		= 0,
+		.board_info	= &i2c_camera_mt9t111,
+	},
 };
 
 static struct platform_device camera_device = {
-- 
1.7.2.5

