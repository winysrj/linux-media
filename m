Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m89Le2o4032359
	for <video4linux-list@redhat.com>; Tue, 9 Sep 2008 17:41:11 -0400
Received: from franta.hanzlici.cz (ns.hanzlici.cz [212.158.159.56])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m89L1uO5000512
	for <video4linux-list@redhat.com>; Tue, 9 Sep 2008 17:01:56 -0400
Message-ID: <48C6E413.5010401@hanzlici.cz>
Date: Tue, 09 Sep 2008 23:01:07 +0200
From: Frantisek Hanzlik <franta@hanzlici.cz>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org, video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Kworld DVB-T 323U hybrid tuner (eb1a:e323) - no analog audio
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,
is possible audio on analog TV on Kworld VS-DVB-T 323UR hybrid tuner?
After several days of playing with, I'm without luck..

My piece of knowledge and proofs:
- Stick use these chips: Empia EM2882, TI TVP5150AM1, Xceive XC3028ACQ,
Empia EMP202, Intel WJCE6353 (I have some photos too)

- I tested v4l-dvb-085961e0b1cc and v4l-dvb-6032ecd6ad7e sources from
linuxtv.org v4l-dvb repo, on Fedora 9 x86 2.6.25.14, 2.6.26.3 and
2.6.26.3-PAE kernels.

- Tuner firmware (xc3028-v27.fw) I extracted from in "extract_xc3028.pl"
recommended http source:
www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip
as Kworld's driver has different structure, there are not hcw85bda.sys,
but some emBDA.sys, emAudio.sys and emOEM.sys files.

- Our country use PAL-DK TV norm. On WinXP with Kworlds driver and their
v3.50 HyperMedia Center apps all incl. audio works fine. On Linux I tried
tvtime-1.0.2 and xawtv-3.95 (from F9 distro), on both video is OK, but
without audio.

- /proc/bus/usb/devices part:
T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=eb1a ProdID=e323 Rev= 1.10
S:  Product=USB 2883 Device
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=   0 Ivl=125us
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=84(I) Atr=01(Isoc) MxPS=   0 Ivl=125us
I:  If#= 0 Alt= 1 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=   0 Ivl=125us
E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
E:  Ad=84(I) Atr=01(Isoc) MxPS= 564 Ivl=125us
I:  If#= 0 Alt= 2 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=1448 Ivl=125us
E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
E:  Ad=84(I) Atr=01(Isoc) MxPS= 564 Ivl=125us
I:  If#= 0 Alt= 3 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=2048 Ivl=125us
E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
E:  Ad=84(I) Atr=01(Isoc) MxPS= 564 Ivl=125us
I:  If#= 0 Alt= 4 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=2304 Ivl=125us
E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
E:  Ad=84(I) Atr=01(Isoc) MxPS= 564 Ivl=125us
I:  If#= 0 Alt= 5 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=2580 Ivl=125us
E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
E:  Ad=84(I) Atr=01(Isoc) MxPS= 564 Ivl=125us
I:  If#= 0 Alt= 6 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=2892 Ivl=125us
E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
E:  Ad=84(I) Atr=01(Isoc) MxPS= 564 Ivl=125us
I:  If#= 0 Alt= 7 #EPs= 4 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=3072 Ivl=125us
E:  Ad=83(I) Atr=01(Isoc) MxPS= 196 Ivl=1ms
E:  Ad=84(I) Atr=01(Isoc) MxPS= 564 Ivl=125us


