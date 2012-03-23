Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56500 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381Ab2CWRvr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 13:51:47 -0400
Received: by wejx9 with SMTP id x9so2839225wej.19
        for <linux-media@vger.kernel.org>; Fri, 23 Mar 2012 10:51:46 -0700 (PDT)
Date: Fri, 23 Mar 2012 18:52:31 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Sumit Semwal <sumit.semwal@ti.com>
Cc: daniel.vetter@ffwll.ch, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH] dma-buf: Correct dummy function declarations.
Message-ID: <20120323175230.GE4087@phenom.ffwll.local>
References: <1332517757-25532-1-git-send-email-sumit.semwal@ti.com>
MIME-Version: 1.0
In-Reply-To: <1332517757-25532-1-git-send-email-sumit.semwal@ti.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 23, 2012 at 09:19:17PM +0530, Sumit Semwal wrote:
> While testing, I found that we need to correct some of the dummy declarations. When I send my pull request to Linus, I wish to squash these changes into the original patches from Daniel. Could you please review?
> 
> Best regards,
> ~Sumit
> 
> =========
> 
> Dummy functions for the newly added cpu access ops are needed for compilation
> when dma-buf framework is not compiled-in.
> 
> Also, the introduction of flags in dma_buf_fd  needs to be added to dummy
> functions as well.
> 
> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>

Sorry for fumbling the compile-testing for the !DMA_BUF case here.

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Cheers, Daniel

> ---
>  include/linux/dma-buf.h |   26 +++++++++++++-------------
>  1 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index f08028e..779aaf9 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -189,7 +189,7 @@ static inline struct dma_buf *dma_buf_export(void *priv,
>  	return ERR_PTR(-ENODEV);
>  }
>  
> -static inline int dma_buf_fd(struct dma_buf *dmabuf)
> +static inline int dma_buf_fd(struct dma_buf *dmabuf, int flags)
>  {
>  	return -ENODEV;
>  }
> @@ -216,36 +216,36 @@ static inline void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
>  	return;
>  }
>  
> -static inline int dma_buf_begin_cpu_access(struct dma_buf *,
> -					   size_t, size_t,
> -					   enum dma_data_direction)
> +static inline int dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
> +					   size_t start, size_t len,
> +					   enum dma_data_direction dir)
>  {
>  	return -ENODEV;
>  }
>  
> -static inline void dma_buf_end_cpu_access(struct dma_buf *,
> -					  size_t, size_t,
> -					  enum dma_data_direction)
> +static inline void dma_buf_end_cpu_access(struct dma_buf *dmabuf,
> +					  size_t start, size_t len,
> +					  enum dma_data_direction dir)
>  {
>  }
>  
> -static inline void *dma_buf_kmap_atomic(struct dma_buf *, unsigned long)
> +static inline void *dma_buf_kmap_atomic(struct dma_buf *db, unsigned long pnum)
>  {
>  	return NULL;
>  }
>  
> -static inline void dma_buf_kunmap_atomic(struct dma_buf *, unsigned long,
> -					 void *)
> +static inline void dma_buf_kunmap_atomic(struct dma_buf *db, unsigned long pnum,
> +					 void *vaddr)
>  {
>  }
>  
> -static inline void *dma_buf_kmap(struct dma_buf *, unsigned long)
> +static inline void *dma_buf_kmap(struct dma_buf *db, unsigned long pnum)
>  {
>  	return NULL;
>  }
>  
> -static inline void dma_buf_kunmap(struct dma_buf *, unsigned long,
> -				  void *)
> +static inline void dma_buf_kunmap(struct dma_buf *db, unsigned long pnum,
> +				  void *vaddr)
>  {
>  }
>  #endif /* CONFIG_DMA_SHARED_BUFFER */
> -- 
> 1.7.5.4
> 

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
