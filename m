Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34432 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbcHOQCT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 12:02:19 -0400
Received: by mail-wm0-f68.google.com with SMTP id q128so11840206wma.1
        for <linux-media@vger.kernel.org>; Mon, 15 Aug 2016 09:02:19 -0700 (PDT)
Date: Mon, 15 Aug 2016 18:02:14 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Eric Anholt <eric@anholt.net>, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dma-buf: Wait on the reservation object when sync'ing
 before CPU access
Message-ID: <20160815160214.GK6232@phenom.ffwll.local>
References: <1466492640-12551-1-git-send-email-chris@chris-wilson.co.uk>
 <1471275738-31994-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1471275738-31994-1-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 15, 2016 at 04:42:18PM +0100, Chris Wilson wrote:
> Rendering operations to the dma-buf are tracked implicitly via the
> reservation_object (dmabuf->resv). This is used to allow poll() to
> wait upon outstanding rendering (or just query the current status of
> rendering). The dma-buf sync ioctl allows userspace to prepare the
> dma-buf for CPU access, which should include waiting upon rendering.
> (Some drivers may need to do more work to ensure that the dma-buf mmap
> is coherent as well as complete.)
> 
> v2: Always wait upon the reservation object implicitly. We choose to do
> it after the native handler in case it can do so more efficiently.
> 
> Testcase: igt/prime_vgem
> Testcase: igt/gem_concurrent_blit # *vgem*
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Eric Anholt <eric@anholt.net>
> Cc: linux-media@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linaro-mm-sig@lists.linaro.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/dma-buf/dma-buf.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index ddaee60ae52a..cf04d249a6a4 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -586,6 +586,22 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
>  
> +static int __dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
> +				      enum dma_data_direction direction)
> +{
> +	bool write = (direction == DMA_BIDIRECTIONAL ||
> +		      direction == DMA_TO_DEVICE);
> +	struct reservation_object *resv = dmabuf->resv;
> +	long ret;
> +
> +	/* Wait on any implicit rendering fences */
> +	ret = reservation_object_wait_timeout_rcu(resv, write, true,
> +						  MAX_SCHEDULE_TIMEOUT);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
>  
>  /**
>   * dma_buf_begin_cpu_access - Must be called before accessing a dma_buf from the
> @@ -608,6 +624,13 @@ int dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
>  	if (dmabuf->ops->begin_cpu_access)
>  		ret = dmabuf->ops->begin_cpu_access(dmabuf, direction);
>  
> +	/* Ensure that all fences are waited upon - but we first allow
> +	 * the native handler the chance to do so more efficiently if it
> +	 * chooses. A double invocation here will be reasonably cheap no-op.
> +	 */
> +	if (ret == 0)
> +		ret = __dma_buf_begin_cpu_access(dmabuf, direction);

Not sure we should wait first and the flush or the other way round. But I
don't think it'll matter for any current dma-buf exporter, so meh.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Sumits, can you pls pick this one up and put into drm-misc?
-Daniel

> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_begin_cpu_access);
> -- 
> 2.8.1
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
