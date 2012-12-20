Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4692 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2LTQJr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Dec 2012 11:09:47 -0500
Message-ID: <50D3384A.2070800@nvidia.com>
Date: Thu, 20 Dec 2012 08:09:46 -0800
From: Aaron Plattner <aplattner@nvidia.com>
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: DRI Development <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] dma-buf: implement vmap refcounting in the interface
 logic
References: <50D255F5.5030602@nvidia.com> <1356009263-15822-1-git-send-email-daniel.vetter@ffwll.ch>
In-Reply-To: <1356009263-15822-1-git-send-email-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/20/2012 05:14 AM, Daniel Vetter wrote:
> All drivers which implement this need to have some sort of refcount to
> allow concurrent vmap usage. Hence implement this in the dma-buf core.
>
> To protect against concurrent calls we need a lock, which potentially
> causes new funny locking inversions. But this shouldn't be a problem
> for exporters with statically allocated backing storage, and more
> dynamic drivers have decent issues already anyway.
>
> Inspired by some refactoring patches from Aaron Plattner, who
> implemented the same idea, but only for drm/prime drivers.
>
> v2: Check in dma_buf_release that no dangling vmaps are left.
> Suggested by Aaron Plattner. We might want to do similar checks for
> attachments, but that's for another patch. Also fix up ERR_PTR return
> for vmap.
>
> v3: Check whether the passed-in vmap address matches with the cached
> one for vunmap. Eventually we might want to remove that parameter -
> compared to the kmap functions there's no need for the vaddr for
> unmapping.  Suggested by Chris Wilson.
>
> v4: Fix a brown-paper-bag bug spotted by Aaron Plattner.

The kernel spotted it when I tried to vunmap a buffer.  :)

> Cc: Aaron Plattner <aplattner@nvidia.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Reviewed-by: Aaron Plattner <aplattner@nvidia.com>
Tested-by: Aaron Plattner <aplattner@nvidia.com>

--
Aaron

> ---
>   Documentation/dma-buf-sharing.txt |  6 +++++-
>   drivers/base/dma-buf.c            | 43 ++++++++++++++++++++++++++++++++++-----
>   include/linux/dma-buf.h           |  4 +++-
>   3 files changed, 46 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
> index 0188903..4966b1b 100644
> --- a/Documentation/dma-buf-sharing.txt
> +++ b/Documentation/dma-buf-sharing.txt
> @@ -302,7 +302,11 @@ Access to a dma_buf from the kernel context involves three steps:
>         void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
>
>      The vmap call can fail if there is no vmap support in the exporter, or if it
> -   runs out of vmalloc space. Fallback to kmap should be implemented.
> +   runs out of vmalloc space. Fallback to kmap should be implemented. Note that
> +   the dma-buf layer keeps a reference count for all vmap access and calls down
> +   into the exporter's vmap function only when no vmapping exists, and only
> +   unmaps it once. Protection against concurrent vmap/vunmap calls is provided
> +   by taking the dma_buf->lock mutex.
>
>   3. Finish access
>
> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> index a3f79c4..26b68de 100644
> --- a/drivers/base/dma-buf.c
> +++ b/drivers/base/dma-buf.c
> @@ -39,6 +39,8 @@ static int dma_buf_release(struct inode *inode, struct file *file)
>
>   	dmabuf = file->private_data;
>
> +	BUG_ON(dmabuf->vmapping_counter);
> +
>   	dmabuf->ops->release(dmabuf);
>   	kfree(dmabuf);
>   	return 0;
> @@ -482,12 +484,34 @@ EXPORT_SYMBOL_GPL(dma_buf_mmap);
>    */
>   void *dma_buf_vmap(struct dma_buf *dmabuf)
>   {
> +	void *ptr;
> +
>   	if (WARN_ON(!dmabuf))
>   		return NULL;
>
> -	if (dmabuf->ops->vmap)
> -		return dmabuf->ops->vmap(dmabuf);
> -	return NULL;
> +	if (!dmabuf->ops->vmap)
> +		return NULL;
> +
> +	mutex_lock(&dmabuf->lock);
> +	if (dmabuf->vmapping_counter) {
> +		dmabuf->vmapping_counter++;
> +		BUG_ON(!dmabuf->vmap_ptr);
> +		ptr = dmabuf->vmap_ptr;
> +		goto out_unlock;
> +	}
> +
> +	BUG_ON(dmabuf->vmap_ptr);
> +
> +	ptr = dmabuf->ops->vmap(dmabuf);
> +	if (IS_ERR_OR_NULL(ptr))
> +		goto out_unlock;
> +
> +	dmabuf->vmap_ptr = ptr;
> +	dmabuf->vmapping_counter = 1;
> +
> +out_unlock:
> +	mutex_unlock(&dmabuf->lock);
> +	return ptr;
>   }
>   EXPORT_SYMBOL_GPL(dma_buf_vmap);
>
> @@ -501,7 +525,16 @@ void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
>   	if (WARN_ON(!dmabuf))
>   		return;
>
> -	if (dmabuf->ops->vunmap)
> -		dmabuf->ops->vunmap(dmabuf, vaddr);
> +	BUG_ON(!dmabuf->vmap_ptr);
> +	BUG_ON(dmabuf->vmapping_counter == 0);
> +	BUG_ON(dmabuf->vmap_ptr != vaddr);
> +
> +	mutex_lock(&dmabuf->lock);
> +	if (--dmabuf->vmapping_counter == 0) {
> +		if (dmabuf->ops->vunmap)
> +			dmabuf->ops->vunmap(dmabuf, vaddr);
> +		dmabuf->vmap_ptr = NULL;
> +	}
> +	mutex_unlock(&dmabuf->lock);
>   }
>   EXPORT_SYMBOL_GPL(dma_buf_vunmap);
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index bd2e52c..e3bf2f6 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -119,8 +119,10 @@ struct dma_buf {
>   	struct file *file;
>   	struct list_head attachments;
>   	const struct dma_buf_ops *ops;
> -	/* mutex to serialize list manipulation and attach/detach */
> +	/* mutex to serialize list manipulation, attach/detach and vmap/unmap */
>   	struct mutex lock;
> +	unsigned vmapping_counter;
> +	void *vmap_ptr;
>   	void *priv;
>   };
>
>

