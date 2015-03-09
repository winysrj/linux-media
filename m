Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:34277 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932227AbbCIQei (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:34:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 02/19] vim2m: embed video_device
Date: Mon,  9 Mar 2015 17:33:56 +0100
Message-Id: <1425918853-12371-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/platform/vim2m.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index d9d844a..4d6b4cc 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -142,7 +142,7 @@ static struct vim2m_fmt *find_format(struct v4l2_format *f)
 
 struct vim2m_dev {
 	struct v4l2_device	v4l2_dev;
-	struct video_device	*vfd;
+	struct video_device	vfd;
 
 	atomic_t		num_inst;
 	struct mutex		dev_mutex;
@@ -968,7 +968,7 @@ static struct video_device vim2m_videodev = {
 	.fops		= &vim2m_fops,
 	.ioctl_ops	= &vim2m_ioctl_ops,
 	.minor		= -1,
-	.release	= video_device_release,
+	.release	= video_device_release_empty,
 };
 
 static struct v4l2_m2m_ops m2m_ops = {
@@ -996,26 +996,19 @@ static int vim2m_probe(struct platform_device *pdev)
 	atomic_set(&dev->num_inst, 0);
 	mutex_init(&dev->dev_mutex);
 
-	vfd = video_device_alloc();
-	if (!vfd) {
-		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
-		ret = -ENOMEM;
-		goto unreg_dev;
-	}
-
-	*vfd = vim2m_videodev;
+	dev->vfd = vim2m_videodev;
+	vfd = &dev->vfd;
 	vfd->lock = &dev->dev_mutex;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-		goto rel_vdev;
+		goto unreg_dev;
 	}
 
 	video_set_drvdata(vfd, dev);
 	snprintf(vfd->name, sizeof(vfd->name), "%s", vim2m_videodev.name);
-	dev->vfd = vfd;
 	v4l2_info(&dev->v4l2_dev,
 			"Device registered as /dev/video%d\n", vfd->num);
 
@@ -1033,9 +1026,7 @@ static int vim2m_probe(struct platform_device *pdev)
 
 err_m2m:
 	v4l2_m2m_release(dev->m2m_dev);
-	video_unregister_device(dev->vfd);
-rel_vdev:
-	video_device_release(vfd);
+	video_unregister_device(&dev->vfd);
 unreg_dev:
 	v4l2_device_unregister(&dev->v4l2_dev);
 
@@ -1049,7 +1040,7 @@ static int vim2m_remove(struct platform_device *pdev)
 	v4l2_info(&dev->v4l2_dev, "Removing " MEM2MEM_NAME);
 	v4l2_m2m_release(dev->m2m_dev);
 	del_timer_sync(&dev->timer);
-	video_unregister_device(dev->vfd);
+	video_unregister_device(&dev->vfd);
 	v4l2_device_unregister(&dev->v4l2_dev);
 
 	return 0;
-- 
2.1.4

