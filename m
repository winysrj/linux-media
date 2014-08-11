Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:60522 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbaHKMFm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Aug 2014 08:05:42 -0400
From: Ian Molton <ian.molton@codethink.co.uk>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	robh+dt@kernel.org, devicetree@vger.kernel.org, lars@metafoo.de,
	shubhrajyoti@ti.com, william-towle@codethink.co.uk,
	ian.molton@codethink.co.uk
Subject: [PATCH 1/2] media: adv7604: Add support for ADV7612 dual HDMI input decoder.
Date: Mon, 11 Aug 2014 13:05:18 +0100
Message-Id: <1407758719-12474-2-git-send-email-ian.molton@codethink.co.uk>
In-Reply-To: <1407758719-12474-1-git-send-email-ian.molton@codethink.co.uk>
References: <1407758719-12474-1-git-send-email-ian.molton@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds necessary support for the ADV7612 dual HDMI decoder / repeater
chip.

This was tested using a heavily modified rcar_vin/soc_camera capture driver.

Tested-by: William Towle <william.towle@codethink.co.uk>
Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
---
 .../devicetree/bindings/media/i2c/adv7604.txt      | 17 +++----
 drivers/media/i2c/adv7604.c                        | 54 +++++++++++++++++++++-
 2 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
index c27cede..cc0708c 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
@@ -1,15 +1,16 @@
-* Analog Devices ADV7604/11 video decoder with HDMI receiver
+* Analog Devices ADV7604/11/12 video decoder with HDMI receiver
 
-The ADV7604 and ADV7611 are multiformat video decoders with an integrated HDMI
-receiver. The ADV7604 has four multiplexed HDMI inputs and one analog input,
-and the ADV7611 has one HDMI input and no analog input.
+The ADV7604 and ADV7611/12 are multiformat video decoders with an integrated
+HDMI receiver. The ADV7604 has four multiplexed HDMI inputs and one analog
+input, and the ADV7611 has one HDMI input and no analog input. The 7612 is similar to the 7611 but has 2 HDMI inputs.
 
-These device tree bindings support the ADV7611 only at the moment.
+These device tree bindings support the ADV7611/12 only at the moment.
 
 Required Properties:
 
   - compatible: Must contain one of the following
     - "adi,adv7611" for the ADV7611
+    - "adi,adv7612" for the ADV7612
 
   - reg: I2C slave address
 
@@ -22,10 +23,10 @@ port, in accordance with the video interface bindings defined in
 Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
 are numbered as follows.
 
-  Port			ADV7611
+  Port			ADV7611    ADV7612
 ------------------------------------------------------------
-  HDMI			0
-  Digital output	1
+  HDMI			0             0, 1
+  Digital output	1                2
 
 The digital output port node must contain at least one endpoint.
 
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 1778d32..9f73a7f 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -80,6 +80,7 @@ MODULE_LICENSE("GPL");
 enum adv7604_type {
 	ADV7604,
 	ADV7611,
+	ADV7612,
 };
 
 struct adv7604_reg_seq {
@@ -2517,6 +2518,11 @@ static void adv7611_setup_irqs(struct v4l2_subdev *sd)
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
@@ -2601,6 +2607,19 @@ static const struct adv7604_reg_seq adv7611_recommended_settings_hdmi[] = {
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
@@ -2663,17 +2682,47 @@ static const struct adv7604_chip_info adv7604_chip_info[] = {
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
+		.formats = adv7604_formats,
+		.nformats = ARRAY_SIZE(adv7604_formats),
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
@@ -2828,8 +2877,9 @@ static int adv7604_probe(struct i2c_client *client,
 	} else {
 		val = (adv_smbus_read_byte_data_check(client, 0xea, false) << 8)
 		    | (adv_smbus_read_byte_data_check(client, 0xeb, false) << 0);
-		if (val != 0x2051) {
-			v4l2_info(sd, "not an adv7611 on address 0x%x\n",
+		if ((state->info->type == ADV7611 && val != 0x2051) ||
+		    (state->info->type == ADV7612 && val != 0x2041)) {
+			v4l2_info(sd, "not an adv761x on address 0x%x\n",
 					client->addr << 1);
 			return -ENODEV;
 		}
-- 
1.9.1

