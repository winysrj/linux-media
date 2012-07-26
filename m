Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61810 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2GZLNi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 07:13:38 -0400
Received: by pbbrp8 with SMTP id rp8so3069482pbb.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 04:13:38 -0700 (PDT)
From: Hideki EIRAKU <hdk@igel.co.jp>
To: Russell King <linux@arm.linux.org.uk>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
	alsa-devel@alsa-project.org, Katsuya MATSUBARA <matsu@igel.co.jp>,
	Hideki EIRAKU <hdk@igel.co.jp>
Subject: [PATCH v2 0/4] Use dma_mmap_coherent to support IOMMU mapper
Date: Thu, 26 Jul 2012 20:13:07 +0900
Message-Id: <1343301191-26001-1-git-send-email-hdk@igel.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a dma_mmap_coherent() API in some architectures.  This API
provides a mmap function for memory allocated by dma_alloc_coherent().
Some drivers mmap a dma_addr_t returned by dma_alloc_coherent() as a
physical address.  But such drivers do not work correctly when IOMMU
mapper is used.

v2:
- Rebase on fbdev-next branch of
  git://github.com/schandinat/linux-2.6.git.
- Initialize .fb_mmap in both sh_mobile_lcdc_overlay_ops and
  sh_mobile_lcdc_ops.
- Add Laurent's clean up patch.

Hideki EIRAKU (3):
  ARM: dma-mapping: define ARCH_HAS_DMA_MMAP_COHERENT
  media: videobuf2-dma-contig: use dma_mmap_coherent if available
  fbdev: sh_mobile_lcdc: use dma_mmap_coherent if available

Laurent Pinchart (1):
  ALSA: pcm - Don't define ARCH_HAS_DMA_MMAP_COHERENT privately for ARM

 arch/arm/include/asm/dma-mapping.h         |    1 +
 drivers/media/video/videobuf2-dma-contig.c |   18 ++++++++++++++++++
 drivers/video/sh_mobile_lcdcfb.c           |   28 ++++++++++++++++++++++++++++
 sound/core/pcm_native.c                    |    7 -------
 4 files changed, 47 insertions(+), 7 deletions(-)

