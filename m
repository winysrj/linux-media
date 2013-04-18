Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:60219 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936231Ab3DRVf6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:58 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 22/24] V4L2: soc-camera: use the pad-operation wrapper
Date: Thu, 18 Apr 2013 23:35:43 +0200
Message-Id: <1366320945-21591-23-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the pad-operation wrapper to soc-camera, which
allows pure pad-level subdevice drivers, e.g. mt9p031 to be used with
soc-camera.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/soc_camera.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 3113287..dfd1741 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -36,6 +36,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
+#include <media/v4l2-pad-wrap.h>
 #include <media/videobuf-core.h>
 #include <media/videobuf2-core.h>
 
@@ -62,7 +63,9 @@ struct soc_camera_async_client {
 	struct v4l2_async_subdev *sensor;
 	struct v4l2_async_notifier notifier;
 	struct platform_device *pdev;
-	struct list_head list;		/* needed for clean up */
+	/* needed for clean up */
+	struct list_head list;
+	struct v4l2_subdev *subdev;
 };
 
 static int soc_camera_video_start(struct soc_camera_device *icd);
@@ -1301,10 +1304,14 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
 	if (ret < 0)
 		return ret;
 
+	ret = v4l2_subdev_pad_wrap(sd);
+	if (ret < 0 && ret != -ENOSYS)
+		return ret;
+
 	ret = soc_camera_add_device(icd);
 	if (ret < 0) {
 		dev_err(icd->pdev, "Couldn't activate the camera: %d\n", ret);
-		return ret;
+		goto eadddev;
 	}
 
 	/* At this point client .probe() should have run already */
@@ -1329,6 +1336,8 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
 
 	return 0;
 
+eadddev:
+	v4l2_subdev_pad_unwrap(sd);
 evidstart:
 	soc_camera_free_user_formats(icd);
 eusrfmt:
@@ -1693,6 +1702,8 @@ static int soc_camera_remove(struct soc_camera_device *icd)
 {
 	struct soc_camera_desc *sdesc = to_soc_camera_desc(icd);
 	struct video_device *vdev = icd->vdev;
+	struct v4l2_subdev *sd = icd->sasc ? icd->sasc->subdev :
+		soc_camera_to_subdev(icd);
 
 	v4l2_ctrl_handler_free(&icd->ctrl_handler);
 	if (vdev) {
@@ -1700,6 +1711,9 @@ static int soc_camera_remove(struct soc_camera_device *icd)
 		icd->vdev = NULL;
 	}
 
+	/* Before cleaning up the sensor subdevice */
+	v4l2_subdev_pad_unwrap(sd);
+
 	if (sdesc->host_desc.board_info) {
 		soc_camera_i2c_free(icd);
 	} else {
@@ -1867,6 +1881,7 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 			/* as long as we hold the device, sasc won't be freed */
 			get_device(icd->pdev);
 			list_add(&icd->sasc->list, &notifiers);
+			icd->sasc->subdev = soc_camera_to_subdev(icd);
 		}
 	mutex_unlock(&list_lock);
 
-- 
1.7.2.5

