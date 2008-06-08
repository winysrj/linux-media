Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout11.t-online.de ([194.25.134.85])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <halim.sahin@t-online.de>) id 1K5GTo-0001K6-Hs
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 10:42:27 +0200
Date: Sun, 8 Jun 2008 10:42:17 +0200
From: Halim Sahin <halim.sahin@t-online.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080608084217.GA15568@halim.local>
References: <20080607184758.GA30074@halim.local>
	<200806080029.00312@orion.escape-edv.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200806080029.00312@orion.escape-edv.de>
Subject: Re: [linux-dvb] budget_av,  high cpuload with kncone tvstar
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

Hi Oliver,
Thanks a lot thats it.
I have on emore Question:
dmesg says ci interface initialized but this card has not a ci
connector.
Is there a way to disable ci support completely?
BR.
Halim


On So, Jun 08, 2008 at 12:28:59 +0200, Oliver Endriss wrote:
> Halim Sahin wrote:
> > Hi,
> > 
> > I have one knc one tvstar.
> > After loading budget_av the machine show this:
> > uptime
> >  20:44:58 up 37 min,  2 users,  load average: 0.71, 0.65, 0.67
> > 
> > When I unload the modules the load is 0.00.
> > The machine is a amd athlon x2 1900 mhz.
> > running a i686 kenel 2.6.25 from debian.
> > Here is dmesg output:
> > [ 2044.394304] saa7146: register extension 'budget_av'.
> > [ 2044.394345] ACPI: PCI Interrupt 0000:03:02.0[A] -> GSI 22 (level,
> > low) -> IRQ
> >  22
> > [ 2044.394370] saa7146: found saa7146 @ mem f8a64400 (revision 1, irq
> > 22) (0x189
> > 4,0x0014).
> > [ 2044.394380] saa7146 (0): dma buffer size 192512
> > [ 2044.394384] DVB: registering new adapter (KNC TV STAR DVB-S)
> > [ 2044.398012] adapter failed MAC signature check
> > [ 2044.398020] encoded MAC from EEPROM was
> > ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:f
> > f:ff:ff:ff:ff:ff:ff:ff
> > [ 2044.666029] KNC1-0: MAC addr = 00:09:d6:65:83:60
> > [ 2045.017670] DVB: registering frontend 0 (ST STV0299 DVB-S)...
> > [ 2045.021319] budget-av: ci interface initialised.
> > 
> > thanks for any help.
> > Halim
> 
> See http://linuxtv.org/pipermail/linux-dvb/2008-April/025248.html
> That fix is in the current HG driver, and will be included in 2.6.26.
> 
> CU
> Oliver
> 
> -- 
> ----------------------------------------------------------------
> VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
> ----------------------------------------------------------------
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

-- 
Halim Sahin
E-Mail:				
halim.sahin (at) t-online.de

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
