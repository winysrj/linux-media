Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55809 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab1KDOUL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 10:20:11 -0400
Date: Fri, 04 Nov 2011 15:19:59 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 5/8] s5p-fimc: Allow probe() to succeed with null platform data
In-reply-to: <1320416402-22883-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: samsung-soc@vger.kernel.org, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1320416402-22883-6-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1320416402-22883-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "s5p-fimc-md" platform device platform_data is used to pass
attached camera sensor data. Not allowing device probe() to succeed
when it's null prevents using FIMC as a mem-to-mem device only.
Fix this by removing the platform_data check against null and
registering sensors only if platform_data is specified.
Also add logging of the information which /dev/video is assigned
to which device during probe().

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-mdevice.c |   35 ++++++++++++++++----------
 1 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index d558ae7..fc81f6f 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -385,20 +385,28 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 
 static int fimc_md_register_video_nodes(struct fimc_md *fmd)
 {
+	struct video_device *vdev;
 	int i, ret = 0;
 
 	for (i = 0; i < FIMC_MAX_DEVS && !ret; i++) {
 		if (!fmd->fimc[i])
 			continue;
 
-		if (fmd->fimc[i]->m2m.vfd)
-			ret = video_register_device(fmd->fimc[i]->m2m.vfd,
-						    VFL_TYPE_GRABBER, -1);
-		if (ret)
-			break;
-		if (fmd->fimc[i]->vid_cap.vfd)
-			ret = video_register_device(fmd->fimc[i]->vid_cap.vfd,
-						    VFL_TYPE_GRABBER, -1);
+		vdev = fmd->fimc[i]->m2m.vfd;
+		if (vdev) {
+			ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+			if (ret)
+				break;
+			v4l2_info(&fmd->v4l2_dev, "Registered %s as /dev/%s\n",
+				  vdev->name, video_device_node_name(vdev));
+		}
+
+		vdev = fmd->fimc[i]->vid_cap.vfd;
+		if (vdev == NULL)
+			continue;
+		ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+		v4l2_info(&fmd->v4l2_dev, "Registered %s as /dev/%s\n",
+			  vdev->name, video_device_node_name(vdev));
 	}
 
 	return ret;
@@ -746,9 +754,6 @@ static int __devinit fimc_md_probe(struct platform_device *pdev)
 	struct fimc_md *fmd;
 	int ret;
 
-	if (WARN(!pdev->dev.platform_data, "Platform data not specified!\n"))
-		return -EINVAL;
-
 	fmd = kzalloc(sizeof(struct fimc_md), GFP_KERNEL);
 	if (!fmd)
 		return -ENOMEM;
@@ -786,9 +791,11 @@ static int __devinit fimc_md_probe(struct platform_device *pdev)
 	if (ret)
 		goto err3;
 
-	ret = fimc_md_register_sensor_entities(fmd);
-	if (ret)
-		goto err3;
+	if (pdev->dev.platform_data) {
+		ret = fimc_md_register_sensor_entities(fmd);
+		if (ret)
+			goto err3;
+	}
 	ret = fimc_md_create_links(fmd);
 	if (ret)
 		goto err3;
-- 
1.7.7.1

