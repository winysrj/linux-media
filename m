Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6CLMntH004221
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 17:22:49 -0400
Received: from mail-in-08.arcor-online.net (mail-in-08.arcor-online.net
	[151.189.21.48])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6CLMWXZ029185
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 17:22:32 -0400
Received: from mail-in-15-z2.arcor-online.net (mail-in-15-z2.arcor-online.net
	[151.189.8.32])
	by mail-in-08.arcor-online.net (Postfix) with ESMTP id B279727B000
	for <video4linux-list@redhat.com>;
	Sat, 12 Jul 2008 23:22:31 +0200 (CEST)
Received: from mail-in-10.arcor-online.net (mail-in-10.arcor-online.net
	[151.189.21.50])
	by mail-in-15-z2.arcor-online.net (Postfix) with ESMTP id 9B175724268
	for <video4linux-list@redhat.com>;
	Sat, 12 Jul 2008 23:22:31 +0200 (CEST)
Received: from [192.168.0.10] (181.126.46.212.adsl.ncore.de [212.46.126.181])
	(Authenticated sender: hermann-pitton@arcor.de)
	by mail-in-10.arcor-online.net (Postfix) with ESMTP id D838224E512
	for <video4linux-list@redhat.com>;
	Sat, 12 Jul 2008 23:22:30 +0200 (CEST)
From: hermann pitton <hermann-pitton@arcor.de>
To: video4linux-list@redhat.com
In-Reply-To: <20080712092931.0099413a@gaivota>
References: <1634623854.65471.1213524197148.JavaMail.apache@mail71.abv.bg>
	<1213562075.2683.79.camel@pc10.localdom.local>
	<20080712092931.0099413a@gaivota>
Content-Type: multipart/mixed; boundary="=-T/RXeyR/BNGbtC6y35Cc"
Date: Sat, 12 Jul 2008 23:18:45 +0200
Message-Id: <1215897525.2987.31.camel@pc10.localdom.local>
Mime-Version: 1.0
Subject: Re: [linux-dvb] ASUS My-Cinema remote patch
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


--=-T/RXeyR/BNGbtC6y35Cc
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

Am Samstag, den 12.07.2008, 09:29 -0300 schrieb Mauro Carvalho Chehab:
> On Sun, 15 Jun 2008 22:34:35 +0200
> hermann pitton <hermann-pitton@arcor.de> wrote:
> 
> > Hi,
> > 
> > Am Sonntag, den 15.06.2008, 13:03 +0300 schrieb Bozhan Boiadzhiev:
> > > 
> > > ok i'll test patch later.
> > > thanks
> > > :)
> > 
> > here is an updated version after latest changes by Matthias and Tim on
> > saa7134. Should work.
> > 
> > Can't do much more on it. 
> > 
> > Hartmut, Mauro, the eeprom detection is very basic, but should work. I
> > sign off so far. Also attached.
> 
> Patch applied. I had to manually fix a conflict with a previously applied one. Please check.
> 
> Cheers,
> Mauro

latest version around with TVFM7135 device name fix was here.

http://www.spinics.net/lists/vfl/msg37290.html

Latest questions on it are in the same thread.

Mauro, almost all my tabs were lost, maybe it works better with
attachments.

Cheers,
Hermann

saa7134: update the Asustek P7131 Analog patch to latest
         version and also try to replace lost tabs.

Signed-off-by: Hermann Pitton <hermann-pitton@arcor.de>











--=-T/RXeyR/BNGbtC6y35Cc
Content-Disposition: inline;
	filename=saa7134_update_Asustek_P7131-Analog-patch.patch
Content-Type: text/x-patch;
	name=saa7134_update_Asustek_P7131-Analog-patch.patch;
	charset=utf-8
Content-Transfer-Encoding: 7bit

diff -r 0ebffe1cc136 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Jul 12 16:50:43 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Jul 12 22:48:11 2008 +0200
@@ -3558,39 +3558,39 @@ struct saa7134_board saa7134_boards[] = 
 			.amux = TV,
 			.gpio = 0x0200000,
 		},
