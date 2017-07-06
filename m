Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33513 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752520AbdGFMYI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 08:24:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAAFQd5BFLvWS5n8owm053GNC5VniMq-8Gh0BHo43B-TYShpsnA@mail.gmail.com>
References: <20170705071215.17603-1-tfiga@chromium.org> <20170705071215.17603-2-tfiga@chromium.org>
 <20170705151728.GA2479@lst.de> <CAAFQd5DijKbNJ-8wHh=+2Z2y1nSF-LC8R+d+NktTRF4iQqPsrA@mail.gmail.com>
 <20170705172019.GB5246@lst.de> <CAAFQd5CkVYd6uyoFP_15N8ZaZp8jivJ-4S=CAvrTynRU2ShFYg@mail.gmail.com>
 <CAK8P3a2htZ7q=npfwJVW7Lr90O78Ey+OR5e0ivaR7GwV4YBs=A@mail.gmail.com>
 <CAAFQd5BMorNa8CD+cEap2=boD2-=jr+DFF9cXTNXzSSfe7FnLg@mail.gmail.com> <CAAFQd5BFLvWS5n8owm053GNC5VniMq-8Gh0BHo43B-TYShpsnA@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 6 Jul 2017 14:23:57 +0200
Message-ID: <CAK8P3a2JyQ-qLgh+ig4yWMJvB0AGjspMu8P8fNrPHgm3NMCGNw@mail.gmail.com>
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

On Thu, Jul 6, 2017 at 10:36 AM, Tomasz Figa <tfiga@chromium.org> wrote:
> On Thu, Jul 6, 2017 at 5:34 PM, Tomasz Figa <tfiga@chromium.org> wrote:
>> On Thu, Jul 6, 2017 at 5:26 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Thu, Jul 6, 2017 at 3:44 AM, Tomasz Figa <tfiga@chromium.org> wrote:

>>
>> I'd say that this is something that has been consistently tried to be
>> avoided by V4L2 and that's why it's so tightly integrated with DMA
>> mapping. IMHO re-implementing the code that's already there in
>> videobuf2 again in the driver, only because, for no good reason
>> mentioned as for now, having a loadable module providing DMA ops was
>> disliked.
>
> Sorry, I intended to mean:
>
> IMHO re-implementing the code that's already there in videobuf2 again
> in the driver, only because, for no good reason mentioned as for now,
> having a loadable module providing DMA ops was disliked, would make no
> sense.

Why would we need to duplicate that code? I would expect that the videobuf2
core can simply call the regular dma_mapping interfaces, and you handle the
IOPTE generation at the point when the buffer is handed off from the core
code to the device driver. Am I missing something?

       Arnd
