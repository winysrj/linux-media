Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53902 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934873AbeFMBi3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 21:38:29 -0400
Subject: Re: [PATCH v3 6/9] xen/gntdev: Make private routines/structures
 accessible
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180612134200.17456-1-andr2000@gmail.com>
 <20180612134200.17456-7-andr2000@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <fc339230-f1e1-303b-1b82-0bd23d7b69b3@oracle.com>
Date: Tue, 12 Jun 2018 21:38:13 -0400
MIME-Version: 1.0
In-Reply-To: <20180612134200.17456-7-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/12/2018 09:41 AM, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
> 
> This is in preparation for adding support of DMA buffer
> functionality: make map/unmap related code and structures, used
> privately by gntdev, ready for dma-buf extension, which will re-use
> these. Rename corresponding structures as those become non-private
> to gntdev now.
> 
> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
> ---
>   drivers/xen/gntdev-common.h |  86 +++++++++++++++++++++++
>   drivers/xen/gntdev.c        | 132 ++++++++++++------------------------
>   2 files changed, 128 insertions(+), 90 deletions(-)
>   create mode 100644 drivers/xen/gntdev-common.h
> 
> diff --git a/drivers/xen/gntdev-common.h b/drivers/xen/gntdev-common.h
> new file mode 100644
> index 000000000000..7a9845a6bee9
> --- /dev/null
> +++ b/drivers/xen/gntdev-common.h
> @@ -0,0 +1,86 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/*
> + * Common functionality of grant device.
> + *
> + * Copyright (c) 2006-2007, D G Murray.
> + *           (c) 2009 Gerd Hoffmann <kraxel@redhat.com>
> + *           (c) 2018 Oleksandr Andrushchenko, EPAM Systems Inc.
> + */
> +
> +#ifndef _GNTDEV_COMMON_H
> +#define _GNTDEV_COMMON_H
> +
> +#include <linux/mm.h>
> +#include <linux/mman.h>
> +#include <linux/mmu_notifier.h>
> +#include <linux/types.h>
> +
> +struct gntdev_priv {
> +	/* maps with visible offsets in the file descriptor */
> +	struct list_head maps;
> +	/* maps that are not visible; will be freed on munmap.
> +	 * Only populated if populate_freeable_maps == 1 */


Since you are touching this code please fix comment style.


> +	struct list_head freeable_maps;
> +	/* lock protects maps and freeable_maps */
> +	struct mutex lock;
> +	struct mm_struct *mm;
> +	struct mmu_notifier mn;
> +
> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
> +	/* Device for which DMA memory is allocated. */
> +	struct device *dma_dev;
> +#endif
> +};


With that fixed,

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