- lsmod :
Module                  Size  Used by
em28xx_alsa            11144  0
tuner_xc2028           21424  1
tuner                  26184  0
tvp5150                19472  0
em28xx                 57640  1 em28xx_alsa
videodev               32768  2 tuner,em28xx
v4l1_compat            15876  1 videodev
compat_ioctl32          5120  1 em28xx
videobuf_vmalloc        9604  1 em28xx
videobuf_core          18052  2 em28xx,videobuf_vmalloc
ir_common              39172  1 em28xx
v4l2_common            13440  3 tuner,tvp5150,em28xx
tveeprom               14596  1 em28xx
nfsd                  191388  17
lockd                  57848  1 nfsd
nfs_acl                 6656  1 nfsd
auth_rpcgss            37256  1 nfsd
exportfs                7808  1 nfsd
autofs4                20356  2
coretemp                9472  0
w83627ehf              21000  0
hwmon_vid               6400  1 w83627ehf
hwmon                   6300  2 coretemp,w83627ehf
fuse                   47516  3
sunrpc                153876  14 nfsd,lockd,nfs_acl,auth_rpcgss
bridge                 45336  0
rfcomm                 34064  0
l2cap                  21632  3 rfcomm
bluetooth              46308  2 rfcomm,l2cap
cpufreq_ondemand       10124  1
acpi_cpufreq           11660  1
dm_mirror              20096  0
dm_log                 12036  1 dm_mirror
dm_multipath           18056  0
dm_mod                 48180  3 dm_mirror,dm_log,dm_multipath
kvm_intel              38328  0
kvm                   110656  1 kvm_intel
snd_hda_intel         321692  3
snd_intel8x0           29980  0
snd_ac97_codec         93604  1 snd_intel8x0
ac97_bus                5504  1 snd_ac97_codec
snd_seq_dummy           6532  0
snd_seq_oss            29212  0
snd_seq_midi_event      9600  1 snd_seq_oss
snd_seq                44736  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_seq_device          9740  3 snd_seq_dummy,snd_seq_oss,snd_seq
snd_pcm_oss            36480  0
snd_mixer_oss          16384  1 snd_pcm_oss
snd_pcm                60676  5 em28xx_alsa,snd_hda_intel,snd_intel8x0,snd_ac97_codec,snd_pcm_oss
snd_timer              20744  2 snd_seq,snd_pcm
sr_mod                 17064  0
snd_page_alloc         11144  3 snd_hda_intel,snd_intel8x0,snd_pcm
snd_hwdep              10244  1 snd_hda_intel
snd                    46136  18 em28xx_alsa,snd_hda_intel,snd_intel8x0,snd_ac97_codec,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer,snd_hwdep
i915                   85892  2
pcspkr                  6272  0
serio_raw               8708  0
soundcore               9288  1 snd
cdrom                  33304  1 sr_mod
pata_jmicron            6912  0
atl1                   32392  0
drm                   145508  3 i915
i2c_i801               11536  0
iTCO_wdt               13604  0
ata_generic             8452  0
sg                     30900  0
pata_acpi               7680  0
iTCO_vendor_support     6916  1 iTCO_wdt
e100                   33932  0
mii                     8192  2 atl1,e100
i2c_algo_bit            8964  1 i915
floppy                 52180  0
i2c_core               20500  10 tuner_xc2028,tuner,tvp5150,em28xx,v4l2_common,tveeprom,i915,drm,i2c_i801,i2c_algo_bit
pata_sis               13316  0
sata_sil               11016  0
ahci                   27144  7
libata                132584  6 pata_jmicron,ata_generic,pata_acpi,pata_sis,sata_sil,ahci
sd_mod                 26008  8
scsi_mod              122876  4 sr_mod,sg,libata,sd_mod
ext3                  108680  6
jbd                    40852  1 ext3
mbcache                10116  1 ext3
uhci_hcd               23056  0
ohci_hcd               22660  0
ehci_hcd               33164  0


- /etc/modprobe.conf :
alias snd-card-0 snd-intel8x0
options snd-card-0 index=0
options em28xx core_debug=1
options em28xx_alsa debug=1
options tuner_xc2028 debug=1 audio_std=A2
options tuner debug=1 show_i2c=1 pal=DK
options tvp5150 debug=1
options tveeprom debug=1

