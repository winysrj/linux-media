Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:39862 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292AbbBMI5P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 03:57:15 -0500
Message-ID: <54DDBC5A.8020905@xs4all.nl>
Date: Fri, 13 Feb 2015 09:56:58 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
CC: mchehab@osg.samsung.com
Subject: Re: [REVIEW PATCH FOR v3.19 1/1] vb2: Fix dma_dir setting for dma-contig
 mem type
References: <1423813357-31446-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1423813357-31446-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/13/2015 08:42 AM, Sakari Ailus wrote:
> The last argument of vb2_dc_get_user_pages() is of type enum
> dma_data_direction, but the caller, vb2_dc_get_userptr() passes a value
> which is the result of comparison dma_dir == DMA_FROM_DEVICE. This results
> in the write parameter to get_user_pages() being zero in all cases, i.e.
> that the caller has no intent to write there.
> 
> This was broken by patch "vb2: replace 'write' by 'dma_dir'".
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Yuck.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index b481d20..69e0483 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -632,8 +632,7 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
>  	}
>  
>  	/* extract page list from userspace mapping */
> -	ret = vb2_dc_get_user_pages(start, pages, n_pages, vma,
> -				    dma_dir == DMA_FROM_DEVICE);
> +	ret = vb2_dc_get_user_pages(start, pages, n_pages, vma, dma_dir);
>  	if (ret) {
>  		unsigned long pfn;
>  		if (vb2_dc_get_user_pfn(start, n_pages, vma, &pfn) == 0) {
> 

