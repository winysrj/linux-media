Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:58350 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934290AbeFQRDB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Jun 2018 13:03:01 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Nicolas Pitre <nico@fluxnic.net>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH v3 02/14] ARM: pxa: add dma slave map
Date: Sun, 17 Jun 2018 19:02:05 +0200
Message-Id: <20180617170217.24177-3-robert.jarzmik@free.fr>
In-Reply-To: <20180617170217.24177-1-robert.jarzmik@free.fr>
References: <20180617170217.24177-1-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to remove the specific knowledge of the dma mapping from PXA
drivers, add a default slave map for pxa architectures.

This is the first step, and once all drivers are converted,
pxad_filter_fn() will be made static, and the DMA resources removed from
device.c.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Reported-by: Arnd Bergmann <arnd@arndb.de>
---
Since v1: revamped the SSP part, split into pxa25.c, pxa27x.c and
          pxa3xx.c, and add pxa-i2s.
---
 arch/arm/mach-pxa/devices.c | 12 +++---------
 arch/arm/mach-pxa/devices.h |  6 +++++-
 arch/arm/mach-pxa/pxa25x.c  | 38 +++++++++++++++++++++++++++++++++++++-
 arch/arm/mach-pxa/pxa27x.c  | 39 ++++++++++++++++++++++++++++++++++++++-
 arch/arm/mach-pxa/pxa3xx.c  | 41 ++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 123 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-pxa/devices.c b/arch/arm/mach-pxa/devices.c
index d7c9a8476d57..1e8915fc340d 100644
--- a/arch/arm/mach-pxa/devices.c
+++ b/arch/arm/mach-pxa/devices.c
@@ -4,6 +4,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
 #include <linux/spi/pxa2xx_spi.h>
 #include <linux/platform_data/i2c-pxa.h>
 
@@ -1202,11 +1203,6 @@ void __init pxa2xx_set_spi_info(unsigned id, struct pxa2xx_spi_master *info)
 	platform_device_add(pd);
 }
 
