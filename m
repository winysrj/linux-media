Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40731 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731268AbeKVOaF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 09:30:05 -0500
Received: by mail-pl1-f196.google.com with SMTP id b22-v6so8414391pls.7
        for <linux-media@vger.kernel.org>; Wed, 21 Nov 2018 19:52:36 -0800 (PST)
From: Matt Ranostay <matt.ranostay@konsulko.com>
To: linux-media@vger.kernel.org
Cc: Matt Ranostay <matt.ranostay@konsulko.com>,
        devicetree@vger.kernel.org
Subject: [PATCH v2 2/2] media: video-i2c: add Melexis MLX90640 thermal camera support
Date: Wed, 21 Nov 2018 19:52:29 -0800
Message-Id: <20181122035229.3630-3-matt.ranostay@konsulko.com>
In-Reply-To: <20181122035229.3630-1-matt.ranostay@konsulko.com>
References: <20181122035229.3630-1-matt.ranostay@konsulko.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add initial support for MLX90640 thermal cameras which output an 32x24
greyscale pixel image along with 2 rows of coefficent data.

Because of this the data outputed is really 32x26 and needs the two rows
removed after using the coefficent information to generate processed
images in userspace.

Cc: devicetree@vger.kernel.org
Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
---
 .../bindings/media/i2c/melexis,mlx90640.txt   |  20 ++++
 drivers/media/i2c/Kconfig                     |   1 +
 drivers/media/i2c/video-i2c.c                 | 110 +++++++++++++++++-
 3 files changed, 130 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt b/Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt
new file mode 100644
index 000000000000..060d2b7a5893
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt
@@ -0,0 +1,20 @@
+* Melexis MLX90640 FIR Sensor
+
+Melexis MLX90640 FIR sensor support which allows recording of thermal data
+with 32x24 resolution excluding 2 lines of coefficient data that is used by
+userspace to render processed frames.
+
+Required Properties:
+ - compatible : Must be "melexis,mlx90640"
+ - reg : i2c address of the device
+
+Example:
+
+	i2c0@1c22000 {
+		...
+		mlx90640@33 {
+			compatible = "melexis,mlx90640";
+			reg = <0x33>;
+		};
+		...
+	};
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 66bbbec487ec..24342f283f2a 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -1097,6 +1097,7 @@ config VIDEO_I2C
 	  Enable the I2C transport video support which supports the
 	  following:
 	   * Panasonic AMG88xx Grid-Eye Sensors
+	   * Melexis MLX90640 Thermal Cameras
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called video-i2c
diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index a64e1a725a20..d58f40334e8b 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -6,6 +6,7 @@
  *
  * Supported:
  * - Panasonic AMG88xx Grid-Eye Sensors
+ * - Melexis MLX90640 Thermal Cameras
  */
 
 #include <linux/delay.h>
@@ -18,6 +19,7 @@
 #include <linux/mutex.h>
 #include <linux/of_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/nvmem-provider.h>
 #include <linux/regmap.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -66,12 +68,26 @@ static const struct v4l2_frmsize_discrete amg88xx_size = {
 	.height = 8,
 };
 
+static const struct v4l2_fmtdesc mlx90640_format = {
+	.pixelformat = V4L2_PIX_FMT_Y16_BE,
+};
+
+static const struct v4l2_frmsize_discrete mlx90640_size = {
+	.width = 32,
+	.height = 26, /* 24 lines of pixel data + 2 lines of processing data */
+};
+
 static const struct regmap_config amg88xx_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.max_register = 0xff
 };
 
