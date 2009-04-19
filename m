Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057AbZDSIEf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2009 04:04:35 -0400
Date: Sun, 19 Apr 2009 01:03:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-media@vger.kernel.org
Cc: Alejandro =?ISO-8859-1?Q?V=E9lez?= <null274@gmail.com>
Subject: Fw: PROBLEM: crashes or unstability while watching tv with MPlayer
 from  pci bttv card
Message-Id: <20090419010302.55987a5a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Begin forwarded message:

Date: Wed, 15 Apr 2009 06:31:46 -0500
From: Alejandro Vélez <null274@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: crashes or unstability while watching tv with MPlayer from  pci bttv card


[1.] One line summary of the problem:

General system unstability occurs while previewing any video input
from the pci bttv-card with MPlayer SVN.

[2.] Full description of the problem/report:

after a time of watching or previewing the tv card input with MPlayer
the system becomes irreversibly unstable, for example the kernel can
crash in a different number of ways all the times that that I have
reproduced such behavior or the system just lockups with the caps lock
and scroll lock leds blinking.

[3.] Keywords (i.e., modules, networking, kernel):

kernel, crashes, lockups, unstability, MPlayer, Hauppauge WinTV-Go,
bttv, X11, bttv.

[4.] Kernel version (from /proc/version):

Linux version 2.6.29.1-smp (root@midas) (gcc version 4.3.3 (GCC) ) #1
SMP Fri Apr 10 18:42:54 CDT 2009

[5.] Output of Oops.. message (if applicable) with symbolic
information resolved (see Documentation/oops-tracing.txt)

Not Applicable. There's a different type of kernel crash if there's it
at all everytime that I reproduce the bug.

[6.] A small shell script or example program which triggers the
problem (if possible)

I just preview the tv input with the command: mplayer tv:// -tv input=1:normid=0

