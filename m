Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:42843 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab1K2LIM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 06:08:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 1/2] v4l: Add new alpha component control
Date: Tue, 29 Nov 2011 12:08:10 +0100
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com,
	jonghun.han@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
References: <1322235572-22016-1-git-send-email-s.nawrocki@samsung.com> <201111281339.03100.hverkuil@xs4all.nl> <4ED38679.2080101@samsung.com>
In-Reply-To: <4ED38679.2080101@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111291208.10495.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 28 November 2011 14:02:49 Sylwester Nawrocki wrote:
> On 11/28/2011 01:39 PM, Hans Verkuil wrote:
> > On Monday 28 November 2011 13:13:32 Sylwester Nawrocki wrote:
> >> On 11/28/2011 12:38 PM, Hans Verkuil wrote:
> >>> On Friday 25 November 2011 16:39:31 Sylwester Nawrocki wrote:
> >>>> This control is intended for the video capture or memory-to-memory
> >>>> devices that are capable of setting up a per-pixel alpha component to
> >>>> some arbitrary value. The V4L2_CID_ALPHA_COMPONENT control allows to
> >>>> set the alpha component for all pixels to a value in range from 0 to
> >>>> 255.
> >>>> 
> >>>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>>> ---
> >>>> 
> >>>>  Documentation/DocBook/media/v4l/compat.xml         |   11 ++++++++
> >>>>  Documentation/DocBook/media/v4l/controls.xml       |   25
> >>>> 
> >>>> +++++++++++++++---- .../DocBook/media/v4l/pixfmt-packed-rgb.xml       
> >>>> |
> >>>> 
> >>>>  7 ++++-
> >>>>  drivers/media/video/v4l2-ctrls.c                   |    7 +++++
> >>>>  include/linux/videodev2.h                          |    6 ++--
> >>>>  5 files changed, 45 insertions(+), 11 deletions(-)
> >> 
> >> ...
> >> 
> >>>>  	/* MPEG controls */
> >>>>  	/* Keep the order of the 'case's the same as in videodev2.h! */
> >>>> 
> >>>> @@ -714,6 +715,12 @@ void v4l2_ctrl_fill(u32 id, const char **name,
> >>>> enum v4l2_ctrl_type *type, /* Max is calculated as RGB888 that is
> >>>> 2^24 */
> >>>> 
> >>>>  		*max = 0xFFFFFF;
> >>>>  		break;
> >>>> 
> >>>> +	case V4L2_CID_ALPHA_COMPONENT:
> >>>> +		*type = V4L2_CTRL_TYPE_INTEGER;
> >>>> +		*step = 1;
> >>>> +		*min = 0;
> >>>> +		*max = 0xff;
> >>>> +		break;
> >>> 
> >>> Hmm. Do we really want to fix the max value to 0xff? The bits assigned
> >>> to the alpha component will vary between 1 (V4L2_PIX_FMT_RGB555X), 4
> >>> (V4L2_PIX_FMT_RGB444) or 8 (V4L2_PIX_FMT_RGB32). It wouldn't surprise
> >>> me to see larger sizes as well in the future (e.g. 16 bits).
> >>> 
> >>> I think the max value should be the largest alpha value the hardware
> >>> can support. The application has to set it to the right value that
> >>> corresponds to the currently chosen pixel format. The driver just
> >>> copies the first N bits into the alpha value where N depends on the
> >>> pixel format.
> >>> 
> >>> what do you think?
> >> 
> >> Yes, ideally the maximum value of the alpha control should be changing
> >> depending on the set colour format.
> >> Currently the maximum value of the control equals maximum alpha value
> >> for the fourcc of maximum colour depth (V4L2_PIX_FMT_RGB32).
> >> 
> >> What I found missing was a method for changing the control range
> >> dynamically, without deleting and re-initializing the control handler.
> >> If we reinitalize whole control handler the previously set control
> >> values are lost.
> > 
> > You can just change the maximum field of struct v4l2_ctrl on the fly like
> > this:
> > diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> > struct v4l2_ctrl *my_ctrl;
> > 
> > v4l2_ctrl_lock(my_ctrl);
> > my_ctrl->maximum = 10;
> > if (my_ctrl->cur.val > my_ctrl->maximum)
> > 
> > 	my_ctrl->cur.val = my_ctrl->maximum;
> > 
> > v4l2_ctrl_unlock(my_ctrl);
> > 
> > Although this might warrant a v4l2_ctrl_update_range() function that does
> > this for you. Because after a change like this a V4L2_EVENT_CTRL should
> > also be sent.
> > 
> > In any case, this functionality isn't hard to add. Just let me know if
> > you need it and I can make a patch for this.
> 
> Yes, it would be great if you could prepare a patch for
> v4l2_ctrl_update_range(). Then I could use it in the next iteration of the
> patches, instead of hacking at the driver. IIRC it's not the first time we
> needed changing the control range dynamically.

Here is a patch that updates the range. It also sends a control event telling
any listener that the range has changed. Tested with vivi and a modified
v4l2-ctl.

The only thing missing is a DocBook entry for that new event flag and perhaps
some more documentation in places.

Let me know how this works for you, and if it is really needed, then I can
add it to the control framework.

Regards,

	Hans

index 0f415da..d7ca646 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -913,8 +913,7 @@ static int new_to_user(struct v4l2_ext_control *c,
 }
 
 /* Copy the new value to the current value. */
-static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
-						bool update_inactive)
+static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
 {
 	bool changed = false;
 
@@ -938,8 +937,8 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 		ctrl->cur.val = ctrl->val;
 		break;
 	}
