Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab1GMV6p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 17:58:45 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6DLwil7014623
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 13 Jul 2011 17:58:44 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] [media] imon: rate-limit send_packet spew
Date: Wed, 13 Jul 2011 17:58:41 -0400
Message-Id: <1310594321-12921-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are folks with flaky imon hardware out there that doesn't always
respond to requests to write to their displays for some reason, which
can flood logs quickly when something like lcdproc is trying to
constantly update the display, so lets rate-limit all that error spew.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/imon.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 6bc35ee..ba48c1e 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -516,19 +516,19 @@ static int send_packet(struct imon_context *ictx)
 	if (retval) {
 		ictx->tx.busy = false;
 		smp_rmb(); /* ensure later readers know we're not busy */
-		pr_err("error submitting urb(%d)\n", retval);
+		pr_err_ratelimited("error submitting urb(%d)\n", retval);
 	} else {
 		/* Wait for transmission to complete (or abort) */
 		mutex_unlock(&ictx->lock);
 		retval = wait_for_completion_interruptible(
 				&ictx->tx.finished);
 		if (retval)
-			pr_err("task interrupted\n");
+			pr_err_ratelimited("task interrupted\n");
 		mutex_lock(&ictx->lock);
 
 		retval = ictx->tx.status;
 		if (retval)
-			pr_err("packet tx failed (%d)\n", retval);
+			pr_err_ratelimited("packet tx failed (%d)\n", retval);
 	}
 
 	kfree(control_req);
@@ -830,20 +830,20 @@ static ssize_t vfd_write(struct file *file, const char *buf,
 
 	ictx = file->private_data;
 	if (!ictx) {
-		pr_err("no context for device\n");
+		pr_err_ratelimited("no context for device\n");
 		return -ENODEV;
 	}
 
 	mutex_lock(&ictx->lock);
 
 	if (!ictx->dev_present_intf0) {
-		pr_err("no iMON device present\n");
+		pr_err_ratelimited("no iMON device present\n");
 		retval = -ENODEV;
 		goto exit;
 	}
 
 	if (n_bytes <= 0 || n_bytes > 32) {
-		pr_err("invalid payload size\n");
+		pr_err_ratelimited("invalid payload size\n");
 		retval = -EINVAL;
 		goto exit;
 	}
@@ -869,7 +869,7 @@ static ssize_t vfd_write(struct file *file, const char *buf,
 
 		retval = send_packet(ictx);
 		if (retval) {
-			pr_err("send packet failed for packet #%d\n", seq / 2);
+			pr_err_ratelimited("send packet #%d failed\n", seq / 2);
 			goto exit;
 		} else {
 			seq += 2;
@@ -883,7 +883,7 @@ static ssize_t vfd_write(struct file *file, const char *buf,
 	ictx->usb_tx_buf[7] = (unsigned char) seq;
 	retval = send_packet(ictx);
 	if (retval)
-		pr_err("send packet failed for packet #%d\n", seq / 2);
+		pr_err_ratelimited("send packet #%d failed\n", seq / 2);
 
 exit:
 	mutex_unlock(&ictx->lock);
@@ -912,20 +912,21 @@ static ssize_t lcd_write(struct file *file, const char *buf,
 
 	ictx = file->private_data;
 	if (!ictx) {
-		pr_err("no context for device\n");
+		pr_err_ratelimited("no context for device\n");
 		return -ENODEV;
 	}
 
 	mutex_lock(&ictx->lock);
 
 	if (!ictx->display_supported) {
-		pr_err("no iMON display present\n");
+		pr_err_ratelimited("no iMON display present\n");
 		retval = -ENODEV;
 		goto exit;
 	}
 
 	if (n_bytes != 8) {
-		pr_err("invalid payload size: %d (expected 8)\n", (int)n_bytes);
+		pr_err_ratelimited("invalid payload size: %d (expected 8)\n",
+				   (int)n_bytes);
 		retval = -EINVAL;
 		goto exit;
 	}
@@ -937,7 +938,7 @@ static ssize_t lcd_write(struct file *file, const char *buf,
 
 	retval = send_packet(ictx);
 	if (retval) {
-		pr_err("send packet failed!\n");
+		pr_err_ratelimited("send packet failed!\n");
 		goto exit;
 	} else {
 		dev_dbg(ictx->dev, "%s: write %d bytes to LCD\n",
-- 
1.7.1

