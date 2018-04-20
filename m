Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42773 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753494AbeDTRnB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 13:43:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        mjpeg-users@lists.sourceforge.net, linux-arch@vger.kernel.org
Subject: [PATCH 1/7] asm-generic, media: allow COMPILE_TEST with virt_to_bus
Date: Fri, 20 Apr 2018 13:42:47 -0400
Message-Id: <d8bdf4a080d4655d20b532a37ae22ca7e3483cc4.1524245455.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524245455.git.mchehab@s-opensource.com>
References: <cover.1524245455.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524245455.git.mchehab@s-opensource.com>
References: <cover.1524245455.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The virt_to_bus/bus_to_virt macros are arch-specific. Some
archs don't support it. Yet, as it is interesting to allow
doing compilation tests on non-ia32/ia64 archs, provide a
fallback for such archs.

While here, enable COMPILE_TEST for two media drivers that
depends on it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/sta2x11/Kconfig | 4 ++--
 drivers/media/pci/zoran/Kconfig   | 3 ++-
 include/asm-generic/io.h          | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/sta2x11/Kconfig b/drivers/media/pci/sta2x11/Kconfig
index 7af3f1cbcea8..fb4b4c8ac430 100644
--- a/drivers/media/pci/sta2x11/Kconfig
+++ b/drivers/media/pci/sta2x11/Kconfig
@@ -1,10 +1,10 @@
 config STA2X11_VIP
 	tristate "STA2X11 VIP Video For Linux"
-	depends on STA2X11 || COMPILE_TEST
+	depends on (STA2X11 && VIRT_TO_BUS) || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEO_ADV7180 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEOBUF2_DMA_CONTIG
-	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
+	depends on PCI && VIDEO_V4L2
 	depends on VIDEO_V4L2_SUBDEV_API
 	depends on I2C
 	help
diff --git a/drivers/media/pci/zoran/Kconfig b/drivers/media/pci/zoran/Kconfig
index 39ec35bd21a5..5d2678a9e310 100644
--- a/drivers/media/pci/zoran/Kconfig
+++ b/drivers/media/pci/zoran/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_ZORAN
 	tristate "Zoran ZR36057/36067 Video For Linux"
-	depends on PCI && I2C_ALGOBIT && VIDEO_V4L2 && VIRT_TO_BUS
+	depends on PCI && I2C_ALGOBIT && VIDEO_V4L2
+	depends on VIRT_TO_BUS || COMPILE_TEST
 	depends on !ALPHA
 	help
 	  Say Y for support for MJPEG capture cards based on the Zoran
diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 66d1d45fa2e1..f448129ad15c 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -1068,7 +1068,7 @@ static inline void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr)
 }
 #endif
 
-#ifdef CONFIG_VIRT_TO_BUS
+#if defined(CONFIG_VIRT_TO_BUS) || defined(CONFIG_COMPILE_TEST)
 #ifndef virt_to_bus
 static inline unsigned long virt_to_bus(void *address)
 {
-- 
2.14.3
