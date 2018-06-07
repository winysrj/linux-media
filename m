Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:43486 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbeFGHdp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 03:33:45 -0400
Subject: Re: [Xen-devel] [PATCH v2 9/9] xen/gntdev: Expose gntdev's dma-buf
 API for in-kernel use
To: Dongwon Kim <dongwon.kim@intel.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: matthew.d.roper@intel.com, jgross@suse.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        daniel.vetter@intel.com, xen-devel@lists.xenproject.org,
        linux-media@vger.kernel.org
References: <20180601114132.22596-1-andr2000@gmail.com>
 <20180601114132.22596-10-andr2000@gmail.com>
 <86f5b340-856c-204f-4ba7-dd51f1e92639@oracle.com>
 <984bcf75-9bea-aceb-3d3a-62e3c65709c7@gmail.com>
 <398d53c9-9c47-d86a-89bd-b9941e638434@oracle.com>
 <20180606220521.GA7054@downor-Z87X-UD5H>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <87d02b3a-3dd0-d3c5-3b2b-29fa1a27ba75@gmail.com>
Date: Thu, 7 Jun 2018 10:33:41 +0300
MIME-Version: 1.0
In-Reply-To: <20180606220521.GA7054@downor-Z87X-UD5H>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/07/2018 01:05 AM, Dongwon Kim wrote:
> On Wed, Jun 06, 2018 at 05:51:38PM -0400, Boris Ostrovsky wrote:
>> On 06/06/2018 08:46 AM, Oleksandr Andrushchenko wrote:
>>> On 06/05/2018 01:36 AM, Boris Ostrovsky wrote:
>>>> On 06/01/2018 07:41 AM, Oleksandr Andrushchenko wrote:
>>>>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>>>
>>>>> Allow creating grant device context for use by kernel modules which
>>>>> require functionality, provided by gntdev. Export symbols for dma-buf
>>>>> API provided by the module.
>>>> Can you give an example of who'd be using these interfaces?
>>> There is no use-case at the moment I can think of, but hyper dma-buf
>>> [1], [2]
>>> I let Intel folks (CCed) to defend this patch as it was done primarily
>>> for them
>>> and I don't use it in any of my use-cases. So, from this POV it can be
>>> dropped,
>>> at least from this series.
>>
>> Yes, let's drop this until someone actually needs it.
>>
>> -boris
> I agree. We are working on re-architecturing hyper_dmabuf. We would use zcopy
> apis however, not sure if we are going to do it from kernel or from userspace.
> So please do not expose those for now.
Ok, as we are all on the same page for that then I'll drop this patch 
for now
>>
>>>> -boris
>>>>
>>> [1] https://patchwork.freedesktop.org/series/38207/
>>> [2] https://patchwork.freedesktop.org/patch/204447/
>>>
>>> _______________________________________________
>>> Xen-devel mailing list
>>> Xen-devel@lists.xenproject.org
>>> https://lists.xenproject.org/mailman/listinfo/xen-devel
