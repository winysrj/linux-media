Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34417 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbcFVTXE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2016 15:23:04 -0400
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com, tony@atomide.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [RESEND PATCH v2 4/5] ir-rx51: add DT support to driver
Date: Wed, 22 Jun 2016 22:22:20 +0300
Message-Id: <1466623341-30130-5-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1466623341-30130-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <1466623341-30130-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the upcoming removal of legacy boot, lets add support to one of the
last N900 drivers remaining without it. As the driver still uses omap
dmtimer, add auxdata as well.

Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/media/nokia,n900-ir          | 20 ++++++++++++++++++++
 arch/arm/mach-omap2/pdata-quirks.c                   |  6 +-----
 drivers/media/rc/ir-rx51.c                           | 11 ++++++++++-
 3 files changed, 31 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/nokia,n900-ir

diff --git a/Documentation/devicetree/bindings/media/nokia,n900-ir b/Documentation/devicetree/bindings/media/nokia,n900-ir
new file mode 100644
index 0000000..13a18ce
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/nokia,n900-ir
@@ -0,0 +1,20 @@
+Device-Tree bindings for LIRC TX driver for Nokia N900(RX51)
+
+Required properties:
+	- compatible: should be "nokia,n900-ir".
+	- pwms: specifies PWM used for IR signal transmission.
+
+Example node:
+
+	pwm9: dmtimer-pwm@9 {
+		compatible = "ti,omap-dmtimer-pwm";
+		ti,timers = <&timer9>;
+		ti,clock-source = <0x00>; /* timer_sys_ck */
+		#pwm-cells = <3>;
+	};
+
+	ir: n900-ir {
+		compatible = "nokia,n900-ir";
+
+		pwms = <&pwm9 0 26316 0>; /* 38000 Hz */
+	};
diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 278bb8f..0d7b05a 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -273,8 +273,6 @@ static struct platform_device omap3_rom_rng_device = {
 	},
 };
 
-static struct platform_device rx51_lirc_device;
-
 static void __init nokia_n900_legacy_init(void)
 {
 	hsmmc2_internal_input_clk();
@@ -293,10 +291,7 @@ static void __init nokia_n900_legacy_init(void)
 
 		pr_info("RX-51: Registering OMAP3 HWRNG device\n");
 		platform_device_register(&omap3_rom_rng_device);
-
 	}
-
-	platform_device_register(&rx51_lirc_device);
 }
 
 static void __init omap3_tao3530_legacy_init(void)
@@ -531,6 +526,7 @@ static struct of_dev_auxdata omap_auxdata_lookup[] __initdata = {
 		       &omap3_iommu_pdata),
 	OF_DEV_AUXDATA("ti,omap3-hsmmc", 0x4809c000, "4809c000.mmc", &mmc_pdata[0]),
 	OF_DEV_AUXDATA("ti,omap3-hsmmc", 0x480b4000, "480b4000.mmc", &mmc_pdata[1]),
+	OF_DEV_AUXDATA("nokia,n900-ir", 0, "n900-ir", &rx51_lirc_data),
 	/* Only on am3517 */
 	OF_DEV_AUXDATA("ti,davinci_mdio", 0x5c030000, "davinci_mdio.0", NULL),
 	OF_DEV_AUXDATA("ti,am3517-emac", 0x5c000000, "davinci_emac.0",
diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 5096ef3..1cbb43d 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/pwm.h>
+#include <linux/of.h>
 
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
@@ -478,6 +479,14 @@ static int lirc_rx51_remove(struct platform_device *dev)
 	return lirc_unregister_driver(lirc_rx51_driver.minor);
 }
 
+static const struct of_device_id lirc_rx51_match[] = {
+	{
+		.compatible = "nokia,n900-ir",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, lirc_rx51_match);
+
 struct platform_driver lirc_rx51_platform_driver = {
 	.probe		= lirc_rx51_probe,
 	.remove		= lirc_rx51_remove,
@@ -485,7 +494,7 @@ struct platform_driver lirc_rx51_platform_driver = {
 	.resume		= lirc_rx51_resume,
 	.driver		= {
 		.name	= DRIVER_NAME,
-		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(lirc_rx51_match),
 	},
 };
 module_platform_driver(lirc_rx51_platform_driver);
-- 
1.9.1

