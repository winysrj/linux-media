Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:32913 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753490AbdLNRWC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 12:22:02 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 08/10] media: lirc: no need to recalculate duration
Date: Thu, 14 Dec 2017 17:21:58 +0000
Message-Id: <38923c5f39c5421201b431c4e0ff754dcfacc70f.1513271970.git.sean@mess.org>
In-Reply-To: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
References: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
In-Reply-To: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
References: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is code existed for when drivers would send less than the whole
buffer; no driver does this any more, so this is redundant. Drivers
should return -EINVAL if they cannot send the entire buffer.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 8618aba152c6..1fc1fd665bce 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -347,15 +347,6 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	if (ret < 0)
 		goto out_kfree;
 
-	if (fh->send_mode == LIRC_MODE_SCANCODE) {
-		ret = n;
-	} else {
-		for (duration = i = 0; i < ret; i++)
-			duration += txbuf[i];
-
-		ret *= sizeof(unsigned int);
-	}
-
 	/*
 	 * The lircd gap calculation expects the write function to
 	 * wait for the actual IR signal to be transmitted before
@@ -368,6 +359,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 		schedule_timeout(usecs_to_jiffies(towait));
 	}
 
+	ret = n;
 out_kfree:
 	kfree(txbuf);
 	kfree(raw);
-- 
2.14.3
