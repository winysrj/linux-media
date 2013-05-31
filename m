Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4408 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab3EaKDe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 20/21] radio-sf16fmi: convert to the control framework.
Date: Fri, 31 May 2013 12:02:40 +0200
Message-Id: <1369994561-25236-21-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/radio/radio-sf16fmi.c |   56 ++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 31 deletions(-)

diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index 9cd0338..b058f36 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -27,6 +27,7 @@
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
 #include "lm7000.h"
 
 MODULE_AUTHOR("Petr Vandrovec, vandrove@vc.cvut.cz and M. Kirkwood");
@@ -44,6 +45,7 @@ module_param(radio_nr, int, 0);
 struct fmi
 {
 	struct v4l2_device v4l2_dev;
+	struct v4l2_ctrl_handler hdl;
 	struct video_device vdev;
 	int io;
 	bool mute;
@@ -178,46 +180,26 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_queryctrl(struct file *file, void *priv,
-					struct v4l2_queryctrl *qc)
+static int fmi_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
-	}
-	return -EINVAL;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-					struct v4l2_control *ctrl)
-{
-	struct fmi *fmi = video_drvdata(file);
+	struct fmi *fmi = container_of(ctrl->handler, struct fmi, hdl);
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = fmi->mute;
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-					struct v4l2_control *ctrl)
-{
-	struct fmi *fmi = video_drvdata(file);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		if (ctrl->value)
+		if (ctrl->val)
 			fmi_mute(fmi);
 		else
 			fmi_unmute(fmi);
-		fmi->mute = ctrl->value;
+		fmi->mute = ctrl->val;
 		return 0;
 	}
 	return -EINVAL;
 }
 
+static const struct v4l2_ctrl_ops fmi_ctrl_ops = {
+	.s_ctrl = fmi_s_ctrl,
+};
+
 static const struct v4l2_file_operations fmi_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= video_ioctl2,
@@ -229,9 +211,6 @@ static const struct v4l2_ioctl_ops fmi_ioctl_ops = {
 	.vidioc_s_tuner     = vidioc_s_tuner,
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
-	.vidioc_queryctrl   = vidioc_queryctrl,
-	.vidioc_g_ctrl      = vidioc_g_ctrl,
-	.vidioc_s_ctrl      = vidioc_s_ctrl,
 };
 
 /* ladis: this is my card. does any other types exist? */
@@ -281,6 +260,7 @@ static int __init fmi_init(void)
 {
 	struct fmi *fmi = &fmi_card;
 	struct v4l2_device *v4l2_dev = &fmi->v4l2_dev;
+	struct v4l2_ctrl_handler *hdl = &fmi->hdl;
 	int res, i;
 	int probe_ports[] = { 0, 0x284, 0x384 };
 
@@ -333,6 +313,18 @@ static int __init fmi_init(void)
 		return res;
 	}
 
+	v4l2_ctrl_handler_init(hdl, 1);
+	v4l2_ctrl_new_std(hdl, &fmi_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
+	v4l2_dev->ctrl_handler = hdl;
+	if (hdl->error) {
+		res = hdl->error;
+		v4l2_err(v4l2_dev, "Could not register controls\n");
+		v4l2_ctrl_handler_free(hdl);
+		v4l2_device_unregister(v4l2_dev);
+		return res;
+	}
+
 	strlcpy(fmi->vdev.name, v4l2_dev->name, sizeof(fmi->vdev.name));
 	fmi->vdev.v4l2_dev = v4l2_dev;
 	fmi->vdev.fops = &fmi_fops;
@@ -346,6 +338,7 @@ static int __init fmi_init(void)
 	fmi_mute(fmi);
 
 	if (video_register_device(&fmi->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
+		v4l2_ctrl_handler_free(hdl);
 		v4l2_device_unregister(v4l2_dev);
 		release_region(fmi->io, 2);
 		if (pnp_attached)
@@ -361,6 +354,7 @@ static void __exit fmi_exit(void)
 {
 	struct fmi *fmi = &fmi_card;
 
+	v4l2_ctrl_handler_free(&fmi->hdl);
 	video_unregister_device(&fmi->vdev);
 	v4l2_device_unregister(&fmi->v4l2_dev);
 	release_region(fmi->io, 2);
-- 
1.7.10.4

