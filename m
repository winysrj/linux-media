Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53808 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbeHEJxt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Aug 2018 05:53:49 -0400
Date: Sun, 5 Aug 2018 00:49:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        keiichiw@chromium.org
Subject: Re: [PATCH 2/2] media: usb: pwc: Don't use coherent DMA buffers for
 ISO transfer
Message-ID: <20180805074946.GA14119@infradead.org>
References: <CAJs94EZA=o5=4frPhXs3vnr4x-__gSZ2ximvTyugLoaD6KLcUg@mail.gmail.com>
 <Pine.LNX.4.44L0.1808041045060.25853-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1808041045060.25853-100000@netrider.rowland.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 04, 2018 at 10:46:35AM -0400, Alan Stern wrote:
> > 2) dma_unmap and dma_map in the handler:
> > 2A) dma_unmap_single call: 28.8 +- 1.5 usec
> > 2B) memcpy and the rest: 58 +- 6 usec
> > 2C) dma_map_single call: 22 +- 2 usec
> > Total: 110 +- 7 usec
> > 
> > 3) dma_sync_single_for_cpu
> > 3A) dma_sync_single_for_cpu call: 29.4 +- 1.7 usec
> > 3B) memcpy and the rest: 59 +- 6 usec
> > 3C) noop (trace events overhead): 5 +- 2 usec
> > Total: 93 +- 7 usec
> > 
> > So, now we see that 2A and 3A (as well as 2B and 3B) agree good within
> > error ranges.
> 
> Taken together, those measurements look like a pretty good argument for 
> always using dma_sync_single_for_cpu in the driver.  Provided results 
> on other platforms aren't too far out of line with these results.

Logically speaking on no-mmio no-swiotlb platforms dma_sync_single_for_cpu
and dma_unmap should always be identical.  With the migration towards
everyone using dma-direct and dma-noncoherent this is actually going to
be enforced, and I plan to move that enforcement to common code in the
next merge window or two.
