Return-path: <mchehab@pedra>
Received: from tur.go2.pl ([193.17.41.50]:34327 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326Ab0JYR7y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Oct 2010 13:59:54 -0400
Received: from moh1-ve1.go2.pl (moh1-ve3.go2.pl [193.17.41.134])
	by tur.go2.pl (o2.pl Mailer 2.0.1) with ESMTP id 47867230C65
	for <linux-media@vger.kernel.org>; Mon, 25 Oct 2010 19:59:53 +0200 (CEST)
Received: from moh1-ve1.go2.pl (unknown [10.0.0.134])
	by moh1-ve1.go2.pl (Postfix) with ESMTP id B4860570213
	for <linux-media@vger.kernel.org>; Mon, 25 Oct 2010 19:59:10 +0200 (CEST)
Received: from unknown (unknown [10.0.0.42])
	by moh1-ve1.go2.pl (Postfix) with SMTP
	for <linux-media@vger.kernel.org>; Mon, 25 Oct 2010 19:59:10 +0200 (CEST)
Message-ID: <4CC5C568.4090809@o2.pl>
Date: Mon, 25 Oct 2010 19:59:04 +0200
From: Maciej Szmigiero <mhej@o2.pl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [V4L][SAA7134] fix tda9887 detection on cold and eeprom read corruption
 on warm Medion 7134
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

[V4L][SAA7134] fix tda9887 detection on cold and eeprom read corruption on warm Medion 7134

When Medion 7134 analog+DVB-T card is cold (after powerup) the tda9887 analog demodulator
won't show on i2c bus.
This results in no signal on analog TV. After loading driver for second time
eeprom (required for tuner autodetection) read is corrupted, but tda9987 is detected
properly and analog TV works when tuner model is forced.

Fix tda9887 problem by moving its detect code after tuner setup which unhides it.
The eeprom read issue is fixed by opening i2c gate in DVB-T demodulator.

Tested on Medion 7134 and also tested for reference on Typhoon Cardbus Hybrid
(which also uses saa7134 driver).

Signed-off-by: Maciej Szmigiero <mhej@o2.pl>

--- a/drivers/media/video/saa7134/saa7134-cards.c	2010-08-02 00:11:14.000000000 +0200
+++ b/drivers/media/video/saa7134/saa7134-cards.c	2010-10-25 19:19:08.000000000 +0200
@@ -7249,12 +7249,37 @@
 		break;
 	case SAA7134_BOARD_MD7134:
 	{
-		u8 subaddr;
+		u8 subaddr, dmdregval;
 		u8 data[3];
 		int ret, tuner_t;
+		struct i2c_msg i2cgatemsg_r[] = { {.addr = 0x08, .flags = 0,
+						.buf = &subaddr, .len = 1},
+						{.addr = 0x08,
+							.flags = I2C_M_RD,
+						.buf = &dmdregval, .len = 1} };
+		struct i2c_msg i2cgatemsg_w[] = { {.addr = 0x08, .flags = 0,
+						.buf = data, .len = 2} };
 		struct i2c_msg msg[] = {{.addr=0x50, .flags=0, .buf=&subaddr, .len = 1},
 					{.addr=0x50, .flags=I2C_M_RD, .buf=data, .len = 3}};
 
+		/* open i2c gate in DVB-T demod */
+		/* so eeprom read won't be corrupted */
+		subaddr = 0x7;
+		ret = i2c_transfer(&dev->i2c_adap, i2cgatemsg_r, 2);
+		if ((ret == 2) && (dmdregval & 0x2)) {
+			printk(KERN_NOTICE "%s DVB-T demod i2c gate was left"
+						    " closed\n", dev->name);
+			printk(KERN_NOTICE "%s previous informational"
+					    " EEPROM read might have been"
+					    " corrupted\n", dev->name);
+
+			data[0] = 0x7;
+			data[1] = (dmdregval & ~0x2);
+			if (i2c_transfer(&dev->i2c_adap, i2cgatemsg_w, 1) != 1)
+				printk(KERN_ERR "early i2c gate"
+						" open failure\n");
+		}
+
 		subaddr= 0x14;
 		tuner_t = 0;
 
@@ -7522,10 +7547,6 @@
 			v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_adap, "tuner", "tuner",
 				dev->radio_addr, NULL);
-		if (has_demod)
-			v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, "tuner", "tuner",
-				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
 		if (dev->tuner_addr == ADDR_UNSET) {
 			enum v4l2_i2c_tuner_type type =
 				has_demod ? ADDRS_TV_WITH_DEMOD : ADDRS_TV;
@@ -7542,6 +7563,15 @@
 
 	saa7134_tuner_setup(dev);
 
+	/* some cards (Medion 7134 for example) needs tuner to be setup */
+	/* before tda9887 shows itself on i2c bus */
+	if ((TUNER_ABSENT != dev->tuner_type)
+			&& (dev->tda9887_conf & TDA9887_PRESENT)) {
+		v4l2_i2c_new_subdev(&dev->v4l2_dev,
+			&dev->i2c_adap, "tuner", "tuner",
+			0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
+	}
+
 	switch (dev->board) {
 	case SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM:
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:


