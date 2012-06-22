Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2221 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787Ab2FVMVq (ORCPT
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
Subject: [RFCv2 PATCH 16/34] v4l2-ioctl.c: use the new table for preset/timings ioctls.
Date: Fri, 22 Jun 2012 14:21:10 +0200
Message-Id: <2c3f1a2993cd8904d2001b8d40a76eacdb2e3822.1340366355.git.hans.verkuil@cisco.com>
In-Reply-To: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
References: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |  207 ++++++++++++--------------------------
 1 file changed, 67 insertions(+), 140 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index bebd2aa..ea5f8fd 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -655,29 +655,35 @@ static void v4l_print_dbg_register(const void *arg, bool write_only)
 			p->reg, p->val);
 }
 
-static void v4l_print_u32(const void *arg, bool write_only)
+static void v4l_print_dv_enum_presets(const void *arg, bool write_only)
 {
-	pr_cont("value=%u\n", *(const u32 *)arg);
+	const struct v4l2_dv_enum_preset *p = arg;
+
+	pr_cont("index=%u, preset=%u, name=%s, width=%u, height=%u\n",
+			p->index, p->preset, p->name, p->width, p->height);
 }
 
-static void v4l_print_newline(const void *arg, bool write_only)
+static void v4l_print_dv_preset(const void *arg, bool write_only)
 {
-	pr_cont("\n");
+	const struct v4l2_dv_preset *p = arg;
+
+	pr_cont("preset=%u\n", p->preset);
 }
 
-static void dbgtimings(struct video_device *vfd,
-			const struct v4l2_dv_timings *p)
+static void v4l_print_dv_timings(const void *arg, bool write_only)
 {
+	const struct v4l2_dv_timings *p = arg;
+
 	switch (p->type) {
 	case V4L2_DV_BT_656_1120:
-		dbgarg2("bt-656/1120:interlaced=%d,"
-				" pixelclock=%lld,"
-				" width=%d, height=%d, polarities=%x,"
-				" hfrontporch=%d, hsync=%d,"
-				" hbackporch=%d, vfrontporch=%d,"
-				" vsync=%d, vbackporch=%d,"
-				" il_vfrontporch=%d, il_vsync=%d,"
-				" il_vbackporch=%d, standards=%x, flags=%x\n",
+		pr_cont("type=bt-656/1120, interlaced=%u, "
+			"pixelclock=%llu, "
+			"width=%u, height=%u, polarities=0x%x, "
+			"hfrontporch=%u, hsync=%u, "
+			"hbackporch=%u, vfrontporch=%u, "
+			"vsync=%u, vbackporch=%u, "
+			"il_vfrontporch=%u, il_vsync=%u, "
+			"il_vbackporch=%u, standards=0x%x, flags=0x%x\n",
 				p->bt.interlaced, p->bt.pixelclock,
 				p->bt.width, p->bt.height,
 				p->bt.polarities, p->bt.hfrontporch,
@@ -688,11 +694,48 @@ static void dbgtimings(struct video_device *vfd,
 				p->bt.standards, p->bt.flags);
 		break;
 	default:
-		dbgarg2("Unknown type %d!\n", p->type);
+		pr_cont("type=%d\n", p->type);
 		break;
 	}
 }
 
+static void v4l_print_enum_dv_timings(const void *arg, bool write_only)
+{
+	const struct v4l2_enum_dv_timings *p = arg;
+
+	pr_cont("index=%u, ", p->index);
+	v4l_print_dv_timings(&p->timings, write_only);
+}
+
+static void v4l_print_dv_timings_cap(const void *arg, bool write_only)
+{
+	const struct v4l2_dv_timings_cap *p = arg;
+
+	switch (p->type) {
+	case V4L2_DV_BT_656_1120:
+		pr_cont("type=bt-656/1120, width=%u-%u, height=%u-%u, "
+			"pixelclock=%llu-%llu, standards=0x%x, capabilities=0x%x\n",
+			p->bt.min_width, p->bt.max_width,
+			p->bt.min_height, p->bt.max_height,
+			p->bt.min_pixelclock, p->bt.max_pixelclock,
+			p->bt.standards, p->bt.capabilities);
+		break;
+	default:
+		pr_cont("type=%u\n", p->type);
+		break;
+	}
+}
+
+static void v4l_print_u32(const void *arg, bool write_only)
+{
+	pr_cont("value=%u\n", *(const u32 *)arg);
+}
+
+static void v4l_print_newline(const void *arg, bool write_only)
+{
+	pr_cont("\n");
+}
+
 static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
 {
 	__u32 i;
@@ -1739,20 +1782,20 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_DBG_G_REGISTER, v4l_dbg_g_register, v4l_print_dbg_register, 0),
 	IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_IDENT, v4l_dbg_g_chip_ident, v4l_print_dbg_chip_ident, 0),
 	IOCTL_INFO_FNC(VIDIOC_S_HW_FREQ_SEEK, v4l_s_hw_freq_seek, v4l_print_hw_freq_seek, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_ENUM_DV_PRESETS, 0),
-	IOCTL_INFO(VIDIOC_S_DV_PRESET, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_DV_PRESET, 0),
-	IOCTL_INFO(VIDIOC_QUERY_DV_PRESET, 0),
-	IOCTL_INFO(VIDIOC_S_DV_TIMINGS, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_DV_TIMINGS, 0),
+	IOCTL_INFO_STD(VIDIOC_ENUM_DV_PRESETS, vidioc_enum_dv_presets, v4l_print_dv_enum_presets, 0),
+	IOCTL_INFO_STD(VIDIOC_S_DV_PRESET, vidioc_s_dv_preset, v4l_print_dv_preset, INFO_FL_PRIO),
+	IOCTL_INFO_STD(VIDIOC_G_DV_PRESET, vidioc_g_dv_preset, v4l_print_dv_preset, 0),
+	IOCTL_INFO_STD(VIDIOC_QUERY_DV_PRESET, vidioc_query_dv_preset, v4l_print_dv_preset, 0),
+	IOCTL_INFO_STD(VIDIOC_S_DV_TIMINGS, vidioc_s_dv_timings, v4l_print_dv_timings, INFO_FL_PRIO),
+	IOCTL_INFO_STD(VIDIOC_G_DV_TIMINGS, vidioc_g_dv_timings, v4l_print_dv_timings, 0),
 	IOCTL_INFO(VIDIOC_DQEVENT, 0),
 	IOCTL_INFO(VIDIOC_SUBSCRIBE_EVENT, 0),
 	IOCTL_INFO(VIDIOC_UNSUBSCRIBE_EVENT, 0),
 	IOCTL_INFO_FNC(VIDIOC_CREATE_BUFS, v4l_create_bufs, v4l_print_create_buffers, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_PREPARE_BUF, v4l_prepare_buf, v4l_print_buffer, 0),
-	IOCTL_INFO(VIDIOC_ENUM_DV_TIMINGS, 0),
-	IOCTL_INFO(VIDIOC_QUERY_DV_TIMINGS, 0),
-	IOCTL_INFO(VIDIOC_DV_TIMINGS_CAP, 0),
+	IOCTL_INFO_STD(VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings, v4l_print_enum_dv_timings, 0),
+	IOCTL_INFO_STD(VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings, v4l_print_dv_timings, 0),
+	IOCTL_INFO_STD(VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap, v4l_print_dv_timings_cap, 0),
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
@@ -1937,122 +1980,6 @@ static long __video_do_ioctl(struct file *file,
 		}
 		break;
 	}
