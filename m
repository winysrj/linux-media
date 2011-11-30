Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:60966 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab1K3Rjs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 12:39:48 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, snjw23@gmail.com,
	hverkuil@xs4all.nl
Subject: [RFC/PATCH v2 1/3] v4l: Introduce integer menu controls
Date: Wed, 30 Nov 2011 19:35:56 +0200
Message-Id: <1322674558-7963-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20111130173821.GH29805@valkosipuli.localdomain>
References: <20111130173821.GH29805@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create a new control type called V4L2_CTRL_TYPE_INTEGER_MENU. Integer menu
controls are just like menu controls but the menu items are 64-bit integers
rather than strings.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/v4l2-ctrls.c |   60 +++++++++++++++++++++++++++----------
 include/linux/videodev2.h        |    6 +++-
 include/media/v4l2-ctrls.h       |    6 +++-
 3 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 0f415da..083bb79 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -804,7 +804,8 @@ static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32 change
 		ev->u.ctrl.value64 = ctrl->cur.val64;
 	ev->u.ctrl.minimum = ctrl->minimum;
 	ev->u.ctrl.maximum = ctrl->maximum;
-	if (ctrl->type == V4L2_CTRL_TYPE_MENU)
+	if (ctrl->type == V4L2_CTRL_TYPE_MENU
+	    || ctrl->type == V4L2_CTRL_TYPE_INTEGER_MENU)
 		ev->u.ctrl.step = 1;
 	else
 		ev->u.ctrl.step = ctrl->step;
@@ -1035,10 +1036,13 @@ static int validate_new_int(const struct v4l2_ctrl *ctrl, s32 *pval)
 		return 0;
 
 	case V4L2_CTRL_TYPE_MENU:
+	case V4L2_CTRL_TYPE_INTEGER_MENU:
 		if (val < ctrl->minimum || val > ctrl->maximum)
 			return -ERANGE;
-		if (ctrl->qmenu[val][0] == '\0' ||
-		    (ctrl->menu_skip_mask & (1 << val)))
+		if (ctrl->menu_skip_mask & (1 << val))
+			return -EINVAL;
+		if (ctrl->type == V4L2_CTRL_TYPE_MENU &&
+		    ctrl->qmenu[val][0] == '\0')
 			return -EINVAL;
 		return 0;
 
@@ -1295,7 +1299,8 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, const char *name, enum v4l2_ctrl_type type,
 			s32 min, s32 max, u32 step, s32 def,
-			u32 flags, const char * const *qmenu, void *priv)
+			u32 flags, const char * const *qmenu,
+			const s64 *qmenu_int, void *priv)
 {
 	struct v4l2_ctrl *ctrl;
 	unsigned sz_extra = 0;
@@ -1308,6 +1313,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	    (type == V4L2_CTRL_TYPE_INTEGER && step == 0) ||
 	    (type == V4L2_CTRL_TYPE_BITMASK && max == 0) ||
 	    (type == V4L2_CTRL_TYPE_MENU && qmenu == NULL) ||
+	    (type == V4L2_CTRL_TYPE_INTEGER_MENU && qmenu_int == NULL) ||
 	    (type == V4L2_CTRL_TYPE_STRING && max == 0)) {
 		handler_set_err(hdl, -ERANGE);
 		return NULL;
@@ -1318,6 +1324,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	}
 	if ((type == V4L2_CTRL_TYPE_INTEGER ||
 	     type == V4L2_CTRL_TYPE_MENU ||
+	     type == V4L2_CTRL_TYPE_INTEGER_MENU ||
 	     type == V4L2_CTRL_TYPE_BOOLEAN) &&
 	    (def < min || def > max)) {
 		handler_set_err(hdl, -ERANGE);
@@ -1352,7 +1359,10 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	ctrl->minimum = min;
 	ctrl->maximum = max;
 	ctrl->step = step;
-	ctrl->qmenu = qmenu;
+	if (type == V4L2_CTRL_TYPE_MENU)
+		ctrl->qmenu = qmenu;
+	else if (type == V4L2_CTRL_TYPE_INTEGER_MENU)
+		ctrl->qmenu_int = qmenu_int;
 	ctrl->priv = priv;
 	ctrl->cur.val = ctrl->val = ctrl->default_value = def;
 
@@ -1379,6 +1389,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
 	struct v4l2_ctrl *ctrl;
 	const char *name = cfg->name;
 	const char * const *qmenu = cfg->qmenu;
+	const s64 *qmenu_int = cfg->qmenu_int;
 	enum v4l2_ctrl_type type = cfg->type;
 	u32 flags = cfg->flags;
 	s32 min = cfg->min;
@@ -1390,18 +1401,24 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
 		v4l2_ctrl_fill(cfg->id, &name, &type, &min, &max, &step,
 								&def, &flags);
 
-	is_menu = (cfg->type == V4L2_CTRL_TYPE_MENU);
+	is_menu = (cfg->type == V4L2_CTRL_TYPE_MENU ||
+		   cfg->type == V4L2_CTRL_TYPE_INTEGER_MENU);
 	if (is_menu)
 		WARN_ON(step);
 	else
 		WARN_ON(cfg->menu_skip_mask);
-	if (is_menu && qmenu == NULL)
+	if (cfg->type == V4L2_CTRL_TYPE_MENU && qmenu == NULL)
 		qmenu = v4l2_ctrl_get_menu(cfg->id);
+	else if (cfg->type == V4L2_CTRL_TYPE_INTEGER_MENU &&
+		 qmenu_int == NULL) {
+		handler_set_err(hdl, -EINVAL);
+		return NULL;
+	}
 
 	ctrl = v4l2_ctrl_new(hdl, cfg->ops, cfg->id, name,
 			type, min, max,
 			is_menu ? cfg->menu_skip_mask : step,
-			def, flags, qmenu, priv);
+			def, flags, qmenu, qmenu_int, priv);
 	if (ctrl)
 		ctrl->is_private = cfg->is_private;
 	return ctrl;
