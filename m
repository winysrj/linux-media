Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:16412 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbcHHTb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2016 15:31:29 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v3 12/14] media: platform: pxa_camera: add debug register access
Date: Mon,  8 Aug 2016 21:30:50 +0200
Message-Id: <1470684652-16295-13-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add pxa_camera registers access through advanced video debugging.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/soc_camera/pxa_camera.c | 57 ++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 1e15734ae287..20340489e07e 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1344,6 +1344,58 @@ static int pxa_camera_check_frame(u32 width, u32 height)
 		(width & 0x01);
 }
 
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int pxac_vidioc_g_register(struct file *file, void *priv,
+				  struct v4l2_dbg_register *reg)
+{
+	struct pxa_camera_dev *pcdev = video_drvdata(file);
+
+	if (reg->reg > CIBR2)
+		return -ERANGE;
+
+	reg->val = __raw_readl(pcdev->base + reg->reg);
+	reg->size = sizeof(__u32);
+	return 0;
+}
+
+static int pxac_vidioc_s_register(struct file *file, void *priv,
+				  const struct v4l2_dbg_register *reg)
+{
+	struct pxa_camera_dev *pcdev = video_drvdata(file);
+
+	if (reg->reg > CIBR2)
+		return -ERANGE;
+	if (reg->size != sizeof(__u32))
+		return -EINVAL;
+	__raw_writel(reg->val, pcdev->base + reg->reg);
+	return 0;
+}
+
+static int pxac_vidioc_g_chip_info(struct file *file, void *fh,
+				   struct v4l2_dbg_chip_info *chip)
+{
+	struct pxa_camera_dev *pcdev = video_drvdata(file);
+
+	switch (chip->match.type) {
+	case V4L2_CHIP_MATCH_BRIDGE:
+		if (chip->match.addr > 0)
+			return -EINVAL;
+
+		strlcpy(chip->name, "pxa-camera", sizeof(chip->name));
+		return 0;
+	case V4L2_CHIP_MATCH_SUBDEV:
+		if (chip->match.addr > 0)
+			return -EINVAL;
+
+		strlcpy(chip->name, pcdev->sensor->name, sizeof(chip->name));
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+#endif
+
 static int pxac_vidioc_enum_fmt_vid_cap(struct file *filp, void  *priv,
 					struct v4l2_fmtdesc *f)
 {
@@ -1594,6 +1646,11 @@ static const struct v4l2_ioctl_ops pxa_camera_ioctl_ops = {
 	.vidioc_expbuf			= vb2_ioctl_expbuf,
 	.vidioc_streamon		= vb2_ioctl_streamon,
 	.vidioc_streamoff		= vb2_ioctl_streamoff,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_register		= pxac_vidioc_g_register,
+	.vidioc_s_register		= pxac_vidioc_s_register,
+	.vidioc_g_chip_info		= pxac_vidioc_g_chip_info,
+#endif
 };
 
 static struct v4l2_clk_ops pxa_camera_mclk_ops = {
-- 
2.1.4

