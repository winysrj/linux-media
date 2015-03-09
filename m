Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:44514 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754473AbbCIQfy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:35:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 11/19] m2m-deinterlace: embed video_device
Date: Mon,  9 Mar 2015 17:34:05 +0100
Message-Id: <1425918853-12371-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/platform/m2m-deinterlace.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index b70c1ae..92d9549 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -127,7 +127,7 @@ static struct deinterlace_fmt *find_format(struct v4l2_format *f)
 
 struct deinterlace_dev {
 	struct v4l2_device	v4l2_dev;
-	struct video_device	*vfd;
+	struct video_device	vfd;
 
 	atomic_t		busy;
 	struct mutex		dev_mutex;
@@ -983,7 +983,7 @@ static struct video_device deinterlace_videodev = {
 	.fops		= &deinterlace_fops,
 	.ioctl_ops	= &deinterlace_ioctl_ops,
 	.minor		= -1,
-	.release	= video_device_release,
+	.release	= video_device_release_empty,
 	.vfl_dir	= VFL_DIR_M2M,
 };
 
@@ -1026,13 +1026,7 @@ static int deinterlace_probe(struct platform_device *pdev)
 	atomic_set(&pcdev->busy, 0);
 	mutex_init(&pcdev->dev_mutex);
 
-	vfd = video_device_alloc();
-	if (!vfd) {
-		v4l2_err(&pcdev->v4l2_dev, "Failed to allocate video device\n");
-		ret = -ENOMEM;
-		goto unreg_dev;
-	}
-
+	vfd = &pcdev->vfd;
 	*vfd = deinterlace_videodev;
 	vfd->lock = &pcdev->dev_mutex;
 	vfd->v4l2_dev = &pcdev->v4l2_dev;
@@ -1040,12 +1034,11 @@ static int deinterlace_probe(struct platform_device *pdev)
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
 		v4l2_err(&pcdev->v4l2_dev, "Failed to register video device\n");
-		goto rel_vdev;
+		goto unreg_dev;
 	}
 
 	video_set_drvdata(vfd, pcdev);
 	snprintf(vfd->name, sizeof(vfd->name), "%s", deinterlace_videodev.name);
-	pcdev->vfd = vfd;
 	v4l2_info(&pcdev->v4l2_dev, MEM2MEM_TEST_MODULE_NAME
 			" Device registered as /dev/video%d\n", vfd->num);
 
@@ -1069,11 +1062,9 @@ static int deinterlace_probe(struct platform_device *pdev)
 
 	v4l2_m2m_release(pcdev->m2m_dev);
 err_m2m:
-	video_unregister_device(pcdev->vfd);
+	video_unregister_device(&pcdev->vfd);
 err_ctx:
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
-rel_vdev:
-	video_device_release(vfd);
 unreg_dev:
 	v4l2_device_unregister(&pcdev->v4l2_dev);
 rel_dma:
@@ -1088,7 +1079,7 @@ static int deinterlace_remove(struct platform_device *pdev)
 
 	v4l2_info(&pcdev->v4l2_dev, "Removing " MEM2MEM_TEST_MODULE_NAME);
 	v4l2_m2m_release(pcdev->m2m_dev);
-	video_unregister_device(pcdev->vfd);
+	video_unregister_device(&pcdev->vfd);
 	v4l2_device_unregister(&pcdev->v4l2_dev);
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 	dma_release_channel(pcdev->dma_chan);
-- 
2.1.4

