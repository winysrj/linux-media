Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7QNUMhA027323
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 19:30:23 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7QNTk15002241
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 19:30:02 -0400
Date: Wed, 27 Aug 2008 01:29:13 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Andy Walls <awalls@radix.net>
Message-ID: <20080826232913.GA2145@daniel.bse>
References: <200808251445.22005.jdelvare@suse.de>
	<1219711251.2796.47.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219711251.2796.47.camel@morgan.walls.org>
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Jean Delvare <jdelvare@suse.de>
Subject: Re: [v4l-dvb-maintainer] bttv driver questions
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

On Mon, Aug 25, 2008 at 08:40:51PM -0400, Andy Walls wrote:
> On Mon, 2008-08-25 at 14:45 +0200, Jean Delvare wrote:
> > * When is the bttv IRQ handler called? At the end of every frame?

yes

> > At the end of the VBI?

yes

> > Between the odd field and even field sequences for full resolution frames?

no, in-between only if fields are captured independently

> > * Does the bttv driver have anything special to do for full
> >   resolution frames, that it doesn't have to do for half resolution
> >   ones? In particular, I wonder if the BT878 DMA engine knows how to
> >   interlace fields when writing to the memory, or if the bttv driver
> >   must take care of reordering the fields properly afterwards. I
> >   suspect the latter.

The driver fills buffers with instructions for the DMA engine, one buffer
for the top field and one for the bottom field. These instructions tell
the engine where to write a specific pixel. For interlaced video the
instructions for the top field write to line 0, 2, 4, ... in memory and for
the bottom field to line 1, 3, 5, ... .

> > * How longs are the blocks written by the BT878 DMA engine to memory?
> >   Obviously it can't send more than the FIFO size (128 bytes) at
> >   once.

The FIFO is bigger. In packed modes it is 140x4 bytes. In planar modes
it is 70x4 bytes for luma and 35x4 bytes for each chroma FIFO.

> IF I'm reading the PCI 2.2 spec correctly, targets are allowed an
> initial (start of burst) latency of up to 16 cycles before they must be
> ready for the first data transfer in a burst.  Host bridges as targets
> are allowed an additional 16 cycles setup time (for a total of 32) if
> the transfer is to a modified cache line.  For subsequent transfers in
> the burst, the target is only allowed 8 setup cycles max.
> 
> So with a BT878 latency timer of 32 cycles, a 128 byte burst could be
> sent as 2 transactions, assuming a maximum target setup time for the
> host bridge, with a transfer that doesn't hit a modified cache line,
> assuming transparent arbitration:
> 
> 1 addr cycle + 16 setup cycles + 15 data cycles  (60 bytes transferred)
> 1 turn around cycle (I think...)
> 1 addr cycle + 8 setup cycles + 17 data cycles (68 bytes transferred)
> 1 turn around cycle

I think worst case for slow targets is more like

1 addr cycle
15 setup cycles (unsure if initial latency includes addr cycle...)
1 data cycle
7 setup cycles
1 data cycle
7 setup cycles <-- latency timer of 32 expires, assuming GNT# is deasserted
1 data cycle <-- can't deassert FRAME# yet
7 setup cycles <-- FRAME# deasserted
1 data cycle
1 turnaround cycle
--------------------
16 bytes in 42 cycles

With fast targets we have

1 addr cycle
31 data cycles
(more data cycles as long as GNT# is asserted)
1 data cycle with FRAME# deasserted
1 turnaround cycle
--------------------
128 bytes in 34 cycles

> >  I am curious if there is a minimum FIFO usage for the
> >   BT878 to request the PCI bus. Couldn't find anything related to
> >   this in the datasheet.

There are FIFO trigger points settable in the GPIO_DMA_CTL register.
They can be set to 4, 8, 16, or 32 DWORDS.

> A PCI latency timer is the maximum amount of cycles a master is allowed
> to have the bus before it must request another grant.

The master may request extended/another grant before its timer expires.
Furthermore the arbiter may grant the bus without it being requested (bus
parking).

Making use of both features can be turned off in the Bt878 by the EN_TBFX and
EN_VSFX bits respectively to cope with bad chipsets.

Jean, is v4l-dvb-maintainer the right place to discuss these things?

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
