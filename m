Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:62797 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab0APQWE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 11:22:04 -0500
Message-ID: <4B51E7A7.8000507@freemail.hu>
Date: Sat, 16 Jan 2010 17:21:59 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Srinivasa Deevi <srinivasa.deevi@conexant.com>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] cx231xx: cleanup dvb_attach() return value handling
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Remove the following sparse error (see "make C=1"):
 * error: incompatible types for operation (<)
       left side has type struct dvb_frontend *
       right side has type int

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 5bcdcc072b6d linux/drivers/media/video/cx231xx/cx231xx-dvb.c
--- a/linux/drivers/media/video/cx231xx/cx231xx-dvb.c	Sat Jan 16 07:25:43 2010 +0100
+++ b/linux/drivers/media/video/cx231xx/cx231xx-dvb.c	Sat Jan 16 17:21:06 2010 +0100
@@ -465,9 +465,9 @@
 		/* define general-purpose callback pointer */
 		dvb->frontend->callback = cx231xx_tuner_callback;

-		if (dvb_attach(xc5000_attach, dev->dvb->frontend,
+		if (!dvb_attach(xc5000_attach, dev->dvb->frontend,
 			       &dev->i2c_bus[1].i2c_adap,
-			       &cnxt_rde250_tunerconfig) < 0) {
+			       &cnxt_rde250_tunerconfig)) {
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -487,9 +487,9 @@
 		/* define general-purpose callback pointer */
 		dvb->frontend->callback = cx231xx_tuner_callback;

-		if (dvb_attach(xc5000_attach, dev->dvb->frontend,
+		if (!dvb_attach(xc5000_attach, dev->dvb->frontend,
 			       &dev->i2c_bus[1].i2c_adap,
-			       &cnxt_rde250_tunerconfig) < 0) {
+			       &cnxt_rde250_tunerconfig)) {
 			result = -EINVAL;
 			goto out_free;
 		}
