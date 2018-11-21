Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:51892 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726016AbeKUTQG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Nov 2018 14:16:06 -0500
Subject: [PATCH v2] vim2m/vicodec: set device_caps in video_device struct
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <26edd663-20f2-014c-b628-2d6bb10aad8b@xs4all.nl>
Message-ID: <7e0e2e95-792d-1efa-c012-5e6737b219b6@xs4all.nl>
Date: Wed, 21 Nov 2018 09:42:27 +0100
MIME-Version: 1.0
In-Reply-To: <26edd663-20f2-014c-b628-2d6bb10aad8b@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of setting device_caps/capabilities in the querycap ioctl, set
it in struct video_device instead.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Changes in v2: vfd->device_caps was only set for the first of the two video
devices. Set it for the second video_device as well.
---
 drivers/media/platform/vicodec/vicodec-core.c | 9 ++++-----
 drivers/media/platform/vim2m.c                | 3 +--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index b292cff26c86..9b6416ba5901 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -397,11 +397,6 @@ static int vidioc_querycap(struct file *file, void *priv,
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

@@ -1311,6 +1306,8 @@ static int vicodec_probe(struct platform_device *pdev)
 	vfd->lock = &dev->enc_mutex;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	strscpy(vfd->name, "vicodec-enc", sizeof(vfd->name));
+	vfd->device_caps = V4L2_CAP_STREAMING |
+		(multiplanar ? V4L2_CAP_VIDEO_M2M_MPLANE : V4L2_CAP_VIDEO_M2M);
 	v4l2_disable_ioctl(vfd, VIDIOC_DECODER_CMD);
 	v4l2_disable_ioctl(vfd, VIDIOC_TRY_DECODER_CMD);
 	video_set_drvdata(vfd, dev);
@@ -1327,6 +1324,8 @@ static int vicodec_probe(struct platform_device *pdev)
 	vfd = &dev->dec_vfd;
 	vfd->lock = &dev->dec_mutex;
 	vfd->v4l2_dev = &dev->v4l2_dev;
+	vfd->device_caps = V4L2_CAP_STREAMING |
+		(multiplanar ? V4L2_CAP_VIDEO_M2M_MPLANE : V4L2_CAP_VIDEO_M2M);
 	strscpy(vfd->name, "vicodec-dec", sizeof(vfd->name));
 	v4l2_disable_ioctl(vfd, VIDIOC_ENCODER_CMD);
 	v4l2_disable_ioctl(vfd, VIDIOC_TRY_ENCODER_CMD);
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index d82db738f174..035c7b7c8d87 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -438,8 +438,6 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 			"platform:%s", MEM2MEM_NAME);
-	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
-	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }

@@ -999,6 +997,7 @@ static const struct video_device vim2m_videodev = {
 	.ioctl_ops	= &vim2m_ioctl_ops,
 	.minor		= -1,
 	.release	= video_device_release_empty,
+	.device_caps	= V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING,
 };

 static const struct v4l2_m2m_ops m2m_ops = {
-- 
2.19.1
