Return-path: <linux-media-owner@vger.kernel.org>
Received: from tempsmtp2.alltele.net ([79.138.0.61]:54787 "EHLO
	tempsmtp2.alltele.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275AbaFLRXe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:23:34 -0400
Received: from localhost (tempsmtp2.alltele.net [127.0.0.1])
	by tempsmtp2.alltele.net (Postfix) with ESMTP id F372320389
	for <linux-media@vger.kernel.org>; Thu, 12 Jun 2014 19:00:06 +0200 (CEST)
Received: from tempsmtp2.alltele.net ([127.0.0.1])
	by localhost (tempsmtp.alltele.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7HjC38nyIHh9 for <linux-media@vger.kernel.org>;
	Thu, 12 Jun 2014 19:00:01 +0200 (CEST)
Received: from smtp.alltele.net (smtp.alltele.net [85.30.0.4])
	by tempsmtp2.alltele.net (Postfix) with ESMTPS id CCA5020061
	for <linux-media@vger.kernel.org>; Thu, 12 Jun 2014 18:59:59 +0200 (CEST)
Received: from MacBook-Pro-de-Thierry-Coton.local ([78.51.19.2])
        by smtp.alltele.net (IceWarp 11.0.0.3) with ASMTP id 201406121913121531
        for <linux-media@vger.kernel.org>; Thu, 12 Jun 2014 19:13:12 +0200
Message-ID: <5399DFA6.6000904@free.fr>
Date: Thu, 12 Jun 2014 19:13:10 +0200
From: Thierry Coton <tcoton@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: 046d:0896 [Acer Aspire 5630] Orbicam not working
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have been asked to post on this mailing list about an annoying 
integrated webcam issue, please find details below:

I have installed latest version available 3.15-0-031500-generic for 
testing purpose as current distribution kernel did not work and result 
is not convincing.

The main issue is that integrated webcam does not work.

First time I launched guvcview, nothing happened as usual, no video 
window and no camera working. Program closed

I then launched Skype which did exactly the same apart of the camera led 
which was "on" this time but no video working. When I quit Skype, the 
led shut down then shortly blinked after ca. 15 sec.

Back to guvcview, the camera worked straight away. So, I closed it and 
started Skype and video did not work.

When I quit and open Skype again, it does not work anymore neither with 
guvcview.

Back to Skype, the LED is "on" but no video... (on /dev/video0). I quit 
Skype, restart it and this time no video and no LED...

Reboot-----> Skype = no video nor LED --> Quit

Guvcview = no video nor LED --> Quit

Skype = LED but no video --> Quit (LED blink when closing video options)

Guvcview = video fully working -->Quit

Skype = no video nor LED.... --> Quit

Guvcview = the same --> Quit

Skype = LED but no video --> Quit (LED blink when closing video options)

Guvcview = video working --> Quit

Skype = no video nor LED --> Quit

Guvcview = video working --> Quit

Skype = LED but no video --> Quit (LED blink when closing video options)

Skype = no video nor LED --> Quit

So it looks too random for a normal human to use the webcam!



Technical data:

cat /proc/version = Linux version 3.15.0-031500-generic (apw@gomeisa) 
(gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201406081435 SMP 
Sun Jun 8 18:56:41 UTC 2014


lsb_release -rd = Description:    Ubuntu 14.04 LTS  Release: 14.04

/usr/src/linux-headers-3.15.0-031500-generic/scripts/ver_linux = sh: 0: 
can't open ver_linux

cat /proc/cpuinfo =

processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Core(TM)2 CPU         T5500  @ 1.66GHz
stepping    : 6
microcode    : 0x48
cpu MHz        : 1333.000
cache size    : 2048 KB
physical id    : 0
siblings    : 2
core id        : 0
cpu cores    : 2
apicid        : 0
initial apicid    : 0
fdiv_bug    : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl 
est tm2 ssse3 cx16 xtpr pdcm lahf_lm dtherm
bogomips    : 3324.91
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Core(TM)2 CPU         T5500  @ 1.66GHz
stepping    : 6
microcode    : 0x48
cpu MHz        : 1000.000
cache size    : 2048 KB
physical id    : 0
siblings    : 2
core id        : 1
cpu cores    : 2
apicid        : 1
initial apicid    : 1
fdiv_bug    : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl 
est tm2 ssse3 cx16 xtpr pdcm lahf_lm dtherm
bogomips    : 3324.91
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

cat /proc/modules =

ctr 13025 2 - Live 0x00000000
ccm 17562 2 - Live 0x00000000
bnep 19107 2 - Live 0x00000000
rfcomm 59300 0 - Live 0x00000000
bluetooth 401303 10 bnep,rfcomm, Live 0x00000000
6lowpan_iphc 18480 1 bluetooth, Live 0x00000000
snd_hda_codec_realtek 65688 1 - Live 0x00000000
snd_hda_codec_generic 63743 2 snd_hda_codec_realtek, Live 0x00000000
snd_hda_intel 29400 1 - Live 0x00000000
gspca_vc032x 31460 0 - Live 0x00000000
coretemp 13358 0 - Live 0x00000000
snd_hda_controller 30246 1 snd_hda_intel, Live 0x00000000
gspca_main 28077 1 gspca_vc032x, Live 0x00000000
arc4 12509 2 - Live 0x00000000
snd_hda_codec 121022 4 
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_controller, 
Live 0x00000000
videodev 122550 2 gspca_vc032x,gspca_main, Live 0x00000000
snd_hwdep 13276 1 snd_hda_codec, Live 0x00000000
snd_pcm 96792 3 snd_hda_intel,snd_hda_controller,snd_hda_codec, Live 
0x00000000
iwl3945 64660 0 - Live 0x00000000
snd_seq_midi 13324 0 - Live 0x00000000
iwlegacy 88297 1 iwl3945, Live 0x00000000
mac80211 573480 2 iwl3945,iwlegacy, Live 0x00000000
snd_seq_midi_event 14475 1 snd_seq_midi, Live 0x00000000
snd_rawmidi 25518 1 snd_seq_midi, Live 0x00000000
acer_wmi 32140 0 - Live 0x00000000
microcode 19509 0 - Live 0x00000000
sparse_keymap 13658 1 acer_wmi, Live 0x00000000
snd_seq 56978 2 snd_seq_midi,snd_seq_midi_event, Live 0x00000000
snd_seq_device 14137 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x00000000
cfg80211 435387 3 iwl3945,iwlegacy,mac80211, Live 0x00000000
pcmcia 56297 0 - Live 0x00000000
snd_timer 29035 2 snd_pcm,snd_seq, Live 0x00000000
joydev 17311 0 - Live 0x00000000
snd 61616 12 
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer, 
Live 0x00000000
soundcore 12600 2 snd_hda_codec,snd, Live 0x00000000
serio_raw 13251 0 - Live 0x00000000
parport_pc 32154 0 - Live 0x00000000
lpc_ich 17000 0 - Live 0x00000000
yenta_socket 44635 0 - Live 0x00000000
ppdev 17423 0 - Live 0x00000000
pcmcia_rsrc 18495 1 yenta_socket, Live 0x00000000
irda 108061 0 - Live 0x00000000
lp 13359 0 - Live 0x00000000
pcmcia_core 22396 3 pcmcia,yenta_socket,pcmcia_rsrc, Live 0x00000000
crc_ccitt 12627 1 irda, Live 0x00000000
wmi 18843 1 acer_wmi, Live 0x00000000
parport 40945 3 parport_pc,ppdev,lp, Live 0x00000000
mac_hid 13099 0 - Live 0x00000000
video 19348 1 acer_wmi, Live 0x00000000
psmouse 97425 0 - Live 0x00000000
sdhci_pci 18677 0 - Live 0x00000000
b44 39820 0 - Live 0x00000000
sdhci 38093 1 sdhci_pci, Live 0x00000000
ssb 56649 1 b44, Live 0x00000000
mii 13693 1 b44, Live 0x00000000


cat /proc/ioports =
0000-0cf7 : PCI Bus 0000:00
   0000-001f : dma1
   0020-0021 : pic1
   0040-0043 : timer0
   0050-0053 : timer1
   0060-0060 : keyboard
   0062-0062 : EC data
   0064-0064 : keyboard
   0066-0066 : EC cmd
   0070-0077 : rtc0
   0080-008f : dma page reg
   00a0-00a1 : pic2
   00c0-00df : dma2
   00f0-00ff : fpu
   0170-0177 : 0000:00:1f.2
     0170-0177 : ata_piix
   01f0-01f7 : 0000:00:1f.2
     01f0-01f7 : ata_piix
   0376-0376 : 0000:00:1f.2
     0376-0376 : ata_piix
   03c0-03df : vga+
   03f6-03f6 : 0000:00:1f.2
     03f6-03f6 : ata_piix
   0800-080f : pnp 00:05
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
   1000-1003 : ACPI PM1a_EVT_BLK
   1004-1005 : ACPI PM1a_CNT_BLK
   1008-100b : ACPI PM_TMR
   1010-1015 : ACPI CPU throttle
   1020-1020 : ACPI PM2_CNT_BLK
   1028-102f : ACPI GPE0_BLK
   1030-1033 : iTCO_wdt
   1060-107f : iTCO_wdt
   1180-11bf : 0000:00:1f.0
     1180-11bf : pnp 00:05
   1640-164f : pnp 00:05
   2000-2fff : PCI Bus 0000:02
   3000-3fff : PCI Bus 0000:03
   4000-4fff : PCI Bus 0000:04
   50a0-50bf : 0000:00:1d.0
     50a0-50bf : uhci_hcd
   50c0-50df : 0000:00:1d.1
     50c0-50df : uhci_hcd
   50e0-50ff : 0000:00:1d.2
     50e0-50ff : uhci_hcd
   5400-541f : 0000:00:1d.3
     5400-541f : uhci_hcd
   5420-543f : 0000:00:1f.3
   5440-544f : 0000:00:1f.2
     5440-544f : ata_piix
   6000-6fff : PCI Bus 0000:05
   7000-7fff : PCI Bus 0000:06
     7000-70ff : PCI CardBus 0000:07
     7400-74ff : PCI CardBus 0000:07
   fe00-fefe : pnp 00:05
   ff2c-ff2f : pnp 00:05


cat /proc/iomem =

00000000-00000fff : reserved
00001000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
   000a0000-000bffff : Video RAM area
000c0000-000cdfff : Video ROM
000ce000-000cffff : reserved
000d0000-000d3fff : PCI Bus 0000:00
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000dffff : PCI Bus 0000:00
000e0000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-7fe7ffff : System RAM
   01000000-016ad158 : Kernel code
   016ad159-01a36dff : Kernel data
   01b1c000-01c00fff : Kernel bss
7fe80000-7fefffff : ACPI Non-volatile Storage
7ff00000-7fffffff : reserved
80000000-febfffff : PCI Bus 0000:00
   80000000-83ffffff : PCI Bus 0000:06
     80000000-83ffffff : PCI CardBus 0000:07
   84000000-841fffff : PCI Bus 0000:02
   84200000-843fffff : PCI Bus 0000:02
   84400000-845fffff : PCI Bus 0000:03
   84600000-847fffff : PCI Bus 0000:03
   84800000-849fffff : PCI Bus 0000:04
   84a00000-84bfffff : PCI Bus 0000:04
   84c00000-84dfffff : PCI Bus 0000:05
   88000000-88000fff : 0000:06:04.0
     88000000-88000fff : yenta_socket
   8c000000-8fffffff : PCI CardBus 0000:07
   cd000000-ceffffff : PCI Bus 0000:01
     cd000000-cdffffff : 0000:01:00.0
     ce000000-ceffffff : 0000:01:00.0
   d0000000-dfffffff : PCI Bus 0000:01
     d0000000-dfffffff : 0000:01:00.0
   e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
     e0000000-efffffff : reserved
       e0000000-efffffff : pnp 00:00
   f0200000-f02fffff : PCI Bus 0000:06
     f0200000-f0201fff : 0000:06:01.0
       f0200000-f0201fff : b44
     f0202000-f02020ff : 0000:06:04.4
       f0202000-f02020ff : mmc1
     f0203000-f020307f : 0000:06:04.1
     f0203400-f02034ff : 0000:06:04.2
       f0203400-f02034ff : mmc0
     f0203800-f020387f : 0000:06:04.3
   f0300000-f03fffff : PCI Bus 0000:05
     f0300000-f0300fff : 0000:05:00.0
       f0300000-f0300fff : iwl3945
   f0400000-f0403fff : 0000:00:1b.0
     f0400000-f0403fff : ICH HD audio
   f0404000-f04043ff : 0000:00:1d.7
     f0404000-f04043ff : ehci_hcd
fec00000-fec0ffff : reserved
   fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
   fed00000-fed003ff : reserved
     fed00000-fed003ff : pnp 00:03
fed14000-fed19fff : reserved
   fed14000-fed17fff : pnp 00:00
   fed18000-fed18fff : pnp 00:00
   fed19000-fed19fff : pnp 00:00
fed1c000-fed8ffff : reserved
   fed1c000-fed1ffff : pnp 00:00
     fed1f410-fed1f414 : iTCO_wdt
   fed20000-fed3ffff : pnp 00:00
fee00000-fee00fff : Local APIC
   fee00000-fee00fff : reserved
ff000000-ffffffff : reserved


sudo lspci -vvv =

00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML 
and 945GT Express Memory Controller Hub (rev 03)
     Subsystem: Acer Incorporated [ALI] Device 0090
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
     Latency: 0
     Capabilities: [e0] Vendor Specific Information: Len=09 <?>

00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML 
and 945GT Express PCI Express Root Port (rev 03) (prog-if 00 [Normal 
decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
     I/O behind bridge: 0000f000-00000fff
     Memory behind bridge: cd000000-ceffffff
     Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [88] Subsystem: Acer Incorporated [ALI] Device 0090
     Capabilities: [80] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0300c  Data: 4181
     Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0
             ExtTag- RBE-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1, Exit 
Latency L0s <256ns, L1 <4us
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- 
Surprise-
             Slot #1, PowerLimit 75.000W; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Off, PwrInd On, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
             Changed: MRL- PresDet+ LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed+ WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
             Status:    NegoPending- InProgress-
     Capabilities: [140 v1] Root Complex Link
         Desc:    PortNumber=02 ComponentID=01 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=01 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed19000
     Kernel driver in use: pcieport

00:1b.0 Audio device: Intel Corporation NM10/ICH7 Family High Definition 
Audio Controller (rev 02)
     Subsystem: Acer Incorporated [ALI] Device 0090
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 46
     Region 0: Memory at f0400000 (64-bit, non-prefetchable) [size=16K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000fee0300c  Data: 4152
     Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, 
MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0
             ExtTag- RBE-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
             Status:    NegoPending- InProgress-
         VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=1 ArbSelect=Fixed TC/VC=80
             Status:    NegoPending- InProgress-
     Capabilities: [130 v1] Root Complex Link
         Desc:    PortNumber=0f ComponentID=02 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed1c000
     Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 
1 (rev 02) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
     I/O behind bridge: 00002000-00002fff
     Memory behind bridge: 84000000-841fffff
     Prefetchable memory behind bridge: 0000000084200000-00000000843fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0
             ExtTag- RBE-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit 
Latency L0s <1us, L1 <4us
             ClockPM- Surprise- LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surprise+
             Slot #2, PowerLimit 6.500W; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- 
Interlock-
             Changed: MRL- PresDet- LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0300c  Data: 41a1
     Capabilities: [90] Subsystem: Acer Incorporated [ALI] Device 0090
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed+ WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending- InProgress-
         VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable- ID=0 ArbSelect=Fixed TC/VC=00
             Status:    NegoPending- InProgress-
     Capabilities: [180 v1] Root Complex Link
         Desc:    PortNumber=01 ComponentID=02 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed1c001
     Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 
2 (rev 02) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
     I/O behind bridge: 00003000-00003fff
     Memory behind bridge: 84400000-845fffff
     Prefetchable memory behind bridge: 0000000084600000-00000000847fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0
             ExtTag- RBE-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit 
Latency L0s <1us, L1 <4us
             ClockPM- Surprise- LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surprise+
             Slot #3, PowerLimit 6.500W; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- 
Interlock-
             Changed: MRL- PresDet- LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0300c  Data: 41b1
     Capabilities: [90] Subsystem: Acer Incorporated [ALI] Device 0090
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed+ WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending- InProgress-
         VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable- ID=0 ArbSelect=Fixed TC/VC=00
             Status:    NegoPending- InProgress-
     Capabilities: [180 v1] Root Complex Link
         Desc:    PortNumber=02 ComponentID=02 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed1c001
     Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 
3 (rev 02) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
     I/O behind bridge: 00004000-00004fff
     Memory behind bridge: 84800000-849fffff
     Prefetchable memory behind bridge: 0000000084a00000-0000000084bfffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0
             ExtTag- RBE-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit 
Latency L0s <1us, L1 <4us
             ClockPM- Surprise- LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surprise+
             Slot #4, PowerLimit 6.500W; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- 
Interlock-
             Changed: MRL- PresDet- LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0300c  Data: 41c1
     Capabilities: [90] Subsystem: Acer Incorporated [ALI] Device 0090
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed+ WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending- InProgress-
         VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable- ID=0 ArbSelect=Fixed TC/VC=00
             Status:    NegoPending- InProgress-
     Capabilities: [180 v1] Root Complex Link
         Desc:    PortNumber=03 ComponentID=02 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed1c001
     Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 
4 (rev 02) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
     I/O behind bridge: 00006000-00006fff
     Memory behind bridge: f0300000-f03fffff
     Prefetchable memory behind bridge: 0000000084c00000-0000000084dfffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0
             ExtTag- RBE-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit 
Latency L0s <256ns, L1 <4us
             ClockPM- Surprise- LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surprise+
             Slot #5, PowerLimit 6.500W; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
             Changed: MRL- PresDet- LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0300c  Data: 41d1
     Capabilities: [90] Subsystem: Acer Incorporated [ALI] Device 0090
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed+ WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
             Status:    NegoPending- InProgress-
         VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable- ID=0 ArbSelect=Fixed TC/VC=00
             Status:    NegoPending- InProgress-
     Capabilities: [180 v1] Root Complex Link
         Desc:    PortNumber=04 ComponentID=02 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed1c001
     Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI 
Controller #1 (rev 02) (prog-if 00 [UHCI])
     Subsystem: Acer Incorporated [ALI] Device 0090
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 23
     Region 4: I/O ports at 50a0 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.1 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI 
Controller #2 (rev 02) (prog-if 00 [UHCI])
     Subsystem: Acer Incorporated [ALI] Device 0090
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 19
     Region 4: I/O ports at 50c0 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.2 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI 
Controller #3 (rev 02) (prog-if 00 [UHCI])
     Subsystem: Acer Incorporated [ALI] Device 0090
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin C routed to IRQ 18
     Region 4: I/O ports at 50e0 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.3 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI 
Controller #4 (rev 02) (prog-if 00 [UHCI])
     Subsystem: Acer Incorporated [ALI] Device 0090
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin D routed to IRQ 16
     Region 4: I/O ports at 5400 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.7 USB controller: Intel Corporation NM10/ICH7 Family USB2 EHCI 
Controller (rev 02) (prog-if 20 [EHCI])
     Subsystem: Acer Incorporated [ALI] Device 0090
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 23
     Region 0: Memory at f0404000 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Debug port: BAR=1 offset=00a0
     Kernel driver in use: ehci-pci

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2) 
(prog-if 01 [Subtractive decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Bus: primary=00, secondary=06, subordinate=07, sec-latency=32
     I/O behind bridge: 00007000-00007fff
     Memory behind bridge: f0200000-f02fffff
     Prefetchable memory behind bridge: 0000000080000000-0000000083ffffff
     Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Subsystem: Acer Incorporated [ALI] Device 0090

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface 
Bridge (rev 02)
     Subsystem: Acer Incorporated [ALI] Device 0090
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Capabilities: [e0] Vendor Specific Information: Len=0c <?>
     Kernel driver in use: lpc_ich

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7-M Family) 
SATA Controller [IDE mode] (rev 02) (prog-if 80 [Master])
     Subsystem: Acer Incorporated [ALI] Device 0090
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 19
     Region 0: I/O ports at 01f0 [size=8]
     Region 1: I/O ports at 03f4
     Region 2: I/O ports at 0170 [size=8]
     Region 3: I/O ports at 0374
     Region 4: I/O ports at 5440 [size=16]
     Capabilities: [70] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation NM10/ICH7 Family SMBus Controller (rev 02)
     Subsystem: Acer Incorporated [ALI] Device 0090
     Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Interrupt: pin B routed to IRQ 10
     Region 4: I/O ports at 5420 [size=32]

01:00.0 VGA compatible controller: NVIDIA Corporation G72M [Quadro NVS 
110M/GeForce Go 7300] (rev a1) (prog-if 00 [VGA controller])
     Subsystem: Acer Incorporated [ALI] Device 0090
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 6
     Region 0: Memory at cd000000 (32-bit, non-prefetchable) [size=16M]
     Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
     Region 3: Memory at ce000000 (64-bit, non-prefetchable) [size=16M]
     Expansion ROM at <unassigned> [disabled]
     Capabilities: [60] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Capabilities: [78] Express (v1) Endpoint, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<256ns, L1 <4us
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 512 bytes
         DevSta:    CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Exit 
Latency L0s <256ns, L1 <4us
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 128 bytes Disabled- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
             Status:    NegoPending- InProgress-
     Capabilities: [128 v1] Power Budgeting <?>

05:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG 
[Golan] Network Connection (rev 02)
     Subsystem: Intel Corporation PRO/Wireless 3945ABG Network Connection
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 45
     Region 0: Memory at f0300000 (32-bit, non-prefetchable) [size=4K]
     Capabilities: [c8] Power Management version 2
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000fee0200c  Data: 4122
     Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 unlimited
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit 
Latency L0s <128ns, L1 <64us
             ClockPM+ Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         AERCap:    First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
     Capabilities: [140 v1] Device Serial Number 00-18-de-ff-ff-87-55-79
     Kernel driver in use: iwl3945

06:01.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX 
(rev 02)
     Subsystem: Acer Incorporated [ALI] Device 0090
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 64
     Interrupt: pin A routed to IRQ 21
     Region 0: Memory at f0200000 (32-bit, non-prefetchable) [size=8K]
     Capabilities: [40] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
     Kernel driver in use: b44

06:04.0 CardBus bridge: ENE Technology Inc CB-712/4 Cardbus Controller 
(rev 10)
     Subsystem: Acer Incorporated [ALI] Device 0090
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 168, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 16
     Region 0: Memory at 88000000 (32-bit, non-prefetchable) [size=4K]
     Bus: primary=06, secondary=07, subordinate=07, sec-latency=176
     Memory window 0: 80000000-83ffffff (prefetchable)
     Memory window 1: 8c000000-8fffffff
     I/O window 0: 00007000-000070ff
     I/O window 1: 00007400-000074ff
     BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
     16-bit legacy interface ports at 0001
     Capabilities: [a0] Power Management version 1
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Bridge: PM- B3+
     Kernel driver in use: yenta_cardbus

06:04.1 FLASH memory: ENE Technology Inc ENE PCI Memory Stick Card 
Reader Controller (rev 01)
     Subsystem: Acer Incorporated [ALI] Device 0090
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Interrupt: pin B routed to IRQ 11
     Region 0: Memory at f0203000 (32-bit, non-prefetchable) [disabled] 
[size=128]
     Capabilities: [80] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

06:04.2 SD Host controller: ENE Technology Inc ENE PCI Secure Digital 
Card Reader Controller (rev 01) (prog-if 01)
     Subsystem: Acer Incorporated [ALI] Device 0090
     Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Interrupt: pin B routed to IRQ 17
     Region 0: Memory at f0203400 (32-bit, non-prefetchable) [size=256]
     Capabilities: [80] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: sdhci-pci

06:04.3 FLASH memory: ENE Technology Inc FLASH memory: ENE Technology 
Inc: (rev 01)
     Subsystem: Acer Incorporated [ALI] Device 0090
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Interrupt: pin B routed to IRQ 11
     Region 0: Memory at f0203800 (32-bit, non-prefetchable) [disabled] 
[size=128]
     Capabilities: [80] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

06:04.4 FLASH memory: ENE Technology Inc SD/MMC Card Reader Controller 
(rev 01)
     Subsystem: Acer Incorporated [ALI] Device 0090
     Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Interrupt: pin B routed to IRQ 17
     Region 0: Memory at f0202000 (32-bit, non-prefetchable) [size=256]
     Capabilities: [80] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: sdhci-pci



cat /proc/scsi/scsi =
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: ST9120821A       Rev: 3.06
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: HL-DT-ST Model: DVDRAM GSA-T10N  Rev: PP02
   Type:   CD-ROM                           ANSI  SCSI revision: 05


ls /proc =

1
10
1006
1011
1015
1031
1037
1063
1066
1083
11
1114
1157
12
1260
1290
13
132
138
139
141
142
1436
1498
15
1504
1505
1528
1531
1532
1533
1545
1554
1559
1567
1568
157
1570
1574
1578
158
1581
1594
16
1605
1608
1610
1613
1622
1628
1633
1634
1640
1646
1655
1660
1662
1667
1674
17
18
1835
1846
1885
19
1922
1926
2
20
2001
2013
2085
21
2108
22
23
24
25
26
27
28
280
286
29
3
30
31
34
35
36
37
380
418
447
468
484
49
5
50
502
51
52
53
54
541
55
57
587
6
609
636
638
649
671
694
7
725
729
735
736
739
77
78
788
79
8
801
849
877
9
974
995
acpi
asound
buddyinfo
bus
cgroups
cmdline
consoles
cpuinfo
crypto
devices
diskstats
dma
driver
execdomains
fb
filesystems
fs
interrupts
iomem
ioports
irq
kallsyms
kcore
key-users
kmsg
kpagecount
kpageflags
latency_stats
loadavg
locks
mdstat
meminfo
misc
modules
mounts
mtrr
net
pagetypeinfo
partitions
sched_debug
schedstat
scsi
self
slabinfo
softirqs
stat
swaps
sys
sysrq-trigger
sysvipc
timer_list
timer_stats
tty
uptime
version
vmallocinfo
vmstat
zoneinfo

Launchpad report url = 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1325412?comments=all


Best regards,

Thierry Coton



