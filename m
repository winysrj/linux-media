Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:33261 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbcEQOzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2016 10:55:55 -0400
Received: by mail-lf0-f44.google.com with SMTP id y84so8023171lfc.0
        for <linux-media@vger.kernel.org>; Tue, 17 May 2016 07:55:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACvgo51sRwhpzyzqGRmxFnqefSvT0r1ekjxhnuQBbT-FuxBRhA@mail.gmail.com>
References: <1462806459-8124-1-git-send-email-benjamin.gaignard@linaro.org>
	<1462806459-8124-3-git-send-email-benjamin.gaignard@linaro.org>
	<CACvgo51sRwhpzyzqGRmxFnqefSvT0r1ekjxhnuQBbT-FuxBRhA@mail.gmail.com>
Date: Tue, 17 May 2016 16:55:53 +0200
Message-ID: <CA+M3ks6u437g7QPOKjg500afayhVUd1Mk6qcR1oDrXMoLvp88w@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] SMAF: add CMA allocator
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: Emil Velikov <emil.l.velikov@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
	ML dri-devel <dri-devel@lists.freedesktop.org>,
	Zoltan Kuscsik <zoltan.kuscsik@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Cc Ma <cc.ma@mediatek.com>,
	Pascal Brand <pascal.brand@linaro.org>,
	Joakim Bech <joakim.bech@linaro.org>,
	Dan Caprita <dan.caprita@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Emil,

2016-05-17 1:05 GMT+02:00 Emil Velikov <emil.l.velikov@gmail.com>:
> Hi Benjamin,
>
> On 9 May 2016 at 16:07, Benjamin Gaignard <benjamin.gaignard@linaro.org> wrote:
>> SMAF CMA allocator implement helpers functions to allow SMAF
>> to allocate contiguous memory.
>>
>> match() each if at least one of the attached devices have coherent_dma_mask
>> set to DMA_BIT_MASK(32).
>>
> What is the idea behind the hardcoded 32. Wouldn't it be better to avoid that ?
>

Device dma_bit_mask field has to be set to DMA_BIT_MASK(32) to target
a CMA area.
I haven't see any other #define for that.

>
>> +static void smaf_cma_release(struct dma_buf *dmabuf)
>> +{
>> +       struct smaf_cma_buffer_info *info = dmabuf->priv;
>> +       DEFINE_DMA_ATTRS(attrs);
>> +
>> +       dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
>> +
> Imho it's worth storing the dma_attrs within smaf_cma_buffer_info.
> This way it's less likely for things to go wrong, if one forgets to
> update one of the three in the future.

Here I have duplicate what is done everywhere else but I could try to
add it into
smaf_cma_buffer_info structure.

>
>> +static void smaf_cma_unmap(struct dma_buf_attachment *attachment,
>> +                          struct sg_table *sgt,
>> +                          enum dma_data_direction direction)
>> +{
>> +       /* do nothing */
> There could/should really be a comment explaining why we "do nothing"
> here, right ?
>

I haven't used DMA_ATTR_NO_KERNEL_MAPPING while allocating the buffer
so kernel mapping is set by default and I don't have to manage map refcounting.

>> +}
>> +
>> +static int smaf_cma_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
>> +{
>> +       struct smaf_cma_buffer_info *info = dmabuf->priv;
>> +       int ret;
>> +       DEFINE_DMA_ATTRS(attrs);
>> +
>> +       dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
>> +
>> +       if (info->size < vma->vm_end - vma->vm_start)
>> +               return -EINVAL;
>> +
>> +       vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
>> +       ret = dma_mmap_attrs(info->dev, vma, info->vaddr, info->paddr,
>> +                            info->size, &attrs);
>> +
>> +       return ret;
> Kill the temporary variable 'ret' ?

sure
>
>
>> +static struct dma_buf_ops smaf_cma_ops = {
> const ? Afaict the compiler would/should warn you about discarding it
> as the ops are defined const.
>
>
>> +static struct dma_buf *smaf_cma_allocate(struct dma_buf *dmabuf,
>> +                                        size_t length, unsigned int flags)
>> +{
>> +       struct dma_buf_attachment *attach_obj;
>> +       struct smaf_cma_buffer_info *info;
>> +       struct dma_buf *cma_dmabuf;
>> +       int ret;
>> +
>> +       DEFINE_DMA_BUF_EXPORT_INFO(export);
>> +       DEFINE_DMA_ATTRS(attrs);
>> +
>> +       dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
>> +
>> +       info = kzalloc(sizeof(*info), GFP_KERNEL);
>> +       if (!info)
>> +               return NULL;
>> +
>> +       info->dev = find_matching_device(dmabuf);
> find_matching_device() can return NULL. We should handle that imho.
>

If the returned device have an associated CMA area then it will use it else
if dev have not CMA area or if find_matching_device() return NULL
the default CMA area will be used

>> +       info->size = length;
>> +       info->vaddr = dma_alloc_attrs(info->dev, info->size, &info->paddr,
>> +                                     GFP_KERNEL | __GFP_NOWARN, &attrs);
>> +       if (!info->vaddr) {
>> +               ret = -ENOMEM;
> set-but-unused-variable 'ret' ?
>
I will remove it

>> +               goto error;
>> +       }
>> +
>> +       export.ops = &smaf_cma_ops;
>> +       export.size = info->size;
>> +       export.flags = flags;
>> +       export.priv = info;
>> +
>> +       cma_dmabuf = dma_buf_export(&export);
>> +       if (IS_ERR(cma_dmabuf))
> Missing dma_free_attrs() ? I'd add another label in the error path and
> handle it there.
>
OK

>> +               goto error;
>> +
>> +       list_for_each_entry(attach_obj, &dmabuf->attachments, node) {
>> +               dma_buf_attach(cma_dmabuf, attach_obj->dev);
> Imho one should error out if attach fails. Or warn at the very least ?
>
>
>> +static int __init smaf_cma_init(void)
>> +{
>> +       INIT_LIST_HEAD(&smaf_cma.list_node);
> Isn't this something that smaf_register_allocator() should be doing ?
>

Yes for sure

>
> Regards,
> Emil



-- 
Benjamin Gaignard

Graphic Working Group

Linaro.org │ Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