- /var/log/messages part:
Sep  9 20:49:25 q kernel: usb 2-1: new high speed USB device using ehci_hcd and address 2
Sep  9 20:49:25 q kernel: usb 2-1: configuration #1 chosen from 1 choice
Sep  9 20:49:25 q kernel: usb 2-1: New USB device found, idVendor=eb1a, idProduct=e323
Sep  9 20:49:25 q kernel: usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
Sep  9 20:49:25 q kernel: usb 2-1: Product: USB 2883 Device
Sep  9 20:49:25 q kernel: Linux video capture interface: v2.00
Sep  9 20:49:25 q kernel: em28xx v4l2 driver version 0.1.0 loaded
Sep  9 20:49:25 q kernel: em28xx new video device (eb1a:e323): interface 0, class 255
Sep  9 20:49:25 q kernel: em28xx Doesn't have usb audio class
Sep  9 20:49:25 q kernel: em28xx #0: Alternate settings: 8
Sep  9 20:49:25 q kernel: em28xx #0: Alternate setting 0, max size= 0
Sep  9 20:49:25 q kernel: em28xx #0: Alternate setting 1, max size= 0
Sep  9 20:49:25 q kernel: em28xx #0: Alternate setting 2, max size= 1448
Sep  9 20:49:25 q kernel: em28xx #0: Alternate setting 3, max size= 2048
Sep  9 20:49:25 q kernel: em28xx #0: Alternate setting 4, max size= 2304
Sep  9 20:49:25 q kernel: em28xx #0: Alternate setting 5, max size= 2580
Sep  9 20:49:25 q kernel: em28xx #0: Alternate setting 6, max size= 2892
Sep  9 20:49:25 q kernel: em28xx #0: Alternate setting 7, max size= 3072
Sep  9 20:49:25 q kernel: em28xx #0: chip ID is em2882/em2883
Sep  9 20:49:25 q kernel: em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 23 e3 d0 12 5c 00 6a 22 00 00
Sep  9 20:49:25 q kernel: em28xx #0: i2c eeprom 10: 00 00 04 57 4e 07 00 00 00 00 00 00 00 00 00 00
Sep  9 20:49:25 q kernel: em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 01 00 00 00 00 00 5b 1e 00 00
Sep  9 20:49:25 q kernel: em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 00 00 00 00 00 00
Sep  9 20:49:25 q kernel: em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Sep  9 20:49:25 q kernel: em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Sep  9 20:49:25 q kernel: em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
Sep  9 20:49:25 q kernel: em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 33 00 20 00 44 00
Sep  9 20:49:25 q kernel: em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
Sep  9 20:49:25 q kernel: em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Sep  9 20:49:25 q kernel: em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Sep  9 20:49:25 q kernel: em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Sep  9 20:49:25 q kernel: em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Sep  9 20:49:25 q kernel: em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Sep  9 20:49:25 q kernel: em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Sep  9 20:49:25 q kernel: em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Sep  9 20:49:25 q kernel: EEPROM ID= 0x9567eb1a, hash = 0x0d913542
Sep  9 20:49:25 q kernel: Vendor/Product ID= eb1a:e323
Sep  9 20:49:25 q kernel: AC97 audio (5 sample rates)
Sep  9 20:49:25 q kernel: 500mA max power
Sep  9 20:49:25 q kernel: Table at 0x04, strings=0x226a, 0x0000, 0x0000
Sep  9 20:49:25 q kernel: em28xx #0:
Sep  9 20:49:25 q kernel:
Sep  9 20:49:25 q kernel: em28xx #0: The support for this board weren't valid yet.
Sep  9 20:49:25 q kernel: em28xx #0: Please send a report of having this working
Sep  9 20:49:25 q kernel: em28xx #0: not to V4L mailing list (and/or to other addresses)
Sep  9 20:49:25 q kernel:
Sep  9 20:49:25 q kernel: tvp5150.c: starting probe for adapter SMBus I801 adapter at 0400 (0x40004)
Sep  9 20:49:25 q kernel: tvp5150.c: starting probe for adapter em28xx #0 (0x1001f)
Sep  9 20:49:25 q kernel: tvp5150.c: detecting tvp5150 client on address 0xb8
Sep  9 20:49:25 q kernel: tuner' 1-0061: I2C RECV = b2 00 4a fe b2 00 4a fe b2 00 4a fe b2 00 4a fe
Sep  9 20:49:25 q kernel: tuner' 1-0061: chip found @ 0xc2 (em28xx #0)
Sep  9 20:49:25 q kernel: xc2028 1-0061: creating new instance
Sep  9 20:49:25 q kernel: xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
Sep  9 20:49:25 q kernel: firmware: requesting xc3028-v27.fw
Sep  9 20:49:25 q kernel: xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Sep  9 20:49:25 q kernel: xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
Sep  9 20:49:26 q kernel: xc2028 1-0061: Loading firmware for type=(0), id 000000000000b700.
Sep  9 20:49:26 q kernel: xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
Sep  9 20:49:26 q kernel: tvp5150 1-005c: tvp5150am1 detected.
Sep  9 20:49:27 q kernel: em28xx #0 em28xx_set_alternate :minimum isoc packet size: 2888 (alt=6)
Sep  9 20:49:27 q kernel: em28xx #0 em28xx_set_alternate :setting alternate 6 with wMaxPacketSize=2892
Sep  9 20:49:27 q kernel: em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,71)
Sep  9 20:49:27 q kernel: em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
Sep  9 20:49:27 q kernel: em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
Sep  9 20:49:27 q kernel: em28xx #0: Found Kworld VS-DVB-T 323UR
Sep  9 20:49:27 q kernel: usbcore: registered new interface driver em28xx
Sep  9 20:49:27 q kernel: em28xx-audio.c: probing for em28x1 non standard usbaudio
Sep  9 20:49:27 q kernel: em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
Sep  9 20:49:27 q kernel: Em28xx: Initialized (Em28xx Audio Extension) extension
Sep  9 20:49:27 q kernel: tvp5150 1-005c: tvp5150am1 detected.
Sep  9 20:49:27 q kernel: em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
Sep  9 20:49:27 q kernel: em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
Sep  9 21:33:25 q kernel: em28xx #0 em28xx_set_alternate :minimum isoc packet size: 2888 (alt=6)
Sep  9 21:33:25 q kernel: em28xx #0 em28xx_set_alternate :setting alternate 6 with wMaxPacketSize=2892
Sep  9 21:33:25 q kernel: em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,71)
Sep  9 21:33:25 q kernel: em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
Sep  9 21:33:25 q kernel: tvp5150 1-005c: tvp5150am1 detected.
Sep  9 21:33:25 q kernel: em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
Sep  9 21:33:25 q kernel: em28xx #0 em28xx_set_alternate :minimum isoc packet size: 2888 (alt=6)
Sep  9 21:33:25 q kernel: em28xx #0 em28xx_set_alternate :setting alternate 6 with wMaxPacketSize=2892
Sep  9 21:33:25 q kernel: em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,71)
Sep  9 21:33:25 q kernel: em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
Sep  9 21:33:25 q kernel: tvp5150 1-005c: tvp5150am1 detected.
Sep  9 21:33:25 q kernel: em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
Sep  9 21:33:25 q kernel: em28xx #0 em28xx_set_alternate :minimum isoc packet size: 2888 (alt=6)
Sep  9 21:33:25 q kernel: em28xx #0 em28xx_set_alternate :setting alternate 6 with wMaxPacketSize=2892
Sep  9 21:33:25 q kernel: em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,71)
Sep  9 21:33:25 q kernel: em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
Sep  9 21:33:25 q kernel: tvp5150 1-005c: tvp5150am1 detected.
Sep  9 21:33:26 q kernel: em28xx #0 em28xx_set_alternate :minimum isoc packet size: 772 (alt=2)
Sep  9 21:33:26 q kernel: em28xx #0 em28xx_set_alternate :setting alternate 2 with wMaxPacketSize=1448
Sep  9 21:33:26 q kernel: em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,71)
Sep  9 21:33:26 q kernel: em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
Sep  9 21:33:26 q kernel: em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,71)
Sep  9 21:33:26 q kernel: em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
Sep  9 21:33:26 q kernel: em28xx #0 em28xx_init_isoc :em28xx: called em28xx_prepare_isoc
Sep  9 21:33:26 q kernel: em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
Sep  9 21:33:26 q kernel: em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,71)
Sep  9 21:33:26 q kernel: em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)


