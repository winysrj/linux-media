Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49428 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751383AbZCLTLP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 15:11:15 -0400
Date: Thu, 12 Mar 2009 20:11:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/5] pcm990 baseboard: add camera bus width switch
 setting
In-Reply-To: <20090312141819.GN425@pengutronix.de>
Message-ID: <alpine.DEB.2.00.0903122008160.9725@axis700.grange>
References: <1236857239-2146-1-git-send-email-s.hauer@pengutronix.de> <1236857239-2146-2-git-send-email-s.hauer@pengutronix.de> <1236857239-2146-3-git-send-email-s.hauer@pengutronix.de> <Pine.LNX.4.64.0903121405150.4896@axis700.grange>
 <20090312141819.GN425@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

...one more thing. I noticed, that after patch 2 the cameras would stop 
work, because iclink->gpio would be set to 0. Which would break bisection. 
Ok, this is rather theoretical, still I modified the patches a bit. 
Please, have a look, if you're ok with these changes, that's how I'm going 
to commit them. Affected are patches 2/5 and 5/5. I'm just quoting them 
below.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

>From 80912f8e2bbbf0f81318c68e1bd5f69fc9537795 Mon Sep 17 00:00:00 2001
From: Sascha Hauer <s.hauer@pengutronix.de>
Date: Thu, 12 Mar 2009 20:04:43 +0100
Subject: [PATCH] pcm990 baseboard: add camera bus width switch setting

Some Phytec cameras have a I2C GPIO expander which allows it to
switch between different sensor bus widths. This was previously
handled in the camera driver. Since handling of this switch
varies on several boards the cameras are used on, the board
support seems a better place to handle the switch

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 arch/arm/mach-pxa/pcm990-baseboard.c |   54 ++++++++++++++++++++++++++++-----
 1 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index f46698e..90a3990 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -380,14 +380,50 @@ static struct pca953x_platform_data pca9536_data = {
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
+static int pcm990_camera_set_bus_param(struct soc_camera_link *link,
+		unsigned long flags)
+{
+	if (gpio_bus_switch <= 0) {
+		if (flags == SOCAM_DATAWIDTH_10)
+			return 0;
+		else
+			return -EINVAL;
+	}
+
+	if (flags & SOCAM_DATAWIDTH_8)
+		gpio_set_value(gpio_bus_switch, 1);
+	else
+		gpio_set_value(gpio_bus_switch, 0);
+
+	return 0;
+}
+
+static unsigned long pcm990_camera_query_bus_param(struct soc_camera_link *link)
+{
+	int ret;
+
+	if (!gpio_bus_switch) {
+		ret = gpio_request(NR_BUILTIN_GPIO + 1, "camera");
+		if (!ret) {
+			gpio_bus_switch = NR_BUILTIN_GPIO + 1;
+			gpio_direction_output(gpio_bus_switch, 0);
+		} else
+			gpio_bus_switch = -EINVAL;
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
+	.gpio = NR_BUILTIN_GPIO + 1,
+	.query_bus_param = pcm990_camera_query_bus_param,
+	.set_bus_param = pcm990_camera_set_bus_param,
 };
 
 /* Board I2C devices. */
@@ -398,10 +434,10 @@ static struct i2c_board_info __initdata pcm990_i2c_devices[] = {
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
1.5.4


>From 2d9b3eb219c391f9d626ae63835c8224ea8ef10e Mon Sep 17 00:00:00 2001
From: Sascha Hauer <s.hauer@pengutronix.de>
Date: Thu, 12 Mar 2009 20:06:01 +0100
Subject: [PATCH] soc-camera: remove now unused gpio member of struct soc_camera_link

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 arch/arm/mach-pxa/pcm990-baseboard.c |    1 -
 include/media/soc_camera.h           |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index 90a3990..6112740 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -421,7 +421,6 @@ static unsigned long pcm990_camera_query_bus_param(struct soc_camera_link *link)
 
 static struct soc_camera_link iclink = {
 	.bus_id	= 0, /* Must match with the camera ID above */
-	.gpio = NR_BUILTIN_GPIO + 1,
 	.query_bus_param = pcm990_camera_query_bus_param,
 	.set_bus_param = pcm990_camera_set_bus_param,
 };
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index b44fa09..3701368 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -95,8 +95,6 @@ struct soc_camera_host_ops {
 struct soc_camera_link {
 	/* Camera bus id, used to match a camera and a bus */
 	int bus_id;
-	/* GPIO number to switch between 8 and 10 bit modes */
-	unsigned int gpio;
 	/* Per camera SOCAM_SENSOR_* bus flags */
 	unsigned long flags;
 	/* Optional callbacks to power on or off and reset the sensor */
-- 
1.5.4

