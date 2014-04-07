Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49082 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbaDGNm3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 09:42:29 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] stk1160: warrant a NUL terminated string
Date: Mon,  7 Apr 2014 10:42:20 -0300
Message-Id: <1396878140-22084-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

strncpy() doesn't warrant a NUL terminated string. Use
strlcpy() instead.

Fixes Coverity bug CID#1195195.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/stk1160/stk1160-ac97.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/usb/stk1160/stk1160-ac97.c
index c46c8be89602..2dd308f9541f 100644
--- a/drivers/media/usb/stk1160/stk1160-ac97.c
+++ b/drivers/media/usb/stk1160/stk1160-ac97.c
@@ -108,7 +108,7 @@ int stk1160_ac97_register(struct stk1160 *dev)
 		 "stk1160-mixer");
 	snprintf(card->longname, sizeof(card->longname),
 		 "stk1160 ac97 codec mixer control");
-	strncpy(card->driver, dev->dev->driver->name, sizeof(card->driver));
+	strlcpy(card->driver, dev->dev->driver->name, sizeof(card->driver));
 
 	rc = snd_ac97_bus(card, 0, &stk1160_ac97_ops, NULL, &ac97_bus);
 	if (rc)
-- 
1.9.0

