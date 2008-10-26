Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.acc.umu.se ([130.239.18.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <andreas@acc.umu.se>) id 1KuAMe-0004jO-TI
	for linux-dvb@linuxtv.org; Sun, 26 Oct 2008 19:29:26 +0100
Received: from localhost (localhost [127.0.0.1])
	by amavisd-new (Postfix) with ESMTP id 10D1F798
	for <linux-dvb@linuxtv.org>; Sun, 26 Oct 2008 19:29:20 +0100 (MET)
Received: from suiko.acc.umu.se (suiko.acc.umu.se [130.239.18.162])
	by mail.acc.umu.se (Postfix) with ESMTP id 318DA795
	for <linux-dvb@linuxtv.org>; Sun, 26 Oct 2008 19:29:13 +0100 (MET)
Received: from localhost (localhost [127.0.0.1])
	by suiko.acc.umu.se (Postfix) with ESMTP id E48B297
	for <linux-dvb@linuxtv.org>; Sun, 26 Oct 2008 19:29:08 +0100 (CET)
Date: Sun, 26 Oct 2008 19:29:08 +0100 (CET)
From: Andreas Lindkvist <andreas@acc.umu.se>
To: linux-dvb@linuxtv.org
Message-ID: <Pine.LNX.4.64.0810261923340.21924@suiko.acc.umu.se>
MIME-Version: 1.0
Subject: [linux-dvb] Terratec Cinergy C PCI HD
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
Im am trying to get my Cinergy C PCI card to work using the following wiki:

   http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DVB-C

The problem is that I get the following "error" when running 
"modprobe mantis":

   found a UNKNOWN PCI UNKNOWN device on (01:06.0),
       Mantis Rev 1 [153b:0178], irq: 19, latency: 96
       memory: 0xebfff000, mmio: 0xf88fe000
       MAC Address=[ff:ff:ff:ff:ff:ff]

When running lspci i get the following information:

> lspci -v -s 01:06.0

   01:06.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
         Bridge Controller [Ver 1.0] (rev 01)
         Subsystem: TERRATEC Electronic GmbH Device 0178
         Flags: bus master, medium devsel, latency 96, IRQ 19
         Memory at ebfff000 (32-bit, prefetchable) [size=4K]
         Kernel driver in use: Mantis
         Kernel modules: mantis

> lspci -vvn -s 01:06.0

01:06.0 0480: 1822:4e35 (rev 01)
         Subsystem: 153b:0178
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR+ <PERR+ INTx-
         Latency: 96 (2000ns min, 59750ns max)
         Interrupt: pin A routed to IRQ 19
         Region 0: Memory at ebfff000 (32-bit, prefetchable) [size=4K]
         Kernel driver in use: Mantis
         Kernel modules: mantis

which is not the same as the ID on the wiki page:

$ lspci -vvn -s 01:01.0
01:01.0 0480: 1822:4e35 (rev 01)
         Subsystem: 153b:1178
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort+ <MAbort- >SERR- <PERR-
         Latency: 64 (2000ns min, 63750ns max)
         Interrupt: pin A routed to IRQ 22
         Region 0: Memory at cfdff000 (32-bit, prefetchable) [size=4K]

Is this another version of the card not supported by the driver or am I 
missing something or doing something wrong?

I am greatful for any help.

Regards,

   Andreas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
