Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:37240 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbZHKVCe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 17:02:34 -0400
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com, hverkuil@xs4all.nl,
	khilman@deeprootsystems.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 4/4 - v2] DaVinci:platform changes to support vpfe camera capture
Date: Tue, 11 Aug 2009 17:02:28 -0400
Message-Id: <1250024548-5146-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Incorporated some minor comments against v1 of the patch. In addition added
support for clock configuration.

NOTE: depends on vpfe capture initial set of patches which are merged to v4l-dvb
linux-next repository.

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to DaVinci tree
 arch/arm/mach-davinci/board-dm355-evm.c  |  140 +++++++++++++++++++++++++++++-
 arch/arm/mach-davinci/board-dm644x-evm.c |    6 +-
 2 files changed, 140 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index af09de4..f683559 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -24,6 +24,7 @@
 #include <media/tvp514x.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
+#include <linux/i2c/dm355evm_msp.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -138,14 +139,58 @@ static void dm355evm_mmcsd_gpios(unsigned gpio)
 	dm355evm_mmc_gpios = gpio;
 }
 
+#define PCA9543A_I2C_ADDR       (0x73)
+
+static struct i2c_client *pca9543a;
+
+static int pca9543a_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	pca9543a = client;
+	return 0;
+}
+
+static int pca9543a_remove(struct i2c_client *client)
+{
+	pca9543a = NULL;
+	return 0;
+}
+
+static const struct i2c_device_id pca9543a_ids[] = {
+	{ "PCA9543A", 0, },
+	{ /* end of list */ },
+};
+
+/* This is for i2c driver for the MT9T031 header i2c switch */
+static struct i2c_driver pca9543a_driver = {
+	.driver.name	= "PCA9543A",
+	.id_table	= pca9543a_ids,
+	.probe		= pca9543a_probe,
+	.remove		= pca9543a_remove,
+};
+
 static struct i2c_board_info dm355evm_i2c_info[] = {
 	{	I2C_BOARD_INFO("dm355evm_msp", 0x25),
 		.platform_data = dm355evm_mmcsd_gpios,
 	},
+	{
+		I2C_BOARD_INFO("PCA9543A", 0x73),
+	},
 	/* { plus irq  }, */
 	/* { I2C_BOARD_INFO("tlv320aic3x", 0x1b), }, */
 };
 
+/* have_sensor() - Check if we have support for sensor interface */
+static inline int have_sensor(void)
+{
+#if defined(CONFIG_SOC_CAMERA_MT9T031) || \
+    defined(CONFIG_SOC_CAMERA_MT9T031_MODULE)
+	return 1;
+#else
+	return 0;
+#endif
+}
+
 static void __init evm_init_i2c(void)
 {
 	davinci_init_i2c(&i2c_pdata);
@@ -153,7 +198,8 @@ static void __init evm_init_i2c(void)
 	gpio_request(5, "dm355evm_msp");
 	gpio_direction_input(5);
 	dm355evm_i2c_info[0].irq = gpio_to_irq(5);
-
+	if (have_sensor())
+		i2c_add_driver(&pca9543a_driver);
 	i2c_register_board_info(1, dm355evm_i2c_info,
 			ARRAY_SIZE(dm355evm_i2c_info));
 }
@@ -182,6 +228,72 @@ static struct platform_device dm355evm_dm9000 = {
 	.num_resources	= ARRAY_SIZE(dm355evm_dm9000_rsrc),
 };
 
