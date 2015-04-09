Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:23332 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbbDIAiJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 20:38:09 -0400
From: Cho KyongHo <pullip.cho@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
	mchehab@osg.samsung.com
Cc: hans.verkuil@cisco.com
References: <20150205145242.ebb07029fa8664144d687697@samsung.com>
 <552550BE.5030603@xs4all.nl>
In-reply-to: <552550BE.5030603@xs4all.nl>
Subject: RE: [PATCH] [media] v4l: vb2-memops: use vma slab when vma allocation
Date: Thu, 09 Apr 2015 09:38:00 +0900
Message-id: <000401d0725d$724ae3e0$56e0aba0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,
I didn't notice that vb2_put_vma is exported because I don't build modules.
I am sorry about bothering you.

Mauro,
I think it is better to drop my patch out from your tree
because I don't think it is not worth to export vm_area_cache_p to use it
in vb2_put_vma.

Regards,

KyongHo

-----Original Message-----
From: Hans Verkuil [mailto:hverkuil@xs4all.nl] 
Sent: Thursday, April 09, 2015 1:01 AM

Mauro,

Please revert this patch: vm_area_cachep is not exported, so you cannot use
this in a module.

Cho KyongHo, if you believe that vm_area_cachep should be exported so it can
be used here, then please make a patch for that.

For the time being though, this patch should be reverted.

This patch slipped through the cracks and I clearly never reviewed it, and I
only noticed the problem after I compiled the media_tree git repo after this
patch was merged.

Regards,

	Hans

On 02/05/2015 06:52 AM, Cho KyongHo wrote:
> The slab for vm_area_struct which is vm_area_cachep is already 
> prepared for the general use. Instead of kmalloc() for the vma copy 
> for userptr, allocation from vm_area_cachep is more beneficial.
> 
> CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> CC: Hans Verkuil <hans.verkuil@cisco.com>
> CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>  drivers/media/v4l2-core/videobuf2-memops.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-memops.c 
> b/drivers/media/v4l2-core/videobuf2-memops.c
> index 81c1ad8..dd06efa 100644
> --- a/drivers/media/v4l2-core/videobuf2-memops.c
> +++ b/drivers/media/v4l2-core/videobuf2-memops.c
> @@ -37,7 +37,7 @@ struct vm_area_struct *vb2_get_vma(struct 
> vm_area_struct *vma)  {
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

