Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:37393 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935905AbeE3Gw7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 02:52:59 -0400
Subject: Re: [PATCH 5/8] xen/gntdev: Add initial support for dma-buf UAPI
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180525153331.31188-1-andr2000@gmail.com>
 <20180525153331.31188-6-andr2000@gmail.com>
 <232459a8-695f-56bf-e39b-693a2d2b27e3@oracle.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <25a0adae-6488-1d24-0c0a-514b24dcb1df@gmail.com>
Date: Wed, 30 May 2018 09:52:55 +0300
MIME-Version: 1.0
In-Reply-To: <232459a8-695f-56bf-e39b-693a2d2b27e3@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/30/2018 01:34 AM, Boris Ostrovsky wrote:
> On 05/25/2018 11:33 AM, Oleksandr Andrushchenko wrote:
>
>>   
>> +/*
>> + * Create a dma-buf [1] from grant references @refs of count @count provided
>> + * by the foreign domain @domid with flags @flags.
>> + *
>> + * By default dma-buf is backed by system memory pages, but by providing
>> + * one of the GNTDEV_DMA_FLAG_XXX flags it can also be created as
>> + * a DMA write-combine or coherent buffer, e.g. allocated with dma_alloc_wc/
>> + * dma_alloc_coherent.
>> + *
>> + * Returns 0 if dma-buf was successfully created and the corresponding
>> + * dma-buf's file descriptor is returned in @fd.
>> + *
>> + * [1] https://elixir.bootlin.com/linux/latest/source/Documentation/driver-api/dma-buf.rst
>
> Documentation/driver-api/dma-buf.rst.
>
Indeed ;)
> -boris
Thank you,
Oleksandr
