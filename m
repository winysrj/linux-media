Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:51197 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752729AbeDBO2h (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 10:28:37 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>,
        Nicolas Pitre <nico@fluxnic.net>,
        Samuel Ortiz <samuel@sortiz.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org
Subject: [PATCH 14/15] ARM: pxa: change SSP devices allocation
Date: Mon,  2 Apr 2018 16:26:55 +0200
Message-Id: <20180402142656.26815-15-robert.jarzmik@free.fr>
In-Reply-To: <20180402142656.26815-1-robert.jarzmik@free.fr>
References: <20180402142656.26815-1-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to prepare for the dma_slave_map change for SSP DMA channels
allocation, the SSP platform devices will now include a platform data
structure which in turn selects which dma channel has to be used for
data transfers, especially the PCM ones.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 arch/arm/mach-pxa/devices.c            | 78 +++++++++++++++++++++++++++++-----
 arch/arm/mach-pxa/devices.h            | 14 ++----
 arch/arm/mach-pxa/include/mach/audio.h | 12 ++++++
 arch/arm/mach-pxa/pxa25x.c             |  4 +-
 arch/arm/mach-pxa/pxa27x.c             |  4 +-
 arch/arm/mach-pxa/pxa3xx.c             |  5 +--
 6 files changed, 86 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mach-pxa/devices.c b/arch/arm/mach-pxa/devices.c
index c0b3c90fd67f..955d255dc4f4 100644
--- a/arch/arm/mach-pxa/devices.c
+++ b/arch/arm/mach-pxa/devices.c
@@ -481,6 +481,17 @@ void __init pxa_set_ac97_info(pxa2xx_audio_ops_t *ops)
 	pxa_register_device(&pxa_device_ac97, ops);
 }
 
+static struct pxa_ssp_info pxa_ssp_infos[] = {
+	{ .dma_chan_rx_name = "ssp1_rx", .dma_chan_tx_name = "ssp1_tx", },
+	{ .dma_chan_rx_name = "ssp1_rx", .dma_chan_tx_name = "ssp1_tx", },
+	{ .dma_chan_rx_name = "ssp2_rx", .dma_chan_tx_name = "ssp2_tx", },
+	{ .dma_chan_rx_name = "ssp2_rx", .dma_chan_tx_name = "ssp2_tx", },
+	{ .dma_chan_rx_name = "ssp3_rx", .dma_chan_tx_name = "ssp3_tx", },
+	{ .dma_chan_rx_name = "ssp3_rx", .dma_chan_tx_name = "ssp3_tx", },
+	{ .dma_chan_rx_name = "ssp4_rx", .dma_chan_tx_name = "ssp4_tx", },
+	{ .dma_chan_rx_name = "ssp4_rx", .dma_chan_tx_name = "ssp4_tx", },
+};
+
 #ifdef CONFIG_PXA25x
 
 static struct resource pxa25x_resource_pwm0[] = {
@@ -528,7 +539,7 @@ static struct resource pxa25x_resource_ssp[] = {
 	},
 };
 
