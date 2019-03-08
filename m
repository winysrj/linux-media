Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC64EC10F0D
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 13:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9802920661
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 13:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfCHN4e (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:56:34 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:36843 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbfCHN4c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 08:56:32 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id 2Fz7hPu8XI8AW2FzChLWFW; Fri, 08 Mar 2019 14:56:30 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv4 4/9] vim2m: replace devm_kzalloc by kzalloc
Date:   Fri,  8 Mar 2019 14:56:20 +0100
Message-Id: <20190308135625.11278-5-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308135625.11278-1-hverkuil-cisco@xs4all.nl>
References: <20190308135625.11278-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfACdcE0cPS2rLGfu372taeC34S1lAywkR4NlMCsUvZ/F8obcioZCGgjNTN3X5YwLa+qbMwzWHjilWqzh0bVpHKM422Tpu/O0XZgFlTRRHDGHDLt9VNTA
 lDSkhxYDuk3PrBbOmOa6rz4sMrsKGzLjF+r1LiNdVQwvVW4G9rZ6fqqtPzwsKCmoWvpLwy6exzR1+xBVMQWx4rfxSARQxavQzeYvRV9yI8WzgHxQJZkSPL83
 P2EDWkpARa/AuDyr/fzU2MMRWTjH3U+TzfC0HnW14yhVTAFM8uU1uF+uEpKxgOrVvjpBD9fVwckTZ6QcGsOSlw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

It is not possible to use devm_kzalloc since that memory is
freed immediately when the device instance is unbound.

Various objects like the video device may still be in use
since someone has the device node open, and when that is closed
it expects the memory to be around.

So use kzalloc and release it at the appropriate time.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/vim2m.c | 35 +++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 34dcaca45d8b..dd47821fc661 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1262,6 +1262,15 @@ static int vim2m_release(struct file *file)
 	return 0;
 }
 
+static void vim2m_device_release(struct video_device *vdev)
+{
+	struct vim2m_dev *dev = container_of(vdev, struct vim2m_dev, vfd);
+
+	v4l2_device_unregister(&dev->v4l2_dev);
+	v4l2_m2m_release(dev->m2m_dev);
+	kfree(dev);
+}
+
 static const struct v4l2_file_operations vim2m_fops = {
 	.owner		= THIS_MODULE,
 	.open		= vim2m_open,
@@ -1277,7 +1286,7 @@ static const struct video_device vim2m_videodev = {
 	.fops		= &vim2m_fops,
 	.ioctl_ops	= &vim2m_ioctl_ops,
 	.minor		= -1,
-	.release	= video_device_release_empty,
+	.release	= vim2m_device_release,
 	.device_caps	= V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING,
 };
 
@@ -1298,13 +1307,13 @@ static int vim2m_probe(struct platform_device *pdev)
 	struct video_device *vfd;
 	int ret;
 
-	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
-		return ret;
+		goto error_free;
 
 	atomic_set(&dev->num_inst, 0);
 	mutex_init(&dev->dev_mutex);
@@ -1317,7 +1326,7 @@ static int vim2m_probe(struct platform_device *pdev)
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-		goto unreg_v4l2;
+		goto error_v4l2;
 	}
 
 	video_set_drvdata(vfd, dev);
@@ -1330,7 +1339,7 @@ static int vim2m_probe(struct platform_device *pdev)
 	if (IS_ERR(dev->m2m_dev)) {
 		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
 		ret = PTR_ERR(dev->m2m_dev);
-		goto unreg_dev;
+		goto error_dev;
 	}
 
 #ifdef CONFIG_MEDIA_CONTROLLER
@@ -1346,27 +1355,29 @@ static int vim2m_probe(struct platform_device *pdev)
 						 MEDIA_ENT_F_PROC_VIDEO_SCALER);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller\n");
-		goto unreg_m2m;
+		goto error_m2m;
 	}
 
 	ret = media_device_register(&dev->mdev);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register mem2mem media device\n");
-		goto unreg_m2m_mc;
+		goto error_m2m_mc;
 	}
 #endif
 	return 0;
 
 #ifdef CONFIG_MEDIA_CONTROLLER
-unreg_m2m_mc:
+error_m2m_mc:
 	v4l2_m2m_unregister_media_controller(dev->m2m_dev);
-unreg_m2m:
+error_m2m:
 	v4l2_m2m_release(dev->m2m_dev);
 #endif
-unreg_dev:
+error_dev:
 	video_unregister_device(&dev->vfd);
-unreg_v4l2:
+error_v4l2:
 	v4l2_device_unregister(&dev->v4l2_dev);
+error_free:
+	kfree(dev);
 
 	return ret;
 }
@@ -1382,9 +1393,7 @@ static int vim2m_remove(struct platform_device *pdev)
 	v4l2_m2m_unregister_media_controller(dev->m2m_dev);
 	media_device_cleanup(&dev->mdev);
 #endif
-	v4l2_m2m_release(dev->m2m_dev);
 	video_unregister_device(&dev->vfd);
-	v4l2_device_unregister(&dev->v4l2_dev);
 
 	return 0;
 }
-- 
2.20.1

