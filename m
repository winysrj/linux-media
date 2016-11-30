Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f173.google.com ([209.85.210.173]:35461 "EHLO
        mail-wj0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755160AbcK3Vjd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Nov 2016 16:39:33 -0500
Received: by mail-wj0-f173.google.com with SMTP id v7so187642250wjy.2
        for <linux-media@vger.kernel.org>; Wed, 30 Nov 2016 13:39:32 -0800 (PST)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Malcolm Priestley <tvboxspy@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] [media] lmedm04: use %phN for hex dump
Date: Wed, 30 Nov 2016 22:39:09 +0100
Message-Id: <1480541953-27256-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the %ph printf extension for hex dumps like this makes the
generated code quite a bit smaller.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 0e8fb89896c4..7692701878ba 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -99,9 +99,7 @@ static int dvb_usb_lme2510_debug;
 } while (0)
 #define deb_info(level, args...) lme_debug(dvb_usb_lme2510_debug, level, args)
 #define debug_data_snipet(level, name, p) \
-	 deb_info(level, name" (%02x%02x%02x%02x%02x%02x%02x%02x)", \
-		*p, *(p+1), *(p+2), *(p+3), *(p+4), \
-			*(p+5), *(p+6), *(p+7));
+	 deb_info(level, name" (%8phN)", p);
 #define info(args...) pr_info(DVB_USB_LOG_PREFIX": "args)
 
 module_param_named(debug, dvb_usb_lme2510_debug, int, 0644);
-- 
2.1.4

