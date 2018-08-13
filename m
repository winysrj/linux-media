Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41483 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728547AbeHMRdJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 13:33:09 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 02/14] staging: media: tegra-vde: Support reference picture marking
Date: Mon, 13 Aug 2018 16:50:15 +0200
Message-Id: <20180813145027.16346-3-thierry.reding@gmail.com>
In-Reply-To: <20180813145027.16346-1-thierry.reding@gmail.com>
References: <20180813145027.16346-1-thierry.reding@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Thierry Reding <treding@nvidia.com>

Tegra114 and Tegra124 support reference picture marking, which will
cause BSEV to write picture marking data to SDRAM. Make sure there is
a valid destination address for that data to avoid error messages from
the memory controller.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/staging/media/tegra-vde/tegra-vde.c | 54 ++++++++++++++++++++-
 drivers/staging/media/tegra-vde/uapi.h      |  3 ++
 2 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
index 9d8f833744db..3027b11b11ae 100644
--- a/drivers/staging/media/tegra-vde/tegra-vde.c
+++ b/drivers/staging/media/tegra-vde/tegra-vde.c
@@ -60,7 +60,12 @@ struct video_frame {
 	u32 flags;
 };
 
+struct tegra_vde_soc {
+	bool supports_ref_pic_marking;
+};
+
 struct tegra_vde {
+	const struct tegra_vde_soc *soc;
 	void __iomem *sxe;
 	void __iomem *bsev;
 	void __iomem *mbe;
@@ -330,6 +335,7 @@ static int tegra_vde_setup_hw_context(struct tegra_vde *vde,
 				      struct video_frame *dpb_frames,
 				      dma_addr_t bitstream_data_addr,
 				      size_t bitstream_data_size,
+				      dma_addr_t secure_addr,
 				      unsigned int macroblocks_nb)
 {
 	struct device *dev = vde->miscdev.parent;
@@ -454,6 +460,9 @@ static int tegra_vde_setup_hw_context(struct tegra_vde *vde,
 
 	VDE_WR(bitstream_data_addr, vde->sxe + 0x6C);
 
+	if (vde->soc->supports_ref_pic_marking)
+		VDE_WR(secure_addr, vde->sxe + 0x7c);
+
 	value = 0x10000005;
 	value |= ctx->pic_width_in_mbs << 11;
 	value |= ctx->pic_height_in_mbs << 3;
@@ -772,12 +781,15 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
 	struct tegra_vde_h264_frame __user *frames_user;
 	struct video_frame *dpb_frames;
 	struct dma_buf_attachment *bitstream_data_dmabuf_attachment;
-	struct sg_table *bitstream_sgt;
+	struct dma_buf_attachment *secure_attachment = NULL;
+	struct sg_table *bitstream_sgt, *secure_sgt;
 	enum dma_data_direction dma_dir;
 	dma_addr_t bitstream_data_addr;
+	dma_addr_t secure_addr;
 	dma_addr_t bsev_ptr;
 	size_t lsize, csize;
 	size_t bitstream_data_size;
+	size_t secure_size;
 	unsigned int macroblocks_nb;
 	unsigned int read_bytes;
 	unsigned int cstride;
@@ -803,6 +815,18 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
 	if (ret)
 		return ret;
 
+	if (vde->soc->supports_ref_pic_marking) {
+		ret = tegra_vde_attach_dmabuf(dev, ctx.secure_fd,
+					      ctx.secure_offset, 0, SZ_256,
+					      &secure_attachment,
+					      &secure_addr,
+					      &secure_sgt,
+					      &secure_size,
+					      DMA_TO_DEVICE);
+		if (ret)
+			goto release_bitstream_dmabuf;
+	}
+
 	dpb_frames = kcalloc(ctx.dpb_frames_nb, sizeof(*dpb_frames),
 			     GFP_KERNEL);
 	if (!dpb_frames) {
@@ -876,6 +900,7 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
 	ret = tegra_vde_setup_hw_context(vde, &ctx, dpb_frames,
 					 bitstream_data_addr,
 					 bitstream_data_size,
+					 secure_addr,
 					 macroblocks_nb);
 	if (ret)
 		goto put_runtime_pm;
@@ -929,6 +954,10 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
 	kfree(dpb_frames);
 
 release_bitstream_dmabuf:
+	if (secure_attachment)
+		tegra_vde_detach_and_put_dmabuf(secure_attachment, secure_sgt,
+						DMA_TO_DEVICE);
+
 	tegra_vde_detach_and_put_dmabuf(bitstream_data_dmabuf_attachment,
 					bitstream_sgt, DMA_TO_DEVICE);
 
@@ -1029,6 +1058,8 @@ static int tegra_vde_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, vde);
 
+	vde->soc = of_device_get_match_data(&pdev->dev);
+
 	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "sxe");
 	if (!regs)
 		return -ENODEV;
@@ -1258,8 +1289,27 @@ static const struct dev_pm_ops tegra_vde_pm_ops = {
 				tegra_vde_pm_resume)
 };
 
+static const struct tegra_vde_soc tegra20_vde_soc = {
+	.supports_ref_pic_marking = false,
+};
+
+static const struct tegra_vde_soc tegra30_vde_soc = {
+	.supports_ref_pic_marking = false,
+};
+
+static const struct tegra_vde_soc tegra114_vde_soc = {
+	.supports_ref_pic_marking = true,
+};
+
+static const struct tegra_vde_soc tegra124_vde_soc = {
+	.supports_ref_pic_marking = true,
+};
+
 static const struct of_device_id tegra_vde_of_match[] = {
-	{ .compatible = "nvidia,tegra20-vde", },
+	{ .compatible = "nvidia,tegra124-vde", .data = &tegra124_vde_soc },
+	{ .compatible = "nvidia,tegra114-vde", .data = &tegra114_vde_soc },
+	{ .compatible = "nvidia,tegra30-vde", .data = &tegra30_vde_soc },
+	{ .compatible = "nvidia,tegra20-vde", .data = &tegra20_vde_soc },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, tegra_vde_of_match);
diff --git a/drivers/staging/media/tegra-vde/uapi.h b/drivers/staging/media/tegra-vde/uapi.h
index a50c7bcae057..58bfd56de55e 100644
--- a/drivers/staging/media/tegra-vde/uapi.h
+++ b/drivers/staging/media/tegra-vde/uapi.h
@@ -35,6 +35,9 @@ struct tegra_vde_h264_decoder_ctx {
 	__s32 bitstream_data_fd;
 	__u32 bitstream_data_offset;
 
+	__s32 secure_fd;
+	__u32 secure_offset;
+
 	__u64 dpb_frames_ptr;
 	__u8  dpb_frames_nb;
 	__u8  dpb_ref_frames_with_earlier_poc_nb;
-- 
2.17.0
