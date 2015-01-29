Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:55509 "EHLO
	xk120" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753588AbbA2QTx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 11:19:53 -0500
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 2/8] adv7604.c: formats, default colourspace, and IRQs
Date: Thu, 29 Jan 2015 16:19:42 +0000
Message-Id: <1422548388-28861-3-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

** for lx3.18.x+; from previous description **

The original adv7612-specific driver only contained formats meeting
a certain specification; allowing the adv7612 chip to permit all the
formats the adv7611 supports breaks this restriction and means that
enum_mbus_code can end up containing values that cause problems with
frame capture.

...Specifically, introducing a fully identical supported formats list
breaks video capture for video/x-raw-rgb in particular unless the
code path in rcar_vin.c marked "Ian HACK" is present. Reducing the
list leads to the possibility of gstreamer creating zero-length files.

This patch enables the reduced list by default, and does not enable
the corresponding fixup hack.

Support for 'video/x-raw-yuv' is unaffected in either case.

WmT: rcar_vin.c adv7604 driver compatibility

Add 'struct media_pad pad' member and suitable glue code, so that
soc_camera/rcar_vin can become agnostic to whether an old or new-
style driver (wrt pad API use) can sit underneath

This version has been reworked to include appropriate constant and
datatype names for kernel v3.18
---
 drivers/media/i2c/adv7604.c |  148 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 145 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 6666803..30bbd9d 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -43,7 +43,18 @@
 #include <media/v4l2-dv-timings.h>
 #include <media/v4l2-of.h>
 
-static int debug;
+#if 1	/*  WmT: TESTING  */
+#define HAVE_ADV7612_FORMATS
+	/*  Possible issue: adv7604_formats[] is extensive, whereas
+	    adv7612.c only had RGB888_1X24 (-> V4L2_COLORSPACE_SRGB)
+	    ...this doesn't cover MEDIA_BUS_FMT_YUYV8_2X8, which appears
+	    to be the new default format. Forcing 'code' "help"s
+	 */
+//define HAVE_ADV7611_EXTRA_FORMATS	/* identical list to 7611 */
+//#define HAVE_ADV7604_EXTRA_FORMATS	/* -> "unsupported" warnings */
+#endif
+
+static int debug = 0;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "debug level (0-2)");
 
