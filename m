Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A817C282D7
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 03:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49A1020870
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 03:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731098AbfAaDOF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 22:14:05 -0500
Received: from kozue.soulik.info ([108.61.200.231]:36642 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfAaDOE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 22:14:04 -0500
Received: from misaki.sumomo.pri (unknown [IPv6:2001:470:b30d:2:c604:15ff:0:91f])
        by kozue.soulik.info (Postfix) with ESMTPA id 3FDC61018B8;
        Thu, 31 Jan 2019 12:15:07 +0900 (JST)
From:   ayaka <ayaka@soulik.info>
To:     linux-media@vger.kernel.org
Cc:     Randy 'ayaka' Li <ayaka@soulik.info>, acourbot@chromium.org,
        nicolas@ndufresne.ca, paul.kocialkowski@bootlin.com,
        randy.li@rock-chips.com, jernej.skrabec@gmail.com,
        linux-kernel@vger.kernel.org, joro@8bytes.org,
        linux-arm-kernel@lists.infradead.org, mchehab@kernel.org,
        maxime.ripard@bootlin.com, hverkuil@xs4all.nl,
        ezequiel@collabora.com, thomas.petazzoni@bootlin.com,
        linux-rockchip@lists.infradead.org
Subject: [PATCH 2/4] [WIP] staging: video: rockchip: vdpu2
Date:   Thu, 31 Jan 2019 11:13:31 +0800
Message-Id: <20190131031333.11905-3-ayaka@soulik.info>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131031333.11905-1-ayaka@soulik.info>
References: <20190131031333.11905-1-ayaka@soulik.info>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Randy 'ayaka' Li <ayaka@soulik.info>

It doesn't work yet, I am suffering unknow power or
clock problem, but the vendor driver I post to ML
would work.

I want to put the implementation of those v4l2 ioctl
which related to device in echo device's files, but
the current inheritance looks ugly.

TODO:
qp table

Signed-off-by: Randy Li <randy.li@rock-chips.com>
Signed-off-by: Randy Li <ayaka@soulik.info>
---
 drivers/staging/rockchip-mpp/Makefile        |   2 +-
 drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c | 588 ++++++++++------
 drivers/staging/rockchip-mpp/vdpu2/hal.h     |  52 ++
 drivers/staging/rockchip-mpp/vdpu2/mpeg2.c   | 227 ++++++
 drivers/staging/rockchip-mpp/vdpu2/regs.h    | 699 +++++++++++++++++++
 5 files changed, 1361 insertions(+), 207 deletions(-)
 create mode 100644 drivers/staging/rockchip-mpp/vdpu2/hal.h
 create mode 100644 drivers/staging/rockchip-mpp/vdpu2/mpeg2.c
 create mode 100644 drivers/staging/rockchip-mpp/vdpu2/regs.h

diff --git a/drivers/staging/rockchip-mpp/Makefile b/drivers/staging/rockchip-mpp/Makefile
index 36d2958ea7f4..5aa0c596b706 100644
--- a/drivers/staging/rockchip-mpp/Makefile
+++ b/drivers/staging/rockchip-mpp/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 rk-mpp-service-objs := mpp_service.o
 rk-mpp-device-objs := mpp_dev_common.o
-rk-mpp-vdpu2-objs := mpp_dev_vdpu2.o
+rk-mpp-vdpu2-objs := mpp_dev_vdpu2.o vdpu2/mpeg2.o
 
 obj-$(CONFIG_ROCKCHIP_MPP_SERVICE) += rk-mpp-service.o
 obj-$(CONFIG_ROCKCHIP_MPP_DEVICE) += rk-mpp-device.o
diff --git a/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c b/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c
index 5789c8940543..03ed080bb35c 100644
--- a/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c
+++ b/drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c
@@ -24,61 +24,18 @@
 #include <linux/uaccess.h>
 #include <soc/rockchip/pm_domains.h>
 
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mem2mem.h>
+
 #include "mpp_debug.h"
 #include "mpp_dev_common.h"
+#include "vdpu2/hal.h"
 
 #define RKVDPU2_DRIVER_NAME		"mpp_vdpu2"
 #define RKVDPU2_NODE_NAME		"vpu-service"
 
-/* The maximum registers number of all the version */
-#define ROCKCHIP_VDPU2_REG_NUM		159
-
-/* The first register of the decoder is Reg50(0x000c8) */
-#define RKVDPU2_REG_DEC_CTRL			0x0c8
-#define RKVDPU2_REG_DEC_CTRL_INDEX		(50)
-
-#define RKVDPU2_REG_SYS_CTRL			0x0d4
-#define RKVDPU2_REG_SYS_CTRL_INDEX		(53)
-#define		RKVDPU2_GET_FORMAT(x)		((x) & 0xf)
-#define		RKVDPU2_FMT_H264D		0
-#define		RKVDPU2_FMT_MPEG4D		1
-#define		RKVDPU2_FMT_H263D		2
-#define		RKVDPU2_FMT_JPEGD		3
-#define		RKVDPU2_FMT_VC1D		4
-#define		RKVDPU2_FMT_MPEG2D		5
-#define		RKVDPU2_FMT_MPEG1D		6
-#define		RKVDPU2_FMT_VP6D		7
-#define		RKVDPU2_FMT_RESERVED		8
-#define		RKVDPU2_FMT_VP7D		9
-#define		RKVDPU2_FMT_VP8D		10
-#define		RKVDPU2_FMT_AVSD		11
-
-#define RKVDPU2_REG_DEC_INT_EN			0x0dc
-#define RKVDPU2_REG_DEC_INT_EN_INDEX		(55)
-#define		RKVDPU2_INT_TIMEOUT		BIT(13)
-#define		RKVDPU2_INT_STRM_ERROR		BIT(12)
-#define		RKVDPU2_INT_SLICE		BIT(9)
-#define		RKVDPU2_INT_ASO_ERROR		BIT(8)
-#define		RKVDPU2_INT_BUF_EMPTY		BIT(6)
-#define		RKVDPU2_INT_BUS_ERROR		BIT(5)
-#define		RKVDPU2_DEC_INT			BIT(4)
-#define		RKVDPU2_DEC_IRQ_DIS		BIT(1)
-#define		RKVDPU2_DEC_INT_RAW		BIT(0)
-
-#define RKVDPU2_REG_DEC_DEV_CTRL		0x0e4
-#define RKVDPU2_REG_DEC_DEV_CTRL_INDEX		(57)
-#define		RKVDPU2_DEC_CLOCK_GATE_EN	BIT(4)
-#define		RKVDPU2_DEC_START		BIT(0)
-
-#define RKVDPU2_REG59				0x0ec
-#define RKVDPU2_REG59_INDEX			(59)
-
-#define RKVDPU2_REG_DIR_MV_BASE                 0x0f8
-#define RKVDPU2_REG_DIR_MV_BASE_INDEX           (62)
-
-#define RKVDPU2_REG_STREAM_RLC_BASE		0x100
-#define RKVDPU2_REG_STREAM_RLC_BASE_INDEX	(64)
-
 #define to_rkvdpu_task(ctx)		\
 		container_of(ctx, struct rkvdpu_task, mpp_task)
 #define to_rkvdpu_dev(dev)		\
@@ -102,184 +59,389 @@ struct rkvdpu_task {
 
 	u32 reg[ROCKCHIP_VDPU2_REG_NUM];
 	u32 idx;
-	struct extra_info_for_iommu ext_inf;
 
 	u32 strm_base;
 	u32 irq_status;
 };
 
-/*
- * file handle translate information
- */
-static const char trans_tbl_default[] = {
-	61, 62, 63, 64, 131, 134, 135, 148
+static struct rockchip_mpp_control vdpu_controls[] = {
+	{
+	 .codec = V4L2_PIX_FMT_MPEG2_SLICE,
+	 .id = V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS,
+	 .elem_size = sizeof(struct v4l2_ctrl_mpeg2_slice_params),
+	 },
+	{
+	 .codec = V4L2_PIX_FMT_MPEG2_SLICE,
+	 .id = V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION,
+	 .elem_size = sizeof(struct v4l2_ctrl_mpeg2_quantization),
+	 },
 };
 
-static const char trans_tbl_jpegd[] = {
-	21, 22, 61, 63, 64, 131
+static struct v4l2_pix_format_mplane fmt_out_templ[] = {
+	{
+	 .pixelformat = V4L2_PIX_FMT_MPEG2_SLICE,
+	 },
+	{.pixelformat = 0},
 };
 
-static const char trans_tbl_h264d[] = {
-	61, 63, 64, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97,
-	98, 99
+static struct v4l2_pix_format_mplane fmt_cap_templ[] = {
+	{
+	 .pixelformat = V4L2_PIX_FMT_NV12M,
+	 },
+	{.pixelformat = 0},
 };
 
-static const char trans_tbl_vc1d[] = {
-	62, 63, 64, 131, 134, 135, 145, 148
+static const struct mpp_dev_variant rkvdpu_v2_data = {
+	/* Exclude the register of the Performance counter */
+	.reg_len = 159,
+	.node_name = RKVDPU2_NODE_NAME,
+	.vfd_func = MEDIA_ENT_F_PROC_VIDEO_DECODER,
 };
 
-static const char trans_tbl_vp6d[] = {
-	61, 63, 64, 131, 136, 145
-};
+static int rkvdpu_open(struct file *filp);
 
-static const char trans_tbl_vp8d[] = {
-	61, 63, 64, 131, 136, 137, 140, 141, 142, 143, 144, 145, 146, 147, 149
+static const struct v4l2_file_operations rkvdpu_fops = {
+	.open = rkvdpu_open,
+	.release = rockchip_mpp_dev_release,
+	.poll = v4l2_m2m_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap = v4l2_m2m_fop_mmap,
 };
 
-static struct mpp_trans_info trans_rk_vdpu2[] = {
-	[RKVDPU2_FMT_H264D] = {
-		.count = sizeof(trans_tbl_h264d),
-		.table = trans_tbl_h264d,
-	},
-	[RKVDPU2_FMT_H263D] = {
-		.count = sizeof(trans_tbl_default),
-		.table = trans_tbl_default,
-	},
-	[RKVDPU2_FMT_MPEG4D] = {
-		.count = sizeof(trans_tbl_default),
-		.table = trans_tbl_default,
-	},
-	[RKVDPU2_FMT_JPEGD] = {
-		.count = sizeof(trans_tbl_jpegd),
-		.table = trans_tbl_jpegd,
-	},
-	[RKVDPU2_FMT_VC1D] = {
-		.count = sizeof(trans_tbl_vc1d),
-		.table = trans_tbl_vc1d,
-	},
-	[RKVDPU2_FMT_MPEG2D] = {
-		.count = sizeof(trans_tbl_default),
-		.table = trans_tbl_default,
-	},
-	[RKVDPU2_FMT_MPEG1D] = {
-		.count = sizeof(trans_tbl_default),
-		.table = trans_tbl_default,
-	},
-	[RKVDPU2_FMT_VP6D] = {
-		.count = sizeof(trans_tbl_vp6d),
-		.table = trans_tbl_vp6d,
-	},
-	[RKVDPU2_FMT_RESERVED] = {
-		.count = 0,
-		.table = NULL,
-	},
-	[RKVDPU2_FMT_VP7D] = {
-		.count = sizeof(trans_tbl_default),
-		.table = trans_tbl_default,
-	},
-	[RKVDPU2_FMT_VP8D] = {
-		.count = sizeof(trans_tbl_vp8d),
-		.table = trans_tbl_vp8d,
-	},
-	[RKVDPU2_FMT_AVSD] = {
-		.count = sizeof(trans_tbl_default),
-		.table = trans_tbl_default,
-	},
-};
+#if 1
+static struct v4l2_ioctl_ops rkvdpu_ioctl_ops = { 0, };
+#endif
 
-static const struct mpp_dev_variant rkvdpu_v2_data = {
-	/* Exclude the register of the Performance counter */
-	.reg_len = 159,
-	.trans_info = trans_rk_vdpu2,
-	.node_name = RKVDPU2_NODE_NAME,
+static void *rockchip_rkvdpu2_get_drv_data(struct platform_device *pdev);
+
+#if 0
+static int rockchip_mpp_queue_setup(struct vb2_queue *vq,
+				    unsigned int *num_buffers,
+				    unsigned int *num_planes,
+				    unsigned int sizes[],
+				    struct device *alloc_devs[])
+{
+	struct mpp_session *session = vb2_get_drv_priv(vq);
+	struct v4l2_pix_format_mplane pixfmt;
+	unsigned int size;
+
+	switch (vq->type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		pixfmt = &session->fmt_out;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		pixfmt = &session->fmt_cap;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (*num_planes) {
+		if (*num_planes != pixfmt->num_planes)
+			return -EINVAL;
+		for (i = 0; i < pixfmt->num_planes; ++i)
+			if (sizes[i] < pixfmt->plane_fmt[i].sizeimage)
+				return -EINVAL;
+
+		return 0;
+	}
+
+	*num_planes = pixfmt->num_planes;
+	for (i = 0; i < pixfmt->num_planes; ++i)
+		sizes[i] = pixfmt->plane_fmt[i].sizeimage;
+
+	return 0;
+}
+
+static const struct vb2_ops rkvdpu_queue_ops = {
+	.queue_setup = rockchip_mpp_queue_setup,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+	/* TODO */
+	.start_streaming = NULL,
+	.stop_streaming = NULL,
+	.buf_queue = = rockchip_mpp_buf_queue,
+	.buf_request_complete = rockchip_mpp_buf_request_complete,
 };
 
-static void *rockchip_rkvdpu2_get_drv_data(struct platform_device *pdev);
+static int rkvdpu_try_fmt_vid_out(struct file *file, void *fh,
+				  struct v4l2_format *f)
+{
+	struct rockchip_mpp_dev *mpp_dev = video_drvdata(filp);
+	struct mpp_session *session = container_of(filp->private_data,
+						   struct mpp_session, fh);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-static void *rockchip_mpp_rkvdpu_alloc_task(struct mpp_session *session,
-					    void __user *src, u32 size)
+	return 0;
+}
+
+static int rkvdpu_try_fmt_vid_cap(struct file *file, void *fh,
+				  struct v4l2_format *f)
 {
-	struct rkvdpu_task *task = NULL;
-	u32 reg_len;
-	u32 extinf_len;
-	u32 fmt = 0;
-	u32 dwsize = size / sizeof(u32);
-	int err = -EFAULT;
+	struct rockchip_mpp_dev *mpp_dev = video_drvdata(filp);
+	struct mpp_session *session = container_of(filp->private_data,
+						   struct mpp_session, fh);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	mpp_debug_enter();
+	return 0;
+}
+#endif
 
-	task = kzalloc(sizeof(*task), GFP_KERNEL);
-	if (!task)
-		return NULL;
+static int rkvdpu_s_fmt_vid_out_mplane(struct file *filp, void *priv,
+				       struct v4l2_format *f)
+{
+	struct mpp_session *session = container_of(filp->private_data,
+						   struct mpp_session, fh);
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct vb2_queue *vq;
+	int sizes = 0;
+	int i;
+
+	/* TODO: We can change width and height at streaming on */
+	vq = v4l2_m2m_get_vq(session->fh.m2m_ctx, f->type);
+	if (vb2_is_streaming(vq))
+		return -EBUSY;
+
+#if 0
+	ret = rkvdpu_try_fmt_out(filp, priv, f);
+	if (ret)
+		return ret;
+#endif
+	for (i = 0; i < pix_mp->num_planes; i++) {
+		sizes += pix_mp->plane_fmt[i].sizeimage;
+	}
+	/* strm_len is 24 bits */
+	if (sizes >= SZ_16M)
+		return -EINVAL;
 
-	mpp_dev_task_init(session, &task->mpp_task);
+	if (!pix_mp->num_planes)
+		pix_mp->num_planes = 1;
+
+	session->fmt_out = *pix_mp;
+
+	/* Copy the pixel format information from OUTPUT to CAPUTRE */
+	session->fmt_cap.pixelformat = V4L2_PIX_FMT_NV12M;
+	session->fmt_cap.width = pix_mp->width;
+	session->fmt_cap.height = pix_mp->height;
+	session->fmt_cap.colorspace = pix_mp->colorspace;
+	session->fmt_cap.ycbcr_enc = pix_mp->ycbcr_enc;
+	session->fmt_cap.xfer_func = pix_mp->xfer_func;
+	session->fmt_cap.quantization = pix_mp->quantization;
+
+	return 0;
+}
+
+static int rkvdpu_s_fmt_vid_cap_mplane(struct file *filp, void *priv,
+				       struct v4l2_format *f)
+{
+	struct mpp_session *session = container_of(filp->private_data,
+						   struct mpp_session, fh);
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct vb2_queue *vq;
+
+	vq = v4l2_m2m_get_vq(session->fh.m2m_ctx, f->type);
+	if (vb2_is_streaming(vq))
+		return -EBUSY;
+
+#if 0
+	ret = rkvdpu_try_fmt_cap(filp, priv, f);
+	if (ret)
+		return ret;
+#endif
+	switch (pix_mp->pixelformat) {
+	case V4L2_PIX_FMT_NV12M:
+		pix_mp->plane_fmt[0].bytesperline = ALIGN(pix_mp->width, 16);
+		pix_mp->plane_fmt[1].bytesperline = ALIGN(pix_mp->width, 16);
+		pix_mp->plane_fmt[0].sizeimage = ALIGN(pix_mp->width, 16) *
+		    ALIGN(pix_mp->height, 16);
+		/* Additional space for motion vector */
+		pix_mp->plane_fmt[1].sizeimage = ALIGN(pix_mp->width, 16) *
+		    ALIGN(pix_mp->height, 16);
+		pix_mp->num_planes = 2;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	session->fmt_cap = *pix_mp;
+
+	return 0;
+}
+
+#if 0
+static int rkvdpu_queue_init(void *priv, struct vb2_queue *src_vq,
+			     struct vb2_queue *dst_vq)
+{
+	struct mpp_session *session = priv;
+	int ret;
 
-	reg_len = dwsize > ROCKCHIP_VDPU2_REG_NUM ?
-		ROCKCHIP_VDPU2_REG_NUM : dwsize;
-	extinf_len = dwsize > reg_len ? (dwsize - reg_len) * 4 : 0;
+	rockchip_mpp_queue_init(priv, src_vq, dst_vq);
 
-	if (copy_from_user(task->reg, src, reg_len * 4)) {
-		mpp_err("error: copy_from_user failed in reg_init\n");
-		err = -EFAULT;
+	src_vq->ops = rkvdpu_queue_ops;
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	dst_vq->ops = rkvdpu_queue_ops;
+	return vb2_queue_init(dst_vq);
+}
+
+static int mpp_dev_open(struct file *filp)
+{
+	struct rockchip_mpp_dev *mpp_dev = video_drvdata(filp);
+	struct video_device *vdev = video_devdata(filp);
+	struct mpp_session *session = NULL;
+	int error = 0;
+
+	mpp_debug_enter();
+
+	session = rockchip_alloc_session(mpp_dev);
+	if (IS_ERR(session))
+		return PTR_ERR(session);
+
+	session->fh.m2m_ctx = v4l2_m2m_ctx_init(mpp_dev->m2m_dev, session,
+						rockchip_mpp_queue_init);
+	if (IS_ERR(session->fh.m2m_ctx)) {
+		error = PTR_ERR(session->fb.m2m_ctx);
 		goto fail;
 	}
+	v4l2_fh_init(&session->fh, vdev);
+	filp->private_data = &session->fh;
+	v4l2_fh_add(&session->fh);
 
-	fmt = RKVDPU2_GET_FORMAT(task->reg[RKVDPU2_REG_SYS_CTRL_INDEX]);
-	if (extinf_len > 0) {
-		if (likely(fmt == RKVDPU2_FMT_JPEGD)) {
-			err = copy_from_user(&task->ext_inf,
-					     (u8 *)src + size
-					     - JPEG_IOC_EXTRA_SIZE,
-					     JPEG_IOC_EXTRA_SIZE);
-		} else {
-			u32 ext_cpy = min_t(size_t, extinf_len,
-					    sizeof(task->ext_inf));
-			err = copy_from_user(&task->ext_inf,
-					     (u32 *)src + reg_len, ext_cpy);
-		}
+	/* TODO: setup default formats */
+
+	/* TODO: install v4l2 ctrl */
+	if (error) {
+		dev_err(mpp_dev->dev, "Failed to set up controls\n");
+		goto err_fh;
+	}
+
+	session->fb.ctrl_handler = session->ctrl_handler;
+
+	mpp_dev_power_on(mpp);
+	mpp_debug_leave();
 
-		if (err) {
-			mpp_err("copy_from_user failed when extra info\n");
-			err = -EFAULT;
+	return 0;
+
+err_fh:
+	v4l2_fh_del(&session->fh);
+	v4l2_fh_exit(&session->fh);
+fail:
+	kfree(session);
+	return error;
+}
+#endif
+
+static int vdpu_setup_ctrls(struct rockchip_mpp_dev *mpp_dev,
+			    struct mpp_session *session)
+{
+	struct v4l2_ctrl_handler *hdl = &session->ctrl_handler;
+	struct v4l2_ctrl *ctrl;
+	unsigned int num_ctrls = ARRAY_SIZE(vdpu_controls);
+	unsigned int i;
+
+	v4l2_ctrl_handler_init(hdl, num_ctrls);
+	if (hdl->error) {
+		v4l2_err(&mpp_dev->v4l2_dev,
+			 "Failed to initialize control handler\n");
+		return hdl->error;
+	}
+#if 0
+	ctrls_size = sizeof(ctrl) * num_ctrls + 1;
+	session->ctrls = kzalloc(ctrls_size, GFP_KERNEL);
+#endif
+
+	for (i = 0; i < num_ctrls; i++) {
+		struct v4l2_ctrl_config cfg = { };
+
+		cfg.id = vdpu_controls[i].id;
+		cfg.elem_size = vdpu_controls[i].elem_size;
+
+		ctrl = v4l2_ctrl_new_custom(hdl, &cfg, NULL);
+		if (hdl->error) {
+			v4l2_err(&mpp_dev->v4l2_dev,
+				 "Failed to create new custom %d control\n",
+				 cfg.id);
 			goto fail;
 		}
+#if 0
+		session->ctrls[i] = ctrl;
+#endif
 	}
 
-	err = mpp_reg_address_translate(session->mpp, &task->mpp_task, fmt,
-					task->reg);
-	if (err) {
-		mpp_err("error: translate reg address failed.\n");
+	session->fh.ctrl_handler = hdl;
+	v4l2_ctrl_handler_setup(hdl);
 
-		if (unlikely(debug & DEBUG_DUMP_ERR_REG))
-			mpp_debug_dump_reg_mem(task->reg,
-					       ROCKCHIP_VDPU2_REG_NUM);
-		goto fail;
+	return 0;
+fail:
+	v4l2_ctrl_handler_free(hdl);
+#if 0
+	kfree(session->ctrls);
+#endif
+	return hdl->error;
+}
+
+static int rkvdpu_open(struct file *filp)
+{
+	struct rockchip_mpp_dev *mpp_dev = video_drvdata(filp);
+	struct video_device *vdev = video_devdata(filp);
+	struct mpp_session *session = NULL;
+	/* TODO: install ctrl based on register report */
+	int error = 0;
+
+	mpp_debug_enter();
+
+	session = rockchip_mpp_alloc_session(mpp_dev, vdev);
+	if (IS_ERR_OR_NULL(session))
+		return PTR_ERR(session);
+
+	error = vdpu_setup_ctrls(mpp_dev, session);
+	if (error) {
+		kfree(session);
+		return error;
 	}
 
-	if (likely(fmt == RKVDPU2_FMT_H264D)) {
-		struct mpp_mem_region *mem_region = NULL;
-		dma_addr_t iova = 0;
-		u32 offset = task->reg[RKVDPU2_REG_DIR_MV_BASE_INDEX];
-		int fd = task->reg[RKVDPU2_REG_DIR_MV_BASE_INDEX] & 0x3ff;
+	filp->private_data = &session->fh;
 
-		offset = offset >> 10 << 4;
-		mem_region = mpp_dev_task_attach_fd(&task->mpp_task, fd);
-		if (IS_ERR(mem_region)) {
-			err = PTR_ERR(mem_region);
-			goto fail;
-		}
+	mpp_debug_leave();
+	return 0;
+}
+
+static void *rockchip_mpp_rkvdpu_alloc_task(struct mpp_session *session,
+					    void __user * src, u32 size)
+{
+	struct rkvdpu_task *task = NULL;
+	struct vb2_v4l2_buffer *src_buf;
+	u32 fmt = 0;
+	int err = -EFAULT;
 
-		iova = mem_region->iova;
-		mpp_debug(DEBUG_IOMMU, "DMV[%3d]: %3d => %pad + offset %10d\n",
-			  RKVDPU2_REG_DIR_MV_BASE_INDEX, fd, &iova, offset);
-		task->reg[RKVDPU2_REG_DIR_MV_BASE_INDEX] = iova + offset;
+	mpp_debug_enter();
+
+	task = kzalloc(sizeof(*task), GFP_KERNEL);
+	if (!task)
+		return NULL;
+
+	mpp_dev_task_init(session, &task->mpp_task);
+
+	src_buf = v4l2_m2m_next_src_buf(session->fh.m2m_ctx);
+	v4l2_ctrl_request_setup(src_buf->vb2_buf.req_obj.req,
+				&session->ctrl_handler);
+
+	fmt = session->fmt_out.pixelformat;
+	switch (fmt) {
+	case V4L2_PIX_FMT_MPEG2_SLICE:
+		err = rkvdpu_mpeg2_gen_reg(session, task->reg, src_buf);
+		break;
+	default:
+		goto fail;
 	}
 
-	task->strm_base = task->reg[RKVDPU2_REG_STREAM_RLC_BASE_INDEX];
+	if (err)
+		goto fail;
 
-	mpp_debug(DEBUG_SET_REG, "extra info cnt %u, magic %08x",
-		  task->ext_inf.cnt, task->ext_inf.magic);
-	mpp_translate_extra_info(&task->mpp_task, &task->ext_inf, task->reg);
+	v4l2_ctrl_request_complete(src_buf->vb2_buf.req_obj.req,
+				   &session->ctrl_handler);
 
 	mpp_debug_leave();
 
@@ -289,15 +451,17 @@ static void *rockchip_mpp_rkvdpu_alloc_task(struct mpp_session *session,
 	if (unlikely(debug & DEBUG_DUMP_ERR_REG))
 		mpp_debug_dump_reg_mem(task->reg, ROCKCHIP_VDPU2_REG_NUM);
 
-	mpp_dev_task_finalize(session, &task->mpp_task);
 	kfree(task);
 	return ERR_PTR(err);
 }
 
 static int rockchip_mpp_rkvdpu_prepare(struct rockchip_mpp_dev *mpp_dev,
-				       struct mpp_task *task)
+				       struct mpp_task *mpp_task)
 {
-	return -EINVAL;
+	struct rkvdpu_task *task = container_of(mpp_task, struct rkvdpu_task,
+						mpp_task);
+
+	return rkvdpu_mpeg2_prepare_buf(mpp_task->session, task->reg);
 }
 
 static int rockchip_mpp_rkvdpu_run(struct rockchip_mpp_dev *mpp_dev,
@@ -355,17 +519,21 @@ static int rockchip_mpp_rkvdpu_finish(struct rockchip_mpp_dev *mpp_dev,
 
 static int rockchip_mpp_rkvdpu_result(struct rockchip_mpp_dev *mpp_dev,
 				      struct mpp_task *mpp_task,
-				      u32 __user *dst, u32 size)
+				      u32 __user * dst, u32 size)
 {
 	struct rkvdpu_task *task = to_rkvdpu_task(mpp_task);
+	u32 err_mask;
 
-	/* FIXME may overflow the kernel */
-	if (copy_to_user(dst, task->reg, size)) {
-		mpp_err("copy_to_user failed\n");
-		return -EIO;
-	}
+	err_mask = RKVDPU2_INT_TIMEOUT
+	    | RKVDPU2_INT_STRM_ERROR
+	    | RKVDPU2_INT_ASO_ERROR
+	    | RKVDPU2_INT_BUF_EMPTY
+	    | RKVDPU2_INT_BUS_ERROR;
 
-	return 0;
+	if (err_mask & task->irq_status)
+		return VB2_BUF_STATE_ERROR;
+
+	return VB2_BUF_STATE_DONE;
 }
 
 static int rockchip_mpp_rkvdpu_free_task(struct mpp_session *session,
@@ -406,14 +574,13 @@ static irqreturn_t mpp_rkvdpu_isr(int irq, void *dev_id)
 	mpp_task = &task->mpp_task;
 	mpp_debug_time_diff(mpp_task);
 	task->irq_status = irq_status;
-	mpp_debug(DEBUG_IRQ_STATUS, "irq_status: %08x\n",
-		  task->irq_status);
+	mpp_debug(DEBUG_IRQ_STATUS, "irq_status: %08x\n", task->irq_status);
 
 	err_mask = RKVDPU2_INT_TIMEOUT
-		| RKVDPU2_INT_STRM_ERROR
-		| RKVDPU2_INT_ASO_ERROR
-		| RKVDPU2_INT_BUF_EMPTY
-		| RKVDPU2_INT_BUS_ERROR;
+	    | RKVDPU2_INT_STRM_ERROR
+	    | RKVDPU2_INT_ASO_ERROR
+	    | RKVDPU2_INT_BUF_EMPTY
+	    | RKVDPU2_INT_BUS_ERROR;
 
 	if (err_mask & task->irq_status)
 		atomic_set(&mpp_dev->reset_request, 1);
@@ -504,10 +671,19 @@ static int rockchip_mpp_rkvdpu_probe(struct platform_device *pdev)
 
 	rockchip_mpp_rkvdpu_assign_reset(dec_dev);
 
-	ret = mpp_dev_register_node(mpp_dev, mpp_dev->variant->node_name, NULL);
+	rkvdpu_ioctl_ops = mpp_ioctl_ops_templ;
+	rkvdpu_ioctl_ops.vidioc_s_fmt_vid_out_mplane =
+	    rkvdpu_s_fmt_vid_out_mplane;
+	rkvdpu_ioctl_ops.vidioc_s_fmt_vid_cap_mplane =
+	    rkvdpu_s_fmt_vid_cap_mplane;
+
+	ret = mpp_dev_register_node(mpp_dev, mpp_dev->variant->node_name,
+				    &rkvdpu_fops, &rkvdpu_ioctl_ops);
 	if (ret)
 		dev_err(dev, "register char device failed: %d\n", ret);
 
+	memcpy(mpp_dev->fmt_out, fmt_out_templ, sizeof(fmt_out_templ));
+	memcpy(mpp_dev->fmt_cap, fmt_cap_templ, sizeof(fmt_cap_templ));
 	dev_info(dev, "probing finish\n");
 
 	platform_set_drvdata(pdev, dec_dev);
@@ -525,7 +701,7 @@ static int rockchip_mpp_rkvdpu_remove(struct platform_device *pdev)
 }
 
 static const struct of_device_id mpp_rkvdpu2_dt_match[] = {
-	{ .compatible = "rockchip,vpu-decoder-v2", .data = &rkvdpu_v2_data},
+	{.compatible = "rockchip,vpu-decoder-v2",.data = &rkvdpu_v2_data},
 	{},
 };
 
@@ -547,9 +723,9 @@ static struct platform_driver rockchip_rkvdpu2_driver = {
 	.probe = rockchip_mpp_rkvdpu_probe,
 	.remove = rockchip_mpp_rkvdpu_remove,
 	.driver = {
-		.name = RKVDPU2_DRIVER_NAME,
-		.of_match_table = of_match_ptr(mpp_rkvdpu2_dt_match),
-	},
+		   .name = RKVDPU2_DRIVER_NAME,
+		   .of_match_table = of_match_ptr(mpp_rkvdpu2_dt_match),
+		   },
 };
 
 static int __init mpp_dev_rkvdpu2_init(void)
diff --git a/drivers/staging/rockchip-mpp/vdpu2/hal.h b/drivers/staging/rockchip-mpp/vdpu2/hal.h
new file mode 100644
index 000000000000..3da4b0e04c17
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/vdpu2/hal.h
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Randy Li, <ayaka@soulik.info>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _VDPU2_HAL_H_
+#define _VDPU2_HAL_H_
+
+#include <linux/types.h>
+
+/* The maximum registers number of all the version */
+#define ROCKCHIP_VDPU2_REG_NUM		159
+
+/* The first register of the decoder is Reg50(0x000c8) */
+#define RKVDPU2_REG_DEC_CTRL			0x0c8
+#define RKVDPU2_REG_DEC_CTRL_INDEX		(50)
+
+#define RKVDPU2_REG_DEC_INT_EN			0x0dc
+#define RKVDPU2_REG_DEC_INT_EN_INDEX		(55)
+#define		RKVDPU2_INT_TIMEOUT		BIT(13)
+#define		RKVDPU2_INT_STRM_ERROR		BIT(12)
+#define		RKVDPU2_INT_SLICE		BIT(9)
+#define		RKVDPU2_INT_ASO_ERROR		BIT(8)
+#define		RKVDPU2_INT_BUF_EMPTY		BIT(6)
+#define		RKVDPU2_INT_BUS_ERROR		BIT(5)
+#define		RKVDPU2_DEC_INT			BIT(4)
+#define		RKVDPU2_DEC_IRQ_DIS		BIT(1)
+#define		RKVDPU2_DEC_INT_RAW		BIT(0)
+
+#define RKVDPU2_REG_DEC_DEV_CTRL		0x0e4
+#define RKVDPU2_REG_DEC_DEV_CTRL_INDEX		(57)
+#define		RKVDPU2_DEC_CLOCK_GATE_EN	BIT(4)
+#define		RKVDPU2_DEC_START		BIT(0)
+
+#define RKVDPU2_REG59				0x0ec
+#define RKVDPU2_REG59_INDEX			(59)
+
+int rkvdpu_mpeg2_gen_reg(struct mpp_session *session, void *regs,
+			 struct vb2_v4l2_buffer *src_buf);
+int rkvdpu_mpeg2_prepare_buf(struct mpp_session *session, void *regs);
+
+#endif
diff --git a/drivers/staging/rockchip-mpp/vdpu2/mpeg2.c b/drivers/staging/rockchip-mpp/vdpu2/mpeg2.c
new file mode 100644
index 000000000000..a16f7629a811
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/vdpu2/mpeg2.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Randy Li, <ayaka@soulik.info>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/types.h>
+
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-dma-sg.h>
+
+#include "mpp_dev_common.h"
+#include "hal.h"
+#include "regs.h"
+
+#define DEC_LITTLE_ENDIAN	(1)
+
+static void init_hw_cfg(struct vdpu2_regs *p_regs)
+{
+    p_regs->sw54.dec_strm_wordsp = 1;
+    p_regs->sw54.dec_strendian_e = DEC_LITTLE_ENDIAN;
+    p_regs->sw54.dec_in_wordsp = 1;
+    p_regs->sw54.dec_out_wordsp = 1;
+    p_regs->sw54.dec_in_endian = DEC_LITTLE_ENDIAN;  //change
+    p_regs->sw54.dec_out_endian = DEC_LITTLE_ENDIAN;
+    p_regs->sw57.dec_timeout = 1;
+
+    p_regs->sw57.dec_clk_gate_e = 1;
+
+    p_regs->sw50.tiled_mode_msb = 0;
+    p_regs->sw56.dec_max_burst = 16;
+    p_regs->sw50.dec_scmd_dis = 0;
+    p_regs->sw50.dec_adv_pre_dis = 0;
+    p_regs->sw52.apf_threshold = 8;
+
+    p_regs->sw50.dec_latency = 0;
+    p_regs->sw56.dec_data_disc_e  = 0;
+
+    p_regs->sw55.dec_irq = 0;
+    p_regs->sw56.dec_axi_rd_id = 0;
+    p_regs->sw56.dec_axi_wr_id = 0;
+
+    /* default for MPEG-2 */
+    p_regs->sw136.mv_accuracy_fwd = 1;
+    p_regs->sw136.mv_accuracy_bwd = 1;
+}
+
+int rkvdpu_mpeg2_gen_reg(struct mpp_session *session, void *regs,
+			 struct vb2_v4l2_buffer *src_buf)
+{
+	const struct v4l2_ctrl_mpeg2_slice_params *params;
+	const struct v4l2_ctrl_mpeg2_quantization *quantization;
+	const struct v4l2_mpeg2_sequence *sequence;
+	const struct v4l2_mpeg2_picture *picture;
+	struct sg_table *sgt;
+	struct vdpu2_regs *p_regs = regs;
+
+	params = rockchip_mpp_get_cur_ctrl(session,
+			V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS);
+	quantization = rockchip_mpp_get_cur_ctrl(session,
+			V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION);
+
+	if (!params)
+		return -EINVAL;
+	
+	sequence = &params->sequence;
+	picture = &params->picture;
+
+	init_hw_cfg(p_regs);
+
+        p_regs->sw120.pic_mb_width = ALIGN(sequence->horizontal_size, 16);
+        p_regs->sw120.pic_mb_height_p = ALIGN(sequence->vertical_size, 16);
+	
+	/* PICT_FRAME */
+	if (picture->picture_structure == 3) {
+            p_regs->sw57.pic_fieldmode_e = 0;
+	} else {
+            p_regs->sw57.pic_fieldmode_e = 1;
+	    /* PICT_TOP_FIEL */
+	    if (picture->picture_structure == 1)
+		    p_regs->sw57.pic_topfield_e = 1;
+	}
+
+	switch (picture->picture_coding_type) {
+	case V4L2_MPEG2_PICTURE_CODING_TYPE_P:
+            p_regs->sw57.pic_inter_e = 1;
+            p_regs->sw57.pic_b_e = 0;
+	    break;
+	case V4L2_MPEG2_PICTURE_CODING_TYPE_B:
+            p_regs->sw57.pic_b_e = 1;
+            p_regs->sw57.pic_inter_e = 0;
+	    break;
+	case V4L2_MPEG2_PICTURE_CODING_TYPE_I:
+	default:
+            p_regs->sw57.pic_inter_e = 0;
+            p_regs->sw57.pic_b_e = 0;
+	    break;
+	}
+
+	if (picture->top_field_first)
+		p_regs->sw120.topfieldfirst_e = 1;
+
+        p_regs->sw57.fwd_interlace_e = 0;
+        p_regs->sw57.write_mvs_e = 0;
+
+        p_regs->sw120.alt_scan_e = picture->alternate_scan;
+        p_regs->sw136.alt_scan_flag_e = picture->alternate_scan;
+
+        p_regs->sw122.qscale_type = picture->q_scale_type;
+        p_regs->sw122.intra_dc_prec = picture->intra_dc_precision;
+        p_regs->sw122.con_mv_e = picture->concealment_motion_vectors;
+        p_regs->sw122.intra_vlc_tab = picture->intra_vlc_format;
+        p_regs->sw122.frame_pred_dct = picture->frame_pred_frame_dct;
+        p_regs->sw51.qp_init = 1;
+
+	/* MPEG-2 decoding mode */
+        p_regs->sw53.dec_mode = RKVDPU2_FMT_MPEG2D;
+
+        p_regs->sw136.fcode_fwd_hor = picture->f_code[0][0];
+        p_regs->sw136.fcode_fwd_ver = picture->f_code[0][1];
+        p_regs->sw136.fcode_bwd_hor = picture->f_code[1][0];
+        p_regs->sw136.fcode_bwd_ver = picture->f_code[1][1];
+
+	p_regs->sw57.pic_interlace_e = 1 - sequence->progressive_sequence;
+#if 0
+	/* MPEG-1 decoding mode */
+        p_regs->sw53.sw_dec_mode = 6;
+        p_regs->sw136.fcode_fwd_hor = picture->f_code[0][1];
+        p_regs->sw136.fcode_fwd_ver = picture->f_code[0][1];
+        p_regs->sw136.fcode_bwd_hor = picture->f_code[1][1];
+        p_regs->sw136.fcode_bwd_ver = picture->f_code[1][1];
+	if (picture->f_code[0][0])
+		p_regs->sw136.mv_accuracy_fwd = 0;
+	if (picture->f_code[1][0]
+		p_regs->sw136.mv_accuracy_bwd = 0;
+#endif
+
+        p_regs->sw52.startmb_x = 0;
+        p_regs->sw52.startmb_y = 0;
+        p_regs->sw57.dec_out_dis = 0;
+        p_regs->sw50.filtering_dis = 1;
+
+	sgt = vb2_dma_sg_plane_desc(&src_buf->vb2_buf, 0);
+	p_regs->sw64.rlc_vlc_base = sg_dma_address(sgt->sgl);
+	p_regs->sw122.strm_start_bit = params->data_bit_offset;
+        p_regs->sw51.stream_len = vb2_get_plane_payload(&src_buf->vb2_buf, 0);
+
+	return 0;
+}
+
+int rkvdpu_mpeg2_prepare_buf(struct mpp_session *session, void *regs)
+{
+	const struct v4l2_ctrl_mpeg2_slice_params *params;
+	const struct v4l2_mpeg2_sequence *sequence;
+	const struct v4l2_mpeg2_picture *picture;
+	struct vb2_v4l2_buffer *dst_buf;
+	dma_addr_t cur_addr, fwd_addr, bwd_addr;
+	struct sg_table *sgt;
+
+	struct vb2_queue *cap_q = &session->fh.m2m_ctx->cap_q_ctx.q;
+	struct vdpu2_regs *p_regs = regs;
+
+	params = rockchip_mpp_get_cur_ctrl(session,
+			V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS);
+	picture = &params->picture;
+	sequence = &params->sequence;
+
+	dst_buf = v4l2_m2m_next_dst_buf(session->fh.m2m_ctx);
+
+	sgt = vb2_dma_sg_plane_desc(&dst_buf->vb2_buf, 0);
+	cur_addr = fwd_addr = bwd_addr = sg_dma_address(sgt->sgl);
+
+	if (picture->picture_structure == V4L2_FIELD_BOTTOM)
+		cur_addr += ALIGN(sequence->horizontal_size, 16) << 10;
+	p_regs->sw63.dec_out_base = cur_addr;
+
+	fwd_addr = rockchip_mpp_find_addr(cap_q, &dst_buf->vb2_buf,
+					  params->forward_ref_ts);
+	bwd_addr = rockchip_mpp_find_addr(cap_q, &dst_buf->vb2_buf,
+					  params->backward_ref_ts);
+
+#if 1
+	/* TODO: picture_structure is compatible with FFmpeg */
+	if (picture->picture_structure == 3 ||
+	    picture->picture_coding_type == V4L2_MPEG2_PICTURE_CODING_TYPE_B ||
+	    (picture->picture_structure == 1 && picture->top_field_first) ||
+	    (picture->picture_structure == 2 && !picture->top_field_first)) {
+		p_regs->sw131.refer0_base = fwd_addr >> 2;
+		p_regs->sw148.refer1_base = fwd_addr >> 2;
+
+	} else if (picture->picture_structure == V4L2_FIELD_TOP) {
+		p_regs->sw131.refer0_base = fwd_addr >> 2;
+		p_regs->sw148.refer1_base = cur_addr >> 2;
+
+	} else if (picture->picture_structure == V4L2_FIELD_BOTTOM) {
+		p_regs->sw131.refer0_base = cur_addr >> 2;
+		p_regs->sw148.refer1_base = fwd_addr >> 2;
+	}
+#else
+	if (picture->picture_coding_type == V4L2_MPEG2_PICTURE_CODING_TYPE_B) {
+		p_regs->sw131.refer0_base = fwd_addr >> 2;
+		p_regs->sw148.refer1_base = fwd_addr >> 2;
+	}
+#endif
+
+	/* Always the same buffer for MPEG-2 */
+	p_regs->sw134.refer2_base = bwd_addr >> 2;
+	p_regs->sw135.refer3_base = bwd_addr >> 2;
+
+#if 0
+        //ref & qtable config
+        p_regs->sw61.qtable_base = mpp_buffer_get_fd(ctx->qp_table);
+#endif
+	return 0;
+}
diff --git a/drivers/staging/rockchip-mpp/vdpu2/regs.h b/drivers/staging/rockchip-mpp/vdpu2/regs.h
new file mode 100644
index 000000000000..2acc27a09071
--- /dev/null
+++ b/drivers/staging/rockchip-mpp/vdpu2/regs.h
@@ -0,0 +1,699 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2017 Fuzhou Rockchip Electronics Co., Ltd
+ *		Randy Li, <ayaka@soulik.info>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _VDPU2_REGS_H_
+#define _VDPU2_REGS_H_
+
+#define RKVDPU2_REG_SYS_CTRL			0x0d4
+#define RKVDPU2_REG_SYS_CTRL_INDEX		(53)
+#define		RKVDPU2_GET_FORMAT(x)		((x) & 0xf)
+#define		RKVDPU2_FMT_H264D		0
+#define		RKVDPU2_FMT_MPEG4D		1
+#define		RKVDPU2_FMT_H263D		2
+#define		RKVDPU2_FMT_JPEGD		3
+#define		RKVDPU2_FMT_VC1D		4
+#define		RKVDPU2_FMT_MPEG2D		5
+#define		RKVDPU2_FMT_MPEG1D		6
+#define		RKVDPU2_FMT_VP6D		7
+#define		RKVDPU2_FMT_RESERVED		8
+#define		RKVDPU2_FMT_VP7D		9
+#define		RKVDPU2_FMT_VP8D		10
+#define		RKVDPU2_FMT_AVSD		11
+
+#define RKVDPU2_REG_DIR_MV_BASE                 0x0f8
+#define RKVDPU2_REG_DIR_MV_BASE_INDEX           (62)
+
+#define RKVDPU2_REG_STREAM_RLC_BASE		0x100
+#define RKVDPU2_REG_STREAM_RLC_BASE_INDEX	(64)
+
+#if 0
+/*
+ * file handle translate information
+ */
+static const char trans_tbl_default[] = {
+	61, 62, 63, 64, 131, 134, 135, 148
+};
+
+static const char trans_tbl_jpegd[] = {
+	21, 22, 61, 63, 64, 131
+};
+
+static const char trans_tbl_h264d[] = {
+	61, 63, 64, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97,
+	98, 99
+};
+
+static const char trans_tbl_vc1d[] = {
+	62, 63, 64, 131, 134, 135, 145, 148
+};
+
+static const char trans_tbl_vp6d[] = {
+	61, 63, 64, 131, 136, 145
+};
+
+static const char trans_tbl_vp8d[] = {
+	61, 63, 64, 131, 136, 137, 140, 141, 142, 143, 144, 145, 146, 147, 149
+};
+#endif
+
+struct vdpu2_regs {
+	u32 sw00_49[50];
+
+	struct {
+		u32 tiled_mode_msb:1;
+		u32 dec_latency:6;
+		u32 dec_fixed_quant:1;
+		u32 filtering_dis:1;
+		u32 skip_sel:1;
+		u32 dec_scmd_dis:1;
+		u32 dec_adv_pre_dis:1;
+		u32 tiled_mode_lsb:1;
+		u32 refbuf_thrd:12;
+		u32 refbuf_pid:5;
+		u32 reverse0:2;
+	} sw50;
+
+	struct {
+		u32 stream_len:24;
+		u32 stream_len_ext:1;
+		u32 qp_init:6;
+		u32 reverse0:1;
+	} sw51;
+
+	struct {
+		/* ydim_mbst */
+		u32 startmb_y:8;
+		/* xdim_mbst */
+		u32 startmb_x:9;
+		/* adv_pref_thrd */
+		u32 apf_threshold:14;
+		u32 reverse0:1;
+	} sw52;
+
+	struct {
+		u32 dec_mode:4;
+		u32 reverse0:28;
+	} sw53;
+
+	struct {
+		u32 dec_in_endian:1;
+		u32 dec_out_endian:1;
+		u32 dec_in_wordsp:1;
+		u32 dec_out_wordsp:1;
+		u32 dec_strm_wordsp:1;
+		u32 dec_strendian_e:1;
+		u32 reverse0:26;
+	} sw54;
+
+	struct {
+		u32 dec_irq:1;
+		u32 dec_irq_dis:1;
+		u32 reverse0:2;
+		u32 dec_rdy_sts:1;
+		u32 pp_bus_sts:1;
+		u32 buf_emt_sts:1;
+		u32 reverse1:1;
+		u32 aso_det_sts:1;
+		u32 slice_det_sts:1;
+		u32 bslice_det_sts:1;
+		u32 reverse2:1;
+		u32 error_det_sts:1;
+		u32 timeout_det_sts:1;
+		u32 reverse3:18;
+	} sw55;
+
+	struct {
+		u32 dec_axi_rd_id:8;
+		u32 dec_axi_wr_id:8;
+		u32 dec_max_burst:5;
+		u32 bus_pos_sel:1;
+		u32 dec_data_disc_e:1;
+		u32 axi_sel:1;
+		u32 reverse0:8;
+	} sw56;
+
+	struct {
+		u32 dec_e:1;
+		u32 refbuf2_buf_e:1;
+		u32 dec_out_dis:1;
+		u32 reserved2:1;
+		u32 dec_clk_gate_e:1;
+		u32 dec_timeout_e:1;
+		/* rd_cnt_tab_en */
+		u32 picord_count_e:1;
+		u32 seq_mbaff_e:1;
+		u32 reftopfirst_e:1;
+		u32 ref_topfield_e:1;
+		u32 write_mvs_e:1;
+		u32 sorenson_e:1;
+		u32 fwd_interlace_e:1;
+		u32 pic_topfield_e:1;
+		/* sw_pic_type_sel0 */
+		u32 pic_inter_e:1;
+		u32 pic_b_e:1;
+		u32 pic_fieldmode_e:1;
+		u32 pic_interlace_e:1;
+		u32 pjpeg_e:1;
+		u32 divx3_e:1;
+		u32 rlc_mode_e:1;
+		u32 ch_8pix_ileav_e:1;
+		u32 start_code_e:1;
+		u32 reserved1:2;
+		/* sw_init_dc_match0 ? */
+		u32 inter_dblspeed:1;
+		u32 intra_dblspeed:1;
+		u32 intra_dbl3t:1;
+		u32 pref_sigchan:1;
+		u32 cache_en:1;
+		u32 reserved0:1;
+		/* dec_timeout_mode */
+		u32 dec_timeout:1;
+	} sw57;
+
+	struct {
+		u32 soft_rst:1;
+		u32 reverse0:31;
+	} sw58;
+
+	struct {
+		u32 reverse0:2;
+		/* sw_pflt_set0_tap2 */
+		u32 pred_bc_tap_0_2:10;
+		u32 pred_bc_tap_0_1:10;
+		/* pflt_set0_tap0 */
+		u32 pred_bc_tap_0_0:10;
+	} sw59;
+
+	struct {
+		u32 addit_ch_st_adr:32;
+	} sw60;
+
+	struct {
+		u32 qtable_base:32;
+	} sw61;
+
+	struct {
+		u32 dir_mv_base:32;
+	} sw62;
+
+	struct {
+		/* dec_out_st_adr */
+		u32 dec_out_base:32;
+	} sw63;
+
+	struct {
+		u32 rlc_vlc_base:32;
+	} sw64;
+
+	struct {
+		u32 refbuf_y_offset:9;
+		u32 reserve0:3;
+		u32 refbuf_fildpar_mode_e:1;
+		u32 refbuf_idcal_e:1;
+		u32 refbuf_picid:5;
+		u32 refbuf_thr_level:12;
+		u32 refbuf_e:1;
+	} sw65;
+
+	u32 sw66;
+	u32 sw67;
+
+	struct {
+		u32 refbuf_sum_bot:16;
+		u32 refbuf_sum_top:16;
+	} sw68;
+
+	struct {
+		u32 luma_sum_intra:16;
+		u32 refbuf_sum_hit:16;
+	} sw69;
+
+	struct {
+		u32 ycomp_mv_sum:22;
+		u32 reserve0:10;
+	} sw70;
+
+	u32 sw71;
+	u32 sw72;
+	u32 sw73;
+
+	struct {
+		u32 init_reflist_pf4:5;
+		u32 init_reflist_pf5:5;
+		u32 init_reflist_pf6:5;
+		u32 init_reflist_pf7:5;
+		u32 init_reflist_pf8:5;
+		u32 init_reflist_pf9:5;
+		u32 reverse0:2;
+	} sw74;
+
+	struct {
+		u32 init_reflist_pf10:5;
+		u32 init_reflist_pf11:5;
+		u32 init_reflist_pf12:5;
+		u32 init_reflist_pf13:5;
+		u32 init_reflist_pf14:5;
+		u32 init_reflist_pf15:5;
+		u32 reverse0:2;
+	} sw75;
+
+	struct {
+		u32 num_ref_idx0:16;
+		u32 num_ref_idx1:16;
+	} sw76;
+
+	struct {
+		u32 num_ref_idx2:16;
+		u32 num_ref_idx3:16;
+	} sw77;
+
+	struct {
+		u32 num_ref_idx4:16;
+		u32 num_ref_idx5:16;
+	} sw78;
+
+	struct {
+		u32 num_ref_idx6:16;
+		u32 num_ref_idx7:16;
+	} sw79;
+
+	struct {
+		u32 num_ref_idx8:16;
+		u32 num_ref_idx9:16;
+	} sw80;
+
+	struct {
+		u32 num_ref_idx10:16;
+		u32 num_ref_idx11:16;
+	} sw81;
+
+	struct {
+		u32 num_ref_idx12:16;
+		u32 num_ref_idx13:16;
+	} sw82;
+
+	struct {
+		u32 num_ref_idx14:16;
+		u32 num_ref_idx15:16;
+	} sw83;
+
+	/* Used by H.264 */
+	union {
+		u32 ref0_st_addr;
+		struct {
+			u32 ref0_closer_sel:1;
+			u32 ref0_field_en:1;
+			u32 reverse0:30;
+		};
+	} sw84;
+
+	union {
+		u32 ref1_st_addr;
+		struct {
+			u32 ref1_closer_sel:1;
+			u32 ref1_field_en:1;
+			u32 reverse0:30;
+		};
+	} sw85;
+
+	union {
+		u32 ref2_st_addr;
+		struct {
+			u32 ref2_closer_sel:1;
+			u32 ref2_field_en:1;
+			u32 reverse0:30;
+		};
+	} sw86;
+
+	union {
+		u32 ref3_st_addr;
+		struct {
+			u32 ref3_closer_sel:1;
+			u32 ref3_field_en:1;
+			u32 reverse0:30;
+		};
+	} sw87;
+
+	union {
+		u32 ref4_st_addr;
+		struct {
+			u32 ref4_closer_sel:1;
+			u32 ref4_field_en:1;
+			u32 reverse0:30;
+		};
+	} sw88;
+
+	union {
+		u32 ref5_st_addr;
+		struct {
+			u32 ref5_closer_sel:1;
+			u32 ref5_field_en:1;
+			u32 reverse0:30;
+		};
+	} sw89;
+
+	union {
+		u32 ref6_st_addr;
+		struct {
+			u32 ref6_closer_sel:1;
+			u32 ref6_field_en:1;
+			u32 reverse0:30;
+		};
+	} sw90;
+
+	union {
+		u32 ref7_st_addr;
+		struct {
+			u32 ref7_closer_sel:1;
+			u32 ref7_field_en:1;
+			u32 reverse0:30;
+		};
+	} sw91;
+
+	union {
+		u32 ref8_st_addr;
+		struct {
+			u32 ref8_closer_sel:1;
+			u32 ref8_field_en:1;
+			u32 reverse0:30;
+		};
+	} sw92;
+
+	union {
+		u32 ref9_st_addr;
+		struct {
+			u32 ref9_closer_sel:1;
+			u32 ref9_field_en:1;
+			u32 reverse0:30;
+		};
+	} sw93;
+
+	union {
+		u32 ref10_st_addr;
+		struct {
+			u32 ref10_closer_sel:1;
+			u32 ref10_field_en:1;
+			u32 reverse0:30;
+		};
+	} sw94;
+
+	union {
+		u32 ref11_st_addr;
+		struct {
+			u32 ref11_closer_sel:1;
+			u32 ref11_field_en:1;
+			u32 reverse0:30;
+		};
+	} sw95;
+
+	union {
+		u32 ref12_st_addr;
+		struct {
+			u32 ref12_closer_sel:1;
+			u32 ref12_field_en:1;
+			u32 reverse0:30;
+		};
+	} sw96;
+
+	union {
+		u32 ref13_st_addr;
+		struct {
+			u32 ref13_closer_sel:1;
+			u32 ref13_field_en:1;
+			u32 reverse0:30;
+		};
+	} sw97;
+
+	union {
+		u32 ref14_st_addr;
+		struct {
+			u32 ref14_closer_sel:1;
+			u32 ref14_field_en:1;
+			u32 reverse0:30;
+		};
+	} sw98;
+
+	/* Used by H.264 */
+	union {
+		u32 ref15_st_addr;
+		struct {
+			u32 ref15_closer_sel:1;
+			u32 ref15_field_en:1;
+			u32 reverse0:30;
+		};
+	} sw99;
+
+	struct {
+		u32 init_reflist_df0:5;
+		u32 init_reflist_df1:5;
+		u32 init_reflist_df2:5;
+		u32 init_reflist_df3:5;
+		u32 init_reflist_df4:5;
+		u32 init_reflist_df5:5;
+		u32 reverse0:2;
+	} sw100;
+
+	struct {
+		u32 init_reflist_df6:5;
+		u32 init_reflist_df7:5;
+		u32 init_reflist_df8:5;
+		u32 init_reflist_df9:5;
+		u32 init_reflist_df10:5;
+		u32 init_reflist_df11:5;
+		u32 reverse0:2;
+	} sw101;
+
+	struct {
+		u32 init_reflist_df12:5;
+		u32 init_reflist_df13:5;
+		u32 init_reflist_df14:5;
+		u32 init_reflist_df15:5;
+		u32 reverse0:12;
+	} sw102;
+
+	struct {
+		u32 init_reflist_db0:5;
+		u32 init_reflist_db1:5;
+		u32 init_reflist_db2:5;
+		u32 init_reflist_db3:5;
+		u32 init_reflist_db4:5;
+		u32 init_reflist_db5:5;
+		u32 reverse0:2;
+	} sw103;
+
+	struct {
+		u32 init_reflist_db6:5;
+		u32 init_reflist_db7:5;
+		u32 init_reflist_db8:5;
+		u32 init_reflist_db9:5;
+		u32 init_reflist_db10:5;
+		u32 init_reflist_db11:5;
+		u32 reverse0:2;
+	} sw104;
+
+	struct {
+		u32 init_reflist_db12:5;
+		u32 init_reflist_db13:5;
+		u32 init_reflist_db14:5;
+		u32 init_reflist_db15:5;
+		u32 reverse0:12;
+	} sw105;
+
+	struct {
+		u32 init_reflist_pf0:5;
+		u32 init_reflist_pf1:5;
+		u32 init_reflist_pf2:5;
+		u32 init_reflist_pf3:5;
+		u32 reverse0:12;
+	} sw106;
+
+	struct {
+		u32 refpic_term_flag:32;
+	} sw107;
+
+	struct {
+		u32 refpic_valid_flag:32;
+	} sw108;
+
+	struct {
+		u32 strm_start_bit:6;
+		u32 reverse0:26;
+	} sw109;
+
+	struct {
+		u32 pic_mb_w:9;
+		u32 pic_mb_h:8;
+		u32 flt_offset_cb_qp:5;
+		u32 flt_offset_cr_qp:5;
+		u32 reverse0:5;
+	} sw110;
+
+	struct {
+		u32 max_refnum:5;
+		u32 reverse0:11;
+		u32 wp_bslice_sel:2;
+		u32 reverse1:14;
+	} sw111;
+
+	struct {
+		u32 curfrm_num:16;
+		u32 cur_frm_len:5;
+		u32 reverse0:9;
+		u32 rpcp_flag:1;
+		u32 dblk_ctrl_flag:1;
+	} sw112;
+
+	struct {
+		u32 idr_pic_id:16;
+		u32 refpic_mk_len:11;
+		u32 reverse0:5;
+	} sw113;
+
+	struct {
+		u32 poc_field_len:8;
+		u32 reverse0:6;
+		u32 max_refidx0:5;
+		u32 max_refidx1:5;
+		u32 pps_id:5;
+	} sw114;
+
+	struct {
+		u32 fieldpic_flag_exist:1;
+		u32 scl_matrix_en:1;
+		u32 tranf_8x8_flag_en:1;
+		u32 const_intra_en:1;
+		u32 weight_pred_en:1;
+		u32 cabac_en:1;
+		u32 monochr_en:1;
+		u32 dlmv_method_en:1;
+		u32 idr_pic_flag:1;
+		u32 reverse0:23;
+	} sw115;
+
+	u32 sw116_158[43];
+
+	struct {
+#if 0
+		union {
+			struct avs {
+				u32 pic_refer_flag:1;
+				u32 reserved0:5;
+			};
+
+			struct vc1 {
+				u32 pic_mb_w_ext:3;
+				u32 pic_mb_h_ext:3;
+			};
+
+			struct h264 {
+				u32 ref_frames:5;
+				u32 reserved0:1;
+			};
+
+			struct mpeg {
+				u32 reserved0:5;
+				u32 topfieldfirst_e:1;
+			};
+		};
+#else
+		u32 ref_frames:5;
+		u32 topfieldfirst_e:1;
+#endif
+		u32 alt_scan_e:1;
+		u32 mb_height_off:4;
+		u32 pic_mb_height_p:8;
+		/* Used by VC-1 only */
+		u32 mb_width_off:4;
+		u32 pic_mb_width:9;
+	} sw120;
+
+	u32 sw121;
+
+	struct {
+		u32 frame_pred_dct:1;
+		u32 intra_vlc_tab:1;
+		u32 intra_dc_prec:1;
+		u32 con_mv_e:1;
+		u32 reserved0:19;
+		u32 qscale_type:1;
+		u32 reserved1:1;
+		u32 strm_start_bit:6;
+	} sw122;
+
+	u32 sw123;
+	u32 sw124;
+	u32 sw125;
+	u32 sw126;
+	u32 sw127;
+	u32 sw128;
+	u32 sw129;
+	u32 sw130;
+
+	struct {
+		u32 refer0_topc_e:1;
+		u32 refer0_field_e:1;
+		u32 refer0_base:30;
+	} sw131;
+
+	u32 sw132;
+	u32 sw133;
+
+	struct {
+		u32 refer2_topc_e:1;
+		u32 refer2_field_e:1;
+		u32 refer2_base:30;
+	} sw134;
+
+	struct {
+		u32 refer3_topc_e:1;
+		u32 refer3_field_e:1;
+		u32 refer3_base:30;
+	} sw135;
+
+	struct {
+		u32 reserved0:1;
+		u32 mv_accuracy_bwd:1;
+		u32 mv_accuracy_fwd:1;
+		u32 fcode_bwd_ver:4;
+		u32 fcode_bwd_hor:4;
+		u32 fcode_fwd_ver:4;
+		u32 fcode_fwd_hor:4;
+		u32 alt_scan_flag_e:1;
+		u32 reserved1:12;
+	} sw136;
+
+	u32 sw137;
+	u32 sw138;
+	u32 sw139;
+	u32 sw140;
+	u32 sw141;
+	u32 sw142;
+	u32 sw143;
+	u32 sw144;
+	u32 sw145;
+	u32 sw146;
+	u32 sw147;
+
+	struct {
+		u32 refer1_topc_e:1;
+		u32 refer1_field_e:1;
+		u32 refer1_base:30;
+	} sw148;
+
+	u32 sw149_sw158[10];
+} __attribute__((packed));
+
+#endif
-- 
2.20.1

