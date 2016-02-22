Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35753 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbcBVOQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 09:16:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/5] [media] xc4000: shut up a bogus smatch message
Date: Mon, 22 Feb 2016 11:16:19 -0300
Message-Id: <72ef5fcae1ee23265c796b0cacd64ee41b9b9301.1456150537.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

smatch complains about:
	drivers/media/tuners/xc4000.c:1511 xc4000_get_signal() warn: '~value << 3' 524280 can't fit into 65535 'value'

Remove the bogus complain.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/tuners/xc4000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index 219ebafae70f..d95c7e082ccf 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -1508,7 +1508,7 @@ static int xc4000_get_signal(struct dvb_frontend *fe, u16 *strength)
 	if (value >= 0x2000) {
 		value = 0;
 	} else {
-		value = ~value << 3;
+		value = (~value << 3) & 0xffff;
 	}
 
 	goto ret;
-- 
2.5.0

