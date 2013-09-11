Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:28334 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3IKKR6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 06:17:58 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MSY001S4HXTJUL0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 11 Sep 2013 19:17:57 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] s5p-jpeg: Initialize vfd_decoder->vfl_dir field
Date: Wed, 11 Sep 2013 12:17:45 +0200
Message-id: <1378894665-7393-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes regression introduced in the commit
5c77879ff9ab9e7 and caused by not initializing the
vfl_dir field of the vfd_decoder instance of the struct
video_device, after the field was introduced. It precluded
calling the driver ioctls which require vfl_dir not to be
equal to VFL_DIR_RX which is defined as 0 and uninitialized
vfl_dir field is interpreted as such. In effect the unlikely()
condition in the v4l_s_fmt function failed for the ioctls that
expect is_tx to be false, which prevented the ioctl callbacks
registered by the driver from being called.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 88c5beb..1db4736 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1424,6 +1424,7 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	jpeg->vfd_decoder->release	= video_device_release;
 	jpeg->vfd_decoder->lock		= &jpeg->lock;
 	jpeg->vfd_decoder->v4l2_dev	= &jpeg->v4l2_dev;
+	jpeg->vfd_decoder->vfl_dir	= VFL_DIR_M2M;
 
 	ret = video_register_device(jpeg->vfd_decoder, VFL_TYPE_GRABBER, -1);
 	if (ret) {
-- 
1.7.9.5

