Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60864 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752085AbeBFINf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Feb 2018 03:13:35 -0500
Subject: Re: [PATCH v2] media: vb2: Fix videobuf2 to map correct area
To: Masami Hiramatsu <mhiramat@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        orito.takao@socionext.com,
        Fumihiro ATSUMI <atsumi@infinitegra.co.jp>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <cd355844-89d0-b49a-0244-c0e45fc68724@samsung.com>
Date: Tue, 06 Feb 2018 09:13:30 +0100
MIME-version: 1.0
In-reply-to: <151790414344.19507.15297848847845554616.stgit@devbox>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-transfer-encoding: 7bit
Content-language: en-US
References: <CGME20180206080251epcas1p2845745f8edcb71fcce8babcd0c5c4f3a@epcas1p2.samsung.com>
        <151790414344.19507.15297848847845554616.stgit@devbox>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Masami,

On 2018-02-06 09:02, Masami Hiramatsu wrote:
> Fixes vb2_vmalloc_get_userptr() to ioremap correct area.
> Since the current code does ioremap the page address, if the offset > 0,
> it does not do ioremap the last page and results in kernel panic.
>
> This fixes to pass the size + offset to ioremap so that ioremap
> can map correct area. Also, this uses __pfn_to_phys() to get the physical
> address of given PFN.
>
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> Reported-by: Takao Orito <orito.takao@socionext.com>
> Reported-by: Fumihiro ATSUMI <atsumi@infinitegra.co.jp>

Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>    Chanegs in v2:
>     - Fix to pass size + offset instead of changing address.
> ---
>   drivers/media/v4l2-core/videobuf2-vmalloc.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> index 3a7c80cd1a17..359fb9804d16 100644
> --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
> +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> @@ -106,7 +106,7 @@ static void *vb2_vmalloc_get_userptr(struct device *dev, unsigned long vaddr,
>   			if (nums[i-1] + 1 != nums[i])
>   				goto fail_map;
>   		buf->vaddr = (__force void *)
> -				ioremap_nocache(nums[0] << PAGE_SHIFT, size);
> +			ioremap_nocache(__pfn_to_phys(nums[0]), size + offset);
>   	} else {
>   		buf->vaddr = vm_map_ram(frame_vector_pages(vec), n_pages, -1,
>   					PAGE_KERNEL);
>
>
>
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
