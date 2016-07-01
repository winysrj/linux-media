Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:38882 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbcGAJP7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 05:15:59 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH v2 09/15] [media] lirc_dev: merge three if statements in only
 one
Date: Fri, 01 Jul 2016 17:01:32 +0900
Message-id: <1467360098-12539-10-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467360098-12539-1-git-send-email-andi.shyti@samsung.com>
References: <1467360098-12539-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The three if statements check the same thing, merge them in only
one statement.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 2643336..d98a9f1 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -270,15 +270,10 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 			dev_err(d->dev, "add_to_buf not set\n");
 			return -EBADRQC;
 		}
-	} else if (!(d->fops && d->fops->read) && !d->rbuf) {
-		dev_err(d->dev, "fops->read and rbuf are NULL!\n");
+	} else if (!d->rbuf && !(d->fops && d->fops->read &&
+				d->fops->poll && d->fops->unlocked_ioctl)) {
+		dev_err(d->dev, "undefined read, poll, ioctl\n");
 		return -EBADRQC;
-	} else if (!d->rbuf) {
-		if (!(d->fops && d->fops->read && d->fops->poll &&
-		      d->fops->unlocked_ioctl)) {
-			dev_err(d->dev, "undefined read, poll, ioctl\n");
-			return -EBADRQC;
-		}
 	}
 
 	mutex_lock(&lirc_dev_lock);
-- 
2.8.1

