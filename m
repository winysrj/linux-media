Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1375 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbaJVKvp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 06:51:45 -0400
Message-ID: <54478C1C.6020708@xs4all.nl>
Date: Wed, 22 Oct 2014 12:51:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH for v3.18] tw68: remove bogus I2C_ALGOBIT dependency
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tw68 doesn't use i2c at all, so remove this bogus dependency to prevent this warning:

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

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/pci/tw68/Kconfig b/drivers/media/pci/tw68/Kconfig
index 5425ba1..95d5d52 100644
--- a/drivers/media/pci/tw68/Kconfig
+++ b/drivers/media/pci/tw68/Kconfig
@@ -1,7 +1,6 @@
  config VIDEO_TW68
  	tristate "Techwell tw68x Video For Linux"
  	depends on VIDEO_DEV && PCI && VIDEO_V4L2
-	select I2C_ALGOBIT
  	select VIDEOBUF2_DMA_SG
  	---help---
  	  Support for Techwell tw68xx based frame grabber boards.
