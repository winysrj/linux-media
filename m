Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 78.218.95.91.static.ter-s.siw.siwnet.net ([91.95.218.78]
	helo=gw) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <magnus@alefors.se>) id 1JmvhR-0005Tl-Pf
	for linux-dvb@linuxtv.org; Fri, 18 Apr 2008 20:52:42 +0200
Received: from [192.168.0.10] (aria.alefors.se [192.168.0.10])
	by gw (Postfix) with ESMTP id 138E7158A4
	for <linux-dvb@linuxtv.org>; Fri, 18 Apr 2008 20:52:34 +0200 (CEST)
Message-ID: <4808EDF2.3060002@alefors.se>
Date: Fri, 18 Apr 2008 20:52:34 +0200
From: =?UTF-8?B?TWFnbnVzIEjDtnJsaW4=?= <magnus@alefors.se>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] No frontend on VP-2040
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

Hi. I just bought six Azurewave AD-CP400's (VP-2040) since I thought 
they should work after reading this list (for years). The fact that they 
suddenly dropped in price made me a little worried though. It has 
happend (many times) before that I have bought a new unsupported 
revision of a previously supported DVB card. And this time it seems to 
have happened again. If you want I can give you one of them, Manu. Or 
what can I do to help?
/Magnus H

dmesg:
[   37.707361] found a UNKNOWN PCI UNKNOWN device on (01:05.0),
[   37.707363]     Mantis Rev 1 [1822:0043], irq: 21, latency: 64
[   37.707365]     memory: 0xdfeff000, mmio: 0xf8928000

ls /dev/dvb/adapter0:
ca0  demux0  dvr0  net0

lspci -vvn:
01:05.0 0480: 1822:4e35 (rev 01)
         Subsystem: 1822:0043
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (2000ns min, 63750ns max)
         Interrupt: pin A routed to IRQ 21
         Region 0: Memory at dfeff000 (32-bit, prefetchable) [size=4K]


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
