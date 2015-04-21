Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:53405 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753951AbbDUNRG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:17:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 08/15] v4l2-ctrls: add VIDIOC_REQUEST_CMD
Date: Tue, 21 Apr 2015 14:58:51 +0200
Message-Id: <1429621138-17213-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
References: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c  | 60 ++++++++++++++++----------
 drivers/media/v4l2-core/v4l2-dev.c    |  1 +
 drivers/media/v4l2-core/v4l2-ioctl.c  | 81 ++++++++++++++++++++++++++++++-----
 drivers/media/v4l2-core/v4l2-subdev.c | 63 ++++++++++++++++++++++++---
 include/media/v4l2-ctrls.h            |  8 ++--
 include/media/v4l2-fh.h               |  1 +
 include/uapi/linux/videodev2.h        | 19 +++++++-
 7 files changed, 189 insertions(+), 44 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 43fb3c2..d262e2e 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2715,9 +2715,13 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 EXPORT_SYMBOL(v4l2_query_ext_ctrl);
 
 /* Implement VIDIOC_QUERYCTRL */
-int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
+int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl,
+		   unsigned request, struct v4l2_queryctrl *qc)
 {
-	struct v4l2_query_ext_ctrl qec = { qc->id };
+	struct v4l2_query_ext_ctrl qec = {
+		.id = qc->id,
+		.request = request,
+	};
 	int rc;
 
 	rc = v4l2_query_ext_ctrl(hdl, &qec);
@@ -2755,7 +2759,7 @@ int v4l2_subdev_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
 {
 	if (qc->id & (V4L2_CTRL_FLAG_NEXT_CTRL | V4L2_CTRL_FLAG_NEXT_COMPOUND))
 		return -EINVAL;
-	return v4l2_queryctrl(sd->ctrl_handler, qc);
+	return v4l2_queryctrl(sd->ctrl_handler, 0, qc);
 }
 EXPORT_SYMBOL(v4l2_subdev_queryctrl);
 
@@ -3058,7 +3062,8 @@ int v4l2_subdev_g_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs
 EXPORT_SYMBOL(v4l2_subdev_g_ext_ctrls);
 
 /* Helper function to get a single control */
-static int get_ctrl(struct v4l2_ctrl *ctrl, struct v4l2_ext_control *c)
+static int get_ctrl(struct v4l2_ctrl *ctrl,
+		    unsigned request, struct v4l2_ext_control *c)
 {
 	struct v4l2_ctrl *master = ctrl->cluster[0];
 	int ret = 0;
@@ -3076,11 +3081,17 @@ static int get_ctrl(struct v4l2_ctrl *ctrl, struct v4l2_ext_control *c)
 
 	v4l2_ctrl_lock(master);
 	/* g_volatile_ctrl will update the current control values */
-	if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) {
+	if (request == 0 && (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE)) {
 		for (i = 0; i < master->ncontrols; i++)
 			cur_to_new(master->cluster[i]);
 		ret = call_op(master, g_volatile_ctrl);
 		new_to_user(c, ctrl);
+	} else if (request) {
+		ctrl->request = get_request(ctrl, request);
+		if (ctrl->request)
+			ptr_to_user(c, ctrl, ctrl->request->ptr);
+		else
+			ret = -EINVAL;
 	} else {
 		cur_to_user(c, ctrl);
 	}
@@ -3088,7 +3099,8 @@ static int get_ctrl(struct v4l2_ctrl *ctrl, struct v4l2_ext_control *c)
 	return ret;
 }
 
-int v4l2_g_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *control)
+int v4l2_g_ctrl(struct v4l2_ctrl_handler *hdl,
+		unsigned request, struct v4l2_control *control)
 {
 	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(hdl, control->id);
 	struct v4l2_ext_control c;
@@ -3096,7 +3108,7 @@ int v4l2_g_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *control)
 
 	if (ctrl == NULL || !ctrl->is_int)
 		return -EINVAL;
-	ret = get_ctrl(ctrl, &c);
+	ret = get_ctrl(ctrl, request, &c);
 	control->value = c.value;
 	return ret;
 }
@@ -3104,7 +3116,7 @@ EXPORT_SYMBOL(v4l2_g_ctrl);
 
 int v4l2_subdev_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *control)
 {
-	return v4l2_g_ctrl(sd->ctrl_handler, control);
+	return v4l2_g_ctrl(sd->ctrl_handler, 0, control);
 }
 EXPORT_SYMBOL(v4l2_subdev_g_ctrl);
 
@@ -3115,7 +3127,7 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl)
 	/* It's a driver bug if this happens. */
 	WARN_ON(!ctrl->is_int);
 	c.value = 0;
