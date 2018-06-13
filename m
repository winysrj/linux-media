Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr50045.outbound.protection.outlook.com ([40.107.5.45]:58159
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754487AbeFMHX0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 03:23:26 -0400
Subject: Re: [PATCH v3 6/9] xen/gntdev: Make private routines/structures
 accessible
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com
References: <20180612134200.17456-1-andr2000@gmail.com>
 <20180612134200.17456-7-andr2000@gmail.com>
 <fc339230-f1e1-303b-1b82-0bd23d7b69b3@oracle.com>
From: Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>
Message-ID: <ac1f47e6-9d90-ae6b-5596-00a8b3607d96@epam.com>
Date: Wed, 13 Jun 2018 10:23:18 +0300
MIME-Version: 1.0
In-Reply-To: <fc339230-f1e1-303b-1b82-0bd23d7b69b3@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2018 04:38 AM, Boris Ostrovsky wrote:
>
>
> On 06/12/2018 09:41 AM, Oleksandr Andrushchenko wrote:
>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>
>> This is in preparation for adding support of DMA buffer
>> functionality: make map/unmap related code and structures, used
>> privately by gntdev, ready for dma-buf extension, which will re-use
>> these. Rename corresponding structures as those become non-private
>> to gntdev now.
>>
>> Signed-off-by: Oleksandr Andrushchenko 
>> <oleksandr_andrushchenko@epam.com>
>> ---
>>   drivers/xen/gntdev-common.h |  86 +++++++++++++++++++++++
>>   drivers/xen/gntdev.c        | 132 ++++++++++++------------------------
>>   2 files changed, 128 insertions(+), 90 deletions(-)
>>   create mode 100644 drivers/xen/gntdev-common.h
>>
>> diff --git a/drivers/xen/gntdev-common.h b/drivers/xen/gntdev-common.h
>> new file mode 100644
>> index 000000000000..7a9845a6bee9
>> --- /dev/null
>> +++ b/drivers/xen/gntdev-common.h
>> @@ -0,0 +1,86 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +/*
>> + * Common functionality of grant device.
>> + *
>> + * Copyright (c) 2006-2007, D G Murray.
>> + *           (c) 2009 Gerd Hoffmann <kraxel@redhat.com>
>> + *           (c) 2018 Oleksandr Andrushchenko, EPAM Systems Inc.
>> + */
>> +
>> +#ifndef _GNTDEV_COMMON_H
>> +#define _GNTDEV_COMMON_H
>> +
>> +#include <linux/mm.h>
>> +#include <linux/mman.h>
>> +#include <linux/mmu_notifier.h>
>> +#include <linux/types.h>
>> +
>> +struct gntdev_priv {
>> +    /* maps with visible offsets in the file descriptor */
>> +    struct list_head maps;
>> +    /* maps that are not visible; will be freed on munmap.
>> +     * Only populated if populate_freeable_maps == 1 */
>
>
> Since you are touching this code please fix comment style.
>
I saw that while running checkpatch, but was not sure if I have to touch
those as they seemed to be not related to the change itself.
But I'll make sure all the comments are consistent.
>
>> +    struct list_head freeable_maps;
>> +    /* lock protects maps and freeable_maps */
>> +    struct mutex lock;
>> +    struct mm_struct *mm;
>> +    struct mmu_notifier mn;
>> +
>> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>> +    /* Device for which DMA memory is allocated. */
>> +    struct device *dma_dev;
>> +#endif
>> +};
>
>
> With that fixed,
>
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>
Thank you,
Oleksandr
