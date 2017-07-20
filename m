Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:32877 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935041AbdGTLqh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 07:46:37 -0400
MIME-Version: 1.0
In-Reply-To: <dc27b259-437d-177f-4e9c-73830b6656e2@xs4all.nl>
References: <20170719115137.2756-1-stanimir.varbanov@linaro.org> <dc27b259-437d-177f-4e9c-73830b6656e2@xs4all.nl>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 20 Jul 2017 13:46:36 +0200
Message-ID: <CAK8P3a324F5GffbwNRmhEM-zTFM+tAqyJ-5oEjetR2ZfhPzYtw@mail.gmail.com>
Subject: Re: [PATCH v2] media: venus: don't abuse dma_alloc for non-DMA allocations
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 20, 2017 at 1:26 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 19/07/17 13:51, Stanimir Varbanov wrote:
>> In venus_boot(), we pass a pointer to a phys_addr_t
>> into dmam_alloc_coherent, which the compiler warns about:
>>
>> platform/qcom/venus/firmware.c: In function 'venus_boot':
>> platform/qcom/venus/firmware.c:63:49: error: passing argument 3 of 'dmam_alloc_coherent' from incompatible pointer type [-Werror=incompatible-pointer-types]
>>
>> To avoid the error refactor venus_boot function by discard
>> dma_alloc_coherent invocation because we don't want to map the
>> memory for the device.  Something more, the usage of
>> DMA mapping API is actually wrong and the current
>> implementation relies on several bugs in DMA mapping code.
>> When these bugs are fixed that will break firmware loading,
>> so fix this now to avoid future troubles.
>>
>> The meaning of venus_boot is to copy the content of the
>> firmware buffer into reserved (and memblock removed)
>> block of memory and pass that physical address to the
>> trusted zone for authentication and mapping through iommu
>> form the secure world. After iommu mapping is done the iova
>> is passed as ane entry point to the remote processor.
>>
>> After this change memory-region property is parsed manually
>> and the physical address is memremap to CPU, call mdt_load to
>> load firmware segments into proper places and unmap
>> reserved memory.
>>
>> Fixes: af2c3834c8ca ("[media] media: venus: adding core part and helper functions")
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>
> Arnd, is this OK for you?

Looks good

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
