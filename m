Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:60766 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750947Ab1AWAQS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jan 2011 19:16:18 -0500
Content-Type: text/plain; charset="utf-8"
Date: Sun, 23 Jan 2011 01:16:15 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20110123001615.86290@gmx.net>
MIME-Version: 1.0
Subject: [RFC PATCH] Getting Hauppauge WinTV HVR-1400 (XC3028L) to work
To: linux-media@vger.kernel.org, rglowery@exemail.com.au
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With this patch my DVB-T receiver works now like before 2.6.34, only the
first four tunings fails, after that all works fine.
The code was still in there, only commented out. As the original author
says, please test it with different XC3028 hardware. If no one has problems
with it, please commit it.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff -urNp linux-2.6.37.orig/drivers/media/common/tuners/tuner-xc2028.c linux-2.6.37/drivers/media/common/tuners/tuner-xc2028.c
--- linux-2.6.37.orig/drivers/media/common/tuners/tuner-xc2028.c	2011-01-22 23:46:57.000000000 +0100
+++ linux-2.6.37/drivers/media/common/tuners/tuner-xc2028.c	2011-01-22 23:51:33.000000000 +0100
@@ -967,7 +967,7 @@ static int generic_set_freq(struct dvb_f
 		 * newer firmwares
 		 */
 
-#if 1
+#if 0
 		/*
 		 * The proper adjustment would be to do it at s-code table.
 		 * However, this didn't work, as reported by
