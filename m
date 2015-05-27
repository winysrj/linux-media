Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:52384 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752249AbbE0QK7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2015 12:10:59 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 04/15] media: adv7604: chip info and formats for ADV7612
Date: Wed, 27 May 2015 17:10:42 +0100
Message-Id: <1432743053-13479-5-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432743053-13479-1-git-send-email-william.towle@codethink.co.uk>
References: <1432743053-13479-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the ADV7612 chip as implemented on Renesas' Lager
board to adv7604.c, including lists for formats/colourspace/timing
selection and an IRQ handler.

Signed-off-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/i2c/adv7604.c |   83 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 81 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index aaa37b0..c5a1566 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -80,6 +80,7 @@ MODULE_LICENSE("GPL");
 enum adv76xx_type {
 	ADV7604,
 	ADV7611,
+	ADV7612,
 };
 
 struct adv76xx_reg_seq {
@@ -758,6 +759,23 @@ static const struct adv76xx_format_info adv7611_formats[] = {
 	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_12BIT },
 };
 
+static const struct adv76xx_format_info adv7612_formats[] = {
+	{ MEDIA_BUS_FMT_RGB888_1X24, ADV76XX_OP_CH_SEL_RGB, true, false,
+	  ADV76XX_OP_MODE_SEL_SDR_444 | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, ADV76XX_OP_CH_SEL_RGB, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422 | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, ADV76XX_OP_CH_SEL_RGB, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422 | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_UYVY8_1X16, ADV76XX_OP_CH_SEL_RBG, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_VYUY8_1X16, ADV76XX_OP_CH_SEL_RBG, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YUYV8_1X16, ADV76XX_OP_CH_SEL_RGB, false, false,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_8BIT },
+	{ MEDIA_BUS_FMT_YVYU8_1X16, ADV76XX_OP_CH_SEL_RGB, false, true,
+	  ADV76XX_OP_MODE_SEL_SDR_422_2X | ADV76XX_OP_FORMAT_SEL_8BIT },
+};
+
 static const struct adv76xx_format_info *
 adv76xx_format_info(struct adv76xx_state *state, u32 code)
 {
@@ -2471,6 +2489,11 @@ static void adv7611_setup_irqs(struct v4l2_subdev *sd)
 	io_write(sd, 0x41, 0xd0); /* STDI irq for any change, disable INT2 */
 }
 
+static void adv7612_setup_irqs(struct v4l2_subdev *sd)
+{
+	io_write(sd, 0x41, 0xd0); /* disable INT2 */
+}
+
 static void adv76xx_unregister_clients(struct adv76xx_state *state)
 {
 	unsigned int i;
@@ -2558,6 +2581,19 @@ static const struct adv76xx_reg_seq adv7611_recommended_settings_hdmi[] = {
 	{ ADV76XX_REG_SEQ_TERM, 0 },
 };
 
+static const struct adv76xx_reg_seq adv7612_recommended_settings_hdmi[] = {
+	{ ADV76XX_REG(ADV76XX_PAGE_CP, 0x6c), 0x00 },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x9b), 0x03 },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x6f), 0x08 },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x85), 0x1f },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x87), 0x70 },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x57), 0xda },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x58), 0x01 },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x03), 0x98 },
+	{ ADV76XX_REG(ADV76XX_PAGE_HDMI, 0x4c), 0x44 },
+	{ ADV76XX_REG_SEQ_TERM, 0 },
+};
+
 static const struct adv76xx_chip_info adv76xx_chip_info[] = {
 	[ADV7604] = {
 		.type = ADV7604,
@@ -2646,17 +2682,59 @@ static const struct adv76xx_chip_info adv76xx_chip_info[] = {
 		.field1_vsync_mask = 0x3fff,
 		.field1_vbackporch_mask = 0x3fff,
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
+		.formats = adv7612_formats,
+		.nformats = ARRAY_SIZE(adv7612_formats),
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
+		.page_mask = BIT(ADV76XX_PAGE_IO) | BIT(ADV76XX_PAGE_CEC) |
+			BIT(ADV76XX_PAGE_INFOFRAME) | BIT(ADV76XX_PAGE_AFE) |
+			BIT(ADV76XX_PAGE_REP) |  BIT(ADV76XX_PAGE_EDID) |
+			BIT(ADV76XX_PAGE_HDMI) | BIT(ADV76XX_PAGE_CP),
+		.linewidth_mask = 0x1fff,
+		.field0_height_mask = 0x1fff,
+		.field1_height_mask = 0x1fff,
+		.hfrontporch_mask = 0x1fff,
+		.hsync_mask = 0x1fff,
+		.hbackporch_mask = 0x1fff,
+		.field0_vfrontporch_mask = 0x3fff,
+		.field0_vsync_mask = 0x3fff,
+		.field0_vbackporch_mask = 0x3fff,
+		.field1_vfrontporch_mask = 0x3fff,
+		.field1_vsync_mask = 0x3fff,
+		.field1_vbackporch_mask = 0x3fff,
+	},
 };
 
 static const struct i2c_device_id adv76xx_i2c_id[] = {
 	{ "adv7604", (kernel_ulong_t)&adv76xx_chip_info[ADV7604] },
 	{ "adv7611", (kernel_ulong_t)&adv76xx_chip_info[ADV7611] },
+	{ "adv7612", (kernel_ulong_t)&adv76xx_chip_info[ADV7612] },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, adv76xx_i2c_id);
 
 static const struct of_device_id adv76xx_of_id[] __maybe_unused = {
 	{ .compatible = "adi,adv7611", .data = &adv76xx_chip_info[ADV7611] },
+	{ .compatible = "adi,adv7612", .data = &adv76xx_chip_info[ADV7612] },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, adv76xx_of_id);
@@ -2811,8 +2889,9 @@ static int adv76xx_probe(struct i2c_client *client,
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

