Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2198 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab2FJK0U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:26:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 12/32] v4l2-ioctl.c: use the new table for control ioctls.
Date: Sun, 10 Jun 2012 12:25:34 +0200
Message-Id: <f3b93b3758c43848c1e93fbfde5e330121e66bd5.1339321562.git.hans.verkuil@cisco.com>
In-Reply-To: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
References: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |  395 +++++++++++++++++++-------------------
 1 file changed, 198 insertions(+), 197 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 1f7982a..4fb113b 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -527,6 +527,49 @@ static void v4l_print_streamparm(const void *arg)
 	}
 }
 
+static void v4l_print_queryctrl(const void *arg)
+{
+	const struct v4l2_queryctrl *p = arg;
+
+	pr_cont("id=0x%x, type=%d, name=%s, min/max=%d/%d, "
+		"step=%d, default=%d, flags=0x%08x\n",
+			p->id, p->type, p->name,
+			p->minimum, p->maximum,
+			p->step, p->default_value, p->flags);
+}
+
+static void v4l_print_querymenu(const void *arg)
+{
+	const struct v4l2_querymenu *p = arg;
+
+	pr_cont("id=0x%x, index=%d\n", p->id, p->index);
+}
+
+static void v4l_print_control(const void *arg)
+{
+	const struct v4l2_control *p = arg;
+
+	pr_cont("id=0x%x, value=%d\n", p->id, p->value);
+}
+
+static void v4l_print_ext_controls(const void *arg)
+{
+	const struct v4l2_ext_controls *p = arg;
+	int i;
+
+	pr_cont("class=0x%x, count=%d, error_idx=%d",
+			p->ctrl_class, p->count, p->error_idx);
+	for (i = 0; i < p->count; i++) {
+		if (p->controls[i].size)
+			pr_cont(", id/val=0x%x/0x%x",
+				p->controls[i].id, p->controls[i].value);
+		else
+			pr_cont(", id/size=0x%x/%u",
+				p->controls[i].id, p->controls[i].size);
+	}
+	pr_cont("\n");
+}
+
 static void v4l_print_u32(const void *arg)
 {
 	pr_cont("value=%u\n", *(const u32 *)arg);
@@ -567,27 +610,7 @@ static void dbgtimings(struct video_device *vfd,
 	}
 }
 