- under /dev directory appears new devices after tuner connect:
crw-rw----  1 root root  14,  20  9. zář 20.49 /dev/audio1
crw-rw----  1 root root  14,  19  9. zář 20.49 /dev/dsp1
crw-rw----  1 root root  14,  16  9. zář 20.49 /dev/mixer1
crw-rw----  1 root root 249,  23  9. zář 20.49 /dev/usbdev2.2_ep00
crw-rw----  1 root root 249,  19  9. zář 21.45 /dev/usbdev2.2_ep81
crw-rw----  1 root root 249,  20  9. zář 21.45 /dev/usbdev2.2_ep82
crw-rw----  1 root root 249,  21  9. zář 21.45 /dev/usbdev2.2_ep83
crw-rw----  1 root root 249,  22  9. zář 21.45 /dev/usbdev2.2_ep84
lrwxrwxrwx  1 root root        4  9. zář 20.49 /dev/vbi -> vbi0
crw-rw----+ 1 root root  81, 224  9. zář 20.49 /dev/vbi0
lrwxrwxrwx  1 root root        6  9. zář 20.49 /dev/video -> video0
crw-rw----+ 1 root root  81,   0  9. zář 20.49 /dev/video0
crw-rw---- 1 root root 116, 13  9. zář 20.49 /dev/snd/controlC1
crw-rw---- 1 root root 116, 12  9. zář 20.49 /dev/snd/pcmC1D0c

there is one strange thing for me: they appear without ACL for permitting
user access, with root:root ownership and 660 mode. But audio isn't
working neither when I change mode to 666 or log-in as root, then I think
its any udev problem, without tuner relationship.



- alsa-info listing:
!!################################
!!ALSA Information Script v 0.4.51
!!################################

!!Script ran on: Tue Sep  9 22:19:04 CEST 2008


!!Linux Distribution
!!------------------

Fedora release 9 (Sulphur) Fedora release 9 (Sulphur) Fedora release 9 (Sulphur) Fedora release 9 (Sulphur)


!!Kernel Information
!!------------------

Kernel release:    2.6.26.3-29.fc9.i686.PAE
Operating System:  GNU/Linux
Architecture:      i686
Processor:         i686
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     1.0.16
Library version:    1.0.16
Utilities version:  1.0.16


!!Loaded ALSA modules
!!-------------------

snd_hda_intel
em28xx_alsa


!!Soundcards recognised by ALSA
!!-----------------------------

  0 [Intel          ]: HDA-Intel - HDA Intel
                       HDA Intel at 0xfe5f4000 irq 22
  1 [Em28xx Audio   ]: Empia Em28xx AudEm28xx Audio - Em28xx Audio
                       Empia Em28xx Audio


!!PCI Soundcards installed in the system
!!--------------------------------------

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 02)


!!Advanced information - PCI Vendor/Device/Susbsystem ID's
!!--------------------------------------------------------

00:1b.0 0403: 8086:293e (rev 02)
	Subsystem: 1043:829f


!!Modprobe options (Sound related)
!!--------------------------------

snd-card-0: index=0


!!Loaded sound module options
!!--------------------------

!!Module: snd_hda_intel
enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
enable_msi : 0
id : 
<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>
index : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
model : 
<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>
position_fix : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
power_save : 0
power_save_controller : Y
probe_mask : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
single_cmd : N

!!Module: em28xx_alsa
debug : 1


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: Realtek ALC883
Address: 0
Vendor Id: 0x10ec0883
Subsystem Id: 0x1043829f
Revision Id: 0x100002
No Modem Function Group found
Default PCM:
     rates [0x560]: 44100 48000 96000 192000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
GPIO: io=2, o=0, i=0, unsolicited=1, wake=0
   IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0
   IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0
Node 0x02 [Audio Output] wcaps 0x11: Stereo
   Converter: stream=0, channel=0
   PCM:
     rates [0x560]: 44100 48000 96000 192000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Node 0x03 [Audio Output] wcaps 0x11: Stereo
   Converter: stream=0, channel=0
   PCM:
     rates [0x560]: 44100 48000 96000 192000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Node 0x04 [Audio Output] wcaps 0x11: Stereo
   Converter: stream=0, channel=0
   PCM:
     rates [0x560]: 44100 48000 96000 192000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Node 0x05 [Audio Output] wcaps 0x11: Stereo
   Converter: stream=0, channel=0
   PCM:
     rates [0x560]: 44100 48000 96000 192000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Node 0x06 [Audio Output] wcaps 0x211: Stereo Digital
   Converter: stream=0, channel=0
   Digital: Enabled
   Digital category: 0x1
   PCM:
     rates [0x560]: 44100 48000 96000 192000
     bits [0x1e]: 16 20 24 32
     formats [0x1]: PCM
