Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [RFC v3 05/19] media/pci/saa7164-encoder: Implement
 vivioc_g_def_ext_ctrls
Date: Fri, 12 Jun 2015 18:46:24 +0200
Message-id: <1434127598-11719-6-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

Callback needed by ioctl VIDIOC_G_DEF_EXT_CTRLS as this driver does not
use the controller framework.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/pci/saa7164/saa7164-encoder.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 4434e0f28c26..63840b0000c0 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -884,6 +884,33 @@ static int vidioc_queryctrl(struct file *file, void *priv,
 	return -EINVAL;
 }
 
+static int vidioc_g_def_ext_ctrls(struct file *file, void *priv,
+	struct v4l2_ext_controls *ctrls)
+{
+	struct saa7164_encoder_fh *fh = file->private_data;
+	struct saa7164_port *port = fh->port;
+	int i, err = 0;
+	struct v4l2_queryctrl q;
+
+	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
+		for (i = 0; i < ctrls->count; i++) {
+			struct v4l2_ext_control *ctrl = ctrls->controls + i;
+
+			q.id = ctrl->id;
+			err = fill_queryctrl(&port->encoder_params, &q);
+			if (err) {
+				ctrls->error_idx = i;
+				break;
+			}
+			ctrl->value = q.default_value;
+		}
+		return err;
+
+	}
+
+	return -EINVAL;
+}
+
 static int saa7164_encoder_stop_port(struct saa7164_port *port)
 {
 	struct saa7164_dev *dev = port->dev;
@@ -1317,6 +1344,7 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_try_fmt_vid_cap	 = vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap	 = vidioc_s_fmt_vid_cap,
 	.vidioc_g_ext_ctrls	 = vidioc_g_ext_ctrls,
+	.vidioc_g_def_ext_ctrls	 = vidioc_g_def_ext_ctrls,
 	.vidioc_s_ext_ctrls	 = vidioc_s_ext_ctrls,
 	.vidioc_try_ext_ctrls	 = vidioc_try_ext_ctrls,
 	.vidioc_queryctrl	 = vidioc_queryctrl,
-- 
2.1.4
