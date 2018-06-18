Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:38304 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754895AbeFRHIt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 03:08:49 -0400
Received: by mail-yb0-f195.google.com with SMTP id q62-v6so5599615ybg.5
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2018 00:08:49 -0700 (PDT)
Received: from mail-yw0-f172.google.com (mail-yw0-f172.google.com. [209.85.161.172])
        by smtp.gmail.com with ESMTPSA id g62-v6sm6026209ywh.34.2018.06.18.00.08.46
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Jun 2018 00:08:47 -0700 (PDT)
Received: by mail-yw0-f172.google.com with SMTP id p129-v6so5301970ywg.7
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2018 00:08:46 -0700 (PDT)
MIME-Version: 1.0
References: <1522376100-22098-1-git-send-email-yong.zhi@intel.com> <1522376100-22098-5-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1522376100-22098-5-git-send-email-yong.zhi@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 18 Jun 2018 16:08:34 +0900
Message-ID: <CAAFQd5C1nKr+hEVREF99sYBy7Nb8Y8TuimHVgn6r6Sz6b--+Dg@mail.gmail.com>
Subject: Re: [PATCH v6 04/12] intel-ipu3: Implement DMA mapping functions
To: Yong Zhi <yong.zhi@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 30, 2018 at 11:15 AM Yong Zhi <yong.zhi@intel.com> wrote:
>
> From: Tomasz Figa <tfiga@chromium.org>
>
> This driver uses IOVA space for buffer mapping through IPU3 MMU
> to transfer data between imaging pipelines and system DDR.
>
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-css-pool.h |  36 ++++
>  drivers/media/pci/intel/ipu3/ipu3-dmamap.c   | 280 +++++++++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3-dmamap.h   |  22 +++
>  drivers/media/pci/intel/ipu3/ipu3.h          | 151 +++++++++++++++
>  4 files changed, 489 insertions(+)
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-pool.h
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-dmamap.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-dmamap.h
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3.h
>
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-pool.h b/drivers/media/pci/intel/ipu3/ipu3-css-pool.h
> new file mode 100644
> index 000000000000..4b22e0856232
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-css-pool.h
> @@ -0,0 +1,36 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2018 Intel Corporation */
> +
> +#ifndef __IPU3_UTIL_H
> +#define __IPU3_UTIL_H
> +
> +struct device;
> +
> +#define IPU3_CSS_POOL_SIZE             4
> +
> +struct ipu3_css_map {
> +       size_t size;
> +       void *vaddr;
> +       dma_addr_t daddr;
> +       struct vm_struct *vma;
> +};
> +
> +struct ipu3_css_pool {
> +       struct {
> +               struct ipu3_css_map param;
> +               long framenum;
> +       } entry[IPU3_CSS_POOL_SIZE];
> +       unsigned int last; /* Latest entry */

It's not clear what "Latest entry" means here. Since these structs are
a part of the interface exposed by this header, could you write proper
kerneldoc comments for all fields in both of them?

> +};
> +
> +int ipu3_css_dma_buffer_resize(struct device *dev, struct ipu3_css_map *map,
> +                              size_t size);
> +void ipu3_css_pool_cleanup(struct device *dev, struct ipu3_css_pool *pool);
> +int ipu3_css_pool_init(struct device *dev, struct ipu3_css_pool *pool,
> +                      size_t size);
> +int ipu3_css_pool_get(struct ipu3_css_pool *pool, long framenum);
> +void ipu3_css_pool_put(struct ipu3_css_pool *pool);
> +const struct ipu3_css_map *ipu3_css_pool_last(struct ipu3_css_pool *pool,
> +                                             unsigned int last);
> +
> +#endif
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-dmamap.c b/drivers/media/pci/intel/ipu3/ipu3-dmamap.c
> new file mode 100644
> index 000000000000..b2bc5d00debc
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-dmamap.c
> @@ -0,0 +1,280 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2018 Intel Corporation
> + * Copyright (C) 2018 Google, Inc.

Would you mind changing as below?

Copyright 2018 Google LLC.

