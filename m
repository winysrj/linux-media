Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7Q0gNtY012964
	for <video4linux-list@redhat.com>; Mon, 25 Aug 2008 20:42:23 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7Q0gDln027289
	for <video4linux-list@redhat.com>; Mon, 25 Aug 2008 20:42:13 -0400
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <jdelvare@suse.de>
In-Reply-To: <200808251445.22005.jdelvare@suse.de>
References: <200808251445.22005.jdelvare@suse.de>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 20:40:51 -0400
Message-Id: <1219711251.2796.47.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
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

On Mon, 2008-08-25 at 14:45 +0200, Jean Delvare wrote:
> Hi Mauro, hi Trent,
> 
> I'm back with more questions about the bttv driver:
> 
> * When is the bttv IRQ handler called? At the end of every frame? At
>   the end of the VBI? Between the odd field and even field sequences
>   for full resolution frames?
> 
> * Does the bttv driver have anything special to do for full
>   resolution frames, that it doesn't have to do for half resolution
>   ones? In particular, I wonder if the BT878 DMA engine knows how to
>   interlace fields when writing to the memory, or if the bttv driver
>   must take care of reordering the fields properly afterwards. I
>   suspect the latter.
> 
> * How longs are the blocks written by the BT878 DMA engine to memory?
>   Obviously it can't send more than the FIFO size (128 bytes) at
>   once. With the default PCI latency value (32) it seems that a
>   maximum of 96 bytes can actually be sent at once (8 cycles for
>   setup and 24 cycles for data on a 32-bit PCI bus -> 96 bytes per
>   transfer.)

IF I'm reading the PCI 2.2 spec correctly, targets are allowed an
initial (start of burst) latency of up to 16 cycles before they must be
ready for the first data transfer in a burst.  Host bridges as targets
are allowed an additional 16 cycles setup time (for a total of 32) if
the transfer is to a modified cache line.  For subsequent transfers in
the burst, the target is only allowed 8 setup cycles max.

So with a BT878 latency timer of 32 cycles, a 128 byte burst could be
sent as 2 transactions, assuming a maximum target setup time for the
host bridge, with a transfer that doesn't hit a modified cache line,
assuming transparent arbitration:

1 addr cycle + 16 setup cycles + 15 data cycles  (60 bytes transferred)
1 turn around cycle (I think...)
1 addr cycle + 8 setup cycles + 17 data cycles (68 bytes transferred)
1 turn around cycle
....


>  I am curious if there is a minimum FIFO usage for the
>   BT878 to request the PCI bus. Couldn't find anything related to
>   this in the datasheet.
> 
> * In continuation of the above, am I correct assuming that setting
>   the latency timer of the BT878 above 40 doesn't make sense? 40 PCI
>   cycles is enough to empty the FIFO completely,

It can make sense, especially if it's the only high bandwidth card in
the system.  Set the timer too high for any one card though, and you
will start to starve other devices off the bus when that one card is
busy.  The cards that are held off the bus too long, may have their
FIFOs or buffers overrun....

Setting latency timers for a system is a balancing act between the needs
of individual devices and the system's need for the shared PCI bus to
support the maximum anticipated burst or sustained activity on the bus
by all the devices that could be active at once.


>  and then there's no
>   data left to send. But I'm curious how the BT878 behaves if it is
>   granted more time than it needs. Can it return the PCI bus control
>   earlier?

A PCI latency timer is the maximum amount of cycles a master is allowed
to have the bus before it must request another grant.  It is not the
amount of cycles the master must use the bus.  So yes a bus master can,
and often does, release the bus before it's latency timer expires: it's
a normal circumstance.  What an actual BT878 does, I'll leave to the
experts, who may know about any potential quirks it may have.


> Or is it keeping control of the bus and sending more data
>   as it becomes (slowly) available? The later would be bad for both
>   latency and throughput.

During the time an initiator (a bus master like the BT878) has FRAME
asserted, the initiator can deassert IRDY or the target can deassert
TRDY to insert wait states according to the PCI spec.  So theoretically
a BT878 could do such a thing, but I'm unsure why a chip would do such a
thing if it had little or nothing to send.  Of course every wait cycle
counts against the latency timer too.  Again, that's what's possible,
but I defer to BT878 experts on what the chip actually does.



> If anyone can help me answer these questions, I would be grateful.
> Thanks!

PCI-X and PCIe are of course slightly different from PCI.  I do not know
how much of the above applies for those busses.

Regards,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
