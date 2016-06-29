Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:57719 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbcF2NVB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 09:21:01 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH 06/15] lirc_dev: do not use goto to create loops
Date: Wed, 29 Jun 2016 22:20:35 +0900
Message-id: <1467206444-9935-7-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
References: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

... use "do .. while" instead.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 400ab80..cc00b9a 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -103,12 +103,11 @@ static int lirc_add_to_buf(struct irctl *ir)
 		 * service the device as long as it is returning
 		 * data and we have space
 		 */
-get_data:
-		res = ir->d.add_to_buf(ir->d.data, ir->buf);
-		if (res == 0) {
-			got_data++;
-			goto get_data;
-		}
+		do {
+			res = ir->d.add_to_buf(ir->d.data, ir->buf);
+			if (!res)
+				got_data++;
+		} while (!res);
 
 		if (res == -ENODEV)
 			kthread_stop(ir->task);
-- 
2.8.1

