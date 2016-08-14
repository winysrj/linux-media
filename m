Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:54134 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752247AbcHNJqC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 05:46:02 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Tiffany Lin <tiffany.lin@mediatek.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] for v4.8 mtk-vcodec: add HAS_DMA dependency
Message-ID: <616ddb70-e1e4-0477-857a-a5ac4d77ffa8@xs4all.nl>
Date: Sun, 14 Aug 2016 11:45:54 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes this kbuild test robot error:

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   329f4152911c276b074bec75a0443f88821afdb7
commit: c1023ba74fc77dc56dc317bd98f5060aab889ac1 [media] drivers/media/platform/Kconfig: fix VIDEO_MEDIATEK_VCODEC dependency
date:   5 weeks ago
config: m32r-allyesconfig (attached as .config)
compiler: m32r-linux-gcc (GCC) 4.9.0
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout c1023ba74fc77dc56dc317bd98f5060aab889ac1
        # save the attached .config to linux build tree
        make.cross ARCH=m32r

All errors (new ones prefixed by >>):

   drivers/media/v4l2-core/videobuf2-dma-contig.c: In function 'vb2_dc_get_userptr':
>> >> drivers/media/v4l2-core/videobuf2-dma-contig.c:486:2: error: implicit declaration of function 'dma_get_cache_alignment' [-Werror=implicit-function-declaration]
     unsigned long dma_align = dma_get_cache_alignment();
     ^
   cc1: some warnings being treated as errors

This driver depends on HAS_DMA for dma_get_cache_alignment().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index f25344b..552b635 100644
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
