Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:53934 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbZJBVtJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2009 17:49:09 -0400
Received: by fxm27 with SMTP id 27so1452778fxm.17
        for <linux-media@vger.kernel.org>; Fri, 02 Oct 2009 14:49:12 -0700 (PDT)
Date: Sat, 3 Oct 2009 00:49:09 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: linux-media@vger.kernel.org
Cc: Oldrich Jedlicka <oldium.pro@seznam.cz>
Subject: AVerTV MCE 116 Plus remote
Message-ID: <20091002214909.GA4761@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Preliminary version of patch adding support for AVerTV MCE 116 Plus remote.
This board has an IR sensor is connected to EM78P153S, general purpose 8-bit
microcontroller with a 1024 × 13 bits of OTP-ROM. According to i2cdetect, it is
sitting on address 0x40.

Patch allows ir-kbd-i2c to probe cx2341x boards for this address. Manually
loading ir-kbd-i2c now detects remote, every key is working as expected.

As I understand, current I2C/probing code is being redesigned/refactored. Sheer
amount of #ifdefs for every second kernel version is making my eyes bleed, so
please somebody involved check if patch is ok. 

Should I also add the 0x40 address to addr_list[] in ivtv-i2c.c? How to point
ivtv to this remote and autoload ir-kbd-i2c?

diff --git a/linux/drivers/media/video/ir-kbd-i2c.c b/linux/drivers/media/video/ir-kbd-i2c.c
--- a/linux/drivers/media/video/ir-kbd-i2c.c
+++ b/linux/drivers/media/video/ir-kbd-i2c.c
@@ -461,7 +461,7 @@
 		}
 		break;
 	case 0x40:
-		name        = "AVerMedia Cardbus remote";
+		name        = "AVerMedia RM-FP/RM-KH remote";
 		ir->get_key = get_key_avermedia_cardbus;
 		ir_type     = IR_TYPE_OTHER;
 		ir_codes    = &ir_codes_avermedia_cardbus_table;
@@ -706,8 +706,12 @@
 			ir_attach(adap, msg.addr, 0, 0);
 	}
 
-	/* Special case for AVerMedia Cardbus remote */
-	if (adap->id == I2C_HW_SAA7134) {
+	/* Special case for AVerMedia remotes:
+	   * AVerTV Hybrid+FM Cardbus
+	   * AVerTV MCE 116 Plus
+	   * probably others with RM-FP, RM-KH remotes and microcontroller
+	     chip @ 0x40 */
+	if ((adap->id == I2C_HW_SAA7134) || (adap->id == I2C_HW_B_CX2341X)) {
 		unsigned char subaddr, data;
 		struct i2c_msg msg[] = { { .addr = 0x40, .flags = 0,
 					   .buf = &subaddr, .len = 1},
