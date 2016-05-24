Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40731 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460AbcEXQvA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 12:51:00 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC v2 02/21] media: Add media device request state
Date: Tue, 24 May 2016 19:47:12 +0300
Message-Id: <1464108451-28142-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 9 +++++++++
 include/media/media-device.h | 8 ++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 85b13db..7781c49 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -38,6 +38,14 @@
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 
+static char *__request_state[] = {
+	"IDLE",
+	"QUEUED",
+};
+
+#define request_state(i)			\
+	((i) < ARRAY_SIZE(__request_state) ? __request_state[i] : "UNKNOWN")
+
 struct media_device_fh {
 	struct media_devnode_fh fh;
 	struct list_head requests;
@@ -140,6 +148,7 @@ static int media_device_request_alloc(struct media_device *mdev,
 	req->mdev = mdev;
 	req->id = id;
 	req->filp = filp;
+	req->state = MEDIA_DEVICE_REQUEST_STATE_IDLE;
 	kref_init(&req->kref);
 
 	spin_lock_irqsave(&mdev->req_lock, flags);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 39442ae..893e10b 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -265,6 +265,11 @@
 struct device;
 struct media_device;
 
+enum media_device_request_state {
+	MEDIA_DEVICE_REQUEST_STATE_IDLE,
+	MEDIA_DEVICE_REQUEST_STATE_QUEUED,
+};
+
 /**
  * struct media_device_request - Media device request
  * @id: Request ID
@@ -272,6 +277,8 @@ struct media_device;
  * @kref: Reference count
  * @list: List entry in the media device requests list
  * @fh_list: List entry in the media file handle requests list
+ * @state: The state of the request, MEDIA_DEVICE_REQUEST_STATE_*,
+ *	   access to state serialised by mdev->req_lock
  */
 struct media_device_request {
 	u32 id;
@@ -280,6 +287,7 @@ struct media_device_request {
 	struct kref kref;
 	struct list_head list;
 	struct list_head fh_list;
+	enum media_device_request_state state;
 };
 
 /**
-- 
1.9.1

