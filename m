Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:3826 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921Ab2FWHuJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jun 2012 03:50:09 -0400
Date: Sat, 23 Jun 2012 09:43:53 +0200
Message-ID: <4FC4F2380000A8A7@mta-nl-6.mail.tiscali.sys>
From: cedric.dewijs@telfort.nl
Subject: DiB0700 rc submit urb failed after reboot, ok after replug
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="========/4FC4F2380000A8A7/mta-nl-6.mail.tiscali.sys"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--========/4FC4F2380000A8A7/mta-nl-6.mail.tiscali.sys
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

[1.] One line summary of the problem:
My DVB-T receiver does not gie fluid image after a reboot. After replug i=
t
works OK

[2.] Full description of the problem/report:
a) I plugin my DVB-T receiver in a running arch-linux system
b) In one terminal run $ tzap -r 'Nederland 1' 
c) In another terminal run $ mplayer /dev/dvb/adapter0/dvr0 Now TV looks
perfectly fluid.
d) reboot the system
e) watch the URP submit failed message in dmesg:
[    6.064321] dvb-usb: found a 'Pinnacle PCTV 73e SE' in warm state.
[    6.064489] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[    6.064693] DVB: registering new adapter (Pinnacle PCTV 73e SE)
[    6.072559] IR NEC protocol handler initialized
[    6.272088] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[    6.316653] IR Sony protocol handler initialized
[    6.357433] IR SANYO protocol handler initialized
[    6.419732] IR MCE Keyboard/mouse protocol handler initialized
[    6.470114] lirc_dev: IR Remote Control driver registered, major 250 
[    6.470783] IR LIRC bridge handler initialized
[    6.473824] DiB0070: successfully identified
[    6.516701] Registered IR keymap rc-dib0700-rc5
[    6.516942] input: IR-receiver inside an USB DVB receiver as /devices/=
pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc0/input17
[    6.517631] rc0: IR-receiver inside an USB DVB receiver as /devices/pc=
i0000:00/0000:00:1d.7/usb2/2-4/rc/rc0
[    6.517821] dvb-usb: schedule remote query interval to 50 msecs.
[    6.517825] dvb-usb: Pinnacle PCTV 73e SE successfully initialized and=

connected.
[    6.517951] dib0700: rc submit urb failed
[    6.517953] 
f) watching TV does work afterwards, but it feels less fluid, it seems th=
ere
are more framedrops.
I see the following in dmesg:
[  602.860101] ACPI: EC: GPE storm detected, transactions will use pollin=
g
mode
[  772.469183] dib0700: could not acquire lock
[  806.309073] dib0700: could not acquire lock
[  880.837082] dib0700: could not acquire lock
[cedric@cedric ~]$ tzap -r 'Nederland 1'
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/home/cedric/.tzap/channels.conf'
tuning to 618000000 Hz
video pid 0x1b63, audio pid 0x1b64
status 1f | signal 6710 | snr 00ad | ber 001fffff | unc 00000013 | FE_HAS=
_LOCK
status 1f | signal 67bc | snr 00a1 | ber 00000000 | unc 00000000 | FE_HAS=
_LOCK
status 1f | signal 6780 | snr 00a0 | ber 00000000 | unc 00000000 | FE_HAS=
_LOCK

$ mplayer /dev/dvb/adapter0/dvr0 
MPlayer SVN-r34799-4.6.3 (C) 2000-2012 MPlayer Team
183 audio & 398 video codecs
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote cont=
rol.

Playing /dev/dvb/adapter0/dvr0.
libavformat version 54.2.100 (internal)
TS file format detected.
VIDEO MPEG2(pid=3D7011) AUDIO MPA(pid=3D7012) NO SUBS (yet)!  PROGRAM N. =
0
VIDEO:  MPEG2  704x576  (aspect 3)  25.000 fps  15000.0 kbps (1875.0 kbyt=
e/s)
Load subtitles in /dev/dvb/adapter0/

stopping both tzap and mplayer, then unplugging the receiver yields the f=
ollowing:
[  932.252207] usb 2-4: USB disconnect, device number 3
[  932.255716] dvb-usb: Pinnacle PCTV 73e SE successfully deinitialized a=
nd
disconnected.

replugging the receiver:
[  993.159956] usb 2-4: new high-speed USB device number 4 using ehci_hcd=

