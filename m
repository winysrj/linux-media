Return-path: <linux-media-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:48520 "EHLO
        andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753550AbeCPOv2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 10:51:28 -0400
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
Subject: [PATCH v2 07/21] i2c: Remove depends on HAS_DMA in case of platform dependency
Date: Fri, 16 Mar 2018 14:51:40 +0100
Message-Id: <1521208314-4783-8-git-send-email-geert@linux-m68k.org>
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
 drivers/i2c/busses/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index e2954fb86d659f36..2ce9bbd5d56ed06a 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -725,7 +725,6 @@ config I2C_MPC
 config I2C_MT65XX
 	tristate "MediaTek I2C adapter"
 	depends on ARCH_MEDIATEK || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  This selects the MediaTek(R) Integrated Inter Circuit bus driver
 	  for MT65xx and MT81xx.
@@ -903,7 +902,6 @@ config I2C_SH7760
 
 config I2C_SH_MOBILE
 	tristate "SuperH Mobile I2C Controller"
-	depends on HAS_DMA
 	depends on ARCH_SHMOBILE || ARCH_RENESAS || COMPILE_TEST
 	help
 	  If you say yes to this option, support will be included for the
@@ -1106,7 +1104,6 @@ config I2C_XLP9XX
 
 config I2C_RCAR
 	tristate "Renesas R-Car I2C Controller"
-	depends on HAS_DMA
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select I2C_SLAVE
 	help
-- 
2.7.4
