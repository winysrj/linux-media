Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx19.lb01.inode.at ([62.99.145.21] helo=mx.inode.at)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <philipp@kolmann.at>) id 1LM1dJ-0004ml-Gn
	for linux-dvb@linuxtv.org; Sun, 11 Jan 2009 15:49:47 +0100
Message-ID: <496A0704.1090003@kolmann.at>
Date: Sun, 11 Jan 2009 15:49:40 +0100
From: Philipp Kolmann <philipp@kolmann.at>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
References: <1a297b360901091300w6078f926p5efaadeb912e8c03@mail.gmail.com>
In-Reply-To: <1a297b360901091300w6078f926p5efaadeb912e8c03@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
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

Manu Abraham wrote:
> Hi,
>
> Can you all please provide me the following information for the Mantis 
> / Hopper bridge
> based cards that you have in the following manner ?
>
> 1) Card Name (As advertised on the cardboard box):
Don't have the box anymore, but that's was was on the Ordering email:

*TERRATEC Cinergy C PCI bulk*

>
> 2) lspci -vvn:

philipp@chief:~$ lspci -s 05:01.0
05:01.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI 
Bridge Controller [Ver 1.0] (rev 01)
philipp@chief:~$ lspci -s 05:01.0 -vvn
05:01.0 0480: 1822:4e35 (rev 01)
        Subsystem: 153b:1178
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 3
        Region 0: Memory at dfeff000 (32-bit, prefetchable) [size=4K]
        Kernel modules: mantis



>
> 3) Chips on the card if you know them (only the basic chip description 
> is required,
> not the complete batch no. etc)

If needed, I can pull it out of the box. But currently I am writing this 
mail ;)

thanks
Philipp

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
