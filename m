Return-path: <linux-media-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:48507 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030479AbbDWSJM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 14:09:12 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/3] [media] v4l: xilinx: VIDEO_XILINX should depend on HAS_DMA
Date: Thu, 23 Apr 2015 20:09:05 +0200
Message-Id: <1429812547-9640-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If NO_DMA=y:

    warning: (VIDEO_XILINX && VIDEO_DM365_VPFE && VIDEO_DT3155 && VIDEO_OMAP4) selects VIDEOBUF2_DMA_CONTIG which has unmet direct dependencies (MEDIA_SUPPORT && HAS_DMA)

    media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
    media/v4l2-core/videobuf2-dma-contig.c:207: error: implicit declaration of function ‘dma_mmap_coherent’
    media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
    media/v4l2-core/videobuf2-dma-contig.c:390: error: implicit declaration of function ‘dma_get_sgtable’

VIDEO_XILINX selects VIDEOBUF2_DMA_CONTIG, which bypasses its dependency
on HAS_DMA.  Make VIDEO_XILINX depend on HAS_DMA to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/platform/xilinx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/xilinx/Kconfig b/drivers/media/platform/xilinx/Kconfig
index d7324c726fc2a881..84bae795b70d3148 100644
--- a/drivers/media/platform/xilinx/Kconfig
+++ b/drivers/media/platform/xilinx/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_XILINX
 	tristate "Xilinx Video IP (EXPERIMENTAL)"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  Driver for Xilinx Video IP Pipelines
-- 
1.9.1