-static struct mmp_dma_platdata pxa_dma_pdata = {
-	.dma_channels	= 0,
-	.nb_requestors	= 0,
-};
-
 static struct resource pxa_dma_resource[] = {
 	[0] = {
 		.start	= 0x40000000,
@@ -1233,9 +1229,7 @@ static struct platform_device pxa2xx_pxa_dma = {
 	.resource	= pxa_dma_resource,
 };
 
-void __init pxa2xx_set_dmac_info(int nb_channels, int nb_requestors)
+void __init pxa2xx_set_dmac_info(struct mmp_dma_platdata *dma_pdata)
 {
-	pxa_dma_pdata.dma_channels = nb_channels;
-	pxa_dma_pdata.nb_requestors = nb_requestors;
-	pxa_register_device(&pxa2xx_pxa_dma, &pxa_dma_pdata);
+	pxa_register_device(&pxa2xx_pxa_dma, dma_pdata);
 }
diff --git a/arch/arm/mach-pxa/devices.h b/arch/arm/mach-pxa/devices.h
index 11263f7c455b..498b07bc6a3e 100644
--- a/arch/arm/mach-pxa/devices.h
+++ b/arch/arm/mach-pxa/devices.h
@@ -1,4 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#define PDMA_FILTER_PARAM(_prio, _requestor) (&(struct pxad_param) { \
+	.prio = PXAD_PRIO_##_prio, .drcmr = _requestor })
+struct mmp_dma_platdata;
+
 extern struct platform_device pxa_device_pmu;
 extern struct platform_device pxa_device_mci;
 extern struct platform_device pxa3xx_device_mci2;
@@ -55,7 +59,7 @@ extern struct platform_device pxa3xx_device_gpio;
 extern struct platform_device pxa93x_device_gpio;
 
 void __init pxa_register_device(struct platform_device *dev, void *data);
-void __init pxa2xx_set_dmac_info(int nb_channels, int nb_requestors);
+void __init pxa2xx_set_dmac_info(struct mmp_dma_platdata *dma_pdata);
 
 struct i2c_pxa_platform_data;
 extern void pxa_set_i2c_info(struct i2c_pxa_platform_data *info);
diff --git a/arch/arm/mach-pxa/pxa25x.c b/arch/arm/mach-pxa/pxa25x.c
index ba431fad5c47..ab8808ce7e21 100644
--- a/arch/arm/mach-pxa/pxa25x.c
+++ b/arch/arm/mach-pxa/pxa25x.c
@@ -16,6 +16,8 @@
  * initialization stuff for PXA machines which can be overridden later if
  * need be.
  */
+#include <linux/dmaengine.h>
+#include <linux/dma/pxa-dma.h>
 #include <linux/gpio.h>
 #include <linux/gpio-pxa.h>
 #include <linux/module.h>
@@ -26,6 +28,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/irq.h>
 #include <linux/irqchip.h>
+#include <linux/platform_data/mmp_dma.h>
 
 #include <asm/mach/map.h>
 #include <asm/suspend.h>
@@ -201,6 +204,39 @@ static struct platform_device *pxa25x_devices[] __initdata = {
 	&pxa_device_asoc_platform,
 };
 
+static const struct dma_slave_map pxa25x_slave_map[] = {
+	/* PXA25x, PXA27x and PXA3xx common entries */
+	{ "pxa2xx-ac97", "pcm_pcm_mic_mono", PDMA_FILTER_PARAM(LOWEST, 8) },
+	{ "pxa2xx-ac97", "pcm_pcm_aux_mono_in", PDMA_FILTER_PARAM(LOWEST, 9) },
+	{ "pxa2xx-ac97", "pcm_pcm_aux_mono_out",
+	  PDMA_FILTER_PARAM(LOWEST, 10) },
+	{ "pxa2xx-ac97", "pcm_pcm_stereo_in", PDMA_FILTER_PARAM(LOWEST, 11) },
+	{ "pxa2xx-ac97", "pcm_pcm_stereo_out", PDMA_FILTER_PARAM(LOWEST, 12) },
+	{ "pxa-ssp-dai.1", "rx", PDMA_FILTER_PARAM(LOWEST, 13) },
+	{ "pxa-ssp-dai.1", "tx", PDMA_FILTER_PARAM(LOWEST, 14) },
+	{ "pxa-ssp-dai.2", "rx", PDMA_FILTER_PARAM(LOWEST, 15) },
+	{ "pxa-ssp-dai.2", "tx", PDMA_FILTER_PARAM(LOWEST, 16) },
+	{ "pxa2xx-ir", "rx", PDMA_FILTER_PARAM(LOWEST, 17) },
+	{ "pxa2xx-ir", "tx", PDMA_FILTER_PARAM(LOWEST, 18) },
+	{ "pxa2xx-mci.0", "rx", PDMA_FILTER_PARAM(LOWEST, 21) },
+	{ "pxa2xx-mci.0", "tx", PDMA_FILTER_PARAM(LOWEST, 22) },
+
+	/* PXA25x specific map */
+	{ "pxa25x-ssp.0", "rx", PDMA_FILTER_PARAM(LOWEST, 13) },
+	{ "pxa25x-ssp.0", "tx", PDMA_FILTER_PARAM(LOWEST, 14) },
+	{ "pxa25x-nssp.1", "rx", PDMA_FILTER_PARAM(LOWEST, 15) },
+	{ "pxa25x-nssp.1", "tx", PDMA_FILTER_PARAM(LOWEST, 16) },
+	{ "pxa25x-nssp.2", "rx", PDMA_FILTER_PARAM(LOWEST, 23) },
+	{ "pxa25x-nssp.2", "tx", PDMA_FILTER_PARAM(LOWEST, 24) },
+};
+
+static struct mmp_dma_platdata pxa25x_dma_pdata = {
+	.dma_channels	= 16,
+	.nb_requestors	= 40,
+	.slave_map	= pxa25x_slave_map,
+	.slave_map_cnt	= ARRAY_SIZE(pxa25x_slave_map),
+};
+
 static int __init pxa25x_init(void)
 {
 	int ret = 0;
@@ -215,7 +251,7 @@ static int __init pxa25x_init(void)
 		register_syscore_ops(&pxa2xx_mfp_syscore_ops);
 
 		if (!of_have_populated_dt()) {
-			pxa2xx_set_dmac_info(16, 40);
+			pxa2xx_set_dmac_info(&pxa25x_dma_pdata);
 			pxa_register_device(&pxa25x_device_gpio, &pxa25x_gpio_info);
 			ret = platform_add_devices(pxa25x_devices,
 						   ARRAY_SIZE(pxa25x_devices));
diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
index 0c06f383ad52..5a8990a9313d 100644
--- a/arch/arm/mach-pxa/pxa27x.c
+++ b/arch/arm/mach-pxa/pxa27x.c
@@ -11,6 +11,8 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/dmaengine.h>
+#include <linux/dma/pxa-dma.h>
 #include <linux/gpio.h>
 #include <linux/gpio-pxa.h>
 #include <linux/module.h>
@@ -23,6 +25,7 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/platform_data/i2c-pxa.h>
+#include <linux/platform_data/mmp_dma.h>
 
 #include <asm/mach/map.h>
 #include <mach/hardware.h>
@@ -297,6 +300,40 @@ static struct platform_device *devices[] __initdata = {
 	&pxa27x_device_pwm1,
 };
 
+static const struct dma_slave_map pxa27x_slave_map[] = {
+	/* PXA25x, PXA27x and PXA3xx common entries */
+	{ "pxa2xx-ac97", "pcm_pcm_mic_mono", PDMA_FILTER_PARAM(LOWEST, 8) },
+	{ "pxa2xx-ac97", "pcm_pcm_aux_mono_in", PDMA_FILTER_PARAM(LOWEST, 9) },
+	{ "pxa2xx-ac97", "pcm_pcm_aux_mono_out",
+	  PDMA_FILTER_PARAM(LOWEST, 10) },
+	{ "pxa2xx-ac97", "pcm_pcm_stereo_in", PDMA_FILTER_PARAM(LOWEST, 11) },
+	{ "pxa2xx-ac97", "pcm_pcm_stereo_out", PDMA_FILTER_PARAM(LOWEST, 12) },
+	{ "pxa-ssp-dai.0", "rx", PDMA_FILTER_PARAM(LOWEST, 13) },
+	{ "pxa-ssp-dai.0", "tx", PDMA_FILTER_PARAM(LOWEST, 14) },
+	{ "pxa-ssp-dai.1", "rx", PDMA_FILTER_PARAM(LOWEST, 15) },
+	{ "pxa-ssp-dai.1", "tx", PDMA_FILTER_PARAM(LOWEST, 16) },
+	{ "pxa2xx-ir", "rx", PDMA_FILTER_PARAM(LOWEST, 17) },
+	{ "pxa2xx-ir", "tx", PDMA_FILTER_PARAM(LOWEST, 18) },
+	{ "pxa2xx-mci.0", "rx", PDMA_FILTER_PARAM(LOWEST, 21) },
+	{ "pxa2xx-mci.0", "tx", PDMA_FILTER_PARAM(LOWEST, 22) },
+	{ "pxa-ssp-dai.2", "rx", PDMA_FILTER_PARAM(LOWEST, 66) },
+	{ "pxa-ssp-dai.2", "tx", PDMA_FILTER_PARAM(LOWEST, 67) },
+
+	/* PXA27x specific map */
+	{ "pxa2xx-i2s", "rx", PDMA_FILTER_PARAM(LOWEST, 2) },
+	{ "pxa2xx-i2s", "tx", PDMA_FILTER_PARAM(LOWEST, 3) },
+	{ "pxa27x-camera.0", "CI_Y", PDMA_FILTER_PARAM(HIGHEST, 68) },
+	{ "pxa27x-camera.0", "CI_U", PDMA_FILTER_PARAM(HIGHEST, 69) },
+	{ "pxa27x-camera.0", "CI_V", PDMA_FILTER_PARAM(HIGHEST, 70) },
+};
+
+static struct mmp_dma_platdata pxa27x_dma_pdata = {
+	.dma_channels	= 32,
+	.nb_requestors	= 75,
+	.slave_map	= pxa27x_slave_map,
+	.slave_map_cnt	= ARRAY_SIZE(pxa27x_slave_map),
+};
+
 static int __init pxa27x_init(void)
 {
 	int ret = 0;
@@ -313,7 +350,7 @@ static int __init pxa27x_init(void)
 		if (!of_have_populated_dt()) {
 			pxa_register_device(&pxa27x_device_gpio,
 					    &pxa27x_gpio_info);
-			pxa2xx_set_dmac_info(32, 75);
+			pxa2xx_set_dmac_info(&pxa27x_dma_pdata);
 			ret = platform_add_devices(devices,
 						   ARRAY_SIZE(devices));
 		}
diff --git a/arch/arm/mach-pxa/pxa3xx.c b/arch/arm/mach-pxa/pxa3xx.c
index 4b8a0df8ea57..22ff8ce6761c 100644
--- a/arch/arm/mach-pxa/pxa3xx.c
+++ b/arch/arm/mach-pxa/pxa3xx.c
@@ -12,6 +12,8 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/dmaengine.h>
+#include <linux/dma/pxa-dma.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -24,6 +26,7 @@
 #include <linux/of.h>
 #include <linux/syscore_ops.h>
 #include <linux/platform_data/i2c-pxa.h>
+#include <linux/platform_data/mmp_dma.h>
 
 #include <asm/mach/map.h>
 #include <asm/suspend.h>
@@ -421,6 +424,42 @@ static struct platform_device *devices[] __initdata = {
 	&pxa27x_device_pwm1,
 };
 
+static const struct dma_slave_map pxa3xx_slave_map[] = {
+	/* PXA25x, PXA27x and PXA3xx common entries */
+	{ "pxa2xx-ac97", "pcm_pcm_mic_mono", PDMA_FILTER_PARAM(LOWEST, 8) },
+	{ "pxa2xx-ac97", "pcm_pcm_aux_mono_in", PDMA_FILTER_PARAM(LOWEST, 9) },
+	{ "pxa2xx-ac97", "pcm_pcm_aux_mono_out",
+	  PDMA_FILTER_PARAM(LOWEST, 10) },
+	{ "pxa2xx-ac97", "pcm_pcm_stereo_in", PDMA_FILTER_PARAM(LOWEST, 11) },
+	{ "pxa2xx-ac97", "pcm_pcm_stereo_out", PDMA_FILTER_PARAM(LOWEST, 12) },
+	{ "pxa-ssp-dai.0", "rx", PDMA_FILTER_PARAM(LOWEST, 13) },
+	{ "pxa-ssp-dai.0", "tx", PDMA_FILTER_PARAM(LOWEST, 14) },
+	{ "pxa-ssp-dai.1", "rx", PDMA_FILTER_PARAM(LOWEST, 15) },
+	{ "pxa-ssp-dai.1", "tx", PDMA_FILTER_PARAM(LOWEST, 16) },
+	{ "pxa2xx-ir", "rx", PDMA_FILTER_PARAM(LOWEST, 17) },
+	{ "pxa2xx-ir", "tx", PDMA_FILTER_PARAM(LOWEST, 18) },
+	{ "pxa2xx-mci.0", "rx", PDMA_FILTER_PARAM(LOWEST, 21) },
+	{ "pxa2xx-mci.0", "tx", PDMA_FILTER_PARAM(LOWEST, 22) },
+	{ "pxa-ssp-dai.2", "rx", PDMA_FILTER_PARAM(LOWEST, 66) },
+	{ "pxa-ssp-dai.2", "tx", PDMA_FILTER_PARAM(LOWEST, 67) },
+
+	/* PXA3xx specific map */
+	{ "pxa-ssp-dai.3", "rx", PDMA_FILTER_PARAM(LOWEST, 2) },
+	{ "pxa-ssp-dai.3", "tx", PDMA_FILTER_PARAM(LOWEST, 3) },
+	{ "pxa2xx-mci.1", "rx", PDMA_FILTER_PARAM(LOWEST, 93) },
+	{ "pxa2xx-mci.1", "tx", PDMA_FILTER_PARAM(LOWEST, 94) },
+	{ "pxa3xx-nand", "data", PDMA_FILTER_PARAM(LOWEST, 97) },
+	{ "pxa2xx-mci.2", "rx", PDMA_FILTER_PARAM(LOWEST, 100) },
+	{ "pxa2xx-mci.2", "tx", PDMA_FILTER_PARAM(LOWEST, 101) },
+};
+
+static struct mmp_dma_platdata pxa3xx_dma_pdata = {
+	.dma_channels	= 32,
+	.nb_requestors	= 100,
+	.slave_map	= pxa3xx_slave_map,
+	.slave_map_cnt	= ARRAY_SIZE(pxa3xx_slave_map),
+};
+
 static int __init pxa3xx_init(void)
 {
 	int ret = 0;
@@ -452,7 +491,7 @@ static int __init pxa3xx_init(void)
 		if (of_have_populated_dt())
 			return 0;
 
-		pxa2xx_set_dmac_info(32, 100);
+		pxa2xx_set_dmac_info(&pxa3xx_dma_pdata);
 		ret = platform_add_devices(devices, ARRAY_SIZE(devices));
 		if (ret)
 			return ret;
-- 
2.11.0
