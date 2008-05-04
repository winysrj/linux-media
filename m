Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1JsjEC-0001qn-QE
	for linux-dvb@linuxtv.org; Sun, 04 May 2008 20:46:30 +0200
From: Andy Walls <awalls@radix.net>
To: Wayne and Holly <wayneandholly@woosh.co.nz>
In-Reply-To: <000001c8ada6$4a24a0f0$fd01a8c0@speedy>
References: <000001c8ada6$4a24a0f0$fd01a8c0@speedy>
Date: Sun, 04 May 2008 14:45:48 -0400
Message-Id: <1209926748.3208.86.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Geniatech DVB-S Digistar
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sun, 2008-05-04 at 17:18 +1200, Wayne and Holly wrote:
> > > I also have a Twinhan 1020a installed and it works with no problems
> > > whatsoever (no skips at all), is there any chance that 
> > having the two
> > > cards installed could be part of the problem?
> > 
> > Maybe, if they now have to share the same PCI bus segments to 
> > the CPU and RAM.
> >
> 
> 
> Is there anything I can do about this?  It is always the Geniatech that
> is effected, never the Twinhan.  Is it likely to be this?

What I was getting at was that a PCI bus segment is a shared resource,
able to transfer, optimistically, at a maximum rate of 4*33MHz = 132
MB/s (not MiB/s).  Ideally, when one adds a card to the system, one
needs to compute the burst times and interburst latencies required and
achievable for each card at a *system level*, and then set them
accordingly.  In Windows this isn't usually really necessary, but Linux
can keep the PCI bus very busy.

As you said in your previous post, your processor speed and system
memory probably meet or exceed the data handling requirements.  My
thought is that you likely need to tune the IO bottleneck (PCI Bus), to
get satisfactory performance from all the devices.  My reasoning is that
it's probably easier to open up a spreadsheet and check the timing
budgets on your PCI bus segments and make sure they're OK, than to
analyze the Genitech card or linux driver for performance problems.

> > 
> > > Below are the lspci and dmesg outputs relevant to the Geniatech:
> > > 
> > > 
> > > >From lspci -vnn
> > > 
> > > 01:06.0 Multimedia video controller [0400]: Conexant 
> > CX23880/1/2/3 PCI 
> > > Video and Audio Decoder [14f1:8800] (rev 05)
> > >         Subsystem: Conexant Unknown device [14f1:0084]
> > >         Flags: bus master, medium devsel, latency 20, IRQ 18
> > >         Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
> > >         Capabilities: [44] Vital Product Data
> > >         Capabilities: [4c] Power Management version 2
> > 
> > A latency timer of 20 cycles is pretty low, especially when 
> > you consider the case when this card becomes a bus master, a 
> > target is initially allowed to hold-off for up to 16 cycles 
> > if it is not ready.
> > 
> > Use the setpci command line tool to bump this device's 
> > latency timer up to 64 or 80 or 160 (or some other multiple 
> > of 8) and see if things improve.
> > 
> 
> 
> Thanks for that Andy, much appreciated.  I have tried setting the
> latency_timer to a bunch of different hex values
> (0,14,20,30,40,a0,a8,f0) and none of them fix the problem. In fact, the
> higher values appeared to make the problem worse.  

You're welcome.  Too bad, there goes the simple fix.  I suppose things
may have gotten worse, because of MAX_LAT for the card not being
satisfied once you upped the latency timer.

I noticed that the card has a MAX_LAT of 13750ns.  This means that the
manufacturer specifies that this master should  be allowed to start a
data burst at least every 13750ns/250ns * 8 PCI bus cycles = 440 PCI bus
cycles (or it may be that many bus cycles from the end of one burst to
the start of the next - I think manufacturers screw this up at times).
This number thus says something about how long other devices should be
allowed to hold the bus (i.e. other latency timers in the system).  You
can safely assume round robin PCI bus arbitration between devices,
unless you know you have a special PCI bus arbiter.

If The device bursts for 160 cycles, but then needs to start another
burst in 440 cycles, that only leaves 280 cycles for other devices.
What this says, I think, is that this card wants 160/440 = 36.3% of the
PCI bus segment bandwidth under worst case conditions.


For comparison, my PVR-150 has a MAX_LAT of 1024 PCI bus cycles and a
MIN_GNT of 64 cycles or 64/1024 = 6.25 % of the bus bandwidth.  My
HVR-1600 has a MAX_LAT of 1600 PCI bus cycles and (supposedly) a MIN_GNT
of 16 cycles or 16/1600 = 1% of the bus bandwidth.  So compared to these
cards, your Genitech needs to get back on the PCI bus to burst data a
bit more frequently.


