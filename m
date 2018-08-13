Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33931 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729029AbeHMRdN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 13:33:13 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 04/14] staging: media: tegra-vde: Use DRM/KMS framebuffer modifiers
Date: Mon, 13 Aug 2018 16:50:17 +0200
Message-Id: <20180813145027.16346-5-thierry.reding@gmail.com>
In-Reply-To: <20180813145027.16346-1-thierry.reding@gmail.com>
References: <20180813145027.16346-1-thierry.reding@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Thierry Reding <treding@nvidia.com>

VDE on Tegra20 through Tegra114 supports reading and writing frames in
16x16 tiled layout. Similarily, the various block-linear layouts that
are supported by the GPU on Tegra124 can also be read from and written
to by the Tegra124 VDE.

Enable userspace to specify the desired layout using the existing DRM
framebuffer modifiers.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/staging/media/tegra-vde/tegra-vde.c | 112 +++++++++++++++++---
 drivers/staging/media/tegra-vde/uapi.h      |   3 +-
 2 files changed, 100 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
index 1a40f6dff7c8..275884e745df 100644
--- a/drivers/staging/media/tegra-vde/tegra-vde.c
+++ b/drivers/staging/media/tegra-vde/tegra-vde.c
@@ -24,6 +24,8 @@
 
 #include <soc/tegra/pmc.h>
 
+#include <drm/drm_fourcc.h>
+
 #include "uapi.h"
 
 #define ICMDQUE_WR		0x00
