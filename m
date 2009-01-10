Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1LLYbf-0000eO-Lo
	for linux-dvb@linuxtv.org; Sat, 10 Jan 2009 08:50:09 +0100
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1LLYba-0005Me-Jr
	for linux-dvb@linuxtv.org; Sat, 10 Jan 2009 07:50:02 +0000
Received: from rain.gmane.org ([80.91.229.7])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sat, 10 Jan 2009 07:50:02 +0000
Received: from thomas by rain.gmane.org with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sat, 10 Jan 2009 07:50:02 +0000
To: linux-dvb@linuxtv.org
From: =?ISO-8859-15?Q?Thomas_M=FCller?= <thomas@mathtm.de>
Date: Sat, 10 Jan 2009 08:42:18 +0100
Message-ID: <gk9jgq$6u5$1@ger.gmane.org>
References: <1a297b360901091300w6078f926p5efaadeb912e8c03@mail.gmail.com>
Mime-Version: 1.0
In-Reply-To: <1a297b360901091300w6078f926p5efaadeb912e8c03@mail.gmail.com>
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

Hi :)

Manu Abraham schrieb:
> Can you all please provide me the following information for the Mantis /
> Hopper bridge
> based cards that you have in the following manner ?
> 
> 1) Card Name (As advertised on the cardboard box):

TerraTec Cinergy S2 PCI HD
http://www.terratec.net/de/produkte/Cinergy_S2_PCI_HD_2335.html
http://www.terratec.net/en/products/Cinergy_S2_PCI_HD_2336.html


> 2) lspci -vvn:

07:02.0 0480: 1822:4e35 (rev 01)
	Subsystem: 153b:1179
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at e3000000 (32-bit, prefetchable) [size=4K]
	Kernel driver in use: Mantis
	Kernel modules: mantis


> 3) Chips on the card if you know them (only the basic chip description
> is required,
> not the complete batch no. etc)
> 
no idea, but if necessary I could remove the card from the case and have a look...


Regards,
Thomas


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
