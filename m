Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57568 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbcCaQ0z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2016 12:26:55 -0400
Message-ID: <1459441216.8191.21.camel@linux.intel.com>
Subject: Re: [Intel-gfx] [PATCH] dma-buf: Release module reference on
 creation failure
From: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
	intel-gfx@lists.freedesktop.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	linux-media@vger.kernel.org
Date: Thu, 31 Mar 2016 19:20:16 +0300
In-Reply-To: <1459413350-31082-1-git-send-email-chris@chris-wilson.co.uk>
References: <1459413350-31082-1-git-send-email-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On to, 2016-03-31 at 09:35 +0100, Chris Wilson wrote:
> If we fail to create the anon file, we need to remember to release the
> module reference on the owner.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: linux-media@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linaro-mm-sig@lists.linaro.org
> ---
>  drivers/dma-buf/dma-buf.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 4a2c07ee6677..6f0f0b10a241 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -333,6 +333,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>  	struct reservation_object *resv = exp_info->resv;
>  	struct file *file;
>  	size_t alloc_size = sizeof(struct dma_buf);
> +	int ret;
>  
>  	if (!exp_info->resv)
>  		alloc_size += sizeof(struct reservation_object);
> @@ -356,8 +357,8 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>  
>  	dmabuf = kzalloc(alloc_size, GFP_KERNEL);
>  	if (!dmabuf) {
> -		module_put(exp_info->owner);
> -		return ERR_PTR(-ENOMEM);
> +		ret = -ENOMEM;
> +		goto free_module;
>  	}
>  
>  	dmabuf->priv = exp_info->priv;
> @@ -378,8 +379,8 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>  	file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf,
>  					exp_info->flags);
>  	if (IS_ERR(file)) {
> -		kfree(dmabuf);
> -		return ERR_CAST(file);
> +		ret = PTR_ERR(file);
> +		goto free_dmabuf;
>  	}
>  
>  	file->f_mode |= FMODE_LSEEK;
> @@ -393,6 +394,12 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>  	mutex_unlock(&db_list.lock);
>  
>  	return dmabuf;
> +
> +free_dmabuf:
> +	kfree(dmabuf);
> +free_module:
> +	module_put(exp_info->owner);
> +	return ERR_PTR(ret);

Labels could really be err_dmabuf (/ out_dmabuf). That's more in line
with rest of the codebase and kernel coding style: 'An example of a
good name could be "out_buffer:" if the goto frees "buffer".'

"free_dmabuf" does sound to me like it could also be executed on the
normal execution path of the function.

Other than that,

Reviewed-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

>  }
>  EXPORT_SYMBOL_GPL(dma_buf_export);
>  
-- 
Joonas Lahtinen
Open Source Technology Center
Intel Corporation
