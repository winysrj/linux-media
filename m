Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:19796 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758049AbcEFK4k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 06:56:40 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC 03/22] media: Prevent queueing queued requests
Date: Fri,  6 May 2016 13:53:12 +0300
Message-Id: <1462532011-15527-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Verify that the request state is IDLE before queueing it. Also mark
requests queued when they're queued, and return the request to IDLE if
queueing it failed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 43 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 4fc1eb1..481e8e4 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -158,6 +158,37 @@ static void media_device_request_delete(struct media_device *mdev,
 	media_device_request_put(req);
 }
 
+static int media_device_request_queue_apply(
+	struct media_device *mdev, struct media_device_request *req,
+	int (*fn)(struct media_device *mdev,
+		  struct media_device_request *req))
+{
+	unsigned long flags;
+	int rval = 0;
+
+	if (!fn)
+		return -ENOSYS;
+
+	spin_lock_irqsave(&mdev->req_lock, flags);
+	if (req->state != MEDIA_DEVICE_REQUEST_STATE_IDLE)
+		rval = -EINVAL;
+	else
+		req->state = MEDIA_DEVICE_REQUEST_STATE_QUEUED;
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
+	}
+
+	return rval;
+}
+
 static long media_device_request_cmd(struct media_device *mdev,
 				     struct file *filp,
 				     struct media_request_cmd *cmd)
@@ -186,17 +217,13 @@ static long media_device_request_cmd(struct media_device *mdev,
 		break;
 
 	case MEDIA_REQ_CMD_APPLY:
-		if (!mdev->ops->req_apply)
-			return -ENOSYS;
-
-		ret = mdev->ops->req_apply(mdev, req);
+		ret = media_device_request_queue_apply(mdev, req,
+						       mdev->ops->req_apply);
 		break;
 
 	case MEDIA_REQ_CMD_QUEUE:
-		if (!mdev->ops->req_queue)
-			return -ENOSYS;
-
-		ret = mdev->ops->req_queue(mdev, req);
+		ret = media_device_request_queue_apply(mdev, req,
+						       mdev->ops->req_queue);
 		break;
 
 	default:
-- 
1.9.1

