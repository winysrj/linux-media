Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63881 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbcEFK4j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 06:56:39 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC 04/22] media: Only requests in IDLE state may be deleted
Date: Fri,  6 May 2016 13:53:13 +0300
Message-Id: <1462532011-15527-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prevent deleting queued requests. Also mark deleted requests as such by
adding a new state for them.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 14 ++++++++++++--
 include/media/media-device.h |  1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 481e8e4..5b7bfcf 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -195,6 +195,7 @@ static long media_device_request_cmd(struct media_device *mdev,
 {
 	struct media_device_fh *fh = media_device_fh(filp);
 	struct media_device_request *req = NULL;
+	unsigned long flags;
 	int ret;
 
 	if (!mdev->ops || !mdev->ops->req_alloc || !mdev->ops->req_free)
@@ -212,8 +213,17 @@ static long media_device_request_cmd(struct media_device *mdev,
 		break;
 
 	case MEDIA_REQ_CMD_DELETE:
-		media_device_request_delete(mdev, req);
-		ret = 0;
+		spin_lock_irqsave(&mdev->req_lock, flags);
+		if (req->state == MEDIA_DEVICE_REQUEST_STATE_IDLE) {
+			ret = 0;
+			req->state = MEDIA_DEVICE_REQUEST_STATE_DELETED;
+		} else {
+			ret = -EINVAL;
+		}
+		spin_unlock_irqrestore(&mdev->req_lock, flags);
+
+		if (!ret)
+			media_device_request_delete(mdev, req);
 		break;
 
 	case MEDIA_REQ_CMD_APPLY:
diff --git a/include/media/media-device.h b/include/media/media-device.h
index acb2481..3167c52 100644
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

