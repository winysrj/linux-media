Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:53778 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932112AbbDHQBK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2015 12:01:10 -0400
Message-ID: <552550BE.5030603@xs4all.nl>
Date: Wed, 08 Apr 2015 18:01:02 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Cho KyongHo <pullip.cho@samsung.com>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
	mchehab@osg.samsung.com
CC: hans.verkuil@cisco.com
Subject: Re: [PATCH] [media] v4l: vb2-memops: use vma slab when vma allocation
References: <20150205145242.ebb07029fa8664144d687697@samsung.com>
In-Reply-To: <20150205145242.ebb07029fa8664144d687697@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please revert this patch: vm_area_cachep is not exported, so you cannot use this
in a module.

Cho KyongHo, if you believe that vm_area_cachep should be exported so it can be
used here, then please make a patch for that.

For the time being though, this patch should be reverted.

This patch slipped through the cracks and I clearly never reviewed it, and I only
noticed the problem after I compiled the media_tree git repo after this patch
was merged.

Regards,

	Hans

On 02/05/2015 06:52 AM, Cho KyongHo wrote:
> The slab for vm_area_struct which is vm_area_cachep is already prepared
> for the general use. Instead of kmalloc() for the vma copy for userptr,
> allocation from vm_area_cachep is more beneficial.
> 
> CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> CC: Hans Verkuil <hans.verkuil@cisco.com>
> CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>  drivers/media/v4l2-core/videobuf2-memops.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-memops.c b/drivers/media/v4l2-core/videobuf2-memops.c
> index 81c1ad8..dd06efa 100644
> --- a/drivers/media/v4l2-core/videobuf2-memops.c
> +++ b/drivers/media/v4l2-core/videobuf2-memops.c
> @@ -37,7 +37,7 @@ struct vm_area_struct *vb2_get_vma(struct vm_area_struct *vma)
>  {
>  	struct vm_area_struct *vma_copy;
>  
> -	vma_copy = kmalloc(sizeof(*vma_copy), GFP_KERNEL);
> +	vma_copy = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
>  	if (vma_copy == NULL)
>  		return NULL;
>  
> @@ -75,7 +75,7 @@ void vb2_put_vma(struct vm_area_struct *vma)
>  	if (vma->vm_file)
>  		fput(vma->vm_file);
>  
> -	kfree(vma);
> +	kmem_cache_free(vm_area_cachep, vma);
>  }
>  EXPORT_SYMBOL_GPL(vb2_put_vma);
>  
> 

