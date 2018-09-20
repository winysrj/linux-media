Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33322 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1731135AbeITUMY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 16:12:24 -0400
Date: Thu, 20 Sep 2018 10:28:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Ezequiel Garcia <ezequiel@collabora.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Matwey V. Kornilov" <matwey.kornilov@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, <mingo@redhat.com>,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        <keiichiw@chromium.org>
Subject: Re: [PATCH v4 2/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
In-Reply-To: <5b84e0e4f1b0cbfd3cf3e641c41f9fc50a74e6bf.camel@collabora.com>
Message-ID: <Pine.LNX.4.44L0.1809201027130.2141-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 20 Sep 2018, Ezequiel Garcia wrote:

> Alan, Laurent:
> 
> On Fri, 2018-08-10 at 10:27 -0400, Alan Stern wrote:
> > On Fri, 10 Aug 2018, Laurent Pinchart wrote:
> > 
> > > > > Aren't you're missing a dma_sync_single_for_device() call before
> > > > > submitting the URB ? IIRC that's required for correct operation of the DMA
> > > > > mapping API on some platforms, depending on the cache architecture. The
> > > > > additional sync can affect performances, so it would be useful to re-run
> > > > > the perf test.
> > > > 
> > > > This was already discussed:
> > > > 
> > > > https://lkml.org/lkml/2018/7/23/1051
> > > > 
> > > > I rely on Alan's reply:
> > > > 
> > > > > According to Documentation/DMA-API-HOWTO.txt, the CPU should not write
> > > > > to a DMA_FROM_DEVICE-mapped area, so dma_sync_single_for_device() is
> > > > > not needed.
> > > 
> > > I fully agree that the CPU should not write to the buffer. However, I think 
> > > the sync call is still needed. It's been a long time since I touched this 
> > > area, but IIRC, some cache architectures (VIVT ?) require both cache clean 
> > > before the transfer and cache invalidation after the transfer. On platforms 
> > > where no cache management operation is needed before the transfer in the 
> > > DMA_FROM_DEVICE direction, the dma_sync_*_for_device() calls should be no-ops 
> > > (and if they're not, it's a bug of the DMA mapping implementation).
> > 
> > In general, I agree that the cache has to be clean before a transfer
> > starts.  This means some sort of mapping operation (like
> > dma_sync_*_for-device) is indeed required at some point between the
> > allocation and the first transfer.
> > 
> > For subsequent transfers, however, the cache is already clean and it
> > will remain clean because the CPU will not do any writes to the buffer.
> > (Note: clean != empty.  Rather, clean == !dirty.)  Therefore transfers
> > following the first should not need any dma_sync_*_for_device.
> > 
> > If you don't accept this reasoning then you should ask the people who 
> > wrote DMA-API-HOWTO.txt.  They certainly will know more about this 
> > issue than I do.
> > 
> 
> Can either of you ack or nack this change? I'd like to see this merged,
> or either re-worked, so we can merge it.

I don't have the hardware and I'm not terribly familiar with that part 
of the code, so it would be better for Laurent to respond.  The basic 
idea seems good, but I'm not looking at the details.

Alan Stern
