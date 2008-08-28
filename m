Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oscarmax3@gmail.com>) id 1KYkyZ-0001l7-0Q
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 19:08:03 +0200
Received: by ug-out-1314.google.com with SMTP id q7so1506507uge.16
	for <linux-dvb@linuxtv.org>; Thu, 28 Aug 2008 10:07:58 -0700 (PDT)
Message-ID: <48B6DBC9.7020300@gmail.com>
Date: Thu, 28 Aug 2008 19:09:29 +0200
From: Carl Oscar Ejwertz <oscarmax3@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Twinhan VP-3030 Mantis card help
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

Hi!

I have this Twinhan dvb-t VP-3030 Mantis card that im trying to get to
work with Linux.
I have compiled the drivers from I dl with hg clone
http://*jusst*.de/hg/mantis <http://jusst.de/hg/mantis>
and did a make install.

I do get some success with it that it creates some of the devices in the
/dev/dvb/adapter0 get created like
ca0, demux0, dvr0 and net0 - but no frontend0 is created and I suspect
that is the problem since when I do a
dvbscan it says "Failed to open frontend"

dmesg | grep mantis
[   46.115937] mantis_alloc_buffers (0): DMA=0x1f490000 cpu=0xdf490000
size=65536
[   46.115943] mantis_alloc_buffers (0): RISC=0x1e5a3000 cpu=0xde5a3000
size=1000
[   46.632033] mantis_ca_init (0): Registering EN50221 device
[   46.667981] mantis_ca_init (0): Registered EN50221 device
[   46.667991] mantis_hif_init (0): Adapter(0) Initializing Mantis Host
Interface


lspci -vvvnn
01:06.0 Multimedia controller [0480]: Twinhan Technology Co. Ltd Mantis
DTV PCI Bridge Controller [Ver 1.0] [1822:4e35] (rev 01)
    Subsystem: Twinhan Technology Co. Ltd Unknown device [1822:0024]
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 32 (2000ns min, 63750ns max)
    Interrupt: pin A routed to IRQ 20
    Region 0: Memory at ea000000 (32-bit, prefetchable) [size=4K]

So any pointer to getting this card to work under my ubuntu would be great!




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
