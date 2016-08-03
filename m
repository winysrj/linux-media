Return-path: <linux-media-owner@vger.kernel.org>
Received: from leibniz.telenet-ops.be ([195.130.137.77]:59125 "EHLO
	leibniz.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbcHCSaU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 14:30:20 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
	by leibniz.telenet-ops.be (Postfix) with ESMTP id 3s4Lkl0X19zMrMy7
	for <linux-media@vger.kernel.org>; Wed,  3 Aug 2016 20:12:15 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] [media] VIDEO_MEDIATEK_VCODEC should depend on HAS_DMA
Date: Wed,  3 Aug 2016 20:10:08 +0200
Message-Id: <1470247809-31212-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If NO_DMA=y:

    warning: (VIDEO_MEDIATEK_VCODEC && VIDEO_DM365_VPFE && VIDEO_OMAP4) selects VIDEOBUF2_DMA_CONTIG which has unmet direct dependencies (MEDIA_SUPPORT && HAS_DMA)

    drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_userptr’:
    drivers/media/v4l2-core/videobuf2-dma-contig.c:486: error: implicit declaration of function ‘dma_get_cache_alignment’

VIDEO_MEDIATEK_VCODEC selects VIDEOBUF2_DMA_CONTIG, which bypasses its
dependency on HAS_DMA.  Make VIDEO_MEDIATEK_VCODEC depend on HAS_DMA to
fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index f25344bc79126e2f..552b635cfce7f02b 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -169,7 +169,7 @@ config VIDEO_MEDIATEK_VPU
 config VIDEO_MEDIATEK_VCODEC
 	tristate "Mediatek Video Codec driver"
 	depends on MTK_IOMMU || COMPILE_TEST
-	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-- 
1.9.1

