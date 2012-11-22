Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:47470 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab2KVSxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 13:53:42 -0500
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [212.27.42.1])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 60178CA8F38
	for <linux-media@vger.kernel.org>; Thu, 22 Nov 2012 12:47:16 +0100 (CET)
Date: Thu, 22 Nov 2012 12:46:52 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] gspca - ov534: Fix the light frequency filter
Message-ID: <20121122124652.3a832e33@armhf>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(fix lack of signature)
From: Jean-François Moine <moinejf@free.fr>

The exchanges relative to the light frequency filter were adapted
from a description found in a ms-windows driver. It seems that the
registers were the ones of some other sensor.

This patch was done thanks to the documentation of the right
OmniVision sensors.

Note: The light frequency filter is either off or automatic.
The application will see either off or "50Hz" only.

Tested-by: alexander calderon <fabianp902@gmail.com>
Signed-off-by: Jean-François Moine <moinejf@free.fr>

--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -1038,13 +1038,12 @@
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	val = val ? 0x9e : 0x00;
-	if (sd->sensor == SENSOR_OV767x) {
-		sccb_reg_write(gspca_dev, 0x2a, 0x00);
-		if (val)
-			val = 0x9d;	/* insert dummy to 25fps for 50Hz */
-	}
-	sccb_reg_write(gspca_dev, 0x2b, val);
+	if (!val)
+		sccb_reg_write(gspca_dev, 0x13,		/* off */
+				sccb_reg_read(gspca_dev, 0x13) & ~0x20);
+	else
+		sccb_reg_write(gspca_dev, 0x13,		/* auto */
+				sccb_reg_read(gspca_dev, 0x13) | 0x20);
 }
 
 

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
