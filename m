Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:2394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab0LQRWM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 12:22:12 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBHHMB0A022230
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 17 Dec 2010 12:22:12 -0500
Received: from [10.3.232.172] (vpn-232-172.phx2.redhat.com [10.3.232.172])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBHHMAOK024018
	for <linux-media@vger.kernel.org>; Fri, 17 Dec 2010 12:22:11 -0500
Message-ID: <4D0B9C41.8030704@redhat.com>
Date: Fri, 17 Dec 2010 15:22:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] cx231xx: Fix inverted bits for RC on PV Hybrid
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

At Pixelview SBTVD Hybrid, the bits sent by the IR are inverted. Due to that,
the existing keytables produce wrong codes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-input.c b/drivers/media/video/cx231xx/cx231xx-input.c
index c236a4e..45e14ca 100644
--- a/drivers/media/video/cx231xx/cx231xx-input.c
+++ b/drivers/media/video/cx231xx/cx231xx-input.c
@@ -27,7 +27,7 @@
 static int get_key_isdbt(struct IR_i2c *ir, u32 *ir_key,
 			 u32 *ir_raw)
 {
-	u8	cmd;
+	u8	cmd, scancode;
 
 	dev_dbg(&ir->rc->input_dev->dev, "%s\n", __func__);
 
@@ -42,10 +42,21 @@ static int get_key_isdbt(struct IR_i2c *ir, u32 *ir_key,
 	if (cmd == 0xff)
 		return 0;
 
-	dev_dbg(&ir->rc->input_dev->dev, "scancode = %02x\n", cmd);
-
-	*ir_key = cmd;
-	*ir_raw = cmd;
+	scancode =
+		 ((cmd & 0x01) ? 0x80 : 0) |
+		 ((cmd & 0x02) ? 0x40 : 0) |
+		 ((cmd & 0x04) ? 0x20 : 0) |
+		 ((cmd & 0x08) ? 0x10 : 0) |
+		 ((cmd & 0x10) ? 0x08 : 0) |
+		 ((cmd & 0x20) ? 0x04 : 0) |
+		 ((cmd & 0x40) ? 0x02 : 0) |
+		 ((cmd & 0x80) ? 0x01 : 0);
+
+	dev_dbg(&ir->rc->input_dev->dev, "cmd %02x, scan = %02x\n",
+		cmd, scancode);
+
+	*ir_key = scancode;
+	*ir_raw = scancode;
 	return 1;
 }
 