[  993.285182] dvb-usb: found a 'Pinnacle PCTV 73e SE' in cold state, wil=
l
try to load a firmware
[  993.553356] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1=
.20.fw'
[  993.755291] dib0700: firmware started successfully.
[  994.256827] dvb-usb: found a 'Pinnacle PCTV 73e SE' in warm state.
[  994.256910] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[  994.257066] DVB: registering new adapter (Pinnacle PCTV 73e SE)
[  994.466309] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[  994.673807] DiB0070: successfully identified
[  994.673819] Registered IR keymap rc-dib0700-rc5
[  994.674013] input: IR-receiver inside an USB DVB receiver as /devices/=
pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc1/input18
[  994.674178] rc1: IR-receiver inside an USB DVB receiver as /devices/pc=
i0000:00/0000:00:1d.7/usb2/2-4/rc/rc1
[  994.674296] dvb-usb: schedule remote query interval to 50 msecs.
[  994.674305] dvb-usb: Pinnacle PCTV 73e SE successfully initialized and=

connected.

after starting mplayer and tzap, the image is fluid again

[3.] Keywords (i.e., modules, networking, kernel):
M4L, DVB
[4.] Kernel information
[4.1.] Kernel version (from /proc/version):
$ cat /proc/version 
Linux version 3.3.7-1-ARCH (tobias@T-POWA-LX) (gcc version 4.7.0 20120505=

(prerelease) (GCC) ) #1 SMP PREEMPT Tue May 22 00:26:26 CEST 2012
[4.2.] Kernel .config file:
attached
[5.] Most recent kernel version which did not have the bug:
Unknown.
[6.] Output of Oops.. message (if applicable) with symbolic information
This is not an oops
[7.] A small shell script or example program which triggers the
     problem (if possible)
[8.] Environment
[8.1.] Software (add the output of the ver_linux script here)
$ sh scripts/ver_linux 
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux cedric 3.3.7-1-ARCH #1 SMP PREEMPT Tue May 22 00:26:26 CEST 2012 x8=
6_64
GNU/Linux
 
Gnu C                  4.7.0
Gnu make               3.82
binutils               2.22.0.20120323
util-linux             2.21.2
mount                  debug
module-init-tools      8
e2fsprogs              1.42.3
jfsutils               1.1.15
reiserfsprogs          3.6.21
xfsprogs               3.1.8
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.15
Dynamic linker (ldd)   2.15
Linux C++ Library      6.0.17
Procps                 3.3.3
Net-tools              1.60
Kbd                    1.15.3
Sh-utils               8.17
wireless-tools         29
Modules Loaded         rc_dib0700_rc5 ir_lirc_codec lirc_dev ir_mce_kbd_d=
ecoder
ir_sanyo_decoder ir_sony_decoder dvb_usb_dib0700 dib3000mc dib8000 dib007=
0
dib7000m dib7000p dibx000_common dib0090 ir_jvc_decoder ir_rc6_decoder ir=
_rc5_decoder
ir_nec_decoder dvb_usb dvb_core rc_core nls_cp437 vfat fat fuse aes_x86_6=
4
cryptd aes_generic snd_hda_codec_realtek mmc_block snd_hda_intel snd_hda_=
codec
snd_hwdep snd_pcm snd_page_alloc snd_timer snd iTCO_wdt sdhci_pci dell_wm=
i
firewire_ohci intel_agp r8169 joydev hid_logitech_dj nvidia btusb bluetoo=
th
soundcore intel_gtt firewire_core processor i2c_i801 iTCO_vendor_support
sdhci mii dell_laptop sparse_keymap battery ac video button arc4 dcdbas c=
rc_itu_t
i2c_core serio_raw b43 pcspkr psmouse wmi evdev ssb pcmcia bcma mmc_core
mac80211 cfg80211 rfkill pcmcia_core vboxdrv ext4 crc16 jbd2 mbcache usbh=
id
hid sr_mod cdrom sd_mod pata_acpi ahci ata_generic libahci ata_piix libat=
a
scsi_mod uhci_hcd ehci_hcd usbcore usb_common

