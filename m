Return-path: <linux-media-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33965 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751157AbdGMNgC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 09:36:02 -0400
Date: Thu, 13 Jul 2017 15:36:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Thierry Escande <thierry.escande@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-parisc@vger.kernel.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 0/2] [media] videobuf2-dc: Add support for cacheable
        MMAP
Message-ID: <20170713133600.GA24748@lst.de>
References: <CGME20161026085228epcas3p3895ea279d5538750a3b1c59715ad3761@epcas3p3.samsung.com> <1477471926-15796-1-git-send-email-thierry.escande@collabora.com> <f829886e-4842-a500-6b10-9a46e1b763f5@samsung.com> <20170705173327.GD5417@lst.de> <7505cb31-6bd1-7f76-f975-aa5e61e567f0@samsung.com> <20170713132153.GD31807@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170713132153.GD31807@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 13, 2017 at 02:21:53PM +0100, Russell King - ARM Linux wrote:
> My conclusion of the dma_alloc_noncoherent() and dma_cache_sync() API
> when it was introduced is that it's basically a completely broken
> interface, and I've never seen any point to it.  Maybe some of that is
> because it's badly documented - which in turn makes it badly designed
> (because there's no specification detailing what it's supposed to be
> doing.)
> 
> I'd like to see that thing die...

It's not exactly the best interface ever, so any improvement is welcome.

I've posted a series to kill dma_alloc_noncoherent in favor of
dma_alloc_attrs a short while ago, and a big chunk of it should have
made it into 4.12.  I plan to kill it off entirely for 4.13.

That leaves dma_cache_sync() - it's used by 6 drivers:

drivers/net/ethernet/i825xx/lasi_82596.c
drivers/net/ethernet/seeq/sgiseeq.c
drivers/scsi/53c700.c
drivers/scsi/sgiwd93.c
drivers/sh/maple/maple.c
drivers/tty/serial/mpsc.c

Those are used on parisc, mips for a few old SGI systems, the SH
dreamcast and powerpc marvell mv64x60 devices.

So it shouldn't be too hard to figure out if they could be moved
to the normal dma_sync_* calls.

On parisc dma_cache_sync is equivalent to dma_sync_single_for_cpu,
so that should be fine.

On mips the implementation of dma_sync_single_for_cpu is a little
more complicated, but both dma_sync_single_for_cpu and dma_cache_sync
end up calling __dma_sync_virtual, so they look like the same in
the end as well.

On SH sync_single_for_device is implemented using dma_cache_sync,
and there is no dma_sync_single_for_cpu.

On powerpc both dma_sync_single_for_cpu and dma_sync_single_for_device
are implemented using the same primitive as dma_cache_sync.

In short: killing off dma_cache_sync and using the existing and
better defined syncing primitives looks entirely feasible.

I'll add it to my TODO list for 4.13.
