Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp239.poczta.interia.pl ([217.74.64.239])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mincho@interia.pl>) id 1KZ7Se-0006wU-B4
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 19:08:37 +0200
Received: from poczta.interia.pl (mi02.poczta.interia.pl [10.217.12.2])
	by smtp239.poczta.interia.pl (INTERIA.PL) with ESMTP id 3E7E7D2A87
	for <linux-dvb@linuxtv.org>; Fri, 29 Aug 2008 19:08:26 +0200 (CEST)
Received: from [10.68.0.121] (unknown [81.219.10.162])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTP id 577822BC15D
	for <linux-dvb@linuxtv.org>; Fri, 29 Aug 2008 19:08:26 +0200 (CEST)
Message-ID: <48B82D09.60200@interia.pl>
Date: Fri, 29 Aug 2008 19:08:25 +0200
From: mincho@interia.pl
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48B59989.4080004@interia.pl>	
	<bb72339d0808282125g59a24920o6af8b41ccfa1f15c@mail.gmail.com>	
	<48B7AB83.90802@farba.eu.org>
	<bb72339d0808290347l7732b608idaabad895c2488d7@mail.gmail.com>
In-Reply-To: <bb72339d0808290347l7732b608idaabad895c2488d7@mail.gmail.com>
Subject: Re: [linux-dvb] saa7162. Aver saa7135 cards. User stupid questions.
 More or less.
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

> Hey,
>  If it's detecting and working as the 777 A16AR then it would make
> sense to add it to the existing page, similar to the A16AR/A16D
> Hybrid+FM Page.
>  As to the first question, the 7162 development seemed to be still
> progressing as of last month:
>  http://article.gmane.org/gmane.linux.drivers.dvb/43048
Hey, hey.

Here are few pictures (slow link):
ftp://farba.eu.org//download/AVER777A16A-C.zip

lspci -vv:
01:0a.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
Video Broadcast Decoder (rev d1)
         Subsystem: Avermedia Technologies Inc Unknown device 2c05
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 32
         Interrupt: pin A routed to IRQ 7
         Region 0: Memory at e4000000 (32-bit, non-prefetchable) [size=2K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: saa7134
         Kernel modules: saa7134


And dmesg output:
Aug 29 18:24:23 mincho kernel: saa7130/34: v4l2 driver version 0.2.14 loaded
Aug 29 18:24:23 mincho kernel: saa7133[0]: found at 0000:01:0a.0, rev:
209, irq: 7, latency: 32, mmio: 0xe4000000
Aug 29 18:24:23 mincho kernel: saa7133[0]: subsystem: 1461:2c05, board:
AverTV DVB-T 777 [card=85,autodetected]
Aug 29 18:24:23 mincho kernel: saa7133[0]: board init: gpio is 2e400
Aug 29 18:24:23 mincho kernel: input: saa7134 IR (AverTV DVB-T 777) as
/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/input/input7

Bag your pardon for writing to priv address.

Cheers, cheers.
-- 
WK

---------------------------------------------------------------
Nasilaja sie kradzieze.
Mieszkancy osiedli zaniepokojeni.
Prosimy o pomoc w tej sprawie >>> http://link.interia.pl/f1eef



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
