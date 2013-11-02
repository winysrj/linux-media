Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60744 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab3KBQdk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:40 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	stable@vger.kernel.org
Subject: [PATCHv2 07/29] platform drivers: Fix build on cris and frv archs
Date: Sat,  2 Nov 2013 11:31:15 -0200
Message-Id: <1383399097-11615-8-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On cris and frv archs, the functions below aren't defined:
	drivers/media/platform/sh_veu.c: In function 'sh_veu_reg_read':
	drivers/media/platform/sh_veu.c:228:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
	drivers/media/platform/sh_veu.c: In function 'sh_veu_reg_write':
	drivers/media/platform/sh_veu.c:234:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]
	drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_read':
	drivers/media/platform/vsp1/vsp1.h:66:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
	drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_write':
	drivers/media/platform/vsp1/vsp1.h:71:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]
	drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_read':
	drivers/media/platform/vsp1/vsp1.h:66:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
	drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_write':
	drivers/media/platform/vsp1/vsp1.h:71:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]
	drivers/media/platform/soc_camera/rcar_vin.c: In function 'rcar_vin_setup':
	drivers/media/platform/soc_camera/rcar_vin.c:284:3: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]
	drivers/media/platform/soc_camera/rcar_vin.c: In function 'rcar_vin_request_capture_stop':
	drivers/media/platform/soc_camera/rcar_vin.c:353:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]

While this is not fixed, remove those 3 drivers from building on
those archs.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: stable@vger.kernel.org
---
 drivers/media/platform/Kconfig            | 2 ++
 drivers/media/platform/soc_camera/Kconfig | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 3d9beef60325..ab4b22c8ee85 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -205,6 +205,7 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 config VIDEO_SH_VEU
 	tristate "SuperH VEU mem2mem video processing driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
+	depends on !CRIS && !FRV
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
@@ -214,6 +215,7 @@ config VIDEO_SH_VEU
 config VIDEO_RENESAS_VSP1
 	tristate "Renesas VSP1 Video Processing Engine"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on !CRIS && !FRV
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a V4L2 driver for the Renesas VSP1 video processing engine.
diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index af39c4665554..df11f69aeba5 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -47,6 +47,7 @@ config VIDEO_PXA27x
 config VIDEO_RCAR_VIN
 	tristate "R-Car Video Input (VIN) support"
 	depends on VIDEO_DEV && SOC_CAMERA
+	depends on !CRIS && !FRV
 	select VIDEOBUF2_DMA_CONTIG
 	select SOC_CAMERA_SCALE_CROP
 	---help---
-- 
1.8.3.1

