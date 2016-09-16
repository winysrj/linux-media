Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:60293 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933781AbcIPLuU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 07:50:20 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        mchehab@s-opensource.com
Subject: [PATCH v5 1/4] media: Determine early whether an IOCTL is supported
Date: Fri, 16 Sep 2016 14:49:05 +0300
Message-Id: <1474026548-28829-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474026548-28829-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474026548-28829-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Preparation for refactoring media IOCTL handling to unify common parts.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-device.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 1795abe..f321264 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -419,6 +419,22 @@ static long media_device_get_topology(struct media_device *mdev,
 	return 0;
 }
 
+#define MEDIA_IOC(__cmd) \
+	[_IOC_NR(MEDIA_IOC_##__cmd)] = { .cmd = MEDIA_IOC_##__cmd }
+
+/* the table is indexed by _IOC_NR(cmd) */
+struct media_ioctl_info {
+	unsigned int cmd;
+};
+
+static const struct media_ioctl_info ioctl_info[] = {
+	MEDIA_IOC(DEVICE_INFO),
+	MEDIA_IOC(ENUM_ENTITIES),
+	MEDIA_IOC(ENUM_LINKS),
+	MEDIA_IOC(SETUP_LINK),
+	MEDIA_IOC(G_TOPOLOGY),
+};
+
 static long media_device_ioctl(struct file *filp, unsigned int cmd,
 			       unsigned long arg)
 {
@@ -426,6 +442,10 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 	struct media_device *dev = devnode->media_dev;
 	long ret;
 
+	if (_IOC_NR(cmd) >= ARRAY_SIZE(ioctl_info)
+	    || ioctl_info[_IOC_NR(cmd)].cmd != cmd)
+		return -ENOIOCTLCMD;
+
 	mutex_lock(&dev->graph_mutex);
 	switch (cmd) {
 	case MEDIA_IOC_DEVICE_INFO:
-- 
2.7.4

