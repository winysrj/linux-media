Return-path: <linux-media-owner@vger.kernel.org>
Received: from laurent.telenet-ops.be ([195.130.137.89]:33224 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142AbbBLOLt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2015 09:11:49 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] [media] am437x: VIDEO_AM437X_VPFE should depend on HAS_DMA
Date: Thu, 12 Feb 2015 15:11:39 +0100
Message-Id: <1423750300-29433-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If NO_DMA=y:

    warning: (VIDEO_AM437X_VPFE && VIDEO_DM365_VPFE && VIDEO_DT3155 && VIDEO_OMAP4) selects VIDEOBUF2_DMA_CONTIG which has unmet direct dependencies (MEDIA_SUPPORT && HAS_DMA)

    drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
    drivers/media/v4l2-core/videobuf2-dma-contig.c:207: error: implicit declaration of function ‘dma_mmap_coherent’
    drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
    drivers/media/v4l2-core/videobuf2-dma-contig.c:390: error: implicit declaration of function ‘dma_get_sgtable’

VIDEO_AM437X_VPFE selects VIDEOBUF2_DMA_CONTIG, which bypasses its
dependency on HAS_DMA.  Make VIDEO_AM437X_VPFE depend on HAS_DMA to fix
this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/platform/am437x/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/am437x/Kconfig b/drivers/media/platform/am437x/Kconfig
index 7b023a76e32ebabc..42d9c186710a6423 100644
--- a/drivers/media/platform/am437x/Kconfig
+++ b/drivers/media/platform/am437x/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_AM437X_VPFE
 	tristate "TI AM437x VPFE video capture driver"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
 	depends on SOC_AM43XX || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	help
-- 
1.9.1

