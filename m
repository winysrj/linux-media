Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sonofzev@iinet.net.au>) id 1Jnwuk-0005jy-6N
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 16:22:39 +0200
From: allan k <sonofzev@iinet.net.au>
To: bumkunjo@gmx.de
In-Reply-To: <200804201259.56890.bumkunjo@gmx.de>
References: <37824.1208252766@iinet.net.au> <48048592.70408@shikadi.net>
	<1208359404.21157.4.camel@media1> <200804201259.56890.bumkunjo@gmx.de>
Date: Tue, 22 Apr 2008 00:22:40 +1000
Message-Id: <1208787760.9790.4.camel@media1>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvico Fusion HDTV DVB-T dual express -
	willing	to	help	test e.t.c...
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

Hi 

I'm not sure what else I need to do, a couple of people have offered to
help but I think everyone's been a bit too busy. 

There is basic support for the cx23885 chip, and there appears to be
full support for the atsc version of this card but not for dvb. The
modules all load without error etc but it just appears to be trying to
tune to the wrong standard. It doesn't look like much work needs to be
done but I don't have the relevant skills to do so. 

If you wish I can email you some login details to access my machine so
you don't have to buy the card yourself, but there are times during the
day when I use this machine. Of course I imagine it may be easier to
have the card on hand. I believe the European and Australian cards are
the same. 

cheers

Allan   



On Sun, 2008-04-20 at 12:59 +0200, bumkunjo@gmx.de wrote:
> Have you or someone else made any progress with this card yet?
> If there's basic support by a driver I would  buy it too and help to support 
> improving the driver but I'm confused by the wiki information and your posts.
> 
> > This is the relevant output from lspci -v
> >
> >
> > 03:00.0 Multimedia video controller: Conexant Unknown device 8852 (rev
> > 02)
> > 	Subsystem: DViCO Corporation Unknown device db78
> > 	Flags: bus master, fast devsel, latency 0, IRQ 21
> > 	Memory at fd600000 (64-bit, non-prefetchable) [size=2M]
> > 	Capabilities: [40] Express Endpoint, MSI 00
> > 	Capabilities: [80] Power Management version 2
> > 	Capabilities: [90] Vital Product Data <?>
> > 	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
> > Enable-
> > 	Capabilities: [100] Advanced Error Reporting <?>
> > 	Capabilities: [200] Virtual Channel <?>
> > 	Kernel driver in use: cx23885
> > 	Kernel modules: cx23885
> >
> > I'm not realy sure what I would need to do from here (I don't really
> > have any skills in C programming)....
> >
> > 8-04-15 at 20:38 +1000, Adam Nielsen wrote:
> > > > I have mistakenly bought a Fusion HDTV DVB-T dual express (cx23885) as
> > > > a result of misreading some other posts and sites. I was under the
> > > > impression that it would work either from the current kernel source or
> > > > using Chris Pascoe's modules.  Unfortunately I didn't realise that the
> > > > American and Euro/Australian version were different.
> > >
> > > What are the PCI IDs for the card?  I'm not sure what criteria the
> > > driver uses to detect DVB vs ATSC, but I would guess you could tweak the
> > > PCI IDs to make the driver detect your card as one of the others that
> > > supports DVB and has the same cx23885 chipset.
> > >
> > > Cheers,
> > > Adam.
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
