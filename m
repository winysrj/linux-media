Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:39493 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728561AbeJaKvc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 06:51:32 -0400
Received: by mail-yb1-f194.google.com with SMTP id j9-v6so5948542ybj.6
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2018 18:55:37 -0700 (PDT)
Received: from mail-yw1-f53.google.com (mail-yw1-f53.google.com. [209.85.161.53])
        by smtp.gmail.com with ESMTPSA id k82-v6sm657581ywb.65.2018.10.30.18.55.35
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Oct 2018 18:55:35 -0700 (PDT)
Received: by mail-yw1-f53.google.com with SMTP id v1-v6so5806570ywv.6
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2018 18:55:35 -0700 (PDT)
MIME-Version: 1.0
References: <20180830172030.23344-1-ezequiel@collabora.com>
 <20180830172030.23344-3-ezequiel@collabora.com> <20180830175850.GA11521@infradead.org>
 <4fc5107f93871599ead017af7ad50f22535a7683.camel@collabora.com>
 <20180831055047.GA9140@infradead.org> <CAAFQd5DhFr8ywjc41oK9q+zZXH9zsOKh_7DxWmjzcE0+5Q3hGA@mail.gmail.com>
In-Reply-To: <CAAFQd5DhFr8ywjc41oK9q+zZXH9zsOKh_7DxWmjzcE0+5Q3hGA@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 31 Oct 2018 10:55:23 +0900
Message-ID: <CAAFQd5BjGkJf-Yz3ixiCjCaoeQJKKXbF41JyEvrm1DQ6uNnBrQ@mail.gmail.com>
Subject: Re: [RFC 2/3] USB: core: Add non-coherent buffer allocation helpers
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

Hi Christoph and everyone,

On Fri, Aug 31, 2018 at 3:51 PM Tomasz Figa <tfiga@chromium.org> wrote:
>
> On Fri, Aug 31, 2018 at 2:50 PM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Thu, Aug 30, 2018 at 07:11:35PM -0300, Ezequiel Garcia wrote:
> > > On Thu, 2018-08-30 at 10:58 -0700, Christoph Hellwig wrote:
> > > > Please don't introduce new DMA_ATTR_NON_CONSISTENT users, it is
> > > > a rather horrible interface, and I plan to kill it off rather sooner
> > > > than later.  I plan to post some patches for a better interface
> > > > that can reuse the normal dma_sync_single_* interfaces for ownership
> > > > transfers.  I can happily include usb in that initial patch set based
> > > > on your work here if that helps.
> > >
> > > Please do. Until we have proper allocators that go thru the DMA API,
> > > drivers will have to kmalloc the USB transfer buffers, and have
> > > streaming mappings. Which in turns mean not using IOMMU or CMA.
> >
> > dma_map_page will of course use the iommu.
>
> Sure, dma_map*() will, but using kmalloc() defeats (half of) the
> purpose of it, since contiguous memory would be allocated
> unnecessarily, risking failures due to fragmentation.

Have we reached a conclusion here?

It sounds like it's a quite significant problem, at least for some of
the camera (media) devices over there and there are people interested
in solving it, so all we need here is a conclusion on how to do it. :)

Best regards,
Tomasz
