Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64267 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936155Ab0COMut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 08:50:49 -0400
Received: by wyb38 with SMTP id 38so1453647wyb.19
        for <linux-media@vger.kernel.org>; Mon, 15 Mar 2010 05:50:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100314215202.GA229@daniel.bse>
References: <eccab77d1003140521v73b17897h76ce413d5dc59361@mail.gmail.com>
	 <eccab77d1003140914p20debe7fka2fbd173a85b860f@mail.gmail.com>
	 <20100314215202.GA229@daniel.bse>
Date: Mon, 15 Mar 2010 13:50:45 +0100
Message-ID: <eccab77d1003150550g2d1c03eapd45fd2daa6488fdf@mail.gmail.com>
Subject: Re: dual TT C-1501 on a single PCI riser
From: Martin van Es <mrvanes@gmail.com>
To: Martin van Es <mrvanes@gmail.com>, linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <daniel-gl@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

Thx for your answer. It put me on the right track because I have
finally solved the puzzle!
Here's how:

I did some testing with the IDSEL jumpers and saw the following pattern:

IDSEL   GSI/IRQ reported by kernel.
24      17
25      20
26      no route -> 1
27      no route -> 1
28      17
29      20
30      no route -> 1
31      no device present

But none of these settings resulted in a response to interrupts.
Also I had measured that INTA of slot2 was wired to INTD of the riser
connector, which I thought strange, because I'd expect a forward rotation
for slot2 (A>B)?

When I look at the pci layout, pci device 05 is connected to bridge 1e.0:

-[0000:00]-+-00.0
           +-02.0
           +-02.1
           +-1b.0
           +-1c.0-[01]----00.0
           +-1c.1-[02]--
           +-1c.2-[03]--
           +-1c.3-[04]--
           +-1d.0
           +-1d.1
           +-1d.2
           +-1d.3
           +-1d.7
           +-1e.0-[05]--+-00.0  Philips Semiconductors SAA7146
           |            \-0c.0  Philips Semiconductors SAA7146
           +-1f.0
           +-1f.1
           +-1f.2
           \-1f.3

Then I wondered if device 05 would still be present if I removed the riser and
it was. So I started to suspect that the motherboard had no way to know what
PCI int's were used behind the bridge if both cards were detected to serve
INTA (i.e. 05.0x = INTA in lspci -v) and would thus (quite stupidly?)
route any int for
this slot to INTA?

So, when I hard-wired the 2nd slot INTA to riser INTA together and used IDSEL 29
I had a succesful initialisation of the DVB card (the other IDSELs didn't work,
even on different PCI INTs), but way too many interrupts on int 20. Then I tried
both cards and that worked as well, but again far too many interrupts
on int 20.
Last change was to cut the original slot2 connection to INTD and gone were my
extra interrupts!

So now I have two correctly recognised cards, both using int 20 and PCI INTA.
Now I wonder if this will harm the performance if both cards are recording
streams, let alone if they work, because that's the next test I still have to
do.

Regards,
Martin van Es

On Sun, Mar 14, 2010 at 22:52, Daniel Glöckner <daniel-gl@gmx.net> wrote:
> Hi,
>
> On Sun, Mar 14, 2010 at 05:14:33PM +0100, Martin van Es wrote:
>> ? Pin A11: additional 33 MHz PCI clock
>> ? Pin B10: additional PCI request signal (i.e., PREQ#2)
>> ? Pin B14: additional PCI Grant signal (i.e., GNT#2)
>> -----
>>
>> I'm 100% sure the Tranquil riser does not support this suggestion
>> since the A11/B10 and B14 leads are not used on the riser.
>
> Your riser card doesn't need these signals thanks to the IT8209R.
> The drawback is that the cards will be granted less bus time when
> competing with on board PCI peripherals.
>
>> On the other hand, my guess would be that an ordinary
>> riser with arbiter and the correct wiring should do the trick. My
>> question is more or less the same as Udo's in the thread I posted: how
>> do I check if int 17 of the second card is correctly connected to int
>> A of the second slot and if not, where to start changing things?
>
> PCI slots have four interrupts, INTA, INTB, INTC, and INTC. Riser cards
> usually permute these for the second and following slots to avoid
> interrupt sharing. The BIOS has a built-in table that tells Linux for
> every slot which pin of the interrupt controller is connected to these
> four interrupt lines. So we need to make the second slot appear to the
> BIOS to be one where INTA is same interrupt as (probably) INTB of the
> first slot.
>
> Slots are addressed using the IDSEL line. Every slot has its own line.
> To reduce the number of signals (and to allow riser cards) the PCI
> standards suggests reusing the upper AD lines as IDSEL lines for the
> slots. So by changing the AD line connected to the IDSEL line of the
> second slot with the jumper on the riser card, the slot will get another
> number and thus another interrupt mapping.
>
> According to the ICH7 datasheet you should currently have selected
> AD24, as your card is 08.0 on the bus (strange... at that position
> should have been the intel ethernet controller..). Just subtract
> 16 from the AD number to get the slot number. Now try all of them
> until you find one where interrupts work. Avoid those already in
> use on the same bus as listed by "lspci -tv".
>
> Good luck!
>
>  Daniel
>
