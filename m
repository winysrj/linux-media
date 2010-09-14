Return-path: <mchehab@pedra>
Received: from smtpauth11.prod.mesa1.secureserver.net ([64.202.165.33]:56097
	"HELO smtpauth11.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752400Ab0INX7V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 19:59:21 -0400
Message-ID: <4C900AAC.4050904@galilsoft.com>
Date: Wed, 15 Sep 2010 01:52:12 +0200
From: Yanir Lubetkin <yanir.lubetkin@galilsoft.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] mt9p031 support for dm355-evm
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch was created from the linux-davinci staging kernel at 
arago-project.org


---
  arch/arm/mach-davinci/board-dm355-evm.c    |   49 ++-
  drivers/media/video/Kconfig                |   10 +
  drivers/media/video/Makefile               |    1 +
  drivers/media/video/davinci/vpfe_capture.c |    2 +-
  drivers/media/video/mt9p031.c              |  834 
++++++++++++++++++++++++++++
  drivers/mfd/dm355evm_msp.c                 |   12 +-
  include/media/davinci/vpfe_capture.h       |    1 +
  include/media/v4l2-chip-ident.h            |    3 +
  8 files changed, 902 insertions(+), 10 deletions(-)
  create mode 100644 drivers/media/video/mt9p031.c

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c 
b/arch/arm/mach-davinci/board-dm355-evm.c
index 5d3946e..dd329dd 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -179,9 +179,11 @@ static struct i2c_board_info dm355evm_i2c_info[] = {
  	{	I2C_BOARD_INFO("dm355evm_msp", 0x25),
  		.platform_data = dm355evm_mmcsd_gpios,
  	},
+#if defined(CONFIG_SOC_CAMERA_MT9T031)
  	{
  		I2C_BOARD_INFO("PCA9543A", 0x73),
  	},
+#endif
  	/* { plus irq  }, */
  	{ I2C_BOARD_INFO("tlv320aic33", 0x1b), },
  };
@@ -190,8 +192,10 @@ static struct i2c_board_info dm355evm_i2c_info[] = {
  static inline int have_sensor(void)
  {
  #if defined(CONFIG_SOC_CAMERA_MT9T031) || \
-    defined(CONFIG_SOC_CAMERA_MT9T031_MODULE)
-	return 1;
+    defined(CONFIG_SOC_CAMERA_MT9T031_MODULE) || \
+    defined(CONFIG_VIDEO_MT9P031) || \
+    defined(CONFIG_VIDEO_MT9P031_MODULE)
+		return 1;
  #else
  	return 0;
  #endif
@@ -204,8 +208,10 @@ static void __init evm_init_i2c(void)
  	gpio_request(5, "dm355evm_msp");
  	gpio_direction_input(5);
  	dm355evm_i2c_info[0].irq = gpio_to_irq(5);
+#if defined(CONFIG_SOC_CAMERA_MT9T031)
  	if (have_sensor())
  		i2c_add_driver(&pca9543a_driver);
+#endif
  	i2c_register_board_info(1, dm355evm_i2c_info,
  			ARRAY_SIZE(dm355evm_i2c_info));
  }
@@ -266,18 +272,21 @@ static int dm355evm_enable_pca9543a(int en)
   */
  static int dm355evm_setup_video_input(enum vpfe_subdev_id id)
  {
-	int ret;
-
+	int ret = 0;
+#if defined CONFIG_VIDEO_CAPTURE_DRIVERS
  	switch (id) {
+	case VPFE_SUBDEV_MT9P031:
  	case VPFE_SUBDEV_MT9T031:
  	{
  		ret = dm355evm_msp_write(MSP_VIDEO_IMAGER,
  					 DM355EVM_MSP_VIDEO_IN);
+#if defined(CONFIG_SOC_CAMERA_MT9T031)
  		if (ret >= 0)
  			ret = dm355evm_enable_pca9543a(1);
  		else
  			/* switch off i2c switch since we failed */
  			ret = dm355evm_enable_pca9543a(0);
+#endif
  		break;
  	}
  	case VPFE_SUBDEV_TVP5146:
@@ -288,6 +297,7 @@ static int dm355evm_setup_video_input(enum 
vpfe_subdev_id id)
  	default:
  		return -EINVAL;
  	}
+#endif
  	return (ret >= 0 ? 0 : ret);
  }

@@ -300,6 +310,15 @@ static struct v4l2_input mt9t031_inputs[] = {
  	}
  };

+/* Input available at the mt9p031 */
+static struct v4l2_input mt9p031_inputs[] = {
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
@@ -357,6 +376,7 @@ static struct vpfe_subdev_info vpfe_sub_devs[] = {
  			.platform_data = &tvp5146_pdata,
  		},
  	},
+#if defined(CONFIG_SOC_CAMERA_MT9T031)
  	{
  		.module_name = "mt9t031",
  		.is_camera = 1,
@@ -373,7 +393,26 @@ static struct vpfe_subdev_info vpfe_sub_devs[] = {
  			/* this is for PCLK rising edge */
  			.platform_data = (void *)1,
  		},
-	}
+	},
+#elif defined(CONFIG_VIDEO_MT9P031) /* mutually exclusive (same i2c 
addr) */
+	{
+		.module_name = "mt9p031",
+		.is_camera = 1,
+		.grp_id = VPFE_SUBDEV_MT9P031,
+		.num_inputs = ARRAY_SIZE(mt9p031_inputs),
+		.inputs = mt9p031_inputs,
+		.ccdc_if_params = {
+			.if_type = VPFE_RAW_BAYER,
+			.hdpol = VPFE_PINPOL_POSITIVE,
+			.vdpol = VPFE_PINPOL_POSITIVE,
+		},
+		.board_info = {
+			I2C_BOARD_INFO("mt9p031", 0x5d),
+			/* this is for PCLK rising edge */
+// 			.platform_data = (void *)1,
+		},
+	},
+#endif
  };

  static struct vpfe_config vpfe_cfg = {
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index becefc9..866f72c 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1002,6 +1002,16 @@ config SOC_CAMERA_MT9T031
  	depends on I2C
  	help
  	  This driver supports MT9T031 cameras from Micron.
+config VIDEO_MT9P031
+	tristate "mt9p031 support"
+	depends on I2C
+	depends on !SOC_CAMERA_MT9T031
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the aptina mt9p031
+	  decoder. It is currently working with the TI dm355evm board.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mt9p031.

  config SOC_CAMERA_MT9V022
  	tristate "mt9v022 support"
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 5327ff4..a48d5d6 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_VIDEO_KS0127) += ks0127.o
  obj-$(CONFIG_VIDEO_THS7303) += ths7303.o
  obj-$(CONFIG_VIDEO_THS7353) += ths7353.o
  obj-$(CONFIG_VIDEO_VINO) += indycam.o
+obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o
  obj-$(CONFIG_VIDEO_TVP5150) += tvp5150.o
  obj-$(CONFIG_VIDEO_TVP514X) += tvp514x.o
  obj-$(CONFIG_VIDEO_TVP7002) += tvp7002.o
diff --git a/drivers/media/video/davinci/vpfe_capture.c 
b/drivers/media/video/davinci/vpfe_capture.c
index 033ceda..77cef74 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -87,7 +87,7 @@
  static int debug;
  static u32 numbuffers = 3;
  static u32 bufsize = HD_IMAGE_SIZE + SECOND_IMAGE_SIZE_MAX;
-static int interface;
+static int interface=1;
  static u32 cont_bufoffset;
  static u32 cont_bufsize;

diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
new file mode 100644
index 0000000..fa8eaa5
--- /dev/null
+++ b/drivers/media/video/mt9p031.c
@@ -0,0 +1,834 @@
+/*
+ * drivers/media/video/mt9p031.c
+ *
+ * Aptina mt9p031 cmos sensor driver
+ * Copyright (C) 2009 Galil Soft Ltd. (http://www.galilsoft.com)
+ * Authors: Ran Eitan & Yanir Lubetkin <galil <at> galilsoft.com>
+ *
+ * This driver is heavily based on and derived from work previously 
published
+ * by Guennadi Liakhovetski, DENX Software Engineering <lg@denx.de> and 
many
+ * other contributors to the kernel sources.
+ * all kudos, credits and rights are humbly acknoledged and granted.
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 or 
later as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with the linux kernel sources; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-chip-ident.h>
+
+#define MT9P031_MODULE_NAME		"mt9p031"
+
+/* we use this number to decide if we can increase the exposure, move 
from skipping to binning, etc.
+   the constraint is that this is the minimal frame rate that can still 
be considered smooth video.
+*/
+#define MIN_VIDEO_FPS 21
+
+MODULE_AUTHOR("Ran Eitan & Yanir Lubetkin (Galil Soft LTD.) galil <at> 
  galilsoft.com");
+MODULE_DESCRIPTION("MT9P031 sensor driver for use with davinci dm355 
vpfe.");
+MODULE_LICENSE("GPL");
+
+#define MT9P031_MAX_HEIGHT		1944
+#define MT9P031_MAX_WIDTH		2592
+#define MT9P031_MIN_HEIGHT		2
+#define MT9P031_MIN_WIDTH		2
+
+
+#define REG_MT9P031_CHIP_VERSION		0x00
+#define REG_MT9P031_ROWSTART			0x01
+#define REG_MT9P031_COLSTART			0x02
+#define REG_MT9P031_HEIGHT				0x03
+#define REG_MT9P031_WIDTH				0x04
+#define REG_MT9P031_HBLANK				0x05
+#define REG_MT9P031_VBLANK				0x06
+#define REG_MT9P031_OUT_CTRL			0x07
+#define REG_MT9P031_SHUTTER_WIDTH_U		0x08
+#define REG_MT9P031_SHUTTER_WIDTH_L		0x09
+#define REG_MT9P031_CLK_SPEED			0x0a
+#define REG_MT9P031_RESTART				0x0b
+#define REG_MT9P031_SHUTTER_DELAY		0x0c
+#define REG_MT9P031_RESET				0x0d
+
+#define REG_MT9P031_PLL_CTRL			0x10
+#define REG_MT9P031_PLL_CONF1			0x11
+#define REG_MT9P031_PLL_CONF2			0x12
+
+#define REG_MT9P031_READ_MODE1			0x1e
+#define REG_MT9P031_READ_MODE2			0x20
+#define REG_MT9P031_ROW_ADDR_MODE		0x22
+#define REG_MT9P031_COL_ADDR_MODE		0x23
+#define REG_MT9P031_GREEN_1_GAIN		0x2b
+#define REG_MT9P031_BLUE_GAIN			0x2c
+#define REG_MT9P031_RED_GAIN			0x2d
+#define REG_MT9P031_GREEN_2_GAIN		0x2e
+#define REG_MT9P031_GLOBAL_GAIN			0x35
+
+#define REG_MT9P031_BLC_SAMPLE_SIZE		0x5b
+#define REG_MT9P031_BLC_TUNE1			0x5c
+#define REG_MT9P031_BLC_DELTA_TRSHLD	0x5d
+#define REG_MT9P031_BLC_TUNE2			0x5e
+#define REG_MT9P031_BLC_TARGET_TRSHLD	0x5f
+#define REG_MT9P031_GREEN_OFFS1			0x60
+#define REG_MT9P031_GREEN_OFFS2			0x61
+#define REG_MT9P031_BLACK_LEVEL_CALIB	0x62
+#define REG_MT9P031_RED_OFFS			0x63
+#define REG_MT9P031_BLUE_OFFS			0x64
+#define REG_MT9P031_SELF_TEST			0xa0
+#define REG_MT9P031_TEST_GREEN			0xa1
+#define REG_MT9P031_TEST_BLUE			0xa2
+#define REG_MT9P031_TEST_RED			0xa3
+#define REG_MT9P031_TEST_WIDTH			0xa4
+
+#define MT9P031_NORMAL_OPERATION_MODE		(0x1F82)//(0x0002)// //write
+#define MT9P031_OUTPUT_CTRL_CHIP_UNSELECT	(0x1F80) //write
+#define MT9P031_OUTPUT_CTRL_HALT			(0x1F83)
+#define ADDRESS_MODE_MASK					(0x0037)
+#define MT9P031_SHUTTER_WIDTH_UPPER_SHIFT	(16)
+#define REG_MT9P031_BLK_DEF_OFFSET			(0x4B)
+
+enum mt9p031_ctrl {
+	CTRL_R_GAIN,
+	CTRL_B_GAIN,
+	CTRL_G_1_GAIN,
+	CTRL_G_2_GAIN,
+	CTRL_R_OFFSET,
+	CTRL_B_OFFSET,
+	CTRL_G1_OFFSET,
+	CTRL_G2_OFFSET,
+	CTRL_CID_GAIN
+};
+
+struct mt9p031
+{
+    int model;	/* V4L2_IDENT_MT9P031* codes from v4l2-chip-ident.h */
+//    struct mt9p031_regs regs;
+    struct v4l2_subdev sd;
+    struct v4l2_format fmt;
+    u16 global_gain, red_bal, blue_bal;
+    u16 exposure;
+    u16 global_gain_max, global_gain_min, exposure_max, exposure_min;
+    int is_aew, wbl_temperature;
+    int r_gain, b_gain ,g1_gain ,g2_gain;
+    int row_bin;
+    int width, height;
+    int column_size, row_size;
+};
+
+int hb_min[4][4] = { {450, 430, 0, 420},
+                     {796, 776, 0, 766},
+                     {0,   0, 0,   0},
+                     {1488,1468,0, 1458} };
+
+int w_dc[4] =  {80, 40, 0, 20 };
+
+static struct v4l2_captureparm g_temp_capture_params =
+{
+    .capability = 0,
+};
+
+static inline struct mt9p031 *to_mt9p031(struct v4l2_subdev *sd)
+{
+    return container_of(sd, struct mt9p031, sd);
+}
+
+static int reg_read(struct i2c_client *client, const u8 reg)
+{
+    s32 data = i2c_smbus_read_word_data(client, reg);
+    return data < 0 ? data : swab16(data);
+}
+
+static int reg_write(struct i2c_client *client, const u8 reg, const u16 
data)
+{
+    return i2c_smbus_write_word_data(client, reg, swab16(data));
+}
+
+static int reg_set(struct i2c_client *client, const u8 reg, const u16 data)
+{
+    int ret = reg_read(client, reg);
+    if (ret < 0)
+        return ret;
+    return reg_write(client, reg, ret | data);
+}
+
+static int reg_clear(struct i2c_client *client, const u8 reg,
+                     const u16 data)
+{
+    int ret = reg_read(client, reg);
+    if (ret < 0)
+        return ret;
+    return reg_write(client, reg, ret & ~data);
+}
+
+
+static const struct v4l2_fmtdesc mt9p031_formats[] =
+{
+    {
+        .index = 0,
+		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+		.description = "Bayer (sRGB) 12 bit",
+		.pixelformat = V4L2_PIX_FMT_SBGGR16,
+	},
+};
+
+static const unsigned int mt9p031_num_formats = 
ARRAY_SIZE(mt9p031_formats);
+
+static struct v4l2_queryctrl mt9p031_qctrl[] = {
+    {
+        .id = V4L2_CID_EXPOSURE,
+        .type = V4L2_CTRL_TYPE_INTEGER,
+        .name = "Exposure",
+        .minimum = 0,
+        .maximum = (1 << 10) - 1,
+        .step = 1,
+        .default_value = 0x0020,
+        .flags = 0,
+    },
+    {
+        .id = V4L2_CID_GAIN,
+        .type = V4L2_CTRL_TYPE_INTEGER,
+        .name = "Gain",
+        .minimum = 0,
+        .maximum = (1 << 10) - 1,
+        .step = 1,
+        .default_value = 0x0020,
+        .flags = 0,
+    },
+    {
+        .id = V4L2_CID_RED_BALANCE,
+        .type = V4L2_CTRL_TYPE_INTEGER,
+        .name = "Red Balance",
+        .minimum = -1 << 9,
+        .maximum = (1 << 9) - 1,
+        .step = 1,
+        .default_value = 0,
+        .flags = 0,
+    },
+    {
+        .id = V4L2_CID_BLUE_BALANCE,
+        .type = V4L2_CTRL_TYPE_INTEGER,
+        .name = "Blue Balance",
+        .minimum = -1 << 9,
+        .maximum = (1 << 9) - 1,
+        .step = 1,
+        .default_value = 0,
+        .flags = 0,
+    },
+    {
+        .id = CTRL_R_GAIN,
+        .type = V4L2_CTRL_TYPE_INTEGER,
+        .name = "red_gain",
+        .minimum = 0,
+        .maximum = (1 << 10) - 1,
+        .step = 1,
+        .default_value = 0x0020,
+        .flags = 0,
+    },
+    {
+        .id = CTRL_B_GAIN,
+        .type = V4L2_CTRL_TYPE_INTEGER,
+        .name = "blue_gain",
+        .minimum = 0,
+        .maximum = (1 << 10) - 1,
+        .step = 1,
+        .default_value = 0x0020,
+        .flags = 0,
+    },
+    {
+        .id = CTRL_G_1_GAIN,
+        .type = V4L2_CTRL_TYPE_INTEGER,
+        .name = "green_1_gain",
+        .minimum = -1 << 9,
+        .maximum = (1 << 9) - 1,
+        .step = 1,
+        .default_value = 0,
+        .flags = 0,
+    },
+    {
+        .id = CTRL_G_2_GAIN,
+        .type = V4L2_CTRL_TYPE_INTEGER,
+        .name = "green_2_gain",
+        .minimum = -1 << 9,
+        .maximum = (1 << 9) - 1,
+        .step = 1,
+        .default_value = 0,
+        .flags = 0,
+    },
+    {
+        .id = CTRL_R_OFFSET,
+        .type = V4L2_CTRL_TYPE_INTEGER,
+        .name = "ctrl_r_offset",
+        .minimum = -1 << 9,
+        .maximum = (1 << 9) - 1,
+        .step = 1,
+        .default_value = 0,
+        .flags = 0,
+    },
+    {
+        .id = CTRL_B_OFFSET,
+        .type = V4L2_CTRL_TYPE_INTEGER,
+        .name = "ctrl_b_offset",
+        .minimum = -1 << 9,
+        .maximum = (1 << 9) - 1,
+        .step = 1,
+        .default_value = 0,
+        .flags = 0,
+    },
+    {
+        .id = CTRL_G1_OFFSET,
+        .type = V4L2_CTRL_TYPE_INTEGER,
+        .name = "green_g1_gain",
+        .minimum = -1 << 9,
+        .maximum = (1 << 9) - 1,
+        .step = 1,
+        .default_value = 0,
+        .flags = 0,
+    },
+    {
+        .id = CTRL_G2_OFFSET,
+        .type = V4L2_CTRL_TYPE_INTEGER,
+        .name = "green_g2_gain",
+        .minimum = -1 << 9,
+        .maximum = (1 << 9) - 1,
+        .step = 1,
+        .default_value = 0,
+        .flags = 0,
+    }
+};
+
+static int mt9p031_init(struct v4l2_subdev *sd, u32 val)
+{
+    int ret;
+    struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+#define PLL_MUL       88
+#define PLL_DIV_SCLK  4
+#define PLL_DIV_PCLK  8
+
+	ret = reg_write(client, REG_MT9P031_RESET, 0xffff);
+	if(ret < 0)
+		goto err;
+	mdelay(100);
+	ret = reg_write(client, REG_MT9P031_RESET, 0x0000);
+	if(ret < 0)
+		goto err;
+	mdelay(10);
+	ret = reg_write(client, REG_MT9P031_PLL_CTRL, 0x0051);
+	if(ret < 0)
+		goto err;
+	ret = reg_write(client, REG_MT9P031_PLL_CONF1, (PLL_MUL << 8) | 
(PLL_DIV_SCLK - 1));
+	if(ret < 0)
+		goto err;
+	ret = reg_write(client, REG_MT9P031_PLL_CONF2, PLL_DIV_PCLK - 1);
+	if(ret < 0)
+		goto err;
+	ret = reg_write(client, REG_MT9P031_PLL_CTRL, 0x0053);
+	if(ret < 0)
+		goto err;
+ 	ret = reg_write(client, REG_MT9P031_CLK_SPEED, 0x8000);
+	if(ret < 0)
+		goto err;
+	ret = reg_write(client, REG_MT9P031_HBLANK, 0);
+	if(ret < 0)
+		goto err;
+	ret = reg_write(client, REG_MT9P031_VBLANK, 8);
+	if(ret < 0)
+		goto err;
+	ret = reg_write(client, REG_MT9P031_READ_MODE1, 0x4006);
+	if(ret < 0)
+		goto err;
+	ret = reg_write(client, REG_MT9P031_SHUTTER_WIDTH_U, 0x0);
+	if(ret < 0)
+		goto err;
+	ret = reg_write(client, REG_MT9P031_SHUTTER_WIDTH_L, 100);
+	if(ret < 0)
+		goto err;
+	ret = reg_write(client, 0x29, 0x481);
+	ret |= reg_write(client, 0x3E, 0x87);
+	ret |= reg_write(client, 0x3F, 0x07);
+	ret |= reg_write(client, 0x41, 0x0003);
+	ret |= reg_write(client, 0x42, 0x0003);
+	ret |= reg_write(client, 0x43, 0x0003);
+	ret |= reg_write(client, 0x4F, 0x0014);
+	ret |= reg_write(client, 0x48, 0x18);
+	ret |= reg_write(client, 0x5F, 0x1C16);
+	ret |= reg_write(client, 0x57, 0x7);
+	ret |= reg_write(client, 0x70, 0x005C);
+	ret |= reg_write(client, 0x71, 0x5B00);
+	ret |= reg_write(client, 0x72, 0x5900);
+	ret |= reg_write(client, 0x73, 0x200);
+	ret |= reg_write(client, 0x74, 0x200);
+	ret |= reg_write(client, 0x75, 0x2800);
+	ret |= reg_write(client, 0x76, 0x3E29);
+	ret |= reg_write(client, 0x77, 0x3E29);
+	ret |= reg_write(client, 0x78, 0x583F);
+	ret |= reg_write(client, 0x79, 0x5B00);
+	ret |= reg_write(client, 0x7A, 0x5A00);
+	ret |= reg_write(client, 0x7B, 0x5900);
+	ret |= reg_write(client, 0x7C, 0x5900);
+	ret |= reg_write(client, 0x7E, 0x5900);
+	ret |= reg_write(client, 0x7F, 0x5900);
+	ret |= reg_write(client, REG_MT9P031_RESTART, 1);
+err:
+    return ret >= 0 ? 0 : -EIO;
+}
+
+static int mt9p031_queryctrl(struct v4l2_subdev *sd, struct 
v4l2_queryctrl *qc)
+{
+    int i;
+    for (i = 0; i < ARRAY_SIZE(mt9p031_qctrl); i++) {
+        if (qc->id && qc->id == mt9p031_qctrl[i].id) {
+            memcpy(qc, &(mt9p031_qctrl[i]), sizeof(*qc));
+            return 0;
+        }
+    }
+    return -EINVAL;
+}
+
+static int mt9p031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control 
*ctrl)
+{
+    struct i2c_client *client = v4l2_get_subdevdata(sd);
+    struct mt9p031 *core = to_mt9p031(sd);
+    int ret = 0, shutter_width, so_p, pix_clk, sd_p, shutter_delay;
+    int sw_l ,sw_u ,W ,h_banking, t_row;
+    switch (ctrl->id) {
+    case CTRL_R_GAIN:
+        core->r_gain = ctrl->value;
+        ret = reg_write(client, REG_MT9P031_RED_GAIN, ctrl->value);
+        break;
+    case CTRL_B_GAIN:
+        core->b_gain = ctrl->value;
+        ret = reg_write(client, REG_MT9P031_BLUE_GAIN, ctrl->value);
+        break;
+    case CTRL_G_1_GAIN:
+        core->g1_gain = ctrl->value;
+        ret = reg_write(client, REG_MT9P031_GREEN_1_GAIN, ctrl->value);
+        break;
+    case CTRL_G_2_GAIN:
+        core->g2_gain = ctrl->value;
+        ret = reg_write(client, REG_MT9P031_GREEN_2_GAIN, ctrl->value);
+        break;
+    case CTRL_R_OFFSET:
+        ret = reg_write(client, REG_MT9P031_RED_OFFS, ctrl->value);
+        break;
+    case CTRL_B_OFFSET:
+        ret = reg_write(client, REG_MT9P031_BLUE_OFFS, ctrl->value);
+        break;
+    case CTRL_G1_OFFSET:
+        ret = reg_write(client, REG_MT9P031_GREEN_OFFS1, ctrl->value);
+        break;
+    case CTRL_G2_OFFSET:
+        ret = reg_write(client, REG_MT9P031_GREEN_OFFS2, ctrl->value);
+        break;
+    case CTRL_CID_GAIN:
+        ret = reg_write(client, REG_MT9P031_RED_GAIN,     (ctrl->value 
& 0x0000007f));
+        mdelay(1);
+        ret |= reg_write(client, REG_MT9P031_GREEN_1_GAIN, 
((ctrl->value & 0x00007f00) >> 8));
+        mdelay(1);
+        ret |= reg_write(client, REG_MT9P031_GREEN_2_GAIN, 
((ctrl->value & 0x007f0000) >> 16));
+        mdelay(1);
+        ret |= reg_write(client, REG_MT9P031_RED_GAIN, 
((ctrl->value & 0x7f000000) >> 24));
+        break;
+    case V4L2_CID_EXPOSURE:
+        shutter_delay = reg_read(client, REG_MT9P031_SHUTTER_DELAY);
+        sd_p = min(shutter_delay + 1, 1604);
+        so_p = 346 * (core->row_bin + 1) + 98 + sd_p + 166;
+        pix_clk = 41;
+        h_banking = reg_read(client, REG_MT9P031_HBLANK) + 1;
+        W = (core->width + 1) / (core->row_bin + 1);
+        t_row = 2 * pix_clk * max(W/2 + max(h_banking, 
hb_min[core->row_bin][core->row_bin]),
+                                  (41 + 346 * (core->row_bin + 1) + 
99))/1000;
+        shutter_width = (ctrl->value + 2*so_p*pix_clk) / t_row;
+        if (shutter_width < 3) {
+            sd_p = 1315 > shutter_delay ? 1315 : shutter_delay;
+            so_p = 346 * (core->row_bin + 1) + 98 + sd_p + 166;
+            shutter_width = (ctrl->value + 2*so_p*pix_clk) / t_row;
+        }
+        if (shutter_width < 1)
+            shutter_width = 1;
+        sw_l = shutter_width & 0xffff;
+        sw_u = (shutter_width) >> 16;
+        ret = reg_write(client, REG_MT9P031_SHUTTER_WIDTH_L,sw_l);
+        mdelay(1);
+        ret = reg_write(client, REG_MT9P031_SHUTTER_WIDTH_U,sw_u);
+        break;
+    default:
+        return -ERANGE;
+    }
+    return ret;
+}
+
+static int mt9p031_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	if (pix->height < MT9P031_MIN_HEIGHT)
+		pix->height = MT9P031_MIN_HEIGHT;
+	else if (pix->height > MT9P031_MAX_HEIGHT)
+		pix->height = MT9P031_MAX_HEIGHT;
+	if (pix->width < MT9P031_MIN_WIDTH)
+		pix->width = MT9P031_MIN_WIDTH;
+	if (pix->width > MT9P031_MAX_WIDTH)
+		pix->width = MT9P031_MAX_WIDTH;
+
+	pix->width &= ~0x01; /* has to be even */
+	pix->height &= ~0x01; /* has to be even */
+	pix->pixelformat =  V4L2_PIX_FMT_SBGGR16;
+	return 0;
+}
+struct mt9p031_format_params {
+	int width;
+	int height;
+	int col_size;
+	int row_size;
+	int hblank;
+	int vblank;
+	int shutter_width;
+	int row_addr_mode;
+	int col_addr_mode;
+	int black_level;
+	int pixel_clk_control;
+	int row_start;
+	int col_start;
+	int read_mode_2_config;
+	int output_ctrl;
+	int pll_m;
+	int pll_n;
+	int pll_p1;
+};
+
+enum formats {
+	VGA_BIN_30FPS,
+	SVGA_30FPS,
+	XGA_30FPS,
+	SXGA_30FPS,
+	HD_READY_720P_30FPS,
+	FULL_5MP_7FPS,
+};
+
+const struct mt9p031_format_params mt9p031_supported_formats[] =
+	{
+		{ 640, 480, 2575, 1951, 1470, 8, 496, 0x33, 0x33, 64, 0x8000, 32, 24, 
32, 0x1F82, 0x12,  4, 2, },  // VGA_BIN_30FPS
+		{ 800, 600, 1599, 1199,    0, 8, 599, 0x11, 0x11, 64, 0x8000,  0,  0, 
64, 0x1F82, 0xFF, 29, 4, },  // SVGA_30FPS
+		{1024, 768, 2047, 1535,    0, 8, 767, 0x11, 0x11, 64, 0x8000,  0,  0, 
64, 0x1F82, 0xFF, 29, 4, },  // XGA_30FPS
+		{1280,1024, 2575, 1951,  776,10, 744, 0x11, 0x11, 64, 0x8000, 32, 24, 
32, 0x1F8E, 0x1C,  4, 2, },  // SXGA_30FPS
+		{1280, 720, 2583, 1491,  786, 0, 740, 0x11, 0x11, 64, 0x8000,272, 24, 
32, 0x1F8E,   16,  3, 2, },
+		{2592,1944, 2591, 1943,  450, 9,1942, 0x00, 0x00, 64, 0x8000, 66, 32, 
64, 0x1F82, /*24*/ 12,  4, 2, },  // 5MP_7FPS
+	};
+static int mt9p031_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *fmt)
+{
+	int ret;
+    struct v4l2_pix_format *pix = &fmt->fmt.pix;
+    struct mt9p031 *core = to_mt9p031(sd);
+	enum formats i;
+    struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+    memcpy(&(core->fmt), fmt, sizeof(struct v4l2_format));
+	if (pix->width < 640)
+		return -EINVAL;
+    else if (pix->width < 800) {
+		if (pix->height >= 480)
+			i = VGA_BIN_30FPS;
+		else
+			return -EINVAL;
+    }
+    else if (pix->width < 1024) {
+		if (pix->height >= 600)
+			i = SVGA_30FPS;
+		else
+			return -EINVAL;
+    }
+    else if (pix->width < 1280) {
+		if (pix->height >= 768)
+			i = XGA_30FPS;
+		else
+		return -EINVAL;
+    }
+	else if (pix->width < 2592) {
+		if (pix->height < 768) {
+			i = HD_READY_720P_30FPS;	// 1280*720
+    }
+		else if (pix->height == 768) {
+			i = SXGA_30FPS;	// 1280*768
+    }
+		else {
+			return -EINVAL;
+    }
+    }
+	else {
+		if (pix->height == 1944)
+			i = FULL_5MP_7FPS;
+		else
+        return -EINVAL;
+    }
+	
+	core->width = mt9p031_supported_formats[i].width;
+	core->height = mt9p031_supported_formats[i].height;
+	ret = reg_write(client, REG_MT9P031_OUT_CTRL, MT9P031_OUTPUT_CTRL_HALT);	
+	ret |= reg_write(client, REG_MT9P031_HEIGHT, 
mt9p031_supported_formats[i].row_size );
+	ret |= reg_write(client, REG_MT9P031_WIDTH, 
mt9p031_supported_formats[i].col_size);
+	ret |= reg_clear(client, REG_MT9P031_ROW_ADDR_MODE, ADDRESS_MODE_MASK);
+	ret |= reg_set(client, REG_MT9P031_ROW_ADDR_MODE, 
mt9p031_supported_formats[i].row_addr_mode);
+	ret |= reg_clear(client, REG_MT9P031_COL_ADDR_MODE, ADDRESS_MODE_MASK);
+	ret |= reg_set(client, REG_MT9P031_COL_ADDR_MODE, 
mt9p031_supported_formats[i].col_addr_mode);
+	core->row_bin = mt9p031_supported_formats[i].row_addr_mode & 0x0F;
+	ret |= reg_write(client, REG_MT9P031_HBLANK, 
mt9p031_supported_formats[i].hblank);
+	ret |= reg_write(client, REG_MT9P031_VBLANK, 
mt9p031_supported_formats[i].vblank);
+	ret |= reg_write(client, REG_MT9P031_ROWSTART, 
mt9p031_supported_formats[i].row_start);
+	ret |= reg_write(client, REG_MT9P031_COLSTART, 
mt9p031_supported_formats[i].col_start);
+
+	ret |= reg_write(client, REG_MT9P031_SHUTTER_WIDTH_U,
+		  (unsigned short)(mt9p031_supported_formats[i].shutter_width >> 
MT9P031_SHUTTER_WIDTH_UPPER_SHIFT) );
+	ret |= reg_write(client, REG_MT9P031_SHUTTER_WIDTH_L, (unsigned 
short)mt9p031_supported_formats[i].shutter_width);
+
+	ret |= reg_write(client, REG_MT9P031_BLK_DEF_OFFSET, 
mt9p031_supported_formats[i].black_level);
+	ret |= reg_write(client, REG_MT9P031_CLK_SPEED, 
mt9p031_supported_formats[i].pixel_clk_control);
+
+	// PLL setup
+	ret |= reg_write(client,REG_MT9P031_PLL_CTRL, 0x0051);
+	ret |= reg_write(client, REG_MT9P031_PLL_CONF1,
+		  (mt9p031_supported_formats[i].pll_m << 8) | 
(mt9p031_supported_formats[i].pll_n - 1));
+	ret |= reg_write(client, REG_MT9P031_PLL_CONF2, 
mt9p031_supported_formats[i].pll_p1 - 1);
+	ret |= reg_write(client,REG_MT9P031_PLL_CTRL, 0x0053);
+
+	ret |= reg_write(client, REG_MT9P031_OUT_CTRL, 
mt9p031_supported_formats[i].output_ctrl);
+	return ret;
+}
+
+static int mt9p031_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *fmt)
+{
+    struct v4l2_pix_format *pix = &fmt->fmt.pix;
+    struct mt9p031 *core = to_mt9p031(sd);
+    pix->width = core->width;
+    pix->height = core->height;
+    pix->pixelformat = V4L2_PIX_FMT_SBGGR16;
+    pix->field = V4L2_FIELD_NONE;
+    pix->bytesperline = 2 * core->width;
+    pix->sizeimage = 2 * core->width * core->height;
+    pix->colorspace = V4L2_COLORSPACE_SRGB;
+    return 0;
+}
+
+static int mt9p031_g_parm(struct v4l2_subdev *sd, struct 
v4l2_streamparm *parms)
+{
+    memcpy(parms, &g_temp_capture_params, sizeof(*parms));
+    return 0;
+}
+
+static int mt9p031_s_parm(struct v4l2_subdev *sd, struct 
v4l2_streamparm *parms)
+{
+    struct v4l2_captureparm *cp = &parms->parm.capture;
+
+    if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+        return -EINVAL;
+    if (cp->extendedmode != 0)
+        return -EINVAL;
+    memcpy(&g_temp_capture_params, parms, sizeof(*parms));
+    g_temp_capture_params.capability = V4L2_CAP_TIMEPERFRAME;
+    return 0;
+}
+
+static int mt9p031_s_stream(struct v4l2_subdev *sd, int enable)
+{
+    struct i2c_client *client = v4l2_get_subdevdata(sd);
+    int ret = 0;
+	if (enable) {
+        ret = reg_clear(client, REG_MT9P031_RESTART, 2);
+		if(ret < 0)
+			return ret;
+        mdelay(5);
+        ret = reg_write(client, REG_MT9P031_RESTART, 1);
+    }else {
+        ret = reg_set(client, REG_MT9P031_RESTART, 2);
+		if(ret < 0)
+			return ret;
+        mdelay(50);
+        ret = reg_set(client, REG_MT9P031_RESTART, 1);
+    }
+	return ret;
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int mt9p031_g_register(struct v4l2_subdev *sd,
+                              struct v4l2_dbg_register *reg)
+{
+    struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+    if (!v4l2_chip_match_i2c_client(client, &reg->match))
+        return -EINVAL;
+    if (!capable(CAP_SYS_ADMIN))
+        return -EPERM;
+    reg->val = reg_read(client, reg->reg & 0xff);
+    reg->size = 2;
+    return 0;
+}
+
+static int mt9p031_s_register(struct v4l2_subdev *sd,
+                              struct v4l2_dbg_register *reg)
+{
+    struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+    if (!v4l2_chip_match_i2c_client(client, &reg->match))
+        return -EINVAL;
+    if (!capable(CAP_SYS_ADMIN))
+        return -EPERM;
+    reg_write(client, reg->reg & 0xff, reg->val & 0xffff);
+    return 0;
+}
+#endif
+
+static int mt9p031_g_chip_ident(struct v4l2_subdev *sd,
+                                struct v4l2_dbg_chip_ident *chip)
+{
+    struct i2c_client *client = v4l2_get_subdevdata(sd);
+    u16 version = reg_read(client, REG_MT9P031_CHIP_VERSION);
+    return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_MT9P031, 
version);
+}
+
+static const struct v4l2_subdev_core_ops mt9p031_core_ops =
+{
+	.g_chip_ident = mt9p031_g_chip_ident,
+	.init = mt9p031_init,
+	.queryctrl = mt9p031_queryctrl,
+	.s_ctrl = mt9p031_s_ctrl,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register = mt9p031_g_register,
+	.s_register = mt9p031_s_register,
+#endif
+};
+
+static const struct v4l2_subdev_video_ops mt9p031_video_ops = {
+	.s_stream = mt9p031_s_stream,
+	.s_fmt = mt9p031_s_fmt,
+	.g_fmt = mt9p031_g_fmt,
+	.try_fmt = mt9p031_try_fmt,
+	.s_parm = mt9p031_s_parm,
+	.g_parm = mt9p031_g_parm,
+};
+
+static const struct v4l2_subdev_ops mt9p031_ops = {
+	.core = &mt9p031_core_ops,
+	.video = &mt9p031_video_ops,
+};
+
+static int mt9p031_detect(struct i2c_client *client, int *model)
+{
+    int ret, version;
+    dev_info(&client->dev, "entering %s\n", __FUNCTION__);
+    ret = reg_write(client, REG_MT9P031_OUT_CTRL, 
MT9P031_NORMAL_OPERATION_MODE);
+	if(ret < 0)
+		return ret;
+    mdelay(1);
+    version = reg_read(client, REG_MT9P031_CHIP_VERSION);
+    if (version != V4L2_IDENT_MT9P031)
+        return -EINVAL;
+    switch (version) {
+    case 6145:
+        *model = V4L2_IDENT_MT9P031;
+        break;
+    default:
+        dev_err(&client->dev,"No MT9P031 chip detected, register read 
%x\n", version);
+        return -ENODEV;
+    }
+    dev_info(&client->dev, "Detected a MT9P031 chip ID %x\n", version);
+    return 0;
+}
+
+
+static int mt9p031_probe(struct i2c_client *client, const struct 
i2c_device_id *id)
+{
+    int ret;
+    struct mt9p031 *decoder;
+    struct v4l2_subdev *sd;
+
+    dev_info(&client->dev, "entering %s\n", __FUNCTION__);
+    if (!i2c_check_functionality(client->adapter, 
I2C_FUNC_SMBUS_WORD_DATA))
+        return -EIO;
+    decoder = kzalloc(sizeof(*decoder), GFP_KERNEL);
+    if (!decoder)
+        return -ENOMEM;
+    ret = mt9p031_detect(client, &decoder->model);
+    if (ret)
+        goto clean;
+    ret = reg_write(client, REG_MT9P031_HEIGHT, 240);
+    if (ret < 0)
+        goto clean;
+    ret = reg_write(client, REG_MT9P031_WIDTH, 320);
+    if (ret < 0)
+        goto clean;
+
+    dev_info(&client->dev, "cont. %s\n", __FUNCTION__);
+    sd = &decoder->sd;
+    v4l2_i2c_subdev_init(sd, client, &mt9p031_ops);
+    ret = mt9p031_init(sd, 0);
+
+    v4l2_info(sd, "%s decoder driver registered\n", sd->name);
+    return 0;
+clean:
+    kfree(decoder);
+    return ret;
+}
+
+
+static int mt9p031_remove(struct i2c_client *client)
+{
+	int ret;
+    struct v4l2_subdev *sd = i2c_get_clientdata(client);
+    struct mt9p031 *decoder = to_mt9p031(sd);
+    ret = reg_write(client, REG_MT9P031_OUT_CTRL, 
MT9P031_NORMAL_OPERATION_MODE);
+    sd = i2c_get_clientdata(client);
+    ret |= reg_write(client, REG_MT9P031_OUT_CTRL, 
MT9P031_OUTPUT_CTRL_CHIP_UNSELECT);
+    v4l2_device_unregister_subdev(sd);
+    kfree(decoder);
+    return ret;
+}
+
+
+static const struct i2c_device_id mt9p031_id[] =
+{
+    {"mt9p031", 0},
+    {},
+};
+
+MODULE_DEVICE_TABLE(i2c, mt9p031_id);
+
+static struct i2c_driver mt9p031_driver =
+{
+    .driver = {
+        .owner = THIS_MODULE,
+        .name = MT9P031_MODULE_NAME,
+    },
+    .probe = mt9p031_probe,
+	.remove = mt9p031_remove,
+	.id_table = mt9p031_id,
+};
+
+static int __init mt9p031_module_init(void)
+{
+    return i2c_add_driver(&mt9p031_driver);
+}
+
+static void __exit mt9p031_exit(void)
+{
+    i2c_del_driver(&mt9p031_driver);
+}
+
+module_init(mt9p031_module_init);
+module_exit(mt9p031_exit);
+
diff --git a/drivers/mfd/dm355evm_msp.c b/drivers/mfd/dm355evm_msp.c
index 3d4a861..341b685 100644
--- a/drivers/mfd/dm355evm_msp.c
+++ b/drivers/mfd/dm355evm_msp.c
@@ -56,7 +56,9 @@
  #define msp_has_tvp()		false
  #endif

-
+static int msp_use_soc_camera=1;
+module_param(msp_use_soc_camera,bool, S_IRUGO);
+MODULE_PARM_DESC(msp_use_soc_camera, "initially selects tvp541x(0) or a 
sensor(1)");
  /*----------------------------------------------------------------------*/

  /* REVISIT for paranoia's sake, retry reads/writes on error */
@@ -368,8 +370,8 @@ static int
  dm355evm_msp_probe(struct i2c_client *client, const struct 
i2c_device_id *id)
  {
  	int		status;
-	const char	*video = msp_has_tvp() ? "TVP5146" : "imager";
-
+//	const char	*video = msp_has_tvp() ? "TVP5146" : "imager";
+	const char	*video = msp_use_soc_camera == 0 ? "TVP5146" : "imager";
  	if (msp430)
  		return -EBUSY;
  	msp430 = client;
@@ -382,7 +384,9 @@ dm355evm_msp_probe(struct i2c_client *client, const 
struct i2c_device_id *id)
  			status, video);

  	/* mux video input:  either tvp5146 or some external imager */
-	status = dm355evm_msp_write(msp_has_tvp() ? 0 : MSP_VIDEO_IMAGER,
+//	status = dm355evm_msp_write(msp_has_tvp() ? 0 : MSP_VIDEO_IMAGER,
+//			DM355EVM_MSP_VIDEO_IN);
+	status = dm355evm_msp_write(msp_use_soc_camera ?  MSP_VIDEO_IMAGER : 0,
  			DM355EVM_MSP_VIDEO_IN);
  	if (status < 0)
  		dev_warn(&client->dev, "error %d muxing %s as video-in\n",
diff --git a/include/media/davinci/vpfe_capture.h 
b/include/media/davinci/vpfe_capture.h
index 785157c..cdea6ac 100644
--- a/include/media/davinci/vpfe_capture.h
+++ b/include/media/davinci/vpfe_capture.h
@@ -68,6 +68,7 @@ enum vpfe_subdev_id {
  	VPFE_SUBDEV_TVP5146 = 1,
  	VPFE_SUBDEV_MT9T031 = 2,
  	VPFE_SUBDEV_TVP7002 = 3,
+	VPFE_SUBDEV_MT9P031 = 4,
  };

  struct vpfe_subdev_info {
diff --git a/include/media/v4l2-chip-ident.h 
b/include/media/v4l2-chip-ident.h
index 688b7ed..42ac2de 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -174,6 +174,9 @@ enum {
  	/* module mt9v011, just ident 8243 */
  	V4L2_IDENT_MT9V011 = 8243,

+	/* module mt9p031, just ident 6145 */
+	V4L2_IDENT_MT9P031 = 6145,
+
  	/* module tw9910: just ident 9910 */
  	V4L2_IDENT_TW9910 = 9910,

-- 
1.7.2.2

