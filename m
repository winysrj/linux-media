Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2422 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933238AbaFLLym (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 07/34] v4l2-ctrls: create type_ops.
Date: Thu, 12 Jun 2014 13:52:39 +0200
Message-Id: <470e700d69f21bed15f0444c685b1863c2618697.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Since compound controls can have non-standard types we need to be able to do
type-specific checks etc. In order to make that easy type operations are added.
There are four operations:

- equal: check if two values are equal
- init: initialize a value
- log: log the value
- validate: validate a new value

The v4l2_ctrl struct adds p_new and p_cur unions at the end of the struct.
This union provides a standard way of accessing control types through a pointer,
which greatly simplifies internal control processing.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 273 ++++++++++++++++++++++-------------
 include/media/v4l2-ctrls.h           |  37 +++++
 2 files changed, 210 insertions(+), 100 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index d5cd1aa..09e2c3a 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1161,6 +1161,149 @@ static void send_event(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 changes)
 			v4l2_event_queue_fh(sev->fh, &ev);
 }
 
+static bool std_equal(const struct v4l2_ctrl *ctrl,
+		      union v4l2_ctrl_ptr ptr1,
+		      union v4l2_ctrl_ptr ptr2)
+{
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_BUTTON:
+		return false;
+	case V4L2_CTRL_TYPE_STRING:
+		/* strings are always 0-terminated */
+		return !strcmp(ptr1.p_char, ptr2.p_char);
+	case V4L2_CTRL_TYPE_INTEGER64:
+		return *ptr1.p_s64 == *ptr2.p_s64;
+	default:
+		if (ctrl->is_ptr)
+			return !memcmp(ptr1.p, ptr2.p, ctrl->elem_size);
+		return *ptr1.p_s32 == *ptr2.p_s32;
+	}
+}
+
+static void std_init(const struct v4l2_ctrl *ctrl,
+		     union v4l2_ctrl_ptr ptr)
+{
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_STRING:
+		memset(ptr.p_char, ' ', ctrl->minimum);
+		ptr.p_char[ctrl->minimum] = '\0';
+		break;
+	case V4L2_CTRL_TYPE_INTEGER64:
+		*ptr.p_s64 = ctrl->default_value;
+		break;
+	case V4L2_CTRL_TYPE_INTEGER:
+	case V4L2_CTRL_TYPE_INTEGER_MENU:
+	case V4L2_CTRL_TYPE_MENU:
+	case V4L2_CTRL_TYPE_BITMASK:
+	case V4L2_CTRL_TYPE_BOOLEAN:
+		*ptr.p_s32 = ctrl->default_value;
+		break;
+	default:
+		break;
+	}
+}
+
+static void std_log(const struct v4l2_ctrl *ctrl)
+{
+	union v4l2_ctrl_ptr ptr = ctrl->p_cur;
+
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_INTEGER:
+		pr_cont("%d", *ptr.p_s32);
+		break;
+	case V4L2_CTRL_TYPE_BOOLEAN:
+		pr_cont("%s", *ptr.p_s32 ? "true" : "false");
+		break;
+	case V4L2_CTRL_TYPE_MENU:
+		pr_cont("%s", ctrl->qmenu[*ptr.p_s32]);
+		break;
+	case V4L2_CTRL_TYPE_INTEGER_MENU:
+		pr_cont("%lld", ctrl->qmenu_int[*ptr.p_s32]);
+		break;
+	case V4L2_CTRL_TYPE_BITMASK:
+		pr_cont("0x%08x", *ptr.p_s32);
+		break;
+	case V4L2_CTRL_TYPE_INTEGER64:
+		pr_cont("%lld", *ptr.p_s64);
+		break;
+	case V4L2_CTRL_TYPE_STRING:
+		pr_cont("%s", ptr.p_char);
+		break;
+	default:
+		pr_cont("unknown type %d", ctrl->type);
+		break;
+	}
+}
+
+/* Round towards the closest legal value */
+#define ROUND_TO_RANGE(val, offset_type, ctrl)			\
+({								\
+	offset_type offset;					\
+	val += (ctrl)->step / 2;				\
+	val = clamp_t(typeof(val), val,				\
+		      (ctrl)->minimum, (ctrl)->maximum);	\
+	offset = (val) - (ctrl)->minimum;			\
+	offset = (ctrl)->step * (offset / (ctrl)->step);	\
+	val = (ctrl)->minimum + offset;				\
+	0;							\
+})
+
+/* Validate a new control */
+static int std_validate(const struct v4l2_ctrl *ctrl,
+			union v4l2_ctrl_ptr ptr)
+{
+	size_t len;
+
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_INTEGER:
+		return ROUND_TO_RANGE(*ptr.p_s32, u32, ctrl);
+	case V4L2_CTRL_TYPE_INTEGER64:
+		return ROUND_TO_RANGE(*ptr.p_s64, u64, ctrl);
+
+	case V4L2_CTRL_TYPE_BOOLEAN:
+		*ptr.p_s32 = !!*ptr.p_s32;
+		return 0;
+
+	case V4L2_CTRL_TYPE_MENU:
+	case V4L2_CTRL_TYPE_INTEGER_MENU:
+		if (*ptr.p_s32 < ctrl->minimum || *ptr.p_s32 > ctrl->maximum)
+			return -ERANGE;
+		if (ctrl->menu_skip_mask & (1 << *ptr.p_s32))
+			return -EINVAL;
+		if (ctrl->type == V4L2_CTRL_TYPE_MENU &&
+		    ctrl->qmenu[*ptr.p_s32][0] == '\0')
+			return -EINVAL;
+		return 0;
+
+	case V4L2_CTRL_TYPE_BITMASK:
+		*ptr.p_s32 &= ctrl->maximum;
+		return 0;
+
+	case V4L2_CTRL_TYPE_BUTTON:
+	case V4L2_CTRL_TYPE_CTRL_CLASS:
+		*ptr.p_s32 = 0;
+		return 0;
+
+	case V4L2_CTRL_TYPE_STRING:
+		len = strlen(ptr.p_char);
+		if (len < ctrl->minimum)
+			return -ERANGE;
+		if ((len - ctrl->minimum) % ctrl->step)
+			return -ERANGE;
+		return 0;
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static const struct v4l2_ctrl_type_ops std_type_ops = {
+	.equal = std_equal,
+	.init = std_init,
+	.log = std_log,
+	.validate = std_validate,
+};
+
 /* Helper function: copy the current control value back to the caller */
 static int cur_to_user(struct v4l2_ext_control *c,
 		       struct v4l2_ctrl *ctrl)
@@ -1344,21 +1487,7 @@ static int cluster_changed(struct v4l2_ctrl *master)
 
 		if (ctrl == NULL)
 			continue;
-		switch (ctrl->type) {
-		case V4L2_CTRL_TYPE_BUTTON:
-			/* Button controls are always 'different' */
-			return 1;
-		case V4L2_CTRL_TYPE_STRING:
-			/* strings are always 0-terminated */
-			diff = strcmp(ctrl->string, ctrl->cur.string);
-			break;
-		case V4L2_CTRL_TYPE_INTEGER64:
-			diff = ctrl->val64 != ctrl->cur.val64;
-			break;
-		default:
-			diff = ctrl->val != ctrl->cur.val;
-			break;
-		}
+		diff = !ctrl->type_ops->equal(ctrl, ctrl->p_cur, ctrl->p_new);
 	}
 	return diff;
 }
