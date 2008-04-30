Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate02.web.de ([217.72.192.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ron.w@web.de>) id 1Jr37O-00025C-LX
	for linux-dvb@linuxtv.org; Wed, 30 Apr 2008 05:36:33 +0200
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate02.web.de (Postfix) with ESMTP id 5DFA9DAB3D30
	for <linux-dvb@linuxtv.org>; Wed, 30 Apr 2008 05:35:57 +0200 (CEST)
Received: from [80.145.40.165] (helo=boston)
	by smtp08.web.de with asmtp (WEB.DE 4.109 #226) id 1Jr36j-000213-00
	for linux-dvb@linuxtv.org; Wed, 30 Apr 2008 05:35:49 +0200
From: "Ron.W" <ron.w@web.de>
To: <linux-dvb@linuxtv.org>
Date: Wed, 30 Apr 2008 05:35:01 +0200
Message-ID: <NFBBKEGPALMMLCECKEBMAEPGCDAA.ron.w@web.de>
MIME-Version: 1.0
Subject: [linux-dvb] Lifeview DVB-T Duo Mini PCI (5168:0307) SAA7134
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

I have a Lifeview DVB-T Duo Mini-PCI Card (type 5168:0307) in this Medion
MD95500-Notebook.

I was used to get its analog part working by

modprobe saa7134 card=3D55 tuner=3D54 i2c_scan=3D1
modprobe saa7134-alsa

as root, and then as user

mplayer -tv
driver=3Dv4l2:device=3D/dev/video0:chanlist=3Deurope-west:alsa:adevice=3Dhw=
.1,0:amod
e=3D1:audiorate=3D32000:forceaudio:volume=3D100:immediatemode=3D0:norm=3DPA=
L tv://36

or any other tv-viewer application (kdetv, tvtime).

I need analog part since there is no DVB-T in our area and I connect the
card usually to a satellite receiver which has analog output on ch36.

This worked that way fine in kanotix 2005-04, 2006-01-RC4 as well as in
Sabayonlinux 3.2. Since these are outdated I had to reinstall newer versions
of the OSs. Strange enough, I did everything as before, but now I don't get
a picture and no sound anymore from the tv-card. What has happened? It seems
to me you have changed something in the modules.

Well, after long testing I noticed I get a picture from analog input now,
using Sidux 2008-01 when typing

modprobe saa7134 card=3D5 tuner=3D54 alsa=3D1

But there was no way to get sound from this. Since I've read somewhere in
this list, the alsa-support would be better in the mercurial version of
v4l-dvb, I installed mercurial and followed the instructions in the wiki to
make and install this version.

While performing "make reload" the PC stopped responding with black screen.
I had to hardreset and reboot, so the new versions of the modules should be
employed by now anyway.

But now the tv-picture stays black again, the module uses obviously not the
needed tuner.

It looks to me like the module sticks to DVB Part now. How can I switch
between DVB-T and Analog Tuner? I didn't find anything in the manuals about
this.

Please, can anybody help me to get this card back to work?

Greetings
Ron.


----------------


P.S.: Here are the logs from mercurial version, installed on sidux 2008-01,
and below some older logs from the versions I got picture and sound with.

lspci -v

06:03.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135 Video
Broadcast Decoder (rev d0)
        Subsystem: Animation Technologies Inc. Unknown device 0307
        Flags: bus master, medium devsel, latency 181, IRQ 19
        Memory at b4007800 (32-bit, non-prefetchable) [size=3D2K]
        Capabilities: [40] Power Management version 2
        Kernel driver in use: saa7134
        Kernel modules: saa7134

00:1b.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
High Definition Audio Controller (rev 04)
        Subsystem: Rioworks Unknown device 203d
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at 80000000 (64-bit, non-prefetchable) [size=3D16K]
        Capabilities: [50] Power Management version 2
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+
Queue=3D0/0 Enable-
        Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [130] Root Complex Link <?>
        Kernel driver in use: HDA Intel
        Kernel modules: snd-hda-intel


---------------------------------------
modprobe saa7134 card=3D5 tuner=3D54 alsa=3D1

dmesg:

saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:06:03.0, rev: 208, irq: 19, latency: 181, mmio:
0xb4007800
saa7133[0]: subsystem: 5168:0307, board: SKNet Monster TV [card=3D5,insmod
option]
saa7133[0]: board init: gpio is 10000
saa7133[0]: i2c eeprom 00: 68 51 07 03 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 e7 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 24 00 c2 96 10 ff ff 01 16 32 15 ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xb4007800 irq 19 registered as card -1


lsmod:

Module                  Size  Used by
saa7134_alsa           15648  0
saa7134               144340  1 saa7134_alsa
tuner                  28876  0
tda1004x               17028  0
videobuf_dvb            7812  0
dvb_core               80636  1 videobuf_dvb
tda827x                11268  0
tuner_simple           16272  0
tuner_types            14848  1 tuner_simple
tda8290                14596  0
nvidia               7825024  26
ppdev                  10372  0
lp                     13444  0
acpi_cpufreq           10540  0
cpufreq_stats           7232  0
cpufreq_powersave       2816  0
cpufreq_ondemand        9740  1
freq_table              5664  3 acpi_cpufreq,cpufreq_stats,cpufreq_ondemand
cpufreq_conservative     8840  0
ipv6                  270436  8
af_packet              23812  2
fuse                   50580  1
joydev                 13248  0
pcmcia                 41260  0
irda                  129464  0
psmouse                40976  0
sdhci                  19332  0
parport_pc             41060  1
parport                38216  3 ppdev,lp,parport_pc
crc_ccitt               3072  1 irda
ipw2200               146120  0
pcspkr                  4096  0
serio_raw               7940  0
videodev               34688  2 saa7134,tuner
v4l1_compat            15748  1 videodev
compat_ioctl32          2304  1 saa7134
v4l2_common            12672  2 saa7134,tuner
videobuf_dma_sg        14980  2 saa7134_alsa,saa7134
videobuf_core          19460  3 saa7134,videobuf_dvb,videobuf_dma_sg
ir_kbd_i2c             11152  1 saa7134
ir_common              40708  2 saa7134,ir_kbd_i2c
tveeprom               13444  1 saa7134
tifm_7xx1               8832  0
ieee80211              35784  1 ipw2200
ieee80211_crypt         7040  1 ieee80211
mmc_core               51460  1 sdhci
tifm_core              11140  1 tifm_7xx1
yenta_socket           27404  1
rsrc_nonstatic         14464  1 yenta_socket
pcmcia_core            41112  3 pcmcia,yenta_socket,rsrc_nonstatic
i2c_i801               10128  0
i2c_core               25088  11
saa7134,tuner,tda1004x,tda827x,tuner_simple,tda8290,nvidia,v4l2_common,ir_kb
d_i2c,tveeprom,i2c_i801
iTCO_wdt               13352  0
iTCO_vendor_support     4868  1 iTCO_wdt
evdev                  13184  5
snd_hda_intel         295712  1
snd_pcm_oss            42752  0
snd_mixer_oss          17792  1 snd_pcm_oss
container               5760  0
snd_pcm                80644  3 saa7134_alsa,snd_hda_intel,snd_pcm_oss
snd_timer              24452  1 snd_pcm
battery                12164  0
ac                      6532  0
button                  9232  0
snd                    55684  8
saa7134_alsa,snd_hda_intel,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer
soundcore               9184  1 snd
snd_page_alloc         11400  2 snd_hda_intel,snd_pcm
intel_agp              25620  0
ext3                  137608  5
jbd                    51476  1 ext3
dm_mirror              25216  0
dm_snapshot            19752  0
dm_mod                 62916  2 dm_mirror,dm_snapshot
sg                     36624  0
sr_mod                 19364  0
cdrom                  37408  1 sr_mod
sd_mod                 30720  7
pata_acpi               8320  0
usbhid                 46208  0
ff_memless              6920  1 usbhid
ata_piix               19588  6
ahci                   28548  0
ata_generic             8452  0
firewire_ohci          19456  0
firewire_core          44096  1 firewire_ohci
crc_itu_t               3072  1 firewire_core
libata                158264  4 pata_acpi,ata_piix,ahci,ata_generic
ehci_hcd               37004  0
uhci_hcd               27020  0
usbcore               146156  4 usbhid,ehci_hcd,uhci_hcd
sky2                   47364  0
thermal                16796  0
processor              37000  3 acpi_cpufreq,thermal
fan                     5636  0



---------------------------------------------------
modprobe saa7134 card=3D55 tuner=3D54 alsa=3D1 i2c_scan=3D1

dmesg

saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:06:03.0, rev: 208, irq: 19, latency: 181, mmio:
0xb4007800
saa7133[0]: subsystem: 5168:0307, board: LifeView FlyDVB-T DUO / MSI
TV@nywhere Duo [card=3D55,insmod option]
saa7133[0]: board init: gpio is 10000
input: saa7134 IR (LifeView FlyDVB-T D as
/devices/pci0000:00/0000:00:1e.0/0000:06:03.0/input/input12
saa7133[0]: i2c eeprom 00: 68 51 07 03 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 e7 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 24 00 c2 96 10 ff ff 01 16 32 15 ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
saa7133[0]/dvb: frontend initialization failed
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xb4007800 irq 19 registered as card -1


lsmod:

Module                  Size  Used by
saa7134_alsa           15648  0
saa7134_dvb            21516  0
saa7134               144340  2 saa7134_alsa,saa7134_dvb
tuner                  28876  0
tda1004x               17028  0
videobuf_dvb            7812  1 saa7134_dvb
dvb_core               80636  2 saa7134_dvb,videobuf_dvb
tda827x                11268  0
tuner_simple           16272  0
tuner_types            14848  1 tuner_simple
tda8290                14596  0
nvidia               7825024  26
ppdev                  10372  0
lp                     13444  0
acpi_cpufreq           10540  0
cpufreq_stats           7232  0
cpufreq_powersave       2816  0
cpufreq_ondemand        9740  1
freq_table              5664  3 acpi_cpufreq,cpufreq_stats,cpufreq_ondemand
cpufreq_conservative     8840  0
ipv6                  270436  8
af_packet              23812  2
fuse                   50580  1
joydev                 13248  0
pcmcia                 41260  0
irda                  129464  0
psmouse                40976  0
sdhci                  19332  0
parport_pc             41060  1
parport                38216  3 ppdev,lp,parport_pc
crc_ccitt               3072  1 irda
ipw2200               146120  0
pcspkr                  4096  0
serio_raw               7940  0
videodev               34688  2 saa7134,tuner
v4l1_compat            15748  1 videodev
compat_ioctl32          2304  1 saa7134
v4l2_common            12672  2 saa7134,tuner
videobuf_dma_sg        14980  3 saa7134_alsa,saa7134_dvb,saa7134
videobuf_core          19460  3 saa7134,videobuf_dvb,videobuf_dma_sg
ir_kbd_i2c             11152  1 saa7134
ir_common              40708  2 saa7134,ir_kbd_i2c
tveeprom               13444  1 saa7134
tifm_7xx1               8832  0
ieee80211              35784  1 ipw2200
ieee80211_crypt         7040  1 ieee80211
mmc_core               51460  1 sdhci
tifm_core              11140  1 tifm_7xx1
yenta_socket           27404  1
rsrc_nonstatic         14464  1 yenta_socket
pcmcia_core            41112  3 pcmcia,yenta_socket,rsrc_nonstatic
i2c_i801               10128  0
i2c_core               25088  12
saa7134_dvb,saa7134,tuner,tda1004x,tda827x,tuner_simple,tda8290,nvidia,v4l2_
common,ir_kbd_i2c,tveeprom,i2c_i801
iTCO_wdt               13352  0
iTCO_vendor_support     4868  1 iTCO_wdt
evdev                  13184  6
snd_hda_intel         295712  1
snd_pcm_oss            42752  0
snd_mixer_oss          17792  1 snd_pcm_oss
container               5760  0
snd_pcm                80644  3 saa7134_alsa,snd_hda_intel,snd_pcm_oss
snd_timer              24452  1 snd_pcm
battery                12164  0
ac                      6532  0
button                  9232  0
snd                    55684  8
saa7134_alsa,snd_hda_intel,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer
soundcore               9184  1 snd
snd_page_alloc         11400  2 snd_hda_intel,snd_pcm
intel_agp              25620  0
ext3                  137608  5
jbd                    51476  1 ext3
dm_mirror              25216  0
dm_snapshot            19752  0
dm_mod                 62916  2 dm_mirror,dm_snapshot
sg                     36624  0
sr_mod                 19364  0
cdrom                  37408  1 sr_mod
sd_mod                 30720  7
pata_acpi               8320  0
usbhid                 46208  0
ff_memless              6920  1 usbhid
ata_piix               19588  6
ahci                   28548  0
ata_generic             8452  0
firewire_ohci          19456  0
firewire_core          44096  1 firewire_ohci
crc_itu_t               3072  1 firewire_core
libata                158264  4 pata_acpi,ata_piix,ahci,ata_generic
ehci_hcd               37004  0
uhci_hcd               27020  0
usbcore               146156  4 usbhid,ehci_hcd,uhci_hcd
sky2                   47364  0
thermal                16796  0
processor              37000  3 acpi_cpufreq,thermal
fan                     5636  0




Here are some earlier outputs I have logged:

----------------------------------------------------------------------------
------------------------------------------
sabayon 3.2 (analog tv works fine)
uname -r
2.6.18-gentoo-r4


as root:

modprobe saa7134 card=3D55 tuner=3D54
modprobe saa7134-dvb
modprobe saa7134-alsa

dmesg:
[  479.063000] saa7130/34: v4l2 driver version 0.2.14 loaded
[  479.064000] saa7133[0]: found at 0000:06:03.0, rev: 208, irq: 209,
latency: 181, mmio: 0xb4007800
[  479.064000] saa7133[0]: subsystem: 5168:0307, board: LifeView FlyDVB-T
DUO [card=3D55,insmod option]
[  479.064000] saa7133[0]: board init: gpio is 10000
[  479.064000] input: saa7134 IR (LifeView FlyDVB-T D as /class/input/input4
[  479.188000] saa7133[0]: i2c eeprom 00: 68 51 07 03 54 20 1c 00 43 43 a9
1c 55 d2 b2 92
[  479.188000] saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff ff
ff ff ff ff ff
[  479.188000] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01
e7 ff ff ff ff
[  479.188000] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[  479.188000] saa7133[0]: i2c eeprom 40: ff 24 00 c2 96 10 ff ff 01 16 32
15 ff ff ff ff
[  479.188000] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[  479.188000] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[  479.188000] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[  479.562000] tuner 1-004b: chip found @ 0x96 (saa7133[0])
[  479.589000] tuner 1-004b: setting tuner address to 61
[  479.614000] tuner 1-004b: type set to tda8290+75
[  479.650000] saa7133[0]: registered device video0 [v4l2]
[  479.650000] saa7133[0]: registered device vbi0
[  489.380000] DVB: registering new adapter (saa7133[0]).
[  489.380000] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[  495.776000] saa7134 ALSA driver for DMA sound loaded
[  495.776000] saa7133[0]/alsa: saa7133[0] at 0xb4007800 irq 209 registered
as card -1


lspci -v
06:03.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135 Video
Broadcast Decoder (rev d0)
        Subsystem: Animation Technologies Inc. Unknown device 0307
        Flags: bus master, medium devsel, latency 181, IRQ 209
        Memory at b4007800 (32-bit, non-prefetchable) [size=3D2K]
        Capabilities: [40] Power Management version 2

lsmod:
sabayonx86 sabayonuser # lsmod
Module                  Size  Used by
nls_iso8859_1           4992  1
nls_cp437               6656  1
saa7134_alsa           10560  1
saa7134_dvb            13060  0
dvb_pll                12676  1 saa7134_dvb
mt352                   6532  1 saa7134_dvb
video_buf_dvb           5252  1 saa7134_dvb
nxt200x                12292  1 saa7134_dvb
tda1004x               13572  1 saa7134_dvb
tuner                  52392  0
saa7134                99168  2 saa7134_alsa,saa7134_dvb
snd_seq_dummy           3716  0
snd_seq_oss            26240  0
snd_seq_midi_event      6656  1 snd_seq_oss
snd_seq                41040  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_seq_device          6924  3 snd_seq_dummy,snd_seq_oss,snd_seq
nvidia               4703156  32
pcmcia                 27708  0
joydev                  8128  0
video_buf              18820  4
saa7134_alsa,saa7134_dvb,video_buf_dvb,saa7134
compat_ioctl32          2176  1 saa7134
ir_kbd_i2c              7312  1 saa7134
yenta_socket           21772  1
i2c_i801                7436  0
ir_common              24964  2 saa7134,ir_kbd_i2c
ipw2200                92100  0
videodev               19584  1 saa7134
v4l1_compat            12292  2 saa7134,videodev
sky2                   32900  0
rsrc_nonstatic         10496  1 yenta_socket
sdhci                  14604  0
intel_agp              18844  1
i2c_core               15744  10
saa7134_dvb,dvb_pll,mt352,nxt200x,tda1004x,tuner,saa7134,nvidia,ir_kbd_i2c,i
2c_i801
serio_raw               5892  0
snd_hda_intel          13844  1
irda                   99512  0
crc_ccitt               2944  1 irda
v4l2_common            19584  3 tuner,saa7134,videodev
ieee80211              26184  1 ipw2200
ieee80211_crypt         5376  1 ieee80211
snd_hda_codec         135808  1 snd_hda_intel
mmc_core               18176  1 sdhci
agpgart                24008  2 nvidia,intel_agp
pcspkr                  3456  0
e1000                 102080  0
unionfs                73632  1
sl811_hcd              10496  0
ohci_hcd               16644  0
uhci_hcd               18568  0
ehci_hcd               25480  0




as user:

sabayonuser@sabayonx86 ~ $ /usr/bin/mplayer -v -vo gl -fs -tv
driver=3Dv4l2:device
=3D/dev/video0:chanlist=3Deurope-west:alsa:adevice=3Dhw.1,0:amode=3D1:audio=
rate=3D3200
0:fo
rceaudio:volume=3D100:immediatemode=3D0:norm=3DPAL tv://36
MPlayer 1.0rc1-4.1.1 (C) 2000-2006 MPlayer Team
CPU: Intel(R) Pentium(R) M processor 1.73GHz (Family: 6, Model: 13,
Stepping: 8)
MMX2 supported but disabled
SSE supported but disabled
SSE2 supported but disabled
CPUflags:  MMX: 1 MMX2: 0 3DNow: 0 3DNow2: 0 SSE: 0 SSE2: 0
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD =EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD -
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD - =
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD =EF=BF=BD =EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD
=EF=BF=BD!
=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD-=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD,
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD MPlayer
=EF=BF=BD --disable-runtime-cpudet
ection.
get_path('codecs.conf') -> '/home/sabayonuser/.mplayer/codecs.conf'
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD /=
home/sabayonuser/.mplayer/codecs.conf:
'/home/sabayonuser/.mplayer/co
decs.conf': No such file or directory =EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD /=
usr/share/mplayer/codecs.conf:
'/usr/share/mplayer/codecs.conf': No s
uch file or directory =EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD =EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =
=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD codecs.conf.
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =
=EF=BF=BD=EF=BF=BD=EF=BF=BD: '-v' '-vo' 'gl' '-fs' '-tv'
'driver=3Dv4l2:device=3D/dev/video0:chanli
st=3Deurope-west:alsa:adevice=3Dhw.1,0:amode=3D1:audiorate=3D32000:forceaud=
io:volume
=3D100
:immediatemode=3D0:norm=3DPAL' 'tv://36'
get_path('font/font.desc') -> '/home/sabayonuser/.mplayer/font/font.desc'
font: can't open file: /home/sabayonuser/.mplayer/font/font.desc
font: can't open file: /usr/share/mplayer/font/font.desc
Using MMX Optimized OnScreenDisplay
Using nanosleep() timing
get_path('input.conf') -> '/home/sabayonuser/.mplayer/input.conf'
Can't open input config file /home/sabayonuser/.mplayer/input.conf: No such
file
 or directory
Parsing input config file /usr/share/mplayer/input.conf
Input config file /usr/share/mplayer/input.conf parsed: 67 binds
Opening joystick device /dev/input/js0
Can't open joystick device /dev/input/js0: No such file or directory
Can't init input joystick
get_path('36.conf') -> '/home/sabayonuser/.mplayer/36.conf'
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=
=BF=BD tv://36.
get_path('sub/') -> '/home/sabayonuser/.mplayer/sub/'
STREAM: [tv] tv://36
STREAM: Description: TV Input
STREAM: Author: Benjamin Zores, Albeu
STREAM: Comment:
TV =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
Selected device: LifeView FlyDVB-T DUO
 Tuner cap: STEREO LANG1 LANG2
 Tuner rxs: MONO
 Capabilites:  video capture  video overlay  VBI capture device  tuner
read/wri
te  streaming
 supported norms: 0 =3D PAL; 1 =3D PAL-BG; 2 =3D PAL-I; 3 =3D PAL-DK; 4 =3D=
 NTSC; 5 =3D
SECA
M; 6 =3D PAL-M; 7 =3D PAL-Nc; 8 =3D PAL-60;
 inputs: 0 =3D Television; 1 =3D Composite1; 2 =3D Composite2; 3 =3D S-Vide=
o;
 Current input: 0
 Format GREY   ( 8 bits, 8 bpp gray): Planar Y800
 Format RGB555 (16 bits, 15 bpp RGB, le): BGR 15-bit
 Format RGB555X (16 bits, 15 bpp RGB, be): Unknown
 Format RGB565 (16 bits, 16 bpp RGB, le): BGR 16-bit
 Format RGB565X (16 bits, 16 bpp RGB, be): Unknown
 Format BGR24  (24 bits, 24 bpp RGB, le): BGR 24-bit
 Format RGB24  (24 bits, 24 bpp RGB, be): RGB 24-bit
 Format BGR32  (32 bits, 32 bpp RGB, le): BGRA
 Format RGB32  (32 bits, 32 bpp RGB, be): RGBA
 Format YUYV   (16 bits, 4:2:2 packed, YUYV): Packed YUY2
 Format UYVY   (16 bits, 4:2:2 packed, UYVY): Packed UYVY
 Format YUV422P (16 bits, 4:2:2 planar, Y-Cb-Cr): Planar 422P
 Format YUV420 (12 bits, 4:2:0 planar, Y-Cb-Cr): Planar I420
 Format YVU420 (12 bits, 4:2:0 planar, Y-Cb-Cr): Planar YV12
 Current format: BGR24
v4l2: setting audio mode
v4l2: current audio mode is : STEREO
v4l2: set Volume: 15 [-15, 15]
v4l2: set format: YVU420
v4l2: set input: 0
Selected norm: PAL
v4l2: set norm: PAL
Selected channel list: europe-west (including 104 channels)
Requested channel: 36
Selected channel: 36 (freq: 591.250)
Current frequency: 9460 (591.250)
Current frequency: 9460 (591.250)
=3D=3D> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD =
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD: 0
v4l2: get format: YVU420
v4l2: get fps: 25.000000
v4l2: get width: 640
v4l2: get height: 480
Hardware PCM card 1 'SAA7134' device 0 subdevice 0
Its setup is:
  stream       : CAPTURE
  access       : RW_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 48000
  exact rate   : 48000 (48000/1)
  msbits       : 16
  buffer_size  : 48000
  period_size  : 12000
  period_time  : 250000
  tick_time    : 1000
  tstamp_mode  : NONE
  period_step  : 1
  sleep_min    : 0
  avail_min    : 12000
  xfer_align   : 12000
  start_threshold  : 0
  stop_threshold   : 48000
  silence_threshold: 0
  silence_size : 0
  boundary     : 1572864000
v4l2: set audio samplerate: 32000
Hardware PCM card 1 'SAA7134' device 0 subdevice 0
Its setup is:
  stream       : CAPTURE
  access       : RW_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 32000
  exact rate   : 32000 (32000/1)
  msbits       : 16
  buffer_size  : 32000
  period_size  : 8000
  period_time  : 250000
  tick_time    : 1000
  tstamp_mode  : NONE
  period_step  : 1
  sleep_min    : 0
  avail_min    : 8000
  xfer_align   : 8000
  start_threshold  : 0
  stop_threshold   : 32000
  silence_threshold: 0
  silence_size : 0
  boundary     : 2097152000
v4l2: get audio format: 9
=3D=3D> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD =
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD: 0
v4l2: get audio samplerate: 32000
v4l2: get audio samplesize: 2
v4l2: get audio channels: 2
  TV audio: 2 channels, 16 bits, 32000 Hz
Audio capture - buffer 256 blocks of 32000 bytes, skew average from 16 meas.
Using a ring buffer for maximum 566 frames, 248 MB total size.
v4l2: set Brightness: 128 [0, 255]
v4l2: set Hue: 0 [-128, 127]
v4l2: set Saturation: 64 [0, 127]
v4l2: set Contrast: 68 [0, 127]
[V] filefmt:9  fourcc:0x32315659  size:640x480  fps:25.00  ftime:=3D0.0400
get_path('sub/') -> '/home/sabayonuser/.mplayer/sub/'
[gl] using extended formats. Use -vo gl:nomanyfmts if playback fails.
[gl] Using 4 as slice height (0 means image height).
X11 opening display: :0.0
vo: X11 color mask:  FFFFFF  (R:FF0000 G:FF00 B:FF)
vo: X11 running at 1440x900 with depth 24 and 32 bpp (":0.0" =3D> local
display)
[x11] Detected wm supports NetWM.
[x11] Detected wm supports FULLSCREEN state.
[x11] Detected wm supports ABOVE state.
[x11] Detected wm supports BELOW state.
[x11] Current fstype setting honours FULLSCREEN ABOVE BELOW X atoms
Disabling DPMS
DPMSDisable stat: 1
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =
=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD: [raw]
RAW Uncompressed Video
VDec: =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=
=BF=BD vo config - 640 x 480 (preferred csp: Planar
YV12)
Trying filter chain: vo
=EF=BF=BD=EF=BF=BD =EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD - =EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD =EF=BF=BD -vf scale...
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =
=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD: [scale]
SwScale params: -1 x -1 (-1=3Dno scaling)
Trying filter chain: scale vo
VDec: using Planar YV12 as output csp (no 0)
=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD -
=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD.
VO Config (640x480->640x480,flags=3D1,'MPlayer',0x32315659)
SwScaler: using unscaled yuv420p -> rgb32 special converter
REQ: flags=3D0x24B7  req=3D0x0
VO: [gl] 640x480 =3D> 640x480 BGRA  [fs]
VO: Description: X11 (OpenGL)
VO: Author: Arpad Gereoffy <arpi@esp-team.scene.hu>
OpenGL extensions string:
GL_ARB_color_buffer_float GL_ARB_depth_texture GL_ARB_draw_buffers
GL_ARB_fragme
nt_program GL_ARB_fragment_program_shadow GL_ARB_fragment_shader
GL_ARB_half_flo
at_pixel GL_ARB_imaging GL_ARB_multisample GL_ARB_multitexture
GL_ARB_occlusion_
query GL_ARB_pixel_buffer_object GL_ARB_point_parameters GL_ARB_point_sprite
GL_
ARB_shadow GL_ARB_shader_objects GL_ARB_shading_language_100
GL_ARB_texture_bord
er_clamp GL_ARB_texture_compression GL_ARB_texture_cube_map
GL_ARB_texture_env_a
dd GL_ARB_texture_env_combine GL_ARB_texture_env_dot3 GL_ARB_texture_float
GL_AR
B_texture_mirrored_repeat GL_ARB_texture_non_power_of_two
GL_ARB_texture_rectang
le GL_ARB_transpose_matrix GL_ARB_vertex_buffer_object GL_ARB_vertex_program
GL_
ARB_vertex_shader GL_ARB_window_pos GL_ATI_draw_buffers GL_ATI_texture_float
GL_
ATI_texture_mirror_once GL_S3_s3tc GL_EXT_texture_env_add GL_EXT_abgr
GL_EXT_bgr
a GL_EXT_blend_color GL_EXT_blend_equation_separate
GL_EXT_blend_func_separate G
L_EXT_blend_minmax GL_EXT_blend_subtract GL_EXT_compiled_vertex_array
GL_EXT_Cg_
shader GL_EXT_depth_bounds_test GL_EXT_draw_range_elements GL_EXT_fog_coord
GL_E
XT_framebuffer_object GL_EXT_gpu_program_parameters GL_EXT_multi_draw_arrays
GL_
EXT_packed_depth_stencil GL_EXT_packed_pixels GL_EXT_pixel_buffer_object
GL_EXT_
point_parameters GL_EXT_rescale_normal GL_EXT_secondary_color
GL_EXT_separate_sp
ecular_color GL_EXT_shadow_funcs GL_EXT_stencil_two_side GL_EXT_stencil_wrap
GL_
EXT_texture3D GL_EXT_texture_compression_s3tc GL_EXT_texture_cube_map
GL_EXT_tex
ture_edge_clamp GL_EXT_texture_env_combine GL_EXT_texture_env_dot3
GL_EXT_textur
e_filter_anisotropic GL_EXT_texture_lod GL_EXT_texture_lod_bias
GL_EXT_texture_m
irror_clamp GL_EXT_texture_object GL_EXT_texture_sRGB GL_EXT_timer_query
GL_EXT_
vertex_array GL_HP_occlusion_test GL_IBM_rasterpos_clip
GL_IBM_texture_mirrored_
repeat GL_KTX_buffer_region GL_NV_blend_square GL_NV_copy_depth_to_color
GL_NV_d
epth_clamp GL_NV_fence GL_NV_float_buffer GL_NV_fog_distance
GL_NV_fragment_prog
ram GL_NV_fragment_program_option GL_NV_fragment_program2 GL_NV_half_float
GL_NV
_light_max_exponent GL_NV_multisample_filter_hint GL_NV_occlusion_query
GL_NV_pa
cked_depth_stencil GL_NV_pixel_data_range GL_NV_point_sprite
GL_NV_primitive_res
tart GL_NV_register_combiners GL_NV_register_combiners2
GL_NV_texgen_reflection
GL_NV_texture_compression_vtc GL_NV_texture_env_combine4
GL_NV_texture_expand_no
rmal GL_NV_texture_rectangle GL_NV_texture_shader GL_NV_texture_shader2
GL_NV_te
xture_shader3 GL_NV_vertex_array_range GL_NV_vertex_array_range2
GL_NV_vertex_pr
ogram GL_NV_vertex_program1_1 GL_NV_vertex_program2
GL_NV_vertex_program2_option
 GL_NV_vertex_program3 GL_NVX_conditional_render GL_SGIS_generate_mipmap
GL_SGIS
_texture_lod GL_SGIX_depth_texture GL_SGIX_shadow GL_SUN_slice_accum
GLX_EXT_vi
sual_info GLX_EXT_visual_rating GLX_SGIX_fbconfig GLX_SGIX_pbuffer
GLX_SGI_video
_sync GLX_SGI_swap_control GLX_EXT_texture_from_pixmap GLX_ARB_multisample
GLX_N
V_float_buffer GLX_ARB_fbconfig_float GLX_ARB_get_proc_address
[gl] Creating 1024x512 texture...
[gl] Resize: 1440x900
Selected video codec: [rawyv12] vfm: raw (RAW YV12)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =
=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD: [pcm]
Uncompressed PCM audio decoder
dec_audio: =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD =EF=BF=BD=EF=BF=BD 2048 + 65536 =3D 67584
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD =EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD.
AUDIO: 32000 Hz, 2 ch, s16le, 1024.0 kbit/100.00% (ratio: 128000->128000)
Selected audio codec: [pcm] afm: pcm (Uncompressed PCM)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Building audio filter chain for 32000Hz/2ch/s16le -> 0Hz/0ch/??...
[libaf] Adding filter dummy
[dummy] Was reinitialized: 32000Hz/2ch/s16le
[dummy] Was reinitialized: 32000Hz/2ch/s16le
alsa-init: requested format: 32000 Hz, 2 channels, 9
alsa-init: using ALSA 1.0.13
alsa-init: setup for 1/2 channel(s)
alsa-init: using device default
alsa-init: pcm opend in blocking mode
alsa-init: chunksize set to 1024
alsa-init: fragcount=3D16
alsa-init: got buffersize=3D65536
alsa-init: got period size 1024
alsa: 48000 Hz/2 channels/4 bpf/65536 bytes buffer/Signed 16 bit Little
Endian
AO: [alsa] 48000Hz 2ch s16le (2 bytes per sample)
AO: Description: ALSA-0.9.x-1.x audio output
AO: Author: Alex Beregszaszi, Zsolt Barat <joy@streamminister.de>
AO: Comment: under developement
Building audio filter chain for 32000Hz/2ch/s16le -> 48000Hz/2ch/s16le...
[dummy] Was reinitialized: 32000Hz/2ch/s16le
[libaf] Adding filter lavcresample
[dummy] Was reinitialized: 48000Hz/2ch/s16le
[dummy] Was reinitialized: 48000Hz/2ch/s16le
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD...
[libaf] Reallocating memory in module lavcresample, old len =3D 0, new len =
=3D
65536
v4l2: going to capture
*** [scale] Exporting mp_image_t, 640x480x12bpp YUV planar, 460800 bytes
*** [vo] Allocating mp_image_t, 640x480x32bpp BGR packed, 1228800 bytes
[gl] Resize: 1440x900
Uninit audio filters...-0.001 ct:  0.253 529/529  0% 14%  1.6% 1 0
[libaf] Removing filter lavcresample
[libaf] Removing filter dummy
uninit audio: pcm
uninit video: raw
v4l2: 543 frames successfully processed, 0 frames dropped.
v4l2: up to 22 video frames buffered.
Successfully enabled DPMS
alsa-uninit: pcm closed
vo: uninit ...

=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =
=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD...
(=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD)
sabayonuser@sabayonx86 ~ $

This procedure puts program on screen. In order to recover propperly from
suspend2ram I need to rmmod saa7134 and modprobe it after resume.
----------------------------------------------------------------------------
------------------------------------------


sabayon 3.4f (analog tv =3D black screen! DVB-T may work, can't check.)
uname -r
2.6.22-sabayon

as root:

modprobe saa7134 card=3D55 tuner=3D54
modprobe saa7134-alsa

(saa7134-dvb is pulled in by saa7134 now automatically)

dmesg
[  170.647534] saa7130/34: v4l2 driver version 0.2.14 loaded
[  170.648379] saa7133[0]: found at 0000:06:03.0, rev: 208, irq: 18,
latency: 181, mmio: 0xb4007800
[  170.648387] saa7133[0]: subsystem: 5168:0307, board: LifeView FlyDVB-T
DUO / MSI TV@nywhere Duo [card=3D55,insmod option]
[  170.648533] saa7133[0]: board init: gpio is 10000
[  170.654867] input: saa7134 IR (LifeView FlyDVB-T D as /class/input/input7
[  369.779915] Device driver i2c-1 lacks bus and class support for being
resumed.
[  170.766334] saa7133[0]: i2c eeprom 00: 68 51 07 03 54 20 1c 00 43 43 a9
1c 55 d2 b2 92
[  170.766345] saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff ff
ff ff ff ff ff
[  170.766355] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01
e7 ff ff ff ff
[  170.766365] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[  170.766374] saa7133[0]: i2c eeprom 40: ff 24 00 c2 96 10 ff ff 01 16 32
15 ff ff ff ff
[  170.766384] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[  170.766394] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[  170.766404] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[  369.977042] tuner 1-004b: chip found @ 0x96 (saa7133[0])
[  370.004005] tuner 1-004b: setting tuner address to 61
[  370.028977] tuner 1-004b: type set to tda8290+75
[  371.348535] tuner 1-004b: setting tuner address to 61
[  371.373508] tuner 1-004b: type set to tda8290+75
[  372.683561] saa7133[0]: registered device video0 [v4l2]
[  372.684216] saa7133[0]: registered device vbi0
[  372.684749] saa7133[0]: registered device radio0
[  172.130894] PCI driver saa7134 lacks driver specific resume support.
[  172.181758] DVB: registering new adapter (saa7133[0]).
[  172.181878] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[  172.212537] tda1004x: setting up plls for 48MHz sampling clock
[  375.152271] tda1004x: timeout waiting for DSP ready
[  375.163259] tda1004x: found firmware revision 0 -- invalid
[  375.163267] tda1004x: trying to boot from eeprom
[  377.469734] tda1004x: timeout waiting for DSP ready
[  377.480721] tda1004x: found firmware revision 0 -- invalid
[  377.480728] tda1004x: waiting for firmware upload...
[  377.480974] Device driver 0000:06:03.0 lacks bus and class support for
being resumed.
[  391.056659] tda1004x: found firmware revision 29 -- ok
[  391.144700] tda827x_probe_version: could not read from tuner at addr:
0xc0
[  191.953115] saa7134 ALSA driver for DMA sound loaded
[  191.953269] saa7133[0]/alsa: saa7133[0] at 0xb4007800 irq 18 registered
as card -1


lspci -v
06:03.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135 Video
Broadcast Decoder (rev d0)
        Subsystem: Animation Technologies Inc. Unknown device 0307
        Flags: bus master, medium devsel, latency 181, IRQ 18
        Memory at b4007800 (32-bit, non-prefetchable) [size=3D2K]
        Capabilities: [40] Power Management version 2

lsmod
Module                  Size  Used by
nls_iso8859_1           4256  1
nls_cp437               5920  1
saa7134_alsa           13696  0
tda827x                 7108  1
saa7134_dvb            16332  0
dvb_pll                14276  1 saa7134_dvb
video_buf_dvb           6756  1 saa7134_dvb
tda1004x               14404  2 saa7134_dvb
tuner                  57800  0
saa7134               121964  2 saa7134_alsa,saa7134_dvb
snd_seq_dummy           3876  0
snd_seq_oss            29600  0
snd_seq_midi_event      7008  1 snd_seq_oss
snd_seq                46448  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_seq_device          7884  3 snd_seq_dummy,snd_seq_oss,snd_seq
vboxdrv                39176  0
pcmcia                 36756  0
video_buf              23620  4
saa7134_alsa,saa7134_dvb,video_buf_dvb,saa7134
compat_ioctl32          1472  1 saa7134
ir_kbd_i2c              8816  1 saa7134
ir_common              34212  2 saa7134,ir_kbd_i2c
videodev               26848  1 saa7134
v4l2_common            16800  3 tuner,saa7134,videodev
v4l1_compat            12708  2 saa7134,videodev
yenta_socket           25100  1
rsrc_nonstatic         11200  1 yenta_socket
ipw2200               138216  0
ieee80211              31752  1 ipw2200
ieee80211_crypt         5984  1 ieee80211
smsc_ircc2             18016  0
irda                  114200  1 smsc_ircc2
crc_ccitt               2240  1 irda
tifm_7xx1               7552  0
tifm_core              10404  1 tifm_7xx1
sdhci                  16780  0
mmc_core               26180  1 sdhci
nvidia               6215536  36
iTCO_wdt               10788  0
iTCO_vendor_support     3940  1 iTCO_wdt
i2c_i801                8368  0
i2c_core               23840  9
tda827x,saa7134_dvb,dvb_pll,tda1004x,tuner,saa7134,ir_kbd_i2c,nvidia,i2c_i80
1
snd_hda_intel         238776  0
sky2                   40520  0
intel_agp              23380  0
joydev                  9696  0
tg3                   100452  0
e1000                 111680  0
scsi_wait_scan          1504  0
sl811_hcd              11808  0
uhci_hcd               22896  0
ehci_hcd               31276  0



/var/log/messages
Nov 20 11:18:43 birke [  170.647534] saa7130/34: v4l2 driver version 0.2.14
loaded
Nov 20 11:18:43 birke [  170.648379] saa7133[0]: found at 0000:06:03.0, rev:
208, irq: 18, latency: 181, mmio: 0xb4007800
Nov 20 11:18:43 birke [  170.648387] saa7133[0]: subsystem: 5168:0307,
board: LifeView FlyDVB-T DUO / MSI TV@nywhere Duo [card=3D55,insmod option]
Nov 20 11:18:43 birke [  170.648533] saa7133[0]: board init: gpio is 10000
Nov 20 11:18:43 birke [  170.654867] input: saa7134 IR (LifeView FlyDVB-T D
as /class/input/input7
Nov 20 11:18:43 birke NetworkManager: <debug> [1195557523.918003]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/pci_1131_7133_logicaldev_input').
Nov 20 11:18:43 birke [  369.779915] Device driver i2c-1 lacks bus and class
support for being resumed.
Nov 20 11:18:43 birke [  170.766334] saa7133[0]: i2c eeprom 00: 68 51 07 03
54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Nov 20 11:18:43 birke [  170.766345] saa7133[0]: i2c eeprom 10: 00 00 62 08
ff 20 ff ff ff ff ff ff ff ff ff ff
Nov 20 11:18:43 birke [  170.766355] saa7133[0]: i2c eeprom 20: 01 40 01 03
03 01 01 03 08 ff 01 e7 ff ff ff ff
Nov 20 11:18:43 birke [  170.766365] saa7133[0]: i2c eeprom 30: ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff
Nov 20 11:18:43 birke [  170.766374] saa7133[0]: i2c eeprom 40: ff 24 00 c2
96 10 ff ff 01 16 32 15 ff ff ff ff
Nov 20 11:18:43 birke [  170.766384] saa7133[0]: i2c eeprom 50: ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff
Nov 20 11:18:43 birke [  170.766394] saa7133[0]: i2c eeprom 60: ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff
Nov 20 11:18:43 birke [  170.766404] saa7133[0]: i2c eeprom 70: ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff
Nov 20 11:18:44 birke [  369.977042] tuner 1-004b: chip found @ 0x96
(saa7133[0])
Nov 20 11:18:44 birke [  370.004005] tuner 1-004b: setting tuner address to
61
Nov 20 11:18:44 birke [  370.028977] tuner 1-004b: type set to tda8290+75
Nov 20 11:18:45 birke [  371.348535] tuner 1-004b: setting tuner address to
61
Nov 20 11:18:45 birke [  371.373508] tuner 1-004b: type set to tda8290+75
Nov 20 11:18:46 birke NetworkManager: <debug> [1195557526.816957]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/pci_1131_7133_video4linux').
Nov 20 11:18:46 birke [  372.683561] saa7133[0]: registered device video0
[v4l2]
Nov 20 11:18:46 birke [  372.684216] saa7133[0]: registered device vbi0
Nov 20 11:18:46 birke [  372.684749] saa7133[0]: registered device radio0
Nov 20 11:18:46 birke NetworkManager: <debug> [1195557526.835733]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/pci_1131_7133_video4linux_0').
Nov 20 11:18:46 birke NetworkManager: <debug> [1195557526.842858]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/pci_1131_7133_video4linux_1').
Nov 20 11:18:46 birke [  172.130894] PCI driver saa7134 lacks driver
specific resume support.
Nov 20 11:18:46 birke [  172.181758] DVB: registering new adapter
(saa7133[0]).
Nov 20 11:18:46 birke [  172.181878] DVB: registering frontend 0 (Philips
TDA10046H DVB-T)...
Nov 20 11:18:46 birke NetworkManager: <debug> [1195557526.947825]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/pci_1131_7133_dvb').
Nov 20 11:18:46 birke NetworkManager: <debug> [1195557526.956965]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/pci_1131_7133_dvb_0').
Nov 20 11:18:46 birke [  172.212537] tda1004x: setting up plls for 48MHz
sampling clock
Nov 20 11:18:46 birke NetworkManager: <debug> [1195557526.964937]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/pci_1131_7133_dvb_1').
Nov 20 11:18:46 birke NetworkManager: <debug> [1195557526.966709]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/pci_1131_7133_dvb_2').
Nov 20 11:18:49 birke [  375.152271] tda1004x: timeout waiting for DSP ready
Nov 20 11:18:49 birke [  375.163259] tda1004x: found firmware revision 0 --
invalid
Nov 20 11:18:49 birke [  375.163267] tda1004x: trying to boot from eeprom
Nov 20 11:18:51 birke [  377.469734] tda1004x: timeout waiting for DSP ready
Nov 20 11:18:51 birke [  377.480721] tda1004x: found firmware revision 0 --
invalid
Nov 20 11:18:51 birke [  377.480728] tda1004x: waiting for firmware
upload...
Nov 20 11:18:51 birke [  377.480974] Device driver 0000:06:03.0 lacks bus
and class support for being resumed.
Nov 20 11:18:57 birke [  391.056659] tda1004x: found firmware revision 29 --
ok
Nov 20 11:18:57 birke [  391.144700] tda827x_probe_version: could not read
from tuner at addr: 0xc0
Nov 20 11:19:19 birke [  191.953115] saa7134 ALSA driver for DMA sound
loaded
Nov 20 11:19:19 birke [  191.953269] saa7133[0]/alsa: saa7133[0] at
0xb4007800 irq 18 registered as card -1
Nov 20 11:19:19 birke NetworkManager: <debug> [1195557559.314474]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/pci_1131_7133_alsa_capture_0').
Nov 20 11:19:19 birke NetworkManager: <debug> [1195557559.331121]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/pci_1131_7133_oss_pcm_0').
Nov 20 11:19:19 birke NetworkManager: <debug> [1195557559.339036]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/pci_1131_7133_oss_pcm_0_0').
Nov 20 11:19:19 birke NetworkManager: <debug> [1195557559.340276]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/pci_1131_7133_alsa_control__1').
Nov 20 11:19:19 birke NetworkManager: <debug> [1195557559.341315]
nm_hal_device_added(): New device added (hal udi is
'/org/freedesktop/Hal/devices/pci_1131_7133_oss_mixer__1').


----------------------------------------------------------------------------
-----

as user:

/usr/bin/mplayer -vo gl -v -tv
driver=3Dv4l2:device=3D/dev/video0:chanlist=3Deurope-west:alsa:adevice=3Dhw=
.1,0:amod
e=3D1:audiorate=3D32000:forceaudio:volume=3D100:immediatemode=3D0:norm=3DPA=
L tv://36
MPlayer dev-SVN-rUNKNOWN-4.1.2 (C) 2000-2007 MPlayer Team
CPU: Intel(R) Pentium(R) M processor 1.73GHz (Family: 6, Model: 13,
Stepping: 8)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
Compiled with runtime CPU detection.
get_path('codecs.conf') -> '/home/sabayonuser/.mplayer/codecs.conf'
Reading /home/sabayonuser/.mplayer/codecs.conf: Can't open
'/home/sabayonuser/.mplayer/codecs.conf': No such file or directory
Reading /etc/mplayer/codecs.conf: Can't open '/etc/mplayer/codecs.conf': No
such file or directory
Using built-in default codecs.conf.
Configuration: --cc=3Di586-pc-linux-gnu-gcc --host-cc=3Di586-pc-linux-gnu-g=
cc --
prefix=3D/usr --confdir=3D/etc/mplayer --datadir=3D/usr/share/mplayer --lib=
dir=3D/us
r/lib --enable-largefiles --enable-menu --enable-network --disable-tv-bsdbt8
48 --disable-faad-external --disable-libcdio --enable-bl --disable-enca --di
sable-ass --charset=3DUTF-8 --enable-joystick --enable-radio --enable-radio=
-ca
pture --disable-pvr --disable-xanim --realcodecsdir=3D/opt/RealPlayer/codec=
s -
-disable-directfb --disable-ivtv --disable-ggi --disable-fbdev --enable-gui =

--enable-xvmc --with-xvmclib=3DXvMCW --enable-tdfxvid --disable-tdfxfb --di=
sab
le-nas --enable-runtime-cpudetection --disable-altivec
CommandLine: '-vo' 'gl' '-v' '-tv'
'driver=3Dv4l2:device=3D/dev/video0:chanlist=3Deurope-west:alsa:adevice=3Dh=
w.1,0:amo
de=3D1:audiorate=3D32000:forceaudio:volume=3D100:immediatemode=3D0:norm=3DP=
AL'
'tv://36'
init_freetype
Using MMX (with tiny bit MMX2) Optimized OnScreenDisplay
Using nanosleep() timing
get_path('input.conf') -> '/home/sabayonuser/.mplayer/input.conf'
Can't open input config file /home/sabayonuser/.mplayer/input.conf: No such
file or directory
Can't open input config file /etc/mplayer/input.conf: No such file or
directory
Falling back on default (hardcoded) input config
Opening joystick device /dev/input/js0
Can't open joystick device /dev/input/js0: No such file or directory
Can't init input joystick
Setting up LIRC support...
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote
control.
get_path('36.conf') -> '/home/sabayonuser/.mplayer/36.conf'

Playing tv://36.
get_path('sub/') -> '/home/sabayonuser/.mplayer/sub/'
STREAM: [tv] tv://36
STREAM: Description: TV Input
STREAM: Author: Benjamin Zores, Albeu
STREAM: Comment:
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
Selected device: LifeView FlyDVB-T DUO / MSI TV@
 Tuner cap: STEREO LANG1 LANG2
 Tuner rxs: MONO
 Capabilites:  video capture  video overlay  VBI capture device  tuner
read/write  streaming
 supported norms: 0 =3D PAL; 1 =3D PAL-BG; 2 =3D PAL-I; 3 =3D PAL-DK; 4 =3D=
 NTSC; 5 =3D
SECAM; 6 =3D SECAM-DK; 7 =3D SECAM-L; 8 =3D SECAM-Lc; 9 =3D PAL-M; 10 =3D P=
AL-Nc; 11 =3D
PAL-60;
 inputs: 0 =3D Television; 1 =3D Composite1; 2 =3D Composite2; 3 =3D S-Vide=
o;
 Current input: 0
 Format GREY   ( 8 bits, 8 bpp gray): Planar Y800
 Format RGB555 (16 bits, 15 bpp RGB, le): BGR 15-bit
 Format RGB555X (16 bits, 15 bpp RGB, be): Unknown
 Format RGB565 (16 bits, 16 bpp RGB, le): BGR 16-bit
 Format RGB565X (16 bits, 16 bpp RGB, be): Unknown
 Format BGR24  (24 bits, 24 bpp RGB, le): BGR 24-bit
 Format RGB24  (24 bits, 24 bpp RGB, be): RGB 24-bit
 Format BGR32  (32 bits, 32 bpp RGB, le): BGRA
 Format RGB32  (32 bits, 32 bpp RGB, be): RGBA
 Format YUYV   (16 bits, 4:2:2 packed, YUYV): Packed YUY2
 Format UYVY   (16 bits, 4:2:2 packed, UYVY): Packed UYVY
 Format YUV422P (16 bits, 4:2:2 planar, Y-Cb-Cr): Planar 422P
 Format YUV420 (12 bits, 4:2:0 planar, Y-Cb-Cr): Planar I420
 Format YVU420 (12 bits, 4:2:0 planar, Y-Cb-Cr): Planar YV12
 Current format: BGR24
v4l2: setting audio mode
v4l2: current audio mode is : STEREO
v4l2: set Volume: 15 [-15, 15]
v4l2: set format: YVU420
v4l2: set input: 0
Selected norm: PAL
v4l2: set norm: PAL
Selected channel list: europe-west (including 104 channels)
Requested channel: 36
Selected channel: 36 (freq: 591.250)
Current frequency: 9460 (591.250)
Current frequency: 9460 (591.250)
=3D=3D> Found video stream: 0
v4l2: get format: YVU420
v4l2: get fps: 25.000000
v4l2: get width: 640
v4l2: get height: 480
Hardware PCM card 1 'SAA7134' device 0 subdevice 0
Its setup is:
  stream       : CAPTURE
  access       : RW_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 48000
  exact rate   : 48000 (48000/1)
  msbits       : 16
  buffer_size  : 48000
  period_size  : 12000
  period_time  : 250000
  tick_time    : 1000
  tstamp_mode  : NONE
  period_step  : 1
  sleep_min    : 0
  avail_min    : 12000
  xfer_align   : 12000
  start_threshold  : 0
  stop_threshold   : 48000
  silence_threshold: 0
  silence_size : 0
  boundary     : 1572864000
v4l2: set audio samplerate: 32000
Hardware PCM card 1 'SAA7134' device 0 subdevice 0
Its setup is:
  stream       : CAPTURE
  access       : RW_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 32000
  exact rate   : 32000 (32000/1)
  msbits       : 16
  buffer_size  : 32000
  period_size  : 8000
  period_time  : 250000
  tick_time    : 1000
  tstamp_mode  : NONE
  period_step  : 1
  sleep_min    : 0
  avail_min    : 8000
  xfer_align   : 8000
  start_threshold  : 0
  stop_threshold   : 32000
  silence_threshold: 0
  silence_size : 0
  boundary     : 2097152000
v4l2: get audio format: 9
=3D=3D> Found audio stream: 0
v4l2: get audio samplerate: 32000
v4l2: get audio samplesize: 2
v4l2: get audio channels: 2
  TV audio: 2 channels, 16 bits, 32000 Hz
Audio capture - buffer 256 blocks of 32000 bytes, skew average from 16 meas.
Using a ring buffer for maximum 561 frames, 246 MB total size.
v4l2: set Brightness: 128 [0, 255]
v4l2: set Hue: 0 [-128, 127]
v4l2: set Saturation: 64 [0, 127]
v4l2: set Contrast: 68 [0, 127]
[V] filefmt:9  fourcc:0x32315659  size:640x480  fps:25.00  ftime:=3D0.0400
get_path('sub/') -> '/home/sabayonuser/.mplayer/sub/'
[gl] using extended formats. Use -vo gl:nomanyfmts if playback fails.
[gl] Using 4 as slice height (0 means image height).
X11 opening display: :0.0
vo: X11 color mask:  FFFFFF  (R:FF0000 G:FF00 B:FF)
vo: X11 running at 1440x900 with depth 24 and 32 bpp (":0.0" =3D> local
display)
[x11] Detected wm supports NetWM.
[x11] Detected wm supports FULLSCREEN state.
[x11] Detected wm supports ABOVE state.
[x11] Detected wm supports BELOW state.
[x11] Current fstype setting honours FULLSCREEN ABOVE BELOW X atoms
Disabling DPMS
DPMSDisable stat: 1
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Opening video decoder: [raw] RAW Uncompressed Video
VDec: vo config request - 640 x 480 (preferred colorspace: Planar YV12)
Trying filter chain: vo
Could not find matching colorspace - retrying with -vf scale...
Opening video filter: [scale]
SwScale params: -1 x -1 (-1=3Dno scaling)
Trying filter chain: scale vo
VDec: using Planar YV12 as output csp (no 0)
Movie-Aspect is undefined - no prescaling applied.
VO Config (640x480->640x480,flags=3D0,'MPlayer',0x32315659)
[swscaler @ 0x8895698]SwScaler: using unscaled yuv420p -> rgb32 special
converter
REQ: flags=3D0x24B7  req=3D0x0
VO: [gl] 640x480 =3D> 640x480 BGRA
VO: Description: X11 (OpenGL)
VO: Author: Arpad Gereoffy <arpi@esp-team.scene.hu>
OpenGL extensions string:
GL_ARB_color_buffer_float GL_ARB_depth_texture GL_ARB_draw_buffers
GL_ARB_fragment_program GL_ARB_fragment_program_shadow
GL_ARB_fragment_shader GL_ARB_half_float_pixel GL_ARB_imaging
GL_ARB_multisample GL_ARB_multitexture GL_ARB_occlusion_query
GL_ARB_pixel_buffer_object GL_ARB_point_parameters GL_ARB_point_sprite
GL_ARB_shadow GL_ARB_shader_objects GL_ARB_shading_language_100
GL_ARB_texture_border_clamp GL_ARB_texture_compression
GL_ARB_texture_cube_map GL_ARB_texture_env_add GL_ARB_texture_env_combine
GL_ARB_texture_env_dot3 GL_ARB_texture_float GL_ARB_texture_mirrored_repeat
GL_ARB_texture_non_power_of_two GL_ARB_texture_rectangle
GL_ARB_transpose_matrix GL_ARB_vertex_buffer_object GL_ARB_vertex_program
GL_ARB_vertex_shader GL_ARB_window_pos GL_ATI_draw_buffers
GL_ATI_texture_float GL_ATI_texture_mirror_once GL_S3_s3tc
GL_EXT_texture_env_add GL_EXT_abgr GL_EXT_bgra GL_EXT_blend_color
GL_EXT_blend_equation_separate GL_EXT_blend_func_separate
GL_EXT_blend_minmax GL_EXT_blend_subtract GL_EXT_compiled_vertex_array
GL_EXT_Cg_shader GL_EXT_depth_bounds_test GL_EXT_draw_range_elements
GL_EXT_fog_coord GL_EXT_framebuffer_blit GL_EXT_framebuffer_multisample
GL_EXT_framebuffer_object GL_EXT_gpu_program_parameters
GL_EXT_multi_draw_arrays GL_EXT_packed_depth_stencil GL_EXT_packed_pixels
GL_EXT_pixel_buffer_object GL_EXT_point_parameters GL_EXT_rescale_normal
GL_EXT_secondary_color GL_EXT_separate_specular_color GL_EXT_shadow_funcs
GL_EXT_stencil_two_side GL_EXT_stencil_wrap GL_EXT_texture3D
GL_EXT_texture_compression_s3tc GL_EXT_texture_cube_map
GL_EXT_texture_edge_clamp GL_EXT_texture_env_combine GL_EXT_texture_env_dot3
GL_EXT_texture_filter_anisotropic GL_EXT_texture_lod GL_EXT_texture_lod_bias
GL_EXT_texture_mirror_clamp GL_EXT_texture_object GL_EXT_texture_sRGB
GL_EXT_timer_query GL_EXT_vertex_array GL_IBM_rasterpos_clip
GL_IBM_texture_mirrored_repeat GL_KTX_buffer_region GL_NV_blend_square
GL_NV_copy_depth_to_color GL_NV_depth_clamp GL_NV_fence GL_NV_float_buffer
GL_NV_fog_distance GL_NV_fragment_program GL_NV_fragment_program_option
GL_NV_fragment_program2 GL_NV_framebuffer_multisample_coverage
GL_NV_half_float GL_NV_light_max_exponent GL_NV_multisample_filter_hint
GL_NV_occlusion_query GL_NV_packed_depth_stencil GL_NV_pixel_data_range
GL_NV_point_sprite GL_NV_primitive_restart GL_NV_register_combiners
GL_NV_register_combiners2 GL_NV_texgen_reflection
GL_NV_texture_compression_vtc GL_NV_texture_env_combine4
GL_NV_texture_expand_normal GL_NV_texture_rectangle GL_NV_texture_shader
GL_NV_texture_shader2 GL_NV_texture_shader3 GL_NV_vertex_array_range
GL_NV_vertex_array_range2 GL_NV_vertex_program GL_NV_vertex_program1_1
GL_NV_vertex_program2 GL_NV_vertex_program2_option GL_NV_vertex_program3
GL_NVX_conditional_render GL_SGIS_generate_mipmap GL_SGIS_texture_lod
GL_SGIX_depth_texture GL_SGIX_shadow GL_SUN_slice_accum  GLX_EXT_visual_info
GLX_EXT_visual_rating GLX_SGIX_fbconfig GLX_SGIX_pbuffer GLX_SGI_video_sync
GLX_SGI_swap_control GLX_EXT_texture_from_pixmap GLX_ARB_multisample
GLX_NV_float_buf
[gl] Creating 1024x512 texture...
[gl] Resize: 768x480
Selected video codec: [rawyv12] vfm: raw (RAW YV12)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Opening audio decoder: [pcm] Uncompressed PCM audio decoder
dec_audio: Allocating 2048 + 65536 =3D 67584 bytes for output buffer.
AUDIO: 32000 Hz, 2 ch, s16le, 1024.0 kbit/100.00% (ratio: 128000->128000)
Selected audio codec: [pcm] afm: pcm (Uncompressed PCM)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Building audio filter chain for 32000Hz/2ch/s16le -> 0Hz/0ch/??...
[libaf] Adding filter dummy
[dummy] Was reinitialized: 32000Hz/2ch/s16le
[dummy] Was reinitialized: 32000Hz/2ch/s16le
ao2: 32000 Hz  2 chans  s16le
audio_setup: using '/dev/dsp' dsp device
audio_setup: using '/dev/mixer' mixer device
audio_setup: using 'pcm' mixer device
audio_setup: sample format: s16le (requested: s16le)
audio_setup: using 2 channels (requested: 2)
audio_setup: using 32000 Hz samplerate (requested: 32000)
audio_setup: frags:   2/2  (8196 bytes/frag)  free:  16392
AO: [oss] 32000Hz 2ch s16le (2 bytes per sample)
AO: Description: OSS/ioctl audio output
AO: Author: A'rpi
Building audio filter chain for 32000Hz/2ch/s16le -> 32000Hz/2ch/s16le...
[dummy] Was reinitialized: 32000Hz/2ch/s16le
[dummy] Was reinitialized: 32000Hz/2ch/s16le
Starting playback...
v4l2: going to capture
*** [scale] Exporting mp_image_t, 640x480x12bpp YUV planar, 460800 bytes
*** [vo] Allocating mp_image_t, 640x480x32bpp BGR packed, 1228800 bytes
Unicode font: 255 glyphs.
[gl] Resize: 768x480
Unicode font: 255 glyphs..378 ct:  0.000   1/  1 ??% ??% ??,?% 1 0
[gl] Resize: 768x480V:  0.012 ct:  0.254 801/801  0% 13%  0.1% 1 0
Unicode font: 255 glyphs..002 ct:  0.253 802/802  0% 13%  0.1% 1 0
Uninit audio filters...-0.002 ct:  0.253 803/803  0% 13%  0.1% 1 0
[libaf] Removing filter dummy
Uninit audio: pcm
Uninit video: raw
v4l2: 811 frames successfully processed, 0 frames dropped.
v4l2: up to 12 video frames buffered.
Successfully enabled DPMS
vo: uninit ...

Exiting... (Quit)


Everything seems to be working fine as before upgrading, but screen stays
black now. Same with other tv viewers (kdetv, tvtime)

----------------------------------------------------------------------------
---------------------------


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
