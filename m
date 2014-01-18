Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:36060 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaARRWa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jan 2014 12:22:30 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so2319190eaj.1
        for <linux-media@vger.kernel.org>; Sat, 18 Jan 2014 09:22:28 -0800 (PST)
Received: from [192.168.2.1] (ip503da65a.speed.planet.nl. [80.61.166.90])
        by mx.google.com with ESMTPSA id 4sm36825744eed.14.2014.01.18.09.22.27
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Sat, 18 Jan 2014 09:22:28 -0800 (PST)
Subject: ZOLID new usb dvb-t
From: mjs <mjstork@gmail.com>
Reply-To: mjstork@gmail.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Jan 2014 18:22:25 +0100
Message-ID: <1390065745.1925.75.camel@fujitsu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hallo,

I'm new to linux and step by step learning by working with debian.
I'm using the 2.6.32-5-686 kernel and i have no knowledge about c+ other
then common sense and copy-paste.
(upgrading to the latest kernel will be a project in the future).

I've mechanical opened a :ZOLID Hybrid TV Stick.
This is a usb dvb-t analog and digital receiver (the : in front of the
name is no typo mistake).
Next hardware was found, EM2882 - XC3028L (needs XC3028L-v36.fw) -
WJCE6353 (equal to ZL10353) - TVP5150 - EM202 - T24LC02.
I believe every component is known by the EM28xx driver but not in this
specific configuration.
So no card in the EM28xx driver was found as a direct (or induced)
match.

I've made some modifications in the source code em28xx.h, em28xx-dvb.c
and em28xx-cards.c.
Successfully compiled the driver, made a great progress but not yet
victory.

After a "scan /usr/share/dvb/dvb-t/nl-all", the following lines were
added to the dmesg (tuning failed).
[ 2876.028035] xc2028 3-0061: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[ 2876.949274] xc2028 3-0061: Loading firmware for type=D2633 DTV8
(210), id 0000000000000000.
[ 2876.961893] xc2028 3-0061: Loading SCODE for type=DTV6 QAM DTV7
ZARLINK456 SCODE HAS_IF_4760 (620000e0), id 0000000000000000.

At this point i think i have two problems which i cannot solve (maybe
more ?).
    * gpio values em2882.
    * dmesg informed me the stick uses a IF=4500 which isn't listed
      in tuner_xc2028.h  (XC3028L-v36.fw ??).

I'm stuck and i hope some one can help me to take the next step.

Thanks.
  Marcel Stork (Netherlands).



Modifications:
[.....] = local position in gedit
___________________________________________________________________________________________________

em28xx.h
---------------------------------------------------------------------------------------------------
[ 113] #define  EM2882_BOARD_ZOLID_HYBRID_TV_STICK 74
___________________________________________________________________________________________________

em28xx-dvb.c
---------------------------------------------------------------------------------------------------
[ 304] static struct zl10353_config em28xx_zl10353_with_xc3028_zolid = {
.demod_address = (0x1e >> 1),
.no_tuner = 1,
.parallel_ts = 1,
.if2 = 45000,
};
---------------------------------------------------------------------------------------------------
[ 460] static int dvb_init(struct em28xx *dev)
[ 578] case EM2882_BOARD_ZOLID_HYBRID_TV_STICK:
dvb->frontend = dvb_attach(zl10353_attach,
&em28xx_zl10353_with_xc3028_zolid,
&dev->i2c_adap);
if (attach_xc3028(0x61, dev) < 0) {
result = -EINVAL;
goto out_free;
}
break;
___________________________________________________________________________________________________

em28xx-cards.c
---------------------------------------------------------------------------------------------------
[ 228] static struct em28xx_reg_seq zolid_tuner_gpio[] = { /*
[FIXME-MJS] */
{EM28XX_R08_GPIO, EM_GPIO_4, EM_GPIO_4, 10},
{EM28XX_R08_GPIO, 0, EM_GPIO_4, 10},
{EM28XX_R08_GPIO, EM_GPIO_4, EM_GPIO_4, 10},
{  -1, -1, -1, -1},
};