[8.2.] Processor information (from /proc/cpuinfo):
$ cat /proc/cpuinfo 
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     T5670  @ 1.80GHz
stepping	: 13
microcode	: 0xa1
cpu MHz		: 1795.394
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pa=
t
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm const=
ant_tsc
arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 monitor ds_cpl
est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts
bogomips	: 3592.40
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     T5670  @ 1.80GHz
stepping	: 13
microcode	: 0xa1
cpu MHz		: 1795.394
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pa=
t
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm const=
ant_tsc
arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 monitor ds_cpl
est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts
bogomips	: 3592.40
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

[8.3.] Module information (from /proc/modules):
$ cat /proc/modules 
rc_dib0700_rc5 2300 0 - Live 0xffffffffa0172000
ir_lirc_codec 4027 0 - Live 0xffffffffa016e000
lirc_dev 9359 1 ir_lirc_codec, Live 0xffffffffa013c000
ir_mce_kbd_decoder 3254 0 - Live 0xffffffffa0138000
ir_sanyo_decoder 1677 0 - Live 0xffffffffa0134000
ir_sony_decoder 1579 0 - Live 0xffffffffa010d000
dvb_usb_dib0700 134133 0 - Live 0xffffffffa00e5000
dib3000mc 13077 1 dvb_usb_dib0700, Live 0xffffffffa00d6000
dib8000 41012 1 dvb_usb_dib0700, Live 0xffffffffa00c6000
dib0070 8050 2 dvb_usb_dib0700, Live 0xffffffffa00c1000
dib7000m 15390 1 dvb_usb_dib0700, Live 0xffffffffa00b9000
dib7000p 27940 2 dvb_usb_dib0700, Live 0xffffffffa00ae000
dibx000_common 7048 5 dvb_usb_dib0700,dib3000mc,dib8000,dib7000m,dib7000p=
,
Live 0xffffffffa00a9000
dib0090 24877 1 dvb_usb_dib0700, Live 0xffffffffa009e000
ir_jvc_decoder 1673 0 - Live 0xffffffffa009a000
ir_rc6_decoder 2153 0 - Live 0xffffffffa0096000
ir_rc5_decoder 1609 0 - Live 0xffffffffa0059000
ir_nec_decoder 1705 0 - Live 0xffffffffa0002000
dvb_usb 17288 1 dvb_usb_dib0700, Live 0xffffffffa0066000
dvb_core 95963 3 dib8000,dib7000p,dvb_usb, Live 0xffffffffa007a000
rc_core 13280 12 rc_dib0700_rc5,ir_lirc_codec,ir_mce_kbd_decoder,ir_sanyo=
_decoder,ir_sony_decoder,dvb_usb_dib0700,ir_jvc_decoder,ir_rc6_decoder,ir=
_rc5_decoder,ir_nec_decoder,dvb_usb,
Live 0xffffffffa003b000
nls_cp437 5953 1 - Live 0xffffffffa005b000
vfat 10183 1 - Live 0xffffffffa0055000
fat 49739 1 vfat, Live 0xffffffffa0042000
fuse 68162 2 - Live 0xffffffffa0029000
aes_x86_64 7508 2 - Live 0xffffffffa1577000
cryptd 8383 0 - Live 0xffffffffa1570000
aes_generic 26138 1 aes_x86_64, Live 0xffffffffa1561000
snd_hda_codec_realtek 114123 1 - Live 0xffffffffa153d000
mmc_block 19219 2 - Live 0xffffffffa1534000
snd_hda_intel 24021 1 - Live 0xffffffffa1528000
snd_hda_codec 92713 2 snd_hda_codec_realtek,snd_hda_intel, Live 0xfffffff=
fa1503000
snd_hwdep 6556 1 snd_hda_codec, Live 0xffffffffa14fd000
snd_pcm 74812 2 snd_hda_intel,snd_hda_codec, Live 0xffffffffa14e0000
snd_page_alloc 7217 2 snd_hda_intel,snd_pcm, Live 0xffffffffa14da000
snd_timer 19222 1 snd_pcm, Live 0xffffffffa14d0000
snd 59656 8 snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,s=
nd_pcm,snd_timer,
Live 0xffffffffa14b7000
iTCO_wdt 12877 0 - Live 0xffffffffa14ae000
sdhci_pci 10535 0 - Live 0xffffffffa14a7000
dell_wmi 1517 0 - Live 0xffffffffa14a3000
firewire_ohci 31554 0 - Live 0xffffffffa1497000
intel_agp 10872 0 - Live 0xffffffffa1490000
r8169 48740 0 - Live 0xffffffffa147e000
joydev 9991 0 - Live 0xffffffffa1478000
hid_logitech_dj 10181 0 - Live 0xffffffffa1463000
nvidia 12283579 33 - Live 0xffffffffa07fe000 (PO)
btusb 11675 0 - Live 0xffffffffa07f7000
bluetooth 171342 1 btusb, Live 0xffffffffa078d000
soundcore 6082 1 snd, Live 0xffffffffa0787000
intel_gtt 14007 1 intel_agp, Live 0xffffffffa077f000
firewire_core 51466 1 firewire_ohci, Live 0xffffffffa076b000
processor 26144 2 - Live 0xffffffffa0751000
i2c_i801 8116 0 - Live 0xffffffffa074b000
iTCO_vendor_support 1929 1 iTCO_wdt, Live 0xffffffffa0747000
sdhci 23662 1 sdhci_pci, Live 0xffffffffa073d000
mii 4091 1 r8169, Live 0xffffffffa0739000
dell_laptop 10600 0 - Live 0xffffffffa0732000
sparse_keymap 3056 1 dell_wmi, Live 0xffffffffa072e000
battery 6485 0 - Live 0xffffffffa0729000
ac 2376 0 - Live 0xffffffffa0716000
video 11243 0 - Live 0xffffffffa0703000
button 4502 0 - Live 0xffffffffa06fd000
arc4 1410 2 - Live 0xffffffffa06f9000
dcdbas 5552 1 dell_laptop, Live 0xffffffffa06f3000
crc_itu_t 1363 1 firewire_core, Live 0xffffffffa06ef000
i2c_core 20593 11 dvb_usb_dib0700,dib3000mc,dib8000,dib0070,dib7000m,dib7=
000p,dibx000_common,dib0090,dvb_usb,nvidia,i2c_i801,
Live 0xffffffffa06e3000
serio_raw 4653 0 - Live 0xffffffffa067c000
b43 347913 0 - Live 0xffffffffa061a000
pcspkr 1835 0 - Live 0xffffffffa0616000
psmouse 69539 0 - Live 0xffffffffa05fd000
wmi 8475 1 dell_wmi, Live 0xffffffffa05f6000
evdev 9402 25 - Live 0xffffffffa05ef000
ssb 48216 1 b43, Live 0xffffffffa05dc000
pcmcia 36073 2 b43,ssb, Live 0xffffffffa05cd000
bcma 21810 1 b43, Live 0xffffffffa05c2000
mmc_core 82735 5 mmc_block,sdhci_pci,sdhci,b43,ssb, Live 0xffffffffa05a20=
00
mac80211 391455 1 b43, Live 0xffffffffa0525000
cfg80211 176857 2 b43,mac80211, Live 0xffffffffa04eb000
rfkill 15604 3 bluetooth,dell_laptop,cfg80211, Live 0xffffffffa04e2000
pcmcia_core 12189 1 pcmcia, Live 0xffffffffa04da000
vboxdrv 1792230 0 - Live 0xffffffffa0306000 (O)
ext4 424467 2 - Live 0xffffffffa0283000
crc16 1359 2 bluetooth,ext4, Live 0xffffffffa027f000
jbd2 71704 1 ext4, Live 0xffffffffa0263000
mbcache 5977 1 ext4, Live 0xffffffffa025d000
usbhid 36142 1 hid_logitech_dj, Live 0xffffffffa0241000
hid 84549 2 hid_logitech_dj,usbhid, Live 0xffffffffa020b000
sr_mod 14823 0 - Live 0xffffffffa0203000
cdrom 35744 1 sr_mod, Live 0xffffffffa01f5000
sd_mod 28059 4 - Live 0xffffffffa01e9000
pata_acpi 3408 0 - Live 0xffffffffa01e5000
ahci 20261 3 - Live 0xffffffffa01db000
ata_generic 3295 0 - Live 0xffffffffa01d7000
libahci 19999 1 ahci, Live 0xffffffffa01cd000
ata_piix 22136 0 - Live 0xffffffffa0183000
libata 167083 5 pata_acpi,ahci,ata_generic,libahci,ata_piix, Live 0xfffff=
fffa0144000
scsi_mod 133422 3 sr_mod,sd_mod,libata, Live 0xffffffffa0110000
uhci_hcd 23404 0 - Live 0xffffffffa00de000
ehci_hcd 44104 0 - Live 0xffffffffa006e000
usbcore 146847 7 dvb_usb_dib0700,dvb_usb,btusb,usbhid,uhci_hcd,ehci_hcd,
Live 0xffffffffa0004000
usb_common 954 1 usbcore, Live 0xffffffffa0000000


