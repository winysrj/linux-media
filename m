Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:32913 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753524AbdLNRWD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 12:22:03 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 09/10] media: lirc: release lock before sleep
Date: Thu, 14 Dec 2017 17:22:02 +0000
Message-Id: <2da4e2d2ed4a98d2e56d5a8da378c437708b7ea9.1513271970.git.sean@mess.org>
In-Reply-To: <520044a764d3b795fb10e0b381cc7a48f729cfbb.1513271970.git.sean@mess.org>
References: <520044a764d3b795fb10e0b381cc7a48f729cfbb.1513271970.git.sean@mess.org>
In-Reply-To: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
References: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no reason to hold the lock while we wait for the IR to transmit.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 1fc1fd665bce..713d42e4b661 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -347,6 +347,10 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	if (ret < 0)
 		goto out_kfree;
 
+	kfree(txbuf);
+	kfree(raw);
+	mutex_unlock(&dev->lock);
+
 	/*
 	 * The lircd gap calculation expects the write function to
 	 * wait for the actual IR signal to be transmitted before
@@ -359,7 +363,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 		schedule_timeout(usecs_to_jiffies(towait));
 	}
 
-	ret = n;
+	return n;
 out_kfree:
 	kfree(txbuf);
 	kfree(raw);
-- 
2.14.3
