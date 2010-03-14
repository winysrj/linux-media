Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54294 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934063Ab0CNVwK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Mar 2010 17:52:10 -0400
Date: Sun, 14 Mar 2010 22:52:02 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Martin van Es <mrvanes@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: dual TT C-1501 on a single PCI riser
Message-ID: <20100314215202.GA229@daniel.bse>
References: <eccab77d1003140521v73b17897h76ce413d5dc59361@mail.gmail.com> <eccab77d1003140914p20debe7fka2fbd173a85b860f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eccab77d1003140914p20debe7fka2fbd173a85b860f@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sun, Mar 14, 2010 at 05:14:33PM +0100, Martin van Es wrote:
> ? Pin A11: additional 33 MHz PCI clock
> ? Pin B10: additional PCI request signal (i.e., PREQ#2)
> ? Pin B14: additional PCI Grant signal (i.e., GNT#2)
> -----
> 
> I'm 100% sure the Tranquil riser does not support this suggestion
> since the A11/B10 and B14 leads are not used on the riser.

Your riser card doesn't need these signals thanks to the IT8209R.
The drawback is that the cards will be granted less bus time when
competing with on board PCI peripherals.

> On the other hand, my guess would be that an ordinary
> riser with arbiter and the correct wiring should do the trick. My
> question is more or less the same as Udo's in the thread I posted: how
> do I check if int 17 of the second card is correctly connected to int
> A of the second slot and if not, where to start changing things?

PCI slots have four interrupts, INTA, INTB, INTC, and INTC. Riser cards
usually permute these for the second and following slots to avoid
interrupt sharing. The BIOS has a built-in table that tells Linux for
every slot which pin of the interrupt controller is connected to these
four interrupt lines. So we need to make the second slot appear to the
BIOS to be one where INTA is same interrupt as (probably) INTB of the
first slot.

Slots are addressed using the IDSEL line. Every slot has its own line.
To reduce the number of signals (and to allow riser cards) the PCI
standards suggests reusing the upper AD lines as IDSEL lines for the
slots. So by changing the AD line connected to the IDSEL line of the
second slot with the jumper on the riser card, the slot will get another
number and thus another interrupt mapping.

According to the ICH7 datasheet you should currently have selected
AD24, as your card is 08.0 on the bus (strange... at that position
should have been the intel ethernet controller..). Just subtract
16 from the AD number to get the slot number. Now try all of them
until you find one where interrupts work. Avoid those already in
use on the same bus as listed by "lspci -tv".

Good luck!

  Daniel
