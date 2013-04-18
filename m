Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:57467 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936456Ab3DRVf6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:58 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 13/24] ARM: pcm037: convert custom GPIO-based power function to a regulator
Date: Thu, 18 Apr 2013 23:35:34 +0200
Message-Id: <1366320945-21591-14-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a fixed-voltage GPIO-enabled regulator to switch the camera on and off
instead of using a .power() platform callback.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 arch/arm/mach-imx/mach-pcm037.c |   54 ++++++++++++++++++++++++++++-----------
 1 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-imx/mach-pcm037.c b/arch/arm/mach-imx/mach-pcm037.c
index ef55ac1..f138481 100644
--- a/arch/arm/mach-imx/mach-pcm037.c
+++ b/arch/arm/mach-imx/mach-pcm037.c
@@ -288,12 +288,39 @@ static struct at24_platform_data board_eeprom = {
 	.flags = AT24_FLAG_ADDR16,
 };
 
-static int pcm037_camera_power(struct device *dev, int on)
-{
-	/* disable or enable the camera in X7 or X8 PCM970 connector */
-	gpio_set_value(IOMUX_TO_GPIO(MX31_PIN_CSI_D5), !on);
-	return 0;
-}
+/* Fixed 3.3V regulator to be used by cameras */
+static struct regulator_consumer_supply vcc_cam_consumers[] = {
+	REGULATOR_SUPPLY("vcc", "2-005d"),
+};
+
+static struct regulator_init_data vcc_cam_init_data = {
+	.constraints = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies  = ARRAY_SIZE(vcc_cam_consumers),
+	.consumer_supplies      = vcc_cam_consumers,
+};
+
+static struct fixed_voltage_config vcc_cam_info = {
+	.supply_name = "Camera Vcc",
+	.microvolts = 2800000,
+	.gpio = IOMUX_TO_GPIO(MX31_PIN_CSI_D5),
+	.init_data = &vcc_cam_init_data,
+};
+
+static struct platform_device vcc_cam = {
+	.name = "reg-fixed-voltage",
+	.id   = 1,
+	.dev  = {
+		.platform_data = &vcc_cam_info,
+	},
+};
+
+static struct regulator_bulk_data cam_supply[] = {
+	{
+		.supply = "vcc",
+	},
+};
 
 static struct i2c_board_info pcm037_i2c_camera[] = {
 	{
@@ -314,8 +341,11 @@ static struct soc_camera_desc iclink_mt9v022 = {
 
 static struct soc_camera_desc iclink_mt9t031 = {
 	.subdev_desc	= {
-		.sd_pdata.host_priv = &iclink_mt9t031,
-		.power		= pcm037_camera_power,
+		.sd_pdata	= {
+			.num_regulators = ARRAY_SIZE(cam_supply),
+			.regulators = cam_supply,
+			.host_priv = &iclink_mt9t031,
+		},
 	},
 	.host_desc	= {
 		.bus_id		= 0,		/* Must match with the camera ID */
@@ -445,6 +475,7 @@ err:
 static struct platform_device *devices[] __initdata = {
 	&pcm037_flash,
 	&pcm037_sram_device,
+	&vcc_cam,
 	&pcm037_mt9t031,
 	&pcm037_mt9v022,
 };
@@ -656,13 +687,6 @@ static void __init pcm037_init(void)
 	imx31_add_mx3_sdc_fb(&mx3fb_pdata);
 
 	/* CSI */
-	/* Camera power: default - off */
-	ret = gpio_request(IOMUX_TO_GPIO(MX31_PIN_CSI_D5), "mt9t031-power");
-	if (!ret)
-		gpio_direction_output(IOMUX_TO_GPIO(MX31_PIN_CSI_D5), 1);
-	else
-		iclink_mt9t031.subdev_desc.power = NULL;
-
 	pcm037_init_camera();
 
 	pcm970_sja1000_resources[1].start =
-- 
1.7.2.5

