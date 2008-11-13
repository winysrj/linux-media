Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mADJ9dqa025719
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 14:09:39 -0500
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mADJ8b2U023867
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 14:08:37 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, video4linux-list@redhat.com
Date: Thu, 13 Nov 2008 20:08:34 +0100
Message-Id: <1226603314-17974-1-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1226521783-19806-13-git-send-email-robert.jarzmik@free.fr>
References: <1226521783-19806-13-git-send-email-robert.jarzmik@free.fr>
Cc: 
Subject: [PATCH 13/13] pxa_camera: add sensor format passthrough
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Once the pixel translation layer is added and used,
pxa_camera should choose which native sensor formats to pass
through untouched (bayer and monochromas are good examples).

Add them in this patch.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/pxa_camera.c |   51 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index fde14e7..829037d 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1010,6 +1010,56 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 	return icd->ops->try_fmt(icd, f);
 }
 
+static bool depth_supported(struct soc_camera_device *icd, int i)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+
+	switch (icd->formats[i].depth) {
+	case 8:
+		if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)
+			return true;
+		return false;
+	case 9:
+		if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_9)
+			return true;
+		return false;
+	case 10:
+		if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_10)
+			return true;
+		return false;
+	}
+	return false;
+}
+
+static int pxa_camera_add_extra_fmt(struct soc_camera_device *icd, int idx,
+				    struct soc_camera_computed_format *fmt)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_format_translate *trans;
+
+	for (trans = ici->translate_fmt; trans->host_fmt.name; trans++) {
+		if (trans->host_fmt.depth != icd->formats[idx].depth)
+			continue;
+		if (trans->sensor_fourcc != icd->formats[idx].fourcc)
+			continue;
+		return 0;
+	}
+
+	if (!depth_supported(icd, idx))
+		return 0;
+	/*
+	 * TODO: We should check if we really shall pass this format through
+	 *       For now, if the depth is supported, it is passed through
+	 */
+
+	if (fmt) {
+		fmt[0].host_fmt = &icd->formats[idx];
+		fmt[0].sensor_fmt = &icd->formats[idx];
+	}
+	return 1;
+}
+
 static int pxa_camera_reqbufs(struct soc_camera_file *icf,
 			      struct v4l2_requestbuffers *p)
 {
@@ -1115,6 +1165,7 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.resume		= pxa_camera_resume,
 	.set_fmt	= pxa_camera_set_fmt,
 	.try_fmt	= pxa_camera_try_fmt,
+	.add_extra_format = pxa_camera_add_extra_fmt,
 	.init_videobuf	= pxa_camera_init_videobuf,
 	.reqbufs	= pxa_camera_reqbufs,
 	.poll		= pxa_camera_poll,
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
