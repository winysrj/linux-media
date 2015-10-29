Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:33883 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342AbbJ2KKn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 06:10:43 -0400
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
Subject: [PATCH v2 4/6] usb/uvc: Support for V4L2_CTRL_WHICH_DEF_VAL
Date: Thu, 29 Oct 2015 11:10:30 +0100
Message-Id: <1446113432-27390-5-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1446113432-27390-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1446113432-27390-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver does not use the control infrastructure.
Add support for the new field which on structure
 v4l2_ext_controls

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 2764f43607c1..d7723ce772b3 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -983,6 +983,22 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
 	unsigned int i;
 	int ret;
 
+	if (ctrls->which == V4L2_CTRL_WHICH_DEF_VAL) {
+		for (i = 0; i < ctrls->count; ++ctrl, ++i) {
+			struct v4l2_queryctrl qc = { .id = ctrl->id };
+
+			ret = uvc_query_v4l2_ctrl(chain, &qc);
+			if (ret < 0) {
+				ctrls->error_idx = i;
+				return ret;
+			}
+
+			ctrl->value = qc.default_value;
+		}
+
+		return 0;
+	}
+
 	ret = uvc_ctrl_begin(chain);
 	if (ret < 0)
 		return ret;
@@ -1010,6 +1026,10 @@ static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh *handle,
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
2.6.1

