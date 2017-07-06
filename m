Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35179 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751745AbdGFOCH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 10:02:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAAFQd5Axz2yMnOo4rtP3jgEBJxUVOW0RLmFEGFejBHkYjq0s5A@mail.gmail.com>
References: <20170705071215.17603-1-tfiga@chromium.org> <20170705071215.17603-2-tfiga@chromium.org>
 <20170705151728.GA2479@lst.de> <CAAFQd5DijKbNJ-8wHh=+2Z2y1nSF-LC8R+d+NktTRF4iQqPsrA@mail.gmail.com>
 <20170705172019.GB5246@lst.de> <CAAFQd5CkVYd6uyoFP_15N8ZaZp8jivJ-4S=CAvrTynRU2ShFYg@mail.gmail.com>
 <CAK8P3a2htZ7q=npfwJVW7Lr90O78Ey+OR5e0ivaR7GwV4YBs=A@mail.gmail.com>
 <CAAFQd5BMorNa8CD+cEap2=boD2-=jr+DFF9cXTNXzSSfe7FnLg@mail.gmail.com>
 <CAAFQd5BFLvWS5n8owm053GNC5VniMq-8Gh0BHo43B-TYShpsnA@mail.gmail.com>
 <CAK8P3a2JyQ-qLgh+ig4yWMJvB0AGjspMu8P8fNrPHgm3NMCGNw@mail.gmail.com>
 <CAAFQd5DS1NxKh4OJ52T2AJNTHg6K2fnuDm5-GHzmUk-kjowf2w@mail.gmail.com> <CAAFQd5Axz2yMnOo4rtP3jgEBJxUVOW0RLmFEGFejBHkYjq0s5A@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 6 Jul 2017 16:02:05 +0200
Message-ID: <CAK8P3a0xVjgD-w-uVDc54Mx0s6b1Bd3tRYt9rpetjNoMwDXvCA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] base: dma-mapping: Export commonly used symbols
To: Tomasz Figa <tfiga@chromium.org>
Cc: Christoph Hellwig <hch@lst.de>,
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
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pawel Osciak <posciak@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 6, 2017 at 3:49 PM, Tomasz Figa <tfiga@chromium.org> wrote:
> On Thu, Jul 6, 2017 at 10:31 PM, Tomasz Figa <tfiga@chromium.org> wrote:

>> On the other hand, if it's strictly about base/dma-mapping, we might
>> not need it indeed. The driver could call iommu-dma helpers directly,
>> without the need to provide its own DMA ops. One caveat, though, we
>> are not able to obtain coherent (i.e. uncached) memory with this
>> approach, which might have some performance effects and complicates
>> the code, that would now need to flush caches even for some small
>> internal buffers.
>
> I think I should add a bit of explanation here:
>  1) the device is non-coherent with CPU caches, even on x86,
>  2) it looks like x86 does not have non-coherent DMA ops, (but it
> might be something that could be fixed)

I don't understand what this means here. The PCI on x86 is always
cache-coherent, so why is the device not?

Do you mean that the device has its own caches that may need
flushing to make the device cache coherent with the CPU cache,
rather than flushing the CPU caches?

          Arnd
