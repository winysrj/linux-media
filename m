Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ptb-relay01.plus.net ([212.159.14.212])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@adslpipe.co.uk>) id 1KDk3A-0008I7-KT
	for linux-dvb@linuxtv.org; Tue, 01 Jul 2008 19:53:58 +0200
Received: from [84.92.25.126] (helo=[192.168.1.100])
	by ptb-relay01.plus.net with esmtp (Exim) id 1KDk2a-0008D9-Vs
	for linux-dvb@linuxtv.org; Tue, 01 Jul 2008 18:53:21 +0100
Message-ID: <486A6F0F.7090507@adslpipe.co.uk>
Date: Tue, 01 Jul 2008 18:53:19 +0100
From: Andy Burns <linux-dvb@adslpipe.co.uk>
MIME-Version: 1.0
To: Linux DVB List <linux-dvb@linuxtv.org>
Subject: [linux-dvb] saa7134 ioremap() problem
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

I have been using the saa7134.ko and saa7134_dvb.ko drivers for years as 
part of my mythtv system, working very nicely.

Now I am trying to use xen to virtualise my mythtv-backend, with PCI 
passthrough of the tuner to the virtual machine, everything hasn't gone 
smoothly, but I believe I have found an issue within the driver which 
would have gone un-noticed on a bare-metal machine, yet which causes a 
problem under xen.

Here is what lspci -vvv shows for my card

08:01.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
Broadcast Decoder (rev 01)
         Subsystem: Compro Technology, Inc. Videomate DVB-T200
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 64 (21000ns min, 8000ns max)
         Interrupt: pin A routed to IRQ 17
         Region 0: Memory at febffc00 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [40] Power Management version 1
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
         Kernel modules: saa7134

Notice the MMIO area is 1K in size, but within the driver, it requests 
mapping of a 4K area, rather than 1K.

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=blob;f=drivers/media/video/saa7134/saa7134-core.c;h=58ab163fdbd74e628e60655ea05c5d3bea611599;hb=HEAD#l998

Obviously the kernel will have to round the start/end addresses to the 
nearest 4K boundaries as this is the granularity of page mapping, but if 
the request is too large to begin with it attempts to map two pages, 
straddling the card's physical address range, this works on a physical 
machine, but fails under xen due to more rigourous checking/enforcement 
of permissions.

I have rebuilt the driver module using 0x400 instead of 0x1000 for the 
ioremap() size and the driver then loads, instead of failing (I still 
have an interrupt problem but will follow that up separately).

If you'd like to follow the discussion I've been having on the xen-devel 
list, Keir Fraser should be able to answer questions on why this fails 
under xen far better than I can.

http://lists.xensource.com/archives/html/xen-devel/2008-07/msg00004.html

Could you comment on whether you'd accept a patch for this?


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
