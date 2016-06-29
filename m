Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:57719 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbcF2NVE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 09:21:04 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH 07/15] lirc_dev: simplify if statement in lirc_add_to_buf
Date: Wed, 29 Jun 2016 22:20:36 +0900
Message-id: <1467206444-9935-8-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
References: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The whole function is inside an 'if' statement
("if (ir->d.add_to_buf)").

Check the opposite of that statement at the beginning and exit,
this way we can have one level less of indentation.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index cc00b9a..d63ff85 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -95,27 +95,26 @@ static void lirc_irctl_cleanup(struct irctl *ir)
  */
 static int lirc_add_to_buf(struct irctl *ir)
 {
-	if (ir->d.add_to_buf) {
-		int res = -ENODATA;
-		int got_data = 0;
+	int res;
+	int got_data = 0;
 
-		/*
-		 * service the device as long as it is returning
-		 * data and we have space
-		 */
-		do {
-			res = ir->d.add_to_buf(ir->d.data, ir->buf);
-			if (!res)
-				got_data++;
-		} while (!res);
+	if (!ir->d.add_to_buf)
+		return 0;
 
-		if (res == -ENODEV)
-			kthread_stop(ir->task);
+	/*
+	 * service the device as long as it is returning
+	 * data and we have space
+	 */
+	do {
+		res = ir->d.add_to_buf(ir->d.data, ir->buf);
+		if (!res)
+			got_data++;
+	} while (!res);
 
-		return got_data ? 0 : res;
-	}
+	if (res == -ENODEV)
+		kthread_stop(ir->task);
 
-	return 0;
+	return got_data ? 0 : res;
 }
 
 /* main function of the polling thread
-- 
2.8.1

