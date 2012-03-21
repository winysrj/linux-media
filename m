Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57785 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030800Ab2CULDY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 07:03:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 9/9] soc-camera: Support user-configurable line stride
Date: Wed, 21 Mar 2012 12:03:28 +0100
Message-Id: <1332327808-6056-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a capabilities field to the soc_camera_host structure to flag hosts
that support user-configurable line strides. soc_camera_try_fmt() then
passes the user-provided bytesperline and sizeimage format fields to
such hosts, and expects the host to check (and fix if needed) the
values.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mx2_camera.c |    2 ++
 drivers/media/video/soc_camera.c |    6 ++++--
 include/media/soc_camera.h       |    4 ++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 1269b5f..253232e 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -1626,6 +1626,8 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 	pcdev->soc_host.priv		= pcdev;
 	pcdev->soc_host.v4l2_dev.dev	= &pdev->dev;
 	pcdev->soc_host.nr		= pdev->id;
+	if (cpu_is_mx25()) {
+		pcdev->soc_host.capabilities = SOCAM_HOST_CAP_STRIDE;
 	err = soc_camera_host_register(&pcdev->soc_host);
 	if (err)
 		goto exit_free_emma;
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 02ae98b..04a5fcab 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -171,8 +171,10 @@ static int soc_camera_try_fmt(struct soc_camera_device *icd,
 	dev_dbg(icd->pdev, "TRY_FMT(%c%c%c%c, %ux%u)\n",
 		pixfmtstr(pix->pixelformat), pix->width, pix->height);
 
-	pix->bytesperline = 0;
-	pix->sizeimage = 0;
+	if (!(ici->capabilities & SOCAM_HOST_CAP_STRIDE)) {
+		pix->bytesperline = 0;
+		pix->sizeimage = 0;
+	}
 
 	ret = ici->ops->try_fmt(icd, f);
 	if (ret < 0)
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index b5c2b6c..9eee641 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -56,10 +56,14 @@ struct soc_camera_device {
 	};
 };
 
+/* Host supports programmable stride */
+#define SOCAM_HOST_CAP_STRIDE		(1 << 0)
+
 struct soc_camera_host {
 	struct v4l2_device v4l2_dev;
 	struct list_head list;
 	unsigned char nr;				/* Host number */
+	u32 capabilities;
 	void *priv;
 	const char *drv_name;
 	struct soc_camera_host_ops *ops;
-- 
1.7.3.4

