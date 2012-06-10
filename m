Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2289 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab2FJK0M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:26:12 -0400
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
Subject: [RFCv1 PATCH 15/32] v4l2-ioctl.c: use the new table for debug ioctls.
Date: Sun, 10 Jun 2012 12:25:37 +0200
Message-Id: <9f639172dd95060e57f405d514e1e887ff838cc0.1339321562.git.hans.verkuil@cisco.com>
In-Reply-To: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
References: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |  139 ++++++++++++++++++++++++--------------
 1 file changed, 89 insertions(+), 50 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index a7e583e..c22a310 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -644,11 +644,42 @@ static void v4l_print_decoder_cmd(const void *arg)
 		pr_info("pts=%llu\n", p->stop.pts);
 }
 
+static void v4l_print_dbg_chip_ident(const void *arg)
+{
+	const struct v4l2_dbg_chip_ident *p = arg;
+
+	pr_cont("type=%u, ", p->match.type);
+	if (p->match.type == V4L2_CHIP_MATCH_I2C_DRIVER)
+		pr_cont("name=%s, ", p->match.name);
+	else
+		pr_cont("addr=%u, ", p->match.addr);
+	pr_cont("chip_ident=%u, revision=0x%x\n",
+			p->ident, p->revision);
+}
+
+static void v4l_print_dbg_register(const void *arg)
+{
+	const struct v4l2_dbg_register *p = arg;
+
+	pr_cont("type=%u, ", p->match.type);
+	if (p->match.type == V4L2_CHIP_MATCH_I2C_DRIVER)
+		pr_cont("name=%s, ", p->match.name);
+	else
+		pr_cont("addr=%u, ", p->match.addr);
+	pr_cont("reg=0x%llx, val=0x%llx\n",
+			p->reg, p->val);
+}
+
 static void v4l_print_u32(const void *arg)
 {
 	pr_cont("value=%u\n", *(const u32 *)arg);
 }
 
+static void v4l_print_newline(const void *arg)
+{
+	pr_cont("\n");
+}
+
 static void dbgtimings(struct video_device *vfd,
 			const struct v4l2_dv_timings *p)
 {
@@ -1551,6 +1582,60 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 	return 0;
 }
 
+static int v4l_log_status(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	int ret;
+
+	if (vfd->v4l2_dev)
+		pr_info("%s: =================  START STATUS  =================\n",
+			vfd->v4l2_dev->name);
+	ret = ops->vidioc_log_status(file, fh);
+	if (vfd->v4l2_dev)
+		pr_info("%s: ==================  END STATUS  ==================\n",
+			vfd->v4l2_dev->name);
+	return ret;
+}
+
+static int v4l_dbg_g_register(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	struct v4l2_dbg_register *p = arg;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	return ops->vidioc_g_register(file, fh, p);
+#else
+	return -ENOTTY;
+#endif
+}
+
+static int v4l_dbg_s_register(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	struct v4l2_dbg_register *p = arg;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	return ops->vidioc_s_register(file, fh, p);
+#else
+	return -ENOTTY;
+#endif
+}
+
+static int v4l_dbg_g_chip_ident(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_dbg_chip_ident *p = arg;
+
+	p->ident = V4L2_IDENT_NONE;
+	p->revision = 0;
+	return ops->vidioc_g_chip_ident(file, fh, p);
+}
+
 struct v4l2_ioctl_info {
 	unsigned int ioctl;
 	u32 flags;
@@ -1654,7 +1739,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_G_PRIORITY, v4l_g_priority, v4l_print_u32, 0),
 	IOCTL_INFO_FNC(VIDIOC_S_PRIORITY, v4l_s_priority, v4l_print_u32, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_G_SLICED_VBI_CAP, INFO_FL_CLEAR(v4l2_sliced_vbi_cap, type)),