-	get_ctrl(ctrl, &c);
+	get_ctrl(ctrl, 0, &c);
 	return c.value;
 }
 EXPORT_SYMBOL(v4l2_ctrl_g_ctrl);
@@ -3127,7 +3139,7 @@ s64 v4l2_ctrl_g_ctrl_int64(struct v4l2_ctrl *ctrl)
 	/* It's a driver bug if this happens. */
 	WARN_ON(ctrl->is_ptr || ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
 	c.value = 0;
-	get_ctrl(ctrl, &c);
+	get_ctrl(ctrl, 0, &c);
 	return c.value;
 }
 EXPORT_SYMBOL(v4l2_ctrl_g_ctrl_int64);
@@ -3384,7 +3396,8 @@ int v4l2_subdev_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs
 EXPORT_SYMBOL(v4l2_subdev_s_ext_ctrls);
 
 /* Helper function for VIDIOC_S_CTRL compatibility */
-static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
+static int set_ctrl(struct v4l2_fh *fh, unsigned request,
+		    struct v4l2_ctrl *ctrl, u32 ch_flags)
 {
 	struct v4l2_ctrl *master = ctrl->cluster[0];
 	int ret;
@@ -3404,23 +3417,24 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
 	/* For autoclusters with volatiles that are switched from auto to
 	   manual mode we have to update the current volatile values since
 	   those will become the initial manual values after such a switch. */
-	if (master->is_auto && master->has_volatiles && ctrl == master &&
+	if (request == 0 &&
+	    master->is_auto && master->has_volatiles && ctrl == master &&
 	    !is_cur_manual(master) && ctrl->val == master->manual_mode_value)
 		update_from_auto_cluster(master);
 
 	ctrl->is_new = 1;
-	return try_or_set_cluster(fh, master, 0, true, ch_flags);
+	return try_or_set_cluster(fh, master, request, true, ch_flags);
 }
 
 /* Helper function for VIDIOC_S_CTRL compatibility */
-static int set_ctrl_lock(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
-			 struct v4l2_ext_control *c)
+static int set_ctrl_lock(struct v4l2_fh *fh, unsigned request,
+			 struct v4l2_ctrl *ctrl, struct v4l2_ext_control *c)
 {
 	int ret;
 
 	v4l2_ctrl_lock(ctrl);
 	user_to_new(c, ctrl);
-	ret = set_ctrl(fh, ctrl, 0);
+	ret = set_ctrl(fh, request, ctrl, 0);
 	if (!ret)
 		cur_to_user(c, ctrl);
 	v4l2_ctrl_unlock(ctrl);
@@ -3428,7 +3442,7 @@ static int set_ctrl_lock(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 }
 
 int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
-					struct v4l2_control *control)
+		unsigned request, struct v4l2_control *control)
 {
 	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(hdl, control->id);
 	struct v4l2_ext_control c = { control->id };
@@ -3441,7 +3455,7 @@ int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		return -EACCES;
 
 	c.value = control->value;
-	ret = set_ctrl_lock(fh, ctrl, &c);
+	ret = set_ctrl_lock(fh, request, ctrl, &c);
 	control->value = c.value;
 	return ret;
 }
@@ -3449,7 +3463,7 @@ EXPORT_SYMBOL(v4l2_s_ctrl);
 
 int v4l2_subdev_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *control)
 {
-	return v4l2_s_ctrl(NULL, sd->ctrl_handler, control);
+	return v4l2_s_ctrl(NULL, sd->ctrl_handler, 0, control);
 }
 EXPORT_SYMBOL(v4l2_subdev_s_ctrl);
 
@@ -3460,7 +3474,7 @@ int __v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 	/* It's a driver bug if this happens. */
 	WARN_ON(!ctrl->is_int);
 	ctrl->val = val;
-	return set_ctrl(NULL, ctrl, 0);
+	return set_ctrl(NULL, 0, ctrl, 0);
 }
 EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl);
 
@@ -3471,7 +3485,7 @@ int __v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
 	/* It's a driver bug if this happens. */
 	WARN_ON(ctrl->is_ptr || ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
 	*ctrl->p_new.p_s64 = val;
-	return set_ctrl(NULL, ctrl, 0);
+	return set_ctrl(NULL, 0, ctrl, 0);
 }
 EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_int64);
 
@@ -3482,7 +3496,7 @@ int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
 	/* It's a driver bug if this happens. */
 	WARN_ON(ctrl->type != V4L2_CTRL_TYPE_STRING);
 	strlcpy(ctrl->p_new.p_char, s, ctrl->maximum + 1);
