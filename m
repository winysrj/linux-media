Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:46763 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbcGFJoA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 05:44:00 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH v3 08/15] [media] lirc_dev: remove double if ... else statement
Date: Wed, 06 Jul 2016 18:01:20 +0900
Message-id: <1467795687-10737-9-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
References: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two if ... else which check the same thing in different
part of the code, they can be merged in a single check.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index c2826a7..a8a5116 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -310,13 +310,6 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 	irctls[minor] = ir;
 	d->minor = minor;
 
-	if (d->sample_rate) {
-		ir->jiffies_to_wait = HZ / d->sample_rate;
-	} else {
-		/* it means - wait for external event in task queue */
-		ir->jiffies_to_wait = 0;
-	}
-
 	/* some safety check 8-) */
 	d->name[sizeof(d->name)-1] = '\0';
 
@@ -330,6 +323,8 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 		      "lirc%u", ir->d.minor);
 
 	if (d->sample_rate) {
+		ir->jiffies_to_wait = HZ / d->sample_rate;
+
 		/* try to fire up polling thread */
 		ir->task = kthread_run(lirc_thread, (void *)ir, "lirc_dev");
 		if (IS_ERR(ir->task)) {
@@ -338,6 +333,9 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 			err = -ECHILD;
 			goto out_sysfs;
 		}
+	} else {
+		/* it means - wait for external event in task queue */
+		ir->jiffies_to_wait = 0;
 	}
 
 	err = lirc_cdev_add(ir);
-- 
2.8.1

