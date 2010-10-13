Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57745 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab0JMH3W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Oct 2010 03:29:22 -0400
Received: by ewy20 with SMTP id 20so1892172ewy.19
        for <linux-media@vger.kernel.org>; Wed, 13 Oct 2010 00:29:21 -0700 (PDT)
Date: Wed, 13 Oct 2010 17:30:10 -0400
From: Dmitri Belimov <d.belimov@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>
Subject: [PATCH] xc5000 and switch RF input
Message-ID: <20101013173010.74ee2827@glory.local>
In-Reply-To: <AANLkTinctdXC5lmzXSkgwjwfIwAH3BNFCWeWMnK3Xi5-@mail.gmail.com>
References: <20100518173011.5d9c7f2c@glory.loctelecom.ru>
 <AANLkTilL60q2PrBGagobWK99dV9OMKldxLiKZafn1oYb@mail.gmail.com>
 <20100525114939.067404eb@glory.loctelecom.ru>
 <4C32044C.3060007@redhat.com>
 <AANLkTinctdXC5lmzXSkgwjwfIwAH3BNFCWeWMnK3Xi5-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/w9sjyt4HEiXNROvNOjxje/w"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--MP_/w9sjyt4HEiXNROvNOjxje/w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Our TV card Behold X7 has two different RF input. This RF inputs can switch between
different RF sources. 

ANT 1 for analog and digital TV
ANT 2 for FM radio

The switch controlled by zl10353.

I add some defines for the tuner xc5000 and use tuner callback to saa7134 part.
All works well. But my patch can touch other TV cards with xc5000.

Devin can you check my changes on the other TV cards.

With my best regards, Dmitry.

--MP_/w9sjyt4HEiXNROvNOjxje/w
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_switch_ant.patch

diff -r 1da5fed5c8b2 linux/drivers/media/common/tuners/xc5000.c
--- a/linux/drivers/media/common/tuners/xc5000.c	Sun Sep 19 02:23:09 2010 -0300
+++ b/linux/drivers/media/common/tuners/xc5000.c	Wed Oct 13 10:49:45 2010 +1000
@@ -903,10 +903,33 @@
 	switch (params->mode) {
 	case V4L2_TUNER_RADIO:
 		ret = xc5000_set_radio_freq(fe, params);
+		if (fe->callback) {
+			fe->callback(((fe->dvb) && (fe->dvb->priv)) ?
+					   fe->dvb->priv :
+					   priv->i2c_props.adap->algo_data,
+					   DVB_FRONTEND_COMPONENT_TUNER,
+					   XC5000_TUNER_SET_RADIO, 0);
+		}
 		break;
 	case V4L2_TUNER_ANALOG_TV:
+		ret = xc5000_set_tv_freq(fe, params);
+		if (fe->callback) {
+			fe->callback(((fe->dvb) && (fe->dvb->priv)) ?
+					   fe->dvb->priv :
+					   priv->i2c_props.adap->algo_data,
+					   DVB_FRONTEND_COMPONENT_TUNER,
+					   XC5000_TUNER_SET_ANALOG_TV, 0);
+		}
+		break;
 	case V4L2_TUNER_DIGITAL_TV:
 		ret = xc5000_set_tv_freq(fe, params);
+		if (fe->callback) {
+			fe->callback(((fe->dvb) && (fe->dvb->priv)) ?
+					   fe->dvb->priv :
+					   priv->i2c_props.adap->algo_data,
+					   DVB_FRONTEND_COMPONENT_TUNER,
+					   XC5000_TUNER_SET_DIGITAL_TV, 0);
+		}
 		break;
 	}
 
diff -r 1da5fed5c8b2 linux/drivers/media/common/tuners/xc5000.h
--- a/linux/drivers/media/common/tuners/xc5000.h	Sun Sep 19 02:23:09 2010 -0300
+++ b/linux/drivers/media/common/tuners/xc5000.h	Wed Oct 13 10:49:45 2010 +1000
@@ -35,6 +35,9 @@
 
 /* xc5000 callback command */
 #define XC5000_TUNER_RESET		0
+#define XC5000_TUNER_SET_RADIO		1
+#define XC5000_TUNER_SET_ANALOG_TV	2
+#define XC5000_TUNER_SET_DIGITAL_TV	3
 
 /* Possible Radio inputs */
 #define XC5000_RADIO_NOT_CONFIGURED		0
diff -r 1da5fed5c8b2 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Sep 19 02:23:09 2010 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Oct 13 10:49:45 2010 +1000
@@ -6842,12 +6842,53 @@
 	case SAA7134_BOARD_BEHOLD_X7:
 	case SAA7134_BOARD_BEHOLD_H7:
 	case SAA7134_BOARD_BEHOLD_A7:
-		if (command == XC5000_TUNER_RESET) {
-		/* Down and UP pheripherial RESET pin for reset all chips */
+		switch (command) {
+		case XC5000_TUNER_RESET:
+			/* Down/UP pheripherial RESET pin for reset all chips */
 			saa_writeb(SAA7134_SPECIAL_MODE, 0x00);
 			msleep(10);
 			saa_writeb(SAA7134_SPECIAL_MODE, 0x01);
 			msleep(10);
+			break;
+		case XC5000_TUNER_SET_RADIO:
+			{
+			static u8 zl10353_ant2_enable[]  = { 0x63, 0x40 };
+			struct i2c_msg zl10353_msg = {.addr = 0x1e >> 1,
+					.flags = 0, .len = 2};
+
+			zl10353_msg.buf = zl10353_ant2_enable;
+
+			/* Switch RF to the ANT2 source */
+			if (i2c_transfer(&dev->i2c_adap, &zl10353_msg, 1) != 1) {
+				printk(KERN_INFO "could not access RF
+					 source control\n");
+				return -EIO;
+				}
+
+			msleep(10);
+			}
+			break;
+		case XC5000_TUNER_SET_ANALOG_TV:
+		case XC5000_TUNER_SET_DIGITAL_TV:
+			{
+			static u8 zl10353_ant1_enable[]  = { 0x63, 0x00 };
+			struct i2c_msg zl10353_msg = {.addr = 0x1e >> 1,
+					.flags = 0, .len = 2};
+
+			zl10353_msg.buf = zl10353_ant1_enable;
+
+			/* Switch RF to the ANT1 source */
+			if (i2c_transfer(&dev->i2c_adap, &zl10353_msg, 1) != 1) {
+				printk(KERN_INFO "could not access RF
+					 source control\n");
+				return -EIO;
+				}
+
+			msleep(10);
+			}
+			break;
+		default:
+			break;
 		}
 		break;
 	default:

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/w9sjyt4HEiXNROvNOjxje/w--
