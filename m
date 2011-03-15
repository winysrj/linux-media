Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:48202 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870Ab1CON7o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 09:59:44 -0400
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v17 11/13] davinci: dm644x: move vpfe init from soc to board specific files
Date: Tue, 15 Mar 2011 19:29:27 +0530
Message-Id: <1300197567-4903-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Move all vpfe platform device registrations to the board specific
file like the rest of the devices, and have all of them together.

This would remove the  restriction of inclusion and registration of
vpfe platform devices for non-vpfe boards.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 arch/arm/mach-davinci/board-dm644x-evm.c    |    3 +-
 arch/arm/mach-davinci/dm644x.c              |   29 +++++++++++++++-----------
 arch/arm/mach-davinci/include/mach/dm644x.h |    2 +-
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 6919f28..d1542b1 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -628,8 +628,6 @@ static struct davinci_uart_config uart_config __initdata = {
 static void __init
 davinci_evm_map_io(void)
 {
-	/* setup input configuration for VPFE input devices */
-	dm644x_set_vpfe_config(&dm644xevm_capture_cfg);
 	dm644x_init();
 }
 
@@ -701,6 +699,7 @@ static __init void davinci_evm_init(void)
 	evm_init_i2c();
 
 	davinci_setup_mmc(0, &dm6446evm_mmc_config);
+	dm644x_init_video(&dm644xevm_capture_cfg);
 
 	davinci_serial_init(&uart_config);
 	dm644x_init_asp(&dm644x_evm_snd_data);
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 8ff5d5f..41e8866 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -651,11 +651,6 @@ static struct platform_device dm644x_vpfe_dev = {
 	},
 };
 
-void dm644x_set_vpfe_config(struct vpfe_config *cfg)
-{
-	dm644x_vpfe_dev.dev.platform_data = cfg;
-}
-
 /*----------------------------------------------------------------------*/
 
 static struct map_desc dm644x_io_desc[] = {
@@ -784,14 +779,28 @@ void __init dm644x_init(void)
 	davinci_map_sysmod();
 }
 
+static struct platform_device *dm644x_video_devices[] __initdata = {
+	&dm644x_vpss_device,
+	&dm644x_ccdc_dev,
+	&dm644x_vpfe_dev,
+};
+
+int __init dm644x_init_video(struct vpfe_config *vpfe_cfg)
+{
+	dm644x_vpfe_dev.dev.platform_data = vpfe_cfg;
+	/* Add ccdc clock aliases */
+	clk_add_alias("master", dm644x_ccdc_dev.name, "vpss_master", NULL);
+	clk_add_alias("slave", dm644x_ccdc_dev.name, "vpss_slave", NULL);
+	platform_add_devices(dm644x_video_devices,
+				ARRAY_SIZE(dm644x_video_devices));
+	return 0;
+}
+
 static int __init dm644x_init_devices(void)
 {
 	if (!cpu_is_davinci_dm644x())
 		return 0;
 
-	/* Add ccdc clock aliases */
-	clk_add_alias("master", dm644x_ccdc_dev.name, "vpss_master", NULL);
-	clk_add_alias("slave", dm644x_ccdc_dev.name, "vpss_slave", NULL);
 	platform_device_register(&dm644x_edma_device);
 
 	platform_device_register(&dm644x_mdio_device);
@@ -799,10 +808,6 @@ static int __init dm644x_init_devices(void)
 	clk_add_alias(NULL, dev_name(&dm644x_mdio_device.dev),
 		      NULL, &dm644x_emac_device.dev);
 
-	platform_device_register(&dm644x_vpss_device);
-	platform_device_register(&dm644x_ccdc_dev);
-	platform_device_register(&dm644x_vpfe_dev);
-
 	return 0;
 }
 postcore_initcall(dm644x_init_devices);
diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-davinci/include/mach/dm644x.h
index 5a1b26d..29a9e24 100644
--- a/arch/arm/mach-davinci/include/mach/dm644x.h
+++ b/arch/arm/mach-davinci/include/mach/dm644x.h
@@ -42,6 +42,6 @@
 
 void __init dm644x_init(void);
 void __init dm644x_init_asp(struct snd_platform_data *pdata);
-void dm644x_set_vpfe_config(struct vpfe_config *cfg);
+int __init dm644x_init_video(struct vpfe_config *);
 
 #endif /* __ASM_ARCH_DM644X_H */
-- 
1.6.2.4