-static inline void v4l_print_ext_ctrls(unsigned int cmd,
-	struct video_device *vfd, struct v4l2_ext_controls *c, int show_vals)
-{
-	__u32 i;
-
-	if (!(vfd->debug & V4L2_DEBUG_IOCTL_ARG))
-		return;
-	dbgarg(cmd, "");
-	printk(KERN_CONT "class=0x%x", c->ctrl_class);
-	for (i = 0; i < c->count; i++) {
-		if (show_vals && !c->controls[i].size)
-			printk(KERN_CONT " id/val=0x%x/0x%x",
-				c->controls[i].id, c->controls[i].value);
-		else
-			printk(KERN_CONT " id=0x%x,size=%u",
-				c->controls[i].id, c->controls[i].size);
-	}
-	printk(KERN_CONT "\n");
-};
-
-static inline int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
+static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
 {
 	__u32 i;
 
@@ -1227,6 +1250,153 @@ static int v4l_s_parm(const struct v4l2_ioctl_ops *ops,
 	return ret ? ret : ops->vidioc_s_parm(file, fh, p);
 }
 
+static int v4l_queryctrl(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_queryctrl *p = arg;
+	struct v4l2_fh *vfh = fh;
+
+	if (vfh && vfh->ctrl_handler)
+		return v4l2_queryctrl(vfh->ctrl_handler, p);
+	if (vfd->ctrl_handler)
+		return v4l2_queryctrl(vfd->ctrl_handler, p);
+	if (ops->vidioc_queryctrl)
+		return ops->vidioc_queryctrl(file, fh, p);
+	return -ENOTTY;
+}
+
+static int v4l_querymenu(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_querymenu *p = arg;
+	struct v4l2_fh *vfh = fh;
+
+	if (vfh && vfh->ctrl_handler)
+		return v4l2_querymenu(vfh->ctrl_handler, p);
+	if (vfd->ctrl_handler)
+		return v4l2_querymenu(vfd->ctrl_handler, p);
+	if (ops->vidioc_querymenu)
+		return ops->vidioc_querymenu(file, fh, p);
+	return -ENOTTY;
+}
+
+static int v4l_g_ctrl(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_control *p = arg;
+	struct v4l2_fh *vfh = fh;
+	struct v4l2_ext_controls ctrls;
+	struct v4l2_ext_control ctrl;
+
+	if (vfh && vfh->ctrl_handler)
+		return v4l2_g_ctrl(vfh->ctrl_handler, p);
+	if (vfd->ctrl_handler)
+		return v4l2_g_ctrl(vfd->ctrl_handler, p);
+	if (ops->vidioc_g_ctrl)
+		return ops->vidioc_g_ctrl(file, fh, p);
+	if (ops->vidioc_g_ext_ctrls == NULL)
+		return -ENOTTY;
+
+	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(p->id);
+	ctrls.count = 1;
+	ctrls.controls = &ctrl;
+	ctrl.id = p->id;
+	ctrl.value = p->value;
+	if (check_ext_ctrls(&ctrls, 1)) {
+		int ret = ops->vidioc_g_ext_ctrls(file, fh, &ctrls);
+
+		if (ret == 0)
+			p->value = ctrl.value;
+		return ret;
+	}
+	return -EINVAL;
+}
+
+static int v4l_s_ctrl(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_control *p = arg;
+	struct v4l2_fh *vfh = fh;
+	struct v4l2_ext_controls ctrls;
+	struct v4l2_ext_control ctrl;
+
+	if (vfh && vfh->ctrl_handler)
+		return v4l2_s_ctrl(vfh, vfh->ctrl_handler, p);
+	if (vfd->ctrl_handler)
+		return v4l2_s_ctrl(NULL, vfd->ctrl_handler, p);
+	if (ops->vidioc_s_ctrl)
+		return ops->vidioc_s_ctrl(file, fh, p);
+	if (ops->vidioc_s_ext_ctrls == NULL)
+		return -ENOTTY;
+
+	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(p->id);
+	ctrls.count = 1;
+	ctrls.controls = &ctrl;
+	ctrl.id = p->id;
+	ctrl.value = p->value;
+	if (check_ext_ctrls(&ctrls, 1))
+		return ops->vidioc_s_ext_ctrls(file, fh, &ctrls);
+	return -EINVAL;
+}
+
+static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_ext_controls *p = arg;
+	struct v4l2_fh *vfh = fh;
+
+	p->error_idx = p->count;
+	if (vfh && vfh->ctrl_handler)
+		return v4l2_g_ext_ctrls(vfh->ctrl_handler, p);
+	if (vfd->ctrl_handler)
+		return v4l2_g_ext_ctrls(vfd->ctrl_handler, p);
+	if (ops->vidioc_g_ext_ctrls == NULL)
+		return -ENOTTY;
+	return check_ext_ctrls(p, 0) ? ops->vidioc_g_ext_ctrls(file, fh, p) :
+					-EINVAL;
+}
+
+static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_ext_controls *p = arg;
+	struct v4l2_fh *vfh = fh;
+
+	p->error_idx = p->count;
+	if (vfh && vfh->ctrl_handler)
+		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, p);
+	if (vfd->ctrl_handler)
+		return v4l2_s_ext_ctrls(NULL, vfd->ctrl_handler, p);
+	if (ops->vidioc_s_ext_ctrls == NULL)
+		return -ENOTTY;
+	return check_ext_ctrls(p, 0) ? ops->vidioc_s_ext_ctrls(file, fh, p) :
+					-EINVAL;
+}
+
+static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_ext_controls *p = arg;
+	struct v4l2_fh *vfh = fh;
+
+	p->error_idx = p->count;
+	if (vfh && vfh->ctrl_handler)
+		return v4l2_try_ext_ctrls(vfh->ctrl_handler, p);
+	if (vfd->ctrl_handler)
+		return v4l2_try_ext_ctrls(vfd->ctrl_handler, p);
+	if (ops->vidioc_try_ext_ctrls == NULL)
+		return -ENOTTY;
+	return check_ext_ctrls(p, 0) ? ops->vidioc_try_ext_ctrls(file, fh, p) :
+					-EINVAL;
+}
+
 struct v4l2_ioctl_info {
 	unsigned int ioctl;
 	u32 flags;
@@ -1297,14 +1467,14 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_S_STD, v4l_s_std, v4l_print_std, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_ENUMSTD, v4l_enumstd, v4l_print_standard, INFO_FL_CLEAR(v4l2_standard, index)),
 	IOCTL_INFO_FNC(VIDIOC_ENUMINPUT, v4l_enuminput, v4l_print_enuminput, INFO_FL_CLEAR(v4l2_input, index)),
