Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:56421 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbaKHKx2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Nov 2014 05:53:28 -0500
Received: by mail-la0-f48.google.com with SMTP id gq15so5754458lab.35
        for <linux-media@vger.kernel.org>; Sat, 08 Nov 2014 02:53:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415350234-9826-6-git-send-email-hverkuil@xs4all.nl>
References: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl> <1415350234-9826-6-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Sat, 8 Nov 2014 19:45:19 +0900
Message-ID: <CAMm-=zBMODk93vYHHaJ8MbP2VQRVqEzJ5vcUJqirhF-jWhH8Hw@mail.gmail.com>
Subject: Re: [RFCv5 PATCH 05/15] vb2-dma-sg: add get_dmabuf
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Thank you for the patch.

On Fri, Nov 7, 2014 at 5:50 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hansverk@cisco.com>
>
> Add DMABUF export support to vb2-dma-sg.

I think we should mention in the subject that this adds dmabuf export to dma-sg.

> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-sg.c | 170 +++++++++++++++++++++++++++++
>  1 file changed, 170 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index 2795c27..ca28a50 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -407,6 +407,175 @@ static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
>  }
>
>  /*********************************************/
> +/*         DMABUF ops for exporters          */
> +/*********************************************/
> +
> +struct vb2_dma_sg_attachment {
> +       struct sg_table sgt;
> +       enum dma_data_direction dir;
> +};
> +
> +static int vb2_dma_sg_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
> +       struct dma_buf_attachment *dbuf_attach)
> +{
> +       struct vb2_dma_sg_attachment *attach;
> +       unsigned int i;
> +       struct scatterlist *rd, *wr;
> +       struct sg_table *sgt;
> +       struct vb2_dma_sg_buf *buf = dbuf->priv;
> +       int ret;
> +
> +       attach = kzalloc(sizeof(*attach), GFP_KERNEL);
> +       if (!attach)
> +               return -ENOMEM;
> +
> +       sgt = &attach->sgt;
> +       /* Copy the buf->base_sgt scatter list to the attachment, as we can't
> +        * map the same scatter list to multiple attachments at the same time.
> +        */
> +       ret = sg_alloc_table(sgt, buf->dma_sgt->orig_nents, GFP_KERNEL);
> +       if (ret) {
> +               kfree(attach);
> +               return -ENOMEM;
> +       }
> +
> +       rd = buf->dma_sgt->sgl;
> +       wr = sgt->sgl;
> +       for (i = 0; i < sgt->orig_nents; ++i) {
> +               sg_set_page(wr, sg_page(rd), rd->length, rd->offset);
> +               rd = sg_next(rd);
> +               wr = sg_next(wr);
> +       }
> +
> +       attach->dir = DMA_NONE;
> +       dbuf_attach->priv = attach;
> +
> +       return 0;
> +}
> +
> +static void vb2_dma_sg_dmabuf_ops_detach(struct dma_buf *dbuf,
> +       struct dma_buf_attachment *db_attach)
> +{
> +       struct vb2_dma_sg_attachment *attach = db_attach->priv;
> +       struct sg_table *sgt;
> +
> +       if (!attach)
> +               return;
> +
> +       sgt = &attach->sgt;
> +
> +       /* release the scatterlist cache */
> +       if (attach->dir != DMA_NONE)
> +               dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
> +                       attach->dir);
> +       sg_free_table(sgt);
> +       kfree(attach);
> +       db_attach->priv = NULL;
> +}
> +
> +static struct sg_table *vb2_dma_sg_dmabuf_ops_map(
> +       struct dma_buf_attachment *db_attach, enum dma_data_direction dir)
> +{
> +       struct vb2_dma_sg_attachment *attach = db_attach->priv;
> +       /* stealing dmabuf mutex to serialize map/unmap operations */
> +       struct mutex *lock = &db_attach->dmabuf->lock;
> +       struct sg_table *sgt;
> +       int ret;
> +
> +       mutex_lock(lock);
> +
> +       sgt = &attach->sgt;
> +       /* return previously mapped sg table */
> +       if (attach->dir == dir) {
> +               mutex_unlock(lock);
> +               return sgt;
> +       }
> +
> +       /* release any previous cache */
> +       if (attach->dir != DMA_NONE) {
> +               dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
> +                       attach->dir);
> +               attach->dir = DMA_NONE;
> +       }
> +
> +       /* mapping to the client with new direction */
> +       ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dir);
> +       if (ret <= 0) {
> +               pr_err("failed to map scatterlist\n");
> +               mutex_unlock(lock);
> +               return ERR_PTR(-EIO);
> +       }
> +
> +       attach->dir = dir;
> +
> +       mutex_unlock(lock);
> +
> +       return sgt;
> +}
> +
> +static void vb2_dma_sg_dmabuf_ops_unmap(struct dma_buf_attachment *db_attach,
> +       struct sg_table *sgt, enum dma_data_direction dir)
> +{
> +       /* nothing to be done here */
> +}
> +
> +static void vb2_dma_sg_dmabuf_ops_release(struct dma_buf *dbuf)
> +{
> +       /* drop reference obtained in vb2_dma_sg_get_dmabuf */
> +       vb2_dma_sg_put(dbuf->priv);
> +}
> +
> +static void *vb2_dma_sg_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnum)
> +{
> +       struct vb2_dma_sg_buf *buf = dbuf->priv;
> +
> +       return buf->vaddr + pgnum * PAGE_SIZE;

As opposed to contig, which assigns vaddr on alloc(), vaddr can very
well be NULL here for sg.

-- 
Best regards,
Pawel Osciak