-	IOCTL_INFO(VIDIOC_LOG_STATUS, 0),
+	IOCTL_INFO_FNC(VIDIOC_LOG_STATUS, v4l_log_status, v4l_print_newline, 0),
 	IOCTL_INFO_FNC(VIDIOC_G_EXT_CTRLS, v4l_g_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
 	IOCTL_INFO_FNC(VIDIOC_S_EXT_CTRLS, v4l_s_ext_ctrls, v4l_print_ext_controls, INFO_FL_PRIO | INFO_FL_CTRL),
 	IOCTL_INFO_FNC(VIDIOC_TRY_EXT_CTRLS, v4l_try_ext_ctrls, v4l_print_ext_controls, 0),
@@ -1665,9 +1750,9 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_STD(VIDIOC_TRY_ENCODER_CMD, vidioc_try_encoder_cmd, v4l_print_encoder_cmd, INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
 	IOCTL_INFO_STD(VIDIOC_DECODER_CMD, vidioc_decoder_cmd, v4l_print_decoder_cmd, INFO_FL_PRIO),
 	IOCTL_INFO_STD(VIDIOC_TRY_DECODER_CMD, vidioc_try_decoder_cmd, v4l_print_decoder_cmd, 0),
-	IOCTL_INFO(VIDIOC_DBG_S_REGISTER, 0),
-	IOCTL_INFO(VIDIOC_DBG_G_REGISTER, 0),
-	IOCTL_INFO(VIDIOC_DBG_G_CHIP_IDENT, 0),
+	IOCTL_INFO_FNC(VIDIOC_DBG_S_REGISTER, v4l_dbg_s_register, v4l_print_dbg_register, 0),
+	IOCTL_INFO_FNC(VIDIOC_DBG_G_REGISTER, v4l_dbg_g_register, v4l_print_dbg_register, 0),
+	IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_IDENT, v4l_dbg_g_chip_ident, v4l_print_dbg_chip_ident, 0),
 	IOCTL_INFO_FNC(VIDIOC_S_HW_FREQ_SEEK, v4l_s_hw_freq_seek, v4l_print_hw_freq_seek, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_ENUM_DV_PRESETS, 0),
 	IOCTL_INFO(VIDIOC_S_DV_PRESET, INFO_FL_PRIO),
@@ -1802,52 +1887,6 @@ static long __video_do_ioctl(struct file *file,
 			dbgarg2("service_set=%d\n", p->service_set);
 		break;
 	}
-	case VIDIOC_LOG_STATUS:
-	{
-		if (vfd->v4l2_dev)
-			pr_info("%s: =================  START STATUS  =================\n",
-				vfd->v4l2_dev->name);
-		ret = ops->vidioc_log_status(file, fh);
-		if (vfd->v4l2_dev)
-			pr_info("%s: ==================  END STATUS  ==================\n",
-				vfd->v4l2_dev->name);
-		break;
-	}
-	case VIDIOC_DBG_G_REGISTER:
-	{
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-		struct v4l2_dbg_register *p = arg;
-
-		if (!capable(CAP_SYS_ADMIN))
-			ret = -EPERM;
-		else
-			ret = ops->vidioc_g_register(file, fh, p);
-#endif
-		break;
-	}
-	case VIDIOC_DBG_S_REGISTER:
-	{
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-		struct v4l2_dbg_register *p = arg;
-
-		if (!capable(CAP_SYS_ADMIN))
-			ret = -EPERM;
-		else
-			ret = ops->vidioc_s_register(file, fh, p);
-#endif
-		break;
-	}
-	case VIDIOC_DBG_G_CHIP_IDENT:
-	{
-		struct v4l2_dbg_chip_ident *p = arg;
-
-		p->ident = V4L2_IDENT_NONE;
-		p->revision = 0;
-		ret = ops->vidioc_g_chip_ident(file, fh, p);
-		if (!ret)
-			dbgarg(cmd, "chip_ident=%u, revision=0x%x\n", p->ident, p->revision);
-		break;
-	}
 	case VIDIOC_ENUM_FRAMESIZES:
 	{
 		struct v4l2_frmsizeenum *p = arg;
-- 
1.7.10

