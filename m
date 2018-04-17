Return-path: <linux-media-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:41558 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752784AbeDQSy1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 14:54:27 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-fpga@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-block@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-spi@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v3 14/20] mtd: Remove depends on HAS_DMA in case of platform dependency
Date: Tue, 17 Apr 2018 19:49:14 +0200
Message-Id: <1523987360-18760-15-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1523987360-18760-1-git-send-email-geert@linux-m68k.org>
References: <1523987360-18760-1-git-send-email-geert@linux-m68k.org>
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
v3:
  - Rebase to v4.17-rc1,

v2:
  - Add Reviewed-by, Acked-by,
  - Drop RFC state,
  - Drop new dependency of MTD_NAND_MARVELL on HAS_DMA,
  - Split per subsystem.
---
 drivers/mtd/nand/raw/Kconfig | 8 ++------
 drivers/mtd/spi-nor/Kconfig  | 2 +-
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index 19a2b283fbbe627e..6871ff0fd300bb81 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -46,7 +46,7 @@ config MTD_NAND_DENALI
 config MTD_NAND_DENALI_PCI
         tristate "Support Denali NAND controller on Intel Moorestown"
 	select MTD_NAND_DENALI
-	depends on HAS_DMA && PCI
+	depends on PCI
         help
           Enable the driver for NAND flash on Intel Moorestown, using the
           Denali NAND controller core.
@@ -152,7 +152,6 @@ config MTD_NAND_S3C2410_CLKSTOP
 config MTD_NAND_TANGO
 	tristate "NAND Flash support for Tango chips"
 	depends on ARCH_TANGO || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  Enables the NAND Flash controller on Tango chips.
 
@@ -285,7 +284,7 @@ config MTD_NAND_MARVELL
 	tristate "NAND controller support on Marvell boards"
 	depends on PXA3xx || ARCH_MMP || PLAT_ORION || ARCH_MVEBU || \
 		   COMPILE_TEST
-	depends on HAS_IOMEM && HAS_DMA
+	depends on HAS_IOMEM
 	help
 	  This enables the NAND flash controller driver for Marvell boards,
 	  including:
@@ -447,7 +446,6 @@ config MTD_NAND_SH_FLCTL
 	tristate "Support for NAND on Renesas SuperH FLCTL"
 	depends on SUPERH || COMPILE_TEST
 	depends on HAS_IOMEM
-	depends on HAS_DMA
 	help
 	  Several Renesas SuperH CPU has FLCTL. This option enables support
 	  for NAND Flash using FLCTL.
@@ -515,7 +513,6 @@ config MTD_NAND_SUNXI
 config MTD_NAND_HISI504
 	tristate "Support for NAND controller on Hisilicon SoC Hip04"
 	depends on ARCH_HISI || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  Enables support for NAND controller on Hisilicon SoC Hip04.
 
@@ -529,7 +526,6 @@ config MTD_NAND_QCOM
 config MTD_NAND_MTK
 	tristate "Support for NAND controller on MTK SoCs"
 	depends on ARCH_MEDIATEK || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  Enables support for NAND controller on MTK SoCs.
 	  This controller is found on mt27xx, mt81xx, mt65xx SoCs.
diff --git a/drivers/mtd/spi-nor/Kconfig b/drivers/mtd/spi-nor/Kconfig
index 89da88e591215db1..c493b8230a38c059 100644
--- a/drivers/mtd/spi-nor/Kconfig
+++ b/drivers/mtd/spi-nor/Kconfig
@@ -71,7 +71,7 @@ config SPI_FSL_QUADSPI
 config SPI_HISI_SFC
 	tristate "Hisilicon SPI-NOR Flash Controller(SFC)"
 	depends on ARCH_HISI || COMPILE_TEST
-	depends on HAS_IOMEM && HAS_DMA
+	depends on HAS_IOMEM
 	help
 	  This enables support for hisilicon SPI-NOR flash controller.
 
-- 
2.7.4
