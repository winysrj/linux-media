Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:39793 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728922AbeKOSXP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 13:23:15 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: vim2m/vicodec: set device_caps in video_device struct
Message-ID: <26edd663-20f2-014c-b628-2d6bb10aad8b@xs4all.nl>
Date: Thu, 15 Nov 2018 09:16:22 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of setting device_caps/capabilities in the querycap ioctl, set
it in struct video_device instead.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 72245183b077..35703c251d1b 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -387,11 +387,6 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strncpy(cap->card, VICODEC_NAME, sizeof(cap->card) - 1);
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 			"platform:%s", VICODEC_NAME);
-	cap->device_caps =  V4L2_CAP_STREAMING |
-			    (multiplanar ?
-			     V4L2_CAP_VIDEO_M2M_MPLANE :
-			     V4L2_CAP_VIDEO_M2M);
-	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }

@@ -1303,6 +1298,8 @@ static int vicodec_probe(struct platform_device *pdev)
 	vfd->lock = &dev->enc_mutex;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	strscpy(vfd->name, "vicodec-enc", sizeof(vfd->name));
+	vfd->device_caps = V4L2_CAP_STREAMING |
+		(multiplanar ? V4L2_CAP_VIDEO_M2M_MPLANE : V4L2_CAP_VIDEO_M2M);
 	v4l2_disable_ioctl(vfd, VIDIOC_DECODER_CMD);
 	v4l2_disable_ioctl(vfd, VIDIOC_TRY_DECODER_CMD);
 	video_set_drvdata(vfd, dev);
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 9d1222f489b8..644f81568351 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -428,8 +428,6 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 			"platform:%s", MEM2MEM_NAME);
-	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
-	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }

@@ -991,6 +989,7 @@ static const struct video_device vim2m_videodev = {
 	.ioctl_ops	= &vim2m_ioctl_ops,
 	.minor		= -1,
 	.release	= video_device_release_empty,
+	.device_caps	= V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING,
 };

 static const struct v4l2_m2m_ops m2m_ops = {
