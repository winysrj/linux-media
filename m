Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:32988 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932253AbeFFJGG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 05:06:06 -0400
Subject: Re: [PATCH v2 6/9] xen/gntdev: Add initial support for dma-buf UAPI
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180601114132.22596-1-andr2000@gmail.com>
 <20180601114132.22596-7-andr2000@gmail.com>
 <29c1f1fb-2d52-e3df-adce-44fdee135413@oracle.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <d2bbda68-af74-58b1-36a6-d8af47ad8beb@gmail.com>
Date: Wed, 6 Jun 2018 12:06:02 +0300
MIME-Version: 1.0
In-Reply-To: <29c1f1fb-2d52-e3df-adce-44fdee135413@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/04/2018 11:49 PM, Boris Ostrovsky wrote:
> On 06/01/2018 07:41 AM, Oleksandr Andrushchenko wrote:
>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>
>> Add UAPI and IOCTLs for dma-buf grant device driver extension:
>> the extension allows userspace processes and kernel modules to
>> use Xen backed dma-buf implementation. With this extension grant
>> references to the pages of an imported dma-buf can be exported
>> for other domain use and grant references coming from a foreign
>> domain can be converted into a local dma-buf for local export.
>> Implement basic initialization and stubs for Xen DMA buffers'
>> support.
>
> It would be very helpful if people advocating for this interface
> reviewed it as well.
I would also love to see their comments here ;)
>
>> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>> ---
>>   drivers/xen/Kconfig         |  10 +++
>>   drivers/xen/Makefile        |   1 +
>>   drivers/xen/gntdev-dmabuf.c |  75 +++++++++++++++++++
>>   drivers/xen/gntdev-dmabuf.h |  41 +++++++++++
>>   drivers/xen/gntdev.c        | 142 ++++++++++++++++++++++++++++++++++++
>>   include/uapi/xen/gntdev.h   |  91 +++++++++++++++++++++++
>>   6 files changed, 360 insertions(+)
>>   create mode 100644 drivers/xen/gntdev-dmabuf.c
>>   create mode 100644 drivers/xen/gntdev-dmabuf.h
>>
>> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
>> index 39536ddfbce4..52d64e4b6b81 100644
>> --- a/drivers/xen/Kconfig
>> +++ b/drivers/xen/Kconfig
>> @@ -152,6 +152,16 @@ config XEN_GNTDEV
>>   	help
>>   	  Allows userspace processes to use grants.
>>   
>> +config XEN_GNTDEV_DMABUF
>> +	bool "Add support for dma-buf grant access device driver extension"
>> +	depends on XEN_GNTDEV && XEN_GRANT_DMA_ALLOC && DMA_SHARED_BUFFER
>
> Is there a reason to have XEN_GRANT_DMA_ALLOC without XEN_GNTDEV_DMABUF?
One can use grant-table's DMA API without using dma-buf at all, e.g.
dma-buf is sort of functionality on top of DMA allocated memory.
We have a use-case for a driver domain (guest domain in fact)
backed with IOMMU and still requiring allocations created as
contiguous/DMA memory, so those buffers can be passed around to
drivers expecting DMA-only buffers.
So, IMO this is a valid use-case "to have XEN_GRANT_DMA_ALLOC
without XEN_GNTDEV_DMABUF"
>
>> +	help
>> +	  Allows userspace processes and kernel modules to use Xen backed
>> +	  dma-buf implementation. With this extension grant references to
>> +	  the pages of an imported dma-buf can be exported for other domain
>> +	  use and grant references coming from a foreign domain can be
>> +	  converted into a local dma-buf for local export.
>> +
>>   config XEN_GRANT_DEV_ALLOC
>>   	tristate "User-space grant reference allocator driver"
>>   	depends on XEN
>> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
>> index 3c87b0c3aca6..33afb7b2b227 100644
>> --- a/drivers/xen/Makefile
>> +++ b/drivers/xen/Makefile
>> @@ -41,5 +41,6 @@ obj-$(CONFIG_XEN_PVCALLS_BACKEND)	+= pvcalls-back.o
>>   obj-$(CONFIG_XEN_PVCALLS_FRONTEND)	+= pvcalls-front.o
>>   xen-evtchn-y				:= evtchn.o
>>   xen-gntdev-y				:= gntdev.o
>> +xen-gntdev-$(CONFIG_XEN_GNTDEV_DMABUF)	+= gntdev-dmabuf.o
>>   xen-gntalloc-y				:= gntalloc.o
>>   xen-privcmd-y				:= privcmd.o
>> diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
>> new file mode 100644
>> index 000000000000..6bedd1387bd9
>> --- /dev/null
>> +++ b/drivers/xen/gntdev-dmabuf.c
>> @@ -0,0 +1,75 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +/*
>> + * Xen dma-buf functionality for gntdev.
>> + *
>> + * Copyright (c) 2018 Oleksandr Andrushchenko, EPAM Systems Inc.
>> + */
>> +
>> +#include <linux/slab.h>
>> +
>> +#include "gntdev-dmabuf.h"
>> +
>> +struct gntdev_dmabuf_priv {
>> +	int dummy;
>> +};
>> +
>> +/* ------------------------------------------------------------------ */
>> +/* DMA buffer export support.                                         */
>> +/* ------------------------------------------------------------------ */
>> +
>> +/* ------------------------------------------------------------------ */
>> +/* Implementation of wait for exported DMA buffer to be released.     */
>> +/* ------------------------------------------------------------------ */
> Why this comment style?
Just a copy-paste from gntdev, will change to usual /*..*/
>
>> +
>> +int gntdev_dmabuf_exp_wait_released(struct gntdev_dmabuf_priv *priv, int fd,
>> +				    int wait_to_ms)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +/* ------------------------------------------------------------------ */
>> +/* DMA buffer export support.                                         */
>> +/* ------------------------------------------------------------------ */
>> +
>> +int gntdev_dmabuf_exp_from_pages(struct gntdev_dmabuf_export_args *args)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +/* ------------------------------------------------------------------ */
>> +/* DMA buffer import support.                                         */
>> +/* ------------------------------------------------------------------ */
>> +
>> +struct gntdev_dmabuf *
>> +gntdev_dmabuf_imp_to_refs(struct gntdev_dmabuf_priv *priv, struct device *dev,
>> +			  int fd, int count, int domid)
>> +{
>> +	return ERR_PTR(-ENOMEM);
>> +}
>> +
>> +u32 *gntdev_dmabuf_imp_get_refs(struct gntdev_dmabuf *gntdev_dmabuf)
>> +{
>> +	return NULL;
>> +}
>> +
>> +int gntdev_dmabuf_imp_release(struct gntdev_dmabuf_priv *priv, u32 fd)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +struct gntdev_dmabuf_priv *gntdev_dmabuf_init(void)
>> +{
>> +	struct gntdev_dmabuf_priv *priv;
>> +
>> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>> +	if (!priv)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	return priv;
>> +}
>> +
>> +void gntdev_dmabuf_fini(struct gntdev_dmabuf_priv *priv)
>> +{
>> +	kfree(priv);
>> +}
>> diff --git a/drivers/xen/gntdev-dmabuf.h b/drivers/xen/gntdev-dmabuf.h
>> new file mode 100644
>> index 000000000000..040b2de904ac
>> --- /dev/null
>> +++ b/drivers/xen/gntdev-dmabuf.h
>> @@ -0,0 +1,41 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +/*
>> + * Xen dma-buf functionality for gntdev.
>> + *
>> + * Copyright (c) 2018 Oleksandr Andrushchenko, EPAM Systems Inc.
>> + */
>> +
>> +#ifndef _GNTDEV_DMABUF_H
>> +#define _GNTDEV_DMABUF_H
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/errno.h>
>> +#include <linux/types.h>
>> +
>> +struct gntdev_dmabuf_priv;
>> +struct gntdev_dmabuf;
>> +struct device;
>> +
>> +struct gntdev_dmabuf_export_args {
>> +	int dummy;
>> +};
>
> Please define the full structure (at least what you have in the next
> patch) here.
Ok, will define what I have in the next patch, but won't
initialize anything until the next patch. Will this work for you?
>
>> +
>> +struct gntdev_dmabuf_priv *gntdev_dmabuf_init(void);
>> +
>> +void gntdev_dmabuf_fini(struct gntdev_dmabuf_priv *priv);
>> +
>> +int gntdev_dmabuf_exp_from_pages(struct gntdev_dmabuf_export_args *args);
>> +
>> +int gntdev_dmabuf_exp_wait_released(struct gntdev_dmabuf_priv *priv, int fd,
>> +				    int wait_to_ms);
>> +
>> +struct gntdev_dmabuf *
>> +gntdev_dmabuf_imp_to_refs(struct gntdev_dmabuf_priv *priv, struct device *dev,
>> +			  int fd, int count, int domid);
>> +
>> +u32 *gntdev_dmabuf_imp_get_refs(struct gntdev_dmabuf *gntdev_dmabuf);
>> +
>> +int gntdev_dmabuf_imp_release(struct gntdev_dmabuf_priv *priv, u32 fd);
>> +
>> +#endif
>> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
>> index 9813fc440c70..7d58dfb3e5e8 100644
>> --- a/drivers/xen/gntdev.c
>> +++ b/drivers/xen/gntdev.c
> ...
>
>>   
>> +#ifdef CONFIG_XEN_GNTDEV_DMABUF
> This code belongs in gntdev-dmabuf.c.
The reason I have this code here is that it is heavily
tied to gntdev's internal functionality, e.g. map/unmap.
I do not want to extend gntdev's API, so gntdev-dmabuf can
access these. What is more dma-buf doesn't need to know about
maps done by gntdev as there is no use of that information
in gntdev-dmabuf. So, it seems more naturally to have
dma-buf's related map/unmap code where it is: in gntdev.
>
>> +/* ------------------------------------------------------------------ */
>> +/* DMA buffer export support.                                         */
>> +/* ------------------------------------------------------------------ */
>> +
>> +int gntdev_dmabuf_exp_from_refs(struct gntdev_priv *priv, int flags,
>> +				int count, u32 domid, u32 *refs, u32 *fd)
>> +{
>> +	/* XXX: this will need to work with gntdev's map, so leave it here. */
> This doesn't help understanding what's going on (at least to me) and is
> removed in the next patch. So no need for this comment.
Will remove the comment
> -boris
>
>> +	*fd = -1;
>> +	return -EINVAL;
>> +}
>
