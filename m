Return-path: <linux-media-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:41578 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753015AbeDQSzL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 14:55:11 -0400
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
Subject: [PATCH v3 07/20] i2c: Remove depends on HAS_DMA in case of platform dependency
Date: Tue, 17 Apr 2018 19:49:07 +0200
Message-Id: <1523987360-18760-8-git-send-email-geert@linux-m68k.org>
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
  - Split per subsystem.
---
 drivers/i2c/busses/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index c4865b08d7fb9e3b..8d21b9825d71764d 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -707,7 +707,6 @@ config I2C_MPC
 config I2C_MT65XX
 	tristate "MediaTek I2C adapter"
 	depends on ARCH_MEDIATEK || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  This selects the MediaTek(R) Integrated Inter Circuit bus driver
 	  for MT65xx and MT81xx.
@@ -885,7 +884,6 @@ config I2C_SH7760
 
 config I2C_SH_MOBILE
 	tristate "SuperH Mobile I2C Controller"
-	depends on HAS_DMA
 	depends on ARCH_SHMOBILE || ARCH_RENESAS || COMPILE_TEST
 	help
 	  If you say yes to this option, support will be included for the
@@ -1098,7 +1096,6 @@ config I2C_XLP9XX
 
 config I2C_RCAR
 	tristate "Renesas R-Car I2C Controller"
-	depends on HAS_DMA
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select I2C_SLAVE
 	help
-- 
2.7.4
