Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:42217 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbeE3Lgq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 07:36:46 -0400
Subject: Re: [PATCH] dma-buf: make map_atomic and map function pointers
 optional
To: Gerd Hoffmann <kraxel@redhat.com>, dri-devel@lists.freedesktop.org
Cc: open list <linux-kernel@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
References: <20180529135918.19729-1-kraxel@redhat.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <cc4a43db-8479-37e6-3f4f-57dbf04f5110@gmail.com>
Date: Wed, 30 May 2018 14:36:43 +0300
MIME-Version: 1.0
In-Reply-To: <20180529135918.19729-1-kraxel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/29/2018 04:59 PM, Gerd Hoffmann wrote:
> So drivers don't need dummy functions just returning NULL.
>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>   include/linux/dma-buf.h   | 4 ++--
>   drivers/dma-buf/dma-buf.c | 4 ++++
>   2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index 085db2fee2..88917fa796 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -39,12 +39,12 @@ struct dma_buf_attachment;
>   
>   /**
>    * struct dma_buf_ops - operations possible on struct dma_buf
> - * @map_atomic: maps a page from the buffer into kernel address
> + * @map_atomic: [optional] maps a page from the buffer into kernel address
>    *		space, users may not block until the subsequent unmap call.
>    *		This callback must not sleep.
>    * @unmap_atomic: [optional] unmaps a atomically mapped page from the buffer.
>    *		  This Callback must not sleep.
> - * @map: maps a page from the buffer into kernel address space.
> + * @map: [optional] maps a page from the buffer into kernel address space.
>    * @unmap: [optional] unmaps a page from the buffer.
>    * @vmap: [optional] creates a virtual mapping for the buffer into kernel
>    *	  address space. Same restrictions as for vmap and friends apply.
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index d78d5fc173..4c45e31258 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -872,6 +872,8 @@ void *dma_buf_kmap_atomic(struct dma_buf *dmabuf, unsigned long page_num)
>   {
>   	WARN_ON(!dmabuf);
>   
> +	if (!dmabuf->ops->map_atomic)
> +		return NULL;
>   	return dmabuf->ops->map_atomic(dmabuf, page_num);
>   }
>   EXPORT_SYMBOL_GPL(dma_buf_kmap_atomic);
> @@ -907,6 +909,8 @@ void *dma_buf_kmap(struct dma_buf *dmabuf, unsigned long page_num)
>   {
>   	WARN_ON(!dmabuf);
>   
> +	if (!dmabuf->ops->map)
> +		return NULL;
>   	return dmabuf->ops->map(dmabuf, page_num);
>   }
>   EXPORT_SYMBOL_GPL(dma_buf_kmap);
Reviewed-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
