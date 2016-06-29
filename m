Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:48043 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbcF2NVE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 09:21:04 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH 08/15] lirc_dev: remove double if ... else statement
Date: Wed, 29 Jun 2016 22:20:37 +0900
Message-id: <1467206444-9935-9-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
References: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two if ... else which check the same thing in different
part of the code, they can be merged in a single check.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index d63ff85..7dff92c 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -309,13 +309,6 @@ static int lirc_allocate_driver(struct lirc_driver *d)
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
 
@@ -329,6 +322,8 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 		      "lirc%u", ir->d.minor);
 
 	if (d->sample_rate) {
+		ir->jiffies_to_wait = HZ / d->sample_rate;
+
 		/* try to fire up polling thread */
 		ir->task = kthread_run(lirc_thread, (void *)ir, "lirc_dev");
 		if (IS_ERR(ir->task)) {
@@ -337,6 +332,9 @@ static int lirc_allocate_driver(struct lirc_driver *d)
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

