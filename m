Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m17NUjE5006717
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 18:30:45 -0500
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net
	[151.189.21.53])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m17NU9dX021923
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 18:30:10 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <47AA2EBD.2050900@t-online.de>
References: <E1JMMVt-000Lwk-00.yurifun-mail-ru@f43.mail.ru>
	<1202258883.4261.28.camel@pc08.localdom.local>
	<47AA2EBD.2050900@t-online.de>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 00:26:23 +0100
Message-Id: <1202426783.20032.73.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Yuri Fundurian <yurifun@mail.ru>, v4l-dvb-maintainer@linuxtv.org,
	video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 2.6.24 1/1] saa7134: fix fm-radio
	pinnacle pctv 110i
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

Am Mittwoch, den 06.02.2008, 23:03 +0100 schrieb Hartmut Hackmann:
> Hi
> 
> hermann pitton schrieb:
> > Hi,
> > 
> > Am Dienstag, den 05.02.2008, 15:02 +0300 schrieb Yuri Fundurian:
> >> This patch for fm-radio on pinnacle pctv 110i.
> >> Without this patch fm-radio doesn't work.
> >>
> >> --- /usr/src/kernels/2.6.24/drivers/media/video/saa7134/saa7134-cards.c 2008-01-25 03:58:37.000000000 +0500
> >> +++ /usr/src/kernels/2.6.24/drivers/media/video/saa7134/saa7134-cards.c.patch   2008-01-31 11:27:01.000000000 +0500
> >> @@ -2484,7 +2484,8 @@ struct saa7134_board saa7134_boards[] =
> >>                 }},
> >>                 .radio = {
> >>                           .name = name_radio,
> >> -                         .amux = LINE1,
> >> +                       .amux = TV,
> >> +                       .gpio = 0x0200000,
> >>                 },
> >>         },
> >>         [SAA7134_BOARD_ASUSTeK_P7131_DUAL] = {
> >> Signed-off-by: Yuri Funduryan <yurifun@mail.ru>
> > Reviewed-by: Hermann Pitton <hermann-pitton@arcor.de>
> > 
> > Yuri, thanks for the fix.
> > 
> > Hartmut, does it apply with some offset or should I prepare something
> > against v4l-dvb?
> > 
> > Mauro can pull it as a fix for 2.6.25 then.
> > 
> > We also have the same issue on the Avermedia 007, AFAIK.
> > Next we should fix the indentation on the 110i entry ;)
> > 
> Hermann, will you generate a new patch?

Yes, of course. Had one already, but backed it out again.

> > Got a Medion/Creatix CTX953 today.
> > Against prior reports, DVB-T and analog TV work very well,
> > have to check the other inputs.
> > 
> > A patch will follow soon.

Have done all testing and the patch is ready.
There are slightly different versions of the CTX953 around and they are
in many recent Medion PCs, guess in the one sold today too.

> > No trace of the CTX948 yet I did send to you as a letter in the hope to
> > save some time. Will try to get it investigated. A new one is bought,
> > but might take time to arrive.
> > 
> > In between we might call for testers on both lists and point to what we
> > have so far.
> > 
> Jep. Btw: i might get a CTX948 let for some days... I will inform you as soon
> as there are news.

If my new one arrives, can send it too choosing a safer service this
time.

> I now have to hack a patch for the 10086 diseqc issue...
> 
> Hartmut
> 

Great, see Patrick has already acked it.

Here is a preview of the CTX953 patch against v4l-dvb.

This will conflict with the Quadro DVB-T/DVB-S switching in your repo.
Beside your devel repo, we could need a plain v4l-dvb repo for updates
and fixes. Should I regenerate the patch against your current repo and
the 110i radio fix also or stay against main v4l-dvb?

This variant of the CTX953 Hybrid (PCI/low profile) has no radio, no
LNA, externally on the bracket only one antenna connector, and
internally only analog audio-in and the usual combined s-video/composite
connector in MPC2 style. Means no analog audio out. It has a firmware
eeprom. The gpio init is 0. On the one on the wiki 0x200000 is probably
caused by using antenna_switch = 1 previously with an other card, but it
is different for the external inputs. Eeprom and subsystem is the same.
I'll provide some tuner area pictures too. Creatix.de also has an older
variant with the 5.7MHz ceramic filter for radio on their sites.

I'll resend this after "make commit" locally also to the dvb-ml and send
then the 110i fix, if you don't mind. Can be done also the other way
round.

Cheers,
Hermann


