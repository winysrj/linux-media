Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:48874 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab0JFI7o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 04:59:44 -0400
Received: from localhost.localdomain (unknown [91.178.188.185])
	by perceval.irobotique.be (Postfix) with ESMTPSA id 59BE435FEE
	for <linux-media@vger.kernel.org>; Wed,  6 Oct 2010 08:59:40 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 10/14] uvcvideo: Remove sysadmin requirements for UVCIOC_CTRL_MAP
Date: Wed,  6 Oct 2010 10:59:48 +0200
Message-Id: <1286355592-13603-11-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Martin Rubli <martin_rubli@logitech.com>

This patch removes the sysadmin requirements for UVCIOC_CTRL_MAP (and the stub
implementation of UVCIOC_CTRL_ADD). This requirement no longer makes sense with
the new XU control access mechanisms since XU controls can be accessed without
adding control mappings first.

A maximum number (currently 1024) of control mappings per device is enforced to
avoid excess memory consumption caused by careless user space applications.

Signed-off-by: Martin Rubli <martin_rubli@logitech.com>
---
 drivers/media/video/uvc/uvc_ctrl.c   |   14 ++++++++++++++
 drivers/media/video/uvc/uvc_driver.c |    1 +
 drivers/media/video/uvc/uvc_v4l2.c   |    6 ------
 drivers/media/video/uvc/uvcvideo.h   |    4 ++++
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 2c81b7f..531a3e1 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -1435,6 +1435,7 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 	struct uvc_entity *entity;
 	struct uvc_control *ctrl;
 	int found = 0;
+	int ret;
 
 	if (mapping->id & ~V4L2_CTRL_ID_MASK) {
 		uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s', control "
@@ -1478,7 +1479,20 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 		}
 	}
 
+	/* Prevent excess memory consumption */
+	if (atomic_inc_return(&dev->nmappings) > UVC_MAX_CONTROL_MAPPINGS) {
+		atomic_dec(&dev->nmappings);
+		uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s', maximum "
+			"mappings count (%u) exceeded.\n", mapping->name,
+			UVC_MAX_CONTROL_MAPPINGS);
+		ret = -ENOMEM;
+		goto done;
+	}
+
 	ret = __uvc_ctrl_add_mapping(dev, ctrl, mapping);
+	if (ret < 0)
+		atomic_dec(&dev->nmappings);
+
 done:
 	mutex_unlock(&chain->ctrl_mutex);
 	return ret;
diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 71efda7..a1e9dfb 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1760,6 +1760,7 @@ static int uvc_probe(struct usb_interface *intf,
 	INIT_LIST_HEAD(&dev->streams);
 	atomic_set(&dev->nstreams, 0);
 	atomic_set(&dev->users, 0);
+	atomic_set(&dev->nmappings, 0);
 
 	dev->udev = usb_get_dev(udev);
 	dev->intf = usb_get_intf(intf);
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 4a51048..6d15de9 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -1025,16 +1025,10 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	/* Dynamic controls. */
 	case UVCIOC_CTRL_ADD:
 		/* Legacy ioctl, kept for API compatibility reasons */
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
 		return -EEXIST;
 
 	case UVCIOC_CTRL_MAP_OLD:
 	case UVCIOC_CTRL_MAP:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
 		return uvc_ioctl_ctrl_map(chain, arg,
 					  cmd == UVCIOC_CTRL_MAP_OLD);
 
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 34637fb..39e9e36 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -172,6 +172,9 @@ struct uvc_xu_control {
 #define UVC_CTRL_CONTROL_TIMEOUT	300
 #define UVC_CTRL_STREAMING_TIMEOUT	5000
 
+/* Maximum allowed number of control mappings per device */
+#define UVC_MAX_CONTROL_MAPPINGS	1024
+
 /* Devices quirks */
 #define UVC_QUIRK_STATUS_INTERVAL	0x00000001
 #define UVC_QUIRK_PROBE_MINMAX		0x00000002
@@ -472,6 +475,7 @@ struct uvc_device {
 
 	enum uvc_device_state state;
 	atomic_t users;
+	atomic_t nmappings;
 
 	/* Video control interface */
 	__u16 uvc_version;
-- 
1.7.2.2

