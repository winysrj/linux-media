Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vlada.matena@gmail.com>) id 1KMVKs-0001z5-50
	for linux-dvb@linuxtv.org; Sat, 26 Jul 2008 00:00:27 +0200
Received: by fg-out-1718.google.com with SMTP id e21so2070682fga.25
	for <linux-dvb@linuxtv.org>; Fri, 25 Jul 2008 15:00:22 -0700 (PDT)
Message-ID: <488A4CF4.4010206@gmail.com>
Date: Sat, 26 Jul 2008 00:00:20 +0200
From: =?ISO-8859-2?Q?Vladim=EDr_Mat=ECna?= <vlada.matena@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------030501070603040902090303"
Subject: [linux-dvb]  Compro DVB-T100
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------030501070603040902090303
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit

I have Compro Videomate DVB T-100 card.
There are drivers for T200 and other Videomate cards in my current 
kernel 2.6.25-gentoo-r7.
The card is using saa7134 chip with mt352 demodulator and qt1010 tuner.
I was able to modify some code to get T100 support.
Unfortunately I had to change some code common for all cards using 
qt1010 tuner.
This will probably break other cards support.

I attach patch against my kernel source. Use at own risk this is my firs 
patch.
There are some comments on changes on my personal pages 
http://www.vlamat.wz.cz/index.php?t100

Vladimír Matìna
vlada.matena@gmail.com

--------------030501070603040902090303
Content-Type: text/plain;
 name="videomate T100.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="videomate T100.patch"

diff -upr --exclude='*.o' --exclude='*.ko' --exclude='*.mod.c' --exclude='*.o.*' linux-2.6.25-gentoo-r7-unmodified/drivers/media/dvb/frontends/qt1010.c linux-2.6.25-gentoo-r7/drivers/media/dvb/frontends/qt1010.c
--- linux-2.6.25-gentoo-r7-unmodified/drivers/media/dvb/frontends/qt1010.c	2008-07-25 21:03:52.000000000 +0200
+++ linux-2.6.25-gentoo-r7/drivers/media/dvb/frontends/qt1010.c	2008-07-25 11:13:53.000000000 +0200
@@ -227,6 +227,9 @@ static int qt1010_set_params(struct dvb_
 	else                      tmpval = 0x05;
 	rd[41].val = (priv->reg20_init_val + 0x0d + tmpval);
 
+	rd[41].val = 0x39 +  tmpval; // for Videomate DVB T-100 
+	// FIXME two different calcualtion models on the lines above
+
 	/* 25 */
 	rd[43].val = priv->reg25_init_val;
 
diff -upr --exclude='*.o' --exclude='*.ko' --exclude='*.mod.c' --exclude='*.o.*' linux-2.6.25-gentoo-r7-unmodified/drivers/media/video/saa7134/saa7134-cards.c linux-2.6.25-gentoo-r7/drivers/media/video/saa7134/saa7134-cards.c
--- linux-2.6.25-gentoo-r7-unmodified/drivers/media/video/saa7134/saa7134-cards.c	2008-07-25 21:03:52.000000000 +0200
+++ linux-2.6.25-gentoo-r7/drivers/media/video/saa7134/saa7134-cards.c	2008-07-25 10:51:19.000000000 +0200
@@ -2331,6 +2331,24 @@ struct saa7134_board saa7134_boards[] = 
 			.amux   = LINE1,
 		}},
 	},
+	[SAA7134_BOARD_VIDEOMATE_DVBT_100] = {
+                .name           = "Compro Videomate DVB-T100",
+                .tuner_type     = TUNER_ABSENT,
+                .audio_clock    = 0x00187de7,
+                .radio_type     = UNSET,
+                .tuner_addr     = ADDR_UNSET,
+                .radio_addr     = ADDR_UNSET,
+                .mpeg           = SAA7134_MPEG_DVB,
+                .inputs = {{
+                        .name   = name_comp1,
+                        .vmux   = 0,
+                        .amux   = LINE1,
+                },{
+                        .name   = name_svideo,
+                        .vmux   = 8,
+                        .amux   = LINE1,
+                }},
+        },
 	[SAA7134_BOARD_RTD_VFG7350] = {
 		.name		= "RTD Embedded Technologies VFG7350",
 		.audio_clock	= 0x00200000,
@@ -5066,6 +5084,7 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUSII:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:
+        case SAA7134_BOARD_VIDEOMATE_DVBT_100:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200A:
 	case SAA7134_BOARD_MANLI_MTV001:
 	case SAA7134_BOARD_MANLI_MTV002:
@@ -5392,29 +5411,46 @@ int saa7134_board_init2(struct saa7134_d
 					       dev->name, i);
 		}
 		break;