@@ -1399,65 +1528,30 @@ static int check_range(enum v4l2_ctrl_type type,
 	}
 }
 
-/* Round towards the closest legal value */
-#define ROUND_TO_RANGE(val, offset_type, ctrl)			\
-({								\
-	offset_type offset;					\
-	val += (ctrl)->step / 2;				\
-	val = clamp_t(typeof(val), val,				\
-		      (ctrl)->minimum, (ctrl)->maximum);	\
-	offset = (val) - (ctrl)->minimum;			\
-	offset = (ctrl)->step * (offset / (ctrl)->step);	\
-	val = (ctrl)->minimum + offset;				\
-	0;							\
-})
-
 /* Validate a new control */
 static int validate_new(const struct v4l2_ctrl *ctrl,
 			struct v4l2_ext_control *c)
 {
-	size_t len;
+	union v4l2_ctrl_ptr ptr;
 
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER:
-		return ROUND_TO_RANGE(*(s32 *)&c->value, u32, ctrl);
-	case V4L2_CTRL_TYPE_INTEGER64:
-		return ROUND_TO_RANGE(*(s64 *)&c->value64, u64, ctrl);
-
-	case V4L2_CTRL_TYPE_BOOLEAN:
-		c->value = !!c->value;
-		return 0;
-
-	case V4L2_CTRL_TYPE_MENU:
 	case V4L2_CTRL_TYPE_INTEGER_MENU:
-		if (c->value < ctrl->minimum || c->value > ctrl->maximum)
-			return -ERANGE;
-		if (ctrl->menu_skip_mask & (1 << c->value))
-			return -EINVAL;
-		if (ctrl->type == V4L2_CTRL_TYPE_MENU &&
-		    ctrl->qmenu[c->value][0] == '\0')
-			return -EINVAL;
-		return 0;
-
+	case V4L2_CTRL_TYPE_MENU:
 	case V4L2_CTRL_TYPE_BITMASK:
-		c->value &= ctrl->maximum;
-		return 0;
-
+	case V4L2_CTRL_TYPE_BOOLEAN:
 	case V4L2_CTRL_TYPE_BUTTON:
 	case V4L2_CTRL_TYPE_CTRL_CLASS:
-		c->value = 0;
-		return 0;
+		ptr.p_s32 = &c->value;
+		return ctrl->type_ops->validate(ctrl, ptr);
 
-	case V4L2_CTRL_TYPE_STRING:
-		len = strlen(c->string);
-		if (len < ctrl->minimum)
-			return -ERANGE;
-		if ((len - ctrl->minimum) % ctrl->step)
-			return -ERANGE;
-		return 0;
+	case V4L2_CTRL_TYPE_INTEGER64:
+		ptr.p_s64 = &c->value64;
+		return ctrl->type_ops->validate(ctrl, ptr);
 
 	default:
-		return -EINVAL;
+		ptr.p = c->ptr;
+		return ctrl->type_ops->validate(ctrl, ptr);
 	}
 }
 
