Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2718 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbaJVKAj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 06:00:39 -0400
Message-ID: <5447803E.6080505@xs4all.nl>
Date: Wed, 22 Oct 2014 12:00:30 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] v4l2-ctrls: fix sparse warning
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems I forgot about this patch and I never posted it, but it is something that
needs to be fixed. Validating compound types could cause user pointers to be interpreted
as kernel pointers with potentially bad results. Pawel, this is likely to be relevant
to the codec API you are doing.


The warning is simple:

drivers/media/v4l2-core/v4l2-ctrls.c:1685:15: warning: incorrect type in assignment (different address spaces)

but the fix isn't.

The core problem was that the conversion from user to kernelspace was
done at too low a level and that needed to be moved up. That made it possible
to drop pointers to v4l2_ext_control from set_ctrl and validate_new and
clean up this sparse warning because those functions now always operate
on kernelspace pointers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
  drivers/media/v4l2-core/v4l2-ctrls.c | 87 +++++++++++++++++++++---------------
  1 file changed, 52 insertions(+), 35 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 8601214..45c5b47 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1658,10 +1658,8 @@ static int check_range(enum v4l2_ctrl_type type,
  }
  
  /* Validate a new control */
-static int validate_new(const struct v4l2_ctrl *ctrl,
-			struct v4l2_ext_control *c)
+static int validate_new(const struct v4l2_ctrl *ctrl, union v4l2_ctrl_ptr p_new)
  {
-	union v4l2_ctrl_ptr ptr;
  	unsigned idx;
  	int err = 0;
  
@@ -1674,19 +1672,14 @@ static int validate_new(const struct v4l2_ctrl *ctrl,
  		case V4L2_CTRL_TYPE_BOOLEAN:
  		case V4L2_CTRL_TYPE_BUTTON:
  		case V4L2_CTRL_TYPE_CTRL_CLASS:
-			ptr.p_s32 = &c->value;
-			return ctrl->type_ops->validate(ctrl, 0, ptr);
-
  		case V4L2_CTRL_TYPE_INTEGER64:
-			ptr.p_s64 = &c->value64;
-			return ctrl->type_ops->validate(ctrl, 0, ptr);
+			return ctrl->type_ops->validate(ctrl, 0, p_new);
  		default:
  			break;
  		}
  	}
-	ptr.p = c->ptr;
-	for (idx = 0; !err && idx < c->size / ctrl->elem_size; idx++)
-		err = ctrl->type_ops->validate(ctrl, idx, ptr);
+	for (idx = 0; !err && idx < ctrl->elems; idx++)
+		err = ctrl->type_ops->validate(ctrl, idx, p_new);
  	return err;
  }
  
