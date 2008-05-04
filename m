Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail.woosh.co.nz ([202.74.207.2] helo=mail2.woosh.co.nz)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <wayneandholly@woosh.co.nz>) id 1JsWd8-0003wD-0f
	for linux-dvb@linuxtv.org; Sun, 04 May 2008 07:19:23 +0200
Received: from speedy (203-211-106-230.ue.woosh.co.nz [203.211.106.230]) by
	woosh.co.nz
	(Rockliffe SMTPRA 6.1.22) with ESMTP id <B0116656564@mail2.woosh.co.nz>
	for <linux-dvb@linuxtv.org>; Sun, 4 May 2008 17:18:46 +1200
From: "Wayne and Holly" <wayneandholly@woosh.co.nz>
To: <linux-dvb@linuxtv.org>
Date: Sun, 4 May 2008 17:18:29 +1200
Message-ID: <000001c8ada6$4a24a0f0$fd01a8c0@speedy>
MIME-Version: 1.0
In-Reply-To: <1209853537.9347.45.camel@palomino.walls.org>
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


> > I also have a Twinhan 1020a installed and it works with no problems
> > whatsoever (no skips at all), is there any chance that 
> having the two
> > cards installed could be part of the problem?
> 
> Maybe, if they now have to share the same PCI bus segments to 
> the CPU and RAM.
>


Is there anything I can do about this?  It is always the Geniatech that
is effected, never the Twinhan.  Is it likely to be this?

> 
> > Below are the lspci and dmesg outputs relevant to the Geniatech:
> > 
> > 
> > >From lspci -vnn
> > 
> > 01:06.0 Multimedia video controller [0400]: Conexant 
> CX23880/1/2/3 PCI 
> > Video and Audio Decoder [14f1:8800] (rev 05)
> >         Subsystem: Conexant Unknown device [14f1:0084]
> >         Flags: bus master, medium devsel, latency 20, IRQ 18
> >         Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
> >         Capabilities: [44] Vital Product Data
> >         Capabilities: [4c] Power Management version 2
> 
> A latency timer of 20 cycles is pretty low, especially when 
> you consider the case when this card becomes a bus master, a 
> target is initially allowed to hold-off for up to 16 cycles 
> if it is not ready.
> 
> Use the setpci command line tool to bump this device's 
> latency timer up to 64 or 80 or 160 (or some other multiple 
> of 8) and see if things improve.
> 


Thanks for that Andy, much appreciated.  I have tried setting the
latency_timer to a bunch of different hex values
(0,14,20,30,40,a0,a8,f0) and none of them fix the problem. In fact, the
higher values appeared to make the problem worse.  

> Also, you could reduce the timer value for cards that have 
> large timer values (nVidia cards are often set at the maximum of 248).


Interestingly, the two TV cards are the only two devices that don't have
the latency set to 0, including the onboard nVidia.  Does 0 actually
mean 0 or is it perhaps a maximum value?  I haven't fiddled with these
yet.


> And looking at you second e-mail you sent on this matter I see:
> 
> "Latency: 20 (5000ns min, 13750ns max)"
> 
> MIN_GRANT is 5000ns, and for the purposes of MIN_GRANT, 8 PCI 
> cycles are approximated as 250 ns.  5000 ns / 250 ns/8 PCI 
> cycles = 160 PCI cycles is the minimum grant specified by the 
> vendor for the latency timer for this device, not 20 PCI cycles.


I noticed that the Twinhan has a similar minimum latency (4000ns) to the
Geniatech yet it only has a latency of 16 (decimal) and it works fine.
Should the math instead be 5000ns/250ns = 20 which is the original
latency set?

Cheers
Wayne


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