+/**
+ * dm355_enable_i2c_switch() - Enable/Disable I2C switch PCA9543A for sensor
+ * @en: enable/disbale flag
+ */
+static int dm355evm_enable_i2c_switch(int en)
+{
+	static char val = 1;
+	int status;
+	struct i2c_msg msg = {
+			.flags = 0,
+			.len = 1,
+			.buf = &val,
+		};
+
+	if (!en)
+		val = 0;
+
+	if (!pca9543a)
+		return -ENXIO;
+
+	msg.addr = pca9543a->addr;
+	/* turn i2c switch, pca9543a, on/off */
+	status = i2c_transfer(pca9543a->adapter, &msg, 1);
+	return status;
+}
+
+/**
+ * dm355evm_setup_video_input() - setup video data path and i2c
+ * @id: sub device id
+ */
+static int dm355evm_setup_video_input(enum vpfe_subdev_id id)
+{
+	int ret;
+
+	switch (id) {
+	case VPFE_SUBDEV_MT9T031:
+	{
+		ret = dm355evm_msp_write(MSP_VIDEO_IMAGER,
+					 DM355EVM_MSP_VIDEO_IN);
+		if (ret >= 0)
+			ret = dm355evm_enable_i2c_switch(1);
+		else
+			/* switch off i2c switch since we failed */
+			ret = dm355evm_enable_i2c_switch(0);
+		break;
+	}
+	case VPFE_SUBDEV_TVP5146:
+	{
+		ret = dm355evm_msp_write(0, DM355EVM_MSP_VIDEO_IN);
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+	return (ret >= 0 ? 0 : ret);
+}
+
+/* Input available at the mt9t031 */
+static struct v4l2_input mt9t031_inputs[] = {
+	{
+		.index = 0,
+		.name = "Camera",
+		.type = V4L2_INPUT_TYPE_CAMERA,
+	}
+};
+
 static struct tvp514x_platform_data tvp5146_pdata = {
 	.clk_polarity = 0,
 	.hs_polarity = 1,
@@ -205,7 +317,7 @@ static struct v4l2_input tvp5146_inputs[] = {
 	},
 };
 
-/*
+/**
  * this is the route info for connecting each input to decoder
  * ouput that goes to vpfe. There is a one to one correspondence
  * with tvp5146_inputs
@@ -223,8 +335,8 @@ static struct vpfe_route tvp5146_routes[] = {
 
 static struct vpfe_subdev_info vpfe_sub_devs[] = {
 	{
-		.name = "tvp5146",
-		.grp_id = 0,
+		.module_name = TVP514X_MODULE_NAME,
+		.grp_id = VPFE_SUBDEV_TVP5146,
 		.num_inputs = ARRAY_SIZE(tvp5146_inputs),
 		.inputs = tvp5146_inputs,
 		.routes = tvp5146_routes,
@@ -238,6 +350,23 @@ static struct vpfe_subdev_info vpfe_sub_devs[] = {
 			I2C_BOARD_INFO("tvp5146", 0x5d),
 			.platform_data = &tvp5146_pdata,
 		},
+	},
+	{
+		.module_name = "mt9t031",
+		.is_camera = 1,
+		.grp_id = VPFE_SUBDEV_MT9T031,
+		.num_inputs = ARRAY_SIZE(mt9t031_inputs),
+		.inputs = mt9t031_inputs,
+		.ccdc_if_params = {
+			.if_type = VPFE_RAW_BAYER,
+			.hdpol = VPFE_PINPOL_POSITIVE,
+			.vdpol = VPFE_PINPOL_POSITIVE,
+		},
+		.board_info = {
+			I2C_BOARD_INFO("mt9t031", 0x5d),
+			/* this is for PCLK rising edge */
+			.platform_data = (void *)1,
+		},
 	}
 };
 
@@ -246,6 +375,9 @@ static struct vpfe_config vpfe_cfg = {
 	.sub_devs = vpfe_sub_devs,
 	.card_name = "DM355 EVM",
 	.ccdc = "DM355 CCDC",
+	.num_clocks = 2,
+	.clocks = {"vpss_master", "vpss_slave"},
+	.setup_input = dm355evm_setup_video_input,
 };
 
 static struct platform_device *davinci_evm_devices[] __initdata = {
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 8cc6acd..cfd9afa 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -237,8 +237,8 @@ static struct vpfe_route tvp5146_routes[] = {
 
 static struct vpfe_subdev_info vpfe_sub_devs[] = {
 	{
-		.name = "tvp5146",
-		.grp_id = 0,
+		.module_name = TVP514X_MODULE_NAME,
+		.grp_id = VPFE_SUBDEV_TVP5146,
 		.num_inputs = ARRAY_SIZE(tvp5146_inputs),
 		.inputs = tvp5146_inputs,
 		.routes = tvp5146_routes,
@@ -260,6 +260,8 @@ static struct vpfe_config vpfe_cfg = {
 	.sub_devs = vpfe_sub_devs,
 	.card_name = "DM6446 EVM",
 	.ccdc = "DM6446 CCDC",
+	.num_clocks = 2,
+	.clocks = {"vpss_master", "vpss_slave"},
 };
 
 static struct platform_device rtc_dev = {
-- 
1.6.0.4

