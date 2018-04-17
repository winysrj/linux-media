Return-path: <linux-media-owner@vger.kernel.org>
Received: from leibniz.telenet-ops.be ([195.130.137.77]:38824 "EHLO
        leibniz.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752120AbeDQSAN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 14:00:13 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by leibniz.telenet-ops.be (Postfix) with ESMTPS id 40QY1l0R2gzMqjZD
        for <linux-media@vger.kernel.org>; Tue, 17 Apr 2018 20:00:11 +0200 (CEST)
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
Subject: [PATCH v3 03/20] crypto: Remove depends on HAS_DMA in case of platform dependency
Date: Tue, 17 Apr 2018 19:49:03 +0200
Message-Id: <1523987360-18760-4-git-send-email-geert@linux-m68k.org>
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
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
---
v3:
  - Add Acked-by,
  - Rebase to v4.17-rc1,

v2:
  - Add Reviewed-by, Acked-by,
  - Drop RFC state,
  - Split per subsystem.
---
 drivers/crypto/Kconfig | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index d1ea1a07cecbb36c..3dbc47528667b77c 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -419,7 +419,7 @@ config CRYPTO_DEV_EXYNOS_RNG
 config CRYPTO_DEV_S5P
 	tristate "Support for Samsung S5PV210/Exynos crypto accelerator"
 	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
-	depends on HAS_IOMEM && HAS_DMA
+	depends on HAS_IOMEM
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER
 	help
@@ -466,7 +466,6 @@ endif # if CRYPTO_DEV_UX500
 
 config CRYPTO_DEV_ATMEL_AUTHENC
 	tristate "Support for Atmel IPSEC/SSL hw accelerator"
-	depends on HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_AUTHENC
 	select CRYPTO_DEV_ATMEL_AES
@@ -479,7 +478,6 @@ config CRYPTO_DEV_ATMEL_AUTHENC
 
 config CRYPTO_DEV_ATMEL_AES
 	tristate "Support for Atmel AES hw accelerator"
-	depends on HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_AEAD
@@ -494,7 +492,6 @@ config CRYPTO_DEV_ATMEL_AES
 
 config CRYPTO_DEV_ATMEL_TDES
 	tristate "Support for Atmel DES/TDES hw accelerator"
-	depends on HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_DES
 	select CRYPTO_BLKCIPHER
@@ -508,7 +505,6 @@ config CRYPTO_DEV_ATMEL_TDES
 
 config CRYPTO_DEV_ATMEL_SHA
 	tristate "Support for Atmel SHA hw accelerator"
-	depends on HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_HASH
 	help
@@ -574,7 +570,8 @@ config CRYPTO_DEV_CAVIUM_ZIP
 
 config CRYPTO_DEV_QCE
 	tristate "Qualcomm crypto engine accelerator"
-	depends on (ARCH_QCOM || COMPILE_TEST) && HAS_DMA && HAS_IOMEM
+	depends on ARCH_QCOM || COMPILE_TEST
+	depends on HAS_IOMEM
 	select CRYPTO_AES
 	select CRYPTO_DES
 	select CRYPTO_ECB
@@ -598,7 +595,6 @@ source "drivers/crypto/vmx/Kconfig"
 config CRYPTO_DEV_IMGTEC_HASH
 	tristate "Imagination Technologies hardware hash accelerator"
 	depends on MIPS || COMPILE_TEST
-	depends on HAS_DMA
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
@@ -650,7 +646,6 @@ config CRYPTO_DEV_ROCKCHIP
 
 config CRYPTO_DEV_MEDIATEK
 	tristate "MediaTek's EIP97 Cryptographic Engine driver"
-	depends on HAS_DMA
 	depends on (ARM && ARCH_MEDIATEK) || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_AEAD
@@ -688,7 +683,7 @@ source "drivers/crypto/stm32/Kconfig"
 
 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
-	depends on HAS_DMA && OF
+	depends on OF
 	depends on (ARM64 && ARCH_MVEBU) || (COMPILE_TEST && 64BIT)
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER
@@ -706,7 +701,6 @@ config CRYPTO_DEV_SAFEXCEL
 config CRYPTO_DEV_ARTPEC6
 	tristate "Support for Axis ARTPEC-6/7 hardware crypto acceleration."
 	depends on ARM && (ARCH_ARTPEC || COMPILE_TEST)
-	depends on HAS_DMA
 	depends on OF
 	select CRYPTO_AEAD
 	select CRYPTO_AES
-- 
2.7.4
