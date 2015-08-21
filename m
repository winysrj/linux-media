Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:35652 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbbHUNTs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 09:19:48 -0400
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
Subject: [PATCH v2 09/10] media/pci/saa7164-vbi Support for V4L2_CTRL_WHICH_DEF_VAL
Date: Fri, 21 Aug 2015 15:19:28 +0200
Message-Id: <1440163169-18047-10-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1440163169-18047-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1440163169-18047-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver does not use the control infrastructure.
Add support for the new field which on structure
 v4l2_ext_controls

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/pci/saa7164/saa7164-vbi.c | 57 +++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index 08f23b6d9cef..4c2d8ec5b4dd 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -494,30 +494,6 @@ static int saa7164_get_ctrl(struct saa7164_port *port,
 	return 0;
 }
 
-static int vidioc_g_ext_ctrls(struct file *file, void *priv,
-	struct v4l2_ext_controls *ctrls)
-{
-	struct saa7164_vbi_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	int i, err = 0;
-
-	if (ctrls->which == V4L2_CTRL_CLASS_MPEG) {
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
@@ -810,6 +786,39 @@ static int vidioc_queryctrl(struct file *file, void *priv,
 	return -EINVAL;
 }
 
+static int vidioc_g_ext_ctrls(struct file *file, void *priv,
+	struct v4l2_ext_controls *ctrls)
+{
+	struct saa7164_vbi_fh *fh = file->private_data;
+	struct saa7164_port *port = fh->port;
+	int i, err = 0;
+
+	if (ctrls->which != V4L2_CTRL_CLASS_MPEG &&
+		ctrls->which != V4L2_CTRL_WHICH_DEF_VAL)
+		return -EINVAL;
+
+	for (i = 0; i < ctrls->count; i++) {
+		struct v4l2_ext_control *ctrl = ctrls->controls + i;
+
+		if (ctrls->which == V4L2_CTRL_WHICH_DEF_VAL) {
+			struct v4l2_queryctrl q;
+
+			err = fill_queryctrl(&port->vbi_params, &q);
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
+
+	return err;
+}
+
+
 static int saa7164_vbi_stop_port(struct saa7164_port *port)
 {
 	struct saa7164_dev *dev = port->dev;
-- 
2.5.0