[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux slacktoo 2.6.29.1-smp #1 SMP Fri Apr 10 18:42:54 CDT 2009 i686
Unknown CPU Type AuthenticAMD GNU/Linux

Gnu C                  4.2.3
Gnu make               3.81
binutils               2.17.50.0.17.20070615
util-linux             2.13.1
mount                  2.13.1
module-init-tools      found
quota-tools            3.13.
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Linux C++ Library      6.0.9
Procps                 3.2.7
Kbd                    1.12
oprofile               0.9.2
Sh-utils               6.9
udev                   118
Modules Loaded         savage drm bsd_comp ppp_synctty ppp_async
crc_ccitt ppp_generic slhc it87 hwmon_vid snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss ipt_MASQUERADE
xt_limit xt_pkttype ipt_REJECT xt_tcpudp xt_state ipt_LOG
iptable_mangle iptable_nat iptable_filter nf_conntrack_irc nf_nat_ftp
nf_nat nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
ip_tables x_tables nls_utf8 ntfs xfs exportfs quota_v2 quota_tree lp
fuse tuner_simple tuner_types tuner tvaudio fan snd_cs4232
snd_wavefront snd_wss_lib ns558 snd_opl3_lib snd_hwdep bttv snd_mpu401
ir_common i2c_algo_bit v4l2_common thermal parport_pc videodev parport
v4l1_compat serio_raw processor thermal_sys hwmon videobuf_dma_sg
videobuf_core evdev psmouse button rtc_cmos rtc_core rtc_lib
snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm snd_timer
snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device snd
soundcore btcx_risc uhci_hcd via_agp tveeprom i2c_viapro shpchp
agpgart sundance i2c_core 8139too mii sg ext3 jbd mbcache

[7.2.] Processor information (from /proc/cpuinfo):

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 8
model name      : Unknown CPU Type
stepping        : 1
cpu MHz         : 1673.954
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow up
bogomips        : 3347.90
clflush size    : 32
power management: ts

[7.3.] Module information (from /proc/modules):

savage 30940 2 - Live 0xe6ccb000
drm 137824 3 savage, Live 0xe6ae7000
bsd_comp 5244 0 - Live 0xe6f2e000
ppp_synctty 6940 0 - Live 0xe6eca000
ppp_async 8668 1 - Live 0xe6de5000
crc_ccitt 1628 1 ppp_async, Live 0xe6ddd000
ppp_generic 22472 7 bsd_comp,ppp_synctty,ppp_async, Live 0xe6d88000
slhc 5404 1 ppp_generic, Live 0xe6d6d000
it87 19820 0 - Live 0xe6d51000
hwmon_vid 2684 1 it87, Live 0xe6d4e000
snd_seq_dummy 2464 0 - Live 0xe6cc6000
snd_seq_oss 29792 0 - Live 0xe6ca3000
snd_seq_midi_event 5980 1 snd_seq_oss, Live 0xe6c8e000
snd_seq 47984 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event, Live 0xe6a67000
snd_pcm_oss 37728 0 - Live 0xe683e000
snd_mixer_oss 14300 1 snd_pcm_oss, Live 0xe6812000
ipt_MASQUERADE 2460 1 - Live 0xe897a000
xt_limit 1824 3 - Live 0xe8885000
xt_pkttype 1372 1 - Live 0xe886d000
ipt_REJECT 2780 8 - Live 0xe8659000
xt_tcpudp 2620 40 - Live 0xe852f000
xt_state 1756 7 - Live 0xe84f4000
ipt_LOG 5344 13 - Live 0xe84d8000
iptable_mangle 2332 0 - Live 0xe843b000
iptable_nat 4796 1 - Live 0xe8415000
iptable_filter 2268 1 - Live 0xe83f0000
nf_conntrack_irc 4800 0 - Live 0xe83e5000
nf_nat_ftp 2492 0 - Live 0xe83db000
nf_nat 16208 3 ipt_MASQUERADE,iptable_nat,nf_nat_ftp, Live 0xe83c2000
nf_conntrack_ftp 6880 1 nf_nat_ftp, Live 0xe83b6000
nf_conntrack_ipv4 12520 10 iptable_nat,nf_nat, Live 0xe839f000
nf_conntrack 53844 8
ipt_MASQUERADE,xt_state,iptable_nat,nf_conntrack_irc,nf_nat_ftp,nf_nat,nf_conntrack_ftp,nf_conntrack_ipv4,
Live 0xe830c000
nf_defrag_ipv4 1532 1 nf_conntrack_ipv4, Live 0xe70a6000
ip_tables 10860 3 iptable_mangle,iptable_nat,iptable_filter, Live 0xe82f4000
x_tables 13280 9
ipt_MASQUERADE,xt_limit,xt_pkttype,ipt_REJECT,xt_tcpudp,xt_state,ipt_LOG,iptable_nat,ip_tables,
Live 0xe82e8000
nls_utf8 1472 1 - Live 0xe6f93000
ntfs 220320 1 - Live 0xe7db7000
xfs 521320 1 - Live 0xe7278000
exportfs 3964 1 xfs, Live 0xe6cc8000
quota_v2 3324 2 - Live 0xe6cbb000
quota_tree 8284 1 quota_v2, Live 0xe6c9e000
lp 9316 0 - Live 0xe6c7d000
fuse 53976 1 - Live 0xe6a79000
tuner_simple 14288 1 - Live 0xe6a61000
tuner_types 13884 1 tuner_simple, Live 0xe6a54000
tuner 27620 0 - Live 0xe6a31000
tvaudio 26332 0 - Live 0xe6a0c000
fan 4064 0 - Live 0xe6a06000
snd_cs4232 11956 0 - Live 0xe6875000
snd_wavefront 51444 0 - Live 0xe684b000
snd_wss_lib 23996 2 snd_cs4232,snd_wavefront, Live 0xe6829000
ns558 4156 0 - Live 0xe680e000
snd_opl3_lib 9212 2 snd_cs4232,snd_wavefront, Live 0xe71e3000
snd_hwdep 6816 2 snd_wavefront,snd_opl3_lib, Live 0xe71cd000
bttv 191828 0 - Live 0xe7247000
snd_mpu401 6152 0 - Live 0xe71aa000
ir_common 39872 1 bttv, Live 0xe7189000
i2c_algo_bit 5504 1 bttv, Live 0xe7178000
v4l2_common 14268 3 tuner,tvaudio,bttv, Live 0xe715a000
thermal 15096 0 - Live 0xe714a000
parport_pc 24004 1 - Live 0xe712f000
videodev 38688 4 tuner,tvaudio,bttv,v4l2_common, Live 0xe70f2000
parport 30700 2 lp,parport_pc, Live 0xe706c000
v4l1_compat 13184 1 videodev, Live 0xe704c000
serio_raw 5024 0 - Live 0xe7036000
processor 38568 2 thermal, Live 0xe6fdd000
thermal_sys 10756 3 fan,thermal,processor, Live 0xe6fc1000
hwmon 2104 2 it87,thermal_sys, Live 0xe6fa9000
videobuf_dma_sg 10784 1 bttv, Live 0xe6fa1000
videobuf_core 15520 2 bttv,videobuf_dma_sg, Live 0xe6f95000
evdev 9152 4 - Live 0xe6f6a000
psmouse 41676 0 - Live 0xe6ebd000
button 5708 0 - Live 0xe6e43000
rtc_cmos 10124 0 - Live 0xe6e0e000
rtc_core 15992 1 rtc_cmos, Live 0xe6dbf000
rtc_lib 2332 1 rtc_core, Live 0xe6db4000
snd_via82xx 22772 1 - Live 0xe6d76000
gameport 9864 3 ns558,snd_via82xx, Live 0xe6d58000
snd_ac97_codec 100128 1 snd_via82xx, Live 0xe6d0c000
ac97_bus 1372 1 snd_ac97_codec, Live 0xe6ce4000
snd_pcm 68128 5 snd_pcm_oss,snd_wss_lib,snd_via82xx,snd_ac97_codec,
Live 0xe6b8b000
snd_timer 19108 4 snd_seq,snd_wss_lib,snd_opl3_lib,snd_pcm, Live 0xe6b1f000
snd_page_alloc 7972 3 snd_wss_lib,snd_via82xx,snd_pcm, Live 0xe6b0f000
snd_mpu401_uart 6524 4
snd_cs4232,snd_wavefront,snd_mpu401,snd_via82xx, Live 0xe6ae3000
snd_rawmidi 19040 2 snd_wavefront,snd_mpu401_uart, Live 0xe6aa0000
snd_seq_device 6088 5
snd_seq_dummy,snd_seq_oss,snd_seq,snd_opl3_lib,snd_rawmidi, Live
0xe6a91000
snd 50820 18 snd_seq_oss,snd_seq,snd_pcm_oss,snd_mixer_oss,snd_cs4232,snd_wavefront,snd_wss_lib,snd_opl3_lib,snd_hwdep,snd_mpu401,snd_via82xx,snd_ac97_codec,snd_pcm,snd_timer,snd_mpu401_uart,snd_rawmidi,snd_seq_device,
Live 0xe6a3e000
soundcore 5824 1 snd, Live 0xe6a14000
btcx_risc 4196 1 bttv, Live 0xe6a02000
uhci_hcd 22284 0 - Live 0xe6817000
via_agp 7900 1 - Live 0xe7217000
tveeprom 11808 1 bttv, Live 0xe720c000
i2c_viapro 7440 0 - Live 0xe71fe000
shpchp 31888 0 - Live 0xe71d4000
agpgart 29256 2 drm,via_agp, Live 0xe7116000
sundance 19808 0 - Live 0xe70c5000
i2c_core 20496 9
drm,tuner_simple,tuner,tvaudio,bttv,i2c_algo_bit,v4l2_common,tveeprom,i2c_viapro,
Live 0xe70a8000
8139too 22780 0 - Live 0xe7044000
mii 4380 2 sundance,8139too, Live 0xe7032000
sg 24432 0 - Live 0xe701f000
ext3 126020 2 - Live 0xe6e69000
jbd 42416 1 ext3, Live 0xe685d000
mbcache 6496 1 ext3, Live 0xe680a000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

/proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0073 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:11.1
  0170-0177 : via82cxxx
01f0-01f7 : 0000:00:11.1
  01f0-01f7 : via82cxxx
0201-0201 : ns558-pnp
0290-0297 : pnp 00:02
  0295-0296 : it87
    0295-0296 : it87
02f8-02ff : serial
0330-0331 : MPU401 UART
0376-0376 : 0000:00:11.1
  0376-0376 : via82cxxx
0378-037a : parport0
03c0-03df : vesafb
03f2-03f2 : floppy
03f4-03f5 : floppy
03f6-03f6 : 0000:00:11.1
  03f6-03f6 : via82cxxx
03f7-03f7 : floppy
03f8-03ff : serial
04d0-04d1 : pnp 00:02
0800-0805 : pnp 00:02
0cf8-0cff : PCI conf1
4000-4003 : ACPI PM1a_EVT_BLK
4008-400b : ACPI PM_TMR
4010-4015 : ACPI CPU throttle
4020-4023 : ACPI GPE0_BLK
40f0-40f1 : ACPI PM1a_CNT_BLK
5000-5007 : vt596_smbus
c000-c007 : 0000:00:08.0
c400-c403 : 0000:00:08.0
c800-c807 : 0000:00:08.0
cc00-cc03 : 0000:00:08.0
d000-d00f : 0000:00:08.0
d400-d47f : 0000:00:09.0
  d400-d47f : sundance
d800-d8ff : 0000:00:0e.0
  d800-d8ff : 8139too
dc00-dc0f : 0000:00:11.1
  dc00-dc0f : via82cxxx
e000-e01f : 0000:00:11.2
  e000-e01f : uhci_hcd
e400-e41f : 0000:00:11.3
  e400-e41f : uhci_hcd
e800-e8ff : 0000:00:11.5
  e800-e8ff : VIA8233A

/proc/iomem
00000000-0000ffff : reserved
00010000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cbfff : Video ROM
000cc000-000d07ff : Adapter ROM
000d0800-000d3fff : pnp 00:00
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-25feffff : System RAM
  00100000-0040ea82 : Kernel code
  0040ea83-00577507 : Kernel data
  005da000-00636e23 : Kernel bss
25ff0000-25ff2fff : ACPI Non-volatile Storage
25ff3000-25ffffff : ACPI Tables
30000000-3007ffff : 0000:00:08.0
30080000-3008ffff : 0000:00:09.0
d0000000-d7ffffff : 0000:00:00.0
d8000000-dfffffff : PCI Bus 0000:01
  d8000000-dfffffff : 0000:01:00.0
    d8000000-d9eeffff : vesafb
e0000000-e1ffffff : PCI Bus 0000:01
  e0000000-e000ffff : 0000:01:00.0
  e1000000-e107ffff : 0000:01:00.0
e3000000-e30001ff : 0000:00:08.0
  e3000000-e30001ff : sata_sil
e3001000-e30011ff : 0000:00:09.0
  e3001000-e30011ff : sundance
e3002000-e3002fff : 0000:00:0a.0
  e3002000-e3002fff : bttv0
e3003000-e3003fff : 0000:00:0a.1
e3004000-e30040ff : 0000:00:0e.0
  e3004000-e30040ff : 8139too
fec00000-fec00fff : IOAPIC 0
  fec00000-fec00fff : reserved
    fec00000-fec00fff : pnp 00:00
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:00
fff80000-fffeffff : pnp 00:00
ffff0000-ffffffff : reserved
  ffff0000-ffffffff : pnp 00:00

[7.5.] PCI information ('lspci -vvv' as root)

00:00.0 Host bridge: VIA Technologies, Inc. VT8375 [KM266/KL266] Host Bridge
	Subsystem: Elitegroup Computer Systems Unknown device 0a76
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 8
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=128M]
	Capabilities: [a0] AGP version 2.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit-
