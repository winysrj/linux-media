Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2701 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbaFLLyi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 11/34] v4l2-ctrls: prepare for array support
Date: Thu, 12 Jun 2014 13:52:43 +0200
Message-Id: <b948cc68f6bf1557b8141564e488f96287992201.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add dims, nr_of_dims and elems fields to the core control structures in preparation
for N-dimensional array support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 33 ++++++++++++++++++++++++---------
 include/media/v4l2-ctrls.h           |  8 ++++++++
 2 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 4b10571..e6c98a7 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1759,18 +1759,27 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_type_ops *type_ops,
 			u32 id, const char *name, enum v4l2_ctrl_type type,
 			s64 min, s64 max, u64 step, s64 def,
-			u32 elem_size,
+			const u32 dims[V4L2_CTRL_MAX_DIMS], u32 elem_size,
 			u32 flags, const char * const *qmenu,
 			const s64 *qmenu_int, void *priv)
 {
 	struct v4l2_ctrl *ctrl;
 	unsigned sz_extra;
+	unsigned nr_of_dims = 0;
+	unsigned elems = 1;
 	void *data;
 	int err;
 
 	if (hdl->error)
 		return NULL;
 
+	while (dims && dims[nr_of_dims]) {
+		elems *= dims[nr_of_dims];
+		nr_of_dims++;
+		if (nr_of_dims == V4L2_CTRL_MAX_DIMS)
+			break;
+	}
+
 	if (type == V4L2_CTRL_TYPE_INTEGER64)
 		elem_size = sizeof(s64);
 	else if (type == V4L2_CTRL_TYPE_STRING)
@@ -1828,6 +1837,10 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	ctrl->is_string = type == V4L2_CTRL_TYPE_STRING;
 	ctrl->is_ptr = type >= V4L2_CTRL_COMPOUND_TYPES || ctrl->is_string;
 	ctrl->is_int = !ctrl->is_ptr && type != V4L2_CTRL_TYPE_INTEGER64;
+	ctrl->elems = elems;
+	ctrl->nr_of_dims = nr_of_dims;
+	if (nr_of_dims)
+		memcpy(ctrl->dims, dims, nr_of_dims * sizeof(dims[0]));
 	ctrl->elem_size = elem_size;
 	if (type == V4L2_CTRL_TYPE_MENU)
 		ctrl->qmenu = qmenu;
@@ -1892,8 +1905,8 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
 
 	ctrl = v4l2_ctrl_new(hdl, cfg->ops, cfg->type_ops, cfg->id, name,
 			type, min, max,
-			is_menu ? cfg->menu_skip_mask : step,
-			def, cfg->elem_size,
+			is_menu ? cfg->menu_skip_mask : step, def,
+			cfg->dims, cfg->elem_size,
 			flags, qmenu, qmenu_int, priv);
 	if (ctrl)
 		ctrl->is_private = cfg->is_private;
@@ -1918,7 +1931,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
 		return NULL;
 	}
 	return v4l2_ctrl_new(hdl, ops, NULL, id, name, type,
-			     min, max, step, def, 0,
+			     min, max, step, def, NULL, 0,
 			     flags, NULL, NULL, NULL);
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_std);
@@ -1951,7 +1964,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 		return NULL;
 	}
 	return v4l2_ctrl_new(hdl, ops, NULL, id, name, type,
-			     0, max, mask, def, 0,
+			     0, max, mask, def, NULL, 0,
 			     flags, qmenu, qmenu_int, NULL);
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_std_menu);
@@ -1983,8 +1996,8 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
 		return NULL;
 	}
 	return v4l2_ctrl_new(hdl, ops, NULL, id, name, type,
-			     0, max, mask, def,
-			     0, flags, qmenu, NULL, NULL);
+			     0, max, mask, def, NULL, 0,
+			     flags, qmenu, NULL, NULL);
 
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_std_menu_items);
@@ -2008,7 +2021,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
 		return NULL;
 	}
 	return v4l2_ctrl_new(hdl, ops, NULL, id, name, type,
-			     0, max, 0, def, 0,
+			     0, max, 0, def, NULL, 0,
 			     flags, NULL, qmenu_int, NULL);
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_int_menu);
@@ -2354,7 +2367,9 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 	if (ctrl->is_ptr)
 		qc->flags |= V4L2_CTRL_FLAG_HAS_PAYLOAD;
 	qc->elem_size = ctrl->elem_size;
-	qc->elems = 1;
+	qc->elems = ctrl->elems;
+	qc->nr_of_dims = ctrl->nr_of_dims;
+	memcpy(qc->dims, ctrl->dims, qc->nr_of_dims * sizeof(qc->dims[0]));
 	qc->minimum = ctrl->minimum;
 	qc->maximum = ctrl->maximum;
 	qc->default_value = ctrl->default_value;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index eb69c52..d30da09 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -129,7 +129,10 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
   * @maximum:	The control's maximum value.
   * @default_value: The control's default value.
   * @step:	The control's step value for non-menu controls.
+  * @elems:	The number of elements in the N-dimensional array.
   * @elem_size:	The size in bytes of the control.
+  * @dims:	The size of each dimension.
+  * @nr_of_dims:The number of dimensions in @dims.
   * @menu_skip_mask: The control's skip mask for menu controls. This makes it
   *		easy to skip menu items that are not valid. If bit X is set,
   *		then menu item X is skipped. Of course, this only works for
@@ -176,7 +179,10 @@ struct v4l2_ctrl {
 	const char *name;
 	enum v4l2_ctrl_type type;
 	s64 minimum, maximum, default_value;
+	u32 elems;
 	u32 elem_size;
+	u32 dims[V4L2_CTRL_MAX_DIMS];
+	u32 nr_of_dims;
 	union {
 		u64 step;
 		u64 menu_skip_mask;
@@ -255,6 +261,7 @@ struct v4l2_ctrl_handler {
   * @max:	The control's maximum value.
   * @step:	The control's step value for non-menu controls.
   * @def: 	The control's default value.
+  * @dims:	The size of each dimension.
   * @elem_size:	The size in bytes of the control.
   * @flags:	The control's flags.
   * @menu_skip_mask: The control's skip mask for menu controls. This makes it
@@ -280,6 +287,7 @@ struct v4l2_ctrl_config {
 	s64 max;
 	u64 step;
 	s64 def;
+	u32 dims[V4L2_CTRL_MAX_DIMS];
 	u32 elem_size;
 	u32 flags;
 	u64 menu_skip_mask;
-- 
2.0.0.rc0

