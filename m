Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:44968 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512Ab2DTPTj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 11:19:39 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	=?UTF-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
Subject: [RFC PATCH 3/3] [media] gspca - main: implement vidioc_g_ext_ctrls and vidioc_s_ext_ctrls
Date: Fri, 20 Apr 2012 17:19:11 +0200
Message-Id: <1334935152-16165-4-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1334935152-16165-1-git-send-email-ospite@studenti.unina.it>
References: <20120418153720.1359c7d2f2a3efc2c7c17b88@studenti.unina.it>
 <1334935152-16165-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes it possible for applications to handle controls with a class
different than V4L2_CTRL_CLASS_USER for gspca subdevices, like for
instance V4L2_CID_EXPOSURE_AUTO which some subdrivers use and which
can't be controlled right now.

See
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/47010
for an example of a problem fixed by this change.

NOTE: gspca currently won't handle control types like
V4L2_CTRL_TYPE_INTEGER64 or V4L2_CTRL_TYPE_STRING, so just the
__s32 field 'value' of 'struct v4l2_ext_control' is handled for now.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/video/gspca/gspca.c |   42 +++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index ba1bda9..7906093 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -1567,6 +1567,46 @@ static int vidioc_g_ctrl(struct file *file, void *priv,
 	return gspca_get_ctrl(gspca_dev, ctrl->id, &ctrl->value);
 }
 
+static int vidioc_s_ext_ctrls(struct file *file, void *priv,
+			 struct v4l2_ext_controls *ext_ctrls)
+{
+	struct gspca_dev *gspca_dev = priv;
+	int ret = 0;
+	int i;
+
+	for (i = 0; i < ext_ctrls->count; i++) {
+		struct v4l2_ext_control *ctrl;
+
+		ctrl = ext_ctrls->controls + i;
+		ret = gspca_set_ctrl(gspca_dev, ctrl->id, ctrl->value);
+		if (ret < 0) {
+			ext_ctrls->error_idx = i;
+			return ret;
+		}
+	}
+	return ret;
+}
+
+static int vidioc_g_ext_ctrls(struct file *file, void *priv,
+			 struct v4l2_ext_controls *ext_ctrls)
+{
+	struct gspca_dev *gspca_dev = priv;
+	int i;
+	int ret = 0;
+
+	for (i = 0; i < ext_ctrls->count; i++) {
+		struct v4l2_ext_control *ctrl;
+
+		ctrl = ext_ctrls->controls + i;
+		ret = gspca_get_ctrl(gspca_dev, ctrl->id, &ctrl->value);
+		if (ret < 0) {
+			ext_ctrls->error_idx = i;
+			return ret;
+		}
+	}
+	return ret;
+}
+
 static int vidioc_querymenu(struct file *file, void *priv,
 			    struct v4l2_querymenu *qmenu)
 {
@@ -2260,6 +2300,8 @@ static const struct v4l2_ioctl_ops dev_ioctl_ops = {
 	.vidioc_queryctrl	= vidioc_queryctrl,
 	.vidioc_g_ctrl		= vidioc_g_ctrl,
 	.vidioc_s_ctrl		= vidioc_s_ctrl,
+	.vidioc_g_ext_ctrls	= vidioc_g_ext_ctrls,
+	.vidioc_s_ext_ctrls	= vidioc_s_ext_ctrls,
 	.vidioc_querymenu	= vidioc_querymenu,
 	.vidioc_enum_input	= vidioc_enum_input,
 	.vidioc_g_input		= vidioc_g_input,
-- 
1.7.10