[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem=
)
$ cat /proc/ioports 
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
  0170-0177 : 0000:00:1f.1
    0170-0177 : ata_piix
  01f0-01f7 : 0000:00:1f.1
    01f0-01f7 : ata_piix
  0376-0376 : 0000:00:1f.1
    0376-0376 : ata_piix
  03c0-03df : vga+
  03f6-03f6 : 0000:00:1f.1
    03f6-03f6 : ata_piix
  0680-069f : pnp 00:06
  0800-080f : pnp 00:06
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-107f : 0000:00:1f.0
    1000-107f : pnp 00:06
      1000-1003 : ACPI PM1a_EVT_BLK
      1004-1005 : ACPI PM1a_CNT_BLK
      1008-100b : ACPI PM_TMR
      1010-1015 : ACPI CPU throttle
      1020-1020 : ACPI PM2_CNT_BLK
      1028-102f : ACPI GPE0_BLK
      1030-1033 : iTCO_wdt
      1060-107f : iTCO_wdt
  1180-11bf : 0000:00:1f.0
    1180-11bf : pnp 00:06
  1800-181f : 0000:00:1a.0
    1800-181f : uhci_hcd
  1820-183f : 0000:00:1a.1
    1820-183f : uhci_hcd
  1840-185f : 0000:00:1d.0
    1840-185f : uhci_hcd
  1860-187f : 0000:00:1d.1
    1860-187f : uhci_hcd
  1880-189f : 0000:00:1d.2
    1880-189f : uhci_hcd
  18a0-18af : 0000:00:1f.1
    18a0-18af : ata_piix
  18c8-18cb : 0000:00:1f.2
    18c8-18cb : ahci
  18cc-18cf : 0000:00:1f.2
    18cc-18cf : ahci
  18d0-18d7 : 0000:00:1f.2
    18d0-18d7 : ahci
  18d8-18df : 0000:00:1f.2
    18d8-18df : ahci
  18e0-18ff : 0000:00:1f.2
    18e0-18ff : ahci
  1c00-1c1f : 0000:00:1f.3
  2000-2fff : PCI Bus 0000:01
    2000-207f : 0000:01:00.0
  3000-3fff : PCI Bus 0000:02
  4000-4fff : PCI Bus 0000:03
  5000-5fff : PCI Bus 0000:06
  6000-6fff : PCI Bus 0000:07
    6000-60ff : 0000:07:00.0
      6000-60ff : r8169
  fe00-fe00 : pnp 00:06
  ff00-ff7f : pnp 00:06

