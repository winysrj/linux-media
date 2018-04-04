Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44044 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752344AbeDDPdV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2018 11:33:21 -0400
Subject: Patch "media: v4l2-ctrls: fix sparse warning" has been added to the 3.18-stable tree
To: mchehab@s-opensource.com, gregkh@linuxfoundation.org,
        hans.verkuil@cisco.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, mchehab@infradead.org,
        mchehab@osg.samsung.com
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Wed, 04 Apr 2018 17:32:59 +0200
In-Reply-To: <d53d22eb0ea4cdbcb2e7f02d789a01892d8c36cf.1522260310.git.mchehab@s-opensource.com>
Message-ID: <152285597918642@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This is a note to let you know that I've just added the patch titled

    media: v4l2-ctrls: fix sparse warning

to the 3.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     media-v4l2-ctrls-fix-sparse-warning.patch
and it can be found in the queue-3.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From foo@baz Wed Apr  4 17:30:18 CEST 2018
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Date: Wed, 28 Mar 2018 15:12:34 -0300
Subject: media: v4l2-ctrls: fix sparse warning
To: Linux Media Mailing List <linux-media@vger.kernel.org>, stable@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@s-opensource.com>
Message-ID: <d53d22eb0ea4cdbcb2e7f02d789a01892d8c36cf.1522260310.git.mchehab@s-opensource.com>

From: Hans Verkuil <hans.verkuil@cisco.com>

The warning is simple:

drivers/media/v4l2-core/v4l2-ctrls.c:1685:15: warning: incorrect type in assignment (different address spaces)

but the fix isn't.

The core problem was that the conversion from user to kernelspace was
done at too low a level and that needed to be moved up. That made it possible
to drop pointers to v4l2_ext_control from set_ctrl and validate_new and
clean up this sparse warning because those functions now always operate
on kernelspace pointers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |   87 ++++++++++++++++++++---------------
 1 file changed, 52 insertions(+), 35 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1668,10 +1668,8 @@ static int check_range(enum v4l2_ctrl_ty
 }
 
 /* Validate a new control */
