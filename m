Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:18579 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbcEXQu7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 12:50:59 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC v2 05/21] media: Add media_device_request_complete() to mark requests complete
Date: Tue, 24 May 2016 19:47:15 +0300
Message-Id: <1464108451-28142-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Once the request has been queued and later on completed, a driver will
mark the request complete by calling media_device_request_complete().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 49 ++++++++++++++++++++++++++++++++++++++++++++
 include/media/media-device.h |  3 +++
 2 files changed, 52 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index a89d046..16fcc20 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -42,6 +42,7 @@ static char *__request_state[] = {
 	"IDLE",
 	"QUEUED",
 	"DELETED",
+	"COMPLETED",
 };
 
 #define request_state(i)			\
@@ -203,6 +204,54 @@ static int media_device_request_delete(struct media_device *mdev,
 	return 0;
 }
 
+void media_device_request_complete(struct media_device *mdev,
+				   struct media_device_request *req)
+{
+	struct file *filp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+
+	if (req->state == MEDIA_DEVICE_REQUEST_STATE_IDLE) {
+		dev_dbg(mdev->dev,
+			"request: not completing an idle request %u\n",
+			req->id);
+		spin_unlock_irqrestore(&mdev->req_lock, flags);
+		return;
+	}
+
+	if (WARN_ON(req->state != MEDIA_DEVICE_REQUEST_STATE_QUEUED)) {
+		dev_dbg(mdev->dev, "request: can't delete %u, state %s\n",
+			req->id, request_state(req->state));
+		spin_unlock_irqrestore(&mdev->req_lock, flags);
+		return;
+	}
+
+	req->state = MEDIA_DEVICE_REQUEST_STATE_COMPLETE;
+	filp = req->filp;
+	if (filp) {
+		/*
+		 * If the file handle is still around we remove if
+		 * from the lists here. Otherwise it has been removed
+		 * when the file handle closed.
+		 */
+		list_del(&req->list);
+		list_del(&req->fh_list);
+		req->filp = NULL;
+	}
+
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+	/*
+	 * The driver holds a reference to a request if the filp
+	 * pointer is non-NULL: the file handle associated to the
+	 * request may have been released by now, i.e. filp is NULL.
+	 */
+	if (filp)
+		media_device_request_put(req);
+}
+EXPORT_SYMBOL_GPL(media_device_request_complete);
+
 static int media_device_request_queue_apply(
 	struct media_device *mdev, struct media_device_request *req,
 	int (*fn)(struct media_device *mdev,
diff --git a/include/media/media-device.h b/include/media/media-device.h
index df4afeb..acb7181 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -269,6 +269,7 @@ enum media_device_request_state {
 	MEDIA_DEVICE_REQUEST_STATE_IDLE,
 	MEDIA_DEVICE_REQUEST_STATE_QUEUED,
 	MEDIA_DEVICE_REQUEST_STATE_DELETED,
+	MEDIA_DEVICE_REQUEST_STATE_COMPLETE,
 };
 
 /**
@@ -765,5 +766,7 @@ struct media_device_request *
 media_device_request_find(struct media_device *mdev, u16 reqid);
 void media_device_request_get(struct media_device_request *req);
 void media_device_request_put(struct media_device_request *req);
+void media_device_request_complete(struct media_device *mdev,
+				   struct media_device_request *req);
 
 #endif
-- 
1.9.1

