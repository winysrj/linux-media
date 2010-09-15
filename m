Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55200 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab0IOIzn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 04:55:43 -0400
Received: by gxk23 with SMTP id 23so2659642gxk.19
        for <linux-media@vger.kernel.org>; Wed, 15 Sep 2010 01:55:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1284023988-23351-8-git-send-email-p.osciak@samsung.com>
References: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>
	<1284023988-23351-8-git-send-email-p.osciak@samsung.com>
Date: Wed, 15 Sep 2010 17:55:42 +0900
Message-ID: <AANLkTi=QYNNLqAYZcwECpa8Fxmpxt05i_0M_v+wk=+PJ@mail.gmail.com>
Subject: Re: [PATCH v1 7/7] v4l: videobuf2: add CMA allocator
From: han jonghun <jonghun79.han@gmail.com>
To: Pawel Osciak <p.osciak@samsung.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

In vb2_cma_put if buf->refcount is 0, cma_free is called.
But vb2_cma_put is usually called from munmap.
In my opinion cma_free should be called from VIDIOC_REQBUFS(0) not munmap.

BRs,

2010/9/9 Pawel Osciak <p.osciak@samsung.com>:
> Add support for the CMA contiguous memory allocator to videobuf2.
>
> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/Kconfig         |    5 +
>  drivers/media/video/Makefile        |    2 +
>  drivers/media/video/videobuf2-cma.c |  250 +++++++++++++++++++++++++++++++++++
>  include/media/videobuf2-cma.h       |   25 ++++
>  4 files changed, 282 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/videobuf2-cma.c
>  create mode 100644 include/media/videobuf2-cma.h
>
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index c2ea549..b63f377 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -65,6 +65,11 @@ config VIDEOBUF2_VMALLOC
>        select VIDEOBUF2_GEN_MEMOPS
>        tristate
>
> +config VIDEOBUF2_CMA
> +       depends on CMA
> +       select VIDEOBUF2_CORE
> +       select VIDEOBUF2_GEN_MEMOPS
> +       tristate
>
>  #
>  # Multimedia Video device configuration
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 20d359d..4146700 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -128,6 +128,8 @@ obj-$(CONFIG_VIDEOBUF2_VMALLOC)             += videobuf2_vmalloc.o
>  videobuf2_vmalloc-y                    := videobuf2-vmalloc.o \
>                                           videobuf2-memops.o
>
> +obj-$(CONFIG_VIDEOBUF2_CMA)            += videobuf2_cma.o
> +videobuf2_cma-y                                := videobuf2-cma.o videobuf2-memops.o
>
>  obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
>
> diff --git a/drivers/media/video/videobuf2-cma.c b/drivers/media/video/videobuf2-cma.c
> new file mode 100644
> index 0000000..c51e5a8
> --- /dev/null
> +++ b/drivers/media/video/videobuf2-cma.c
> @@ -0,0 +1,250 @@
> +/*
> + * videobuf2-cma.c - CMA memory allocator for videobuf2
> + *
> + * Copyright (C) 2010 Samsung Electronics
> + *
> + * Author: Pawel Osciak <p.osciak@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/cma.h>
> +#include <linux/mm.h>
> +#include <linux/sched.h>
> +#include <linux/file.h>
> +
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-memops.h>
> +
> +struct vb2_cma_conf {
> +       struct vb2_alloc_ctx    alloc_ctx;
> +       struct device           *dev;
> +       const char              *type;
> +       unsigned long           alignment;
> +};
> +
> +struct vb2_cma_buf {
> +       struct vb2_cma_conf     *conf;
> +       dma_addr_t              paddr;
> +       unsigned long           size;
> +       unsigned int            refcount;
> +       struct vm_area_struct   *vma;
> +};
> +
> +static void *vb2_cma_alloc(const struct vb2_alloc_ctx *alloc_ctx,
> +                               unsigned long size)
> +{
> +       struct vb2_cma_conf *conf =
> +               container_of(alloc_ctx, struct vb2_cma_conf, alloc_ctx);
> +       struct vb2_cma_buf *buf;
> +
> +       buf = kzalloc(sizeof *buf, GFP_KERNEL);
> +       if (!buf)
> +               return ERR_PTR(-ENOMEM);
> +
> +       buf->paddr = cma_alloc(conf->dev, conf->type, size, conf->alignment);
> +       if (!buf->paddr) {
> +               printk(KERN_ERR "cma_alloc of size %ld failed\n", size);
> +               kfree(buf);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       buf->conf = conf;
> +       buf->size = size;
> +       buf->refcount++;
> +
> +       printk(KERN_DEBUG "Allocated cma mem of size %ld at paddr=0x%08x\n",
> +                       buf->size, buf->paddr);
> +
> +       return buf;
> +}
> +
> +static void vb2_cma_put(void *buf_priv)
> +{
> +       struct vb2_cma_buf *buf = buf_priv;
> +
> +       buf->refcount--;
> +
> +       if (0 == buf->refcount) {
> +               cma_free(buf->paddr);
> +               kfree(buf);
> +       }
> +}
> +
> +static unsigned long vb2_cma_paddr(void *buf_priv)
> +{
> +       struct vb2_cma_buf *buf = buf_priv;
> +
> +       return buf->paddr;
> +}
> +
> +static unsigned int vb2_cma_num_users(void *buf_priv)
> +{
> +       struct vb2_cma_buf *buf = buf_priv;
> +
> +       return buf->refcount;
> +}
> +
> +static void vb2_cma_vm_open(struct vm_area_struct *vma)
> +{
> +       struct vb2_cma_buf *buf = vma->vm_private_data;
> +
> +       printk(KERN_DEBUG "%s cma_priv: %p, refcount: %d, "
> +                       "vma: %08lx-%08lx\n", __func__, buf, buf->refcount,
> +                       vma->vm_start, vma->vm_end);
> +
> +       buf->refcount++;
> +}
> +
> +static void vb2_cma_vm_close(struct vm_area_struct *vma)
> +{
> +       struct vb2_cma_buf *buf = vma->vm_private_data;
> +
> +       printk(KERN_DEBUG "%s cma_priv: %p, refcount: %d, "
> +                       "vma: %08lx-%08lx\n", __func__, buf, buf->refcount,
> +                       vma->vm_start, vma->vm_end);
> +
> +       vb2_cma_put(buf);
> +}
> +
> +static const struct vm_operations_struct vb2_cma_vm_ops = {
> +       .open = vb2_cma_vm_open,
> +       .close = vb2_cma_vm_close,
> +};
> +
> +static int vb2_cma_mmap(void *buf_priv, struct vm_area_struct *vma)
> +{
> +       struct vb2_cma_buf *buf = buf_priv;
> +
> +       if (!buf) {
> +               printk(KERN_ERR "No memory to map\n");
> +               return -EINVAL;
> +       }
> +
> +       return vb2_mmap_pfn_range(vma, buf->paddr, buf->size,
> +                                       &vb2_cma_vm_ops, buf);
> +}
> +
> +static void *vb2_cma_get_userptr(unsigned long vaddr, unsigned long size)
> +{
> +       struct vb2_cma_buf *buf;
> +       unsigned long paddr = 0;
> +       int ret;
> +
> +       buf = kzalloc(sizeof *buf, GFP_KERNEL);
> +       if (!buf)
> +               return ERR_PTR(-ENOMEM);
> +
> +       buf->vma = vb2_get_userptr(vaddr);
> +       if (!buf->vma) {
> +               printk(KERN_ERR "Failed acquiring VMA for vaddr 0x%08lx\n",
> +                               vaddr);
> +               ret = -EINVAL;
> +               goto done;
> +       }
> +
> +       ret = vb2_contig_verify_userptr(buf->vma, vaddr, size, &paddr);
> +       if (ret) {
> +               vb2_put_userptr(buf->vma);
> +               goto done;
> +       }
> +
> +       buf->size = size;
> +       buf->paddr = paddr;
> +
> +       return buf;
> +
> +done:
> +       kfree(buf);
> +       return ERR_PTR(ret);
> +}
> +
> +static void vb2_cma_put_userptr(void *mem_priv)
> +{
> +       struct vb2_cma_buf *buf = mem_priv;
> +
> +       if (!buf)
> +               return;
> +
> +       vb2_put_userptr(buf->vma);
> +       kfree(buf);
> +}
> +
> +static const struct vb2_mem_ops vb2_cma_ops = {
> +       .alloc          = vb2_cma_alloc,
> +       .put            = vb2_cma_put,
> +       .paddr          = vb2_cma_paddr,
> +       .mmap           = vb2_cma_mmap,
> +       .get_userptr    = vb2_cma_get_userptr,
> +       .put_userptr    = vb2_cma_put_userptr,
> +       .num_users      = vb2_cma_num_users,
> +};
> +
> +struct vb2_alloc_ctx *vb2_cma_init(struct device *dev, const char *type,
> +                                       unsigned long alignment)
> +{
> +       struct vb2_cma_conf *conf;
> +
> +       conf = kzalloc(sizeof *conf, GFP_KERNEL);
> +       if (!conf)
> +               return ERR_PTR(-ENOMEM);
> +
> +       conf->dev = dev;
> +       conf->type = type;
> +       conf->alignment = alignment;
> +       conf->alloc_ctx.mem_ops = &vb2_cma_ops;
> +
> +       return &conf->alloc_ctx;
> +}
> +EXPORT_SYMBOL_GPL(vb2_cma_init);
> +
> +void vb2_cma_cleanup(struct vb2_alloc_ctx *alloc_ctx)
> +{
> +       struct vb2_cma_conf *conf =
> +               container_of(alloc_ctx, struct vb2_cma_conf, alloc_ctx);
> +
> +       kfree(conf);
> +}
> +EXPORT_SYMBOL_GPL(vb2_cma_cleanup);
> +
> +struct vb2_alloc_ctx **vb2_cma_init_multi(struct device *dev,
> +                                         unsigned int num_planes,
> +                                         const char *types[],
> +                                         unsigned long alignments[])
> +{
> +       struct vb2_alloc_ctx    **alloc_ctxes;
> +       struct vb2_cma_conf     *cma_conf;
> +       unsigned int i;
> +
> +       alloc_ctxes = kzalloc((sizeof *alloc_ctxes + sizeof *cma_conf)
> +                               * num_planes, GFP_KERNEL);
> +       if (!alloc_ctxes)
> +               return ERR_PTR(-ENOMEM);
> +
> +       cma_conf = (void *)(alloc_ctxes + num_planes);
> +
> +       for (i = 0; i < num_planes; ++i, ++cma_conf) {
> +               alloc_ctxes[i] = &cma_conf->alloc_ctx;
> +               cma_conf->dev = dev;
> +               cma_conf->type = types[i];
> +               cma_conf->alignment = alignments[i];
> +               cma_conf->alloc_ctx.mem_ops = &vb2_cma_ops;
> +       }
> +
> +       return alloc_ctxes;
> +}
> +EXPORT_SYMBOL_GPL(vb2_cma_init_multi);
> +
> +void vb2_cma_cleanup_multi(struct vb2_alloc_ctx **alloc_ctxes)
> +{
> +       kfree(alloc_ctxes);
> +}
> +EXPORT_SYMBOL_GPL(vb2_cma_cleanup_multi);
> +
> +MODULE_DESCRIPTION("CMA allocator handling routines for videobuf2");
> +MODULE_AUTHOR("Pawel Osciak");
> +MODULE_LICENSE("GPL");
> diff --git a/include/media/videobuf2-cma.h b/include/media/videobuf2-cma.h
> new file mode 100644
> index 0000000..557eeb0
> --- /dev/null
> +++ b/include/media/videobuf2-cma.h
> @@ -0,0 +1,25 @@
> +/*
> + * videobuf2-cma.h - CMA memory allocator for videobuf2
> + *
> + * Copyright (C) 2010 Samsung Electronics
> + *
> + * Author: Pawel Osciak <p.osciak@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation.
> + */
> +
> +struct vb2_alloc_ctx *vb2_cma_init(struct device *dev, const char *type,
> +                                       unsigned long alignment);
> +void vb2_cma_cleanup(struct vb2_alloc_ctx *alloc_ctx);
> +
> +struct vb2_alloc_ctx **vb2_cma_init_multi(struct device *dev,
> +                                 unsigned int num_planes, const char *types[],
> +                                 unsigned long alignments[]);
> +void vb2_cma_cleanup_multi(struct vb2_alloc_ctx **alloc_ctxes);
> +
> +struct vb2_alloc_ctx *vb2_cma_init(struct device *dev, const char *type,
> +                                       unsigned long alignment);
> +void vb2_cma_cleanup(struct vb2_alloc_ctx *alloc_ctx);
> +
> --
> 1.7.2.1.97.g3235b.dirty
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
