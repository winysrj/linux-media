Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:56713 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbeKLTNj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 14:13:39 -0500
Date: Mon, 12 Nov 2018 11:21:15 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: "Zhi, Yong" <yong.zhi@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: Re: [PATCH v7 08/16] intel-ipu3: css: Add dma buff pool utility
 functions
Message-ID: <20181112092115.2xjho6wkdhruuvx6@paasikivi.fi.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-9-git-send-email-yong.zhi@intel.com>
 <20181108153611.amyq6s7ikvn6aakw@paasikivi.fi.intel.com>
 <C193D76D23A22742993887E6D207B54D3DB2FF65@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C193D76D23A22742993887E6D207B54D3DB2FF65@ORSMSX106.amr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Fri, Nov 09, 2018 at 11:16:44PM +0000, Zhi, Yong wrote:
> Hi, Sakari,
> 
> > -----Original Message-----
> > From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]
> > Sent: Thursday, November 8, 2018 9:36 AM
> > To: Zhi, Yong <yong.zhi@intel.com>
> > Cc: linux-media@vger.kernel.org; tfiga@chromium.org;
> > mchehab@kernel.org; hans.verkuil@cisco.com;
> > laurent.pinchart@ideasonboard.com; Mani, Rajmohan
> > <rajmohan.mani@intel.com>; Zheng, Jian Xu <jian.xu.zheng@intel.com>; Hu,
> > Jerry W <jerry.w.hu@intel.com>; Toivonen, Tuukka
> > <tuukka.toivonen@intel.com>; Qiu, Tian Shu <tian.shu.qiu@intel.com>; Cao,
> > Bingbu <bingbu.cao@intel.com>
> > Subject: Re: [PATCH v7 08/16] intel-ipu3: css: Add dma buff pool utility
> > functions
> > 
> > Hi Yong,
> > 
> > On Mon, Oct 29, 2018 at 03:23:02PM -0700, Yong Zhi wrote:
> > > The pools are used to store previous parameters set by user with the
> > > parameter queue. Due to pipelining, there needs to be multiple sets
> > > (up to four) of parameters which are queued in a host-to-sp queue.
> > >
> > > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > > ---
> > >  drivers/media/pci/intel/ipu3/ipu3-css-pool.c | 136
> > > +++++++++++++++++++++++++++
> > > drivers/media/pci/intel/ipu3/ipu3-css-pool.h |  56 +++++++++++
> > >  2 files changed, 192 insertions(+)
> > >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-pool.c
> > >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-pool.h
> > >
> > > diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-pool.c
> > > b/drivers/media/pci/intel/ipu3/ipu3-css-pool.c
> > > new file mode 100644
> > > index 0000000..eab41c3
> > > --- /dev/null
> > > +++ b/drivers/media/pci/intel/ipu3/ipu3-css-pool.c
> > > @@ -0,0 +1,136 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +// Copyright (C) 2018 Intel Corporation
> > > +
> > > +#include <linux/device.h>
> > > +
> > > +#include "ipu3.h"
> > > +#include "ipu3-css-pool.h"
> > > +#include "ipu3-dmamap.h"
> > > +
> > > +int ipu3_css_dma_buffer_resize(struct imgu_device *imgu,
> > > +			       struct ipu3_css_map *map, size_t size) {
> > > +	if (map->size < size && map->vaddr) {
> > > +		dev_warn(&imgu->pci_dev->dev, "dma buf resized from %zu
> > to %zu",
> > > +			 map->size, size);
> > > +
> > > +		ipu3_dmamap_free(imgu, map);
> > > +		if (!ipu3_dmamap_alloc(imgu, map, size))
> > > +			return -ENOMEM;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +void ipu3_css_pool_cleanup(struct imgu_device *imgu, struct
> > > +ipu3_css_pool *pool) {
> > > +	unsigned int i;
> > > +
> > > +	for (i = 0; i < IPU3_CSS_POOL_SIZE; i++)
> > > +		ipu3_dmamap_free(imgu, &pool->entry[i].param); }
> > > +
> > > +int ipu3_css_pool_init(struct imgu_device *imgu, struct ipu3_css_pool
> > *pool,
> > > +		       size_t size)
> > > +{
> > > +	unsigned int i;
> > > +
> > > +	for (i = 0; i < IPU3_CSS_POOL_SIZE; i++) {
> > > +		/*
> > > +		 * entry[i].framenum is initialized to INT_MIN so that
> > > +		 * ipu3_css_pool_check() can treat it as usesable slot.
> > > +		 */
> > > +		pool->entry[i].framenum = INT_MIN;
> > > +
> > > +		if (size == 0) {
> > > +			pool->entry[i].param.vaddr = NULL;
> > > +			continue;
> > > +		}
> > > +
> > > +		if (!ipu3_dmamap_alloc(imgu, &pool->entry[i].param, size))
> > > +			goto fail;
> > > +	}
> > > +
> > > +	pool->last = IPU3_CSS_POOL_SIZE;
> > > +
> > > +	return 0;
> > > +
> > > +fail:
> > > +	ipu3_css_pool_cleanup(imgu, pool);
> > > +	return -ENOMEM;
> > > +}
> > > +
> > > +/*
> > > + * Check that the following call to pool_get succeeds.
> > > + * Return negative on error.
> > > + */
> > > +static int ipu3_css_pool_check(struct ipu3_css_pool *pool, long
> > > +framenum) {
> > > +	/* Get the oldest entry */
> > > +	int n = (pool->last + 1) % IPU3_CSS_POOL_SIZE;
> > > +	long diff = framenum - pool->entry[n].framenum;
> > > +
> > > +	/* if framenum wraps around and becomes smaller than entry n */
> > > +	if (diff < 0)
> > > +		diff += LONG_MAX;
> > 
> > Have you tested the wrap-around? As a result, the value of the diff is
> > between -1 and LONG_MAX - 1 (without considering more than just the two
> > lines above). Is that intended?
> > 
> 
> Yes, I simulated wrap-around using a smaller limit in v5.
> 
> > You seem to be using different types for the frame number; sometimes int,
> > sometimes long. Could you align that, preferrably to an unsigned type? u32
> > would probably be a sound choice.
> > 
> 
> Will use u32 at places except entry.framenum, which is initialized to
> INT_MIN. This is because the frame is counted from 0 at stream start, and
> the entry.framenum must be smaller enough for the ipu3_css_pool_check()
> to not return -ENOSPC.

You could use another field to tell whether an entry is valid or not.
That'd simplify the code, as well as remove the need to cap the frame
number to an arbitrary value.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
