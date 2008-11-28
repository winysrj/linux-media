Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.seznam.cz ([77.75.72.43])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thunder.m@email.cz>) id 1L61q6-00079z-NU
	for linux-dvb@linuxtv.org; Fri, 28 Nov 2008 12:48:52 +0100
Message-ID: <492FDA9A.3060206@email.cz>
Date: Fri, 28 Nov 2008 12:48:42 +0100
From: =?UTF-8?B?TWlyZWsgU2x1Z2XFiA==?= <thunder.m@email.cz>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------000500000801010800070400"
Subject: [linux-dvb] Patch for select frontends in system with multiple cards
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
--------------000500000801010800070400
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi, this patch add support for define frontend (satellite or 
terrestrial) in system with more than one cards.

example usage: saa7134-dvb use_frontend=0,1,0,1,1

Mirek Slugen

--------------000500000801010800070400
Content-Type: text/x-patch;
 name="satellite.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="satellite.diff"

diff -Naur v4l-dvb-24bc99070e97.old/linux/drivers/media/video/saa7134/saa7134-dvb.c v4l-dvb-24bc99070e97/linux/drivers/media/video/saa7134/saa7134-dvb.c
--- v4l-dvb-24bc99070e97.old/linux/drivers/media/video/saa7134/saa7134-dvb.c	2008-09-29 07:25:40.000000000 +0200
+++ v4l-dvb-24bc99070e97/linux/drivers/media/video/saa7134/saa7134-dvb.c	2008-10-01 10:25:05.000000000 +0200
@@ -57,8 +57,8 @@
 module_param(antenna_pwr, int, 0444);
 MODULE_PARM_DESC(antenna_pwr,"enable antenna power (Pinnacle 300i)");
 
-static int use_frontend;
-module_param(use_frontend, int, 0644);
+static unsigned int use_frontend[]     = {[0 ... (SAA7134_MAXBOARDS - 1)] = 0 };
+module_param_array(use_frontend, int, NULL, 0644);
 MODULE_PARM_DESC(use_frontend,"for cards with multiple frontends (0: terrestrial, 1: satellite)");
 
 static int debug;
@@ -1061,7 +1061,7 @@
 			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_FLYDVB_TRIO:
-		if (!use_frontend) {	/* terrestrial */
+		if (!use_frontend[dev->nr]) {	/* terrestrial */
 			if (configure_tda827x_fe(dev, &lifeview_trio_config,
 						 &tda827x_cfg_0) < 0)
 				goto dettach_frontend;
@@ -1103,7 +1103,7 @@
 			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_MEDION_MD8800_QUADRO:
-		if (!use_frontend) {     /* terrestrial */
+		if (!use_frontend[dev->nr]) {     /* terrestrial */
 			if (configure_tda827x_fe(dev, &md8800_dvbt_config,
 						 &tda827x_cfg_0) < 0)
 				goto dettach_frontend;
@@ -1315,7 +1315,7 @@
 		attach_xc3028 = 1;
 		break;
 	case SAA7134_BOARD_ASUSTeK_TIGER_3IN1:
-		if (!use_frontend) {     /* terrestrial */
+		if (!use_frontend[dev->nr]) {     /* terrestrial */
 			if (configure_tda827x_fe(dev, &asus_tiger_3in1_config,
 							&tda827x_cfg_2) < 0)
 				goto dettach_frontend;
@@ -1410,7 +1410,7 @@
 		/* otherwise we don't detect the tuner on next insmod */
 		saa7134_i2c_call_clients(dev, TUNER_SET_CONFIG, &tda9887_cfg);
 	} else if (dev->board == SAA7134_BOARD_MEDION_MD8800_QUADRO) {
-		if ((dev->eedata[2] == 0x07) && use_frontend) {
+		if ((dev->eedata[2] == 0x07) && use_frontend[dev->nr]) {
 			/* turn off the 2nd lnb supply */
 			u8 data = 0x80;
 			struct i2c_msg msg = {.addr = 0x08, .buf = &data, .flags = 0, .len = 1};

--------------000500000801010800070400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------000500000801010800070400--
