Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48150 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933164AbdAHBIw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Jan 2017 20:08:52 -0500
To: linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] media: fix dm1105.c build error
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Message-ID: <977da606-65e9-e2d0-62e4-f3025daabd51@infradead.org>
Date: Sat, 7 Jan 2017 17:08:49 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix dm1105 build error when CONFIG_I2C_ALGOBIT=m and
CONFIG_DVB_DM1105=y.

drivers/built-in.o: In function `dm1105_probe':
dm1105.c:(.text+0x2836e7): undefined reference to `i2c_bit_add_bus'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: stable@vger.kernel.org # applies to 4.0 (maybe even 3.x)
---
 drivers/media/pci/dm1105/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-410-rc2.orig/drivers/media/pci/dm1105/Kconfig
+++ lnx-410-rc2/drivers/media/pci/dm1105/Kconfig
@@ -1,6 +1,6 @@
 config DVB_DM1105
 	tristate "SDMC DM1105 based PCI cards"
-	depends on DVB_CORE && PCI && I2C
+	depends on DVB_CORE && PCI && I2C && I2C_ALGOBIT
 	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_STV0299 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_STV0288 if MEDIA_SUBDRV_AUTOSELECT
