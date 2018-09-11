Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:39886 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbeIKUHX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 16:07:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: dri-devel@lists.freedesktop.org, daniel@ffwll.ch,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 12/13] udmabuf: use sizeof(variable) instead of sizeof(type)
Date: Tue, 11 Sep 2018 18:07:52 +0300
Message-ID: <12710794.bZoXGNj3NF@avalon>
In-Reply-To: <20180911134216.9760-13-kraxel@redhat.com>
References: <20180911134216.9760-1-kraxel@redhat.com> <20180911134216.9760-13-kraxel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gerd,

Thank you for the patch.

On Tuesday, 11 September 2018 16:42:15 EEST Gerd Hoffmann wrote:
> Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/dma-buf/udmabuf.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
> index 7a4fd2194d..92af9b5300 100644
> --- a/drivers/dma-buf/udmabuf.c
> +++ b/drivers/dma-buf/udmabuf.c
> @@ -128,7 +128,7 @@ static long udmabuf_create(const struct
> udmabuf_create_list *head, int seals, ret = -EINVAL;
>  	u32 i, flags;
> 
> -	ubuf = kzalloc(sizeof(struct udmabuf), GFP_KERNEL);
> +	ubuf = kzalloc(sizeof(*ubuf), GFP_KERNEL);
>  	if (!ubuf)
>  		return -ENOMEM;
> 
> @@ -142,7 +142,7 @@ static long udmabuf_create(const struct
> udmabuf_create_list *head, if (ubuf->pagecount > pglimit)
>  			goto err;
>  	}
> -	ubuf->pages = kmalloc_array(ubuf->pagecount, sizeof(struct page *),
> +	ubuf->pages = kmalloc_array(ubuf->pagecount, sizeof(*ubuf->pages),
>  				    GFP_KERNEL);
>  	if (!ubuf->pages) {
>  		ret = -ENOMEM;
> @@ -211,7 +211,7 @@ static long udmabuf_ioctl_create(struct file *filp,
> unsigned long arg) struct udmabuf_create_item list;
> 
>  	if (copy_from_user(&create, (void __user *)arg,
> -			   sizeof(struct udmabuf_create)))
> +			   sizeof(create)))
>  		return -EFAULT;
> 
>  	head.flags  = create.flags;

-- 
Regards,

Laurent Pinchart
