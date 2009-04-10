Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.30])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <foceni@gmail.com>) id 1LsEkJ-0006c5-E1
	for linux-dvb@linuxtv.org; Fri, 10 Apr 2009 13:18:08 +0200
Received: by yx-out-2324.google.com with SMTP id 8so733962yxm.41
	for <linux-dvb@linuxtv.org>; Fri, 10 Apr 2009 04:18:02 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 Apr 2009 13:18:01 +0200
Message-ID: <621110570904100418r9d7e583j5ae4982a77e9dba9@mail.gmail.com>
From: Dave Lister <foceni@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] SkyStar HD2 (TwinHan VP-1041/Mantis) S2API support
Reply-To: linux-media@vger.kernel.org
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

Hello all,

I'd like to ask for your help. After weeks of research and
deliberation I bought two SkyStar HD2 PCI cards (quite a lot money for
me). It seemed to be working for everybody. BUT I have already spent
two days reading mailing lists, downloading repositories, compiling
drivers, apps, kernels and bending code to make it compile. Please,
does anybody know how to help me?

In short the driver doesn't seem to communicate with the card at all.
It's unable to send DiSEqC commands (not necessary in my case), unable
to tune the tuner, unable to report any signal strength info etc. I
have a dark sense of foreboding about this, because as things stand
now, it seems I'll have to recoup my losses (can't return these cards)
and buy different ones, possibly more expensive. Just these two cost
me half my month's salary. I was so damn sure they'll work - from all
the reports and success stories on the web, even LinuxTV said so. If
you knew my wife... I mean this is going to be a disaster. :(


Drivers tried: http://jusst.de/hg/multiproto,
http://jusst.de/hg/mantis (couldn't make it compile)
Driver used: http://mercurial.intuxication.org/hg/s2-liplianin
Kernels tried w/driver: Debian 2.6.29; Debian 2.6.26; vanilla 2.6.29
DVB apps/utils: 1.1.1+rev1207-4
S2API DVB apps/utils: http://mercurial.intuxication.org/hg/{szap-s2,scan-s2}

lspci -vv:
07:01.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV
PCI Bridge Controller [Ver 1.0] (rev 01)
	Subsystem: Device 1ae4:0003
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort+ <MAbort- >SERR- <PERR+ INTx-
	Latency: 32 (2000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at ec200000 (32-bit, prefetchable) [size=4K]
	Kernel driver in use: Mantis
	Kernel modules: mantis

Boot-up dmesg:
[    6.704959] Mantis 0000:07:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    6.705100] irq: 19, latency: 32
[    6.705101]  memory: 0xec200000, mmio: 0xf8286000
[    6.705183] found a VP-1041 PCI DSS/DVB-S/DVB-S2 device on (07:01.0),
[    6.705228]     Mantis Rev 1 [1ae4:0003], irq: 19, latency: 32
[    6.705261]     memory: 0xec200000, mmio: 0xf8286000
[    6.708020]     MAC Address=[00:08:c9:e0:40:6a]
[    6.708075] mantis_alloc_buffers (0): DMA=0x35d40000 cpu=0xf5d40000
size=65536
[    6.708128] mantis_alloc_buffers (0): RISC=0x36327000
cpu=0xf6327000 size=1000
[    6.708179] DVB: registering new adapter (Mantis dvb adapter)
[    7.253355] stb0899_attach: Attaching STB0899
[    7.253397] mantis_frontend_init (0): found STB0899 DVB-S/DVB-S2
frontend @0x68
[    7.253449] stb6100_attach: Attaching STB6100
[    7.253836] LNBx2x attached on addr=8DVB: registering adapter 0
frontend 0 (STB0899 Multistandard)...
[    7.253938] mantis_ca_init (0): Registering EN50221 device
[    7.254033] mantis_ca_init (0): Registered EN50221 device
[    7.254096] mantis_hif_init (0): Adapter(0) Initializing Mantis
Host Interface

Sat cable has 98% signal, Astra 19.2E, working in a TV/STB sitting
right next to the PC. I reconnect the cable from the TV into SkyStar
and try tuning:

birko:~# scan-s2 -v /usr/share/dvb/dvb-s/Astra-19.2E
API major 5, minor 0
ERROR: Cannot open rotor configuration file 'rotor.conf'.
scanning /usr/share/dvb/dvb-s/Astra-19.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder DVB-S  12551500 V 22000000 5/6 AUTO AUTO
initial transponder DVB-S2 12551500 V 22000000 5/6 AUTO AUTO
----------------------------------> Using DVB-S
>>> tune to: 12551:vC56S0:S0.0W:22000:
DiSEqC: uncommitted switch pos 0
DiSEqC: switch pos 0, 13V, hiband (index 2)
DVB-S IF freq is 1951500
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
----------------------------------> Using DVB-S2
>>> tune to: 12551:vC56S1:S0.0W:22000:
DiSEqC: uncommitted switch pos 0
DiSEqC: switch pos 0, 13V, hiband (index 2)
DVB-S IF freq is 1951500
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

Meanwhile, this is written to dmesg (repeating):
[43395.935293] stb6100_set_bandwidth: Bandwidth=51610000
[43395.943657] stb6100_get_bandwidth: Bandwidth=10000000
[43395.970435] stb6100_get_bandwidth: Bandwidth=10000000
[43396.062102] stb6100_set_frequency: Frequency=1951500
[43396.070464] stb6100_get_frequency: Frequency=0
[43396.084862] stb6100_get_bandwidth: Bandwidth=10000000
[43396.622789] stb6100_set_bandwidth: Bandwidth=51610000
[43396.631150] stb6100_get_bandwidth: Bandwidth=10000000
[43396.657947] stb6100_get_bandwidth: Bandwidth=10000000
[43396.754182] stb6100_set_frequency: Frequency=1951500
[43396.762548] stb6100_get_frequency: Frequency=0
[43396.776884] stb6100_get_bandwidth: Bandwidth=10000000
[43397.314789] stb6100_set_bandwidth: Bandwidth=51610000
[43397.323151] stb6100_get_bandwidth: Bandwidth=10000000
[43397.349932] stb6100_get_bandwidth: Bandwidth=10000000
[43397.442099] stb6100_set_frequency: Frequency=1951500
[43397.450460] stb6100_get_frequency: Frequency=0
[43397.464861] stb6100_get_bandwidth: Bandwidth=10000000
[43398.002788] stb6100_set_bandwidth: Bandwidth=51610000
[43398.011150] stb6100_get_bandwidth: Bandwidth=10000000
[43398.037932] stb6100_get_bandwidth: Bandwidth=10000000
[43398.130098] stb6100_set_frequency: Frequency=1951500
[43398.138459] stb6100_get_frequency: Frequency=0

Szap/szap-s2 also doesn't work. The channel in question is the same
one, being displayed on TV/STB, when I re-plug the sat. cable into the
TV (not changing channels, STB has it locked and as soon as I provide
signal, it works). The STB parallel-story is there for you to see
there are no switching issues, no signal weakness, etc.

birko:~# szap-s2 -c channels.conf CT1
reading channels from file 'channels.conf'
zapping to 3 'CT1':
delivery DVB-S2, modulation QPSK
sat 0, frequency 12382 MHz V, symbolrate 27500000, coderate 3/4, rolloff 0.35
vpid 0x0065, apid 0x006f, sid 0x4f5b
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
FE_SET_TONE failed: Connection timed out
FE_DISEQC_SEND_BURST failed: Connection timed out
FE_SET_TONE failed: Connection timed out
status 00 | signal 006f | snr 0001 | ber 00000000 | unc fffffffe |
status 00 | signal 006f | snr 0001 | ber 00000000 | unc fffffffe |
status 00 | signal 006f | snr 0001 | ber 00000000 | unc fffffffe |
... repeated; same values even if sat. cable disconnected ...

Meanwhile in dmesg:
[43679.573136] mantis start feed & dma
[43679.602799] stb6100_set_bandwidth: Bandwidth=47125000
[43679.611161] stb6100_get_bandwidth: Bandwidth=10000000
[43679.710092] stb6100_set_frequency: Frequency=1782000
[43679.718453] stb6100_get_frequency: Frequency=0
[43680.947291] stb6100_set_bandwidth: Bandwidth=47125000
[43680.955653] stb6100_get_bandwidth: Bandwidth=10000000
[43681.050093] stb6100_set_frequency: Frequency=1782000
[43681.058454] stb6100_get_frequency: Frequency=0
[43682.286788] stb6100_set_bandwidth: Bandwidth=47125000
[43682.295149] stb6100_get_bandwidth: Bandwidth=10000000
[43682.394092] stb6100_set_frequency: Frequency=1782000
[43682.402453] stb6100_get_frequency: Frequency=0
[43683.630788] stb6100_set_bandwidth: Bandwidth=47125000
[43683.639150] stb6100_get_bandwidth: Bandwidth=10000000
[43683.652591] mantis stop feed and dma


What do you think? Is there any chance of finding a working driver?

Thank you,
David Lister

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
