Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:48265 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3IHLh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Sep 2013 07:37:56 -0400
Received: by mail-ee0-f45.google.com with SMTP id c50so2550962eek.18
        for <linux-media@vger.kernel.org>; Sun, 08 Sep 2013 04:37:54 -0700 (PDT)
Message-ID: <522C618E.6020203@googlemail.com>
Date: Sun, 08 Sep 2013 13:37:50 +0200
From: Frank Dierich <frank.dierich@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: hdegoede@redhat.com
Subject: [Bug] 0ac8:0321 Vimicro generic vc0321 Camera is not working and
 causes crashes since 3.2
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have an ASUS A8JP Notebook with Ubuntu 12.04 with the following build 
in webcam

     Bus 001 Device 004: ID 0ac8:0321 Z-Star Microelectronics Corp. 
Vimicro generic vc0321 Camera

The camera is working nice with Cheese and kernels before 3.2. I have 
tested the following once 2.6.32.61, 2.6.33.20, 2.6.34.11, 2.6.35.14, 
2.6.36.4, 2.6.37.6, 2.6.38.8, 2.6.39.4, 3.0.94, 3.1.10. In all later 
kernels I have tested (3.2.50, 3.4.60, 3.10.10, 3.11.0) Cheese shows for 
some seconds a green and noisy image and crashes then with a 
segmentation fault.

On the web I found some bug reports very similar to my problem but no 
one of these leads to a solution.
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=677533
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/990749

In the following i give some informations about my system which 
hopefully helps to find the problem.

Frank


[4.1.]Kernel version

dierich@2x2GHZ:~$ sudo cat /proc/version
Linux version 3.11.0 (dierich@2x2GHZ) (gcc version 4.6.3 (Ubuntu/Linaro 
4.6.3-1ubuntu5) ) #1 SMP Sat Sep 7 15:17:47 CEST 2013

[8.1.]  Software

dierich@2x2GHZ:~/Projects/Kernel/linux-3.11/scripts$ sudo ./ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux 2x2GHZ 3.11.0 #1 SMP Sat Sep 7 15:17:47 CEST 2013 x86_64 x86_64 
x86_64 GNU/Linux

Gnu C                  4.6
Gnu make               3.81
binutils               2.22
util-linux             2.20.1
mount                  support
module-init-tools      3.16
e2fsprogs              1.42
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.15
Dynamic linker (ldd)   2.15
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.2
Sh-utils               8.13
wireless-tools         30
Modules Loaded         hidp rfcomm parport_pc bnep ppdev binfmt_misc 
snd_hda_codec_si3054 snd_hda_codec_analog radeon snd_hda_intel arc4 
snd_hda_codec snd_usb_audio joydev iwl3945 ttm hid_generic iwlegacy 
snd_pcm snd_hwdep gspca_vc032x snd_usbmidi_lib gspca_main drm_kms_helper 
snd_seq_midi r852 snd_rawmidi drm usbhid mac80211 sm_common 
snd_seq_midi_event nand snd_seq videodev btusb mtd snd_timer hid 
snd_seq_device r592
nand_ids nand_bch irda bluetooth bch snd memstick psmouse lpc_ich 
nand_ecc cfg80211 asus_laptop snd_page_alloc soundcore i2c_algo_bit 
serio_raw sparse_keymap video crc_ccitt input_polldev mac_hid lp parport 
firewire_ohci sdhci_pci sdhci firewire_core crc_itu_t r8169 mii

[8.2.]Processor information

dierich@2x2GHZ:~$ sudo cat /proc/cpuinfo
processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
stepping    : 6
microcode    : 0x48
cpu MHz        : 996.000
cache size    : 4096 KB
physical id    : 0
siblings    : 2
core id        : 0
cpu cores    : 2
apicid        : 0
initial apicid    : 0
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni 
dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm dtherm 
tpr_shadow
bogomips    : 3989.88
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:
processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
stepping    : 6
microcode    : 0x48
cpu MHz        : 1992.000
cache size    : 4096 KB
physical id    : 0
siblings    : 2
core id        : 1
cpu cores    : 2
apicid        : 1
initial apicid    : 1
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni 
dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm dtherm 
tpr_shadow
bogomips    : 3989.88
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

[8.3.]  Module information

dierich@2x2GHZ:~$ sudo cat /proc/modules
hidp 22605 1 - Live 0xffffffffa05f7000 (F)
rfcomm 42582 12 - Live 0xffffffffa05eb000 (F)
parport_pc 32688 0 - Live 0xffffffffa05dc000 (F)
bnep 18040 2 - Live 0xffffffffa047a000 (F)
ppdev 12934 0 - Live 0xffffffffa040d000 (F)
binfmt_misc 17399 1 - Live 0xffffffffa0407000 (F)
snd_hda_codec_si3054 13008 1 - Live 0xffffffffa03bf000 (F)
snd_hda_codec_analog 94059 1 - Live 0xffffffffa0609000 (F)
radeon 1397549 2 - Live 0xffffffffa0481000 (F)
snd_hda_intel 47993 2 - Live 0xffffffffa043b000 (F)
arc4 12573 2 - Live 0xffffffffa035d000 (F)
snd_hda_codec 192524 3 
snd_hda_codec_si3054,snd_hda_codec_analog,snd_hda_intel, Live 
0xffffffffa0449000 (F)
snd_usb_audio 153720 2 - Live 0xffffffffa0414000 (F)
joydev 17377 0 - Live 0xffffffffa03b9000 (F)
iwl3945 68985 0 - Live 0xffffffffa03f5000 (F)
ttm 83463 1 radeon, Live 0xffffffffa03df000 (F)
hid_generic 12548 0 - Live 0xffffffffa0358000 (F)
iwlegacy 104438 1 iwl3945, Live 0xffffffffa03c4000 (F)
snd_pcm 102010 4 
snd_hda_codec_si3054,snd_hda_intel,snd_hda_codec,snd_usb_audio, Live 
0xffffffffa033e000 (F)
snd_hwdep 13563 2 snd_hda_codec,snd_usb_audio, Live 0xffffffffa032a000 (F)
gspca_vc032x 32059 0 - Live 0xffffffffa0311000 (F)
snd_usbmidi_lib 29090 1 snd_usb_audio, Live 0xffffffffa025e000 (F)
gspca_main 36687 1 gspca_vc032x, Live 0xffffffffa0307000 (F)
drm_kms_helper 52723 1 radeon, Live 0xffffffffa03ab000 (F)
snd_seq_midi 13324 0 - Live 0xffffffffa02fc000 (F)
r852 18241 0 - Live 0xffffffffa0301000 (F)
snd_rawmidi 30237 2 snd_usbmidi_lib,snd_seq_midi, Live 
0xffffffffa031d000 (F)
drm 292382 4 radeon,ttm,drm_kms_helper, Live 0xffffffffa0362000 (F)
usbhid 46782 0 - Live 0xffffffffa0331000 (F)
mac80211 604845 2 iwl3945,iwlegacy, Live 0xffffffffa0267000 (F)
sm_common 16860 1 r852, Live 0xffffffffa01d8000 (F)
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0xffffffffa018d000 (F)
nand 58837 2 r852,sm_common, Live 0xffffffffa0232000 (F)
snd_seq 65685 2 snd_seq_midi,snd_seq_midi_event, Live 0xffffffffa024c000 (F)
videodev 137517 2 gspca_vc032x,gspca_main, Live 0xffffffffa020f000 (F)
btusb 22474 0 - Live 0xffffffffa0208000 (F)
mtd 50162 2 sm_common,nand, Live 0xffffffffa01fa000 (F)
snd_timer 29532 2 snd_pcm,snd_seq, Live 0xffffffffa0243000 (F)
hid 100933 3 hidp,hid_generic,usbhid, Live 0xffffffffa01e0000 (F)
snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 
0xffffffffa01b5000 (F)
r592 18023 0 - Live 0xffffffffa0187000 (F)
nand_ids 8627 1 nand, Live 0xffffffffa0050000 (F)
nand_bch 13147 1 nand, Live 0xffffffffa012d000 (F)
irda 129264 0 - Live 0xffffffffa0194000 (F)
bluetooth 238654 29 hidp,rfcomm,bnep,btusb, Live 0xffffffffa014b000 (F)
bch 17500 1 nand_bch, Live 0xffffffffa01d2000 (F)
snd 69182 21 
snd_hda_codec_si3054,snd_hda_codec_analog,snd_hda_intel,snd_hda_codec,snd_usb_audio,snd_pcm,snd_hwdep,snd_usbmidi_lib,snd_seq_midi,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, 
Live 0xffffffffa01c0000 (F)
memstick 16476 1 r592, Live 0xffffffffa01ba000 (F)
psmouse 96025 0 - Live 0xffffffffa0132000 (F)
lpc_ich 21080 0 - Live 0xffffffffa0126000 (F)
nand_ecc 13312 1 nand, Live 0xffffffffa00a7000 (F)
cfg80211 492040 3 iwl3945,iwlegacy,mac80211, Live 0xffffffffa00ac000 (F)
asus_laptop 28666 0 - Live 0xffffffffa009f000 (F)
snd_page_alloc 18710 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0095000 (F)
soundcore 12680 1 snd, Live 0xffffffffa007c000 (F)
i2c_algo_bit 13413 1 radeon, Live 0xffffffffa0090000 (F)
serio_raw 13253 0 - Live 0xffffffffa008b000 (F)
sparse_keymap 13890 1 asus_laptop, Live 0xffffffffa0082000 (F)
video 19214 0 - Live 0xffffffffa0076000 (F)
crc_ccitt 12707 1 irda, Live 0xffffffffa006c000 (F)
input_polldev 13896 1 asus_laptop, Live 0xffffffffa0071000 (F)
mac_hid 13205 0 - Live 0xffffffffa0038000 (F)
lp 17759 0 - Live 0xffffffffa0019000 (F)
parport 42258 3 parport_pc,ppdev,lp, Live 0xffffffffa0060000 (F)
firewire_ohci 44146 0 - Live 0xffffffffa0054000 (F)
sdhci_pci 18906 0 - Live 0xffffffffa004a000 (F)
sdhci 32855 1 sdhci_pci, Live 0xffffffffa0040000 (F)
firewire_core 64643 1 firewire_ohci, Live 0xffffffffa0027000 (F)
crc_itu_t 12707 1 firewire_core, Live 0xffffffffa0020000 (F)
r8169 67579 0 - Live 0xffffffffa0007000 (F)
mii 13934 1 r8169, Live 0xffffffffa0000000 (F)

[8.4.] Loaded driver and hardware information

dierich@2x2GHZ:~$ sudo cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0062-0062 : EC data
0064-0064 : keyboard
0066-0066 : EC cmd
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.2
   0170-0177 : ata_piix
01f0-01f7 : 0000:00:1f.2
   01f0-01f7 : ata_piix
02f8-02ff : serial
0376-0376 : 0000:00:1f.2
   0376-0376 : ata_piix
03f6-03f6 : 0000:00:1f.2
   03f6-03f6 : ata_piix
0400-041f : pnp 00:0c
0480-04bf : 0000:00:1f.0
   0480-04bf : pnp 00:09
04d0-04d1 : pnp 00:09
0800-0803 : ACPI PM1a_EVT_BLK
0804-0805 : ACPI PM1a_CNT_BLK
0808-080b : ACPI PM_TMR
0810-0815 : ACPI CPU throttle
0820-0820 : ACPI PM2_CNT_BLK
0828-082f : ACPI GPE0_BLK
0830-0833 : iTCO_wdt
0860-087f : iTCO_wdt
0a00-0a0f : pnp 00:08
0cf8-0cff : PCI conf1
1000-1fff : PCI Bus 0000:02
2000-2fff : PCI Bus 0000:04
9000-bfff : PCI Bus 0000:01
   b000-b0ff : 0000:01:00.0
c000-cfff : PCI Bus 0000:03
   c800-c8ff : 0000:03:00.0
     c800-c8ff : r8169
e480-e49f : 0000:00:1d.3
   e480-e49f : uhci_hcd
e800-e81f : 0000:00:1d.2
   e800-e81f : uhci_hcd
e880-e89f : 0000:00:1d.1
   e880-e89f : uhci_hcd
ec00-ec1f : 0000:00:1d.0
   ec00-ec1f : uhci_hcd
ffa0-ffaf : 0000:00:1f.2
   ffa0-ffaf : ata_piix

dierich@2x2GHZ:~$ sudo cat /proc/iomem
00000000-00000fff : reserved
00001000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000c0000-000cffff : Video ROM
000e0000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-b7fbffff : System RAM
   01000000-01708fb5 : Kernel code
   01708fb6-01d0067f : Kernel data
   01e5b000-01fcdfff : Kernel bss
