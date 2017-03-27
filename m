Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:35438 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752514AbdC0Wvm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 18:51:42 -0400
Received: by mail-ot0-f194.google.com with SMTP id s100so5538516ota.2
        for <linux-media@vger.kernel.org>; Mon, 27 Mar 2017 15:51:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161216012425.11179-8-laurent.pinchart+renesas@ideasonboard.com>
References: <20161216012425.11179-1-laurent.pinchart+renesas@ideasonboard.com> <20161216012425.11179-8-laurent.pinchart+renesas@ideasonboard.com>
From: Shuah Khan <shuahkhan@gmail.com>
Date: Mon, 27 Mar 2017 16:51:40 -0600
Message-ID: <CAKocOOPipHsPR-rhOzMOt=12c0nuQ=SpkAKCygjGzWbWki1P5A@mail.gmail.com>
Subject: Re: [RFC v2 07/11] vb2: dma-contig: Remove redundant sgt_base field
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laura Abbott <labbott@redhat.com>,
        Shuah Khan <shuahkhan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 15, 2016 at 6:24 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
>
> The struct vb2_dc_buf contains two struct sg_table fields: sgt_base and
> dma_sgt. The former is used by DMA-BUF buffers whereas the latter is used
> by USERPTR.
>
> Unify the two, leaving dma_sgt.

I think this patch should be split in two.

1. Unifying dma_sgt and sgt_base

>
> MMAP buffers do not need cache flushing since they have been allocated
> using dma_alloc_coherent().

2. That uses vec to check for checking for no flush needed condition.

>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Changes since v1:
>
> - Test for MMAP or DMABUF type through the vec field instead of the now
>   gone vma field.

What is this gone vma field? Did I miss a patch in the series that
makes this change? This check that is changed used dma_sgt and
db_attach vma

These comments don't agree with the code change.

> - Move the vec field to a USERPTR section in struct vb2_dc_buf, where
>   the vma field was located.
> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index fb6a177be461..2a00d12ffee2 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -30,12 +30,13 @@ struct vb2_dc_buf {
>         unsigned long                   attrs;
>         enum dma_data_direction         dma_dir;
>         struct sg_table                 *dma_sgt;
> -       struct frame_vector             *vec;
>
>         /* MMAP related */
>         struct vb2_vmarea_handler       handler;
>         atomic_t                        refcount;
> -       struct sg_table                 *sgt_base;
> +
> +       /* USERPTR related */
> +       struct frame_vector             *vec;
>
>         /* DMABUF related */
>         struct dma_buf_attachment       *db_attach;
> @@ -95,7 +96,7 @@ static void vb2_dc_prepare(void *buf_priv)
>         struct sg_table *sgt = buf->dma_sgt;
>
>         /* DMABUF exporter will flush the cache for us */
> -       if (!sgt || buf->db_attach)
> +       if (!buf->vec)
>                 return;

With the unification dma_sgt is valid for MMAP buffers after vb2_dma_sg_alloc()
if dma_sgt is not null, sync happens - the patch description doesn't seem to be
in sync with the change.

I might be missing something. I think it would help if these two changes are
split since they are really separate changes.

thanks,
-- Shuah

>
>         dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
> @@ -108,7 +109,7 @@ static void vb2_dc_finish(void *buf_priv)
>         struct sg_table *sgt = buf->dma_sgt;
>
>         /* DMABUF exporter will flush the cache for us */
> -       if (!sgt || buf->db_attach)
> +       if (!buf->vec)
>                 return;
>
>         dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
> @@ -125,9 +126,9 @@ static void vb2_dc_put(void *buf_priv)
>         if (!atomic_dec_and_test(&buf->refcount))
>                 return;
>
> -       if (buf->sgt_base) {
> -               sg_free_table(buf->sgt_base);
> -               kfree(buf->sgt_base);
> +       if (buf->dma_sgt) {
> +               sg_free_table(buf->dma_sgt);
> +               kfree(buf->dma_sgt);
>         }
>         dma_free_attrs(buf->dev, buf->size, buf->cookie, buf->dma_addr,
>                        buf->attrs);
> @@ -239,13 +240,13 @@ static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
>         /* Copy the buf->base_sgt scatter list to the attachment, as we can't
>          * map the same scatter list to multiple attachments at the same time.
>          */
> -       ret = sg_alloc_table(sgt, buf->sgt_base->orig_nents, GFP_KERNEL);
> +       ret = sg_alloc_table(sgt, buf->dma_sgt->orig_nents, GFP_KERNEL);
>         if (ret) {
>                 kfree(attach);
>                 return -ENOMEM;
>         }
>
> -       rd = buf->sgt_base->sgl;
> +       rd = buf->dma_sgt->sgl;
>         wr = sgt->sgl;
>         for (i = 0; i < sgt->orig_nents; ++i) {
>                 sg_set_page(wr, sg_page(rd), rd->length, rd->offset);
> @@ -396,10 +397,10 @@ static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv, unsigned long flags)
>         exp_info.flags = flags;
>         exp_info.priv = buf;
>
> -       if (!buf->sgt_base)
> -               buf->sgt_base = vb2_dc_get_base_sgt(buf);
> +       if (!buf->dma_sgt)
> +               buf->dma_sgt = vb2_dc_get_base_sgt(buf);
>
> -       if (WARN_ON(!buf->sgt_base))
> +       if (WARN_ON(!buf->dma_sgt))
>                 return NULL;
>
>         dbuf = dma_buf_export(&exp_info);
> --
> Regards,
>
> Laurent Pinchart
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
