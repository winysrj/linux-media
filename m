Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.abbadie.fr ([37.187.122.32]:53306 "EHLO mail.abbadie.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941030AbcJSR1Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 13:27:16 -0400
From: Jean-Baptiste Abbadie <jb@abbadie.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Cc: Jean-Baptiste Abbadie <jb@abbadie.fr>
Subject: [PATCH 2/3] Staging: media: radio-bcm2048: Fix alignment issues
Date: Wed, 19 Oct 2016 19:17:12 +0200
Message-Id: <20161019171713.19181-2-jb@abbadie.fr>
In-Reply-To: <20161019171713.19181-1-jb@abbadie.fr>
References: <20161019171713.19181-1-jb@abbadie.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jean-Baptiste Abbadie <jb@abbadie.fr>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 188d045d44ad..f66bea631e8e 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -997,7 +997,7 @@ static int bcm2048_set_fm_search_tune_mode(struct bcm2048_device *bdev,
 		timeout = BCM2048_AUTO_SEARCH_TIMEOUT;
 
 	if (!wait_for_completion_timeout(&bdev->compl,
-		msecs_to_jiffies(timeout)))
+					 msecs_to_jiffies(timeout)))
 		dev_err(&bdev->client->dev, "IRQ timeout.\n");
 
 	if (value)
@@ -2202,7 +2202,7 @@ static ssize_t bcm2048_fops_read(struct file *file, char __user *buf,
 		}
 		/* interruptible_sleep_on(&bdev->read_queue); */
 		if (wait_event_interruptible(bdev->read_queue,
-		    bdev->rds_data_available) < 0) {
+					     bdev->rds_data_available) < 0) {
 			retval = -EINTR;
 			goto done;
 		}
-- 
2.10.0

