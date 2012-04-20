Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22793 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab2DTOpk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 10:45:40 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 20 Apr 2012 16:45:33 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv5 12/13] v4l: s5p-tv: mixer: support for dmabuf importing
In-reply-to: <1334933134-4688-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, linux-doc@vger.kernel.org,
	g.liakhovetski@gmx.de
Message-id: <1334933134-4688-13-git-send-email-t.stanislaws@samsung.com>
References: <1334933134-4688-1-git-send-email-t.stanislaws@samsung.com>
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

