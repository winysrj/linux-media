Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36232 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754165AbcK3Vje (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Nov 2016 16:39:34 -0500
Received: by mail-wm0-f46.google.com with SMTP id g23so281216537wme.1
        for <linux-media@vger.kernel.org>; Wed, 30 Nov 2016 13:39:34 -0800 (PST)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Malcolm Priestley <tvboxspy@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] [media] lmedm04: change some static variables to automatic
Date: Wed, 30 Nov 2016 22:39:10 +0100
Message-Id: <1480541953-27256-2-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1480541953-27256-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1480541953-27256-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ibuf and rbuf in lme2510_int_response are always assigned to before they
are read, and their addresses do not escape the function, so they have
no reason to be static.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 7692701878ba..cd463f09ebc7 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -315,7 +315,7 @@ static void lme2510_int_response(struct urb *lme_urb)
 {
 	struct dvb_usb_adapter *adap = lme_urb->context;
 	struct lme2510_state *st = adap_to_priv(adap);
-	static u8 *ibuf, *rbuf;
+	u8 *ibuf, *rbuf;
 	int i = 0, offset;
 	u32 key;
 	u8 signal_lock = 0;
-- 
2.1.4

