Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:22257
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754674Ab1IMGgg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 02:36:36 -0400
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>,
	<uclinux-dist-devel@blackfin.uclinux.org>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH 2/4] v4l2: add adv7183 decoder driver
Date: Tue, 13 Sep 2011 14:34:50 -0400
Message-ID: <1315938892-20243-2-git-send-email-scott.jiang.linux@gmail.com>
In-Reply-To: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

this driver is a v4l2 subdevice driver to support
Analog Devices ADV7183 SDTV video decoder

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/video/Kconfig        |   10 +
 drivers/media/video/Makefile       |    1 +
 drivers/media/video/adv7183.c      |  684 ++++++++++++++++++++++++++++++++++++
 drivers/media/video/adv7183_regs.h |  107 ++++++
 include/media/adv7183.h            |   47 +++
 include/media/v4l2-chip-ident.h    |    3 +
 6 files changed, 852 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/adv7183.c
 create mode 100644 drivers/media/video/adv7183_regs.h
 create mode 100644 include/media/adv7183.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f574dc0..af8ed6b 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -273,6 +273,16 @@ config VIDEO_ADV7180
 	  To compile this driver as a module, choose M here: the
 	  module will be called adv7180.
 
+config VIDEO_ADV7183
+	tristate "Analog Devices ADV7183 decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  V4l2 subdevice driver for the Analog Devices
+	  ADV7183 video decoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called adv7183.
+
 config VIDEO_BT819
 	tristate "BT819A VideoStream decoder"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 2723900..b0329ae 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_VIDEO_SAA7191) += saa7191.o
 obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
 obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
 obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o
+obj-$(CONFIG_VIDEO_ADV7183) += adv7183.o
 obj-$(CONFIG_VIDEO_ADV7343) += adv7343.o
 obj-$(CONFIG_VIDEO_VPX3220) += vpx3220.o
 obj-$(CONFIG_VIDEO_BT819) += bt819.o
