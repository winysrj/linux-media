Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49905 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751113AbdJWDKL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Oct 2017 23:10:11 -0400
From: "Zhi, Yong" <yong.zhi@intel.com>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        Tomasz Figa <tfiga@chromium.org>
Subject: RE: [PATCH v4 06/12] intel-ipu3: css: imgu dma buff pool
Date: Mon, 23 Oct 2017 03:10:09 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D1AE2B790@ORSMSX106.amr.corp.intel.com>
References: <1508298896-26096-1-git-send-email-yong.zhi@intel.com>
 <1508298896-26096-3-git-send-email-yong.zhi@intel.com>
 <20171020103827.owz24ki6cmd6laop@valkosipuli.retiisi.org.uk>
In-Reply-To: <20171020103827.owz24ki6cmd6laop@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Sakari,

Thanks for your review.

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> Sent: Friday, October 20, 2017 3:38 AM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; Zheng, Jian
> Xu <jian.xu.zheng@intel.com>; Mani, Rajmohan
> <rajmohan.mani@intel.com>; Toivonen, Tuukka
> <tuukka.toivonen@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>; Tomasz
> Figa <tfiga@chromium.org>
> Subject: Re: [PATCH v4 06/12] intel-ipu3: css: imgu dma buff pool
> 
> On Tue, Oct 17, 2017 at 10:54:51PM -0500, Yong Zhi wrote:
> > The pools are used to store previous parameters set by user with the
> > parameter queue. Due to pipelining, there needs to be multiple sets
> > (up to four) of parameters which are queued in a host-to-sp queue.
> >
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> > ---
> >  drivers/media/pci/intel/ipu3/ipu3-css-pool.c | 132
> > +++++++++++++++++++++++++++
> > drivers/media/pci/intel/ipu3/ipu3-css-pool.h |  54 +++++++++++
> >  2 files changed, 186 insertions(+)
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-pool.c
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-pool.h
> >
> > diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-pool.c
> > b/drivers/media/pci/intel/ipu3/ipu3-css-pool.c
> > new file mode 100644
> > index 000000000000..d08e2a8b68ed
> > --- /dev/null
> > +++ b/drivers/media/pci/intel/ipu3/ipu3-css-pool.c
> > @@ -0,0 +1,132 @@
> > +/*
> > + * Copyright (c) 2017 Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > +version
> > + * 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/dma-direction.h>
> > +#include <linux/scatterlist.h>
> > +#include <linux/types.h>
> > +
> > +#include "ipu3-css-pool.h"
> > +#include "ipu3-dmamap.h"
> > +
> > +int ipu3_css_dma_alloc(struct device *dev,
> > +		       struct ipu3_css_map *map, size_t size) {
> > +	struct imgu_device *imgu = dev_get_drvdata(dev);
> > +
> > +	if (size == 0) {
> > +		map->vaddr = NULL;
> > +		return 0;
> > +	}
> > +
> > +	if (!ipu3_dmamap_alloc(imgu, map, size))
> > +		return -ENOMEM;
> > +
> > +	return 0;
> > +}
> > +
> > +void ipu3_css_dma_free(struct device *dev, struct ipu3_css_map *map)
> > +{
> > +	struct imgu_device *imgu = dev_get_drvdata(dev);
> > +
> > +	ipu3_dmamap_free(imgu, map);
> > +}
> > +
> > +void ipu3_css_pool_cleanup(struct device *dev, struct ipu3_css_pool
> > +*pool) {
> > +	int i;
> > +
> > +	for (i = 0; i < IPU3_CSS_POOL_SIZE; i++)
> > +		ipu3_css_dma_free(dev, &pool->entry[i].param); }
> > +
> > +int ipu3_css_pool_init(struct device *dev, struct ipu3_css_pool *pool,
> > +		       int size)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < IPU3_CSS_POOL_SIZE; i++) {
> > +		pool->entry[i].framenum = INT_MIN;
> > +		if (ipu3_css_dma_alloc(dev, &pool->entry[i].param, size))
> > +			goto fail;
> > +	}
> > +
> > +	pool->last = IPU3_CSS_POOL_SIZE;
> > +
> > +	return 0;
> > +
> > +fail:
> > +	ipu3_css_pool_cleanup(dev, pool);
> > +	return -ENOMEM;
> > +}
> > +
> > +/*
> > + * Check that the following call to pool_get succeeds.
> > + * Return negative on error.
> > + */
> > +static int ipu3_css_pool_check(struct ipu3_css_pool *pool, long
> > +framenum) {
> > +	/* Get the oldest entry */
> > +	int n = (pool->last + 1) % IPU3_CSS_POOL_SIZE;
> > +
> > +	/*
> > +	 * pool->entry[n].framenum stores the frame number where that
> > +	 * entry was allocated. If that was allocated more than POOL_SIZE
> > +	 * frames back, it is old enough that we know it is no more in
> > +	 * use by firmware.
> > +	 */
> > +	if (pool->entry[n].framenum + IPU3_CSS_POOL_SIZE > framenum)
> 
> This will wrap around and the comparison fails when pool-
> >entry[n].framenum
> + IPU3_CSS_POOL_SIZE - 1 reaches LONG_MAX.
> 
> You could write this as:
> 
> if (framenum - pool->entry[n].franenum < IPU3_CSS_POOL_SIZE)
> 
> to avoid the problem.
> 
> You could use also int instead of long without any other changes to the code,
> or change INT_MAX / INT_MIN assignments to LONG_MAX / LONG_MIN.
> 

Ack the problem, the framenum could also become smaller than pool->entry[n].franenum when it wraps around, will fix in next update.

The pool->entry[n].franenum is initialized to INT_MIN so that it can satisfy the condition to return n, think any negative value greater than IPU3_CSS_POOL_SIZE should work here, I can add a comment for clarify.

> > +		return -ENOSPC;
> > +
> > +	return n;
> > +}
> > +
> > +/*
> > + * Allocate a new parameter from pool at frame number `framenum'.
> > + * Release the oldest entry in the pool to make space for the new entry.
> > + * Return negative on error.
> > + */
> > +int ipu3_css_pool_get(struct ipu3_css_pool *pool, long framenum) {
> > +	int n = ipu3_css_pool_check(pool, framenum);
> > +
> > +	if (n < 0)
> > +		return n;
> > +
> > +	pool->entry[n].framenum = framenum;
> > +	pool->last = n;
> > +
> > +	return n;
> > +}
> > +
> > +/*
> > + * Undo, for all practical purposes, the effect of pool_get().
> > + */
> > +void ipu3_css_pool_put(struct ipu3_css_pool *pool) {
> > +	pool->entry[pool->last].framenum = INT_MIN;
> > +	pool->last = (pool->last + IPU3_CSS_POOL_SIZE - 1) %
> > +IPU3_CSS_POOL_SIZE; }
> > +
> > +const struct ipu3_css_map *
> > +ipu3_css_pool_last(struct ipu3_css_pool *pool, unsigned int n) {
> > +	static const struct ipu3_css_map null_map = { 0 };
> > +	int i = (pool->last + IPU3_CSS_POOL_SIZE - n) % IPU3_CSS_POOL_SIZE;
> > +
> > +	WARN_ON(n >= IPU3_CSS_POOL_SIZE);
> > +
> > +	if (pool->entry[i].framenum < 0)
> > +		return &null_map;
> > +
> > +	return &pool->entry[i].param;
> > +}
> > diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-pool.h
> > b/drivers/media/pci/intel/ipu3/ipu3-css-pool.h
> > new file mode 100644
> > index 000000000000..9b6ac14acfb2
> > --- /dev/null
> > +++ b/drivers/media/pci/intel/ipu3/ipu3-css-pool.h
> > @@ -0,0 +1,54 @@
> > +/*
> > + * Copyright (c) 2017 Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > +version
> > + * 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __IPU3_UTIL_H
> > +#define __IPU3_UTIL_H
> > +
> > +#include <linux/device.h>
> > +
> > +#define sqr(x)				((x) * (x))
> > +#define DIV_ROUND_CLOSEST_DOWN(a, b)	(((a) + (b / 2) - 1) / (b))
> > +#define roundclosest_down(a, b)
> 	(DIV_ROUND_CLOSEST_DOWN(a, b) * (b))
> > +#define roundclosest(n, di)				\
> > +	({ typeof(n) __n = (n); typeof(di) __di = (di); \
> > +	DIV_ROUND_CLOSEST(__n, __di) * __di; })
> > +
> > +#define IPU3_CSS_POOL_SIZE		4
> > +
> > +struct ipu3_css_map {
> > +	size_t size;
> > +	void *vaddr;
> > +	dma_addr_t daddr;
> > +	struct vm_struct *vma;
> > +};
> > +
> > +struct ipu3_css_pool {
> > +	struct {
> > +		struct ipu3_css_map param;
> > +		long framenum;
> > +	} entry[IPU3_CSS_POOL_SIZE];
> > +	unsigned int last; /* Latest entry */ };
> > +
> > +int ipu3_css_dma_alloc(struct device *dev, struct ipu3_css_map *map,
> > +		       size_t size);
> > +void ipu3_css_dma_free(struct device *dev, struct ipu3_css_map *map);
> > +void ipu3_css_pool_cleanup(struct device *dev, struct ipu3_css_pool
> > +*pool); int ipu3_css_pool_init(struct device *dev, struct ipu3_css_pool
> *pool,
> > +		       int size);
> > +int ipu3_css_pool_get(struct ipu3_css_pool *pool, long framenum);
> > +void ipu3_css_pool_put(struct ipu3_css_pool *pool); const struct
> > +ipu3_css_map *ipu3_css_pool_last(struct ipu3_css_pool *pool,
> > +					      unsigned int last);
> > +
> > +#endif
> > --
> > 2.7.4
> >
> 
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi
