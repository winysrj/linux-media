Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:52071 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbbA2Bmj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 20:42:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6/7] [media] marvell-ccic: MMP_CAMERA never worked
Date: Wed, 28 Jan 2015 22:17:46 +0100
Message-Id: <1422479867-3370921-7-git-send-email-arnd@arndb.de>
In-Reply-To: <1422479867-3370921-1-git-send-email-arnd@arndb.de>
References: <1422479867-3370921-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mmp ccic driver uses a platform_data structure that has never
existed in an upstream kernel and always fails to build:

media/platform/marvell-ccic/mmp-driver.c: In function 'mmpcam_calc_dphy':
media/platform/marvell-ccic/mmp-driver.c:252:15: error: 'struct mmp_camera_platform_data' has no member named 'dphy3_algo'
  switch (pdata->dphy3_algo) {
               ^
media/platform/marvell-ccic/mmp-driver.c:253:7: error: 'DPHY3_ALGO_PXA910' undeclared (first use in this function)
  case DPHY3_ALGO_PXA910:
       ^
media/platform/marvell-ccic/mmp-driver.c:253:7: note: each undeclared identifier is reported only once for each function it appears in
media/platform/marvell-ccic/mmp-driver.c:257:8: error: 'struct mmp_camera_platform_data' has no member named 'dphy'

This marks the driver as 'BROKEN' but keeps the code around.
Alternatively it could be removed entirely.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/platform/marvell-ccic/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
index 6265d36adceb..7ac0f13c98be 100644
--- a/drivers/media/platform/marvell-ccic/Kconfig
+++ b/drivers/media/platform/marvell-ccic/Kconfig
@@ -13,7 +13,7 @@ config VIDEO_CAFE_CCIC
 config VIDEO_MMP_CAMERA
 	tristate "Marvell Armada 610 integrated camera controller support"
 	depends on ARCH_MMP && I2C && VIDEO_V4L2
-	depends on HAS_DMA
+	depends on HAS_DMA && BROKEN
 	select VIDEO_OV7670
 	select I2C_GPIO
 	select VIDEOBUF2_DMA_SG
-- 
2.1.0.rc2

