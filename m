Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55244 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbcGFJoA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 05:44:00 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH v3 07/15] [media] lirc_dev: simplify if statement in
 lirc_add_to_buf
Date: Wed, 06 Jul 2016 18:01:19 +0900
Message-id: <1467795687-10737-8-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
References: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The whole function is inside an 'if' statement
("if (ir->d.add_to_buf)").

Check the opposite of that statement at the beginning and exit,
this way we can have one level less of indentation.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index cfa6031..c2826a7 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -97,26 +97,25 @@ static void lirc_irctl_cleanup(struct irctl *ir)
  */
 static int lirc_add_to_buf(struct irctl *ir)
 {
-	if (ir->d.add_to_buf) {
-		int res = -ENODATA;
-		int got_data = -1;
+	int res;
+	int got_data = -1;
 
-		/*
-		 * service the device as long as it is returning
-		 * data and we have space
-		 */
-		do {
-			got_data++;
-			res = ir->d.add_to_buf(ir->d.data, ir->buf);
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
+		got_data++;
+		res = ir->d.add_to_buf(ir->d.data, ir->buf);
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

