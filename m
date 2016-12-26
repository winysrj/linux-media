Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:36061 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbcLZH6J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Dec 2016 02:58:09 -0500
Received: by mail-ua0-f177.google.com with SMTP id 88so152905065uaq.3
        for <linux-media@vger.kernel.org>; Sun, 25 Dec 2016 23:58:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161216012425.11179-11-laurent.pinchart+renesas@ideasonboard.com>
References: <20161216012425.11179-11-laurent.pinchart+renesas@ideasonboard.com>
From: Ricky Liang <jcliang@chromium.org>
Date: Mon, 26 Dec 2016 15:58:07 +0800
Message-ID: <CAAJzSMep+qccM+UV+T-wgpqTNPYD3yHWqpjJbhH5v4NLxjqZ=w@mail.gmail.com>
Subject: Re: [RFC, v2, 10/11] vb2: dma-contig: Let drivers decide DMA attrs of
 MMAP and USERPTR bufs
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laura Abbott <labbott@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Dec 16, 2016 at 9:24 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
>
> The desirable DMA attributes are not generic for all devices using
> Videobuf2 contiguous DMA ops. Let the drivers decide.
>
> This change also results in MMAP buffers always having an sg_table
> (dma_sgt field).
>
> Also arrange the header files alphabetically.
>
> As a result, also the DMA-BUF exporter must provide ops for synchronising
> the cache. This adds begin_cpu_access and end_cpu_access ops to
> vb2_dc_dmabuf_ops.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 66 ++++++++++++++++++++++----
>  1 file changed, 56 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index d503647ea522..a0e88ad93f07 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -11,11 +11,11 @@
>   */
>
>  #include <linux/dma-buf.h>
> +#include <linux/dma-mapping.h>
>  #include <linux/module.h>
>  #include <linux/scatterlist.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> -#include <linux/dma-mapping.h>
>
>  #include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
> @@ -115,8 +115,11 @@ static void vb2_dc_prepare(void *buf_priv)
>         struct vb2_dc_buf *buf = buf_priv;
>         struct sg_table *sgt = buf->dma_sgt;
>
> -       /* DMABUF exporter will flush the cache for us */
> -       if (!buf->vec)
> +       /*
> +        * DMABUF exporter will flush the cache for us; only USERPTR
> +        * and MMAP buffers with non-coherent memory will be flushed.
> +        */
> +       if (!(buf->attrs & DMA_ATTR_NON_CONSISTENT))

Should here be "if (!buf->vec || !(buf->attrs & DMA_ATTR_NON_CONSISTENT))" ?

>                 return;
>
>         dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
> @@ -128,8 +131,11 @@ static void vb2_dc_finish(void *buf_priv)
>         struct vb2_dc_buf *buf = buf_priv;
>         struct sg_table *sgt = buf->dma_sgt;
>
> -       /* DMABUF exporter will flush the cache for us */
> -       if (!buf->vec)
> +       /*
> +        * DMABUF exporter will flush the cache for us; only USERPTR
> +        * and MMAP buffers with non-coherent memory will be flushed.
> +        */
> +       if (!(buf->attrs & DMA_ATTR_NON_CONSISTENT))
>                 return;
>
>         dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
> @@ -172,13 +178,22 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
>         if (attrs)
>                 buf->attrs = attrs;
>         buf->cookie = dma_alloc_attrs(dev, size, &buf->dma_addr,
> -                                       GFP_KERNEL | gfp_flags, buf->attrs);
> +                                    GFP_KERNEL | gfp_flags, buf->attrs);
>         if (!buf->cookie) {
> -               dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
> +               dev_err(dev, "dma_alloc_attrs of size %ld failed\n", size);
>                 kfree(buf);
>                 return ERR_PTR(-ENOMEM);
>         }
>
> +       if (buf->attrs & DMA_ATTR_NON_CONSISTENT) {
> +               buf->dma_sgt = vb2_dc_get_base_sgt(buf);
> +               if (!buf->dma_sgt) {
> +                       dma_free_attrs(dev, size, buf->cookie, buf->dma_addr,
> +                                      buf->attrs);
> +                       return ERR_PTR(-ENOMEM);
> +               }
> +       }
> +
>         if ((buf->attrs & DMA_ATTR_NO_KERNEL_MAPPING) == 0)
>                 buf->vaddr = buf->cookie;
>
> @@ -359,6 +374,34 @@ static void *vb2_dc_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnum)
>         return buf->vaddr ? buf->vaddr + pgnum * PAGE_SIZE : NULL;
>  }
>
> +static int vb2_dc_dmabuf_ops_begin_cpu_access(struct dma_buf *dbuf,
> +                                             enum dma_data_direction direction)
> +{
> +       struct vb2_dc_buf *buf = dbuf->priv;
> +       struct sg_table *sgt = buf->dma_sgt;
> +
> +       if (!(buf->attrs & DMA_ATTR_NON_CONSISTENT))
> +               return 0;
> +
> +       dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> +
> +       return 0;
> +}
> +
> +static int vb2_dc_dmabuf_ops_end_cpu_access(struct dma_buf *dbuf,
> +                                           enum dma_data_direction direction)
> +{
> +       struct vb2_dc_buf *buf = dbuf->priv;
> +       struct sg_table *sgt = buf->dma_sgt;
> +
> +       if (!(buf->attrs & DMA_ATTR_NON_CONSISTENT))
> +               return 0;
> +
> +       dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> +
> +       return 0;
> +}
> +
>  static void *vb2_dc_dmabuf_ops_vmap(struct dma_buf *dbuf)
>  {
>         struct vb2_dc_buf *buf = dbuf->priv;
> @@ -379,6 +422,8 @@ static struct dma_buf_ops vb2_dc_dmabuf_ops = {
>         .unmap_dma_buf = vb2_dc_dmabuf_ops_unmap,
>         .kmap = vb2_dc_dmabuf_ops_kmap,
>         .kmap_atomic = vb2_dc_dmabuf_ops_kmap,
> +       .begin_cpu_access = vb2_dc_dmabuf_ops_begin_cpu_access,
> +       .end_cpu_access = vb2_dc_dmabuf_ops_end_cpu_access,
>         .vmap = vb2_dc_dmabuf_ops_vmap,
>         .mmap = vb2_dc_dmabuf_ops_mmap,
>         .release = vb2_dc_dmabuf_ops_release,
> @@ -424,11 +469,12 @@ static void vb2_dc_put_userptr(void *buf_priv)
>
>         if (sgt) {
>                 /*
> -                * No need to sync to CPU, it's already synced to the CPU
> -                * since the finish() memop will have been called before this.
> +                * Don't ask to skip cache sync in case if the user
> +                * did ask to skip cache flush the last time the
> +                * buffer was dequeued.
>                  */
>                 dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
> -                                  buf->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
> +                                  buf->dma_dir, 0);
>                 pages = frame_vector_pages(buf->vec);
>                 /* sgt should exist only if vector contains pages... */
>                 BUG_ON(IS_ERR(pages));
