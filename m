Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 78.218.95.91.static.ter-s.siw.siwnet.net ([91.95.218.78]
	helo=gw) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <magnus@alefors.se>) id 1JfYwb-0006Ub-HW
	for linux-dvb@linuxtv.org; Sat, 29 Mar 2008 12:09:59 +0100
Received: from [192.168.0.10] (aria.alefors.se [192.168.0.10])
	by gw (Postfix) with ESMTP id 0524115A8B
	for <linux-dvb@linuxtv.org>; Sat, 29 Mar 2008 12:09:47 +0100 (CET)
Message-ID: <47EE237B.4000903@alefors.se>
Date: Sat, 29 Mar 2008 12:09:47 +0100
From: =?UTF-8?B?TWFnbnVzIEjDtnJsaW4=?= <magnus@alefors.se>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] No reception on VP-2033
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

Hi. I'm running the http://www.jusst.de/hg/mantis code from mars 19 on a 
2.6.22 kernel and can't get any reception on my AD-CP300. I find it a 
little strange that both tda10021 and 10023 are loaded by the mantis 
module. Is that ok?

I would really appreciate any help on this.
/Magnus H

scan .czap/se-comhem
scanning .czap/se-comhem
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 362000000 6875000 0 3
 >>> tune to: 362000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64
WARNING: >>> tuning failed!!!
 >>> tune to: 362000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64 (tuning 
failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

lsmod:
mantis                 33284  0
tda10021                7940  1 mantis
tda10023                7428  1 mantis
lnbp21                  3328  1 mantis
mb86a16                21632  1 mantis
stb6100                 8964  1 mantis
stb0899                36480  1 mantis
stv0299                11528  1 mantis
dvb_core               89500  2 mantis,stv0299
i2c_core               26112  11 
mantis,tda10021,tda10023,it87,i2c_isa,lnbp21,mb86a16,stb6100,stb0899,stv0299,i2c_nforce2

dmesg:
[  289.330023] found a VP-2033 PCI DVB-C device on (01:09.0),
[  289.330025]     Mantis Rev 1 [1822:0008], irq: 21, latency: 32
[  289.330028]     memory: 0xe4100000, mmio: 0xf894e000
[  289.332717]     MAC Address=[00:08:ca:1c:2d:b3]
[  289.332747] mantis_alloc_buffers (0): DMA=0x1fbc0000 cpu=0xdfbc0000 
size=65536
[  289.332778] mantis_alloc_buffers (0): RISC=0x1fded000 cpu=0xdfded000 
size=1000
[  289.332804] DVB: registering new adapter (Mantis dvb adapter)
[  289.849341] mantis_frontend_init (0): Probing for CU1216 (DVB-C)
[  289.850762] TDA10021: i2c-addr = 0x0c, id = 0x7d
[  289.850765] mantis_frontend_init (0): found Philips CU1216 DVB-C 
frontend (TDA10021) @ 0x0c
[  289.850791] mantis_frontend_init (0): Mantis DVB-C Philips CU1216 
frontend attach success
[  289.850819] DVB: registering frontend 0 (Philips TDA10021 DVB-C)...

lspci -vvv -s 01:09
01:09.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI 
Bridge Controller [Ver 1.0] (rev 01)
        Subsystem: Twinhan Technology Co. Ltd Unknown device 0008
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort+ <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at e4100000 (32-bit, prefetchable) [size=4K]

lspci -vvn -s 01:09
01:09.0 0480: 1822:4e35 (rev 01)
        Subsystem: 1822:0008
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort+ <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at e4100000 (32-bit, prefetchable) [size=4K]


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