-	if (update_inactive) {
-		/* Note: update_inactive can only be true for auto clusters. */
+	if (ch_flags & V4L2_EVENT_CTRL_CH_FLAGS) {
+		/* Note: CH_FLAGS is only set for auto clusters. */
 		ctrl->flags &=
 			~(V4L2_CTRL_FLAG_INACTIVE | V4L2_CTRL_FLAG_VOLATILE);
 		if (!is_cur_manual(ctrl->cluster[0])) {
@@ -949,14 +948,13 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 		}
 		fh = NULL;
 	}
-	if (changed || update_inactive) {
+	if (changed || ch_flags) {
 		/* If a control was changed that was not one of the controls
 		   modified by the application, then send the event to all. */
 		if (!ctrl->is_new)
 			fh = NULL;
 		send_event(fh, ctrl,
-			(changed ? V4L2_EVENT_CTRL_CH_VALUE : 0) |
-			(update_inactive ? V4L2_EVENT_CTRL_CH_FLAGS : 0));
+			(changed ? V4L2_EVENT_CTRL_CH_VALUE : 0) | ch_flags);
 	}
 }
 
@@ -1290,6 +1288,40 @@ unlock:
 	return 0;
 }
 
+/* Control range checking */
+static int check_range(enum v4l2_ctrl_type type,
+		s32 min, s32 max, u32 step, s32 def)
+{
+	switch (type) {
+	case V4L2_CTRL_TYPE_BOOLEAN:
+		if (step != 1 || max > 1 || min < 0)
+			return -ERANGE;
+		/* fall through */
+	case V4L2_CTRL_TYPE_INTEGER:
+		if (step <= 0 || min > max || def < min || def > max)
+			return -ERANGE;
+		return 0;
+	case V4L2_CTRL_TYPE_BITMASK:
+		if (step || min || !max || (def & ~max))
+			return -ERANGE;
+		return 0;
+	case V4L2_CTRL_TYPE_MENU:
+		if (min > max || def < min || def > max)
+			return -ERANGE;
+		/* Note: step == menu_skip_mask for menu controls.
+		   So here we check if the default value is masked out. */
+		if (step && ((1 << def) & step))
+			return -EINVAL;
+		return 0;
+	case V4L2_CTRL_TYPE_STRING:
+		if (min > max || min < 0 || step < 1 || def)
+			return -ERANGE;
+		return 0;
+	default:
+		return 0;
+	}
+}
+
 /* Add a new control */
 static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
