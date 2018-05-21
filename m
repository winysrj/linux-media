Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44476 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752986AbeEURC3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 13:02:29 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v10 15/16] v4l: Add V4L2_CAP_FENCES to drivers
Date: Mon, 21 May 2018 13:59:45 -0300
Message-Id: <20180521165946.11778-16-ezequiel@collabora.com>
In-Reply-To: <20180521165946.11778-1-ezequiel@collabora.com>
References: <20180521165946.11778-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Drivers that use videobuf2 are capable of using fences and
should report that to userspace.

v10: - Add CAPS_FENCES to drivers that don't use fh->m2m_ctx.
     - Keep the ifdef V4L2_MEM2MEM_DEV.
     - Set CAPS_FENCES after vidioc_querycap.
v9: Add in the core.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |  3 ++-
 drivers/media/platform/m2m-deinterlace.c           |  3 ++-
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c       |  3 ++-
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c |  2 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |  3 ++-
 drivers/media/platform/mx2_emmaprp.c               |  3 ++-
 drivers/media/platform/qcom/venus/vdec.c           |  3 ++-
 drivers/media/platform/qcom/venus/venc.c           |  3 ++-
 drivers/media/platform/sh_veu.c                    |  3 ++-
 drivers/media/v4l2-core/v4l2-ioctl.c               | 24 +++++++++++++++++++++-
 10 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index e9ff27949a91..fbf072c8aedd 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -298,7 +298,8 @@ static int gsc_m2m_querycap(struct file *file, void *fh,
 	strlcpy(cap->card, GSC_MODULE_NAME " gscaler", sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(&gsc->pdev->dev));
-	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE;
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE |
+			   V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 1e4195144f39..b7421de1268f 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -461,7 +461,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 	 * and are scheduled for removal.
 	 */
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
-			   V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
+			   V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING |
+			   V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
index 583d47724ee8..7aba2ba128ba 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
@@ -1242,7 +1242,8 @@ int mtk_mdp_register_m2m_device(struct mtk_mdp_dev *mdp)
 		ret = -ENOMEM;
 		goto err_video_alloc;
 	}
-	mdp->vdev->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
+	mdp->vdev->device_caps = V4L2_CAP_FENCES | V4L2_CAP_VIDEO_M2M_MPLANE |
+				 V4L2_CAP_STREAMING;
 	mdp->vdev->fops = &mtk_mdp_m2m_fops;
 	mdp->vdev->ioctl_ops = &mtk_mdp_m2m_ioctl_ops;
 	mdp->vdev->release = video_device_release;
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
index 4334b7394861..75318a4129ea 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
@@ -321,7 +321,7 @@ static int mtk_vcodec_probe(struct platform_device *pdev)
 	vfd_dec->v4l2_dev	= &dev->v4l2_dev;
 	vfd_dec->vfl_dir	= VFL_DIR_M2M;
 	vfd_dec->device_caps	= V4L2_CAP_VIDEO_M2M_MPLANE |
-			V4L2_CAP_STREAMING;
+			V4L2_CAP_STREAMING | V4L2_CAP_FENCES;
 
 	snprintf(vfd_dec->name, sizeof(vfd_dec->name), "%s",
 		MTK_VCODEC_DEC_NAME);
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
index 83f859e8509c..1c9d4e7262bb 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
@@ -339,7 +339,8 @@ static int mtk_vcodec_probe(struct platform_device *pdev)
 	vfd_enc->v4l2_dev       = &dev->v4l2_dev;
 	vfd_enc->vfl_dir        = VFL_DIR_M2M;
 	vfd_enc->device_caps	= V4L2_CAP_VIDEO_M2M_MPLANE |
-					V4L2_CAP_STREAMING;
+					V4L2_CAP_STREAMING |
+					V4L2_CAP_FENCES;
 
 	snprintf(vfd_enc->name, sizeof(vfd_enc->name), "%s",
 		 MTK_VCODEC_ENC_NAME);
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 5a8eff60e95f..230ad00fc62d 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -401,7 +401,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
 	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
-	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING |
+			   V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 8d7b4fc95880..9da748d05bd9 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1099,7 +1099,8 @@ static int vdec_probe(struct platform_device *pdev)
 	vdev->ioctl_ops = &vdec_ioctl_ops;
 	vdev->vfl_dir = VFL_DIR_M2M;
 	vdev->v4l2_dev = &core->v4l2_dev;
-	vdev->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
+	vdev->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING |
+			    V4L2_CAP_FENCES;
 
 	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
 	if (ret)
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 713c79ba9639..41b25ef2d4dc 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -1243,7 +1243,8 @@ static int venc_probe(struct platform_device *pdev)
 	vdev->ioctl_ops = &venc_ioctl_ops;
 	vdev->vfl_dir = VFL_DIR_M2M;
 	vdev->v4l2_dev = &core->v4l2_dev;
-	vdev->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
+	vdev->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING |
+			    V4L2_CAP_FENCES;
 
 	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
 	if (ret)
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 1a0cde017fdf..4ad7ec5a197a 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -351,7 +351,8 @@ static int sh_veu_querycap(struct file *file, void *priv,
 	strlcpy(cap->driver, "sh-veu", sizeof(cap->driver));
 	strlcpy(cap->card, "sh-mobile VEU", sizeof(cap->card));
 	strlcpy(cap->bus_info, "platform:sh-veu", sizeof(cap->bus_info));
-	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING |
+			   V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 2135ac235a96..4c5e95a0fe6f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -29,6 +29,7 @@
 #include <media/v4l2-device.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/v4l2-mc.h>
+#include <media/v4l2-mem2mem.h>
 
 #include <trace/events/v4l2.h>
 
@@ -1002,6 +1003,8 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 {
 	struct v4l2_capability *cap = (struct v4l2_capability *)arg;
 	struct video_device *vfd = video_devdata(file);
+	struct v4l2_fh *vfh =
+		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 	int ret;
 
 	cap->version = LINUX_VERSION_CODE;
@@ -1010,7 +1013,26 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 
 	ret = ops->vidioc_querycap(file, fh, cap);
 
-	cap->capabilities |= V4L2_CAP_EXT_PIX_FORMAT;
+	/* If a streaming device has a queue or a m2m context,
+	 * then the device supports explicit sync.
+	 */
+	if (cap->device_caps & V4L2_CAP_STREAMING) {
+		/*
+		 * TODO: Drop these additional queue lock
+		 * checks once we make vb2_queue lock
+		 * mandatory.
+		 */
+		if (vfd->queue && vfd->queue->lock)
+			cap->device_caps |= V4L2_CAP_FENCES;
+#if IS_ENABLED(CONFIG_V4L2_MEM2MEM_DEV)
+		if (vfh && vfh->m2m_ctx &&
+		    vfh->m2m_ctx->cap_q_ctx.q.lock &&
+		    vfh->m2m_ctx->out_q_ctx.q.lock)
+			cap->device_caps |= V4L2_CAP_FENCES;
+#endif
+	}
+	cap->capabilities |= cap->device_caps | V4L2_CAP_EXT_PIX_FORMAT;
+
 	/*
 	 * Drivers MUST fill in device_caps, so check for this and
 	 * warn if it was forgotten.
-- 
2.16.3
