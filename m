Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:34380 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaHAOEs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 10:04:48 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so4357559wes.0
        for <linux-media@vger.kernel.org>; Fri, 01 Aug 2014 07:04:44 -0700 (PDT)
From: jean-michel.hautbois@vodalys.com
To: linux-media@vger.kernel.org
Cc: jhautbois@gmail.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH] Add support for LMH0395
Date: Fri,  1 Aug 2014 16:04:37 +0200
Message-Id: <1406901877-18329-1-git-send-email-jean-michel.hautbois@vodalys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>

This device is a SPI based device from TI.
It is a 3 Gbps HD/SD SDI Dual Output Low Power
Extended Reach Adaptive Cable Equalizer.

Add routing support in order to select output
LMH0395 enables the use of up to two outputs.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 .../devicetree/bindings/media/spi/lmh0395.txt      |  24 ++
 drivers/media/Kconfig                              |   1 +
 drivers/media/Makefile                             |   2 +-
 drivers/media/spi/Kconfig                          |  14 ++
 drivers/media/spi/Makefile                         |   1 +
 drivers/media/spi/lmh0395.c                        | 256 +++++++++++++++++++++
 6 files changed, 297 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/media/spi/lmh0395.txt
 create mode 100644 drivers/media/spi/Kconfig
 create mode 100644 drivers/media/spi/Makefile
 create mode 100644 drivers/media/spi/lmh0395.c

diff --git a/Documentation/devicetree/bindings/media/spi/lmh0395.txt b/Documentation/devicetree/bindings/media/spi/lmh0395.txt
new file mode 100644
index 0000000..d55c4eb
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/spi/lmh0395.txt
@@ -0,0 +1,24 @@
+* Texas Instruments lmh0395 3G HD/SD SDI equalizer
+
+The LMH0395 3 Gbps HD/SD SDI Dual Output Low Power Extended Reach Adaptive
+Cable Equalizer is designed to equalize data transmitted over cable (or any
+media with similar dispersive loss characteristics).
+The equalizer operates over a wide range of data rates from 125 Mbps to 2.97 Gbps
+and supports SMPTE 424M, SMPTE 292M, SMPTE344M, SMPTE 259M, and DVB-ASI standards.
+
+Required Properties :
+- compatible: Must be "ti,lmh0395"
+
+Example:
+
+ecspi@02010000 {
+	...
+	...
+
+	lmh0395@1 {
+		compatible = "ti,lmh0395";
+		reg = <1>;
+		spi-max-frequency = <20000000>;
+	};
+	...
+};
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 1d0758a..ce193b0 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -199,6 +199,7 @@ config MEDIA_ATTACH
 	default MODULES
 
 source "drivers/media/i2c/Kconfig"
+source "drivers/media/spi/Kconfig"
 source "drivers/media/tuners/Kconfig"
 source "drivers/media/dvb-frontends/Kconfig"
 
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 620f275..7578bcd 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -28,6 +28,6 @@ obj-y += rc/
 # Finally, merge the drivers that require the core
 #
 
-obj-y += common/ platform/ pci/ usb/ mmc/ firewire/ parport/
+obj-y += common/ platform/ pci/ usb/ mmc/ firewire/ parport/ spi/
 obj-$(CONFIG_VIDEO_DEV) += radio/
 
