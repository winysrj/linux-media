Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60705 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758773AbZDQSiu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 14:38:50 -0400
Date: Fri, 17 Apr 2009 20:38:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>
Subject: [PATCH 5/5 v2] soc-camera: Convert to a platform driver
In-Reply-To: <aec7e5c30904170040p6ec1721aj6885ef16573cd484@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0904172017550.5119@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
 <aec7e5c30904170040p6ec1721aj6885ef16573cd484@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert soc-camera core to a platform driver. With this approach I2C
devices are no longer statically registered in platform code, instead they
are registered dynamically by the soc-camera core, when a match with a
host driver is found. With this patch all platforms and all soc-camera
device drivers are converted too. This is a preparatory step for the
v4l-subdev conversion.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Changes since v1: addressed Robert's wishes:-), even compile-tested for 
mioa701! Fixed sh_mobile_ceu / migor and tested (still only blindly, I'll 
come to the mplayer thing some time...) - it turned out to be a great 
test-case - caught a couple of driver and soc-camera core bugs.

Darius, would be nice if you could test this patch series too (see 
archives). Unfortunately, I cannot seem to find a suitable i.MX1 platform 
code for your camera driver, so, you'd have to convert it yourself. It 
isn't very difficult though - just look at other examples, e.g., mx3.

 arch/arm/mach-mx3/pcm037.c                 |   25 ++-
 arch/arm/mach-pxa/em-x270.c                |   21 ++-
 arch/arm/mach-pxa/mioa701.c                |   19 +-
 arch/arm/mach-pxa/pcm990-baseboard.c       |   52 +++-
 arch/sh/boards/board-ap325rxa.c            |   55 +++--
 arch/sh/boards/mach-migor/setup.c          |   77 ++++--
 drivers/media/video/mt9m001.c              |  113 ++++-----
 drivers/media/video/mt9m111.c              |  152 ++++++------
 drivers/media/video/mt9t031.c              |  113 ++++-----
 drivers/media/video/mt9v022.c              |  118 +++++-----
 drivers/media/video/mx3_camera.c           |   27 ++-
 drivers/media/video/ov772x.c               |  153 +++++++-----
 drivers/media/video/pxa_camera.c           |   27 ++-
 drivers/media/video/sh_mobile_ceu_camera.c |   13 +-
 drivers/media/video/soc_camera.c           |  371 +++++++++++++++-------------
 drivers/media/video/soc_camera_platform.c  |  112 +++++----
 drivers/media/video/tw9910.c               |  106 +++++----
 include/media/soc_camera.h                 |   30 ++-
 include/media/soc_camera_platform.h        |    5 +-
 19 files changed, 894 insertions(+), 695 deletions(-)

diff --git a/arch/arm/mach-mx3/pcm037.c b/arch/arm/mach-mx3/pcm037.c
index 6bfd29a..00ce1eb 100644
--- a/arch/arm/mach-mx3/pcm037.c
+++ b/arch/arm/mach-mx3/pcm037.c
@@ -241,9 +241,17 @@ static int pcm037_camera_power(struct device *dev, int on)
 	return 0;
 }
 
+static struct i2c_board_info pcm037_i2c_2_devices[] = {
+	{
+		I2C_BOARD_INFO("mt9t031", 0x5d),
+	},
+};
+
 static struct soc_camera_link iclink = {
-	.bus_id	= 0,			/* Must match with the camera ID */
-	.power = pcm037_camera_power,
+	.bus_id		= 0,		/* Must match with the camera ID */
+	.power		= pcm037_camera_power,
+	.board_info	= &pcm037_i2c_2_devices[0],
+	.i2c_adapter_id	= 2,
 };
 
 static struct i2c_board_info pcm037_i2c_devices[] = {
@@ -256,9 +264,10 @@ static struct i2c_board_info pcm037_i2c_devices[] = {
 	}
 };
 
-static struct i2c_board_info pcm037_i2c_2_devices[] = {
-	{
-		I2C_BOARD_INFO("mt9t031", 0x5d),
+static struct platform_device pcm037_camera = {
+	.name	= "soc-camera-pdrv",
+	.id	= 0,
+	.dev	= {
 		.platform_data = &iclink,
 	},
 };
@@ -338,6 +347,9 @@ static struct platform_device *devices[] __initdata = {
 	&pcm037_flash,
 	&pcm037_eth,
 	&pcm037_sram_device,
+#if defined(CONFIG_I2C_IMX) || defined(CONFIG_I2C_IMX_MODULE)
+	&pcm037_camera,
+#endif
 };
 
 static struct ipu_platform_data mx3_ipu_data = {
@@ -395,9 +407,6 @@ static void __init mxc_board_init(void)
 	i2c_register_board_info(1, pcm037_i2c_devices,
 			ARRAY_SIZE(pcm037_i2c_devices));
 
-	i2c_register_board_info(2, pcm037_i2c_2_devices,
-			ARRAY_SIZE(pcm037_i2c_2_devices));
-
 	mxc_register_device(&mxc_i2c_device1, &pcm037_i2c_1_data);
 	mxc_register_device(&mxc_i2c_device2, &pcm037_i2c_2_data);
 #endif
diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
index 920dfb8..d4eb0c7 100644
--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -847,14 +847,23 @@ static int em_x270_sensor_power(struct device *dev, int on)
 	return 0;
 }
 
-static struct soc_camera_link iclink = {
-	.bus_id	= 0,
-	.power = em_x270_sensor_power,
-};
-
 static struct i2c_board_info em_x270_i2c_cam_info[] = {
 	{
 		I2C_BOARD_INFO("mt9m111", 0x48),
+	},
+};
+
+static struct soc_camera_link iclink = {
+	.bus_id		= 0,
+	.power		= em_x270_sensor_power,
+	.board_info	= &em_x270_i2c_cam_info[0],
+	.i2c_adapter_id	= 0,
+};
+
+static struct platform_device em_x270_camera = {
+	.name	= "soc-camera-pdrv",
+	.id	= -1,
+	.dev	= {
 		.platform_data = &iclink,
 	},
 };
@@ -866,8 +875,8 @@ static struct i2c_pxa_platform_data em_x270_i2c_info = {
 static void  __init em_x270_init_camera(void)
 {
 	pxa_set_i2c_info(&em_x270_i2c_info);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(em_x270_i2c_cam_info));
 	pxa_set_camera_info(&em_x270_camera_platform_data);
+	platform_device_register(&em_x270_camera);
 }
 #else
 static inline void em_x270_init_camera(void) {}
diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
index 97c93a7..204263d 100644
--- a/arch/arm/mach-pxa/mioa701.c
+++ b/arch/arm/mach-pxa/mioa701.c
@@ -724,19 +724,21 @@ struct pxacamera_platform_data mioa701_pxacamera_platform_data = {
 	.mclk_10khz = 5000,
 };
 
-static struct soc_camera_link iclink = {
-	.bus_id	= 0, /* Must match id in pxa27x_device_camera in device.c */
-};
-
-/* Board I2C devices. */
+/*
+ * Board I2C devices
+ */
 static struct i2c_board_info __initdata mioa701_i2c_devices[] = {
 	{
-		/* Must initialize before the camera(s) */
 		I2C_BOARD_INFO("mt9m111", 0x5d),
-		.platform_data = &iclink,
 	},
 };
 
+static struct soc_camera_link iclink = {
+	.bus_id		= 0, /* Match id in pxa27x_device_camera in device.c */
+	.board_info	= &mioa701_i2c_devices[0],
+	.i2c_adapter_id	= 0,
+};
+
 struct i2c_pxa_platform_data i2c_pdata = {
 	.fast_mode = 1,
 };
@@ -768,6 +770,7 @@ MIO_PARENT_DEV(mio_wm9713_codec,  "wm9713-codec",   &pxa2xx_ac97.dev, NULL)
 MIO_SIMPLE_DEV(mioa701_sound,	  "mioa701-wm9713", NULL)
 MIO_SIMPLE_DEV(mioa701_board,	  "mioa701-board",  NULL)
 MIO_SIMPLE_DEV(gpio_vbus,	  "gpio-vbus",      &gpio_vbus_data);
+MIO_SIMPLE_DEV(mioa701_camera,	  "soc-camera-pdrv",&iclink)
 
 static struct platform_device *devices[] __initdata = {
 	&mioa701_gpio_keys,
@@ -780,6 +783,7 @@ static struct platform_device *devices[] __initdata = {
 	&power_dev,
 	&strataflash,
 	&gpio_vbus,
+	&mioa701_camera,
 	&mioa701_board,
 };
 
@@ -825,7 +829,6 @@ static void __init mioa701_machine_init(void)
 
 	pxa_set_i2c_info(&i2c_pdata);
 	pxa_set_camera_info(&mioa701_pxacamera_platform_data);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(mioa701_i2c_devices));
 }
 
 static void mioa701_machine_exit(void)
diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index 9ce1ef2..619b90e 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -427,25 +427,54 @@ static void pcm990_camera_free_bus(struct soc_camera_link *link)
 	gpio_bus_switch = -EINVAL;
 }
 
-static struct soc_camera_link iclink = {
-	.bus_id	= 0, /* Must match with the camera ID above */
-	.query_bus_param = pcm990_camera_query_bus_param,
-	.set_bus_param = pcm990_camera_set_bus_param,
-	.free_bus = pcm990_camera_free_bus,
-};
-
 /* Board I2C devices. */
 static struct i2c_board_info __initdata pcm990_i2c_devices[] = {
 	{
 		/* Must initialize before the camera(s) */
 		I2C_BOARD_INFO("pca9536", 0x41),
 		.platform_data = &pca9536_data,
-	}, {
+	},
+};
+
+static struct i2c_board_info __initdata pcm990_camera_i2c[] = {
+	{
 		I2C_BOARD_INFO("mt9v022", 0x48),
-		.platform_data = &iclink, /* With extender */
 	}, {
 		I2C_BOARD_INFO("mt9m001", 0x5d),
-		.platform_data = &iclink, /* With extender */
+	},
+};
+
+static struct soc_camera_link iclink[] = {
+	{
+		.bus_id			= 0, /* Must match with the camera ID */
+		.board_info		= &pcm990_camera_i2c[0],
+		.i2c_adapter_id		= 0,
+		.query_bus_param	= pcm990_camera_query_bus_param,
+		.set_bus_param		= pcm990_camera_set_bus_param,
+		.free_bus		= pcm990_camera_free_bus,
+	}, {
+		.bus_id			= 0, /* Must match with the camera ID */
+		.board_info		= &pcm990_camera_i2c[1],
+		.i2c_adapter_id		= 0,
+		.query_bus_param	= pcm990_camera_query_bus_param,
+		.set_bus_param		= pcm990_camera_set_bus_param,
+		.free_bus		= pcm990_camera_free_bus,
+	},
+};
+
+static struct platform_device pcm990_camera[] = {
+	{
+		.name	= "soc-camera-pdrv",
+		.id	= 0,
+		.dev	= {
+			.platform_data = &iclink[0],
+		},
+	}, {
+		.name	= "soc-camera-pdrv",
+		.id	= 1,
+		.dev	= {
+			.platform_data = &iclink[1],
+		},
 	},
 };
 #endif /* CONFIG_VIDEO_PXA27x ||CONFIG_VIDEO_PXA27x_MODULE */
@@ -501,6 +530,9 @@ void __init pcm990_baseboard_init(void)
 	pxa_set_camera_info(&pcm990_pxacamera_platform_data);
 
 	i2c_register_board_info(0, ARRAY_AND_SIZE(pcm990_i2c_devices));
+
+	platform_device_register(&pcm990_camera[0]);
+	platform_device_register(&pcm990_camera[1]);
 #endif
 
 	printk(KERN_INFO "PCM-990 Evaluation baseboard initialized\n");
diff --git a/arch/sh/boards/board-ap325rxa.c b/arch/sh/boards/board-ap325rxa.c
index e27655b..37c9139 100644
--- a/arch/sh/boards/board-ap325rxa.c
+++ b/arch/sh/boards/board-ap325rxa.c
@@ -228,12 +228,6 @@ static struct platform_device lcdc_device = {
 	},
 };
 
-static void camera_power(int val)
-{
-	gpio_set_value(GPIO_PTZ5, val); /* RST_CAM/RSTB */
-	mdelay(10);
-}
-
 #ifdef CONFIG_I2C
 static unsigned char camera_ncm03j_magic[] =
 {
@@ -255,23 +249,28 @@ static unsigned char camera_ncm03j_magic[] =
 	0x63, 0xD4, 0x64, 0xEA, 0xD6, 0x0F,
 };
 
