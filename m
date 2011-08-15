Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:60439 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab1HOPaU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 11:30:20 -0400
Received: by iye16 with SMTP id 16so7682633iye.1
        for <linux-media@vger.kernel.org>; Mon, 15 Aug 2011 08:30:19 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 15 Aug 2011 11:30:19 -0400
Message-ID: <CALOpvGU204CNypf98-nUCreoZx9A6Mj4R4fueSihCByQd6MDRA@mail.gmail.com>
Subject: em28xx module (Kaiomy TVnPC U2, card=63), loaded but NO output [ioctl
 VIDIOCGFBUF: Invalid argument]
From: Zumstein Patrick <pzlingo@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

My system is running Opensuse 11.4 x64 with KDE 4.6. Plugged device
Kaiomy TVnPC U2.
Followed the instruccions to extract missing firmware xc2038, also
updated v4l-dvb tree.
Implemented em28xx-new driver. No errors on boot.

All modules seemed to be loaded correctly, card seemes to be
recognized correctly, but
I am not able to get any images/sound from TV nor sound from RADIO.

The device is recognized as card=63, /dev/video1, /dev/vbi1 and
/dev/radio0, /dev/audio1
I would like to use this card on channel 1 (Composite1) for TV

Tried with KMPlayer and VLC, but cannot get any video.
Also tried with LD_PRELOAD="/usr/lib64/libv4l/v4lcomvert.so", no success.

norm NTSC-M, Video YUYV, framerate 29,70, input: 1

System Informations:

uname -r:
2.6.37.6-0.7-desktop

lsusb:
Bus 002 Device 005: ID eb1a:2863 eMPIA Technology, Inc.