b7fc0000-b7fcdfff : ACPI Tables
b7fce000-b7ffffff : ACPI Non-volatile Storage
b8000000-b81fffff : PCI Bus 0000:02
b8200000-b83fffff : PCI Bus 0000:03
b8400000-b85fffff : PCI Bus 0000:04
b8600000-b87fffff : PCI Bus 0000:04
bdf00000-ddefffff : PCI Bus 0000:01
   c0000000-cfffffff : 0000:01:00.0
e0000000-e3ffffff : PCI MMCONFIG 0000 [bus 00-3f]
   e0000000-e3ffffff : pnp 00:0d
fdf00000-fdffffff : PCI Bus 0000:01
   fdfc0000-fdfdffff : 0000:01:00.0
   fdff0000-fdffffff : 0000:01:00.0
fe000000-fe0fffff : PCI Bus 0000:02
   fe0ff000-fe0fffff : 0000:02:00.0
     fe0ff000-fe0fffff : iwl3945
fe100000-fe1fffff : PCI Bus 0000:03
   fe1e0000-fe1effff : 0000:03:00.0
   fe1ff000-fe1fffff : 0000:03:00.0
     fe1ff000-fe1fffff : r8169
fea00000-feafffff : PCI Bus 0000:06
   feafec00-feafecff : 0000:06:00.3
     feafec00-feafecff : r852
   feaff000-feaff0ff : 0000:06:00.2
     feaff000-feaff0ff : r592
   feaff400-feaff4ff : 0000:06:00.1
     feaff400-feaff4ff : mmc0
   feaff800-feafffff : 0000:06:00.0
     feaff800-feafffff : firewire_ohci
febfbc00-febfbfff : 0000:00:1d.7
   febfbc00-febfbfff : ehci_hcd
febfc000-febfffff : 0000:00:1b.0
   febfc000-febfffff : ICH HD audio
fec00000-fec003ff : IOAPIC 0
fec10000-fec17fff : pnp 00:0c
fec18000-fec1ffff : pnp 00:0c
fec20000-fec27fff : pnp 00:0c
fec28000-fec2ffff : pnp 00:0c
fed13000-fed19fff : pnp 00:00
fed1c000-fed1ffff : pnp 00:09
   fed1f410-fed1f414 : iTCO_wdt
fed20000-fed3ffff : pnp 00:09
fed45000-fed89fff : pnp 00:09
fee00000-fee00fff : Local APIC
   fee00000-fee00fff : reserved
     fee00000-fee00fff : pnp 00:0c
ffb80000-ffffffff : reserved
   ffb80000-ffbfffff : pnp 00:0a
   ffc00000-fff7ffff : pnp 00:0b
   fff80000-ffffffff : pnp 00:0a

[8.5.] PCI information

dierich@2x2GHZ:~$ sudo lspci -vvv
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML 
and 945GT Express Memory Controller Hub (rev 03)
     Subsystem: ASUSTeK Computer Inc. Device 1447
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
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
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
     I/O behind bridge: 00009000-0000bfff
     Memory behind bridge: fdf00000-fdffffff
     Prefetchable memory behind bridge: 00000000bdf00000-00000000ddefffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [88] Subsystem: Intel Corporation Mobile 
945GM/PM/GMS, 943/940GML and 945GT Express PCI Express Root Port
     Capabilities: [80] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0300c  Data: 41a1
     Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- 
Surprise-
             Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
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
     Kernel modules: shpchp

00:1b.0 Audio device: Intel Corporation NM10/ICH7 Family High Definition 
Audio Controller (rev 02)
     Subsystem: ASUSTeK Computer Inc. Device 1447
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 46
     Region 0: Memory at febfc000 (64-bit, non-prefetchable) [size=16K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000fee0100c  Data: 4162
     Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, 
MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown, 
Latency L0 <64ns, L1 <1us
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk- 
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
         VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable- ID=0 ArbSelect=Fixed TC/VC=00
             Status:    NegoPending- InProgress-
     Capabilities: [130 v1] Root Complex Link
         Desc:    PortNumber=0f ComponentID=00 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=00 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed1c000
     Kernel driver in use: snd_hda_intel
     Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 
1 (rev 02) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
     I/O behind bridge: 00001000-00001fff
     Memory behind bridge: fe000000-fe0fffff
     Prefetchable memory behind bridge: 00000000b8000000-00000000b81fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
             ClockPM- Surprise- LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surprise+
             Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
             Changed: MRL- PresDet+ LinkState+
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0300c  Data: 41b1
     Capabilities: [90] Subsystem: Intel Corporation NM10/ICH7 Family 
PCI Express Port 1
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
         Desc:    PortNumber=01 ComponentID=00 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=00 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed1c001
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:1c.2 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 
3 (rev 02) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
     I/O behind bridge: 0000c000-0000cfff
     Memory behind bridge: fe100000-fe1fffff
     Prefetchable memory behind bridge: 00000000b8200000-00000000b83fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
             ClockPM- Surprise- LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surprise+
             Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
             Changed: MRL- PresDet+ LinkState+
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0300c  Data: 41c1
     Capabilities: [90] Subsystem: Intel Corporation NM10/ICH7 Family 
PCI Express Port 3
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
         Desc:    PortNumber=03 ComponentID=00 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=00 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed1c001
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 
4 (rev 02) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=00, secondary=04, subordinate=05, sec-latency=0
     I/O behind bridge: 00002000-00002fff
     Memory behind bridge: b8400000-b85fffff
     Prefetchable memory behind bridge: 00000000b8600000-00000000b87fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
             ExtTag- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <1us, L1 <4us
             ClockPM- Surprise- LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surprise+
             Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
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
         Address: fee0300c  Data: 41d1
     Capabilities: [90] Subsystem: Intel Corporation NM10/ICH7 Family 
PCI Express Port 4
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
         Desc:    PortNumber=04 ComponentID=00 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=00 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed1c001
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:1d.0 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI 
Controller #1 (rev 02) (prog-if 00 [UHCI])
     Subsystem: ASUSTeK Computer Inc. Device 1447
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 23
     Region 4: I/O ports at ec00 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.1 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI 
Controller #2 (rev 02) (prog-if 00 [UHCI])
     Subsystem: ASUSTeK Computer Inc. Device 1447
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 19
     Region 4: I/O ports at e880 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.2 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI 
Controller #3 (rev 02) (prog-if 00 [UHCI])
     Subsystem: ASUSTeK Computer Inc. Device 1447
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin C routed to IRQ 20
     Region 4: I/O ports at e800 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.3 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI 
Controller #4 (rev 02) (prog-if 00 [UHCI])
     Subsystem: ASUSTeK Computer Inc. Device 1447
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin D routed to IRQ 22
     Region 4: I/O ports at e480 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.7 USB controller: Intel Corporation NM10/ICH7 Family USB2 EHCI 
Controller (rev 02) (prog-if 20 [EHCI])
     Subsystem: ASUSTeK Computer Inc. Device 1447
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 23
     Region 0: Memory at febfbc00 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Debug port: BAR=1 offset=00a0
     Kernel driver in use: ehci-pci

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2) 
(prog-if 01 [Subtractive decode])
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Bus: primary=00, secondary=06, subordinate=06, sec-latency=32
     I/O behind bridge: 0000f000-00000fff
     Memory behind bridge: fea00000-feafffff
     Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
     Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Subsystem: Intel Corporation 82801 Mobile PCI Bridge

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface 
Bridge (rev 02)
     Subsystem: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Capabilities: [e0] Vendor Specific Information: Len=0c <?>
     Kernel driver in use: lpc_ich
     Kernel modules: leds-ss4200, lpc_ich, intel-rng

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7-M Family) 
SATA Controller [IDE mode] (rev 02) (prog-if 80 [Master])
     Subsystem: ASUSTeK Computer Inc. Device 1447
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 19
     Region 0: I/O ports at 01f0 [size=8]
     Region 1: I/O ports at 03f4 [size=1]
     Region 2: I/O ports at 0170 [size=8]
     Region 3: I/O ports at 0374 [size=1]
     Region 4: I/O ports at ffa0 [size=16]
     Capabilities: [70] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: ata_piix
     Kernel modules: pata_acpi

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. 
[AMD/ATI] RV530/M66-P [Mobility Radeon X1700] (prog-if 00 [VGA controller])
     Subsystem: ASUSTeK Computer Inc. Device 1242
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 47
     Region 0: Memory at c0000000 (32-bit, prefetchable) [size=256M]
     Region 1: I/O ports at b000 [size=256]
     Region 2: Memory at fdff0000 (32-bit, non-prefetchable) [size=64K]
     Expansion ROM at fdfc0000 [disabled] [size=128K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Express (v1) Legacy Endpoint, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, 
L1 unlimited
             ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, 
Latency L0 <64ns, L1 <1us
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000fee0300c  Data: 4172
     Kernel driver in use: radeon
     Kernel modules: radeon

02:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG 
[Golan] Network Connection (rev 02)
     Subsystem: Intel Corporation PRO/Wireless 3945ABG Network Connection
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 45
     Region 0: Memory at fe0ff000 (32-bit, non-prefetchable) [size=4K]
     Capabilities: [c8] Power Management version 2
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000fee0100c  Data: 4142
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
         LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <128ns, L1 <64us
             ClockPM+ Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
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
     Capabilities: [140 v1] Device Serial Number 00-18-de-ff-ff-95-c8-c3
     Kernel driver in use: iwl3945
     Kernel modules: iwl3945

03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 01)
     Subsystem: ASUSTeK Computer Inc. A6J-Q008
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 44
     Region 0: I/O ports at c800 [size=256]
     Region 2: Memory at fe1ff000 (64-bit, non-prefetchable) [size=4K]
     Expansion ROM at fe1e0000 [disabled] [size=64K]
     Capabilities: [40] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0-,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [48] Vital Product Data
         Unknown small resource type 00, will not decode more.
     Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
         Address: 00000000fee0100c  Data: 41e1
     Capabilities: [60] Express (v1) Endpoint, MSI 00
         DevCap:    MaxPayload 1024 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
             ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 4096 bytes
         DevSta:    CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 unlimited, L1 unlimited
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [84] Vendor Specific Information: Len=4c <?>
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
     Capabilities: [12c v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending- InProgress-
     Capabilities: [148 v1] Device Serial Number 03-00-00-00-00-00-00-00
     Capabilities: [154 v1] Power Budgeting <?>
     Kernel driver in use: r8169
     Kernel modules: r8169

06:00.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller 
(prog-if 10 [OHCI])
     Subsystem: ASUSTeK Computer Inc. Device 1447
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 64 (500ns min, 1000ns max)
     Interrupt: pin B routed to IRQ 17
     Region 0: Memory at feaff800 (32-bit, non-prefetchable) [size=2K]
     Capabilities: [dc] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME+
     Kernel driver in use: firewire_ohci
     Kernel modules: firewire-ohci

06:00.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro 
Host Adapter (rev 19)
     Subsystem: ASUSTeK Computer Inc. Device 1447
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 64
     Interrupt: pin B routed to IRQ 17
     Region 0: Memory at feaff400 (32-bit, non-prefetchable) [size=256]
     Capabilities: [80] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
     Kernel driver in use: sdhci-pci
     Kernel modules: sdhci-pci

06:00.2 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host 
Adapter (rev 0a)
     Subsystem: ASUSTeK Computer Inc. Device 1447
     Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Interrupt: pin B routed to IRQ 17
     Region 0: Memory at feaff000 (32-bit, non-prefetchable) [size=256]
     Capabilities: [80] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
     Kernel driver in use: r592
     Kernel modules: r592

06:00.3 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 05)
     Subsystem: ASUSTeK Computer Inc. Device 1447
     Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Interrupt: pin B routed to IRQ 17
     Region 0: Memory at feafec00 (32-bit, non-prefetchable) [size=256]
     Capabilities: [80] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
     Kernel driver in use: r852
     Kernel modules: r852

[8.6.] SCSI information

dierich@2x2GHZ:~$ sudo cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000BEVT-0 Rev: 01.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 01 Lun: 00
   Vendor: HL-DT-ST Model: DVDRAM GSA-T10N  Rev: PR03
   Type:   CD-ROM                           ANSI  SCSI revision: 05

[8.7.] Other information that might be relevant to the problem
        lsusb -v and dmesg

dierich@2x2GHZ:~$ sudo lsusb -v