$ cat /proc/iomem 
00000000-0000ffff : reserved
00010000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000ccdff : Video ROM
000cd000-000cdfff : Adapter ROM
000ce000-000cffff : reserved
000d0000-000d3fff : PCI Bus 0000:00
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-7fecffff : System RAM
  01000000-01463f3d : Kernel code
  01463f3e-0189dbff : Kernel data
  0195b000-01a99fff : Kernel bss
7fed0000-7fee2fff : ACPI Non-volatile Storage
7fee3000-7fffffff : reserved
80000000-dfffffff : PCI Bus 0000:00
  80100000-801000ff : 0000:00:1f.3
  80200000-806fffff : PCI Bus 0000:07
  c0000000-c3ffffff : PCI Bus 0000:02
  c8000000-caffffff : PCI Bus 0000:01
    c8000000-c9ffffff : 0000:01:00.0
    ca000000-caffffff : 0000:01:00.0
      ca000000-caffffff : nvidia
  cc000000-cdffffff : PCI Bus 0000:02
  d0000000-dfffffff : PCI Bus 0000:01
    d0000000-dfffffff : 0000:01:00.0
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
  e0000000-efffffff : reserved
    e0000000-efffffff : pnp 00:01
f0000000-febfffff : PCI Bus 0000:00
  f0000000-f3ffffff : PCI Bus 0000:03
  f4000000-f7ffffff : PCI Bus 0000:06
    f4000000-f4003fff : 0000:06:00.0
      f4000000-f4003fff : 0000:06:00.0
  f8000000-f80fffff : PCI Bus 0000:08
    f8000000-f8000fff : 0000:08:05.0
      f8000000-f8000fff : firewire_ohci
    f8001000-f8001fff : 0000:08:05.3
    f8002000-f80027ff : 0000:08:05.0
    f8002800-f80028ff : 0000:08:05.2
      f8002800-f80028ff : mmc0
  f8300000-f8303fff : 0000:00:1b.0
    f8300000-f8303fff : ICH HD audio
  f8304000-f83047ff : 0000:00:1f.2
    f8304000-f83047ff : ahci
  f8304800-f8304bff : 0000:00:1a.7
    f8304800-f8304bff : ehci_hcd
  f8304c00-f8304fff : 0000:00:1d.7
    f8304c00-f8304fff : ehci_hcd
  f8400000-f84fffff : PCI Bus 0000:07
    f8400000-f840ffff : 0000:07:00.0
      f8400000-f840ffff : r8169
    f8410000-f8410fff : 0000:07:00.0
      f8410000-f8410fff : r8169
    f8420000-f842ffff : 0000:07:00.0
  fa000000-fbffffff : PCI Bus 0000:03
  fc000000-fdffffff : PCI Bus 0000:06
    fc000000-fc0fffff : 0000:06:00.0
      fc000000-fc0fffff : 0000:06:00.0