dmesg | grep em28:
[   16.023986] em28xx: New device USB 2863 Device @ 480 Mbps
(eb1a:2863, interface 0, class 0)
[   16.024358] em28xx #0: chip ID is em2860
[   16.258872] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 63 28 f0 00
65 03 6a 20 8a 0a
[   16.258883] em28xx #0: i2c eeprom 10: 00 00 24 57 4e 02 08 00 60 00
00 00 02 00 00 00
[   16.258892] em28xx #0: i2c eeprom 20: 1e 00 13 00 f0 10 01 82 82 00
00 00 5b 00 00 00
[   16.258900] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 00 00 00 00
[   16.258907] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 c4 00 00
[   16.258915] em28xx #0: i2c eeprom 50: 81 00 00 00 00 00 00 00 00 c3
00 00 00 00 00 00
[   16.258923] em28xx #0: i2c eeprom 60: 11 00 00 00 00 00 00 00 00 00
20 03 55 00 53 00
[   16.258931] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 36 00
33 00 20 00 44 00
[   16.258939] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
0a 03 31 00 32 00
[   16.258947] em28xx #0: i2c eeprom 90: 33 00 34 00 00 00 00 00 00 00
00 00 00 00 00 00
[   16.258955] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   16.258963] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   16.258970] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   16.258978] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   16.258986] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   16.258994] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   16.259017] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xc143f201
[   16.259019] em28xx #0: EEPROM info:
[   16.259020] em28xx #0:       I2S audio, 3 sample rates
[   16.259022] em28xx #0:       500mA max power
[   16.259024] em28xx #0:       Table at 0x24, strings=0x206a, 0x0a8a, 0x0000
[   16.260109] em28xx #0: Identified as Kaiomy TVnPC U2 (card=63)
[   16.987726] tuner 11-0061: chip found @ 0xc2 (em28xx #0)
[   26.399413] input: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1.1/rc/rc0/input13
[   26.399507] rc0: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1.1/rc/rc0
[   26.406261] em28xx #0: Config register raw data: 0xf0
[   26.406263] em28xx #0: I2S Audio (5 sample rates)
[   26.406265] em28xx #0: No AC97 audio processor
[   26.436058] em28xx #0: v4l2 driver version 0.1.2
[   33.581230] em28xx #0: Registered radio device as radio0
[   33.581233] em28xx #0: V4L2 video device registered as video1
[   33.581234] em28xx #0: V4L2 VBI device registered as vbi1
[   33.587096] usbcore: registered new interface driver em28xx
[   33.587098] em28xx driver loaded
[   33.607880] em28xx-audio.c: probing for em28x1 non standard usbaudio
[   33.607884] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger

xawtv -hwscan:
This is xawtv-3.95, running on Linux/x86_64 (2.6.37.6-0.7-desktop)
looking for available devices
port 86-101
    type : Xvideo, image scaler
    name : Intel(R) Textured Video

/dev/video0: OK                         [ -device /dev/video0 ]
    type : v4l2
    name : CNF7051
    flags:  capture

/dev/video1: OK                         [ -device /dev/video1 ]
    type : v4l2
    name : Kaiomy TVnPC U2
    flags:  capture tuner


HERE SEEMES TO BE A PROBLEM:

 v4l-info /dev/video1 | grep invalid:
ioctl VIDIOCGFBUF: Invalid argument


and here the list of loaded modules
lsmod:

Module                  Size  Used by
em28xx_alsa             7655  1
hdj_mod               153949  0
snd_rawmidi            26923  1 hdj_mod
rc_kaiomy               1315  0
tuner_xc2028           21545  1
tuner                  24130  1
tvp5150                17692  0
ir_lirc_codec           4843  0
lirc_dev               16018  1 ir_lirc_codec
ir_sony_decoder         2453  0
ir_jvc_decoder          2578  0
ir_rc6_decoder          3090  0
ir_rc5_decoder          2546  0
ir_nec_decoder          2738  0
em28xx                103656  1 em28xx_alsa
v4l2_common            12303  3 tuner,tvp5150,em28xx
ir_core                21236  9
rc_kaiomy,ir_lirc_codec,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder,em28xx
videobuf_vmalloc        5773  1 em28xx
videobuf_core          22220  2 em28xx,videobuf_vmalloc
tveeprom               14233  1 em28xx
tun                    18197  2
ip6t_LOG                9192  5
xt_tcpudp               3812  2
xt_pkttype              1288  3
ipt_LOG                 8721  5
xt_limit                2591  10
af_packet              23463  4
edd                     9664  0
ip6t_REJECT             4709  3
nf_conntrack_ipv6       9399  3
nf_defrag_ipv6         11699  1 nf_conntrack_ipv6
ip6table_raw            1627  1
xt_NOTRACK              1224  4
ipt_REJECT              2640  3
iptable_raw             1686  1
iptable_filter          1946  1
ip6table_mangle         2036  0
nf_conntrack_netbios_ns     1822  0
nf_conntrack_ipv4      10168  3
nf_defrag_ipv4          1737  1 nf_conntrack_ipv4
ip_tables              22270  2 iptable_raw,iptable_filter
xt_conntrack            2880  6
nf_conntrack           88175  5
nf_conntrack_ipv6,xt_NOTRACK,nf_conntrack_netbios_ns,nf_conntrack_ipv4,xt_conntrack
ip6table_filter         1855  1
ip6_tables             22656  4
ip6t_LOG,ip6table_raw,ip6table_mangle,ip6table_filter
x_tables               28281  16
ip6t_LOG,xt_tcpudp,xt_pkttype,ipt_LOG,xt_limit,ip6t_REJECT,ip6table_raw,xt_NOTRACK,ipt_REJECT,iptable_raw,iptable_filter,ip6table_mangle,ip_tables,xt_conntrack,ip6table_filter,ip6_tables
snd_pcm_oss            53391  0
snd_mixer_oss          20225  1 snd_pcm_oss
snd_seq                66675  0
snd_seq_device          7770  2 snd_rawmidi,snd_seq
cpufreq_conservative    11828  0
cpufreq_userspace       3264  0
cpufreq_powersave       1290  0
acpi_cpufreq            8367  0
mperf                   1555  1 acpi_cpufreq
fuse                   80767  5
dm_mod                 86272  0
snd_hda_codec_realtek   356587  1
sr_mod                 16781  0
snd_hda_intel          28773  2
arc4                    1601  2
ecb                     2463  2
snd_hda_codec         108050  2 snd_hda_codec_realtek,snd_hda_intel
snd_hwdep               7772  1 snd_hda_codec
uvcvideo               70281  0
videodev               81448  5 tuner,tvp5150,em28xx,v4l2_common,uvcvideo
v4l1_compat            17505  2 uvcvideo,videodev
v4l2_compat_ioctl32    10573  1 videodev
snd_pcm               104468  4
em28xx_alsa,snd_pcm_oss,snd_hda_intel,snd_hda_codec
iTCO_wdt               12266  0
cdrom                  43280  1 sr_mod
snd_timer              26774  2 snd_seq,snd_pcm
snd                    84374  19
em28xx_alsa,hdj_mod,snd_rawmidi,snd_pcm_oss,snd_mixer_oss,snd_seq,snd_seq_device,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
soundcore               8782  1 snd
i2c_i801               10920  0
sg                     33426  0
snd_page_alloc          9569  2 snd_hda_intel,snd_pcm
joydev                 12166  0
ath5k                 156664  0
ath                    17387  1 ath5k
r8169                  43831  0
iTCO_vendor_support     3118  1 iTCO_wdt
pcspkr                  2190  0
mac80211              300859  1 ath5k
cfg80211              177329  3 ath5k,ath,mac80211
shpchp                 31135  0
pci_hotplug            32310  1 shpchp
battery                12334  0
sparse_keymap           4466  0
rfkill                 21955  1 cfg80211
ac                      4151  0
preloadtrace           86398  2
ext4                  398026  2
jbd2                   91654  1 ext4
crc16                   1747  1 ext4
i915                  461044  2
drm_kms_helper         36694  1 i915
drm                   232428  3 i915,drm_kms_helper
i2c_algo_bit            6342  1 i915
button                  6829  1 i915
video                  15929  1 i915
fan                     3215  0
processor              39669  3 acpi_cpufreq
ata_generic             3995  0
thermal                14914  0
thermal_sys            17462  4 video,fan,processor,thermal

GOOGELING I FOUND THAT THERE ARE OTHERS WITH SIMILAR PROBLEMS WITH THIS CARD.
HOW TO FIX THE ioctl VIDIOCGFBUF: Invalid argument ERROR ?
DOES ANYONE HAVE ANY IDEA OR SUGGESTION HOW THIS DEVICE COULD BE GET
WORKING PROPERLY ?

Thanks
Patrick
