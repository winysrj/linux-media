Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59733 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752833AbZG2PSV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 11:18:21 -0400
Date: Wed, 29 Jul 2009 17:18:32 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Magnus Damm <magnus.damm@gmail.com>, m-karicheri2@ti.com,
	Valentin Longchamp <valentin.longchamp@epfl.ch>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Darius Augulis <augulis.darius@gmail.com>
Subject: [PATCH 2/4] soc-camera: Use camera device object for core output
In-Reply-To: <Pine.LNX.4.64.0907291640010.4983@axis700.grange>
Message-ID: <Pine.LNX.4.64.0907291658310.4983@axis700.grange>
References: <Pine.LNX.4.64.0907291640010.4983@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index dd023bd..c6cccdf 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -297,7 +297,7 @@ static int soc_camera_set_fmt(struct soc_camera_file *icf,
 		return ret;
 	} else if (!icd->current_fmt ||
 		   icd->current_fmt->fourcc != pix->pixelformat) {
-		dev_err(ici->v4l2_dev.dev,
+		dev_err(&icd->dev,
 			"Host driver hasn't set up current format correctly!\n");
 		return -EINVAL;
 	}
@@ -426,7 +426,6 @@ static int soc_camera_close(struct file *file)
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	struct video_device *vdev = icd->vdev;
 
 	mutex_lock(&icd->video_lock);
 	icd->use_count--;
@@ -446,7 +445,7 @@ static int soc_camera_close(struct file *file)
 
 	vfree(icf);
 
-	dev_dbg(vdev->parent, "camera device close\n");
+	dev_dbg(&icd->dev, "camera device close\n");
 
 	return 0;
 }
@@ -456,10 +455,9 @@ static ssize_t soc_camera_read(struct file *file, char __user *buf,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
-	struct video_device *vdev = icd->vdev;
 	int err = -EINVAL;
 
-	dev_err(vdev->parent, "camera device read not implemented\n");
+	dev_err(&icd->dev, "camera device read not implemented\n");
 
 	return err;
 }
-- 
1.6.2.4

