Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41295 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbZCKKHU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 06:07:20 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/4] pcm990 baseboard: add camera bus width switch setting
Date: Wed, 11 Mar 2009 11:06:14 +0100
Message-Id: <1236765976-20581-3-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1236765976-20581-2-git-send-email-s.hauer@pengutronix.de>
References: <1236765976-20581-1-git-send-email-s.hauer@pengutronix.de>
 <1236765976-20581-2-git-send-email-s.hauer@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some Phytec cameras have a I2C GPIO expander which allows it to
switch between different sensor bus widths. This was previously
handled in the camera driver. Since handling of this switch
varies on several boards the cameras are used on, the board
support seems a better place to handle the switch

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/mach-pxa/pcm990-baseboard.c |   50 +++++++++++++++++++++++++++------
 1 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index 34841c7..e9feb89 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -381,14 +381,46 @@ static struct pca953x_platform_data pca9536_data = {
 	.gpio_base	= NR_BUILTIN_GPIO + 1,
 };
 
-static struct soc_camera_link iclink[] = {
-	{
-		.bus_id	= 0, /* Must match with the camera ID above */
-		.gpio	= NR_BUILTIN_GPIO + 1,
-	}, {
-		.bus_id	= 0, /* Must match with the camera ID above */
-		.gpio	= -ENXIO,
+static int gpio_bus_switch;
+
+static int pcm990_camera_set_bus_param(struct device *dev,
+		unsigned long flags)
+{
+	if (gpio_bus_switch <= 0)
+		return 0;
+
+	if (flags & SOCAM_DATAWIDTH_8)
+		gpio_set_value(NR_BUILTIN_GPIO + 1, 1);
+	else
+		gpio_set_value(NR_BUILTIN_GPIO + 1, 0);
+
+	return 0;
+}
+
+static unsigned long pcm990_camera_query_bus_param(struct device *dev)
+{
+	int ret;
+
+	if (!gpio_bus_switch) {
+		ret = gpio_request(NR_BUILTIN_GPIO + 1, "camera");
+		if (!ret) {
+			gpio_bus_switch = NR_BUILTIN_GPIO + 1;
+			gpio_direction_output(gpio_bus_switch, 0);
+		} else
+			gpio_bus_switch = -1;
 	}
+
+	if (gpio_bus_switch > 0)
+		return SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_10;
+	else
+		return SOCAM_DATAWIDTH_10;
+}
+
+static struct soc_camera_link iclink = {
+	.bus_id	= 0, /* Must match with the camera ID above */
+	.query_bus_param = pcm990_camera_query_bus_param,
+	.set_bus_param = pcm990_camera_set_bus_param,
+	.gpio	= NR_BUILTIN_GPIO + 1,
 };
 
 /* Board I2C devices. */
@@ -399,10 +431,10 @@ static struct i2c_board_info __initdata pcm990_i2c_devices[] = {
 		.platform_data = &pca9536_data,
 	}, {
 		I2C_BOARD_INFO("mt9v022", 0x48),
-		.platform_data = &iclink[0], /* With extender */
+		.platform_data = &iclink, /* With extender */
 	}, {
 		I2C_BOARD_INFO("mt9m001", 0x5d),
-		.platform_data = &iclink[0], /* With extender */
+		.platform_data = &iclink, /* With extender */
 	},
 };
 #endif /* CONFIG_VIDEO_PXA27x ||CONFIG_VIDEO_PXA27x_MODULE */
-- 
1.5.6.5