@@ -1674,6 +1768,7 @@ unlock:
 /* Add a new control */
 static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
+			const struct v4l2_ctrl_type_ops *type_ops,
 			u32 id, const char *name, enum v4l2_ctrl_type type,
 			s64 min, s64 max, u64 step, s64 def,
 			u32 elem_size,
@@ -1731,6 +1826,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	INIT_LIST_HEAD(&ctrl->ev_subs);
 	ctrl->handler = hdl;
 	ctrl->ops = ops;
+	ctrl->type_ops = type_ops ? type_ops : &std_type_ops;
 	ctrl->id = id;
 	ctrl->name = name;
 	ctrl->type = type;
@@ -1751,16 +1847,16 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	ctrl->cur.val = ctrl->val = def;
 	data = &ctrl->cur + 1;
 
-	if (ctrl->is_string) {
-		ctrl->string = data;
-		ctrl->cur.string = data + elem_size;
-
-		if (ctrl->minimum)
-			memset(ctrl->cur.string, ' ', ctrl->minimum);
-	} else if (ctrl->is_ptr) {
-		ctrl->p = data;
-		ctrl->cur.p = data + elem_size;
+	if (ctrl->is_ptr) {
+		ctrl->p = ctrl->p_new.p = data;
+		ctrl->p_cur.p = data + elem_size;
+	} else {
+		ctrl->p_new.p = &ctrl->val;
+		ctrl->p_cur.p = &ctrl->cur.val;
 	}
+	ctrl->type_ops->init(ctrl, ctrl->p_cur);
+	ctrl->type_ops->init(ctrl, ctrl->p_new);
+
 	if (handler_new_ref(hdl, ctrl)) {
 		kfree(ctrl);
 		return NULL;
@@ -1804,7 +1900,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
 		return NULL;
 	}
 
-	ctrl = v4l2_ctrl_new(hdl, cfg->ops, cfg->id, name,
+	ctrl = v4l2_ctrl_new(hdl, cfg->ops, cfg->type_ops, cfg->id, name,
 			type, min, max,
 			is_menu ? cfg->menu_skip_mask : step,
 			def, cfg->elem_size,
@@ -1831,7 +1927,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
 		handler_set_err(hdl, -EINVAL);
 		return NULL;
 	}
-	return v4l2_ctrl_new(hdl, ops, id, name, type,
+	return v4l2_ctrl_new(hdl, ops, NULL, id, name, type,
 			     min, max, step, def, 0,
 			     flags, NULL, NULL, NULL);
 }
@@ -1864,7 +1960,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 		handler_set_err(hdl, -EINVAL);
 		return NULL;
 	}
-	return v4l2_ctrl_new(hdl, ops, id, name, type,
+	return v4l2_ctrl_new(hdl, ops, NULL, id, name, type,
 			     0, max, mask, def, 0,
 			     flags, qmenu, qmenu_int, NULL);
 }
@@ -1896,7 +1992,8 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
 		handler_set_err(hdl, -EINVAL);
 		return NULL;
 	}
