Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58802 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab2DJKLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 06:11:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M29005R9DNMM040@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 11:11:46 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2900K1VDND2K@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 11:11:37 +0100 (BST)
Date: Tue, 10 Apr 2012 12:11:31 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 3/3] v4l: vivi: support for dmabuf importing
In-reply-to: <1334052691-5145-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com, mchehab@redhat.com
Message-id: <1334052691-5145-4-git-send-email-t.stanislaws@samsung.com>
References: <1334052691-5145-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enhances VIVI driver with a support for importing a buffer
from DMABUF file descriptors.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig |    1 +
 drivers/media/video/vivi.c  |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f2479c5..d6294d6 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -625,6 +625,7 @@ config VIDEO_VIVI
 	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
 	select FONT_8x16
 	select VIDEOBUF2_VMALLOC
+	select DMA_SHARED_BUFFER
 	default n
 	---help---
 	  Enables a virtual video driver. This device shows a color bar
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 5e8b071..489d685 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1289,7 +1289,7 @@ static int __init vivi_create_instance(int inst)
 	q = &dev->vb_vidq;
 	memset(q, 0, sizeof(dev->vb_vidq));
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
 	q->drv_priv = dev;
 	q->buf_struct_size = sizeof(struct vivi_buffer);
 	q->ops = &vivi_video_qops;
-- 
1.7.5.4

