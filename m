Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:48146 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab0EHQGd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 May 2010 12:06:33 -0400
Received: by ey-out-2122.google.com with SMTP id d26so169004eyd.19
        for <linux-media@vger.kernel.org>; Sat, 08 May 2010 09:06:31 -0700 (PDT)
Received: from emard by z60m.lan with local (Exim 4.71)
	(envelope-from <emard@z60m>)
	id 1OAmXs-0001mP-NZ
	for linux-media@vger.kernel.org; Sat, 08 May 2010 18:06:28 +0200
Date: Sat, 8 May 2010 18:06:28 +0200
From: Emard <davoremard@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] Compro Videomate T750F Vista digital+analog support
Message-ID: <20100508160628.GA6050@z60m>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI

I've been fixing this driver a bit in order to unify dvb-t and
loading of xc2028 firmware for analog tv and fm radio without 
failure when cold booted directly to linux 

(some say that xc2028 would load if card is "prepared" by previously 
boothing window$ but franky I was too bothered to go this far)

So this is my v07 of the patch that even registers IR remote device
(I copied the code for compro S350)
but it recognizes remote IR keypresses but all keys are the same - 
generate the same GPIO value thus having same keycode 0x3f so it's 
not too useable right now if you want a remote with more than one 
button.

Can someone knowlegeable of saa7134 remotes review the code and suggest 
some fix?

--- linux-2.6.33.3/drivers/media/video/saa7134/saa7134-cards.c.orig	2010-05-08 16:13:28.000000000 +0200
+++ linux-2.6.33.3/drivers/media/video/saa7134/saa7134-cards.c	2010-05-08 16:46:19.000000000 +0200
@@ -4885,8 +4885,9 @@ struct saa7134_board saa7134_boards[] =
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_XC2028,
 		.radio_type     = UNSET,
-		.tuner_addr	= ADDR_UNSET,
+		.tuner_addr	= 0x61,
 		.radio_addr	= ADDR_UNSET,
+		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
 			.name   = name_tv,
 			.vmux   = 3,
@@ -6550,6 +6551,11 @@ static int saa7134_xc2028_callback(struc
 			msleep(10);
 			saa7134_set_gpio(dev, 18, 1);
 		break;
+		case SAA7134_BOARD_VIDEOMATE_T750:
+			saa7134_set_gpio(dev, 20, 0);
+			msleep(10);
+			saa7134_set_gpio(dev, 20, 1);
+		break;
 		}
 	return 0;
 	}
@@ -6956,6 +6962,11 @@ int saa7134_board_init1(struct saa7134_d
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
 		break;
+	case SAA7134_BOARD_VIDEOMATE_T750:
+		dev->has_remote = SAA7134_REMOTE_GPIO;
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
+		break;
 	}
 	return 0;
 }
@@ -7192,6 +7203,7 @@ int saa7134_board_init2(struct saa7134_d
 	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
 	case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:
 	case SAA7134_BOARD_CREATIX_CTX953:
+	case SAA7134_BOARD_VIDEOMATE_T750:
 	{
 		/* this is a hybrid board, initialize to analog mode
 		 * and configure firmware eeprom address
--- linux-2.6.33.3/drivers/media/video/saa7134/saa7134-dvb.c.orig	2010-05-08 16:20:12.000000000 +0200
+++ linux-2.6.33.3/drivers/media/video/saa7134/saa7134-dvb.c	2010-05-08 16:21:10.000000000 +0200
@@ -55,6 +55,7 @@
 #include "tda8290.h"
 
 #include "zl10353.h"
+#include "qt1010.h"
 
 #include "zl10036.h"
 #include "zl10039.h"
@@ -886,6 +887,17 @@ static struct zl10353_config behold_x7_c
 	.disable_i2c_gate_ctrl = 1,
 };
 
+static struct zl10353_config videomate_t750_zl10353_config = {
+       .demod_address  = 0x0f,
+       .no_tuner = 1,
+       .parallel_ts = 1,
+};
+
+static struct qt1010_config videomate_t750_qt1010_config = {
+       .i2c_address = 0x62
+};
+
+
 /* ==================================================================
  * tda10086 based DVB-S cards, helper functions
  */
@@ -1556,6 +1568,26 @@ static int dvb_init(struct saa7134_dev *
 					__func__);
 
 		break;
+        /*FIXME: What frontend does Videomate T750 use? */
+        case SAA7134_BOARD_VIDEOMATE_T750:
+                printk("Compro VideoMate T750 DVB setup\n");
+                fe0->dvb.frontend = dvb_attach(zl10353_attach,
+                                                &videomate_t750_zl10353_config,
+                                                &dev->i2c_adap);
+                if (fe0->dvb.frontend != NULL) {
+                        printk("Attaching pll\n");
+                        // if there is a gate function then the i2c bus breaks.....!
+                        fe0->dvb.frontend->ops.i2c_gate_ctrl = 0;
+ 
+                        if (dvb_attach(qt1010_attach,
+                                       fe0->dvb.frontend,
+                                       &dev->i2c_adap,
+                                       &videomate_t750_qt1010_config) == NULL)
+                        {
+                                wprintk("error attaching QT1010\n");
+                        }
+                }
+                break;
 	case SAA7134_BOARD_ZOLID_HYBRID_PCI:
 		fe0->dvb.frontend = dvb_attach(tda10048_attach,
 					       &zolid_tda10048_config,
--- linux-2.6.33.3/drivers/media/video/saa7134/saa7134-input.c.orig	2010-05-08 16:52:20.000000000 +0200
+++ linux-2.6.33.3/drivers/media/video/saa7134/saa7134-input.c	2010-05-08 17:28:48.000000000 +0200
@@ -671,6 +671,11 @@ int saa7134_input_init1(struct saa7134_d
 		mask_keycode = 0x003f00;
 		mask_keydown = 0x040000;
 		break;
+	case SAA7134_BOARD_VIDEOMATE_T750:
+		ir_codes     = &ir_codes_videomate_s350_table;
+		mask_keycode = 0x003f00;
+		mask_keydown = 0x040000;
+		break;
 	case SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S:
 		ir_codes     = &ir_codes_winfast_table;
 		mask_keycode = 0x5f00;
