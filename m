Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:56773 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbZEaMkI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 08:40:08 -0400
Subject: [PATCH] xc2028: Add support for Taiwan 6 MHz DVB-T
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Terry Wu <terrywu2009@gmail.com>
Content-Type: text/plain
Date: Sun, 31 May 2009 08:41:43 -0400
Message-Id: <1243773703.3133.24.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a patch with changes provided by Terry Wu to support 6 MHz DVB-T
as is deployed in Taiwan.


I took quick look at the changes and they look OK to me, but I'm no
expert on the XC2028/XC3028 deivces.

My one observation is that the change assumes all COFDM frontends can
support QAM (FE_CAN_QAM..).  This is apparently the case looking through
all the Linux supported FE_OFDM frontends, and it seems like a
reasonable assumption to me.


Terry,

Please check the diff below, to make sure I captured all your changes.

For inclusion into the kernel, you will need to provide a
"Signed-off-by:" in a rely to this patch list posting.  Please see:

http://www.linuxtv.org/wiki/index.php/Development:_Submitting_Patches#Developer.27s_Certificate_of_Origin_1.1


Regards,
Andy


diff -r 8291f6042c9a linux/drivers/media/common/tuners/tuner-xc2028.c
--- a/linux/drivers/media/common/tuners/tuner-xc2028.c	Fri May 29 21:19:25 2009 -0400
+++ b/linux/drivers/media/common/tuners/tuner-xc2028.c	Sun May 31 08:29:32 2009 -0400
@@ -925,6 +925,9 @@
 		rc = send_seq(priv, {0x00, 0x00});
 	} else if (priv->cur_fw.type & ATSC) {
 		offset = 1750000;
+	} else if (priv->cur_fw.type & DTV6) {
+		/* For Taiwan DVB-T 6 MHz bandwidth - Terry Wu */
+		offset = 1750000;
 	} else {
 		offset = 2750000;
 		/*
@@ -1026,6 +1029,11 @@
 	switch(fe->ops.info.type) {
 	case FE_OFDM:
 		bw = p->u.ofdm.bandwidth;
+		/* For Taiwan DVB-T 6 MHz bandwidth - Terry Wu */
+		if (bw == BANDWIDTH_6_MHZ) {
+			type |= (DTV6|QAM|D2633);
+			priv->ctrl.type = XC2028_D2633;
+		}
 		break;
 	case FE_QAM:
 		tuner_info("WARN: There are some reports that "


