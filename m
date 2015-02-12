Return-path: <linux-media-owner@vger.kernel.org>
Received: from michel.telenet-ops.be ([195.130.137.88]:49403 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbbBLOLv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2015 09:11:51 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] [media] timberdale: VIDEO_TIMBERDALE should depend on HAS_DMA
Date: Thu, 12 Feb 2015 15:11:40 +0100
Message-Id: <1423750300-29433-2-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1423750300-29433-1-git-send-email-geert@linux-m68k.org>
References: <1423750300-29433-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If NO_DMA=y:

    warning: (VIDEO_OMAP2_VOUT && VIDEO_VIU && VIDEO_TIMBERDALE) selects VIDEOBUF_DMA_CONTIG which has unmet direct dependencies (MEDIA_SUPPORT && HAS_DMA)

    drivers/built-in.o: In function `__videobuf_dc_free':
    videobuf-dma-contig.c:(.text+0x6f4d32): undefined reference to `dma_free_coherent'
    drivers/built-in.o: In function `__videobuf_dc_alloc':
    videobuf-dma-contig.c:(.text+0x6f4fe6): undefined reference to `dma_alloc_coherent'
    drivers/built-in.o: In function `__videobuf_mmap_mapper':
    videobuf-dma-contig.c:(.text+0x6f518e): undefined reference to `dma_free_coherent'

Commit 244829226f47ffb4 ("[media] timberdale: do not select TIMB_DMA")
dropped the dependency of VIDEO_TIMBERDALE on DMADEVICES, and thus the
implicit dependency on HAS_DMA.  VIDEO_TIMBERDALE selects
VIDEOBUF_DMA_CONTIG, which bypasses its dependency on HAS_DMA.  Make
VIDEO_TIMBERDALE depend on HAS_DMA to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index d9b872b9285a3460..2e30be55d17a7db2 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -56,7 +56,7 @@ config VIDEO_VIU
 
 config VIDEO_TIMBERDALE
 	tristate "Support for timberdale Video In/LogiWIN"
-	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && HAS_DMA
 	depends on (MFD_TIMBERDALE && TIMB_DMA) || COMPILE_TEST
 	select VIDEO_ADV7180
 	select VIDEOBUF_DMA_CONTIG
-- 
1.9.1