-	return set_ctrl(NULL, ctrl, 0);
+	return set_ctrl(NULL, 0, ctrl, 0);
 }
 EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_string);
 
@@ -3668,7 +3682,7 @@ int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 	else
 		changed = *ctrl->p_new.p_s32 != *ctrl->p_cur.p_s32;
 	if (changed)
-		ret = set_ctrl(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
+		ret = set_ctrl(NULL, 0, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
 	else
 		send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
 	return ret;
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 71a1b93..ff206f1 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -558,6 +558,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	SET_VALID_IOCTL(ops, VIDIOC_G_FREQUENCY, vidioc_g_frequency);
 	SET_VALID_IOCTL(ops, VIDIOC_S_FREQUENCY, vidioc_s_frequency);
 	SET_VALID_IOCTL(ops, VIDIOC_LOG_STATUS, vidioc_log_status);
+	set_bit(_IOC_NR(VIDIOC_REQUEST_CMD), valid_ioctls);
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	set_bit(_IOC_NR(VIDIOC_DBG_G_CHIP_INFO), valid_ioctls);
 	set_bit(_IOC_NR(VIDIOC_DBG_G_REGISTER), valid_ioctls);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index a16af7f..51830c2 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -653,6 +653,14 @@ static void v4l_print_decoder_cmd(const void *arg, bool write_only)
 		pr_info("pts=%llu\n", p->stop.pts);
 }
 
+static void v4l_print_request_cmd(const void *arg, bool write_only)
+{
+	const struct v4l2_request_cmd *p = arg;
+
+	pr_cont("cmd=%u, request=%u, flags=0x%x\n",
+			p->cmd, p->request, p->flags);
+}
+
 static void v4l_print_dbg_chip_info(const void *arg, bool write_only)
 {
 	const struct v4l2_dbg_chip_info *p = arg;
@@ -1681,9 +1689,9 @@ static int v4l_queryctrl(const struct v4l2_ioctl_ops *ops,
 		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 
 	if (vfh && vfh->ctrl_handler)
-		return v4l2_queryctrl(vfh->ctrl_handler, p);
+		return v4l2_queryctrl(vfh->ctrl_handler, vfh->request, p);
 	if (vfd->ctrl_handler)
-		return v4l2_queryctrl(vfd->ctrl_handler, p);
+		return v4l2_queryctrl(vfd->ctrl_handler, 0, p);
 	if (ops->vidioc_queryctrl)
 		return ops->vidioc_queryctrl(file, fh, p);
 	return -ENOTTY;
@@ -1697,8 +1705,11 @@ static int v4l_query_ext_ctrl(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_fh *vfh =
 		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 
-	if (vfh && vfh->ctrl_handler)
+	if (vfh && vfh->ctrl_handler) {
+		if (vfh->request && p->request == 0)
+			p->request = vfh->request;
 		return v4l2_query_ext_ctrl(vfh->ctrl_handler, p);
+	}
 	if (vfd->ctrl_handler)
 		return v4l2_query_ext_ctrl(vfd->ctrl_handler, p);
 	if (p->request)
@@ -1736,9 +1747,9 @@ static int v4l_g_ctrl(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_ext_control ctrl;
 
 	if (vfh && vfh->ctrl_handler)
-		return v4l2_g_ctrl(vfh->ctrl_handler, p);
+		return v4l2_g_ctrl(vfh->ctrl_handler, vfh->request, p);
 	if (vfd->ctrl_handler)
-		return v4l2_g_ctrl(vfd->ctrl_handler, p);
+		return v4l2_g_ctrl(vfd->ctrl_handler, 0, p);
 	if (ops->vidioc_g_ctrl)
 		return ops->vidioc_g_ctrl(file, fh, p);
 	if (ops->vidioc_g_ext_ctrls == NULL)
@@ -1770,9 +1781,9 @@ static int v4l_s_ctrl(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_ext_control ctrl;
 
 	if (vfh && vfh->ctrl_handler)
-		return v4l2_s_ctrl(vfh, vfh->ctrl_handler, p);
+		return v4l2_s_ctrl(vfh, vfh->ctrl_handler, vfh->request, p);
 	if (vfd->ctrl_handler)
-		return v4l2_s_ctrl(NULL, vfd->ctrl_handler, p);
+		return v4l2_s_ctrl(NULL, vfd->ctrl_handler, 0, p);
 	if (ops->vidioc_s_ctrl)
 		return ops->vidioc_s_ctrl(file, fh, p);
 	if (ops->vidioc_s_ext_ctrls == NULL)
@@ -1797,8 +1808,11 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 
 	p->error_idx = p->count;
-	if (vfh && vfh->ctrl_handler)
+	if (vfh && vfh->ctrl_handler) {
+		if (vfh->request && p->request == 0)
+			p->request = vfh->request;
 		return v4l2_g_ext_ctrls(vfh->ctrl_handler, p);
+	}
 	if (vfd->ctrl_handler)
 		return v4l2_g_ext_ctrls(vfd->ctrl_handler, p);
 	if (ops->vidioc_g_ext_ctrls == NULL)
@@ -1818,8 +1832,11 @@ static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 
 	p->error_idx = p->count;
-	if (vfh && vfh->ctrl_handler)
+	if (vfh && vfh->ctrl_handler) {
+		if (vfh->request && p->request == 0)
+			p->request = vfh->request;
 		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, p);
+	}
 	if (vfd->ctrl_handler)
 		return v4l2_s_ext_ctrls(NULL, vfd->ctrl_handler, p);
 	if (ops->vidioc_s_ext_ctrls == NULL)
@@ -1839,8 +1856,11 @@ static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 
 	p->error_idx = p->count;
-	if (vfh && vfh->ctrl_handler)
+	if (vfh && vfh->ctrl_handler) {
+		if (vfh->request && p->request == 0)
+			p->request = vfh->request;
 		return v4l2_try_ext_ctrls(vfh->ctrl_handler, p);
+	}
 	if (vfd->ctrl_handler)
 		return v4l2_try_ext_ctrls(vfd->ctrl_handler, p);
 	if (ops->vidioc_try_ext_ctrls == NULL)
@@ -1942,6 +1962,46 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 	return 0;
 }
 
+static int v4l_request_cmd(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_request_cmd *p = arg;
+	struct video_device *vfd;
+	struct v4l2_fh *vfh;
+	int ret;
+
+	vfd = video_devdata(file);
+	if (!test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags))
+		return -ENOTTY;
+	vfh = file->private_data;
+	if (vfh->ctrl_handler == NULL)
+		return -ENOTTY;
+	ret = v4l2_prio_check(vfd->prio, vfh->prio);
+	if (ret)
+		return ret;
+	if (p->request > USHRT_MAX)
+		return -EINVAL;
+	switch (p->cmd) {
+	case V4L2_REQ_CMD_BEGIN:
+		if (vfh->request)
+			return -EBUSY;
+		if (p->request == 0)
+			return -EINVAL;
+		vfh->request = p->request;
+		break;
+	case V4L2_REQ_CMD_END:
+		vfh->request = 0;
+		break;
+	case V4L2_REQ_CMD_DELETE:
+		return v4l2_ctrl_delete_request(vfh->ctrl_handler, p->request);
+	case V4L2_REQ_CMD_APPLY:
+		return v4l2_ctrl_apply_request(vfh->ctrl_handler, p->request);
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int v4l_log_status(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -2282,6 +2342,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_ENUM_FREQ_BANDS, v4l_enum_freq_bands, v4l_print_freq_band, 0),
 	IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_INFO, v4l_dbg_g_chip_info, v4l_print_dbg_chip_info, INFO_FL_CLEAR(v4l2_dbg_chip_info, match)),
 	IOCTL_INFO_FNC(VIDIOC_QUERY_EXT_CTRL, v4l_query_ext_ctrl, v4l_print_query_ext_ctrl, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_query_ext_ctrl, id)),
+	IOCTL_INFO_FNC(VIDIOC_REQUEST_CMD, v4l_request_cmd, v4l_print_request_cmd, 0),
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 6359606..cabbddc 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -188,28 +188,48 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	switch (cmd) {
 	case VIDIOC_QUERYCTRL:
-		return v4l2_queryctrl(vfh->ctrl_handler, arg);
+		return v4l2_queryctrl(vfh->ctrl_handler, vfh->request, arg);
 
-	case VIDIOC_QUERY_EXT_CTRL:
+	case VIDIOC_QUERY_EXT_CTRL: {
+		struct v4l2_query_ext_ctrl *p = arg;
+
+		if (vfh->request && p->request == 0)
+			p->request = vfh->request;
 		return v4l2_query_ext_ctrl(vfh->ctrl_handler, arg);
+	}
 
 	case VIDIOC_QUERYMENU:
 		return v4l2_querymenu(vfh->ctrl_handler, arg);
 
 	case VIDIOC_G_CTRL:
-		return v4l2_g_ctrl(vfh->ctrl_handler, arg);
+		return v4l2_g_ctrl(vfh->ctrl_handler, vfh->request, arg);
 
 	case VIDIOC_S_CTRL:
-		return v4l2_s_ctrl(vfh, vfh->ctrl_handler, arg);
+		return v4l2_s_ctrl(vfh, vfh->ctrl_handler, vfh->request, arg);
 
-	case VIDIOC_G_EXT_CTRLS:
+	case VIDIOC_G_EXT_CTRLS: {
+		struct v4l2_ext_controls *p = arg;
+
+		if (vfh->request && p->request == 0)
+			p->request = vfh->request;
 		return v4l2_g_ext_ctrls(vfh->ctrl_handler, arg);
+	}
 
-	case VIDIOC_S_EXT_CTRLS:
+	case VIDIOC_S_EXT_CTRLS: {
+		struct v4l2_ext_controls *p = arg;
+
+		if (vfh->request && p->request == 0)
+			p->request = vfh->request;
 		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, arg);
+	}
 
-	case VIDIOC_TRY_EXT_CTRLS:
+	case VIDIOC_TRY_EXT_CTRLS: {
+		struct v4l2_ext_controls *p = arg;
+
+		if (vfh->request && p->request == 0)
+			p->request = vfh->request;
 		return v4l2_try_ext_ctrls(vfh->ctrl_handler, arg);
+	}
 
 	case VIDIOC_DQEVENT:
 		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS))
@@ -223,6 +243,35 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_UNSUBSCRIBE_EVENT:
 		return v4l2_subdev_call(sd, core, unsubscribe_event, vfh, arg);
 
+	case VIDIOC_REQUEST_CMD: {
+		struct v4l2_request_cmd *p = arg;
+
+		if (p->request > USHRT_MAX)
+			return -EINVAL;
+
+		switch (p->cmd) {
+		case V4L2_REQ_CMD_BEGIN:
+			if (vfh->request)
+				return -EBUSY;
+			if (p->request == 0)
+				return -EINVAL;
+			vfh->request = p->request;
+			break;
+		case V4L2_REQ_CMD_END:
+			vfh->request = 0;
+			break;
+		case V4L2_REQ_CMD_DELETE:
+			return v4l2_ctrl_delete_request(vfh->ctrl_handler,
+							p->request);
+		case V4L2_REQ_CMD_APPLY:
+			return v4l2_ctrl_apply_request(vfh->ctrl_handler,
+						       p->request);
+		default:
+			return -EINVAL;
+		}
+		return 0;
+	}
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	case VIDIOC_DBG_G_REGISTER:
 	{
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 324db6d..efba887 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -830,12 +830,14 @@ int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
 unsigned int v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait);
 
 /* Helpers for ioctl_ops. If hdl == NULL then they will all return -EINVAL. */
-int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc);
+int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl,
+		   unsigned request, struct v4l2_queryctrl *qc);
 int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctrl *qc);
 int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm);
