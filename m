Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27598 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbcD2IqW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 04:46:22 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Subject: [PATCH 1/3] media: Determine early whether an IOCTL is supported
Date: Fri, 29 Apr 2016 11:43:18 +0300
Message-Id: <1461919400-2658-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1461919400-2658-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1461919400-2658-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Preparation for refactoring media IOCTL handling to unify common parts.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 898a3cf..6d3ee5c 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -419,6 +419,20 @@ static long media_device_get_topology(struct media_device *mdev,
 	return 0;
 }
 
+#define MEDIA_IOC(__cmd) \
+	[_IOC_NR(MEDIA_IOC_##__cmd)] = { .cmd = MEDIA_IOC_##__cmd }
+
+/* the table is indexed by _IOC_NR(cmd) */
+static struct {
+	unsigned int cmd;
+} media_ioctl_info[] = {
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
@@ -426,6 +440,10 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 	struct media_device *dev = to_media_device(devnode);
 	long ret;
 
+	if (_IOC_NR(cmd) >= ARRAY_SIZE(media_ioctl_info)
+	    || media_ioctl_info[_IOC_NR(cmd)].cmd != cmd)
+		return -ENOIOCTLCMD;
+
 	mutex_lock(&dev->graph_mutex);
 	switch (cmd) {
 	case MEDIA_IOC_DEVICE_INFO:
-- 
1.9.1

