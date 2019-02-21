Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEE3C10F08
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9501D206A3
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfBUOV7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 09:21:59 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:44065 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbfBUOV4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 09:21:56 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id wpETg3zIdLMwIwpEYg1DUp; Thu, 21 Feb 2019 15:21:54 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5/7] vim2m: replace devm_kzalloc by kzalloc
Date:   Thu, 21 Feb 2019 15:21:46 +0100
Message-Id: <20190221142148.3412-6-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
References: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfKkiTtITKTCYaPqL5gMAGSWSW0EcLRzFNnF7FJn8rgEH9dHSuZsDLJ/WbjPN07V9kdSWHGOpvIVwOWpKyvSXg9nnggH3bdmt/MxLf2XPk3UsdpWotqmm
 S0kBcxeSTAlhQRQmPfO/qZCQYSgfRDfZ+4XDfbgqV8uB1/ZxtfJS/CIpCN/Ds9BxYZKcO5QG7LkigCxChmXa+M+3WQ87uU9iuKq7WXTAfOfGvmCZgbkXDyH/
 TQ5gEDk4sj61b570XFrW7g7ny6MGDQn29twKSGtRmCHJAd/4Aj3bfuKzwBUNkSYKdIM/ptOaB2+5JUu/5clLQA==
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
---
 drivers/media/platform/vim2m.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index a27d3052bb62..bfb3e3eb48d1 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1087,6 +1087,16 @@ static int vim2m_release(struct file *file)
 	return 0;
 }
 
+static void vim2m_device_release(struct video_device *vdev)
+{
+	struct vim2m_dev *dev = container_of(vdev, struct vim2m_dev, vfd);
+
+	dprintk(dev, "Releasing last dev\n");
+	v4l2_device_unregister(&dev->v4l2_dev);
+	v4l2_m2m_release(dev->m2m_dev);
+	kfree(dev);
+}
+
 static const struct v4l2_file_operations vim2m_fops = {
 	.owner		= THIS_MODULE,
 	.open		= vim2m_open,
@@ -1102,7 +1112,7 @@ static const struct video_device vim2m_videodev = {
 	.fops		= &vim2m_fops,
 	.ioctl_ops	= &vim2m_ioctl_ops,
 	.minor		= -1,
-	.release	= video_device_release_empty,
+	.release	= vim2m_device_release,
 	.device_caps	= V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING,
 };
 
@@ -1123,13 +1133,13 @@ static int vim2m_probe(struct platform_device *pdev)
 	struct video_device *vfd;
 	int ret;
 
-	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
-		return ret;
+		goto unreg_free;
 
 	atomic_set(&dev->num_inst, 0);
 	mutex_init(&dev->dev_mutex);
@@ -1192,6 +1202,8 @@ static int vim2m_probe(struct platform_device *pdev)
 	video_unregister_device(&dev->vfd);
 unreg_v4l2:
 	v4l2_device_unregister(&dev->v4l2_dev);
+unreg_free:
+	kfree(dev);
 
 	return ret;
 }
@@ -1207,9 +1219,7 @@ static int vim2m_remove(struct platform_device *pdev)
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

