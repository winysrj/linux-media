Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4VMIh7w021119
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 18:18:43 -0400
Received: from mail.libertysurf.net (mx-out.libertysurf.net [213.36.80.91])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4VMIUvn021186
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 18:18:31 -0400
Received: from [192.168.0.230] (213.36.0.124) by mail.libertysurf.net
	(7.3.118.8) id 482DD26E005CBDE5 for video4linux-list@redhat.com;
	Sun, 1 Jun 2008 00:19:31 +0200
From: Nigel Henry <cave.dnb2m97pp@aliceadsl.fr>
To: video4linux-list@redhat.com
Date: Sat, 31 May 2008 23:11:24 +0200
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200805312311.25073.cave.dnb2m97pp@aliceadsl.fr>
Subject: Problems inserting tuner module with options set on 2.6.25 kernel
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

I have an Hauppauge Win TV Express card (bt878a) , and use this card on a 
machine that runs various distros. Tda9887 has been integrated within the 
tuner module for some time now, and now I set options against the tuner 
module, as below.
options tuner port2=0 pal=I

port2=0 is necessary to just get the sound working, and pal=I is necessary to 
get sound working for the transmissions I get from the Uk.

Moving on to my Archlinux install. This has progressed from kernel 2.6.22 to 
2.6.23, and 2.6.24, and with no problems with watching TV.

the only options set in /etc/modprobe.conf are:
options bttv automute=0  (that's because the signal strength is low from the 
uk)
options tuner port2=0 pal=I

No problems up to kernel 2.6.24, but when Archlinux upgraded the kernel to 
2.6.25 the shit hit the fan (excuse the language please), and I no longer had 
TV. Dmesg said it could not insert the tuner module. Modprobe tune printed 
out the following stuff.
[root@myhost djmons]# modprobe tuner
FATAL: Error inserting tuner 
(/lib/modules/2.6.25-ARCH/kernel/drivers/media/video/tuner.ko): Unknown 
symbol in module, or unknown parameter (see dmesg)
[root@myhost djmons]#

This was no doubt due to the options line for the tuner that I set 
in /etc/modprobe.conf for the 2.6.24, and earlier kernels. Commenting out 
that line, and running modprobe tuner again, resulted in the tuner being 
loaded, and having sound , and images for the TV card on the French channels.

A rmmod tuner, followed by modprobe tuner port2=0 resulted in the same failure 
to load as above. Another modprobe, this time as modprobe tuner pal=1 loaded 
the tuner with no errors, and I also have sound from the UK channels.

Modinfo shows this for the 2.6.25 kernel on Archlinux.

[root@myhost djmons]# modinfo tuner
filename:       /lib/modules/2.6.25-ARCH/kernel/drivers/media/video/tuner.ko
license:        GPL
author:         Ralph Metzler, Gerd Knorr, Gunther Mayer
description:    device driver for various TV and TV+FM radio tuners
depends:        
i2c-core,tea5761,v4l2-common,mt20xx,tuner-simple,tda9887,videodev,tea5767,xc5000,tuner-xc2028,tda8290
vermagic:       2.6.25-ARCH SMP preempt mod_unload 686
parm:           force:List of adapter,address pairs to boldly assume to be 
present (array of short)
parm:           probe:List of adapter,address pairs to scan additionally 
(array of short)
parm:           ignore:List of adapter,address pairs not to scan (array of 
short)
parm:           addr:int
parm:           no_autodetect:int
parm:           show_i2c:int
parm:           debug:int
parm:           pal:string
parm:           secam:string
parm:           ntsc:string
parm:           tv_range:array of int
parm:           radio_range:array of int
[root@myhost djmons]#

As you can see the ports parameters are missing, which no doubt explains why I 
couldn't modprobe the tuner with port2=0 set.

There's some odd modules being loaded with this 2.6.25 kernel, and just as an 
example tda9887 is being loaded, but that has been integrated within the 
tuner module for some time now, so why is it being loaded as a separate 
module? Lsmod for the 2.6.25 kernel on Archlinux is at the bottom of this 
post.

The question:

Booting the 2.6.24 kernel on Archlinux, with the following line 
in /etc/modprobe,conf works fine for sound and vision.
options tuner port2=0 pal-I

Booting the 2.6.25 kernel results in no tuner being loaded, thus no sound, or 
vision. This appears to be because modprobe detects a non existant option 
(port2=0) for loading the tuner module, and throws in the towel.

I think I'll stop here, as I believe this problem has more to do with how 
modprobe reads the options set in /etc/modprobe.conf, and deals with them.

Saying that though, is there not some way that when modprobe tries to load a 
module, using options set in /etc/modprobe.conf, and if some of these options 
are unavailable, they could just be ignored, and the module loaded anyway, 
missing some options yes, but they may not be critical.

This is a bit of modinfo stuff for the tuner on Fedora 8, running kernel 
2.6.24.7-92.fc8, and shows the ports parameters available, whereas on the 
Archlinux kernel 2.6.25 they no longer exist. See below.

