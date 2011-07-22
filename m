Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:34211 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751943Ab1GVQjp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 12:39:45 -0400
Cc: rglowery@exemail.com.au
Content-Type: text/plain; charset="utf-8"
Date: Fri, 22 Jul 2011 18:39:40 +0200
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20110722163940.169950@gmx.net>
MIME-Version: 1.0
Subject: [PATCH v2] tuner_xc2028: Allow selection of the frequency adjustment
 code for XC3028
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since many, many kernel releases my Hauppauge WinTV HVR-1400 doesn't work
anymore, and nobody feels responsible to fix it.
The code to get it work is still in there, it's only commented out.
My patch to enable it was rejected, because somebody had fear that it could
break other cards.
So here is a new patch, that allows you to select the frequency adjustment
code by a module parameter. Default is the old code, so it can't break
anything.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff -urN linux-3.0.orig/drivers/media/common/tuners/tuner-xc2028.c linux-3.0/drivers/media/common/tuners/tuner-xc2028.c
--- linux-3.0.orig/drivers/media/common/tuners/tuner-xc2028.c	2011-07-22 04:17:23.000000000 +0200
+++ linux-3.0/drivers/media/common/tuners/tuner-xc2028.c	2011-07-22 18:31:20.181449782 +0200
@@ -54,6 +54,11 @@
 MODULE_PARM_DESC(firmware_name, "Firmware file name. Allows overriding the "
 				"default firmware name\n");
 
+static int frequency_magic;
+module_param(frequency_magic, int, 0644);
+MODULE_PARM_DESC(frequency_magic, "Selects the frequency adjustment code "
+				  "for XC3028. Set it to 1 if tuning fails.");
+
 static LIST_HEAD(hybrid_tuner_instance_list);
 static DEFINE_MUTEX(xc2028_list_mutex);
 
@@ -967,34 +972,36 @@
 		 * newer firmwares
 		 */
 
-#if 1
-		/*
-		 * The proper adjustment would be to do it at s-code table.
-		 * However, this didn't work, as reported by
-		 * Robert Lowery <rglowery@exemail.com.au>
-		 */
-
-		if (priv->cur_fw.type & DTV7)
-			offset += 500000;
-
-#else
-		/*
-		 * Still need tests for XC3028L (firmware 3.2 or upper)
-		 * So, for now, let's just comment the per-firmware
-		 * version of this change. Reports with xc3028l working
-		 * with and without the lines bellow are welcome
-		 */
+		if (!frequency_magic) {
+			/*
+			 * The proper adjustment would be to do it at s-code
+			 * table. However, this didn't work, as reported by
+			 * Robert Lowery <rglowery@exemail.com.au>
+			 */
 
-		if (priv->firm_version < 0x0302) {
 			if (priv->cur_fw.type & DTV7)
 				offset += 500000;
+
 		} else {
-			if (priv->cur_fw.type & DTV7)
-				offset -= 300000;
-			else if (type != ATSC) /* DVB @6MHz, DTV 8 and DTV 7/8 */
-				offset += 200000;
+			/*
+			 * Still need tests for XC3028L (firmware 3.2 or upper)
+			 * So, for now, let's just comment the per-firmware
+			 * version of this change. Reports with xc3028l working
+			 * with and without the lines bellow are welcome
+			 */
+
+			if (priv->firm_version < 0x0302) {
+				if (priv->cur_fw.type & DTV7)
+					offset += 500000;
+			} else {
+				if (priv->cur_fw.type & DTV7)
+					offset -= 300000;
+				else if (type != ATSC) {
+					/* DVB @6MHz, DTV 8 and DTV 7/8 */
+					offset += 200000;
+				}
+			}
 		}
-#endif
 	}
 
 	div = (freq - offset + DIV / 2) / DIV;
