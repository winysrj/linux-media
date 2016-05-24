Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:62295 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463AbcEXQvA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 12:51:00 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC v2 14/21] media: Make events on request completion optional, disabled by default
Date: Tue, 24 May 2016 19:47:24 +0300
Message-Id: <1464108451-28142-15-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add flags to requests. The first defined flag, MEDIA_REQ_FL_COMPLETE_EVENT
is used to tell whether to queue an event on request completion. Unless
the flag is set, no event is generated when a request completes.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 24 ++++++++++++++++--------
 include/media/media-device.h |  2 ++
 include/uapi/linux/media.h   | 10 ++++++++++
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index d00d3fc..2ff8b29 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -348,8 +348,10 @@ void media_device_request_complete(struct media_device *mdev,
 		 */
 		list_del(&req->list);
 		list_del(&req->fh_list);
-		media_device_request_queue_event(
-			mdev, req, media_device_fh(filp));
+		/* If the user asked for an event, let's queue one. */
+		if (req->flags & MEDIA_REQ_FL_COMPLETE_EVENT)
+			media_device_request_queue_event(
+				mdev, req, media_device_fh(filp));
 		req->filp = NULL;
 	}
 
@@ -367,8 +369,8 @@ EXPORT_SYMBOL_GPL(media_device_request_complete);
 
 static int media_device_request_queue_apply(
 	struct media_device *mdev, struct media_device_request *req,
-	int (*fn)(struct media_device *mdev,
-		  struct media_device_request *req), bool queue)
+	u32 req_flags, int (*fn)(struct media_device *mdev,
+				 struct media_device_request *req), bool queue)
 {
 	char *str = queue ? "queue" : "apply";
 	unsigned long flags;
@@ -385,6 +387,7 @@ static int media_device_request_queue_apply(
 			str, req->id, request_state(req->state));
 	} else {
 		req->state = MEDIA_DEVICE_REQUEST_STATE_QUEUED;
+		req->flags = req_flags;
 	}
 	spin_unlock_irqrestore(&mdev->req_lock, flags);
 
@@ -432,13 +435,13 @@ static long media_device_request_cmd(struct media_device *mdev,
 		break;
 
 	case MEDIA_REQ_CMD_APPLY:
-		ret = media_device_request_queue_apply(mdev, req,
+		ret = media_device_request_queue_apply(mdev, req, cmd->flags,
 						       mdev->ops->req_apply,
 						       false);
 		break;
 
 	case MEDIA_REQ_CMD_QUEUE:
-		ret = media_device_request_queue_apply(mdev, req,
+		ret = media_device_request_queue_apply(mdev, req, cmd->flags,
 						       mdev->ops->req_queue,
 						       true);
 		break;
@@ -1015,13 +1018,18 @@ out_free:
 	return ret;
 }
 
+static const unsigned short media_request_cmd_sizes[] = {
+	sizeof(struct media_request_cmd_0),
+	0
+};
+
 static const struct media_ioctl_info ioctl_info[] = {
 	MEDIA_IOC(DEVICE_INFO, media_device_get_info, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
-	MEDIA_IOC(REQUEST_CMD, media_device_request_cmd, 0),
+	MEDIA_IOC_SZ(REQUEST_CMD, media_device_request_cmd, 0, media_request_cmd_sizes),
 	MEDIA_IOC(DQEVENT, media_device_dqevent, 0),
 };
 
@@ -1070,7 +1078,7 @@ static const struct media_ioctl_info compat_ioctl_info[] = {
 	MEDIA_IOC_ARG(ENUM_LINKS32, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX, from_user_enum_links32, copy_arg_to_user_nop),
 	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
-	MEDIA_IOC(REQUEST_CMD, media_device_request_cmd, 0),
+	MEDIA_IOC_SZ(REQUEST_CMD, media_device_request_cmd, 0, media_request_cmd_sizes),
 	MEDIA_IOC(DQEVENT, media_device_dqevent, 0),
 };
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 21b3deb..15d496c 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -291,6 +291,7 @@ struct media_kevent {
  * @state: The state of the request, MEDIA_DEVICE_REQUEST_STATE_*,
  *	   access to state serialised by mdev->req_lock
  * @data: Per-entity data list
+ * @flags: Request specific flags, MEDIA_REQ_FL_*
  */
 struct media_device_request {
 	u32 id;
@@ -302,6 +303,7 @@ struct media_device_request {
 	struct list_head fh_list;
 	enum media_device_request_state state;
 	struct list_head data;
+	u32 flags;
 };
 
 /**
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 60cc34c..2092720 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -394,9 +394,19 @@ struct media_v2_topology {
 #define MEDIA_REQ_CMD_APPLY		2
 #define MEDIA_REQ_CMD_QUEUE		3
 
+#define MEDIA_REQ_FL_COMPLETE_EVENT	(1 << 0)
+
+#ifdef __KERNEL__
+struct __attribute__ ((packed)) media_request_cmd_0 {
+	__u32 cmd;
+	__u32 request;
+};
+#endif
+
 struct __attribute__ ((packed)) media_request_cmd {
 	__u32 cmd;
 	__u32 request;
+	__u32 flags;
 };
 
 struct __attribute__ ((packed)) media_event_request_complete {
-- 
1.9.1

