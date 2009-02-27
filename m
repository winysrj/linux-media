Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:61243 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbZB0Qb6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 11:31:58 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: video4linux-list@redhat.com, tuukka.o.toivonen@nokia.com,
	saaguirre@ti.com, antti.koskipaa@nokia.com, david.cohen@nokia.com,
	Sakari Ailus <sakari.ailus@nokia.com>
Subject: [PATCH 2/4] V4L: Int if: Dummy slave
Date: Fri, 27 Feb 2009 18:31:31 +0200
Message-Id: <1235752293-14452-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1235752293-14452-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <49A81502.3090002@maxwell.research.nokia.com>
 <1235752293-14452-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@nokia.com>

This patch implements a dummy slave that has no functionality. Helps
managing slaves in the OMAP 3 camera driver; no need to check for NULL
pointers.

Signed-off-by: Sakari Ailus <sakari.ailus@nokia.com>
---
 drivers/media/video/v4l2-int-device.c |   19 +++++++++++++++++++
 include/media/v4l2-int-device.h       |    2 ++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-int-device.c b/drivers/media/video/v4l2-int-device.c
index eb8dc84..483ee2e 100644
--- a/drivers/media/video/v4l2-int-device.c
+++ b/drivers/media/video/v4l2-int-device.c
@@ -67,6 +67,25 @@ static void __v4l2_int_device_try_attach_all(void)
 	}
 }
 
+static struct v4l2_int_slave dummy_slave = {
+	/* Dummy pointer to avoid underflow in find_ioctl. */
+	.ioctls = (void *)sizeof(struct v4l2_int_ioctl_desc),
+	.num_ioctls = 0,
+};
+
+static struct v4l2_int_device dummy = {
+	.type = v4l2_int_type_slave,
+	.u = {
+		.slave = &dummy_slave,
+	},
+};
+
+struct v4l2_int_device *v4l2_int_device_dummy()
+{
+	return &dummy;
+}
+EXPORT_SYMBOL_GPL(v4l2_int_device_dummy);
+
 void v4l2_int_device_try_attach_all(void)
 {
 	mutex_lock(&mutex);
diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index fbf5855..5d254c4 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -84,6 +84,8 @@ struct v4l2_int_device {
 	void *priv;
 };
 
+struct v4l2_int_device *v4l2_int_device_dummy(void);
+
 void v4l2_int_device_try_attach_all(void);
 
 int v4l2_int_device_register(struct v4l2_int_device *d);
-- 
1.5.6.5

