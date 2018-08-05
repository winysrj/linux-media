Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54638 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbeHEKpU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Aug 2018 06:45:20 -0400
Date: Sun, 5 Aug 2018 01:41:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Cc: Christoph Hellwig <hch@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
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
Message-ID: <20180805084116.GA15482@infradead.org>
References: <CAJs94EZA=o5=4frPhXs3vnr4x-__gSZ2ximvTyugLoaD6KLcUg@mail.gmail.com>
 <Pine.LNX.4.44L0.1808041045060.25853-100000@netrider.rowland.org>
 <20180805074946.GA14119@infradead.org>
 <CAJs94Eb_Mzxk6a+_b8ZnutdkBjrk5=UWg0F1X0-iRZK1do5uLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJs94Eb_Mzxk6a+_b8ZnutdkBjrk5=UWg0F1X0-iRZK1do5uLg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 05, 2018 at 11:33:38AM +0300, Matwey V. Kornilov wrote:
> >> Taken together, those measurements look like a pretty good argument for
> >> always using dma_sync_single_for_cpu in the driver.  Provided results
> >> on other platforms aren't too far out of line with these results.
> >
> > Logically speaking on no-mmio no-swiotlb platforms dma_sync_single_for_cpu
> > and dma_unmap should always be identical.  With the migration towards
> > everyone using dma-direct and dma-noncoherent this is actually going to
> > be enforced, and I plan to move that enforcement to common code in the
> > next merge window or two.
> >
> 
> I think that Alan means that using dma_sync_single_for_cpu() we save
> time required for subsequent dma_map() call (which is required when we
> do dma_unmap()).

The point still stands.  By definition for a correct DMA API
implementation a dma_sync_single_for_cpu/dma_sync_single_for_device
pair is always going to be cheaper than a dma_unmap/dma_map pair,
although for many cases the difference might be so small that it is
not measureable.

If you reuse a buffer using dma_sync_single* is always the right thing
to do vs unmapping and remapping it.
