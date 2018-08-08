Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44173 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbeHHKpi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 06:45:38 -0400
Received: by mail-ed1-f65.google.com with SMTP id f23-v6so820936edr.11
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2018 01:27:00 -0700 (PDT)
Date: Wed, 8 Aug 2018 10:26:57 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH] dma-buf: fix sanity check in dma_buf_export
Message-ID: <20180808082657.GJ3008@phenom.ffwll.local>
References: <20180808062540.13545-1-kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180808062540.13545-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 08, 2018 at 08:25:40AM +0200, Gerd Hoffmann wrote:
> Commit 09ea0dfbf972 made map_atomic and map function pointers optional,
> but didn't adapt the sanity check in dma_buf_export.  Fix that.
> 
> Note that the atomic map interface has been removed altogether meanwhile
> (commit f664a52695), therefore we have to remove the map check only.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

Chris Wilson just submitted the exact same patch ...
-Daniel

> ---
>  drivers/dma-buf/dma-buf.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 13884474d1..02f7f9a899 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -405,7 +405,6 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>  			  || !exp_info->ops->map_dma_buf
>  			  || !exp_info->ops->unmap_dma_buf
>  			  || !exp_info->ops->release
> -			  || !exp_info->ops->map
>  			  || !exp_info->ops->mmap)) {
>  		return ERR_PTR(-EINVAL);
>  	}
> -- 
> 2.9.3
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
