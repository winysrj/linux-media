Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:45990 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbZDQUeP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 16:34:15 -0400
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1Luvqa-0000xm-6e
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Fri, 17 Apr 2009 23:43:44 +0200
Date: Fri, 17 Apr 2009 22:34:09 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH 6/6] saa7134: Simplify handling of IR on AVerMedia Cardbus
 E506R
Message-ID: <20090417223409.676fab23@hyperion.delvare>
In-Reply-To: <20090417222927.7a966350@hyperion.delvare>
References: <20090417222927.7a966350@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we instantiate I2C IR devices explicitly, we can skip probing
altogether on boards where the I2C IR device address is known. The
AVerMedia Cardbus E506R is one of these boards.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Oldrich Jedlicka <oldium.pro@seznam.cz>
---
 linux/drivers/media/video/saa7134/saa7134-input.c |   32 ++-------------------
 1 file changed, 4 insertions(+), 28 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-input.c	2009-04-17 15:10:55.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c	2009-04-17 15:44:21.000000000 +0200
@@ -699,20 +699,6 @@ void saa7134_probe_i2c_ir(struct saa7134
 		.buf = NULL,
 	};
 
-	unsigned char subaddr, data;
-	struct i2c_msg msg_avermedia[] = { {
-		.addr = 0x40,
-		.flags = 0,
-		.len = 1,
-		.buf = &subaddr,
-	}, {
-		.addr = 0x40,
-		.flags = I2C_M_RD,
-		.len = 1,
-		.buf = &data,
-	} };
-
-	struct i2c_client *client;
 	int rc;
 
 	if (disable_ir) {
@@ -769,6 +755,9 @@ void saa7134_probe_i2c_ir(struct saa7134
 		init_data.get_key = get_key_beholdm6xx;
 		init_data.ir_codes = ir_codes_behold;
 		break;
+	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
+		info.addr = 0x40;
+		break;
 	}
 
 	if (init_data.name)
@@ -780,20 +769,7 @@ void saa7134_probe_i2c_ir(struct saa7134
 	}
 
 	/* Address not known, fallback to probing */
-	client = i2c_new_probed_device(&dev->i2c_adap, &info, addr_list);
-	if (client)
-		return;
-
-	/* Special case for AVerMedia Cardbus remote */
-	subaddr = 0x0d;
-	rc = i2c_transfer(&dev->i2c_adap, msg_avermedia, 2);
-	dprintk(KERN_DEBUG "probe 0x%02x/0x%02x @ %s: %s\n",
-		msg_avermedia[0].addr, subaddr, dev->i2c_adap.name,
-		(2 == rc) ? "yes" : "no");
-	if (2 == rc) {
-		info.addr = msg_avermedia[0].addr;
-		i2c_new_device(&dev->i2c_adap, &info);
-	}
+	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list);
 }
 
 static int saa7134_rc5_irq(struct saa7134_dev *dev)

-- 
Jean Delvare
