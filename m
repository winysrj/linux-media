Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:44024 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754414AbeDTI6x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 04:58:53 -0400
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH 4/8] dma-buf: add peer2peer flag
To: Christoph Hellwig <hch@infradead.org>,
        Jerome Glisse <jglisse@redhat.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Dan Williams <dan.j.williams@intel.com>
References: <20180325110000.2238-1-christian.koenig@amd.com>
 <20180325110000.2238-4-christian.koenig@amd.com>
 <20180329065753.GD3881@phenom.ffwll.local>
 <8b823458-8bdc-3217-572b-509a28aae742@gmail.com>
 <20180403090909.GN3881@phenom.ffwll.local> <20180403170645.GB5935@redhat.com>
 <20180403180832.GZ3881@phenom.ffwll.local>
 <20180416123937.GA9073@infradead.org>
 <CAKMK7uEFVOh-R2_4vs1M22_wDau0oNTgmCcTWDE+ScxL=92+2g@mail.gmail.com>
 <20180419081657.GA16735@infradead.org>
 <20180420071312.GF31310@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <3e17afc5-7d6c-5795-07bd-f23e34cf8d4b@gmail.com>
Date: Fri, 20 Apr 2018 10:58:50 +0200
MIME-Version: 1.0
In-Reply-To: <20180420071312.GF31310@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 20.04.2018 um 09:13 schrieb Daniel Vetter:
> On Thu, Apr 19, 2018 at 01:16:57AM -0700, Christoph Hellwig wrote:
>> On Mon, Apr 16, 2018 at 03:38:56PM +0200, Daniel Vetter wrote:
>>> We've broken that assumption in i915 years ago. Not struct page backed
>>> gpu memory is very real.
>>>
>>> Of course we'll never feed such a strange sg table to a driver which
>>> doesn't understand it, but allowing sg_page == NULL works perfectly
>>> fine. At least for gpu drivers.
>> For GPU drivers on x86 with no dma coherency problems, sure.  But not
>> all the world is x86.  We already have problems due to dmabugs use
>> of the awkward get_sgtable interface (see the common on
>> arm_dma_get_sgtable that I fully agree with), and doing this for memory
>> that doesn't have a struct page at all will make things even worse.
> x86 dma isn't coherent either, if you're a GPU :-) Flushing gpu caches
> tends to be too expensive, so there's pci-e support and chipset support to
> forgo it. Plus drivers flushing caches themselves.
>
> The dma_get_sgtable thing is indeed fun, right solution would probably be
> to push the dma-buf export down into the dma layer. The comment for
> arm_dma_get_sgtable is also not a realy concern, because dma-buf also
> abstracts away the flushing (or well is supposed to), so there really
> shouldn't be anyone calling the streaming apis on the returned sg table.
> That's why dma-buf gives you an sg table that's mapped already.
>
>>> If that's not acceptable then I guess we could go over the entire tree
>>> and frob all the gpu related code to switch over to a new struct
>>> sg_table_might_not_be_struct_page_backed, including all the other
>>> functions we added over the past few years to iterate over sg tables.
>>> But seems slightly silly, given that sg tables seem to do exactly what
>>> we need.
>> It isn't silly.  We will have to do some surgery like that anyway
>> because the current APIs don't work.  So relax, sit back and come up
>> with an API that solves the existing issues and serves us well in
>> the future.
> So we should just implement a copy of sg table for dma-buf, since I still
> think it does exactly what we need for gpus?
>
> Yes there's a bit a layering violation insofar that drivers really
> shouldn't each have their own copy of "how do I convert a piece of dma
> memory into  dma-buf", but that doesn't render the interface a bad idea.

Completely agree on that.

What we need is an sg_alloc_table_from_resources(dev, resources, 
num_resources) which does the handling common to all drivers.

Christian.

> -Daniel