Node 0x07 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x08 [Audio Input] wcaps 0x10011b: Stereo Amp-In
   Amp-In caps: ofs=0x08, nsteps=0x1f, stepsize=0x05, mute=1
   Amp-In vals:  [0x1f 0x1f]
   Converter: stream=0, channel=0
   SDI-Select: 0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0x6]: 16 20
     formats [0x1]: PCM
   Connection: 1
      0x23
Node 0x09 [Audio Input] wcaps 0x10011b: Stereo Amp-In
   Amp-In caps: ofs=0x08, nsteps=0x1f, stepsize=0x05, mute=1
   Amp-In vals:  [0x1f 0x1f]
   Converter: stream=0, channel=0
   SDI-Select: 0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0x6]: 16 20
     formats [0x1]: PCM
   Connection: 1
      0x22
Node 0x0a [Audio Input] wcaps 0x100391: Stereo Digital
   Converter: stream=0, channel=0
   SDI-Select: 0
   Digital:
   Digital category: 0x0
   PCM:
     rates [0x560]: 44100 48000 96000 192000
     bits [0x1e]: 16 20 24 32
     formats [0x1]: PCM
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x1f
Node 0x0b [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
   Amp-In vals:  [0x1f 0x1f] [0x1f 0x1f] [0x1f 0x1f] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
   Connection: 10
      0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x17
Node 0x0c [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x00 0x00]
   Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
   Amp-Out vals:  [0x1f 0x1f]
   Connection: 2
      0x02 0x0b
Node 0x0d [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x00 0x00]
   Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
   Amp-Out vals:  [0x00 0x00]
   Connection: 2
      0x03 0x0b
Node 0x0e [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x00 0x00]
   Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
   Amp-Out vals:  [0x00 0x1f]
   Connection: 2
      0x04 0x0b
Node 0x0f [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x00 0x00]
   Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
   Amp-Out vals:  [0x1e 0x1e]
   Connection: 2
      0x05 0x0b
Node 0x10 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x11 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x12 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x13 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x14 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x00 0x00]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x00 0x00]
   Pincap 0x083e: IN OUT HP Detect Trigger
   Pin Default 0x01014010: [Jack] Line Out at Ext Rear
     Conn = 1/8, Color = Green
     DefAssociation = 0x1, Sequence = 0x0
   Pin-ctls: 0x40: OUT
   Unsolicited: tag=00, enabled=0
   Connection: 5
      0x0c* 0x0d 0x0e 0x0f 0x26
Node 0x15 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x00 0x00]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x00 0x00]
   Pincap 0x083e: IN OUT HP Detect Trigger
   Pin Default 0x01011012: [Jack] Line Out at Ext Rear
     Conn = 1/8, Color = Black
     DefAssociation = 0x1, Sequence = 0x2
   Pin-ctls: 0x40: OUT
   Unsolicited: tag=00, enabled=0
   Connection: 5
      0x0c 0x0d* 0x0e 0x0f 0x26
Node 0x16 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x00 0x00]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x00 0x00]
   Pincap 0x083e: IN OUT HP Detect Trigger
   Pin Default 0x01016011: [Jack] Line Out at Ext Rear
     Conn = 1/8, Color = Orange
     DefAssociation = 0x1, Sequence = 0x1
   Pin-ctls: 0x40: OUT
   Unsolicited: tag=00, enabled=0
   Connection: 5
      0x0c 0x0d 0x0e* 0x0f 0x26
Node 0x17 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x00 0x00]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x00 0x00]
   Pincap 0x083e: IN OUT HP Detect Trigger
   Pin Default 0x01012014: [Jack] Line Out at Ext Rear
     Conn = 1/8, Color = Grey
     DefAssociation = 0x1, Sequence = 0x4
   Pin-ctls: 0x40: OUT
   Unsolicited: tag=00, enabled=0
   Connection: 5
      0x0c 0x0d 0x0e 0x0f* 0x26
Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x01 0x01]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x08173e: IN OUT HP Detect Trigger
     Vref caps: HIZ 50 GRD 80
   Pin Default 0x01a19840: [Jack] Mic at Ext Rear
     Conn = 1/8, Color = Pink
     DefAssociation = 0x4, Sequence = 0x0
   Pin-ctls: 0x24: IN VREF_80
   Unsolicited: tag=00, enabled=0
   Connection: 5
      0x0c* 0x0d 0x0e 0x0f 0x26
Node 0x19 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x00 0x00]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x08173e: IN OUT HP Detect Trigger
     Vref caps: HIZ 50 GRD 80
   Pin Default 0x02a19c50: [Jack] Mic at Ext Front
     Conn = 1/8, Color = Pink
     DefAssociation = 0x5, Sequence = 0x0
   Pin-ctls: 0x24: IN VREF_80
   Unsolicited: tag=00, enabled=0
   Connection: 5
      0x0c* 0x0d 0x0e 0x0f 0x26
Node 0x1a [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x00 0x00]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x08173e: IN OUT HP Detect Trigger
     Vref caps: HIZ 50 GRD 80
   Pin Default 0x0181304f: [Jack] Line In at Ext Rear
     Conn = 1/8, Color = Blue
     DefAssociation = 0x4, Sequence = 0xf
   Pin-ctls: 0x20: IN VREF_HIZ
   Unsolicited: tag=00, enabled=0
   Connection: 5
      0x0c* 0x0d 0x0e 0x0f 0x26