fec00000-fec0ffff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : reserved
    fed00000-fed003ff : pnp 00:04
fed14000-fed19fff : reserved
  fed14000-fed17fff : pnp 00:01
  fed18000-fed18fff : pnp 00:01
  fed19000-fed19fff : pnp 00:01
fed1c000-fed8ffff : reserved
  fed1c000-fed1ffff : pnp 00:01
  fed20000-fed3ffff : pnp 00:01
  fed40000-fed44fff : pnp 00:01
  fed45000-fed8ffff : pnp 00:01
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff000000-ffffffff : reserved

[8.5.] PCI information ('lspci -vvv' as root)
# lspci -vvv
00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Co=
ntroller
Hub (rev 0c)
	Subsystem: Dell Device 0275
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=3D0a <?>

00:01.0 PCI bridge: Intel Corporation Mobile PM965/GM965/GL960 PCI Expres=
s
Root Port (rev 0c) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: c8000000-caffffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [88] Subsystem: Dell Device 0275
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [90] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4169
	Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <256=
ns,
L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMg=
mt-
ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise-
			Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
			Status:	NegoPending- InProgress-
	Capabilities: [140 v1] Root Complex Link
		Desc:	PortNumber=3D02 ComponentID=3D01 EltType=3DConfig
		Link0:	Desc:	TargetPort=3D00 TargetComponent=3D01 AssocRCRB- LinkType=3D=
MemMapped
LinkValid+
			Addr:	00000000fed19000
	Kernel driver in use: pcieport

00:1a.0 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI C=
ontroller
#4 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 1800 [size=3D32]
	Kernel driver in use: uhci_hcd

00:1a.1 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI C=
ontroller
#5 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at 1820 [size=3D32]
	Kernel driver in use: uhci_hcd

