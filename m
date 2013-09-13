Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:43864 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3IML6O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Sep 2013 07:58:14 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>, devicetree@vger.kernel.org
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>, linux-doc@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: i2c: adv7343: fix the DT binding properties
Date: Fri, 13 Sep 2013 17:27:51 +0530
Message-Id: <1379073471-7244-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch fixes the DT binding properties of adv7343 decoder.
The pdata which was being read from the DT property, is removed
as this can done internally in the driver using cable detection
register.

This patch also removes the pdata of ADV7343 which was passed from
DA850 machine.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 .../devicetree/bindings/media/i2c/adv7343.txt      |   33 ++++----
 arch/arm/mach-davinci/board-da850-evm.c            |   10 ---
 drivers/media/i2c/adv7343.c                        |   86 ++++++--------------
 drivers/media/i2c/adv7343_regs.h                   |    8 +-
 include/media/adv7343.h                            |   40 ---------
 5 files changed, 42 insertions(+), 135 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv7343.txt b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
index 5653bc2..5d0e7e4 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7343.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
@@ -8,39 +8,34 @@ formats.
 
 Required Properties :
 - compatible: Must be "adi,adv7343"
+- reg: I2C device address.
+- vddio-supply: I/O voltage supply.
+- vddcore-supply: core voltage supply.
+- vaa-supply: Analog power supply.
+- pvdd-supply: PLL power supply.
 
 Optional Properties :
