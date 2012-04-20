Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:40423 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470Ab2DTPTj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 11:19:39 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	=?UTF-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
Subject: [RFC PATCH 2/3] [media] gspca - main: factor out the logic to set and get controls
Date: Fri, 20 Apr 2012 17:19:10 +0200
Message-Id: <1334935152-16165-3-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1334935152-16165-1-git-send-email-ospite@studenti.unina.it>
References: <20120418153720.1359c7d2f2a3efc2c7c17b88@studenti.unina.it>
 <1334935152-16165-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Factor out the logic to set and get controls from vidioc_s_ctrl()
and vidioc_g_ctrl() so that the code can be reused in the coming
implementation of vidioc_s_ext_ctrls() and vidioc_g_ext_ctrls().

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/video/gspca/gspca.c |  148 ++++++++++++++++++++-----------------
 1 file changed, 80 insertions(+), 68 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index bc9d037..ba1bda9 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -1432,6 +1432,84 @@ static int get_ctrl_index(struct gspca_dev *gspca_dev,
 	return -1;
 }
 
+static int gspca_set_ctrl(struct gspca_dev *gspca_dev,
+			  __u32 id, __s32 value)
+{
+	const struct ctrl *ctrls;
+	struct gspca_ctrl *gspca_ctrl;
+	int idx, ret;
+
+	idx = get_ctrl_index(gspca_dev, id);
+	if (idx < 0)
+		return -EINVAL;
+	if (gspca_dev->ctrl_inac & (1 << idx))
+		return -EINVAL;
+	ctrls = &gspca_dev->sd_desc->ctrls[idx];
+	if (gspca_dev->cam.ctrls != NULL) {
+		gspca_ctrl = &gspca_dev->cam.ctrls[idx];
+		if (value < gspca_ctrl->min
+		    || value > gspca_ctrl->max)
+			return -ERANGE;
+	} else {
+		gspca_ctrl = NULL;
+		if (value < ctrls->qctrl.minimum
+		    || value > ctrls->qctrl.maximum)
+			return -ERANGE;
+	}
+	PDEBUG(D_CONF, "set ctrl [%08x] = %d", id, value);
+	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
+		return -ERESTARTSYS;
+	if (!gspca_dev->present) {
+		ret = -ENODEV;
+		goto out;
+	}
+	gspca_dev->usb_err = 0;
+	if (ctrls->set != NULL) {
+		ret = ctrls->set(gspca_dev, value);
+		goto out;
+	}
+	if (gspca_ctrl != NULL) {
+		gspca_ctrl->val = value;
+		if (ctrls->set_control != NULL
+		 && gspca_dev->streaming)
+			ctrls->set_control(gspca_dev);
+	}
+	ret = gspca_dev->usb_err;
+out:
+	mutex_unlock(&gspca_dev->usb_lock);
+	return ret;
+}
+
+static int gspca_get_ctrl(struct gspca_dev *gspca_dev,
+			  __u32 id, __s32 *value)
+{
+	const struct ctrl *ctrls;
+	int idx, ret;
+
+	idx = get_ctrl_index(gspca_dev, id);
+	if (idx < 0)
+		return -EINVAL;
+	ctrls = &gspca_dev->sd_desc->ctrls[idx];
+
+	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
+		return -ERESTARTSYS;
+	if (!gspca_dev->present) {
+		ret = -ENODEV;
+		goto out;
+	}
+	gspca_dev->usb_err = 0;
+	if (ctrls->get != NULL) {
+		ret = ctrls->get(gspca_dev, value);
+		goto out;
+	}
+	if (gspca_dev->cam.ctrls != NULL)
+		*value = gspca_dev->cam.ctrls[idx].val;
+	ret = 0;
+out:
+	mutex_unlock(&gspca_dev->usb_lock);
+	return ret;
+}
+
 static int vidioc_queryctrl(struct file *file, void *priv,
 			   struct v4l2_queryctrl *q_ctrl)
 {
@@ -1479,80 +1557,14 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 			 struct v4l2_control *ctrl)
 {
 	struct gspca_dev *gspca_dev = priv;
-	const struct ctrl *ctrls;
-	struct gspca_ctrl *gspca_ctrl;
-	int idx, ret;
-
-	idx = get_ctrl_index(gspca_dev, ctrl->id);
-	if (idx < 0)
-		return -EINVAL;
-	if (gspca_dev->ctrl_inac & (1 << idx))
-		return -EINVAL;
-	ctrls = &gspca_dev->sd_desc->ctrls[idx];
-	if (gspca_dev->cam.ctrls != NULL) {
-		gspca_ctrl = &gspca_dev->cam.ctrls[idx];
-		if (ctrl->value < gspca_ctrl->min
-		    || ctrl->value > gspca_ctrl->max)
-			return -ERANGE;
-	} else {
-		gspca_ctrl = NULL;
-		if (ctrl->value < ctrls->qctrl.minimum
-		    || ctrl->value > ctrls->qctrl.maximum)
-			return -ERANGE;
-	}
-	PDEBUG(D_CONF, "set ctrl [%08x] = %d", ctrl->id, ctrl->value);
-	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
-		return -ERESTARTSYS;
-	if (!gspca_dev->present) {
-		ret = -ENODEV;
-		goto out;
-	}
-	gspca_dev->usb_err = 0;
-	if (ctrls->set != NULL) {
-		ret = ctrls->set(gspca_dev, ctrl->value);
-		goto out;
-	}
-	if (gspca_ctrl != NULL) {
-		gspca_ctrl->val = ctrl->value;
-		if (ctrls->set_control != NULL
-		 && gspca_dev->streaming)
-			ctrls->set_control(gspca_dev);
-	}
-	ret = gspca_dev->usb_err;
-out:
-	mutex_unlock(&gspca_dev->usb_lock);
-	return ret;
+	return gspca_set_ctrl(gspca_dev, ctrl->id, ctrl->value);
 }
 
 static int vidioc_g_ctrl(struct file *file, void *priv,
 			 struct v4l2_control *ctrl)
 {
 	struct gspca_dev *gspca_dev = priv;
-	const struct ctrl *ctrls;
-	int idx, ret;
-
-	idx = get_ctrl_index(gspca_dev, ctrl->id);
-	if (idx < 0)
-		return -EINVAL;
-	ctrls = &gspca_dev->sd_desc->ctrls[idx];
-
-	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
-		return -ERESTARTSYS;
-	if (!gspca_dev->present) {
-		ret = -ENODEV;
-		goto out;
-	}
-	gspca_dev->usb_err = 0;
-	if (ctrls->get != NULL) {
-		ret = ctrls->get(gspca_dev, &ctrl->value);
-		goto out;
-	}
-	if (gspca_dev->cam.ctrls != NULL)
-		ctrl->value = gspca_dev->cam.ctrls[idx].val;
-	ret = 0;
-out:
-	mutex_unlock(&gspca_dev->usb_lock);
-	return ret;
+	return gspca_get_ctrl(gspca_dev, ctrl->id, &ctrl->value);
 }
 
 static int vidioc_querymenu(struct file *file, void *priv,
-- 
1.7.10

