Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35318 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbcBHLUn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2016 06:20:43 -0500
From: Jean-Michel Hautbois <jhautbois@gmail.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: jslaby@suse.com, joe@perches.com, kvalo@codeaurora.org,
	davem@davemloft.net, gregkh@linuxfoundation.org,
	akpm@linux-foundation.org, mchehab@osg.samsung.com,
	galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
	mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
	laurent.pinchart@ideasonboard.com,
	Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Subject: [PATCH v6] media: spi: Add support for LMH0395
Date: Mon,  8 Feb 2016 12:20:24 +0100
Message-Id: <1454930424-6030-1-git-send-email-jean-michel.hautbois@veo-labs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This device is a SPI based device from TI.
It is a 3 Gbps HD/SD SDI Dual Output Low Power
Extended Reach Adaptive Cable Equalizer.

LMH0395 enables the use of up to two outputs.
These can be configured using DT.
The name gives the spi bus, and the CS associated.
Example : lmh0395-1@spi2
LMH0395 is on bus SPI2 with CS number 1.

Controls should be accessible from userspace too.
This will have to be done later.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
---
v2: Add DT support
v3: Change the bit set/clear in output_type as disabled means 'set the bit'
v4: Clearer description of endpoints usage in Doc, and some init changes.
    Add a dependency on OF and don't test CONFIG_OF anymore.
v5: Change port description in Documentation
    Multiple ports : required #address-cells and #size-cells
    Alphabetical order for include files
    Simplify register set/clear
    Check device ID
    Implement log_status handler
v6: Take Laurent Pinchart remarks into account
    Correct register settings
    Use next generation MC

 .../devicetree/bindings/media/spi/lmh0395.txt      |  51 +++
 MAINTAINERS                                        |   6 +
 drivers/media/Kconfig                              |   1 +
 drivers/media/Makefile                             |   2 +-
 drivers/media/spi/Kconfig                          |  15 +
 drivers/media/spi/Makefile                         |   1 +
 drivers/media/spi/lmh0395.c                        | 477 +++++++++++++++++++++
 drivers/media/spi/lmh039x.h                        |  55 +++
 8 files changed, 607 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/media/spi/lmh0395.txt
 create mode 100644 drivers/media/spi/Kconfig
 create mode 100644 drivers/media/spi/Makefile
 create mode 100644 drivers/media/spi/lmh0395.c
 create mode 100644 drivers/media/spi/lmh039x.h

diff --git a/Documentation/devicetree/bindings/media/spi/lmh0395.txt b/Documentation/devicetree/bindings/media/spi/lmh0395.txt
new file mode 100644
index 0000000..5c6ab4a
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/spi/lmh0395.txt
@@ -0,0 +1,51 @@
+* Texas Instruments lmh0395 3G HD/SD SDI equalizer
+
+"The LMH0395 is an SDI equalizer designed to extend the reach of SDI signals
+transmitted over cable by equalizing the input signal and generating clean
+outputs. It has one differential input and two differential output that can be
+independently controlled."
+
+Required Properties :
+- compatible: Must be "ti,lmh0395"
+
+The device node must contain one 'port' child node per device input and output
+port, in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+The LMH0395 has three ports numbered as follows.
+
+  Port			LMH0395
+------------------------------------------------------------
+  SDI (SDI input)	0
+  SDO0 (SDI output 0)	1
+  SDO1 (SDI output 1)	2
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
+		ports {
+			port@0 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0>;
+				sdi0_in: endpoint {};
+			};
+			port@1 {
+				reg = <1>;
+				sdi0_out0: endpoint {};
+			};
+			port@2 {
+				reg = <2>;
+				/* endpoint not specified, disable output */
+			};
+		};
+	};
+	...
+};
diff --git a/MAINTAINERS b/MAINTAINERS
index 30aca4a..d155df5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10889,6 +10889,12 @@ S:	Maintained
 F:	sound/soc/codecs/lm49453*
 F:	sound/soc/codecs/isabelle*
 
