Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:61317 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbZB0Qcg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 11:32:36 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: video4linux-list@redhat.com, tuukka.o.toivonen@nokia.com,
	saaguirre@ti.com, antti.koskipaa@nokia.com, david.cohen@nokia.com,
	Sakari Ailus <sakari.ailus@nokia.com>
Subject: [PATCH 1/4] V4L: Int if: v4l2_int_device_try_attach_all requires mutex
Date: Fri, 27 Feb 2009 18:31:30 +0200
Message-Id: <1235752293-14452-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <49A81502.3090002@maxwell.research.nokia.com>
References: <49A81502.3090002@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@nokia.com>

Signed-off-by: Sakari Ailus <sakari.ailus@nokia.com>
---
 drivers/media/video/v4l2-int-device.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-int-device.c b/drivers/media/video/v4l2-int-device.c
index a935bae..eb8dc84 100644
--- a/drivers/media/video/v4l2-int-device.c
+++ b/drivers/media/video/v4l2-int-device.c
@@ -32,7 +32,7 @@
 static DEFINE_MUTEX(mutex);
 static LIST_HEAD(int_list);
 
-void v4l2_int_device_try_attach_all(void)
+static void __v4l2_int_device_try_attach_all(void)
 {
 	struct v4l2_int_device *m, *s;
 
@@ -66,6 +66,14 @@ void v4l2_int_device_try_attach_all(void)
 		}
 	}
 }
+
+void v4l2_int_device_try_attach_all(void)
+{
+	mutex_lock(&mutex);
+	__v4l2_int_device_try_attach_all();
+	mutex_unlock(&mutex);
+}
+
 EXPORT_SYMBOL_GPL(v4l2_int_device_try_attach_all);
 
 static int ioctl_sort_cmp(const void *a, const void *b)
@@ -89,7 +97,7 @@ int v4l2_int_device_register(struct v4l2_int_device *d)
 		     &ioctl_sort_cmp, NULL);
 	mutex_lock(&mutex);
 	list_add(&d->head, &int_list);
-	v4l2_int_device_try_attach_all();
+	__v4l2_int_device_try_attach_all();
 	mutex_unlock(&mutex);
 
 	return 0;
-- 
1.5.6.5

