Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:34341 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbbJFHDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Oct 2015 03:03:16 -0400
Received: by lbbwt4 with SMTP id wt4so32957721lbb.1
        for <linux-media@vger.kernel.org>; Tue, 06 Oct 2015 00:03:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56132CF2.3060902@redhat.com>
References: <1444039898-7927-1-git-send-email-benjamin.gaignard@linaro.org>
	<56132CF2.3060902@redhat.com>
Date: Tue, 6 Oct 2015 09:03:14 +0200
Message-ID: <CA+M3ks74JbkzqXK+8-cGKYiPjj6CSxrnxbtm7xiRTjda7wFgyQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] RFC: Secure Memory Allocation Framework
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: Laura Abbott <labbott@redhat.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Rob Clark <robdclark@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Cooksey <tom.cooksey@arm.com>,
	Daniel Stone <daniel.stone@collabora.com>,
	linux-security-module@vger.kernel.org,
	Xiaoquan Li <xiaoquan.li@vivantecorp.com>,
	Tom Gall <tom.gall@linaro.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have mind few uses cases:
- the basic one when an HW device need contiguous memory.
- I have a device that could not cross some memory boundaries so I
need a specific allocator for it.
- when allocating memory for security some platform have address
constraints or need to allocate memory in specific areas (most of the
time because of firewall limited capacities in terms of regions)



2015-10-06 4:07 GMT+02:00 Laura Abbott <labbott@redhat.com>:
> On 10/05/2015 03:11 AM, Benjamin Gaignard wrote:
>>
>> version 4 changes:
>>   - rebased on kernel 4.3-rc3
>>   - fix missing EXPORT_SYMBOL for smaf_create_handle()
>>
>> version 3 changes:
>>   - Remove ioctl for allocator selection instead provide the name of
>>     the targeted allocator with allocation request.
>>     Selecting allocator from userland isn't the prefered way of working
>>     but is needed when the first user of the buffer is a software
>> component.
>>   - Fix issues in case of error while creating smaf handle.
>>   - Fix module license.
>>   - Update libsmaf and tests to care of the SMAF API evolution
>>     https://git.linaro.org/people/benjamin.gaignard/libsmaf.git
>>
>> version 2 changes:
>>   - Add one ioctl to allow allocator selection from userspace.
>>     This is required for the uses case where the first user of
>>     the buffer is a software IP which can't perform dma_buf attachement.
>>   - Add name and ranking to allocator structure to be able to sort them.
>>   - Create a tiny library to test SMAF:
>>     https://git.linaro.org/people/benjamin.gaignard/libsmaf.git
>>   - Fix one issue when try to secure buffer without secure module
>> registered
>>
>> The outcome of the previous RFC about how do secure data path was the need
>> of a secure memory allocator (https://lkml.org/lkml/2015/5/5/551)
>>
>> SMAF goal is to provide a framework that allow allocating and securing
>> memory by using dma_buf. Each platform have it own way to perform those
>> two
>> features so SMAF design allow to register helper modules to perform them.
>>
>> To be sure to select the best allocation method for devices SMAF implement
>> deferred allocation mechanism: memory allocation is only done when the
>> first
>> device effectively required it.
>> Allocator modules have to implement a match() to let SMAF know if they are
>> compatibles with devices needs.
>> This patch set provide an example of allocator module which use
>> dma_{alloc/free/mmap}_attrs() and check if at least one device have
>> coherent_dma_mask set to DMA_BIT_MASK(32) in match function.
>> I have named smaf-cma.c like it is done for drm_gem_cma_helper.c even if
>> a better name could be found for this file.
>>
>> Secure modules are responsibles of granting and revoking devices access
>> rights
>> on the memory. Secure module is also called to check if CPU map memory
>> into
>> kernel and user address spaces.
>> An example of secure module implementation can be found here:
>> http://git.linaro.org/people/benjamin.gaignard/optee-sdp.git
>> This code isn't yet part of the patch set because it depends on generic
>> TEE
>> which is still under discussion (https://lwn.net/Articles/644646/)
>>
>> For allocation part of SMAF code I get inspirated by Sumit Semwal work
>> about
>> constraint aware allocator.
>>
>
> Overall I like the abstraction. Do you have a use case in mind right now for
> the best allocation method? Some of the classic examples (mmu vs. no mmu)
> are gradually becoming less relevant as the systems have evolved. I was
> discussing constraints with Sumit w.r.t. Ion at plumbers so I'm curious
> about
> your uses.
>
> Thanks,
> Laura
>
>



-- 
Benjamin Gaignard

Graphic Working Group

Linaro.org │ Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
