Return-path: <linux-media-owner@vger.kernel.org>
Received: from newton.telenet-ops.be ([195.130.132.45]:46260 "EHLO
        newton.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751548AbeCPOBf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 10:01:35 -0400
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by newton.telenet-ops.be (Postfix) with ESMTPS id 402n391q0PzMqygh
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2018 14:52:53 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Tejun Heo <tj@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Alan Tull <atull@kernel.org>, Moritz Fischer <mdf@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Matias Bjorling <mb@lightnvm.io>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Richard Weinberger <richard@nod.at>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>
Cc: iommu@lists.linux-foundation.org, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-ide@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-fpga@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-block@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-spi@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2 19/21] spi: Remove depends on HAS_DMA in case of platform dependency
Date: Fri, 16 Mar 2018 14:51:52 +0100
Message-Id: <1521208314-4783-20-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
References: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove dependencies on HAS_DMA where a Kconfig symbol depends on another
symbol that implies HAS_DMA, and, optionally, on "|| COMPILE_TEST".
In most cases this other symbol is an architecture or platform specific
symbol, or PCI.

Generic symbols and drivers without platform dependencies keep their
dependencies on HAS_DMA, to prevent compiling subsystems or drivers that
cannot work anyway.

This simplifies the dependencies, and allows to improve compile-testing.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: Robin Murphy <robin.murphy@arm.com>
---
v2:
  - Add Reviewed-by, Acked-by,
  - Drop RFC state,
  - Split per subsystem.
---
 drivers/spi/Kconfig | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 603783976b8152d4..7bd3a94f58511c41 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -71,7 +71,6 @@ config SPI_ARMADA_3700
 
 config SPI_ATMEL
 	tristate "Atmel SPI Controller"
-	depends on HAS_DMA
 	depends on (ARCH_AT91 || AVR32 || COMPILE_TEST)
 	help
 	  This selects a driver for the Atmel SPI Controller, present on
@@ -252,7 +251,6 @@ config SPI_EFM32
 
 config SPI_EP93XX
 	tristate "Cirrus Logic EP93xx SPI controller"
-	depends on HAS_DMA
 	depends on ARCH_EP93XX || COMPILE_TEST
 	help
 	  This enables using the Cirrus EP93xx SPI controller in master
@@ -374,7 +372,6 @@ config SPI_FSL_SPI
 config SPI_FSL_DSPI
 	tristate "Freescale DSPI controller"
 	select REGMAP_MMIO
-	depends on HAS_DMA
 	depends on SOC_VF610 || SOC_LS1021A || ARCH_LAYERSCAPE || M5441x || COMPILE_TEST
 	help
 	  This enables support for the Freescale DSPI controller in master
@@ -450,7 +447,6 @@ config SPI_OMAP_UWIRE
 
 config SPI_OMAP24XX
 	tristate "McSPI driver for OMAP"
-	depends on HAS_DMA
 	depends on ARCH_OMAP2PLUS || COMPILE_TEST
 	select SG_SPLIT
 	help
@@ -459,7 +455,6 @@ config SPI_OMAP24XX
 
 config SPI_TI_QSPI
 	tristate "DRA7xxx QSPI controller support"
-	depends on HAS_DMA
 	depends on ARCH_OMAP2PLUS || COMPILE_TEST
 	help
 	  QSPI master controller for DRA7xxx used for flash devices.
@@ -488,7 +483,6 @@ config SPI_PIC32
 config SPI_PIC32_SQI
 	tristate "Microchip PIC32 Quad SPI driver"
 	depends on MACH_PIC32 || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  SPI driver for PIC32 Quad SPI controller.
 
@@ -591,7 +585,7 @@ config SPI_SC18IS602
 
 config SPI_SH_MSIOF
 	tristate "SuperH MSIOF SPI controller"
-	depends on HAVE_CLK && HAS_DMA
+	depends on HAVE_CLK
 	depends on ARCH_SHMOBILE || ARCH_RENESAS || COMPILE_TEST
 	help
 	  SPI driver for SuperH and SH Mobile MSIOF blocks.
@@ -669,7 +663,7 @@ config SPI_MXS
 config SPI_TEGRA114
 	tristate "NVIDIA Tegra114 SPI Controller"
 	depends on (ARCH_TEGRA && TEGRA20_APB_DMA) || COMPILE_TEST
-	depends on RESET_CONTROLLER && HAS_DMA
+	depends on RESET_CONTROLLER
 	help
 	  SPI driver for NVIDIA Tegra114 SPI Controller interface. This controller
 	  is different than the older SoCs SPI controller and also register interface
@@ -687,7 +681,7 @@ config SPI_TEGRA20_SFLASH
 config SPI_TEGRA20_SLINK
 	tristate "Nvidia Tegra20/Tegra30 SLINK Controller"
 	depends on (ARCH_TEGRA && TEGRA20_APB_DMA) || COMPILE_TEST
-	depends on RESET_CONTROLLER && HAS_DMA
+	depends on RESET_CONTROLLER
 	help
 	  SPI driver for Nvidia Tegra20/Tegra30 SLINK Controller interface.
 
-- 
2.7.4
