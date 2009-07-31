Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.work.de ([212.12.32.49]:56213 "EHLO smtp.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbZGaQvz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 12:51:55 -0400
Received: from [82.83.146.110] (helo=[192.168.0.106])
	by smtp.work.de with esmtpa (Exim 4.63)
	(envelope-from <julian@jusst.de>)
	id 1MWv9v-00019o-65
	for linux-media@vger.kernel.org; Fri, 31 Jul 2009 18:40:43 +0200
Message-ID: <4A731E8B.4030005@jusst.de>
Date: Fri, 31 Jul 2009 18:40:43 +0200
From: Julian Scheel <julian@jusst.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Fix lowband tuning with tda8261
Content-Type: multipart/mixed;
 boundary="------------080802000603050206010307"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080802000603050206010307
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Attached is a patch which fixes tuning to low frequency channels with 
stb0899+tda8261 cards like the KNC TV-Station DVB-S2.
The cause of the issue was a broken if construct, which should have been 
an if/else if, so that the setting for the lowest matching frequency is 
applied.

Without this patch for example tuning to "arte" on Astra 19.2, 10744MHz 
SR22000 failed most times and when it failed the communication between 
driver and tda8261 was completely broken.
This problem disappears with the attached patch.

--------------080802000603050206010307
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="fix_tda8261_lowband.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix_tda8261_lowband.patch"

diff -r 6477aa1782d5 linux/drivers/media/dvb/frontends/tda8261.c
--- a/linux/drivers/media/dvb/frontends/tda8261.c	Tue Jul 21 09:17:24 2009 -0300
+++ b/linux/drivers/media/dvb/frontends/tda8261.c	Fri Jul 31 18:36:07 2009 +0200
@@ -136,9 +136,9 @@
 
 		if (frequency < 1450000)
 			buf[3] = 0x00;
-		if (frequency < 2000000)
+		else if (frequency < 2000000)
 			buf[3] = 0x40;
-		if (frequency < 2150000)
+		else if (frequency < 2150000)
 			buf[3] = 0x80;
 
 		/* Set params */

--------------080802000603050206010307--
