Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:65338 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbZJBN1l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2009 09:27:41 -0400
Received: from localhost (localhost [127.0.0.1])
	by poutre.nerim.net (Postfix) with ESMTP id 9753439DE65
	for <linux-media@vger.kernel.org>; Fri,  2 Oct 2009 15:27:42 +0200 (CEST)
Received: from poutre.nerim.net ([127.0.0.1])
	by localhost (poutre.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B6dxEEteKh5J for <linux-media@vger.kernel.org>;
	Fri,  2 Oct 2009 15:27:41 +0200 (CEST)
Received: from hyperion.delvare (jdelvare.pck.nerim.net [62.212.121.182])
	by poutre.nerim.net (Postfix) with ESMTP id 74B0439DE6C
	for <linux-media@vger.kernel.org>; Fri,  2 Oct 2009 15:27:41 +0200 (CEST)
Date: Fri, 2 Oct 2009 15:27:42 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] ir-kbd-i2c: Don't reject unknown I2C addresses
Message-ID: <20091002152742.7c3416bd@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I do not think it makes sense any longer for ir-kbd-i2c to reject
devices at unknown I2C addresses. The caller can provide all the
details about how the device should be handled. Having to add new
addresses to ir-kbd-i2c so that they aren't rejected is a pain we
don't need. Unsupported devices will be spotted a few lines later
anyway.

This already lets us unlist 2 addresses (0x7a and 0x2d) for which
handling details are always provided by the caller (saa7134-input).
Hopefully we can remove more in the future.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 linux/drivers/media/video/ir-kbd-i2c.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/ir-kbd-i2c.c	2009-10-02 14:52:33.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/ir-kbd-i2c.c	2009-10-02 14:58:33.000000000 +0200
@@ -373,7 +373,7 @@ static int ir_probe(struct i2c_client *c
 {
 	struct ir_scancode_table *ir_codes = NULL;
 	const char *name = NULL;
-	int ir_type;
+	int ir_type = 0;
 	struct IR_i2c *ir;
 	struct input_dev *input_dev;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
@@ -438,10 +438,8 @@ static int ir_probe(struct i2c_client *c
 		ir_type     = IR_TYPE_RC5;
 		ir_codes    = &ir_codes_fusionhdtv_mce_table;
 		break;
-	case 0x7a:
 	case 0x47:
 	case 0x71:
-	case 0x2d:
 		if (adap->id == I2C_HW_B_CX2388x ||
 		    adap->id == I2C_HW_B_CX2341X) {
 			/* Handled by cx88-input */
@@ -466,10 +464,6 @@ static int ir_probe(struct i2c_client *c
 		ir_type     = IR_TYPE_OTHER;
 		ir_codes    = &ir_codes_avermedia_cardbus_table;
 		break;
-	default:
-		dprintk(1, DEVNAME ": Unsupported i2c address 0x%02x\n", addr);
-		err = -ENODEV;
-		goto err_out_free;
 	}
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
@@ -513,7 +507,7 @@ static int ir_probe(struct i2c_client *c
 	}
 
 	/* Make sure we are all setup before going on */
-	if (!name || !ir->get_key || !ir_codes) {
+	if (!name || !ir->get_key || !ir_type || !ir_codes) {
 		dprintk(1, DEVNAME ": Unsupported device at address 0x%02x\n",
 			addr);
 		err = -ENODEV;

-- 
Jean Delvare
