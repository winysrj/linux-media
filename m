Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56568 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751211AbeCIXtX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 18:49:23 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: acourbot@chromium.org
Subject: [RFC 3/8] media: Support polling for completed requests
Date: Sat, 10 Mar 2018 01:48:47 +0200
Message-Id: <1520639332-19190-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1520639332-19190-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1520639332-19190-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement poll for events. POLLPRI is used to notify the user an event is
complete.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 41ec5ac..a4d3884 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -84,6 +84,34 @@ void media_device_request_put(struct media_device_request *req)
 }
 EXPORT_SYMBOL_GPL(media_device_request_put);
 
+static unsigned int media_device_request_poll(struct file *filp,
+					      struct poll_table_struct *wait)
+{
+	struct media_device_request *req = filp->private_data;
+	struct media_device *mdev = req->mdev;
+	unsigned int poll_events = poll_requested_events(wait);
+	int ret = 0;
+
+	if (poll_events & (POLLIN | POLLOUT))
+		return POLLERR;
+
+	if (poll_events & POLLPRI) {
+		unsigned long flags;
+		bool complete;
+
+		spin_lock_irqsave(&mdev->req_lock, flags);
+		complete = req->state == MEDIA_DEVICE_REQUEST_STATE_COMPLETE;
+		spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+		if (complete)
+			poll_wait(filp, &req->poll_wait, wait);
+		else
+			ret |= POLLPRI;
+	}
+
+	return ret;
+}
+
 static int media_device_request_close(struct inode *inode, struct file *filp)
 {
 	struct media_device_request *req = filp->private_data;
@@ -95,6 +123,7 @@ static int media_device_request_close(struct inode *inode, struct file *filp)
 
 static const struct file_operations request_fops = {
 	.owner = THIS_MODULE,
+	.poll = media_device_request_poll,
 	.release = media_device_request_close,
 };
 
-- 
2.7.4
