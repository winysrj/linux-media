Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:37841 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751497AbeDYSiE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 14:38:04 -0400
Received: by mail-oi0-f42.google.com with SMTP id f63-v6so21800160oic.4
        for <linux-media@vger.kernel.org>; Wed, 25 Apr 2018 11:38:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADnq5_O5t8aSJE6SFzyjw-6Pmba7B2aYMztVMOOQCF3drBHR5Q@mail.gmail.com>
References: <3e17afc5-7d6c-5795-07bd-f23e34cf8d4b@gmail.com>
 <20180420101755.GA11400@infradead.org> <f1100bd6-dd98-55a9-a92f-1cad919f235f@amd.com>
 <20180420124625.GA31078@infradead.org> <20180420152111.GR31310@phenom.ffwll.local>
 <20180424184847.GA3247@infradead.org> <CAKMK7uFL68pu+-9LODTgz+GQYvxpnXOGhxfz9zorJ_JKsPVw2g@mail.gmail.com>
 <20180425054855.GA17038@infradead.org> <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
 <CADnq5_P3bT0TStSXpKh11ydifv=KwKtRj-7tDS=GQXey+8tBPw@mail.gmail.com>
 <20180425064118.GA28100@infradead.org> <CADnq5_O5t8aSJE6SFzyjw-6Pmba7B2aYMztVMOOQCF3drBHR5Q@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 25 Apr 2018 11:38:03 -0700
Message-ID: <CAPcyv4gvz8hWLiz3wSitoh3546WV7d=LRYzu5nd9MpKKH7C=mg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 4/8] dma-buf: add peer2peer flag
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 10:44 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Wed, Apr 25, 2018 at 2:41 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Wed, Apr 25, 2018 at 02:24:36AM -0400, Alex Deucher wrote:
>>> > It has a non-coherent transaction mode (which the chipset can opt to
>>> > not implement and still flush), to make sure the AGP horror show
>>> > doesn't happen again and GPU folks are happy with PCIe. That's at
>>> > least my understanding from digging around in amd the last time we had
>>> > coherency issues between intel and amd gpus. GPUs have some bits
>>> > somewhere (in the pagetables, or in the buffer object description
>>> > table created by userspace) to control that stuff.
>>>
>>> Right.  We have a bit in the GPU page table entries that determines
>>> whether we snoop the CPU's cache or not.
>>
>> I can see how that works with the GPU on the same SOC or SOC set as the
>> CPU.  But how is that going to work for a GPU that is a plain old PCIe
>> card?  The cache snooping in that case is happening in the PCIe root
>> complex.
>
> I'm not a pci expert, but as far as I know, the device sends either a
> snooped or non-snooped transaction on the bus.  I think the
> transaction descriptor supports a no snoop attribute.  Our GPUs have
> supported this feature for probably 20 years if not more, going back
> to PCI.  Using non-snooped transactions have lower latency and faster
> throughput compared to snooped transactions.

Right, 'no snoop' and 'relaxed ordering' have been part of the PCI
spec since forever. With a plain old PCI-E card the root complex
indeed arranges for caches to be snooped. Although it's not always
faster depending on the platform. 'No snoop' traffic may be relegated
to less bus resources relative to the much more common snooped
traffic.