-static int validate_new(const struct v4l2_ctrl *ctrl,
-			struct v4l2_ext_control *c)
+static int validate_new(const struct v4l2_ctrl *ctrl, union v4l2_ctrl_ptr p_new)
 {
-	union v4l2_ctrl_ptr ptr;
 	unsigned idx;
 	int err = 0;
 
@@ -1684,19 +1682,14 @@ static int validate_new(const struct v4l
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
 
@@ -3020,6 +3013,7 @@ static int validate_ctrls(struct v4l2_ex
 	cs->error_idx = cs->count;
 	for (i = 0; i < cs->count; i++) {
 		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
+		union v4l2_ctrl_ptr p_new;
 
 		cs->error_idx = i;
 
@@ -3033,7 +3027,17 @@ static int validate_ctrls(struct v4l2_ex
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
@@ -3128,7 +3132,11 @@ static int try_set_ext_ctrls(struct v4l2
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
 
@@ -3178,10 +3186,10 @@ int v4l2_subdev_s_ext_ctrls(struct v4l2_
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
@@ -3189,8 +3197,9 @@ static int set_ctrl(struct v4l2_fh *fh,
 		if (master->cluster[i])
 			master->cluster[i]->is_new = 0;
 
-	if (c)
-		user_to_new(c, ctrl);
+	ret = validate_new(ctrl, ctrl->p_new);
+	if (ret)
+		return ret;
 
 	/* For autoclusters with volatiles that are switched from auto to
 	   manual mode we have to update the current volatile values since
@@ -3207,15 +3216,14 @@ static int set_ctrl(struct v4l2_fh *fh,
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
 
@@ -3223,7 +3231,7 @@ int v4l2_s_ctrl(struct v4l2_fh *fh, stru
 					struct v4l2_control *control)
 {
 	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(hdl, control->id);
-	struct v4l2_ext_control c;
+	struct v4l2_ext_control c = { control->id };
 	int ret;
 
 	if (ctrl == NULL || !ctrl->is_int)
@@ -3252,7 +3260,7 @@ int __v4l2_ctrl_s_ctrl(struct v4l2_ctrl
 	/* It's a driver bug if this happens. */
 	WARN_ON(!ctrl->is_int);
 	ctrl->val = val;
-	return set_ctrl(NULL, ctrl, NULL, 0);
+	return set_ctrl(NULL, ctrl, 0);
 }
 EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl);
 
@@ -3263,7 +3271,7 @@ int __v4l2_ctrl_s_ctrl_int64(struct v4l2
 	/* It's a driver bug if this happens. */
 	WARN_ON(ctrl->is_ptr || ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
 	*ctrl->p_new.p_s64 = val;
-	return set_ctrl(NULL, ctrl, NULL, 0);
+	return set_ctrl(NULL, ctrl, 0);
 }
 EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_int64);
 
@@ -3274,7 +3282,7 @@ int __v4l2_ctrl_s_ctrl_string(struct v4l
 	/* It's a driver bug if this happens. */
 	WARN_ON(ctrl->type != V4L2_CTRL_TYPE_STRING);
 	strlcpy(ctrl->p_new.p_char, s, ctrl->maximum + 1);
-	return set_ctrl(NULL, ctrl, NULL, 0);
+	return set_ctrl(NULL, ctrl, 0);
 }
 EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_string);
 
@@ -3297,8 +3305,8 @@ EXPORT_SYMBOL(v4l2_ctrl_notify);
 int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 			s64 min, s64 max, u64 step, s64 def)
 {
+	bool changed;
 	int ret;
-	struct v4l2_ext_control c;
 
 	lockdep_assert_held(ctrl->handler->lock);
 
@@ -3325,11 +3333,20 @@ int __v4l2_ctrl_modify_range(struct v4l2
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


Patches currently in stable-queue which might be from mchehab@s-opensource.com are

queue-3.18/media-v4l2-compat-ioctl32.c-copy-m.userptr-in-put_v4l2_plane32.patch
queue-3.18/media-v4l2-compat-ioctl32.c-avoid-sizeof-type.patch
queue-3.18/media-v4l2-compat-ioctl32.c-drop-pr_info-for-unknown-buffer-type.patch
queue-3.18/media-v4l2-compat-ioctl32-use-compat_u64-for-video-standard.patch
queue-3.18/media-v4l2-compat-ioctl32.c-add-missing-vidioc_prepare_buf.patch
queue-3.18/vb2-v4l2_buf_flag_done-is-set-after-dqbuf.patch
queue-3.18/media-v4l2-compat-ioctl32.c-refactor-compat-ioctl32-logic.patch
queue-3.18/media-v4l2-ctrls-fix-sparse-warning.patch
queue-3.18/media-v4l2-compat-ioctl32.c-fix-ctrl_is_pointer.patch
queue-3.18/media-v4l2-compat-ioctl32.c-move-helper-functions-to-__get-put_v4l2_format32.patch
queue-3.18/media-media-v4l2-ctrls-volatiles-should-not-generate-ch_value.patch
queue-3.18/media-v4l2-compat-ioctl32.c-don-t-copy-back-the-result-for-certain-errors.patch
queue-3.18/media-v4l2-compat-ioctl32.c-make-ctrl_is_pointer-work-for-subdevs.patch
queue-3.18/media-v4l2-compat-ioctl32.c-fix-the-indentation.patch
queue-3.18/media-v4l2-compat-ioctl32-copy-v4l2_window-global_alpha.patch
queue-3.18/media-v4l2-ioctl.c-don-t-copy-back-the-result-for-enotty.patch
queue-3.18/media-v4l2-compat-ioctl32.c-copy-clip-list-in-put_v4l2_window32.patch
queue-3.18/media-v4l2-compat-ioctl32-initialize-a-reserved-field.patch
