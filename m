Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39344 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753336AbeDTRm7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 13:42:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 4/7] media: ipu3: allow building it with COMPILE_TEST on non-x86 archs
Date: Fri, 20 Apr 2018 13:42:50 -0400
Message-Id: <07d3ab8b8c86a41488d22410968bec96714792f4.1524245455.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524245455.git.mchehab@s-opensource.com>
References: <cover.1524245455.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524245455.git.mchehab@s-opensource.com>
References: <cover.1524245455.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Despite depending on ACPI, this driver builds fine on non-x86
archtecture with COMPILE_TEST, as it doesn't depend on
ACPI-specific functions/structs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/intel/ipu3/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
index a82d3fe277d2..45cf99a512e4 100644
--- a/drivers/media/pci/intel/ipu3/Kconfig
+++ b/drivers/media/pci/intel/ipu3/Kconfig
@@ -2,10 +2,9 @@ config VIDEO_IPU3_CIO2
 	tristate "Intel ipu3-cio2 driver"
 	depends on VIDEO_V4L2 && PCI
 	depends on VIDEO_V4L2_SUBDEV_API
-	depends on X86 || COMPILE_TEST
+	depends on (X86 && ACPI) || COMPILE_TEST
 	depends on MEDIA_CONTROLLER
 	depends on HAS_DMA
-	depends on ACPI
 	select V4L2_FWNODE
 	select VIDEOBUF2_DMA_SG
 
-- 
2.14.3
