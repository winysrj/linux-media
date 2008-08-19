Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.172])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oscarmax3@gmail.com>) id 1KVYg7-0005Px-0N
	for linux-dvb@linuxtv.org; Tue, 19 Aug 2008 23:23:48 +0200
Received: by ug-out-1314.google.com with SMTP id q7so764127uge.16
	for <linux-dvb@linuxtv.org>; Tue, 19 Aug 2008 14:23:42 -0700 (PDT)
Message-ID: <48AB3A52.8010305@gmail.com>
Date: Tue, 19 Aug 2008 23:25:38 +0200
From: Carl Oscar Ejwertz <oscarmax3@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Twinhan AD-TP300 (3030) Mantis .. Help needed..
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

Hello!

I have this DVB-T card in my ubuntu htpc box but cannot get it to work.
I've tried diffrent kinds of drivers and no luck.. my best hopes are on 
some guys drivers called Manu - he has Mantis drivers that are almost 
working for this card. The problem are after compiling the lastest hg 
is  that it doesn't create a Frontend0 in the /dev/dvb/adapter0. I get 
the dvr0, mux0 and the others. I wonder if anyone have any solution for 
this and can assist me in getting this card to work.

I get this from lspci -vvv

01:06.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI 
Bridge Controller [Ver 1.0] (rev 01)
    Subsystem: Twinhan Technology Co. Ltd Unknown device 0024
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 32 (2000ns min, 63750ns max)
    Interrupt: pin A routed to IRQ 10
    Region 0: Memory at ea000000 (32-bit, prefetchable) [size=4K]

Many thanks

Oscar



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