-	IOCTL_INFO(VIDIOC_G_CTRL, INFO_FL_CTRL),
-	IOCTL_INFO(VIDIOC_S_CTRL, INFO_FL_PRIO | INFO_FL_CTRL),
+	IOCTL_INFO_FNC(VIDIOC_G_CTRL, v4l_g_ctrl, v4l_print_control, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_control, id)),
+	IOCTL_INFO_FNC(VIDIOC_S_CTRL, v4l_s_ctrl, v4l_print_control, INFO_FL_PRIO | INFO_FL_CTRL),
 	IOCTL_INFO_FNC(VIDIOC_G_TUNER, v4l_g_tuner, v4l_print_g_tuner, INFO_FL_CLEAR(v4l2_tuner, index)),
 	IOCTL_INFO_FNC(VIDIOC_S_TUNER, v4l_s_tuner, v4l_print_s_tuner, INFO_FL_PRIO),
 	IOCTL_INFO_STD(VIDIOC_G_AUDIO, vidioc_g_audio, v4l_print_audio, 0),
 	IOCTL_INFO_STD(VIDIOC_S_AUDIO, vidioc_s_audio, v4l_print_s_audio, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_QUERYCTRL, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_queryctrl, id)),
-	IOCTL_INFO(VIDIOC_QUERYMENU, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_querymenu, index)),
+	IOCTL_INFO_FNC(VIDIOC_QUERYCTRL, v4l_queryctrl, v4l_print_queryctrl, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_queryctrl, id)),
+	IOCTL_INFO_FNC(VIDIOC_QUERYMENU, v4l_querymenu, v4l_print_querymenu, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_querymenu, index)),
 	IOCTL_INFO_STD(VIDIOC_G_INPUT, vidioc_g_input, v4l_print_u32, 0),
 	IOCTL_INFO_FNC(VIDIOC_S_INPUT, v4l_s_input, v4l_print_u32, INFO_FL_PRIO),
 	IOCTL_INFO_STD(VIDIOC_G_OUTPUT, vidioc_g_output, v4l_print_u32, 0),
@@ -1331,9 +1501,9 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_S_PRIORITY, v4l_s_priority, v4l_print_u32, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_G_SLICED_VBI_CAP, INFO_FL_CLEAR(v4l2_sliced_vbi_cap, type)),
 	IOCTL_INFO(VIDIOC_LOG_STATUS, 0),
