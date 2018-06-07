Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50698 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751739AbeFGWXY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 18:23:24 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v2 6/9] xen/gntdev: Add initial support for dma-buf UAPI
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180601114132.22596-1-andr2000@gmail.com>
 <20180601114132.22596-7-andr2000@gmail.com>
 <29c1f1fb-2d52-e3df-adce-44fdee135413@oracle.com>
 <d2bbda68-af74-58b1-36a6-d8af47ad8beb@gmail.com>
 <7c73fae9-2dac-f3e8-bad8-0dadb73ad7af@oracle.com>
 <4e15c758-a314-9fdc-1d70-4a465137a6f9@gmail.com>
Message-ID: <41d794ce-a318-b2f1-5ad7-e9500175bdc8@oracle.com>
Date: Thu, 7 Jun 2018 18:26:51 -0400
MIME-Version: 1.0
In-Reply-To: <4e15c758-a314-9fdc-1d70-4a465137a6f9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/07/2018 03:17 AM, Oleksandr Andrushchenko wrote:
> On 06/07/2018 12:32 AM, Boris Ostrovsky wrote:
>> On 06/06/2018 05:06 AM, Oleksandr Andrushchenko wrote:
>>> On 06/04/2018 11:49 PM, Boris Ostrovsky wrote:
>>>>> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
>>>>> index 9813fc440c70..7d58dfb3e5e8 100644
>>>>> --- a/drivers/xen/gntdev.c
>>>>> +++ b/drivers/xen/gntdev.c
>>>> ...
>>>>
>>>>>    +#ifdef CONFIG_XEN_GNTDEV_DMABUF
>>>> This code belongs in gntdev-dmabuf.c.
>>> The reason I have this code here is that it is heavily
>>> tied to gntdev's internal functionality, e.g. map/unmap.
>>> I do not want to extend gntdev's API, so gntdev-dmabuf can
>>> access these. What is more dma-buf doesn't need to know about
>>> maps done by gntdev as there is no use of that information
>>> in gntdev-dmabuf. So, it seems more naturally to have
>>> dma-buf's related map/unmap code where it is: in gntdev.
>> Sorry, I don't follow. Why would this require extending the API? It's
>> just moving routines to a different file that is linked to the same
>> module.
> I do understand your intention here and tried to avoid dma-buf
> related code in gntdev.c as much as possible. So, let me explain
> my decision in more detail.
>
> There are 2 use-cases we have: dma-buf import and export.
>
> While importing a dma-buf all the dma-buf related functionality can
> easily be kept inside gntdev-dmabuf.c w/o any issue as all we need
> from gntdev.c is dev, dma_buf_fd, count and domid for that.
>
> But in case of dma-buf export we need to:
> 1. struct grant_map *map = gntdev_alloc_map(priv, count, dmabuf_flags);
> 2. gntdev_add_map(priv, map);
> 3. Set map->flags
> 4. ret = map_grant_pages(map);
> 5. And only now we are all set to export the new dma-buf from
> *map->pages*
>
> So, until 5) we use private gtndev.c's API not exported to outside world:
> a. struct grant_map
> b. static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv,
> int count,
>                       int dma_flags)
> c. static void gntdev_add_map(struct gntdev_priv *priv, struct
> grant_map *add)
> d. static int map_grant_pages(struct grant_map *map)
>
> Thus, all the above cannot be accessed from gntdev-dmabuf.c
> This is why I say that gntdev.c's API will need to be extended to
> provide the above
> a-d if we want all dma-buf export code to leave in gntdev-dmabuf.c.



I still don't understand why you feel this would be extending the API.
These routines and the struct can be declared in local header file and
this header file will not be visible to anyone but gntdev.c and
gntdev-dmabuf.c. You can, for example, put this into gntdev-dmabuf.h
(and then rename it to something else, like gntdev-common.h).



> But that doesn't seem good to me and what is more a-d are really
> gntdev.c's
> functionality, not dma-buf's which only needs pages and doesn't really
> care from
> where those come.
> That was the reason I partitioned export into 2 chunks: gntdev +
> gntdev-dmabuf.
>
> You might also ask why importing side does Xen related things
> (granting references+)
> in gntdev-dmabuf, not gntdev so it is consistent with the dma-buf
> exporter?
> This is because importer uses grant-table's API which seems to be not
> natural for gntdev.c,
> so it can leave in gntdev-dmabuf.c which has a use-case for that,
> while gntdev
> remains the same.


Yet another reason why this code should be moved: importing and
exporting functionalities logically belong together. The fat that they
are implemented using different methods is not relevant IMO.

If you have code which is under ifdef CONFIG_GNTDEV_DMABUF and you have
file called gntdev-dmabuf.c it sort of implies that this code should
live in that file (unless that code is intertwined with other code,
which is not the case here).


-boris



>> Since this is under CONFIG_XEN_GNTDEV_DMABUF then why shouldn't it be in
>> gntdev-dmabuf.c? In my view that's the file where all dma-related
>> "stuff" lives.
> Agree, but IMO grant_map stuff for dma-buf importer is right in its
> place in gntdev.c
> and all the rest of dma-buf specifics live in gntdev-dmabuf.c as they
> should
>>
>> -boris
>>
>>
>> -boris
>>
> Thank you,
> Oleksandr
