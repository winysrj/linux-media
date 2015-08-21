Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34882 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbbHUJ36 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 05:29:58 -0400
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
Subject: [PATCH 6/8] media/pci/saa7164-encoder Support for V4L2_CTRL_WHICH_DEF_VAL
Date: Fri, 21 Aug 2015 11:29:44 +0200
Message-Id: <1440149386-19783-7-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1440149386-19783-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1440149386-19783-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver does not use the control infrastructure.
Add support for the new field which on structure
 v4l2_ext_controls

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/pci/saa7164/saa7164-encoder.c | 55 ++++++++++++++++-------------
 1 file changed, 31 insertions(+), 24 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 4434e0f28c26..e897b83b66dd 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -531,30 +531,6 @@ static int saa7164_get_ctrl(struct saa7164_port *port,
 	return 0;
 }
 
-static int vidioc_g_ext_ctrls(struct file *file, void *priv,
-	struct v4l2_ext_controls *ctrls)
-{
-	struct saa7164_encoder_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	int i, err = 0;
-
-	if (ctrls->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		for (i = 0; i < ctrls->count; i++) {
-			struct v4l2_ext_control *ctrl = ctrls->controls + i;
-
-			err = saa7164_get_ctrl(port, ctrl);
-			if (err) {
-				ctrls->error_idx = i;
-				break;
-			}
-		}
-		return err;
-
-	}
-
-	return -EINVAL;
-}
-
 static int saa7164_try_ctrl(struct v4l2_ext_control *ctrl, int ac3)
 {
 	int ret = -EINVAL;
@@ -884,6 +860,37 @@ static int vidioc_queryctrl(struct file *file, void *priv,
 	return -EINVAL;
 }
 
+static int vidioc_g_ext_ctrls(struct file *file, void *priv,
+	struct v4l2_ext_controls *ctrls)
+{
+	struct saa7164_encoder_fh *fh = file->private_data;
+	struct saa7164_port *port = fh->port;
+	int i, err = 0;
+
+	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_MPEG &&
+		ctrls->which != V4L2_CTRL_WHICH_DEF_VAL)
+		return -EINVAL;
+
+	for (i = 0; i < ctrls->count; i++) {
+		struct v4l2_ext_control *ctrl = ctrls->controls + i;
+
+		if (ctrls->which == V4L2_CTRL_WHICH_DEF_VAL) {
+			struct v4l2_queryctrl q;
+
+			err = fill_queryctrl(&port->encoder_params, &q);
+			if (!err)
+				ctrl->value = q.default_value;
+		} else
+			err = saa7164_get_ctrl(port, ctrl);
+
+		if (err) {
+			ctrls->error_idx = i;
+			break;
+		}
+	}
+	return err;
+}
+
 static int saa7164_encoder_stop_port(struct saa7164_port *port)
 {
 	struct saa7164_dev *dev = port->dev;
-- 
2.5.0