@@ -1299,32 +1331,20 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 {
 	struct v4l2_ctrl *ctrl;
 	unsigned sz_extra = 0;
+	int err;
 
 	if (hdl->error)
 		return NULL;
 
 	/* Sanity checks */
 	if (id == 0 || name == NULL || id >= V4L2_CID_PRIVATE_BASE ||
-	    (type == V4L2_CTRL_TYPE_INTEGER && step == 0) ||
-	    (type == V4L2_CTRL_TYPE_BITMASK && max == 0) ||
-	    (type == V4L2_CTRL_TYPE_MENU && qmenu == NULL) ||
-	    (type == V4L2_CTRL_TYPE_STRING && max == 0)) {
-		handler_set_err(hdl, -ERANGE);
-		return NULL;
-	}
-	if (type != V4L2_CTRL_TYPE_BITMASK && max < min) {
+	    (type == V4L2_CTRL_TYPE_MENU && qmenu == NULL)) {
 		handler_set_err(hdl, -ERANGE);
 		return NULL;
 	}
-	if ((type == V4L2_CTRL_TYPE_INTEGER ||
-	     type == V4L2_CTRL_TYPE_MENU ||
-	     type == V4L2_CTRL_TYPE_BOOLEAN) &&
-	    (def < min || def > max)) {
-		handler_set_err(hdl, -ERANGE);
-		return NULL;
-	}
-	if (type == V4L2_CTRL_TYPE_BITMASK && ((def & ~max) || min || step)) {
-		handler_set_err(hdl, -ERANGE);
+	err = check_range(type, min, max, step, def);
+	if (err) {
+		handler_set_err(hdl, err);
 		return NULL;
 	}
 
@@ -2062,7 +2082,7 @@ EXPORT_SYMBOL(v4l2_ctrl_g_ctrl);
    copied to the current value on a set.
    Must be called with ctrl->handler->lock held. */
 static int try_or_set_cluster(struct v4l2_fh *fh,
-			      struct v4l2_ctrl *master, bool set)
+			      struct v4l2_ctrl *master, bool set, u32 ch_flags)
 {
 	bool update_flag;
 	int ret;
@@ -2100,7 +2120,8 @@ static int try_or_set_cluster(struct v4l2_fh *fh,
 	/* If OK, then make the new values permanent. */
 	update_flag = is_cur_manual(master) != is_new_manual(master);
 	for (i = 0; i < master->ncontrols; i++)
-		new_to_cur(fh, master->cluster[i], update_flag && i > 0);
+		new_to_cur(fh, master->cluster[i], ch_flags |
+			((update_flag && i > 0) ? V4L2_EVENT_CTRL_CH_FLAGS : 0));
 	return 0;
 }
 
@@ -2226,7 +2247,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		} while (!ret && idx);
 
 		if (!ret)
-			ret = try_or_set_cluster(fh, master, set);
+			ret = try_or_set_cluster(fh, master, set, 0);
 
 		/* Copy the new values back to userspace. */
 		if (!ret) {
@@ -2271,18 +2292,12 @@ int v4l2_subdev_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs
 EXPORT_SYMBOL(v4l2_subdev_s_ext_ctrls);
 
 /* Helper function for VIDIOC_S_CTRL compatibility */
-static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, s32 *val)
+static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
+		    s32 val, u32 ch_flags)
 {
 	struct v4l2_ctrl *master = ctrl->cluster[0];
-	int ret;
 	int i;
 
-	ret = validate_new_int(ctrl, val);
-	if (ret)
-		return ret;
-
-	v4l2_ctrl_lock(ctrl);
-
 	/* Reset the 'is_new' flags of the cluster */
 	for (i = 0; i < master->ncontrols; i++)
 		if (master->cluster[i])
@@ -2292,13 +2307,25 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, s32 *val)
 	   manual mode we have to update the current volatile values since
 	   those will become the initial manual values after such a switch. */
 	if (master->is_auto && master->has_volatiles && ctrl == master &&
-	    !is_cur_manual(master) && *val == master->manual_mode_value)
+	    !is_cur_manual(master) && val == master->manual_mode_value)
 		update_from_auto_cluster(master);
-	ctrl->val = *val;
+	ctrl->val = val;
 	ctrl->is_new = 1;
-	ret = try_or_set_cluster(fh, master, true);
-	*val = ctrl->cur.val;
-	v4l2_ctrl_unlock(ctrl);
+	return try_or_set_cluster(fh, master, true, ch_flags);
+}
+
+/* Helper function for VIDIOC_S_CTRL compatibility */
+static int set_ctrl_lock(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, s32 *val)
+{
+	int ret = validate_new_int(ctrl, val);
+
+	if (!ret) {
+		v4l2_ctrl_lock(ctrl);
+		ret = set_ctrl(fh, ctrl, *val, 0);
+		if (!ret)
+			*val = ctrl->cur.val;
+		v4l2_ctrl_unlock(ctrl);
+	}
 	return ret;
 }
 
@@ -2313,7 +2340,7 @@ int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 	if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
 		return -EACCES;
 
-	return set_ctrl(fh, ctrl, &control->value);
+	return set_ctrl_lock(fh, ctrl, &control->value);
 }
 EXPORT_SYMBOL(v4l2_s_ctrl);
 
@@ -2327,10 +2354,44 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 {
 	/* It's a driver bug if this happens. */
 	WARN_ON(!type_is_int(ctrl));
-	return set_ctrl(NULL, ctrl, &val);
+	return set_ctrl_lock(NULL, ctrl, &val);
 }
 EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
 
