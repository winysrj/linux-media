Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57949 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab3KAWld (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Nov 2013 18:41:33 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 03/11] zoran: don't build it on alpha
Date: Fri,  1 Nov 2013 17:39:22 -0200
Message-Id: <1383334770-27130-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383334770-27130-1-git-send-email-m.chehab@samsung.com>
References: <1383334770-27130-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver uses virt_to_bus() with is deprecated on Alpha:

	/devel/v4l/ktest-build/drivers/media/pci/zoran/zoran_device.c: In function 'zr36057_set_vfe':
	/devel/v4l/ktest-build/drivers/media/pci/zoran/zoran_device.c:451:3: warning: 'virt_to_bus' is deprecated (declared at /devel/v4l/ktest-build/arch/alpha/include/asm/io.h:114) [-Wdeprecated-declarations]
	/devel/v4l/ktest-build/drivers/media/pci/zoran/zoran_device.c:453:3: warning: 'virt_to_bus' is deprecated (declared at /devel/v4l/ktest-build/arch/alpha/include/asm/io.h:114) [-Wdeprecated-declarations]
	/devel/v4l/ktest-build/drivers/media/pci/zoran/zoran_device.c: In function 'zr36057_set_jpg':
	/devel/v4l/ktest-build/drivers/media/pci/zoran/zoran_device.c:796:2: warning: 'virt_to_bus' is deprecated (declared at /devel/v4l/ktest-build/arch/alpha/include/asm/io.h:114) [-Wdeprecated-declarations]
	/devel/v4l/ktest-build/drivers/media/pci/zoran/zoran_driver.c: In function 'v4l_fbuffer_alloc':
	/devel/v4l/ktest-build/drivers/media/pci/zoran/zoran_driver.c:241:3: warning: 'virt_to_bus' is deprecated (declared at /devel/v4l/ktest-build/arch/alpha/include/asm/io.h:114) [-Wdeprecated-declarations]
	/devel/v4l/ktest-build/drivers/media/pci/zoran/zoran_driver.c:245:3: warning: 'virt_to_bus' is deprecated (declared at /devel/v4l/ktest-build/arch/alpha/include/asm/io.h:114) [-Wdeprecated-declarations]
	/devel/v4l/ktest-build/drivers/media/pci/zoran/zoran_driver.c: In function 'jpg_fbuffer_alloc':
	/devel/v4l/ktest-build/drivers/media/pci/zoran/zoran_driver.c:334:3: warning: 'virt_to_bus' is deprecated (declared at /devel/v4l/ktest-build/arch/alpha/include/asm/io.h:114) [-Wdeprecated-declarations]
	/devel/v4l/ktest-build/drivers/media/pci/zoran/zoran_driver.c:347:5: warning: 'virt_to_bus' is deprecated (declared at /devel/v4l/ktest-build/arch/alpha/include/asm/io.h:114) [-Wdeprecated-declarations]
	/devel/v4l/ktest-build/drivers/media/pci/zoran/zoran_driver.c:366:6: warning: 'virt_to_bus' is deprecated (declared at /devel/v4l/ktest-build/arch/alpha/include/asm/io.h:114) [-Wdeprecated-declarations]

As we're not even sure if it works on Alpha, better to just disable its compilation there.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/pci/zoran/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/zoran/Kconfig b/drivers/media/pci/zoran/Kconfig
index 26ca8702e33f..39ec35bd21a5 100644
--- a/drivers/media/pci/zoran/Kconfig
+++ b/drivers/media/pci/zoran/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_ZORAN
 	tristate "Zoran ZR36057/36067 Video For Linux"
 	depends on PCI && I2C_ALGOBIT && VIDEO_V4L2 && VIRT_TO_BUS
+	depends on !ALPHA
 	help
 	  Say Y for support for MJPEG capture cards based on the Zoran
 	  36057/36067 PCI controller chipset. This includes the Iomega
-- 
1.8.3.1