-	IOCTL_INFO(VIDIOC_G_EXT_CTRLS, INFO_FL_CTRL),
-	IOCTL_INFO(VIDIOC_S_EXT_CTRLS, INFO_FL_PRIO | INFO_FL_CTRL),
-	IOCTL_INFO(VIDIOC_TRY_EXT_CTRLS, 0),
+	IOCTL_INFO_FNC(VIDIOC_G_EXT_CTRLS, v4l_g_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
+	IOCTL_INFO_FNC(VIDIOC_S_EXT_CTRLS, v4l_s_ext_ctrls, v4l_print_ext_controls, INFO_FL_PRIO | INFO_FL_CTRL),
+	IOCTL_INFO_FNC(VIDIOC_TRY_EXT_CTRLS, v4l_try_ext_ctrls, v4l_print_ext_controls, 0),
 	IOCTL_INFO(VIDIOC_ENUM_FRAMESIZES, INFO_FL_CLEAR(v4l2_frmsizeenum, pixel_format)),
 	IOCTL_INFO(VIDIOC_ENUM_FRAMEINTERVALS, INFO_FL_CLEAR(v4l2_frmivalenum, height)),
 	IOCTL_INFO(VIDIOC_G_ENC_INDEX, 0),
@@ -1465,175 +1635,6 @@ static long __video_do_ioctl(struct file *file,
 	}
 
 	switch (cmd) {
-	/* --- controls ---------------------------------------------- */
-	case VIDIOC_QUERYCTRL:
-	{
-		struct v4l2_queryctrl *p = arg;
-
-		if (vfh && vfh->ctrl_handler)
-			ret = v4l2_queryctrl(vfh->ctrl_handler, p);
-		else if (vfd->ctrl_handler)
-			ret = v4l2_queryctrl(vfd->ctrl_handler, p);
-		else if (ops->vidioc_queryctrl)
-			ret = ops->vidioc_queryctrl(file, fh, p);
-		else
-			break;
-		if (!ret)
-			dbgarg(cmd, "id=0x%x, type=%d, name=%s, min/max=%d/%d, "
-					"step=%d, default=%d, flags=0x%08x\n",
-					p->id, p->type, p->name,
-					p->minimum, p->maximum,
-					p->step, p->default_value, p->flags);
-		else
-			dbgarg(cmd, "id=0x%x\n", p->id);
-		break;
-	}
-	case VIDIOC_G_CTRL:
-	{
-		struct v4l2_control *p = arg;
-
-		if (vfh && vfh->ctrl_handler)
-			ret = v4l2_g_ctrl(vfh->ctrl_handler, p);
-		else if (vfd->ctrl_handler)
-			ret = v4l2_g_ctrl(vfd->ctrl_handler, p);
-		else if (ops->vidioc_g_ctrl)
-			ret = ops->vidioc_g_ctrl(file, fh, p);
-		else if (ops->vidioc_g_ext_ctrls) {
-			struct v4l2_ext_controls ctrls;
-			struct v4l2_ext_control ctrl;
-
-			ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(p->id);
-			ctrls.count = 1;
-			ctrls.controls = &ctrl;
-			ctrl.id = p->id;
-			ctrl.value = p->value;
-			if (check_ext_ctrls(&ctrls, 1)) {
-				ret = ops->vidioc_g_ext_ctrls(file, fh, &ctrls);
-				if (ret == 0)
-					p->value = ctrl.value;
-			}
-		} else
-			break;
-		if (!ret)
-			dbgarg(cmd, "id=0x%x, value=%d\n", p->id, p->value);
-		else
-			dbgarg(cmd, "id=0x%x\n", p->id);
-		break;
-	}
-	case VIDIOC_S_CTRL:
-	{
-		struct v4l2_control *p = arg;
-		struct v4l2_ext_controls ctrls;
-		struct v4l2_ext_control ctrl;
-
-		if (!(vfh && vfh->ctrl_handler) && !vfd->ctrl_handler &&
-			!ops->vidioc_s_ctrl && !ops->vidioc_s_ext_ctrls)
-			break;
-
-		dbgarg(cmd, "id=0x%x, value=%d\n", p->id, p->value);
-
-		if (vfh && vfh->ctrl_handler) {
-			ret = v4l2_s_ctrl(vfh, vfh->ctrl_handler, p);
-			break;
-		}
-		if (vfd->ctrl_handler) {
-			ret = v4l2_s_ctrl(NULL, vfd->ctrl_handler, p);
-			break;
-		}
-		if (ops->vidioc_s_ctrl) {
-			ret = ops->vidioc_s_ctrl(file, fh, p);
-			break;
-		}
-		if (!ops->vidioc_s_ext_ctrls)
-			break;
-
-		ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(p->id);
-		ctrls.count = 1;
-		ctrls.controls = &ctrl;
-		ctrl.id = p->id;
-		ctrl.value = p->value;
-		if (check_ext_ctrls(&ctrls, 1))
-			ret = ops->vidioc_s_ext_ctrls(file, fh, &ctrls);
-		else
-			ret = -EINVAL;
-		break;
-	}
-	case VIDIOC_G_EXT_CTRLS:
-	{
-		struct v4l2_ext_controls *p = arg;
-
-		p->error_idx = p->count;
-		if (vfh && vfh->ctrl_handler)
-			ret = v4l2_g_ext_ctrls(vfh->ctrl_handler, p);
-		else if (vfd->ctrl_handler)
-			ret = v4l2_g_ext_ctrls(vfd->ctrl_handler, p);
-		else if (ops->vidioc_g_ext_ctrls)
-			ret = check_ext_ctrls(p, 0) ?
-				ops->vidioc_g_ext_ctrls(file, fh, p) :
-				-EINVAL;
-		else
-			break;
-		v4l_print_ext_ctrls(cmd, vfd, p, !ret);
-		break;
-	}
-	case VIDIOC_S_EXT_CTRLS:
-	{
-		struct v4l2_ext_controls *p = arg;
-
-		p->error_idx = p->count;
-		if (!(vfh && vfh->ctrl_handler) && !vfd->ctrl_handler &&
-				!ops->vidioc_s_ext_ctrls)
-			break;
-		v4l_print_ext_ctrls(cmd, vfd, p, 1);
-		if (vfh && vfh->ctrl_handler)
-			ret = v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, p);
-		else if (vfd->ctrl_handler)
-			ret = v4l2_s_ext_ctrls(NULL, vfd->ctrl_handler, p);
-		else if (check_ext_ctrls(p, 0))
-			ret = ops->vidioc_s_ext_ctrls(file, fh, p);
-		else
-			ret = -EINVAL;
-		break;
-	}
-	case VIDIOC_TRY_EXT_CTRLS:
-	{
-		struct v4l2_ext_controls *p = arg;
-
-		p->error_idx = p->count;
-		if (!(vfh && vfh->ctrl_handler) && !vfd->ctrl_handler &&
-				!ops->vidioc_try_ext_ctrls)
-			break;
-		v4l_print_ext_ctrls(cmd, vfd, p, 1);
-		if (vfh && vfh->ctrl_handler)
-			ret = v4l2_try_ext_ctrls(vfh->ctrl_handler, p);
-		else if (vfd->ctrl_handler)
-			ret = v4l2_try_ext_ctrls(vfd->ctrl_handler, p);
-		else if (check_ext_ctrls(p, 0))
-			ret = ops->vidioc_try_ext_ctrls(file, fh, p);
-		else
-			ret = -EINVAL;
-		break;
-	}
-	case VIDIOC_QUERYMENU:
-	{
-		struct v4l2_querymenu *p = arg;
-
-		if (vfh && vfh->ctrl_handler)
-			ret = v4l2_querymenu(vfh->ctrl_handler, p);
-		else if (vfd->ctrl_handler)
-			ret = v4l2_querymenu(vfd->ctrl_handler, p);
-		else if (ops->vidioc_querymenu)
-			ret = ops->vidioc_querymenu(file, fh, p);
-		else
-			break;
-		if (!ret)
-			dbgarg(cmd, "id=0x%x, index=%d, name=%s\n",
-				p->id, p->index, p->name);
-		else
-			dbgarg(cmd, "id=0x%x, index=%d\n",
-				p->id, p->index);
-		break;
-	}
 	case VIDIOC_G_CROP:
 	{
 		struct v4l2_crop *p = arg;
-- 
1.7.10

