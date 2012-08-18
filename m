Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:50082 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab2HRLpo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Aug 2012 07:45:44 -0400
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] V4L: soc_camera: allow reading from video device if supported
Date: Sat, 18 Aug 2012 13:45:35 +0200
Message-Id: <1345290335-12980-1-git-send-email-agust@denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Try reading on video device. If the camera bus driver supports reading
we can try it and return the result. Also add a debug line.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/media/platform/soc_camera.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/soc_camera.c b/drivers/media/platform/soc_camera.c
index 10b57f8..d591a42 100644
--- a/drivers/media/platform/soc_camera.c
+++ b/drivers/media/platform/soc_camera.c
@@ -645,9 +645,16 @@ static ssize_t soc_camera_read(struct file *file, char __user *buf,
 			       size_t count, loff_t *ppos)
 {
 	struct soc_camera_device *icd = file->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	int err = -EINVAL;
 
-	dev_err(icd->pdev, "camera device read not implemented\n");
+	dev_dbg(icd->pdev, "read called, buf %p\n", buf);
+
+	if (ici->ops->init_videobuf2 && icd->vb2_vidq.io_modes & VB2_READ)
+		err = vb2_read(&icd->vb2_vidq, buf, count, ppos,
+				file->f_flags & O_NONBLOCK);
+	else
+		dev_err(icd->pdev, "camera device read not implemented\n");
 
 	return err;
 }
-- 
1.7.1