Bus 001 Device 004: ID 0ac8:0321 Z-Star Microelectronics Corp. Vimicro 
generic vc0321 Camera
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass          255 Vendor Specific Class
   bDeviceSubClass       255 Vendor Specific Subclass
   bDeviceProtocol       255 Vendor Specific Protocol
   bMaxPacketSize0        64
   idVendor           0x0ac8 Z-Star Microelectronics Corp.
   idProduct          0x0321 Vimicro generic vc0321 Camera
   bcdDevice            1.00
   iManufacturer           1 Vimicro Corp.
   iProduct                2 USB2.0 Web Camera
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength          193
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower              200mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval               7
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0000  1x 0 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       1
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval               7
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0080  1x 128 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       2
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval               7
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       3
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval               7
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0400  1x 1024 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       4
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval               7
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0b00  2x 768 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       5
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval               7
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0c00  2x 1024 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       6
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval               7
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x1380  3x 896 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       7
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval               7
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x1400  3x 1024 bytes
         bInterval               1
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0000
   (Bus Powered)

Bus 002 Device 002: ID 1241:1503 Belkin Keyboard
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         8
   idVendor           0x1241 Belkin
   idProduct          0x1503 Keyboard
   bcdDevice            2.90
   iManufacturer           1
   iProduct                2 USB Keyboard
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           59
     bNumInterfaces          2
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              100mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         3 Human Interface Device
       bInterfaceSubClass      1 Boot Interface Subclass
       bInterfaceProtocol      1 Keyboard
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.10
           bCountryCode            0 Not supported
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength      62
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval              10
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         3 Human Interface Device
       bInterfaceSubClass      0 No Subclass
       bInterfaceProtocol      0 None
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.10
           bCountryCode            0 Not supported
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength     101
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval              10
Device Status:     0x0000
   (Bus Powered)

Bus 003 Device 002: ID 0b05:1712 ASUSTek Computer, Inc. BT-183 Bluetooth 
2.0+EDR adapter
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass          224 Wireless
   bDeviceSubClass         1 Radio Frequency
   bDeviceProtocol         1 Bluetooth
   bMaxPacketSize0        64
   idVendor           0x0b05 ASUSTek Computer, Inc.
   idProduct          0x1712 BT-183 Bluetooth 2.0+EDR adapter
   bcdDevice           19.15
   iManufacturer           0
   iProduct                0
   iSerial                 3 0194E8-5B-0002
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength          193
     bNumInterfaces          3
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xc0
       Self Powered
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           3
       bInterfaceClass       224 Wireless
       bInterfaceSubClass      1 Radio Frequency
       bInterfaceProtocol      1 Bluetooth
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0010  1x 16 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           2
       bInterfaceClass       224 Wireless
       bInterfaceSubClass      1 Radio Frequency
       bInterfaceProtocol      1 Bluetooth
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0000  1x 0 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0000  1x 0 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       1
       bNumEndpoints           2
       bInterfaceClass       224 Wireless
       bInterfaceSubClass      1 Radio Frequency
       bInterfaceProtocol      1 Bluetooth
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0009  1x 9 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0009  1x 9 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       2
       bNumEndpoints           2
       bInterfaceClass       224 Wireless
       bInterfaceSubClass      1 Radio Frequency
       bInterfaceProtocol      1 Bluetooth
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0011  1x 17 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0011  1x 17 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       3
       bNumEndpoints           2
       bInterfaceClass       224 Wireless
       bInterfaceSubClass      1 Radio Frequency
       bInterfaceProtocol      1 Bluetooth
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0019  1x 25 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0019  1x 25 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       4
       bNumEndpoints           2
       bInterfaceClass       224 Wireless
       bInterfaceSubClass      1 Radio Frequency
       bInterfaceProtocol      1 Bluetooth
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0021  1x 33 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0021  1x 33 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       5
       bNumEndpoints           2
       bInterfaceClass       224 Wireless
       bInterfaceSubClass      1 Radio Frequency
       bInterfaceProtocol      1 Bluetooth
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0031  1x 49 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0031  1x 49 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass       254 Application Specific Interface
       bInterfaceSubClass      1 Device Firmware Update
       bInterfaceProtocol      0
       iInterface              0
       Device Firmware Upgrade Interface Descriptor:
         bLength                             7
         bDescriptorType                    33
         bmAttributes                        7
           Will Not Detach
           Manifestation Tolerant
           Upload Supported
           Download Supported
         wDetachTimeout                   5000 milliseconds
         wTransferSize                    1023 bytes
Device Status:     0x0001
   Self Powered

Bus 005 Device 002: ID 046d:0a29 Logitech, Inc.
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x046d Logitech, Inc.
   idProduct          0x0a29
   bcdDevice           76.57
   iManufacturer           1 Logitech
   iProduct                2 Logitech Wireless Headset
   iSerial                 3 000D44B83F6C
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength          218
     bNumInterfaces          4
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower              144mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass         1 Audio
       bInterfaceSubClass      1 Control Device
       bInterfaceProtocol      0
       iInterface              0
       AudioControl Interface Descriptor:
         bLength                10
         bDescriptorType        36
         bDescriptorSubtype      1 (HEADER)
         bcdADC               1.00
         wTotalLength           71
         bInCollection           2
         baInterfaceNr( 0)       1
         baInterfaceNr( 1)       2
       AudioControl Interface Descriptor:
         bLength                12
         bDescriptorType        36
         bDescriptorSubtype      2 (INPUT_TERMINAL)
         bTerminalID             1
         wTerminalType      0x0101 USB Streaming
         bAssocTerminal          0
         bNrChannels             2
         wChannelConfig     0x0003
           Left Front (L)
           Right Front (R)
         iChannelNames           0
         iTerminal               0
       AudioControl Interface Descriptor:
         bLength                10
         bDescriptorType        36
         bDescriptorSubtype      6 (FEATURE_UNIT)
         bUnitID                 2
         bSourceID               1
         bControlSize            1
         bmaControls( 0)      0x03
           Mute Control
           Volume Control
         bmaControls( 1)      0x00
         bmaControls( 2)      0x00
         iFeature                0
       AudioControl Interface Descriptor:
         bLength                 9
         bDescriptorType        36
         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
         bTerminalID             3
         wTerminalType      0x0301 Speaker
         bAssocTerminal          0
         bSourceID               2
         iTerminal               0
       AudioControl Interface Descriptor:
         bLength                12
         bDescriptorType        36
         bDescriptorSubtype      2 (INPUT_TERMINAL)
         bTerminalID             4
         wTerminalType      0x0201 Microphone
         bAssocTerminal          0
         bNrChannels             1
         wChannelConfig     0x0001
           Left Front (L)
         iChannelNames           0
         iTerminal               0
       AudioControl Interface Descriptor:
         bLength                 9
         bDescriptorType        36
         bDescriptorSubtype      6 (FEATURE_UNIT)
         bUnitID                 5
         bSourceID               4
         bControlSize            1
         bmaControls( 0)      0x02
           Volume Control
         bmaControls( 1)      0x00
         iFeature                0
       AudioControl Interface Descriptor:
         bLength                 9
         bDescriptorType        36
         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
         bTerminalID             6
         wTerminalType      0x0101 USB Streaming
         bAssocTerminal          0
         bSourceID               5
         iTerminal               0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       1
       bNumEndpoints           1
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
       AudioStreaming Interface Descriptor:
         bLength                 7
         bDescriptorType        36
         bDescriptorSubtype      1 (AS_GENERAL)
         bTerminalLink           6
         bDelay                  0 frames
         wFormatTag              1 PCM
       AudioStreaming Interface Descriptor:
         bLength                11
         bDescriptorType        36
         bDescriptorSubtype      2 (FORMAT_TYPE)
         bFormatType             1 (FORMAT_TYPE_I)
         bNrChannels             1
         bSubframeSize           2
         bBitResolution         16
         bSamFreqType            1 Discrete
         tSamFreq[ 0]        48000
       ** UNRECOGNIZED:  07 25 01 00 02 00 00
       Endpoint Descriptor:
         bLength                 9
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0060  1x 96 bytes
         bInterval               1
         bRefresh                0
         bSynchAddress           0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       1
       bNumEndpoints           1
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              0
       AudioStreaming Interface Descriptor:
         bLength                 7
         bDescriptorType        36
         bDescriptorSubtype      1 (AS_GENERAL)
         bTerminalLink           1
         bDelay                  0 frames
         wFormatTag              1 PCM
       AudioStreaming Interface Descriptor:
         bLength                11
         bDescriptorType        36
         bDescriptorSubtype      2 (FORMAT_TYPE)
         bFormatType             1 (FORMAT_TYPE_I)
         bNrChannels             2
         bSubframeSize           2
         bBitResolution         16
         bSamFreqType            1 Discrete
         tSamFreq[ 0]        48000
       ** UNRECOGNIZED:  07 25 01 81 02 00 00
       Endpoint Descriptor:
         bLength                 9
         bDescriptorType         5
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x00c0  1x 192 bytes
         bInterval               1
         bRefresh                0
         bSynchAddress           0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        3
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         3 Human Interface Device
       bInterfaceSubClass      0 No Subclass
       bInterfaceProtocol      0 None
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.11
           bCountryCode            0 Not supported
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength     136
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0010  1x 16 bytes
         bInterval               1
Device Status:     0x0000
   (Bus Powered)

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0        64
   idVendor           0x1d6b Linux Foundation
   idProduct          0x0002 2.0 root hub
   bcdDevice            3.11
   iManufacturer           3 Linux 3.11.0 ehci_hcd
   iProduct                2 EHCI Host Controller
   iSerial                 1 0000:00:1d.7
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           25
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      0 Full speed (or root) hub
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval              12
Hub Descriptor:
   bLength              11
   bDescriptorType      41
   nNbrPorts             8
   wHubCharacteristic 0x000a
     No power switching (usb 1.0)
     Per-port overcurrent protection
   bPwrOn2PwrGood       10 * 2 milli seconds
   bHubContrCurrent      0 milli Ampere
   DeviceRemovable    0x00 0x00
   PortPwrCtrlMask    0xff 0xff
  Hub Port Status:
    Port 1: 0000.0100 power
    Port 2: 0000.0100 power
    Port 3: 0000.0100 power
    Port 4: 0000.0503 highspeed power enable connect
    Port 5: 0000.0100 power
    Port 6: 0000.0100 power
    Port 7: 0000.0100 power
    Port 8: 0000.0100 power
Device Status:     0x0001
   Self Powered

Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0        64
   idVendor           0x1d6b Linux Foundation
   idProduct          0x0001 1.1 root hub
   bcdDevice            3.11
   iManufacturer           3 Linux 3.11.0 uhci_hcd
   iProduct                2 UHCI Host Controller
   iSerial                 1 0000:00:1d.0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           25
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      0 Full speed (or root) hub
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0002  1x 2 bytes
         bInterval             255
Hub Descriptor:
   bLength               9
   bDescriptorType      41
   nNbrPorts             2
   wHubCharacteristic 0x000a
     No power switching (usb 1.0)
     Per-port overcurrent protection
   bPwrOn2PwrGood        1 * 2 milli seconds
   bHubContrCurrent      0 milli Ampere
   DeviceRemovable    0x00
   PortPwrCtrlMask    0xff
  Hub Port Status:
    Port 1: 0000.0100 power
    Port 2: 0000.0303 lowspeed power enable connect
Device Status:     0x0001
   Self Powered

Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0        64
   idVendor           0x1d6b Linux Foundation
   idProduct          0x0001 1.1 root hub
   bcdDevice            3.11
   iManufacturer           3 Linux 3.11.0 uhci_hcd
   iProduct                2 UHCI Host Controller
   iSerial                 1 0000:00:1d.1
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           25
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      0 Full speed (or root) hub
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0002  1x 2 bytes
         bInterval             255
Hub Descriptor:
   bLength               9
   bDescriptorType      41
   nNbrPorts             2
   wHubCharacteristic 0x000a
     No power switching (usb 1.0)
     Per-port overcurrent protection
   bPwrOn2PwrGood        1 * 2 milli seconds
   bHubContrCurrent      0 milli Ampere
   DeviceRemovable    0x00
   PortPwrCtrlMask    0xff
  Hub Port Status:
    Port 1: 0000.0103 power enable connect
    Port 2: 0000.0100 power
Device Status:     0x0001
   Self Powered

Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0        64
   idVendor           0x1d6b Linux Foundation
   idProduct          0x0001 1.1 root hub
   bcdDevice            3.11
   iManufacturer           3 Linux 3.11.0 uhci_hcd
   iProduct                2 UHCI Host Controller
   iSerial                 1 0000:00:1d.2
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           25
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      0 Full speed (or root) hub
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0002  1x 2 bytes
         bInterval             255