+TI LMH0395 DRIVER
+M:	Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/spi/lmh039*
+
 TI LP855x BACKLIGHT DRIVER
 M:	Milo Kim <milo.kim@ti.com>
 S:	Maintained
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index a8518fb..4b38792 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -213,6 +213,7 @@ config MEDIA_ATTACH
 	default MODULES
 
 source "drivers/media/i2c/Kconfig"
+source "drivers/media/spi/Kconfig"
 source "drivers/media/tuners/Kconfig"
 source "drivers/media/dvb-frontends/Kconfig"
 
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index e608bbc..6a64e96 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -8,7 +8,7 @@ media-objs	:= media-device.o media-devnode.o media-entity.o
 # I2C drivers should come before other drivers, otherwise they'll fail
 # when compiled as builtin drivers
 #
-obj-y += i2c/ tuners/
+obj-y += i2c/ tuners/ spi/
 obj-$(CONFIG_DVB_CORE)  += dvb-frontends/
 
 #
diff --git a/drivers/media/spi/Kconfig b/drivers/media/spi/Kconfig
new file mode 100644
index 0000000..a9d06cb
--- /dev/null
+++ b/drivers/media/spi/Kconfig
@@ -0,0 +1,15 @@
+if VIDEO_V4L2
+
+config VIDEO_LMH0395
+	tristate "LMH0395 equalizer"
+	depends on VIDEO_V4L2 && SPI && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CONTROLLER && OF
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
index 0000000..bf6b52c
--- /dev/null
+++ b/drivers/media/spi/lmh0395.c
@@ -0,0 +1,477 @@
+/*
+ * LMH0395 SPI driver.
+ * Copyright (C) 2016  Jean-Michel Hautbois
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
+#include <linux/spi/spi.h>
+#include <linux/uaccess.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-of.h>
+#include "lmh039x.h"
+
+static const char * const lmh039x_output_strs[] = {
+	"No Output Driver",
+	"Output Driver 0",
+	"Output Driver 1",
+	"Output Driver 0+1",
+};
+
+/* spi implementation */
+
+static int lmh0395_spi_write(struct spi_device *spi, u8 reg, u8 data)
+{
+	int err;
+	u8 cmd[2];
+
+	cmd[0] = LMH0395_SPI_CMD_WRITE | reg;
+	cmd[1] = data;
+
+	err = spi_write(spi, cmd, 2);
+	if (err < 0) {
+		dev_err(&spi->dev, "SPI write failed : %d\n", err);
+		return err;
+	}
+
+	return err;
+}
+
+static int lmh0395_spi_read(struct spi_device *spi, u8 reg, unsigned long *data)
+{
+	int err;
+	u8 cmd[2];
+	u8 read_data[2];
+
+	cmd[0] = LMH0395_SPI_CMD_READ | reg;
+	cmd[1] = 0xff;
+
+	err = spi_write(spi, cmd, 2);
+	if (err < 0) {
+		dev_err(&spi->dev, "SPI failed to select reg : %d\n", err);
+		return err;
+	}
+
+	err = spi_read(spi, read_data, 2);
+	if (err < 0) {
+		dev_err(&spi->dev, "SPI failed to read reg : %d\n", err);
+		return err;
+	}
+	/* The first 8 bits is the address used, drop it */
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
+static bool lmh0395_carrier_detect(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	unsigned long reg;
+
+	lmh0395_spi_read(spi, LMH0395_GENERAL_CTRL, &reg);
+
+	if (reg & 0x80)
+		return true;
+	else
+		return false;
+}
+
+static int lmh0395_get_rate(struct v4l2_subdev *sd, u8 *rate)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	int err;
+	unsigned long ctrl;
+
+	if (!lmh0395_carrier_detect(sd))
+		return 0;
+
+	err = lmh0395_spi_read(spi, LMH0395_RATE_INDICATOR, &ctrl);
+	if (err < 0)
+		return err;
+
+	*rate = ctrl & 0x20;
+	dev_dbg(&spi->dev, "Rate : %s\n", (ctrl & 0x20) ? "3G/HD" : "SD");
+	return 0;
+}
+
+static int lmh0395_get_launch_amp(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	unsigned long reg;
+	int launch_amp;
+	int err;
+
+	err = lmh0395_spi_read(spi, LMH0395_LAUNCH_AMP_INDICATION, &reg);
+	if (err < 0)
+		return err;
+
+	launch_amp = ((reg & 0xfc) >> 2);
+	launch_amp = launch_amp - 32;
+
+	dev_dbg(&spi->dev, "Launch amplitude : %d\n", launch_amp);
+
+	return launch_amp;
+}
+
+static int lmh0395_get_cable_length(struct v4l2_subdev *sd, u8 rate)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	u8 length;
+	unsigned long cli;
+	int err;
+
+	err = lmh0395_spi_read(spi, LMH0395_CABLE_LENGTH_INDICATOR, &cli);
+	if (err < 0)
+		return err;
+
+	/* The cable length indicator (CLI) provides an indication of the
+	 * length of the cable attached to input. CLI is accessible via bits
+	 * [7:0] of SPI register 06h.
+	 * The 8-bit setting ranges in decimal value from 0 to 247
+	 * ("00000000" to "11110111" binary), corresponding to 0 to 400m of
+	 * Belden 1694A cable.
+	 * For 3G and HD input, CLI is 1.25m per step.
+	 * For SD input, CLI is 1.25m per step, less 20m, from 0 to 191 decimal
+	 * and 3.5m per step from 192 to 247 decimal.
+	 */
+
+	length = cli*5/4;
+	if (rate == 0) {
+		if (cli <= 191)
+			length -= 20;
+		else
+			length = ((191*5/4)-20) + ((cli-191)*7/2);
+
+	}
+	dev_dbg(&spi->dev, "Length estimated (BELDEN 1694A cables) : %dm\n",
+			length);
+	return length;
+}
+
+static int lmh0395_set_output_type(struct v4l2_subdev *sd, unsigned long output)
+{
+	struct lmh0395_state *state = to_state(sd);
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	unsigned long muteref_reg;
+
+	/* Get the current register status */
+	lmh0395_spi_read(spi, LMH0395_MUTE_REF, &muteref_reg);
+	switch (output) {
+	case LMH0395_OUTPUT_TYPE_SDO0:
+		clear_bit(6, &muteref_reg);
+		break;
+	case LMH0395_OUTPUT_TYPE_SDO1:
+		clear_bit(7, &muteref_reg);
+		break;
+	case LMH0395_OUTPUT_TYPE_BOTH:
+		clear_bit(6, &muteref_reg);
+		clear_bit(7, &muteref_reg);
+		break;
+	case LMH0395_OUTPUT_TYPE_NONE:
+		set_bit(6, &muteref_reg);
+		set_bit(7, &muteref_reg);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	state->output_type = output;
+	return 0;
+
+}
+
+static int lmh0395_get_control(struct v4l2_subdev *sd)
+{
+	int err;
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	unsigned long ctrl;
+	u8 rate = 0;
+
+	err = lmh0395_spi_read(spi, LMH0395_GENERAL_CTRL, &ctrl);
+	if (err < 0)
+		return err;
+
+	if (ctrl & 0x80) {
+		dev_dbg(&spi->dev, "Carrier detected\n");
+		lmh0395_get_rate(sd, &rate);
+		lmh0395_get_cable_length(sd, rate);
+		lmh0395_get_launch_amp(sd);
+	}
+	return 0;
+}
+
+static int lmh0395_get_output_status(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	unsigned long muteref_reg;
+
+	/* Get the current register status */
+	lmh0395_spi_read(spi, LMH0395_MUTE_REF, &muteref_reg);
+	dev_dbg(&spi->dev, "Output 0 is %s\n",
+			test_bit(7, &muteref_reg) ? "enabled" : "disabled");
+	dev_dbg(&spi->dev, "Output 1 is %s\n",
+			test_bit(6, &muteref_reg) ? "enabled" : "disabled");
+	return 0;
+}
+
+static int lmh0395_log_status(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+
+	dev_dbg(&spi->dev, "-----Chip status-----\n");
+	lmh0395_get_output_status(sd);
+	lmh0395_get_control(sd);
+
+	return 0;
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int lmh0395_g_register(struct v4l2_subdev *sd,
+					struct v4l2_dbg_register *reg)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	int err = 0;
+	unsigned long val;
+
+	reg->size = 1;
+	reg->val = 0;
+
+	/* Don't try to access over last register */
+	if (reg->reg > LMH0395_LAUNCH_AMP_INDICATION)
+		return 0;
+
+	err = lmh0395_spi_read(spi, reg->reg, &val);
+	if (!err)
+		reg->val = val;
+
+	return err;
+}
+static int lmh0395_s_register(struct v4l2_subdev *sd,
+					const struct v4l2_dbg_register *reg)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	int err = 0;
+
+	/* Don't try to access over last register */
+	if (reg->reg > LMH0395_LAUNCH_AMP_INDICATION)
+		return -EINVAL;
+
+	err = lmh0395_spi_write(spi, reg->reg, reg->val);
+
+	return err;
+}
+#endif
+
+static int lmh0395_s_routing(struct v4l2_subdev *sd, u32 input, u32 output,
+				u32 config)
+{
+	struct lmh0395_state *state = to_state(sd);
+
+	if (state->output_type == output)
+		return 0;
+
+	return lmh0395_set_output_type(sd, output);
+}
+
+static int lmh0395_registered(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+
+	dev_dbg(&spi->dev, "subdev registered\n");
+	lmh0395_set_output_type(sd, LMH0395_OUTPUT_TYPE_BOTH);
+
+	return 0;
+}
+
+static const struct v4l2_subdev_internal_ops lmh0395_internal_ops = {
+	.registered = lmh0395_registered,
+};
+
+static const struct v4l2_subdev_video_ops lmh0395_video_ops = {
+	.s_routing = lmh0395_s_routing,
+};
+
+static const struct v4l2_subdev_core_ops lmh0395_core_ops = {
+	.log_status = lmh0395_log_status,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register = lmh0395_g_register,
+	.s_register = lmh0395_s_register,
+#endif
+};
+
+static const struct v4l2_subdev_ops lmh0395_ops = {
+	.core = &lmh0395_core_ops,
+	.video = &lmh0395_video_ops,
+};
+
+struct lmh0395_dev {
+	unsigned long dev_id;
+	char *name;
+};
+
+static const struct lmh0395_dev lmh0395_dev[] = {
+	{
+		.dev_id = ID_LMH0384,
+		.name = "LMH0384",
+	},
+	{
+		.dev_id = ID_LMH0394,
+		.name = "LMH0394",
+	},
+	{
+		.dev_id = ID_LMH0395,
+		.name = "LMH0395",
+	},
+	{ /* sentinel */ },
+};
+
+static const struct spi_device_id lmh0395_id[] = {
+	{ "lmh0395", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, lmh0395_id);
+
+static const struct of_device_id lmh0395_of_match[] = {
+	{.compatible = "ti,lmh0395", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, lmh0395_of_match);
+
+static int lmh0395_probe(struct spi_device *spi)
+{
+	unsigned long device_id;
+	struct lmh0395_state *state;
+	struct v4l2_subdev *sd;
+	int err, i;
+	struct device_node *n = NULL;
+	struct of_endpoint ep;
+
+	err = lmh0395_spi_read(spi, LMH0395_DEVICE_ID, &device_id);
+	if (err < 0)
+		return err;
+
+	for (i = 0 ; i < ARRAY_SIZE(lmh0395_dev) ; i++) {
+		if (device_id == lmh0395_dev[i].dev_id)
+			break;
+	}
+	if (i == ARRAY_SIZE(lmh0395_dev)) {
+		dev_err(&spi->dev, "Device not supported (id = %08lx)\n",
+					device_id);
+		return -ENODEV;
+	}
+	dev_dbg(&spi->dev, "%s detected\n", lmh0395_dev[i].name);
+
+	/* Now that the device is here, let's init V4L2 */
+	state = devm_kzalloc(&spi->dev, sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	sd = &state->sd;
+
+	if (spi->dev.of_node) {
+		dev_dbg(&spi->dev, "Parsing DT configuration\n");
+		while ((n = of_graph_get_next_endpoint(spi->dev.of_node, n))
+								!= NULL) {
+			err = of_graph_parse_endpoint(n, &ep);
+			if (err < 0) {
+				dev_err(&spi->dev, "Could not parse endpoint: %d\n", err);
+				of_node_put(n);
+				return err;
+			}
+			dev_dbg(&spi->dev, "endpoint %d on port %d\n",
+						ep.id, ep.port);
+			of_node_put(n);
+		}
+	} else {
+		dev_dbg(&spi->dev, "No DT configuration\n");
+	}
+
+	v4l2_spi_subdev_init(sd, spi, &lmh0395_ops);
+	sd->internal_ops = &lmh0395_internal_ops;
+
+	snprintf(sd->name, sizeof(sd->name), "%s-%d@spi%d",
+		spi->dev.driver->name,
+		spi->chip_select,
+		spi->master->bus_num);
+	dev_dbg(&spi->dev, "%s named %s\n", lmh0395_dev[i].name, sd->name);
+
+	state->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	state->pads[LMH0395_SDI_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[LMH0395_SDI_OUT0].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[LMH0395_SDI_OUT1].flags = MEDIA_PAD_FL_SOURCE;
+
+	err = media_entity_pads_init(&sd->entity,
+				     LMH0395_PADS_NUM, state->pads);
+	if (err) {
+		dev_err(&spi->dev, "entity init failed\n");
+		spi_unregister_device(spi);
+		return err;
+	}
+
+	dev_dbg(&spi->dev, "Entity initialized\n");
+
+	err = v4l2_async_register_subdev(sd);
+	if (err < 0) {
+		media_entity_cleanup(&sd->entity);
+		spi_unregister_device(spi);
+		return err;
+	}
+
+	dev_dbg(&spi->dev, "device probed\n");
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
+	spi_unregister_device(spi);
+	return 0;
+}
+
+static struct spi_driver lmh0395_driver = {
+	.driver = {
+		.of_match_table = lmh0395_of_match,
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
diff --git a/drivers/media/spi/lmh039x.h b/drivers/media/spi/lmh039x.h
new file mode 100644
index 0000000..f3e35e4
--- /dev/null
+++ b/drivers/media/spi/lmh039x.h
@@ -0,0 +1,55 @@
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
+#ifndef _LMH039X_
+#define _LMH039X_
+
+#include <media/v4l2-device.h>
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
+#define ID_LMH0384		0x03
+#define ID_LMH0394		0x13
+#define ID_LMH0395		0x23
+
+/* Register LMH0395_MUTE_REF bits [7:6] */
+enum lmh0395_output_type {
+	LMH0395_OUTPUT_TYPE_NONE,
+	LMH0395_OUTPUT_TYPE_SDO0,
+	LMH0395_OUTPUT_TYPE_SDO1,
+	LMH0395_OUTPUT_TYPE_BOTH
+};
+
+#endif
-- 
2.7.0

