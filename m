Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:36206 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbbGPI4s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 04:56:48 -0400
Received: by lagw2 with SMTP id w2so39446729lag.3
        for <linux-media@vger.kernel.org>; Thu, 16 Jul 2015 01:56:47 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [RFC v4 04/19] media/usb/uvc: Implement vivioc_g_def_ext_ctrls
Date: Thu, 16 Jul 2015 10:56:43 +0200
Message-Id: <1437037003-6113-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Callback needed by ioctl VIDIOC_G_DEF_EXT_CTRLS as this driver does not
use the controller framework.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
Changelog

v4: Comments by Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Remove unneeded  uvc_ctrl_begin()


 drivers/media/usb/uvc/uvc_v4l2.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 2764f43607c1..7ec7d45b24ed 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -1001,6 +1001,31 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
 	return uvc_ctrl_rollback(handle);
 }
 
+static int uvc_ioctl_g_def_ext_ctrls(struct file *file, void *fh,
+				     struct v4l2_ext_controls *ctrls)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_video_chain *chain = handle->chain;
+	struct v4l2_ext_control *ctrl = ctrls->controls;
+	unsigned int i;
+	int ret;
+	struct v4l2_queryctrl qc;
+
+	for (i = 0; i < ctrls->count; ++ctrl, ++i) {
+		qc.id = ctrl->id;
+		ret = uvc_query_v4l2_ctrl(chain, &qc);
+		if (ret < 0) {
+			ctrls->error_idx = i;
+			return ret;
+		}
+		ctrl->value = qc.default_value;
+	}
+
+	ctrls->error_idx = 0;
+
+	return 0;
+}
+
 static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh *handle,
 				     struct v4l2_ext_controls *ctrls,
 				     bool commit)
@@ -1500,6 +1525,7 @@ const struct v4l2_ioctl_ops uvc_ioctl_ops = {
 	.vidioc_g_ctrl = uvc_ioctl_g_ctrl,
 	.vidioc_s_ctrl = uvc_ioctl_s_ctrl,
 	.vidioc_g_ext_ctrls = uvc_ioctl_g_ext_ctrls,
+	.vidioc_g_def_ext_ctrls = uvc_ioctl_g_def_ext_ctrls,
 	.vidioc_s_ext_ctrls = uvc_ioctl_s_ext_ctrls,
 	.vidioc_try_ext_ctrls = uvc_ioctl_try_ext_ctrls,
 	.vidioc_querymenu = uvc_ioctl_querymenu,
-- 
2.1.4

