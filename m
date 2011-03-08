Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:60983 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab1CHAy4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Mar 2011 19:54:56 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [PATCH] V4L: soc-camera: Add support for custom host mmap
Date: Mon,  7 Mar 2011 18:54:51 -0600
Message-Id: <1299545691-917-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This helps redirect mmap calls to custom memory managers which
already have preallocated space to use by the device.

Otherwise, device might not support the allocation attempted
generically by videobuf.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/soc_camera.c |    7 ++++++-
 include/media/soc_camera.h       |    2 ++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 59dc71d..d361ba0 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -512,6 +512,7 @@ static ssize_t soc_camera_read(struct file *file, char __user *buf,
 static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct soc_camera_device *icd = file->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	int err;
 
 	dev_dbg(&icd->dev, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
@@ -519,7 +520,11 @@ static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
 	if (icd->streamer != file)
 		return -EBUSY;
 
-	err = videobuf_mmap_mapper(&icd->vb_vidq, vma);
+	/* Check for an interface custom mmaper */
+	if (ici->ops->mmap)
+		err = ici->ops->mmap(&icd->vb_vidq, icd, vma);
+	else
+		err = videobuf_mmap_mapper(&icd->vb_vidq, vma);
 
 	dev_dbg(&icd->dev, "vma start=0x%08lx, size=%ld, ret=%d\n",
 		(unsigned long)vma->vm_start,
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index de81370..11350c2 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -87,6 +87,8 @@ struct soc_camera_host_ops {
 	int (*set_ctrl)(struct soc_camera_device *, struct v4l2_control *);
 	int (*get_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
 	int (*set_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
+	int (*mmap)(struct videobuf_queue *, struct soc_camera_device *,
+		     struct vm_area_struct *);
 	unsigned int (*poll)(struct file *, poll_table *);
 	const struct v4l2_queryctrl *controls;
 	int num_controls;
-- 
1.7.1

