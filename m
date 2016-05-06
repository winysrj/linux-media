Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:1410 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbcEFK4k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 06:56:40 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC 05/22] media: Add media_device_request_complete() to mark requests complete
Date: Fri,  6 May 2016 13:53:14 +0300
Message-Id: <1462532011-15527-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Once the request has been queued and later on completed, a driver will
mark the request complete by calling media_device_request_complete().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 7 +++++++
 include/media/media-device.h | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 5b7bfcf..cbd3b8b 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -158,6 +158,13 @@ static void media_device_request_delete(struct media_device *mdev,
 	media_device_request_put(req);
 }
 
+void media_device_request_complete(struct media_device *mdev,
+				   struct media_device_request *req)
+{
+	media_device_request_delete(mdev, req);
+}
+EXPORT_SYMBOL_GPL(media_device_request_complete);
+
 static int media_device_request_queue_apply(
 	struct media_device *mdev, struct media_device_request *req,
 	int (*fn)(struct media_device *mdev,
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 3167c52..d86fb8a 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -269,6 +269,7 @@ enum media_device_request_state {
 	MEDIA_DEVICE_REQUEST_STATE_IDLE,
 	MEDIA_DEVICE_REQUEST_STATE_QUEUED,
 	MEDIA_DEVICE_REQUEST_STATE_DELETED,
+	MEDIA_DEVICE_REQUEST_STATE_COMPLETE,
 };
 
 /**
@@ -764,5 +765,7 @@ struct media_device_request *
 media_device_request_find(struct media_device *mdev, u16 reqid);
 void media_device_request_get(struct media_device_request *req);
 void media_device_request_put(struct media_device_request *req);
+void media_device_request_complete(struct media_device *mdev,
+				   struct media_device_request *req);
 
 #endif
-- 
1.9.1

