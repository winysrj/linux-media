Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:34512 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbeKIBMT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 20:12:19 -0500
Date: Thu, 8 Nov 2018 17:36:11 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com,
        tuukka.toivonen@intel.com, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com
Subject: Re: [PATCH v7 08/16] intel-ipu3: css: Add dma buff pool utility
 functions
Message-ID: <20181108153611.amyq6s7ikvn6aakw@paasikivi.fi.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-9-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540851790-1777-9-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Mon, Oct 29, 2018 at 03:23:02PM -0700, Yong Zhi wrote:
> The pools are used to store previous parameters set by
> user with the parameter queue. Due to pipelining,
> there needs to be multiple sets (up to four)
> of parameters which are queued in a host-to-sp queue.
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-css-pool.c | 136 +++++++++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3-css-pool.h |  56 +++++++++++
>  2 files changed, 192 insertions(+)
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-pool.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-pool.h
> 
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-pool.c b/drivers/media/pci/intel/ipu3/ipu3-css-pool.c
> new file mode 100644
> index 0000000..eab41c3
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-css-pool.c
> @@ -0,0 +1,136 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2018 Intel Corporation
> +
> +#include <linux/device.h>
> +
> +#include "ipu3.h"
> +#include "ipu3-css-pool.h"
> +#include "ipu3-dmamap.h"
> +
> +int ipu3_css_dma_buffer_resize(struct imgu_device *imgu,
> +			       struct ipu3_css_map *map, size_t size)
> +{
> +	if (map->size < size && map->vaddr) {
> +		dev_warn(&imgu->pci_dev->dev, "dma buf resized from %zu to %zu",
> +			 map->size, size);
> +
> +		ipu3_dmamap_free(imgu, map);
> +		if (!ipu3_dmamap_alloc(imgu, map, size))
> +			return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +void ipu3_css_pool_cleanup(struct imgu_device *imgu, struct ipu3_css_pool *pool)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < IPU3_CSS_POOL_SIZE; i++)
> +		ipu3_dmamap_free(imgu, &pool->entry[i].param);
> +}
> +
> +int ipu3_css_pool_init(struct imgu_device *imgu, struct ipu3_css_pool *pool,
> +		       size_t size)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < IPU3_CSS_POOL_SIZE; i++) {
> +		/*
> +		 * entry[i].framenum is initialized to INT_MIN so that
> +		 * ipu3_css_pool_check() can treat it as usesable slot.
> +		 */
> +		pool->entry[i].framenum = INT_MIN;
> +
> +		if (size == 0) {
> +			pool->entry[i].param.vaddr = NULL;
> +			continue;
> +		}
> +
> +		if (!ipu3_dmamap_alloc(imgu, &pool->entry[i].param, size))
> +			goto fail;
> +	}
> +
> +	pool->last = IPU3_CSS_POOL_SIZE;
> +
> +	return 0;
> +
> +fail:
> +	ipu3_css_pool_cleanup(imgu, pool);
> +	return -ENOMEM;
> +}
> +
> +/*
> + * Check that the following call to pool_get succeeds.
> + * Return negative on error.
> + */
> +static int ipu3_css_pool_check(struct ipu3_css_pool *pool, long framenum)
> +{
> +	/* Get the oldest entry */
> +	int n = (pool->last + 1) % IPU3_CSS_POOL_SIZE;
> +	long diff = framenum - pool->entry[n].framenum;
> +
> +	/* if framenum wraps around and becomes smaller than entry n */
> +	if (diff < 0)
> +		diff += LONG_MAX;

Have you tested the wrap-around? As a result, the value of the diff is
between -1 and LONG_MAX - 1 (without considering more than just the two
lines above). Is that intended?

You seem to be using different types for the frame number; sometimes int,
sometimes long. Could you align that, preferrably to an unsigned type? u32
would probably be a sound choice.

The entry (index to pool->entry array) should be unsigned as well.

> +
> +	/*
> +	 * pool->entry[n].framenum stores the frame number where that
> +	 * entry was allocated. If that was allocated more than POOL_SIZE
> +	 * frames back, it is old enough that we know it is no more in
> +	 * use by firmware.
> +	 */
> +	if (diff > IPU3_CSS_POOL_SIZE)
> +		return n;
> +
> +	return -ENOSPC;
> +}
> +
> +/*
> + * Allocate a new parameter from pool at frame number `framenum'.
> + * Release the oldest entry in the pool to make space for the new entry.
> + * Return negative on error.
> + */
> +int ipu3_css_pool_get(struct ipu3_css_pool *pool, long framenum)
> +{
> +	int n = ipu3_css_pool_check(pool, framenum);
> +
> +	if (n < 0)
> +		return n;
> +
> +	pool->entry[n].framenum = framenum;
> +	pool->last = n;
> +
> +	return n;
> +}
> +
> +/*
> + * Undo, for all practical purposes, the effect of pool_get().
> + */
> +void ipu3_css_pool_put(struct ipu3_css_pool *pool)
> +{
> +	pool->entry[pool->last].framenum = INT_MIN;
> +	pool->last = (pool->last + IPU3_CSS_POOL_SIZE - 1) % IPU3_CSS_POOL_SIZE;
> +}
> +
> +/**
> + * ipu3_css_pool_last - Retrieve the nth pool entry from last
> + *
> + * @pool: a pointer to &struct ipu3_css_pool.
> + * @n: the distance to the last index.
> + *
> + * Return: The nth entry from last or null map to indicate no frame stored.
> + */
> +const struct ipu3_css_map *
> +ipu3_css_pool_last(struct ipu3_css_pool *pool, unsigned int n)
> +{
> +	static const struct ipu3_css_map null_map = { 0 };
> +	int i = (pool->last + IPU3_CSS_POOL_SIZE - n) % IPU3_CSS_POOL_SIZE;
> +
> +	WARN_ON(n >= IPU3_CSS_POOL_SIZE);
> +
> +	if (pool->entry[i].framenum < 0)
> +		return &null_map;
> +
> +	return &pool->entry[i].param;
> +}
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-pool.h b/drivers/media/pci/intel/ipu3/ipu3-css-pool.h
> new file mode 100644
> index 0000000..71e48d1
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-css-pool.h
> @@ -0,0 +1,56 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2018 Intel Corporation */
> +
> +#ifndef __IPU3_UTIL_H
> +#define __IPU3_UTIL_H
> +
> +struct device;
> +struct imgu_device;
> +
> +#define IPU3_CSS_POOL_SIZE		4
> +
> +/**
> + * ipu3_css_map - store DMA mapping info for buffer
> + *
> + * @size:		size of the buffer in bytes.
> + * @vaddr:		kernel virtual address.
> + * @daddr:		iova dma address to access IPU3.
> + * @vma:		private, a pointer to &struct vm_struct,
> + *			used for ipu3_dmamap_free.
> + */
> +struct ipu3_css_map {
> +	size_t size;
> +	void *vaddr;
> +	dma_addr_t daddr;
> +	struct vm_struct *vma;
> +};
> +
> +/**
> + * ipu3_css_pool - circular buffer pool definition
> + *
> + * @entry:		array with IPU3_CSS_POOL_SIZE elements.
> + * @entry.param:	a &struct ipu3_css_map for storing the mem mapping.
> + * @entry.framenum:	the css frame number, used to determine if the entry
> + *			is old enough to be recycled.
> + * @last:		write pointer, initialized to IPU3_CSS_POOL_SIZE.
> + */
> +struct ipu3_css_pool {
> +	struct {
> +		struct ipu3_css_map param;
> +		long framenum;
> +	} entry[IPU3_CSS_POOL_SIZE];
> +	unsigned int last; /* Latest entry */
> +};
> +
> +int ipu3_css_dma_buffer_resize(struct imgu_device *imgu,
> +			       struct ipu3_css_map *map, size_t size);
> +void ipu3_css_pool_cleanup(struct imgu_device *imgu,
> +			   struct ipu3_css_pool *pool);
> +int ipu3_css_pool_init(struct imgu_device *imgu, struct ipu3_css_pool *pool,
> +		       size_t size);
> +int ipu3_css_pool_get(struct ipu3_css_pool *pool, long framenum);
> +void ipu3_css_pool_put(struct ipu3_css_pool *pool);
> +const struct ipu3_css_map *ipu3_css_pool_last(struct ipu3_css_pool *pool,
> +					      unsigned int last);
> +
> +#endif

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
