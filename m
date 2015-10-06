Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbbJFCHu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2015 22:07:50 -0400
Subject: Re: [PATCH v4 0/2] RFC: Secure Memory Allocation Framework
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, treding@nvidia.com, sumit.semwal@linaro.org,
	tom.cooksey@arm.com, daniel.stone@collabora.com,
	linux-security-module@vger.kernel.org, xiaoquan.li@vivantecorp.com
References: <1444039898-7927-1-git-send-email-benjamin.gaignard@linaro.org>
Cc: tom.gall@linaro.org, linaro-mm-sig@lists.linaro.org
From: Laura Abbott <labbott@redhat.com>
Message-ID: <56132CF2.3060902@redhat.com>
Date: Mon, 5 Oct 2015 19:07:46 -0700
MIME-Version: 1.0
In-Reply-To: <1444039898-7927-1-git-send-email-benjamin.gaignard@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/05/2015 03:11 AM, Benjamin Gaignard wrote:
> version 4 changes:
>   - rebased on kernel 4.3-rc3
>   - fix missing EXPORT_SYMBOL for smaf_create_handle()
>
> version 3 changes:
>   - Remove ioctl for allocator selection instead provide the name of
>     the targeted allocator with allocation request.
>     Selecting allocator from userland isn't the prefered way of working
>     but is needed when the first user of the buffer is a software component.
>   - Fix issues in case of error while creating smaf handle.
>   - Fix module license.
>   - Update libsmaf and tests to care of the SMAF API evolution
>     https://git.linaro.org/people/benjamin.gaignard/libsmaf.git
>
> version 2 changes:
>   - Add one ioctl to allow allocator selection from userspace.
>     This is required for the uses case where the first user of
>     the buffer is a software IP which can't perform dma_buf attachement.
>   - Add name and ranking to allocator structure to be able to sort them.
>   - Create a tiny library to test SMAF:
>     https://git.linaro.org/people/benjamin.gaignard/libsmaf.git
>   - Fix one issue when try to secure buffer without secure module registered
>
> The outcome of the previous RFC about how do secure data path was the need
> of a secure memory allocator (https://lkml.org/lkml/2015/5/5/551)
>
> SMAF goal is to provide a framework that allow allocating and securing
> memory by using dma_buf. Each platform have it own way to perform those two
> features so SMAF design allow to register helper modules to perform them.
>
> To be sure to select the best allocation method for devices SMAF implement
> deferred allocation mechanism: memory allocation is only done when the first
> device effectively required it.
> Allocator modules have to implement a match() to let SMAF know if they are
> compatibles with devices needs.
> This patch set provide an example of allocator module which use
> dma_{alloc/free/mmap}_attrs() and check if at least one device have
> coherent_dma_mask set to DMA_BIT_MASK(32) in match function.
> I have named smaf-cma.c like it is done for drm_gem_cma_helper.c even if
> a better name could be found for this file.
>
> Secure modules are responsibles of granting and revoking devices access rights
> on the memory. Secure module is also called to check if CPU map memory into
> kernel and user address spaces.
> An example of secure module implementation can be found here:
> http://git.linaro.org/people/benjamin.gaignard/optee-sdp.git
> This code isn't yet part of the patch set because it depends on generic TEE
> which is still under discussion (https://lwn.net/Articles/644646/)
>
> For allocation part of SMAF code I get inspirated by Sumit Semwal work about
> constraint aware allocator.
>

Overall I like the abstraction. Do you have a use case in mind right now for
the best allocation method? Some of the classic examples (mmu vs. no mmu)
are gradually becoming less relevant as the systems have evolved. I was
discussing constraints with Sumit w.r.t. Ion at plumbers so I'm curious about
your uses.

Thanks,
Laura


