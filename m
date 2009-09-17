Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:39126 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194AbZIQXHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 19:07:17 -0400
Subject: Re: LifeView LR307Q Mini PCI
From: hermann pitton <hermann-pitton@arcor.de>
To: Gabriel Dos Santos <irkubr@hotmail.com>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <BAY142-W1057A33C315CFDFA910C32DAE10@phx.gbl>
References: <BAY142-W1057A33C315CFDFA910C32DAE10@phx.gbl>
Content-Type: multipart/mixed; boundary="=-XArtTb8MdawWfmiMUMhw"
Date: Fri, 18 Sep 2009 00:55:49 +0200
Message-Id: <1253228149.3308.43.camel@pc07.localdom.local>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-XArtTb8MdawWfmiMUMhw
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Gabriel,

Am Donnerstag, den 17.09.2009, 13:14 +0000 schrieb Gabriel Dos Santos:
> 
> Hi, I recently got a mini PCI LifeView LR307Q Hybrid TV Tuner.  
> I want to use it to tune analog tv (digital would be a plus but it is not really important to me). The card works perfectly (Analog and digital) on the same machine with Windows. Card subsystem is identified as 4e42:4307, which I didn't find in the list of supported cards by v4l. However, tHis forum (http://lists.zerezo.com/video4linux/msg15910.html) reports the card to be working (except for radio) with card=60 and audio_clock_override=0x00187de7 parameters to the module.
> However, I am unable to make sound  work . 

my, this is close to three years back!

The only reports we ever had were from Paul and he tried across
different cards and it was never finished. It has no radio and only one
single RF in connector.

BTW, do you know about an extra fan for cooling the tuner?
Likely not anymore on a tda8275ac1 and mini PCI.

> I am in Spain, which means norm = PAL-BG I think. I am using Ubuntu 9.04 (kernel 2.6.18-11)

That is a nightmare of wasting time. Given that all card entries were
still volatile that time, especially for gpio settings, I would to have
to dig out on what exactly version Paul was and compare it to an Ubuntu
2.6.18-11. Ugh!

On what you really are? They do down port several kernel versions
without problems, but card=109 is a few away from vanilla 2.6.18.

To add more, AFAIK, in Spain you use NICAM-BG for stereo sound and
around that 2.6.18 it might have been broken in favor of NICAM-DK.

The module names even did changed a lot, can't even tell the right debug
options off hand any more. With saa7134 audio_debug=1 you should at
least see, if it fails to detect NICAM-BG and hangs on other audio.

> The steps I follow are
> 
> 1) Remove the modules loaded by default with wrong parameters: rmmod saa7143-alsa;rmmod saa7134
> 2) sudo modprobe saa7134 card=X (I've tried several values of X)
> 3) Run scantv -c /dev/video0  -C /dev/vbi0  (norm = 5 , region=5)
> 4) open alsamixer in the SAAXXXX device and set the volume to 100% for every control
> 5) Run
> sox -c 2 -t ossdsp /dev/dsp1 -t ossdsp /dev/dsp& ; mencoder -tv norm=PAL-BG:driver=v4l2:device=/dev/video0:forceaudio:forcechan=1:adevice=/dev/dsp:fps=25:chanlist=europe-west:audiorate=32000:width=320:height=240 -vf lavcdeint -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=225 -oac lavc -lavcopts abitrate=32  -o out.avi tv://23

Start simple, say xawtv/tvtime and
sox -c 2 -s -w -r 32000 -t ossdsp /dev/dsp1 -t ossdsp -w -r 32000 /dev/dsp

> 
> The results I obtain are as follows
> 
> When using any of the values 2,3,39,54,74, 84,82,94 for the card number when loading the module,  scantv does not detect any channel
> 
> When using any of the values 55,60,81,109 for the card: scantv finds channels and I get an image (perfect image with 109, there are some glitches with other values) but only very short pulses of distorted sound. I have also tried using the parameter audio_clock_override=0x00187de7 when loading the module with the different card values, but the result is the same.
> 
> I have also tried using the tuner= parameter when loading the module but this seems to be ignored, since the dmesg always seems to be loading tuner=54
> 
>     tuner' 0-004b: chip found @ 0x96 (saa7133[0])
>     tda829x 0-004b: setting tuner address to 61
>     tda829x 0-004b: type set to tda8290+75a