[root@localhost djmons]# /sbin/modinfo tuner
filename:       /lib/modules/2.6.24.7-92.fc8/kernel/drivers/media/video/tuner.ko
license:        GPL
author:         Ralph Metzler, Gerd Knorr, Gunther Mayer
description:    device driver for various TV and TV+FM radio tuners
depends:        
i2c-core,tea5761,mt20xx,tuner-simple,v4l2-common,tea5767,tda8290
vermagic:       2.6.24.7-92.fc8 SMP mod_unload 686 4KSTACKS
parm:           port1:int
parm:           port2:int
parm:           qss:int
parm:           adjust:int
parm:           force:List of adapter,address pairs to boldly assume to be 
present (array of short)
parm:           probe:List of adapter,address pairs to scan additionally 
(array of short)
parm:           ignore:List of adapter,address pairs not to scan (array of 
short)
parm:           addr:int
parm:           no_autodetect:int
parm:           show_i2c:int
parm:           debug:int
parm:           pal:string
parm:           secam:string
parm:           ntsc:string
parm:           tv_range:array of int
parm:           radio_range:array of int
[root@localhost djmons]#

Lsmod for kernel 2.6.25 on Archlinux (Don't Panic)
[root@myhost djmons]# lsmod
Module                  Size  Used by
ipx                    24104  2
p8022                   2048  1 ipx
psnap                   3464  1 ipx
llc                     5644  2 p8022,psnap
p8023                   1920  1 ipx
ipv6                  256196  16
nls_cp437               5888  4
vfat                   10880  4
fat                    45984  1 vfat
ov511                  73616  0
psmouse                36880  0
tea5767                 6404  0
tda8290                12676  0
tda18271               31496  1 tda8290
ppdev                   7556  0
serio_raw               5508  0
tda827x                10116  1 tda8290
tuner_xc2028           19984  0
xc5000                 10244  0
lp                      9444  0
ppp_generic            24348  0
tda9887                 9348  0
tuner_simple            8712  0
pcspkr                  2816  0
mt20xx                 12040  0
tea5761                 4868  0
tvaudio                22360  0
bttv                  161940  0
videodev               31616  2 ov511,bttv
v4l1_compat            13956  1 videodev
ir_common              32772  1 bttv
compat_ioctl32          1536  2 ov511,bttv
i2c_algo_bit            6020  1 bttv
v4l2_common            10624  2 tvaudio,bttv
ohci1394               28720  0
videobuf_dma_sg        11396  1 bttv
ieee1394               79288  1 ohci1394
videobuf_core          15876  2 bttv,videobuf_dma_sg
emu10k1_gp              3072  0
btcx_risc               4488  1 bttv
tveeprom               14608  1 bttv
i2c_viapro              7956  0
gameport               11020  2 emu10k1_gp
firewire_ohci          16512  0
firewire_core          36928  1 firewire_ohci
i2c_core               19348  16 
tea5767,tda8290,tda18271,tda827x,tuner_xc2028,xc5000,tda9887,tuner_simple,mt20xx,tea5761,tvaudio,bttv,i2c_algo_bit,v4l2_common,tveeprom,i2c_viapro
crc_itu_t               2304  1 firewire_core
uhci_hcd               22288  0
via686a                13068  0
shpchp                 29460  0
pci_hotplug            26276  1 shpchp
parport_pc             34884  1
via_agp                 8448  1
agpgart                28244  1 via_agp
parport                31596  3 ppdev,lp,parport_pc
sg                     27188  0
thermal                15260  0
evdev                   9472  0
processor              32096  2 thermal
fan                     4356  0
button                  6416  0
battery                10372  0
ac                      4484  0
snd_usb_audio          79488  0
snd_usb_lib            15488  1 snd_usb_audio
usbcore               129776  5 ov511,uhci_hcd,snd_usb_audio,snd_usb_lib
snd_bt87x              12964  1
snd_emu10k1           140192  1
snd_rawmidi            19840  2 snd_usb_lib,snd_emu10k1
snd_ac97_codec         97828  1 snd_emu10k1
snd_util_mem            3840  1 snd_emu10k1
snd_hwdep               7428  2 snd_usb_audio,snd_emu10k1
snd_seq_oss            30336  0
snd_seq_midi_event      6656  1 snd_seq_oss
snd_seq                48432  4 snd_seq_oss,snd_seq_midi_event
snd_seq_device          6796  4 snd_emu10k1,snd_rawmidi,snd_seq_oss,snd_seq
snd_pcm_oss            38656  0
snd_pcm                68228  5 
snd_usb_audio,snd_bt87x,snd_emu10k1,snd_ac97_codec,snd_pcm_oss
snd_timer              19848  3 snd_emu10k1,snd_seq,snd_pcm
snd_page_alloc          8072  3 snd_bt87x,snd_emu10k1,snd_pcm
snd_mixer_oss          14848  1 snd_pcm_oss
snd                    46628  17 
snd_usb_audio,snd_bt87x,snd_emu10k1,snd_rawmidi,snd_ac97_codec,snd_hwdep,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_pcm,snd_timer,snd_mixer_oss
soundcore               6496  1 snd
ac97_bus                2048  1 snd_ac97_codec
slhc                    6016  1 ppp_generic
8139too                22784  0
8139cp                 19328  0
mii                     4992  2 8139too,8139cp
rtc_cmos                9120  0
rtc_core               15516  1 rtc_cmos
rtc_lib                 2944  1 rtc_core
ext3                  123912  2
jbd                    44052  1 ext3
mbcache                 7172  1 ext3
sr_mod                 15300  0
cdrom                  33952  1 sr_mod
sd_mod                 23320  8
pata_acpi               4992  0
ata_generic             5636  0
pata_via                8580  6
libata                141840  3 pata_acpi,ata_generic,pata_via
scsi_mod               92204  4 sg,sr_mod,sd_mod,libata
dock                    7952  1 libata
[root@myhost djmons]#

Thanks for any help with this problem.

Nigel.





--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