Node 0x1b [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x00 0x00]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x00 0x00]
   Pincap 0x08173e: IN OUT HP Detect Trigger
     Vref caps: HIZ 50 GRD 80
   Pin Default 0x02214c20: [Jack] HP Out at Ext Front
     Conn = 1/8, Color = Green
     DefAssociation = 0x2, Sequence = 0x0
   Pin-ctls: 0xc0: OUT HP VREF_HIZ
   Unsolicited: tag=04, enabled=1
   Connection: 5
      0x0c* 0x0d 0x0e 0x0f 0x26
Node 0x1c [Pin Complex] wcaps 0x400001: Stereo
   Pincap 0x0820: IN
   Pin Default 0x593301f0: [N/A] CD at Int ATAPI
     Conn = ATAPI, Color = Unknown
     DefAssociation = 0xf, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x00:
Node 0x1d [Pin Complex] wcaps 0x400000: Mono
   Pincap 0x0820: IN
   Pin Default 0x4005e601: [N/A] Line Out at Ext N/A
     Conn = Optical, Color = White
     DefAssociation = 0x0, Sequence = 0x1
   Pin-ctls: 0x00:
Node 0x1e [Pin Complex] wcaps 0x400300: Mono Digital
   Pincap 0x0810: OUT
   Pin Default 0x01441130: [Jack] SPDIF Out at Ext Rear
     Conn = RCA, Color = Black
     DefAssociation = 0x3, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x00:
   Connection: 1
      0x06
Node 0x1f [Pin Complex] wcaps 0x400200: Mono Digital
   Pincap 0x0820: IN
   Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
     Conn = 1/8, Color = Black
     DefAssociation = 0xf, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x00:
Node 0x20 [Vendor Defined Widget] wcaps 0xf00040: Mono
   Processing caps: benign=0, ncoeff=17
Node 0x21 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x22 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x00 0x00] [0x80 0x80] [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
   Amp-Out caps: N/A
   Amp-Out vals:  [0x00 0x00]
   Connection: 11
      0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x17 0x0b
Node 0x23 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x80 0x80] [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
   Amp-Out caps: N/A
   Amp-Out vals:  [0x00 0x00]
   Connection: 11
      0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x17 0x0b
Node 0x24 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x25 [Audio Output] wcaps 0x11: Stereo
   Converter: stream=0, channel=0
   PCM:
     rates [0x560]: 44100 48000 96000 192000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Node 0x26 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x00 0x00]
   Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
   Amp-Out vals:  [0x00 0x00]
   Connection: 2
      0x25 0x0b
Codec: Silicon Image SiI1392 HDMI
Address: 1
Vendor Id: 0x10951392
Subsystem Id: 0xffffffff
Revision Id: 0x100000
No Modem Function Group found
Default PCM:
     rates [0x0]:
     bits [0x0]:
     formats [0x0]:
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
GPIO: io=0, o=0, i=0, unsolicited=0, wake=0
Node 0x02 [Audio Output] wcaps 0x6211: Stereo Digital
   Converter: stream=0, channel=0
   Digital: Enabled
   Digital category: 0x0
   PCM:
     rates [0x7f0]: 32000 44100 48000 88200 96000 176400 192000
     bits [0x1e]: 16 20 24 32
     formats [0x5]: PCM AC3
Node 0x03 [Pin Complex] wcaps 0x40738d: Stereo Digital Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x00 0x00]
   Pincap 0x0894: OUT Detect R/L
   Pin Default 0x18560010: [Jack] Digital Out at Int HDMI
     Conn = Digital, Color = Unknown
     DefAssociation = 0x1, Sequence = 0x0
   Pin-ctls: 0x40: OUT
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x02
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw----+ 1 root root 116, 11  8. zář 16.44 /dev/snd/controlC0
crw-rw----  1 root root 116, 13  9. zář 20.49 /dev/snd/controlC1
crw-rw----+ 1 root root 116, 10  8. zář 16.44 /dev/snd/hwC0D0
crw-rw----+ 1 root root 116,  9  8. zář 16.44 /dev/snd/hwC0D1
crw-rw----+ 1 root root 116,  8  8. zář 16.46 /dev/snd/pcmC0D0c
crw-rw----+ 1 root root 116,  7  9. zář 22.03 /dev/snd/pcmC0D0p
crw-rw----+ 1 root root 116,  6  8. zář 16.44 /dev/snd/pcmC0D1p
crw-rw----+ 1 root root 116,  5  8. zář 16.44 /dev/snd/pcmC0D2c
crw-rw----+ 1 root root 116,  4  8. zář 16.44 /dev/snd/pcmC0D3p
crw-rw----  1 root root 116, 12  9. zář 20.49 /dev/snd/pcmC1D0c
crw-rw----+ 1 root root 116,  3  8. zář 16.44 /dev/snd/seq
crw-rw----+ 1 root root 116,  2  8. zář 16.44 /dev/snd/timer


!!ALSA configuration files
!!------------------------

!!System wide config file (/etc/asound.conf)

