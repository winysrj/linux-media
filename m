Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14228 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758152AbcEFK4m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 06:56:42 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC 16/22] media: Add poll support
Date: Fri,  6 May 2016 13:53:25 +0300
Message-Id: <1462532011-15527-17-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement poll for events. POLLPRI is used to notify users on incoming
events.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 0b1ab88..2a9bf80 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -956,6 +956,32 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 		ioctl_info, ARRAY_SIZE(ioctl_info));
 }
 
+unsigned int media_device_poll(struct file *filp, struct poll_table_struct *wait)
+{
+	struct media_device_fh *fh = media_device_fh(filp);
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
+		spin_lock_irqsave(&fh->kevents.lock, flags);
+		empty = list_empty(&fh->kevents.head);
+		spin_unlock_irqrestore(&fh->kevents.lock, flags);
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
@@ -1010,6 +1036,7 @@ static const struct media_file_operations media_device_fops = {
 	.owner = THIS_MODULE,
 	.open = media_device_open,
 	.ioctl = media_device_ioctl,
+	.poll = media_device_poll,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = media_device_compat_ioctl,
 #endif /* CONFIG_COMPAT */
-- 
1.9.1

