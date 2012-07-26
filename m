Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54179 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab2GZLNl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 07:13:41 -0400
Received: by yhmm54 with SMTP id m54so1795177yhm.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 04:13:41 -0700 (PDT)
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
Subject: [PATCH v2 1/4] ARM: dma-mapping: define ARCH_HAS_DMA_MMAP_COHERENT
Date: Thu, 26 Jul 2012 20:13:08 +0900
Message-Id: <1343301191-26001-2-git-send-email-hdk@igel.co.jp>
In-Reply-To: <1343301191-26001-1-git-send-email-hdk@igel.co.jp>
References: <1343301191-26001-1-git-send-email-hdk@igel.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ARCH_HAS_DMA_MMAP_COHERENT indicates that there is dma_mmap_coherent() API
in this architecture.  The name is already defined in PowerPC.

Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
---
 arch/arm/include/asm/dma-mapping.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index bbef15d..f41cd30 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -187,6 +187,7 @@ extern int arm_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 			struct dma_attrs *attrs);
 
 #define dma_mmap_coherent(d, v, c, h, s) dma_mmap_attrs(d, v, c, h, s, NULL)
+#define ARCH_HAS_DMA_MMAP_COHERENT
 
 static inline int dma_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
 				  void *cpu_addr, dma_addr_t dma_addr,
-- 
1.7.0.4