#Generated by system-config-soundcard
#If you edit this file, don't run system-config-soundcard,
#all your changes here could be lost.
#SWCONF
#DEV 0
defaults.pcm.card 0
defaults.pcm.device 0
defaults.ctl.card 0


!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC883 Analog [ALC883 Analog]
   Subdevices: 1/1
   Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 1: ALC883 Digital [ALC883 Digital]
   Subdevices: 1/1
   Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 3: ATI HDMI [ATI HDMI]
   Subdevices: 1/1
   Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC883 Analog [ALC883 Analog]
   Subdevices: 1/1
   Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 2: ALC883 Analog [ALC883 Analog]
   Subdevices: 1/1
   Subdevice #0: subdevice #0
card 1: Em28xx Audio [Em28xx Audio], device 0: Em28xx Audio [Empia 28xx Capture]
   Subdevices: 1/1
   Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [Intel]

Card hw:0 'Intel'/'HDA Intel at 0xfe5f4000 irq 22'
   Mixer name	: 'Silicon Image SiI1392 HDMI'
   Components	: 'HDA:10ec0883 HDA:10951392'
   Controls      : 37
   Simple ctrls  : 20
Simple mixer control 'Master',0
   Capabilities: pvolume pvolume-joined pswitch pswitch-joined
   Playback channels: Mono
   Limits: Playback 0 - 31
   Mono: Playback 31 [100%] [0.00dB] [on]
Simple mixer control 'Headphone',0
   Capabilities: pswitch
   Playback channels: Front Left - Front Right
   Mono:
   Front Left: Playback [on]
   Front Right: Playback [on]
Simple mixer control 'PCM',0
   Capabilities: pvolume
   Playback channels: Front Left - Front Right
   Limits: Playback 0 - 255
   Mono:
   Front Left: Playback 255 [100%] [0.00dB]
   Front Right: Playback 255 [100%] [0.00dB]
Simple mixer control 'Front',0
   Capabilities: pvolume pswitch
   Playback channels: Front Left - Front Right
   Limits: Playback 0 - 31
   Mono:
   Front Left: Playback 31 [100%] [0.00dB] [on]
   Front Right: Playback 31 [100%] [0.00dB] [on]
Simple mixer control 'Front Mic',0
   Capabilities: pvolume pswitch
   Playback channels: Front Left - Front Right
   Limits: Playback 0 - 31
   Mono:
   Front Left: Playback 31 [100%] [12.00dB] [on]
   Front Right: Playback 31 [100%] [12.00dB] [on]
Simple mixer control 'Front Mic Boost',0
   Capabilities: volume
   Playback channels: Front Left - Front Right
   Capture channels: Front Left - Front Right
   Limits: 0 - 3
   Front Left: 0 [0%]
   Front Right: 0 [0%]
Simple mixer control 'Surround',0
   Capabilities: pvolume pswitch
   Playback channels: Front Left - Front Right
   Limits: Playback 0 - 31
   Mono:
   Front Left: Playback 0 [0%] [-46.50dB] [on]
   Front Right: Playback 0 [0%] [-46.50dB] [on]
Simple mixer control 'Center',0
   Capabilities: pvolume pvolume-joined pswitch pswitch-joined
   Playback channels: Mono
   Limits: Playback 0 - 31
   Mono: Playback 0 [0%] [-46.50dB] [on]
Simple mixer control 'LFE',0
   Capabilities: pvolume pvolume-joined pswitch pswitch-joined
   Playback channels: Mono
   Limits: Playback 0 - 31
   Mono: Playback 31 [100%] [0.00dB] [on]
Simple mixer control 'Side',0
   Capabilities: pvolume pswitch
   Playback channels: Front Left - Front Right
   Limits: Playback 0 - 31
   Mono:
   Front Left: Playback 30 [97%] [-1.50dB] [on]
   Front Right: Playback 30 [97%] [-1.50dB] [on]
Simple mixer control 'Line',0
   Capabilities: pvolume pswitch
   Playback channels: Front Left - Front Right
   Limits: Playback 0 - 31
   Mono:
   Front Left: Playback 31 [100%] [12.00dB] [on]
   Front Right: Playback 31 [100%] [12.00dB] [on]
Simple mixer control 'Mic',0
   Capabilities: pvolume pswitch
   Playback channels: Front Left - Front Right
   Limits: Playback 0 - 31
   Mono:
   Front Left: Playback 31 [100%] [12.00dB] [on]
   Front Right: Playback 31 [100%] [12.00dB] [on]
Simple mixer control 'Mic Boost',0
   Capabilities: volume
   Playback channels: Front Left - Front Right
   Capture channels: Front Left - Front Right
   Limits: 0 - 3
   Front Left: 1 [33%]
   Front Right: 1 [33%]
Simple mixer control 'IEC958',0
   Capabilities: pswitch pswitch-joined
   Playback channels: Mono
   Mono: Playback [on]
Simple mixer control 'IEC958 Default PCM',0
   Capabilities: pswitch pswitch-joined
   Playback channels: Mono
   Mono: Playback [on]
Simple mixer control 'IEC958',1
   Capabilities: pswitch pswitch-joined
   Playback channels: Mono
   Mono: Playback [on]
