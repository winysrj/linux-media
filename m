Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:57350 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaLYLPn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Dec 2014 06:15:43 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so15351751wiw.10
        for <linux-media@vger.kernel.org>; Thu, 25 Dec 2014 03:15:41 -0800 (PST)
Received: from [192.168.10.221] (ip-81-11-230-94.dsl.scarlet.be. [81.11.230.94])
        by mx.google.com with ESMTPSA id i3sm15765138wjw.2.2014.12.25.03.15.38
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Dec 2014 03:15:40 -0800 (PST)
Message-ID: <549BF1DA.8050905@sanderdevrieze.net>
Date: Thu, 25 Dec 2014 12:15:38 +0100
From: Sander Devrieze <sander@sanderdevrieze.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: PROBLEM: Won't suspend when using DVB-t USB stick
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[1.] One line summary of the problem:

0ccd:00ab [Asus 901] Won't suspend using DVB-t USB stick


[2.] Full description of the problem/report:

Suspending the system while a radio or TV channel is actively playing 
using the Terratec Cinergy T USB XXS DVB-t USB stick in for example VLC, 
the system fails to suspend. The system will interact and will not wake 
up again. A hard reset of the computer is required.


[3.] Keywords (i.e., modules, networking, kernel):

[4.] Kernel version (from /proc/version):

