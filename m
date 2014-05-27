Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc4-s25.blu0.hotmail.com ([65.55.111.164]:22059 "EHLO
	blu0-omc4-s25.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751887AbaE0Bj2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 21:39:28 -0400
Message-ID: <BLU436-SMTP93884884267098D387F74FF23A0@phx.gbl>
From: Richie <searchfgold67899@live.com>
To: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Subject: 1d6b:0001 [MSI A55M-P33] No webcam functionality with Zoran Microelectronics, Ltd Digital Camera EX-20 DSC
Date: Mon, 26 May 2014 21:34:18 -0400
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1322380

[1.] One line summary of the problem:

1d6b:0001 [MSI A55M-P33] No webcam functionality with Zoran Microelectronics, 
Ltd Digital Camera EX-20 DSC

[2.] Full description of the problem/report: 

No software recognizes the webcam and this is not a regression. dmesg reports 
the following additional output after plugging the camera. You can see where I 
change the camera to "PC Mode" (in order to use the webcam, users must do this 
from the camera) at [ 691.147589]. The device is turned off at [ 1094.746444]:

[ 688.796908] usb 4-2: new full-speed USB device number 2 using ohci-pci
[ 688.965802] usb 4-2: New USB device found, idVendor=0595, idProduct=2002
[ 688.965807] usb 4-2: New USB device strings: Mfr=4, Product=5, 
SerialNumber=6
[ 688.965809] usb 4-2: Product: COACH DSC
[ 688.965811] usb 4-2: Manufacturer: ZORAN
[ 688.965813] usb 4-2: SerialNumber: ZORAN01234567
[ 689.012630] usb-storage 4-2:1.0: USB Mass Storage device detected
[ 689.021168] scsi6 : usb-storage 4-2:1.0
[ 689.021266] usbcore: registered new interface driver usb-storage
[ 690.030971] scsi 6:0:0:0: Direct-Access ZORAN COACH6 (I62) 1.10 PQ: 0 ANSI: 
0 CCS
[ 690.036147] sd 6:0:0:0: Attached scsi generic sg3 type 0
[ 690.044964] sd 6:0:0:0: [sdc] 3962629 512-byte logical blocks: (2.02 GB/1.88 
GiB)
[ 690.054977] sd 6:0:0:0: [sdc] Write Protect is off
[ 690.054984] sd 6:0:0:0: [sdc] Mode Sense: 00 06 00 00
[ 690.064965] sd 6:0:0:0: [sdc] No Caching mode page found
[ 690.064971] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[ 690.108960] sd 6:0:0:0: [sdc] No Caching mode page found
[ 690.108966] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[ 690.156970] sdc:
[ 690.210974] sd 6:0:0:0: [sdc] No Caching mode page found
[ 690.210980] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[ 690.210985] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[ 691.147589] usb 4-2: USB disconnect, device number 2
[ 691.793364] usb 4-2: new full-speed USB device number 3 using ohci-pci
[ 691.962202] usb 4-2: New USB device found, idVendor=0595, idProduct=4343
[ 691.962207] usb 4-2: New USB device strings: Mfr=7, Product=8, 
SerialNumber=9
[ 691.962209] usb 4-2: Product: COACH DSC
[ 691.962211] usb 4-2: Manufacturer: ZORAN
[ 691.962213] usb 4-2: SerialNumber: ZORAN00000001
[ 691.964262] usb-storage 4-2:1.0: USB Mass Storage device detected
[ 691.965410] usb-storage: probe of 4-2:1.0 failed with error -5
[ 692.053929] Linux video capture interface: v2.00
[ 692.091447] zr364xx 4-2:1.0: Zoran 364xx compatible webcam plugged
[ 692.091453] zr364xx 4-2:1.0: model 0595:4343 detected
[ 692.091461] usb 4-2: 320x240 mode selected
[ 692.094356] usb 4-2: Zoran 364xx controlling device video0
[ 692.094672] usbcore: registered new interface driver zr364xx
[ 1094.746444] hub 4-0:1.0: port 2 disabled by hub (EMI?), re-enabling...
[ 1094.746451] usb 4-2: USB disconnect, device number 3
[ 1094.747395] zr364xx 4-2:1.0: Zoran 364xx webcam unplugged

[4.] Kernel version (from /proc/version): 

Linux version 3.15.0-031500rc6-generic (apw@gomeisa) (gcc version 4.6.3 
(Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201405211835 SMP Wed May 21 22:35:54 UTC 
2014

[5.] Output of Oops.. message (if applicable) with symbolic information 
resolved (see Documentation/oops-tracing.txt) 

N/A

[6.] A small shell script or example program which triggers the problem (if 
possible) 

N/A

[7.] Environment 

Description:    Ubuntu 14.04 LTS
Release:        14.04

[7.1.] Software (add the output of the ver_linux script here) 

$ /usr/src/linux-headers-3.15.0-031500rc6/scripts/ver_linux 
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux richie-desktop 3.15.0-031500rc6-generic #201405211835 SMP Wed May 21 
22:35:54 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
 
Gnu C                  4.8
Gnu make               3.81
binutils               2.24
util-linux             2.20.1
mount                  support
module-init-tools      15
e2fsprogs              1.42.9
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.19
Dynamic linker (ldd)   2.19
Procps                 3.3.9
Net-tools              1.60
Kbd                    1.15.5
Sh-utils               8.21
wireless-tools         30
Modules Loaded         ipheth nls_iso8859_1 uas usb_storage pci_stub vboxpci 
vboxnetadp vboxnetflt vboxdrv bnep rfcomm bluetooth 6lowpan_iphc fglrx 
snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic kvm_amd 
kvm snd_hda_intel usblp snd_hda_controller snd_hda_codec snd_ctxfi joydev 
snd_hwdep snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi microcode 
snd_seq snd_seq_device snd_timer serio_raw ppdev snd amd_iommu_v2 
soundcore k10temp lp i2c_piix4 parport_pc mac_hid parport hid_generic usbhid 
hid pata_acpi psmouse sdhci_pci r8169 sdhci mii wmi ahci libahci pata_atiixp


[7.2.] Processor information (from /proc/cpuinfo): 

$ cat /proc/cpuinfo 
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 18
model           : 1
model name      : AMD A4-3400 APU with Radeon(tm) HD Graphics
stepping        : 0
microcode       : 0x3000027
cpu MHz         : 2694.927
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb 
rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc extd_apicid 
aperfmperf pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy 
abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt arat hw_pstate npt 
lbrv svm_lock nrip_save pausefilter
bogomips        : 5389.85
TLB size        : 1536 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 18
model           : 1
model name      : AMD A4-3400 APU with Radeon(tm) HD Graphics
stepping        : 0
microcode       : 0x3000027
cpu MHz         : 2694.927
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb 
rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc extd_apicid 
aperfmperf pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy 
abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt arat hw_pstate npt 
lbrv svm_lock nrip_save pausefilter
bogomips        : 5389.85
TLB size        : 1536 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwps


[7.3.] Module information (from /proc/modules): 

ipheth 13547 0 - Live 0x0000000000000000
nls_iso8859_1 12713 0 - Live 0x0000000000000000
uas 27672 0 - Live 0x0000000000000000
usb_storage 67009 1 uas, Live 0x0000000000000000
pci_stub 12622 1 - Live 0x0000000000000000
vboxpci 23194 0 - Live 0x0000000000000000 (OE)
vboxnetadp 25670 0 - Live 0x0000000000000000 (OE)
vboxnetflt 27613 1 - Live 0x0000000000000000 (OE)
vboxdrv 339502 5 vboxpci,vboxnetadp,vboxnetflt, Live 0x0000000000000000 (OE)
bnep 19884 2 - Live 0x0000000000000000
rfcomm 75078 0 - Live 0x0000000000000000
bluetooth 461775 10 bnep,rfcomm, Live 0x0000000000000000
6lowpan_iphc 18968 1 bluetooth, Live 0x0000000000000000
fglrx 8081264 147 - Live 0x0000000000000000 (POE)
snd_hda_codec_realtek 72529 1 - Live 0x0000000000000000
snd_hda_codec_hdmi 48229 1 - Live 0x0000000000000000
snd_hda_codec_generic 70087 2 snd_hda_codec_realtek, Live 
0x0000000000000000
kvm_amd 60778 0 - Live 0x0000000000000000
kvm 463808 1 kvm_amd, Live 0x0000000000000000
snd_hda_intel 30608 10 - Live 0x0000000000000000
usblp 23075 0 - Live 0x0000000000000000
snd_hda_controller 35518 1 snd_hda_intel, Live 0x0000000000000000
snd_hda_codec 144671 5 
snd_hda_codec_realtek,snd_hda_codec_hdmi,snd_hda_codec_generic,snd_hda_intel,snd_hda_controller, 
Live 0x0000000000000000
snd_ctxfi 105129 5 - Live 0x0000000000000000
joydev 17587 0 - Live 0x0000000000000000
snd_hwdep 13613 1 snd_hda_codec, Live 0x0000000000000000
snd_pcm 113863 6 
snd_hda_codec_hdmi,snd_hda_intel,snd_hda_controller,snd_hda_codec,snd_ctxfi, 
Live 0x0000000000000000
snd_seq_midi 13564 0 - Live 0x0000000000000000
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
snd_rawmidi 30865 1 snd_seq_midi, Live 0x0000000000000000
microcode 24391 0 - Live 0x0000000000000000
snd_seq 67636 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 
0x0000000000000000
snd_timer 30118 2 snd_pcm,snd_seq, Live 0x0000000000000000
serio_raw 13483 0 - Live 0x0000000000000000
ppdev 17711 0 - Live 0x0000000000000000
snd 74195 41 
snd_hda_codec_realtek,snd_hda_codec_hdmi,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_ctxfi,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer, 
Live 0x0000000000000000
amd_iommu_v2 19227 1 fglrx, Live 0x0000000000000000
soundcore 12680 2 snd_hda_codec,snd, Live 0x0000000000000000
k10temp 13191 0 - Live 0x0000000000000000
lp 17799 0 - Live 0x0000000000000000
i2c_piix4 22310 0 - Live 0x0000000000000000
parport_pc 32906 1 - Live 0x0000000000000000
mac_hid 13275 0 - Live 0x0000000000000000
parport 42481 3 ppdev,lp,parport_pc, Live 0x0000000000000000
hid_generic 12559 0 - Live 0x0000000000000000
usbhid 53121 0 - Live 0x0000000000000000
hid 106436 2 hid_generic,usbhid, Live 0x0000000000000000
pata_acpi 13053 0 - Live 0x0000000000000000
psmouse 113320 0 - Live 0x0000000000000000
sdhci_pci 23347 0 - Live 0x0000000000000000
r8169 73316 0 - Live 0x0000000000000000
sdhci 43409 1 sdhci_pci, Live 0x0000000000000000
mii 13981 1 r8169, Live 0x0000000000000000
wmi 19379 0 - Live 0x0000000000000000
ahci 30167 3 - Live 0x0000000000000000
libahci 32191 1 ahci, Live 0x0000000000000000
pata_atiixp 13279 1 - Live 0x0000000000000000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem) 

$ cat /proc/ioports
0000-03af : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0170-0177 : 0000:00:14.1
    0170-0177 : pata_atiixp
  01f0-01f7 : 0000:00:14.1
    01f0-01f7 : pata_atiixp
  0376-0376 : 0000:00:14.1
    0376-0376 : pata_atiixp
  0378-037a : parport0
03b0-03df : PCI Bus 0000:00
  03c0-03df : vesafb
03e0-0cf7 : PCI Bus 0000:00
  03f6-03f6 : 0000:00:14.1
    03f6-03f6 : pata_atiixp
  03f8-03ff : serial
  040b-040b : pnp 00:01
  04d0-04d1 : pnp 00:01
    04d0-04d1 : pnp 00:08
  04d6-04d6 : pnp 00:01
  0600-060f : pnp 00:02
  0800-0803 : ACPI PM1a_EVT_BLK
  0804-0805 : ACPI PM1a_CNT_BLK
  0808-080b : ACPI PM_TMR
  0810-0815 : ACPI CPU throttle
  0820-0827 : ACPI GPE0_BLK
  0900-090f : pnp 00:01
  0910-091f : pnp 00:01
  0a00-0a1f : pnp 00:02
  0b00-0b07 : piix4_smbus
  0b20-0b3f : pnp 00:01
    0b20-0b27 : piix4_smbus
  0c00-0c01 : pnp 00:01
  0c14-0c14 : pnp 00:01
  0c50-0c51 : pnp 00:01
  0c52-0c52 : pnp 00:01
  0c6c-0c6c : pnp 00:01
  0c6f-0c6f : pnp 00:01
  0cd0-0cd1 : pnp 00:01
  0cd2-0cd3 : pnp 00:01
  0cd4-0cd5 : pnp 00:01
  0cd6-0cd7 : pnp 00:01
  0cd8-0cdf : pnp 00:01
0cf8-0cff : PCI conf1
1770-1777 : pnp 00:0a
1778-ffff : PCI Bus 0000:00
  c000-cfff : PCI Bus 0000:03
    c000-c01f : 0000:03:05.0
      c000-c01f : XFi
  d000-dfff : PCI Bus 0000:02
    d000-d0ff : 0000:02:00.0
      d000-d0ff : r8169
  e000-efff : PCI Bus 0000:01
    e000-e0ff : 0000:01:00.0
  f000-f00f : 0000:00:14.1
    f000-f00f : pata_atiixp
  f050-f05f : 0000:00:11.0
    f050-f05f : ahci
  f060-f063 : 0000:00:11.0
    f060-f063 : ahci
  f070-f077 : 0000:00:11.0
    f070-f077 : ahci
  f080-f083 : 0000:00:11.0
    f080-f083 : ahci
  f090-f097 : 0000:00:11.0
    f090-f097 : ahci
  fe00-fefe : pnp 00:01

$ cat /proc/iomem 
00000000-00000fff : reserved
00001000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000dffff : PCI Bus 0000:00
  000c0000-000cf5ff : Video ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-be8e9fff : System RAM
  01000000-0177c658 : Kernel code
  0177c659-01d1efbf : Kernel data
  01e7b000-01fe0fff : Kernel bss
be8ea000-be917fff : reserved
be918000-be9e4fff : ACPI Non-volatile Storage
be9e5000-bf045fff : reserved
bf046000-bf046fff : System RAM
bf047000-bf04efff : ACPI Non-volatile Storage
bf04f000-bf471fff : System RAM
bf472000-bf7f2fff : reserved
bf7f3000-bf7fffff : System RAM
bf800000-bfffffff : RAM buffer
c0000000-ffffffff : PCI Bus 0000:00
  c0000000-cfffffff : PCI Bus 0000:01
    c0000000-cfffffff : 0000:01:00.0
      c0000000-c05affff : vesafb
  d0000000-d00fffff : PCI Bus 0000:02
    d0000000-d0003fff : 0000:02:00.0
      d0000000-d0003fff : r8169
    d0004000-d0004fff : 0000:02:00.0
      d0004000-d0004fff : r8169
  e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
    e0000000-efffffff : reserved
      e0000000-efffffff : pnp 00:00
  f0000000-f41fffff : PCI Bus 0000:03
    f0000000-f3ffffff : 0000:03:05.0
      f0000000-f3ffffff : XFi
    f4000000-f41fffff : 0000:03:05.0
      f4000000-f41fffff : XFi
  f4200000-f42fffff : PCI Bus 0000:01
    f4200000-f421ffff : 0000:01:00.0
    f4220000-f423ffff : 0000:01:00.0
    f4240000-f4243fff : 0000:01:00.1
      f4240000-f4243fff : ICH HD audio
  f4300000-f4303fff : 0000:00:14.2
    f4300000-f4303fff : ICH HD audio
  f4304000-f43040ff : 0000:00:16.2
    f4304000-f43040ff : ehci_hcd
  f4305000-f4305fff : 0000:00:16.0
    f4305000-f4305fff : ohci_hcd
  f4306000-f43060ff : 0000:00:14.7
    f4306000-f43060ff : mmc0
  f4307000-f4307fff : 0000:00:14.5
    f4307000-f4307fff : ohci_hcd
  f4308000-f43080ff : 0000:00:13.2
    f4308000-f43080ff : ehci_hcd
  f4309000-f4309fff : 0000:00:13.0
    f4309000-f4309fff : ohci_hcd
  f430a000-f430a0ff : 0000:00:12.2
    f430a000-f430a0ff : ehci_hcd
  f430b000-f430bfff : 0000:00:12.0
    f430b000-f430bfff : ohci_hcd
  f430c000-f430c7ff : 0000:00:11.0
    f430c000-f430c7ff : ahci
  f8000000-fbffffff : reserved
  fec00000-fec00fff : reserved
    fec00000-fec003ff : IOAPIC 0
  fec10000-fec10fff : reserved
    fec10000-fec10fff : pnp 00:01
  fed00000-fed00fff : reserved
    fed00000-fed00fff : pnp 00:01
      fed00000-fed003ff : HPET 0
  fed40000-fed44fff : reserved
  fed61000-fed70fff : reserved
    fed61000-fed70fff : pnp 00:01
  fed80000-fed8ffff : reserved
    fed80000-fed8ffff : pnp 00:01
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:01
  ff000000-ffffffff : reserved
    ff000000-ffffffff : pnp 00:01
100001000-23fffffff : System RAM

[7.5.] PCI information ('lspci -vvv' as root) 

$ sudo lspci -vvv 
[sudo] password for : 
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h Processor 
Root Complex
        Subsystem: Advanced Micro Devices, Inc. [AMD] Family 12h Processor 
Root Complex
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0

00:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 12h Processor 
Root Port (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: f4200000-f42fffff
        Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag+ RBE+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
                LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Exit 
Latency L0s <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep+ BwNot+
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- 
Surprise-
                        Slot #2, PowerLimit 75.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- 
LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- 
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
                        Changed: MRL- PresDet+ LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ 
CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, 
OBFF Not Supported ARIFwd-
                DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-, LTR-, 
OBFF Disabled ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0100c  Data: 4161
        Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD] 
Device 1234
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 
Len=010 <?>
        Kernel driver in use: pcieport

00:04.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 12h Processor 
Root Port (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000d00fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag+ RBE+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
                LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Exit 
Latency L0s <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep+ BwNot+
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- 
Surprise-
                        Slot #4, PowerLimit 75.000W; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- 
LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- 
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
                        Changed: MRL- PresDet+ LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ 
CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, 
OBFF Not Supported ARIFwd-
                DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-, LTR-, 
OBFF Disabled ARIFwd-
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0100c  Data: 4181
        Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD] 
Device 1234
        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
        Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 
Len=010 <?>
        Kernel driver in use: pcieport

00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD] FCH SATA 
Controller [IDE mode] (rev 40) (prog-if 01 [AHCI 1.0])
        Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7786
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Interrupt: pin A routed to IRQ 19
        Region 0: I/O ports at f090 [size=8]
        Region 1: I/O ports at f080 [size=4]
        Region 2: I/O ports at f070 [size=8]
        Region 3: I/O ports at f060 [size=4]
        Region 4: I/O ports at f050 [size=16]
        Region 5: Memory at f430c000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [70] SATA HBA v1.0 InCfgSpace
        Kernel driver in use: ahci

00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB OHCI 
Controller (rev 11) (prog-if 10 [OHCI])
        Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7786
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at f430b000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci-pci

00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB EHCI 
Controller (rev 11) (prog-if 20 [EHCI])
        Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7786
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 17
        Region 0: Memory at f430a000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
                Bridge: PM- B3+
        Capabilities: [e4] Debug port: BAR=1 offset=00e0
        Kernel driver in use: ehci-pci

00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB OHCI 
Controller (rev 11) (prog-if 10 [OHCI])
        Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7786
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at f4309000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci-pci

00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB EHCI 
Controller (rev 11) (prog-if 20 [EHCI])
        Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7786
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 17
        Region 0: Memory at f4308000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+
        Capabilities: [e4] Debug port: BAR=1 offset=00e0
        Kernel driver in use: ehci-pci

00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller (rev 
14)
        Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7786
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Kernel driver in use: piix4_smbus

00:14.1 IDE interface: Advanced Micro Devices, Inc. [AMD] FCH IDE Controller 
(prog-if 8a [Master SecP PriP])
        Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7786
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Interrupt: pin B routed to IRQ 17
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374
        Region 4: I/O ports at f000 [size=16]
        Kernel driver in use: pata_atiixp

00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD] FCH Azalia Controller 
(rev 01)
        Subsystem: Micro-Star International Co., Ltd. [MSI] Device d786
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f4300000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: snd_hda_intel

