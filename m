Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:62716 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab2HNPhC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 11:37:02 -0400
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8R003Y94PHBPE0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:37:01 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8R004J44MBC810@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:37:01 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de, dmitriyz@google.com,
	s.nawrocki@samsung.com, k.debski@samsung.com
Subject: [PATCHv8 14/26] v4l: s5p-tv: mixer: support for dmabuf importing
Date: Tue, 14 Aug 2012 17:34:44 +0200
Message-id: <1344958496-9373-15-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enhances s5p-tv with support for DMABUF importing via
V4L2_MEMORY_DMABUF memory type.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-tv/Kconfig       |    1 +
 drivers/media/video/s5p-tv/mixer_video.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

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
index e0e02cc..da5b7a5 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -1091,7 +1091,7 @@ struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
 
 	layer->vb_queue = (struct vb2_queue) {
 		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
-		.io_modes = VB2_MMAP | VB2_USERPTR,
+		.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF,
 		.drv_priv = layer,
 		.buf_struct_size = sizeof(struct mxr_buffer),
 		.ops = &mxr_video_qops,
-- 
1.7.9.5

