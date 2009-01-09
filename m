Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1LLR7Y-0006UX-0r
	for linux-dvb@linuxtv.org; Sat, 10 Jan 2009 00:50:35 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: Hans Werner <HWerner4@gmx.de>
In-Reply-To: <20090109224606.225290@gmx.net>
References: <1a297b360901091300w6078f926p5efaadeb912e8c03@mail.gmail.com>
	<20090109224606.225290@gmx.net>
Date: Sat, 10 Jan 2009 00:49:09 +0100
Message-Id: <1231544949.2621.3.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] Mantis users
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

Hi,

Am Freitag, den 09.01.2009, 23:46 +0100 schrieb Hans Werner:
> > Hi,
> > 
> > Can you all please provide me the following information for the Mantis /
> > Hopper bridge
> > based cards that you have in the following manner ?
> > 
> > 1) Card Name (As advertised on the cardboard box):
> 
> Azurewave AD-SP 400
> 
> > 2) lspci -vvn:
> 
> 04:00.0 0480: 1822:4e35 (rev 01)
>         Subsystem: 1822:0031
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32 (2000ns min, 63750ns max)
>         Interrupt: pin A routed to IRQ 21
>         Region 0: Memory at 99100000 (32-bit, prefetchable) [size=4K]
> 
> > 3) Chips on the card if you know them (only the basic chip description is
> > required,
> > not the complete batch no. etc)
> 
> Mantis K62323.1A-2
> STB0899
> STB6100
> 20-pin chip under heatsink (LNBP21?)

that one seems to always come with an eight pin
ST(micro) EZb.16 something, which is not an eeprom ;)

just my two cents

> Portek PTK8706 18-pin 8-bit microcontroller
> 402B2GLI 8-pin
> Nikos N2576 5-pin Voltage Regulator
> 
> Regards,
> Hans
> 
> > 
> > 
> > Regards,
> > Manu
> 


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
