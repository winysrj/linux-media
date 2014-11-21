Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46899 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbaKUPNw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 10:13:52 -0500
Received: by mail-wg0-f50.google.com with SMTP id k14so6713368wgh.23
        for <linux-media@vger.kernel.org>; Fri, 21 Nov 2014 07:13:45 -0800 (PST)
Date: Fri, 21 Nov 2014 14:21:40 +0100
From: Abel Moyo <abelmoyo.ab@gmail.com>
To: jarod@wilsonet.com
Cc: m.chehab@samsung.com, devel@driverdev.osuosl.org,
	linux-media@vger.kernel.org
Subject: [PATCH] Staging: media: lirc: lirc_serial: replaced printk with
 pr_debug
Message-ID: <20141121132137.GA23740@gentoodev.infor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replaced printk with pr_debug in dprintk

Signed-off-by: Abel Moyo <abelmoyo.ab@gmail.com>
---
 drivers/staging/media/lirc/lirc_serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 181b92b..86c5274 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -116,7 +116,7 @@ static bool txsense;	/* 0 = active high, 1 = active low */
 #define dprintk(fmt, args...)					\
 	do {							\
 		if (debug)					\
-			printk(KERN_DEBUG LIRC_DRIVER_NAME ": "	\
+			pr_debug(LIRC_DRIVER_NAME ": "		\
 			       fmt, ## args);			\
 	} while (0)
 
-- 
1.8.5.5

