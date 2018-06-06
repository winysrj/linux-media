Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56298 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752205AbeFFV21 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 17:28:27 -0400
Subject: Re: [PATCH v2 6/9] xen/gntdev: Add initial support for dma-buf UAPI
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
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <7c73fae9-2dac-f3e8-bad8-0dadb73ad7af@oracle.com>
Date: Wed, 6 Jun 2018 17:32:02 -0400
MIME-Version: 1.0
In-Reply-To: <d2bbda68-af74-58b1-36a6-d8af47ad8beb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/06/2018 05:06 AM, Oleksandr Andrushchenko wrote:
> On 06/04/2018 11:49 PM, Boris Ostrovsky wrote:
>> On 06/01/2018 07:41 AM, Oleksandr Andrushchenko wrote:

>> +struct gntdev_dmabuf_export_args {
>> +    int dummy;
>> +};
>>
>> Please define the full structure (at least what you have in the next
>> patch) here.
> Ok, will define what I have in the next patch, but won't
> initialize anything until the next patch. Will this work for you?

Sure, I just didn't see the need for the dummy argument that you remove
later.

>>
>>> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
>>> index 9813fc440c70..7d58dfb3e5e8 100644
>>> --- a/drivers/xen/gntdev.c
>>> +++ b/drivers/xen/gntdev.c
>> ...
>>
>>>   +#ifdef CONFIG_XEN_GNTDEV_DMABUF
>> This code belongs in gntdev-dmabuf.c.
> The reason I have this code here is that it is heavily
> tied to gntdev's internal functionality, e.g. map/unmap.
> I do not want to extend gntdev's API, so gntdev-dmabuf can
> access these. What is more dma-buf doesn't need to know about
> maps done by gntdev as there is no use of that information
> in gntdev-dmabuf. So, it seems more naturally to have
> dma-buf's related map/unmap code where it is: in gntdev.

Sorry, I don't follow. Why would this require extending the API? It's
just moving routines to a different file that is linked to the same module.

Since this is under CONFIG_XEN_GNTDEV_DMABUF then why shouldn't it be in
gntdev-dmabuf.c? In my view that's the file where all dma-related
"stuff" lives.


-boris


-boris