diff --git a/drivers/media/spi/Kconfig b/drivers/media/spi/Kconfig
new file mode 100644
index 0000000..291e7ea
--- /dev/null
+++ b/drivers/media/spi/Kconfig
@@ -0,0 +1,14 @@
+if VIDEO_V4L2
+
+config VIDEO_LMH0395
+	tristate "LMH0395 equalizer"
+	depends on VIDEO_V4L2 && SPI && MEDIA_CONTROLLER
+	---help---
+	  Support for TI LMH0395 3G HD/SD SDI Dual Output Low Power
+	  Extended Reach Adaptive Cable Equalizer.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called lmh0395.
+
+
+endif
diff --git a/drivers/media/spi/Makefile b/drivers/media/spi/Makefile
new file mode 100644
index 0000000..6c587e5
--- /dev/null
+++ b/drivers/media/spi/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_LMH0395)	+= lmh0395.o
diff --git a/drivers/media/spi/lmh0395.c b/drivers/media/spi/lmh0395.c
new file mode 100644
index 0000000..e287725
--- /dev/null
+++ b/drivers/media/spi/lmh0395.c
@@ -0,0 +1,256 @@
+/*
+ * LMH0395 SPI driver.
+ * Copyright (C) 2014  Jean-Michel Hautbois
+ *
+ * 3G HD/SD SDI Dual Output Low Power Extended Reach Adaptive Cable Equalizer
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/ioctl.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/spi/spi.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "debug level (0-1)");
+
+#define	LMH0395_SPI_CMD_WRITE	0x00
+#define	LMH0395_SPI_CMD_READ	0x80
+
+/* Registers of LMH0395 */
+#define LMH0395_GENERAL_CTRL		0x00
+#define LMH0395_OUTPUT_DRIVER		0x01
+#define LMH0395_LAUNCH_AMP_CTRL		0x02
+#define LMH0395_MUTE_REF		0x03
+#define LMH0395_DEVICE_ID		0x04
+#define	LMH0395_RATE_INDICATOR		0x05
+#define	LMH0395_CABLE_LENGTH_INDICATOR	0x06
+#define	LMH0395_LAUNCH_AMP_INDICATION	0x07
+
+/* This is a one input, dual output device */
+#define LMH0395_SDI_INPUT	0
+#define LMH0395_SDI_OUT0	1
+#define LMH0395_SDI_OUT1	2
+
+#define LMH0395_PADS_NUM	3
+
+/* Register LMH0395_MUTE_REF bits [7:6] */
+enum lmh0395_output_type {
+	LMH0395_OUTPUT_TYPE_NONE,
+	LMH0395_OUTPUT_TYPE_SDO0,
+	LMH0395_OUTPUT_TYPE_SDO1,
+	LMH0395_OUTPUT_TYPE_BOTH
+};
+
+static const char * const output_strs[] = {
+	"No Output Driver",
+	"Output Driver 0",
+	"Output Driver 1",
+	"Output Driver 0+1",
+};
+
+
+/* spi implementation */
+
+static int lmh0395_spi_write(struct spi_device *spi, u8 reg, u8 data)
+{
+	int err = 0;
+	u8 cmd[2];
+
+	cmd[0] = LMH0395_SPI_CMD_WRITE | reg;
+	cmd[1] = data;
+
+	err = spi_write(spi, cmd, 2);
+	if (err < 0) {
+		dev_err(&spi->dev, "SPI failed to select reg\n");
+		return err;
+	}
+
+	return err;
+}
+
+static int lmh0395_spi_read(struct spi_device *spi, u8 reg, u8 *data)
+{
+	int err = 0;
+	u8 cmd[2];
+	u8 read_data[2];
+
+	cmd[0] = LMH0395_SPI_CMD_READ | reg;
+	cmd[1] = 0xFF;
+
+	err = spi_write(spi, cmd, 2);
+	if (err < 0) {
+		dev_err(&spi->dev, "SPI failed to select reg\n");
+		return err;
+	}
+
+	err = spi_read(spi, read_data, 2);
+	if (err < 0) {
+		dev_err(&spi->dev, "SPI failed to read reg\n");
+		return err;
+	}
+	/* The first 8 bits is the adress used, drop it */
+	*data = read_data[1];
+
+	return err;
+}
+
+struct lmh0395_state {
+	struct v4l2_subdev sd;
+	struct media_pad pads[LMH0395_PADS_NUM];
+	enum lmh0395_output_type output_type;
+};
+
+static inline struct lmh0395_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct lmh0395_state, sd);
+}
+
+static int lmh0395_set_output_type(struct v4l2_subdev *sd, u32 output)
+{
+	struct lmh0395_state *state = to_state(sd);
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	u8 muteref_reg;
+
+	switch (output) {
+	case LMH0395_OUTPUT_TYPE_SDO0:
+		lmh0395_spi_read(spi, LMH0395_MUTE_REF, &muteref_reg);
+		muteref_reg |= 0x01 << 6;
+		break;
+	case LMH0395_OUTPUT_TYPE_SDO1:
+		lmh0395_spi_read(spi, LMH0395_MUTE_REF, &muteref_reg);
+		muteref_reg |= 0x10 << 6;
+		break;
+	case LMH0395_OUTPUT_TYPE_BOTH:
+		lmh0395_spi_read(spi, LMH0395_MUTE_REF, &muteref_reg);
+		muteref_reg |= 0x11 << 6;
+		break;
+	case LMH0395_OUTPUT_TYPE_NONE:
+		lmh0395_spi_read(spi, LMH0395_MUTE_REF, &muteref_reg);
+		muteref_reg |= 0x0 << 6;
+		break;
+	default:
+		return -EINVAL;
+	}
+	v4l2_info(sd, "Selecting %s output type\n", output_strs[output]);
+
+	lmh0395_spi_write(spi, LMH0395_MUTE_REF, muteref_reg);
+	state->output_type = output;
+	return 0;
+
+}
+
+static int lmh0395_s_routing(struct v4l2_subdev *sd, u32 input, u32 output,
+				u32 config)
+{
+	struct lmh0395_state *state = to_state(sd);
+	int err = 0;
+
+	if (state->output_type != output)
+		err = lmh0395_set_output_type(sd, output);
+
+	return err;
+}
+
+static const struct v4l2_subdev_video_ops lmh0395_video_ops = {
+	.s_routing = lmh0395_s_routing,
+};
+
+static const struct v4l2_subdev_ops lmh0395_ops = {
+	.video = &lmh0395_video_ops,
+};
+
+static int lmh0395_probe(struct spi_device *spi)
+{
+	u8 device_id;
+	struct lmh0395_state *state;
+	struct v4l2_subdev *sd;
+	int err;
+
+	err = lmh0395_spi_read(spi, LMH0395_DEVICE_ID, &device_id);
+	if (err < 0)
+		return err;
+
+	dev_dbg(&spi->dev, "device_id 0x%x\n", device_id);
+
+	/* Now that the device is here, let's init V4L2 */
+	state = devm_kzalloc(&spi->dev, sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	sd = &state->sd;
+	v4l2_spi_subdev_init(sd, spi, &lmh0395_ops);
+	state->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	state->pads[LMH0395_SDI_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[LMH0395_SDI_OUT0].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[LMH0395_SDI_OUT1].flags = MEDIA_PAD_FL_SOURCE;
+	err = media_entity_init(&sd->entity, LMH0395_PADS_NUM, &state->pads, 0);
+	if (err)
+		return err;
+
+	err = v4l2_async_register_subdev(sd);
+	if (err < 0)
+		media_entity_cleanup(&sd->entity);
+
+	v4l2_dbg(1, debug, sd, "Configuring equalizer\n");
+	lmh0395_set_output_type(sd, LMH0395_OUTPUT_TYPE_BOTH);
+	dev_info(&spi->dev, "driver registered\n");
+
+	return 0;
+}
+
+static int lmh0395_remove(struct spi_device *spi)
+{
+	struct v4l2_subdev *sd = spi_get_drvdata(spi);
+
+	v4l2_async_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	return 0;
+}
+
+static const struct spi_device_id lmh0395_id[] = {
+	{ "lmh0395", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, lmh0395_id);
+
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id lmh0395_of_match[] = {
+	{.compatible = "ti,lmh0395", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, lmh0395_of_match);
+#endif
+
+static struct spi_driver lmh0395_driver = {
+	.driver = {
+		.of_match_table = of_match_ptr(lmh0395_of_match),
+		.name = "lmh0395",
+		.owner = THIS_MODULE,
+	},
+	.probe = lmh0395_probe,
+	.remove = lmh0395_remove,
+	.id_table = lmh0395_id,
+};
+
+module_spi_driver(lmh0395_driver);
+
+MODULE_DESCRIPTION("spi device driver for LMH0395 equalizer");
+MODULE_AUTHOR("Jean-Michel Hautbois");
+MODULE_LICENSE("GPL");
-- 
2.0.0