00:1a.7 USB controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI
Controller #2 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Dell Device 0275
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at f8304800 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0+,D1-,D2-,D3hot+,D=
3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Con=
troller
(rev 03)
	Subsystem: Dell Device 0275
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 47
	Region 0: Memory at f8300000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA PME(D0+,D1-,D2-,D3hot+,D3=
cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [60] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 41a9
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00=

		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64n=
s,
L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgm=
t-
ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D1 ArbSelect=3DFixed TC/VC=3D80
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=3D0f ComponentID=3D02 EltType=3DConfig
		Link0:	Desc:	TargetPort=3D00 TargetComponent=3D02 AssocRCRB- LinkType=3D=
MemMapped
LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Po=
rt
1 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: c0000000-c3ffffff
	Prefetchable memory behind bridge: 00000000cc000000-00000000cdffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 un=
limited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us,=

L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgm=
t-
ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #2, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4171
	Capabilities: [90] Subsystem: Dell Device 0275
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3Dff
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=3D01 ComponentID=3D02 EltType=3DConfig
		Link0:	Desc:	TargetPort=3D00 TargetComponent=3D02 AssocRCRB- LinkType=3D=
MemMapped
LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Po=
rt
2 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D03, subordinate=3D03, sec-latency=3D0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: f0000000-f3ffffff
	Prefetchable memory behind bridge: 00000000fa000000-00000000fbffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 un=
limited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us,=

L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgm=
t-
ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #3, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4179
	Capabilities: [90] Subsystem: Dell Device 0275
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3Dff
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=3D02 ComponentID=3D02 EltType=3DConfig
		Link0:	Desc:	TargetPort=3D00 TargetComponent=3D02 AssocRCRB- LinkType=3D=
MemMapped
LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Po=
rt
4 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D06, subordinate=3D06, sec-latency=3D0
	I/O behind bridge: 00005000-00005fff
	Memory behind bridge: f4000000-f7ffffff
	Prefetchable memory behind bridge: 00000000fc000000-00000000fdffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 un=
limited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256n=
s,
L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgm=
t-
ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #5, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4181
	Capabilities: [90] Subsystem: Dell Device 0275
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=3D04 ComponentID=3D02 EltType=3DConfig
		Link0:	Desc:	TargetPort=3D00 TargetComponent=3D02 AssocRCRB- LinkType=3D=
MemMapped
LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Po=
rt
5 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D07, subordinate=3D07, sec-latency=3D0
	I/O behind bridge: 00006000-00006fff
	Memory behind bridge: 80200000-806fffff
	Prefetchable memory behind bridge: 00000000f8400000-00000000f84fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 un=
limited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256n=
s,
L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgm=
t-
ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #2, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4189
	Capabilities: [90] Subsystem: Dell Device 0275
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=3D05 ComponentID=3D02 EltType=3DConfig
		Link0:	Desc:	TargetPort=3D00 TargetComponent=3D02 AssocRCRB- LinkType=3D=
MemMapped
LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI C=
ontroller
#1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at 1840 [size=3D32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI C=
ontroller
#2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at 1860 [size=3D32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI C=
ontroller
#3 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 1880 [size=3D32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI
Controller #1 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Dell Device 0275
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at f8304c00 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0+,D1-,D2-,D3hot+,D=
3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME+
	Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3) (p=
rog-if
01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=3D00, secondary=3D08, subordinate=3D08, sec-latency=3D32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: f8000000-f80fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt-
<MAbort+ <SERR- <PERR+
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Dell Device 0275

00:1f.0 ISA bridge: Intel Corporation 82801HM (ICH8M) LPC Interface Contr=
oller
(rev 03)
	Subsystem: Dell Device 0275
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=3D0c <?>

00:1f.1 IDE interface: Intel Corporation 82801HM/HEM (ICH8M/ICH8M-E) IDE
Controller (rev 03) (prog-if 8a [Master SecP PriP])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 01f0 [size=3D8]
	Region 1: I/O ports at 03f4 [size=3D1]
	Region 2: I/O ports at 0170 [size=3D8]
	Region 3: I/O ports at 0374 [size=3D1]
	Region 4: I/O ports at 18a0 [size=3D16]
	Kernel driver in use: ata_piix

00:1f.2 SATA controller: Intel Corporation 82801HM/HEM (ICH8M/ICH8M-E) SA=
TA
Controller [AHCI mode] (rev 03) (prog-if 01 [AHCI 1.0])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 45
	Region 0: I/O ports at 18d8 [size=3D8]
	Region 1: I/O ports at 18cc [size=3D4]
	Region 2: I/O ports at 18d0 [size=3D8]
	Region 3: I/O ports at 18c8 [size=3D4]
	Region 4: I/O ports at 18e0 [size=3D32]
	Region 5: Memory at f8304000 (32-bit, non-prefetchable) [size=3D2K]
	Capabilities: [80] MSI: Enable+ Count=3D1/4 Maskable- 64bit-
		Address: fee0300c  Data: 4191
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,D3c=
old-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=3D00000004
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (r=
ev
03)
	Subsystem: Dell Device 0275
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt-
<MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at 80100000 (32-bit, non-prefetchable) [size=3D256]
	Region 4: I/O ports at 1c00 [size=3D32]

01:00.0 VGA compatible controller: NVIDIA Corporation G86 [GeForce 8600M
GS] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at ca000000 (32-bit, non-prefetchable) [size=3D16M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=3D256M]
	Region 3: Memory at c8000000 (64-bit, non-prefetchable) [size=3D32M]
	Region 5: I/O ports at 2000 [size=3D128]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [68] MSI: Enable- Count=3D1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <512=
ns,
L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMg=
mt-
ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
			Status:	NegoPending- InProgress-
	Capabilities: [128 v1] Power Budgeting <?>
	Capabilities: [600 v1] Vendor Specific Information: ID=3D0001 Rev=3D1 Le=
n=3D024
<?>
	Kernel driver in use: nvidia

06:00.0 Network controller: Broadcom Corporation BCM4321 802.11a/b/g/n (r=
ev
03)
	Subsystem: Dell Wireless 1500 Draft 802.11n WLAN Mini-card
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at f4000000 (64-bit, non-prefetchable) [size=3D16K]
	Region 2: Memory at fc000000 (64-bit, prefetchable) [size=3D1M]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D2 PME-
	Capabilities: [58] Vendor Specific Information: Len=3D78 <?>
	Capabilities: [e8] MSI: Enable- Count=3D1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [d0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimit=
ed
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM unknown, Latency L0 <4us=
,
L1 <64us
			ClockPM- Surprise+ LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgm=
t-
ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
-
ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
-
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTL=
P+
ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [13c v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number c9-97-4d-ff-ff-95-00-23
	Capabilities: [16c v1] Power Budgeting <?>
	Kernel driver in use: b43-pci-bridge

07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168=
B
PCI Express Gigabit Ethernet controller (rev 02)
	Subsystem: Dell Device 0275
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-
<MAbort- >SERR+ <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 46
	Region 0: I/O ports at 6000 [size=3D256]
	Region 2: Memory at f8410000 (64-bit, prefetchable) [size=3D4K]
	Region 4: Memory at f8400000 (64-bit, prefetchable) [size=3D64K]
	[virtual] Expansion ROM at f8420000 [disabled] [size=3D64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+,D2+,D3hot+,D=
3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [50] MSI: Enable+ Count=3D1/2 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4199
	Capabilities: [70] Express (v1) Endpoint, MSI 01
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <8us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512n=
s,
L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgm=
t-
ABWMgmt-
	Capabilities: [b0] MSI-X: Enable- Count=3D2 Masked-
		Vector table: BAR=3D4 offset=3D00000000
		PBA: BAR=3D4 offset=3D00000800
	Capabilities: [d0] Vital Product Data
		Unknown small resource type 00, will not decode more.
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
-
ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP=
-
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTL=
P+
ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout+ NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=3DFixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: r8169

08:05.0 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02=
)
(prog-if 10 [OHCI])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt-
<MAbort- >SERR- <PERR- INTx+
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at f8000000 (32-bit, non-prefetchable) [size=3D4K]
	Region 1: Memory at f8002000 (32-bit, non-prefetchable) [size=3D2K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME+
	Kernel driver in use: firewire_ohci

08:05.2 SD Host controller: O2 Micro, Inc. Integrated MMC/SD Controller (=
rev
02) (prog-if 01)
	Subsystem: Dell Device 0275
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at f8002800 (32-bit, non-prefetchable) [size=3D256]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: sdhci-pci

08:05.3 Mass storage controller: O2 Micro, Inc. Integrated MS/xD Controll=
er
(rev 01)
	Subsystem: Dell Device 0275
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort- <TAbort=
-
<MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at f8001000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3c=
old+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-

[8.6.] SCSI information (from /proc/scsi/scsi)
$ cat /proc/scsi/scsi 
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: Optiarc  Model: DVD+-RW AD-7640A Rev: JD06
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD2500BJKT-7 Rev: 11.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05

[8.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
# lsusb -v
Bus 002 Device 003: ID 2013:0245 PCTV Systems PCTV 73ESE
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x2013 PCTV Systems
  idProduct          0x0245 PCTV 73ESE
  bcdDevice            1.00
  iManufacturer           1 PCTV Systems
  iProduct                2 PCTV 73e SE
  iSerial                 3 0000000M05E19JN
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
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
[X.] Other notes, patches, fixes, workarounds:

       




--========/4FC4F2380000A8A7/mta-nl-6.mail.tiscali.sys
Content-Type: application/x-gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="config.gz"

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
to2ysup5nGl2mPVcbjIPlcf/Ad7PGrtX6gEA

--========/4FC4F2380000A8A7/mta-nl-6.mail.tiscali.sys--
