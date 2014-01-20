Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3482 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaATMql (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 07:46:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 02/21] v4l2-ctrls: add unit string.
Date: Mon, 20 Jan 2014 13:45:55 +0100
Message-Id: <1390221974-28194-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The upcoming VIDIOC_QUERY_EXT_CTRL adds support for a unit string. This
allows userspace to show the unit belonging to a particular control.

This patch adds support for the unit string to the control framework.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-common.c |  3 ++-
 drivers/media/v4l2-core/v4l2-ctrls.c  | 36 +++++++++++++++++++++--------------
 include/media/v4l2-ctrls.h            | 13 +++++++++----
 3 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index ccaa38f..ee8ea66 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -114,12 +114,13 @@ EXPORT_SYMBOL(v4l2_ctrl_check);
 int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 _min, s32 _max, s32 _step, s32 _def)
 {
 	const char *name;
+	const char *unit = NULL;
 	s64 min = _min;
 	s64 max = _max;
 	u64 step = _step;
 	s64 def = _def;
 
-	v4l2_ctrl_fill(qctrl->id, &name, &qctrl->type,
+	v4l2_ctrl_fill(qctrl->id, &name, &unit, &qctrl->type,
 		       &min, &max, &step, &def, &qctrl->flags);
 
 	if (name == NULL)
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 5b60b53..0b9246b 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -863,8 +863,9 @@ const char *v4l2_ctrl_get_name(u32 id)
 }
 EXPORT_SYMBOL(v4l2_ctrl_get_name);
 
-void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
-		    s64 *min, s64 *max, u64 *step, s64 *def, u32 *flags)
+void v4l2_ctrl_fill(u32 id, const char **name, const char **unit,
+		    enum v4l2_ctrl_type *type, s64 *min, s64 *max,
+		    u64 *step, s64 *def, u32 *flags)
 {
 	*name = v4l2_ctrl_get_name(id);
 	*flags = 0;
@@ -1627,7 +1628,8 @@ unlock:
 /* Add a new control */
 static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
-			u32 id, const char *name, enum v4l2_ctrl_type type,
+			u32 id, const char *name, const char *unit,
+			enum v4l2_ctrl_type type,
 			s64 min, s64 max, u64 step, s64 def,
 			u32 flags, const char * const *qmenu,
 			const s64 *qmenu_int, void *priv)
@@ -1675,6 +1677,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	ctrl->ops = ops;
 	ctrl->id = id;
 	ctrl->name = name;
+	ctrl->unit = unit;
 	ctrl->type = type;
 	ctrl->flags = flags;
 	ctrl->minimum = min;
@@ -1709,6 +1712,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
 	bool is_menu;
 	struct v4l2_ctrl *ctrl;
 	const char *name = cfg->name;
+	const char *unit = cfg->unit;
 	const char * const *qmenu = cfg->qmenu;
 	const s64 *qmenu_int = cfg->qmenu_int;
 	enum v4l2_ctrl_type type = cfg->type;
@@ -1719,8 +1723,8 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
 	s64 def = cfg->def;
 
 	if (name == NULL)
-		v4l2_ctrl_fill(cfg->id, &name, &type, &min, &max, &step,
-								&def, &flags);
+		v4l2_ctrl_fill(cfg->id, &name, &unit, &type,
+			       &min, &max, &step, &def, &flags);
 
 	is_menu = (cfg->type == V4L2_CTRL_TYPE_MENU ||
 		   cfg->type == V4L2_CTRL_TYPE_INTEGER_MENU);
@@ -1736,7 +1740,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
 		return NULL;
 	}
 
-	ctrl = v4l2_ctrl_new(hdl, cfg->ops, cfg->id, name,
+	ctrl = v4l2_ctrl_new(hdl, cfg->ops, cfg->id, name, unit,
 			type, min, max,
 			is_menu ? cfg->menu_skip_mask : step,
 			def, flags, qmenu, qmenu_int, priv);
@@ -1752,16 +1756,17 @@ struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
 			u32 id, s64 min, s64 max, u64 step, s64 def)
 {
 	const char *name;
+	const char *unit = NULL;
 	enum v4l2_ctrl_type type;
 	u32 flags;
 
-	v4l2_ctrl_fill(id, &name, &type, &min, &max, &step, &def, &flags);
+	v4l2_ctrl_fill(id, &name, &unit, &type, &min, &max, &step, &def, &flags);
 	if (type == V4L2_CTRL_TYPE_MENU
 	    || type == V4L2_CTRL_TYPE_INTEGER_MENU) {
 		handler_set_err(hdl, -EINVAL);
 		return NULL;
 	}
-	return v4l2_ctrl_new(hdl, ops, id, name, type,
+	return v4l2_ctrl_new(hdl, ops, id, name, unit, type,
 			     min, max, step, def, flags, NULL, NULL, NULL);
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_std);
@@ -1775,6 +1780,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 	const s64 *qmenu_int = NULL;
 	unsigned int qmenu_int_len = 0;
 	const char *name;
+	const char *unit = NULL;
 	enum v4l2_ctrl_type type;
 	s64 min;
 	s64 max = _max;
@@ -1782,7 +1788,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 	u64 step;
 	u32 flags;
 
-	v4l2_ctrl_fill(id, &name, &type, &min, &max, &step, &def, &flags);
+	v4l2_ctrl_fill(id, &name, &unit, &type, &min, &max, &step, &def, &flags);
 
 	if (type == V4L2_CTRL_TYPE_MENU)
 		qmenu = v4l2_ctrl_get_menu(id);
@@ -1793,7 +1799,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 		handler_set_err(hdl, -EINVAL);
 		return NULL;
 	}
