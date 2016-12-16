Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:51944 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760687AbcLPLsD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 06:48:03 -0500
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kyungmin.park@samsung.com, jtp.park@samsung.com,
        mchehab@kernel.org, mchehab@osg.samsung.com,
        hans.verkuil@cisco.com, krzk@kernel.org, kgene@kernel.org,
        javier@osg.samsung.com, Smitha T Murthy <smitha.t@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 2/2] media: s5p-mfc: fix MMAP of mfc buffer during reqbufs
Date: Fri, 16 Dec 2016 17:18:35 +0530
Message-id: <1481888915-19624-3-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1481888915-19624-1-git-send-email-pankaj.dubey@samsung.com>
References: <1481888915-19624-1-git-send-email-pankaj.dubey@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Smitha T Murthy <smitha.t@samsung.com>

It has been observed on ARM64 based Exynos SoC, if IOMMU is not enabled
and we try to use reserved memory for MFC, reqbufs fails with below
mentioned error
---------------------------------------------------------------------------
V4L2 Codec decoding example application
Kamil Debski <k.debski@samsung.com>
Copyright 2012 Samsung Electronics Co., Ltd.

Opening MFC.
(mfc.c:mfc_open:58): MFC Info (/dev/video0): driver="s5p-mfc" \
bus_info="platform:12c30000.mfc0" card="s5p-mfc-dec" fd=0x4[
42.339165] Remapping memory failed, error: -6

MFC Open Success.
(main.c:main:711): Successfully opened all necessary files and devices
(mfc.c:mfc_dec_setup_output:103): Setup MFC decoding OUTPUT buffer \
size=4194304 (requested=4194304)
(mfc.c:mfc_dec_setup_output:120): Number of MFC OUTPUT buffers is 2 \
(requested 2)

[App] Out buf phy : 0x00000000, virt : 0xffffffff
Output Length is = 0x300000
Error (mfc.c:mfc_dec_setup_output:145): Failed to MMAP MFC OUTPUT buffer
-------------------------------------------------------------------------
This is because the device requesting for memory is mfc0.left not the parent mfc0.
Hence setting of alloc_devs need to be done only if IOMMU is enabled
and in that case both the left and right device is treated as mfc0 only.

Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
[pankaj.dubey: debugging issue and formatting commit message]
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 17 ++++++++++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 18 +++++++++++-------
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 52081dd..9cfca5d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -30,6 +30,7 @@
 #include "s5p_mfc_intr.h"
 #include "s5p_mfc_opr.h"
 #include "s5p_mfc_pm.h"
+#include "s5p_mfc_iommu.h"
 
 static struct s5p_mfc_fmt formats[] = {
 	{
@@ -930,16 +931,18 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 	    vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		psize[0] = ctx->luma_size;
 		psize[1] = ctx->chroma_size;
-
-		if (IS_MFCV6_PLUS(dev))
-			alloc_devs[0] = ctx->dev->mem_dev_l;
-		else
-			alloc_devs[0] = ctx->dev->mem_dev_r;
-		alloc_devs[1] = ctx->dev->mem_dev_l;
+		if (exynos_is_iommu_available(&dev->plat_dev->dev)) {
+			if (IS_MFCV6_PLUS(dev))
+				alloc_devs[0] = ctx->dev->mem_dev_l;
+			else
+				alloc_devs[0] = ctx->dev->mem_dev_r;
+			alloc_devs[1] = ctx->dev->mem_dev_l;
+		}
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
 		   ctx->state == MFCINST_INIT) {
 		psize[0] = ctx->dec_src_buf_size;
-		alloc_devs[0] = ctx->dev->mem_dev_l;
+		if (exynos_is_iommu_available(&dev->plat_dev->dev))
+			alloc_devs[0] = ctx->dev->mem_dev_l;
 	} else {
 		mfc_err("This video node is dedicated to decoding. Decoding not initialized\n");
 		return -EINVAL;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index fcc2e05..eb8f06d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -30,6 +30,7 @@
 #include "s5p_mfc_enc.h"
 #include "s5p_mfc_intr.h"
 #include "s5p_mfc_opr.h"
+#include "s5p_mfc_iommu.h"
 
 #define DEF_SRC_FMT_ENC	V4L2_PIX_FMT_NV12M
 #define DEF_DST_FMT_ENC	V4L2_PIX_FMT_H264
@@ -1832,7 +1833,8 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		if (*buf_count > MFC_MAX_BUFFERS)
 			*buf_count = MFC_MAX_BUFFERS;
 		psize[0] = ctx->enc_dst_buf_size;
-		alloc_devs[0] = ctx->dev->mem_dev_l;
+		if (exynos_is_iommu_available(&dev->plat_dev->dev))
+			alloc_devs[0] = ctx->dev->mem_dev_l;
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (ctx->src_fmt)
 			*plane_count = ctx->src_fmt->num_planes;
@@ -1847,12 +1849,14 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		psize[0] = ctx->luma_size;
 		psize[1] = ctx->chroma_size;
 
-		if (IS_MFCV6_PLUS(dev)) {
-			alloc_devs[0] = ctx->dev->mem_dev_l;
-			alloc_devs[1] = ctx->dev->mem_dev_l;
-		} else {
-			alloc_devs[0] = ctx->dev->mem_dev_r;
-			alloc_devs[1] = ctx->dev->mem_dev_r;
+		if (exynos_is_iommu_available(&dev->plat_dev->dev)) {
+			if (IS_MFCV6_PLUS(dev)) {
+				alloc_devs[0] = ctx->dev->mem_dev_l;
+				alloc_devs[1] = ctx->dev->mem_dev_l;
+			} else {
+				alloc_devs[0] = ctx->dev->mem_dev_r;
+				alloc_devs[1] = ctx->dev->mem_dev_r;
+			}
 		}
 	} else {
 		mfc_err("invalid queue type: %d\n", vq->type);
-- 
2.7.4