Hub Descriptor:
   bLength               9
   bDescriptorType      41
   nNbrPorts             2
   wHubCharacteristic 0x000a
     No power switching (usb 1.0)
     Per-port overcurrent protection
   bPwrOn2PwrGood        1 * 2 milli seconds
   bHubContrCurrent      0 milli Ampere
   DeviceRemovable    0x00
   PortPwrCtrlMask    0xff
  Hub Port Status:
    Port 1: 0000.0100 power
    Port 2: 0000.0100 power
Device Status:     0x0001
   Self Powered

Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            9 Hub
   bDeviceSubClass         0 Unused
   bDeviceProtocol         0 Full speed (or root) hub
   bMaxPacketSize0        64
   idVendor           0x1d6b Linux Foundation
   idProduct          0x0001 1.1 root hub
   bcdDevice            3.11
   iManufacturer           3 Linux 3.11.0 uhci_hcd
   iProduct                2 UHCI Host Controller
   iSerial                 1 0000:00:1d.3
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           25
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xe0
       Self Powered
       Remote Wakeup
     MaxPower                0mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         9 Hub
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      0 Full speed (or root) hub
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0002  1x 2 bytes
         bInterval             255
Hub Descriptor:
   bLength               9
   bDescriptorType      41
   nNbrPorts             2
   wHubCharacteristic 0x000a
     No power switching (usb 1.0)
     Per-port overcurrent protection
   bPwrOn2PwrGood        1 * 2 milli seconds
   bHubContrCurrent      0 milli Ampere
   DeviceRemovable    0x00
   PortPwrCtrlMask    0xff
  Hub Port Status:
    Port 1: 0000.0100 power
    Port 2: 0000.0103 power enable connect
Device Status:     0x0001
   Self Powered


