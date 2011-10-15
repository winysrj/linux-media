Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50114 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab1JOAD6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 20:03:58 -0400
Date: Fri, 14 Oct 2011 17:03:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org,
	Michal Nazarewicz <mina86@mina86.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Ankita Garg <ankita@in.ibm.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Mel Gorman <mel@csn.ul.ie>, Arnd Bergmann <arnd@arndb.de>,
	Jesse Barker <jesse.barker@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shariq Hasnain <shariq.hasnain@linaro.org>,
	Chunsang Jeong <chunsang.jeong@linaro.org>,
	Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/7] ARM: integrate CMA with DMA-mapping subsystem
Message-Id: <20111014170354.ebd604a6.akpm@linux-foundation.org>
In-Reply-To: <1317909290-29832-8-git-send-email-m.szyprowski@samsung.com>
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
	<1317909290-29832-8-git-send-email-m.szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 06 Oct 2011 15:54:47 +0200
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> This patch adds support for CMA to dma-mapping subsystem for ARM
> architecture. By default a global CMA area is used, but specific devices
> are allowed to have their private memory areas if required (they can be
> created with dma_declare_contiguous() function during board
> initialization).
> 
> Contiguous memory areas reserved for DMA are remapped with 2-level page
> tables on boot. Once a buffer is requested, a low memory kernel mapping
> is updated to to match requested memory access type.
> 
> GFP_ATOMIC allocations are performed from special pool which is created
> early during boot. This way remapping page attributes is not needed on
> allocation time.
> 
> CMA has been enabled unconditionally for ARMv6+ systems.
> 
>
> ...
>
> --- /dev/null
> +++ b/arch/arm/include/asm/dma-contiguous.h
> @@ -0,0 +1,33 @@
> +#ifndef ASMARM_DMA_CONTIGUOUS_H
> +#define ASMARM_DMA_CONTIGUOUS_H
> +
> +#ifdef __KERNEL__
> +
> +#include <linux/device.h>
> +#include <linux/dma-contiguous.h>
> +
> +#ifdef CONFIG_CMA
> +
> +#define MAX_CMA_AREAS	(8)

This was already defined in include/linux/dma-contiguous.h.  The
compiler didn't warn because it was defined to the same value.  Sort it
out, please?

>
> ...
>
> +static int __init early_coherent_pool(char *p)
> +{
> +	coherent_pool_size = memparse(p, &p);
> +	return 0;
> +}
> +early_param("coherent_pool", early_coherent_pool);

Is there user documentation for the new parameter?

>
> ...
>
> +struct dma_contiguous_early_reserve {
> +	phys_addr_t base;
> +	unsigned long size;
> +};
> +
> +static struct dma_contiguous_early_reserve
> +dma_mmu_remap[MAX_CMA_AREAS] __initdata;

Tab the continuation line to the right a bit.

> +
> +static int dma_mmu_remap_num __initdata;
>
> ...
>
> +static void *__alloc_from_pool(struct device *dev, size_t size,
> +			       struct page **ret_page)
> +{
> +	struct arm_vmregion *c;
> +	size_t align;
> +
> +	if (!coherent_head.vm_start) {
> +		printk(KERN_ERR "%s: coherent pool not initialised!\n",
> +		       __func__);
> +		dump_stack();
> +		return NULL;
> +	}
> +
> +	align = 1 << fls(size - 1);

Is there a roundup_pow_of_two() hiding in there?

> +	c = arm_vmregion_alloc(&coherent_head, align, size, 0);
> +	if (c) {
> +		void *ptr = (void *)c->vm_start;
> +		struct page *page = virt_to_page(ptr);
> +		*ret_page = page;
> +		return ptr;
> +	}
> +	return NULL;
> +}
>
> ...
>