+	case SAA7134_BOARD_VIDEOMATE_DVBT_100:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200A:
-		/* The T200 and the T200A share the same pci id.  Consequently,
+		/* The T100, T200 and the T200A share the same pci id.  Consequently,
 		 * we are going to query eeprom to try to find out which one we
 		 * are actually looking at. */
 
 		/* Don't do this if the board was specifically selected with an
 		 * insmod option or if we have the default configuration T200*/
-		if(!dev->autodetected || (dev->eedata[0x41] == 0xd0))
+		if(!dev->autodetected)
+		{
+			printk(KERN_INFO "%s: Board type forced by insmod option.  %s\n", dev->name, saa7134_boards[dev->board].name);
 			break;
-		if(dev->eedata[0x41] == 0x02) {
-			/* Reconfigure board  as T200A */
-			dev->board = SAA7134_BOARD_VIDEOMATE_DVBT_200A;
-			dev->tuner_type   = saa7134_boards[dev->board].tuner_type;
-			dev->tda9887_conf = saa7134_boards[dev->board].tda9887_conf;
-			printk(KERN_INFO "%s: Reconfigured board as %s\n",
-				dev->name, saa7134_boards[dev->board].name);
-		} else {
-			printk(KERN_WARNING "%s: Unexpected tuner type info: %x in eeprom\n",
-				dev->name, dev->eedata[0x41]);
+		}
+		
+		switch(dev->eedata[0x41])
+		{
+			case 0xd0:
+				printk(KERN_INFO "%s: Configured board as %s by eeprom data\n", dev->name, saa7134_boards[dev->board].name);
+			break;
+			case 0x02:
+				// Reconfigure board  as T200A 
+				dev->board = SAA7134_BOARD_VIDEOMATE_DVBT_200A;
+				dev->tuner_type   = saa7134_boards[dev->board].tuner_type;
+				dev->tda9887_conf = saa7134_boards[dev->board].tda9887_conf;
+				printk(KERN_INFO "%s: Reconfigured board as %s  by eeprom data\n", dev->name, saa7134_boards[dev->board].name);
+			break;	
+			case 0xd5:
+				// Reconfigure board  as T100 
+				dev->board = SAA7134_BOARD_VIDEOMATE_DVBT_100;
+				dev->tuner_type   = saa7134_boards[dev->board].tuner_type;
+				dev->tda9887_conf = saa7134_boards[dev->board].tda9887_conf;
+				printk(KERN_INFO "%s: Reconfigured board as %s by eeprom data\n", dev->name, saa7134_boards[dev->board].name);
+			break;
+
+			default:
+				printk(KERN_WARNING "%s: Unexpected tuner type info: %x in eeprom\n",dev->name, dev->eedata[0x41]);
 			break;
 		}
-		break;
+	break;
 	}
 	saa7134_tuner_setup(dev);
 	return 0;
diff -upr --exclude='*.o' --exclude='*.ko' --exclude='*.mod.c' --exclude='*.o.*' linux-2.6.25-gentoo-r7-unmodified/drivers/media/video/saa7134/saa7134-dvb.c linux-2.6.25-gentoo-r7/drivers/media/video/saa7134/saa7134-dvb.c
--- linux-2.6.25-gentoo-r7-unmodified/drivers/media/video/saa7134/saa7134-dvb.c	2008-07-25 21:03:52.000000000 +0200
+++ linux-2.6.25-gentoo-r7/drivers/media/video/saa7134/saa7134-dvb.c	2008-07-25 11:05:22.000000000 +0200
@@ -39,6 +39,7 @@
 #include "tda1004x.h"
 #include "nxt200x.h"
 