dierich@2x2GHZ:~$ sudo dmesg
[sudo] password for dierich:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.11.0 (dierich@2x2GHZ) (gcc version 4.6.3 
(Ubuntu/Linaro 4.6.3-1ubuntu5) ) #1 SMP Sat Sep 7 15:17:47 CEST 2013
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.11.0 
root=UUID=1b0e422e-f022-453c-9ef0-b8be9ab517bc ro quiet splash vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000b7fbffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b7fc0000-0x00000000b7fcdfff] 
ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000b7fce000-0x00000000b7ffffff] 
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffb80000-0x00000000ffffffff] 
reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.3 present.
[    0.000000] DMI: ASUSTeK Computer Inc.  A8JP /A8JP      , BIOS 
A8JpeAS.203  08/10/2006
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xb7fc0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FE0000000 write-back
[    0.000000]   2 base 0A0000000 mask FF0000000 write-back
[    0.000000]   3 base 0B0000000 mask FF8000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped 
at [ffff8800000ff780]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fcf000, 0x01fcffff] PGTABLE
[    0.000000] BRK [0x01fd0000, 0x01fd0fff] PGTABLE
[    0.000000] BRK [0x01fd1000, 0x01fd1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xb7c00000-0xb7dfffff]
[    0.000000]  [mem 0xb7c00000-0xb7dfffff] page 2M
[    0.000000] BRK [0x01fd2000, 0x01fd2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xb4000000-0xb7bfffff]
[    0.000000]  [mem 0xb4000000-0xb7bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x80000000-0xb3ffffff]
[    0.000000]  [mem 0x80000000-0xb3ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x7fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0xb7e00000-0xb7fbffff]
[    0.000000]  [mem 0xb7e00000-0xb7fbffff] page 4k
[    0.000000] BRK [0x01fd3000, 0x01fd3fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x3631c000-0x37185fff]
[    0.000000] ACPI: RSDP 00000000000f7c40 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000b7fc0000 0003C (v01 A M I OEMRSDT  
08000610 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000b7fc0200 00084 (v02 A M I OEMFACP  
08000610 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000b7fc0460 0837F (v01  A8J00 A8J00005 
00000005 INTL 02002026)
[    0.000000] ACPI: FACS 00000000b7fce000 00040
[    0.000000] ACPI: APIC 00000000b7fc0390 0005C (v01 A M I OEMAPIC  
08000610 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000b7fc03f0 0003C (v01 A M I OEMMCFG  
08000610 MSFT 00000097)
[    0.000000] ACPI: BOOT 00000000b7fc0430 00028 (v01 A M I OEMBOOT  
08000610 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000b7fce040 00046 (v01 A M I AMI_OEM  
08000610 MSFT 00000097)
[    0.000000] ACPI: TCPA 00000000b7fc87e0 00032 (v01 A M I TBLOEMID 
00000001 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000000b7fbffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0xb7fbffff]
[    0.000000]   NODE_DATA [mem 0xb7fbb000-0xb7fbffff]
[    0.000000]  [ffffea0000000000-ffffea0002dfffff] PMD -> 
[ffff8800b4600000-ffff8800b73fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xb7fbffff]
[    0.000000] On node 0 totalpages: 753502
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11711 pages used for memmap
[    0.000000]   DMA32 zone: 749504 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] e820: [mem 0xb8000000-0xfedfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 
nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff8800b7a00000 s86720 
r8192 d23872 u1048576
[    0.000000] pcpu-alloc: s86720 r8192 d23872 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  
Total pages: 741706
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.11.0 
root=UUID=1b0e422e-f022-453c-9ef0-b8be9ab517bc ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 2935348K/3014008K available (7203K kernel code, 
1025K rwdata, 3208K rodata, 1352K init, 1484K bss, 78660K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]     RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]     RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=2.
[    0.000000]     Offload RCU callbacks from all CPUs
[    0.000000]     Offload RCU callbacks from CPUs: 0-255.
[    0.000000] NR_IRQS:16640 nr_irqs:512 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 12058624 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't 
want memory cgroups
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1995.077 MHz processor
[    0.004006] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 3990.15 BogoMIPS (lpj=7980308)
[    0.004010] pid_max: default: 32768 minimum: 301
[    0.004048] Security Framework initialized
[    0.004071] AppArmor: AppArmor initialized
[    0.004073] Yama: becoming mindful.
[    0.004542] Dentry cache hash table entries: 524288 (order: 10, 
4194304 bytes)
[    0.008850] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.010374] Mount-cache hash table entries: 256
[    0.010713] Initializing cgroup subsys memory
[    0.010741] Initializing cgroup subsys devices
[    0.010744] Initializing cgroup subsys freezer
[    0.010747] Initializing cgroup subsys blkio
[    0.010749] Initializing cgroup subsys perf_event
[    0.010753] Initializing cgroup subsys hugetlb
[    0.010787] CPU: Physical Processor ID: 0
[    0.010789] CPU: Processor Core ID: 0
[    0.010792] mce: CPU supports 6 MCE banks
[    0.010803] CPU0: Thermal monitoring enabled (TM2)
[    0.010814] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.010814] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
[    0.010814] tlb_flushall_shift: -1
[    0.010940] Freeing SMP alternatives memory: 24K (ffffffff81e54000 - 
ffffffff81e5a000)
[    0.014161] ACPI: Core revision 20130517
[    0.018631] ACPI: All ACPI Tables successfully acquired
[    0.020016] ftrace: allocating 27664 entries in 109 pages
[    0.032577] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.075617] smpboot: CPU0: Intel(R) Core(TM)2 CPU T7200  @ 2.00GHz 
(fam: 06, model: 0f, stepping: 06)
[    0.076000] Performance Events: PEBS fmt0-, 4-deep LBR, Core2 events, 
Intel PMU driver.
[    0.076000] perf_event_intel: PEBS disabled due to CPU errata
[    0.076000] ... version:                2
[    0.076000] ... bit width:              40
[    0.076000] ... generic registers:      2
[    0.076000] ... value mask:             000000ffffffffff
[    0.076000] ... max period:             000000007fffffff
[    0.076000] ... fixed-purpose events:   3
[    0.076000] ... event mask:             0000000700000003
[    0.076000] NMI watchdog: Disabled lockup detectors by default for 
full dynticks
[    0.076000] NMI watchdog: You can reactivate it with 'sysctl -w 
kernel.watchdog=1'
[    0.076000] smpboot: Booting Node   0, Processors  #1 OK
[    0.086478] Brought up 2 CPUs
[    0.086483] smpboot: Total of 2 processors activated (7980.30 BogoMIPS)
[    0.088153] devtmpfs: initialized
[    0.089275] EVM: security.selinux
[    0.089277] EVM: security.SMACK64
[    0.089279] EVM: security.capability
[    0.089320] PM: Registering ACPI NVS region [mem 
0xb7fce000-0xb7ffffff] (204800 bytes)
[    0.089320] regulator-dummy: no parameters
[    0.089320] NET: Registered protocol family 16
[    0.089360] ACPI: bus type PCI registered
[    0.089363] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.089432] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.089436] PCI: not using MMCONFIG
[    0.089438] PCI: Using configuration type 1 for base access
[    0.092083] bio: create slab <bio-0> at 0
[    0.092102] ACPI: Added _OSI(Module Device)
[    0.092105] ACPI: Added _OSI(Processor Device)
[    0.092108] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.092110] ACPI: Added _OSI(Processor Aggregator Device)
[    0.093923] ACPI: EC: Look up EC in DSDT
[    0.097206] ACPI: Executed 1 blocks of module-level executable AML code
[    0.100242] ACPI BIOS Warning (bug): Incorrect checksum in table 
[SSDT] - 0x83, should be 0x80 (20130517/tbprint-204)
[    0.100249] ACPI: SSDT 00000000b7fc8820 00CC3 (v01    AMI CPU1PM 
00000001 INTL 20051117)
[    0.100723] ACPI: Dynamic OEM Table Load:
[    0.100727] ACPI: SSDT           (null) 00CC3 (v01    AMI CPU1PM 
00000001 INTL 20051117)
[    0.100825] ACPI BIOS Warning (bug): Incorrect checksum in table 
[SSDT] - 0x4D, should be 0x13 (20130517/tbprint-204)
[    0.100830] ACPI: SSDT 00000000b7fc94f0 004A4 (v01    AMI CPU2PM 
00000001 INTL 20051117)
[    0.101300] ACPI: Dynamic OEM Table Load:
[    0.101303] ACPI: SSDT           (null) 004A4 (v01    AMI CPU2PM 
00000001 INTL 20051117)
[    0.101588] ACPI: Interpreter enabled
[    0.101597] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep 
State [\_S1_] (20130517/hwxface-571)
[    0.101603] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep 
State [\_S2_] (20130517/hwxface-571)
[    0.101622] ACPI: (supports S0 S3 S4 S5)
[    0.101624] ACPI: Using IOAPIC for interrupt routing
[    0.101649] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.106389] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in 
ACPI motherboard resources
[    0.106394] PCI: MMCONFIG for 0000 [bus00-3f] at [mem 
0xe0000000-0xe3ffffff] (base 0xe0000000) (size reduced!)
[    0.111180] PCI: Ignoring host bridge windows from ACPI; if 
necessary, use "pci=use_crs" and report a bug
[    0.111297] ACPI: No dock devices found.
[    0.112593] ACPI: Power Resource [GFAN] (off)
[    0.129768] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.129884] acpi PNP0A08:00: host bridge window [io 0x0000-0x0cf7] 
(ignored)
[    0.129887] acpi PNP0A08:00: host bridge window [io 0x0d00-0xffff] 
(ignored)
[    0.129890] acpi PNP0A08:00: host bridge window [mem 
0x000a0000-0x000bffff] (ignored)
[    0.129893] acpi PNP0A08:00: host bridge window [mem 
0x000d0000-0x000dffff] (ignored)
[    0.129896] acpi PNP0A08:00: host bridge window [mem 
0xb8000000-0xffffffff] (ignored)
[    0.129899] PCI: root bus 00: using default resources
[    0.129902] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 
0000 [bus 00-3f] only partially covers this bridge
[    0.130024] PCI host bridge to bus 0000:00
[    0.130028] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.130031] pci_bus 0000:00: root bus resource [io 0x0000-0xffff]
[    0.130034] pci_bus 0000:00: root bus resource [mem 
0x00000000-0xfffffffff]
[    0.130046] pci 0000:00:00.0: [8086:27a0] type 00 class 0x060000
[    0.130166] pci 0000:00:01.0: [8086:27a1] type 01 class 0x060400
[    0.130218] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.130272] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.130362] pci 0000:00:1b.0: [8086:27d8] type 00 class 0x040300
[    0.130386] pci 0000:00:1b.0: reg 0x10: [mem 0xfebfc000-0xfebfffff 64bit]
[    0.130492] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.130553] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.130599] pci 0000:00:1c.0: [8086:27d0] type 01 class 0x060400
[    0.130709] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.130773] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.130820] pci 0000:00:1c.2: [8086:27d4] type 01 class 0x060400
[    0.130931] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.130995] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.131040] pci 0000:00:1c.3: [8086:27d6] type 01 class 0x060400
[    0.131150] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.131220] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.131265] pci 0000:00:1d.0: [8086:27c8] type 00 class 0x0c0300
[    0.131323] pci 0000:00:1d.0: reg 0x20: [io  0xec00-0xec1f]
[    0.131424] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.131466] pci 0000:00:1d.1: [8086:27c9] type 00 class 0x0c0300
[    0.131524] pci 0000:00:1d.1: reg 0x20: [io  0xe880-0xe89f]
[    0.131632] pci 0000:00:1d.2: [8086:27ca] type 00 class 0x0c0300
[    0.131689] pci 0000:00:1d.2: reg 0x20: [io  0xe800-0xe81f]
[    0.131787] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.131828] pci 0000:00:1d.3: [8086:27cb] type 00 class 0x0c0300
[    0.131886] pci 0000:00:1d.3: reg 0x20: [io  0xe480-0xe49f]
[    0.132010] pci 0000:00:1d.3: System wakeup disabled by ACPI
[    0.132063] pci 0000:00:1d.7: [8086:27cc] type 00 class 0x0c0320
[    0.132089] pci 0000:00:1d.7: reg 0x10: [mem 0xfebfbc00-0xfebfbfff]
[    0.132197] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.132255] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.132299] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.132426] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.132473] pci 0000:00:1f.0: [8086:27b9] type 00 class 0x060100
[    0.132591] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.132600] pci 0000:00:1f.0: address space collision: [io 
0x0800-0x087f] conflicts with ACPI CPU throttle [??? 
0x00000810-0x00000815 flags 0x80000000]
[    0.132607] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by 
ICH6 GPIO
[    0.132612] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 
0a00 (mask 007f)
[    0.132617] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 
06f0 (mask 007f)
[    0.132622] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 
0250 (mask 000f)
[    0.132751] pci 0000:00:1f.2: [8086:27c4] type 00 class 0x010180
[    0.132773] pci 0000:00:1f.2: reg 0x10: [io  0x0000-0x0007]
[    0.132786] pci 0000:00:1f.2: reg 0x14: [io  0x0000-0x0003]
[    0.132799] pci 0000:00:1f.2: reg 0x18: [io  0x0000-0x0007]
[    0.132811] pci 0000:00:1f.2: reg 0x1c: [io  0x0000-0x0003]
[    0.132824] pci 0000:00:1f.2: reg 0x20: [io  0xffa0-0xffaf]
[    0.132882] pci 0000:00:1f.2: PME# supported from D3hot
[    0.133035] pci 0000:01:00.0: [1002:71d5] type 00 class 0x030000
[    0.133052] pci 0000:01:00.0: reg 0x10: [mem 0xc0000000-0xcfffffff pref]
[    0.133064] pci 0000:01:00.0: reg 0x14: [io  0xb000-0xb0ff]
[    0.133076] pci 0000:01:00.0: reg 0x18: [mem 0xfdff0000-0xfdffffff]
[    0.133116] pci 0000:01:00.0: reg 0x30: [mem 0xfdfc0000-0xfdfdffff pref]
[    0.133169] pci 0000:01:00.0: supports D1 D2
[    0.133219] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  
You can enable it with 'pcie_aspm=force'
[    0.133229] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.133233] pci 0000:00:01.0:   bridge window [io 0x9000-0xbfff]
[    0.133237] pci 0000:00:01.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.133242] pci 0000:00:01.0:   bridge window [mem 
0xbdf00000-0xddefffff 64bit pref]
[    0.133436] pci 0000:02:00.0: [8086:4222] type 00 class 0x028000
[    0.133493] pci 0000:02:00.0: reg 0x10: [mem 0xfe0ff000-0xfe0fffff]
[    0.133914] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.134020] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  
You can enable it with 'pcie_aspm=force'
[    0.134049] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.134057] pci 0000:00:1c.0:   bridge window [mem 0xfe000000-0xfe0fffff]
[    0.134174] pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000
[    0.134200] pci 0000:03:00.0: reg 0x10: [io  0xc800-0xc8ff]
[    0.134242] pci 0000:03:00.0: reg 0x18: [mem 0xfe1ff000-0xfe1fffff 64bit]
[    0.134293] pci 0000:03:00.0: reg 0x30: [mem 0xfe1e0000-0xfe1effff pref]
[    0.134405] pci 0000:03:00.0: supports D1 D2
[    0.134408] pci 0000:03:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.134466] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  
You can enable it with 'pcie_aspm=force'
[    0.134480] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.134485] pci 0000:00:1c.2:   bridge window [io 0xc000-0xcfff]
[    0.134491] pci 0000:00:1c.2:   bridge window [mem 0xfe100000-0xfe1fffff]
[    0.134612] acpiphp: Slot [1] registered
[    0.134622] pci 0000:00:1c.3: PCI bridge to [bus 04-05]
[    0.134628] pci 0000:00:1c.3:   bridge window [io 0x0000-0x0fff]
[    0.134633] pci 0000:00:1c.3:   bridge window [mem 0x00000000-0x000fffff]
[    0.134642] pci 0000:00:1c.3:   bridge window [mem 
0x00000000-0x000fffff 64bit pref]
[    0.134718] pci 0000:06:00.0: [1180:0832] type 00 class 0x0c0010
[    0.134743] pci 0000:06:00.0: reg 0x10: [mem 0xfeaff800-0xfeafffff]
[    0.134845] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.134871] pci 0000:06:00.0: System wakeup disabled by ACPI
[    0.134917] pci 0000:06:00.1: [1180:0822] type 00 class 0x080500
[    0.134941] pci 0000:06:00.1: reg 0x10: [mem 0xfeaff400-0xfeaff4ff]
[    0.135040] pci 0000:06:00.1: supports D1 D2
[    0.135042] pci 0000:06:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.135109] pci 0000:06:00.2: [1180:0592] type 00 class 0x088000
[    0.135133] pci 0000:06:00.2: reg 0x10: [mem 0xfeaff000-0xfeaff0ff]
[    0.135234] pci 0000:06:00.2: supports D1 D2
[    0.135237] pci 0000:06:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.135300] pci 0000:06:00.3: [1180:0852] type 00 class 0x088000
[    0.135323] pci 0000:06:00.3: reg 0x10: [mem 0xfeafec00-0xfeafecff]
[    0.135424] pci 0000:06:00.3: supports D1 D2
[    0.135426] pci 0000:06:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.135542] pci 0000:00:1e.0: PCI bridge to [bus 06] (subtractive decode)
[    0.135551] pci 0000:00:1e.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.135560] pci 0000:00:1e.0:   bridge window [io 0x0000-0xffff] 
(subtractive decode)
[    0.135563] pci 0000:00:1e.0:   bridge window [mem 
0x00000000-0xfffffffff] (subtractive decode)
[    0.135594] acpi PNP0A08:00: ACPI _OSC support notification failed, 
disabling PCIe ASPM
[    0.135597] acpi PNP0A08:00: Unable to request _OSC control (_OSC 
support mask: 0x08)
[    0.144081] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 
14 15)
[    0.144153] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 
14 15)
[    0.144223] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 12 
14 15)
[    0.144292] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 
14 15)
[    0.144360] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 
14 15)
[    0.144429] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 *4 5 6 7 10 11 12 
14 15)
[    0.144498] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 
14 15)
[    0.144567] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 *6 7 10 11 12 
14 15)
[    0.144871] ACPI: Enabled 5 GPEs in block 00 to 1F
[    0.144880] ACPI: \_SB_.PCI0: notify handler is installed
[    0.144938] Found 1 acpi root devices
[    0.145008] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.145106] vgaarb: device added: 
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.145106] vgaarb: loaded
[    0.145106] vgaarb: bridge control possible 0000:01:00.0
[    0.145106] SCSI subsystem initialized
[    0.145106] ACPI: bus type ATA registered
[    0.145106] libata version 3.00 loaded.
[    0.145106] ACPI: bus type USB registered
[    0.145106] usbcore: registered new interface driver usbfs
[    0.145106] usbcore: registered new interface driver hub
[    0.145106] usbcore: registered new device driver usb
[    0.145106] PCI: Using ACPI for IRQ routing
[    0.145795] PCI: pci_cache_line_size set to 64 bytes
[    0.145874] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.145876] e820: reserve RAM buffer [mem 0xb7fc0000-0xb7ffffff]
[    0.145986] NetLabel: Initializing
[    0.145988] NetLabel:  domain hash size = 128
[    0.145990] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.146005] NetLabel:  unlabeled traffic allowed by default
[    0.148167] hpet clockevent registered
[    0.148172] HPET: 3 timers in total, 0 timers will be used for 
per-cpu timer
[    0.148178] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.148183] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.150189] Switched to clocksource hpet
[    0.156510] AppArmor: AppArmor Filesystem Enabled
[    0.156551] pnp: PnP ACPI init
[    0.156569] ACPI: bus type PNP registered
[    0.156678] system 00:00: [mem 0xfed13000-0xfed19fff] has been reserved
[    0.156684] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.156756] pnp 00:01: [dma 4]
[    0.156780] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.156834] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.156897] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b 
(active)
[    0.156975] pnp 00:04: Plug and Play ACPI device, IDs SYN0a06 SYN0a00 
SYN0002 PNP0f03 PNP0f13 PNP0f12 (active)
[    0.157008] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.157041] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.157229] pnp 00:07: [dma 0 disabled]
[    0.157338] pnp 00:07: Plug and Play ACPI device, IDs SMCf010 (active)
[    0.157437] system 00:08: [io  0x0a00-0x0a0f] has been reserved
[    0.157441] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.157609] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.157613] system 00:09: [io  0x0800-0x087f] could not be reserved
[    0.157616] system 00:09: [io  0x0480-0x04bf] has been reserved
[    0.157620] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.157623] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.157626] system 00:09: [mem 0xfed45000-0xfed89fff] has been reserved
[    0.157630] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.157718] system 00:0a: [mem 0xffb80000-0xffbfffff] has been reserved
[    0.157722] system 00:0a: [mem 0xfff80000-0xffffffff] has been reserved
[    0.157726] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.157805] system 00:0b: [mem 0xffc00000-0xfff7ffff] has been reserved
[    0.157809] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.157893] system 00:0c: [io  0x0400-0x041f] has been reserved
[    0.157897] system 00:0c: [mem 0xfec00000-0xfec00fff] could not be 
reserved
[    0.157900] system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.157903] system 00:0c: [mem 0xfec10000-0xfec17fff] has been reserved
[    0.157906] system 00:0c: [mem 0xfec18000-0xfec1ffff] has been reserved
[    0.157909] system 00:0c: [mem 0xfec20000-0xfec27fff] has been reserved
[    0.157912] system 00:0c: [mem 0xfec28000-0xfec2ffff] has been reserved
[    0.157916] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.158040] system 00:0d: [mem 0xe0000000-0xe3ffffff] has been reserved
[    0.158045] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.164195] system 00:0e: [mem 0x00000000-0x0009ffff] could not be 
reserved
[    0.164199] system 00:0e: [mem 0x000c0000-0x000cffff] could not be 
reserved
[    0.164202] system 00:0e: [mem 0x000e0000-0x000fffff] could not be 
reserved
[    0.164206] system 00:0e: [mem 0x00100000-0xb7ffffff] could not be 
reserved
[    0.164210] system 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.164367] pnp: PnP ACPI: found 15 devices
[    0.164369] ACPI: bus type PNP unregistered
[    0.171826] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to 
[bus 02] add_size 1000
[    0.171832] pci 0000:00:1c.0: bridge window [mem 
0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[    0.171844] pci 0000:00:1c.2: bridge window [mem 
0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
[    0.171861] pci 0000:00:1c.3: bridge window [io  0x1000-0x0fff] to 
[bus 04-05] add_size 1000
[    0.171864] pci 0000:00:1c.3: bridge window [mem 
0x00100000-0x000fffff 64bit pref] to [bus 04-05] add_size 200000
[    0.171868] pci 0000:00:1c.3: bridge window [mem 
0x00100000-0x000fffff] to [bus 04-05] add_size 200000
[    0.171887] pci 0000:00:1f.0: BAR 13: [io  0x0800-0x087f] has bogus 
alignment
[    0.171892] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 
64bit pref] get_res_add_size add_size 200000
[    0.171895] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x000fffff 
64bit pref] get_res_add_size add_size 200000
[    0.171898] pci 0000:00:1c.3: res[14]=[mem 0x00100000-0x000fffff] 
get_res_add_size add_size 200000
[    0.171901] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x000fffff 
64bit pref] get_res_add_size add_size 200000
[    0.171904] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] 
get_res_add_size add_size 1000
[    0.171907] pci 0000:00:1c.3: res[13]=[io  0x1000-0x0fff] 
get_res_add_size add_size 1000
[    0.171913] pci 0000:00:1c.0: BAR 15: assigned [mem 
0xb8000000-0xb81fffff 64bit pref]
[    0.171916] pci 0000:00:1c.2: BAR 15: assigned [mem 
0xb8200000-0xb83fffff 64bit pref]
[    0.171919] pci 0000:00:1c.3: BAR 14: assigned [mem 
0xb8400000-0xb85fffff]
[    0.171923] pci 0000:00:1c.3: BAR 15: assigned [mem 
0xb8600000-0xb87fffff 64bit pref]
[    0.171927] pci 0000:00:1c.0: BAR 13: assigned [io 0x1000-0x1fff]
[    0.171930] pci 0000:00:1c.3: BAR 13: assigned [io 0x2000-0x2fff]
[    0.171935] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.171939] pci 0000:00:01.0:   bridge window [io 0x9000-0xbfff]
[    0.171944] pci 0000:00:01.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.171948] pci 0000:00:01.0:   bridge window [mem 
0xbdf00000-0xddefffff 64bit pref]
[    0.171953] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.171957] pci 0000:00:1c.0:   bridge window [io 0x1000-0x1fff]
[    0.171964] pci 0000:00:1c.0:   bridge window [mem 0xfe000000-0xfe0fffff]
[    0.171970] pci 0000:00:1c.0:   bridge window [mem 
0xb8000000-0xb81fffff 64bit pref]
[    0.171978] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.171982] pci 0000:00:1c.2:   bridge window [io 0xc000-0xcfff]
[    0.171989] pci 0000:00:1c.2:   bridge window [mem 0xfe100000-0xfe1fffff]
[    0.171994] pci 0000:00:1c.2:   bridge window [mem 
0xb8200000-0xb83fffff 64bit pref]
[    0.172014] pci 0000:00:1c.3: PCI bridge to [bus 04-05]
[    0.172018] pci 0000:00:1c.3:   bridge window [io 0x2000-0x2fff]
[    0.172025] pci 0000:00:1c.3:   bridge window [mem 0xb8400000-0xb85fffff]
[    0.172031] pci 0000:00:1c.3:   bridge window [mem 
0xb8600000-0xb87fffff 64bit pref]
[    0.172040] pci 0000:00:1e.0: PCI bridge to [bus 06]
[    0.172046] pci 0000:00:1e.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.172139] pci 0000:00:1c.0: enabling device (0106 -> 0107)
[    0.172258] pci 0000:00:1c.3: enabling device (0100 -> 0103)
[    0.172327] pci 0000:00:1e.0: setting latency timer to 64
[    0.172333] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.172336] pci_bus 0000:00: resource 5 [mem 0x00000000-0xfffffffff]
[    0.172339] pci_bus 0000:01: resource 0 [io  0x9000-0xbfff]
[    0.172341] pci_bus 0000:01: resource 1 [mem 0xfdf00000-0xfdffffff]
[    0.172344] pci_bus 0000:01: resource 2 [mem 0xbdf00000-0xddefffff 
64bit pref]
[    0.172347] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.172350] pci_bus 0000:02: resource 1 [mem 0xfe000000-0xfe0fffff]
[    0.172353] pci_bus 0000:02: resource 2 [mem 0xb8000000-0xb81fffff 
64bit pref]
[    0.172355] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.172358] pci_bus 0000:03: resource 1 [mem 0xfe100000-0xfe1fffff]
[    0.172361] pci_bus 0000:03: resource 2 [mem 0xb8200000-0xb83fffff 
64bit pref]
[    0.172364] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.172366] pci_bus 0000:04: resource 1 [mem 0xb8400000-0xb85fffff]
[    0.172369] pci_bus 0000:04: resource 2 [mem 0xb8600000-0xb87fffff 
64bit pref]
[    0.172372] pci_bus 0000:06: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.172375] pci_bus 0000:06: resource 4 [io  0x0000-0xffff]
[    0.172378] pci_bus 0000:06: resource 5 [mem 0x00000000-0xfffffffff]
[    0.172422] NET: Registered protocol family 2
[    0.172646] TCP established hash table entries: 32768 (order: 7, 
524288 bytes)
[    0.172948] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.173193] TCP: Hash tables configured (established 32768 bind 32768)
[    0.173251] TCP: reno registered
[    0.173262] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.173300] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.173401] NET: Registered protocol family 1
[    0.174091] pci 0000:01:00.0: Boot video device
[    0.174116] PCI: CLS 32 bytes, default 64
[    0.174181] Trying to unpack rootfs image as initramfs...
[    0.527152] Freeing initrd memory: 14760K (ffff88003631c000 - 
ffff880037186000)
[    0.527222] Simple Boot Flag at 0x52 set to 0x1
[    0.527427] Scanning for low memory corruption every 60 seconds
[    0.527757] Initialise module verification
[    0.527830] audit: initializing netlink socket (disabled)
[    0.527850] type=2000 audit(1378646331.524:1): initialized
[    0.561001] bounce pool size: 64 pages
[    0.561022] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.562900] VFS: Disk quotas dquot_6.5.2
[    0.562955] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.563613] fuse init (API version 7.22)
[    0.563714] msgmni has been set to 5761
[    0.564362] Key type asymmetric registered
[    0.564365] Asymmetric key parser 'x509' registered
[    0.564405] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 252)
[    0.564453] io scheduler noop registered
[    0.564456] io scheduler deadline registered (default)
[    0.564488] io scheduler cfq registered
[    0.564623] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.564699] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.564791] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    0.564892] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    0.564989] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.565011] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.565085] intel_idle: does not run on family 6 model 15
[    0.565205] ACPI: AC Adapter [AC0] (on-line)
[    0.565320] input: Lid Switch as 
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.566854] ACPI: Lid Switch [LID]
[    0.566900] input: Power Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.566905] ACPI: Power Button [PWRB]
[    0.566946] input: Sleep Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.566950] ACPI: Sleep Button [SLPB]
[    0.566991] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.566994] ACPI: Power Button [PWRF]
[    0.567061] ACPI: Fan [FN00] (off)
[    0.567109] ACPI: Requesting acpi_cpufreq
[    0.580079] Monitor-Mwait will be used to enter C-1 state
[    0.580087] Monitor-Mwait will be used to enter C-2 state
[    0.580091] tsc: Marking TSC unstable due to TSC halts in idle
[    0.580096] ACPI: acpi_idle registered with cpuidle
[    0.620155] thermal LNXTHERM:00: registered as thermal_zone0
[    0.620158] ACPI: Thermal Zone [THRM] (60 C)
[    0.620202] GHES: HEST is not enabled!
[    0.620297] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.641111] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.642841] Linux agpgart interface v0.103
[    0.644801] brd: module loaded
[    0.646380] loop: module loaded
[    0.646719] ata_piix 0000:00:1f.2: version 2.13
[    0.646899] ata_piix 0000:00:1f.2: MAP [
[    0.646901]  P0 P2 IDE IDE ]
[    0.647011] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.647664] scsi0 : ata_piix
[    0.648459] scsi1 : ata_piix
[    0.648944] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 
irq 14
[    0.648947] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 
irq 15
[    0.649301] libphy: Fixed MDIO Bus: probed
[    0.649409] tun: Universal TUN/TAP device driver, 1.6
[    0.649411] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.649508] PPP generic driver version 2.4.2
[    0.649607] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.649610] ehci-pci: EHCI PCI platform driver
[    0.649697] ehci-pci 0000:00:1d.7: setting latency timer to 64
[    0.649711] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    0.649720] ehci-pci 0000:00:1d.7: new USB bus registered, assigned 
bus number 1
[    0.649738] ehci-pci 0000:00:1d.7: debug port 1
[    0.653658] ehci-pci 0000:00:1d.7: cache line size of 32 is not supported
[    0.653686] ehci-pci 0000:00:1d.7: irq 23, io mem 0xfebfbc00
[    0.664022] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.664077] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.664080] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.664083] usb usb1: Product: EHCI Host Controller
[    0.664086] usb usb1: Manufacturer: Linux 3.11.0 ehci_hcd
[    0.664088] usb usb1: SerialNumber: 0000:00:1d.7
[    0.664228] hub 1-0:1.0: USB hub found
[    0.664234] hub 1-0:1.0: 8 ports detected
[    0.664545] ehci-platform: EHCI generic platform driver
[    0.664555] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.664557] ohci-pci: OHCI PCI platform driver
[    0.664571] ohci-platform: OHCI generic platform driver
[    0.664579] uhci_hcd: USB Universal Host Controller Interface driver
[    0.664719] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.664724] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.664730] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    0.664821] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000ec00
[    0.664872] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.664875] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.664878] usb usb2: Product: UHCI Host Controller
[    0.664880] usb usb2: Manufacturer: Linux 3.11.0 uhci_hcd
[    0.664883] usb usb2: SerialNumber: 0000:00:1d.0
[    0.665033] hub 2-0:1.0: USB hub found
[    0.665039] hub 2-0:1.0: 2 ports detected
[    0.665333] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.665375] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.665389] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 3
[    0.665489] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e880
[    0.665566] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.665570] usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.665572] usb usb3: Product: UHCI Host Controller
[    0.665575] usb usb3: Manufacturer: Linux 3.11.0 uhci_hcd
[    0.665578] usb usb3: SerialNumber: 0000:00:1d.1
[    0.665740] hub 3-0:1.0: USB hub found
[    0.665745] hub 3-0:1.0: 2 ports detected
[    0.665885] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.665890] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.665896] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 4
[    0.665935] uhci_hcd 0000:00:1d.2: irq 20, io base 0x0000e800
[    0.665973] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.665977] usb usb4: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.665979] usb usb4: Product: UHCI Host Controller
[    0.665982] usb usb4: Manufacturer: Linux 3.11.0 uhci_hcd
[    0.665984] usb usb4: SerialNumber: 0000:00:1d.2
[    0.666084] hub 4-0:1.0: USB hub found
[    0.666089] hub 4-0:1.0: 2 ports detected
[    0.666389] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    0.666412] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    0.666419] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned 
bus number 5
[    0.666457] uhci_hcd 0000:00:1d.3: irq 22, io base 0x0000e480
[    0.666523] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.666526] usb usb5: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.666528] usb usb5: Product: UHCI Host Controller
[    0.666563] usb usb5: Manufacturer: Linux 3.11.0 uhci_hcd
[    0.666566] usb usb5: SerialNumber: 0000:00:1d.3
[    0.666736] hub 5-0:1.0: USB hub found
[    0.666744] hub 5-0:1.0: 2 ports detected
[    0.667065] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] 
at 0x60,0x64 irq 1,12
[    0.680878] i8042: Detected active multiplexing controller, rev 1.1
[    0.690949] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.690955] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.690972] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.690975] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.690978] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.691163] mousedev: PS/2 mouse device common for all mice
[    0.691389] rtc_cmos 00:02: RTC can wake from S4
[    0.691582] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.691617] rtc_cmos 00:02: alarms up to one month, 114 bytes nvram, 
hpet irqs
[    0.691698] device-mapper: uevent: version 1.0.3
[    0.691778] device-mapper: ioctl: 4.25.0-ioctl (2013-06-26) 
initialised: dm-devel@redhat.com
[    0.691829] cpuidle: using governor ladder
[    0.691882] cpuidle: using governor menu
[    0.691894] ledtrig-cpu: registered to indicate activity on CPUs
[    0.692060] ashmem: initialized
[    0.692246] TCP: cubic registered
[    0.692373] NET: Registered protocol family 10
[    0.692625] NET: Registered protocol family 17
[    0.692637] Key type dns_resolver registered
[    0.692924] Loading module verification certificates
[    0.694168] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: 
fcc365353b3ecab47ade33fab05801e652383ac5'
[    0.694184] registered taskstats version 1
[    0.697415] Key type trusted registered
[    0.700167] Key type encrypted registered
[    0.703386] rtc_cmos 00:02: setting system clock to 2013-09-08 
13:18:52 UTC (1378646332)
[    0.708917] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.708920] EDD information not available.
[    0.724618] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input4
[    0.824561] ata2.01: ATAPI: HL-DT-ST DVDRAM GSA-T10N, PR03, max UDMA/33
[    0.824874] ata1.00: ATA-8: WDC WD5000BEVT-00ZAT0, 01.01A01, max UDMA/133
[    0.824881] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    0.832720] ata1.00: configured for UDMA/133
[    0.840324] ata2.01: configured for UDMA/33
[    0.892503] ACPI: Battery Slot [BAT0] (battery present)
[    0.892688] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000BEVT-0 
01.0 PQ: 0 ANSI: 5
[    0.892823] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 
GB/465 GiB)
[    0.892843] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.892893] sd 0:0:0:0: [sda] Write Protect is off
[    0.892897] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.892924] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.896230] scsi 1:0:1:0: CD-ROM            HL-DT-ST DVDRAM GSA-T10N  
PR03 PQ: 0 ANSI: 5
[    0.901465] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw 
xa/form2 cdda tray
[    0.901471] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.901662] sr 1:0:1:0: Attached scsi CD-ROM sr0
[    0.901800] sr 1:0:1:0: Attached scsi generic sg1 type 5
[    0.926775]  sda: sda1 sda2 sda3 sda4
[    0.927316] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.929583] Freeing unused kernel memory: 1352K (ffffffff81d02000 - 
ffffffff81e54000)
[    0.929587] Write protecting the kernel read-only data: 12288k
[    0.933759] Freeing unused kernel memory: 976K (ffff88000170c000 - 
ffff880001800000)
[    0.937411] Freeing unused kernel memory: 888K (ffff880001b22000 - 
ffff880001c00000)
[    0.959834] udevd[103]: starting version 175
[    1.030532] mii: module verification failed: signature and/or 
required key missing - tainting kernel
[    1.031252] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.031268] r8169 0000:03:00.0: can't disable ASPM; OS doesn't have 
ASPM control
[    1.031514] sdhci: Secure Digital Host Controller Interface driver
[    1.031516] sdhci: Copyright(c) Pierre Ossman
[    1.031538] r8169 0000:03:00.0: irq 44 for MSI/MSI-X
[    1.031743] r8169 0000:03:00.0 eth0: RTL8168b/8111b at 
0xffffc9000060a000, 00:18:f3:ce:a6:5c, XID 18000000 IRQ 44
[    1.031747] r8169 0000:03:00.0 eth0: jumbo features [frames: 4080 
bytes, tx checksumming: ko]
[    1.031812] sdhci-pci 0000:06:00.1: SDHCI controller found 
[1180:0822] (rev 19)
[    1.032872] sdhci-pci 0000:06:00.1: Will use DMA mode even though HW 
doesn't fully claim to support it.
[    1.061960] mmc0: no vqmmc regulator found
[    1.061966] mmc0: no vmmc regulator found
[    1.062995] sdhci-pci 0000:06:00.1: Will use DMA mode even though HW 
doesn't fully claim to support it.
[    1.065917] mmc0: SDHCI controller on PCI [0000:06:00.1] using DMA
[    1.136145] firewire_ohci 0000:06:00.0: added OHCI v1.0 device as 
card 0, 4 IR + 4 IT contexts, quirks 0x11
[    1.292078] usb 1-4: new high-speed USB device number 4 using ehci-pci
[    1.435302] usb 1-4: New USB device found, idVendor=0ac8, idProduct=0321
[    1.435306] usb 1-4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    1.435309] usb 1-4: Product: USB2.0 Web Camera
[    1.435311] usb 1-4: Manufacturer: Vimicro Corp.
[    1.582053] kjournald starting.  Commit interval 5 seconds
[    1.582123] EXT3-fs (sda1): mounted filesystem with ordered data mode
[    1.636254] firewire_core 0000:06:00.0: created device fw0: GUID 
00e0180003755d78, S400
[    1.932055] usb 2-2: new low-speed USB device number 2 using uhci_hcd
[    2.183896] usb 2-2: New USB device found, idVendor=1241, idProduct=1503
[    2.183904] usb 2-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    2.183910] usb 2-2: Product: USB Keyboard
[    2.183916] usb 2-2: Manufacturer:
[    2.428054] usb 3-1: new full-speed USB device number 2 using uhci_hcd
[    2.670560] usb 3-1: New USB device found, idVendor=0b05, idProduct=1712
[    2.670570] usb 3-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=3
[    2.670576] usb 3-1: SerialNumber: 0194E8-5B-0002
[    2.912051] usb 5-2: new full-speed USB device number 2 using uhci_hcd
[    3.167528] usb 5-2: New USB device found, idVendor=046d, idProduct=0a29
[    3.167537] usb 5-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[    3.167543] usb 5-2: Product: Logitech Wireless Headset
[    3.167549] usb 5-2: Manufacturer: Logitech
[    3.167554] usb 5-2: SerialNumber: 000D44B83F6C
[   19.600242] Adding 8388604k swap on /dev/sda2.  Priority:-1 extents:1 
across:8388604k FS
[   19.716675] udevd[361]: starting version 175
[   20.047092] lp: driver loaded but no devices found
[   20.053945] intel_rng: FWH not detected
[   20.247576] ACPI: Video Device [VGA] (multi-head: yes  rom: no post: no)
[   20.247635] input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/LNXVIDEO:00/input/input5
[   20.296112] type=1400 audit(1378639152.092:2): apparmor="STATUS" 
operation="profile_load" name="/sbin/dhclient" pid=531 
comm="apparmor_parser"
[   20.296145] type=1400 audit(1378639152.092:3): apparmor="STATUS" 
operation="profile_replace" name="/sbin/dhclient" pid=690 
comm="apparmor_parser"
[   20.296536] type=1400 audit(1378639152.092:4): apparmor="STATUS" 
operation="profile_load" 
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=531 
comm="apparmor_parser"
[   20.296573] type=1400 audit(1378639152.092:5): apparmor="STATUS" 
operation="profile_replace" 
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=690 
comm="apparmor_parser"
[   20.296786] type=1400 audit(1378639152.092:6): apparmor="STATUS" 
operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" 
pid=531 comm="apparmor_parser"
[   20.296828] type=1400 audit(1378639152.092:7): apparmor="STATUS" 
operation="profile_replace" 
name="/usr/lib/connman/scripts/dhclient-script" pid=690 
comm="apparmor_parser"
[   20.357368] Bluetooth: Core ver 2.16
[   20.357790] NET: Registered protocol family 31
[   20.357794] Bluetooth: HCI device and connection manager initialized
[   20.357808] Bluetooth: HCI socket layer initialized
[   20.357812] Bluetooth: L2CAP socket layer initialized
[   20.357822] Bluetooth: SCO socket layer initialized
[   20.378001] ACPI Warning: 0x0000000000000828-0x000000000000082f 
SystemIO conflicts with Region \GPIS 1 (20130517/utaddress-251)
[   20.378009] ACPI Warning: 0x0000000000000828-0x000000000000082f 
SystemIO conflicts with Region \PMIO 2 (20130517/utaddress-251)
[   20.378014] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   20.378018] ACPI Warning: 0x00000000000004b0-0x00000000000004bf 
SystemIO conflicts with Region \GPIO 1 (20130517/utaddress-251)
[   20.378023] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   20.378025] ACPI Warning: 0x0000000000000480-0x00000000000004af 
SystemIO conflicts with Region \GPIO 1 (20130517/utaddress-251)
[   20.378029] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   20.378031] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   20.454046] cfg80211: Calling CRDA to update world regulatory domain
[   20.538467] cfg80211: World regulatory domain updated:
[   20.538471] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[   20.538474] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   20.538477] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 
mBi, 2000 mBm)
[   20.538479] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 
mBi, 2000 mBm)
[   20.538482] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   20.538484] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   20.658515] NET: Registered protocol family 23
[   20.679164] Linux video capture interface: v2.00
[   20.753026] hidraw: raw HID events driver (C) Jiri Kosina
[   20.788679] usbcore: registered new interface driver btusb
[   20.849412] r592 0000:06:00.2: setting latency timer to 64
[   20.849533] r592: driver successfully loaded
[   20.855185] leds_ss4200: no LED devices found
[   20.947021] asus_laptop: Asus Laptop Support version 0.42
[   20.964166] asus_laptop:   A8JP model detected
[   20.967062] input: Asus Laptop extra buttons as 
/devices/platform/asus_laptop/input/input6
[   21.050501] found SMC SuperIO Chip (devid=0x7a rev=01 base=0x002e): 
LPC47N227
[   21.050527] smsc_superio_flat(): fir: 0x6f8, sir: 0x2f8, dma: 15, 
irq: 3, mode: 0x0e
[   21.050533] smsc_ircc_present: can't get sir_base of 0x2f8
[   21.069436] gspca_main: v2.14.0 registered
[   21.151440] [drm] Initialized drm 1.1.0 20060810
[   21.186200] gspca_main: vc032x-2.14.0 probing 0ac8:0321
[   21.232654] usbcore: registered new interface driver usbhid
[   21.232662] usbhid: USB HID core driver
[   21.371604] usbcore: registered new interface driver vc032x
[   21.395570] input:   USB Keyboard as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input7
[   21.395808] hid-generic 0003:1241:1503.0001: input,hidraw0: USB HID 
v1.10 Keyboard [  USB Keyboard] on usb-0000:00:1d.0-2/input0
[   21.414037] input:   USB Keyboard as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input8
[   21.414347] hid-generic 0003:1241:1503.0002: input,hidraw1: USB HID 
v1.10 Device [  USB Keyboard] on usb-0000:00:1d.0-2/input1
[   21.418704] r852 0000:06:00.3: setting latency timer to 64
[   21.418783] r852: Non dma capable device detected, dma disabled
[   21.418794] r852: driver loaded successfully
[   21.419987] input: Logitech Logitech Wireless Headset as 
/devices/pci0000:00/0000:00:1d.3/usb5/5-2/5-2:1.3/input/input9
[   21.420162] hid-generic 0003:046D:0A29.0003: input,hiddev0,hidraw2: 
USB HID v1.11 Device [Logitech Logitech Wireless Headset] on 
usb-0000:00:1d.3-2/input3
[   21.524225] psmouse serio4: synaptics: Touchpad model: 1, fw: 6.2, 
id: 0x81a0b1, caps: 0xa04713/0x200000/0x0, board id: 3655, fw id: 204506
[   21.542835] usbcore: registered new interface driver snd-usb-audio
[   21.563489] input: SynPS/2 Synaptics TouchPad as 
/devices/platform/i8042/serio4/input/input10
[   21.597634] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network 
Connection driver for Linux, in-tree:s
[   21.597639] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[   21.597698] iwl3945 0000:02:00.0: can't disable ASPM; OS doesn't have 
ASPM control
[   21.641489] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[   21.652417] iwl3945 0000:02:00.0: Tunable channels: 13 802.11bg, 23 
802.11a channels
[   21.652422] iwl3945 0000:02:00.0: Detected Intel Wireless WiFi Link 
3945ABG
[   21.652488] iwl3945 0000:02:00.0: irq 46 for MSI/MSI-X
[   21.735445] ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
[   21.815156] [drm] radeon kernel modesetting enabled.
[   21.815522] [drm] initializing kernel modesetting (RV530 
0x1002:0x71D5 0x1043:0x1242).
[   21.815546] [drm] register mmio base: 0xFDFF0000
[   21.815548] [drm] register mmio size: 65536
[   21.815661] ATOM BIOS: Asus
[   21.815681] [drm] Generation 2 PCI interface, using max accessible memory
[   21.815687] radeon 0000:01:00.0: VRAM: 256M 0x0000000000000000 - 
0x000000000FFFFFFF (256M used)
[   21.815691] radeon 0000:01:00.0: GTT: 512M 0x0000000010000000 - 
0x000000002FFFFFFF
[   21.815712] [drm] Detected VRAM RAM=256M, BAR=256M
[   21.815714] [drm] RAM width 128bits DDR
[   21.815807] [TTM] Zone  kernel: Available graphics memory: 1476674 kiB
[   21.815809] [TTM] Initializing pool allocator
[   21.815815] [TTM] Initializing DMA pool allocator
[   21.815835] [drm] radeon: 256M of VRAM memory ready
[   21.815837] [drm] radeon: 512M of GTT memory ready.
[   21.815851] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   21.831538] [drm] radeon: 1 quad pipes, 2 z pipes initialized.
[   21.832966] [drm] PCIE GART of 512M enabled (table at 
0x0000000000040000).
[   21.832988] radeon 0000:01:00.0: WB enabled
[   21.832993] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 
0x0000000010000000 and cpu addr 0xffff88009f4cb000
[   21.832996] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   21.832997] [drm] Driver supports precise vblank timestamp query.
[   21.833023] radeon 0000:01:00.0: irq 47 for MSI/MSI-X
[   21.833038] radeon 0000:01:00.0: radeon: using MSI.
[   21.833065] [drm] radeon: irq initialized.
[   21.833155] [drm] Loading R500 Microcode
[   21.869921] [drm] radeon: ring at 0x0000000010001000
[   21.870018] [drm] ring test succeeded in 3 usecs
[   21.870220] [drm] ib test succeeded in 0 usecs
[   21.870850] [drm] Radeon Display Connectors
[   21.870924] [drm] Connector 0:
[   21.870926] [drm]   VGA-1
[   21.870929] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 
0x7e4c 0x7e4c
[   21.870930] [drm]   Encoders:
[   21.870932] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   21.870934] [drm] Connector 1:
[   21.870936] [drm]   LVDS-1
[   21.870938] [drm]   DDC: 0x7e30 0x7e30 0x7e34 0x7e34 0x7e38 0x7e38 
0x7e3c 0x7e3c
[   21.870939] [drm]   Encoders:
[   21.870941] [drm]     LCD1: INTERNAL_LVTM1
[   21.870943] [drm] Connector 2:
[   21.870944] [drm]   SVIDEO-1
[   21.870946] [drm]   Encoders:
[   21.870947] [drm]     TV1: INTERNAL_KLDSCP_DAC2
[   21.870949] [drm] Connector 3:
[   21.870951] [drm]   DVI-I-1
[   21.870952] [drm]   HPD1
[   21.870954] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 
0x7e5c 0x7e5c
[   21.870956] [drm]   Encoders:
[   21.870957] [drm]     DFP1: INTERNAL_KLDSCP_TMDS1
[   21.870976] [drm] radeon: power management initialized
[   22.317462] [drm] fb mappable at 0xC00C0000
[   22.317467] [drm] vram apper at 0xC0000000
[   22.317469] [drm] size 5300224
[   22.317470] [drm] fb depth is 24
[   22.317472] [drm]    pitch is 5888
[   22.317944] fbcon: radeondrmfb (fb0) is primary device
[   22.329040] EXT3-fs (sda1): using internal journal
[   22.740227] Console: switching to colour frame buffer device 180x56
[   22.744102] radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
[   22.744104] radeon 0000:01:00.0: registered panic notifier
[   22.744123] [drm] Initialized radeon 2.34.0 20080528 for 0000:01:00.0 
on minor 0
[   23.573071] kjournald starting.  Commit interval 5 seconds
[   23.573751] EXT3-fs (sda3): using internal journal
[   23.573756] EXT3-fs (sda3): mounted filesystem with ordered data mode
[   24.402668] init: failsafe main process (927) killed by TERM signal
[   24.614329] ppdev: user-space parallel port driver
[   24.683483] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   24.683488] Bluetooth: BNEP filters: protocol multicast
[   24.683501] Bluetooth: BNEP socket layer initialized
[   24.694596] type=1400 audit(1378639156.488:8): apparmor="STATUS" 
operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=1011 
comm="apparmor_parser"
[   24.695145] type=1400 audit(1378639156.488:9): apparmor="STATUS" 
operation="profile_load" name="/usr/sbin/cupsd" pid=1011 
comm="apparmor_parser"
[   24.708534] Bluetooth: RFCOMM TTY layer initialized
[   24.708553] Bluetooth: RFCOMM socket layer initialized
[   24.708555] Bluetooth: RFCOMM ver 1.11
[   24.727190] type=1400 audit(1378639156.520:10): apparmor="STATUS" 
operation="profile_replace" name="/sbin/dhclient" pid=1028 
comm="apparmor_parser"
[   24.727625] type=1400 audit(1378639156.520:11): apparmor="STATUS" 
operation="profile_replace" 
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1028 
comm="apparmor_parser"
[   24.810200] iwl3945 0000:02:00.0: loaded firmware version 15.32.2.9
[   24.886393] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   24.897347] r8169 0000:03:00.0 eth0: link down
[   24.897387] r8169 0000:03:00.0 eth0: link down
[   24.897515] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   25.112407] init: gdm main process (1115) killed by TERM signal
[   25.718722] init: plymouth-stop pre-start process (1345) terminated 
with status 1
[   26.601005] r8169 0000:03:00.0 eth0: link up
[   26.601018] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   31.984728] wlan0: authenticate with 00:23:08:57:a6:15
[   31.986392] wlan0: send auth to 00:23:08:57:a6:15 (try 1/3)
[   31.988174] wlan0: authenticated
[   31.992063] wlan0: associate with 00:23:08:57:a6:15 (try 1/3)
[   31.994678] wlan0: RX AssocResp from 00:23:08:57:a6:15 (capab=0x411 
status=0 aid=1)
[   32.003957] wlan0: associated
[   32.004038] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   32.004156] cfg80211: Calling CRDA for country: DE
[   32.011797] cfg80211: Regulatory domain changed to country: DE
[   32.011802] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[   32.011805] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
[   32.011808] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
[   32.011810] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
[   32.011812] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), 
(N/A, 2698 mBm)
[   36.006748] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   36.006765] Bluetooth: HIDP socket layer initialized
[   36.009556] hid-generic 0005:045E:0702.0004: unknown main item tag 0x0
[   36.009729] input: Microsoft Wireless Laser Mouse 8000 as 
/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/bluetooth/hci0/hci0:42/input11
[   36.014117] hid-generic 0005:045E:0702.0004: input,hidraw3: BLUETOOTH 
HID v0.80 Mouse [Microsoft Wireless Laser Mouse 8000] on 00:18:f3:af:cd:9b
[   94.220363] CE: hpet increased min_delta_ns to 20113 nsec
[  147.434749] gspca_main: ISOC data error: [14] len=0, status=-71
[  147.466741] gspca_main: ISOC data error: [3] len=0, status=-71
[  147.498771] gspca_main: ISOC data error: [19] len=0, status=-71
[  147.530787] gspca_main: ISOC data error: [27] len=0, status=-71
[  147.566798] gspca_main: ISOC data error: [3] len=0, status=-71
[  147.598822] gspca_main: ISOC data error: [18] len=0, status=-71
[  147.630827] gspca_main: ISOC data error: [23] len=0, status=-71
[  147.698873] gspca_main: ISOC data error: [14] len=0, status=-71
[  147.730891] gspca_main: ISOC data error: [30] len=0, status=-71
[  147.766903] gspca_main: ISOC data error: [6] len=0, status=-71
[  147.798926] gspca_main: ISOC data error: [21] len=0, status=-71
[  147.830934] gspca_main: ISOC data error: [26] len=0, status=-71
[  147.866950] gspca_main: ISOC data error: [2] len=0, status=-71
[  147.898971] gspca_main: ISOC data error: [17] len=0, status=-71
[  147.930981] gspca_main: ISOC data error: [25] len=0, status=-71
[  147.966998] gspca_main: ISOC data error: [1] len=0, status=-71
[  147.999019] gspca_main: ISOC data error: [17] len=0, status=-71
[  148.035029] gspca_main: ISOC data error: [0] len=0, status=-71
[  148.067055] gspca_main: ISOC data error: [5] len=0, status=-71
[  148.099061] gspca_main: ISOC data error: [13] len=0, status=-71
[  148.131094] gspca_main: ISOC data error: [28] len=0, status=-71
[  148.167101] gspca_main: ISOC data error: [4] len=0, status=-71
[  148.199125] gspca_main: ISOC data error: [20] len=0, status=-71
[  148.267147] gspca_main: ISOC data error: [0] len=0, status=-71
[  148.299171] gspca_main: ISOC data error: [16] len=0, status=-71
[  148.331197] gspca_main: ISOC data error: [31] len=0, status=-71
[  148.367203] gspca_main: ISOC data error: [7] len=0, status=-71
[  148.435239] gspca_main: ISOC data error: [6] len=0, status=-71
[  148.467249] gspca_main: ISOC data error: [3] len=0, status=-71
[  148.499266] gspca_main: ISOC data error: [11] len=0, status=-71
[  148.535281] gspca_main: ISOC data error: [2] len=0, status=-71
[  148.567311] gspca_main: ISOC data error: [10] len=0, status=-71
[  148.599323] gspca_main: ISOC data error: [18] len=0, status=-71
[  148.635342] gspca_main: ISOC data error: [9] len=0, status=-71
[  148.667352] gspca_main: ISOC data error: [6] len=0, status=-71
[  148.699369] gspca_main: ISOC data error: [14] len=0, status=-71
[  148.731381] gspca_main: ISOC data error: [22] len=0, status=-71
[  148.767411] gspca_main: ISOC data error: [13] len=0, status=-71
[  148.831448] gspca_main: ISOC data error: [29] len=0, status=-71
[  148.867460] gspca_main: ISOC data error: [20] len=0, status=-71
[  148.899447] gspca_main: ISOC data error: [9] len=0, status=-71
[  148.931470] gspca_main: ISOC data error: [25] len=0, status=-71
[  148.967501] gspca_main: ISOC data error: [1] len=0, status=-71
[  148.999529] gspca_main: ISOC data error: [16] len=0, status=-71
[  149.031531] gspca_main: ISOC data error: [21] len=0, status=-71
[  149.063542] gspca_main: ISOC data error: [29] len=0, status=-71
[  149.099566] gspca_main: ISOC data error: [12] len=0, status=-71
[  149.131582] gspca_main: ISOC data error: [20] len=0, status=-71
[  149.167602] gspca_main: ISOC data error: [4] len=0, status=-71
[  149.267646] gspca_main: ISOC data error: [0] len=0, status=-71
[  149.299664] gspca_main: ISOC data error: [8] len=0, status=-71
[  149.331686] gspca_main: ISOC data error: [23] len=0, status=-71
[  149.363697] gspca_main: ISOC data error: [31] len=0, status=-71
[  149.399725] gspca_main: ISOC data error: [15] len=0, status=-71
[  149.431730] gspca_main: ISOC data error: [19] len=0, status=-71
[  149.467748] gspca_main: ISOC data error: [3] len=0, status=-71
[  149.499769] gspca_main: ISOC data error: [11] len=0, status=-71
[  149.531780] gspca_main: ISOC data error: [19] len=0, status=-71
[  149.567796] gspca_main: ISOC data error: [2] len=0, status=-71
[  149.599815] gspca_main: ISOC data error: [7] len=0, status=-71
[  149.663850] gspca_main: ISOC data error: [30] len=0, status=-71
[  149.699863] gspca_main: ISOC data error: [6] len=0, status=-71
[  149.731889] gspca_main: ISOC data error: [22] len=0, status=-71
[  149.767902] gspca_main: ISOC data error: [5] len=0, status=-71
[  149.799922] gspca_main: ISOC data error: [13] len=0, status=-71
[  149.831931] gspca_main: ISOC data error: [18] len=0, status=-71
[  149.867945] gspca_main: ISOC data error: [1] len=0, status=-71
[  149.899969] gspca_main: ISOC data error: [9] len=0, status=-71
[  149.931982] gspca_main: ISOC data error: [17] len=0, status=-71
[  149.968008] gspca_main: ISOC data error: [8] len=0, status=-71
[  150.000021] gspca_main: ISOC data error: [5] len=0, status=-71
[  150.032039] gspca_main: ISOC data error: [21] len=0, status=-71
[  150.100081] gspca_main: ISOC data error: [12] len=0, status=-71
[  150.101051] show_signal_msg: 48 callbacks suppressed
[  150.101058] video_source:sr[2710]: segfault at 8 ip 00007f5db78cc68c 
sp 00007f5d8d64b900 error 4 in 
libgstreamer-0.10.so.0.30.0[7f5db7879000+de000]
[  150.132088] gspca_main: ISOC data error: [20] len=0, status=-71
[  150.164098] gspca_main: ISOC data error: [28] len=0, status=-71
[  150.200144] gspca_main: ISOC data error: [19] len=0, status=-71
[  150.232132] gspca_main: ISOC data error: [16] len=0, status=-71
[  150.268175] gspca_main: ISOC data error: [18] len=0, status=-71
[  150.300182] gspca_main: ISOC data error: [15] len=0, status=-71
[  150.332184] gspca_main: ISOC data error: [15] len=0, status=-71
[  150.364214] gspca_main: ISOC data error: [31] len=0, status=-71
[  150.400239] gspca_main: ISOC data error: [22] len=0, status=-71