-       },
-       [SAA7134_BOARD_ASUSTeK_P7131_ANALOG] = {
-	       .name           = "ASUSTeK P7131 Analog",
-	       .audio_clock    = 0x00187de7,
-	       .tuner_type     = TUNER_PHILIPS_TDA8290,
-	       .radio_type     = UNSET,
-	       .tuner_addr     = ADDR_UNSET,
-	       .radio_addr     = ADDR_UNSET,
-	       .gpiomask       = 1 << 21,
-	       .inputs         = {{
-		       .name = name_tv,
-		       .vmux = 1,
-		       .amux = TV,
-		       .tv   = 1,
-		       .gpio = 0x0000000,
-	       }, {
-		       .name = name_comp1,
-		       .vmux = 3,
-		       .amux = LINE2,
-	       }, {
-		       .name = name_comp2,
-		       .vmux = 0,
-		       .amux = LINE2,
-	       }, {
-		       .name = name_svideo,
-		       .vmux = 8,
-		       .amux = LINE2,
-	       } },
-	       .radio = {
-		       .name = name_radio,
-		       .amux = TV,
-		       .gpio = 0x0200000,
-	       },
+	},
+	[SAA7134_BOARD_ASUSTeK_P7131_ANALOG] = {
+		.name           = "ASUSTeK P7131 Analog",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.gpiomask       = 1 << 21,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+			.gpio = 0x0000000,
+		}, {
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE2,
+		}, {
+			.name = name_comp2,
+			.vmux = 0,
+			.amux = LINE2,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE2,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x0200000,
+		},
 	},
 	[SAA7134_BOARD_SABRENT_TV_PCB05] = {
 		.name           = "Sabrent PCMCIA TV-PCB05",
@@ -5737,7 +5737,7 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_FLYDVBT_LR301:
 	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
-       case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
+	case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
 	case SAA7134_BOARD_FLYDVBTDUO:
 	case SAA7134_BOARD_PROTEUS_2309:
 	case SAA7134_BOARD_AVERMEDIA_A16AR:
@@ -6078,18 +6078,15 @@ int saa7134_board_init2(struct saa7134_d
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
 		break;
 	}
-#if 0
-	/* FIXME: This entry doesn't exist yet */
-       case SAA7134_BOARD_ASUSTeK_TVFM35:
-       /* The card below is detected as card=53, but is different */
-	       if (dev->autodetected && (dev->eedata[0x27] == 0x03)) {
-		       dev->board = SAA7134_BOARD_ASUSTeK_P7131_ANALOG;
-		       printk(KERN_INFO "%s: P7131 analog only, using "
-						       "entry of %s\n",
-		       dev->name, saa7134_boards[dev->board].name);
-	       }
-	       break;
-#endif
+	case SAA7134_BOARD_ASUSTeK_TVFM7135:
+	/* The card below is detected as card=53, but is different */
+		if (dev->autodetected && (dev->eedata[0x27] == 0x03)) {
+			dev->board = SAA7134_BOARD_ASUSTeK_P7131_ANALOG;
+			printk(KERN_INFO "%s: P7131 analog only, using "
+							"entry of %s\n",
+			dev->name, saa7134_boards[dev->board].name);
+		}
+		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 		hauppauge_eeprom(dev, dev->eedata+0x80);
 		/* break intentionally omitted */
diff -r 0ebffe1cc136 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Sat Jul 12 16:50:43 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Sat Jul 12 22:48:11 2008 +0200
@@ -409,7 +409,7 @@ int saa7134_input_init1(struct saa7134_d
 		break;
 	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
-       case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
+	case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
 		ir_codes     = ir_codes_asus_pc39;
 		mask_keydown = 0x0040000;
 		rc5_gpio = 1;

--=-T/RXeyR/BNGbtC6y35Cc
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-T/RXeyR/BNGbtC6y35Cc--