diff --git a/drivers/media/video/adv7183.c b/drivers/media/video/adv7183.c
new file mode 100644
index 0000000..afcaf5d
--- /dev/null
+++ b/drivers/media/video/adv7183.c
@@ -0,0 +1,684 @@
+/*
+ * adv7183.c Analog Devices ADV7183 video decoder driver
+ *
+ * Copyright (c) 2011 Analog Devices Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
+#include <media/adv7183.h>
+#include "adv7183_regs.h"
+
+struct adv7183 {
+	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+
+	v4l2_std_id std; /* Current set standard */
+	u32 input;
+	u32 output;
+	unsigned reset_pin;
+	unsigned oe_pin;
+	struct v4l2_mbus_framefmt fmt;
+};
+
+/* EXAMPLES USING 27 MHz CLOCK
+ * Mode 1 CVBS Input (Composite Video on AIN5)
+ * All standards are supported through autodetect, 8-bit, 4:2:2, ITU-R BT.656 output on P15 to P8.
+ */
+static const unsigned char adv7183_init_regs[] = {
+	ADV7183_IN_CTRL, 0x04,           /* CVBS input on AIN5 */
+	ADV7183_DIGI_CLAMP_CTRL_1, 0x00, /* Slow down digital clamps */
+	ADV7183_SHAP_FILT_CTRL, 0x41,    /* Set CSFM to SH1 */
+	ADV7183_ADC_CTRL, 0x16,          /* Power down ADC 1 and ADC 2 */
+	ADV7183_CTI_DNR_CTRL_4, 0x04,    /* Set DNR threshold to 4 for flat response */
+	/* ADI recommended programming sequence */
+	ADV7183_ADI_CTRL, 0x80,
+	ADV7183_CTI_DNR_CTRL_4, 0x20,
+	0x52, 0x18,
+	0x58, 0xED,
+	0x77, 0xC5,
+	0x7C, 0x93,
+	0x7D, 0x00,
+	0xD0, 0x48,
+	0xD5, 0xA0,
+	0xD7, 0xEA,
+	ADV7183_SD_SATURATION_CR, 0x3E,
+	ADV7183_PAL_V_END, 0x3E,
+	ADV7183_PAL_F_TOGGLE, 0x0F,
+	ADV7183_ADI_CTRL, 0x00,
+};
+
+static inline struct adv7183 *to_adv7183(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct adv7183, sd);
+}
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct adv7183, hdl)->sd;
+}
+
+static inline int adv7183_read(struct v4l2_subdev *sd, unsigned char reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return i2c_smbus_read_byte_data(client, reg);
+}
+
+static inline int adv7183_write(struct v4l2_subdev *sd, unsigned char reg,
+				unsigned char value)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return i2c_smbus_write_byte_data(client, reg, value);
+}
+
+static int adv7183_writeregs(struct v4l2_subdev *sd,
+		const unsigned char *regs, unsigned int num)
+{
+	unsigned char reg, data;
+	unsigned int cnt = 0;
+
+	if (num & 0x1) {
+		v4l2_err(sd, "invalid regs array\n");
+		return -1;
+	}
+
+	while (cnt < num) {
+		reg = *regs++;
+		data = *regs++;
+		cnt += 2;
+
+		adv7183_write(sd, reg, data);
+	}
+	return 0;
+}
+
+static int adv7183_log_status(struct v4l2_subdev *sd)
+{
+	struct adv7183 *decoder = to_adv7183(sd);
+
+	v4l2_info(sd, "adv7183: Input control = 0x%02x\n",
+			adv7183_read(sd, ADV7183_IN_CTRL));
+	v4l2_info(sd, "adv7183: Video selection = 0x%02x\n",
+			adv7183_read(sd, ADV7183_VD_SEL));
+	v4l2_info(sd, "adv7183: Output control = 0x%02x\n",
+			adv7183_read(sd, ADV7183_OUT_CTRL));
+	v4l2_info(sd, "adv7183: Extended output control = 0x%02x\n",
+			adv7183_read(sd, ADV7183_EXT_OUT_CTRL));
+	v4l2_info(sd, "adv7183: Autodetect enable = 0x%02x\n",
+			adv7183_read(sd, ADV7183_AUTO_DET_EN));
+	v4l2_info(sd, "adv7183: Contrast = 0x%02x\n",
+			adv7183_read(sd, ADV7183_CONTRAST));
+	v4l2_info(sd, "adv7183: Brightness = 0x%02x\n",
+			adv7183_read(sd, ADV7183_BRIGHTNESS));
+	v4l2_info(sd, "adv7183: Hue = 0x%02x\n",
+			adv7183_read(sd, ADV7183_HUE));
+	v4l2_info(sd, "adv7183: Default value Y = 0x%02x\n",
+			adv7183_read(sd, ADV7183_DEF_Y));
+	v4l2_info(sd, "adv7183: Default value C = 0x%02x\n",
+			adv7183_read(sd, ADV7183_DEF_C));
+	v4l2_info(sd, "adv7183: ADI control = 0x%02x\n",
+			adv7183_read(sd, ADV7183_ADI_CTRL));
+	v4l2_info(sd, "adv7183: Power Management = 0x%02x\n",
+			adv7183_read(sd, ADV7183_POW_MANAGE));
+	v4l2_info(sd, "adv7183: Status 1 2 and 3 = 0x%02x 0x%02x 0x%02x\n",
+			adv7183_read(sd, ADV7183_STATUS_1),
+			adv7183_read(sd, ADV7183_STATUS_2),
+			adv7183_read(sd, ADV7183_STATUS_3));
+	v4l2_info(sd, "adv7183: Ident = 0x%02x\n",
+			adv7183_read(sd, ADV7183_IDENT));
+	v4l2_info(sd, "adv7183: Analog clamp control = 0x%02x\n",
+			adv7183_read(sd, ADV7183_ANAL_CLAMP_CTRL));
+	v4l2_info(sd, "adv7183: Digital clamp control 1 = 0x%02x\n",
+			adv7183_read(sd, ADV7183_DIGI_CLAMP_CTRL_1));
+	v4l2_info(sd, "adv7183: Shaping filter control 1 and 2 = 0x%02x 0x%02x\n",
+			adv7183_read(sd, ADV7183_SHAP_FILT_CTRL),
+			adv7183_read(sd, ADV7183_SHAP_FILT_CTRL_2));
+	v4l2_info(sd, "adv7183: Comb filter control = 0x%02x\n",
+			adv7183_read(sd, ADV7183_COMB_FILT_CTRL));
+	v4l2_info(sd, "adv7183: ADI control 2 = 0x%02x\n",
+			adv7183_read(sd, ADV7183_ADI_CTRL_2));
+	v4l2_info(sd, "adv7183: Pixel delay control = 0x%02x\n",
+			adv7183_read(sd, ADV7183_PIX_DELAY_CTRL));
+	v4l2_info(sd, "adv7183: Misc gain control = 0x%02x\n",
+			adv7183_read(sd, ADV7183_MISC_GAIN_CTRL));
+	v4l2_info(sd, "adv7183: AGC mode control = 0x%02x\n",
+			adv7183_read(sd, ADV7183_AGC_MODE_CTRL));
+	v4l2_info(sd, "adv7183: Chroma gain control 1 and 2 = 0x%02x 0x%02x\n",
+			adv7183_read(sd, ADV7183_CHRO_GAIN_CTRL_1),
+			adv7183_read(sd, ADV7183_CHRO_GAIN_CTRL_2));
+	v4l2_info(sd, "adv7183: Luma gain control 1 and 2 = 0x%02x 0x%02x\n",
+			adv7183_read(sd, ADV7183_LUMA_GAIN_CTRL_1),
+			adv7183_read(sd, ADV7183_LUMA_GAIN_CTRL_2));
+	v4l2_info(sd, "adv7183: Vsync field control 1 2 and 3 = 0x%02x 0x%02x 0x%02x\n",
+			adv7183_read(sd, ADV7183_VS_FIELD_CTRL_1),
+			adv7183_read(sd, ADV7183_VS_FIELD_CTRL_2),
+			adv7183_read(sd, ADV7183_VS_FIELD_CTRL_3));
+	v4l2_info(sd, "adv7183: Hsync positon control 1 2 and 3 = 0x%02x 0x%02x 0x%02x\n",
+			adv7183_read(sd, ADV7183_HS_POS_CTRL_1),
+			adv7183_read(sd, ADV7183_HS_POS_CTRL_2),
+			adv7183_read(sd, ADV7183_HS_POS_CTRL_3));
+	v4l2_info(sd, "adv7183: Polarity = 0x%02x\n",
+			adv7183_read(sd, ADV7183_POLARITY));
+	v4l2_info(sd, "adv7183: ADC control = 0x%02x\n",
+			adv7183_read(sd, ADV7183_ADC_CTRL));
+	v4l2_info(sd, "adv7183: SD offset Cb and Cr = 0x%02x 0x%02x\n",
+			adv7183_read(sd, ADV7183_SD_OFFSET_CB),
+			adv7183_read(sd, ADV7183_SD_OFFSET_CR));
+	v4l2_info(sd, "adv7183: SD saturation Cb and Cr = 0x%02x 0x%02x\n",
+			adv7183_read(sd, ADV7183_SD_SATURATION_CB),
+			adv7183_read(sd, ADV7183_SD_SATURATION_CR));
+	v4l2_info(sd, "adv7183: Drive strength = 0x%02x\n",
+			adv7183_read(sd, ADV7183_DRIVE_STR));
+	v4l2_ctrl_handler_log_status(&decoder->hdl, sd->name);
+	return 0;
+}
+
+static int adv7183_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	struct adv7183 *decoder = to_adv7183(sd);
+	int reg;
+
+	if (std == decoder->std)
+		return 0;
+	reg = adv7183_read(sd, ADV7183_IN_CTRL) & 0xF;
+	if (std == V4L2_STD_ALL)
+		adv7183_write(sd, ADV7183_IN_CTRL, reg);
+	else {
+		if (std == V4L2_STD_PAL_60)
+			reg |= 0x60;
+		else if (std == V4L2_STD_NTSC_443)
+			reg |= 0x70;
+		else if (std == V4L2_STD_PAL_N)
+			reg |= 0x90;
+		else if (std == V4L2_STD_PAL_M)
+			reg |= 0xA0;
+		else if (std == V4L2_STD_PAL_Nc)
+			reg |= 0xC0;
+		else if (std & V4L2_STD_PAL)
+			reg |= 0x80;
+		else if (std & V4L2_STD_NTSC)
+			reg |= 0x50;
+		else if (std & V4L2_STD_SECAM)
+			reg |= 0xE0;
+		else
+			return -EINVAL;
+		adv7183_write(sd, ADV7183_IN_CTRL, reg);
+	}
+
+	decoder->std = std;
+
+	return 0;
+}
+
+static int adv7183_reset(struct v4l2_subdev *sd, u32 val)
+{
+	int reg;
+
+	reg = adv7183_read(sd, ADV7183_POW_MANAGE) | 0x80;
+	adv7183_write(sd, ADV7183_POW_MANAGE, reg);
+	/* wait 5ms before any further i2c writes are performed */
+	usleep_range(5000, 10000);
+	return 0;
+}
+
+static int adv7183_s_routing(struct v4l2_subdev *sd,
+				u32 input, u32 output, u32 config)
+{
+	struct adv7183 *decoder = to_adv7183(sd);
+	int reg;
+
+	if ((input > ADV7183_COMPONENT1) || (output > ADV7183_16BIT_OUT))
+		return -EINVAL;
+
+	if (input != decoder->input) {
+		decoder->input = input;
+		reg = adv7183_read(sd, ADV7183_IN_CTRL) & 0xF0;
+		switch (input) {
+		case ADV7183_COMPOSITE1:
+			reg |= 0x1;
+			break;
+		case ADV7183_COMPOSITE2:
+			reg |= 0x2;
+			break;
+		case ADV7183_COMPOSITE3:
+			reg |= 0x3;
+			break;
+		case ADV7183_COMPOSITE4:
+			reg |= 0x4;
+			break;
+		case ADV7183_COMPOSITE5:
+			reg |= 0x5;
+			break;
+		case ADV7183_COMPOSITE6:
+			reg |= 0xB;
+			break;
+		case ADV7183_COMPOSITE7:
+			reg |= 0xC;
+			break;
+		case ADV7183_COMPOSITE8:
+			reg |= 0xD;
+			break;
+		case ADV7183_COMPOSITE9:
+			reg |= 0xE;
+			break;
+		case ADV7183_COMPOSITE10:
+			reg |= 0xF;
+			break;
+		case ADV7183_SVIDEO0:
+			reg |= 0x6;
+			break;
+		case ADV7183_SVIDEO1:
+			reg |= 0x7;
+			break;
+		case ADV7183_SVIDEO2:
+			reg |= 0x8;
+			break;
+		case ADV7183_COMPONENT0:
+			reg |= 0x9;
+			break;
+		case ADV7183_COMPONENT1:
+			reg |= 0xA;
+			break;
+		default:
+			break;
+		}
+		adv7183_write(sd, ADV7183_IN_CTRL, reg);
+	}
+
+	if (output != decoder->output) {
+		decoder->output = output;
+		reg = adv7183_read(sd, ADV7183_OUT_CTRL) & 0xC0;
+		switch (output) {
+		case ADV7183_16BIT_OUT:
+			reg |= 0x9;
+			break;
+		default:
+			reg |= 0xC;
+			break;
+		}
+		adv7183_write(sd, ADV7183_OUT_CTRL, reg);
+	}
+
+	return 0;
+}
+
+static int adv7183_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = to_sd(ctrl);
+	int val = ctrl->val;
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		if (val < 0)
+			val = 127 - val;
+		adv7183_write(sd, ADV7183_BRIGHTNESS, val);
+		break;
+	case V4L2_CID_CONTRAST:
+		adv7183_write(sd, ADV7183_CONTRAST, val);
+		break;
+	case V4L2_CID_SATURATION:
+		adv7183_write(sd, ADV7183_SD_SATURATION_CB, val >> 8);
+		adv7183_write(sd, ADV7183_SD_SATURATION_CR, (val & 0xFF));
+		break;
+	case V4L2_CID_HUE:
+		adv7183_write(sd, ADV7183_SD_OFFSET_CB, val >> 8);
+		adv7183_write(sd, ADV7183_SD_OFFSET_CR, (val & 0xFF));
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int adv7183_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
+{
+	struct adv7183 *decoder = to_adv7183(sd);
+	int reg;
+
+	if (decoder->std == V4L2_STD_ALL) {
+		reg = adv7183_read(sd, ADV7183_STATUS_1);
+		switch ((reg >> 0x4) & 0x7) {
+		case 0:
+			*std = V4L2_STD_NTSC;
+			break;
+		case 1:
+			*std = V4L2_STD_NTSC_443;
+			break;
+		case 2:
+			*std = V4L2_STD_PAL_M;
+			break;
+		case 3:
+			*std = V4L2_STD_PAL_60;
+			break;
+		case 4:
+			*std = V4L2_STD_PAL;
+			break;
+		case 5:
+			*std = V4L2_STD_SECAM;
+			break;
+		case 6:
+			*std = V4L2_STD_PAL_Nc;
+			break;
+		case 7:
+			*std = V4L2_STD_SECAM;
+			break;
+		default:
+			*std = V4L2_STD_UNKNOWN;
+			break;
+		}
+	} else
+		*std = decoder->std;
+	return 0;
+}
+
+static int adv7183_g_input_status(struct v4l2_subdev *sd, u32 *status)
+{
+	int reg;
+
+	*status = V4L2_IN_ST_NO_SIGNAL;
+	reg = adv7183_read(sd, ADV7183_STATUS_1);
+	if (reg < 0)
+		return reg;
+	else if (reg & 0x1)
+		*status = 0;
+	return 0;
+}
+
+static int adv7183_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
+				enum v4l2_mbus_pixelcode *code)
+{
+	if (index > 0)
+		return -EINVAL;
+
+	*code = V4L2_MBUS_FMT_UYVY8_2X8;
+	return 0;
+}
+
+static int adv7183_try_mbus_fmt(struct v4l2_subdev *sd,
+				struct v4l2_mbus_framefmt *fmt)
+{
+	v4l2_std_id std;
+
+	fmt->code = V4L2_MBUS_FMT_UYVY8_2X8;
+	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	adv7183_querystd(sd, &std);
+	if (std & V4L2_STD_525_60) {
+		fmt->field = V4L2_FIELD_SEQ_TB;
+		fmt->width = 720;
+		fmt->height = 480;
+	} else {
+		fmt->field = V4L2_FIELD_SEQ_BT;
+		fmt->width = 720;
+		fmt->height = 576;
+	}
+	return 0;
+}
+
+static int adv7183_s_mbus_fmt(struct v4l2_subdev *sd,
+				struct v4l2_mbus_framefmt *fmt)
+{
+	struct adv7183 *decoder = to_adv7183(sd);
+
+	adv7183_try_mbus_fmt(sd, fmt);
+	decoder->fmt = *fmt;
+	return 0;
+}
+
+static int adv7183_g_mbus_fmt(struct v4l2_subdev *sd,
+				struct v4l2_mbus_framefmt *fmt)
+{
+	struct adv7183 *decoder = to_adv7183(sd);
+
+	*fmt = decoder->fmt;
+	return 0;
+}
+
+static int adv7183_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct adv7183 *decoder = to_adv7183(sd);
+
+	if (enable)
+		gpio_direction_output(decoder->oe_pin, 0);
+	else
+		gpio_direction_output(decoder->oe_pin, 1);
+	udelay(1);
+	return 0;
+}
+
+static int adv7183_g_chip_ident(struct v4l2_subdev *sd,
+		struct v4l2_dbg_chip_ident *chip)
+{
+	int rev;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	/* 0x11 for adv7183, 0x13 for adv7183b */
+	rev = adv7183_read(sd, ADV7183_IDENT);
+
+	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_ADV7183, rev);
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int adv7183_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (!v4l2_chip_match_i2c_client(client, &reg->match))
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	reg->val = adv7183_read(sd, reg->reg & 0xff);
+	reg->size = 1;
+	return 0;
+}
+
+static int adv7183_s_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (!v4l2_chip_match_i2c_client(client, &reg->match))
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	adv7183_write(sd, reg->reg & 0xff, reg->val & 0xff);
+	return 0;
+}
+#endif
+
+static const struct v4l2_ctrl_ops adv7183_ctrl_ops = {
+	.s_ctrl = adv7183_s_ctrl,
+};
+
+static const struct v4l2_subdev_core_ops adv7183_core_ops = {
+	.log_status = adv7183_log_status,
+	.s_std = adv7183_s_std,
+	.reset = adv7183_reset,
+	.g_chip_ident = adv7183_g_chip_ident,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register = adv7183_g_register,
+	.s_register = adv7183_s_register,
+#endif
+};
+
+static const struct v4l2_subdev_video_ops adv7183_video_ops = {
+	.s_routing = adv7183_s_routing,
+	.querystd = adv7183_querystd,
+	.g_input_status = adv7183_g_input_status,
+	.enum_mbus_fmt = adv7183_enum_mbus_fmt,
+	.try_mbus_fmt = adv7183_try_mbus_fmt,
+	.s_mbus_fmt = adv7183_s_mbus_fmt,
+	.g_mbus_fmt = adv7183_g_mbus_fmt,
+	.s_stream = adv7183_s_stream,
+};
+
+static const struct v4l2_subdev_ops adv7183_ops = {
+	.core = &adv7183_core_ops,
+	.video = &adv7183_video_ops,
+};
+
+static int adv7183_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct adv7183 *decoder;
+	struct v4l2_subdev *sd;
+	struct v4l2_ctrl_handler *hdl;
+	int ret;
+	const unsigned *pin_array;
+
+	/* Check if the adapter supports the needed features */
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -EIO;
+
+	v4l_info(client, "chip found @ 0x%02x (%s)\n",
+			client->addr << 1, client->adapter->name);
+
+	pin_array = client->dev.platform_data;
+	if (pin_array == NULL)
+		return -EINVAL;
+
+	decoder = kzalloc(sizeof(struct adv7183), GFP_KERNEL);
+	if (decoder == NULL)
+		return -ENOMEM;
+
+	decoder->reset_pin = pin_array[0];
+	decoder->oe_pin = pin_array[1];
+
+	if (gpio_request(decoder->reset_pin, "ADV7183 Reset")) {
+		v4l_err(client, "failed to request GPIO %d\n", decoder->reset_pin);
+		ret = -EBUSY;
+		goto err_free_decoder;
+	}
+
+	if (gpio_request(decoder->oe_pin, "ADV7183 Output Enable")) {
+		v4l_err(client, "failed to request GPIO %d\n", decoder->oe_pin);
+		ret = -EBUSY;
+		goto err_free_reset;
+	}
+
+	sd = &decoder->sd;
+	v4l2_i2c_subdev_init(sd, client, &adv7183_ops);
+
+	hdl = &decoder->hdl;
+	v4l2_ctrl_handler_init(hdl, 4);
+	v4l2_ctrl_new_std(hdl, &adv7183_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, -128, 127, 1, 0);
+	v4l2_ctrl_new_std(hdl, &adv7183_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 0xFF, 1, 0x80);
+	v4l2_ctrl_new_std(hdl, &adv7183_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 0xFFFF, 1, 0x8080);
+	v4l2_ctrl_new_std(hdl, &adv7183_ctrl_ops,
+			V4L2_CID_HUE, 0, 0xFFFF, 1, 0x8080);
+	/* hook the control handler into the driver */
+	sd->ctrl_handler = hdl;
+	if (hdl->error) {
+		ret = hdl->error;
+
+		v4l2_ctrl_handler_free(hdl);
+		goto err_free_oe;
+	}
+
+	decoder->std = V4L2_STD_ALL; /* Default is autodetect */
+	decoder->input = ADV7183_COMPOSITE4;
+	decoder->output = ADV7183_8BIT_OUT;
+
+	gpio_direction_output(decoder->oe_pin, 1);
+	/* reset chip */
+	gpio_direction_output(decoder->reset_pin, 0);
+	/* reset pulse width at least 5ms */
+	mdelay(10);
+	gpio_direction_output(decoder->reset_pin, 1);
+	/* wait 5ms before any further i2c writes are performed */
+	mdelay(5);
+
+	adv7183_writeregs(sd, adv7183_init_regs, ARRAY_SIZE(adv7183_init_regs));
+
+	/* initialize the hardware to the default control values */
+	v4l2_ctrl_handler_setup(hdl);
+
+	return 0;
+err_free_oe:
+	gpio_free(decoder->oe_pin);
+err_free_reset:
+	gpio_free(decoder->reset_pin);
+err_free_decoder:
+	kfree(decoder);
+	return ret;
+}
+
+static int adv7183_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct adv7183 *decoder = to_adv7183(sd);
+
+	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
+	gpio_free(decoder->oe_pin);
+	gpio_free(decoder->reset_pin);
+	kfree(decoder);
+	return 0;
+}
+
+static const struct i2c_device_id adv7183_id[] = {
+	{"adv7183", 0},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, adv7183_id);
+
+static struct i2c_driver adv7183_driver = {
+	.driver = {
+		.owner  = THIS_MODULE,
+		.name   = "adv7183",
+	},
+	.probe          = adv7183_probe,
+	.remove         = __devexit_p(adv7183_remove),
+	.id_table       = adv7183_id,
+};
+
+static __init int adv7183_init(void)
+{
+	return i2c_add_driver(&adv7183_driver);
+}
+
+static __exit void adv7183_exit(void)
+{
+	i2c_del_driver(&adv7183_driver);
+}
+
+module_init(adv7183_init);
+module_exit(adv7183_exit);
+
+MODULE_DESCRIPTION("Analog Devices ADV7183 video decoder driver");
+MODULE_AUTHOR("Scott Jiang <Scott.Jiang.Linux@gmail.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/video/adv7183_regs.h b/drivers/media/video/adv7183_regs.h
new file mode 100644
index 0000000..c2378c8
--- /dev/null
+++ b/drivers/media/video/adv7183_regs.h
@@ -0,0 +1,107 @@
+/*
+ * adv7183 - Analog Devices ADV7183 video decoder registers
+ *
+ * Copyright (c) 2011 Analog Devices Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _ADV7183_REGS_H_
+#define _ADV7183_REGS_H_
+
+#define	ADV7183_IN_CTRL            0x00 /* Input control */
+#define ADV7183_VD_SEL             0x01 /* Video selection */
+#define ADV7183_OUT_CTRL           0x03 /* Output control */
+#define ADV7183_EXT_OUT_CTRL       0x04 /* Extended output control */
+#define ADV7183_AUTO_DET_EN        0x07 /* Autodetect enable */
+#define ADV7183_CONTRAST           0x08 /* Contrast */
+#define ADV7183_BRIGHTNESS         0x0A /* Brightness */
+#define ADV7183_HUE                0x0B /* Hue */
+#define ADV7183_DEF_Y              0x0C /* Default value Y */
+#define ADV7183_DEF_C              0x0D /* Default value C */
+#define ADV7183_ADI_CTRL           0x0E /* ADI control */
+#define ADV7183_POW_MANAGE         0x0F /* Power Management */
+#define ADV7183_STATUS_1           0x10 /* Status 1 */
+#define ADV7183_IDENT              0x11 /* Ident */
+#define ADV7183_STATUS_2           0x12 /* Status 2 */
+#define ADV7183_STATUS_3           0x13 /* Status 3 */
+#define ADV7183_ANAL_CLAMP_CTRL    0x14 /* Analog clamp control */
+#define ADV7183_DIGI_CLAMP_CTRL_1  0x15 /* Digital clamp control 1 */
+#define ADV7183_SHAP_FILT_CTRL     0x17 /* Shaping filter control */
+#define ADV7183_SHAP_FILT_CTRL_2   0x18 /* Shaping filter control 2 */
+#define ADV7183_COMB_FILT_CTRL     0x19 /* Comb filter control */
+#define ADV7183_ADI_CTRL_2         0x1D /* ADI control 2 */
+#define ADV7183_PIX_DELAY_CTRL     0x27 /* Pixel delay control */
+#define ADV7183_MISC_GAIN_CTRL     0x2B /* Misc gain control */
+#define ADV7183_AGC_MODE_CTRL      0x2C /* AGC mode control */
+#define ADV7183_CHRO_GAIN_CTRL_1   0x2D /* Chroma gain control 1 */
+#define ADV7183_CHRO_GAIN_CTRL_2   0x2E /* Chroma gain control 2 */
+#define ADV7183_LUMA_GAIN_CTRL_1   0x2F /* Luma gain control 1 */
+#define ADV7183_LUMA_GAIN_CTRL_2   0x30 /* Luma gain control 2 */
+#define ADV7183_VS_FIELD_CTRL_1    0x31 /* Vsync field control 1 */
+#define ADV7183_VS_FIELD_CTRL_2    0x32 /* Vsync field control 2 */
+#define ADV7183_VS_FIELD_CTRL_3    0x33 /* Vsync field control 3 */
+#define ADV7183_HS_POS_CTRL_1      0x34 /* Hsync positon control 1 */
+#define ADV7183_HS_POS_CTRL_2      0x35 /* Hsync positon control 2 */
+#define ADV7183_HS_POS_CTRL_3      0x36 /* Hsync positon control 3 */
+#define ADV7183_POLARITY           0x37 /* Polarity */
+#define ADV7183_NTSC_COMB_CTRL     0x38 /* NTSC comb control */
+#define ADV7183_PAL_COMB_CTRL      0x39 /* PAL comb control */
+#define ADV7183_ADC_CTRL           0x3A /* ADC control */
+#define ADV7183_MAN_WIN_CTRL       0x3D /* Manual window control */
+#define ADV7183_RESAMPLE_CTRL      0x41 /* Resample control */
+#define ADV7183_GEMSTAR_CTRL_1     0x48 /* Gemstar ctrl 1 */
+#define ADV7183_GEMSTAR_CTRL_2     0x49 /* Gemstar ctrl 2 */
+#define ADV7183_GEMSTAR_CTRL_3     0x4A /* Gemstar ctrl 3 */
+#define ADV7183_GEMSTAR_CTRL_4     0x4B /* Gemstar ctrl 4 */
+#define ADV7183_GEMSTAR_CTRL_5     0x4C /* Gemstar ctrl 5 */
+#define ADV7183_CTI_DNR_CTRL_1     0x4D /* CTI DNR ctrl 1 */
+#define ADV7183_CTI_DNR_CTRL_2     0x4E /* CTI DNR ctrl 2 */
+#define ADV7183_CTI_DNR_CTRL_4     0x50 /* CTI DNR ctrl 4 */
+#define ADV7183_LOCK_CNT           0x51 /* Lock count */
+#define ADV7183_FREE_LINE_LEN      0x8F /* Free-Run line length 1 */
+#define ADV7183_VBI_INFO           0x90 /* VBI info */
+#define ADV7183_WSS_1              0x91 /* WSS 1 */
+#define ADV7183_WSS_2              0x92 /* WSS 2 */
+#define ADV7183_EDTV_1             0x93 /* EDTV 1 */
+#define ADV7183_EDTV_2             0x94 /* EDTV 2 */
+#define ADV7183_EDTV_3             0x95 /* EDTV 3 */
+#define ADV7183_CGMS_1             0x96 /* CGMS 1 */
+#define ADV7183_CGMS_2             0x97 /* CGMS 2 */
+#define ADV7183_CGMS_3             0x98 /* CGMS 3 */
+#define ADV7183_CCAP_1             0x99 /* CCAP 1 */
+#define ADV7183_CCAP_2             0x9A /* CCAP 2 */
+#define ADV7183_LETTERBOX_1        0x9B /* Letterbox 1 */
+#define ADV7183_LETTERBOX_2        0x9C /* Letterbox 2 */
+#define ADV7183_LETTERBOX_3        0x9D /* Letterbox 3 */
+#define ADV7183_CRC_EN             0xB2 /* CRC enable */
+#define ADV7183_ADC_SWITCH_1       0xC3 /* ADC switch 1 */
+#define ADV7183_ADC_SWITCH_2       0xC4 /* ADC swithc 2 */
+#define ADV7183_LETTERBOX_CTRL_1   0xDC /* Letterbox control 1 */
+#define ADV7183_LETTERBOX_CTRL_2   0xDD /* Letterbox control 2 */
+#define ADV7183_SD_OFFSET_CB       0xE1 /* SD offset Cb */
+#define ADV7183_SD_OFFSET_CR       0xE2 /* SD offset Cr */
+#define ADV7183_SD_SATURATION_CB   0xE3 /* SD saturation Cb */
+#define ADV7183_SD_SATURATION_CR   0xE4 /* SD saturation Cr */
+#define ADV7183_NTSC_V_BEGIN       0xE5 /* NTSC V bit begin */
+#define ADV7183_NTSC_V_END         0xE6 /* NTSC V bit end */
+#define ADV7183_NTSC_F_TOGGLE      0xE7 /* NTSC F bit toggle */
+#define ADV7183_PAL_V_BEGIN        0xE8 /* PAL V bit begin */
+#define ADV7183_PAL_V_END          0xE9 /* PAL V bit end */
+#define ADV7183_PAL_F_TOGGLE       0xEA /* PAL F bit toggle */
+#define ADV7183_DRIVE_STR          0xF4 /* Drive strength */
+#define ADV7183_IF_COMP_CTRL       0xF8 /* IF comp control */
+#define ADV7183_VS_MODE_CTRL       0xF9 /* VS mode control */
+
+#endif
diff --git a/include/media/adv7183.h b/include/media/adv7183.h
new file mode 100644
index 0000000..ef99a00
--- /dev/null
+++ b/include/media/adv7183.h
@@ -0,0 +1,47 @@
+/*
+ * adv7183.h - definition for adv7183 inputs and outputs
+ *
+ * Copyright (c) 2011 Analog Devices Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _ADV7183_H_
+#define _ADV7183_H_
+
+/* ADV7183 HW inputs */
+#define ADV7183_COMPOSITE0  0  /* CVBS in on AIN1 */
+#define ADV7183_COMPOSITE1  1  /* CVBS in on AIN2 */
+#define ADV7183_COMPOSITE2  2  /* CVBS in on AIN3 */
+#define ADV7183_COMPOSITE3  3  /* CVBS in on AIN4 */
+#define ADV7183_COMPOSITE4  4  /* CVBS in on AIN5 */
+#define ADV7183_COMPOSITE5  5  /* CVBS in on AIN6 */
+#define ADV7183_COMPOSITE6  6  /* CVBS in on AIN7 */
+#define ADV7183_COMPOSITE7  7  /* CVBS in on AIN8 */
+#define ADV7183_COMPOSITE8  8  /* CVBS in on AIN9 */
+#define ADV7183_COMPOSITE9  9  /* CVBS in on AIN10 */
+#define ADV7183_COMPOSITE10 10 /* CVBS in on AIN11 */
+
+#define ADV7183_SVIDEO0     11 /* Y on AIN1, C on AIN4 */
+#define ADV7183_SVIDEO1     12 /* Y on AIN2, C on AIN5 */
+#define ADV7183_SVIDEO2     13 /* Y on AIN3, C on AIN6 */
+
+#define ADV7183_COMPONENT0  14 /* Y on AIN1, Pr on AIN4, Pb on AIN5 */
+#define ADV7183_COMPONENT1  15 /* Y on AIN2, Pr on AIN3, Pb on AIN6 */
+
+/* ADV7183 HW outputs */
+#define ADV7183_8BIT_OUT    0
+#define	ADV7183_16BIT_OUT   1
+
+#endif
diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 63fd9d3..20fd16d 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -162,6 +162,9 @@ enum {
 	/* module adv7180: just ident 7180 */
 	V4L2_IDENT_ADV7180 = 7180,
 
+	/* module adv7183: just ident 7183 */
+	V4L2_IDENT_ADV7183 = 7183,
+
 	/* module saa7185: just ident 7185 */
 	V4L2_IDENT_SAA7185 = 7185,
 
-- 
1.7.0.4