-int v4l2_g_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *ctrl);
+int v4l2_g_ctrl(struct v4l2_ctrl_handler *hdl,
+		unsigned request, struct v4l2_control *ctrl);
 int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
-						struct v4l2_control *ctrl);
+		unsigned request, struct v4l2_control *ctrl);
 int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
 int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
 int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 8035167..652202f 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -45,6 +45,7 @@ struct v4l2_fh {
 	struct list_head	available; /* Dequeueable event */
 	unsigned int		navailable;
 	u32			sequence;
+	u16			request;
 
 #if IS_ENABLED(CONFIG_V4L2_MEM2MEM_DEV)
 	struct v4l2_m2m_ctx	*m2m_ctx;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 7f2b548..98a7717 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -2085,6 +2085,21 @@ struct v4l2_create_buffers {
 	__u32			reserved[8];
 };
 
+#define V4L2_REQ_CMD_BEGIN	(0)
+#define V4L2_REQ_CMD_END	(1)
+#define V4L2_REQ_CMD_DELETE	(2)
+#define V4L2_REQ_CMD_APPLY	(3)
+
+struct v4l2_request_cmd {
+	__u32 cmd;
+	__u16 request;
+	__u16 flags;
+	union {
+		struct {
+			__u32 data[8];
+		} raw;
+	};
+};
 /*
  *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
  *
@@ -2197,8 +2212,10 @@ struct v4l2_create_buffers {
 
 #define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
 
+#define VIDIOC_REQUEST_CMD      _IOWR('V', 104, struct v4l2_request_cmd)
+
 /* Reminder: when adding new ioctls please add support for them to
-   drivers/media/video/v4l2-compat-ioctl32.c as well! */
+   drivers/media/v4l2-core/v4l2-compat-ioctl32.c as well! */
 
 #define BASE_VIDIOC_PRIVATE	192		/* 192-255 are private */
 
-- 
2.1.4