-	return v4l2_ctrl_new(hdl, ops, id, name, type,
+	return v4l2_ctrl_new(hdl, ops, id, name, unit, type,
 			     0, max, mask, def, flags, qmenu, qmenu_int, NULL);
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_std_menu);
@@ -1805,6 +1811,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
 {
 	enum v4l2_ctrl_type type;
 	const char *name;
+	const char *unit = NULL;
 	u32 flags;
 	u64 step;
 	s64 min;
@@ -1819,12 +1826,12 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
 		return NULL;
 	}
 
-	v4l2_ctrl_fill(id, &name, &type, &min, &max, &step, &def, &flags);
+	v4l2_ctrl_fill(id, &name, &unit, &type, &min, &max, &step, &def, &flags);
 	if (type != V4L2_CTRL_TYPE_MENU || qmenu == NULL) {
 		handler_set_err(hdl, -EINVAL);
 		return NULL;
 	}
-	return v4l2_ctrl_new(hdl, ops, id, name, type, 0, max, mask, def,
+	return v4l2_ctrl_new(hdl, ops, id, name, unit, type, 0, max, mask, def,
 			     flags, qmenu, NULL, NULL);
 
 }
@@ -1836,6 +1843,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
 			u32 id, u8 _max, u8 _def, const s64 *qmenu_int)
 {
 	const char *name;
+	const char *unit = NULL;
 	enum v4l2_ctrl_type type;
 	s64 min;
 	u64 step;
@@ -1843,12 +1851,12 @@ struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
 	s64 def = _def;
 	u32 flags;
 
-	v4l2_ctrl_fill(id, &name, &type, &min, &max, &step, &def, &flags);
+	v4l2_ctrl_fill(id, &name, &unit, &type, &min, &max, &step, &def, &flags);
 	if (type != V4L2_CTRL_TYPE_INTEGER_MENU) {
 		handler_set_err(hdl, -EINVAL);
 		return NULL;
 	}
-	return v4l2_ctrl_new(hdl, ops, id, name, type,
+	return v4l2_ctrl_new(hdl, ops, id, name, unit, type,
 			     0, max, 0, def, flags, NULL, qmenu_int, NULL);
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_int_menu);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 0b347e8..3998049 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -85,6 +85,7 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
   * @ops:	The control ops.
   * @id:	The control ID.
   * @name:	The control name.
+  * @unit:	The control's unit. May be NULL.
   * @type:	The control type.
   * @minimum:	The control's minimum value.
   * @maximum:	The control's maximum value.
@@ -130,6 +131,7 @@ struct v4l2_ctrl {
 	const struct v4l2_ctrl_ops *ops;
 	u32 id;
 	const char *name;
+	const char *unit;
 	enum v4l2_ctrl_type type;
 	s64 minimum, maximum, default_value;
 	union {
@@ -207,6 +209,7 @@ struct v4l2_ctrl_handler {
   * @ops:	The control ops.
   * @id:	The control ID.
   * @name:	The control name.
+  * @unit:	The control's unit.
   * @type:	The control type.
   * @min:	The control's minimum value.
   * @max:	The control's maximum value.
@@ -230,6 +233,7 @@ struct v4l2_ctrl_config {
 	const struct v4l2_ctrl_ops *ops;
 	u32 id;
 	const char *name;
+	const char *unit;
 	enum v4l2_ctrl_type type;
 	s64 min;
 	s64 max;
@@ -249,15 +253,16 @@ struct v4l2_ctrl_config {
   * and @name will be NULL.
   *
   * This function will overwrite the contents of @name, @type and @flags.
-  * The contents of @min, @max, @step and @def may be modified depending on
-  * the type.
+  * The contents of @unit, @min, @max, @step and @def may be modified depending
+  * on the type.
   *
   * Do not use in drivers! It is used internally for backwards compatibility
   * control handling only. Once all drivers are converted to use the new
   * control framework this function will no longer be exported.
   */
-void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
-		    s64 *min, s64 *max, u64 *step, s64 *def, u32 *flags);
+void v4l2_ctrl_fill(u32 id, const char **name, const char **unit,
+		    enum v4l2_ctrl_type *type, s64 *min, s64 *max,
+		    u64 *step, s64 *def, u32 *flags);
 
 
 /** v4l2_ctrl_handler_init_class() - Initialize the control handler.
-- 
1.8.5.2