@@ -58,12 +60,14 @@ struct video_frame {
 	dma_addr_t aux_addr;
 	u32 frame_num;
 	u32 flags;
+	u64 modifier;
 };
 
 struct tegra_vde_soc {
 	unsigned int num_ref_pics;
 	bool supports_ref_pic_marking;
 	bool supports_interlacing;
+	bool supports_block_linear;
 };
 
 struct tegra_vde {
@@ -202,6 +206,7 @@ static void tegra_vde_setup_frameid(struct tegra_vde *vde,
 				    unsigned int frameid,
 				    u32 mbs_width, u32 mbs_height)
 {
+	u64 modifier = frame ? frame->modifier : DRM_FORMAT_MOD_LINEAR;
 	u32 y_addr  = frame ? frame->y_addr  : 0x6CDEAD00;
 	u32 cb_addr = frame ? frame->cb_addr : 0x6CDEAD00;
 	u32 cr_addr = frame ? frame->cr_addr : 0x6CDEAD00;
@@ -209,8 +214,12 @@ static void tegra_vde_setup_frameid(struct tegra_vde *vde,
 	u32 value2 = frame ? ((((mbs_width + 1) >> 1) << 6) | 1) : 0;
 	u32 value = y_addr >> 8;
 
-	if (vde->soc->supports_interlacing)
+	if (!vde->soc->supports_interlacing) {
+		if (modifier == DRM_FORMAT_MOD_NVIDIA_TEGRA_TILED)
+			value |= BIT(31);
+	} else {
 		value |= BIT(31);
+	}
 
 	VDE_WR(value,        vde->frameid + 0x000 + frameid * 4);
 	VDE_WR(cb_addr >> 8, vde->frameid + 0x100 + frameid * 4);
@@ -349,6 +358,37 @@ static void tegra_vde_setup_iram_tables(struct tegra_vde *vde,
 	}
 }
 
+static int tegra_vde_get_block_height(u64 modifier, unsigned int *block_height)
+{
+	switch (modifier) {
+	case DRM_FORMAT_MOD_NVIDIA_16BX2_BLOCK_ONE_GOB:
+		*block_height = 0;
+		return 0;
+
+	case DRM_FORMAT_MOD_NVIDIA_16BX2_BLOCK_TWO_GOB:
+		*block_height = 1;
+		return 0;
+
+	case DRM_FORMAT_MOD_NVIDIA_16BX2_BLOCK_FOUR_GOB:
+		*block_height = 2;
+		return 0;
+
+	case DRM_FORMAT_MOD_NVIDIA_16BX2_BLOCK_EIGHT_GOB:
+		*block_height = 3;
+		return 0;
+
+	case DRM_FORMAT_MOD_NVIDIA_16BX2_BLOCK_SIXTEEN_GOB:
+		*block_height = 4;
+		return 0;
+
+	case DRM_FORMAT_MOD_NVIDIA_16BX2_BLOCK_THIRTYTWO_GOB:
+		*block_height = 5;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 static int tegra_vde_setup_hw_context(struct tegra_vde *vde,
 				      struct tegra_vde_h264_decoder_ctx *ctx,
 				      struct video_frame *dpb_frames,
@@ -383,7 +423,21 @@ static int tegra_vde_setup_hw_context(struct tegra_vde *vde,
 	tegra_vde_set_bits(vde, 0x0005, vde->vdma + 0x04);
 
 	VDE_WR(0x00000000, vde->vdma + 0x1C);
-	VDE_WR(0x00000000, vde->vdma + 0x00);
+
+	value = 0x00000000;
+
+	if (vde->soc->supports_block_linear) {
+		unsigned int block_height;
+
+		err = tegra_vde_get_block_height(dpb_frames[0].modifier,
+						 &block_height);
+		if (err < 0)
+			return err;
+
+		value |= block_height << 10;
+	}
+
+	VDE_WR(value, vde->vdma + 0x00);
 	VDE_WR(0x00000007, vde->vdma + 0x04);
 	VDE_WR(0x00000007, vde->frameid + 0x200);
 	VDE_WR(0x00000005, vde->tfe + 0x04);
@@ -730,11 +784,37 @@ static void tegra_vde_release_frame_dmabufs(struct video_frame *frame,
 static int tegra_vde_validate_frame(struct device *dev,
 				    struct tegra_vde_h264_frame *frame)
 {
+	struct tegra_vde *vde = dev_get_drvdata(dev);
+
 	if (frame->frame_num > 0x7FFFFF) {
 		dev_err(dev, "Bad frame_num %u\n", frame->frame_num);
 		return -EINVAL;
 	}
 
+	if (vde->soc->supports_block_linear) {
+		switch (frame->modifier) {
+		case DRM_FORMAT_MOD_NVIDIA_16BX2_BLOCK_ONE_GOB:
+		case DRM_FORMAT_MOD_NVIDIA_16BX2_BLOCK_TWO_GOB:
+		case DRM_FORMAT_MOD_NVIDIA_16BX2_BLOCK_FOUR_GOB:
+		case DRM_FORMAT_MOD_NVIDIA_16BX2_BLOCK_EIGHT_GOB:
+		case DRM_FORMAT_MOD_NVIDIA_16BX2_BLOCK_SIXTEEN_GOB:
+		case DRM_FORMAT_MOD_NVIDIA_16BX2_BLOCK_THIRTYTWO_GOB:
+			break;
+
+		default:
+			return -EINVAL;
+		}
+	} else {
+		switch (frame->modifier) {
+		case DRM_FORMAT_MOD_NVIDIA_TEGRA_TILED:
+		case DRM_FORMAT_MOD_LINEAR:
+			break;
+
+		default:
+			return -EINVAL;
+		}
+	}
+
 	return 0;
 }
 
@@ -812,7 +892,6 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
 {
 	struct device *dev = vde->miscdev.parent;
 	struct tegra_vde_h264_decoder_ctx ctx;
-	struct tegra_vde_h264_frame frames[17];
 	struct tegra_vde_h264_frame __user *frames_user;
 	struct video_frame *dpb_frames;
 	struct dma_buf_attachment *bitstream_data_dmabuf_attachment;
@@ -872,28 +951,30 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
 	macroblocks_nb = ctx.pic_width_in_mbs * ctx.pic_height_in_mbs;
 	frames_user = u64_to_user_ptr(ctx.dpb_frames_ptr);
 
-	if (copy_from_user(frames, frames_user,
-			   ctx.dpb_frames_nb * sizeof(*frames))) {
-		ret = -EFAULT;
-		goto free_dpb_frames;
-	}
-
 	cstride = ALIGN(ctx.pic_width_in_mbs * 8, 16);
 	csize = cstride * ctx.pic_height_in_mbs * 8;
 	lsize = macroblocks_nb * 256;
 
 	for (i = 0; i < ctx.dpb_frames_nb; i++) {
-		ret = tegra_vde_validate_frame(dev, &frames[i]);
+		struct tegra_vde_h264_frame frame;
+
+		if (copy_from_user(&frame, &frames_user[i], sizeof(frame))) {
+			ret = -EFAULT;
+			goto release_dpb_frames;
+		}
+
+		ret = tegra_vde_validate_frame(dev, &frame);
 		if (ret)
 			goto release_dpb_frames;
 
-		dpb_frames[i].flags = frames[i].flags;
-		dpb_frames[i].frame_num = frames[i].frame_num;
+		dpb_frames[i].flags = frame.flags;
+		dpb_frames[i].frame_num = frame.frame_num;
+		dpb_frames[i].modifier = frame.modifier;
 
 		dma_dir = (i == 0) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 
 		ret = tegra_vde_attach_dmabufs_to_frame(dev, &dpb_frames[i],
-							&frames[i], dma_dir,
+							&frame, dma_dir,
 							ctx.baseline_profile,
 							lsize, csize);
 		if (ret)
@@ -985,7 +1066,6 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
 						ctx.baseline_profile);
 	}
 
-free_dpb_frames:
 	kfree(dpb_frames);
 
 release_bitstream_dmabuf:
@@ -1328,24 +1408,28 @@ static const struct tegra_vde_soc tegra20_vde_soc = {
 	.num_ref_pics = 16,
 	.supports_ref_pic_marking = false,
 	.supports_interlacing = false,
+	.supports_block_linear = false,
 };
 
 static const struct tegra_vde_soc tegra30_vde_soc = {
 	.num_ref_pics = 32,
 	.supports_ref_pic_marking = false,
 	.supports_interlacing = false,
+	.supports_block_linear = false,
 };
 
 static const struct tegra_vde_soc tegra114_vde_soc = {
 	.num_ref_pics = 32,
 	.supports_ref_pic_marking = true,
 	.supports_interlacing = false,
+	.supports_block_linear = false,
 };
 
 static const struct tegra_vde_soc tegra124_vde_soc = {
 	.num_ref_pics = 32,
 	.supports_ref_pic_marking = true,
 	.supports_interlacing = true,
+	.supports_block_linear = true,
 };
 
 static const struct of_device_id tegra_vde_of_match[] = {
diff --git a/drivers/staging/media/tegra-vde/uapi.h b/drivers/staging/media/tegra-vde/uapi.h
index 58bfd56de55e..6cd730dda61c 100644
--- a/drivers/staging/media/tegra-vde/uapi.h
+++ b/drivers/staging/media/tegra-vde/uapi.h
@@ -27,8 +27,9 @@ struct tegra_vde_h264_frame {
 	__u32 aux_offset;
 	__u32 frame_num;
 	__u32 flags;
+	__u64 modifier;
 
-	__u32 reserved;
+	__u32 reserved[4];
 } __attribute__((packed));
 
 struct tegra_vde_h264_decoder_ctx {
-- 
2.17.0
