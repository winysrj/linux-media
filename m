Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2334 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788Ab2FVMVq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 08:21:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 17/34] v4l2-ioctl.c: use the new table for the remaining ioctls.
Date: Fri, 22 Jun 2012 14:21:11 +0200
Message-Id: <014dfacd801659187e4eadf8d2f3b6a8c9b9ac67.1340366355.git.hans.verkuil@cisco.com>
In-Reply-To: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
References: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |  278 +++++++++++++++++++++-----------------
 1 file changed, 154 insertions(+), 124 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index ea5f8fd..2ec1755 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -726,6 +726,125 @@ static void v4l_print_dv_timings_cap(const void *arg, bool write_only)
 	}
 }
 
+static void v4l_print_frmsizeenum(const void *arg, bool write_only)
+{
+	const struct v4l2_frmsizeenum *p = arg;
+
+	pr_cont("index=%u, pixelformat=%c%c%c%c, type=%u",
+			p->index,
+			(p->pixel_format & 0xff),
+			(p->pixel_format >>  8) & 0xff,
+			(p->pixel_format >> 16) & 0xff,
+			(p->pixel_format >> 24) & 0xff,
+			p->type);
+	switch (p->type) {
+	case V4L2_FRMSIZE_TYPE_DISCRETE:
+		pr_cont(" wxh=%ux%u\n",
+			p->discrete.width, p->discrete.height);
+		break;
+	case V4L2_FRMSIZE_TYPE_STEPWISE:
+		pr_cont(" min=%ux%u, max=%ux%u, step=%ux%u\n",
+				p->stepwise.min_width,  p->stepwise.min_height,
+				p->stepwise.step_width, p->stepwise.step_height,
+				p->stepwise.max_width,  p->stepwise.max_height);
+		break;
+	case V4L2_FRMSIZE_TYPE_CONTINUOUS:
+		/* fall through */
+	default:
+		pr_cont("\n");
+		break;
+	}
+}
+
+static void v4l_print_frmivalenum(const void *arg, bool write_only)
+{
+	const struct v4l2_frmivalenum *p = arg;
+
+	pr_cont("index=%u, pixelformat=%c%c%c%c, wxh=%ux%u, type=%u",
+			p->index,
+			(p->pixel_format & 0xff),
+			(p->pixel_format >>  8) & 0xff,
+			(p->pixel_format >> 16) & 0xff,
+			(p->pixel_format >> 24) & 0xff,
+			p->width, p->height, p->type);
+	switch (p->type) {
+	case V4L2_FRMIVAL_TYPE_DISCRETE:
+		pr_cont(" fps=%d/%d\n",
+				p->discrete.numerator,
+				p->discrete.denominator);
+		break;
+	case V4L2_FRMIVAL_TYPE_STEPWISE:
+		pr_cont(" min=%d/%d, max=%d/%d, step=%d/%d\n",
+				p->stepwise.min.numerator,
+				p->stepwise.min.denominator,
+				p->stepwise.max.numerator,
+				p->stepwise.max.denominator,
+				p->stepwise.step.numerator,
+				p->stepwise.step.denominator);
+		break;
+	case V4L2_FRMIVAL_TYPE_CONTINUOUS:
+		/* fall through */
+	default:
+		pr_cont("\n");
+		break;
+	}
+}
+
+static void v4l_print_event(const void *arg, bool write_only)
+{
+	const struct v4l2_event *p = arg;
+	const struct v4l2_event_ctrl *c;
+
+	pr_cont("type=0x%x, pending=%u, sequence=%u, id=%u, "
+		"timestamp=%lu.%9.9lu\n",
+			p->type, p->pending, p->sequence, p->id,
+			p->timestamp.tv_sec, p->timestamp.tv_nsec);
+	switch (p->type) {
+	case V4L2_EVENT_VSYNC:
+		printk(KERN_DEBUG "field=%s\n",
+			prt_names(p->u.vsync.field, v4l2_field_names));
+		break;
+	case V4L2_EVENT_CTRL:
+		c = &p->u.ctrl;
+		printk(KERN_DEBUG "changes=0x%x, type=%u, ",
+			c->changes, c->type);
+		if (c->type == V4L2_CTRL_TYPE_INTEGER64)
+			pr_cont("value64=%lld, ", c->value64);
+		else
+			pr_cont("value=%d, ", c->value);
+		pr_cont("flags=0x%x, minimum=%d, maximum=%d, step=%d,"
+				" default_value=%d\n",
+			c->flags, c->minimum, c->maximum,
+			c->step, c->default_value);
+		break;
+	case V4L2_EVENT_FRAME_SYNC:
+		pr_cont("frame_sequence=%u\n",
+			p->u.frame_sync.frame_sequence);
+		break;
+	}
+}
+
+static void v4l_print_event_subscription(const void *arg, bool write_only)
+{
+	const struct v4l2_event_subscription *p = arg;
+
+	pr_cont("type=0x%x, id=0x%x, flags=0x%x\n",
+			p->type, p->id, p->flags);
+}
+
+static void v4l_print_sliced_vbi_cap(const void *arg, bool write_only)
+{
+	const struct v4l2_sliced_vbi_cap *p = arg;
+	int i;
+
+	pr_cont("type=%s, service_set=0x%08x\n",
+			prt_names(p->type, v4l2_type_names), p->service_set);
+	for (i = 0; i < 24; i++)
+		printk(KERN_DEBUG "line[%02u]=0x%04x, 0x%04x\n", i,
+				p->service_lines[0][i],
+				p->service_lines[1][i]);
+}
+
 static void v4l_print_u32(const void *arg, bool write_only)
 {
 	pr_cont("value=%u\n", *(const u32 *)arg);
@@ -1664,6 +1783,35 @@ static int v4l_dbg_g_chip_ident(const struct v4l2_ioctl_ops *ops,
 	return ops->vidioc_g_chip_ident(file, fh, p);
 }
 
+static int v4l_dqevent(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	return v4l2_event_dequeue(fh, arg, file->f_flags & O_NONBLOCK);
+}
+
+static int v4l_subscribe_event(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	return ops->vidioc_subscribe_event(fh, arg);
+}
+
+static int v4l_unsubscribe_event(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	return ops->vidioc_unsubscribe_event(fh, arg);
+}
+
+static int v4l_g_sliced_vbi_cap(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_sliced_vbi_cap *p = arg;
+
+	/* Clear up to type, everything after type is zeroed already */
+	memset(p, 0, offsetof(struct v4l2_sliced_vbi_cap, type));
+
+	return ops->vidioc_g_sliced_vbi_cap(file, fh, p);
+}
+
 struct v4l2_ioctl_info {
 	unsigned int ioctl;
 	u32 flags;
@@ -1766,13 +1914,13 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_STD(VIDIOC_ENUMAUDOUT, vidioc_enumaudout, v4l_print_audioout, INFO_FL_CLEAR(v4l2_audioout, index)),
 	IOCTL_INFO_FNC(VIDIOC_G_PRIORITY, v4l_g_priority, v4l_print_u32, 0),
 	IOCTL_INFO_FNC(VIDIOC_S_PRIORITY, v4l_s_priority, v4l_print_u32, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_SLICED_VBI_CAP, INFO_FL_CLEAR(v4l2_sliced_vbi_cap, type)),
+	IOCTL_INFO_FNC(VIDIOC_G_SLICED_VBI_CAP, v4l_g_sliced_vbi_cap, v4l_print_sliced_vbi_cap, INFO_FL_CLEAR(v4l2_sliced_vbi_cap, type)),
 	IOCTL_INFO_FNC(VIDIOC_LOG_STATUS, v4l_log_status, v4l_print_newline, 0),
 	IOCTL_INFO_FNC(VIDIOC_G_EXT_CTRLS, v4l_g_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
 	IOCTL_INFO_FNC(VIDIOC_S_EXT_CTRLS, v4l_s_ext_ctrls, v4l_print_ext_controls, INFO_FL_PRIO | INFO_FL_CTRL),
 	IOCTL_INFO_FNC(VIDIOC_TRY_EXT_CTRLS, v4l_try_ext_ctrls, v4l_print_ext_controls, 0),
-	IOCTL_INFO(VIDIOC_ENUM_FRAMESIZES, INFO_FL_CLEAR(v4l2_frmsizeenum, pixel_format)),
-	IOCTL_INFO(VIDIOC_ENUM_FRAMEINTERVALS, INFO_FL_CLEAR(v4l2_frmivalenum, height)),
+	IOCTL_INFO_STD(VIDIOC_ENUM_FRAMESIZES, vidioc_enum_framesizes, v4l_print_frmsizeenum, INFO_FL_CLEAR(v4l2_frmsizeenum, pixel_format)),
+	IOCTL_INFO_STD(VIDIOC_ENUM_FRAMEINTERVALS, vidioc_enum_frameintervals, v4l_print_frmivalenum, INFO_FL_CLEAR(v4l2_frmivalenum, height)),
 	IOCTL_INFO_STD(VIDIOC_G_ENC_INDEX, vidioc_g_enc_index, v4l_print_enc_idx, 0),
 	IOCTL_INFO_STD(VIDIOC_ENCODER_CMD, vidioc_encoder_cmd, v4l_print_encoder_cmd, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
 	IOCTL_INFO_STD(VIDIOC_TRY_ENCODER_CMD, vidioc_try_encoder_cmd, v4l_print_encoder_cmd, INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
@@ -1788,9 +1936,9 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_STD(VIDIOC_QUERY_DV_PRESET, vidioc_query_dv_preset, v4l_print_dv_preset, 0),
 	IOCTL_INFO_STD(VIDIOC_S_DV_TIMINGS, vidioc_s_dv_timings, v4l_print_dv_timings, INFO_FL_PRIO),
 	IOCTL_INFO_STD(VIDIOC_G_DV_TIMINGS, vidioc_g_dv_timings, v4l_print_dv_timings, 0),
-	IOCTL_INFO(VIDIOC_DQEVENT, 0),
-	IOCTL_INFO(VIDIOC_SUBSCRIBE_EVENT, 0),
-	IOCTL_INFO(VIDIOC_UNSUBSCRIBE_EVENT, 0),
+	IOCTL_INFO_FNC(VIDIOC_DQEVENT, v4l_dqevent, v4l_print_event, 0),
+	IOCTL_INFO_FNC(VIDIOC_SUBSCRIBE_EVENT, v4l_subscribe_event, v4l_print_event_subscription, 0),
+	IOCTL_INFO_FNC(VIDIOC_UNSUBSCRIBE_EVENT, v4l_unsubscribe_event, v4l_print_event_subscription, 0),
 	IOCTL_INFO_FNC(VIDIOC_CREATE_BUFS, v4l_create_bufs, v4l_print_create_buffers, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_PREPARE_BUF, v4l_prepare_buf, v4l_print_buffer, 0),
 	IOCTL_INFO_STD(VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings, v4l_print_enum_dv_timings, 0),
@@ -1902,124 +2050,6 @@ static long __video_do_ioctl(struct file *file,
 	}
 
 	switch (cmd) {
-	case VIDIOC_G_SLICED_VBI_CAP:
-	{
-		struct v4l2_sliced_vbi_cap *p = arg;
-
-		/* Clear up to type, everything after type is zerod already */
-		memset(p, 0, offsetof(struct v4l2_sliced_vbi_cap, type));
-
-		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
-		ret = ops->vidioc_g_sliced_vbi_cap(file, fh, p);
-		if (!ret)
-			dbgarg2("service_set=%d\n", p->service_set);
-		break;
-	}
-	case VIDIOC_ENUM_FRAMESIZES:
-	{
-		struct v4l2_frmsizeenum *p = arg;
-
-		ret = ops->vidioc_enum_framesizes(file, fh, p);
-		dbgarg(cmd,
-			"index=%d, pixelformat=%c%c%c%c, type=%d ",
-			p->index,
-			(p->pixel_format & 0xff),
-			(p->pixel_format >>  8) & 0xff,
-			(p->pixel_format >> 16) & 0xff,
-			(p->pixel_format >> 24) & 0xff,
-			p->type);
-		switch (p->type) {
-		case V4L2_FRMSIZE_TYPE_DISCRETE:
-			dbgarg3("width = %d, height=%d\n",
-				p->discrete.width, p->discrete.height);
-			break;
-		case V4L2_FRMSIZE_TYPE_STEPWISE:
-			dbgarg3("min %dx%d, max %dx%d, step %dx%d\n",
-				p->stepwise.min_width,  p->stepwise.min_height,
-				p->stepwise.step_width, p->stepwise.step_height,
-				p->stepwise.max_width,  p->stepwise.max_height);
-			break;
-		case V4L2_FRMSIZE_TYPE_CONTINUOUS:
-			dbgarg3("continuous\n");
-			break;
-		default:
-			dbgarg3("- Unknown type!\n");
-		}
-
-		break;
-	}
-	case VIDIOC_ENUM_FRAMEINTERVALS:
-	{
-		struct v4l2_frmivalenum *p = arg;
-
-		ret = ops->vidioc_enum_frameintervals(file, fh, p);
-		dbgarg(cmd,
-			"index=%d, pixelformat=%d, width=%d, height=%d, type=%d ",
-			p->index, p->pixel_format,
-			p->width, p->height, p->type);
-		switch (p->type) {
-		case V4L2_FRMIVAL_TYPE_DISCRETE:
-			dbgarg2("fps=%d/%d\n",
-				p->discrete.numerator,
-				p->discrete.denominator);
-			break;
-		case V4L2_FRMIVAL_TYPE_STEPWISE:
-			dbgarg2("min=%d/%d, max=%d/%d, step=%d/%d\n",
-				p->stepwise.min.numerator,
-				p->stepwise.min.denominator,
-				p->stepwise.max.numerator,
-				p->stepwise.max.denominator,
-				p->stepwise.step.numerator,
-				p->stepwise.step.denominator);
-			break;
-		case V4L2_FRMIVAL_TYPE_CONTINUOUS:
-			dbgarg2("continuous\n");
-			break;
-		default:
-			dbgarg2("- Unknown type!\n");
-		}
-		break;
-	}
-	case VIDIOC_DQEVENT:
-	{
-		struct v4l2_event *ev = arg;
-
-		ret = v4l2_event_dequeue(fh, ev, file->f_flags & O_NONBLOCK);
-		if (ret < 0) {
-			dbgarg(cmd, "no pending events?");
-			break;
-		}
-		dbgarg(cmd,
-		       "pending=%d, type=0x%8.8x, sequence=%d, "
-		       "timestamp=%lu.%9.9lu ",
-		       ev->pending, ev->type, ev->sequence,
-		       ev->timestamp.tv_sec, ev->timestamp.tv_nsec);
-		break;
-	}
-	case VIDIOC_SUBSCRIBE_EVENT:
-	{
-		struct v4l2_event_subscription *sub = arg;
-
-		ret = ops->vidioc_subscribe_event(fh, sub);
-		if (ret < 0) {
-			dbgarg(cmd, "failed, ret=%ld", ret);
-			break;
-		}
-		dbgarg(cmd, "type=0x%8.8x", sub->type);
-		break;
-	}
-	case VIDIOC_UNSUBSCRIBE_EVENT:
-	{
-		struct v4l2_event_subscription *sub = arg;
-
-		ret = ops->vidioc_unsubscribe_event(fh, sub);
-		if (ret < 0) {
-			dbgarg(cmd, "failed, ret=%ld", ret);
-			break;
-		}
-		dbgarg(cmd, "type=0x%8.8x", sub->type);
-		break;
-	}
 	default:
 		if (!ops->vidioc_default)
 			break;
-- 
1.7.10

