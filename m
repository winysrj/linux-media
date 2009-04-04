Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:43329 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbZDDMao (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2009 08:30:44 -0400
Date: Sat, 4 Apr 2009 14:30:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Andy Walls <awalls@radix.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>
Subject: [PATCH 5/6] saa7134: Simplify handling of IR on MSI TV@nywhere Plus
Message-ID: <20090404143036.0df137fd@hyperion.delvare>
In-Reply-To: <20090404142427.6e81f316@hyperion.delvare>
References: <20090404142427.6e81f316@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we instantiate I2C IR devices explicitly, we can skip probing
altogether on boards where the I2C IR device address is known. The MSI
TV@nywhere Plus is one of these boards.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 linux/drivers/media/video/saa7134/saa7134-input.c |   27 +++++----------------
 1 file changed, 7 insertions(+), 20 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-input.c	2009-04-04 10:07:49.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c	2009-04-04 10:22:14.000000000 +0200
@@ -691,16 +691,6 @@ void saa7134_probe_i2c_ir(struct saa7134
 		I2C_CLIENT_END
 	};
 
-	const unsigned short addr_list_msi[] = {
-		0x30, I2C_CLIENT_END
-	};
-	struct i2c_msg msg_msi = {
-		.addr = 0x50,
-		.flags = I2C_M_RD,
-		.len = 0,
-		.buf = NULL,
-	};
-
 	unsigned char subaddr, data;
 	struct i2c_msg msg_avermedia[] = { {
 		.addr = 0x40,
@@ -747,6 +737,7 @@ void saa7134_probe_i2c_ir(struct saa7134
 		init_data.name = "MSI TV@nywhere Plus";
 		init_data.get_key = get_key_msi_tvanywhere_plus;
 		init_data.ir_codes = ir_codes_msi_tvanywhere_plus;
+		info.addr = 0x30;
 		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 		init_data.name = "HVR 1110";
@@ -766,18 +757,14 @@ void saa7134_probe_i2c_ir(struct saa7134
 
 	if (init_data.name)
 		info.platform_data = &init_data;
-	client = i2c_new_probed_device(&dev->i2c_adap, &info, addr_list);
-	if (client)
+	/* No need to probe if address is known */
+	if (info.addr) {
+		i2c_new_device(&dev->i2c_adap, &info);
 		return;
+	}
 
-	/* MSI TV@nywhere Plus controller doesn't seem to
-	   respond to probes unless we read something from
-	   an existing device. Weird... */
-	rc = i2c_transfer(&dev->i2c_adap, &msg_msi, 1);
-	dprintk(KERN_DEBUG "probe 0x%02x @ %s: %s\n",
-		msg_msi.addr, dev->i2c_adap.name,
-		(1 == rc) ? "yes" : "no");
-	client = i2c_new_probed_device(&dev->i2c_adap, &info, addr_list_msi);
+	/* Address not known, fallback to probing */
+	client = i2c_new_probed_device(&dev->i2c_adap, &info, addr_list);
 	if (client)
 		return;
 

-- 
Jean Delvare