-	return v4l2_ctrl_new(hdl, ops, id, name, type, 0, max, mask, def,
+	return v4l2_ctrl_new(hdl, ops, NULL, id, name, type,
+			     0, max, mask, def,
 			     0, flags, qmenu, NULL, NULL);
 
 }
@@ -1920,7 +2017,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
 		handler_set_err(hdl, -EINVAL);
 		return NULL;
 	}
-	return v4l2_ctrl_new(hdl, ops, id, name, type,
+	return v4l2_ctrl_new(hdl, ops, NULL, id, name, type,
 			     0, max, 0, def, 0,
 			     flags, NULL, qmenu_int, NULL);
 }
@@ -2104,32 +2201,8 @@ static void log_ctrl(const struct v4l2_ctrl *ctrl,
 
 	pr_info("%s%s%s: ", prefix, colon, ctrl->name);
 
-	switch (ctrl->type) {
-	case V4L2_CTRL_TYPE_INTEGER:
-		pr_cont("%d", ctrl->cur.val);
-		break;
-	case V4L2_CTRL_TYPE_BOOLEAN:
-		pr_cont("%s", ctrl->cur.val ? "true" : "false");
-		break;
-	case V4L2_CTRL_TYPE_MENU:
-		pr_cont("%s", ctrl->qmenu[ctrl->cur.val]);
-		break;
-	case V4L2_CTRL_TYPE_INTEGER_MENU:
-		pr_cont("%lld", ctrl->qmenu_int[ctrl->cur.val]);
-		break;
-	case V4L2_CTRL_TYPE_BITMASK:
-		pr_cont("0x%08x", ctrl->cur.val);
-		break;
-	case V4L2_CTRL_TYPE_INTEGER64:
-		pr_cont("%lld", ctrl->cur.val64);
-		break;
-	case V4L2_CTRL_TYPE_STRING:
-		pr_cont("%s", ctrl->cur.string);
-		break;
-	default:
-		pr_cont("unknown type %d", ctrl->type);
-		break;
-	}
+	ctrl->type_ops->log(ctrl);
+
 	if (ctrl->flags & (V4L2_CTRL_FLAG_INACTIVE |
 			   V4L2_CTRL_FLAG_GRABBED |
 			   V4L2_CTRL_FLAG_VOLATILE)) {
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 9024dae..ddd9fdf 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -36,6 +36,19 @@ struct v4l2_subscribed_event;
 struct v4l2_fh;
 struct poll_table_struct;
 
+/** union v4l2_ctrl_ptr - A pointer to a control value.
+ * @p_s32:	Pointer to a 32-bit signed value.
+ * @p_s64:	Pointer to a 64-bit signed value.
+ * @p_char:	Pointer to a string.
+ * @p:		Pointer to a compound value.
+ */
+union v4l2_ctrl_ptr {
+	s32 *p_s32;
+	s64 *p_s64;
+	char *p_char;
+	void *p;
+};
+
 /** struct v4l2_ctrl_ops - The control operations that the driver has to provide.
   * @g_volatile_ctrl: Get a new value for this control. Generally only relevant
   *		for volatile (and usually read-only) controls such as a control
@@ -54,6 +67,23 @@ struct v4l2_ctrl_ops {
 	int (*s_ctrl)(struct v4l2_ctrl *ctrl);
 };
 
+/** struct v4l2_ctrl_type_ops - The control type operations that the driver has to provide.
+  * @equal: return true if both values are equal.
+  * @init: initialize the value.
+  * @log: log the value.
+  * @validate: validate the value. Return 0 on success and a negative value otherwise.
+  */
+struct v4l2_ctrl_type_ops {
+	bool (*equal)(const struct v4l2_ctrl *ctrl,
+		      union v4l2_ctrl_ptr ptr1,
+		      union v4l2_ctrl_ptr ptr2);
+	void (*init)(const struct v4l2_ctrl *ctrl,
+		     union v4l2_ctrl_ptr ptr);
+	void (*log)(const struct v4l2_ctrl *ctrl);
+	int (*validate)(const struct v4l2_ctrl *ctrl,
+			union v4l2_ctrl_ptr ptr);
+};
+
 typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
 
 /** struct v4l2_ctrl - The control structure.
@@ -89,6 +119,7 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
   *		value, then the whole cluster is in manual mode. Drivers should
   *		never set this flag directly.
   * @ops:	The control ops.
+  * @type_ops:	The control type ops.
   * @id:	The control ID.
   * @name:	The control name.
   * @type:	The control type.
@@ -137,6 +168,7 @@ struct v4l2_ctrl {
 	unsigned int manual_mode_value:8;
 
 	const struct v4l2_ctrl_ops *ops;
+	const struct v4l2_ctrl_type_ops *type_ops;
 	u32 id;
 	const char *name;
 	enum v4l2_ctrl_type type;
@@ -164,6 +196,9 @@ struct v4l2_ctrl {
 		char *string;
 		void *p;
 	} cur;
+
+	union v4l2_ctrl_ptr p_new;
+	union v4l2_ctrl_ptr p_cur;
 };
 
 /** struct v4l2_ctrl_ref - The control reference.
@@ -217,6 +252,7 @@ struct v4l2_ctrl_handler {
 
 /** struct v4l2_ctrl_config - Control configuration structure.
   * @ops:	The control ops.
+  * @type_ops:	The control type ops. Only needed for compound controls.
   * @id:	The control ID.
   * @name:	The control name.
   * @type:	The control type.
@@ -241,6 +277,7 @@ struct v4l2_ctrl_handler {
   */
 struct v4l2_ctrl_config {
 	const struct v4l2_ctrl_ops *ops;
+	const struct v4l2_ctrl_type_ops *type_ops;
 	u32 id;
 	const char *name;
 	enum v4l2_ctrl_type type;
-- 
2.0.0.rc0