+static const struct regmap_config mlx90640_regmap_config = {
+	.reg_bits = 16,
+	.val_bits = 16,
+};
+
 struct video_i2c_chip {
 	/* video dimensions */
 	const struct v4l2_fmtdesc *format;
@@ -88,6 +104,7 @@ struct video_i2c_chip {
 	unsigned int bpp;
 
 	const struct regmap_config *regmap_config;
+	struct nvmem_config *nvmem_config;
 
 	/* setup function */
 	int (*setup)(struct video_i2c_data *data);
@@ -102,6 +119,22 @@ struct video_i2c_chip {
 	int (*hwmon_init)(struct video_i2c_data *data);
 };
 
+static int mlx90640_nvram_read(void *priv, unsigned int offset, void *val,
+			     size_t bytes)
+{
+	struct video_i2c_data *data = priv;
+
+	return regmap_bulk_read(data->regmap, 0x2400 + offset, val, bytes);
+}
+
+static struct nvmem_config mlx90640_nvram_config = {
+	.name = "mlx90640_nvram",
+	.word_size = 2,
+	.stride = 1,
+	.size = 1664,
+	.reg_read = mlx90640_nvram_read,
+};
+
 /* Power control register */
 #define AMG88XX_REG_PCTL	0x00
 #define AMG88XX_PCTL_NORMAL		0x00
@@ -122,12 +155,23 @@ struct video_i2c_chip {
 /* Temperature register */
 #define AMG88XX_REG_T01L	0x80
 
+/* Control register */
+#define MLX90640_REG_CTL1		0x800d
+#define MLX90640_REG_CTL1_MASK		0x0380
+#define MLX90640_REG_CTL1_MASK_SHIFT	7
+
 static int amg88xx_xfer(struct video_i2c_data *data, char *buf)
 {
 	return regmap_bulk_read(data->regmap, AMG88XX_REG_T01L, buf,
 				data->chip->buffer_size);
 }
 
+static int mlx90640_xfer(struct video_i2c_data *data, char *buf)
+{
+	return regmap_bulk_read(data->regmap, 0x400, buf,
+				data->chip->buffer_size);
+}
+
 static int amg88xx_setup(struct video_i2c_data *data)
 {
 	unsigned int mask = AMG88XX_FPSC_1FPS;
@@ -141,6 +185,27 @@ static int amg88xx_setup(struct video_i2c_data *data)
 	return regmap_update_bits(data->regmap, AMG88XX_REG_FPSC, mask, val);
 }
 
+static int mlx90640_setup(struct video_i2c_data *data)
+{
+	unsigned int n, idx;
+
+	for (n = 0; n < data->chip->num_frame_intervals - 1; n++) {
+		if (data->frame_interval.numerator
+				!= data->chip->frame_intervals[n].numerator)
+			continue;
+
+		if (data->frame_interval.denominator
+				== data->chip->frame_intervals[n].denominator)
+			break;
+	}
+
+	idx = data->chip->num_frame_intervals - n - 1;
+
+	return regmap_update_bits(data->regmap, MLX90640_REG_CTL1,
+				  MLX90640_REG_CTL1_MASK,
+				  idx << MLX90640_REG_CTL1_MASK_SHIFT);
+}
+
 static int amg88xx_set_power_on(struct video_i2c_data *data)
 {
 	int ret;
@@ -274,13 +339,27 @@ static int amg88xx_hwmon_init(struct video_i2c_data *data)
 #define	amg88xx_hwmon_init	NULL
 #endif
 
-#define AMG88XX		0
+enum {
+	AMG88XX,
+	MLX90640,
+};
 
 static const struct v4l2_fract amg88xx_frame_intervals[] = {
 	{ 1, 10 },
 	{ 1, 1 },
 };
 
+static const struct v4l2_fract mlx90640_frame_intervals[] = {
+	{ 1, 64 },
+	{ 1, 32 },
+	{ 1, 16 },
+	{ 1, 8 },
+	{ 1, 4 },
+	{ 1, 2 },
+	{ 1, 1 },
+	{ 2, 1 },
+};
+
 static const struct video_i2c_chip video_i2c_chip[] = {
 	[AMG88XX] = {
 		.size		= &amg88xx_size,
@@ -295,6 +374,18 @@ static const struct video_i2c_chip video_i2c_chip[] = {
 		.set_power	= amg88xx_set_power,
 		.hwmon_init	= amg88xx_hwmon_init,
 	},
+	[MLX90640] = {
+		.size		= &mlx90640_size,
+		.format		= &mlx90640_format,
+		.frame_intervals	= mlx90640_frame_intervals,
+		.num_frame_intervals	= ARRAY_SIZE(mlx90640_frame_intervals),
+		.buffer_size	= 1664,
+		.bpp		= 16,
+		.regmap_config	= &mlx90640_regmap_config,
+		.nvmem_config	= &mlx90640_nvram_config,
+		.setup		= mlx90640_setup,
+		.xfer		= mlx90640_xfer,
+	},
 };
 
 static const struct v4l2_file_operations video_i2c_fops = {
@@ -756,6 +847,21 @@ static int video_i2c_probe(struct i2c_client *client,
 		}
 	}
 
+	if (data->chip->nvmem_config) {
+		struct nvmem_config *config = data->chip->nvmem_config;
+		struct nvmem_device *device;
+
+		config->priv = data;
+		config->dev = &client->dev;
+
+		device = devm_nvmem_register(&client->dev, config);
+
+		if (IS_ERR(device)) {
+			dev_warn(&client->dev,
+				 "failed to register nvmem device\n");
+		}
+	}
+
 	ret = video_register_device(&data->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret < 0)
 		goto error_pm_disable;
@@ -834,12 +940,14 @@ static const struct dev_pm_ops video_i2c_pm_ops = {
 
 static const struct i2c_device_id video_i2c_id_table[] = {
 	{ "amg88xx", AMG88XX },
+	{ "mlx90640", MLX90640 },
 	{}
 };
 MODULE_DEVICE_TABLE(i2c, video_i2c_id_table);
 
 static const struct of_device_id video_i2c_of_match[] = {
 	{ .compatible = "panasonic,amg88xx", .data = &video_i2c_chip[AMG88XX] },
+	{ .compatible = "melexis,mlx90640", .data = &video_i2c_chip[MLX90640] },
 	{}
 };
 MODULE_DEVICE_TABLE(of, video_i2c_of_match);
-- 
2.17.1