@@ -80,6 +91,7 @@ MODULE_LICENSE("GPL");
 enum adv7604_type {
 	ADV7604,
 	ADV7611,
+	ADV7612,
 };
 
 struct adv7604_reg_seq {
@@ -818,6 +830,73 @@ static const struct adv7604_format_info adv7611_formats[] = {
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
 };
 
+#ifdef HAVE_ADV7612_FORMATS
+static const struct adv7604_format_info adv7612_formats[] = {
+	{ MEDIA_BUS_FMT_RGB888_1X24, ADV7604_OP_CH_SEL_RGB, true, false,
+	  ADV7604_OP_MODE_SEL_SDR_444 | ADV7604_OP_FORMAT_SEL_8BIT },
+#ifdef HAVE_ADV7611_EXTRA_FORMATS	/* breaks without "Ian HACK"? */
+	{ MEDIA_BUS_FMT_YUYV8_2X8, ADV7604_OP_CH_SEL_RGB, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
+#endif
+	{ MEDIA_BUS_FMT_YVYU8_2X8, ADV7604_OP_CH_SEL_RGB, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
+#ifdef HAVE_ADV7604_EXTRA_FORMATS
+	/* 0x200b not in soc_mediabus.c mbus_fmt[] (07/01/2015) */
+	{ MEDIA_BUS_FMT_YUYV10_2X10, ADV7604_OP_CH_SEL_RGB, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_10BIT },
+	/* 0x200c not in soc_mediabus.c mbus_fmt[] (07/01/2015) */
+	{ MEDIA_BUS_FMT_YVYU10_2X10, ADV7604_OP_CH_SEL_RGB, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_10BIT },
+	/* 0x201e not in soc_mediabus.c mbus_fmt[] (07/01/2015) */
+	{ MEDIA_BUS_FMT_YUYV12_2X12, ADV7604_OP_CH_SEL_RGB, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
+	/* 0x201f not in soc_mediabus.c mbus_fmt[] (07/01/2015) */
+	{ MEDIA_BUS_FMT_YVYU12_2X12, ADV7604_OP_CH_SEL_RGB, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
+#endif
+	{ MEDIA_BUS_FMT_UYVY8_1X16, ADV7604_OP_CH_SEL_RBG, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_VYUY8_1X16, ADV7604_OP_CH_SEL_RBG, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
+#ifdef HAVE_ADV7611_EXTRA_FORMATS	/* inconsistent RGB <-> RGB without "Ian HACK" */
+	{ MEDIA_BUS_FMT_YUYV8_1X16, ADV7604_OP_CH_SEL_RGB, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YVYU8_1X16, ADV7604_OP_CH_SEL_RGB, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
+#endif
+#ifdef HAVE_ADV7604_EXTRA_FORMATS
+	/* 0x201a not in soc_mediabus.c mbus_fmt[] (07/01/2015) */
+	{ MEDIA_BUS_FMT_UYVY10_1X20, ADV7604_OP_CH_SEL_RBG, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
+	/* 0x201b not in soc_mediabus.c mbus_fmt[] (07/01/2015) */
+	{ MEDIA_BUS_FMT_VYUY10_1X20, ADV7604_OP_CH_SEL_RBG, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
+	/* 0x200d not in soc_mediabus.c mbus_fmt[] (07/01/2015) */
+	{ MEDIA_BUS_FMT_YUYV10_1X20, ADV7604_OP_CH_SEL_RGB, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
+	/* 0x200e not in soc_mediabus.c mbus_fmt[] (07/01/2015) */
+	{ MEDIA_BUS_FMT_YVYU10_1X20, ADV7604_OP_CH_SEL_RGB, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
+	/* 0x2020 not in soc_mediabus.c mbus_fmt[] (07/01/2015) */
+	/* IS in adv7611_formats[] */
+	{ MEDIA_BUS_FMT_UYVY12_1X24, ADV7604_OP_CH_SEL_RBG, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
+	/* 0x2021 not in soc_mediabus.c mbus_fmt[] (07/01/2015) */
+	{ MEDIA_BUS_FMT_VYUY12_1X24, ADV7604_OP_CH_SEL_RBG, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
+	/* IS in adv7611_formats[] */
+	/* 0x2022 not in soc_mediabus.c mbus_fmt[] (07/01/2015) */
+	/* IS in adv7611_formats[] */
+	{ MEDIA_BUS_FMT_YUYV12_1X24, ADV7604_OP_CH_SEL_RGB, false, false,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
+	/* 0x2023 not in soc_mediabus.c mbus_fmt[] (07/01/2015) */
+	/* IS in adv7611_formats[] */
+	{ MEDIA_BUS_FMT_YVYU12_1X24, ADV7604_OP_CH_SEL_RGB, false, true,
+	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
+#endif
+};
+#endif	/*  HAVE_ADV7612_FORMATS  */
+
 static const struct adv7604_format_info *
 adv7604_format_info(struct adv7604_state *state, u32 code)
 {
@@ -1918,6 +1997,10 @@ static int adv7604_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	info = adv7604_format_info(state, format->format.code);
 	if (info == NULL)
 		info = adv7604_format_info(state, MEDIA_BUS_FMT_YUYV8_2X8);
+#ifndef HAVE_ADV7611_EXTRA_FORMATS	/* above is missing for 7612 */
+	if (info == NULL)
+		info = adv7604_format_info(state, MEDIA_BUS_FMT_RGB888_1X24);
+#endif
 
 	adv7604_fill_format(state, &format->format);
 	format->format.code = info->code;
@@ -2516,6 +2599,11 @@ static void adv7611_setup_irqs(struct v4l2_subdev *sd)
 	io_write(sd, 0x41, 0xd0); /* STDI irq for any change, disable INT2 */
 }
 
+static void adv7612_setup_irqs(struct v4l2_subdev *sd)
+{
+	io_write(sd, 0x41, 0xd0); /* disable INT2 */
+}
+
 static void adv7604_unregister_clients(struct adv7604_state *state)
 {
 	unsigned int i;
@@ -2603,6 +2691,19 @@ static const struct adv7604_reg_seq adv7611_recommended_settings_hdmi[] = {
 	{ ADV7604_REG_SEQ_TERM, 0 },
 };
 
+static const struct adv7604_reg_seq adv7612_recommended_settings_hdmi[] = {
+	{ ADV7604_REG(ADV7604_PAGE_CP, 0x6c), 0x00 },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x9b), 0x03 },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x6f), 0x08 },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x85), 0x1f },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x87), 0x70 },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x57), 0xda },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x58), 0x01 },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x03), 0x98 },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x4c), 0x44 },
+	{ ADV7604_REG_SEQ_TERM, 0 },
+};
+
 static const struct adv7604_chip_info adv7604_chip_info[] = {
 	[ADV7604] = {
 		.type = ADV7604,
@@ -2665,17 +2766,52 @@ static const struct adv7604_chip_info adv7604_chip_info[] = {
 			BIT(ADV7604_PAGE_REP) |  BIT(ADV7604_PAGE_EDID) |
 			BIT(ADV7604_PAGE_HDMI) | BIT(ADV7604_PAGE_CP),
 	},
+	[ADV7612] = {
+		.type = ADV7612,
+		.has_afe = false,
+		.max_port = ADV7604_PAD_HDMI_PORT_B,
+		.num_dv_ports = 2,
+		.edid_enable_reg = 0x74,
+		.edid_status_reg = 0x76,
+		.lcf_reg = 0xa3,
+		.tdms_lock_mask = 0x43,
+		.cable_det_mask = 0x01,
+		.fmt_change_digital_mask = 0x03,
+#ifdef HAVE_ADV7612_FORMATS
+		.formats = adv7612_formats,
+		.nformats = ARRAY_SIZE(adv7612_formats),
+#else
+		.formats = adv7604_formats,
+		.nformats = ARRAY_SIZE(adv7604_formats),
+#endif	/*  HAVE_ADV7612_FORMATS  */
+		.set_termination = adv7611_set_termination,
+		.setup_irqs = adv7612_setup_irqs,
+		.read_hdmi_pixelclock = adv7611_read_hdmi_pixelclock,
+		.read_cable_det = adv7611_read_cable_det,
+		.recommended_settings = {
+		    [1] = adv7612_recommended_settings_hdmi,
+		},
+		.num_recommended_settings = {
+		    [1] = ARRAY_SIZE(adv7612_recommended_settings_hdmi),
+		},
+		.page_mask = BIT(ADV7604_PAGE_IO) | BIT(ADV7604_PAGE_CEC) |
+			BIT(ADV7604_PAGE_INFOFRAME) | BIT(ADV7604_PAGE_AFE) |
+			BIT(ADV7604_PAGE_REP) |  BIT(ADV7604_PAGE_EDID) |
+			BIT(ADV7604_PAGE_HDMI) | BIT(ADV7604_PAGE_CP),
+	},
 };
 
 static struct i2c_device_id adv7604_i2c_id[] = {
 	{ "adv7604", (kernel_ulong_t)&adv7604_chip_info[ADV7604] },
 	{ "adv7611", (kernel_ulong_t)&adv7604_chip_info[ADV7611] },
+	{ "adv7612", (kernel_ulong_t)&adv7604_chip_info[ADV7612] },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, adv7604_i2c_id);
 
 static struct of_device_id adv7604_of_id[] __maybe_unused = {
 	{ .compatible = "adi,adv7611", .data = &adv7604_chip_info[ADV7611] },
+	{ .compatible = "adi,adv7612", .data = &adv7604_chip_info[ADV7612] },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, adv7604_of_id);
@@ -2812,7 +2948,12 @@ static int adv7604_probe(struct i2c_client *client,
 	}
 
 	state->timings = cea640x480;
+	/* FIXME: interesting on adv7612 */
 	state->format = adv7604_format_info(state, MEDIA_BUS_FMT_YUYV8_2X8);
+#ifndef HAVE_ADV7611_EXTRA_FORMATS	/* above is missing for 7612 */
+	if (state->format == NULL)	// state->info->type != ADV7612
+		state->format = adv7604_format_info(state, MEDIA_BUS_FMT_RGB888_1X24);
+#endif
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7604_ops);
@@ -2836,8 +2977,9 @@ static int adv7604_probe(struct i2c_client *client,
 	} else {
 		val = (adv_smbus_read_byte_data_check(client, 0xea, false) << 8)
 		    | (adv_smbus_read_byte_data_check(client, 0xeb, false) << 0);
-		if (val != 0x2051) {
-			v4l2_info(sd, "not an adv7611 on address 0x%x\n",
+		if ((state->info->type == ADV7611 && val != 0x2051) ||
+			(state->info->type == ADV7612 && val != 0x2041)) {
+			v4l2_info(sd, "not an adv761x on address 0x%x\n",
 					client->addr << 1);
 			return -ENODEV;
 		}
-- 
1.7.10.4

