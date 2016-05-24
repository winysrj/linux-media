Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40731 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbcEXQu7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 12:50:59 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC v2 03/21] media: Prevent queueing queued requests
Date: Tue, 24 May 2016 19:47:13 +0300
Message-Id: <1464108451-28142-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Verify that the request state is IDLE before queueing it. Also mark
requests queued when they're queued, and return the request to IDLE if
queueing it failed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 55 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 47 insertions(+), 8 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 7781c49..247587b 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -189,6 +189,47 @@ static void media_device_request_delete(struct media_device *mdev,
 	media_device_request_put(req);
 }
 
+static int media_device_request_queue_apply(
+	struct media_device *mdev, struct media_device_request *req,
+	int (*fn)(struct media_device *mdev,
+		  struct media_device_request *req), bool queue)
+{
+	char *str = queue ? "queue" : "apply";
+	unsigned long flags;
+	int rval = 0;
+
+	if (!fn)
+		return -ENOSYS;
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	if (req->state != MEDIA_DEVICE_REQUEST_STATE_IDLE) {
+		rval = -EINVAL;
+		dev_dbg(mdev->dev,
+			"request: unable to %s %u, request in state %s\n",
+			str, req->id, request_state(req->state));
+	} else {
+		req->state = MEDIA_DEVICE_REQUEST_STATE_QUEUED;
+	}
+	spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+	if (rval)
+		return rval;
+
+	rval = fn(mdev, req);
+	if (rval) {
+		spin_lock_irqsave(&mdev->req_lock, flags);
+		req->state = MEDIA_DEVICE_REQUEST_STATE_IDLE;
+		spin_unlock_irqrestore(&mdev->req_lock, flags);
+		dev_dbg(mdev->dev,
+			"request: can't %s %u\n", str, req->id);
+	} else {
+		dev_dbg(mdev->dev,
+			"request: %s %u\n", str, req->id);
+	}
+
+	return rval;
+}
+
 static long media_device_request_cmd(struct media_device *mdev,
 				     struct file *filp,
 				     struct media_request_cmd *cmd)
@@ -216,17 +257,15 @@ static long media_device_request_cmd(struct media_device *mdev,
 		break;
 
 	case MEDIA_REQ_CMD_APPLY:
-		if (!mdev->ops->req_apply)
-			return -ENOSYS;
-
-		ret = mdev->ops->req_apply(mdev, req);
+		ret = media_device_request_queue_apply(mdev, req,
+						       mdev->ops->req_apply,
+						       false);
 		break;
 
 	case MEDIA_REQ_CMD_QUEUE:
-		if (!mdev->ops->req_queue)
-			return -ENOSYS;
-
-		ret = mdev->ops->req_queue(mdev, req);
+		ret = media_device_request_queue_apply(mdev, req,
+						       mdev->ops->req_queue,
+						       true);
 		break;
 
 	default:
-- 
1.9.1