Simple mixer control 'Capture',0
   Capabilities: cvolume cswitch
   Capture channels: Front Left - Front Right
   Limits: Capture 0 - 31
   Front Left: Capture 31 [100%] [34.50dB] [on]
   Front Right: Capture 31 [100%] [34.50dB] [on]
Simple mixer control 'Capture',1
   Capabilities: cvolume cswitch
   Capture channels: Front Left - Front Right
   Limits: Capture 0 - 31
   Front Left: Capture 31 [100%] [34.50dB] [on]
   Front Right: Capture 31 [100%] [34.50dB] [on]
Simple mixer control 'Input Source',0
   Capabilities: cenum
   Items: 'Mic' 'Front Mic' 'Line'
   Item0: 'Mic'
Simple mixer control 'Input Source',1
   Capabilities: cenum
   Items: 'Mic' 'Front Mic' 'Line'
   Item0: 'Line'

!!-------Mixer controls for card 1 [Em28xx]

Card hw:1 'Em28xx Audio'/'Empia Em28xx Audio'
   Mixer name	: ''
   Components	: ''
   Controls      : 0
   Simple ctrls  : 0


!!Alsactl output
!!-------------

--startcollapse--
state.Intel {
	control.1 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -4650
		comment.dbmax 0
		iface MIXER
		name 'Front Playback Volume'
		value.0 31
		value.1 31
	}
	control.2 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Front Playback Switch'
		value.0 true
		value.1 true
	}
	control.3 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -4650
		comment.dbmax 0
		iface MIXER
		name 'Surround Playback Volume'
		value.0 0
		value.1 0
	}
	control.4 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Surround Playback Switch'
		value.0 true
		value.1 true
	}
	control.5 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 31'
		comment.dbmin -4650
		comment.dbmax 0
		iface MIXER
		name 'Center Playback Volume'
		value 0
	}
	control.6 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 31'
		comment.dbmin -4650
		comment.dbmax 0
		iface MIXER
		name 'LFE Playback Volume'
		value 31
	}
	control.7 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Center Playback Switch'
		value true
	}
	control.8 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'LFE Playback Switch'
		value true
	}
	control.9 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -4650
		comment.dbmax 0
		iface MIXER
		name 'Side Playback Volume'
		value.0 30
		value.1 30
	}
	control.10 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Side Playback Switch'
		value.0 true
		value.1 true
	}
	control.11 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Headphone Playback Switch'
		value.0 true
		value.1 true
	}
	control.12 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Mic Playback Volume'
		value.0 31
		value.1 31
	}
	control.13 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Mic Playback Switch'
		value.0 true
		value.1 true
	}
	control.14 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Front Mic Playback Volume'
		value.0 31
		value.1 31
	}
	control.15 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Front Mic Playback Switch'
		value.0 true
		value.1 true
	}
	control.16 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Line Playback Volume'
		value.0 31
		value.1 31
	}
	control.17 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Line Playback Switch'
		value.0 true
		value.1 true
	}
	control.18 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Mic Boost'
		value.0 1
		value.1 1
	}
	control.19 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Front Mic Boost'
		value.0 0
		value.1 0
	}
	control.20 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -1200
		comment.dbmax 3450
		iface MIXER
		name 'Capture Volume'
		value.0 31
		value.1 31
	}
	control.21 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		value.0 true
		value.1 true
	}
	control.22 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -1200
		comment.dbmax 3450
		iface MIXER
		name 'Capture Volume'
		index 1
		value.0 31
		value.1 31
	}
	control.23 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		index 1
		value.0 true
		value.1 true
	}
	control.24 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Mic
		comment.item.1 'Front Mic'
		comment.item.2 Line
		iface MIXER
		name 'Input Source'
		value Mic
	}
	control.25 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Mic
		comment.item.1 'Front Mic'
		comment.item.2 Line
		iface MIXER
		name 'Input Source'
		index 1
		value Line
	}
	control.26 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Con Mask'
		value 
'0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.27 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Pro Mask'
		value 
'0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.28 {
		comment.access 'read write'
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Default'
		value 
'0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.29 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Switch'
		value true
	}
	control.30 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 Default PCM Playback Switch'
		value true
	}
	control.31 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 31'
		comment.dbmin -4650
		comment.dbmax 0
		iface MIXER
		name 'Master Playback Volume'
		value 31
	}
	control.32 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Master Playback Switch'
		value true
	}
	control.33 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Con Mask'
		index 1
		value 
'0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.34 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Pro Mask'
		index 1
		value 
'0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.35 {
		comment.access 'read write'
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Default'
		index 1
		value 
'0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.36 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Switch'
		index 1
		value true
	}
	control.37 {
		comment.access 'read write user'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 255'
		comment.tlv '0000000100000008ffffec1400000014'
		comment.dbmin -5100
		comment.dbmax 0
		iface MIXER
		name 'PCM Playback Volume'
		value.0 255
		value.1 255
	}
}
state.'Em28xx Audio' {
	control {
	}
}
--endcollapse--



- in Gnome volume control applet is only Intel HDA device (well, once I
had there em28xx audiodevice, but I cannot tell what witcheries got it
there... And can't repeat this :)

Got someone this device working? I have some usbsnoop.log from Benoit's
Windos USB sniffer too, but it's 480MB big and beyond my understanding...

Thanks, Franta Hanzlik

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