static struct em28xx_reg_seq zolid_digital[] = { /* [FIXME-MJS] */
        {EM28XX_R08_GPIO, 0x6e, ~EM_GPIO_4, 10},
{EM2880_R04_GPO, 0x04, 0xff,        100},/* zl10353 reset */
{EM2880_R04_GPO, 0x0c, 0xff, 1},
{ -1, -1, -1, -1},
};

static struct em28xx_reg_seq zolid_analog[] = { /* [FIXME-MJS] */
{EM28XX_R08_GPIO, 0x6d,   ~EM_GPIO_4, 10},
{ -1, -1, -1, -1},
};
---------------------------------------------------------------------------------------------------
[ 250] struct em28xx_board em28xx_boards[] = {
[1609] [EM2882_BOARD_ZOLID_HYBRID_TV_STICK] = {
.name         = ":ZOLID Hybrid TV Stick",
.tuner_type   = TUNER_XC2028,
.tuner_gpio   = zolid_tuner_gpio,
.decoder      = EM28XX_TVP5150,
.xclk         = EM28XX_XCLK_FREQUENCY_12MHZ,
.mts_firmware = 1,
.has_dvb      = 1,
.dvb_gpio     = zolid_digital,
/* .ir_codes     = &ir_codes_evga_indtube_table, [FIXME-MJS] */
.input        = { {
.type     = EM28XX_VMUX_TELEVISION,
.vmux     = TVP5150_COMPOSITE0,
.amux     = EM28XX_AMUX_VIDEO,
.gpio     = zolid_analog,
}, {
.type     = EM28XX_VMUX_COMPOSITE1,
.vmux     = TVP5150_COMPOSITE1,
.amux     = EM28XX_AMUX_LINE_IN,
.gpio     = zolid_analog,
}, {
.type     = EM28XX_VMUX_SVIDEO,
.vmux     = TVP5150_SVIDEO,
.amux     = EM28XX_AMUX_LINE_IN,
.gpio     = zolid_analog,
} },
},
---------------------------------------------------------------------------------------------------
[1641] struct usb_device_id em28xx_id_table[] = {
/* { USB_DEVICE(0xeb1a, 0x2883), [ Delete cause same vid/pid ] */
/* .driver_info = EM2880_BOARD_UNKNOWN }, [FIXME-MJS] */
[1663] { USB_DEVICE(0xeb1a, 0x2883),
.driver_info = EM2882_BOARD_ZOLID_HYBRID_TV_STICK },
---------------------------------------------------------------------------------------------------
[1761] static struct em28xx_hash_table em28xx_eeprom_hash[] = {
[1770] {0x85dd871e, EM2882_BOARD_ZOLID_HYBRID_TV_STICK, TUNER_XC2028},
---------------------------------------------------------------------------------------------------
[1774] static struct em28xx_hash_table em28xx_i2c_hash[] = {
[1780] {0xb06a32c3, EM2882_BOARD_ZOLID_HYBRID_TV_STICK, TUNER_XC2028},
---------------------------------------------------------------------------------------------------
[2091] static void em28xx_setup_xc3028(struct em28xx *dev, struct
xc2028_ctrl *ctl)
[2130] case EM2882_BOARD_ZOLID_HYBRID_TV_STICK: /* [FIXME-MJS] */
ctl->demod = XC3028_FE_ZARLINK456; /* according dmesg if = 45000 */
ctl->fname = XC3028L_DEFAULT_FIRMWARE;
break;


Lsmod:
Module                  Size  Used by
zl10353                 4961  1 
em28xx_dvb              5609  0 
dvb_core               62606  1 em28xx_dvb
em28xx_alsa             4831  0 
tuner_xc2028           14609  2 
tuner                  14428  1 
tvp5150                 9262  1 
em28xx                 63029  2 em28xx_dvb,em28xx_alsa
v4l2_common             9776  3 tuner,tvp5150,em28xx
ir_common              22187  1 em28xx
videobuf_vmalloc        3860  1 em28xx
videobuf_core          10452  2 em28xx,videobuf_vmalloc
tveeprom                9393  1 em28xx
aes_i586                6816  2 
aes_generic            25738  1 aes_i586
lib80211_crypt_ccmp     3643  2 
cpufreq_powersave        602  0 
cpufreq_stats           1997  0 
cpufreq_conservative     4018  0 
cpufreq_userspace       1456  0 
parport_pc             15799  0 
ppdev                   4058  0 
lp                      5570  0 
parport                22554  3 parport_pc,ppdev,lp
sco                     5885  2 
bridge                 32943  0 
stp                      996  1 bridge
bnep                    7408  2 
rfcomm                 25147  0 
l2cap                  21745  4 bnep,rfcomm
crc16                   1027  1 l2cap
bluetooth              36287  6 sco,bnep,rfcomm,l2cap
rfkill                 10220  3 bluetooth
binfmt_misc             4879  1 
uinput                  4796  1 
fuse                   44196  1 
gspca_sunplus          11210  0 
gspca_main             15775  1 gspca_sunplus
videodev               25573  5
tuner,tvp5150,em28xx,v4l2_common,gspca_main
v4l1_compat            10250  1 videodev
loop                    9745  0 
firewire_sbp2           9603  0 
snd_hda_codec_realtek   163390  1 
snd_hda_codec_si3054     2410  1 
snd_hda_intel          16635  1 
snd_hda_codec          46066  3
snd_hda_codec_realtek,snd_hda_codec_si3054,snd_hda_intel
snd_hwdep               4054  1 snd_hda_codec
snd_pcm                47226  4
em28xx_alsa,snd_hda_codec_si3054,snd_hda_intel,snd_hda_codec
snd_seq                35375  0 
joydev                  6739  0 
snd_timer              12270  2 snd_pcm,snd_seq
ipw2200               108300  0 
snd_seq_device          3673  1 snd_seq
i915                  223838  2 
libipw                 18415  1 ipw2200
drm_kms_helper         18545  1 i915
drm                   112489  3 i915,drm_kms_helper
i2c_algo_bit            3493  1 i915
i2c_i801                6462  0 
psmouse                44817  0 
snd                    34399  12
em28xx_alsa,snd_hda_codec_realtek,snd_hda_codec_si3054,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq,snd_timer,snd_seq_device
pcspkr                  1207  0 
evdev                   5609  15 
serio_raw               2916  0 
ac                      1636  0 
battery                 3782  0 
video                  14605  1 i915
processor              26283  1 
button                  3598  1 i915
i2c_core               12763  13
zl10353,tuner_xc2028,tuner,tvp5150,em28xx,v4l2_common,tveeprom,videodev,i915,drm_kms_helper,drm,i2c_algo_bit,i2c_i801
rng_core                2178  0 
lib80211                2846  3 lib80211_crypt_ccmp,ipw2200,libipw
soundcore               3450  1 snd
output                  1204  1 video
snd_page_alloc          5001  2 snd_hda_intel,snd_pcm
ext3                   94204  5 
jbd                    32269  1 ext3
mbcache                 3762  1 ext3
sg                     19917  0 
sr_mod                 10770  0 
sd_mod                 25969  7 
crc_t10dif              1012  1 sd_mod
cdrom                  26435  1 sr_mod
ata_generic             2247  0 
8139too                14885  0 
ata_piix               17716  6 
ahci                   27786  0 
8139cp                 13333  0 
firewire_ohci          16705  0 
libata                115713  3 ata_generic,ata_piix,ahci
uhci_hcd               16013  0 
thermal                 9206  0 
mii                     2714  2 8139too,8139cp
firewire_core          31155  2 firewire_sbp2,firewire_ohci
crc_itu_t               1035  1 firewire_core
ehci_hcd               28533  0 
scsi_mod              104949  5 firewire_sbp2,sg,sr_mod,sd_mod,libata
usbcore                99350  8
em28xx_dvb,em28xx_alsa,em28xx,gspca_sunplus,gspca_main,uhci_hcd,ehci_hcd
nls_base                4727  1 usbcore
thermal_sys             9378  3 video,processor,thermal


Dmesg:
[ 2530.756044] usb 1-3: new high speed USB device using ehci_hcd and
address 2
[ 2530.893179] usb 1-3: New USB device found, idVendor=eb1a,
idProduct=2883
[ 2530.893190] usb 1-3: New USB device strings: Mfr=0, Product=1,
SerialNumber=2
[ 2530.893200] usb 1-3: Product: USB 2883 Device
[ 2530.893207] usb 1-3: SerialNumber: 200804
[ 2530.895014] usb 1-3: configuration #1 chosen from 1 choice
[ 2531.425003] em28xx: New device USB 2883 Device @ 480 Mbps (eb1a:2883,
interface 0, class 0)
[ 2531.425200] em28xx #0: chip ID is em2882/em2883
[ 2531.581575] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 83 28 d0 12
65 00 6a 22 8c 10
[ 2531.581608] em28xx #0: i2c eeprom 10: 00 00 24 57 4e 37 01 00 60 00
00 00 02 00 00 00
[ 2531.581639] em28xx #0: i2c eeprom 20: 5e 00 01 00 f0 10 01 00 b8 00
00 00 5b 1e 00 00
[ 2531.581669] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 04 20 01 01
00 00 00 00 00 00
[ 2531.581699] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 d3 c4 00 00
[ 2531.581729] em28xx #0: i2c eeprom 50: 00 a2 b2 87 81 80 00 00 00 00
00 00 00 00 00 00
[ 2531.581758] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[ 2531.581788] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00
33 00 20 00 44 00
[ 2531.581818] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 10 03 32 00
[ 2531.581848] em28xx #0: i2c eeprom 90: 30 00 30 00 38 00 30 00 34 00
00 00 00 00 00 00
[ 2531.581878] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2531.581907] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2531.581937] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2531.581966] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2531.581996] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2531.582025] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2531.582060] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash =
0x85dd871e
[ 2531.582067] em28xx #0: EEPROM info:
[ 2531.582073] em28xx #0: AC97 audio (5 sample rates)
[ 2531.582079] em28xx #0: 500mA max power
[ 2531.582087] em28xx #0: Table at 0x24, strings=0x226a, 0x108c, 0x0000
[ 2531.582819] em28xx #0: Identified as :ZOLID Hybrid TV Stick (card=74)
[ 2531.616392] tvp5150 3-005c: chip found @ 0xb8 (em28xx #0)
[ 2531.645143] tuner 3-0061: chip found @ 0xc2 (em28xx #0)
[ 2531.691798] xc2028 3-0061: creating new instance
[ 2531.691809] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[ 2531.691826] usb 1-3: firmware: requesting xc3028L-v36.fw
[ 2531.709045] xc2028 3-0061: Loading 81 firmware images from
xc3028L-v36.fw, type: xc2028 firmware, ver 3.6
[ 2531.756034] xc2028 3-0061: Loading firmware for type=BASE MTS (5), id
0000000000000000.
[ 2532.661365] xc2028 3-0061: Loading firmware for type=MTS (4), id
000000000000b700.
[ 2532.675734] xc2028 3-0061: Loading SCODE for type=MTS LCD NOGD MONO
IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[ 2532.860114] em28xx #0: Config register raw data: 0xd0
[ 2532.860857] em28xx #0: AC97 vendor ID = 0xffffffff
[ 2532.861233] em28xx #0: AC97 features = 0x6a90
[ 2532.861239] em28xx #0: Empia 202 AC97 audio processor detected
[ 2532.972493] tvp5150 3-005c: tvp5150am1 detected.
[ 2533.068873] em28xx #0: v4l2 driver version 0.1.2
[ 2533.139659] em28xx #0: V4L2 video device registered as /dev/video0
[ 2533.139668] em28xx #0: V4L2 VBI device registered as /dev/vbi0
[ 2533.156139] usbcore: registered new interface driver em28xx
[ 2533.156795] em28xx driver loaded
[ 2533.273556] em28xx-audio.c: probing for em28x1 non standard usbaudio
[ 2533.273566] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[ 2533.276830] Em28xx: Initialized (Em28xx Audio Extension) extension
[ 2533.642770] xc2028 3-0061: attaching existing instance
[ 2533.642781] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[ 2533.642789] em28xx #0/2: xc3028 attached
[ 2533.642795] DVB: registering new adapter (em28xx #0)
[ 2533.642806] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353
DVB-T)...
[ 2533.647152] Successfully loaded em28xx-dvb
[ 2533.647161] Em28xx: Initialized (Em28xx dvb Extension) extension


