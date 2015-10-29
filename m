Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:35410 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638AbbJ2KKo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 06:10:44 -0400
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
Subject: [PATCH v2 5/6] media/usb/pvrusb2: Support for V4L2_CTRL_WHICH_DEF_VAL
Date: Thu, 29 Oct 2015 11:10:31 +0100
Message-Id: <1446113432-27390-6-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1446113432-27390-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1446113432-27390-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver does not use the control infrastructure.
Add support for the new field which on structure
 v4l2_ext_controls

Acked-by: Mike Isely <isely@pobox.com>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 1c5f85bf7ed4..81f788b7b242 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -628,6 +628,7 @@ static int pvr2_g_ext_ctrls(struct file *file, void *priv,
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
 	struct v4l2_ext_control *ctrl;
+	struct pvr2_ctrl *cptr;
 	unsigned int idx;
 	int val;
 	int ret;
@@ -635,8 +636,15 @@ static int pvr2_g_ext_ctrls(struct file *file, void *priv,
 	ret = 0;
 	for (idx = 0; idx < ctls->count; idx++) {
 		ctrl = ctls->controls + idx;
-		ret = pvr2_ctrl_get_value(
-				pvr2_hdw_get_ctrl_v4l(hdw, ctrl->id), &val);
+		cptr = pvr2_hdw_get_ctrl_v4l(hdw, ctrl->id);
+		if (cptr) {
+			if (ctls->which == V4L2_CTRL_WHICH_DEF_VAL)
+				pvr2_ctrl_get_def(cptr, &val);
+			else
+				ret = pvr2_ctrl_get_value(cptr, &val);
+		} else
+			ret = -EINVAL;
+
 		if (ret) {
 			ctls->error_idx = idx;
 			return ret;
@@ -658,6 +666,10 @@ static int pvr2_s_ext_ctrls(struct file *file, void *priv,
 	unsigned int idx;
 	int ret;
 
+	/* Default value cannot be changed */
+	if (ctls->which == V4L2_CTRL_WHICH_DEF_VAL)
+		return -EINVAL;
+
 	ret = 0;
 	for (idx = 0; idx < ctls->count; idx++) {
 		ctrl = ctls->controls + idx;
-- 
2.6.1