-- adi,power-mode-sleep-mode: on enable the current consumption is reduced to
-			      micro ampere level. All DACs and the internal PLL
-			      circuit are disabled.
-- adi,power-mode-pll-ctrl: PLL and oversampling control. This control allows
-			   internal PLL 1 circuit to be powered down and the
-			   oversampling to be switched off.
-- ad,adv7343-power-mode-dac: array configuring the power on/off DAC's 1..6,
-			      0 = OFF and 1 = ON, Default value when this
-			      property is not specified is <0 0 0 0 0 0>.
-- ad,adv7343-sd-config-dac-out: array configure SD DAC Output's 1 and 2, 0 = OFF
-				 and 1 = ON, Default value when this property is
-				 not specified is <0 0>.
+- vref-supply: Voltage reference output.
+
+For further reading on port node refer to
+Documentation/devicetree/bindings/media/video-interfaces.txt.
 
 Example:
 
 i2c0@1c22000 {
 	...
 	...
-
 	adv7343@2a {
 		compatible = "adi,adv7343";
 		reg = <0x2a>;
+		vddio-supply = <&regulator1>;
+		vddcore-supply = <&regulator2>;
+		vaa-supply = <&regulator3>;
+		pvdd-supply = <&regulator4>;
 
 		port {
 			adv7343_1: endpoint {
-					adi,power-mode-sleep-mode;
-					adi,power-mode-pll-ctrl;
-					/* Use DAC1..3, DAC6 */
-					adi,dac-enable = <1 1 1 0 0 1>;
-					/* Use SD DAC output 1 */
-					adi,sd-dac-enable = <1 0>;
+				remote-endpoint = <&vpif0_1>;
 			};
 		};
 	};
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index dd1fb24..5c72c8a 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1243,21 +1243,11 @@ static struct vpif_capture_config da850_vpif_capture_config = {
 
 /* VPIF display configuration */
 
-static struct adv7343_platform_data adv7343_pdata = {
-	.mode_config = {
-		.dac = { 1, 1, 1 },
-	},
-	.sd_config = {
-		.sd_dac_out = { 1 },
-	},
-};
-
 static struct vpif_subdev_info da850_vpif_subdev[] = {
 	{
 		.name = "adv7343",
 		.board_info = {
 			I2C_BOARD_INFO("adv7343", 0x2a),
-			.platform_data = &adv7343_pdata,
 		},
 	},
 };
diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
index aeb56c5..97aa8e5 100644
--- a/drivers/media/i2c/adv7343.c
+++ b/drivers/media/i2c/adv7343.c
@@ -44,7 +44,6 @@ MODULE_PARM_DESC(debug, "Debug level 0-1");
 struct adv7343_state {
 	struct v4l2_subdev sd;
 	struct v4l2_ctrl_handler hdl;
-	const struct adv7343_platform_data *pdata;
 	u8 reg00;
 	u8 reg01;
 	u8 reg02;
@@ -72,6 +71,13 @@ static inline int adv7343_write(struct v4l2_subdev *sd, u8 reg, u8 value)
 	return i2c_smbus_write_byte_data(client, reg, value);
 }
 
+static int adv7343_read(struct v4l2_subdev *sd, u8 reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return i2c_smbus_read_byte_data(client, reg);
+}
+
 static const u8 adv7343_init_reg_val[] = {
 	ADV7343_SOFT_RESET, ADV7343_SOFT_RESET_DEFAULT,
 	ADV7343_POWER_MODE_REG, ADV7343_POWER_MODE_REG_DEFAULT,
@@ -204,6 +210,7 @@ setstd_exit:
 static int adv7343_setoutput(struct v4l2_subdev *sd, u32 output_type)
 {
 	struct adv7343_state *state = to_state(sd);
+	unsigned char cable_detect;
 	unsigned char val;
 	int err = 0;
 
@@ -217,23 +224,8 @@ static int adv7343_setoutput(struct v4l2_subdev *sd, u32 output_type)
 	/* Enable Appropriate DAC */
 	val = state->reg00 & 0x03;
 
-	/* configure default configuration */
-	if (!state->pdata)
-		if (output_type == ADV7343_COMPOSITE_ID)
-			val |= ADV7343_COMPOSITE_POWER_VALUE;
-		else if (output_type == ADV7343_COMPONENT_ID)
-			val |= ADV7343_COMPONENT_POWER_VALUE;
-		else
-			val |= ADV7343_SVIDEO_POWER_VALUE;
-	else
-		val = state->pdata->mode_config.sleep_mode << 0 |
-		      state->pdata->mode_config.pll_control << 1 |
-		      state->pdata->mode_config.dac[2] << 2 |
-		      state->pdata->mode_config.dac[1] << 3 |
-		      state->pdata->mode_config.dac[0] << 4 |
-		      state->pdata->mode_config.dac[5] << 5 |
-		      state->pdata->mode_config.dac[4] << 6 |
-		      state->pdata->mode_config.dac[3] << 7;
+	/* Enable all the DAC's DAC1..DAC6 */
+	val |= ADV7343_POWER_VALUE;
 
 	err = adv7343_write(sd, ADV7343_POWER_MODE_REG, val);
 	if (err < 0)
@@ -252,15 +244,14 @@ static int adv7343_setoutput(struct v4l2_subdev *sd, u32 output_type)
 	/* configure SD DAC Output 2 and SD DAC Output 1 bit to zero */
 	val = state->reg82 & (SD_DAC_1_DI & SD_DAC_2_DI);
 
-	if (state->pdata && state->pdata->sd_config.sd_dac_out[0])
-		val = val | (state->pdata->sd_config.sd_dac_out[0] << 1);
-	else if (state->pdata && !state->pdata->sd_config.sd_dac_out[0])
-		val = val & ~(state->pdata->sd_config.sd_dac_out[0] << 1);
+	cable_detect = adv7343_read(sd, ADV7343_CABLE_DETECTION);
+	/* enable SD DAC output 1 */
+	if (!(cable_detect & (1 << 0)))
+		val = val | 0x2;
 
-	if (state->pdata && state->pdata->sd_config.sd_dac_out[1])
-		val = val | (state->pdata->sd_config.sd_dac_out[1] << 2);
-	else if (state->pdata && !state->pdata->sd_config.sd_dac_out[1])
-		val = val & ~(state->pdata->sd_config.sd_dac_out[1] << 2);
+	/* enable SD DAC output 2 */
+	if (!(cable_detect & (1 << 1)))
+		val = val | 0x4;
 
 	err = adv7343_write(sd, ADV7343_SD_MODE_REG2, val);
 	if (err < 0)
@@ -268,6 +259,12 @@ static int adv7343_setoutput(struct v4l2_subdev *sd, u32 output_type)
 
 	state->reg82 = val;
 
+	/* enable unconnected DAC auto power down */
+	err = adv7343_write(sd, ADV7343_CABLE_DETECTION,
+			    cable_detect | ADV7343_AUTO_POWER_DOWN_ENABLE);
+	if (err < 0)
+		goto setoutput_exit;
+
 	/* configure ED/HD Color DAC Swap and ED/HD RGB Input Enable bit to
 	 * zero */
 	val = state->reg35 & (HD_RGB_INPUT_DI & HD_DAC_SWAP_DI);
@@ -400,40 +397,6 @@ static int adv7343_initialize(struct v4l2_subdev *sd)
 	return err;
 }
 
-static struct adv7343_platform_data *
-adv7343_get_pdata(struct i2c_client *client)
-{
-	struct adv7343_platform_data *pdata;
-	struct device_node *np;
-
-	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
-		return client->dev.platform_data;
-
-	np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
-	if (!np)
-		return NULL;
-
-	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata)
-		goto done;
-
-	pdata->mode_config.sleep_mode =
-			of_property_read_bool(np, "adi,power-mode-sleep-mode");
-
-	pdata->mode_config.pll_control =
-			of_property_read_bool(np, "adi,power-mode-pll-ctrl");
-
-	of_property_read_u32_array(np, "adi,dac-enable",
-				   pdata->mode_config.dac, 6);
-
-	of_property_read_u32_array(np, "adi,sd-dac-enable",
-				   pdata->sd_config.sd_dac_out, 2);
-
-done:
-	of_node_put(np);
-	return pdata;
-}
-
 static int adv7343_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
@@ -451,9 +414,6 @@ static int adv7343_probe(struct i2c_client *client,
 	if (state == NULL)
 		return -ENOMEM;
 
-	/* Copy board specific information here */
-	state->pdata = adv7343_get_pdata(client);
-
 	state->reg00	= 0x80;
 	state->reg01	= 0x00;
 	state->reg02	= 0x20;
diff --git a/drivers/media/i2c/adv7343_regs.h b/drivers/media/i2c/adv7343_regs.h
index 4466067..94d9722 100644
--- a/drivers/media/i2c/adv7343_regs.h
+++ b/drivers/media/i2c/adv7343_regs.h
@@ -29,6 +29,8 @@ struct adv7343_std_info {
 
 #define ADV7343_DAC2_OUTPUT_LEVEL	(0x0b)
 
+#define ADV7343_CABLE_DETECTION		0x10
+
 #define ADV7343_SOFT_RESET		(0x17)
 
 #define ADV7343_HD_MODE_REG1		(0x30)
@@ -72,9 +74,7 @@ struct adv7343_std_info {
 #define ADV7343_HD_MODE_REG7_DEFAULT		(0x00)
 #define ADV7343_SD_MODE_REG8_DEFAULT		(0x00)
 #define ADV7343_SOFT_RESET_DEFAULT		(0x02)
-#define ADV7343_COMPOSITE_POWER_VALUE		(0x80)
-#define ADV7343_COMPONENT_POWER_VALUE		(0x1C)
-#define ADV7343_SVIDEO_POWER_VALUE		(0x60)
+#define ADV7343_POWER_VALUE			0xfc
 #define ADV7343_SD_HUE_REG_DEFAULT		(127)
 #define ADV7343_SD_BRIGHTNESS_WSS_DEFAULT	(0x03)
 
@@ -178,4 +178,6 @@ struct adv7343_std_info {
 #define ADV7343_GAIN_MIN	(-64)
 #define ADV7343_GAIN_DEF	(0)
 
+#define ADV7343_AUTO_POWER_DOWN_ENABLE	0x10
+
 #endif
diff --git a/include/media/adv7343.h b/include/media/adv7343.h
index e4142b1..d6f8a4e 100644
--- a/include/media/adv7343.h
+++ b/include/media/adv7343.h
@@ -20,44 +20,4 @@
 #define ADV7343_COMPONENT_ID	(1)
 #define ADV7343_SVIDEO_ID	(2)
 
-/**
- * adv7343_power_mode - power mode configuration.
- * @sleep_mode: on enable the current consumption is reduced to micro ampere
- *		level. All DACs and the internal PLL circuit are disabled.
- *		Registers can be read from and written in sleep mode.
- * @pll_control: PLL and oversampling control. This control allows internal
- *		 PLL 1 circuit to be powered down and the oversampling to be
- *		 switched off.
- * @dac: array to configure power on/off DAC's 1..6
- *
- * Power mode register (Register 0x0), for more info refer REGISTER MAP ACCESS
- * section of datasheet[1], table 17 page no 30.
- *
- * [1] http://www.analog.com/static/imported-files/data_sheets/ADV7342_7343.pdf
- */
-struct adv7343_power_mode {
-	bool sleep_mode;
-	bool pll_control;
-	u32 dac[6];
-};
-
-/**
- * struct adv7343_sd_config - SD Only Output Configuration.
- * @sd_dac_out: array configuring SD DAC Outputs 1 and 2
- */
-struct adv7343_sd_config {
-	/* SD only Output Configuration */
-	u32 sd_dac_out[2];
-};
-
-/**
- * struct adv7343_platform_data - Platform data values and access functions.
- * @mode_config: Configuration for power mode.
- * @sd_config: SD Only Configuration.
- */
-struct adv7343_platform_data {
-	struct adv7343_power_mode mode_config;
-	struct adv7343_sd_config sd_config;
-};
-
 #endif				/* End of #ifndef ADV7343_H */
-- 
1.7.9.5

