Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:38575 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753487AbeDZJjK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 05:39:10 -0400
Received: by mail-io0-f182.google.com with SMTP id z4-v6so6597805iof.5
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2018 02:39:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180426092422.GA26825@infradead.org>
References: <20180425054855.GA17038@infradead.org> <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
 <CAKMK7uFx=KB1vup=WhPCyfUFairKQcRR4BEd7aXaX1Pj-vj3Cw@mail.gmail.com>
 <20180425064335.GB28100@infradead.org> <20180425074151.GA2271@ulmo>
 <20180425085439.GA29996@infradead.org> <20180425100429.GR25142@phenom.ffwll.local>
 <20180425153312.GD27076@infradead.org> <20180425225443.GQ16141@n2100.armlinux.org.uk>
 <CAKMK7uG9R6paoP4BmvqDVUP_4Db4Dz8MSXeLwUBMYaORa5-kVw@mail.gmail.com> <20180426092422.GA26825@infradead.org>
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Thu, 26 Apr 2018 11:39:09 +0200
Message-ID: <CAKMK7uEK_KjjWUwsiFPW1KmUkjy2j8tA_R4zc5u1gJ6BHRfAVw@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] noveau vs arm dma ops
To: Christoph Hellwig <hch@infradead.org>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        iommu@lists.linux-foundation.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Thierry Reding <treding@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 26, 2018 at 11:24 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Apr 26, 2018 at 11:20:44AM +0200, Daniel Vetter wrote:
>> The above is already what we're implementing in i915, at least
>> conceptually (it all boils down to clflush instructions because those
>> both invalidate and flush).
>
> The clwb instruction that just writes back dirty cache lines might
> be very interesting for the x86 non-coherent dma case.  A lot of
> architectures use their equivalent to prepare to to device transfers.

Iirc didn't help for i915 use-cases much. Either data gets streamed
between cpu and gpu, and then keeping the clean cacheline around
doesn't buy you anything. In other cases we need to flush because the
gpu really wants to use non-snooped transactions (faster/lower
latency/less power required for display because you can shut down the
caches), and then there's also no benefit with keeping the cacheline
around (no one will ever need it again).

I think clwb is more for persistent memory and stuff like that, not so
much for gpus.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
