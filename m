Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr710059.outbound.protection.outlook.com ([40.107.71.59]:29872
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932809AbeF1JyG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 05:54:06 -0400
Message-ID: <5B34B037.50105@amd.com>
Date: Thu, 28 Jun 2018 17:53:59 +0800
From: "Zhang, Jerry (Junwei)" <Jerry.Zhang@amd.com>
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?=
        <ckoenig.leichtzumerken@gmail.com>, <daniel@ffwll.ch>,
        <sumit.semwal@linaro.org>, <dri-devel@lists.freedesktop.org>,
        <linux-media@vger.kernel.org>, <linaro-mm-sig@lists.linaro.org>,
        <intel-gfx@lists.freedesktop.org>
Subject: Re: [PATCH 2/4] dma-buf: lock the reservation object during (un)map_dma_buf
 v2
References: <20180622141103.1787-1-christian.koenig@amd.com> <20180622141103.1787-3-christian.koenig@amd.com>
In-Reply-To: <20180622141103.1787-3-christian.koenig@amd.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/22/2018 10:11 PM, Christian König wrote:
> First step towards unpinned DMA buf operation.
>
> I've checked the DRM drivers to potential locking of the reservation
> object, but essentially we need to audit all implementations of the
> dma_buf _ops for this to work.
>
> v2: reordered
>
> Signed-off-by: Christian König <christian.koenig@amd.com>

looks good for me.

Reviewed-by: Junwei Zhang <Jerry.Zhang@amd.com>

Jerry
> ---
>   drivers/dma-buf/dma-buf.c | 9 ++++++---
>   include/linux/dma-buf.h   | 4 ++++
>   2 files changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index dc94e76e2e2a..49f23b791eb8 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -665,7 +665,9 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
>   	if (WARN_ON(!attach || !attach->dmabuf))
>   		return ERR_PTR(-EINVAL);
>
> -	sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
> +	reservation_object_lock(attach->dmabuf->resv, NULL);
> +	sg_table = dma_buf_map_attachment_locked(attach, direction);
> +	reservation_object_unlock(attach->dmabuf->resv);
>   	if (!sg_table)
>   		sg_table = ERR_PTR(-ENOMEM);
>
> @@ -715,8 +717,9 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
>   	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
>   		return;
>
> -	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table,
> -						direction);
> +	reservation_object_lock(attach->dmabuf->resv, NULL);
> +	dma_buf_unmap_attachment_locked(attach, sg_table, direction);
> +	reservation_object_unlock(attach->dmabuf->resv);
>   }
>   EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
>
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index a25e754ae2f7..024658d1f22e 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -118,6 +118,8 @@ struct dma_buf_ops {
>   	 * any other kind of sharing that the exporter might wish to make
>   	 * available to buffer-users.
>   	 *
> +	 * This is called with the dmabuf->resv object locked.
> +	 *
>   	 * Returns:
>   	 *
>   	 * A &sg_table scatter list of or the backing storage of the DMA buffer,
> @@ -138,6 +140,8 @@ struct dma_buf_ops {
>   	 * It should also unpin the backing storage if this is the last mapping
>   	 * of the DMA buffer, it the exporter supports backing storage
>   	 * migration.
> +	 *
> +	 * This is called with the dmabuf->resv object locked.
>   	 */
>   	void (*unmap_dma_buf)(struct dma_buf_attachment *,
>   			      struct sg_table *,
>