Paul later reported that it works for the Philips Tiger S card=109 and
it has for sure a LNA config type 2. That explained the better image at
that time already with clear symptoms of missing LNA support previously.

> 
> Sorry for the long mail but I wanted to provide as much info as possible. I have now spent many nights trying to make this work and I am in the point in which I don't know what else to do. I would really appreciate to have some hint on what I am doing wrong,

It is difficult on 2.6.18.
You must upgrade to current mercurial v4l-dvb.

Currently it does not even compile on a 2.6.30.

  CC [M]  /mercurial/hg-head/v4l-dvb/v4l/videobuf-dma-sg.o
  CC [M]  /mercurial/hg-head/v4l-dvb/v4l/videobuf-dma-contig.o
/mercurial/hg-head/v4l-dvb/v4l/videobuf-dma-contig.c: In function 'videobuf_dma_contig_user_get':
/mercurial/hg-head/v4l-dvb/v4l/videobuf-dma-contig.c:164: error: implicit declaration of function 'follow_pfn'
make[3]: *** [/mercurial/hg-head/v4l-dvb/v4l/videobuf-dma-contig.o] Error 1

Anyway, attached is a testing patch, which if applied to something
working earlier or fixed later, might give you some direction.

Since I don't know, if gpio settings for RF antenna input switch are
correct for card=60 and/or 109 that time, in case you get no picture
anymore on card=109 with it on recent, change TV gpio in saa7134-cards.c
to 0x0000000 and antenna_switch in saa7134-dvb.c to 1 in that case.

Cheers,
Hermann

> Thanks in advance,
> 
> Gabriel
> 
> BTW: this is the dmesg and lspci output
> #sudo lspci -v
> 00:0e.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
>         Subsystem: Device 4e42:4307
>         Flags: bus master, medium devsel, latency 84, IRQ 10
>         Memory at efffe000 (32-bit, non-prefetchable) [size=2K]
>         Capabilities: [40] Power Management version 2
>         Kernel modules: saa7134
> 
> 
> #sudo modprobe saa7134 card=109
> 
> #dmesg
> [ 1821.423064] saa7130/34: v4l2 driver version 0.2.14 loaded
> [ 1821.423235] saa7133[0]: found at 0000:00:0e.0, rev: 209, irq: 10, latency: 84, mmio: 0xefffe000
> [ 1821.423269] saa7133[0]: subsystem: 4e42:4307, board: Philips Tiger - S Reference design [card=109,insmod option]
> [ 1821.423452] saa7133[0]: board init: gpio is 200000
> [ 1821.572569] saa7133[0]: i2c eeprom 00: 42 4e 07 43 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> [ 1821.572636] saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
> [ 1821.572698] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 00 9d ff ff ff ff
> [ 1821.572759] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 1821.572821] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 22 15 50 ff ff ff ff ff ff
> [ 1821.572883] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 1821.572945] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 1821.573007] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 1821.573070] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 1821.573132] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 1821.573194] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 1821.573256] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 1821.573318] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 1821.573381] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 1821.573443] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 1821.573505] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 1821.657407] tuner' 0-004b: chip found @ 0x96 (saa7133[0])
> [ 1821.740582] tda829x 0-004b: setting tuner address to 61
> [ 1821.804588] tda829x 0-004b: type set to tda8290+75a
> [ 1825.693389] saa7133[0]: registered device video0 [v4l2]
> [ 1825.693525] saa7133[0]: registered device vbi0
> [ 1825.693659] saa7133[0]: registered device radio0
> [ 1825.867650] saa7134 ALSA driver for DMA sound loaded
> [ 1825.883426] dvb_init() allocating 1 frontend
> [ 1825.884457] saa7133[0]/alsa: saa7133[0] at 0xefffe000 irq 10 registered as card -2
> [ 1825.945980] DVB: registering new adapter (saa7133[0])
> [ 1825.946008] DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
> [ 1826.168955] tda1004x: setting up plls for 48MHz sampling clock
> [ 1828.165008] tda1004x: found firmware revision 29 -- ok
> 


