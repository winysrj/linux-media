Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464AbcEXQvA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 12:51:00 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC v2 15/21] media: Add poll support
Date: Tue, 24 May 2016 19:47:25 +0300
Message-Id: <1464108451-28142-16-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement poll for events. POLLPRI is used to notify users on incoming
events.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 2ff8b29..25f7aea 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -1041,6 +1041,33 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 		ioctl_info, ARRAY_SIZE(ioctl_info));
 }
 
+unsigned int media_device_poll(struct file *filp, struct poll_table_struct *wait)
+{
+	struct media_device_fh *fh = media_device_fh(filp);
+	struct media_device *mdev = to_media_device(fh->fh.devnode);
+	unsigned int poll_events = poll_requested_events(wait);
+	int ret = 0;
+
+	if (poll_events & (POLLIN | POLLOUT))
+		return POLLERR;
+
+	if (poll_events & POLLPRI) {
+		unsigned long flags;
+		bool empty;
+
+		spin_lock_irqsave(&mdev->req_lock, flags);
+		empty = list_empty(&fh->kevents.head);
+		spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+		if (empty)
+			poll_wait(filp, &fh->kevents.wait, wait);
+		else
+			ret |= POLLPRI;
+	}
+
+	return ret;
+}
+
 #ifdef CONFIG_COMPAT
 
 struct media_links_enum32 {
@@ -1095,6 +1122,7 @@ static const struct media_file_operations media_device_fops = {
 	.owner = THIS_MODULE,
 	.open = media_device_open,
 	.ioctl = media_device_ioctl,
+	.poll = media_device_poll,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = media_device_compat_ioctl,
 #endif /* CONFIG_COMPAT */
-- 
1.9.1

