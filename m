Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50239 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbcEXHQY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 03:16:24 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v5 0/2] vb2-dma-contig: configure DMA max segment size properly
Date: Tue, 24 May 2016 09:16:05 +0200
Message-id: <1464074167-27330-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch is a follow-up of my previous attempts to let Exynos
multimedia devices to work properly with shared buffers when IOMMU is
enabled:
1. https://www.mail-archive.com/linux-media@vger.kernel.org/msg96946.html
2. http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/97316
3. https://patchwork.linuxtv.org/patch/30870/
4. http://www.spinics.net/lists/linux-media/msg100353.html

After another discussion (4th link above) I agree with Mauro that
changing dma_parms should be done from device drivers not the
videobuf2-dc module. Now drivers releases dma_parms structure (allocated
by vb2_dc_set_max_seg_size()), which in theory might be allocated by
other function than vb2_dc_set_max_seg_size(). This is however not a big
issue, because no such case exist in mainline kernel (there is no
generic bus code for platform devices, which allocates dma_parms
structure).

Here is some more backgroud why this is done in videobuf2-dc not in the
respective generic bus code:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/305913.html

Best regards,
Marek Szyprowski

changelog:
v5:
- got back to the v1-style version on Mauro request
- added function to clear dma_parms and release allocated structure

v4: http://www.spinics.net/lists/linux-media/msg100182.html
- rebased onto media master tree
- call vb2_dc_set_max_seg_size after allocating vb2 buf object

v3: http://www.spinics.net/lists/linux-media/msg100125.html
- added FIXME note about possible memory leak

v2: http://www.spinics.net/lists/linux-media/msg100011.html
- fixes typos and other language issues in the comments

v1: http://article.gmane.org/gmane.linux.kernel.samsung-soc/53690

Marek Szyprowski (2):
  media: vb2-dma-contig: add helper for setting dma max seg size
  media: set proper max seg size for devices on Exynos SoCs

 drivers/media/platform/exynos-gsc/gsc-core.c   |  2 +
 drivers/media/platform/exynos4-is/fimc-core.c  |  2 +
 drivers/media/platform/exynos4-is/fimc-is.c    |  2 +
 drivers/media/platform/exynos4-is/fimc-lite.c  |  2 +
 drivers/media/platform/s5p-g2d/g2d.c           |  2 +
 drivers/media/platform/s5p-jpeg/jpeg-core.c    |  2 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c       |  4 ++
 drivers/media/platform/s5p-tv/mixer_video.c    |  2 +
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 53 ++++++++++++++++++++++++++
 include/media/videobuf2-dma-contig.h           |  2 +
 10 files changed, 73 insertions(+)

-- 
1.9.2

