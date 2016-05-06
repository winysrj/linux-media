Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:19796 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbcEFK4j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 06:56:39 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC 02/22] media: Add media device request state
Date: Fri,  6 May 2016 13:53:11 +0300
Message-Id: <1462532011-15527-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/media-device.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/media/media-device.h b/include/media/media-device.h
index 49c3367a..acb2481 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -265,6 +265,11 @@ struct ida;
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
@@ -279,6 +286,7 @@ struct media_device_request {
 	struct kref kref;
 	struct list_head list;
 	struct list_head fh_list;
+	enum media_device_request_state state;
 };
 
 /**
-- 
1.9.1