saa7133[2]: found at 0000:01:0a.0, rev: 209, irq: 21, latency: 64, mmio: 0xe8002000
saa7133[2]: subsystem: 16be:0010, board: Medion/Creatix CTX953 Hybrid [card=132,autodetected]
saa7133[2]: board init: gpio is 0
tuner' 4-004b: chip found @ 0x96 (saa7133[2])
tda829x 4-004b: setting tuner address to 60
tda829x 4-004b: type set to tda8290+75a
saa7133[2]: i2c eeprom 00: be 16 10 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[2]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
saa7133[2]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 2c 02 51 96 2b
saa7133[2]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
saa7133[2]: i2c eeprom 40: ff 21 00 c0 96 10 03 22 15 00 fd 79 44 9f c2 8f
saa7133[2]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: registered device video2 [v4l2]
saa7133[2]: registered device vbi2
DVB: registering new adapter (saa7134[0])
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 53MHz sampling clock
tda1004x: found firmware revision 26 -- ok
DVB: registering new adapter (saa7133[1])
DVB: registering frontend 1 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
DVB: registering new adapter (saa7133[2])
DVB: registering frontend 2 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 26 -- ok
saa7134 ALSA driver for DMA sound loaded
saa7134[0]/alsa: saa7134[0] at 0xe8000000 irq 19 registered as card -1
saa7133[1]/alsa: saa7133[1] at 0xe8001000 irq 20 registered as card -1
saa7133[2]/alsa: saa7133[2] at 0xe8002000 irq 21 registered as card -1


saa7134: add support for the Creatix CTX953_V.1.4.3 Hybrid

Signed-off-by: Hermann Pitton <hermann-pitton@arcor.de>

diff -r bc05bbbf9e60 linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134	Wed Feb 06 16:52:15 2008 -0200
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134	Thu Feb 07 11:07:01 2008 +0100
@@ -130,3 +130,4 @@ 129 -> Beholder BeholdTV 607 / BeholdTV 
 129 -> Beholder BeholdTV 607 / BeholdTV 609     [5ace:6070,5ace:6071,5ace:6072,5ace:6073,5ace:6090,5ace:6091,5ace:6092,5ace:6093]
 130 -> Beholder BeholdTV M6 / BeholdTV M6 Extra [5ace:6190,5ace:6193]
 131 -> Twinhan Hybrid DTV-DVB 3056 PCI          [1822:0022]
+132 -> Medion/Creatix CTX953 Hybrid             [16be:0010]
diff -r bc05bbbf9e60 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Feb 06 16:52:15 2008 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Feb 07 12:34:53 2008 +0100
@@ -3992,6 +3992,30 @@ struct saa7134_board saa7134_boards[] = 
 			.gpio   = 0x0200000,
 		},
 	},
+	[SAA7134_BOARD_CREATIX_CTX953] = {
+		.name         = "Medion/Creatix CTX953 Hybrid",
+		.audio_clock  = 0x00187de7,
+		.tuner_type   = TUNER_PHILIPS_TDA8290,
+		.radio_type   = UNSET,
+		.tuner_addr   = ADDR_UNSET,
+		.radio_addr   = ADDR_UNSET,
+		.tuner_config = 0,
+		.mpeg         = SAA7134_MPEG_DVB,
+		.inputs       = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+		}, {
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		} },
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -4942,6 +4966,12 @@ struct pci_device_id saa7134_pci_tbl[] =
 		.subvendor    = 0x1822, /*Twinhan Technology Co. Ltd*/
 		.subdevice    = 0x0022,
 		.driver_data  = SAA7134_BOARD_TWINHAN_DTV_DVB_3056,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x16be,
+		.subdevice    = 0x0010, /* Medion version CTX953_V.1.4.3 */
+		.driver_data  = SAA7134_BOARD_CREATIX_CTX953,
 	},{
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
@@ -5369,6 +5399,7 @@ int saa7134_board_init2(struct saa7134_d
 	case SAA7134_BOARD_MEDION_MD8800_QUADRO:
 	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
 	case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:
+	case SAA7134_BOARD_CREATIX_CTX953:
 		/* this is a hybrid board, initialize to analog mode
 		 * and configure firmware eeprom address
 		 */
diff -r bc05bbbf9e60 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Wed Feb 06 16:52:15 2008 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Thu Feb 07 12:48:43 2008 +0100
@@ -1063,6 +1063,9 @@ static int dvb_init(struct saa7134_dev *
 	case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:
 		configure_tda827x_fe(dev, &twinhan_dtv_dvb_3056_config);
 		break;
+	case SAA7134_BOARD_CREATIX_CTX953:
+		configure_tda827x_fe(dev, &md8800_dvbt_config);
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff -r bc05bbbf9e60 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Wed Feb 06 16:52:15 2008 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Wed Feb 06 21:52:42 2008 +0100
@@ -260,6 +260,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_BEHOLD_607_9FM	129
 #define SAA7134_BOARD_BEHOLD_M6		130
 #define SAA7134_BOARD_TWINHAN_DTV_DVB_3056 131
+#define SAA7134_BOARD_CREATIX_CTX953    132
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8



 





--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
