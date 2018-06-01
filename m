Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:44709 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbeFAFm1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 01:42:27 -0400
Subject: Re: [PATCH 0/8] xen: dma-buf support for grant device
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Oleksandr_Andrushchenko@epam.com" <Oleksandr_Andrushchenko@epam.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com
References: <20180525153331.31188-1-andr2000@gmail.com>
 <9687b6e5-808e-0c63-34c3-90e6fcbdfb2e@oracle.com>
 <bc6a2e2f-f650-86db-ac8c-1945a6183c06@gmail.com>
 <d0f55179-8edd-d0b9-d335-735c5012659c@gmail.com>
 <00c0eabc-3a5e-5335-5a7e-2cebce5387c9@oracle.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <fa050c85-f236-2f70-414b-80c095d825cb@gmail.com>
Date: Fri, 1 Jun 2018 08:42:23 +0300
MIME-Version: 1.0
In-Reply-To: <00c0eabc-3a5e-5335-5a7e-2cebce5387c9@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/31/2018 11:25 PM, Boris Ostrovsky wrote:
> On 05/31/2018 10:41 AM, Oleksandr Andrushchenko wrote:
>> On 05/31/2018 08:51 AM, Oleksandr Andrushchenko wrote:
>>> On 05/31/2018 04:46 AM, Boris Ostrovsky wrote:
>>>>
>>>> On 05/25/2018 11:33 AM, Oleksandr Andrushchenko wrote:
>>>>
>>>>> Oleksandr Andrushchenko (8):
>>>>>     xen/grant-table: Make set/clear page private code shared
>>>>>     xen/balloon: Move common memory reservation routines to a module
>>>>>     xen/grant-table: Allow allocating buffers suitable for DMA
>>>>>     xen/gntdev: Allow mappings for DMA buffers
>>>>>     xen/gntdev: Add initial support for dma-buf UAPI
>>>>>     xen/gntdev: Implement dma-buf export functionality
>>>>>     xen/gntdev: Implement dma-buf import functionality
>>>>>     xen/gntdev: Expose gntdev's dma-buf API for in-kernel use
>>>>>
>>>>>    drivers/xen/Kconfig           |   23 +
>>>>>    drivers/xen/Makefile          |    1 +
>>>>>    drivers/xen/balloon.c         |   71 +--
>>>>>    drivers/xen/gntdev.c          | 1025
>>>>> ++++++++++++++++++++++++++++++++-
>>>>
>>>> I think this calls for gntdev_dma.c.
>>> I assume you mean as a separate file (part of gntdev driver)?
>>>> I only had a quick look over gntdev changes but they very much are
>>>> concentrated in dma-specific routines.
>>>>
>>> I tried to do that, but there are some dependencies between the
>>> gntdev.c and gntdev_dma.c,
>>> so finally I decided to put it all together.
>>>> You essentially only share file_operations entry points with
>>>> original gntdev code, right?
>>>>
>>> fops + mappings done by gntdev (struct grant_map) and I need to
>>> release map on dma_buf .release
>>> callback which makes some cross-dependencies between modules which
>>> seemed to be not cute
>>> (gntdev keeps its all structs and functions inside, so I cannot
>>> easily access those w/o
>>> helpers).
>>>
>>> But I'll try one more time and move all DMA specific stuff into
>>> gntdev_dma.c
>> Could you please take a quick look at the way I re-structured the
>> sources here [1]?
>> If this is what you meant.
>
> I looked at final gntdev.c code and I think at least one of the chunks
> there ("DMA buffer export support. ") can also be moved out. It still
> have a bit too many ifdefs but it looks better to my eye than jamming
> everything into a single file (and I think more code can be moved out,
> but we can talk about it when you post the patches so that we can see
> context).
Sure, will send v2 after I re-check all the patches
and run some smoke tests again
>
> BTW, I believe it won't build with !CONFIG_XEN_GNTDEV_DMABUF ---
> gntdev_remove_map() is defined under this option and is referenced later
> without it.
Will check, thank you
>
> -boris
>
>
>> Thank you,
>> Oleksandr
>>>> -boris
>>>>
>>> Thank you,
>>> Oleksandr
>>>>>    drivers/xen/grant-table.c     |  176 +++++-
>>>>>    drivers/xen/mem-reservation.c |  134 +++++
>>>>>    include/uapi/xen/gntdev.h     |  106 ++++
>>>>>    include/xen/grant_dev.h       |   37 ++
>>>>>    include/xen/grant_table.h     |   28 +
>>>>>    include/xen/mem_reservation.h |   29 +
>>>>>    10 files changed, 1527 insertions(+), 103 deletions(-)
>>>>>    create mode 100644 drivers/xen/mem-reservation.c
>>>>>    create mode 100644 include/xen/grant_dev.h
>>>>>    create mode 100644 include/xen/mem_reservation.h
>>>>>
>> [1]
>> https://github.com/andr2000/linux/commits/xen_tip_linux_next_xen_dma_buf_v2
