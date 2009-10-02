Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:55393 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825AbZJBMsD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2009 08:48:03 -0400
Received: from localhost (localhost [127.0.0.1])
	by bamako.nerim.net (Postfix) with ESMTP id B5F9439DE4A
	for <linux-media@vger.kernel.org>; Fri,  2 Oct 2009 14:48:03 +0200 (CEST)
Received: from bamako.nerim.net ([127.0.0.1])
	by localhost (bamako.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MueeN84BqOBX for <linux-media@vger.kernel.org>;
	Fri,  2 Oct 2009 14:48:02 +0200 (CEST)
Received: from hyperion.delvare (jdelvare.pck.nerim.net [62.212.121.182])
	by bamako.nerim.net (Postfix) with ESMTP id 96F5239DE5A
	for <linux-media@vger.kernel.org>; Fri,  2 Oct 2009 14:48:02 +0200 (CEST)
Date: Fri, 2 Oct 2009 14:48:04 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] saa7134: Complete the IR address list
Message-ID: <20091002144804.56b0b908@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Google is pretty clear that the HVR 1110 IR chip is always at address
0x71 and the BeholdTV IR chip is always at address 0x2d. This
completes the list of IR device addresses for the SAA7134-based
adapters, and we no longer need to probe any of them.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
Note: this goes on top of the other saa7134 patches I've sent earlier
today.

 linux/drivers/media/video/saa7134/saa7134-input.c |   25 ++++++---------------
 1 file changed, 8 insertions(+), 17 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-input.c	2009-10-02 13:50:12.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c	2009-10-02 14:29:07.000000000 +0200
@@ -746,10 +746,6 @@ void saa7134_probe_i2c_ir(struct saa7134
 {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
 	struct i2c_board_info info;
-	const unsigned short addr_list[] = {
-		0x47, 0x71, 0x2d,
-		I2C_CLIENT_END
-	};
 
 	struct i2c_msg msg_msi = {
 		.addr = 0x50,
@@ -846,6 +842,7 @@ void saa7134_probe_i2c_ir(struct saa7134
 		dev->init_data.name = "HVR 1110";
 		dev->init_data.get_key = get_key_hvr1110;
 		dev->init_data.ir_codes = &ir_codes_hauppauge_new_table;
+		info.addr = 0x71;
 #endif
 		break;
 	case SAA7134_BOARD_BEHOLD_607FM_MK3:
@@ -869,30 +866,24 @@ void saa7134_probe_i2c_ir(struct saa7134
 		dev->init_data.name = "BeholdTV";
 		dev->init_data.get_key = get_key_beholdm6xx;
 		dev->init_data.ir_codes = &ir_codes_behold_table;
+		info.addr = 0x2d;
 #endif
 		break;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
-	default:
-		dprintk("Shouldn't get here: Unknown board %x for I2C IR?\n",dev->board);
-#else
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
 		info.addr = 0x40;
-#endif
 		break;
+#endif
+	default:
+		dprintk("No I2C IR support for board %x\n", dev->board);
+		return;
 	}
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
 	if (dev->init_data.name)
 		info.platform_data = &dev->init_data;
-	/* No need to probe if address is known */
-	if (info.addr) {
-		i2c_new_device(&dev->i2c_adap, &info);
-		return;
-	}
-
-	/* Address not known, fallback to probing */
-	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list);
+	i2c_new_device(&dev->i2c_adap, &info);
 #endif
 }
 

-- 
Jean Delvare