How long is the MAX_LAT for your Twinhan card?


> > Also, you could reduce the timer value for cards that have 
> > large timer values (nVidia cards are often set at the maximum of 248).
> 
> 
> Interestingly, the two TV cards are the only two devices that don't have
> the latency set to 0, including the onboard nVidia.  Does 0 actually
> mean 0 or is it perhaps a maximum value?  I haven't fiddled with these
> yet.

The PCI spec requires devices with programmable latency timers to be set
to 0 after assertion of RST (reset).  If you have timers that are 0, it
may be that nothing ever set their value or that they are read-only
hardwired to 0.  As for the behavior if it is set to 0:

>From section 3.5.4 of the PCI spec:

"In essence, the value programmed into the Latency Timer represents a minimum guaranteed
number of clocks allotted to the master, after which it must surrender tenure as soon as
possible after its GNT# is deasserted. The actual duration of a transaction (assuming its
GNT# is deasserted) can be from a minimum of the Latency Timer value plus one clock to a
maximum of the Latency Timer value plus the number of clocks required to complete an
entire cacheline transfer (unless the target asserts STOP#)."

So a latency timer value of 0, is supposed to mean a master is only
guaranteed to be able to transfer 1 clock cycle's worth of data - 4
bytes - in a burst.

The above applies for PCI, PCIe is likely different in some ways.

> 
> > And looking at you second e-mail you sent on this matter I see:
> > 
> > "Latency: 20 (5000ns min, 13750ns max)"
> > 
> > MIN_GRANT is 5000ns, and for the purposes of MIN_GRANT, 8 PCI 
> > cycles are approximated as 250 ns.  5000 ns / 250 ns/8 PCI 
> > cycles = 160 PCI cycles is the minimum grant specified by the 
> > vendor for the latency timer for this device, not 20 PCI cycles.
> 
> 
> I noticed that the Twinhan has a similar minimum latency (4000ns) to the
> Geniatech yet it only has a latency of 16 (decimal) and it works fine.

Be glad.  The Twinhan may rarely need all 4000/(250/8) = 128 bus clocks
to transfer its data burst.  Or the manufacturer could have specified a
value that was too high for MIN_GNT.

Here's an example of where a manufacturer appears to have screwed up. My
PVR-150 has strange values for MIN_GNT and MAX_LAT:

02:02.0 Multimedia video controller: Internext Compression Inc iTVC16 (CX23416) MPEG-2 Encoder (rev 01)
        Subsystem: Hauppauge computer works Inc. WinTV PVR 150
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (32000ns min, 2000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at dc000000 (32-bit, prefetchable) [size=64M]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 44 44 16 00 06 00 10 02 01 00 00 04 08 40 00 00
                                 Latency---^^
10: 08 00 00 dc 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 70 00 01 88
30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 01 80 08
                     MIN_GNT and MAX_LAT -----^^^^^

It looks like Hauppauge programmed MIN_GNT and MAX_LAT backwards.
8*0x08 = 64 is a good value for the latency timer on this card, but the
card says MIN_GNT should be 0x80*8 = 1024 cycles (or approximately
32000ns), a value that can't be specified in the 8 bit latency timer
field. :)



> Should the math instead be 5000ns/250ns = 20 which is the original
> latency set?

No, latency timer is set in units of PCI bus clocks at 33 MHz (i.e. ~ 30
ns).  5000ns * 33 MHz = 165 cycles.  Remember that the 5000 ns is an
approximate number assuming 8 pci bus cycles are 250 ns instead of the
actual 8 cycles/33MHz = 242 ns

Here's the PCI spec, if you'd like to verify for yourself:

http://rm-f.net/~orange/devel/specifications/pci/pci_lb3.0-2-6-04.pdf

See section 6.2.4 for definitions of values for Latency Timer, MIN_GNT,
and MAX_LAT.  (N.B. MAX_LAT  is latency between bursts in units of 8
clocks, Latency Timer is maximum length of a burst in units of clocks.)

Also see all of section 3.5.


> Cheers
> Wayne


Sorry, if the above discussion doesn't help you get your Geniatech card
working.  At least you should be able to eliminate if it's a PCI bus
timing budget problem and then look to other causes.

Good luck,
Andy




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
