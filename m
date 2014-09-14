Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:51838 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaINHBv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Sep 2014 03:01:51 -0400
Received: by mail-lb0-f177.google.com with SMTP id l4so2915464lbv.22
        for <linux-media@vger.kernel.org>; Sun, 14 Sep 2014 00:01:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1410185681-20111-7-git-send-email-hverkuil@xs4all.nl>
References: <1410185681-20111-1-git-send-email-hverkuil@xs4all.nl> <1410185681-20111-7-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 14 Sep 2014 14:55:24 +0800
Message-ID: <CAMm-=zA=RYod5KPLK0f9nrE0eb3CRSfoFfT8v4xYaqVNyeKcrQ@mail.gmail.com>
Subject: Re: [RFC PATCH 06/12] vb2-dma-sg: add dmabuf import support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Thank you for the patch.

On Mon, Sep 8, 2014 at 10:14 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Add support for dmabuf to vb2-dma-sg.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-sg.c | 125 +++++++++++++++++++++++++++--
>  1 file changed, 118 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index abd5252..6d922c0 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -42,11 +42,15 @@ struct vb2_dma_sg_buf {
>         int                             offset;
>         enum dma_data_direction         dma_dir;
>         struct sg_table                 sg_table;
> +       struct sg_table                 *dma_sgt;

I think we should document and/or have a bit better naming here. Maybe
sgt_in_use?

>         size_t                          size;
>         unsigned int                    num_pages;
>         atomic_t                        refcount;
>         struct vb2_vmarea_handler       handler;
>         struct vm_area_struct           *vma;
> +
> +       /* DMABUF related */
> +       struct dma_buf_attachment       *db_attach;
>  };
>
>  static void vb2_dma_sg_put(void *buf_priv);
> @@ -113,6 +117,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, int write,
>         /* size is already page aligned */
>         buf->num_pages = size >> PAGE_SHIFT;
>         buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +       buf->dma_sgt = &buf->sg_table;
>
>         buf->pages = kzalloc(buf->num_pages * sizeof(struct page *),
>                              GFP_KERNEL);
> @@ -123,7 +128,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, int write,
>         if (ret)
>                 goto fail_pages_alloc;
>
> -       ret = sg_alloc_table_from_pages(&buf->sg_table, buf->pages,
> +       ret = sg_alloc_table_from_pages(buf->dma_sgt, buf->pages,
>                         buf->num_pages, 0, size, gfp_flags);
>         if (ret)
>                 goto fail_table_alloc;
> @@ -161,7 +166,7 @@ static void vb2_dma_sg_put(void *buf_priv)
>                         buf->num_pages);
>                 if (buf->vaddr)
>                         vm_unmap_ram(buf->vaddr, buf->num_pages);
> -               sg_free_table(&buf->sg_table);
> +               sg_free_table(buf->dma_sgt);
>                 while (--i >= 0)
>                         __free_page(buf->pages[i]);
>                 kfree(buf->pages);
> @@ -173,7 +178,11 @@ static void vb2_dma_sg_put(void *buf_priv)
>  static int vb2_dma_sg_prepare(void *buf_priv)
>  {
>         struct vb2_dma_sg_buf *buf = buf_priv;
> -       struct sg_table *sgt = &buf->sg_table;
> +       struct sg_table *sgt = buf->dma_sgt;
> +
> +       /* DMABUF exporter will flush the cache for us */
> +       if (buf->db_attach)
> +               return 0;
>
>         return dma_map_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir) ? 0 : -EIO;
>  }
> @@ -181,7 +190,11 @@ static int vb2_dma_sg_prepare(void *buf_priv)
>  static void vb2_dma_sg_finish(void *buf_priv)
>  {
>         struct vb2_dma_sg_buf *buf = buf_priv;
> -       struct sg_table *sgt = &buf->sg_table;
> +       struct sg_table *sgt = buf->dma_sgt;
> +
> +       /* DMABUF exporter will flush the cache for us */
> +       if (buf->db_attach)
> +               return;
>
>         dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
>  }
> @@ -209,6 +222,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>         buf->offset = vaddr & ~PAGE_MASK;
>         buf->size = size;
>         buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +       buf->dma_sgt = &buf->sg_table;
>
>         first = (vaddr           & PAGE_MASK) >> PAGE_SHIFT;
>         last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
> @@ -261,7 +275,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>         if (num_pages_from_user != buf->num_pages)
>                 goto userptr_fail_get_user_pages;
>
> -       if (sg_alloc_table_from_pages(&buf->sg_table, buf->pages,
> +       if (sg_alloc_table_from_pages(buf->dma_sgt, buf->pages,
>                         buf->num_pages, buf->offset, size, 0))
>                 goto userptr_fail_alloc_table_from_pages;
>
> @@ -297,7 +311,7 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
>                __func__, buf->num_pages);
>         if (buf->vaddr)
>                 vm_unmap_ram(buf->vaddr, buf->num_pages);
> -       sg_free_table(&buf->sg_table);
> +       sg_free_table(buf->dma_sgt);
>         while (--i >= 0) {
>                 if (buf->write)
>                         set_page_dirty_lock(buf->pages[i]);
> @@ -370,11 +384,104 @@ static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
>         return 0;
>  }
>
> +/*********************************************/
> +/*       callbacks for DMABUF buffers        */
> +/*********************************************/
> +
> +static int vb2_dma_sg_map_dmabuf(void *mem_priv)
> +{
> +       struct vb2_dma_sg_buf *buf = mem_priv;
> +       struct sg_table *sgt;
> +
> +       if (WARN_ON(!buf->db_attach)) {
> +               pr_err("trying to pin a non attached buffer\n");

s/a non attached/an unattached/
In general, it would perhaps be nice to clean up/pretty up messages in
this file while we have the chance please...

> +               return -EINVAL;
> +       }
> +
> +       if (WARN_ON(buf->dma_sgt)) {
> +               pr_err("dmabuf buffer is already pinned\n");
> +               return 0;
> +       }
> +
> +       /* get the associated scatterlist for this buffer */

This comment doesn't really add value, and there is a few like this around.
I know they are copied from dma-contig, but I think we should remove them.
Others include "detach", "create attachment", etc.

-- 
Best regards,
Pawel Osciak
