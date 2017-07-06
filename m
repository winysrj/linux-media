Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:36796 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751751AbdGFOlP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 10:41:15 -0400
Received: by mail-yw0-f173.google.com with SMTP id a12so1910988ywh.3
        for <linux-media@vger.kernel.org>; Thu, 06 Jul 2017 07:41:15 -0700 (PDT)
Received: from mail-yb0-f169.google.com (mail-yb0-f169.google.com. [209.85.213.169])
        by smtp.gmail.com with ESMTPSA id q184sm151743ywf.36.2017.07.06.07.41.14
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jul 2017 07:41:14 -0700 (PDT)
Received: by mail-yb0-f169.google.com with SMTP id f194so1453338yba.3
        for <linux-media@vger.kernel.org>; Thu, 06 Jul 2017 07:41:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK8P3a0_S=ONcnfD0qrt61iu4N_2WQHbGTtED-WXHov-30gK=w@mail.gmail.com>
References: <20170705071215.17603-1-tfiga@chromium.org> <20170705071215.17603-2-tfiga@chromium.org>
 <20170705151728.GA2479@lst.de> <CAAFQd5DijKbNJ-8wHh=+2Z2y1nSF-LC8R+d+NktTRF4iQqPsrA@mail.gmail.com>
 <20170705172019.GB5246@lst.de> <CAAFQd5CkVYd6uyoFP_15N8ZaZp8jivJ-4S=CAvrTynRU2ShFYg@mail.gmail.com>
 <CAK8P3a2htZ7q=npfwJVW7Lr90O78Ey+OR5e0ivaR7GwV4YBs=A@mail.gmail.com>
 <CAAFQd5BMorNa8CD+cEap2=boD2-=jr+DFF9cXTNXzSSfe7FnLg@mail.gmail.com>
 <CAAFQd5BFLvWS5n8owm053GNC5VniMq-8Gh0BHo43B-TYShpsnA@mail.gmail.com>
 <CAK8P3a2JyQ-qLgh+ig4yWMJvB0AGjspMu8P8fNrPHgm3NMCGNw@mail.gmail.com>
 <CAAFQd5DS1NxKh4OJ52T2AJNTHg6K2fnuDm5-GHzmUk-kjowf2w@mail.gmail.com>
 <CAAFQd5Axz2yMnOo4rtP3jgEBJxUVOW0RLmFEGFejBHkYjq0s5A@mail.gmail.com>
 <CAK8P3a0xVjgD-w-uVDc54Mx0s6b1Bd3tRYt9rpetjNoMwDXvCA@mail.gmail.com>
 <CAAFQd5BgVRaEym9fXt3sMSafFPK1cXwTdMgSiB87w8QVeXzzVw@mail.gmail.com> <CAK8P3a0_S=ONcnfD0qrt61iu4N_2WQHbGTtED-WXHov-30gK=w@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 6 Jul 2017 23:35:50 +0900
Message-ID: <CAAFQd5DGNgT7=5Rg4F_iZEwQA+yn7kVA-ESxsiTxPinizcXXdA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] base: dma-mapping: Export commonly used symbols
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, Christoph Hellwig <hch@lst.de>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will.deacon@arm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Hans-Christian Noren Egtvedt <egtvedt@samfundet.no>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 6, 2017 at 11:27 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thu, Jul 6, 2017 at 4:06 PM, Tomasz Figa <tfiga@chromium.org> wrote:
>> On Thu, Jul 6, 2017 at 11:02 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Thu, Jul 6, 2017 at 3:49 PM, Tomasz Figa <tfiga@chromium.org> wrote:
>>>> On Thu, Jul 6, 2017 at 10:31 PM, Tomasz Figa <tfiga@chromium.org> wrote:
>>>
>>>>> On the other hand, if it's strictly about base/dma-mapping, we might
>>>>> not need it indeed. The driver could call iommu-dma helpers directly,
>>>>> without the need to provide its own DMA ops. One caveat, though, we
>>>>> are not able to obtain coherent (i.e. uncached) memory with this
>>>>> approach, which might have some performance effects and complicates
>>>>> the code, that would now need to flush caches even for some small
>>>>> internal buffers.
>>>>
>>>> I think I should add a bit of explanation here:
>>>>  1) the device is non-coherent with CPU caches, even on x86,
>>>>  2) it looks like x86 does not have non-coherent DMA ops, (but it
>>>> might be something that could be fixed)
>>>
>>> I don't understand what this means here. The PCI on x86 is always
>>> cache-coherent, so why is the device not?
>>>
>>> Do you mean that the device has its own caches that may need
>>> flushing to make the device cache coherent with the CPU cache,
>>> rather than flushing the CPU caches?
>>
>> Sakari might be able to explain this with more technical details, but
>> generally the device is not a standard PCI device one might find on
>> existing x86 systems.
>>
>> It is some kind of embedded subsystem that behaves mostly like a PCI
>> device, with certain exceptions, one being the lack of coherency with
>> CPU caches, at least for certain parts of the subsystem. The reference
>> vendor code disables the coherency completely, for reasons not known
>> to me, but AFAICT this is the preferred operating mode, possibly due
>> to performance effects (this is a memory-heavy image processing
>
> Ok, got it. I think something similar happens on integrated GPUs for
> a certain CPU family. The DRM code has its own ways of dealing with
> this kind of device. If you find that the hardware to be closely
> related (either the implementation, or the location on the internal
> buses) to the GPU on this machine, I'd recommend having a look
> in drivers/gpu/drm to see how it's handled there, and if that code could
> be shared.

I think it's not closely related, but might be a very similar case.

Still, DRM is very liberal in terms of not using common code for doing
things, while V4L2 tries to makes things generic as much as possible.
There is already the vb2_dma_contig backend, which allocates coherent
memory (in case of V4L2-allocated buffers), manages caches (in case of
userptr or DMA-buf buffers) and so on for you. If we can't have the
DMA ops do the right thing, the code there is essentially useless and
you are left with vb2_dma_sg that uses a page allocator and gives the
driver sg tables (it actually can also do cache management for you,
but since dma_sync_sg_*() is essentially a no-op on x86, the driver
would have to do it on its own).

Best regards,
Tomasz
