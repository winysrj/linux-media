Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:39024 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab3JJIqB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Oct 2013 04:46:01 -0400
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	m.chehab@samsung.com, s.nawrocki@samsung.com
Cc: sw0312.kim@samsung.com
Subject: [PATCH] s5p-jpeg: fix encoder and decoder video dev names
Date: Thu, 10 Oct 2013 17:45:56 +0900
Message-id: <1381394756-17651-1-git-send-email-sw0312.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is hard to distinguish between decoder and encoder video device
because their names are same. So this patch fixes the names.

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 15d2396..d5b4a0d 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1387,8 +1387,8 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 		ret = -ENOMEM;
 		goto vb2_allocator_rollback;
 	}
-	strlcpy(jpeg->vfd_encoder->name, S5P_JPEG_M2M_NAME,
-		sizeof(jpeg->vfd_encoder->name));
+	snprintf(jpeg->vfd_encoder->name, sizeof(jpeg->vfd_encoder->name),
+				"%s-enc", S5P_JPEG_M2M_NAME);
 	jpeg->vfd_encoder->fops		= &s5p_jpeg_fops;
 	jpeg->vfd_encoder->ioctl_ops	= &s5p_jpeg_ioctl_ops;
 	jpeg->vfd_encoder->minor	= -1;
@@ -1415,8 +1415,8 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 		ret = -ENOMEM;
 		goto enc_vdev_register_rollback;
 	}
-	strlcpy(jpeg->vfd_decoder->name, S5P_JPEG_M2M_NAME,
-		sizeof(jpeg->vfd_decoder->name));
+	snprintf(jpeg->vfd_decoder->name, sizeof(jpeg->vfd_decoder->name),
+				"%s-dec", S5P_JPEG_M2M_NAME);
 	jpeg->vfd_decoder->fops		= &s5p_jpeg_fops;
 	jpeg->vfd_decoder->ioctl_ops	= &s5p_jpeg_ioctl_ops;
 	jpeg->vfd_decoder->minor	= -1;
-- 
1.7.4.1

