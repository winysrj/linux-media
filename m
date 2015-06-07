Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:45215 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbbFGI6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 04:58:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 05/11] sh-vou: support compulsory G/S/ENUM_OUTPUT ioctls
Date: Sun,  7 Jun 2015 10:57:59 +0200
Message-Id: <1433667485-35711-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl>
References: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Video output drivers must support these ioctls. Otherwise applications
cannot deduce that these outputs exist and what capabilities they have.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/sh_vou.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 4994b7b..d9a4502 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -872,6 +872,30 @@ static int sh_vou_streamoff(struct file *file, void *priv,
 	return 0;
 }
 
+static int sh_vou_enum_output(struct file *file, void *fh,
+			      struct v4l2_output *a)
+{
+	struct sh_vou_device *vou_dev = video_drvdata(file);
+
+	if (a->index)
+		return -EINVAL;
+	strlcpy(a->name, "Video Out", sizeof(a->name));
+	a->type = V4L2_OUTPUT_TYPE_ANALOG;
+	a->std = vou_dev->vdev.tvnorms;
+	return 0;
+}
+
+int sh_vou_g_output(struct file *file, void *fh, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+int sh_vou_s_output(struct file *file, void *fh, unsigned int i)
+{
+	return i ? -EINVAL : 0;
+}
+
 static u32 sh_vou_ntsc_mode(enum sh_vou_bus_fmt bus_fmt)
 {
 	switch (bus_fmt) {
@@ -1276,6 +1300,9 @@ static const struct v4l2_ioctl_ops sh_vou_ioctl_ops = {
 	.vidioc_dqbuf			= sh_vou_dqbuf,
 	.vidioc_streamon		= sh_vou_streamon,
 	.vidioc_streamoff		= sh_vou_streamoff,
+	.vidioc_g_output		= sh_vou_g_output,
+	.vidioc_s_output		= sh_vou_s_output,
+	.vidioc_enum_output		= sh_vou_enum_output,
 	.vidioc_s_std			= sh_vou_s_std,
 	.vidioc_g_std			= sh_vou_g_std,
 	.vidioc_cropcap			= sh_vou_cropcap,
-- 
2.1.4