00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge (rev 11)
        Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7786
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0

00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD] FCH PCI Bridge (rev 40) 
(prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: f0000000-f41fffff
        Prefetchable memory behind bridge: fff00000-000fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB OHCI 
Controller (rev 11) (prog-if 10 [OHCI])
        Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7786
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 64 bytes
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at f4307000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci-pci

00:14.7 SD Host controller: Advanced Micro Devices, Inc. [AMD] FCH SD Flash 
Controller (prog-if 01)
        Subsystem: Advanced Micro Devices, Inc. [AMD] FCH SD Flash Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 39, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f4306000 (64-bit, non-prefetchable) [size=256]
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Kernel driver in use: sdhci-pci

00:16.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB OHCI 
Controller (rev 11) (prog-if 10 [OHCI])
        Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7786
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at f4305000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci-pci

00:16.2 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB EHCI 
Controller (rev 11) (prog-if 20 [EHCI])
        Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7786
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 17
        Region 0: Memory at f4304000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+
        Capabilities: [e4] Debug port: BAR=1 offset=00e0
        Kernel driver in use: ehci-pci

00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h 
Processor Function 0 (rev 43)
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h 
Processor Function 1
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h 
Processor Function 2
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h 
Processor Function 3
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Capabilities: [f0] Secure device <?>
        Kernel driver in use: k10temp

00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h 
Processor Function 4
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h 
Processor Function 6
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.6 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h 
Processor Function 5
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.7 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 12h/14h 
Processor Function 7
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] 
Juniper PRO [Radeon HD 5750] (prog-if 00 [VGA controller])
        Subsystem: PC Partner Limited / Sapphire Technology Device e148
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 44
        Region 0: Memory at c0000000 (64-bit, prefetchable) [size=256M]
        Region 2: Memory at f4220000 (64-bit, non-prefetchable) [size=128K]
        Region 4: I/O ports at e000 [size=256]
        Expansion ROM at f4200000 [disabled] [size=128K]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, 
