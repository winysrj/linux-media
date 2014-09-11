Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48542 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaIKGKK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Sep 2014 02:10:10 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj1so7893506pad.0
        for <linux-media@vger.kernel.org>; Wed, 10 Sep 2014 23:10:10 -0700 (PDT)
From: Kazunori Kobayashi <kkobayas@igel.co.jp>
To: g.liakhovetski@gmx.de, m.chehab@samsung.com
Cc: dhobsong@igel.co.jp, linux-media@vger.kernel.org,
	Kazunori Kobayashi <kkobayas@igel.co.jp>
Subject: [PATCH] [media] soc_camera: Support VIDIOC_EXPBUF ioctl
Date: Thu, 11 Sep 2014 15:09:38 +0900
Message-Id: <1410415778-15415-1-git-send-email-kkobayas@igel.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch allows for exporting a dmabuf descriptor from soc_camera drivers.

Signed-off-by: Kazunori Kobayashi <kkobayas@igel.co.jp>
---
 drivers/media/platform/soc_camera/soc_camera.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index f4308fe..9d7b8ea 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -437,6 +437,19 @@ static int soc_camera_prepare_buf(struct file *file, void *priv,
 		return vb2_prepare_buf(&icd->vb2_vidq, b);
 }
 
+static int soc_camera_expbuf(struct file *file, void *priv,
+			     struct v4l2_exportbuffer *p)
+{
+	struct soc_camera_device *icd = file->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+
+	/* videobuf2 only */
+	if (ici->ops->init_videobuf)
+		return -EINVAL;
+	else
+		return vb2_expbuf(&icd->vb2_vidq, p);
+}
+
 /* Always entered with .host_lock held */
 static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 {
@@ -2085,6 +2098,7 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 	.vidioc_dqbuf		 = soc_camera_dqbuf,
 	.vidioc_create_bufs	 = soc_camera_create_bufs,
 	.vidioc_prepare_buf	 = soc_camera_prepare_buf,
+	.vidioc_expbuf		 = soc_camera_expbuf,
 	.vidioc_streamon	 = soc_camera_streamon,
 	.vidioc_streamoff	 = soc_camera_streamoff,
 	.vidioc_cropcap		 = soc_camera_cropcap,
-- 
1.8.1.2

