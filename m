Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:38390 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2HXOgP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 10:36:15 -0400
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>, dzu@denx.de
Subject: [PATCH v3] V4L: soc_camera: allow reading from video device if supported
Date: Fri, 24 Aug 2012 16:36:11 +0200
Message-Id: <1345818971-31062-1-git-send-email-agust@denx.de>
In-Reply-To: <1345799604-29608-1-git-send-email-agust@denx.de>
References: <1345799604-29608-1-git-send-email-agust@denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Try reading on video device. If the camera bus driver supports reading
we can try it and return the result. Also add a debug line.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 v3: - simplified as suggested by Guennadi

 v2: - rebased on current staging/for_v3.7 branch

 drivers/media/platform/soc_camera/soc_camera.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 10b57f8..1dd3997 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -645,11 +645,17 @@ static ssize_t soc_camera_read(struct file *file, char __user *buf,
 			       size_t count, loff_t *ppos)
 {
 	struct soc_camera_device *icd = file->private_data;
-	int err = -EINVAL;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+
+	dev_dbg(icd->pdev, "read called, buf %p\n", buf);
+
+	if (ici->ops->init_videobuf2 && icd->vb2_vidq.io_modes & VB2_READ)
+		return vb2_read(&icd->vb2_vidq, buf, count, ppos,
+				file->f_flags & O_NONBLOCK);
 
 	dev_err(icd->pdev, "camera device read not implemented\n");
 
-	return err;
+	return -EINVAL;
 }
 
 static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
-- 
1.7.1

