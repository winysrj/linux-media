Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57495 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab0CNQOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Mar 2010 12:14:35 -0400
Received: by wyb38 with SMTP id 38so1170578wyb.19
        for <linux-media@vger.kernel.org>; Sun, 14 Mar 2010 09:14:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <eccab77d1003140521v73b17897h76ce413d5dc59361@mail.gmail.com>
References: <eccab77d1003140521v73b17897h76ce413d5dc59361@mail.gmail.com>
Date: Sun, 14 Mar 2010 17:14:33 +0100
Message-ID: <eccab77d1003140914p20debe7fka2fbd173a85b860f@mail.gmail.com>
Subject: Re: dual TT C-1501 on a single PCI riser
From: Martin van Es <mrvanes@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reply to myself with some extra information:
Just found this thread about the same problem, but different MB:
http://kerneltrap.org/mailarchive/linux-kernel/2007/2/18/56447

Have to study all the replies in more depth to see if there's a
solution hidden in there for me.

Another thing to remark is that the D945GSEJT does support a dual
riser card as it's described in the manual:
-----
The PCI bus connector also supports single-slot and dual-slot riser cards for
 use of up to two bus master PCI expansion cards. In order to support two PCI
bus master expansion cards, the riser card must support the following PCI
signal routing:
• Pin A11: additional 33 MHz PCI clock
• Pin B10: additional PCI request signal (i.e., PREQ#2)
• Pin B14: additional PCI Grant signal (i.e., GNT#2)
-----

I'm 100% sure the Tranquil riser does not support this suggestion
since the A11/B10 and B14 leads are not used on the riser.

So I'm doubting the remark that this riser is specifically made for
the D945GSEJT. On the other hand, my guess would be that an ordinary
riser with arbiter and the correct wiring should do the trick. My
question is more or less the same as Udo's in the thread I posted: how
do I check if int 17 of the second card is correctly connected to int
A of the second slot and if not, where to start changing things?

Regards
Martin

On Sun, Mar 14, 2010 at 13:21, Martin van Es <mrvanes@gmail.com> wrote:
> Hi,
>
> My name is Martin van Es and I just subscribed to the DVB mailinglist
> because I'm currently facing a challenge that's beyond my knowledge so
> I hope to find some cooperative minds in the list who could point me
> in the right direction.
>
> My problem is that I try to build a dual DVB-C tuner HTPC, based on an
> Intel D945GSEJT mini-itx motherboard. This board is equipped with only
> 1 PCI slot, so a PCI riser is the only solution (no single board dual
> DVB-C solutions exist today).
>
> The case I've bought came with a riser but that didn't work so my
> first attempt was to order this riser, which, they say is specifically
> designed for the D945GSEJT:
> http://www.tranquilpc-shop.co.uk/acatalog/PCI_Risers.html (top one,
> it's based on a IT8209R PCI Arbiter).
> When that didn't work I suspected there's more to this than correct
> hardware and started looking for solutions, including mailing a
> knowledgable PCI expert but even that didn't bring much relief. I must
> add that I'm technically inclined, just lack a background in low-level
> (PC) hardware programming.
>
> So far my quest has revealed the following:
> My 2 tunercards both get assigned a unique GSI on PCI interrupt A.
> Both cards get detected correctly, but as soon as the second card
> starts initialising the front-end it fails due to read/write timeouts
> on the  saa7146 (i2c).
> The interrupt counter assigned to the second card never shows any
> activity (cat /proc/interrupts counter for irq 17 is 0).
>
> Here are the (most) relevant pieces of dmesg output:
> First the PCI initialisation. Mind the mentioning of both 0000:05:*
> devices (the riser slots):
>
> [    0.234259] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.234500] pci 0000:00:02.0: reg 10 32bit mmio: [0xdfe80000-0xdfefffff]
> [    0.234520] pci 0000:00:02.0: reg 14 io port: [0xf150-0xf157]
> [    0.234537] pci 0000:00:02.0: reg 18 32bit mmio pref: [0xc0000000-0xcfffffff]
> [    0.234555] pci 0000:00:02.0: reg 1c 32bit mmio: [0xdff00000-0xdff3ffff]
> [    0.234641] pci 0000:00:02.1: reg 10 32bit mmio: [0xdfe00000-0xdfe7ffff]
> [    0.234799] pci 0000:00:1b.0: reg 10 64bit mmio: [0xffe00000-0xffe03fff]
> [    0.234875] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.234889] pci 0000:00:1b.0: PME# disabled
> [    0.235003] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.235016] pci 0000:00:1c.0: PME# disabled
> [    0.235131] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.235144] pci 0000:00:1c.1: PME# disabled
> [    0.235259] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> [    0.235272] pci 0000:00:1c.2: PME# disabled
> [    0.235387] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> [    0.235400] pci 0000:00:1c.3: PME# disabled
> [    0.235488] pci 0000:00:1d.0: reg 20 io port: [0xf0a0-0xf0bf]
> [    0.235578] pci 0000:00:1d.1: reg 20 io port: [0xf080-0xf09f]
> [    0.235669] pci 0000:00:1d.2: reg 20 io port: [0xf060-0xf07f]
> [    0.235759] pci 0000:00:1d.3: reg 20 io port: [0xf040-0xf05f]
> [    0.235856] pci 0000:00:1d.7: reg 10 32bit mmio: [0xdff41000-0xdff413ff]
> [    0.235940] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.235954] pci 0000:00:1d.7: PME# disabled
> [    0.236202] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
> [    0.236221] pci 0000:00:1f.0: quirk: region 0400-047f claimed by
> ICH6 ACPI/GPIO/TCO
> [    0.236236] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
> [    0.236251] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at
> 0a00 (mask 007f)
> [    0.236265] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at
> 1640 (mask 000f)
> [    0.236352] pci 0000:00:1f.1: reg 10 io port: [0xf140-0xf147]
> [    0.236371] pci 0000:00:1f.1: reg 14 io port: [0xf130-0xf133]
> [    0.236390] pci 0000:00:1f.1: reg 18 io port: [0xf120-0xf127]
> [    0.236408] pci 0000:00:1f.1: reg 1c io port: [0xf110-0xf113]
> [    0.236426] pci 0000:00:1f.1: reg 20 io port: [0xf100-0xf10f]
> [    0.236524] pci 0000:00:1f.2: reg 10 io port: [0xf0f0-0xf0f7]
> [    0.236542] pci 0000:00:1f.2: reg 14 io port: [0xf0e0-0xf0e3]
> [    0.236560] pci 0000:00:1f.2: reg 18 io port: [0xf0d0-0xf0d7]
> [    0.236578] pci 0000:00:1f.2: reg 1c io port: [0xf0c0-0xf0c3]
> [    0.236595] pci 0000:00:1f.2: reg 20 io port: [0xf020-0xf03f]
> [    0.236614] pci 0000:00:1f.2: reg 24 32bit mmio: [0xdff40000-0xdff403ff]
> [    0.236668] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.236681] pci 0000:00:1f.2: PME# disabled
> [    0.236765] pci 0000:00:1f.3: reg 20 io port: [0x1180-0x119f]
> [    0.236891] pci 0000:01:00.0: reg 10 io port: [0xe000-0xe0ff]
> [    0.236929] pci 0000:01:00.0: reg 18 64bit mmio pref: [0xffd04000-0xffd04fff]
> [    0.236959] pci 0000:01:00.0: reg 20 64bit mmio pref: [0xffd00000-0xffd03fff]
> [    0.236980] pci 0000:01:00.0: reg 30 32bit mmio pref: [0xdfd00000-0xdfd1ffff]
> [    0.237045] pci 0000:01:00.0: supports D1 D2
> [    0.237055] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.237069] pci 0000:01:00.0: PME# disabled
> [    0.237163] pci 0000:00:1c.0: bridge io port: [0xe000-0xefff]
> [    0.237178] pci 0000:00:1c.0: bridge 32bit mmio: [0xdfd00000-0xdfdfffff]
> [    0.237198] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xffd00000-0xffdfffff]
> [    0.237469] pci 0000:05:00.0: reg 10 32bit mmio: [0xdfc01000-0xdfc011ff]
> [    0.237578] pci 0000:05:08.0: reg 10 32bit mmio: [0xdfc00000-0xdfc001ff]
> [    0.237683] pci 0000:00:1e.0: transparent bridge
> [    0.237700] pci 0000:00:1e.0: bridge 32bit mmio: [0xdfc00000-0xdfcfffff]
> [    0.237750] pci_bus 0000:00: on NUMA node 0
> [    0.237771] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.238344] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
> [    0.238626] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
> [    0.238822] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
> [    0.280835] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [    0.281203] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [    0.281564] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12 14 15)
> [    0.281920] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [    0.282279] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *7 10 11 12 14 15)
> [    0.282640] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11
> 12 14 15) *0, disabled.
> [    0.283003] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11
> 12 14 15) *0, disabled.
> [    0.283367] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
>
> And finally the initialisation of both budget_ci cards, of which only
> the first one succeeds:
> [    9.364122] saa7146: register extension 'budget_ci dvb'.
> [    9.364253] budget_ci dvb 0000:05:00.0: PCI INT A -> GSI 20 (level,
> low) -> IRQ 20
> [    9.364334] IRQ 20/: IRQF_DISABLED is not guaranteed on shared IRQs
> [    9.364417] saa7146: found saa7146 @ mem f8bd0000 (revision 1, irq
> 20) (0x13c2,0x101a).
> [    9.364451] saa7146 (0): dma buffer size 192512
> [    9.364463] DVB: registering new adapter (TT-Budget C-1501 PCI)
> [    9.404001] adapter has MAC addr = 00:d0:5c:cd:53:57
> [    9.405808] input: Budget-CI dvb ir receiver saa7146 (0) as
> /devices/pci0000:00/0000:00:1e.0/0000:05:00.0/input/input7
> [    9.558977] DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
> [    9.559245] budget_ci dvb 0000:05:08.0: PCI INT A -> GSI 17 (level,
> low) -> IRQ 17
> [    9.559339] IRQ 17/: IRQF_DISABLED is not guaranteed on shared IRQs
> [    9.559404] saa7146: found saa7146 @ mem f8dfa000 (revision 1, irq
> 17) (0x13c2,0x101a).
> [    9.559429] saa7146 (1): dma buffer size 192512
> [    9.559438] DVB: registering new adapter (TT-Budget C-1501 PCI)
> [    9.604093] saa7146 (1) saa7146_i2c_writeout [irq]: timed out
> waiting for end of xfer
> [    9.632093] saa7146 (1) saa7146_i2c_writeout [irq]: timed out
> waiting for end of xfer
> [    9.660155] saa7146 (1) saa7146_i2c_writeout [irq]: timed out
> waiting for end of xfer
> [    9.688088] saa7146 (1) saa7146_i2c_writeout [irq]: timed out
> waiting for end of xfer
> [    9.704110] Couldn't read from EEPROM: not there?
> [    9.706068] input: Budget-CI dvb ir receiver saa7146 (1) as
> /devices/pci0000:00/0000:00:1e.0/0000:05:08.0/input/input9
> [    9.716109] saa7146 (1) saa7146_i2c_writeout [irq]: timed out
> waiting for end of xfer
> [    9.744091] saa7146 (1) saa7146_i2c_writeout [irq]: timed out
> waiting for end of xfer
> [    9.772100] saa7146 (1) saa7146_i2c_writeout [irq]: timed out
> waiting for end of xfer
> [    9.800093] saa7146 (1) saa7146_i2c_writeout [irq]: timed out
> waiting for end of xfer
> [    9.816139] DVB: TDA10023(-1): tda10023_writereg, writereg error
> (reg == 0x00, val == 0x33, ret == -5)
> [    9.828080] saa7146 (1) saa7146_i2c_writeout [irq]: timed out
> waiting for end of xfer
> [    9.856084] saa7146 (1) saa7146_i2c_writeout [irq]: timed out
> waiting for end of xfer
> [    9.884088] saa7146 (1) saa7146_i2c_writeout [irq]: timed out
> waiting for end of xfer
> [    9.912084] saa7146 (1) saa7146_i2c_writeout [irq]: timed out
> waiting for end of xfer
> [    9.928117] DVB: TDA10023(-1): tda10023_readreg: readreg error (reg
> == 0x1a, ret == -5)
> [    9.928778] budget-ci: A frontend driver was not found for device
> [1131:7146] subsystem [13c2:101a]
>
> Does anybody have a clue where to start looking? BIOS? (is flashed to
> latest!). PCI initialisation routines (which)? Or is something simply
> missing in the budget_ci code to catch this specific setup?
>
> Regards,
> Martin van Es
> --
> if but was of any use, it would be a logic operator
>



-- 
if but was of any use, it would be a logic operator
