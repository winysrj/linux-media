Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab1FAN1q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 09:27:46 -0400
Message-ID: <4DE63E43.1090208@redhat.com>
Date: Wed, 01 Jun 2011 10:27:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Steve Kerrison <steve@stevekerrison.com>,
	Dan Carpenter <error27@gmail.com>
Subject: Re: [GIT PULL FOR 2.6.40] PCTV nanoStick T2 290e (Sony CXD2820R DVB-T/T2/C)
References: <4DDD69AE.3070606@iki.fi>
In-Reply-To: <4DDD69AE.3070606@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 25-05-2011 17:42, Antti Palosaari escreveu:
> Moikka Mauro,
> 
> Fixes...
> 
> 
> The following changes since commit 87cf028f3aa1ed51fe29c36df548aa714dc7438f:
> 
>   [media] dm1105: GPIO handling added, I2C on GPIO added, LNB control through GPIO reworked (2011-05-21 11:10:28 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/anttip/media_tree.git pctv_290e
> 
> Antti Palosaari (7):
>       em28xx-dvb: add module param "options" and use it for LNA

That patch is ugly, for several reasons:

1) we don't want a generic "options" parameter, whose meaning changes from
   device to devices;
2) what happens if someone has two em28xx devices plugged?
3) the better would be to detect if LNA is needed, or to add a DVBS2API
   call to enable/disable LNA.

>       cxd2820r: malloc buffers instead of stack
>       cxd2820r: fix bitfields
>       em28xx: EM28174 remote support
>       em28xx: add remote for PCTV nanoStick T2 290e
>       em28xx: correct PCTV nanoStick T2 290e device name
>       cxd2820r: correct missing error checks

The others are OK. Applied, thanks!

While here, I've updated the CARDLIST.* stuff, with the two patches
bellow, and running the old -hg scripts that auto-generat the cardlists.

Cheers,
Mauro

-


commit 9b5a38d2e549f3f66ce10ee6b669a401bb5f186b
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Wed Jun 1 10:16:25 2011 -0300

    [media] em28xx: use the proper prefix for board names
    
    All boards use EM28xxx_BOARD, to identify that the macro
    refers to a card entry. So:
    
    EM2874_LEADERSHIP_ISDBT -> EM2874_BOARD_LEADERSHIP_ISDBT
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index f15c734..7635a45 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1259,7 +1259,7 @@ struct em28xx_board em28xx_boards[] = {
 		} },
 	},
 
