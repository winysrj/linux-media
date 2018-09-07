Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:37530 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbeIGNec (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2018 09:34:32 -0400
Received: by mail-yw1-f65.google.com with SMTP id x83-v6so5137245ywd.4
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2018 01:54:35 -0700 (PDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id y2-v6sm3187392ywd.38.2018.09.07.01.54.33
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Sep 2018 01:54:34 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id k5-v6so5186782ybo.10
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2018 01:54:33 -0700 (PDT)
MIME-Version: 1.0
References: <20180830172030.23344-1-ezequiel@collabora.com>
 <20180830172030.23344-4-ezequiel@collabora.com> <20180830175937.GB11521@infradead.org>
In-Reply-To: <20180830175937.GB11521@infradead.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 7 Sep 2018 17:54:22 +0900
Message-ID: <CAAFQd5D=tETh0638gR0TP=_FZXzMcy=6EjOLW8n1SRPqR=sCrQ@mail.gmail.com>
Subject: Re: [RFC 3/3] stk1160: Use non-coherent buffers for USB transfers
To: Christoph Hellwig <hch@infradead.org>
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Alan Stern <stern@rowland.harvard.edu>, kernel@collabora.com,
        keiichiw@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 31, 2018 at 2:59 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> > +     dma_sync_single_for_cpu(&urb->dev->dev, urb->transfer_dma,
> > +             urb->transfer_buffer_length, DMA_FROM_DEVICE);
>
> You can't ue dma_sync_single_for_cpu on non-coherent dma buffers,
> which is one of the major issues with them.

It's not an issue of DMA API, but just an API mismatch. By design,
memory allocated for device (e.g. by DMA API) doesn't have to be
physically contiguous, while dma_*_single() API expects a _single_,
physically contiguous region of memory.

We need a way to allocate non-coherent memory using DMA API to handle
(on USB example, but applies to virtually any class of devices doing
DMA):
 - DMA address range limitations (e.g. dma_mask) - while a USB HCD
driver is normally aware of those, USB device driver should have no
idea,
 - memory mapping capability === whether contiguous memory or a set of
random pages can be allocated - this is a platform integration detail,
which even a USB HCD driver may not be aware of, if a SoC IOMMU is
just stuffed between the bus and HCD,
 - platform coherency specifics - there are practical scenarios when
on a coherent-by-default system it's more efficient to allocate
non-coherent memory and manage caches explicitly to avoid the costs of
cache snooping.

If DMA_ATTR_NON_CONSISTENT is not the right way to do it, there should
be definitely a new API introduced, coupled closely to DMA API
implementation on given platform, since it's the only place which can
solve all the constraints above.

Best regards,
Tomasz