Linux version 3.19.0-031900rc1-generic (apw@tangerine) (gcc version 
4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201412210135 SMP Sun Dec 21 
01:53:48 UTC 2014


[5.] Output of Oops.. message (if applicable) with symbolic information
      resolved (see Documentation/oops-tracing.txt)

[6.] A small shell script or example program which triggers the
      problem (if possible)

Execute pm-suspend during playback of a DVB-t stream (e.g. in VLC)


[7.] Environment

Description:	Ubuntu 12.04.5 LTS
Release:	12.04


[7.1.] Software (add the output of the ver_linux script here)

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux sander-901 3.19.0-031900rc1-generic #201412210135 SMP Sun Dec 21 
01:53:48 UTC 2014 i686 i686 i386 GNU/Linux

Gnu C                  4.6
Gnu make               3.81
binutils               2.22
util-linux             2.20.1
mount                  support
module-init-tools      3.16
e2fsprogs              1.42
pcmciautils            018
Linux C Library        2.15
Dynamic linker (ldd)   2.15
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.2
Sh-utils               8.13
wireless-tools         30
Modules Loaded         rpcsec_gss_krb5 nfsv4 ctr ccm rc_dib0700_rc5 
joydev snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel arc4 
snd_hda_controller rt2800pci snd_hda_codec rt2800mmio snd_hwdep 
rt2800lib dib7000p crc_ccitt snd_pcm rt2x00mmio dvb_usb_dib0700 
rt2x00pci dib0090 rt2x00lib uvcvideo dib7000m snd_seq_midi 
videobuf2_core v4l2_common dib0070 snd_rawmidi dvb_usb videodev mac80211 
dvb_core media snd_seq_midi_event rc_core cfg80211 i915 dib3000mc 
snd_seq dibx000_common videobuf2_vmalloc snd_timer videobuf2_memops 
lpc_ich psmouse snd_seq_device eeprom_93cx6 serio_raw drm_kms_helper snd 
eeepc_laptop drm soundcore video i2c_algo_bit sparse_keymap mac_hid 
parport_pc rfcomm bnep ppdev nfsd nfs_acl auth_rpcgss lp nfs bluetooth 
fscache parport lockd sunrpc binfmt_misc grace atl1e

[7.2.] Processor information (from /proc/cpuinfo):

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 28
model name	: Intel(R) Atom(TM) CPU N270   @ 1.60GHz
stepping	: 2
microcode	: 0x212
cpu MHz		: 1067.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc 
arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3 
xtpr pdcm movbe lahf_lm dtherm
bugs		:
bogomips	: 3200.09
clflush size	: 64
cache_alignment	: 64
address sizes	: 32 bits physical, 32 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 28
model name	: Intel(R) Atom(TM) CPU N270   @ 1.60GHz
stepping	: 2
microcode	: 0x212
cpu MHz		: 800.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc 
arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3 
xtpr pdcm movbe lahf_lm dtherm
bugs		:
bogomips	: 3200.09
clflush size	: 64
cache_alignment	: 64
address sizes	: 32 bits physical, 32 bits virtual
power management:


[7.3.] Module information (from /proc/modules):

rpcsec_gss_krb5 31491 0 - Live 0x00000000
nfsv4 412068 1 - Live 0x00000000
ctr 13025 2 - Live 0x00000000
ccm 17562 2 - Live 0x00000000
rc_dib0700_rc5 12460 0 - Live 0x00000000
joydev 17311 0 - Live 0x00000000
snd_hda_codec_realtek 68841 1 - Live 0x00000000
snd_hda_codec_generic 63667 1 snd_hda_codec_realtek, Live 0x00000000
snd_hda_intel 29576 3 - Live 0x00000000
arc4 12509 2 - Live 0x00000000
snd_hda_controller 30930 1 snd_hda_intel, Live 0x00000000
rt2800pci 13434 0 - Live 0x00000000
snd_hda_codec 121018 4 
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_controller, 
Live 0x00000000
rt2800mmio 20399 1 rt2800pci, Live 0x00000000
snd_hwdep 13276 1 snd_hda_codec, Live 0x00000000
rt2800lib 89231 2 rt2800pci,rt2800mmio, Live 0x00000000
dib7000p 36552 1 - Live 0x00000000
crc_ccitt 12627 1 rt2800lib, Live 0x00000000
snd_pcm 89214 3 snd_hda_intel,snd_hda_controller,snd_hda_codec, Live 
0x00000000
rt2x00mmio 13445 2 rt2800pci,rt2800mmio, Live 0x00000000
dvb_usb_dib0700 102088 0 - Live 0x00000000
rt2x00pci 13111 1 rt2800pci, Live 0x00000000
dib0090 37964 1 dvb_usb_dib0700, Live 0x00000000
rt2x00lib 53613 5 rt2800pci,rt2800mmio,rt2800lib,rt2x00mmio,rt2x00pci, 
Live 0x00000000
uvcvideo 78147 0 - Live 0x00000000
dib7000m 22994 1 dvb_usb_dib0700, Live 0x00000000
snd_seq_midi 13324 0 - Live 0x00000000
videobuf2_core 45571 1 uvcvideo, Live 0x00000000
v4l2_common 14442 1 videobuf2_core, Live 0x00000000
dib0070 18143 2 dvb_usb_dib0700, Live 0x00000000
snd_rawmidi 25786 1 snd_seq_midi, Live 0x00000000
dvb_usb 23898 1 dvb_usb_dib0700, Live 0x00000000
videodev 140634 3 uvcvideo,videobuf2_core,v4l2_common, Live 0x00000000
mac80211 642970 3 rt2800lib,rt2x00pci,rt2x00lib, Live 0x00000000
dvb_core 106259 2 dib7000p,dvb_usb, Live 0x00000000
media 21127 2 uvcvideo,videodev, Live 0x00000000
snd_seq_midi_event 14475 1 snd_seq_midi, Live 0x00000000
rc_core 26291 4 rc_dib0700_rc5,dvb_usb_dib0700,dvb_usb, Live 0x00000000
cfg80211 437514 2 rt2x00lib,mac80211, Live 0x00000000
i915 956606 3 - Live 0x00000000
dib3000mc 22906 1 dvb_usb_dib0700, Live 0x00000000
snd_seq 56978 2 snd_seq_midi,snd_seq_midi_event, Live 0x00000000
dibx000_common 18456 4 dib7000p,dvb_usb_dib0700,dib7000m,dib3000mc, Live 
0x00000000
videobuf2_vmalloc 13485 1 uvcvideo, Live 0x00000000
snd_timer 29036 2 snd_pcm,snd_seq, Live 0x00000000
videobuf2_memops 13170 1 videobuf2_vmalloc, Live 0x00000000
lpc_ich 17000 0 - Live 0x00000000
psmouse 106559 0 - Live 0x00000000
snd_seq_device 14451 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x00000000
eeprom_93cx6 13567 1 rt2800pci, Live 0x00000000
serio_raw 13251 0 - Live 0x00000000
drm_kms_helper 106489 1 i915, Live 0x00000000
snd 67102 16 
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, 
Live 0x00000000
eeepc_laptop 19290 0 - Live 0x00000000
drm 276007 5 i915,drm_kms_helper, Live 0x00000000
soundcore 14635 2 snd_hda_codec,snd, Live 0x00000000
video 20019 1 i915, Live 0x00000000
i2c_algo_bit 13316 1 i915, Live 0x00000000
sparse_keymap 13658 1 eeepc_laptop, Live 0x00000000
mac_hid 13099 0 - Live 0x00000000
parport_pc 32154 0 - Live 0x00000000
rfcomm 59314 0 - Live 0x00000000
bnep 19107 2 - Live 0x00000000
ppdev 17423 0 - Live 0x00000000
nfsd 265311 2 - Live 0x00000000
nfs_acl 12771 1 nfsd, Live 0x00000000
auth_rpcgss 53857 2 rpcsec_gss_krb5,nfsd, Live 0x00000000
lp 13359 0 - Live 0x00000000
nfs 218040 2 nfsv4, Live 0x00000000
bluetooth 444619 10 rfcomm,bnep, Live 0x00000000
fscache 57003 2 nfsv4,nfs, Live 0x00000000
parport 40945 3 parport_pc,ppdev,lp, Live 0x00000000
lockd 79026 2 nfsd,nfs, Live 0x00000000
sunrpc 278186 14 
rpcsec_gss_krb5,nfsv4,nfsd,nfs_acl,auth_rpcgss,nfs,lockd, Live 0x00000000
binfmt_misc 17795 1 - Live 0x00000000
grace 13061 2 nfsd,lockd, Live 0x00000000
atl1e 37748 0 - Live 0x00000000


[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

/proc/ioports:
0000-0cf7 : PCI Bus 0000:00
   0000-001f : dma1
   0020-0021 : pic1
   0040-0043 : timer0
   0050-0053 : timer1
   0060-0060 : keyboard
   0061-0061 : PNP0800:00
   0062-0062 : PNP0C09:00
     0062-0062 : EC data
   0064-0064 : keyboard
   0066-0066 : PNP0C09:00
     0066-0066 : EC cmd
   0070-0071 : rtc0
   0080-008f : dma page reg
   00a0-00a1 : pic2
   00c0-00df : dma2
   00f0-00ff : PNP0C04:00
     00f0-00ff : fpu
   0170-0177 : 0000:00:1f.2
     0170-0177 : ata_piix
   01f0-01f7 : 0000:00:1f.2
     01f0-01f7 : ata_piix
   025c-025f : pnp 00:04
   0376-0376 : 0000:00:1f.2
     0376-0376 : ata_piix
   0380-0383 : pnp 00:04
   03c0-03df : vesafb
   03f6-03f6 : 0000:00:1f.2
     03f6-03f6 : ata_piix
   0400-041f : 0000:00:1f.3
     0400-041f : pnp 00:04
   0480-04bf : 0000:00:1f.0
     0480-04bf : pnp 00:04
   04d0-04d1 : pnp 00:04
   0800-0803 : ACPI PM1a_EVT_BLK
   0804-0805 : ACPI PM1a_CNT_BLK
   0808-080b : ACPI PM_TMR
   0810-0815 : ACPI CPU throttle
   0820-0820 : ACPI PM2_CNT_BLK
   0828-082f : ACPI GPE0_BLK
   0830-0833 : iTCO_wdt
   0860-087f : iTCO_wdt
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
   1000-1fff : PCI Bus 0000:05
   2000-2fff : PCI Bus 0000:03
   3000-3fff : PCI Bus 0000:01
   d480-d49f : 0000:00:1d.0
     d480-d49f : uhci_hcd
   d800-d81f : 0000:00:1d.1
     d800-d81f : uhci_hcd
   d880-d89f : 0000:00:1d.2
     d880-d89f : uhci_hcd
   dc00-dc1f : 0000:00:1d.3
     dc00-dc1f : uhci_hcd
   dc80-dc87 : 0000:00:02.0
   e000-efff : PCI Bus 0000:04
     ec80-ecff : 0000:04:00.0
       ec80-ecff : ATL1E
   ffa0-ffaf : 0000:00:1f.2
     ffa0-ffaf : ata_piix

/proc/iomem:
00000000-00000fff : reserved
00001000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
   000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000d0000-000dffff : PCI Bus 0000:00
000e0000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-3f79ffff : System RAM
   01000000-016ed852 : Kernel code
   016ed853-01a9a0ff : Kernel data
   01b8c000-01c50fff : Kernel bss
3f7a0000-3f7adfff : ACPI Tables
3f7ae000-3f7effff : ACPI Non-volatile Storage
3f7f0000-ffffffff : reserved
   3f800000-ffffffff : PCI Bus 0000:00
     3f800000-3ffbffff : Graphics Stolen Memory
     40000000-401fffff : PCI Bus 0000:05
     40200000-403fffff : PCI Bus 0000:05
     40400000-405fffff : PCI Bus 0000:04
     40600000-407fffff : PCI Bus 0000:03
     40800000-409fffff : PCI Bus 0000:03
     8c000000-8c01ffff : pnp 00:04
     d0000000-dfffffff : 0000:00:02.0
     e0000000-e3ffffff : PCI MMCONFIG 0000 [bus 00-3f]
       e0000000-e3ffffff : pnp 00:06
     f0000000-f6ffffff : PCI Bus 0000:01
     f7eb7c00-f7eb7fff : 0000:00:1d.7
       f7eb7c00-f7eb7fff : ehci_hcd
     f7eb8000-f7ebbfff : 0000:00:1b.0
       f7eb8000-f7ebbfff : ICH HD audio
     f7ec0000-f7efffff : 0000:00:02.0
     f7f00000-f7f7ffff : 0000:00:02.0
     f7f80000-f7ffffff : 0000:00:02.1
     f8000000-fbefffff : PCI Bus 0000:01
       fbef0000-fbefffff : 0000:01:00.0
         fbef0000-fbefffff : 0000:01:00.0
     fbf00000-fbffffff : PCI Bus 0000:04
       fbfc0000-fbffffff : 0000:04:00.0
         fbfc0000-fbffffff : ATL1E
     fec00000-fec003ff : IOAPIC 0
     fed00000-fed003ff : HPET 0
       fed00000-fed003ff : PNP0103:00
     fed13000-fed19fff : pnp 00:00
     fed1c000-fed1ffff : pnp 00:04
       fed1f410-fed1f414 : iTCO_wdt
     fed20000-fed3ffff : pnp 00:04
     fed50000-fed8ffff : pnp 00:04
     fee00000-fee00fff : Local APIC
       fee00000-fee00fff : reserved
         fee00000-fee00fff : pnp 00:05
     ffb00000-ffbfffff : pnp 00:04
     fff80000-ffffffff : reserved


[7.5.] PCI information ('lspci -vvv' as root)

00:00.0 Host bridge: Intel Corporation Mobile 945GSE Express Memory 
Controller Hub (rev 03)
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=09 <?>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GSE 
Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA 
controller])
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f7f00000 (32-bit, non-prefetchable) [size=512K]
	Region 1: I/O ports at dc80 [size=8]
	Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Region 3: Memory at f7ec0000 (32-bit, non-prefetchable) [size=256K]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 