--=-XArtTb8MdawWfmiMUMhw
Content-Disposition: inline; filename=saa7134_test-the-lifeview-minipci-lna-hybrid.patch
Content-Type: text/x-patch; name=saa7134_test-the-lifeview-minipci-lna-hybrid.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r bbfe5db62836 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Sep 17 12:49:42 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Sep 18 00:26:33 2009 +0200
@@ -5296,7 +5296,32 @@
 			.amux = TV,
 		},
 	},
-
+	[SAA7134_BOARD_LIVEVIEW_MINIPCI_LNA] = {
+		.name           = "LifeView MiniPCI LNA",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.tuner_config   = 2,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.gpiomask       = 0x0200000,
+		.inputs = {{
+			.name   = name_tv,
+			.vmux   = 1,
+			.amux   = TV,
+			.tv     = 1,
+			.gpio   = 0x0200000,
+		}, {
+			.name   = name_comp1,
+			.vmux   = 3,
+			.amux   = LINE1,
+		}, {
+			.name   = name_svideo,
+			.vmux   = 8,
+			.amux   = LINE1,
+		} },
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -6429,6 +6454,12 @@
 		.subdevice    = 0x0138, /* LifeView FlyTV Prime30 OEM */
 		.driver_data  = SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x4e42,
+		.subdevice    = 0x4307, /* LifeView MiniPCI LR307-Q OEM */
+		.driver_data  = SAA7134_BOARD_LIVEVIEW_MINIPCI_LNA,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -7193,6 +7224,7 @@
 	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
 	case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:
 	case SAA7134_BOARD_CREATIX_CTX953:
+	case SAA7134_BOARD_LIVEVIEW_MINIPCI_LNA:
 	{
 		/* this is a hybrid board, initialize to analog mode
 		 * and configure firmware eeprom address
diff -r bbfe5db62836 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Thu Sep 17 12:49:42 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Fri Sep 18 00:26:33 2009 +0200
@@ -824,6 +824,20 @@
 	.request_firmware = philips_tda1004x_request_firmware
 };
 
+static struct tda1004x_config lifeview_minipci_lna_config = {
+	.demod_address = 0x08,
+	.invert        = 1,
+	.invert_oclk   = 0,
+	.xtal_freq     = TDA10046_XTAL_16M,
+	.agc_config    = TDA10046_AGC_TDA827X,
+	.gpio_config   = TDA10046_GP01_I,
+	.if_freq       = TDA10046_FREQ_045,
+	.i2c_gate      = 0x4b,
+	.tuner_address = 0x61,
+	.antenna_switch = 2, /* only one RF input, needs gpio 21 high */
+	.request_firmware = philips_tda1004x_request_firmware
+};
+
 /* ------------------------------------------------------------------
  * special case: this card uses saa713x GPIO22 for the mode switch
  */
@@ -1491,7 +1505,11 @@
 					0x60, &dev->i2c_adap) == NULL)
 				wprintk("%s: No zl10039 found!\n",
 					__func__);
-
+		break;
+	case SAA7134_BOARD_LIVEVIEW_MINIPCI_LNA:
+		if (configure_tda827x_fe(dev, &lifeview_minipci_lna_config,
+					 &tda827x_cfg_2) < 0)
+			goto dettach_frontend;
 		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
diff -r bbfe5db62836 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Thu Sep 17 12:49:42 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Fri Sep 18 00:26:33 2009 +0200
@@ -297,6 +297,7 @@
 #define SAA7134_BOARD_AVERMEDIA_STUDIO_505  170
 #define SAA7134_BOARD_BEHOLD_X7             171
 #define SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM 172
+#define SAA7134_BOARD_LIVEVIEW_MINIPCI_LNA   173
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

--=-XArtTb8MdawWfmiMUMhw--

