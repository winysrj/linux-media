Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab3AHNFn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jan 2013 08:05:43 -0500
Date: Tue, 8 Jan 2013 11:05:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: gennarone@gmail.com, linux-media@vger.kernel.org
Subject: Re: cron job: media_tree daily build: ERRORS
Message-ID: <20130108110510.549fe616@redhat.com>
In-Reply-To: <201301081343.43562.hverkuil@xs4all.nl>
References: <20130107213823.ED56311E00F1@alastor.dyndns.org>
	<201301081058.11297.hverkuil@xs4all.nl>
	<50EBFC9F.2060103@gmail.com>
	<201301081343.43562.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 8 Jan 2013 13:43:43 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Tue 8 January 2013 12:01:51 Gianluca Gennari wrote:
> > Il 08/01/2013 10:58, Hans Verkuil ha scritto:
> > > On Mon 7 January 2013 22:38:23 Hans Verkuil wrote:
> > >> This message is generated daily by a cron job that builds media_tree for
> > >> the kernels and architectures in the list below.
> > >>
> > >> Results of the daily build of media_tree:
> > >>
> > >> date:        Mon Jan  7 19:00:18 CET 2013
> > >> git hash:    73ec66c000e9816806c7380ca3420f4e0638c40e
> > >> gcc version:      i686-linux-gcc (GCC) 4.7.1
> > >> host hardware:    x86_64
> > >> host os:          3.4.07-marune
> > >>
> > >> linux-git-arm-eabi-davinci: WARNINGS
> > >> linux-git-arm-eabi-exynos: WARNINGS
> > >> linux-git-arm-eabi-omap: ERRORS
> > >> linux-git-i686: OK
> > >> linux-git-m32r: OK
> > >> linux-git-mips: WARNINGS
> > >> linux-git-powerpc64: OK
> > >> linux-git-sh: OK
> > >> linux-git-x86_64: OK
> > >> linux-2.6.31.12-i686: WARNINGS
> > >> linux-2.6.32.6-i686: WARNINGS
> > >> linux-2.6.33-i686: WARNINGS
> > >> linux-2.6.34-i686: WARNINGS
> > >> linux-2.6.35.3-i686: WARNINGS
> > >> linux-2.6.36-i686: WARNINGS
> > >> linux-2.6.37-i686: WARNINGS
> > >> linux-2.6.38.2-i686: WARNINGS
> > >> linux-2.6.39.1-i686: WARNINGS
> > >> linux-3.0-i686: WARNINGS
> > >> linux-3.1-i686: WARNINGS
> > >> linux-3.2.1-i686: WARNINGS
> > >> linux-3.3-i686: WARNINGS
> > >> linux-3.4-i686: WARNINGS
> > >> linux-3.5-i686: WARNINGS
> > >> linux-3.6-i686: WARNINGS
> > >> linux-3.7-i686: WARNINGS
> > >> linux-3.8-rc1-i686: WARNINGS
> > >> linux-2.6.31.12-x86_64: WARNINGS
> > >> linux-2.6.32.6-x86_64: WARNINGS
> > >> linux-2.6.33-x86_64: WARNINGS
> > >> linux-2.6.34-x86_64: WARNINGS
> > >> linux-2.6.35.3-x86_64: WARNINGS
> > >> linux-2.6.36-x86_64: WARNINGS
> > >> linux-2.6.37-x86_64: WARNINGS
> > >> linux-2.6.38.2-x86_64: WARNINGS
> > >> linux-2.6.39.1-x86_64: WARNINGS
> > >> linux-3.0-x86_64: WARNINGS
> > >> linux-3.1-x86_64: WARNINGS
> > >> linux-3.2.1-x86_64: WARNINGS
> > >> linux-3.3-x86_64: WARNINGS
> > >> linux-3.4-x86_64: WARNINGS
> > >> linux-3.5-x86_64: WARNINGS
> > >> linux-3.6-x86_64: WARNINGS
> > >> linux-3.7-x86_64: WARNINGS
> > >> linux-3.8-rc1-x86_64: WARNINGS
> > >> apps: WARNINGS
> > >> spec-git: OK
> > >> sparse: ERRORS
> > >>
> > >> Detailed results are available here:
> > >>
> > >> http://www.xs4all.nl/~hverkuil/logs/Monday.log
> > > 
> > > There were a lot of new 'redefined' warnings that I have fixed.
> > > 
> > > In addition, it turned out that any driver using vb2 wasn't compiled for
> > > kernels <3.2 due to the fact that DMA_SHARED_BUFFER wasn't set. That's fixed
> > > as well, so drivers like em28xx and vivi will now compile on those older
> > > kernels. This also was the reason I never saw that the usb_translate_error
> > > function needed to be added to compat.h: it's used in em28xx but that driver
> > > was never compiled on kernels without usb_translate_error.
> > > 
> > > Hopefully everything works now.
> > > 
> > > Regards,
> > > 
> > > 	Hans
> > 
> > Hi Hans,
> > on kernel 2.6.32 (Ubuntu 10.04) the media_build tree compiles fine, with
> > just a few remaining warnings.
> > 
> > In particular, there are several new warnings related to DMA_SHARED_BUFFER:
> > 
> > WARNING: "dma_buf_vunmap" [media_build/v4l/videobuf2-vmalloc.ko] undefined!
> > WARNING: "dma_buf_vmap" [media_build/v4l/videobuf2-vmalloc.ko] undefined!
> > WARNING: "dma_buf_fd" [media_build/v4l/videobuf2-core.ko] undefined!
> > WARNING: "dma_buf_put" [media_build/v4l/videobuf2-core.ko] undefined!
> > WARNING: "dma_buf_get" [media_build/v4l/videobuf2-core.ko] undefined!
> 
> Gianluca,
> 
> Can you patch media_build with the patch below and try again? If it doesn't
> work, then replace '#ifdef CONFIG_DMA_SHARED_BUFFER' by '#if 0' in the patch
> below and try that instead.
> 
> Let me know what works.

You don't need to write a patch that replaces CONFIG_DMA_SHARED_BUFFER by 0.
you can patch, instead, v4l/scripts/make_kconfig.pl, like those:


# Kernel < 2.6.22 is missing the HAS_IOMEM option
if (!defined $kernopts{HAS_IOMEM} && cmp_ver($kernver, '2.6.22') < 0) {
    $kernopts{HAS_IOMEM} = 2;
}

# Kernel < 2.6.22 is missing the HAS_DMA option
if (!defined $kernopts{HAS_DMA} && cmp_ver($kernver, '2.6.22') < 0) {
    $kernopts{HAS_DMA} = 2;
}

# Kernel < 2.6.23 is missing the VIRT_TO_BUS option
if (!defined $kernopts{VIRT_TO_BUS} && cmp_ver($kernver, '2.6.23') < 0) {
	# VIRT_TO_BUS -> !PPC64
	$kernopts{VIRT_TO_BUS} = 2 - $kernopts{PPC64};
}

# Kernel < 2.6.37 is missing the BKL option
if (!defined $kernopts{BKL} && cmp_ver($kernver, '2.6.37') < 0) {
    $kernopts{BKL} = 2;
}

-- 

Cheers,
Mauro
