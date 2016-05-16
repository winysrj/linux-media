Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33107 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbcEPXFP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2016 19:05:15 -0400
MIME-Version: 1.0
In-Reply-To: <1462806459-8124-3-git-send-email-benjamin.gaignard@linaro.org>
References: <1462806459-8124-1-git-send-email-benjamin.gaignard@linaro.org>
	<1462806459-8124-3-git-send-email-benjamin.gaignard@linaro.org>
Date: Tue, 17 May 2016 00:05:13 +0100
Message-ID: <CACvgo51sRwhpzyzqGRmxFnqefSvT0r1ekjxhnuQBbT-FuxBRhA@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] SMAF: add CMA allocator
From: Emil Velikov <emil.l.velikov@gmail.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: linux-media@vger.kernel.org,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
	ML dri-devel <dri-devel@lists.freedesktop.org>,
	zoltan.kuscsik@linaro.org, Sumit Semwal <sumit.semwal@linaro.org>,
	cc.ma@mediatek.com, pascal.brand@linaro.org,
	joakim.bech@linaro.org, dan.caprita@windriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Benjamin,

On 9 May 2016 at 16:07, Benjamin Gaignard <benjamin.gaignard@linaro.org> wrote:
> SMAF CMA allocator implement helpers functions to allow SMAF
> to allocate contiguous memory.
>
> match() each if at least one of the attached devices have coherent_dma_mask
> set to DMA_BIT_MASK(32).
>
What is the idea behind the hardcoded 32. Wouldn't it be better to avoid that ?


> +static void smaf_cma_release(struct dma_buf *dmabuf)
> +{
> +       struct smaf_cma_buffer_info *info = dmabuf->priv;
> +       DEFINE_DMA_ATTRS(attrs);
> +
> +       dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> +
Imho it's worth storing the dma_attrs within smaf_cma_buffer_info.
This way it's less likely for things to go wrong, if one forgets to
update one of the three in the future.


> +static void smaf_cma_unmap(struct dma_buf_attachment *attachment,
> +                          struct sg_table *sgt,
> +                          enum dma_data_direction direction)
> +{
> +       /* do nothing */
There could/should really be a comment explaining why we "do nothing"
here, right ?

> +}
> +
> +static int smaf_cma_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
> +{
> +       struct smaf_cma_buffer_info *info = dmabuf->priv;
> +       int ret;
> +       DEFINE_DMA_ATTRS(attrs);
> +
> +       dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> +
> +       if (info->size < vma->vm_end - vma->vm_start)
> +               return -EINVAL;
> +
> +       vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
> +       ret = dma_mmap_attrs(info->dev, vma, info->vaddr, info->paddr,
> +                            info->size, &attrs);
> +
> +       return ret;
Kill the temporary variable 'ret' ?


> +static struct dma_buf_ops smaf_cma_ops = {
const ? Afaict the compiler would/should warn you about discarding it
as the ops are defined const.


> +static struct dma_buf *smaf_cma_allocate(struct dma_buf *dmabuf,
> +                                        size_t length, unsigned int flags)
> +{
> +       struct dma_buf_attachment *attach_obj;
> +       struct smaf_cma_buffer_info *info;
> +       struct dma_buf *cma_dmabuf;
> +       int ret;
> +
> +       DEFINE_DMA_BUF_EXPORT_INFO(export);
> +       DEFINE_DMA_ATTRS(attrs);
> +
> +       dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> +
> +       info = kzalloc(sizeof(*info), GFP_KERNEL);
> +       if (!info)
> +               return NULL;
> +
> +       info->dev = find_matching_device(dmabuf);
find_matching_device() can return NULL. We should handle that imho.

> +       info->size = length;
> +       info->vaddr = dma_alloc_attrs(info->dev, info->size, &info->paddr,
> +                                     GFP_KERNEL | __GFP_NOWARN, &attrs);
> +       if (!info->vaddr) {
> +               ret = -ENOMEM;
set-but-unused-variable 'ret' ?

> +               goto error;
> +       }
> +
> +       export.ops = &smaf_cma_ops;
> +       export.size = info->size;
> +       export.flags = flags;
> +       export.priv = info;
> +
> +       cma_dmabuf = dma_buf_export(&export);
> +       if (IS_ERR(cma_dmabuf))
Missing dma_free_attrs() ? I'd add another label in the error path and
handle it there.

> +               goto error;
> +
> +       list_for_each_entry(attach_obj, &dmabuf->attachments, node) {
> +               dma_buf_attach(cma_dmabuf, attach_obj->dev);
Imho one should error out if attach fails. Or warn at the very least ?


> +static int __init smaf_cma_init(void)
> +{
> +       INIT_LIST_HEAD(&smaf_cma.list_node);
Isn't this something that smaf_register_allocator() should be doing ?


Regards,
Emil
