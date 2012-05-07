Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab2EGTUg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 15:20:36 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 16/23] gspca: Use req_events in poll
Date: Mon,  7 May 2012 21:01:27 +0200
Message-Id: <1336417294-4566-17-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
References: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So that we don't start a read stream when an app is only polling for control
events.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/gspca.c |   44 ++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 8dca187..dc62829 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -2031,31 +2031,39 @@ out:
 static unsigned int dev_poll(struct file *file, poll_table *wait)
 {
 	struct gspca_dev *gspca_dev = video_drvdata(file);
-	int ret;
+	unsigned long req_events = poll_requested_events(wait);
+	int ret = 0;
 
 	PDEBUG(D_FRAM, "poll");
 
-	poll_wait(file, &gspca_dev->wq, wait);
+	if (req_events & POLLPRI)
+		ret |= v4l2_ctrl_poll(file, wait);
 
-	/* if reqbufs is not done, the user would use read() */
-	if (gspca_dev->memory == GSPCA_MEMORY_NO) {
-		ret = read_alloc(gspca_dev, file);
-		if (ret != 0)
-			return POLLERR;
-	}
+	if (req_events & (POLLIN | POLLRDNORM)) {
+		/* if reqbufs is not done, the user would use read() */
+		if (gspca_dev->memory == GSPCA_MEMORY_NO) {
+			if (read_alloc(gspca_dev, file) != 0) {
+				ret |= POLLERR;
+				goto out;
+			}
+		}
 
-	if (mutex_lock_interruptible(&gspca_dev->queue_lock) != 0)
-		return POLLERR;
+		poll_wait(file, &gspca_dev->wq, wait);
 
-	/* check if an image has been received */
-	if (gspca_dev->fr_o != atomic_read(&gspca_dev->fr_i))
-		ret = POLLIN | POLLRDNORM;	/* yes */
-	else
-		ret = 0;
-	ret |= v4l2_ctrl_poll(file, wait);
-	mutex_unlock(&gspca_dev->queue_lock);
+		/* check if an image has been received */
+		if (mutex_lock_interruptible(&gspca_dev->queue_lock) != 0) {
+			ret |= POLLERR;
+			goto out;
+		}
+		if (gspca_dev->fr_o != atomic_read(&gspca_dev->fr_i))
+			ret |= POLLIN | POLLRDNORM;
+		mutex_unlock(&gspca_dev->queue_lock);
+	}
+
+out:
 	if (!gspca_dev->present)
-		return POLLHUP;
+		ret |= POLLHUP;
+
 	return ret;
 }
 
-- 
1.7.10

