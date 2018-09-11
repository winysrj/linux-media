Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34166 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbeIKOgG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 10:36:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: dri-devel@lists.freedesktop.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] udmabuf: improve map_udmabuf error handling
Date: Tue, 11 Sep 2018 12:37:48 +0300
Message-ID: <2321736.6fDm34KxGD@avalon>
In-Reply-To: <20180911065921.23818-3-kraxel@redhat.com>
References: <20180911065921.23818-1-kraxel@redhat.com> <20180911065921.23818-3-kraxel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gerd,

Thank you for the patch.

On Tuesday, 11 September 2018 09:59:13 EEST Gerd Hoffmann wrote:

A commit message would be nice, for all patches in this series.

> Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

Reviewed-by: Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/dma-buf/udmabuf.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
> index e63d301bcb..19bd918209 100644
> --- a/drivers/dma-buf/udmabuf.c
> +++ b/drivers/dma-buf/udmabuf.c
> @@ -51,25 +51,24 @@ static struct sg_table *map_udmabuf(struct
> dma_buf_attachment *at, {
>  	struct udmabuf *ubuf = at->dmabuf->priv;
>  	struct sg_table *sg;
> +	int ret;
> 
>  	sg = kzalloc(sizeof(*sg), GFP_KERNEL);
>  	if (!sg)
> -		goto err1;
> -	if (sg_alloc_table_from_pages(sg, ubuf->pages, ubuf->pagecount,
> -				      0, ubuf->pagecount << PAGE_SHIFT,
> -				      GFP_KERNEL) < 0)
> -		goto err2;
> +		return ERR_PTR(-ENOMEM);
> +	ret = sg_alloc_table_from_pages(sg, ubuf->pages, ubuf->pagecount,
> +					0, ubuf->pagecount << PAGE_SHIFT,
> +					GFP_KERNEL);
> +	if (ret < 0)
> +		goto err;
>  	if (!dma_map_sg(at->dev, sg->sgl, sg->nents, direction))
> -		goto err3;
> -
> +		goto err;
>  	return sg;
> 
> -err3:
> +err:
>  	sg_free_table(sg);
> -err2:
>  	kfree(sg);
> -err1:
> -	return ERR_PTR(-ENOMEM);
> +	return ERR_PTR(ret);
>  }
> 
>  static void unmap_udmabuf(struct dma_buf_attachment *at,

-- 
Regards,

Laurent Pinchart