@@ -1418,12 +1435,13 @@ struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
 	u32 flags;
 
 	v4l2_ctrl_fill(id, &name, &type, &min, &max, &step, &def, &flags);
-	if (type == V4L2_CTRL_TYPE_MENU) {
+	if (type == V4L2_CTRL_TYPE_MENU
+	    || type == V4L2_CTRL_TYPE_INTEGER_MENU) {
 		handler_set_err(hdl, -EINVAL);
 		return NULL;
 	}
 	return v4l2_ctrl_new(hdl, ops, id, name, type,
-				    min, max, step, def, flags, NULL, NULL);
+			     min, max, step, def, flags, NULL, NULL, NULL);
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_std);
 
@@ -1445,7 +1463,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 		return NULL;
 	}
 	return v4l2_ctrl_new(hdl, ops, id, name, type,
-				    0, max, mask, def, flags, qmenu, NULL);
+			     0, max, mask, def, flags, qmenu, NULL, NULL);
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_std_menu);
 
@@ -1609,6 +1627,9 @@ static void log_ctrl(const struct v4l2_ctrl *ctrl,
 	case V4L2_CTRL_TYPE_MENU:
 		printk(KERN_CONT "%s", ctrl->qmenu[ctrl->cur.val]);
 		break;
+	case V4L2_CTRL_TYPE_INTEGER_MENU:
+		printk(KERN_CONT "%lld", ctrl->qmenu_int[ctrl->cur.val]);
+		break;
 	case V4L2_CTRL_TYPE_BITMASK:
 		printk(KERN_CONT "0x%08x", ctrl->cur.val);
 		break;
@@ -1745,7 +1766,8 @@ int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
 	qc->minimum = ctrl->minimum;
 	qc->maximum = ctrl->maximum;
 	qc->default_value = ctrl->default_value;
-	if (ctrl->type == V4L2_CTRL_TYPE_MENU)
+	if (ctrl->type == V4L2_CTRL_TYPE_MENU
+	    || ctrl->type == V4L2_CTRL_TYPE_INTEGER_MENU)
 		qc->step = 1;
 	else
 		qc->step = ctrl->step;
@@ -1775,16 +1797,22 @@ int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm)
 
 	qm->reserved = 0;
 	/* Sanity checks */
-	if (ctrl->qmenu == NULL ||
+	if ((ctrl->type == V4L2_CTRL_TYPE_MENU && ctrl->qmenu == NULL) ||
+	    (ctrl->type == V4L2_CTRL_TYPE_INTEGER_MENU
+	     && ctrl->qmenu_int == NULL) ||
 	    i < ctrl->minimum || i > ctrl->maximum)
 		return -EINVAL;
 	/* Use mask to see if this menu item should be skipped */
 	if (ctrl->menu_skip_mask & (1 << i))
 		return -EINVAL;
 	/* Empty menu items should also be skipped */
-	if (ctrl->qmenu[i] == NULL || ctrl->qmenu[i][0] == '\0')
-		return -EINVAL;
-	strlcpy(qm->name, ctrl->qmenu[i], sizeof(qm->name));
+	if (ctrl->type == V4L2_CTRL_TYPE_MENU) {
+		if (ctrl->qmenu[i] == NULL || ctrl->qmenu[i][0] == '\0')
+			return -EINVAL;
+		strlcpy(qm->name, ctrl->qmenu[i], sizeof(qm->name));
+	} else if (ctrl->type == V4L2_CTRL_TYPE_INTEGER_MENU) {
+		qm->value = ctrl->qmenu_int[i];
+	}
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_querymenu);
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 4b752d5..9633c69 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1094,6 +1094,7 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_CTRL_CLASS    = 6,
 	V4L2_CTRL_TYPE_STRING        = 7,
 	V4L2_CTRL_TYPE_BITMASK       = 8,
+	V4L2_CTRL_TYPE_INTEGER_MENU = 9,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
@@ -1113,7 +1114,10 @@ struct v4l2_queryctrl {
 struct v4l2_querymenu {
 	__u32		id;
 	__u32		index;
-	__u8		name[32];	/* Whatever */
+	union {
+		__u8	name[32];	/* Whatever */
+		__s64	value;
+	};
 	__u32		reserved;
 };
 
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index eeb3df6..f7819e7 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -129,7 +129,10 @@ struct v4l2_ctrl {
 		u32 step;
 		u32 menu_skip_mask;
 	};
-	const char * const *qmenu;
+	union {
+		const char * const *qmenu;
+		const s64 *qmenu_int;
+	};
 	unsigned long flags;
 	union {
 		s32 val;
@@ -219,6 +222,7 @@ struct v4l2_ctrl_config {
 	u32 flags;
 	u32 menu_skip_mask;
 	const char * const *qmenu;
+	const s64 *qmenu_int;
 	unsigned int is_private:1;
 };
 
-- 
1.7.2.5

