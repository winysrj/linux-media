Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:46560 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751128AbeDYHCS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 03:02:18 -0400
Received: by mail-io0-f193.google.com with SMTP id f3-v6so25640013iob.13
        for <linux-media@vger.kernel.org>; Wed, 25 Apr 2018 00:02:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180425064335.GB28100@infradead.org>
References: <3e17afc5-7d6c-5795-07bd-f23e34cf8d4b@gmail.com>
 <20180420101755.GA11400@infradead.org> <f1100bd6-dd98-55a9-a92f-1cad919f235f@amd.com>
 <20180420124625.GA31078@infradead.org> <20180420152111.GR31310@phenom.ffwll.local>
 <20180424184847.GA3247@infradead.org> <CAKMK7uFL68pu+-9LODTgz+GQYvxpnXOGhxfz9zorJ_JKsPVw2g@mail.gmail.com>
 <20180425054855.GA17038@infradead.org> <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
 <CAKMK7uFx=KB1vup=WhPCyfUFairKQcRR4BEd7aXaX1Pj-vj3Cw@mail.gmail.com> <20180425064335.GB28100@infradead.org>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Wed, 25 Apr 2018 09:02:17 +0200
Message-ID: <CAKMK7uGF7p5ko=i6zL4dn0qR-5TVRKMi6xaCGSao_vyfJU+dWQ@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 4/8] dma-buf: add peer2peer flag
To: Christoph Hellwig <hch@infradead.org>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Jerome Glisse <jglisse@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>, Thierry Reding <treding@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 8:43 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Apr 25, 2018 at 08:23:15AM +0200, Daniel Vetter wrote:
>> For more fun:
>>
>> https://www.spinics.net/lists/dri-devel/msg173630.html
>>
>> Yeah, sometimes we want to disable the iommu because the on-gpu
>> pagetables are faster ...
>
> I am not on this list, but remote NAK from here.  This needs an
> API from the iommu/dma-mapping code.  Drivers have no business poking
> into these details.

Can we please not nack everything right away? Doesn't really motivate
me to show you all the various things we're doing in gpu to make the
dma layer work for us. That kind of noodling around in lower levels to
get them to do what we want is absolutely par-for-course for gpu
drivers. If you just nack everything I point you at for illustrative
purposes, then I can't show you stuff anymore.

Just to make it clear: I do want to get this stuff sorted, and it's
awesome that someone from core finally takes a serious look at what
gpu folks have been doing for decades (instead of just telling us
we're incompetent and doing it all wrong and then steaming off), and
how to make this work without layering violations to no end. But
stopping the world until this is fixed isn't really a good option.

Thanks, Daniel

> Thierry, please resend this with at least the iommu list and
> linux-arm-kernel in Cc to have a proper discussion on the right API.



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
