Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:39125 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751030AbeFGHRv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 03:17:51 -0400
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
 <d2bbda68-af74-58b1-36a6-d8af47ad8beb@gmail.com>
 <7c73fae9-2dac-f3e8-bad8-0dadb73ad7af@oracle.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <4e15c758-a314-9fdc-1d70-4a465137a6f9@gmail.com>
Date: Thu, 7 Jun 2018 10:17:47 +0300
MIME-Version: 1.0
In-Reply-To: <7c73fae9-2dac-f3e8-bad8-0dadb73ad7af@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/07/2018 12:32 AM, Boris Ostrovsky wrote:
> On 06/06/2018 05:06 AM, Oleksandr Andrushchenko wrote:
>> On 06/04/2018 11:49 PM, Boris Ostrovsky wrote:
>>> On 06/01/2018 07:41 AM, Oleksandr Andrushchenko wrote:
>>> +struct gntdev_dmabuf_export_args {
>>> +    int dummy;
>>> +};
>>>
>>> Please define the full structure (at least what you have in the next
>>> patch) here.
>> Ok, will define what I have in the next patch, but won't
>> initialize anything until the next patch. Will this work for you?
> Sure, I just didn't see the need for the dummy argument that you remove
> later.
Ok
>>>> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
>>>> index 9813fc440c70..7d58dfb3e5e8 100644
>>>> --- a/drivers/xen/gntdev.c
>>>> +++ b/drivers/xen/gntdev.c
>>> ...
>>>
>>>>    +#ifdef CONFIG_XEN_GNTDEV_DMABUF
>>> This code belongs in gntdev-dmabuf.c.
>> The reason I have this code here is that it is heavily
>> tied to gntdev's internal functionality, e.g. map/unmap.
>> I do not want to extend gntdev's API, so gntdev-dmabuf can
>> access these. What is more dma-buf doesn't need to know about
>> maps done by gntdev as there is no use of that information
>> in gntdev-dmabuf. So, it seems more naturally to have
>> dma-buf's related map/unmap code where it is: in gntdev.
> Sorry, I don't follow. Why would this require extending the API? It's
> just moving routines to a different file that is linked to the same module.
I do understand your intention here and tried to avoid dma-buf
related code in gntdev.c as much as possible. So, let me explain
my decision in more detail.

There are 2 use-cases we have: dma-buf import and export.

While importing a dma-buf all the dma-buf related functionality can
easily be kept inside gntdev-dmabuf.c w/o any issue as all we need
from gntdev.c is dev, dma_buf_fd, count and domid for that.

But in case of dma-buf export we need to:
1. struct grant_map *map = gntdev_alloc_map(priv, count, dmabuf_flags);
2. gntdev_add_map(priv, map);
3. Set map->flags
4. ret = map_grant_pages(map);
5. And only now we are all set to export the new dma-buf from *map->pages*

So, until 5) we use private gtndev.c's API not exported to outside world:
a. struct grant_map
b. static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, 
int count,
                       int dma_flags)
c. static void gntdev_add_map(struct gntdev_priv *priv, struct grant_map 
*add)
d. static int map_grant_pages(struct grant_map *map)

Thus, all the above cannot be accessed from gntdev-dmabuf.c
This is why I say that gntdev.c's API will need to be extended to 
provide the above
a-d if we want all dma-buf export code to leave in gntdev-dmabuf.c.
But that doesn't seem good to me and what is more a-d are really gntdev.c's
functionality, not dma-buf's which only needs pages and doesn't really 
care from
where those come.
That was the reason I partitioned export into 2 chunks: gntdev + 
gntdev-dmabuf.

You might also ask why importing side does Xen related things (granting 
references+)
in gntdev-dmabuf, not gntdev so it is consistent with the dma-buf exporter?
This is because importer uses grant-table's API which seems to be not 
natural for gntdev.c,
so it can leave in gntdev-dmabuf.c which has a use-case for that, while 
gntdev
remains the same.
> Since this is under CONFIG_XEN_GNTDEV_DMABUF then why shouldn't it be in
> gntdev-dmabuf.c? In my view that's the file where all dma-related
> "stuff" lives.
Agree, but IMO grant_map stuff for dma-buf importer is right in its 
place in gntdev.c
and all the rest of dma-buf specifics live in gntdev-dmabuf.c as they should
>
> -boris
>
>
> -boris
>
Thank you,
Oleksandr
