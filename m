Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:41748 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbcGAIE2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 04:04:28 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH v2 06/15] [media] lirc_dev: do not use goto to create loops
Date: Fri, 01 Jul 2016 17:01:29 +0900
Message-id: <1467360098-12539-7-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467360098-12539-1-git-send-email-andi.shyti@samsung.com>
References: <1467360098-12539-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

... use "do .. while" instead.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 0d988c9..da1777c 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -99,18 +99,16 @@ static int lirc_add_to_buf(struct irctl *ir)
 {
 	if (ir->d.add_to_buf) {
 		int res = -ENODATA;
-		int got_data = 0;
+		int got_data = -1;
 
 		/*
 		 * service the device as long as it is returning
 		 * data and we have space
 		 */
-get_data:
-		res = ir->d.add_to_buf(ir->d.data, ir->buf);
-		if (res == 0) {
+		do {
 			got_data++;
-			goto get_data;
-		}
+			res = ir->d.add_to_buf(ir->d.data, ir->buf);
+		} while (!res);
 
 		if (res == -ENODEV)
 			kthread_stop(ir->task);
-- 
2.8.1

