Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:34584 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab2HXJNZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 05:13:25 -0400
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>, dzu@denx.de
Subject: [PATCH v2] V4L: soc_camera: allow reading from video device if supported
Date: Fri, 24 Aug 2012 11:13:24 +0200
Message-Id: <1345799604-29608-1-git-send-email-agust@denx.de>
In-Reply-To: <1345290335-12980-1-git-send-email-agust@denx.de>
References: <1345290335-12980-1-git-send-email-agust@denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Try reading on video device. If the camera bus driver supports reading
we can try it and return the result. Also add a debug line.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 v2: - rebased on current staging/for_v3.7 branch
 
 drivers/media/platform/soc_camera/soc_camera.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 10b57f8..d591a42 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
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

