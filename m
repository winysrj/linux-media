Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:34949 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754505AbcK3Vjn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Nov 2016 16:39:43 -0500
Received: by mail-wm0-f43.google.com with SMTP id a197so280610674wmd.0
        for <linux-media@vger.kernel.org>; Wed, 30 Nov 2016 13:39:42 -0800 (PST)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Malcolm Priestley <tvboxspy@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] [media] lmedm04: make lme2510_powerup a little smaller
Date: Wed, 30 Nov 2016 22:39:12 +0100
Message-Id: <1480541953-27256-4-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1480541953-27256-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1480541953-27256-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gcc isn't smart enough to realize it can share most of the argument
buildup and the actual function call between the two branches, so help
it a little.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index bf5bc36a6ed9..7462207f4fd7 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -1179,10 +1179,7 @@ static int lme2510_powerup(struct dvb_usb_device *d, int onoff)
 
 	mutex_lock(&d->i2c_mutex);
 
-	if (onoff)
-		ret = lme2510_usb_talk(d, lnb_on, len, rbuf, rlen);
-	else
-		ret = lme2510_usb_talk(d, lnb_off, len, rbuf, rlen);
+	ret = lme2510_usb_talk(d, onoff ? lnb_on : lnb_off, len, rbuf, rlen);
 
 	st->i2c_talk_onoff = 1;
 
-- 
2.1.4