FW- AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP+ GART64- 64bit- FW- Rate=x4
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: agpgart-via
	Kernel modules: via-agp

00:01.0 PCI bridge: VIA Technologies, Inc. VT8633 [Apollo Pro266 AGP]
(prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR+ INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: e0000000-e1ffffff
	Prefetchable memory behind bridge: d8000000-dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: shpchp

00:08.0 Mass storage controller: Silicon Image, Inc. SiI 3112
[SATALink/SATARaid] Serial ATA Controller (rev 02)
	Subsystem: Silicon Image, Inc. SiI 3112 SATALink Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at c000 [size=8]
	Region 1: I/O ports at c400 [size=4]
	Region 2: I/O ports at c800 [size=8]
	Region 3: I/O ports at cc00 [size=4]
	Region 4: I/O ports at d000 [size=16]
	Region 5: Memory at e3000000 (32-bit, non-prefetchable) [size=512]
	[virtual] Expansion ROM at 30000000 [disabled] [size=512K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-
	Kernel driver in use: sata_sil

00:09.0 Ethernet controller: Sundance Technology Inc / IC Plus Corp IC
Plus IP100A Integrated 10/100 Ethernet MAC + PHY (rev 31)
	Subsystem: Sundance Technology Inc / IC Plus Corp Unknown device 0201
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort+
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2500ns min, 2500ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at d400 [size=128]
	Region 1: Memory at e3001000 (32-bit, non-prefetchable) [size=512]
	[virtual] Expansion ROM at 30080000 [disabled] [size=64K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable+ DSel=0 DScale=2 PME-
	Kernel driver in use: sundance
	Kernel modules: sundance

00:0a.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
	Subsystem: Hauppauge computer works Inc. WinTV Series
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (4000ns min, 10000ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at e3002000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data <?>
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: bttv
	Kernel modules: bttv

00:0a.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 11)
	Subsystem: Hauppauge computer works Inc. WinTV Series
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at e3003000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data <?>
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: snd-bt87x

00:0e.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. RT8139
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at d800 [size=256]
	Region 1: Memory at e3004000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: 8139too
	Kernel modules: 8139too, 8139cp

00:11.0 ISA bridge: VIA Technologies, Inc. VT8233A ISA Bridge
	Subsystem: Elitegroup Computer Systems Unknown device 0a76
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping+ SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: i2c-viapro, via-ircc

00:11.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
(prog-if 8a [Master SecP PriP])
	Subsystem: VIA Technologies, Inc.
VT82C586/B/VT82C686/A/B/VT8233/A/C/VT8235 PIPC Bus Master IDE
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin A routed to IRQ 23
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	Region 4: I/O ports at dc00 [size=16]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: VIA_IDE
	Kernel modules: pata_via

00:11.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 23) (prog-if 00 [UHCI])
	Subsystem: First International Computer, Inc. VA-502 Mainboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin D routed to IRQ 21
	Region 4: I/O ports at e000 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:11.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 23) (prog-if 00 [UHCI])
	Subsystem: First International Computer, Inc. VA-502 Mainboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin D routed to IRQ 21
	Region 4: I/O ports at e400 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:11.5 Multimedia audio controller: VIA Technologies, Inc.
VT8233/A/8235/8237 AC97 Audio Controller (rev 40)
	Subsystem: Elitegroup Computer Systems Unknown device 0a76
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 22
	Region 0: I/O ports at e800 [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: VIA 82xx Audio
	Kernel modules: snd-via82xx

01:00.0 VGA compatible controller: S3 Inc. VT8375 [ProSavage8
KM266/KL266] (prog-if 00 [VGA controller])
	Subsystem: Elitegroup Computer Systems Unknown device 0a76
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1000ns min, 63750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at e1000000 (32-bit, non-prefetchable) [size=512K]
	Region 1: Memory at d8000000 (32-bit, prefetchable) [size=128M]
	[virtual] Expansion ROM at e0000000 [disabled] [size=64K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] AGP version 2.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA- ITACoh- GART64- HTrans- 64bit-
FW- AGP3- Rate=x4
		Command: RQ=32 ArqSz=0 Cal=0 SBA- AGP+ GART64- 64bit- FW- Rate=x4
	Kernel modules: savagefb

[7.6.] SCSI information (from /proc/scsi/scsi)

Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: SAMSUNG HD250HJ  Rev: FH10
  Type:   Direct-Access                    ANSI  SCSI revision: 05

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

[X.] Other notes, patches, fixes, workarounds:

Note that I havent noticed any crash If I do the same action while X11
isnt running, i.e. trying to view TV input under the text console. the
same kind of behavior had happened me with different kernel versions
and even with a different tv card brand based in the bt8x8 chip
distributions: Xubuntu 8.04 and 8.10, Slackware 12.1 and 12.2
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
