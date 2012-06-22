Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1995 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab2FVMVq (ORCPT
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
Subject: [RFCv2 PATCH 14/34] v4l2-ioctl.c: use the new table for compression ioctls.
Date: Fri, 22 Jun 2012 14:21:08 +0200
Message-Id: <54c642088471dc588db2d3a7c71e94355e248141.1340366355.git.hans.verkuil@cisco.com>
In-Reply-To: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
References: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |  123 ++++++++++++++------------------------
 1 file changed, 46 insertions(+), 77 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index ba13361..93aaa73 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -590,6 +590,45 @@ static void v4l_print_selection(const void *arg, bool write_only)
 		p->r.width, p->r.height, p->r.left, p->r.top);
 }
 
+static void v4l_print_jpegcompression(const void *arg, bool write_only)
+{
+	const struct v4l2_jpegcompression *p = arg;
+
+	pr_cont("quality=%d, APPn=%d, APP_len=%d, "
+		"COM_len=%d, jpeg_markers=0x%x\n",
+		p->quality, p->APPn, p->APP_len,
+		p->COM_len, p->jpeg_markers);
+}
+
+static void v4l_print_enc_idx(const void *arg, bool write_only)
+{
+	const struct v4l2_enc_idx *p = arg;
+
+	pr_cont("entries=%d, entries_cap=%d\n",
+			p->entries, p->entries_cap);
+}
+
+static void v4l_print_encoder_cmd(const void *arg, bool write_only)
+{
+	const struct v4l2_encoder_cmd *p = arg;
+
+	pr_cont("cmd=%d, flags=0x%x\n",
+			p->cmd, p->flags);
+}
+
+static void v4l_print_decoder_cmd(const void *arg, bool write_only)
+{
+	const struct v4l2_decoder_cmd *p = arg;
+
+	pr_cont("cmd=%d, flags=0x%x\n", p->cmd, p->flags);
+
+	if (p->cmd == V4L2_DEC_CMD_START)
+		pr_info("speed=%d, format=%u\n",
+				p->start.speed, p->start.format);
+	else if (p->cmd == V4L2_DEC_CMD_STOP)
+		pr_info("pts=%llu\n", p->stop.pts);
+}
+
 static void v4l_print_u32(const void *arg, bool write_only)
 {
 	pr_cont("value=%u\n", *(const u32 *)arg);
@@ -1591,8 +1630,8 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_S_CROP, v4l_s_crop, v4l_print_crop, INFO_FL_PRIO),
 	IOCTL_INFO_STD(VIDIOC_G_SELECTION, vidioc_g_selection, v4l_print_selection, 0),
 	IOCTL_INFO_STD(VIDIOC_S_SELECTION, vidioc_s_selection, v4l_print_selection, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_JPEGCOMP, 0),
-	IOCTL_INFO(VIDIOC_S_JPEGCOMP, INFO_FL_PRIO),
+	IOCTL_INFO_STD(VIDIOC_G_JPEGCOMP, vidioc_g_jpegcomp, v4l_print_jpegcompression, 0),
+	IOCTL_INFO_STD(VIDIOC_S_JPEGCOMP, vidioc_s_jpegcomp, v4l_print_jpegcompression, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_QUERYSTD, v4l_querystd, v4l_print_std, 0),
 	IOCTL_INFO_FNC(VIDIOC_TRY_FMT, v4l_try_fmt, v4l_print_format, 0),
 	IOCTL_INFO_STD(VIDIOC_ENUMAUDIO, vidioc_enumaudio, v4l_print_audio, INFO_FL_CLEAR(v4l2_audio, index)),
@@ -1606,11 +1645,11 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_TRY_EXT_CTRLS, v4l_try_ext_ctrls, v4l_print_ext_controls, 0),
 	IOCTL_INFO(VIDIOC_ENUM_FRAMESIZES, INFO_FL_CLEAR(v4l2_frmsizeenum, pixel_format)),
 	IOCTL_INFO(VIDIOC_ENUM_FRAMEINTERVALS, INFO_FL_CLEAR(v4l2_frmivalenum, height)),
