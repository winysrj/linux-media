Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:41717 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab0IKB3Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 21:29:24 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: linux-media@vger.kernel.org,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: [PATCH v2 6/6] OMAP1: Amstrad Delta: add camera controlled LEDS trigger
Date: Sat, 11 Sep 2010 03:28:58 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Tony Lindgren <tony@atomide.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201009110317.54899.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009110329.01171.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

This patch extends the Amstrad Delta camera support with LEDS trigger that can 
be used for automatic control of the on-board camera LED. The led turns on 
automatically on camera device open and turns off on camera device close.

Created and tested against linux-2.6.36-rc3.

Works on top of patch 5/6, "OMAP1: Amstrad Delta: add support for on-board 
camera"

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
Having no comments received on v1 of this patch, I assume nobody could see any 
benefit if I implemented this idea at the SoC camera or OMAP1 camera level, 
so I'm leaveing it as an Amstrad Delta only feature, as it originally was for 
v1.

Thanks,
Janusz


v1->v2 changes:
- no functional changes,
- refreshed against linux-2.6.36-rc3.


 arch/arm/mach-omap1/board-ams-delta.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)


diff -upr linux-2.6.36-rc3.orig/arch/arm/mach-omap1/board-ams-delta.c 
linux-2.6.36-rc3/arch/arm/mach-omap1/board-ams-delta.c
--- linux-2.6.36-rc3.orig/arch/arm/mach-omap1/board-ams-delta.c	2010-09-10 22:01:24.000000000 +0200
+++ linux-2.6.36-rc3/arch/arm/mach-omap1/board-ams-delta.c	2010-09-10 22:08:29.000000000 +0200
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
+#include <linux/leds.h>
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
 
@@ -222,11 +223,30 @@ static struct i2c_board_info ams_delta_c
 	},
 };
 
+#ifdef CONFIG_LEDS_TRIGGERS
+DEFINE_LED_TRIGGER(ams_delta_camera_led_trigger);
+
+static int ams_delta_camera_power(struct device *dev, int power)
+{
+	/*
+	 * turn on camera LED
+	 */
+	if (power)
+		led_trigger_event(ams_delta_camera_led_trigger, LED_FULL);
+	else
+		led_trigger_event(ams_delta_camera_led_trigger, LED_OFF);
+	return 0;
+}
+#else
+#define ams_delta_camera_power	NULL
+#endif
+
 static struct soc_camera_link __initdata ams_delta_iclink = {
 	.bus_id         = 0,	/* OMAP1 SoC camera bus */
 	.i2c_adapter_id = 1,
 	.board_info     = &ams_delta_camera_board_info[0],
 	.module_name    = "ov6650",
+	.power		= ams_delta_camera_power,
 };
 
 static struct platform_device ams_delta_camera_device = {
@@ -281,6 +301,10 @@ static void __init ams_delta_init(void)
 
 	omap1_usb_init(&ams_delta_usb_config);
 	omap1_set_camera_info(&ams_delta_camera_platform_data);
+#ifdef CONFIG_LEDS_TRIGGERS
+	led_trigger_register_simple("ams_delta_camera",
+			&ams_delta_camera_led_trigger);
+#endif
 	platform_add_devices(ams_delta_devices, ARRAY_SIZE(ams_delta_devices));
 
 #ifdef CONFIG_AMS_DELTA_FIQ
