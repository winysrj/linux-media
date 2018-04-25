Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:34840 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbeDYGXQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 02:23:16 -0400
Received: by mail-it0-f47.google.com with SMTP id 186-v6so18074942itu.0
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2018 23:23:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
References: <CAKMK7uEFVOh-R2_4vs1M22_wDau0oNTgmCcTWDE+ScxL=92+2g@mail.gmail.com>
 <20180419081657.GA16735@infradead.org> <20180420071312.GF31310@phenom.ffwll.local>
 <3e17afc5-7d6c-5795-07bd-f23e34cf8d4b@gmail.com> <20180420101755.GA11400@infradead.org>
 <f1100bd6-dd98-55a9-a92f-1cad919f235f@amd.com> <20180420124625.GA31078@infradead.org>
 <20180420152111.GR31310@phenom.ffwll.local> <20180424184847.GA3247@infradead.org>
 <CAKMK7uFL68pu+-9LODTgz+GQYvxpnXOGhxfz9zorJ_JKsPVw2g@mail.gmail.com>
 <20180425054855.GA17038@infradead.org> <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Wed, 25 Apr 2018 08:23:15 +0200
Message-ID: <CAKMK7uFx=KB1vup=WhPCyfUFairKQcRR4BEd7aXaX1Pj-vj3Cw@mail.gmail.com>
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
        <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 8:13 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, Apr 25, 2018 at 7:48 AM, Christoph Hellwig <hch@infradead.org> wr=
ote:
>> On Tue, Apr 24, 2018 at 09:32:20PM +0200, Daniel Vetter wrote:
>>> Out of curiosity, how much virtual flushing stuff is there still out
>>> there? At least in drm we've pretty much ignore this, and seem to be
>>> getting away without a huge uproar (at least from driver developers
>>> and users, core folks are less amused about that).
>>
>> As I've just been wading through the code, the following architectures
>> have non-coherent dma that flushes by virtual address for at least some
>> platforms:
>>
>>  - arm [1], arm64, hexagon, nds32, nios2, parisc, sh, xtensa, mips,
>>    powerpc
>>
>> These have non-coherent dma ops that flush by physical address:
>>
>>  - arc, arm [1], c6x, m68k, microblaze, openrisc, sparc
>>
>> And these do not have non-coherent dma ops at all:
>>
>>  - alpha, h8300, riscv, unicore32, x86
>>
>> [1] arm =D1=95eems to do both virtually and physically based ops, furthe=
r
>> audit needed.
>>
>> Note that using virtual addresses in the cache flushing interface
>> doesn't mean that the cache actually is virtually indexed, but it at
>> least allows for the possibility.
>>
>>> > I think the most important thing about such a buffer object is that
>>> > it can distinguish the underlying mapping types.  While
>>> > dma_alloc_coherent, dma_alloc_attrs with DMA_ATTR_NON_CONSISTENT,
>>> > dma_map_page/dma_map_single/dma_map_sg and dma_map_resource all give
>>> > back a dma_addr_t they are in now way interchangable.  And trying to
>>> > stuff them all into a structure like struct scatterlist that has
>>> > no indication what kind of mapping you are dealing with is just
>>> > asking for trouble.
>>>
>>> Well the idea was to have 1 interface to allow all drivers to share
>>> buffers with anything else, no matter how exactly they're allocated.
>>
>> Isn't that interface supposed to be dmabuf?  Currently dma_map leaks
>> a scatterlist through the sg_table in dma_buf_map_attachment /
>> ->map_dma_buf, but looking at a few of the callers it seems like they
>> really do not even want a scatterlist to start with, but check that
>> is contains a physically contiguous range first.  So kicking the
>> scatterlist our there will probably improve the interface in general.
>
> I think by number most drm drivers require contiguous memory (or an
> iommu that makes it look contiguous). But there's plenty others who
> have another set of pagetables on the gpu itself and can
> scatter-gather. Usually it's the former for display/video blocks, and
> the latter for rendering.

For more fun:

https://www.spinics.net/lists/dri-devel/msg173630.html

Yeah, sometimes we want to disable the iommu because the on-gpu
pagetables are faster ...
-Daniel

>>> dma-buf has all the functions for flushing, so you can have coherent
>>> mappings, non-coherent mappings and pretty much anything else. Or well
>>> could, because in practice people hack up layering violations until it
>>> works for the 2-3 drivers they care about. On top of that there's the
>>> small issue that x86 insists that dma is coherent (and that's true for
>>> most devices, including v4l drivers you might want to share stuff
>>> with), and gpus really, really really do want to make almost
>>> everything incoherent.
>>
>> How do discrete GPUs manage to be incoherent when attached over PCIe?
>
> It has a non-coherent transaction mode (which the chipset can opt to
> not implement and still flush), to make sure the AGP horror show
> doesn't happen again and GPU folks are happy with PCIe. That's at
> least my understanding from digging around in amd the last time we had
> coherency issues between intel and amd gpus. GPUs have some bits
> somewhere (in the pagetables, or in the buffer object description
> table created by userspace) to control that stuff.
>
> For anything on the SoC it's presented as pci device, but that's
> extremely fake, and we can definitely do non-snooped transactions on
> drm/i915. Again, controlled by a mix of pagetables and
> userspace-provided buffer object description tables.
> -Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch



--=20
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
