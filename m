Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35933 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753234AbdF0UPU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 16:15:20 -0400
MIME-Version: 1.0
In-Reply-To: <1d7621d4-b7c6-b21b-f06e-ed6baa1b00ca@linaro.org>
References: <20170627150310.719212-1-arnd@arndb.de> <20170627150310.719212-2-arnd@arndb.de>
 <1d7621d4-b7c6-b21b-f06e-ed6baa1b00ca@linaro.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 27 Jun 2017 22:15:18 +0200
Message-ID: <CAK8P3a3cNZ8-Jkmnk4tSmXQA6yqsCfxPvJaUY8Zd007w1tRvDQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] [media] venus: don't abuse dma_alloc for non-DMA allocations
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 27, 2017 at 9:39 PM, Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
> Hi Arnd,
>
> On 27.06.2017 18:02, Arnd Bergmann wrote:
>>
>> In venus_boot(), we pass a pointer to a phys_addr_t
>> into dmam_alloc_coherent, which the compiler warns about:
>>
>> platform/qcom/venus/firmware.c: In function 'venus_boot':
>> platform/qcom/venus/firmware.c:63:49: error: passing argument 3 of
>> 'dmam_alloc_coherent' from incompatible pointer type
>> [-Werror=incompatible-pointer-types]
>>
>> The returned DMA address is later passed on to a function that
>> takes a phys_addr_t, so it's clearly wrong to use the DMA
>> mapping interface here: the memory may be uncached, or the
>> address may be completely wrong if there is an IOMMU connected
>> to the device.
>>
>> My interpretation is that using dmam_alloc_coherent() had two
>> purposes:
>>
>>   a) get a chunk of consecutive memory that may be larger than
>>      the limit for kmalloc()
>>
>>   b) use the devres infrastructure to simplify the unwinding
>>      in the error case.
>
>
> The intension here is to use per-device memory which is removed from kernel
> allocator, that memory is used by remote processor (Venus) for its code
> section and system memory, the memory must not be mapped to kernel to avoid
> any cache issues.
>
> As the memory in subject is reserved per-device memory the only legal way to
> allocate it is by dmam_alloc_coherent() -> dma_alloc_from_coherent().
>
> For me the confusion comes from phys_addr_t which is passed to
> qcom_mdt_load() and then the address passed to qcom_scm_pas_mem_setup()
> which probably protects that physical memory. And the tz really expects
> physical address.
>
> The only solution I see is by casting dma_addr_t to phys_addr_t. Yes it is
> ugly but what is proper solution then?

If you actually have a separate remote processor that accesses this memory,
then qcom_mdt_load() is the wrong interface, as it takes a physical address,
and we need to introduce another interface that can take a DMA address
relative to a particular device.

You cannot cast between the two types because phys_addr_t is an address
as seen from the CPU, and dma_addr_t is seen by a particular device,
and can only be used together with that device pointer.

It looks like the pointer gets passed down to
qcom_scm_call(dev, QCOM_SCM_SVC_PIL,
QCOM_SCM_PAS_MEM_SETUP_CMD, ...), which in turn takes
a 32-bit address, suggesting that this is indeed a dma address for that
device (possibly going through an IOMMU), so maybe it just needs to
all be changed to dma_addr_t.

Is there any official documentation for qcom_scm_call() that clarifies
what address space the arguments are in?

        Arnd
