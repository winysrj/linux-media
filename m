Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41214 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754067AbeEaTdM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 15:33:12 -0400
Subject: Re: [PATCH 0/8] xen: dma-buf support for grant device
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180525153331.31188-1-andr2000@gmail.com>
 <9687b6e5-808e-0c63-34c3-90e6fcbdfb2e@oracle.com>
 <bc6a2e2f-f650-86db-ac8c-1945a6183c06@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <42b9fd3b-11d7-bd56-4fe2-35d087caf123@oracle.com>
Date: Thu, 31 May 2018 15:36:39 -0400
MIME-Version: 1.0
In-Reply-To: <bc6a2e2f-f650-86db-ac8c-1945a6183c06@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/31/2018 01:51 AM, Oleksandr Andrushchenko wrote:
> On 05/31/2018 04:46 AM, Boris Ostrovsky wrote:
>>
>>
>> On 05/25/2018 11:33 AM, Oleksandr Andrushchenko wrote:
>>
>>>
>>> Oleksandr Andrushchenko (8):
>>>    xen/grant-table: Make set/clear page private code shared
>>>    xen/balloon: Move common memory reservation routines to a module
>>>    xen/grant-table: Allow allocating buffers suitable for DMA
>>>    xen/gntdev: Allow mappings for DMA buffers
>>>    xen/gntdev: Add initial support for dma-buf UAPI
>>>    xen/gntdev: Implement dma-buf export functionality
>>>    xen/gntdev: Implement dma-buf import functionality
>>>    xen/gntdev: Expose gntdev's dma-buf API for in-kernel use
>>>
>>>   drivers/xen/Kconfig           |   23 +
>>>   drivers/xen/Makefile          |    1 +
>>>   drivers/xen/balloon.c         |   71 +--
>>>   drivers/xen/gntdev.c          | 1025
>>> ++++++++++++++++++++++++++++++++-
>>
>>
>> I think this calls for gntdev_dma.c.
> I assume you mean as a separate file (part of gntdev driver)?


Yes, source only. The driver stays the same.


>> I only had a quick look over gntdev changes but they very much are
>> concentrated in dma-specific routines.
>>
> I tried to do that, but there are some dependencies between the
> gntdev.c and gntdev_dma.c,
> so finally I decided to put it all together.
>> You essentially only share file_operations entry points with original
>> gntdev code, right?
>>
> fops + mappings done by gntdev (struct grant_map) and I need to
> release map on dma_buf .release
> callback which makes some cross-dependencies between modules which
> seemed to be not cute
> (gntdev keeps its all structs and functions inside, so I cannot easily
> access those w/o
> helpers).
>
> But I'll try one more time and move all DMA specific stuff into
> gntdev_dma.c


Yes, please try it. Maybe even have gntdev_common.c, gntdev_mem.c (??) 
and gntdev_dma.c.

-boris


>> -boris
>>
> Thank you,
> Oleksandr
>>
>>>   drivers/xen/grant-table.c     |  176 +++++-
>>>   drivers/xen/mem-reservation.c |  134 +++++
>>>   include/uapi/xen/gntdev.h     |  106 ++++
>>>   include/xen/grant_dev.h       |   37 ++
>>>   include/xen/grant_table.h     |   28 +
>>>   include/xen/mem_reservation.h |   29 +
>>>   10 files changed, 1527 insertions(+), 103 deletions(-)
>>>   create mode 100644 drivers/xen/mem-reservation.c
>>>   create mode 100644 include/xen/grant_dev.h
>>>   create mode 100644 include/xen/mem_reservation.h
>>>
>
