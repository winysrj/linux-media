Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:56899 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbcF2NVF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 09:21:05 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH 09/15] lirc_dev: merge three if statements in only one
Date: Wed, 29 Jun 2016 22:20:38 +0900
Message-id: <1467206444-9935-10-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
References: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The three if statements check the same thing, merge them in only
one statement.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 7dff92c..0c26609 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -269,15 +269,10 @@ static int lirc_allocate_driver(struct lirc_driver *d)
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