-struct platform_device pxa25x_device_ssp = {
+static struct platform_device pxa25x_device_ssp = {
 	.name		= "pxa25x-ssp",
 	.id		= 0,
 	.dev		= {
@@ -554,7 +565,7 @@ static struct resource pxa25x_resource_nssp[] = {
 	},
 };
 
-struct platform_device pxa25x_device_nssp = {
+static struct platform_device pxa25x_device_nssp = {
 	.name		= "pxa25x-nssp",
 	.id		= 1,
 	.dev		= {
@@ -580,7 +591,7 @@ static struct resource pxa25x_resource_assp[] = {
 	},
 };
 
-struct platform_device pxa25x_device_assp = {
+static struct platform_device pxa25x_device_assp = {
 	/* ASSP is basically equivalent to NSSP */
 	.name		= "pxa25x-nssp",
 	.id		= 2,
@@ -591,6 +602,22 @@ struct platform_device pxa25x_device_assp = {
 	.resource	= pxa25x_resource_assp,
 	.num_resources	= ARRAY_SIZE(pxa25x_resource_assp),
 };
+
+static struct platform_device *pxa25x_device_ssps[] = {
+	&pxa25x_device_ssp,
+	&pxa25x_device_nssp,
+	&pxa25x_device_assp,
+};
+
+void __init pxa25x_set_ssp_info(void)
+{
+	int ssp;
+
+	for (ssp = 0; ssp < ARRAY_SIZE(pxa25x_device_ssps); ssp++)
+		pxa_register_device(pxa25x_device_ssps[ssp],
+				    &pxa_ssp_infos[ssp]);
+}
+
 #endif /* CONFIG_PXA25x */
 
 #if defined(CONFIG_PXA27x) || defined(CONFIG_PXA3xx)
@@ -698,7 +725,7 @@ static struct resource pxa27x_resource_ssp1[] = {
 	},
 };
 
-struct platform_device pxa27x_device_ssp1 = {
+static struct platform_device pxa27x_device_ssp1 = {
 	.name		= "pxa27x-ssp",
 	.id		= 0,
 	.dev		= {
@@ -724,7 +751,7 @@ static struct resource pxa27x_resource_ssp2[] = {
 	},
 };
 
-struct platform_device pxa27x_device_ssp2 = {
+static struct platform_device pxa27x_device_ssp2 = {
 	.name		= "pxa27x-ssp",
 	.id		= 1,
 	.dev		= {
@@ -750,7 +777,7 @@ static struct resource pxa27x_resource_ssp3[] = {
 	},
 };
 
-struct platform_device pxa27x_device_ssp3 = {
+static struct platform_device pxa27x_device_ssp3 = {
 	.name		= "pxa27x-ssp",
 	.id		= 2,
 	.dev		= {
@@ -761,6 +788,21 @@ struct platform_device pxa27x_device_ssp3 = {
 	.num_resources	= ARRAY_SIZE(pxa27x_resource_ssp3),
 };
 
+static struct platform_device *pxa27x_device_ssps[] = {
+	&pxa27x_device_ssp1,
+	&pxa27x_device_ssp2,
+	&pxa27x_device_ssp3,
+};
+
+void __init pxa27x_set_ssp_info(void)
+{
+	int ssp;
+
+	for (ssp = 0; ssp < ARRAY_SIZE(pxa27x_device_ssps); ssp++)
+		pxa_register_device(pxa27x_device_ssps[ssp],
+				    &pxa_ssp_infos[ssp]);
+}
+
 static struct resource pxa27x_resource_pwm0[] = {
 	[0] = {
 		.start	= 0x40b00000,
@@ -951,7 +993,7 @@ static struct resource pxa3xx_resource_ssp4[] = {
  * make the driver set the correct internal type, hence we provide specific
  * platform_devices for each of them.
  */
-struct platform_device pxa3xx_device_ssp1 = {
+static struct platform_device pxa3xx_device_ssp1 = {
 	.name		= "pxa3xx-ssp",
 	.id		= 0,
 	.dev		= {
@@ -962,7 +1004,7 @@ struct platform_device pxa3xx_device_ssp1 = {
 	.num_resources	= ARRAY_SIZE(pxa27x_resource_ssp1),
 };
 
-struct platform_device pxa3xx_device_ssp2 = {
+static struct platform_device pxa3xx_device_ssp2 = {
 	.name		= "pxa3xx-ssp",
 	.id		= 1,
 	.dev		= {
@@ -973,7 +1015,7 @@ struct platform_device pxa3xx_device_ssp2 = {
 	.num_resources	= ARRAY_SIZE(pxa27x_resource_ssp2),
 };
 
-struct platform_device pxa3xx_device_ssp3 = {
+static struct platform_device pxa3xx_device_ssp3 = {
 	.name		= "pxa3xx-ssp",
 	.id		= 2,
 	.dev		= {
@@ -984,7 +1026,7 @@ struct platform_device pxa3xx_device_ssp3 = {
 	.num_resources	= ARRAY_SIZE(pxa27x_resource_ssp3),
 };
 
-struct platform_device pxa3xx_device_ssp4 = {
+static struct platform_device pxa3xx_device_ssp4 = {
 	.name		= "pxa3xx-ssp",
 	.id		= 3,
 	.dev		= {
@@ -994,6 +1036,22 @@ struct platform_device pxa3xx_device_ssp4 = {
 	.resource	= pxa3xx_resource_ssp4,
 	.num_resources	= ARRAY_SIZE(pxa3xx_resource_ssp4),
 };
+
+static struct platform_device *pxa3xx_device_ssps[] = {
+	&pxa3xx_device_ssp1,
+	&pxa3xx_device_ssp2,
+	&pxa3xx_device_ssp3,
+	&pxa3xx_device_ssp4,
+};
+
+void __init pxa3xx_set_ssp_info(void)
+{
+	int ssp;
+
+	for (ssp = 0; ssp < ARRAY_SIZE(pxa3xx_device_ssps); ssp++)
+		pxa_register_device(pxa3xx_device_ssps[ssp],
+				    &pxa_ssp_infos[ssp]);
+}
 #endif /* CONFIG_PXA3xx */
 
 struct resource pxa_resource_gpio[] = {
diff --git a/arch/arm/mach-pxa/devices.h b/arch/arm/mach-pxa/devices.h
index 11263f7c455b..5909805e7d84 100644
--- a/arch/arm/mach-pxa/devices.h
+++ b/arch/arm/mach-pxa/devices.h
@@ -22,17 +22,6 @@ extern struct platform_device pxa27x_device_i2c_power;
 extern struct platform_device pxa27x_device_ohci;
 extern struct platform_device pxa27x_device_keypad;
 
-extern struct platform_device pxa25x_device_ssp;
-extern struct platform_device pxa25x_device_nssp;
-extern struct platform_device pxa25x_device_assp;
-extern struct platform_device pxa27x_device_ssp1;
-extern struct platform_device pxa27x_device_ssp2;
-extern struct platform_device pxa27x_device_ssp3;
-extern struct platform_device pxa3xx_device_ssp1;
-extern struct platform_device pxa3xx_device_ssp2;
-extern struct platform_device pxa3xx_device_ssp3;
-extern struct platform_device pxa3xx_device_ssp4;
-
 extern struct platform_device pxa25x_device_pwm0;
 extern struct platform_device pxa25x_device_pwm1;
 extern struct platform_device pxa27x_device_pwm0;
@@ -65,3 +54,6 @@ extern void pxa27x_set_i2c_power_info(struct i2c_pxa_platform_data *info);
 #ifdef CONFIG_PXA3xx
 extern void pxa3xx_set_i2c_power_info(struct i2c_pxa_platform_data *info);
 #endif
+void pxa25x_set_ssp_info(void);
+void pxa27x_set_ssp_info(void);
+void pxa3xx_set_ssp_info(void);
diff --git a/arch/arm/mach-pxa/include/mach/audio.h b/arch/arm/mach-pxa/include/mach/audio.h
index 7beebf7297b5..f1f6bc7673a1 100644
--- a/arch/arm/mach-pxa/include/mach/audio.h
+++ b/arch/arm/mach-pxa/include/mach/audio.h
@@ -28,4 +28,16 @@ typedef struct {
 
 extern void pxa_set_ac97_info(pxa2xx_audio_ops_t *ops);
 
+/*
+ * struct pxa_ssp_info - platform data for SSP devices
+ * @dma_chan_rx_name: name of the receive dma channel to query, see
+ *		      pxa_slave_map
+ * @dma_chan_tx_name: name of the transmit dma channel to query, see
+ *		      pxa_slave_map
+ */
+struct pxa_ssp_info {
+	const char *dma_chan_rx_name;
+	const char *dma_chan_tx_name;
+};
+
 #endif
diff --git a/arch/arm/mach-pxa/pxa25x.c b/arch/arm/mach-pxa/pxa25x.c
index ba431fad5c47..74779afbf200 100644
--- a/arch/arm/mach-pxa/pxa25x.c
+++ b/arch/arm/mach-pxa/pxa25x.c
@@ -193,9 +193,6 @@ static struct platform_device *pxa25x_devices[] __initdata = {
 	&pxa_device_pmu,
 	&pxa_device_i2s,
 	&sa1100_device_rtc,
-	&pxa25x_device_ssp,
-	&pxa25x_device_nssp,
-	&pxa25x_device_assp,
 	&pxa25x_device_pwm0,
 	&pxa25x_device_pwm1,
 	&pxa_device_asoc_platform,
@@ -219,6 +216,7 @@ static int __init pxa25x_init(void)
 			pxa_register_device(&pxa25x_device_gpio, &pxa25x_gpio_info);
 			ret = platform_add_devices(pxa25x_devices,
 						   ARRAY_SIZE(pxa25x_devices));
+			pxa25x_set_ssp_info();
 		}
 	}
 
diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
index 0c06f383ad52..f3896d164fd3 100644
--- a/arch/arm/mach-pxa/pxa27x.c
+++ b/arch/arm/mach-pxa/pxa27x.c
@@ -290,9 +290,6 @@ static struct platform_device *devices[] __initdata = {
 	&pxa_device_asoc_ssp3,
 	&pxa_device_asoc_platform,
 	&pxa_device_rtc,
-	&pxa27x_device_ssp1,
-	&pxa27x_device_ssp2,
-	&pxa27x_device_ssp3,
 	&pxa27x_device_pwm0,
 	&pxa27x_device_pwm1,
 };
@@ -313,6 +310,7 @@ static int __init pxa27x_init(void)
 		if (!of_have_populated_dt()) {
 			pxa_register_device(&pxa27x_device_gpio,
 					    &pxa27x_gpio_info);
+			pxa27x_set_ssp_info();
 			pxa2xx_set_dmac_info(32, 75);
 			ret = platform_add_devices(devices,
 						   ARRAY_SIZE(devices));
diff --git a/arch/arm/mach-pxa/pxa3xx.c b/arch/arm/mach-pxa/pxa3xx.c
index 4b8a0df8ea57..2a5044dd463e 100644
--- a/arch/arm/mach-pxa/pxa3xx.c
+++ b/arch/arm/mach-pxa/pxa3xx.c
@@ -413,10 +413,6 @@ static struct platform_device *devices[] __initdata = {
 	&pxa_device_asoc_ssp4,
 	&pxa_device_asoc_platform,
 	&pxa_device_rtc,
-	&pxa3xx_device_ssp1,
-	&pxa3xx_device_ssp2,
-	&pxa3xx_device_ssp3,
-	&pxa3xx_device_ssp4,
 	&pxa27x_device_pwm0,
 	&pxa27x_device_pwm1,
 };
@@ -456,6 +452,7 @@ static int __init pxa3xx_init(void)
 		ret = platform_add_devices(devices, ARRAY_SIZE(devices));
 		if (ret)
 			return ret;
+		pxa3xx_set_ssp_info();
 		if (cpu_is_pxa300() || cpu_is_pxa310() || cpu_is_pxa320()) {
 			platform_device_add_data(&pxa3xx_device_gpio,
 						 &pxa3xx_gpio_pdata,
-- 
2.11.0