+int v4l2_ctrl_update_range(struct v4l2_ctrl *ctrl,
+			s32 min, s32 max, u32 step, s32 def)
+{
+	int ret = check_range(ctrl->type, min, max, step, def);
+	s32 val;
+
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_INTEGER:
+	case V4L2_CTRL_TYPE_BOOLEAN:
+	case V4L2_CTRL_TYPE_MENU:
+	case V4L2_CTRL_TYPE_BITMASK:
+		if (ret)
+			return ret;
+		break;
+	default:
+		return -EINVAL;
+	}
+	v4l2_ctrl_lock(ctrl);
+	ctrl->minimum = min;
+	ctrl->maximum = max;
+	ctrl->step = step;
+	ctrl->default_value = def;
+	val = ctrl->cur.val;
+	if (validate_new_int(ctrl, &val))
+		val = def;
+	if (val != ctrl->cur.val)
+		ret = set_ctrl(NULL, ctrl, val, V4L2_EVENT_CTRL_CH_RANGE);
+	else
+		send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
+	v4l2_ctrl_unlock(ctrl);
+	return ret;
+}
+EXPORT_SYMBOL(v4l2_ctrl_update_range);
+
 void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
 				struct v4l2_subscribed_event *sev)
 {
@@ -2339,7 +2400,7 @@ void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
 	if (ctrl->type != V4L2_CTRL_TYPE_CTRL_CLASS &&
 	    (sev->flags & V4L2_EVENT_SUB_FL_SEND_INITIAL)) {
 		struct v4l2_event ev;
-		u32 changes = V4L2_EVENT_CTRL_CH_FLAGS;
+		u32 changes = V4L2_EVENT_CTRL_CH_FLAGS | V4L2_EVENT_CTRL_CH_RANGE;
 
 		if (!(ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY))
 			changes |= V4L2_EVENT_CTRL_CH_VALUE;
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 7d754fb..fd89106 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -190,6 +190,7 @@ struct vivi_dev {
 	unsigned 		   ms;
 	unsigned long              jiffies;
 	unsigned		   button_pressed;
+	bool			   toggle_range;
 
 	int			   mv_count;	/* Controls bars movement */
 
@@ -545,6 +546,17 @@ static void vivi_thread_tick(struct vivi_dev *dev)
 	vivi_fillbuff(dev, buf);
 	dprintk(dev, 1, "filled buffer %p\n", buf);
 
+	if (dev->toggle_range) {
+		static bool toggle;
+
+		dev->toggle_range = false;
+		if (toggle)
+			v4l2_ctrl_update_range(dev->contrast, 0, 255, 1, 16);
+		else
+			v4l2_ctrl_update_range(dev->contrast, 128, 255, 2, 150);
+		toggle = !toggle;
+	}
+
 	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
 	dprintk(dev, 2, "[%p/%d] done\n", buf, buf->vb.v4l2_buf.index);
 }
@@ -1034,8 +1046,10 @@ static int vivi_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct vivi_dev *dev = container_of(ctrl->handler, struct vivi_dev, ctrl_handler);
 
-	if (ctrl == dev->button)
+	if (ctrl == dev->button) {
 		dev->button_pressed = 30;
+		dev->toggle_range = true;
+	}
 	return 0;
 }
 
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 4b752d5..22e632a 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -2063,6 +2063,7 @@ struct v4l2_event_vsync {
 /* Payload for V4L2_EVENT_CTRL */
 #define V4L2_EVENT_CTRL_CH_VALUE		(1 << 0)
 #define V4L2_EVENT_CTRL_CH_FLAGS		(1 << 1)
+#define V4L2_EVENT_CTRL_CH_RANGE		(1 << 2)
 
 struct v4l2_event_ctrl {
 	__u32 changes;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index eeb3df6..69ea0d5 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -445,6 +445,23 @@ void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active);
   */
 void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
 
+/** v4l2_ctrl_update_range() - Update the range of a control.
+  * @ctrl:	The control to update.
+  * @min:	The control's minimum value.
+  * @max:	The control's maximum value.
+  * @step:	The control's step value
+  * @def: 	The control's default value.
+  *
+  * Update the range of a control on the fly. This works for control types
+  * INTEGER, BOOLEAN, MENU and BITMASK. For menu controls the @step value
+  * is interpreted as a menu_skip_mask.
+  *
+  * An error is returned if one of the range arguments is invalid for this
+  * control type.
+  */
+int v4l2_ctrl_update_range(struct v4l2_ctrl *ctrl,
+			s32 min, s32 max, u32 step, s32 def);
+
 /** v4l2_ctrl_lock() - Helper function to lock the handler
   * associated with the control.
   * @ctrl:	The control to lock.
