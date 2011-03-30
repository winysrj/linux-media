Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59014 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab1C3HBI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 03:01:08 -0400
Date: Wed, 30 Mar 2011 09:00:48 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/2] media: s5p-hdmi: add support for frame buffer emulator
In-reply-to: <1301468448-25524-1-git-send-email-m.szyprowski@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	t.stanislaws@samsung.com
Message-id: <1301468448-25524-3-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1301468448-25524-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add support for generic framebuffer emulator.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-tv/Kconfig       |    1 +
 drivers/media/video/s5p-tv/mixer.h       |    2 ++
 drivers/media/video/s5p-tv/mixer_video.c |   10 ++++++++++
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-tv/Kconfig b/drivers/media/video/s5p-tv/Kconfig
index 3b9e543..bac92cc 100644
--- a/drivers/media/video/s5p-tv/Kconfig
+++ b/drivers/media/video/s5p-tv/Kconfig
@@ -37,6 +37,7 @@ config VIDEO_SAMSUNG_S5P_MIXER
 	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
 	default y
 	select VIDEOBUF2_S5P_IOMMU
+	select VIDEOBUF2_FB
 	help
 	  Mixer driver for Samsung ARM based SoC.
 
diff --git a/drivers/media/video/s5p-tv/mixer.h b/drivers/media/video/s5p-tv/mixer.h
index 9c42289..d975dbf 100644
--- a/drivers/media/video/s5p-tv/mixer.h
+++ b/drivers/media/video/s5p-tv/mixer.h
@@ -134,6 +134,8 @@ struct mxr_layer_ops {
 struct mxr_layer {
 	/** parent mixer device */
 	struct mxr_device *mdev;
+	/** frame buffer emulator */
+	void *fb;
 	/** layer index (unique identifier) */
 	int idx;
 	/** callbacks for layer methods */
diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index f23475a..549f5fb 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -17,6 +17,7 @@
 #include <media/v4l2-ioctl.h>
 #include <linux/videodev2.h>
 #include <media/videobuf2-s5p-iommu.h>
+#include <media/videobuf2-fb.h>
 #include <linux/mm.h>
 #include <linux/version.h>
 #include <linux/timer.h>
@@ -282,6 +283,8 @@ static int mxr_g_fmt(struct file *file, void *priv,
 	f->fmt.pix.field	= V4L2_FIELD_NONE;
 	f->fmt.pix.pixelformat	= layer->fmt->fourcc;
 
+	f->fmt.pix_mp.plane_fmt[0].sizeimage = f->fmt.pix.width * f->fmt.pix.height * 2;
+
 	return 0;
 }
 
@@ -773,11 +776,18 @@ int mxr_base_layer_register(struct mxr_layer *layer)
 	else
 		mxr_info(mdev, "registered layer %s as /dev/video%d\n",
 			layer->vfd.name, layer->vfd.num);
+
+	layer->fb = vb2_fb_register(&layer->vb_queue, &layer->vfd);
+	if (PTR_ERR(layer->fb))
+		layer->fb = NULL;
+
 	return ret;
 }
 
 void mxr_base_layer_unregister(struct mxr_layer *layer)
 {
+	if (layer->fb)
+		vb2_fb_unregister(layer->fb);
 	video_unregister_device(&layer->vfd);
 }
 
-- 
1.7.1.569.g6f426