-	[EM2874_LEADERSHIP_ISDBT] = {
+	[EM2874_BOARD_LEADERSHIP_ISDBT] = {
 		.i2c_speed      = EM2874_I2C_SECONDARY_BUS_SELECT |
 				  EM28XX_I2C_CLK_WAIT_ENABLE |
 				  EM28XX_I2C_FREQ_100_KHZ,
@@ -1937,7 +1937,7 @@ static struct em28xx_hash_table em28xx_i2c_hash[] = {
 	{0x77800080, EM2860_BOARD_TVP5150_REFERENCE_DESIGN, TUNER_ABSENT},
 	{0xc51200e3, EM2820_BOARD_GADMEI_TVR200, TUNER_LG_PAL_NEW_TAPC},
 	{0x4ba50080, EM2861_BOARD_GADMEI_UTV330PLUS, TUNER_TNF_5335MF},
-	{0x6b800080, EM2874_LEADERSHIP_ISDBT, TUNER_ABSENT},
+	{0x6b800080, EM2874_BOARD_LEADERSHIP_ISDBT, TUNER_ABSENT},
 };
 
 /* I2C possible address to saa7115, tvp5150, msp3400, tvaudio */
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 7904ca4..012ab8e 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -546,7 +546,7 @@ static int dvb_init(struct em28xx *dev)
 	em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
 	/* init frontend */
 	switch (dev->model) {
-	case EM2874_LEADERSHIP_ISDBT:
+	case EM2874_BOARD_LEADERSHIP_ISDBT:
 		dvb->fe[0] = dvb_attach(s921_attach,
 				&sharp_isdbt, &dev->i2c_adap);
 
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 3cca331..28b9954 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -117,7 +117,7 @@
 #define EM2800_BOARD_VC211A			  74
 #define EM2882_BOARD_DIKOM_DK300		  75
 #define EM2870_BOARD_KWORLD_A340		  76
-#define EM2874_LEADERSHIP_ISDBT			  77
+#define EM2874_BOARD_LEADERSHIP_ISDBT			  77
 #define EM28174_BOARD_PCTV_290E                   78


commit 8d01aee82b8d2b30507a181609ba190bf192fcb0
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Wed Jun 1 10:23:53 2011 -0300

    [media] Update several cardlists
    
    Several cardlist entries are missed. Fix them by running some
    script magic (about the same scripts we used to have at -hg tree).
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/video4linux/CARDLIST.cx23885 b/Documentation/video4linux/CARDLIST.cx23885
index 87c4634..8910449 100644
--- a/Documentation/video4linux/CARDLIST.cx23885
+++ b/Documentation/video4linux/CARDLIST.cx23885
@@ -27,3 +27,5 @@
  26 -> Hauppauge WinTV-HVR1290                             [0070:8551]
  27 -> Mygica X8558 PRO DMB-TH                             [14f1:8578]
  28 -> LEADTEK WinFast PxTV1200                            [107d:6f22]
+ 29 -> GoTView X5 3D Hybrid                                [5654:2390]
+ 30 -> NetUP Dual DVB-T/C-CI RF                            [1b55:e2e4]
diff --git a/Documentation/video4linux/CARDLIST.cx88 b/Documentation/video4linux/CARDLIST.cx88
index 42517d9..d9c0f11 100644
--- a/Documentation/video4linux/CARDLIST.cx88
+++ b/Documentation/video4linux/CARDLIST.cx88
@@ -84,3 +84,4 @@
  83 -> Prof 7301 DVB-S/S2                                  [b034:3034]
  84 -> Samsung SMT 7020 DVB-S                              [18ac:dc00,18ac:dccd]
  85 -> Twinhan VP-1027 DVB-S                               [1822:0023]
+ 86 -> TeVii S464 DVB-S/S2                                 [d464:9022]
diff --git a/Documentation/video4linux/CARDLIST.em28xx b/Documentation/video4linux/CARDLIST.em28xx
index 9aae449..4a7b3df 100644
--- a/Documentation/video4linux/CARDLIST.em28xx
+++ b/Documentation/video4linux/CARDLIST.em28xx
@@ -74,3 +74,5 @@
  74 -> Actionmaster/LinXcel/Digitus VC211A      (em2800)
  75 -> Dikom DK300                              (em2882)
  76 -> KWorld PlusTV 340U or UB435-Q (ATSC)     (em2870)        [1b80:a340]
+ 77 -> EM2874 Leadership ISDBT                  (em2874)
+ 78 -> PCTV nanoStick T2 290e                   (em28174)
diff --git a/Documentation/video4linux/CARDLIST.saa7134 b/Documentation/video4linux/CARDLIST.saa7134
index 6b4c72d..7efae9b 100644
--- a/Documentation/video4linux/CARDLIST.saa7134
+++ b/Documentation/video4linux/CARDLIST.saa7134
@@ -182,3 +182,7 @@
 181 -> TechoTrend TT-budget T-3000              [13c2:2804]
 182 -> Kworld PCI SBTVD/ISDB-T Full-Seg Hybrid  [17de:b136]
 183 -> Compro VideoMate Vista M1F               [185b:c900]
+184 -> Encore ENLTV-FM 3                        [1a7f:2108]
+185 -> MagicPro ProHDTV Pro2 DMB-TH/Hybrid      [17de:d136]
+186 -> Beholder BeholdTV 501                    [5ace:5010]
+187 -> Beholder BeholdTV 503 FM                 [5ace:5030]
diff --git a/Documentation/video4linux/CARDLIST.tuner b/Documentation/video4linux/CARDLIST.tuner
index e67c1db..562d7fa 100644
--- a/Documentation/video4linux/CARDLIST.tuner
+++ b/Documentation/video4linux/CARDLIST.tuner
@@ -83,3 +83,4 @@ tuner=82 - Philips CU1216L
 tuner=83 - NXP TDA18271
 tuner=84 - Sony BTF-Pxn01Z
 tuner=85 - Philips FQ1236 MK5
+tuner=86 - Tena TNF5337 MFD
diff --git a/Documentation/video4linux/CARDLIST.usbvision b/Documentation/video4linux/CARDLIST.usbvision
index 0b72d3f..6fd1af3 100644
--- a/Documentation/video4linux/CARDLIST.usbvision
+++ b/Documentation/video4linux/CARDLIST.usbvision
@@ -63,3 +63,5 @@
  62 -> Pinnacle PCTV Bungee USB (PAL) FM                        [2304:0419]
  63 -> Hauppauge WinTv-USB                                      [2400:4200]
  64 -> Pinnacle Studio PCTV USB (NTSC) FM V3                    [2304:0113]
+ 65 -> Nogatech USB MicroCam NTSC (NV3000N)                     [0573:3000]
+ 66 -> Nogatech USB MicroCam PAL (NV3001P)                      [0573:3001]

