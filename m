Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33050 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbbL3N0K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 08:26:10 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] [media] media: Kconfig: add dependency of HAS_DMA
Date: Wed, 30 Dec 2015 18:56:03 +0530
Message-Id: <1451481963-18853-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The build of m32r allmodconfig fails with the error:
drivers/media/v4l2-core/videobuf2-dma-contig.c:484:2:
	error: implicit declaration of function 'dma_get_cache_alignment'

The build of videobuf2-dma-contig.c depends on HAS_DMA and it is
correctly mentioned in the Kconfig but the symbol VIDEO_STI_BDISP also
selects VIDEOBUF2_DMA_CONTIG, so it is trying to compile
videobuf2-dma-contig.c even though HAS_DMA is not defined.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/media/platform/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 5263594..8b89ebe1 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -215,6 +215,7 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 config VIDEO_STI_BDISP
 	tristate "STMicroelectronics BDISP 2D blitter driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on HAS_DMA
 	depends on ARCH_STI || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-- 
1.9.1