-	IOCTL_INFO(VIDIOC_G_ENC_INDEX, 0),
-	IOCTL_INFO(VIDIOC_ENCODER_CMD, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
-	IOCTL_INFO(VIDIOC_TRY_ENCODER_CMD, INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
-	IOCTL_INFO(VIDIOC_DECODER_CMD, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_TRY_DECODER_CMD, 0),
+	IOCTL_INFO_STD(VIDIOC_G_ENC_INDEX, vidioc_g_enc_index, v4l_print_enc_idx, 0),
+	IOCTL_INFO_STD(VIDIOC_ENCODER_CMD, vidioc_encoder_cmd, v4l_print_encoder_cmd, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
+	IOCTL_INFO_STD(VIDIOC_TRY_ENCODER_CMD, vidioc_try_encoder_cmd, v4l_print_encoder_cmd, INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
+	IOCTL_INFO_STD(VIDIOC_DECODER_CMD, vidioc_decoder_cmd, v4l_print_decoder_cmd, INFO_FL_PRIO),
+	IOCTL_INFO_STD(VIDIOC_TRY_DECODER_CMD, vidioc_try_decoder_cmd, v4l_print_decoder_cmd, 0),
 	IOCTL_INFO(VIDIOC_DBG_S_REGISTER, 0),
 	IOCTL_INFO(VIDIOC_DBG_G_REGISTER, 0),
 	IOCTL_INFO(VIDIOC_DBG_G_CHIP_IDENT, 0),
@@ -1735,76 +1774,6 @@ static long __video_do_ioctl(struct file *file,
 	}
 
 	switch (cmd) {
-	case VIDIOC_G_JPEGCOMP:
-	{
-		struct v4l2_jpegcompression *p = arg;
-
-		ret = ops->vidioc_g_jpegcomp(file, fh, p);
-		if (!ret)
-			dbgarg(cmd, "quality=%d, APPn=%d, "
-					"APP_len=%d, COM_len=%d, "
-					"jpeg_markers=%d\n",
-					p->quality, p->APPn, p->APP_len,
-					p->COM_len, p->jpeg_markers);
-		break;
-	}
-	case VIDIOC_S_JPEGCOMP:
-	{
-		struct v4l2_jpegcompression *p = arg;
-
-		dbgarg(cmd, "quality=%d, APPn=%d, APP_len=%d, "
-					"COM_len=%d, jpeg_markers=%d\n",
-					p->quality, p->APPn, p->APP_len,
-					p->COM_len, p->jpeg_markers);
-		ret = ops->vidioc_s_jpegcomp(file, fh, p);
-		break;
-	}
-	case VIDIOC_G_ENC_INDEX:
-	{
-		struct v4l2_enc_idx *p = arg;
-
-		ret = ops->vidioc_g_enc_index(file, fh, p);
-		if (!ret)
-			dbgarg(cmd, "entries=%d, entries_cap=%d\n",
-					p->entries, p->entries_cap);
-		break;
-	}
-	case VIDIOC_ENCODER_CMD:
-	{
-		struct v4l2_encoder_cmd *p = arg;
-
-		ret = ops->vidioc_encoder_cmd(file, fh, p);
-		if (!ret)
-			dbgarg(cmd, "cmd=%d, flags=%x\n", p->cmd, p->flags);
-		break;
-	}
-	case VIDIOC_TRY_ENCODER_CMD:
-	{
-		struct v4l2_encoder_cmd *p = arg;
-
-		ret = ops->vidioc_try_encoder_cmd(file, fh, p);
-		if (!ret)
-			dbgarg(cmd, "cmd=%d, flags=%x\n", p->cmd, p->flags);
-		break;
-	}
-	case VIDIOC_DECODER_CMD:
-	{
-		struct v4l2_decoder_cmd *p = arg;
-
-		ret = ops->vidioc_decoder_cmd(file, fh, p);
-		if (!ret)
-			dbgarg(cmd, "cmd=%d, flags=%x\n", p->cmd, p->flags);
-		break;
-	}
-	case VIDIOC_TRY_DECODER_CMD:
-	{
-		struct v4l2_decoder_cmd *p = arg;
-
-		ret = ops->vidioc_try_decoder_cmd(file, fh, p);
-		if (!ret)
-			dbgarg(cmd, "cmd=%d, flags=%x\n", p->cmd, p->flags);
-		break;
-	}
 	case VIDIOC_G_SLICED_VBI_CAP:
 	{
 		struct v4l2_sliced_vbi_cap *p = arg;
-- 
1.7.10

