Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:33951 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbZDDMbs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2009 08:31:48 -0400
Date: Sat, 4 Apr 2009 14:31:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Andy Walls <awalls@radix.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>
Subject: [PATCH 6/6] saa7134: Simplify handling of IR on AVerMedia Cardbus
Message-ID: <20090404143137.46899c20@hyperion.delvare>
In-Reply-To: <20090404142427.6e81f316@hyperion.delvare>
References: <20090404142427.6e81f316@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we instantiate I2C IR devices explicitly, we can skip probing
altogether on boards where the I2C IR device address is known. The
AVerMedia Cardbus are two of these boards.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 linux/drivers/media/video/saa7134/saa7134-input.c |   35 +++------------------
 1 file changed, 5 insertions(+), 30 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-input.c	2009-04-04 10:41:44.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c	2009-04-04 10:47:10.000000000 +0200
@@ -691,22 +691,6 @@ void saa7134_probe_i2c_ir(struct saa7134
 		I2C_CLIENT_END
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
-	int rc;
-
 	if (disable_ir) {
 		dprintk("IR has been disabled, not probing for i2c remote\n");
 		return;
@@ -753,6 +737,10 @@ void saa7134_probe_i2c_ir(struct saa7134
 		init_data.get_key = get_key_beholdm6xx;
 		init_data.ir_codes = ir_codes_behold;
 		break;
+	case SAA7134_BOARD_AVERMEDIA_CARDBUS:
+	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
+		info.addr = 0x40;
+		break;
 	}
 
 	if (init_data.name)
@@ -764,20 +752,7 @@ void saa7134_probe_i2c_ir(struct saa7134
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