+#include "qt1010.h"
 #include "tda10086.h"
 #include "tda826x.h"
 #include "tda827x.h"
@@ -146,6 +147,25 @@ static int mt352_aver777_init(struct dvb
 	return 0;
 }
 
+static int mt352_videomate_100_init(struct dvb_frontend* fe)
+{
+	static u8 clock_config []  = { CLOCK_CTL,  0x38, 0x2d };
+	static u8 reset []         = { RESET,      0x80 };
+	static u8 adc_ctl_1_cfg [] = { ADC_CTL_1,  0x40 };//0x40 // 40-43 ,00, ff, 80 , 20
+	static u8 agc_cfg []       = { AGC_TARGET, 0x28, 0xa0 }; // 0x28,0xa0
+	static u8 capt_range_cfg[] = { CAPT_RANGE, 0x50 };	// 0x50
+
+	mt352_write(fe, clock_config,   sizeof(clock_config));
+	udelay(400);
+	mt352_write(fe, reset,          sizeof(reset));	
+	mt352_write(fe, adc_ctl_1_cfg,  sizeof(adc_ctl_1_cfg));
+	mt352_write(fe, agc_cfg,        sizeof(agc_cfg));	
+	mt352_write(fe, capt_range_cfg, sizeof(capt_range_cfg));
+	
+	
+	return 0;
+}
+
 static int mt352_pinnacle_tuner_set_params(struct dvb_frontend* fe,
 					   struct dvb_frontend_parameters* params)
 {
@@ -188,6 +208,14 @@ static struct mt352_config avermedia_777
 	.demod_init    = mt352_aver777_init,
 };
 
+static struct mt352_config videomate_T100 = {
+	.demod_address = 0xf,
+	.adc_clock = 20480,
+	.if2 = 36166,
+	.no_tuner = 1,
+	.demod_init    = mt352_videomate_100_init,
+};
+
 /* ==================================================================
  * tda1004x based DVB-T cards, helper functions
  */
@@ -309,6 +337,10 @@ static int philips_tu1216_init(struct dv
 	return 0;
 }
 
+static struct qt1010_config videomate_t100_qt1010_config = {
+	.i2c_address = 0x62
+};
+
 /* ------------------------------------------------------------------ */
 
 static struct tda1004x_config philips_tu1216_60_config = {
@@ -937,6 +969,17 @@ static int dvb_init(struct saa7134_dev *
 			dev->dvb.frontend->ops.tuner_ops.set_params = philips_tda6651_pll_set;
 		}
 		break;
+	case SAA7134_BOARD_VIDEOMATE_DVBT_100:		
+		dev->dvb.frontend = dvb_attach(mt352_attach, &videomate_T100, &dev->i2c_adap);
+		if (dev->dvb.frontend)
+		{
+			dvb_attach(qt1010_attach, dev->dvb.frontend, &dev->i2c_adap,  &videomate_t100_qt1010_config);
+		}
+		else
+		{
+			printk(KERN_INFO "* * * dvb_attach for demodulator mt352 FAILED no frontend created\n");
+		}
+	break;
 	case SAA7134_BOARD_KWORLD_DVBT_210:
 		configure_tda827x_fe(dev, &kworld_dvb_t_210_config);
 		break;
diff -upr --exclude='*.o' --exclude='*.ko' --exclude='*.mod.c' --exclude='*.o.*' linux-2.6.25-gentoo-r7-unmodified/drivers/media/video/saa7134/saa7134.h linux-2.6.25-gentoo-r7/drivers/media/video/saa7134/saa7134.h
--- linux-2.6.25-gentoo-r7-unmodified/drivers/media/video/saa7134/saa7134.h	2008-07-25 21:03:52.000000000 +0200
+++ linux-2.6.25-gentoo-r7/drivers/media/video/saa7134/saa7134.h	2008-07-25 10:32:21.000000000 +0200
@@ -254,6 +254,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_BEHOLD_M6		130
 #define SAA7134_BOARD_TWINHAN_DTV_DVB_3056 131
 #define SAA7134_BOARD_GENIUS_TVGO_A11MCE 132
+#define SAA7134_BOARD_VIDEOMATE_DVBT_100  150
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8

--------------030501070603040902090303
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------030501070603040902090303--
