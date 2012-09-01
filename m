Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:25670 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab2IASyI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Sep 2012 14:54:08 -0400
Date: Sat, 1 Sep 2012 20:53:57 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] mceusb: Optimize DIV_ROUND_CLOSEST call
Message-ID: <20120901205357.1a75d8a1@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DIV_ROUND_CLOSEST is faster if the compiler knows it will only be
dealing with unsigned dividends.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/rc/mceusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.6-rc3.orig/drivers/media/rc/mceusb.c	2012-08-04 21:49:27.000000000 +0200
+++ linux-3.6-rc3/drivers/media/rc/mceusb.c	2012-09-01 18:53:32.053042123 +0200
@@ -627,7 +627,7 @@ static void mceusb_dev_printdata(struct
 			break;
 		case MCE_RSP_EQIRCFS:
 			period = DIV_ROUND_CLOSEST(
-					(1 << data1 * 2) * (data2 + 1), 10);
+					(1U << data1 * 2) * (data2 + 1), 10);
 			if (!period)
 				break;
 			carrier = (1000 * 1000) / period;


-- 
Jean Delvare
