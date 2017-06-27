Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:36645 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753249AbdF0Tjt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 15:39:49 -0400
Received: by mail-wr0-f174.google.com with SMTP id c11so164293674wrc.3
        for <linux-media@vger.kernel.org>; Tue, 27 Jun 2017 12:39:48 -0700 (PDT)
Subject: Re: [PATCH 2/3] [media] venus: don't abuse dma_alloc for non-DMA
 allocations
To: Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20170627150310.719212-1-arnd@arndb.de>
 <20170627150310.719212-2-arnd@arndb.de>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <1d7621d4-b7c6-b21b-f06e-ed6baa1b00ca@linaro.org>
Date: Tue, 27 Jun 2017 22:39:45 +0300
MIME-Version: 1.0
In-Reply-To: <20170627150310.719212-2-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On 27.06.2017 18:02, Arnd Bergmann wrote:
> In venus_boot(), we pass a pointer to a phys_addr_t
> into dmam_alloc_coherent, which the compiler warns about:
> 
> platform/qcom/venus/firmware.c: In function 'venus_boot':
> platform/qcom/venus/firmware.c:63:49: error: passing argument 3 of 'dmam_alloc_coherent' from incompatible pointer type [-Werror=incompatible-pointer-types]
> 
> The returned DMA address is later passed on to a function that
> takes a phys_addr_t, so it's clearly wrong to use the DMA
> mapping interface here: the memory may be uncached, or the
> address may be completely wrong if there is an IOMMU connected
> to the device.
> 
> My interpretation is that using dmam_alloc_coherent() had two
> purposes:
> 
>   a) get a chunk of consecutive memory that may be larger than
>      the limit for kmalloc()
> 
>   b) use the devres infrastructure to simplify the unwinding
>      in the error case.

The intension here is to use per-device memory which is removed from 
kernel allocator, that memory is used by remote processor (Venus) for 
its code section and system memory, the memory must not be mapped to 
kernel to avoid any cache issues.

As the memory in subject is reserved per-device memory the only legal 
way to allocate it is by dmam_alloc_coherent() -> 
dma_alloc_from_coherent().

For me the confusion comes from phys_addr_t which is passed to 
qcom_mdt_load() and then the address passed to qcom_scm_pas_mem_setup() 
which probably protects that physical memory. And the tz really expects 
physical address.

The only solution I see is by casting dma_addr_t to phys_addr_t. Yes it 
is ugly but what is proper solution then?

> 
> I think ideally we'd use a devres-based version of
> alloc_pages_exact() here, but since that doesn't exist,
> let's use devm_get_free_pages() instead. This wastes a little
> memory as the size gets rounded up to a power of two, but
> is otherwise harmless. If we want to save memory here, calling
> devm_free_pages() to release the memory once it is no longer
> needed is probably better anyway.
> 
> Fixes: af2c3834c8ca ("[media] media: venus: adding core part and helper functions")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> The same problem exists in the drm driver, as of commit 7c65817e6d38
> ("drm/msm: gpu: Enable zap shader for A5XX"), and I submitted the
> same patch for that already.
> ---
>   drivers/media/platform/qcom/venus/firmware.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> index 1b1a4f355918..76edb9f60311 100644
> --- a/drivers/media/platform/qcom/venus/firmware.c
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -60,11 +60,13 @@ int venus_boot(struct device *parent, struct device *fw_dev, const char *fwname)
>   
>   	mem_size = VENUS_FW_MEM_SIZE;
>   
> -	mem_va = dmam_alloc_coherent(fw_dev, mem_size, &mem_phys, GFP_KERNEL);
> +	mem_va = (void *)devm_get_free_pages(parent, GFP_KERNEL,
> +					     get_order(mem_size));
>   	if (!mem_va) {
>   		ret = -ENOMEM;
>   		goto err_unreg_device;
>   	}
> +	mem_phys = virt_to_phys(mem_va);
>   
>   	ret = request_firmware(&mdt, fwname, fw_dev);
>   	if (ret < 0)
> 

regards,
Stan