> + *
> + * Author: Tomasz Figa <tfiga@chromium.org>
> + * Author: Yong Zhi <yong.zhi@intel.com>
> + */
> +
> +#include <linux/vmalloc.h>
> +
> +#include "ipu3.h"
> +#include "ipu3-css-pool.h"
> +#include "ipu3-mmu.h"
> +
> +/*
> + * Free a buffer allocated by ipu3_dmamap_alloc_buffer()
> + */
> +static void ipu3_dmamap_free_buffer(struct page **pages,
> +                                   size_t size)
> +{
> +       int count = size >> PAGE_SHIFT;
> +
> +       while (count--)
> +               __free_page(pages[count]);
> +       kvfree(pages);
> +}
> +
> +/*
> + * Based on the implementation of __iommu_dma_alloc_pages()
> + * defined in drivers/iommu/dma-iommu.c
> + */
> +static struct page **ipu3_dmamap_alloc_buffer(size_t size,
> +                                             unsigned long order_mask,
> +                                             gfp_t gfp)
> +{
> +       struct page **pages;
> +       unsigned int i = 0, count = size >> PAGE_SHIFT;
> +       const gfp_t high_order_gfp = __GFP_NOWARN | __GFP_NORETRY;
> +
> +       /* Allocate mem for array of page ptrs */
> +       pages = kvmalloc_array(count, sizeof(struct page *), GFP_KERNEL);

sizeof(*pages) to ensure that the right type is used regardless of declaration.

> +

No need for this blank line.

> +       if (!pages)
> +               return NULL;
[snip]
> +/**
> + * ipu3_dmamap_alloc - allocate and map a buffer into KVA
> + * @dev: struct device pointer
> + * @map: struct to store mapping variables
> + * @len: size required
> + *
> + * Return KVA on success or NULL on failure
> + */
> +void *ipu3_dmamap_alloc(struct device *dev, struct ipu3_css_map *map,
> +                       size_t len)
> +{
> +       struct imgu_device *imgu = dev_get_drvdata(dev);

Wouldn't it make more sense to just pass struct imgu_device pointer to
all the functions in this file directly?

> +       unsigned long shift = iova_shift(&imgu->iova_domain);
> +       unsigned int alloc_sizes = imgu->mmu->pgsize_bitmap;
> +       size_t size = PAGE_ALIGN(len);
> +       struct page **pages;
> +       dma_addr_t iovaddr;
> +       struct iova *iova;
> +       int i, rval;
> +
> +       if (WARN_ON(!dev))
> +               return NULL;

Isn't this impossible to happen?

> +
> +       dev_dbg(dev, "%s: allocating %zu\n", __func__, size);
> +
> +       iova = alloc_iova(&imgu->iova_domain, size >> shift,
> +                         imgu->mmu->aperture_end >> shift, 0);
> +       if (!iova)
> +               return NULL;
[snip]
> +void ipu3_dmamap_exit(struct device *dev)
> +{
> +       struct imgu_device *imgu = dev_get_drvdata(dev);
> +
> +       put_iova_domain(&imgu->iova_domain);
> +       iova_cache_put();
> +       imgu->mmu = NULL;

We can't set mmu to NULL here, because ipu3_mmu module is the owner of
it and it will be still dereferenced in ipu3_mmu_exit(). (This might
be fixed in your tree already as per
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/1084522)

> +}
[snip]
> diff --git a/drivers/media/pci/intel/ipu3/ipu3.h b/drivers/media/pci/intel/ipu3/ipu3.h
> new file mode 100644
> index 000000000000..2ba6fa58e41c
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3.h
> @@ -0,0 +1,151 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2018 Intel Corporation */
> +
> +#ifndef __IPU3_H
> +#define __IPU3_H
> +
> +#include <linux/iova.h>
> +#include <linux/pci.h>
> +
> +#include <media/v4l2-device.h>
> +#include <media/videobuf2-dma-sg.h>
> +
> +#include "ipu3-css.h"
> +
> +#define IMGU_NAME                      "ipu3-imgu"
> +
> +/*
> + * The semantics of the driver is that whenever there is a buffer available in
> + * master queue, the driver queues a buffer also to all other active nodes.
> + * If user space hasn't provided a buffer to all other video nodes first,
> + * the driver gets an internal dummy buffer and queues it.
> + */
> +#define IMGU_QUEUE_MASTER              IPU3_CSS_QUEUE_IN
> +#define IMGU_QUEUE_FIRST_INPUT         IPU3_CSS_QUEUE_OUT
> +#define IMGU_MAX_QUEUE_DEPTH           (2 + 2)
> +
> +#define IMGU_NODE_IN                   0 /* Input RAW image */
> +#define IMGU_NODE_PARAMS               1 /* Input parameters */
> +#define IMGU_NODE_OUT                  2 /* Main output for still or video */
> +#define IMGU_NODE_VF                   3 /* Preview */
> +#define IMGU_NODE_PV                   4 /* Postview for still capture */
> +#define IMGU_NODE_STAT_3A              5 /* 3A statistics */
> +#define IMGU_NODE_NUM                  6

Does this file really belong to this patch?

Best regards,
Tomasz