-static int camera_set_capture(struct soc_camera_platform_info *info,
-			      int enable)
+static int ap325rxa_camera_power(struct device *dev, int on)
 {
-	struct i2c_adapter *a = i2c_get_adapter(0);
+	gpio_set_value(GPIO_PTZ5, on); /* RST_CAM/RSTB */
+	mdelay(10);
+	return 0;
+}
+
+static int ap325rxa_camera_set_capture(struct soc_camera_platform_info *info,
+				       int enable)
+{
+	struct i2c_adapter *a = i2c_get_adapter(info->link.i2c_adapter_id);
 	struct i2c_msg msg;
 	int ret = 0;
 	int i;
 
-	camera_power(0);
 	if (!enable)
-		return 0; /* no disable for now */
+		return ap325rxa_camera_power(NULL, 0); /* no disable for now */
 
-	camera_power(1);
 	for (i = 0; i < ARRAY_SIZE(camera_ncm03j_magic); i += 2) {
 		u_int8_t buf[8];
 
-		msg.addr = 0x6e;
+		msg.addr = info->link.board_info->addr;
 		msg.buf = buf;
 		msg.len = 2;
 		msg.flags = 0;
@@ -285,8 +284,11 @@ static int camera_set_capture(struct soc_camera_platform_info *info,
 	return ret;
 }
 
+static struct i2c_board_info __initdata ap325rxa_camera_i2c = {
+	I2C_BOARD_INFO("soc_camera_platform", 0x6e),
+};
+
 static struct soc_camera_platform_info camera_info = {
-	.iface = 0,
 	.format_name = "UYVY",
 	.format_depth = 16,
 	.format = {
@@ -296,22 +298,29 @@ static struct soc_camera_platform_info camera_info = {
 		.height = 480,
 	},
 	.bus_param = SOCAM_PCLK_SAMPLE_RISING | SOCAM_HSYNC_ACTIVE_HIGH |
-	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_MASTER | SOCAM_DATAWIDTH_8,
-	.set_capture = camera_set_capture,
+		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_MASTER | SOCAM_DATAWIDTH_8,
+	.set_capture = ap325rxa_camera_set_capture,
+	.link = {
+		.bus_id = 0,
+		.board_info = &ap325rxa_camera_i2c,
+		.i2c_adapter_id	= 0,
+		.power = ap325rxa_camera_power,
+	},
 };
 
-static struct platform_device camera_device = {
-	.name		= "soc_camera_platform",
-	.dev		= {
-		.platform_data	= &camera_info,
+static struct platform_device ap325rxa_camera = {
+	.name	= "soc-camera-pdrv",
+	.id	= -1,
+	.dev	= {
+		.platform_data = &camera_info.link,
 	},
 };
 #endif /* CONFIG_I2C */
 
 static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
 	.flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_HSYNC_ACTIVE_HIGH |
-	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_DATA_ACTIVE_HIGH | SOCAM_MASTER |
-	SOCAM_DATAWIDTH_8,
+		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_DATA_ACTIVE_HIGH |
+		SOCAM_MASTER | SOCAM_DATAWIDTH_8,
 };
 
 static struct resource ceu_resources[] = {
@@ -360,7 +369,7 @@ static struct platform_device *ap325rxa_devices[] __initdata = {
 	&lcdc_device,
 	&ceu_device,
 #ifdef CONFIG_I2C
-	&camera_device,
+	&ap325rxa_camera,
 #endif
 	&nand_flash_device,
 	&sdcard_cn3_device,
diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 4fd6a72..b8cb246 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -383,21 +383,6 @@ static struct platform_device migor_ceu_device = {
 	},
 };
 
-static struct ov772x_camera_info ov7725_info = {
-	.buswidth  = SOCAM_DATAWIDTH_8,
-	.link = {
-		.power  = ov7725_power,
-	},
-};
-
-static struct tw9910_video_info tw9910_info = {
-	.buswidth = SOCAM_DATAWIDTH_8,
-	.mpout    = TW9910_MPO_FIELD,
-	.link = {
-		.power  = tw9910_power,
-	}
-};
-
 struct spi_gpio_platform_data sdcard_cn9_platform_data = {
 	.sck = GPIO_PTD0,
 	.mosi = GPIO_PTD1,
@@ -412,16 +397,6 @@ static struct platform_device sdcard_cn9_device = {
 	},
 };
 
-static struct platform_device *migor_devices[] __initdata = {
-	&smc91x_eth_device,
-	&sh_keysc_device,
-	&migor_lcdc_device,
-	&migor_ceu_device,
-	&migor_nor_flash_device,
-	&migor_nand_flash_device,
-	&sdcard_cn9_device,
-};
-
 static struct i2c_board_info migor_i2c_devices[] = {
 	{
 		I2C_BOARD_INFO("rs5c372b", 0x32),
@@ -430,16 +405,64 @@ static struct i2c_board_info migor_i2c_devices[] = {
 		I2C_BOARD_INFO("migor_ts", 0x51),
 		.irq = 38, /* IRQ6 */
 	},
+};
+
+static struct i2c_board_info migor_camera_i2c[] = {
 	{
 		I2C_BOARD_INFO("ov772x", 0x21),
-		.platform_data = &ov7725_info,
 	},
 	{
 		I2C_BOARD_INFO("tw9910", 0x45),
-		.platform_data = &tw9910_info,
 	},
 };
 
+static struct ov772x_camera_info ov7725_info = {
+	.buswidth  = SOCAM_DATAWIDTH_8,
+	.link = {
+		.power  = ov7725_power,
+		.board_info		= &migor_camera_i2c[0],
+		.i2c_adapter_id		= 0,
+	},
+};
+
+static struct tw9910_video_info tw9910_info = {
+	.buswidth = SOCAM_DATAWIDTH_8,
+	.mpout    = TW9910_MPO_FIELD,
+	.link = {
+		.power  = tw9910_power,
+		.board_info		= &migor_camera_i2c[1],
+		.i2c_adapter_id		= 0,
+	}
+};
+
+static struct platform_device migor_camera[] = {
+	{
+		.name	= "soc-camera-pdrv",
+		.id	= 0,
+		.dev	= {
+			.platform_data = &ov7725_info.link,
+		},
+	}, {
+		.name	= "soc-camera-pdrv",
+		.id	= 1,
+		.dev	= {
+			.platform_data = &tw9910_info.link,
+		},
+	},
+};
+
+static struct platform_device *migor_devices[] __initdata = {
+	&smc91x_eth_device,
+	&sh_keysc_device,
+	&migor_lcdc_device,
+	&migor_ceu_device,
+	&migor_nor_flash_device,
+	&migor_nand_flash_device,
+	&sdcard_cn9_device,
+	&migor_camera[0],
+	&migor_camera[1],
+};
+
 static struct spi_board_info migor_spi_devices[] = {
 	{
 		.modalias = "mmc_spi",
diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 459c04c..b0f4ad5 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -69,8 +69,6 @@ static const struct soc_camera_data_format mt9m001_monochrome_formats[] = {
 };
 
 struct mt9m001 {
-	struct i2c_client *client;
-	struct soc_camera_device icd;
 	int model;	/* V4L2_IDENT_MT9M001* codes from v4l2-chip-ident.h */
 	unsigned char autoexposure;
 };
@@ -111,11 +109,11 @@ static int reg_clear(struct i2c_client *client, const u8 reg,
 
 static int mt9m001_init(struct soc_camera_device *icd)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct soc_camera_link *icl = client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	int ret;
 
-	dev_dbg(icd->vdev->parent, "%s\n", __func__);
+	dev_dbg(&icd->dev, "%s\n", __func__);
 
 	if (icl->power) {
 		ret = icl->power(&client->dev, 1);
@@ -147,8 +145,8 @@ static int mt9m001_init(struct soc_camera_device *icd)
 
 static int mt9m001_release(struct soc_camera_device *icd)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct soc_camera_link *icl = client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 
 	/* Disable the chip */
 	reg_write(client, MT9M001_OUTPUT_CONTROL, 0);
@@ -161,7 +159,7 @@ static int mt9m001_release(struct soc_camera_device *icd)
 
 static int mt9m001_start_capture(struct soc_camera_device *icd)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 
 	/* Switch to master "normal" mode */
 	if (reg_write(client, MT9M001_OUTPUT_CONTROL, 2) < 0)
@@ -171,7 +169,7 @@ static int mt9m001_start_capture(struct soc_camera_device *icd)
 
 static int mt9m001_stop_capture(struct soc_camera_device *icd)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 
 	/* Stop sensor readout */
 	if (reg_write(client, MT9M001_OUTPUT_CONTROL, 0) < 0)
@@ -182,8 +180,7 @@ static int mt9m001_stop_capture(struct soc_camera_device *icd)
 static int mt9m001_set_bus_param(struct soc_camera_device *icd,
 				 unsigned long flags)
 {
-	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
-	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	unsigned long width_flag = flags & SOCAM_DATAWIDTH_MASK;
 
 	/* Only one width bit may be set */
@@ -205,8 +202,7 @@ static int mt9m001_set_bus_param(struct soc_camera_device *icd,
 
 static unsigned long mt9m001_query_bus_param(struct soc_camera_device *icd)
 {
-	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
-	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	/* MT9M001 has all capture_format parameters fixed */
 	unsigned long flags = SOCAM_PCLK_SAMPLE_FALLING |
 		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
@@ -223,8 +219,8 @@ static unsigned long mt9m001_query_bus_param(struct soc_camera_device *icd)
 static int mt9m001_set_crop(struct soc_camera_device *icd,
 			    struct v4l2_rect *rect)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m001 *mt9m001 = i2c_get_clientdata(client);
 	int ret;
 	const u16 hblank = 9, vblank = 25;
 
@@ -296,12 +292,13 @@ static int mt9m001_try_fmt(struct soc_camera_device *icd,
 static int mt9m001_get_chip_id(struct soc_camera_device *icd,
 			       struct v4l2_dbg_chip_ident *id)
 {
-	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m001 *mt9m001 = i2c_get_clientdata(client);
 
 	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
 		return -EINVAL;
 
-	if (id->match.addr != mt9m001->client->addr)
+	if (id->match.addr != client->addr)
 		return -ENODEV;
 
 	id->ident	= mt9m001->model;
@@ -314,7 +311,7 @@ static int mt9m001_get_chip_id(struct soc_camera_device *icd,
 static int mt9m001_get_register(struct soc_camera_device *icd,
 				struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
@@ -334,7 +331,7 @@ static int mt9m001_get_register(struct soc_camera_device *icd,
 static int mt9m001_set_register(struct soc_camera_device *icd,
 				struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
@@ -387,15 +384,11 @@ static const struct v4l2_queryctrl mt9m001_controls[] = {
 	}
 };
 
-static int mt9m001_video_probe(struct soc_camera_device *);
-static void mt9m001_video_remove(struct soc_camera_device *);
 static int mt9m001_get_control(struct soc_camera_device *, struct v4l2_control *);
 static int mt9m001_set_control(struct soc_camera_device *, struct v4l2_control *);
 
 static struct soc_camera_ops mt9m001_ops = {
 	.owner			= THIS_MODULE,
-	.probe			= mt9m001_video_probe,
-	.remove			= mt9m001_video_remove,
 	.init			= mt9m001_init,
 	.release		= mt9m001_release,
 	.start_capture		= mt9m001_start_capture,
@@ -418,8 +411,8 @@ static struct soc_camera_ops mt9m001_ops = {
 
 static int mt9m001_get_control(struct soc_camera_device *icd, struct v4l2_control *ctrl)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m001 *mt9m001 = i2c_get_clientdata(client);
 	int data;
 
 	switch (ctrl->id) {
@@ -438,8 +431,8 @@ static int mt9m001_get_control(struct soc_camera_device *icd, struct v4l2_contro
 
 static int mt9m001_set_control(struct soc_camera_device *icd, struct v4l2_control *ctrl)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m001 *mt9m001 = i2c_get_clientdata(client);
 	const struct v4l2_queryctrl *qctrl;
 	int data;
 
@@ -531,11 +524,11 @@ static int mt9m001_set_control(struct soc_camera_device *icd, struct v4l2_contro
 
 /* Interface active, can use i2c. If it fails, it can indeed mean, that
  * this wasn't our capture interface, so, we wait for the right one */
-static int mt9m001_video_probe(struct soc_camera_device *icd)
+static int mt9m001_video_probe(struct soc_camera_device *icd,
+			       struct i2c_client *client)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
-	struct soc_camera_link *icl = client->dev.platform_data;
+	struct mt9m001 *mt9m001 = i2c_get_clientdata(client);
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	s32 data;
 	int ret;
 	unsigned long flags;
@@ -546,6 +539,11 @@ static int mt9m001_video_probe(struct soc_camera_device *icd)
 	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
 		return -ENODEV;
 
+	/* Switch master clock on */
+	ret = soc_camera_video_start(icd, &client->dev);
+	if (ret)
+		return ret;
+
 	/* Enable the chip */
 	data = reg_write(client, MT9M001_CHIP_ENABLE, 1);
 	dev_dbg(&icd->dev, "write: %d\n", data);
@@ -553,6 +551,8 @@ static int mt9m001_video_probe(struct soc_camera_device *icd)
 	/* Read out the chip version register */
 	data = reg_read(client, MT9M001_CHIP_VERSION);
 
+	soc_camera_video_stop(icd);
+
 	/* must be 0x8411 or 0x8421 for colour sensor and 8431 for bw */
 	switch (data) {
 	case 0x8411:
@@ -565,10 +565,9 @@ static int mt9m001_video_probe(struct soc_camera_device *icd)
 		icd->formats = mt9m001_monochrome_formats;
 		break;
 	default:
-		ret = -ENODEV;
 		dev_err(&icd->dev,
 			"No MT9M001 chip detected, register read %x\n", data);
-		goto ei2c;
+		return -ENODEV;
 	}
 
 	icd->num_formats = 0;
@@ -594,26 +593,17 @@ static int mt9m001_video_probe(struct soc_camera_device *icd)
 	dev_info(&icd->dev, "Detected a MT9M001 chip ID %x (%s)\n", data,
 		 data == 0x8431 ? "C12STM" : "C12ST");
 
-	/* Now that we know the model, we can start video */
-	ret = soc_camera_video_start(icd);
-	if (ret)
-		goto eisis;
-
 	return 0;
-
-eisis:
-ei2c:
-	return ret;
 }
 
 static void mt9m001_video_remove(struct soc_camera_device *icd)
 {
-	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
-	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 
-	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n", mt9m001->client->addr,
+	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n", client->addr,
 		icd->dev.parent, icd->vdev);
-	soc_camera_video_stop(icd);
+	icd->ops = NULL;
 	if (icl->free_bus)
 		icl->free_bus(icl);
 }
@@ -622,11 +612,17 @@ static int mt9m001_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
 	struct mt9m001 *mt9m001;
-	struct soc_camera_device *icd;
+	struct soc_camera_device *icd = client->dev.platform_data;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct soc_camera_link *icl = client->dev.platform_data;
+	struct soc_camera_link *icl;
 	int ret;
 
+	if (!icd) {
+		dev_err(&client->dev, "MT9M001: missing soc-camera data!\n");
+		return -EINVAL;
+	}
+
+	icl = to_soc_camera_link(icd);
 	if (!icl) {
 		dev_err(&client->dev, "MT9M001 driver needs platform data\n");
 		return -EINVAL;
@@ -642,13 +638,10 @@ static int mt9m001_probe(struct i2c_client *client,
 	if (!mt9m001)
 		return -ENOMEM;
 
-	mt9m001->client = client;
 	i2c_set_clientdata(client, mt9m001);
 
 	/* Second stage probe - when a capture adapter is there */
-	icd = &mt9m001->icd;
 	icd->ops	= &mt9m001_ops;
-	icd->control	= &client->dev;
 	icd->x_min	= 20;
 	icd->y_min	= 12;
 	icd->x_current	= 20;
@@ -658,27 +651,27 @@ static int mt9m001_probe(struct i2c_client *client,
 	icd->height_min	= 32;
 	icd->height_max	= 1024;
 	icd->y_skip_top	= 1;
-	icd->iface	= icl->bus_id;
 	/* Simulated autoexposure. If enabled, we calculate shutter width
 	 * ourselves in the driver based on vertical blanking and frame width */
 	mt9m001->autoexposure = 1;
 
-	ret = soc_camera_device_register(icd);
-	if (ret)
-		goto eisdr;
-
-	return 0;
+	ret = mt9m001_video_probe(icd, client);
+	if (ret) {
+		i2c_set_clientdata(client, NULL);
+		kfree(mt9m001);
+	}
 
-eisdr:
-	kfree(mt9m001);
 	return ret;
 }
 
 static int mt9m001_remove(struct i2c_client *client)
 {
 	struct mt9m001 *mt9m001 = i2c_get_clientdata(client);
+	struct soc_camera_device *icd = client->dev.platform_data;
 
-	soc_camera_device_unregister(&mt9m001->icd);
+	mt9m001_video_remove(icd);
+	i2c_set_clientdata(client, NULL);
+	client->driver = NULL;
 	kfree(mt9m001);
 
 	return 0;
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index fc5e2de..06f5f97 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -148,8 +148,6 @@ enum mt9m111_context {
 };
 
 struct mt9m111 {
-	struct i2c_client *client;
-	struct soc_camera_device icd;
 	int model;	/* V4L2_IDENT_MT9M11x* codes from v4l2-chip-ident.h */
 	enum mt9m111_context context;
 	struct v4l2_rect rect;
@@ -203,7 +201,7 @@ static int mt9m111_reg_write(struct i2c_client *client, const u16 reg,
 
 	ret = reg_page_map_set(client, reg);
 	if (!ret)
-		ret = i2c_smbus_write_word_data(client, (reg & 0xff),
+		ret = i2c_smbus_write_word_data(client, reg & 0xff,
 						swab16(data));
 	dev_dbg(&client->dev, "write reg.%03x = %04x -> %d\n", reg, data, ret);
 	return ret;
@@ -232,7 +230,7 @@ static int mt9m111_reg_clear(struct i2c_client *client, const u16 reg,
 static int mt9m111_set_context(struct soc_camera_device *icd,
 			       enum mt9m111_context ctxt)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	int valB = MT9M111_CTXT_CTRL_RESTART | MT9M111_CTXT_CTRL_DEFECTCOR_B
 		| MT9M111_CTXT_CTRL_RESIZE_B | MT9M111_CTXT_CTRL_CTRL2_B
 		| MT9M111_CTXT_CTRL_GAMMA_B | MT9M111_CTXT_CTRL_READ_MODE_B
@@ -249,8 +247,8 @@ static int mt9m111_set_context(struct soc_camera_device *icd,
 static int mt9m111_setup_rect(struct soc_camera_device *icd,
 			      struct v4l2_rect *rect)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 	int ret, is_raw_format;
 	int width = rect->width;
 	int height = rect->height;
@@ -294,7 +292,7 @@ static int mt9m111_setup_rect(struct soc_camera_device *icd,
 
 static int mt9m111_setup_pixfmt(struct soc_camera_device *icd, u16 outfmt)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	int ret;
 
 	ret = reg_write(OUTPUT_FORMAT_CTRL2_A, outfmt);
@@ -315,7 +313,8 @@ static int mt9m111_setfmt_bayer10(struct soc_camera_device *icd)
 
 static int mt9m111_setfmt_rgb565(struct soc_camera_device *icd)
 {
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 	int val = 0;
 
 	if (mt9m111->swap_rgb_red_blue)
@@ -329,7 +328,8 @@ static int mt9m111_setfmt_rgb565(struct soc_camera_device *icd)
 
 static int mt9m111_setfmt_rgb555(struct soc_camera_device *icd)
 {
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 	int val = 0;
 
 	if (mt9m111->swap_rgb_red_blue)
@@ -343,7 +343,8 @@ static int mt9m111_setfmt_rgb555(struct soc_camera_device *icd)
 
 static int mt9m111_setfmt_yuv(struct soc_camera_device *icd)
 {
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 	int val = 0;
 
 	if (mt9m111->swap_yuv_cb_cr)
@@ -356,9 +357,9 @@ static int mt9m111_setfmt_yuv(struct soc_camera_device *icd)
 
 static int mt9m111_enable(struct soc_camera_device *icd)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
-	struct soc_camera_link *icl = client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 	int ret;
 
 	if (icl->power) {
@@ -378,9 +379,9 @@ static int mt9m111_enable(struct soc_camera_device *icd)
 
 static int mt9m111_disable(struct soc_camera_device *icd)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
-	struct soc_camera_link *icl = client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 	int ret;
 
 	ret = reg_clear(RESET, MT9M111_RESET_CHIP_ENABLE);
@@ -395,8 +396,8 @@ static int mt9m111_disable(struct soc_camera_device *icd)
 
 static int mt9m111_reset(struct soc_camera_device *icd)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct soc_camera_link *icl = client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	int ret;
 
 	ret = reg_set(RESET, MT9M111_RESET_RESET_MODE);
@@ -424,8 +425,7 @@ static int mt9m111_stop_capture(struct soc_camera_device *icd)
 
 static unsigned long mt9m111_query_bus_param(struct soc_camera_device *icd)
 {
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
-	struct soc_camera_link *icl = mt9m111->client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	unsigned long flags = SOCAM_MASTER | SOCAM_PCLK_SAMPLE_RISING |
 		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
 		SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATAWIDTH_8;
@@ -441,7 +441,8 @@ static int mt9m111_set_bus_param(struct soc_camera_device *icd, unsigned long f)
 static int mt9m111_set_crop(struct soc_camera_device *icd,
 			    struct v4l2_rect *rect)
 {
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 	int ret;
 
 	dev_dbg(&icd->dev, "%s left=%d, top=%d, width=%d, height=%d\n",
@@ -456,7 +457,8 @@ static int mt9m111_set_crop(struct soc_camera_device *icd,
 
 static int mt9m111_set_pixfmt(struct soc_camera_device *icd, u32 pixfmt)
 {
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 	int ret;
 
 	switch (pixfmt) {
@@ -506,7 +508,8 @@ static int mt9m111_set_pixfmt(struct soc_camera_device *icd, u32 pixfmt)
 static int mt9m111_set_fmt(struct soc_camera_device *icd,
 			   struct v4l2_format *f)
 {
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_rect rect = {
 		.left	= mt9m111->rect.left,
@@ -544,12 +547,13 @@ static int mt9m111_try_fmt(struct soc_camera_device *icd,
 static int mt9m111_get_chip_id(struct soc_camera_device *icd,
 			       struct v4l2_dbg_chip_ident *id)
 {
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 
 	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
 		return -EINVAL;
 
-	if (id->match.addr != mt9m111->client->addr)
+	if (id->match.addr != client->addr)
 		return -ENODEV;
 
 	id->ident	= mt9m111->model;
@@ -562,8 +566,8 @@ static int mt9m111_get_chip_id(struct soc_camera_device *icd,
 static int mt9m111_get_register(struct soc_camera_device *icd,
 				struct v4l2_dbg_register *reg)
 {
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	int val;
-	struct i2c_client *client = to_i2c_client(icd->control);
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0x2ff)
 		return -EINVAL;
@@ -583,7 +587,7 @@ static int mt9m111_get_register(struct soc_camera_device *icd,
 static int mt9m111_set_register(struct soc_camera_device *icd,
 				struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0x2ff)
 		return -EINVAL;
@@ -635,8 +639,6 @@ static const struct v4l2_queryctrl mt9m111_controls[] = {
 	}
 };
 
-static int mt9m111_video_probe(struct soc_camera_device *);
-static void mt9m111_video_remove(struct soc_camera_device *);
 static int mt9m111_get_control(struct soc_camera_device *,
 			       struct v4l2_control *);
 static int mt9m111_set_control(struct soc_camera_device *,
@@ -647,8 +649,6 @@ static int mt9m111_release(struct soc_camera_device *icd);
 
 static struct soc_camera_ops mt9m111_ops = {
 	.owner			= THIS_MODULE,
-	.probe			= mt9m111_video_probe,
-	.remove			= mt9m111_video_remove,
 	.init			= mt9m111_init,
 	.resume			= mt9m111_resume,
 	.release		= mt9m111_release,
@@ -672,8 +672,8 @@ static struct soc_camera_ops mt9m111_ops = {
 
 static int mt9m111_set_flip(struct soc_camera_device *icd, int flip, int mask)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 	int ret;
 
 	if (mt9m111->context == HIGHPOWER) {
@@ -693,7 +693,7 @@ static int mt9m111_set_flip(struct soc_camera_device *icd, int flip, int mask)
 
 static int mt9m111_get_global_gain(struct soc_camera_device *icd)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	int data;
 
 	data = reg_read(GLOBAL_GAIN);
@@ -705,7 +705,7 @@ static int mt9m111_get_global_gain(struct soc_camera_device *icd)
 
 static int mt9m111_set_global_gain(struct soc_camera_device *icd, int gain)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	u16 val;
 
 	if (gain > 63 * 2 * 2)
@@ -724,8 +724,8 @@ static int mt9m111_set_global_gain(struct soc_camera_device *icd, int gain)
 
 static int mt9m111_set_autoexposure(struct soc_camera_device *icd, int on)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 	int ret;
 
 	if (on)
@@ -741,8 +741,8 @@ static int mt9m111_set_autoexposure(struct soc_camera_device *icd, int on)
 
 static int mt9m111_set_autowhitebalance(struct soc_camera_device *icd, int on)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 	int ret;
 
 	if (on)
@@ -759,8 +759,8 @@ static int mt9m111_set_autowhitebalance(struct soc_camera_device *icd, int on)
 static int mt9m111_get_control(struct soc_camera_device *icd,
 			       struct v4l2_control *ctrl)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 	int data;
 
 	switch (ctrl->id) {
@@ -803,7 +803,8 @@ static int mt9m111_get_control(struct soc_camera_device *icd,
 static int mt9m111_set_control(struct soc_camera_device *icd,
 			       struct v4l2_control *ctrl)
 {
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 	const struct v4l2_queryctrl *qctrl;
 	int ret;
 
@@ -841,7 +842,8 @@ static int mt9m111_set_control(struct soc_camera_device *icd,
 
 static int mt9m111_restore_state(struct soc_camera_device *icd)
 {
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 
 	mt9m111_set_context(icd, mt9m111->context);
 	mt9m111_set_pixfmt(icd, mt9m111->pixfmt);
@@ -856,7 +858,8 @@ static int mt9m111_restore_state(struct soc_camera_device *icd)
 
 static int mt9m111_resume(struct soc_camera_device *icd)
 {
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 	int ret = 0;
 
 	if (mt9m111->powered) {
@@ -871,7 +874,8 @@ static int mt9m111_resume(struct soc_camera_device *icd)
 
 static int mt9m111_init(struct soc_camera_device *icd)
 {
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 	int ret;
 
 	mt9m111->context = HIGHPOWER;
@@ -902,10 +906,10 @@ static int mt9m111_release(struct soc_camera_device *icd)
  * Interface active, can use i2c. If it fails, it can indeed mean, that
  * this wasn't our capture interface, so, we wait for the right one
  */
-static int mt9m111_video_probe(struct soc_camera_device *icd)
+static int mt9m111_video_probe(struct soc_camera_device *icd,
+			       struct i2c_client *client)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
 	s32 data;
 	int ret;
 
@@ -917,6 +921,11 @@ static int mt9m111_video_probe(struct soc_camera_device *icd)
 	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
 		return -ENODEV;
 
+	/* Switch master clock on */
+	ret = soc_camera_video_start(icd, &client->dev);
+	if (ret)
+		goto evstart;
+
 	ret = mt9m111_enable(icd);
 	if (ret)
 		goto ei2c;
@@ -945,40 +954,42 @@ static int mt9m111_video_probe(struct soc_camera_device *icd)
 
 	dev_info(&icd->dev, "Detected a MT9M11x chip ID %x\n", data);
 
-	ret = soc_camera_video_start(icd);
-	if (ret)
-		goto eisis;
-
 	mt9m111->autoexposure = 1;
 	mt9m111->autowhitebalance = 1;
 
 	mt9m111->swap_rgb_even_odd = 1;
 	mt9m111->swap_rgb_red_blue = 1;
 
-	return 0;
-eisis:
 ei2c:
+	soc_camera_video_stop(icd);
+evstart:
 	return ret;
 }
 
 static void mt9m111_video_remove(struct soc_camera_device *icd)
 {
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 
-	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n", mt9m111->client->addr,
-		mt9m111->icd.dev.parent, mt9m111->icd.vdev);
-	soc_camera_video_stop(&mt9m111->icd);
+	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n", client->addr,
+		icd->dev.parent, icd->vdev);
+	icd->ops = NULL;
 }
 
 static int mt9m111_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
 	struct mt9m111 *mt9m111;
-	struct soc_camera_device *icd;
+	struct soc_camera_device *icd = client->dev.platform_data;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct soc_camera_link *icl = client->dev.platform_data;
+	struct soc_camera_link *icl;
 	int ret;
 
+	if (!icd) {
+		dev_err(&client->dev, "MT9M11x: missing soc-camera data!\n");
+		return -EINVAL;
+	}
+
+	icl = to_soc_camera_link(icd);
 	if (!icl) {
 		dev_err(&client->dev, "MT9M11x driver needs platform data\n");
 		return -EINVAL;
@@ -994,13 +1005,10 @@ static int mt9m111_probe(struct i2c_client *client,
 	if (!mt9m111)
 		return -ENOMEM;
 
-	mt9m111->client = client;
 	i2c_set_clientdata(client, mt9m111);
 
 	/* Second stage probe - when a capture adapter is there */
-	icd 		= &mt9m111->icd;
 	icd->ops	= &mt9m111_ops;
-	icd->control	= &client->dev;
 	icd->x_min	= MT9M111_MIN_DARK_COLS;
 	icd->y_min	= MT9M111_MIN_DARK_ROWS;
 	icd->x_current	= icd->x_min;
@@ -1010,22 +1018,24 @@ static int mt9m111_probe(struct i2c_client *client,
 	icd->height_min	= MT9M111_MIN_DARK_COLS;
 	icd->height_max	= MT9M111_MAX_HEIGHT;
 	icd->y_skip_top	= 0;
-	icd->iface	= icl->bus_id;
 
-	ret = soc_camera_device_register(icd);
-	if (ret)
-		goto eisdr;
-	return 0;
+	ret = mt9m111_video_probe(icd, client);
+	if (ret) {
+		i2c_set_clientdata(client, NULL);
+		kfree(mt9m111);
+	}
 
-eisdr:
-	kfree(mt9m111);
 	return ret;
 }
 
 static int mt9m111_remove(struct i2c_client *client)
 {
 	struct mt9m111 *mt9m111 = i2c_get_clientdata(client);
-	soc_camera_device_unregister(&mt9m111->icd);
+	struct soc_camera_device *icd = client->dev.platform_data;
+
+	mt9m111_video_remove(icd);
+	i2c_set_clientdata(client, NULL);
+	client->driver = NULL;
 	kfree(mt9m111);
 
 	return 0;
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index f72aeb7..da09906 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -68,8 +68,6 @@ static const struct soc_camera_data_format mt9t031_colour_formats[] = {
 };
 
 struct mt9t031 {
-	struct i2c_client *client;
-	struct soc_camera_device icd;
 	int model;	/* V4L2_IDENT_MT9T031* codes from v4l2-chip-ident.h */
 	unsigned char autoexposure;
 	u16 xskip;
@@ -138,8 +136,8 @@ static int get_shutter(struct i2c_client *client, u32 *data)
 
 static int mt9t031_init(struct soc_camera_device *icd)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct soc_camera_link *icl = client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	int ret;
 
 	if (icl->power) {
@@ -166,8 +164,8 @@ static int mt9t031_init(struct soc_camera_device *icd)
 
 static int mt9t031_release(struct soc_camera_device *icd)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct soc_camera_link *icl = client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 
 	/* Disable the chip */
 	reg_clear(client, MT9T031_OUTPUT_CONTROL, 2);
@@ -180,7 +178,7 @@ static int mt9t031_release(struct soc_camera_device *icd)
 
 static int mt9t031_start_capture(struct soc_camera_device *icd)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 
 	/* Switch to master "normal" mode */
 	if (reg_set(client, MT9T031_OUTPUT_CONTROL, 2) < 0)
@@ -190,7 +188,7 @@ static int mt9t031_start_capture(struct soc_camera_device *icd)
 
 static int mt9t031_stop_capture(struct soc_camera_device *icd)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 
 	/* Stop sensor readout */
 	if (reg_clear(client, MT9T031_OUTPUT_CONTROL, 2) < 0)
@@ -201,7 +199,7 @@ static int mt9t031_stop_capture(struct soc_camera_device *icd)
 static int mt9t031_set_bus_param(struct soc_camera_device *icd,
 				 unsigned long flags)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 
 	/* The caller should have queried our parameters, check anyway */
 	if (flags & ~MT9T031_BUS_PARAM)
@@ -217,8 +215,7 @@ static int mt9t031_set_bus_param(struct soc_camera_device *icd,
 
 static unsigned long mt9t031_query_bus_param(struct soc_camera_device *icd)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
-	struct soc_camera_link *icl = mt9t031->client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 
 	return soc_camera_apply_sensor_flags(icl, MT9T031_BUS_PARAM);
 }
@@ -238,8 +235,8 @@ static void recalculate_limits(struct soc_camera_device *icd,
 static int mt9t031_set_params(struct soc_camera_device *icd,
 			      struct v4l2_rect *rect, u16 xskip, u16 yskip)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
 	int ret;
 	u16 xbin, ybin, width, height, left, top;
 	const u16 hblank = MT9T031_HORIZONTAL_BLANK,
@@ -336,7 +333,8 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
 static int mt9t031_set_crop(struct soc_camera_device *icd,
 			    struct v4l2_rect *rect)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
 
 	/* CROP - no change in scaling, or in limits */
 	return mt9t031_set_params(icd, rect, mt9t031->xskip, mt9t031->yskip);
@@ -345,7 +343,8 @@ static int mt9t031_set_crop(struct soc_camera_device *icd,
 static int mt9t031_set_fmt(struct soc_camera_device *icd,
 			   struct v4l2_format *f)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
 	int ret;
 	u16 xskip, yskip;
 	struct v4l2_rect rect = {
@@ -403,12 +402,13 @@ static int mt9t031_try_fmt(struct soc_camera_device *icd,
 static int mt9t031_get_chip_id(struct soc_camera_device *icd,
 			       struct v4l2_dbg_chip_ident *id)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
 
 	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
 		return -EINVAL;
 
-	if (id->match.addr != mt9t031->client->addr)
+	if (id->match.addr != client->addr)
 		return -ENODEV;
 
 	id->ident	= mt9t031->model;
@@ -421,7 +421,7 @@ static int mt9t031_get_chip_id(struct soc_camera_device *icd,
 static int mt9t031_get_register(struct soc_camera_device *icd,
 				struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
@@ -440,7 +440,7 @@ static int mt9t031_get_register(struct soc_camera_device *icd,
 static int mt9t031_set_register(struct soc_camera_device *icd,
 				struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
@@ -501,15 +501,11 @@ static const struct v4l2_queryctrl mt9t031_controls[] = {
 	}
 };
 
-static int mt9t031_video_probe(struct soc_camera_device *);
-static void mt9t031_video_remove(struct soc_camera_device *);
 static int mt9t031_get_control(struct soc_camera_device *, struct v4l2_control *);
 static int mt9t031_set_control(struct soc_camera_device *, struct v4l2_control *);
 
 static struct soc_camera_ops mt9t031_ops = {
 	.owner			= THIS_MODULE,
-	.probe			= mt9t031_video_probe,
-	.remove			= mt9t031_video_remove,
 	.init			= mt9t031_init,
 	.release		= mt9t031_release,
 	.start_capture		= mt9t031_start_capture,
@@ -532,8 +528,8 @@ static struct soc_camera_ops mt9t031_ops = {
 
 static int mt9t031_get_control(struct soc_camera_device *icd, struct v4l2_control *ctrl)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
 	int data;
 
 	switch (ctrl->id) {
@@ -558,8 +554,8 @@ static int mt9t031_get_control(struct soc_camera_device *icd, struct v4l2_contro
 
 static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_control *ctrl)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
 	const struct v4l2_queryctrl *qctrl;
 	int data;
 
@@ -665,10 +661,10 @@ static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_contro
 
 /* Interface active, can use i2c. If it fails, it can indeed mean, that
  * this wasn't our capture interface, so, we wait for the right one */
-static int mt9t031_video_probe(struct soc_camera_device *icd)
+static int mt9t031_video_probe(struct soc_camera_device *icd,
+			       struct i2c_client *client)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
 	s32 data;
 	int ret;
 
@@ -678,6 +674,11 @@ static int mt9t031_video_probe(struct soc_camera_device *icd)
 	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
 		return -ENODEV;
 
+	/* Switch master clock on */
+	ret = soc_camera_video_start(icd, &client->dev);
+	if (ret)
+		return ret;
+
 	/* Enable the chip */
 	data = reg_write(client, MT9T031_CHIP_ENABLE, 1);
 	dev_dbg(&icd->dev, "write: %d\n", data);
@@ -685,6 +686,8 @@ static int mt9t031_video_probe(struct soc_camera_device *icd)
 	/* Read out the chip version register */
 	data = reg_read(client, MT9T031_CHIP_VERSION);
 
+	soc_camera_video_stop(icd);
+
 	switch (data) {
 	case 0x1621:
 		mt9t031->model = V4L2_IDENT_MT9T031;
@@ -692,44 +695,40 @@ static int mt9t031_video_probe(struct soc_camera_device *icd)
 		icd->num_formats = ARRAY_SIZE(mt9t031_colour_formats);
 		break;
 	default:
-		ret = -ENODEV;
 		dev_err(&icd->dev,
 			"No MT9T031 chip detected, register read %x\n", data);
-		goto ei2c;
+		return -ENODEV;
 	}
 
 	dev_info(&icd->dev, "Detected a MT9T031 chip ID %x\n", data);
 
-	/* Now that we know the model, we can start video */
-	ret = soc_camera_video_start(icd);
-	if (ret)
-		goto evstart;
-
 	return 0;
-
-evstart:
-ei2c:
-	return ret;
 }
 
 static void mt9t031_video_remove(struct soc_camera_device *icd)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 
-	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n", mt9t031->client->addr,
+	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n", client->addr,
 		icd->dev.parent, icd->vdev);
-	soc_camera_video_stop(icd);
+	icd->ops = NULL;
 }
 
 static int mt9t031_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
 	struct mt9t031 *mt9t031;
-	struct soc_camera_device *icd;
+	struct soc_camera_device *icd = client->dev.platform_data;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct soc_camera_link *icl = client->dev.platform_data;
+	struct soc_camera_link *icl;
 	int ret;
 
+	if (!icd) {
+		dev_err(&client->dev, "MT9T031: missing soc-camera data!\n");
+		return -EINVAL;
+	}
+
+	icl = to_soc_camera_link(icd);
 	if (!icl) {
 		dev_err(&client->dev, "MT9T031 driver needs platform data\n");
 		return -EINVAL;
@@ -745,13 +744,10 @@ static int mt9t031_probe(struct i2c_client *client,
 	if (!mt9t031)
 		return -ENOMEM;
 
-	mt9t031->client = client;
 	i2c_set_clientdata(client, mt9t031);
 
 	/* Second stage probe - when a capture adapter is there */
-	icd = &mt9t031->icd;
 	icd->ops	= &mt9t031_ops;
-	icd->control	= &client->dev;
 	icd->x_min	= MT9T031_COLUMN_SKIP;
 	icd->y_min	= MT9T031_ROW_SKIP;
 	icd->x_current	= icd->x_min;
@@ -761,7 +757,6 @@ static int mt9t031_probe(struct i2c_client *client,
 	icd->height_min	= MT9T031_MIN_HEIGHT;
 	icd->height_max	= MT9T031_MAX_HEIGHT;
 	icd->y_skip_top	= 0;
-	icd->iface	= icl->bus_id;
 	/* Simulated autoexposure. If enabled, we calculate shutter width
 	 * ourselves in the driver based on vertical blanking and frame width */
 	mt9t031->autoexposure = 1;
@@ -769,24 +764,24 @@ static int mt9t031_probe(struct i2c_client *client,
 	mt9t031->xskip = 1;
 	mt9t031->yskip = 1;
 
-	ret = soc_camera_device_register(icd);
-	if (ret)
-		goto eisdr;
-
-	return 0;
+	ret = mt9t031_video_probe(icd, client);
+	if (ret) {
+		icd->ops = NULL;
+		i2c_set_clientdata(client, NULL);
+		kfree(mt9t031);
+	}
 
-eisdr:
-	i2c_set_clientdata(client, NULL);
-	kfree(mt9t031);
 	return ret;
 }
 
 static int mt9t031_remove(struct i2c_client *client)
 {
 	struct mt9t031 *mt9t031 = i2c_get_clientdata(client);
+	struct soc_camera_device *icd = client->dev.platform_data;
 
-	soc_camera_device_unregister(&mt9t031->icd);
+	mt9t031_video_remove(icd);
 	i2c_set_clientdata(client, NULL);
+	client->driver = NULL;
 	kfree(mt9t031);
 
 	return 0;
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index be20d31..1683af1 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -85,8 +85,6 @@ static const struct soc_camera_data_format mt9v022_monochrome_formats[] = {
 };
 
 struct mt9v022 {
-	struct i2c_client *client;
-	struct soc_camera_device icd;
 	int model;	/* V4L2_IDENT_MT9V022* codes from v4l2-chip-ident.h */
 	u16 chip_control;
 };
@@ -127,9 +125,9 @@ static int reg_clear(struct i2c_client *client, const u8 reg,
 
 static int mt9v022_init(struct soc_camera_device *icd)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
-	struct soc_camera_link *icl = client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
 	int ret;
 
 	if (icl->power) {
@@ -173,19 +171,19 @@ static int mt9v022_init(struct soc_camera_device *icd)
 
 static int mt9v022_release(struct soc_camera_device *icd)
 {
-	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
-	struct soc_camera_link *icl = mt9v022->client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 
 	if (icl->power)
-		icl->power(&mt9v022->client->dev, 0);
+		icl->power(&client->dev, 0);
 
 	return 0;
 }
 
 static int mt9v022_start_capture(struct soc_camera_device *icd)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
 	/* Switch to master "normal" mode */
 	mt9v022->chip_control &= ~0x10;
 	if (reg_write(client, MT9V022_CHIP_CONTROL,
@@ -196,8 +194,8 @@ static int mt9v022_start_capture(struct soc_camera_device *icd)
 
 static int mt9v022_stop_capture(struct soc_camera_device *icd)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
 	/* Switch to snapshot mode */
 	mt9v022->chip_control |= 0x10;
 	if (reg_write(client, MT9V022_CHIP_CONTROL,
@@ -209,9 +207,9 @@ static int mt9v022_stop_capture(struct soc_camera_device *icd)
 static int mt9v022_set_bus_param(struct soc_camera_device *icd,
 				 unsigned long flags)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
-	struct soc_camera_link *icl = client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	unsigned int width_flag = flags & SOCAM_DATAWIDTH_MASK;
 	int ret;
 	u16 pixclk = 0;
@@ -263,8 +261,7 @@ static int mt9v022_set_bus_param(struct soc_camera_device *icd,
 
 static unsigned long mt9v022_query_bus_param(struct soc_camera_device *icd)
 {
-	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
-	struct soc_camera_link *icl = mt9v022->client->dev.platform_data;
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	unsigned int width_flag;
 
 	if (icl->query_bus_param)
@@ -283,7 +280,7 @@ static unsigned long mt9v022_query_bus_param(struct soc_camera_device *icd)
 static int mt9v022_set_crop(struct soc_camera_device *icd,
 			    struct v4l2_rect *rect)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	int ret;
 
 	/* Like in example app. Contradicts the datasheet though */
@@ -326,7 +323,8 @@ static int mt9v022_set_crop(struct soc_camera_device *icd,
 static int mt9v022_set_fmt(struct soc_camera_device *icd,
 			   struct v4l2_format *f)
 {
-	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_rect rect = {
 		.left	= icd->x_current,
@@ -380,12 +378,13 @@ static int mt9v022_try_fmt(struct soc_camera_device *icd,
 static int mt9v022_get_chip_id(struct soc_camera_device *icd,
 			       struct v4l2_dbg_chip_ident *id)
 {
-	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
 
 	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
 		return -EINVAL;
 
-	if (id->match.addr != mt9v022->client->addr)
+	if (id->match.addr != client->addr)
 		return -ENODEV;
 
 	id->ident	= mt9v022->model;
@@ -398,7 +397,7 @@ static int mt9v022_get_chip_id(struct soc_camera_device *icd,
 static int mt9v022_get_register(struct soc_camera_device *icd,
 				struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
@@ -418,7 +417,7 @@ static int mt9v022_get_register(struct soc_camera_device *icd,
 static int mt9v022_set_register(struct soc_camera_device *icd,
 				struct v4l2_dbg_register *reg)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
@@ -487,15 +486,11 @@ static const struct v4l2_queryctrl mt9v022_controls[] = {
 	}
 };
 
-static int mt9v022_video_probe(struct soc_camera_device *);
-static void mt9v022_video_remove(struct soc_camera_device *);
 static int mt9v022_get_control(struct soc_camera_device *, struct v4l2_control *);
 static int mt9v022_set_control(struct soc_camera_device *, struct v4l2_control *);
 
 static struct soc_camera_ops mt9v022_ops = {
 	.owner			= THIS_MODULE,
-	.probe			= mt9v022_video_probe,
-	.remove			= mt9v022_video_remove,
 	.init			= mt9v022_init,
 	.release		= mt9v022_release,
 	.start_capture		= mt9v022_start_capture,
@@ -519,7 +514,7 @@ static struct soc_camera_ops mt9v022_ops = {
 static int mt9v022_get_control(struct soc_camera_device *icd,
 			       struct v4l2_control *ctrl)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	int data;
 
 	switch (ctrl->id) {
@@ -555,7 +550,7 @@ static int mt9v022_set_control(struct soc_camera_device *icd,
 			       struct v4l2_control *ctrl)
 {
 	int data;
-	struct i2c_client *client = to_i2c_client(icd->control);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	const struct v4l2_queryctrl *qctrl;
 
 	qctrl = soc_camera_find_qctrl(&mt9v022_ops, ctrl->id);
@@ -652,11 +647,11 @@ static int mt9v022_set_control(struct soc_camera_device *icd,
 
 /* Interface active, can use i2c. If it fails, it can indeed mean, that
  * this wasn't our capture interface, so, we wait for the right one */
-static int mt9v022_video_probe(struct soc_camera_device *icd)
+static int mt9v022_video_probe(struct soc_camera_device *icd,
+			       struct i2c_client *client)
 {
-	struct i2c_client *client = to_i2c_client(icd->control);
-	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
-	struct soc_camera_link *icl = client->dev.platform_data;
+	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	s32 data;
 	int ret;
 	unsigned long flags;
@@ -665,6 +660,11 @@ static int mt9v022_video_probe(struct soc_camera_device *icd)
 	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
 		return -ENODEV;
 
+	/* Switch master clock on */
+	ret = soc_camera_video_start(icd, &client->dev);
+	if (ret)
+		return ret;
+
 	/* Read out the chip version register */
 	data = reg_read(client, MT9V022_CHIP_VERSION);
 
@@ -684,6 +684,8 @@ static int mt9v022_video_probe(struct soc_camera_device *icd)
 	udelay(200);
 	if (reg_read(client, MT9V022_RESET)) {
 		dev_err(&icd->dev, "Resetting MT9V022 failed!\n");
+		if (ret > 0)
+			ret = -EIO;
 		goto ei2c;
 	}
 
@@ -700,7 +702,7 @@ static int mt9v022_video_probe(struct soc_camera_device *icd)
 	}
 
 	if (ret < 0)
-		goto eisis;
+		goto ei2c;
 
 	icd->num_formats = 0;
 
@@ -722,29 +724,24 @@ static int mt9v022_video_probe(struct soc_camera_device *icd)
 	if (flags & SOCAM_DATAWIDTH_8)
 		icd->num_formats++;
 
-	ret = soc_camera_video_start(icd);
-	if (ret < 0)
-		goto eisis;
-
 	dev_info(&icd->dev, "Detected a MT9V022 chip ID %x, %s sensor\n",
 		 data, mt9v022->model == V4L2_IDENT_MT9V022IX7ATM ?
 		 "monochrome" : "colour");
 
-	return 0;
-
-eisis:
 ei2c:
+	soc_camera_video_stop(icd);
+
 	return ret;
 }
 
 static void mt9v022_video_remove(struct soc_camera_device *icd)
 {
-	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
-	struct soc_camera_link *icl = mt9v022->client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 
-	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n", mt9v022->client->addr,
+	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n", client->addr,
 		icd->dev.parent, icd->vdev);
-	soc_camera_video_stop(icd);
+	icd->ops = NULL;
 	if (icl->free_bus)
 		icl->free_bus(icl);
 }
@@ -753,11 +750,17 @@ static int mt9v022_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
 	struct mt9v022 *mt9v022;
-	struct soc_camera_device *icd;
+	struct soc_camera_device *icd = client->dev.platform_data;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct soc_camera_link *icl = client->dev.platform_data;
+	struct soc_camera_link *icl;
 	int ret;
 
+	if (!icd) {
+		dev_err(&client->dev, "MT9V022: missing soc-camera data!\n");
+		return -EINVAL;
+	}
+
+	icl = to_soc_camera_link(icd);
 	if (!icl) {
 		dev_err(&client->dev, "MT9V022 driver needs platform data\n");
 		return -EINVAL;
@@ -774,12 +777,9 @@ static int mt9v022_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	mt9v022->chip_control = MT9V022_CHIP_CONTROL_DEFAULT;
-	mt9v022->client = client;
 	i2c_set_clientdata(client, mt9v022);
 
-	icd = &mt9v022->icd;
 	icd->ops	= &mt9v022_ops;
-	icd->control	= &client->dev;
 	icd->x_min	= 1;
 	icd->y_min	= 4;
 	icd->x_current	= 1;
@@ -789,24 +789,24 @@ static int mt9v022_probe(struct i2c_client *client,
 	icd->height_min	= 32;
 	icd->height_max	= 480;
 	icd->y_skip_top	= 1;
-	icd->iface	= icl->bus_id;
-
-	ret = soc_camera_device_register(icd);
-	if (ret)
-		goto eisdr;
 
-	return 0;
+	ret = mt9v022_video_probe(icd, client);
+	if (ret) {
+		i2c_set_clientdata(client, NULL);
+		kfree(mt9v022);
+	}
 
-eisdr:
-	kfree(mt9v022);
 	return ret;
 }
 
 static int mt9v022_remove(struct i2c_client *client)
 {
 	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
+	struct soc_camera_device *icd = client->dev.platform_data;
 
-	soc_camera_device_unregister(&mt9v022->icd);
+	mt9v022_video_remove(icd);
+	i2c_set_clientdata(client, NULL);
+	client->driver = NULL;
 	kfree(mt9v022);
 
 	return 0;
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index cb13faa..ed752c5 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -502,18 +502,19 @@ static int mx3_camera_add_device(struct soc_camera_device *icd)
 
 	mx3_camera_activate(mx3_cam, icd);
 	ret = icd->ops->init(icd);
-	if (ret < 0) {
-		clk_disable(mx3_cam->clk);
+	if (ret < 0)
 		goto einit;
-	}
 
 	mx3_cam->icd = icd;
 
+	dev_info(&icd->dev, "MX3 Camera driver attached to camera %d\n",
+		 icd->devnum);
+
+	return 0;
+
 einit:
+	clk_disable(mx3_cam->clk);
 ebusy:
-	if (!ret)
-		dev_info(&icd->dev, "MX3 Camera driver attached to camera %d\n",
-			 icd->devnum);
 
 	return ret;
 }
@@ -946,9 +947,10 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	camera_flags = icd->ops->query_bus_param(icd);
 
 	common_flags = soc_camera_bus_param_compatible(camera_flags, bus_flags);
+	dev_dbg(ici->dev, "Flags cam: 0x%lx host: 0x%lx common: 0x%lx\n",
+		camera_flags, bus_flags, common_flags);
 	if (!common_flags) {
-		dev_dbg(ici->dev, "no common flags: camera %lx, host %lx\n",
-			camera_flags, bus_flags);
+		dev_dbg(ici->dev, "no common flags");
 		return -EINVAL;
 	}
 
@@ -1001,8 +1003,11 @@ static int mx3_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 			SOCAM_DATAWIDTH_4;
 
 	ret = icd->ops->set_bus_param(icd, common_flags);
-	if (ret < 0)
+	if (ret < 0) {
+		dev_dbg(ici->dev, "camera set_bus_param(%lx) returned %d\n",
+			common_flags, ret);
 		return ret;
+	}
 
 	/*
 	 * So far only gated clock mode is supported. Add a line
@@ -1130,8 +1135,9 @@ static int mx3_camera_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&mx3_cam->capture);
 	spin_lock_init(&mx3_cam->lock);
 
-	base = ioremap(res->start, res->end - res->start + 1);
+	base = ioremap(res->start, resource_size(res));
 	if (!base) {
+		pr_err("Couldn't map %x@%x\n", resource_size(res), res->start);
 		err = -ENOMEM;
 		goto eioremap;
 	}
@@ -1218,3 +1224,4 @@ module_exit(mx3_camera_exit);
 MODULE_DESCRIPTION("i.MX3x SoC Camera Host driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <lg@denx.de>");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" MX3_CAM_DRV_NAME);
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index c0d9112..c90a918 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -399,8 +399,6 @@ struct ov772x_win_size {
 
 struct ov772x_priv {
 	struct ov772x_camera_info        *info;
-	struct i2c_client                *client;
-	struct soc_camera_device          icd;
 	const struct ov772x_color_format *fmt;
 	const struct ov772x_win_size     *win;
 	int                               model;
@@ -619,53 +617,56 @@ static int ov772x_reset(struct i2c_client *client)
 
 static int ov772x_init(struct soc_camera_device *icd)
 {
-	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	int ret = 0;
 
-	if (priv->info->link.power) {
-		ret = priv->info->link.power(&priv->client->dev, 1);
+	if (icl->power) {
+		ret = icl->power(&client->dev, 1);
 		if (ret < 0)
 			return ret;
 	}
 
-	if (priv->info->link.reset)
-		ret = priv->info->link.reset(&priv->client->dev);
+	if (icl->reset)
+		ret = icl->reset(&client->dev);
 
 	return ret;
 }
 
 static int ov772x_release(struct soc_camera_device *icd)
 {
-	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	int ret = 0;
 
-	if (priv->info->link.power)
-		ret = priv->info->link.power(&priv->client->dev, 0);
+	if (icl->power)
+		ret = icl->power(&client->dev, 0);
 
 	return ret;
 }
 
 static int ov772x_start_capture(struct soc_camera_device *icd)
 {
-	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct ov772x_priv *priv = i2c_get_clientdata(client);
 
 	if (!priv->win || !priv->fmt) {
 		dev_err(&icd->dev, "norm or win select error\n");
 		return -EPERM;
 	}
 
-	ov772x_mask_set(priv->client, COM2, SOFT_SLEEP_MODE, 0);
+	ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, 0);
 
 	dev_dbg(&icd->dev,
-		 "format %s, win %s\n", priv->fmt->name, priv->win->name);
+		"format %s, win %s\n", priv->fmt->name, priv->win->name);
 
 	return 0;
 }
 
 static int ov772x_stop_capture(struct soc_camera_device *icd)
 {
-	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
-	ov772x_mask_set(priv->client, COM2, SOFT_SLEEP_MODE, SOFT_SLEEP_MODE);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, SOFT_SLEEP_MODE);
 	return 0;
 }
 
@@ -677,8 +678,9 @@ static int ov772x_set_bus_param(struct soc_camera_device *icd,
 
 static unsigned long ov772x_query_bus_param(struct soc_camera_device *icd)
 {
-	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
-	struct soc_camera_link *icl = &priv->info->link;
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct ov772x_priv *priv = i2c_get_clientdata(client);
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
 		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
 		SOCAM_DATA_ACTIVE_HIGH | priv->info->buswidth;
@@ -689,7 +691,8 @@ static unsigned long ov772x_query_bus_param(struct soc_camera_device *icd)
 static int ov772x_get_control(struct soc_camera_device *icd,
 			      struct v4l2_control *ctrl)
 {
-	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct ov772x_priv *priv = i2c_get_clientdata(client);
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
@@ -705,7 +708,8 @@ static int ov772x_get_control(struct soc_camera_device *icd,
 static int ov772x_set_control(struct soc_camera_device *icd,
 			      struct v4l2_control *ctrl)
 {
-	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct ov772x_priv *priv = i2c_get_clientdata(client);
 	int ret = 0;
 	u8 val;
 
@@ -715,14 +719,14 @@ static int ov772x_set_control(struct soc_camera_device *icd,
 		priv->flag_vflip = ctrl->value;
 		if (priv->info->flags & OV772X_FLAG_VFLIP)
 			val ^= VFLIP_IMG;
-		ret = ov772x_mask_set(priv->client, COM3, VFLIP_IMG, val);
+		ret = ov772x_mask_set(client, COM3, VFLIP_IMG, val);
 		break;
 	case V4L2_CID_HFLIP:
 		val = ctrl->value ? HFLIP_IMG : 0x00;
 		priv->flag_hflip = ctrl->value;
 		if (priv->info->flags & OV772X_FLAG_HFLIP)
 			val ^= HFLIP_IMG;
-		ret = ov772x_mask_set(priv->client, COM3, HFLIP_IMG, val);
+		ret = ov772x_mask_set(client, COM3, HFLIP_IMG, val);
 		break;
 	}
 
@@ -730,9 +734,10 @@ static int ov772x_set_control(struct soc_camera_device *icd,
 }
 
 static int ov772x_get_chip_id(struct soc_camera_device *icd,
-			      struct v4l2_dbg_chip_ident   *id)
+			      struct v4l2_dbg_chip_ident *id)
 {
-	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct ov772x_priv *priv = i2c_get_clientdata(client);
 
 	id->ident    = priv->model;
 	id->revision = 0;
@@ -744,14 +749,14 @@ static int ov772x_get_chip_id(struct soc_camera_device *icd,
 static int ov772x_get_register(struct soc_camera_device *icd,
 			       struct v4l2_dbg_register *reg)
 {
-	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
-	int                 ret;
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	int ret;
 
 	reg->size = 1;
 	if (reg->reg > 0xff)
 		return -EINVAL;
 
-	ret = i2c_smbus_read_byte_data(priv->client, reg->reg);
+	ret = i2c_smbus_read_byte_data(client, reg->reg);
 	if (ret < 0)
 		return ret;
 
@@ -763,13 +768,13 @@ static int ov772x_get_register(struct soc_camera_device *icd,
 static int ov772x_set_register(struct soc_camera_device *icd,
 			       struct v4l2_dbg_register *reg)
 {
-	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 
 	if (reg->reg > 0xff ||
 	    reg->val > 0xff)
 		return -EINVAL;
 
-	return i2c_smbus_write_byte_data(priv->client, reg->reg, reg->val);
+	return i2c_smbus_write_byte_data(client, reg->reg, reg->val);
 }
 #endif
 
@@ -793,9 +798,11 @@ ov772x_select_win(u32 width, u32 height)
 	return win;
 }
 
-static int ov772x_set_params(struct ov772x_priv *priv, u32 width, u32 height,
-			     u32 pixfmt)
+static int ov772x_set_params(struct soc_camera_device *icd,
+			     u32 width, u32 height, u32 pixfmt)
 {
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct ov772x_priv *priv = i2c_get_clientdata(client);
 	int ret = -EINVAL;
 	u8  val;
 	int i;
@@ -810,6 +817,7 @@ static int ov772x_set_params(struct ov772x_priv *priv, u32 width, u32 height,
 			break;
 		}
 	}
+	dev_dbg(&icd->dev, "Using fmt %x #%d\n", pixfmt, i);
 	if (!priv->fmt)
 		goto ov772x_set_fmt_error;
 
@@ -821,7 +829,7 @@ static int ov772x_set_params(struct ov772x_priv *priv, u32 width, u32 height,
 	/*
 	 * reset hardware
 	 */
-	ov772x_reset(priv->client);
+	ov772x_reset(client);
 
 	/*
 	 * Edge Ctrl
@@ -835,17 +843,17 @@ static int ov772x_set_params(struct ov772x_priv *priv, u32 width, u32 height,
 		 * Remove it when manual mode.
 		 */
 
-		ret = ov772x_mask_set(priv->client, DSPAUTO, EDGE_ACTRL, 0x00);
+		ret = ov772x_mask_set(client, DSPAUTO, EDGE_ACTRL, 0x00);
 		if (ret < 0)
 			goto ov772x_set_fmt_error;
 
-		ret = ov772x_mask_set(priv->client,
+		ret = ov772x_mask_set(client,
 				      EDGE_TRSHLD, EDGE_THRESHOLD_MASK,
 				      priv->info->edgectrl.threshold);
 		if (ret < 0)
 			goto ov772x_set_fmt_error;
 
-		ret = ov772x_mask_set(priv->client,
+		ret = ov772x_mask_set(client,
 				      EDGE_STRNGT, EDGE_STRENGTH_MASK,
 				      priv->info->edgectrl.strength);
 		if (ret < 0)
@@ -857,13 +865,13 @@ static int ov772x_set_params(struct ov772x_priv *priv, u32 width, u32 height,
 		 *
 		 * set upper and lower limit
 		 */
-		ret = ov772x_mask_set(priv->client,
+		ret = ov772x_mask_set(client,
 				      EDGE_UPPER, EDGE_UPPER_MASK,
 				      priv->info->edgectrl.upper);
 		if (ret < 0)
 			goto ov772x_set_fmt_error;
 
-		ret = ov772x_mask_set(priv->client,
+		ret = ov772x_mask_set(client,
 				      EDGE_LOWER, EDGE_LOWER_MASK,
 				      priv->info->edgectrl.lower);
 		if (ret < 0)
@@ -873,7 +881,7 @@ static int ov772x_set_params(struct ov772x_priv *priv, u32 width, u32 height,
 	/*
 	 * set size format
 	 */
-	ret = ov772x_write_array(priv->client, priv->win->regs);
+	ret = ov772x_write_array(client, priv->win->regs);
 	if (ret < 0)
 		goto ov772x_set_fmt_error;
 
@@ -882,7 +890,7 @@ static int ov772x_set_params(struct ov772x_priv *priv, u32 width, u32 height,
 	 */
 	val = priv->fmt->dsp3;
 	if (val) {
-		ret = ov772x_mask_set(priv->client,
+		ret = ov772x_mask_set(client,
 				      DSP_CTRL3, UV_MASK, val);
 		if (ret < 0)
 			goto ov772x_set_fmt_error;
@@ -901,7 +909,7 @@ static int ov772x_set_params(struct ov772x_priv *priv, u32 width, u32 height,
 	if (priv->flag_hflip)
 		val ^= HFLIP_IMG;
 
-	ret = ov772x_mask_set(priv->client,
+	ret = ov772x_mask_set(client,
 			      COM3, SWAP_MASK | IMG_MASK, val);
 	if (ret < 0)
 		goto ov772x_set_fmt_error;
@@ -910,7 +918,7 @@ static int ov772x_set_params(struct ov772x_priv *priv, u32 width, u32 height,
 	 * set COM7
 	 */
 	val = priv->win->com7_bit | priv->fmt->com7;
-	ret = ov772x_mask_set(priv->client,
+	ret = ov772x_mask_set(client,
 			      COM7, (SLCT_MASK | FMT_MASK | OFMT_MASK),
 			      val);
 	if (ret < 0)
@@ -920,7 +928,7 @@ static int ov772x_set_params(struct ov772x_priv *priv, u32 width, u32 height,
 
 ov772x_set_fmt_error:
 
-	ov772x_reset(priv->client);
+	ov772x_reset(client);
 	priv->win = NULL;
 	priv->fmt = NULL;
 
@@ -930,22 +938,22 @@ ov772x_set_fmt_error:
 static int ov772x_set_crop(struct soc_camera_device *icd,
 			   struct v4l2_rect *rect)
 {
-	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct ov772x_priv *priv = i2c_get_clientdata(client);
 
 	if (!priv->fmt)
 		return -EINVAL;
 
-	return ov772x_set_params(priv, rect->width, rect->height,
+	return ov772x_set_params(icd, rect->width, rect->height,
 				 priv->fmt->fourcc);
 }
 
 static int ov772x_set_fmt(struct soc_camera_device *icd,
 			  struct v4l2_format *f)
 {
-	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	return ov772x_set_params(priv, pix->width, pix->height,
+	return ov772x_set_params(icd, pix->width, pix->height,
 				 pix->pixelformat);
 }
 
@@ -967,11 +975,13 @@ static int ov772x_try_fmt(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int ov772x_video_probe(struct soc_camera_device *icd)
+static int ov772x_video_probe(struct soc_camera_device *icd,
+			      struct i2c_client *client)
 {
-	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
+	struct ov772x_priv *priv = i2c_get_clientdata(client);
 	u8                  pid, ver;
 	const char         *devname;
+	int ret;
 
 	/*
 	 * We must have a parent by now. And it cannot be a wrong one.
@@ -993,11 +1003,16 @@ static int ov772x_video_probe(struct soc_camera_device *icd)
 	icd->formats     = ov772x_fmt_lists;
 	icd->num_formats = ARRAY_SIZE(ov772x_fmt_lists);
 
+	/* Switch master clock on */
+	ret = soc_camera_video_start(icd, &client->dev);
+	if (ret)
+		return ret;
+
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
-	pid = i2c_smbus_read_byte_data(priv->client, PID);
-	ver = i2c_smbus_read_byte_data(priv->client, VER);
+	pid = i2c_smbus_read_byte_data(client, PID);
+	ver = i2c_smbus_read_byte_data(client, VER);
 
 	switch (VERSION(pid, ver)) {
 	case OV7720:
@@ -1011,7 +1026,8 @@ static int ov772x_video_probe(struct soc_camera_device *icd)
 	default:
 		dev_err(&icd->dev,
 			"Product ID error %x:%x\n", pid, ver);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto ever;
 	}
 
 	dev_info(&icd->dev,
@@ -1019,21 +1035,22 @@ static int ov772x_video_probe(struct soc_camera_device *icd)
 		 devname,
 		 pid,
 		 ver,
-		 i2c_smbus_read_byte_data(priv->client, MIDH),
-		 i2c_smbus_read_byte_data(priv->client, MIDL));
+		 i2c_smbus_read_byte_data(client, MIDH),
+		 i2c_smbus_read_byte_data(client, MIDL));
+
+	soc_camera_video_stop(icd);
 
-	return soc_camera_video_start(icd);
+ever:
+	return ret;
 }
 
 static void ov772x_video_remove(struct soc_camera_device *icd)
 {
-	soc_camera_video_stop(icd);
+	icd->ops = NULL;
 }
 
 static struct soc_camera_ops ov772x_ops = {
 	.owner			= THIS_MODULE,
-	.probe			= ov772x_video_probe,
-	.remove			= ov772x_video_remove,
 	.init			= ov772x_init,
 	.release		= ov772x_release,
 	.start_capture		= ov772x_start_capture,
@@ -1063,14 +1080,22 @@ static int ov772x_probe(struct i2c_client *client,
 {
 	struct ov772x_priv        *priv;
 	struct ov772x_camera_info *info;
-	struct soc_camera_device  *icd;
+	struct soc_camera_device  *icd = client->dev.platform_data;
 	struct i2c_adapter        *adapter = to_i2c_adapter(client->dev.parent);
+	struct soc_camera_link    *icl;
 	int                        ret;
 
-	info = client->dev.platform_data;
-	if (!info)
+	if (!icd) {
+		dev_err(&client->dev, "MT9M001: missing soc-camera data!\n");
+		return -EINVAL;
+	}
+
+	icl = to_soc_camera_link(icd);
+	if (!icl)
 		return -EINVAL;
 
+	info = container_of(icl, struct ov772x_camera_info, link);
+
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_err(&adapter->dev,
 			"I2C-Adapter doesn't support "
@@ -1083,18 +1108,13 @@ static int ov772x_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	priv->info   = info;
-	priv->client = client;
 	i2c_set_clientdata(client, priv);
 
-	icd             = &priv->icd;
 	icd->ops        = &ov772x_ops;
-	icd->control    = &client->dev;
 	icd->width_max  = MAX_WIDTH;
 	icd->height_max = MAX_HEIGHT;
-	icd->iface      = priv->info->link.bus_id;
-
-	ret = soc_camera_device_register(icd);
 
+	ret = ov772x_video_probe(icd, client);
 	if (ret) {
 		i2c_set_clientdata(client, NULL);
 		kfree(priv);
@@ -1106,8 +1126,9 @@ static int ov772x_probe(struct i2c_client *client,
 static int ov772x_remove(struct i2c_client *client)
 {
 	struct ov772x_priv *priv = i2c_get_clientdata(client);
+	struct soc_camera_device *icd = client->dev.platform_data;
 
-	soc_camera_device_unregister(&priv->icd);
+	ov772x_video_remove(icd);
 	i2c_set_clientdata(client, NULL);
 	kfree(priv);
 	return 0;
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 2da5eef..63964d0 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -841,7 +841,8 @@ static void pxa_camera_init_videobuf(struct videobuf_queue *q,
 				sizeof(struct pxa_buffer), icd);
 }
 
-static u32 mclk_get_divisor(struct pxa_camera_dev *pcdev)
+static u32 mclk_get_divisor(struct platform_device *pdev,
+			    struct pxa_camera_dev *pcdev)
 {
 	unsigned long mclk = pcdev->mclk;
 	u32 div;
@@ -853,7 +854,7 @@ static u32 mclk_get_divisor(struct pxa_camera_dev *pcdev)
 	/* mclk <= ciclk / 4 (27.4.2) */
 	if (mclk > lcdclk / 4) {
 		mclk = lcdclk / 4;
-		dev_warn(pcdev->soc_host.dev, "Limiting master clock to %lu\n", mclk);
+		dev_warn(&pdev->dev, "Limiting master clock to %lu\n", mclk);
 	}
 
 	/* We verify mclk != 0, so if anyone breaks it, here comes their Oops */
@@ -863,8 +864,8 @@ static u32 mclk_get_divisor(struct pxa_camera_dev *pcdev)
 	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
 		pcdev->mclk = lcdclk / (2 * (div + 1));
 
-	dev_dbg(pcdev->soc_host.dev, "LCD clock %luHz, target freq %luHz, "
-		"divisor %u\n", lcdclk, mclk, div);
+	dev_dbg(&pdev->dev, "LCD clock %luHz, target freq %luHz, divisor %u\n",
+		lcdclk, mclk, div);
 
 	return div;
 }
@@ -969,15 +970,20 @@ static int pxa_camera_add_device(struct soc_camera_device *icd)
 		goto ebusy;
 	}
 
-	dev_info(&icd->dev, "PXA Camera driver attached to camera %d\n",
-		 icd->devnum);
-
 	pxa_camera_activate(pcdev);
 	ret = icd->ops->init(icd);
+	if (ret < 0)
+		goto einit;
+
+	pcdev->icd = icd;
 
-	if (!ret)
-		pcdev->icd = icd;
+	dev_info(&icd->dev, "PXA Camera driver attached to camera %d\n",
+		 icd->devnum);
 
+	return 0;
+
+einit:
+	pxa_camera_deactivate(pcdev);
 ebusy:
 	return ret;
 }
@@ -1599,7 +1605,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		pcdev->mclk = 20000000;
 	}
 
-	pcdev->mclk_divisor = mclk_get_divisor(pcdev);
+	pcdev->mclk_divisor = mclk_get_divisor(pdev, pcdev);
 
 	INIT_LIST_HEAD(&pcdev->capture);
 	spin_lock_init(&pcdev->lock);
@@ -1746,3 +1752,4 @@ module_exit(pxa_camera_exit);
 MODULE_DESCRIPTION("PXA27x SoC Camera Host driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <kernel@pengutronix.de>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" PXA_CAM_DRV_NAME);
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index d369e84..ac9b467 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -360,11 +360,13 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 		 "SuperH Mobile CEU driver attached to camera %d\n",
 		 icd->devnum);
 
+	clk_enable(pcdev->clk);
+
 	ret = icd->ops->init(icd);
-	if (ret)
+	if (ret) {
+		clk_disable(pcdev->clk);
 		goto err;
-
-	clk_enable(pcdev->clk);
+	}
 
 	ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
 	while (ceu_read(pcdev, CSTSR) & 1)
@@ -398,10 +400,10 @@ static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 	}
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 
-	clk_disable(pcdev->clk);
-
 	icd->ops->release(icd);
 
+	clk_disable(pcdev->clk);
+
 	dev_info(&icd->dev,
 		 "SuperH Mobile CEU driver detached from camera %d\n",
 		 icd->devnum);
@@ -948,3 +950,4 @@ module_exit(sh_mobile_ceu_exit);
 MODULE_DESCRIPTION("SuperH Mobile CEU driver");
 MODULE_AUTHOR("Magnus Damm");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:sh_mobile_ceu");
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 03a6c29..22f544c 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -16,19 +16,21 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
-#include <linux/init.h>
 #include <linux/device.h>
-#include <linux/list.h>
 #include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/vmalloc.h>
 
+#include <media/soc_camera.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
 #include <media/videobuf-core.h>
-#include <media/soc_camera.h>
 
 /* Default to VGA resolution */
 #define DEFAULT_WIDTH	640
@@ -36,7 +38,7 @@
 
 static LIST_HEAD(hosts);
 static LIST_HEAD(devices);
-static DEFINE_MUTEX(list_lock);
+static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
 
 const struct soc_camera_data_format *soc_camera_format_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc)
@@ -207,6 +209,7 @@ static int soc_camera_dqbuf(struct file *file, void *priv,
 	return videobuf_dqbuf(&icf->vb_vidq, p, file->f_flags & O_NONBLOCK);
 }
 
+/* Always entered with .video_lock held */
 static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
@@ -255,9 +258,12 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 	return 0;
 }
 
+/* Always entered with .video_lock held */
 static void soc_camera_free_user_formats(struct soc_camera_device *icd)
 {
+	icd->current_fmt = NULL;
 	vfree(icd->user_formats);
+	icd->user_formats = NULL;
 }
 
 /* Called with .vb_lock held */
@@ -308,10 +314,6 @@ static int soc_camera_open(struct file *file)
 	struct soc_camera_file *icf;
 	int ret;
 
-	icf = vmalloc(sizeof(*icf));
-	if (!icf)
-		return -ENOMEM;
-
 	/*
 	 * It is safe to dereference these pointers now as long as a user has
 	 * the video device open - we are protected by the held cdev reference.
@@ -319,8 +321,17 @@ static int soc_camera_open(struct file *file)
 
 	vdev = video_devdata(file);
 	icd = container_of(vdev->parent, struct soc_camera_device, dev);
+
+	if (!icd->ops)
+		/* No device driver attached */
+		return -ENODEV;
+
 	ici = to_soc_camera_host(icd->dev.parent);
 
+	icf = vmalloc(sizeof(*icf));
+	if (!icf)
+		return -ENOMEM;
+
 	if (!try_module_get(icd->ops->owner)) {
 		dev_err(&icd->dev, "Couldn't lock sensor driver.\n");
 		ret = -EINVAL;
@@ -333,7 +344,7 @@ static int soc_camera_open(struct file *file)
 		goto emgi;
 	}
 
-	/* Protect against icd->remove() until we module_get() both drivers. */
+	/* Protect against icd->ops->remove() until we module_get() both drivers. */
 	mutex_lock(&icd->video_lock);
 
 	icf->icd = icd;
@@ -348,11 +359,18 @@ static int soc_camera_open(struct file *file)
 				.width		= icd->width,
 				.height		= icd->height,
 				.field		= icd->field,
-				.pixelformat	= icd->current_fmt->fourcc,
-				.colorspace	= icd->current_fmt->colorspace,
 			},
 		};
 
+		ret = soc_camera_init_user_formats(icd);
+		if (ret < 0)
+			goto eiufmt;
+
+		dev_dbg(&icd->dev, "Using fmt %x\n", icd->current_fmt->fourcc);
+
+		f.fmt.pix.pixelformat	= icd->current_fmt->fourcc;
+		f.fmt.pix.colorspace	= icd->current_fmt->colorspace;
+
 		ret = ici->ops->add(icd);
 		if (ret < 0) {
 			dev_err(&icd->dev, "Couldn't activate the camera: %d\n", ret);
@@ -381,6 +399,8 @@ static int soc_camera_open(struct file *file)
 esfmt:
 	ici->ops->remove(icd);
 eiciadd:
+	soc_camera_free_user_formats(icd);
+eiufmt:
 	icd->use_count--;
 	mutex_unlock(&icd->video_lock);
 	module_put(ici->ops->owner);
@@ -400,8 +420,10 @@ static int soc_camera_close(struct file *file)
 
 	mutex_lock(&icd->video_lock);
 	icd->use_count--;
-	if (!icd->use_count)
+	if (!icd->use_count) {
 		ici->ops->remove(icd);
+		soc_camera_free_user_formats(icd);
+	}
 
 	mutex_unlock(&icd->video_lock);
 
@@ -762,29 +784,6 @@ static int soc_camera_s_register(struct file *file, void *fh,
 }
 #endif
 
-static int device_register_link(struct soc_camera_device *icd)
-{
-	int ret = dev_set_name(&icd->dev, "%u-%u", icd->iface, icd->devnum);
-
-	if (!ret)
-		ret = device_register(&icd->dev);
-
-	if (ret < 0) {
-		/* Prevent calling device_unregister() */
-		icd->dev.parent = NULL;
-		dev_err(&icd->dev, "Cannot register device: %d\n", ret);
-	/* Even if probe() was unsuccessful for all registered drivers,
-	 * device_register() returns 0, and we add the link, just to
-	 * document this camera's control device */
-	} else if (icd->control)
-		/* Have to sysfs_remove_link() before device_unregister()? */
-		if (sysfs_create_link(&icd->dev.kobj, &icd->control->kobj,
-				      "control"))
-			dev_warn(&icd->dev,
-				 "Failed creating the control symlink\n");
-	return ret;
-}
-
 /* So far this function cannot fail */
 static void scan_add_host(struct soc_camera_host *ici)
 {
@@ -794,103 +793,78 @@ static void scan_add_host(struct soc_camera_host *ici)
 
 	list_for_each_entry(icd, &devices, list) {
 		if (icd->iface == ici->nr) {
+			int ret;
 			icd->dev.parent = ici->dev;
-			device_register_link(icd);
-		}
-	}
-
-	mutex_unlock(&list_lock);
-}
-
-/* return: 0 if no match found or a match found and
- * device_register() successful, error code otherwise */
-static int scan_add_device(struct soc_camera_device *icd)
-{
-	struct soc_camera_host *ici;
-	int ret = 0;
-
-	mutex_lock(&list_lock);
-
-	list_add_tail(&icd->list, &devices);
-
-	/* Watch out for class_for_each_device / class_find_device API by
-	 * Dave Young <hidave.darkstar@gmail.com> */
-	list_for_each_entry(ici, &hosts, list) {
-		if (icd->iface == ici->nr) {
-			ret = 1;
-			icd->dev.parent = ici->dev;
-			break;
+			dev_set_name(&icd->dev, "%u-%u", icd->iface,
+				     icd->devnum);
+			ret = device_register(&icd->dev);
+			if (ret < 0) {
+				icd->dev.parent = NULL;
+				dev_err(&icd->dev,
+					"Cannot register device: %d\n", ret);
+			}
 		}
 	}
 
 	mutex_unlock(&list_lock);
-
-	if (ret)
-		ret = device_register_link(icd);
-
-	return ret;
 }
 
+static int video_dev_create(struct soc_camera_device *icd);
+/* Called during host-driver probe */
 static int soc_camera_probe(struct device *dev)
 {
 	struct soc_camera_device *icd = to_soc_camera_dev(dev);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	int ret;
+	struct i2c_client *client;
+	struct i2c_adapter *adap = i2c_get_adapter(icl->i2c_adapter_id);
 
-	/*
-	 * Possible race scenario:
-	 * modprobe <camera-host-driver> triggers __func__
-	 * at this moment respective <camera-sensor-driver> gets rmmod'ed
-	 * to protect take module references.
-	 */
-
-	if (!try_module_get(icd->ops->owner)) {
-		dev_err(&icd->dev, "Couldn't lock sensor driver.\n");
-		ret = -EINVAL;
-		goto emgd;
-	}
-
-	if (!try_module_get(ici->ops->owner)) {
-		dev_err(&icd->dev, "Couldn't lock capture bus driver.\n");
-		ret = -EINVAL;
-		goto emgi;
+	if (!adap) {
+		ret = -ENODEV;
+		dev_err(dev, "Cannot get I2C adapter %d\n", icl->i2c_adapter_id);
+		goto ei2cga;
 	}
 
-	mutex_lock(&icd->video_lock);
+	dev_info(dev, "Probing %s\n", dev_name(dev));
 
-	/* We only call ->add() here to activate and probe the camera.
-	 * We shall ->remove() and deactivate it immediately afterwards. */
-	ret = ici->ops->add(icd);
+	ret = video_dev_create(icd);
 	if (ret < 0)
-		goto eiadd;
+		goto evdc;
 
-	ret = icd->ops->probe(icd);
-	if (ret >= 0) {
-		const struct v4l2_queryctrl *qctrl;
+	client = i2c_new_device(adap, icl->board_info);
+	if (!client) {
+		ret = -ENOMEM;
+		goto ei2cnd;
+	}
 
-		qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_GAIN);
-		icd->gain = qctrl ? qctrl->default_value : (unsigned short)~0;
-		qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
-		icd->exposure = qctrl ? qctrl->default_value :
-			(unsigned short)~0;
+	/*
+	 * We set icd drvdata at two locations - here and in
+	 * soc_camera_video_start(). Depending on the module loading /
+	 * initialisation order one of these locations will be entered first
+	 */
+	/* Use to_i2c_client(dev) to recover the i2c client */
+	dev_set_drvdata(&icd->dev, &client->dev);
 
-		ret = soc_camera_init_user_formats(icd);
-		if (ret < 0)
-			goto eiufmt;
+	/* Do we have to sysfs_remove_link() before device_unregister()? */
+	if (sysfs_create_link(&dev->kobj, &to_soc_camera_control(icd)->kobj,
+			      "control"))
+		dev_warn(dev, "Failed creating the control symlink\n");
 
-		icd->height	= DEFAULT_HEIGHT;
-		icd->width	= DEFAULT_WIDTH;
-		icd->field	= V4L2_FIELD_ANY;
+	ret = video_register_device(icd->vdev, VFL_TYPE_GRABBER, icd->vdev->minor);
+	if (ret < 0) {
+		dev_err(&icd->dev, "video_register_device failed: %d\n", ret);
+		goto evidregd;
 	}
 
-eiufmt:
-	ici->ops->remove(icd);
-eiadd:
-	mutex_unlock(&icd->video_lock);
-	module_put(ici->ops->owner);
-emgi:
-	module_put(icd->ops->owner);
-emgd:
+	return 0;
+
+evidregd:
+	i2c_unregister_device(client);
+ei2cnd:
+	video_device_release(icd->vdev);
+evdc:
+	i2c_put_adapter(adap);
+ei2cga:
 	return ret;
 }
 
@@ -899,11 +873,24 @@ emgd:
 static int soc_camera_remove(struct device *dev)
 {
 	struct soc_camera_device *icd = to_soc_camera_dev(dev);
+	struct video_device *vdev = icd->vdev;
 
-	if (icd->ops->remove)
-		icd->ops->remove(icd);
+	BUG_ON(!dev->parent);
 
-	soc_camera_free_user_formats(icd);
+	if (vdev) {
+		mutex_lock(&icd->video_lock);
+		video_unregister_device(vdev);
+		icd->vdev = NULL;
+		mutex_unlock(&icd->video_lock);
+	}
+
+	if (to_soc_camera_control(icd)) {
+		struct i2c_client *client =
+			to_i2c_client(to_soc_camera_control(icd));
+		dev_set_drvdata(&icd->dev, NULL);
+		i2c_unregister_device(client);
+		i2c_put_adapter(client->adapter);
+	}
 
 	return 0;
 }
@@ -998,10 +985,14 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 
 	list_for_each_entry(icd, &devices, list) {
 		if (icd->dev.parent == ici->dev) {
+			/* The bus->remove will be called */
 			device_unregister(&icd->dev);
 			/* Not before device_unregister(), .remove
 			 * needs parent to call ici->ops->remove() */
 			icd->dev.parent = NULL;
+
+			/* If the host module is loaded again, device_register()
+			 * would complain "already initialised" */
 			memset(&icd->dev.kobj, 0, sizeof(icd->dev.kobj));
 		}
 	}
@@ -1013,26 +1004,14 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 EXPORT_SYMBOL(soc_camera_host_unregister);
 
 /* Image capture device */
-int soc_camera_device_register(struct soc_camera_device *icd)
+static int soc_camera_device_register(struct soc_camera_device *icd)
 {
 	struct soc_camera_device *ix;
 	int num = -1, i;
 
-	if (!icd || !icd->ops ||
-	    !icd->ops->probe ||
-	    !icd->ops->init ||
-	    !icd->ops->release ||
-	    !icd->ops->start_capture ||
-	    !icd->ops->stop_capture ||
-	    !icd->ops->set_crop ||
-	    !icd->ops->set_fmt ||
-	    !icd->ops->try_fmt ||
-	    !icd->ops->query_bus_param ||
-	    !icd->ops->set_bus_param)
-		return -EINVAL;
-
 	for (i = 0; i < 256 && num < 0; i++) {
 		num = i;
+		/* Check if this index is available on this interface */
 		list_for_each_entry(ix, &devices, list) {
 			if (ix->iface == icd->iface && ix->devnum == i) {
 				num = -1;
@@ -1054,21 +1033,15 @@ int soc_camera_device_register(struct soc_camera_device *icd)
 	icd->host_priv		= NULL;
 	mutex_init(&icd->video_lock);
 
-	return scan_add_device(icd);
+	list_add_tail(&icd->list, &devices);
+
+	return 0;
 }
-EXPORT_SYMBOL(soc_camera_device_register);
 
-void soc_camera_device_unregister(struct soc_camera_device *icd)
+static void soc_camera_device_unregister(struct soc_camera_device *icd)
 {
-	mutex_lock(&list_lock);
 	list_del(&icd->list);
-
-	/* The bus->remove will be eventually called */
-	if (icd->dev.parent)
-		device_unregister(&icd->dev);
-	mutex_unlock(&list_lock);
 }
-EXPORT_SYMBOL(soc_camera_device_unregister);
 
 static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 	.vidioc_querycap	 = soc_camera_querycap,
@@ -1099,22 +1072,13 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 #endif
 };
 
-/*
- * Usually called from the struct soc_camera_ops .probe() method, i.e., from
- * soc_camera_probe() above with .video_lock held
- */
-int soc_camera_video_start(struct soc_camera_device *icd)
+static int video_dev_create(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	int err = -ENOMEM;
-	struct video_device *vdev;
+	struct video_device *vdev = video_device_alloc();
 
-	if (!icd->dev.parent)
-		return -ENODEV;
-
-	vdev = video_device_alloc();
 	if (!vdev)
-		goto evidallocd;
+		return -ENOMEM;
 	dev_dbg(ici->dev, "Allocated video_device %p\n", vdev);
 
 	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
@@ -1125,40 +1089,103 @@ int soc_camera_video_start(struct soc_camera_device *icd)
 	vdev->ioctl_ops		= &soc_camera_ioctl_ops;
 	vdev->release		= video_device_release;
 	vdev->minor		= -1;
-	vdev->tvnorms		= V4L2_STD_UNKNOWN,
+	vdev->tvnorms		= V4L2_STD_UNKNOWN;
 
-	err = video_register_device(vdev, VFL_TYPE_GRABBER, vdev->minor);
-	if (err < 0) {
-		dev_err(vdev->parent, "video_register_device failed\n");
-		goto evidregd;
-	}
 	icd->vdev = vdev;
 
 	return 0;
+}
 
-evidregd:
-	video_device_release(vdev);
-evidallocd:
-	return err;
+/*
+ * Usually called from the struct soc_camera_ops .probe() method, i.e., from
+ * soc_camera_probe() above with .video_lock held
+ */
+int soc_camera_video_start(struct soc_camera_device *icd, struct device *dev)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	const struct v4l2_queryctrl *qctrl;
+
+	if (!icd->dev.parent)
+		return -ENODEV;
+
+	if (!icd->ops ||
+	    !icd->ops->init ||
+	    !icd->ops->release ||
+	    !icd->ops->start_capture ||
+	    !icd->ops->stop_capture ||
+	    !icd->ops->set_fmt ||
+	    !icd->ops->try_fmt ||
+	    !icd->ops->query_bus_param ||
+	    !icd->ops->set_bus_param)
+		return -EINVAL;
+
+	/* See comment in soc_camera_probe() */
+	dev_set_drvdata(&icd->dev, dev);
+
+	qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_GAIN);
+	icd->gain = qctrl ? qctrl->default_value : (unsigned short)~0;
+	qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
+	icd->exposure = qctrl ? qctrl->default_value : (unsigned short)~0;
+
+	return ici->ops->add(icd);
 }
 EXPORT_SYMBOL(soc_camera_video_start);
 
 void soc_camera_video_stop(struct soc_camera_device *icd)
 {
-	struct video_device *vdev = icd->vdev;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	dev_dbg(&icd->dev, "%s\n", __func__);
 
-	if (!icd->dev.parent || !vdev)
-		return;
-
-	mutex_lock(&icd->video_lock);
-	video_unregister_device(vdev);
-	icd->vdev = NULL;
-	mutex_unlock(&icd->video_lock);
+	ici->ops->remove(icd);
 }
 EXPORT_SYMBOL(soc_camera_video_stop);
 
+static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
+{
+	struct soc_camera_link *icl = pdev->dev.platform_data;
+	struct soc_camera_device *icd;
+
+	if (!icl)
+		return -EINVAL;
+
+	icd = kzalloc(sizeof(*icd), GFP_KERNEL);
+	if (!icd)
+		return -ENOMEM;
+
+	icd->iface = icl->bus_id;
+	icl->board_info->platform_data = icd;
+	platform_set_drvdata(pdev, icd);
+	icd->dev.platform_data = icl;
+
+	return soc_camera_device_register(icd);
+}
+
+/* Only called on rmmod for each platform device, since they are not
+ * hot-pluggable. Now we know, that all our users - hosts and devices have
+ * been unloaded already */
+static int __devexit soc_camera_pdrv_remove(struct platform_device *pdev)
+{
+	struct soc_camera_device *icd = platform_get_drvdata(pdev);
+
+	if (!icd)
+		return -EINVAL;
+
+	soc_camera_device_unregister(icd);
+
+	kfree(icd);
+
+	return 0;
+}
+
+static struct platform_driver soc_camera_pdrv = {
+	.remove  = __exit_p(soc_camera_pdrv_remove),
+	.driver  = {
+		.name = "soc-camera-pdrv",
+		.owner = THIS_MODULE,
+	},
+};
+
 static int __init soc_camera_init(void)
 {
 	int ret = bus_register(&soc_camera_bus_type);
@@ -1168,8 +1195,14 @@ static int __init soc_camera_init(void)
 	if (ret)
 		goto edrvr;
 
+	ret = platform_driver_probe(&soc_camera_pdrv, soc_camera_pdrv_probe);
+	if (ret)
+		goto epdr;
+
 	return 0;
 
+epdr:
+	driver_unregister(&ic_drv);
 edrvr:
 	bus_unregister(&soc_camera_bus_type);
 	return ret;
@@ -1177,6 +1210,7 @@ edrvr:
 
 static void __exit soc_camera_exit(void)
 {
+	platform_driver_unregister(&soc_camera_pdrv);
 	driver_unregister(&ic_drv);
 	bus_unregister(&soc_camera_bus_type);
 }
@@ -1187,3 +1221,4 @@ module_exit(soc_camera_exit);
 MODULE_DESCRIPTION("Image capture bus driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <kernel@pengutronix.de>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:soc-camera-pdrv");
diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index c486763..021f9f1 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -20,49 +20,52 @@
 #include <media/soc_camera.h>
 #include <media/soc_camera_platform.h>
 
+static const char drv_name[] = "soc_camera_platform";
+
 struct soc_camera_platform_priv {
 	struct soc_camera_platform_info *info;
-	struct soc_camera_device icd;
 	struct soc_camera_data_format format;
 };
 
-static struct soc_camera_platform_info *
-soc_camera_platform_get_info(struct soc_camera_device *icd)
+static struct soc_camera_platform_info *i2c_to_info(struct i2c_client *client)
 {
-	struct soc_camera_platform_priv *priv;
-	priv = container_of(icd, struct soc_camera_platform_priv, icd);
+	struct soc_camera_platform_priv *priv = i2c_get_clientdata(client);
 	return priv->info;
 }
 
 static int soc_camera_platform_init(struct soc_camera_device *icd)
 {
-	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_platform_info *p = i2c_to_info(client);
 
-	if (p->power)
-		p->power(1);
+	if (p->link.power)
+		p->link.power(&client->dev, 1);
 
 	return 0;
 }
 
 static int soc_camera_platform_release(struct soc_camera_device *icd)
 {
-	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_platform_info *p = i2c_to_info(client);
 
-	if (p->power)
-		p->power(0);
+	if (p->link.power)
+		p->link.power(&client->dev, 0);
 
 	return 0;
 }
 
 static int soc_camera_platform_start_capture(struct soc_camera_device *icd)
 {
-	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_platform_info *p = i2c_to_info(client);
 	return p->set_capture(p, 1);
 }
 
 static int soc_camera_platform_stop_capture(struct soc_camera_device *icd)
 {
-	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_platform_info *p = i2c_to_info(client);
 	return p->set_capture(p, 0);
 }
 
@@ -75,7 +78,8 @@ static int soc_camera_platform_set_bus_param(struct soc_camera_device *icd,
 static unsigned long
 soc_camera_platform_query_bus_param(struct soc_camera_device *icd)
 {
-	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_platform_info *p = i2c_to_info(client);
 	return p->bus_param;
 }
 
@@ -94,7 +98,8 @@ static int soc_camera_platform_set_fmt(struct soc_camera_device *icd,
 static int soc_camera_platform_try_fmt(struct soc_camera_device *icd,
 				       struct v4l2_format *f)
 {
-	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_platform_info *p = i2c_to_info(client);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
 	pix->width = p->format.width;
@@ -102,31 +107,30 @@ static int soc_camera_platform_try_fmt(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int soc_camera_platform_video_probe(struct soc_camera_device *icd)
+static int soc_camera_platform_video_probe(struct soc_camera_device *icd,
+					   struct i2c_client *client)
 {
-	struct soc_camera_platform_priv *priv;
-	priv = container_of(icd, struct soc_camera_platform_priv, icd);
+	struct soc_camera_platform_priv *priv = i2c_get_clientdata(client);
+	struct soc_camera_platform_info *p = priv->info;
 
-	priv->format.name = priv->info->format_name;
-	priv->format.depth = priv->info->format_depth;
-	priv->format.fourcc = priv->info->format.pixelformat;
-	priv->format.colorspace = priv->info->format.colorspace;
+	priv->format.name = p->format_name;
+	priv->format.depth = p->format_depth;
+	priv->format.fourcc = p->format.pixelformat;
+	priv->format.colorspace = p->format.colorspace;
 
 	icd->formats = &priv->format;
 	icd->num_formats = 1;
 
-	return soc_camera_video_start(icd);
+	return 0;
 }
 
 static void soc_camera_platform_video_remove(struct soc_camera_device *icd)
 {
-	soc_camera_video_stop(icd);
+	icd->ops = NULL;
 }
 
 static struct soc_camera_ops soc_camera_platform_ops = {
 	.owner			= THIS_MODULE,
-	.probe			= soc_camera_platform_video_probe,
-	.remove			= soc_camera_platform_video_remove,
 	.init			= soc_camera_platform_init,
 	.release		= soc_camera_platform_release,
 	.start_capture		= soc_camera_platform_start_capture,
@@ -138,66 +142,85 @@ static struct soc_camera_ops soc_camera_platform_ops = {
 	.query_bus_param	= soc_camera_platform_query_bus_param,
 };
 
-static int soc_camera_platform_probe(struct platform_device *pdev)
+static int soc_camera_platform_probe(struct i2c_client *client,
+				     const struct i2c_device_id *did)
 {
 	struct soc_camera_platform_priv *priv;
 	struct soc_camera_platform_info *p;
-	struct soc_camera_device *icd;
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl;
 	int ret;
 
-	p = pdev->dev.platform_data;
-	if (!p)
+	if (!icd) {
+		dev_err(&client->dev, "%s: missing soc-camera data!\n", drv_name);
 		return -EINVAL;
+	}
+
+	icl = dev_get_drvdata(&icd->dev);
+	if (!icl) {
+		dev_err(&client->dev, "%s driver needs platform data\n", drv_name);
+		return -EINVAL;
+	}
+
+	p = container_of(icl, struct soc_camera_platform_info, link);
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
 	priv->info = p;
-	platform_set_drvdata(pdev, priv);
+	i2c_set_clientdata(client, priv);
 
-	icd = &priv->icd;
 	icd->ops	= &soc_camera_platform_ops;
-	icd->control	= &pdev->dev;
 	icd->width_min	= 0;
-	icd->width_max	= priv->info->format.width;
+	icd->width_max	= p->format.width;
 	icd->height_min	= 0;
-	icd->height_max	= priv->info->format.height;
+	icd->height_max	= p->format.height;
 	icd->y_skip_top	= 0;
-	icd->iface	= priv->info->iface;
 
-	ret = soc_camera_device_register(icd);
-	if (ret)
+	ret = soc_camera_platform_video_probe(icd, client);
+	if (ret) {
+		i2c_set_clientdata(client, NULL);
 		kfree(priv);
+	}
 
 	return ret;
 }
 
-static int soc_camera_platform_remove(struct platform_device *pdev)
+static int soc_camera_platform_remove(struct i2c_client *client)
 {
-	struct soc_camera_platform_priv *priv = platform_get_drvdata(pdev);
+	struct soc_camera_platform_priv *priv = i2c_get_clientdata(client);
+	struct soc_camera_device *icd = client->dev.platform_data;
 
-	soc_camera_device_unregister(&priv->icd);
+	soc_camera_platform_video_remove(icd);
+	i2c_set_clientdata(client, NULL);
 	kfree(priv);
 	return 0;
 }
 
-static struct platform_driver soc_camera_platform_driver = {
+static const struct i2c_device_id soc_camera_platform_id[] = {
+	{ "soc_camera_platform", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, soc_camera_platform_id);
+
+static struct i2c_driver soc_camera_platform_driver = {
 	.driver 	= {
 		.name	= "soc_camera_platform",
 	},
 	.probe		= soc_camera_platform_probe,
 	.remove		= soc_camera_platform_remove,
+	.id_table	= soc_camera_platform_id,
 };
 
 static int __init soc_camera_platform_module_init(void)
 {
-	return platform_driver_register(&soc_camera_platform_driver);
+	return i2c_add_driver(&soc_camera_platform_driver);
 }
 
 static void __exit soc_camera_platform_module_exit(void)
 {
-	platform_driver_unregister(&soc_camera_platform_driver);
+	i2c_del_driver(&soc_camera_platform_driver);
 }
 
 module_init(soc_camera_platform_module_init);
@@ -206,3 +229,4 @@ module_exit(soc_camera_platform_module_exit);
 MODULE_DESCRIPTION("SoC Camera Platform driver");
 MODULE_AUTHOR("Magnus Damm");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:soc_camera_platform");
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index a399476..419e596 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -224,8 +224,6 @@ struct tw9910_hsync_ctrl {
 
 struct tw9910_priv {
 	struct tw9910_video_info       *info;
-	struct i2c_client              *client;
-	struct soc_camera_device        icd;
 	const struct tw9910_scale_ctrl *scale;
 };
 
@@ -511,35 +509,38 @@ tw9910_select_norm(struct soc_camera_device *icd, u32 width, u32 height)
  */
 static int tw9910_init(struct soc_camera_device *icd)
 {
-	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	int ret = 0;
 
-	if (priv->info->link.power) {
-		ret = priv->info->link.power(&priv->client->dev, 1);
+	if (icl->power) {
+		ret = icl->power(&client->dev, 1);
 		if (ret < 0)
 			return ret;
 	}
 
-	if (priv->info->link.reset)
-		ret = priv->info->link.reset(&priv->client->dev);
+	if (icl->reset)
+		ret = icl->reset(&client->dev);
 
 	return ret;
 }
 
 static int tw9910_release(struct soc_camera_device *icd)
 {
-	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	int ret = 0;
 
-	if (priv->info->link.power)
-		ret = priv->info->link.power(&priv->client->dev, 0);
+	if (icl->power)
+		ret = icl->power(&client->dev, 0);
 
 	return ret;
 }
 
 static int tw9910_start_capture(struct soc_camera_device *icd)
 {
-	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct tw9910_priv *priv = i2c_get_clientdata(client);
 
 	if (!priv->scale) {
 		dev_err(&icd->dev, "norm select error\n");
@@ -567,8 +568,9 @@ static int tw9910_set_bus_param(struct soc_camera_device *icd,
 
 static unsigned long tw9910_query_bus_param(struct soc_camera_device *icd)
 {
-	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
-	struct soc_camera_link *icl = priv->client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct tw9910_priv *priv = i2c_get_clientdata(client);
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
 		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
 		SOCAM_DATA_ACTIVE_HIGH | priv->info->buswidth;
@@ -610,13 +612,13 @@ static int tw9910_enum_input(struct soc_camera_device *icd,
 static int tw9910_get_register(struct soc_camera_device *icd,
 			       struct v4l2_dbg_register *reg)
 {
-	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 	int ret;
 
 	if (reg->reg > 0xff)
 		return -EINVAL;
 
-	ret = i2c_smbus_read_byte_data(priv->client, reg->reg);
+	ret = i2c_smbus_read_byte_data(client, reg->reg);
 	if (ret < 0)
 		return ret;
 
@@ -631,20 +633,21 @@ static int tw9910_get_register(struct soc_camera_device *icd,
 static int tw9910_set_register(struct soc_camera_device *icd,
 			       struct v4l2_dbg_register *reg)
 {
-	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
 
 	if (reg->reg > 0xff ||
 	    reg->val > 0xff)
 		return -EINVAL;
 
-	return i2c_smbus_write_byte_data(priv->client, reg->reg, reg->val);
+	return i2c_smbus_write_byte_data(client, reg->reg, reg->val);
 }
 #endif
 
 static int tw9910_set_crop(struct soc_camera_device *icd,
 			   struct v4l2_rect *rect)
 {
-	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	struct tw9910_priv *priv = i2c_get_clientdata(client);
 	int                 ret  = -EINVAL;
 	u8                  val;
 
@@ -658,8 +661,8 @@ static int tw9910_set_crop(struct soc_camera_device *icd,
 	/*
 	 * reset hardware
 	 */
-	tw9910_reset(priv->client);
-	ret = tw9910_write_array(priv->client, tw9910_default_regs);
+	tw9910_reset(client);
+	ret = tw9910_write_array(client, tw9910_default_regs);
 	if (ret < 0)
 		goto tw9910_set_fmt_error;
 
@@ -670,7 +673,7 @@ static int tw9910_set_crop(struct soc_camera_device *icd,
 	if (SOCAM_DATAWIDTH_16 == priv->info->buswidth)
 		val = LEN;
 
-	ret = tw9910_mask_set(priv->client, OPFORM, LEN, val);
+	ret = tw9910_mask_set(client, OPFORM, LEN, val);
 	if (ret < 0)
 		goto tw9910_set_fmt_error;
 
@@ -698,28 +701,28 @@ static int tw9910_set_crop(struct soc_camera_device *icd,
 		val = 0;
 	}
 
-	ret = tw9910_mask_set(priv->client, VBICNTL, RTSEL_MASK, val);
+	ret = tw9910_mask_set(client, VBICNTL, RTSEL_MASK, val);
 	if (ret < 0)
 		goto tw9910_set_fmt_error;
 
 	/*
 	 * set scale
 	 */
-	ret = tw9910_set_scale(priv->client, priv->scale);
+	ret = tw9910_set_scale(client, priv->scale);
 	if (ret < 0)
 		goto tw9910_set_fmt_error;
 
 	/*
 	 * set cropping
 	 */
-	ret = tw9910_set_cropping(priv->client, &tw9910_cropping_ctrl);
+	ret = tw9910_set_cropping(client, &tw9910_cropping_ctrl);
 	if (ret < 0)
 		goto tw9910_set_fmt_error;
 
 	/*
 	 * set hsync
 	 */
-	ret = tw9910_set_hsync(priv->client, &tw9910_hsync_ctrl);
+	ret = tw9910_set_hsync(client, &tw9910_hsync_ctrl);
 	if (ret < 0)
 		goto tw9910_set_fmt_error;
 
@@ -727,7 +730,7 @@ static int tw9910_set_crop(struct soc_camera_device *icd,
 
 tw9910_set_fmt_error:
 
-	tw9910_reset(priv->client);
+	tw9910_reset(client);
 	priv->scale = NULL;
 
 	return ret;
@@ -784,9 +787,10 @@ static int tw9910_try_fmt(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int tw9910_video_probe(struct soc_camera_device *icd)
+static int tw9910_video_probe(struct soc_camera_device *icd,
+			      struct i2c_client *client)
 {
-	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
+	struct tw9910_priv *priv = i2c_get_clientdata(client);
 	s32 val;
 	int ret;
 
@@ -810,10 +814,18 @@ static int tw9910_video_probe(struct soc_camera_device *icd)
 	icd->formats     = tw9910_color_fmt;
 	icd->num_formats = ARRAY_SIZE(tw9910_color_fmt);
 
+	/* Switch master clock on */
+	ret = soc_camera_video_start(icd, &client->dev);
+	if (ret)
+		return ret;
+
 	/*
 	 * check and show Product ID
 	 */
-	val = i2c_smbus_read_byte_data(priv->client, ID);
+	val = i2c_smbus_read_byte_data(client, ID);
+
+	soc_camera_video_stop(icd);
+
 	if (0x0B != GET_ID(val) ||
 	    0x00 != GET_ReV(val)) {
 		dev_err(&icd->dev,
@@ -824,10 +836,6 @@ static int tw9910_video_probe(struct soc_camera_device *icd)
 	dev_info(&icd->dev,
 		 "tw9910 Product ID %0x:%0x\n", GET_ID(val), GET_ReV(val));
 
-	ret = soc_camera_video_start(icd);
-	if (ret < 0)
-		return ret;
-
 	icd->vdev->tvnorms      = V4L2_STD_NTSC | V4L2_STD_PAL;
 	icd->vdev->current_norm = V4L2_STD_NTSC;
 
@@ -836,13 +844,11 @@ static int tw9910_video_probe(struct soc_camera_device *icd)
 
 static void tw9910_video_remove(struct soc_camera_device *icd)
 {
-	soc_camera_video_stop(icd);
+	icd->ops = NULL;
 }
 
 static struct soc_camera_ops tw9910_ops = {
 	.owner			= THIS_MODULE,
-	.probe			= tw9910_video_probe,
-	.remove			= tw9910_video_remove,
 	.init			= tw9910_init,
 	.release		= tw9910_release,
 	.start_capture		= tw9910_start_capture,
@@ -871,16 +877,25 @@ static int tw9910_probe(struct i2c_client *client,
 {
 	struct tw9910_priv             *priv;
 	struct tw9910_video_info       *info;
-	struct soc_camera_device       *icd;
+	struct soc_camera_device       *icd = client->dev.platform_data;
+	struct i2c_adapter             *adapter =
+		to_i2c_adapter(client->dev.parent);
+	struct soc_camera_link         *icl;
 	const struct tw9910_scale_ctrl *scale;
 	int                             i, ret;
 
-	info = client->dev.platform_data;
-	if (!info)
+	if (!icd) {
+		dev_err(&client->dev, "TW9910: missing soc-camera data!\n");
 		return -EINVAL;
+	}
 
-	if (!i2c_check_functionality(to_i2c_adapter(client->dev.parent),
-				     I2C_FUNC_SMBUS_BYTE_DATA)) {
+	icl = to_soc_camera_link(icd);
+	if (!icl)
+		return -EINVAL;
+
+	info = container_of(icl, struct tw9910_video_info, link);
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_err(&client->dev,
 			"I2C-Adapter doesn't support "
 			"I2C_FUNC_SMBUS_BYTE_DATA\n");
@@ -892,12 +907,9 @@ static int tw9910_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	priv->info   = info;
-	priv->client = client;
 	i2c_set_clientdata(client, priv);
 
-	icd          = &priv->icd;
 	icd->ops     = &tw9910_ops;
-	icd->control = &client->dev;
 	icd->iface   = info->link.bus_id;
 
 	/*
@@ -923,8 +935,7 @@ static int tw9910_probe(struct i2c_client *client,
 		icd->height_min = min(scale[i].height, icd->height_min);
 	}
 
-	ret = soc_camera_device_register(icd);
-
+	ret = tw9910_video_probe(icd, client);
 	if (ret) {
 		i2c_set_clientdata(client, NULL);
 		kfree(priv);
@@ -936,8 +947,9 @@ static int tw9910_probe(struct i2c_client *client,
 static int tw9910_remove(struct i2c_client *client)
 {
 	struct tw9910_priv *priv = i2c_get_clientdata(client);
+	struct soc_camera_device *icd = client->dev.platform_data;
 
-	soc_camera_device_unregister(&priv->icd);
+	tw9910_video_remove(icd);
 	i2c_set_clientdata(client, NULL);
 	kfree(priv);
 	return 0;
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index bef5e81..977326e 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -12,6 +12,7 @@
 #ifndef SOC_CAMERA_H
 #define SOC_CAMERA_H
 
+#include <linux/i2c.h>
 #include <linux/mutex.h>
 #include <linux/pm.h>
 #include <linux/videodev2.h>
@@ -20,7 +21,6 @@
 struct soc_camera_device {
 	struct list_head list;
 	struct device dev;
-	struct device *control;
 	unsigned short width;		/* Current window */
 	unsigned short height;		/* sizes */
 	unsigned short x_min;		/* Camera capabilities */
@@ -97,6 +97,8 @@ struct soc_camera_link {
 	int bus_id;
 	/* Per camera SOCAM_SENSOR_* bus flags */
 	unsigned long flags;
+	int i2c_adapter_id;
+	struct i2c_board_info *board_info;
 	/* Optional callbacks to power on or off and reset the sensor */
 	int (*power)(struct device *, int);
 	int (*reset)(struct device *);
@@ -120,17 +122,25 @@ static inline struct soc_camera_host *to_soc_camera_host(struct device *dev)
 	return dev_get_drvdata(dev);
 }
 
-extern int soc_camera_host_register(struct soc_camera_host *ici);
-extern void soc_camera_host_unregister(struct soc_camera_host *ici);
-extern int soc_camera_device_register(struct soc_camera_device *icd);
-extern void soc_camera_device_unregister(struct soc_camera_device *icd);
+static inline struct soc_camera_link *to_soc_camera_link(struct soc_camera_device *icd)
+{
+	return icd->dev.platform_data;
+}
 
-extern int soc_camera_video_start(struct soc_camera_device *icd);
-extern void soc_camera_video_stop(struct soc_camera_device *icd);
+static inline struct device *to_soc_camera_control(struct soc_camera_device *icd)
+{
+	return dev_get_drvdata(&icd->dev);
+}
 
-extern const struct soc_camera_data_format *soc_camera_format_by_fourcc(
+int soc_camera_host_register(struct soc_camera_host *ici);
+void soc_camera_host_unregister(struct soc_camera_host *ici);
+
+int soc_camera_video_start(struct soc_camera_device *icd, struct device *dev);
+void soc_camera_video_stop(struct soc_camera_device *icd);
+
+const struct soc_camera_data_format *soc_camera_format_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc);
-extern const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
+const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc);
 
 struct soc_camera_data_format {
@@ -159,8 +169,6 @@ struct soc_camera_format_xlate {
 
 struct soc_camera_ops {
 	struct module *owner;
-	int (*probe)(struct soc_camera_device *);
-	void (*remove)(struct soc_camera_device *);
 	int (*suspend)(struct soc_camera_device *, pm_message_t state);
 	int (*resume)(struct soc_camera_device *);
 	int (*init)(struct soc_camera_device *);
diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
index 1d092b4..db7ff89 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/soc_camera_platform.h
@@ -14,13 +14,12 @@
 #include <linux/videodev2.h>
 
 struct soc_camera_platform_info {
-	int iface;
-	char *format_name;
+	const char *format_name;
 	unsigned long format_depth;
 	struct v4l2_pix_format format;
 	unsigned long bus_param;
-	void (*power)(int);
 	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
+	struct soc_camera_link link;
 };
 
 #endif /* __SOC_CAMERA_H__ */
-- 
1.5.4