-	case VIDIOC_ENUM_DV_PRESETS:
-	{
-		struct v4l2_dv_enum_preset *p = arg;
-
-		ret = ops->vidioc_enum_dv_presets(file, fh, p);
-		if (!ret)
-			dbgarg(cmd,
-				"index=%d, preset=%d, name=%s, width=%d,"
-				" height=%d ",
-				p->index, p->preset, p->name, p->width,
-				p->height);
-		break;
-	}
-	case VIDIOC_S_DV_PRESET:
-	{
-		struct v4l2_dv_preset *p = arg;
-
-		dbgarg(cmd, "preset=%d\n", p->preset);
-		ret = ops->vidioc_s_dv_preset(file, fh, p);
-		break;
-	}
-	case VIDIOC_G_DV_PRESET:
-	{
-		struct v4l2_dv_preset *p = arg;
-
-		ret = ops->vidioc_g_dv_preset(file, fh, p);
-		if (!ret)
-			dbgarg(cmd, "preset=%d\n", p->preset);
-		break;
-	}
-	case VIDIOC_QUERY_DV_PRESET:
-	{
-		struct v4l2_dv_preset *p = arg;
-
-		ret = ops->vidioc_query_dv_preset(file, fh, p);
-		if (!ret)
-			dbgarg(cmd, "preset=%d\n", p->preset);
-		break;
-	}
-	case VIDIOC_S_DV_TIMINGS:
-	{
-		struct v4l2_dv_timings *p = arg;
-
-		dbgtimings(vfd, p);
-		switch (p->type) {
-		case V4L2_DV_BT_656_1120:
-			ret = ops->vidioc_s_dv_timings(file, fh, p);
-			break;
-		default:
-			ret = -EINVAL;
-			break;
-		}
-		break;
-	}
-	case VIDIOC_G_DV_TIMINGS:
-	{
-		struct v4l2_dv_timings *p = arg;
-
-		ret = ops->vidioc_g_dv_timings(file, fh, p);
-		if (!ret)
-			dbgtimings(vfd, p);
-		break;
-	}
-	case VIDIOC_ENUM_DV_TIMINGS:
-	{
-		struct v4l2_enum_dv_timings *p = arg;
-
-		if (!ops->vidioc_enum_dv_timings)
-			break;
-
-		ret = ops->vidioc_enum_dv_timings(file, fh, p);
-		if (!ret) {
-			dbgarg(cmd, "index=%d: ", p->index);
-			dbgtimings(vfd, &p->timings);
-		}
-		break;
-	}
-	case VIDIOC_QUERY_DV_TIMINGS:
-	{
-		struct v4l2_dv_timings *p = arg;
-
-		if (!ops->vidioc_query_dv_timings)
-			break;
-
-		ret = ops->vidioc_query_dv_timings(file, fh, p);
-		if (!ret)
-			dbgtimings(vfd, p);
-		break;
-	}
-	case VIDIOC_DV_TIMINGS_CAP:
-	{
-		struct v4l2_dv_timings_cap *p = arg;
-
-		if (!ops->vidioc_dv_timings_cap)
-			break;
-
-		ret = ops->vidioc_dv_timings_cap(file, fh, p);
-		if (ret)
-			break;
-		switch (p->type) {
-		case V4L2_DV_BT_656_1120:
-			dbgarg(cmd,
-			       "type=%d, width=%u-%u, height=%u-%u, "
-			       "pixelclock=%llu-%llu, standards=%x, capabilities=%x ",
-			       p->type,
-			       p->bt.min_width, p->bt.max_width,
-			       p->bt.min_height, p->bt.max_height,
-			       p->bt.min_pixelclock, p->bt.max_pixelclock,
-			       p->bt.standards, p->bt.capabilities);
-			break;
-		default:
-			dbgarg(cmd, "unknown type ");
-			break;
-		}
-		break;
-	}
 	case VIDIOC_DQEVENT:
 	{
 		struct v4l2_event *ev = arg;
-- 
1.7.10

