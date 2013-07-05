Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25258 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab3GEHjL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jul 2013 03:39:11 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MPG00AFWD71R820@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 05 Jul 2013 08:39:08 +0100 (BST)
Received: from [106.120.53.16] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MPG00GTOD97HG00@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 05 Jul 2013 08:39:08 +0100 (BST)
Message-id: <51D6781A.2000202@samsung.com>
Date: Fri, 05 Jul 2013 09:39:06 +0200
From: Mateusz Krawczuk <m.krawczuk@samsung.com>
MIME-version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] media: s5p-tv: Fix Warn on driver probe
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 From 2cbf0f259fe24d0e3fe9f5b45036dcae3ffb6213 Mon Sep 17 00:00:00 2001
From: Mateusz Krawczuk<m.krawczuk@samsung.com>
Date: Wed, 3 Jul 2013 14:51:45 +0200
Subject: [PATCH] media: s5p-tv: Fix Warn on driver probe

The timestamp_type field in struct vb2_queue wasn`t initalized at s5p-tv probe.
This caused warn on message at boot. This patch fixed this issue.

Signed-off-by: Mateusz Krawczuk<m.krawczuk@partner.samsung.com>
Acked-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
---
  drivers/media/platform/s5p-tv/mixer_video.c |    1 +
  1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 641b1f0..87e3b0a 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -1125,6 +1125,7 @@ struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
  		.buf_struct_size = sizeof(struct mxr_buffer),
  		.ops = &mxr_video_qops,
  		.mem_ops = &vb2_dma_contig_memops,
+		.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC,
  	};
  
  	return layer;
-- 1.7.9.5

