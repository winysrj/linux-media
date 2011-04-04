Return-path: <mchehab@pedra>
Received: from sj-iport-2.cisco.com ([171.71.176.71]:10601 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1DDLwS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 07:52:18 -0400
Received: from OSLEXCP11.eu.tandberg.int ([173.38.136.5])
	by rcdn-core-2.cisco.com (8.14.3/8.14.3) with ESMTP id p34BqDrX001853
	for <linux-media@vger.kernel.org>; Mon, 4 Apr 2011 11:52:16 GMT
Received: from cobaltpc1.rd.tandberg.com (cobaltpc1.rd.tandberg.com [10.47.3.155])
	by ultra.eu.tandberg.int (8.13.1/8.13.1) with ESMTP id p34BqDdH009325
	for <linux-media@vger.kernel.org>; Mon, 4 Apr 2011 13:52:14 +0200
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv1 PATCH 1/9] v4l2-ctrls: add new bitmask control type.
Date: Mon,  4 Apr 2011 13:51:46 +0200
Message-Id: <2fa42294dbc167cae5daf227d072b2284f77b1ab.1301916466.git.hans.verkuil@cisco.com>
In-Reply-To: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-common.c |    3 +++
 drivers/media/video/v4l2-ctrls.c  |   17 ++++++++++++++++-
 include/linux/videodev2.h         |    1 +
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 06b9f9f..5c6100f 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -105,6 +105,9 @@ int v4l2_ctrl_check(struct v4l2_ext_control *ctrl, struct v4l2_queryctrl *qctrl,
 		    menu_items[ctrl->value][0] == '\0')
 			return -EINVAL;
 	}
+	if (qctrl->type == V4L2_CTRL_TYPE_BITMASK &&
+			(ctrl->value & ~qctrl->maximum))
+		return -ERANGE;
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_ctrl_check);
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 2412f08..f75a1d4 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -726,6 +726,10 @@ static int validate_new(struct v4l2_ctrl *ctrl)
 			return -EINVAL;
 		return 0;
 
+	case V4L2_CTRL_TYPE_BITMASK:
+		ctrl->val &= ctrl->maximum;
+		return 0;
+
 	case V4L2_CTRL_TYPE_BUTTON:
 	case V4L2_CTRL_TYPE_CTRL_CLASS:
 		ctrl->val64 = 0;
@@ -962,13 +966,17 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 
 	/* Sanity checks */
 	if (id == 0 || name == NULL || id >= V4L2_CID_PRIVATE_BASE ||
-	    max < min ||
 	    (type == V4L2_CTRL_TYPE_INTEGER && step == 0) ||
+	    (type == V4L2_CTRL_TYPE_BITMASK && max == 0) ||
 	    (type == V4L2_CTRL_TYPE_MENU && qmenu == NULL) ||
 	    (type == V4L2_CTRL_TYPE_STRING && max == 0)) {
 		handler_set_err(hdl, -ERANGE);
 		return NULL;
 	}
+	if (type != V4L2_CTRL_TYPE_BITMASK && max < min) {
+		handler_set_err(hdl, -ERANGE);
+		return NULL;
+	}
 	if ((type == V4L2_CTRL_TYPE_INTEGER ||
 	     type == V4L2_CTRL_TYPE_MENU ||
 	     type == V4L2_CTRL_TYPE_BOOLEAN) &&
@@ -976,6 +984,10 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		handler_set_err(hdl, -ERANGE);
 		return NULL;
 	}
+	if (type == V4L2_CTRL_TYPE_BITMASK && ((def & ~max) || min || step)) {
+		handler_set_err(hdl, -ERANGE);
+		return NULL;
+	}
 
 	if (type == V4L2_CTRL_TYPE_BUTTON)
 		flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
@@ -1217,6 +1229,9 @@ static void log_ctrl(const struct v4l2_ctrl *ctrl,
 	case V4L2_CTRL_TYPE_MENU:
 		printk(KERN_CONT "%s", ctrl->qmenu[ctrl->cur.val]);
 		break;
+	case V4L2_CTRL_TYPE_BITMASK:
+		printk(KERN_CONT "0x%x", ctrl->cur.val);
+		break;
 	case V4L2_CTRL_TYPE_INTEGER64:
 		printk(KERN_CONT "%lld", ctrl->cur.val64);
 		break;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index aa6c393..92d2fdd 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1034,6 +1034,7 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_INTEGER64     = 5,
 	V4L2_CTRL_TYPE_CTRL_CLASS    = 6,
 	V4L2_CTRL_TYPE_STRING        = 7,
+	V4L2_CTRL_TYPE_BITMASK       = 8,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-- 
1.7.1

