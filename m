Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:38838 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab2HNHDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 03:03:49 -0400
Date: Tue, 14 Aug 2012 10:03:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] stk1160: remove unneeded check
Message-ID: <20120814070335.GE4791@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"card" is a valid pointer here because we checked snd_card_create() for
error returns.  Checking after a dereference makes the static checkers
complain.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Only needed on linux-next.

diff --git a/drivers/media/video/stk1160/stk1160-ac97.c b/drivers/media/video/stk1160/stk1160-ac97.c
index 8d325f5..c8583c2 100644
--- a/drivers/media/video/stk1160/stk1160-ac97.c
+++ b/drivers/media/video/stk1160/stk1160-ac97.c
@@ -133,8 +133,7 @@ int stk1160_ac97_register(struct stk1160 *dev)
 
 err:
 	dev->snd_card = NULL;
-	if (card)
-		snd_card_free(card);
+	snd_card_free(card);
 	return rc;
 }
 