943/940GML Express Integrated Graphics Controller (rev 03)
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at f7f80000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

00:1b.0 Audio device: Intel Corporation NM10/ICH7 Family High Definition 
Audio Controller (rev 02)
	Subsystem: ASUSTeK Computer Inc. Device 831a
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 28
	Region 0: Memory at f7eb8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4192
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- 
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable- ID=0 ArbSelect=Fixed TC/VC=00
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 
1 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: 40000000-401fffff
	Prefetchable memory behind bridge: 0000000040200000-00000000403fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 
unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 
<1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 41a1
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 830f
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable- ID=0 ArbSelect=Fixed TC/VC=00
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=01 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 
2 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fbf00000-fbffffff
	Prefetchable memory behind bridge: 0000000040400000-00000000405fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 
unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 
<256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ 
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 41c1
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 830f
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable- ID=0 ArbSelect=Fixed TC/VC=00
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 
3 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: 40600000-407fffff
	Prefetchable memory behind bridge: 0000000040800000-00000000409fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 
unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 
<1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 41e1
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 830f
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable- ID=0 ArbSelect=Fixed TC/VC=00
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=03 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 
4 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=02, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: f8000000-fbefffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f6ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 
unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 
<256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ 
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4142
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 830f
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable- ID=0 ArbSelect=Fixed TC/VC=00
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=04 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- 
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI 
Controller #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at d480 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI 
Controller #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 22
	Region 4: I/O ports at d800 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI 
