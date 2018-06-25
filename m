Return-path: <linux-media-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:36574 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755530AbeFYNPe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 09:15:34 -0400
From: Mark Brown <broonie@kernel.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        alsa-devel@alsa-project.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Applied "ARM: pxa: remove the DMA IO resources" to the asoc tree
In-Reply-To: <20180524070703.11901-13-robert.jarzmik@free.fr>
Message-Id: <E1fXRKw-0008K7-4P@debutante>
Date: Mon, 25 Jun 2018 14:15:18 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch

   ARM: pxa: remove the DMA IO resources

has been applied to the asoc tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git 

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

>From b77ed2e6d61d40117272be1b2377c5dfd101e9cd Mon Sep 17 00:00:00 2001
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 17 Jun 2018 19:02:16 +0200
Subject: [PATCH] ARM: pxa: remove the DMA IO resources

As the last driver using the former mechanism to acquire the DMA
requestor line has be converted to the dma_slave_map, remove all these
resources from the PXA devices.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 arch/arm/mach-pxa/devices.c | 136 ------------------------------------
 1 file changed, 136 deletions(-)

diff --git a/arch/arm/mach-pxa/devices.c b/arch/arm/mach-pxa/devices.c
index 1e8915fc340d..5a16ea74e28a 100644
--- a/arch/arm/mach-pxa/devices.c
+++ b/arch/arm/mach-pxa/devices.c
@@ -60,16 +60,6 @@ static struct resource pxamci_resources[] = {
 		.end	= IRQ_MMC,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[2] = {
-		.start	= 21,
-		.end	= 21,
-		.flags	= IORESOURCE_DMA,
-	},
-	[3] = {
-		.start	= 22,
-		.end	= 22,
-		.flags	= IORESOURCE_DMA,
-	},
 };
 
 static u64 pxamci_dmamask = 0xffffffffUL;
@@ -407,16 +397,6 @@ static struct resource pxa_ir_resources[] = {
 		.end	= 0x40700023,
 		.flags  = IORESOURCE_MEM,
 	},
-	[5] = {
-		.start  = 17,
-		.end	= 17,
-		.flags  = IORESOURCE_DMA,
-	},
-	[6] = {
-		.start  = 18,
-		.end	= 18,
-		.flags  = IORESOURCE_DMA,
-	},
 };
 
 struct platform_device pxa_device_ficp = {
@@ -545,18 +525,6 @@ static struct resource pxa25x_resource_ssp[] = {
 		.end	= IRQ_SSP,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[2] = {
-		/* DRCMR for RX */
-		.start	= 13,
-		.end	= 13,
-		.flags	= IORESOURCE_DMA,
-	},
-	[3] = {
-		/* DRCMR for TX */
-		.start	= 14,
-		.end	= 14,
-		.flags	= IORESOURCE_DMA,
-	},
 };
 
 struct platform_device pxa25x_device_ssp = {
@@ -583,18 +551,6 @@ static struct resource pxa25x_resource_nssp[] = {
 		.end	= IRQ_NSSP,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[2] = {
-		/* DRCMR for RX */
-		.start	= 15,
-		.end	= 15,
-		.flags	= IORESOURCE_DMA,
-	},
-	[3] = {
-		/* DRCMR for TX */
-		.start	= 16,
-		.end	= 16,
-		.flags	= IORESOURCE_DMA,
-	},
 };
 
 struct platform_device pxa25x_device_nssp = {
@@ -621,18 +577,6 @@ static struct resource pxa25x_resource_assp[] = {
 		.end	= IRQ_ASSP,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[2] = {
-		/* DRCMR for RX */
-		.start	= 23,
-		.end	= 23,
-		.flags	= IORESOURCE_DMA,
-	},
-	[3] = {
-		/* DRCMR for TX */
-		.start	= 24,
-		.end	= 24,
-		.flags	= IORESOURCE_DMA,
-	},
 };
 
 struct platform_device pxa25x_device_assp = {
@@ -751,18 +695,6 @@ static struct resource pxa27x_resource_ssp1[] = {
 		.end	= IRQ_SSP,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[2] = {
-		/* DRCMR for RX */
-		.start	= 13,
-		.end	= 13,
-		.flags	= IORESOURCE_DMA,
-	},
-	[3] = {
-		/* DRCMR for TX */
-		.start	= 14,
-		.end	= 14,
-		.flags	= IORESOURCE_DMA,
-	},
 };
 
 struct platform_device pxa27x_device_ssp1 = {
@@ -789,18 +721,6 @@ static struct resource pxa27x_resource_ssp2[] = {
 		.end	= IRQ_SSP2,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[2] = {
-		/* DRCMR for RX */
-		.start	= 15,
-		.end	= 15,
-		.flags	= IORESOURCE_DMA,
-	},
-	[3] = {
-		/* DRCMR for TX */
-		.start	= 16,
-		.end	= 16,
-		.flags	= IORESOURCE_DMA,
-	},
 };
 
 struct platform_device pxa27x_device_ssp2 = {
@@ -827,18 +747,6 @@ static struct resource pxa27x_resource_ssp3[] = {
 		.end	= IRQ_SSP3,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[2] = {
-		/* DRCMR for RX */
-		.start	= 66,
-		.end	= 66,
-		.flags	= IORESOURCE_DMA,
-	},
-	[3] = {
-		/* DRCMR for TX */
-		.start	= 67,
-		.end	= 67,
-		.flags	= IORESOURCE_DMA,
-	},
 };
 
 struct platform_device pxa27x_device_ssp3 = {
@@ -895,16 +803,6 @@ static struct resource pxa3xx_resources_mci2[] = {
 		.end	= IRQ_MMC2,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[2] = {
-		.start	= 93,
-		.end	= 93,
-		.flags	= IORESOURCE_DMA,
-	},
-	[3] = {
-		.start	= 94,
-		.end	= 94,
-		.flags	= IORESOURCE_DMA,
-	},
 };
 
 struct platform_device pxa3xx_device_mci2 = {
@@ -934,16 +832,6 @@ static struct resource pxa3xx_resources_mci3[] = {
 		.end	= IRQ_MMC3,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[2] = {
-		.start	= 100,
-		.end	= 100,
-		.flags	= IORESOURCE_DMA,
-	},
-	[3] = {
-		.start	= 101,
-		.end	= 101,
-		.flags	= IORESOURCE_DMA,
-	},
 };
 
 struct platform_device pxa3xx_device_mci3 = {
@@ -1021,18 +909,6 @@ static struct resource pxa3xx_resources_nand[] = {
 		.end	= IRQ_NAND,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[2] = {
-		/* DRCMR for Data DMA */
-		.start	= 97,
-		.end	= 97,
-		.flags	= IORESOURCE_DMA,
-	},
-	[3] = {
-		/* DRCMR for Command DMA */
-		.start	= 99,
-		.end	= 99,
-		.flags	= IORESOURCE_DMA,
-	},
 };
 
 static u64 pxa3xx_nand_dma_mask = DMA_BIT_MASK(32);
@@ -1066,18 +942,6 @@ static struct resource pxa3xx_resource_ssp4[] = {
 		.end	= IRQ_SSP4,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[2] = {
-		/* DRCMR for RX */
-		.start	= 2,
-		.end	= 2,
-		.flags	= IORESOURCE_DMA,
-	},
-	[3] = {
-		/* DRCMR for TX */
-		.start	= 3,
-		.end	= 3,
-		.flags	= IORESOURCE_DMA,
-	},
 };
 
 /*
-- 
2.18.0.rc2
