Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38828 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389088AbeHGVSZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 17:18:25 -0400
Received: by mail-ed1-f68.google.com with SMTP id t2-v6so86185edr.5
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 12:02:39 -0700 (PDT)
Date: Tue, 7 Aug 2018 21:02:35 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH] dma-buf: Remove requirement for ops->map() from
 dma_buf_export
Message-ID: <20180807190235.GE3008@phenom.ffwll.local>
References: <20180807183647.22626-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180807183647.22626-1-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 07, 2018 at 07:36:47PM +0100, Chris Wilson wrote:
> Since commit 9ea0dfbf972 ("dma-buf: make map_atomic and map function
> pointers optional"), the core provides the no-op functions when map and
> map_atomic are not provided, so we no longer need assert that are
> supplied by a dma-buf exporter.
> 
> Fixes: 09ea0dfbf972 ("dma-buf: make map_atomic and map function pointers optional")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Gerd Hoffmann <kraxel@redhat.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>

Ooops.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  drivers/dma-buf/dma-buf.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 13884474d158..02f7f9a89979 100644
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
> 2.18.0
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
