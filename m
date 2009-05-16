Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:42261 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077AbZEPNIj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 May 2009 09:08:39 -0400
Message-ID: <4A0EBACD.6070601@free.fr>
Date: Sat, 16 May 2009 15:08:29 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, DVB list <linux-dvb@linuxtv.org>
Subject: [PATCH] DIBUSB_MC : fix i2c to not corrupt eeprom in case of strange
 read pattern
References: <484A72D3.7070500@free.fr> <4974E4BE.2060107@free.fr> <20090129074735.76e07d47@caramujo.chehab.org> <alpine.LRH.1.10.0901291117110.15700@pub6.ifh.de> <49820C26.5090309@free.fr> <498215A8.3020203@free.fr>
In-Reply-To: <498215A8.3020203@free.fr>
Content-Type: multipart/mixed;
 boundary="------------040700000202050604000506"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040700000202050604000506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,


dibusb_i2c_xfer seems to do things very dangerous :
it assumes that it get only write/read request or write request.

That means that read can be understood as write. For example a program
doing
file = open("/dev/i2c-x", O_RDWR);
ioctl(file, I2C_SLAVE, 0x50)
read(file, data, 10)
will corrupt the eeprom as it will be understood as a write.

I attach a possible (untested) patch.


Matthieu

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>




--------------040700000202050604000506
Content-Type: text/plain;
 name="dibusb_i2c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dibusb_i2c"

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
Index: linux-2.6/drivers/media/dvb/dvb-usb/dibusb-common.c
===================================================================
--- linux-2.6.orig/drivers/media/dvb/dvb-usb/dibusb-common.c	2009-02-09 20:36:03.000000000 +0100
+++ linux-2.6/drivers/media/dvb/dvb-usb/dibusb-common.c	2009-02-09 20:38:21.000000000 +0100
@@ -133,14 +133,18 @@
 
 	for (i = 0; i < num; i++) {
 		/* write/read request */
-		if (i+1 < num && (msg[i+1].flags & I2C_M_RD)) {
+		if (i+1 < num && (msg[i].flags & I2C_M_RD) == 0
+					  && (msg[i+1].flags & I2C_M_RD)) {
 			if (dibusb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,
 						msg[i+1].buf,msg[i+1].len) < 0)
 				break;
 			i++;
-		} else
+		} else if ((msg[i].flags & I2C_M_RD) == 0) {
 			if (dibusb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,NULL,0) < 0)
 				break;
+		}
+		else
+			break;
 	}
 
 	mutex_unlock(&d->i2c_mutex);


--------------040700000202050604000506--
