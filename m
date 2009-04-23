Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3N3pGQI030167
	for <video4linux-list@redhat.com>; Wed, 22 Apr 2009 23:51:16 -0400
Received: from master.linux-sh.org (124x34x33x190.ap124.ftth.ucom.ne.jp
	[124.34.33.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3N3p30D012744
	for <video4linux-list@redhat.com>; Wed, 22 Apr 2009 23:51:03 -0400
Date: Thu, 23 Apr 2009 12:45:53 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Magnus Damm <magnus.damm@gmail.com>
Message-ID: <20090423034553.GA21515@linux-sh.org>
References: <49EEE84A.5090400@parrot.com>
	<aec7e5c30904220431l55a48efah8881b562928eae5a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c30904220431l55a48efah8881b562928eae5a@mail.gmail.com>
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: videobuf-dma-contig sync question
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, Apr 22, 2009 at 08:31:28PM +0900, Magnus Damm wrote:
> On Wed, Apr 22, 2009 at 6:50 PM, Matthieu CASTET
> <matthieu.castet@parrot.com> wrote:
> > I don't understand why __videobuf_sync in videobuf-dma-contig isn't a nop.
> >
> > All the memory allocated by videobuf-dma-contig is coherent memory. And
> > Documentation/DMA-API.txt seems to imply that this memory is coherent
> > and doesn't need extra cache operation for synchronization.
> 
> Sounds correct. With that in mind the sync doesn't make much sense.
> Fixing the videobuf-dma-contig code seems like a good idea to me. Or
> is it architecture code that needs to be fixed? Any thoughts Paul?
> 
No, no sync points are necessary for dma_alloc_coherent() memory. In the
case of dma_alloc_noncoherent() it is left up to the implementation to
decide what to do and be moderately more intelligent in the sync code,
but not in the dma_alloc_coherent() case where uncached coherent regions
are handed back directly.

dma_alloc_coherent() is also the tie-in point for per-device coherent
memory, which absolutely is not handled by the sync code and will rightly
blow up.

> Initially in V1 of the patch the sync was just a nop, but in V2 the
> current behaviour was introduced. I think Paulius requested the sync
> implementation and I just blindly added it since it worked well for me
> on SuperH anyway:
> 
This probably comes from a lack of understanding of the API and its
subtleties. The sync ops are necessary if a platform can't gaurantee
coherent memory (or the device needs more than it can gaurantee) and
hands back a non-coherent allocation. The driver has to be aware of this
and request it explicitly however, or you just fail on the allocation.
Going down this road means that both the driver and the platform need to
agree on how to manage potentially non-coherent memory, which most are
ill-equipped to do. This also is not a concern for this driver given the
use of dma_alloc_coherent() over dma_alloc_noncoherent().

Beyond that, the sync points are necessary for streaming DMA mappings,
which are likewise unrelated to this driver. ie, videobuf-dma-sg would
use sync points if it cared, videobuf-dma-contig would not, unless you
renamed it to videobuf-dma-maybecontig and dealt with the potential for
being handed back non-coherent memory.

The architecture code is quite right to blow up on this.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