@@ -3012,6 +3005,7 @@ static int validate_ctrls(struct v4l2_ext_controls *cs,
  	cs->error_idx = cs->count;
  	for (i = 0; i < cs->count; i++) {
  		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
+		union v4l2_ctrl_ptr p_new;
  
  		cs->error_idx = i;
  
@@ -3025,7 +3019,17 @@ static int validate_ctrls(struct v4l2_ext_controls *cs,
  		   best-effort to avoid that. */
  		if (set && (ctrl->flags & V4L2_CTRL_FLAG_GRABBED))
  			return -EBUSY;
-		ret = validate_new(ctrl, &cs->controls[i]);
+		/*
+		 * Skip validation for now if the payload needs to be copied
+		 * from userspace into kernelspace. We'll validate those later.
+		 */
+		if (ctrl->is_ptr)
+			continue;
+		if (ctrl->type == V4L2_CTRL_TYPE_INTEGER64)
+			p_new.p_s64 = &cs->controls[i].value64;
+		else
+			p_new.p_s32 = &cs->controls[i].value;
+		ret = validate_new(ctrl, p_new);
  		if (ret)
  			return ret;
  	}
@@ -3120,7 +3124,11 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
  		/* Copy the new caller-supplied control values.
  		   user_to_new() sets 'is_new' to 1. */
  		do {
-			ret = user_to_new(cs->controls + idx, helpers[idx].ctrl);
+			struct v4l2_ctrl *ctrl = helpers[idx].ctrl;
+
+			ret = user_to_new(cs->controls + idx, ctrl);
+			if (!ret && ctrl->is_ptr)
+				ret = validate_new(ctrl, ctrl->p_new);
  			idx = helpers[idx].next;
  		} while (!ret && idx);
  
@@ -3170,10 +3178,10 @@ int v4l2_subdev_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs
  EXPORT_SYMBOL(v4l2_subdev_s_ext_ctrls);
  
  /* Helper function for VIDIOC_S_CTRL compatibility */
-static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
-		    struct v4l2_ext_control *c, u32 ch_flags)
+static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
  {
  	struct v4l2_ctrl *master = ctrl->cluster[0];
+	int ret;
  	int i;
  
  	/* Reset the 'is_new' flags of the cluster */
@@ -3181,8 +3189,9 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
  		if (master->cluster[i])
  			master->cluster[i]->is_new = 0;
  
-	if (c)
-		user_to_new(c, ctrl);
+	ret = validate_new(ctrl, ctrl->p_new);
+	if (ret)
+		return ret;
  
  	/* For autoclusters with volatiles that are switched from auto to
  	   manual mode we have to update the current volatile values since
@@ -3199,15 +3208,14 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
  static int set_ctrl_lock(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
  			 struct v4l2_ext_control *c)
  {
-	int ret = validate_new(ctrl, c);
+	int ret;
  
-	if (!ret) {
-		v4l2_ctrl_lock(ctrl);
-		ret = set_ctrl(fh, ctrl, c, 0);
-		if (!ret)
-			cur_to_user(c, ctrl);
-		v4l2_ctrl_unlock(ctrl);
-	}
+	v4l2_ctrl_lock(ctrl);
+	user_to_new(c, ctrl);
+	ret = set_ctrl(fh, ctrl, 0);
+	if (!ret)
+		cur_to_user(c, ctrl);
+	v4l2_ctrl_unlock(ctrl);
  	return ret;
  }
  
@@ -3215,7 +3223,7 @@ int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
  					struct v4l2_control *control)
  {
  	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(hdl, control->id);
-	struct v4l2_ext_control c;
+	struct v4l2_ext_control c = { control->id };
  	int ret;
  
  	if (ctrl == NULL || !ctrl->is_int)
@@ -3244,7 +3252,7 @@ int __v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
  	/* It's a driver bug if this happens. */
  	WARN_ON(!ctrl->is_int);
  	ctrl->val = val;
-	return set_ctrl(NULL, ctrl, NULL, 0);
+	return set_ctrl(NULL, ctrl, 0);
  }
  EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl);
  
@@ -3255,7 +3263,7 @@ int __v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
  	/* It's a driver bug if this happens. */
  	WARN_ON(ctrl->is_ptr || ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
  	*ctrl->p_new.p_s64 = val;
-	return set_ctrl(NULL, ctrl, NULL, 0);
+	return set_ctrl(NULL, ctrl, 0);
  }
  EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_int64);
  
@@ -3266,7 +3274,7 @@ int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
  	/* It's a driver bug if this happens. */
  	WARN_ON(ctrl->type != V4L2_CTRL_TYPE_STRING);
  	strlcpy(ctrl->p_new.p_char, s, ctrl->maximum + 1);
-	return set_ctrl(NULL, ctrl, NULL, 0);
+	return set_ctrl(NULL, ctrl, 0);
  }
  EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_string);
  
@@ -3289,8 +3297,8 @@ EXPORT_SYMBOL(v4l2_ctrl_notify);
  int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
  			s64 min, s64 max, u64 step, s64 def)
  {
+	bool changed;
  	int ret;
-	struct v4l2_ext_control c;
  
  	lockdep_assert_held(ctrl->handler->lock);
  
@@ -3317,11 +3325,20 @@ int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
  	ctrl->maximum = max;
  	ctrl->step = step;
  	ctrl->default_value = def;
-	c.value = *ctrl->p_cur.p_s32;
-	if (validate_new(ctrl, &c))
-		c.value = def;
-	if (c.value != *ctrl->p_cur.p_s32)
-		ret = set_ctrl(NULL, ctrl, &c, V4L2_EVENT_CTRL_CH_RANGE);
+	cur_to_new(ctrl);
+	if (validate_new(ctrl, ctrl->p_new)) {
+		if (ctrl->type == V4L2_CTRL_TYPE_INTEGER64)
+			*ctrl->p_new.p_s64 = def;
+		else
+			*ctrl->p_new.p_s32 = def;
+	}
+
+	if (ctrl->type == V4L2_CTRL_TYPE_INTEGER64)
+		changed = *ctrl->p_new.p_s64 != *ctrl->p_cur.p_s64;
+	else
+		changed = *ctrl->p_new.p_s32 != *ctrl->p_cur.p_s32;
+	if (changed)
+		ret = set_ctrl(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
  	else
  		send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
  	return ret;
-- 
2.1.1

