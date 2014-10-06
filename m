Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53360 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaJFRFs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Oct 2014 13:05:48 -0400
Message-ID: <5432CBE7.1040901@infradead.org>
Date: Mon, 06 Oct 2014 10:05:43 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Jim Davis <jim.epost@gmail.com>
Subject: [PATCH -next] media: tw68: fix build errors and warnings
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix build errors and kconfig warning: since 'select' does not check
Kconfig symbol dependencies, add that dependency explicitly.

VIDEO_TW68 selects I2C_ALGOBIT, so it should depend on I2C to
prevent build errors and warnings.

warning: (CAN_PEAK_PCIEC && SFC && IGB && VIDEO_TW68 && DRM && FB_DDC && FB_VIA) selects I2C_ALGOBIT which has unmet direct dependencies (I2C)
  CC [M]  drivers/i2c/algos/i2c-algo-bit.o
../drivers/i2c/algos/i2c-algo-bit.c: In function 'i2c_bit_add_bus':
../drivers/i2c/algos/i2c-algo-bit.c:658:33: error: 'i2c_add_adapter' undeclared (first use in this function)
../drivers/i2c/algos/i2c-algo-bit.c:658:33: note: each undeclared identifier is reported only once for each function it appears in
../drivers/i2c/algos/i2c-algo-bit.c: In function 'i2c_bit_add_numbered_bus':
../drivers/i2c/algos/i2c-algo-bit.c:664:33: error: 'i2c_add_numbered_adapter' undeclared (first use in this function)
../drivers/i2c/algos/i2c-algo-bit.c: In function 'i2c_bit_add_bus':
../drivers/i2c/algos/i2c-algo-bit.c:659:1: warning: control reaches end of non-void function [-Wreturn-type]
../drivers/i2c/algos/i2c-algo-bit.c: In function 'i2c_bit_add_numbered_bus':
../drivers/i2c/algos/i2c-algo-bit.c:665:1: warning: control reaches end of non-void function [-Wreturn-type]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/pci/tw68/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20141001.orig/drivers/media/pci/tw68/Kconfig
+++ linux-next-20141001/drivers/media/pci/tw68/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_TW68
 	tristate "Techwell tw68x Video For Linux"
-	depends on VIDEO_DEV && PCI && VIDEO_V4L2
+	depends on VIDEO_DEV && PCI && VIDEO_V4L2 && I2C
 	select I2C_ALGOBIT
 	select VIDEOBUF2_DMA_SG
 	---help---
