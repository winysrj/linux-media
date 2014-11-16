Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:50122 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaKPNVq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Nov 2014 08:21:46 -0500
Received: by mail-lb0-f171.google.com with SMTP id b6so14809864lbj.16
        for <linux-media@vger.kernel.org>; Sun, 16 Nov 2014 05:21:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415623771-29634-5-git-send-email-hverkuil@xs4all.nl>
References: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl> <1415623771-29634-5-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 16 Nov 2014 21:13:50 +0800
Message-ID: <CAMm-=zAwXOqeLmMOgjC-Cg=-OaABopqOZQ36M7WuzPUyznEFig@mail.gmail.com>
Subject: Re: [RFCv6 PATCH 04/16] vb2-dma-sg: add allocation context to dma-sg
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 10, 2014 at 8:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Require that dma-sg also uses an allocation context. This is in preparation
> for adding prepare/finish memops to sync the memory between DMA and CPU.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

[...]

> @@ -166,6 +177,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>                                     unsigned long size,
>                                     enum dma_data_direction dma_dir)
>  {
> +       struct vb2_dma_sg_conf *conf = alloc_ctx;
>         struct vb2_dma_sg_buf *buf;
>         unsigned long first, last;
>         int num_pages_from_user;
> @@ -235,6 +247,8 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>                         buf->num_pages, buf->offset, size, 0))
>                 goto userptr_fail_alloc_table_from_pages;
>
> +       /* Prevent the device from being released while the buffer is used */
> +       buf->dev = get_device(conf->dev);

I'm not sure if we should be managing this... As far as I understand
the logic behind taking a ref in alloc, if we are the exporter, we may
have to keep it in case we need to free the buffers after our device
goes away. But for userptr, we only need this for syncs, and in that
case it's triggered by our driver, so I think we don't have to worry
about that. If we do though, then dma-contig should be doing this as
well.

>         return buf;
>
>  userptr_fail_alloc_table_from_pages:
> @@ -274,6 +288,7 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
>         }
>         kfree(buf->pages);
>         vb2_put_vma(buf->vma);
> +       put_device(buf->dev);
>         kfree(buf);
>  }
>
> @@ -356,6 +371,27 @@ const struct vb2_mem_ops vb2_dma_sg_memops = {
>  };
>  EXPORT_SYMBOL_GPL(vb2_dma_sg_memops);
>
> +void *vb2_dma_sg_init_ctx(struct device *dev)
> +{
> +       struct vb2_dma_sg_conf *conf;
> +
> +       conf = kzalloc(sizeof(*conf), GFP_KERNEL);
> +       if (!conf)
> +               return ERR_PTR(-ENOMEM);
> +
> +       conf->dev = dev;
> +
> +       return conf;
> +}
> +EXPORT_SYMBOL_GPL(vb2_dma_sg_init_ctx);
> +
> +void vb2_dma_sg_cleanup_ctx(void *alloc_ctx)
> +{
> +       if (!IS_ERR_OR_NULL(alloc_ctx))

I would prefer not doing this, it's very weird and would really just
be a programming bug.


-- 
Best regards,
Pawel Osciak
