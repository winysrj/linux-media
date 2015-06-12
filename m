Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [RFC v3 07/19] media/usb/prusb2: Implement vivioc_g_def_ext_ctrls
Date: Fri, 12 Jun 2015 18:46:26 +0200
Message-id: <1434127598-11719-8-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

Callback needed by ioctl VIDIOC_G_DEF_EXT_CTRLS as this driver does not
use the controller framework.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 1c5f85bf7ed4..16198c53ffa3 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -649,6 +649,33 @@ static int pvr2_g_ext_ctrls(struct file *file, void *priv,
 	return 0;
 }
 
+static int pvr2_g_def_ext_ctrls(struct file *file, void *priv,
+					struct v4l2_ext_controls *ctls)
+{
+	struct pvr2_v4l2_fh *fh = file->private_data;
+	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
+	struct v4l2_ext_control *ctrl;
+	unsigned int idx;
+	int ret;
+	struct pvr2_ctrl *cptr;
+
+	ret = 0;
+	for (idx = 0; idx < ctls->count; idx++) {
+		ctrl = ctls->controls + idx;
+		cptr = pvr2_hdw_get_ctrl_v4l(hdw, ctrl->id);
+		if (!ctrl){
+			ctls->error_idx = idx;
+			return -EINVAL;
+		}
+
+		/* Ensure that if read as a 64 bit value, the user
+		   will still get a hopefully sane value */
+		ctrl->value64 = 0;
+		pvr2_ctrl_get_def(cptr, &ctrl->value);
+	}
+	return 0;
+}
+
 static int pvr2_s_ext_ctrls(struct file *file, void *priv,
 		struct v4l2_ext_controls *ctls)
 {
@@ -809,6 +836,7 @@ static const struct v4l2_ioctl_ops pvr2_ioctl_ops = {
 	.vidioc_g_ctrl			    = pvr2_g_ctrl,
 	.vidioc_s_ctrl			    = pvr2_s_ctrl,
 	.vidioc_g_ext_ctrls		    = pvr2_g_ext_ctrls,
+	.vidioc_g_def_ext_ctrls		    = pvr2_g_def_ext_ctrls,
 	.vidioc_s_ext_ctrls		    = pvr2_s_ext_ctrls,
 	.vidioc_try_ext_ctrls		    = pvr2_try_ext_ctrls,
 };
-- 
2.1.4
