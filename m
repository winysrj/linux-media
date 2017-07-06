Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f171.google.com ([209.85.213.171]:34588 "EHLO
        mail-yb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752557AbdGFNjb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 09:39:31 -0400
Received: by mail-yb0-f171.google.com with SMTP id e201so834831ybb.1
        for <linux-media@vger.kernel.org>; Thu, 06 Jul 2017 06:39:30 -0700 (PDT)
Received: from mail-yw0-f182.google.com (mail-yw0-f182.google.com. [209.85.161.182])
        by smtp.gmail.com with ESMTPSA id x78sm74133ywg.70.2017.07.06.06.39.29
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jul 2017 06:39:29 -0700 (PDT)
Received: by mail-yw0-f182.google.com with SMTP id a12so1086834ywh.3
        for <linux-media@vger.kernel.org>; Thu, 06 Jul 2017 06:39:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK8P3a2JyQ-qLgh+ig4yWMJvB0AGjspMu8P8fNrPHgm3NMCGNw@mail.gmail.com>
References: <20170705071215.17603-1-tfiga@chromium.org> <20170705071215.17603-2-tfiga@chromium.org>
 <20170705151728.GA2479@lst.de> <CAAFQd5DijKbNJ-8wHh=+2Z2y1nSF-LC8R+d+NktTRF4iQqPsrA@mail.gmail.com>
 <20170705172019.GB5246@lst.de> <CAAFQd5CkVYd6uyoFP_15N8ZaZp8jivJ-4S=CAvrTynRU2ShFYg@mail.gmail.com>
 <CAK8P3a2htZ7q=npfwJVW7Lr90O78Ey+OR5e0ivaR7GwV4YBs=A@mail.gmail.com>
 <CAAFQd5BMorNa8CD+cEap2=boD2-=jr+DFF9cXTNXzSSfe7FnLg@mail.gmail.com>
 <CAAFQd5BFLvWS5n8owm053GNC5VniMq-8Gh0BHo43B-TYShpsnA@mail.gmail.com> <CAK8P3a2JyQ-qLgh+ig4yWMJvB0AGjspMu8P8fNrPHgm3NMCGNw@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 6 Jul 2017 22:31:57 +0900
Message-ID: <CAAFQd5DS1NxKh4OJ52T2AJNTHg6K2fnuDm5-GHzmUk-kjowf2w@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] base: dma-mapping: Export commonly used symbols
To: Arnd Bergmann <arnd@arndb.de>
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

On Thu, Jul 6, 2017 at 9:23 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thu, Jul 6, 2017 at 10:36 AM, Tomasz Figa <tfiga@chromium.org> wrote:
>> On Thu, Jul 6, 2017 at 5:34 PM, Tomasz Figa <tfiga@chromium.org> wrote:
>>> On Thu, Jul 6, 2017 at 5:26 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>> On Thu, Jul 6, 2017 at 3:44 AM, Tomasz Figa <tfiga@chromium.org> wrote:
>
>>>
>>> I'd say that this is something that has been consistently tried to be
>>> avoided by V4L2 and that's why it's so tightly integrated with DMA
>>> mapping. IMHO re-implementing the code that's already there in
>>> videobuf2 again in the driver, only because, for no good reason
>>> mentioned as for now, having a loadable module providing DMA ops was
>>> disliked.
>>
>> Sorry, I intended to mean:
>>
>> IMHO re-implementing the code that's already there in videobuf2 again
>> in the driver, only because, for no good reason mentioned as for now,
>> having a loadable module providing DMA ops was disliked, would make no
>> sense.
>
> Why would we need to duplicate that code? I would expect that the videobuf2
> core can simply call the regular dma_mapping interfaces, and you handle the
> IOPTE generation at the point when the buffer is handed off from the core
> code to the device driver. Am I missing something?

Well, for example, the iommu-dma helpers already implement all the
IOVA management, SG iterations, IOMMU API calls, sanity checks and so
on. There is a significant amount of common code.

On the other hand, if it's strictly about base/dma-mapping, we might
not need it indeed. The driver could call iommu-dma helpers directly,
without the need to provide its own DMA ops. One caveat, though, we
are not able to obtain coherent (i.e. uncached) memory with this
approach, which might have some performance effects and complicates
the code, that would now need to flush caches even for some small
internal buffers.

Best regards,
Tomasz
