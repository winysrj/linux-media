Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34064 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbbHUJ34 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 05:29:56 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Isely <isely@pobox.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Steven Toth <stoth@kernellabs.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vincent Palatin <vpalatin@chromium.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 4/8] usb/uvc: Support for V4L2_CTRL_WHICH_DEF_VAL
Date: Fri, 21 Aug 2015 11:29:42 +0200
Message-Id: <1440149386-19783-5-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1440149386-19783-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1440149386-19783-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver does not use the control infrastructure.
Add support for the new field which on structure
 v4l2_ext_controls

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 2764f43607c1..e6d3a1bcfa2f 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -980,6 +980,7 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
 	struct uvc_fh *handle = fh;
 	struct uvc_video_chain *chain = handle->chain;
 	struct v4l2_ext_control *ctrl = ctrls->controls;
+	struct v4l2_queryctrl qc;
 	unsigned int i;
 	int ret;
 
@@ -988,7 +989,14 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
 		return ret;
 
 	for (i = 0; i < ctrls->count; ++ctrl, ++i) {
-		ret = uvc_ctrl_get(chain, ctrl);
+		if (ctrls->which == V4L2_CTRL_WHICH_DEF_VAL) {
+			qc.id = ctrl->id;
+			ret = uvc_query_v4l2_ctrl(chain, &qc);
+			if (!ret)
+				ctrl->value = qc.default_value;
+		} else
+			ret = uvc_ctrl_get(chain, ctrl);
+
 		if (ret < 0) {
 			uvc_ctrl_rollback(handle);
 			ctrls->error_idx = i;
@@ -1010,6 +1018,10 @@ static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh *handle,
 	unsigned int i;
 	int ret;
 
+	/* Default value cannot be changed */
+	if (ctrls->which == V4L2_CTRL_WHICH_DEF_VAL)
+		return -EINVAL;
+
 	ret = uvc_ctrl_begin(chain);
 	if (ret < 0)
 		return ret;
-- 
2.5.0

