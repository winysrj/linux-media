Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sonofzev@iinet.net.au>) id 1Jm9TX-0003PA-AE
	for linux-dvb@linuxtv.org; Wed, 16 Apr 2008 17:23:11 +0200
From: allan k <sonofzev@iinet.net.au>
To: Adam Nielsen <a.nielsen@shikadi.net>
In-Reply-To: <48048592.70408@shikadi.net>
References: <37824.1208252766@iinet.net.au>  <48048592.70408@shikadi.net>
Date: Thu, 17 Apr 2008 01:23:24 +1000
Message-Id: <1208359404.21157.4.camel@media1>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvico Fusion HDTV DVB-T dual express - willing
	to	help	test e.t.c...
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

This is the relevant output from lspci -v 


03:00.0 Multimedia video controller: Conexant Unknown device 8852 (rev
02)
	Subsystem: DViCO Corporation Unknown device db78
	Flags: bus master, fast devsel, latency 0, IRQ 21
	Memory at fd600000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: [40] Express Endpoint, MSI 00
	Capabilities: [80] Power Management version 2
	Capabilities: [90] Vital Product Data <?>
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [200] Virtual Channel <?>
	Kernel driver in use: cx23885
	Kernel modules: cx23885

I'm not realy sure what I would need to do from here (I don't really
have any skills in C programming).... 




8-04-15 at 20:38 +1000, Adam Nielsen wrote:
> > I have mistakenly bought a Fusion HDTV DVB-T dual express (cx23885) as a 
> > result of misreading some other posts and sites. I was under the 
> > impression that it would work either from the current kernel source or 
> > using Chris Pascoe's modules.  Unfortunately I didn't realise that the 
> > American and Euro/Australian version were different.
> 
> What are the PCI IDs for the card?  I'm not sure what criteria the 
> driver uses to detect DVB vs ATSC, but I would guess you could tweak the 
> PCI IDs to make the driver detect your card as one of the others that 
> supports DVB and has the same cx23885 chipset.
> 
> Cheers,
> Adam.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