Controller #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 21
	Region 4: I/O ports at d880 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.3 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI 
Controller #4 (rev 02) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 20
	Region 4: I/O ports at dc00 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB controller: Intel Corporation NM10/ICH7 Family USB2 EHCI 
Controller (rev 02) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at f7eb7c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci-pci

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2) 
(prog-if 01 [Subtractive decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: ASUSTeK Computer Inc. Device 830f

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface 
Bridge (rev 02)
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel driver in use: lpc_ich

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7-M Family) 
SATA Controller [IDE mode] (rev 02) (prog-if 80 [Master])
	Subsystem: ASUSTeK Computer Inc. Device 830f
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
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation NM10/ICH7 Family SMBus Controller (rev 02)
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 11
	Region 4: I/O ports at 0400 [size=32]

01:00.0 Network controller: Ralink corp. RT2790 Wireless 802.11n 1T/2R PCIe
	Subsystem: Ralink corp. Device 2790
	Physical Slot: eeepc-wifi
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at fbef0000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
	Capabilities: [50] MSI: Enable- Count=1/32 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <128ns, L1 <2us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 
<512ns, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ 
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Kernel driver in use: rt2800pci

04:00.0 Ethernet controller: Qualcomm Atheros AR8121/AR8113/AR8114 
Gigabit or Fast Ethernet (rev b0)
	Subsystem: ASUSTeK Computer Inc. Device 8324
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at fbfc0000 (64-bit, non-prefetchable) [size=256K]
	Region 2: I/O ports at ec80 [size=128]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [58] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 4096 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 
unlimited, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
	Capabilities: [6c] Vital Product Data
		Unknown small resource type 0b, will not decode more.
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- 
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ 
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [180 v1] Device Serial Number ff-04-a4-2c-00-23-54-ff
	Kernel driver in use: ATL1E


[7.6.] SCSI information (from /proc/scsi/scsi)

Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: ASUS-PHISON SSD  Rev: .04U
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 01 Lun: 00
   Vendor: ATA      Model: ASUS-PHISON SSD  Rev: .04U
   Type:   Direct-Access                    ANSI  SCSI revision: 05


[7.7.] Other information that might be relevant to the problem
        (please look in /proc and include all information that you
        think to be relevant):

1
10
1001
1006
1023
1024
1031
1048
1058
1062
1069
1070
1072
1093
11
1103
12
1255
1274
1298
13
1309
1352
1355
1357
1362
1364
1374
1376
14
1406
1412
15
1545
155
1586
1589
1591
1594
1595
16
1669
1678
1687
1691
1694
1695
1698
17
1710
1714
1718
1720
1723
1725
1728
1731
1737
1749
1751
1769
1773
1782
18
1807
1812
1815
1816
1818
1829
1831
1832
1849
1856
1861
1866
1873
1876
1878
1879
1887
1888
1894
19
1918
1926
1928
1929
1995
2
20
2021
2029
2055
2068
21
22
225
227
23
2318
24
25
26
27
28
29
3
30
31
33
34
35
36
478
48
487
488
49
5
50
503
51
52
520
53
532
539
54
546
547
55
572
579
637
640
641
648
691
7
717
75
76
78
79
8
836
86
865
878
892
894
9
913
936
946
953
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
keys
key-users
kmsg
kpagecount
kpageflags
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
thread-self
timer_list
timer_stats
tty
uptime
version
vmallocinfo
vmstat
zoneinfo

[8.] Other notes, patches, fixes, workarounds:

A workaround is available at 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1404976 . Note that 
removing the module as I did in the workaround is not really necessary. 
It is sufficient to stop playback in VLC to successfully suspend. I just 
added this in my script as an additional precaution in case the VLC LUA 
telnet interface would change in a future release.

I am a noob, but to me this bugs seems to be caused because the DVB-t 
data stream is not closed or blocked by the kernel before kernel 
processes that handle this data are stopped so that important buffers 
are flooded with data. Of course, I may be totally wrong with this guess.

-- 
Kind Regards,
Sander Devrieze.
