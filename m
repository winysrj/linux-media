Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:55622 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbeC2G56 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 02:57:58 -0400
Received: by mail-wm0-f66.google.com with SMTP id b127so8002781wmf.5
        for <linux-media@vger.kernel.org>; Wed, 28 Mar 2018 23:57:57 -0700 (PDT)
Date: Thu, 29 Mar 2018 08:57:53 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian =?iso-8859-1?Q?K=F6nig?=
        <ckoenig.leichtzumerken@gmail.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] dma-buf: add peer2peer flag
Message-ID: <20180329065753.GD3881@phenom.ffwll.local>
References: <20180325110000.2238-1-christian.koenig@amd.com>
 <20180325110000.2238-4-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180325110000.2238-4-christian.koenig@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 25, 2018 at 12:59:56PM +0200, Christian König wrote:
> Add a peer2peer flag noting that the importer can deal with device
> resources which are not backed by pages.
> 
> Signed-off-by: Christian König <christian.koenig@amd.com>

Um strictly speaking they all should, but ttm never bothered to use the
real interfaces but just hacked around the provided sg list, grabbing the
underlying struct pages, then rebuilding&remapping the sg list again.

The entire point of using sg lists was exactly to allow this use case of
peer2peer dma (or well in general have special exporters which managed
memory/IO ranges not backed by struct page). So essentially you're having
a "I'm totally not broken flag" here.

I think a better approach would be if we add a requires_struct_page or so,
and annotate the current importers accordingly. Or we just fix them up (it
is all in shared ttm code after all, I think everyone else got this
right).
-Daniel

> ---
>  drivers/dma-buf/dma-buf.c | 1 +
>  include/linux/dma-buf.h   | 4 ++++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index ffaa2f9a9c2c..f420225f93c6 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -565,6 +565,7 @@ struct dma_buf_attachment *dma_buf_attach(const struct dma_buf_attach_info *info
>  
>  	attach->dev = info->dev;
>  	attach->dmabuf = dmabuf;
> +	attach->peer2peer = info->peer2peer;
>  	attach->priv = info->priv;
>  	attach->invalidate = info->invalidate;
>  
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index 15dd8598bff1..1ef50bd9bc5b 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -313,6 +313,7 @@ struct dma_buf {
>   * @dmabuf: buffer for this attachment.
>   * @dev: device attached to the buffer.
>   * @node: list of dma_buf_attachment.
> + * @peer2peer: true if the importer can handle peer resources without pages.
>   * @priv: exporter specific attachment data.
>   *
>   * This structure holds the attachment information between the dma_buf buffer
> @@ -328,6 +329,7 @@ struct dma_buf_attachment {
>  	struct dma_buf *dmabuf;
>  	struct device *dev;
>  	struct list_head node;
> +	bool peer2peer;
>  	void *priv;
>  
>  	/**
> @@ -392,6 +394,7 @@ struct dma_buf_export_info {
>   * @dmabuf:	the exported dma_buf
>   * @dev:	the device which wants to import the attachment
>   * @priv:	private data of importer to this attachment
> + * @peer2peer:	true if the importer can handle peer resources without pages
>   * @invalidate:	callback to use for invalidating mappings
>   *
>   * This structure holds the information required to attach to a buffer. Used
> @@ -401,6 +404,7 @@ struct dma_buf_attach_info {
>  	struct dma_buf *dmabuf;
>  	struct device *dev;
>  	void *priv;
> +	bool peer2peer;
>  	void (*invalidate)(struct dma_buf_attachment *attach);
>  };
>  
> -- 
> 2.14.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
