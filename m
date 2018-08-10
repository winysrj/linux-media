Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57366 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727477AbeHJQ5q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 12:57:46 -0400
Date: Fri, 10 Aug 2018 10:27:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
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
In-Reply-To: <66694963.VB7x4V86dC@avalon>
Message-ID: <Pine.LNX.4.44L0.1808101019550.1425-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 10 Aug 2018, Laurent Pinchart wrote:

> > > Aren't you're missing a dma_sync_single_for_device() call before
> > > submitting the URB ? IIRC that's required for correct operation of the DMA
> > > mapping API on some platforms, depending on the cache architecture. The
> > > additional sync can affect performances, so it would be useful to re-run
> > > the perf test.
> > 
> > This was already discussed:
> > 
> > https://lkml.org/lkml/2018/7/23/1051
> > 
> > I rely on Alan's reply:
> > 
> > > According to Documentation/DMA-API-HOWTO.txt, the CPU should not write
> > > to a DMA_FROM_DEVICE-mapped area, so dma_sync_single_for_device() is
> > > not needed.
> 
> I fully agree that the CPU should not write to the buffer. However, I think 
> the sync call is still needed. It's been a long time since I touched this 
> area, but IIRC, some cache architectures (VIVT ?) require both cache clean 
> before the transfer and cache invalidation after the transfer. On platforms 
> where no cache management operation is needed before the transfer in the 
> DMA_FROM_DEVICE direction, the dma_sync_*_for_device() calls should be no-ops 
> (and if they're not, it's a bug of the DMA mapping implementation).

In general, I agree that the cache has to be clean before a transfer
starts.  This means some sort of mapping operation (like
dma_sync_*_for-device) is indeed required at some point between the
allocation and the first transfer.

For subsequent transfers, however, the cache is already clean and it
will remain clean because the CPU will not do any writes to the buffer.
(Note: clean != empty.  Rather, clean == !dirty.)  Therefore transfers
following the first should not need any dma_sync_*_for_device.

If you don't accept this reasoning then you should ask the people who 
wrote DMA-API-HOWTO.txt.  They certainly will know more about this 
issue than I do.

Alan Stern
