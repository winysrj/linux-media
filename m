Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:42426 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbZFKK5F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 06:57:05 -0400
Subject: [PATCH v2] tuner-xc2028: Fix 7 MHz DVB-T
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: Terry Wu <terrywu2009@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 06:57:50 -0400
Message-Id: <1244717870.3158.22.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All,

The following patch should fix 7 MHz DVB-T with the XC3028 using the
DTV7 firmware from the xc3028-v27.fw firmware image.

Comments?

Regards,
Andy Walls

Signed-off-by: Andy Walls <awalls@radix.net>
Tested-by: Terry Wu <terrywu2009@gmail.com>

diff -r fad35ab59848 linux/drivers/media/common/tuners/tuner-xc2028.c
--- a/linux/drivers/media/common/tuners/tuner-xc2028.c	Fri Jun 05 08:42:27 2009 -0400
+++ b/linux/drivers/media/common/tuners/tuner-xc2028.c	Thu Jun 11 06:52:55 2009 -0400
@@ -1099,8 +1099,19 @@
 	}
 
 	/* All S-code tables need a 200kHz shift */
-	if (priv->ctrl.demod)
+	if (priv->ctrl.demod) {
 		demod = priv->ctrl.demod + 200;
+		/*
+		 * The DTV7 S-code table needs a 700 kHz shift.
+		 * Thanks to Terry Wu <terrywu2009@gmail.com> for reporting this
+		 *
+		 * DTV7 is only used in Australia.  Germany or Italy may also
+		 * use this firmware after initialization, but a tune to a UHF
+		 * channel should then cause DTV78 to be used.
+		 */
+		if (type & DTV7)
+			demod += 500;
+	}
 
 	return generic_set_freq(fe, p->frequency,
 				T_DIGITAL_TV, type, 0, demod);