L1 unlimited
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                        RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
                LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Exit 
Latency L0s <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, 
OBFF Not Supported
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, 
OBFF Disabled
                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0300c  Data: 41d1
        Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 
Len=010 <?>
        Capabilities: [150 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ 
ChkEn-
        Kernel driver in use: fglrx_pci

01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Juniper HDMI 
Audio [Radeon HD 5700 Series]
        Subsystem: PC Partner Limited / Sapphire Technology Device aa58
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 43
        Region 0: Memory at f4240000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, 
L1 unlimited
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                        RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
                LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Exit 
Latency L0s <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, 
OBFF Not Supported
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, 
OBFF Disabled
                LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0300c  Data: 41e1
        Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 
Len=010 <?>
        Capabilities: [150 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ 
ChkEn-
        Kernel driver in use: snd_hda_intel

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 
PCI Express Gigabit Ethernet Controller (rev 06)
        Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7786
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 42
        Region 0: I/O ports at d000 [size=256]
        Region 2: Memory at d0004000 (64-bit, prefetchable) [size=4K]
        Region 4: Memory at d0000000 (64-bit, prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0100c  Data: 41a1
        Capabilities: [70] Express (v2) Endpoint, MSI 01
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, 
L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit 
Latency L0s unlimited, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, 
OBFF Not Supported
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, 
OBFF Disabled
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- 
SpeedDis-
                         Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
        Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
                Vector table: BAR=4 offset=00000000
                PBA: BAR=4 offset=00000800
        Capabilities: [d0] Vital Product Data
                No end tag found
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ 
ChkEn-
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Capabilities: [160 v1] Device Serial Number 01-00-00-00-68-4c-e0-00
        Kernel driver in use: r8169

03:05.0 Multimedia audio controller: Creative Labs SB X-Fi
        Subsystem: Creative Labs X-Fi XtremeMusic
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1000ns min, 1250ns max)
        Interrupt: pin A routed to IRQ 20
        Region 0: I/O ports at c000 [size=32]
        Region 1: Memory at f4000000 (64-bit, non-prefetchable) [size=2M]
        Region 3: Memory at f0000000 (64-bit, non-prefetchable) [size=64M]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Kernel driver in use: snd_ctxfi

[7.6.] SCSI information (from /proc/scsi/scsi) 

$ cat /proc/scsi/scsi
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: TSSTcorp Model: CDDVDW SH-224BB  Rev: SB00
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3250824AS      Rev: 3.AA
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD5000AAKX-0 Rev: 15.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
richie@richie-desktop:~$ 
richie@richie-desktop:~$ cat /proc/scsi/scsi
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: TSSTcorp Model: CDDVDW SH-224BB  Rev: SB00
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3250824AS      Rev: 3.AA
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD5000AAKX-0 Rev: 15.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
richie@richie-desktop:~$ 
richie@richie-desktop:~$ cat /proc/scsi/scsi
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: TSSTcorp Model: CDDVDW SH-224BB  Rev: SB00
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3250824AS      Rev: 3.AA
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD5000AAKX-0 Rev: 15.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05


[7.7.] Other information that might be relevant to the problem (please look in 
/proc and include all information that you think to be relevant): 

$ ls /proc/
1     13    1734  2109  24    43    755        consoles       mounts
10    131   1738  2132  25    44    770        cpuinfo        mtrr
1011  132   1740  2166  26    5     773        crypto         net
1013  133   1742  2184  27    5260  78         devices        pagetypeinfo
1021  134   1744  2210  28    5308  79         diskstats      partitions
1065  135   1751  2211  29    5342  8          dma            sched_debug
1073  136   18    2212  3     5404  822        driver         schedstat
1084  137   19    2213  30    56    831        execdomains    scsi
1098  1393  195   2214  3041  57    851        fb             self
11    1396  196   2215  31    58    879        filesystems    slabinfo
1101  14    2     2216  3103  588   881        fs             softirqs
1124  1402  20    2217  3153  589   884        interrupts     stat
1138  1413  2009  2218  32    59    9          iomem          swaps
1145  1415  2013  2219  3222  597   916        ioports        sys
12    1417  2029  2220  33    6319  920        irq            sysrq-trigger
1210  1418  2037  2221  334   6826  921        kallsyms       sysvipc
1216  142   2043  2222  34    6850  927        kcore          timer_list
1217  1485  2048  2223  340   6853  928        key-users      timer_stats
1218  15    2051  2262  35    6858  931        kmsg           tty
1219  1505  2053  2264  3594  6915  979        kpagecount     uptime
1238  16    2056  2271  36    6955  981        kpageflags     version
1239  1666  2086  2278  3646  7     acpi       latency_stats  vmallocinfo
124   17    2097  2279  37    7007  asound     loadavg        vmstat
1249  1701  2098  2287  378   7138  ati        locks          zoneinfo
125   1705  2099  23    379   7143  buddyinfo  mdstat
126   1717  21    2309  38    7146  bus        meminfo
127   1720  2103  2319  39    7261  cgroups    misc
128   1726  2105  2333  42    7282  cmdline    modules
