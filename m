Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.orange.fr ([80.12.242.50]:16553 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbZGFVsI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jul 2009 17:48:08 -0400
Message-Id: <200907062148.n66Lm5m04279@neptune.localwarp.net>
Date: Mon, 6 Jul 2009 23:47:44 +0200 (CEST)
From: eric.paturage@orange.fr
Reply-To: eric.paturage@orange.fr
Subject: Re: regression : saa7134  with Pinnacle PCTV 50i (analog) can not
 tune anymore
To: hermann-pitton@arcor.de
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
 BOUNDARY="-1463811324-1804289383-1246916864=:4126"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---1463811324-1804289383-1246916864=:4126
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE


> 
> I did fake your card on 2.6.29 to exclude to have "improvements" on
> those cards I have, which also support DVB-T and DVB-S.
> 
> What was learned previously is, that a missing tda8290 module is
> replaced by the tda9887, if present. No errors will show up and one even
> gets some very decent type of picture ...
> 
> Without tda9887, one gets the "tuning failed" like you had it initially.
> 
> Why you still have it, now without any unresolved symbols, I don't know
> yet. I doubt, that it could be caused by that you have tuner stuff
> compiled into the kernel. (tda8290 module is loadable and no unresolved
> symbols ?)
> 
> A successful tuning attempt faking your card, no auto detection of
> course, does still look like that here.
> (debug=1 for tuner, tda8290, tda827x and saa7134 i2c_debug)
> 
> tuner 3-004b: tv freq set to 196.25
> tda829x 3-004b: setting tda829x to system B
> saa7133[2]: i2c xfer: < 96 01 02 >
> saa7133[2]: i2c xfer: < 96 02 00 >
> saa7133[2]: i2c xfer: < 96 00 00 >
> saa7133[2]: i2c xfer: < 96 01 82 >
> saa7133[2]: i2c xfer: < 96 28 14 >
> saa7133[2]: i2c xfer: < 96 0f 88 >
> saa7133[2]: i2c xfer: < 96 05 04 >
> saa7133[2]: i2c xfer: < 96 0d 47 >
> saa7133[2]: i2c xfer: < 96 21 c0 >
> tda827x: setting tda827x to system B
> saa7133[2]: i2c xfer: < c0 00 32 c0 00 16 5a bb 1c 04 20 00 >
> saa7133[2]: i2c xfer: < c0 90 ff e0 00 99 >
> saa7133[2]: i2c xfer: < c0 a0 c0 >
> saa7133[2]: i2c xfer: < c0 30 10 >
> saa7133[2]: i2c xfer: < c1 =09 =32 >
> tda827x: AGC2 gain is: 3
> saa7133[2]: i2c xfer: < c0 60 3c >
> saa7133[2]: i2c xfer: < c0 50 bf >
> saa7133[2]: i2c xfer: < c0 80 28 >
> saa7133[2]: i2c xfer: < c0 b0 01 >
> saa7133[2]: i2c xfer: < c0 c0 19 >
> saa7133[2]: i2c xfer: < 96 1b >
> saa7133[2]: i2c xfer: < 97 =ff >
> saa7133[2]: i2c xfer: < 96 1a >
> saa7133[2]: i2c xfer: < 97 =00 >
> saa7133[2]: i2c xfer: < 96 1d >
> saa7133[2]: i2c xfer: < 97 =ff >
> tda829x 3-004b: tda8290 is locked, AGC: 255
> tda829x 3-004b: adjust gain, step 1. Agc: 255, ADC stat: 0, lock: 128
> saa7133[2]: i2c xfer: < 96 28 64 >
> saa7133[2]: i2c xfer: < 96 1d >
> saa7133[2]: i2c xfer: < 97 =6d >
> saa7133[2]: i2c xfer: < 96 1b >
> saa7133[2]: i2c xfer: < 97 =ff >
> saa7133[2]: i2c xfer: < 96 21 00 >
> saa7133[2]: i2c xfer: < 96 0f 81 >
> 
> I have no picture, because of the rare/strange vmux = 4 for TV on your card,
> but it all looks fine.
> 
> Ideas are welcome, and Eric, maybe provide more details for debugging on
> what you currently have. Related "dmesg", kernel .config, "lsmod".
> 
> Cheers,
> Hermann
> 

Hi Hermann 


i put the following debug in modprobe.conf :
options saa7134 pinnacle_remote=1
options saa7134 secam=L   
options saa7134 irq_debug=1 gpio_tracking=1 core_debug=1 i2c_debug=1 ts_debug=1 
video_debug=1 
options tuner secam=l debug=1 show_i2c=1
options  tda8290 debug=1
options  tda827x debug=1

i attach /var/log/messages (when doing modprobe saa7134 ) 
dmesg (when loading saa7134)   
dmesg (when using xawtv and attempting to tune ) 
.config from kernel 

there seems to be some i2c  errors when loading saa7134  (??)
tda8290  does not get automaticaly loaded , 

if it is loaded manually once (and unloaded) 
errors about missing symbols disappear .


result with applications are :
xawtv : no picture (black) , no tuning (apparently )
xdtv : hangs badly (cannot be killed by kill -9 )  no picture (black) , 
svv : no picture (black) .
all the pictures i get are black ( no snow , as in between channels ) 

(all those apps work nicely with the vanilla kernel )

Regards 





---1463811324-1804289383-1246916864=:4126
Content-Type: TEXT/PLAIN; NAME="lsmod.out"
Content-Disposition: ATTACHMENT; FILENAME="lsmod.out"

Module                  Size  Used by
saa7134_alsa           10624  0 
tuner                  21576  0 
saa7134               150288  1 saa7134_alsa
ds1621                  6324  0 
w83781d                27312  0 
hwmon_vid               2788  1 w83781d
hwmon                   2040  2 ds1621,w83781d
binfmt_misc             8172  1 
nfsd                  235596  8 
exportfs                4068  1 nfsd
ipv6                  235316  14 
nfs                   249960  1 
lockd                  68104  2 nfsd,nfs
auth_rpcgss            35456  2 nfsd,nfs
sunrpc                172508  12 nfsd,nfs,lockd,auth_rpcgss
snd_seq_dummy           2632  0 
snd_seq_oss            27616  0 
snd_seq_midi_event      6180  1 snd_seq_oss
snd_seq                45488  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_pcm_oss            37792  0 
snd_mixer_oss          16260  1 snd_pcm_oss
ppp_async               8548  0 
ppp_generic            23444  1 ppp_async
slhc                    6052  1 ppp_generic
crc_ccitt               1668  1 ppp_async
af_packet              17156  0 
ip_vs                  98912  0 
sr_mod                 15844  0 
sg                     28628  0 
st                     35904  0 
tmscsim                20672  0 
scsi_mod              138164  4 sr_mod,sg,st,tmscsim
loop                   15152  0 
analog                 10368  0 
nvidia               4703604  22 
usblp                  11940  0 
button                  5300  0 
battery                10120  0 
ac                      4072  0 
gspca_sonixb           10180  0 
gspca_main             21668  1 gspca_sonixb
ir_kbd_i2c              6420  0 
snd_cmipci             31584  0 
gameport               10316  3 analog,snd_cmipci
snd_pcm                66572  3 saa7134_alsa,snd_pcm_oss,snd_cmipci
snd_page_alloc          8396  1 snd_pcm
ir_common              42408  2 saa7134,ir_kbd_i2c
snd_opl3_lib            9220  1 snd_cmipci
v4l2_common            14756  2 tuner,saa7134
snd_timer              19624  3 snd_seq,snd_pcm,snd_opl3_lib
ide_cd_mod             27752  0 
cdrom                  34560  2 sr_mod,ide_cd_mod
videodev               35968  4 tuner,saa7134,gspca_main,v4l2_common
v4l1_compat            14056  1 videodev
snd_hwdep               7272  1 snd_opl3_lib
snd_mpu401_uart         6628  1 snd_cmipci
parport_serial          6212  0 
videobuf_dma_sg        10504  2 saa7134_alsa,saa7134
videobuf_core          14696  2 saa7134,videobuf_dma_sg
snd_rawmidi            20416  1 snd_mpu401_uart
uhci_hcd               22868  0 
ne2k_pci                8672  0 
usbcore               137232  5 usblp,gspca_sonixb,gspca_main,uhci_hcd
tveeprom               11496  1 saa7134
snd_seq_device          6320  5 snd_seq_dummy,snd_seq_oss,snd_seq,snd_opl3_lib,snd_rawmidi
8390                    8964  1 ne2k_pci
snd                    49668  13 saa7134_alsa,snd_seq_oss,snd_seq,snd_pcm_oss,snd_mixer_oss,snd_cmipci,snd_pcm,snd_opl3_lib,snd_timer,snd_hwdep,snd_mpu401_uart,snd_rawmidi,snd_seq_device
shpchp                 32632  0 
i2c_viapro              7384  0 
via_agp                 8036  1 
parport_pc             31652  1 parport_serial
i2c_core               20564  10 tuner,saa7134,ds1621,w83781d,nvidia,ir_kbd_i2c,v4l2_common,videodev,tveeprom,i2c_viapro
parport                31432  1 parport_pc
agpgart                30580  2 nvidia,via_agp
pci_hotplug            26820  1 shpchp
soundcore               5824  1 snd
evdev                   9440  1 
ext3                  123436  10 
jbd                    36536  1 ext3

---1463811324-1804289383-1246916864=:4126
Content-Type: TEXT/PLAIN; NAME="dmesg.xawtv_tune"
Content-Disposition: ATTACHMENT; FILENAME="dmesg.xawtv_tune"

Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOCSPICT
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FBUF
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FBUF
saa7133[0]: gpio: mode=0x0200000 in=0x200c000 out=0x0000000 [Television]
saa7133[0] video (Pinnacle PCTV: VIDIOCGPICT
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOCSPICT
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FBUF
saa7133[0]: gpio: mode=0x0200000 in=0x200e000 out=0x0000000 [Television]
saa7133[0] video (Pinnacle PCTV: VIDIOCGPICT
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOCSPICT
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FBUF
saa7133[0]: gpio: mode=0x0200000 in=0x200e000 out=0x0000000 [Television]
saa7133[0] video (Pinnacle PCTV: VIDIOCGPICT
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOCSPICT
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FBUF
saa7133[0]: gpio: mode=0x0200000 in=0x200c000 out=0x0000000 [Television]
saa7133[0] video (Pinnacle PCTV: VIDIOCSFREQ
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FREQUENCY
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FREQUENCY
saa7133[0]: gpio: mode=0x0200000 in=0x200e000 out=0x0000000 [Television]
saa7133[0] video (Pinnacle PCTV: VIDIOCSFBUF
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FBUF
saa7133[0] video (Pinnacle PCTV: VIDIOCGPICT
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOCSPICT
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FBUF
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FBUF
saa7133[0] video (Pinnacle PCTV: VIDIOCSWIN
saa7133[0] video (Pinnacle PCTV: VIDIOC_STREAMOFF
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOCCAPTURE
saa7133[0] video (Pinnacle PCTV: VIDIOC_OVERLAY
saa7133[0]/core: dmabits: task=0x10 ctrl=0x02 irq=0x0 split=no
saa7133[0] video (Pinnacle PCTV: VIDIOCGAUDIO
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_AUDIO
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_TUNER
saa7133[0] video (Pinnacle PCTV: VIDIOCSAUDIO
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_AUDIO
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0]: gpio: mode=0x0200000 in=0x200e000 out=0x0000000 [Television]
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_TUNER
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_TUNER
saa7133[0]: i2c xfer: < 8f =70 =f9 =9c =e1 >
saa7133[0]: i2c xfer: < 8f =f9 =9c =e1 =70 >
saa7133[0]: i2c xfer: < 8f =9c =e1 =70 =f9 >
saa7133[0]: i2c xfer: < 8f =e1 =70 =f9 =9c >
saa7133[0]: i2c xfer: < 8f =70 =f9 =9c =e1 >
saa7133[0]: i2c xfer: < 8f =f9 =9c =e1 =70 >
saa7133[0]: i2c xfer: < 8f =9c =e1 =70 =f9 >
saa7133[0]: i2c xfer: < 8f =e1 =70 =f9 =9c >
saa7133[0]: i2c xfer: < 8f =70 =f9 =9c =e1 >
saa7133[0]: i2c xfer: < 8f =f9 =9c =e1 =70 >
saa7133[0]: i2c xfer: < 8f =9c =e1 =70 =f9 >
saa7133[0] video (Pinnacle PCTV: VIDIOCSFBUF
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FBUF
saa7133[0] video (Pinnacle PCTV: VIDIOCGPICT
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOCSPICT
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FBUF
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FBUF
saa7133[0] video (Pinnacle PCTV: VIDIOCSWIN
saa7133[0] video (Pinnacle PCTV: VIDIOC_STREAMOFF
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FMT
saa7133[0]/core: dmabits: task=0x00 ctrl=0x00 irq=0x0 split=yes
saa7133[0]/core: dmabits: task=0x10 ctrl=0x02 irq=0x0 split=no
saa7133[0] video (Pinnacle PCTV: VIDIOCCAPTURE
saa7133[0] video (Pinnacle PCTV: VIDIOC_OVERLAY
saa7133[0]/core: dmabits: task=0x10 ctrl=0x02 irq=0x0 split=no
saa7133[0]: i2c xfer: < 8f =e1 =70 =f9 =9c >
saa7133[0]: i2c xfer: < 8f =70 =f9 =9c =e1 >
saa7133[0] video (Pinnacle PCTV: VIDIOCSFBUF
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FBUF
saa7133[0] video (Pinnacle PCTV: VIDIOCGPICT
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOCSPICT
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FBUF
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FBUF
saa7133[0] video (Pinnacle PCTV: VIDIOCSWIN
saa7133[0] video (Pinnacle PCTV: VIDIOC_STREAMOFF
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FMT
saa7133[0]/core: dmabits: task=0x00 ctrl=0x00 irq=0x0 split=yes
saa7133[0]/core: dmabits: task=0x10 ctrl=0x02 irq=0x0 split=no
saa7133[0] video (Pinnacle PCTV: VIDIOCCAPTURE
saa7133[0] video (Pinnacle PCTV: VIDIOC_OVERLAY
saa7133[0]/core: dmabits: task=0x10 ctrl=0x02 irq=0x0 split=no
saa7133[0] video (Pinnacle PCTV: VIDIOCSFBUF
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FBUF
saa7133[0] video (Pinnacle PCTV: VIDIOCGPICT
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOCSPICT
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FBUF
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FBUF
saa7133[0] video (Pinnacle PCTV: VIDIOCSWIN
saa7133[0] video (Pinnacle PCTV: VIDIOC_STREAMOFF
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FMT
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_FMT
saa7133[0]/core: dmabits: task=0x00 ctrl=0x00 irq=0x0 split=yes
saa7133[0]/core: dmabits: task=0x10 ctrl=0x02 irq=0x0 split=no
saa7133[0] video (Pinnacle PCTV: VIDIOCCAPTURE
saa7133[0] video (Pinnacle PCTV: VIDIOC_OVERLAY
saa7133[0]/core: dmabits: task=0x10 ctrl=0x02 irq=0x0 split=no
saa7133[0] video (Pinnacle PCTV: VIDIOCGAUDIO
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_AUDIO
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_TUNER
saa7133[0] video (Pinnacle PCTV: VIDIOCSAUDIO
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_AUDIO
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_QUERYCTRL
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_CTRL
saa7133[0]: gpio: mode=0x0200000 in=0x200e000 out=0x0000000 [Television]
saa7133[0] video (Pinnacle PCTV: VIDIOC_G_TUNER
saa7133[0] video (Pinnacle PCTV: VIDIOC_S_TUNER
saa7133[0] video (Pinnacle PCTV: VIDIOCCAPTURE
saa7133[0] video (Pinnacle PCTV: VIDIOC_STREAMOFF
saa7133[0] video (Pinnacle PCTV: VIDIOC_OVERLAY
saa7133[0]/core: dmabits: task=0x00 ctrl=0x00 irq=0x0 split=yes
saa7133[0]: i2c xfer: < 8f =f9 =9c =e1 =70 >
saa7133[0]: i2c xfer: < 8f =9c =e1 =70 =f9 >
saa7133[0]: i2c xfer: < 8f =e1 =70 =f9 =9c >
saa7133[0]: i2c xfer: < 8f =70 =f9 =9c =e1 >
saa7133[0]: i2c xfer: < 8f =f9 =9c =e1 =70 >
saa7133[0]: i2c xfer: < 8f =9c =e1 =70 =f9 >
saa7133[0]: i2c xfer: < 8f =e1 =70 =f9 =9c >
saa7133[0]: i2c xfer: < 8f =70 =f9 =9c =e1 >
saa7133[0]: i2c xfer: < 8f =f9 =9c =e1 =70 >
saa7133[0]: i2c xfer: < 8f =9c =e1 =70 =f9 >
saa7133[0]: i2c xfer: < 8f =e1 =70 =f9 =9c >
saa7133[0]: i2c xfer: < 8f =70 =f9 =9c =e1 >
saa7133[0]: i2c xfer: < 8f =f9 =9c =e1 =70 >
saa7133[0]: i2c xfer: < 8f =9c =e1 =70 =f9 >

---1463811324-1804289383-1246916864=:4126
Content-Type: TEXT/PLAIN; NAME="dmesg.modprobe_saa7134"
Content-Transfer-Encoding: BASE64
Content-Disposition: ATTACHMENT; FILENAME="dmesg.modprobe_saa7134"

MzNbMF06IGkyYyB4ZmVyOiA8IDhmID1lMSA9NzAgPWY5ID05YyA+DQpzYWE3
MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9NzAgPWY5ID05YyA9ZTEgPg0Kc2Fh
NzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWY5ID05YyA9ZTEgPTcwID4NCnNh
YTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID05YyA9ZTEgPTcwID1mOSA+DQpz
YWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZTEgPTcwID1mOSA9OWMgPg0K
c2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTcwID1mOSA9OWMgPWUxID4N
CnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1mOSA9OWMgPWUxID03MCA+
DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9OWMgPWUxID03MCA9Zjkg
Pg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWUxID03MCA9ZjkgPTlj
ID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID03MCA9ZjkgPTljID1l
MSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZjkgPTljID1lMSA9
NzAgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTljID1lMSA9NzAg
PWY5ID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1lMSA9NzAgPWY5
ID05YyA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9NzAgPWY5ID05
YyA9ZTEgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWY5ID05YyA9
ZTEgPTcwID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID05YyA9ZTEg
PTcwID1mOSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZTEgPTcw
ID1mOSA9OWMgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTcwID1m
OSA9OWMgPWUxID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1mOSA9
OWMgPWUxID03MCA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9OWMg
PWUxID03MCA9ZjkgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWUx
ID03MCA9ZjkgPTljID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID03
MCA9ZjkgPTljID1lMSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9
ZjkgPTljID1lMSA9NzAgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYg
PTljID1lMSA9NzAgPWY5ID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhm
ID1lMSA9NzAgPWY5ID05YyA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4
ZiA9NzAgPWY5ID05YyA9ZTEgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwg
OGYgPWY5ID05YyA9ZTEgPTcwID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8
IDhmID05YyA9ZTEgPTcwID1mOSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjog
PCA4ZiA9ZTEgPTcwID1mOSA9OWMgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6
IDwgOGYgPTcwID1mOSA9OWMgPWUxID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVy
OiA8IDhmID1mOSA9OWMgPWUxID03MCA+DQpzYWE3MTMzWzBdOiBpMmMgeGZl
cjogPCA4ZiA9OWMgPWUxID03MCA9ZjkgPg0Kc2FhNzEzM1swXTogaTJjIHhm
ZXI6IDwgOGYgPWUxID03MCA9ZjkgPTljID4NCnNhYTcxMzNbMF06IGkyYyB4
ZmVyOiA8IDhmID03MCA9ZjkgPTljID1lMSA+DQpzYWE3MTMzWzBdOiBpMmMg
eGZlcjogPCA4ZiA9ZjkgPTljID1lMSA9NzAgPg0Kc2FhNzEzM1swXTogaTJj
IHhmZXI6IDwgOGYgPTljID1lMSA9NzAgPWY5ID4NCnNhYTcxMzNbMF06IGky
YyB4ZmVyOiA8IDhmID1lMSA9NzAgPWY5ID05YyA+DQpzYWE3MTMzWzBdOiBp
MmMgeGZlcjogPCA4ZiA9NzAgPWY5ID05YyA9ZTEgPg0Kc2FhNzEzM1swXTog
aTJjIHhmZXI6IDwgOGYgPWY5ID05YyA9ZTEgPTcwID4NCnNhYTcxMzNbMF06
IGkyYyB4ZmVyOiA8IDhmID05YyA9ZTEgPTcwID1mOSA+DQpzYWE3MTMzWzBd
OiBpMmMgeGZlcjogPCA4ZiA9ZTEgPTcwID1mOSA9OWMgPg0Kc2FhNzEzM1sw
XTogaTJjIHhmZXI6IDwgOGYgPTcwID1mOSA9OWMgPWUxID4NCnNhYTcxMzNb
MF06IGkyYyB4ZmVyOiA8IDhmID1mOSA9OWMgPWUxID03MCA+DQpzYWE3MTMz
WzBdOiBpMmMgeGZlcjogPCA4ZiA9OWMgPWUxID03MCA9ZjkgPg0Kc2FhNzEz
M1swXTogaTJjIHhmZXI6IDwgOGYgPWUxID03MCA9ZjkgPTljID4NCnNhYTcx
MzNbMF06IGkyYyB4ZmVyOiA8IDhmID03MCA9ZjkgPTljID1lMSA+DQpzYWE3
MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZjkgPTljID1lMSA9NzAgPg0Kc2Fh
NzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTljID1lMSA9NzAgPWY5ID4NCnNh
YTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1lMSA9NzAgPWY5ID05YyA+DQpz
YWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9NzAgPWY5ID05YyA9ZTEgPg0K
c2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWY5ID05YyA9ZTEgPTcwID4N
CnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID05YyA9ZTEgPTcwID1mOSA+
DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZTEgPTcwID1mOSA9OWMg
Pg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTcwID1mOSA9OWMgPWUx
ID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1mOSA9OWMgPWUxID03
MCA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9OWMgPWUxID03MCA9
ZjkgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWUxID03MCA9Zjkg
PTljID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID03MCA9ZjkgPTlj
ID1lMSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZjkgPTljID1l
MSA9NzAgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTljID1lMSA9
NzAgPWY5ID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1lMSA9NzAg
PWY5ID05YyA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9NzAgPWY5
ID05YyA9ZTEgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWY5ID05
YyA9ZTEgPTcwID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID05YyA9
ZTEgPTcwID1mOSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZTEg
PTcwID1mOSA9OWMgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTcw
ID1mOSA9OWMgPWUxID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1m
OSA9OWMgPWUxID03MCA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9
OWMgPWUxID03MCA9ZjkgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYg
PWUxID03MCA9ZjkgPTljID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhm
ID03MCA9ZjkgPTljID1lMSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4
ZiA9ZjkgPTljID1lMSA9NzAgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwg
OGYgPTljID1lMSA9NzAgPWY5ID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8
IDhmID1lMSA9NzAgPWY5ID05YyA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjog
PCA4ZiA9NzAgPWY5ID05YyA9ZTEgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6
IDwgOGYgPWY5ID05YyA9ZTEgPTcwID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVy
OiA8IDhmID05YyA9ZTEgPTcwID1mOSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZl
cjogPCA4ZiA9ZTEgPTcwID1mOSA9OWMgPg0Kc2FhNzEzM1swXTogaTJjIHhm
ZXI6IDwgOGYgPTcwID1mOSA9OWMgPWUxID4NCnNhYTcxMzNbMF06IGkyYyB4
ZmVyOiA8IDhmID1mOSA9OWMgPWUxID03MCA+DQpzYWE3MTMzWzBdOiBpMmMg
eGZlcjogPCA4ZiA9OWMgPWUxID03MCA9ZjkgPg0Kc2FhNzEzM1swXTogaTJj
IHhmZXI6IDwgOGYgPWUxID03MCA9ZjkgPTljID4NCnNhYTcxMzNbMF06IGky
YyB4ZmVyOiA8IDhmID03MCA9ZjkgPTljID1lMSA+DQpzYWE3MTMzWzBdOiBp
MmMgeGZlcjogPCA4ZiA9ZjkgPTljID1lMSA9NzAgPg0Kc2FhNzEzM1swXTog
aTJjIHhmZXI6IDwgOGYgPTljID1lMSA9NzAgPWY5ID4NCnNhYTcxMzNbMF06
IGkyYyB4ZmVyOiA8IDhmID1lMSA9NzAgPWY5ID05YyA+DQpzYWE3MTMzWzBd
OiBpMmMgeGZlcjogPCA4ZiA9NzAgPWY5ID05YyA9ZTEgPg0Kc2FhNzEzM1sw
XTogaTJjIHhmZXI6IDwgOGYgPWY5ID05YyA9ZTEgPTcwID4NCnNhYTcxMzNb
MF06IGkyYyB4ZmVyOiA8IDhmID05YyA9ZTEgPTcwID1mOSA+DQpzYWE3MTMz
WzBdOiBpMmMgeGZlcjogPCA4ZiA9ZTEgPTcwID1mOSA9OWMgPg0Kc2FhNzEz
M1swXTogaTJjIHhmZXI6IDwgOGYgPTcwID1mOSA9OWMgPWUxID4NCnNhYTcx
MzNbMF06IGkyYyB4ZmVyOiA8IDhmID1mOSA9OWMgPWUxID03MCA+DQpzYWE3
MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9OWMgPWUxID03MCA9ZjkgPg0Kc2Fh
NzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWUxID03MCA9ZjkgPTljID4NCnNh
YTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID03MCA9ZjkgPTljID1lMSA+DQpz
YWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZjkgPTljID1lMSA9NzAgPg0K
c2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTljID1lMSA9NzAgPWY5ID4N
CnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1lMSA9NzAgPWY5ID05YyA+
DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9NzAgPWY5ID05YyA9ZTEg
Pg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWY5ID05YyA9ZTEgPTcw
ID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID05YyA9ZTEgPTcwID1m
OSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZTEgPTcwID1mOSA9
OWMgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTcwID1mOSA9OWMg
PWUxID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1mOSA9OWMgPWUx
ID03MCA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9OWMgPWUxID03
MCA9ZjkgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWUxID03MCA9
ZjkgPTljID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID03MCA9Zjkg
PTljID1lMSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZjkgPTlj
ID1lMSA9NzAgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTljID1l
MSA9NzAgPWY5ID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1lMSA9
NzAgPWY5ID05YyA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9NzAg
PWY5ID05YyA9ZTEgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWY5
ID05YyA9ZTEgPTcwID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID05
YyA9ZTEgPTcwID1mOSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9
ZTEgPTcwID1mOSA9OWMgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYg
PTcwID1mOSA9OWMgPWUxID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhm
ID1mOSA9OWMgPWUxID03MCA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4
ZiA9OWMgPWUxID03MCA9ZjkgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwg
OGYgPWUxID03MCA9ZjkgPTljID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8
IDhmID03MCA9ZjkgPTljID1lMSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjog
PCA4ZiA9ZjkgPTljID1lMSA9NzAgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6
IDwgOGYgPTljID1lMSA9NzAgPWY5ID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVy
OiA8IDhmID1lMSA9NzAgPWY5ID05YyA+DQpzYWE3MTMzWzBdOiBpMmMgeGZl
cjogPCA4ZiA9NzAgPWY5ID05YyA9ZTEgPg0Kc2FhNzEzM1swXTogaTJjIHhm
ZXI6IDwgOGYgPWY5ID05YyA9ZTEgPTcwID4NCnNhYTcxMzNbMF06IGkyYyB4
ZmVyOiA8IDhmID05YyA9ZTEgPTcwID1mOSA+DQpzYWE3MTMzWzBdOiBpMmMg
eGZlcjogPCA4ZiA9ZTEgPTcwID1mOSA9OWMgPg0Kc2FhNzEzM1swXTogaTJj
IHhmZXI6IDwgOGYgPTcwID1mOSA9OWMgPWUxID4NCnNhYTcxMzNbMF06IGky
YyB4ZmVyOiA8IDhmID1mOSA9OWMgPWUxID03MCA+DQpzYWE3MTMzWzBdOiBp
MmMgeGZlcjogPCA4ZiA9OWMgPWUxID03MCA9ZjkgPg0Kc2FhNzEzM1swXTog
aTJjIHhmZXI6IDwgOGYgPWUxID03MCA9ZjkgPTljID4NCnNhYTcxMzNbMF06
IGkyYyB4ZmVyOiA8IDhmID03MCA9ZjkgPTljID1lMSA+DQpzYWE3MTMzWzBd
OiBpMmMgeGZlcjogPCA4ZiA9ZjkgPTljID1lMSA9NzAgPg0Kc2FhNzEzM1sw
XTogaTJjIHhmZXI6IDwgOGYgPTljID1lMSA9NzAgPWY5ID4NCnNhYTcxMzNb
MF06IGkyYyB4ZmVyOiA8IDhmID1lMSA9NzAgPWY5ID05YyA+DQpzYWE3MTMz
WzBdOiBpMmMgeGZlcjogPCA4ZiA9NzAgPWY5ID05YyA9ZTEgPg0Kc2FhNzEz
M1swXTogaTJjIHhmZXI6IDwgOGYgPWY5ID05YyA9ZTEgPTcwID4NCnNhYTcx
MzNbMF06IGkyYyB4ZmVyOiA8IDhmID05YyA9ZTEgPTcwID1mOSA+DQpzYWE3
MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZTEgPTcwID1mOSA9OWMgPg0Kc2Fh
NzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTcwID1mOSA9OWMgPWUxID4NCnNh
YTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1mOSA9OWMgPWUxID03MCA+DQpz
YWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9OWMgPWUxID03MCA9ZjkgPg0K
c2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWUxID03MCA9ZjkgPTljID4N
CnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID03MCA9ZjkgPTljID1lMSA+
DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZjkgPTljID1lMSA9NzAg
Pg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTljID1lMSA9NzAgPWY5
ID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1lMSA9NzAgPWY5ID05
YyA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9NzAgPWY5ID05YyA9
ZTEgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWY5ID05YyA9ZTEg
PTcwID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID05YyA9ZTEgPTcw
ID1mOSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZTEgPTcwID1m
OSA9OWMgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTcwID1mOSA9
OWMgPWUxID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1mOSA9OWMg
PWUxID03MCA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9OWMgPWUx
ID03MCA9ZjkgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWUxID03
MCA9ZjkgPTljID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID03MCA9
ZjkgPTljID1lMSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9Zjkg
PTljID1lMSA9NzAgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTlj
ID1lMSA9NzAgPWY5ID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1l
MSA9NzAgPWY5ID05YyA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9
NzAgPWY5ID05YyA9ZTEgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYg
PWY5ID05YyA9ZTEgPTcwID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhm
ID05YyA9ZTEgPTcwID1mOSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4
ZiA9ZTEgPTcwID1mOSA9OWMgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwg
OGYgPTcwID1mOSA9OWMgPWUxID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8
IDhmID1mOSA9OWMgPWUxID03MCA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjog
PCA4ZiA9OWMgPWUxID03MCA9ZjkgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6
IDwgOGYgPWUxID03MCA9ZjkgPTljID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVy
OiA8IDhmID03MCA9ZjkgPTljID1lMSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZl
cjogPCA4ZiA9ZjkgPTljID1lMSA9NzAgPg0Kc2FhNzEzM1swXTogaTJjIHhm
ZXI6IDwgOGYgPTljID1lMSA9NzAgPWY5ID4NCnNhYTcxMzNbMF06IGkyYyB4
ZmVyOiA8IDhmID1lMSA9NzAgPWY5ID05YyA+DQpzYWE3MTMzWzBdOiBpMmMg
eGZlcjogPCA4ZiA9NzAgPWY5ID05YyA9ZTEgPg0Kc2FhNzEzM1swXTogaTJj
IHhmZXI6IDwgOGYgPWY5ID05YyA9ZTEgPTcwID4NCnNhYTcxMzNbMF06IGky
YyB4ZmVyOiA8IDhmID05YyA9ZTEgPTcwID1mOSA+DQpzYWE3MTMzWzBdOiBp
MmMgeGZlcjogPCA4ZiA9ZTEgPTcwID1mOSA9OWMgPg0Kc2FhNzEzM1swXTog
aTJjIHhmZXI6IDwgOGYgPTcwID1mOSA9OWMgPWUxID4NCnNhYTcxMzNbMF06
IGkyYyB4ZmVyOiA8IDhmID1mOSA9OWMgPWUxID03MCA+DQpzYWE3MTMzWzBd
OiBpMmMgeGZlcjogPCA4ZiA9OWMgPWUxID03MCA9ZjkgPg0Kc2FhNzEzM1sw
XTogaTJjIHhmZXI6IDwgOGYgPWUxID03MCA9ZjkgPTljID4NCnNhYTcxMzNb
MF06IGkyYyB4ZmVyOiA8IDhmID03MCA9ZjkgPTljID1lMSA+DQpzYWE3MTMz
WzBdOiBpMmMgeGZlcjogPCA4ZiA9ZjkgPTljID1lMSA9NzAgPg0Kc2FhNzEz
M1swXTogaTJjIHhmZXI6IDwgOGYgPTljID1lMSA9NzAgPWY5ID4NCnNhYTcx
MzNbMF06IGkyYyB4ZmVyOiA8IDhmID1lMSA9NzAgPWY5ID05YyA+DQpzYWE3
MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9NzAgPWY5ID05YyA9ZTEgPg0Kc2Fh
NzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWY5ID05YyA9ZTEgPTcwID4NCnNh
YTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID05YyA9ZTEgPTcwID1mOSA+DQpz
YWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZTEgPTcwID1mOSA9OWMgPg0K
c2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTcwID1mOSA9OWMgPWUxID4N
CnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1mOSA9OWMgPWUxID03MCA+
DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9OWMgPWUxID03MCA9Zjkg
Pg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWUxID03MCA9ZjkgPTlj
ID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID03MCA9ZjkgPTljID1l
MSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZjkgPTljID1lMSA9
NzAgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTljID1lMSA9NzAg
PWY5ID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1lMSA9NzAgPWY5
ID05YyA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9NzAgPWY5ID05
YyA9ZTEgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWY5ID05YyA9
ZTEgPTcwID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID05YyA9ZTEg
PTcwID1mOSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZTEgPTcw
ID1mOSA9OWMgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTcwID1m
OSA9OWMgPWUxID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1mOSA9
OWMgPWUxID03MCA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9OWMg
PWUxID03MCA9ZjkgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWUx
ID03MCA9ZjkgPTljID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID03
MCA9ZjkgPTljID1lMSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9
ZjkgPTljID1lMSA9NzAgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYg
PTljID1lMSA9NzAgPWY5ID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhm
ID1lMSA9NzAgPWY5ID05YyA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4
ZiA9NzAgPWY5ID05YyA9ZTEgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwg
OGYgPWY5ID05YyA9ZTEgPTcwID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8
IDhmID05YyA9ZTEgPTcwID1mOSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjog
PCA4ZiA9ZTEgPTcwID1mOSA9OWMgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6
IDwgOGYgPTcwID1mOSA9OWMgPWUxID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVy
OiA8IDhmID1mOSA9OWMgPWUxID03MCA+DQpzYWE3MTMzWzBdOiBpMmMgeGZl
cjogPCA4ZiA9OWMgPWUxID03MCA9ZjkgPg0Kc2FhNzEzM1swXTogaTJjIHhm
ZXI6IDwgOGYgPWUxID03MCA9ZjkgPTljID4NCnNhYTcxMzNbMF06IGkyYyB4
ZmVyOiA8IDhmID03MCA9ZjkgPTljID1lMSA+DQpzYWE3MTMzWzBdOiBpMmMg
eGZlcjogPCA4ZiA9ZjkgPTljID1lMSA9NzAgPg0Kc2FhNzEzM1swXTogaTJj
IHhmZXI6IDwgOGYgPTljID1lMSA9NzAgPWY5ID4NCnNhYTcxMzNbMF06IGky
YyB4ZmVyOiA8IDhmID1lMSA9NzAgPWY5ID05YyA+DQpzYWE3MTMzWzBdOiBp
MmMgeGZlcjogPCA4ZiA9NzAgPWY5ID05YyA9ZTEgPg0Kc2FhNzEzNCBBTFNB
IGRyaXZlciBmb3IgRE1BIHNvdW5kIHVubG9hZGVkDQpzYWE3MTMzWzBdOiBp
MmMgeGZlcjogPCA4ZiA9ZjkgPTljID1lMSA9NzAgPg0Kc2FhNzEzM1swXTog
aTJjIHhmZXI6IDwgOGYgPTljID1lMSA9NzAgPWY5ID4NCnNhYTcxMzNbMF06
IGkyYyB4ZmVyOiA8IDhmID1lMSA9NzAgPWY5ID05YyA+DQpzYWE3MTMzWzBd
OiBpMmMgeGZlcjogPCA4ZiA9NzAgPWY5ID05YyA9ZTEgPg0Kc2FhNzEzM1sw
XTogaTJjIHhmZXI6IDwgOGYgPWY5ID05YyA9ZTEgPTcwID4NCnNhYTcxMzNb
MF06IGkyYyB4ZmVyOiA8IDhmID05YyA9ZTEgPTcwID1mOSA+DQpzYWE3MTMz
WzBdOiBpMmMgeGZlcjogPCA4ZiA9ZTEgPTcwID1mOSA9OWMgPg0Kc2FhNzEz
M1swXTogaTJjIHhmZXI6IDwgOGYgPTcwID1mOSA9OWMgPWUxID4NCnNhYTcx
MzNbMF06IGkyYyB4ZmVyOiA8IDhmID1mOSA9OWMgPWUxID03MCA+DQpzYWE3
MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9OWMgPWUxID03MCA9ZjkgPg0Kc2Fh
NzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWUxID03MCA9ZjkgPTljID4NCnNh
YTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID03MCA9ZjkgPTljID1lMSA+DQpz
YWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZjkgPTljID1lMSA9NzAgPg0K
c2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTljID1lMSA9NzAgPWY5ID4N
CnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1lMSA9NzAgPWY5ID05YyA+
DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9NzAgPWY5ID05YyA9ZTEg
Pg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWY5ID05YyA9ZTEgPTcw
ID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID05YyA9ZTEgPTcwID1m
OSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZTEgPTcwID1mOSA9
OWMgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTcwID1mOSA9OWMg
PWUxID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1mOSA9OWMgPWUx
ID03MCA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9OWMgPWUxID03
MCA9ZjkgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWUxID03MCA9
ZjkgPTljID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID03MCA9Zjkg
PTljID1lMSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9ZjkgPTlj
ID1lMSA9NzAgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPTljID1l
MSA9NzAgPWY5ID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDhmID1lMSA9
NzAgPWY5ID05YyA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4ZiA9NzAg
PWY5ID05YyA9ZTEgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYgPWY5
ID05YyA9ZTEgPTcwID4NCnNhYTcxMzNbMF0vaXJxWzQyLDk4MjA0XTogcj0w
eDAgcz0weDAwDQpzYWE3MTMzWzBdL2NvcmU6IGh3ZmluaQ0Kc2FhNzEzMC8z
NDogdjRsMiBkcml2ZXIgdmVyc2lvbiAwLjIuMTUgbG9hZGVkDQpzYWE3MTMz
WzBdOiBmb3VuZCBhdCAwMDAwOjAwOjBkLjAsIHJldjogMjA4LCBpcnE6IDEx
LCBsYXRlbmN5OiAzMiwgbW1pbzogMHhlZDgwMDAwMA0Kc2FhNzEzM1swXTog
c3Vic3lzdGVtOiAxMWJkOjAwMmUsIGJvYXJkOiBQaW5uYWNsZSBQQ1RWIDQw
aS81MGkvMTEwaSAoc2FhNzEzMykgW2NhcmQ9NzcsYXV0b2RldGVjdGVkXQ0K
c2FhNzEzM1swXTogYm9hcmQgaW5pdDogZ3BpbyBpcyAyMDBlMDAwDQpzYWE3
MTMzWzBdL2NvcmU6IGh3aW5pdDENCnNhYTcxMzNbMF06IGdwaW86IG1vZGU9
MHgwMDAwMDAwIGluPTB4MjAwYzAwMCBvdXQ9MHgwMDAwMDAwIFtwcmUtaW5p
dF0NCklSUSAxMS9zYWE3MTMzWzBdOiBJUlFGX0RJU0FCTEVEIGlzIG5vdCBn
dWFyYW50ZWVkIG9uIHNoYXJlZCBJUlFzDQpzYWE3MTMzWzBdOiBpMmMgeGZl
cjogPCBhMCAwMCA+DQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCBhMSA9YmQg
PTExID0yZSA9MDAgPTU0ID0yMCA9MWMgPTAwID00MyA9NDMgPWE5ID0xYyA9
NTUgPWQyID1iMiA9OTIgPWZmID1lMCA9NjAgPTAyID1mZiA9MjAgPWZmID1m
ZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID0wMSA9MmMgPTAx
ID0wMiA9MDIgPTAxID0wNCA9MzAgPTk4ID1mZiA9MDAgPWEwID1mZiA9MjIg
PTAwID1jMiA9OTYgPWZmID0wMyA9MzAgPTE1ID0wMSA9ZmYgPWZmID0wYyA9
MjIgPTE3ID03NiA9MDMgPTI0ID0zMSA9MDUgPWZmID1mZiA9ZmYgPWZmID1m
ZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZm
ID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYg
PWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9
ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1m
ZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZm
ID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYg
PWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9
ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1m
ZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZm
ID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYg
PWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9
ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1m
ZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZm
ID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYg
PWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9
ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1m
ZiA9ZmYgPWZmID1mZiA9ZmYgPWZmID1mZiA9ZmYgPg0Kc2FhNzEzM1swXTog
aTJjIGVlcHJvbSAwMDogYmQgMTEgMmUgMDAgNTQgMjAgMWMgMDAgNDMgNDMg
YTkgMWMgNTUgZDIgYjIgOTINCnNhYTcxMzNbMF06IGkyYyBlZXByb20gMTA6
IGZmIGUwIDYwIDAyIGZmIDIwIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZm
IGZmDQpzYWE3MTMzWzBdOiBpMmMgZWVwcm9tIDIwOiAwMSAyYyAwMSAwMiAw
MiAwMSAwNCAzMCA5OCBmZiAwMCBhMCBmZiAyMiAwMCBjMg0Kc2FhNzEzM1sw
XTogaTJjIGVlcHJvbSAzMDogOTYgZmYgMDMgMzAgMTUgMDEgZmYgZmYgMGMg
MjIgMTcgNzYgMDMgMjQgMzEgMDUNCnNhYTcxMzNbMF06IGkyYyBlZXByb20g
NDA6IGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZm
IGZmIGZmDQpzYWE3MTMzWzBdOiBpMmMgZWVwcm9tIDUwOiBmZiBmZiBmZiBm
ZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZg0Kc2FhNzEz
M1swXTogaTJjIGVlcHJvbSA2MDogZmYgZmYgZmYgZmYgZmYgZmYgZmYgZmYg
ZmYgZmYgZmYgZmYgZmYgZmYgZmYgZmYNCnNhYTcxMzNbMF06IGkyYyBlZXBy
b20gNzA6IGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZm
IGZmIGZmIGZmDQpzYWE3MTMzWzBdOiBpMmMgZWVwcm9tIDgwOiBmZiBmZiBm
ZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZg0Kc2Fh
NzEzM1swXTogaTJjIGVlcHJvbSA5MDogZmYgZmYgZmYgZmYgZmYgZmYgZmYg
ZmYgZmYgZmYgZmYgZmYgZmYgZmYgZmYgZmYNCnNhYTcxMzNbMF06IGkyYyBl
ZXByb20gYTA6IGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZm
IGZmIGZmIGZmIGZmDQpzYWE3MTMzWzBdOiBpMmMgZWVwcm9tIGIwOiBmZiBm
ZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZg0K
c2FhNzEzM1swXTogaTJjIGVlcHJvbSBjMDogZmYgZmYgZmYgZmYgZmYgZmYg
ZmYgZmYgZmYgZmYgZmYgZmYgZmYgZmYgZmYgZmYNCnNhYTcxMzNbMF06IGky
YyBlZXByb20gZDA6IGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZm
IGZmIGZmIGZmIGZmIGZmDQpzYWE3MTMzWzBdOiBpMmMgZWVwcm9tIGUwOiBm
ZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBm
Zg0Kc2FhNzEzM1swXTogaTJjIGVlcHJvbSBmMDogZmYgZmYgZmYgZmYgZmYg
ZmYgZmYgZmYgZmYgZmYgZmYgZmYgZmYgZmYgZmYgZmYNCmkyYy1hZGFwdGVy
IGkyYy0xOiBJbnZhbGlkIDctYml0IGFkZHJlc3MgMHg3YQ0Kc2FhNzEzM1sw
XTogaTJjIHhmZXI6IDwgOGUgPg0KaW5wdXQ6IGkyYyBJUiAoUGlubmFjbGUg
UENUVikgYXMgL2NsYXNzL2lucHV0L2lucHV0Ng0KaXIta2JkLWkyYzogaTJj
IElSIChQaW5uYWNsZSBQQ1RWKSBkZXRlY3RlZCBhdCBpMmMtMS8xLTAwNDcv
aXIwIFtzYWE3MTMzWzBdXQ0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgOGYg
RVJST1I6IEFSQl9MT1NUDQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4NCBF
UlJPUjogTk9fREVWSUNFDQpzYWE3MTMzWzBdOiBpMmMgeGZlcjogPCA4NiBF
UlJPUjogQVJCX0xPU1QNCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDk0IEVS
Uk9SOiBOT19ERVZJQ0UNCnNhYTcxMzNbMF06IGkyYyB4ZmVyOiA8IDk2IEVS
Uk9SOiBBUkJfTE9TVA0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgYzAgRVJS
T1I6IE5PX0RFVklDRQ0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgYzIgRVJS
T1I6IE5PX0RFVklDRQ0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgYzQgRVJS
T1I6IE5PX0RFVklDRQ0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgYzYgRVJS
T1I6IE5PX0RFVklDRQ0Kc2FhNzEzM1swXTogaTJjIHhmZXI6IDwgYzggRVJS
T1I6IE5PX0RFVklDRQ0Kc2FhNzEzM1swXS9jb3JlOiBod2luaXQyDQpzYWE3
MTMzWzBdOiBncGlvOiBtb2RlPTB4MDIwMDAwMCBpbj0weDIwMGMwMDAgb3V0
PTB4MDAwMDAwMCBbVGVsZXZpc2lvbl0NCnNhYTcxMzNbMF06IGdwaW86IG1v
ZGU9MHgwMjAwMDAwIGluPTB4MjAwZTAwMCBvdXQ9MHgwMDAwMDAwIFtUZWxl
dmlzaW9uXQ0Kc2FhNzEzM1swXTogZ3BpbzogbW9kZT0weDAyMDAwMDAgaW49
MHgyMDBlMDAwIG91dD0weDAwMDAwMDAgW1RlbGV2aXNpb25dDQpzYWE3MTMz
WzBdOiByZWdpc3RlcmVkIGRldmljZSB2aWRlbzAgW3Y0bDJdDQpzYWE3MTMz
WzBdOiByZWdpc3RlcmVkIGRldmljZSB2YmkwDQpzYWE3MTMzWzBdOiByZWdp
c3RlcmVkIGRldmljZSByYWRpbzANCnNhYTcxMzQgQUxTQSBkcml2ZXIgZm9y
IERNQSBzb3VuZCBsb2FkZWQNCklSUSAxMS9zYWE3MTMzWzBdOiBJUlFGX0RJ
U0FCTEVEIGlzIG5vdCBndWFyYW50ZWVkIG9uIHNoYXJlZCBJUlFzDQpzYWE3
MTMzWzBdL2Fsc2E6IHNhYTcxMzNbMF0gYXQgMHhlZDgwMDAwMCBpcnEgMTEg
cmVnaXN0ZXJlZCBhcyBjYXJkIC0xDQpzYWE3MTMzWzBdOiBpMmMgeGZlcjog
PCA4ZiA9OWMgPWUxID03MCA9ZjkgPg0Kc2FhNzEzM1swXTogaTJjIHhmZXI6
IDwgOGYgPWUxID03MCA9ZjkgPTljID4NCnNhYTcxMzNbMF06IGkyYyB4ZmVy
OiA8IDhmID03MCA9ZjkgPTljID1lMSA+DQpzYWE3MTMzWzBdOiBpMmMgeGZl
cjogPCA4ZiA9ZjkgPTljID1lMSA9NzAgPg0Kc2FhNzEzM1swXTogaTJjIHhm
ZXI6IDwgOGYgPTljID1lMSA9NzAgPWY5ID4NCnNhYTcxMzNbMF06IGkyYyB4
ZmVyOiA8IDhmID1lMSA9NzAgPWY5ID05YyA+DQpzYWE3MTMzWzBdOiBpMmMg
eGZlcjogPCA4ZiA9NzAgPWY5ID05YyA9ZTEgPg0Kc2FhNzEzM1swXTogaTJj
IHhmZXI6IDwgOGYgPWY5ID05YyA9ZTEgPTcwID4NCg==

---1463811324-1804289383-1246916864=:4126
Content-Type: TEXT/PLAIN; NAME=".config"
Content-Disposition: ATTACHMENT; FILENAME=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.30
# Mon Jul  6 21:36:12 2009
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
# CONFIG_NAMESPACES is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_KALLSYMS_EXTRA_PASS=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_API_DEBUG=y
# CONFIG_SLOW_WORK is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
# CONFIG_SPARSE_IRQ is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
CONFIG_MK7=y
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_USE_3DNOW=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_NONFATAL is not set
CONFIG_X86_MCE_P4THERMAL=y
CONFIG_VM86=y
CONFIG_TOSHIBA=m
CONFIG_I8K=m
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
# CONFIG_X86_CPU_DEBUG is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K6=m
CONFIG_X86_POWERNOW_K7=m
CONFIG_X86_POWERNOW_K7_ACPI=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_GX_SUSPMOD=m
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=m
CONFIG_X86_SPEEDSTEP_SMI=m
CONFIG_X86_P4_CLOCKMOD=m
CONFIG_X86_CPUFREQ_NFORCE2=m
CONFIG_X86_LONGRUN=m
CONFIG_X86_LONGHAUL=m
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_COMPAQ=m
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
CONFIG_HOTPLUG_PCI_IBM=m
CONFIG_HOTPLUG_PCI_ACPI=m
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
# CONFIG_NF_CONNTRACK is not set
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=m
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
# CONFIG_NETFILTER_XT_TARGET_HL is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_PHYSDEV is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
CONFIG_IP_VS=m
# CONFIG_IP_VS_IPV6 is not set
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
# CONFIG_IP_NF_MATCH_AH is not set
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_ECN=m
# CONFIG_IP_NF_TARGET_TTL is not set
CONFIG_IP_NF_RAW=m
# CONFIG_IP_NF_SECURITY is not set
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
# CONFIG_IP6_NF_MATCH_AH is not set
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
# CONFIG_IP6_NF_MATCH_MH is not set
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
# CONFIG_IP6_NF_TARGET_REJECT is not set
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
# CONFIG_IP6_NF_SECURITY is not set

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
# CONFIG_BRIDGE_EBT_IP6 is not set
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
# CONFIG_BRIDGE_EBT_ULOG is not set
# CONFIG_BRIDGE_EBT_NFLOG is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_HMAC_NONE=y
# CONFIG_SCTP_HMAC_SHA1 is not set
# CONFIG_SCTP_HMAC_MD5 is not set
# CONFIG_TIPC is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
CONFIG_ATM_BR2684=m
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_DECNET=m
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=m
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_LTPC=m
CONFIG_COPS=m
CONFIG_COPS_DAYNA=y
CONFIG_COPS_TANGENT=y
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_IPDDP_DECAP=y
CONFIG_X25=m
CONFIG_LAPB=m
CONFIG_ECONET=m
CONFIG_ECONET_AUNUDP=y
CONFIG_ECONET_NATIVE=y
CONFIG_WAN_ROUTER=m
# CONFIG_PHONET is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=m
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
CONFIG_6PACK=m
CONFIG_BPQETHER=m
CONFIG_DMASCC=m
CONFIG_SCC=m
# CONFIG_SCC_DELAY is not set
# CONFIG_SCC_TRXECHO is not set
CONFIG_BAYCOM_SER_FDX=m
CONFIG_BAYCOM_SER_HDX=m
CONFIG_BAYCOM_PAR=m
CONFIG_BAYCOM_EPP=m
CONFIG_YAM=m
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
# CONFIG_TOIM3232_DONGLE is not set
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m
# CONFIG_KINGSUN_DONGLE is not set
# CONFIG_KSDAZZLE_DONGLE is not set
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_TOSHIBA_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
# CONFIG_MCS_FIR is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_LL is not set
CONFIG_BT_HCIBCM203X=m
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
# CONFIG_RXKAD is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
CONFIG_WIRELESS_OLD_REGULATORY=y
# CONFIG_WIRELESS_EXT is not set
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
# CONFIG_RFKILL_INPUT is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
CONFIG_MTD=m
# CONFIG_MTD_DEBUG is not set
CONFIG_MTD_CONCAT=m
CONFIG_MTD_PARTITIONS=y
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=m
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
# CONFIG_NFTL_RW is not set
CONFIG_INFTL=m
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_SC520CDP=m
CONFIG_MTD_NETSC520=m
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_AMD76XROM=m
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=m
CONFIG_MTD_NETtel=m
CONFIG_MTD_DILNETPC=m
CONFIG_MTD_DILNETPC_BOOTSIZE=0x80000
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=m
CONFIG_MTD_DOC2001=m
CONFIG_MTD_DOC2001PLUS=m
CONFIG_MTD_DOCPROBE=m
CONFIG_MTD_DOCECC=m
CONFIG_MTD_DOCPROBE_ADVANCED=y
CONFIG_MTD_DOCPROBE_ADDRESS=0x0000
CONFIG_MTD_DOCPROBE_HIGH=y
CONFIG_MTD_DOCPROBE_55AA=y
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
# CONFIG_MTD_NAND_ECC_SMC is not set
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_CS553X is not set
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_ALAUDA is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set

#
# UBI - Unsorted block images
#
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
CONFIG_PNPBIOS_PROC_FS=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
CONFIG_BLK_DEV_XD=m
CONFIG_PARIDE=m

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=m
CONFIG_PARIDE_PCD=m
CONFIG_PARIDE_PF=m
CONFIG_PARIDE_PT=m
CONFIG_PARIDE_PG=m

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=m
CONFIG_PARIDE_BPCK=m
CONFIG_PARIDE_BPCK6=m
CONFIG_PARIDE_COMM=m
CONFIG_PARIDE_DSTR=m
CONFIG_PARIDE_FIT2=m
CONFIG_PARIDE_FIT3=m
CONFIG_PARIDE_EPAT=m
CONFIG_PARIDE_EPATC8=y
CONFIG_PARIDE_EPIA=m
CONFIG_PARIDE_FRIQ=m
CONFIG_PARIDE_FRPW=m
CONFIG_PARIDE_KBIC=m
CONFIG_PARIDE_KTTI=m
CONFIG_PARIDE_ON20=m
CONFIG_PARIDE_ON26=m
CONFIG_BLK_CPQ_DA=m
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_SX8=m
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=32000
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=m
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_ISL29003 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=y
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
CONFIG_BLK_DEV_OFFBOARD=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=m
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=m
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=m
CONFIG_BLK_DEV_CS5520=m
CONFIG_BLK_DEV_CS5530=m
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
CONFIG_BLK_DEV_HPT366=y
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=m
CONFIG_BLK_DEV_TRM290=m
CONFIG_BLK_DEV_VIA82CXXX=y
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
# CONFIG_BLK_DEV_ALI14XX is not set
# CONFIG_BLK_DEV_DTC2278 is not set
# CONFIG_BLK_DEV_HT6560B is not set
# CONFIG_BLK_DEV_QD65XX is not set
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_7000FASST=m
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AHA152X=m
CONFIG_SCSI_AHA1542=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=253
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=m
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_DPT_I2O=m
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_IN2000=m
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=m
# CONFIG_SCSI_FLASHPOINT is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
CONFIG_SCSI_DMX3191D=m
CONFIG_SCSI_DTC3280=m
CONFIG_SCSI_EATA=m
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
# CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_GDTH=m
CONFIG_SCSI_GENERIC_NCR5380=m
CONFIG_SCSI_GENERIC_NCR5380_MMIO=m
CONFIG_SCSI_GENERIC_NCR53C400=y
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
# CONFIG_SCSI_MVSAS is not set
CONFIG_SCSI_NCR53C406A=m
# CONFIG_SCSI_STEX is not set
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=0
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_PAS16=m
CONFIG_SCSI_QLOGIC_FAS=m
CONFIG_SCSI_QLOGIC_1280=m
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_SYM53C416=m
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=m
CONFIG_SCSI_T128=m
CONFIG_SCSI_U14_34F=m
# CONFIG_SCSI_U14_34F_TAGGED_QUEUE is not set
CONFIG_SCSI_U14_34F_LINKED_COMMANDS=y
CONFIG_SCSI_U14_34F_MAX_TAGS=8
CONFIG_SCSI_ULTRASTOR=m
CONFIG_SCSI_NSP32=m
CONFIG_SCSI_DEBUG=m
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
CONFIG_MD_RAID456=y
CONFIG_MD_RAID6_PQ=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=m
CONFIG_IEEE1394_OHCI1394=m
CONFIG_IEEE1394_PCILYNX=m
CONFIG_IEEE1394_SBP2=m
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=m
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_DV1394=m
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
# CONFIG_I2O_BUS is not set
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_COMPAT_NET_DEV_OPS=y
# CONFIG_IFB is not set
CONFIG_DUMMY=m
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
CONFIG_EQUALIZER=m
CONFIG_TUN=m
# CONFIG_VETH is not set
CONFIG_NET_SB1000=m
CONFIG_ARCNET=m
CONFIG_ARCNET_1201=m
CONFIG_ARCNET_1051=m
CONFIG_ARCNET_RAW=m
# CONFIG_ARCNET_CAP is not set
CONFIG_ARCNET_COM90xx=m
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=m
CONFIG_ARCNET_COM20020=m
CONFIG_ARCNET_COM20020_ISA=m
CONFIG_ARCNET_COM20020_PCI=m
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
CONFIG_EL1=m
CONFIG_EL2=m
CONFIG_ELPLUS=m
CONFIG_EL16=m
CONFIG_EL3=m
CONFIG_3C515=m
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
CONFIG_LANCE=m
CONFIG_NET_VENDOR_SMC=y
CONFIG_WD80x3=m
CONFIG_ULTRA=m
CONFIG_SMC9194=m
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_RACAL=y
CONFIG_NI5010=m
CONFIG_NI52=m
CONFIG_NI65=m
# CONFIG_DNET is not set
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_TULIP=m
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
# CONFIG_ULI526X is not set
CONFIG_AT1700=m
CONFIG_DEPCA=m
CONFIG_HP100=m
CONFIG_NET_ISA=y
CONFIG_E2100=m
CONFIG_EWRK3=m
CONFIG_EEXPRESS=m
CONFIG_EEXPRESS_PRO=m
CONFIG_HPLAN_PLUS=m
CONFIG_HPLAN=m
CONFIG_LP486E=m
CONFIG_ETH16I=m
CONFIG_NE2000=m
CONFIG_ZNET=m
CONFIG_SEEQ8005=m
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=m
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_AC3200=m
CONFIG_APRICOT=m
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=m
# CONFIG_FORCEDETH_NAPI is not set
CONFIG_CS89x0=m
CONFIG_E100=m
CONFIG_FEALNX=m
CONFIG_NATSEMI=m
CONFIG_NE2K_PCI=m
CONFIG_8139CP=m
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
CONFIG_SIS900=m
CONFIG_EPIC100=m
# CONFIG_SMSC9420 is not set
CONFIG_SUNDANCE=m
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_TLAN=m
CONFIG_VIA_RHINE=m
# CONFIG_VIA_RHINE_MMIO is not set
# CONFIG_SC92031 is not set
CONFIG_NET_POCKET=y
CONFIG_ATP=m
CONFIG_DE600=m
CONFIG_DE620=m
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=m
CONFIG_E1000=m
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
CONFIG_NS83820=m
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
CONFIG_R8169=m
# CONFIG_R8169_VLAN is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_VIA_VELOCITY=m
CONFIG_TIGON3=m
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3_DEPENDS=y
# CONFIG_CHELSIO_T3 is not set
# CONFIG_ENIC is not set
# CONFIG_IXGBE is not set
CONFIG_IXGB=m
CONFIG_S2IO=m
# CONFIG_VXGE is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_QLGE is not set
# CONFIG_SFC is not set
# CONFIG_BE2NET is not set
CONFIG_TR=y
CONFIG_IBMTR=m
CONFIG_IBMOL=m
CONFIG_IBMLS=m
CONFIG_3C359=m
CONFIG_TMS380TR=m
CONFIG_TMSPCI=m
CONFIG_SKISA=m
CONFIG_PROTEON=m
CONFIG_ABYSS=m
CONFIG_SMCTR=m

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
CONFIG_USB_NET_NET1080=m
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
# CONFIG_USB_HSO is not set
CONFIG_WAN=y
CONFIG_HOSTESS_SV11=m
CONFIG_COSA=m
# CONFIG_LANMEDIA is not set
CONFIG_SEALEVEL_4021=m
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m
CONFIG_HDLC_X25=m
CONFIG_PCI200SYN=m
CONFIG_WANXL=m
# CONFIG_PC300TOO is not set
CONFIG_N2=m
CONFIG_C101=m
CONFIG_FARSYNC=m
# CONFIG_DSCC4 is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
CONFIG_SDLA=m
CONFIG_WAN_ROUTER_DRIVERS=m
CONFIG_CYCLADES_SYNC=m
CONFIG_CYCLOMX_X25=y
# CONFIG_LAPBETHER is not set
# CONFIG_X25_ASY is not set
CONFIG_SBNI=m
CONFIG_SBNI_MULTILINE=y
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=m
# CONFIG_ATM_ZATM_DEBUG is not set
CONFIG_ATM_NICSTAR=m
CONFIG_ATM_NICSTAR_USE_SUNI=y
CONFIG_ATM_NICSTAR_USE_IDT77105=y
CONFIG_ATM_IDT77252=m
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=m
# CONFIG_ATM_HORIZON_DEBUG is not set
CONFIG_ATM_IA=m
# CONFIG_ATM_IA_DEBUG is not set
CONFIG_ATM_FORE200E=m
CONFIG_ATM_FORE200E_USE_TASKLET=y
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=m
CONFIG_ATM_HE_USE_SUNI=y
# CONFIG_ATM_SOLOS is not set
CONFIG_FDDI=y
CONFIG_DEFXX=m
# CONFIG_DEFXX_MMIO is not set
CONFIG_SKFP=m
# CONFIG_HIPPI is not set
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
# CONFIG_PPP_MPPE is not set
CONFIG_PPPOE=m
CONFIG_PPPOATM=m
# CONFIG_PPPOL2TP is not set
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=m
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
CONFIG_PHONE=m
CONFIG_PHONE_IXJ=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_NEWTON=m
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_INPORT=m
# CONFIG_MOUSE_ATIXL is not set
CONFIG_MOUSE_LOGIBM=m
CONFIG_MOUSE_PC110PAD=m
CONFIG_MOUSE_VSXXXAA=m
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GUNZE=m
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_HTCPEN is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_COMPUTONE=m
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
CONFIG_DIGIEPCA=m
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
CONFIG_ISI=m
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
# CONFIG_SYNCLINK_GT is not set
CONFIG_N_HDLC=m
CONFIG_RISCOM8=m
CONFIG_SPECIALIX=m
CONFIG_SX=m
CONFIG_RIO=m
# CONFIG_RIO_OLDPCI is not set
CONFIG_STALDRV=y
CONFIG_STALLION=m
CONFIG_ISTALLION=m
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_NVRAM=m
CONFIG_RTC=m
CONFIG_GEN_RTC=m
CONFIG_GEN_RTC_X=y
CONFIG_DTLK=m
CONFIG_R3964=m
CONFIG_APPLICOM=m
CONFIG_SONYPI=m
CONFIG_MWAVE=m
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=m
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_SCx200_ACB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=m

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7473=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATK0110=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHER=m
CONFIG_SENSORS_FSCPOS=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_HDAPS=m
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_SENSORS_APPLESMC=m
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=m
# CONFIG_THERMAL_HWMON is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_SC520_WDT=m
CONFIG_EUROTECH_WDT=m
CONFIG_IB700_WDT=m
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=m
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_60XX_WDT=m
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=m
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
CONFIG_W83627HF_WDT=m
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=m
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=m
CONFIG_MIXCOMWD=m
CONFIG_WDT=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m
CONFIG_WDT_501_PCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_VPX3220=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_PMS=m
CONFIG_VIDEO_BWQCAM=m
CONFIG_VIDEO_CQCAM=m
CONFIG_VIDEO_W9966=m
CONFIG_VIDEO_CPIA=m
CONFIG_VIDEO_CPIA_PP=m
CONFIG_VIDEO_CPIA_USB=m
# CONFIG_VIDEO_CPIA2 is not set
CONFIG_VIDEO_SAA5246A=m
CONFIG_VIDEO_SAA5249=m
CONFIG_VIDEO_STRADIS=m
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_DC30=m
CONFIG_VIDEO_ZORAN_ZR36060=m
CONFIG_VIDEO_ZORAN_BUZ=m
CONFIG_VIDEO_ZORAN_DC10=m
CONFIG_VIDEO_ZORAN_LML33=m
CONFIG_VIDEO_ZORAN_LML33R10=m
# CONFIG_VIDEO_ZORAN_AVS6EYES is not set
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_MXB=m
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_CX88_VP3054=m
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_AU0828 is not set
CONFIG_VIDEO_IVTV=m
# CONFIG_VIDEO_FB_IVTV is not set
# CONFIG_VIDEO_CX18 is not set
CONFIG_VIDEO_CAFE_CCIC=m
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_STK014=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_ZC3XX=m
# CONFIG_VIDEO_PVRUSB2 is not set
CONFIG_VIDEO_HDPVR=m
# CONFIG_VIDEO_EM28XX is not set
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_ALSA=m
CONFIG_VIDEO_CX231XX_DVB=m
# CONFIG_VIDEO_USBVISION is not set
CONFIG_VIDEO_USBVIDEO=m
CONFIG_USB_VICAM=m
CONFIG_USB_IBMCAM=m
CONFIG_USB_KONICAWC=m
CONFIG_USB_QUICKCAM_MESSENGER=m
CONFIG_USB_ET61X251=m
CONFIG_VIDEO_OVCAMCHIP=m
CONFIG_USB_W9968CF=m
CONFIG_USB_OV511=m
CONFIG_USB_SE401=m
CONFIG_USB_SN9C102=m
CONFIG_USB_STV680=m
CONFIG_USB_ZC0301=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
# CONFIG_USB_ZR364XX is not set
CONFIG_USB_STKWEBCAM=m
# CONFIG_USB_S2255 is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_CADET=m
CONFIG_RADIO_RTRACK=m
CONFIG_RADIO_RTRACK2=m
CONFIG_RADIO_AZTECH=m
CONFIG_RADIO_GEMTEK=m
CONFIG_RADIO_GEMTEK_PCI=m
CONFIG_RADIO_MAXIRADIO=m
CONFIG_RADIO_MAESTRO=m
CONFIG_RADIO_SF16FMI=m
CONFIG_RADIO_SF16FMR2=m
CONFIG_RADIO_TERRATEC=m
CONFIG_RADIO_TRUST=m
CONFIG_RADIO_TYPHOON=m
CONFIG_RADIO_TYPHOON_PROC_FS=y
CONFIG_RADIO_ZOLTRIX=m
CONFIG_USB_DSBR=m
CONFIG_USB_SI470X=m
CONFIG_USB_MR800=m
CONFIG_RADIO_TEA5764=m
# CONFIG_DVB_DYNAMIC_MINORS is not set
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m

#
# Supported USB Adapters
#
# CONFIG_DVB_USB is not set
CONFIG_DVB_TTUSB_BUDGET=m
# CONFIG_DVB_TTUSB_DEC is not set
CONFIG_DVB_SIANO_SMS1XXX=m
CONFIG_DVB_SIANO_SMS1XXX_SMS_IDS=y

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=m

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported SDMC DM1105 Adapters
#
CONFIG_DVB_DM1105=m

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_IEEE1394=y
CONFIG_DVB_FIREDTV_INPUT=y

#
# Supported DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_S5H1411=m
CONFIG_DVB_PLL=m
CONFIG_DVB_LNBP21=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DAB=y
CONFIG_USB_DABUSB=m

#
# Graphics support
#
CONFIG_AGP=m
CONFIG_AGP_ALI=m
CONFIG_AGP_ATI=m
CONFIG_AGP_AMD=m
CONFIG_AGP_AMD64=m
CONFIG_AGP_INTEL=m
CONFIG_AGP_NVIDIA=m
CONFIG_AGP_SIS=m
CONFIG_AGP_SWORKS=m
CONFIG_AGP_VIA=m
CONFIG_AGP_EFFICEON=m
CONFIG_DRM=m
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_I810=m
CONFIG_DRM_I830=m
CONFIG_DRM_I915=m
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=m
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=m
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=m
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=m
# CONFIG_FB_HGA_ACCEL is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I810=m
# CONFIG_FB_I810_GTF is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MULTIHEAD=y
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=m
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=m
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=m
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=m
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_BROADSHEET=m
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
# CONFIG_BACKLIGHT_PROGEAR is not set
CONFIG_BACKLIGHT_MBP_NVIDIA=m
CONFIG_BACKLIGHT_SAHARA=m

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_MDA_CONSOLE=m
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=m
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_SB_COMMON=m
# CONFIG_SND_ISA is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
CONFIG_SND_ALS4000=m
CONFIG_SND_ALI5451=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
CONFIG_SND_AW2=m
CONFIG_SND_AZT3328=m
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
# CONFIG_SND_CA0106 is not set
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
# CONFIG_SND_EMU10K1X is not set
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
CONFIG_SND_FM801=m
# CONFIG_SND_FM801_TEA575X_BOOL is not set
# CONFIG_SND_HDA_INTEL is not set
CONFIG_SND_HDSP=m
# CONFIG_SND_HDSPM is not set
CONFIG_SND_HIFIER=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MIXART=m
CONFIG_SND_NM256=m
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
CONFIG_SND_SIS7019=m
CONFIG_SND_SONICVIBES=m
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
# CONFIG_SND_VIA82XX_MODEM is not set
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_USX2Y=m
# CONFIG_SND_USB_CAIAQ is not set
CONFIG_SND_USB_US122L=m
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=m
CONFIG_SOUND_MSNDCLAS=m
CONFIG_MSNDCLAS_INIT_FILE="/etc/sound/msndinit.bin"
CONFIG_MSNDCLAS_PERM_FILE="/etc/sound/msndperm.bin"
CONFIG_SOUND_MSNDPIN=m
CONFIG_MSNDPIN_INIT_FILE="/etc/sound/pndspini.bin"
CONFIG_MSNDPIN_PERM_FILE="/etc/sound/pndsperm.bin"
CONFIG_SOUND_OSS=m
# CONFIG_SOUND_TRACEINIT is not set
# CONFIG_SOUND_DMAP is not set
CONFIG_SOUND_SSCAPE=m
CONFIG_SOUND_VMIDI=m
CONFIG_SOUND_TRIX=m
CONFIG_SOUND_MSS=m
CONFIG_SOUND_MPU401=m
CONFIG_SOUND_PAS=m
CONFIG_SOUND_PSS=m
# CONFIG_PSS_MIXER is not set
# CONFIG_PSS_HAVE_BOOT is not set
CONFIG_SOUND_SB=m
CONFIG_SOUND_YM3812=m
CONFIG_SOUND_UART6850=m
CONFIG_SOUND_AEDSP16=m
CONFIG_SC6600=y
CONFIG_SC6600_JOY=y
CONFIG_SC6600_CDROM=4
CONFIG_SC6600_CDROMBASE=0x0
CONFIG_SOUND_KAHLUA=m
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_APPLE=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_DRAGONRISE_FF=m
CONFIG_HID_EZKEY=m
CONFIG_HID_KYE=m
CONFIG_HID_GYRATION=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LOGITECH=m
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_TOPSEED is not set
CONFIG_THRUSTMASTER_FF=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=m
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=m
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set
# CONFIG_USB_GADGET_MUSB_HDRC is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
# CONFIG_USB_STORAGE_USBAT is not set
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=m
# CONFIG_USB_SERIAL_CH341 is not set
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
# CONFIG_USB_SERIAL_FUNSOFT is not set
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
# CONFIG_USB_SERIAL_KLSI is not set
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
CONFIG_USB_SERIAL_QUALCOMM=m
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_SYMBOL=m
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=m
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
# CONFIG_USB_BERRY_CHARGE is not set
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=m
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_ATM is not set
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_SELECTED=y
# CONFIG_USB_GADGET_AT91 is not set
# CONFIG_USB_GADGET_ATMEL_USBA is not set
# CONFIG_USB_GADGET_FSL_USB2 is not set
# CONFIG_USB_GADGET_LH7A40X is not set
# CONFIG_USB_GADGET_OMAP is not set
# CONFIG_USB_GADGET_PXA25X is not set
# CONFIG_USB_GADGET_PXA27X is not set
# CONFIG_USB_GADGET_S3C2410 is not set
# CONFIG_USB_GADGET_IMX is not set
# CONFIG_USB_GADGET_M66592 is not set
# CONFIG_USB_GADGET_AMD5536UDC is not set
# CONFIG_USB_GADGET_FSL_QE is not set
# CONFIG_USB_GADGET_CI13XXX is not set
CONFIG_USB_GADGET_NET2280=y
CONFIG_USB_NET2280=m
# CONFIG_USB_GADGET_GOKU is not set
# CONFIG_USB_GADGET_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_ZERO=m
CONFIG_USB_ETH=m
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_GADGETFS=m
CONFIG_USB_FILE_STORAGE=m
# CONFIG_USB_FILE_STORAGE_TEST is not set
CONFIG_USB_G_SERIAL=m
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_NOP_USB_XCEIV=m
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
CONFIG_ACPI_ASUS=m
CONFIG_ACPI_TOSHIBA=m

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=m
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=m
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=m
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
# CONFIG_NILFS2_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
CONFIG_NFSD=m
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_RPCSEC_GSS_SPKM3 is not set
CONFIG_SMB_FS=m
CONFIG_SMB_NLS_DEFAULT=y
CONFIG_SMB_NLS_REMOTE="cp437"
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
# CONFIG_CIFS_STATS2 is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
# CONFIG_NCPFS_IOCTL_LOCKING is not set
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=m
CONFIG_AFS_FS=m
# CONFIG_AFS_DEBUG is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_TRACING_SUPPORT=y

#
# Tracers
#
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_EVENT_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_BOOT_TRACER is not set
# CONFIG_TRACE_BRANCH_PROFILING is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_KMEMTRACE is not set
# CONFIG_WORKQUEUE_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_4KSTACKS is not set
CONFIG_DOUBLEFAULT=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
# CONFIG_SECURITY_PATH is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=0
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_IMA is not set
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_GF128MUL is not set
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_CRYPTO_DEV_GEODE=m
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_LGUEST is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_NLATTR=y

---1463811324-1804289383-1246916864=:4126
Content-Type: TEXT/PLAIN; NAME=messages
Content-Disposition: ATTACHMENT; FILENAME=messages

Jul  6 23:20:20 neptune kernel: saa7130/34: v4l2 driver version 0.2.15 loaded
Jul  6 23:20:20 neptune kernel: saa7133[0]: found at 0000:00:0d.0, rev: 208, irq: 11, latency: 32, mmio: 0xed800000
Jul  6 23:20:20 neptune kernel: saa7133[0]: subsystem: 11bd:002e, board: Pinnacle PCTV 40i/50i/110i (saa7133) [card=77,autodetected]
Jul  6 23:20:20 neptune kernel: saa7133[0]: board init: gpio is 200e000
Jul  6 23:20:20 neptune kernel: IRQ 11/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
Jul  6 23:20:20 neptune kernel: ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff >
Jul  6 23:20:20 neptune kernel: saa7133[0]: i2c eeprom 00: bd 11 2e 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Jul  6 23:20:20 neptune kernel: saa7133[0]: i2c eeprom 10: ff e0 60 02 ff 20 ff ff ff ff ff ff ff ff ff ff
Jul  6 23:20:20 neptune kernel: saa7133[0]: i2c eeprom 20: 01 2c 01 02 02 01 04 30 98 ff 00 a0 ff 22 00 c2
Jul  6 23:20:20 neptune kernel: saa7133[0]: i2c eeprom 30: 96 ff 03 30 15 01 ff ff 0c 22 17 76 03 24 31 05
Jul  6 23:20:20 neptune kernel: saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jul  6 23:20:20 neptune kernel: saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jul  6 23:20:20 neptune kernel: saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jul  6 23:20:20 neptune kernel: saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jul  6 23:20:20 neptune kernel: saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jul  6 23:20:20 neptune kernel: saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jul  6 23:20:20 neptune kernel: saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jul  6 23:20:20 neptune kernel: saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jul  6 23:20:20 neptune kernel: saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jul  6 23:20:20 neptune kernel: saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jul  6 23:20:20 neptune kernel: saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jul  6 23:20:20 neptune kernel: saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jul  6 23:20:20 neptune kernel: i2c-adapter i2c-1: Invalid 7-bit address 0x7a
Jul  6 23:20:20 neptune kernel: input: i2c IR (Pinnacle PCTV) as /class/input/input7
Jul  6 23:20:20 neptune kernel: ir-kbd-i2c: i2c IR (Pinnacle PCTV) detected at i2c-1/1-0047/ir0 [saa7133[0]]
Jul  6 23:20:20 neptune kernel: saa7133[0]: registered device video0 [v4l2]
Jul  6 23:20:20 neptune kernel: saa7133[0]: registered device vbi0
Jul  6 23:20:20 neptune kernel: saa7133[0]: registered device radio0
Jul  6 23:20:20 neptune kernel: saa7134 ALSA driver for DMA sound loaded
Jul  6 23:20:20 neptune kernel: IRQ 11/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
Jul  6 23:20:20 neptune kernel: saa7133[0]/alsa: saa7133[0] at 0xed800000 irq 11 registered as card -1
Jul  6 23:21:17 neptune ntpd[3339]: kernel time sync enabled 0001
Jul  6 23:25:20 neptune kernel: 
Jul  6 23:29:46 neptune smartd[2818]: Device: /dev/hdb, Temperature changed +1 Celsius to 43 Celsius (Min/Max 43/43!) 
Jul  6 23:29:46 neptune smartd[2818]: Device: /dev/hdb, SMART Usage Attribute: 190 Airflow_Temperature_Cel changed from 58 to 57 
Jul  6 23:29:46 neptune smartd[2818]: Device: /dev/hdb, SMART Usage Attribute: 195 Hardware_ECC_Recovered changed from 92 to 76 
Jul  6 23:29:47 neptune smartd[2818]: Device: /dev/hdc, SMART Prefailure Attribute: 1 Raw_Read_Error_Rate changed from 119 to 120 
Jul  6 23:29:47 neptune smartd[2818]: Device: /dev/hdc, SMART Usage Attribute: 195 Hardware_ECC_Recovered changed from 97 to 79 

---1463811324-1804289383-1246916864=:4126--

