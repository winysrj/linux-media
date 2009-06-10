Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:57905 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbZFJAN2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Jun 2009 20:13:28 -0400
Subject: [PATCH] tuner-xc2028: Fix 7 MHz DVB-T when used with zl10353 demod
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Terry Wu <terrywu2009@gmail.com>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 20:14:12 -0400
Message-Id: <1244592852.3148.44.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All,

The following is a patch that gets 7 MHz DVB-T working for the Leadtek
DVR3100 H.

Any comments?

Regards,
Andy

Signed-off-by: Andy Walls <awalls@radix.net>
Tested-by: Terry Wu <terrywu2009@gmail.com>

diff -r fad35ab59848 linux/drivers/media/common/tuners/tuner-xc2028.c
--- a/linux/drivers/media/common/tuners/tuner-xc2028.c	Fri Jun 05 08:42:27 2009 -0400
+++ b/linux/drivers/media/common/tuners/tuner-xc2028.c	Tue Jun 09 20:10:06 2009 -0400
@@ -1099,8 +1099,13 @@
 	}
 
 	/* All S-code tables need a 200kHz shift */
-	if (priv->ctrl.demod)
+	if (priv->ctrl.demod) {
 		demod = priv->ctrl.demod + 200;
+		/* Terry Wu <terrywu2009@gmail.com> */
+		if (priv->ctrl.demod == XC3028_FE_ZARLINK456 &&
+		    bw == BANDWIDTH_7_MHZ)
+			demod += 500;
+	}
 
 	return generic_set_freq(fe, p->frequency,
 				T_DIGITAL_TV, type, 0, demod);


