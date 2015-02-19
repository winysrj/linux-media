Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34260 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbbBSTxO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 14:53:14 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] cx25840: fix return logic when media entity init fails
Date: Thu, 19 Feb 2015 17:53:05 -0200
Message-Id: <1424375585-22509-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no need to free state, as it was allocated via devm_kzalloc().

Also, let's return the error code, instead of something else.

Reported-by: Prabhakar Lad <prabhakar.csengg@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/i2c/cx25840/cx25840-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index cb4e03de9b75..185cb55253c9 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -5205,8 +5205,7 @@ static int cx25840_probe(struct i2c_client *client,
 				state->pads, 0);
 	if (ret < 0) {
 		v4l_info(client, "failed to initialize media entity!\n");
-		kfree(state);
-		return -ENODEV;
+		return ret;
 	}
 #endif
 
-- 
2.1.0

