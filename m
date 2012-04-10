Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19427 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758725Ab2DJNKy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 09:10:54 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M290051MLYALQ70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:10:58 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2900ENCLY3XY@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:10:51 +0100 (BST)
Date: Tue, 10 Apr 2012 15:10:43 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 09/13] v4l: s5p-tv: mixer: support for dmabuf importing
In-reply-to: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com, mchehab@redhat.com
Message-id: <1334063447-16824-10-git-send-email-t.stanislaws@samsung.com>
References: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enhances s5p-tv with support for DMABUF importing via
V4L2_MEMORY_DMABUF memory type.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-tv/Kconfig       |    1 +
 drivers/media/video/s5p-tv/mixer_video.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-tv/Kconfig b/drivers/media/video/s5p-tv/Kconfig
index f248b28..2e80126 100644
--- a/drivers/media/video/s5p-tv/Kconfig
+++ b/drivers/media/video/s5p-tv/Kconfig
@@ -10,6 +10,7 @@ config VIDEO_SAMSUNG_S5P_TV
 	bool "Samsung TV driver for S5P platform (experimental)"
 	depends on PLAT_S5P && PM_RUNTIME
 	depends on EXPERIMENTAL
+	select DMA_SHARED_BUFFER
 	default n
 	---help---
 	  Say Y here to enable selecting the TV output devices for
diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index f7ca5cc..6b45d93 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -1074,7 +1074,7 @@ struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
 
 	layer->vb_queue = (struct vb2_queue) {
 		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
-		.io_modes = VB2_MMAP | VB2_USERPTR,
+		.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF,
 		.drv_priv = layer,
 		.buf_struct_size = sizeof(struct mxr_buffer),
 		.ops = &mxr_video_qops,
-- 
1.7.5.4

