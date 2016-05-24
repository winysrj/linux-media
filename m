Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36539 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbcEXQu5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 12:50:57 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC v2 04/21] media: Only requests in IDLE state may be deleted
Date: Tue, 24 May 2016 19:47:14 +0300
Message-Id: <1464108451-28142-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prevent deleting queued requests. Also mark deleted requests as such by
adding a new state for them.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 21 +++++++++++++++++----
 include/media/media-device.h |  1 +
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 247587b..a89d046 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -41,6 +41,7 @@
 static char *__request_state[] = {
 	"IDLE",
 	"QUEUED",
+	"DELETED",
 };
 
 #define request_state(i)			\
@@ -168,12 +169,22 @@ out_ida_simple_remove:
 	return ret;
 }
 
-static void media_device_request_delete(struct media_device *mdev,
-					struct media_device_request *req)
+static int media_device_request_delete(struct media_device *mdev,
+				       struct media_device_request *req)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&mdev->req_lock, flags);
+
+	if (req->state != MEDIA_DEVICE_REQUEST_STATE_IDLE) {
+		spin_unlock_irqrestore(&mdev->req_lock, flags);
+		dev_dbg(mdev->dev, "request: can't delete %u, state %s\n",
+			req->id, request_state(req->state));
+		return -EINVAL;
+	}
+
+	req->state = MEDIA_DEVICE_REQUEST_STATE_DELETED;
+
 	if (req->filp) {
 		/*
 		 * If the file handle is gone by now the
@@ -184,9 +195,12 @@ static void media_device_request_delete(struct media_device *mdev,
 		list_del(&req->fh_list);
 		req->filp = NULL;
 	}
+
 	spin_unlock_irqrestore(&mdev->req_lock, flags);
 
 	media_device_request_put(req);
+
+	return 0;
 }
 
 static int media_device_request_queue_apply(
@@ -252,8 +266,7 @@ static long media_device_request_cmd(struct media_device *mdev,
 		break;
 
 	case MEDIA_REQ_CMD_DELETE:
-		media_device_request_delete(mdev, req);
-		ret = 0;
+		ret = media_device_request_delete(mdev, req);
 		break;
 
 	case MEDIA_REQ_CMD_APPLY:
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 893e10b..df4afeb 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -268,6 +268,7 @@ struct media_device;
 enum media_device_request_state {
 	MEDIA_DEVICE_REQUEST_STATE_IDLE,
 	MEDIA_DEVICE_REQUEST_STATE_QUEUED,
+	MEDIA_DEVICE_REQUEST_STATE_DELETED,
 };
 
 /**
-- 
1.9.1

