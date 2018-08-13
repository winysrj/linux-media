Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:54351 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729900AbeHMRdW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 13:33:22 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 09/14] staging: media: tegra-vde: Add IOMMU support
Date: Mon, 13 Aug 2018 16:50:22 +0200
Message-Id: <20180813145027.16346-10-thierry.reding@gmail.com>
In-Reply-To: <20180813145027.16346-1-thierry.reding@gmail.com>
References: <20180813145027.16346-1-thierry.reding@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Thierry Reding <treding@nvidia.com>

Implement support for using an IOMMU to map physically discontiguous
buffers into contiguous I/O virtual mappings that the VDE can use. This
allows importing arbitrary DMA-BUFs for use by the VDE.

While at it, make sure that the device is detached from any DMA/IOMMU
mapping that it might have automatically been attached to at boot. If
using the IOMMU API explicitly, detaching from any existing mapping is
required to avoid double mapping of buffers.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/staging/media/tegra-vde/tegra-vde.c | 171 +++++++++++++++++---
 1 file changed, 153 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
index 2496a03fd158..3bc0bfcfe34e 100644
--- a/drivers/staging/media/tegra-vde/tegra-vde.c
+++ b/drivers/staging/media/tegra-vde/tegra-vde.c
@@ -13,7 +13,9 @@
 #include <linux/dma-buf.h>
 #include <linux/genalloc.h>
 #include <linux/interrupt.h>
+#include <linux/iommu.h>
 #include <linux/iopoll.h>
+#include <linux/iova.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
@@ -22,6 +24,10 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
+#if IS_ENABLED(CONFIG_ARM_DMA_USE_IOMMU)
+#include <asm/dma-iommu.h>
+#endif
+
 #include <soc/tegra/pmc.h>
 
 #include <drm/drm_fourcc.h>
@@ -61,6 +67,11 @@ struct video_frame {
 	u32 frame_num;
 	u32 flags;
 	u64 modifier;
+
+	struct iova *y_iova;
+	struct iova *cb_iova;
+	struct iova *cr_iova;
+	struct iova *aux_iova;
 };
 
 struct tegra_vde_soc {
@@ -93,6 +104,12 @@ struct tegra_vde {
 	struct clk *clk_bsev;
 	dma_addr_t iram_lists_addr;
 	u32 *iram;
+
+	struct iommu_domain *domain;
+	struct iommu_group *group;
+	struct iova_domain iova;
+	unsigned long limit;
+	unsigned int shift;
 };
 
 static void tegra_vde_set_bits(struct tegra_vde *vde,
@@ -634,12 +651,22 @@ static void tegra_vde_decode_frame(struct tegra_vde *vde,
 	VDE_WR(0x20000000 | (macroblocks_nb - 1), vde->sxe + 0x00);
 }
 
-static void tegra_vde_detach_and_put_dmabuf(struct dma_buf_attachment *a,
+static void tegra_vde_detach_and_put_dmabuf(struct tegra_vde *vde,
+					    struct dma_buf_attachment *a,
 					    struct sg_table *sgt,
+					    struct iova *iova,
 					    enum dma_data_direction dma_dir)
 {
 	struct dma_buf *dmabuf = a->dmabuf;
 
+	if (vde->domain) {
+		unsigned long size = iova_size(iova) << vde->shift;
+		dma_addr_t addr = iova_dma_addr(&vde->iova, iova);
+
+		iommu_unmap(vde->domain, addr, size);
+		__free_iova(&vde->iova, iova);
+	}
+
 	dma_buf_unmap_attachment(a, sgt, dma_dir);
 	dma_buf_detach(dmabuf, a);
 	dma_buf_put(dmabuf);
@@ -651,14 +678,16 @@ static int tegra_vde_attach_dmabuf(struct tegra_vde *vde,
 				   size_t min_size,
 				   size_t align_size,
 				   struct dma_buf_attachment **a,
-				   dma_addr_t *addr,
+				   dma_addr_t *addrp,
 				   struct sg_table **s,
-				   size_t *size,
+				   struct iova **iovap,
+				   size_t *sizep,
 				   enum dma_data_direction dma_dir)
 {
 	struct dma_buf_attachment *attachment;
 	struct dma_buf *dmabuf;
 	struct sg_table *sgt;
+	size_t size;
 	int err;
 
 	dmabuf = dma_buf_get(fd);
@@ -695,18 +724,47 @@ static int tegra_vde_attach_dmabuf(struct tegra_vde *vde,
 		goto err_detach;
 	}
 
-	if (sgt->nents != 1) {
+	if (sgt->nents > 1 && !vde->domain) {
 		dev_err(vde->dev, "Sparse DMA region is unsupported\n");
 		err = -EINVAL;
 		goto err_unmap;
 	}
 
-	*addr = sg_dma_address(sgt->sgl) + offset;
+	if (vde->domain) {
+		int prot = IOMMU_READ | IOMMU_WRITE;
+		struct iova *iova;
+		dma_addr_t addr;
+
+		size = (dmabuf->size - offset) >> vde->shift;
+
+		iova = alloc_iova(&vde->iova, size, vde->limit - 1, true);
+		if (!iova) {
+			err = -ENOMEM;
+			goto err_unmap;
+		}
+
+		addr = iova_dma_addr(&vde->iova, iova);
+
+		size = iommu_map_sg(vde->domain, addr, sgt->sgl, sgt->nents,
+				    prot);
+		if (!size) {
+			__free_iova(&vde->iova, iova);
+			err = -ENXIO;
+			goto err_unmap;
+		}
+
+		*addrp = addr;
+		*iovap = iova;
+	} else {
+		*addrp = sg_dma_address(sgt->sgl) + offset;
+		size = dmabuf->size - offset;
+	}
+
 	*a = attachment;
 	*s = sgt;
 
-	if (size)
-		*size = dmabuf->size - offset;
+	if (sizep)
+		*sizep = size;
 
 	return 0;
 
@@ -734,6 +792,7 @@ static int tegra_vde_attach_dmabufs_to_frame(struct tegra_vde *vde,
 				      &frame->y_dmabuf_attachment,
 				      &frame->y_addr,
 				      &frame->y_sgt,
+				      &frame->y_iova,
 				      NULL, dma_dir);
 	if (err)
 		return err;
@@ -743,6 +802,7 @@ static int tegra_vde_attach_dmabufs_to_frame(struct tegra_vde *vde,
 				      &frame->cb_dmabuf_attachment,
 				      &frame->cb_addr,
 				      &frame->cb_sgt,
+				      &frame->cb_iova,
 				      NULL, dma_dir);
 	if (err)
 		goto err_release_y;
@@ -752,6 +812,7 @@ static int tegra_vde_attach_dmabufs_to_frame(struct tegra_vde *vde,
 				      &frame->cr_dmabuf_attachment,
 				      &frame->cr_addr,
 				      &frame->cr_sgt,
+				      &frame->cr_iova,
 				      NULL, dma_dir);
 	if (err)
 		goto err_release_cb;
@@ -766,6 +827,7 @@ static int tegra_vde_attach_dmabufs_to_frame(struct tegra_vde *vde,
 				      &frame->aux_dmabuf_attachment,
 				      &frame->aux_addr,
 				      &frame->aux_sgt,
+				      &frame->aux_iova,
 				      NULL, dma_dir);
 	if (err)
 		goto err_release_cr;
@@ -774,13 +836,16 @@ static int tegra_vde_attach_dmabufs_to_frame(struct tegra_vde *vde,
 
 err_release_cr:
 	tegra_vde_detach_and_put_dmabuf(vde, frame->cr_dmabuf_attachment,
-					frame->cr_sgt, dma_dir);
+					frame->cr_sgt, frame->cr_iova,
+					dma_dir);
 err_release_cb:
 	tegra_vde_detach_and_put_dmabuf(vde, frame->cb_dmabuf_attachment,
-					frame->cb_sgt, dma_dir);
+					frame->cb_sgt, frame->cb_iova,
+					dma_dir);
 err_release_y:
 	tegra_vde_detach_and_put_dmabuf(vde, frame->y_dmabuf_attachment,
-					frame->y_sgt, dma_dir);
+					frame->y_sgt, frame->y_iova,
+					dma_dir);
 
 	return err;
 }
@@ -793,16 +858,20 @@ static void tegra_vde_release_frame_dmabufs(struct tegra_vde *vde,
 	if (!baseline_profile)
 		tegra_vde_detach_and_put_dmabuf(vde,
 						frame->aux_dmabuf_attachment,
-						frame->aux_sgt, dma_dir);
+						frame->aux_sgt,
+						frame->aux_iova, dma_dir);
 
 	tegra_vde_detach_and_put_dmabuf(vde, frame->cr_dmabuf_attachment,
-					frame->cr_sgt, dma_dir);
+					frame->cr_sgt, frame->cr_iova,
+					dma_dir);
 
 	tegra_vde_detach_and_put_dmabuf(vde, frame->cb_dmabuf_attachment,
-					frame->cb_sgt, dma_dir);
+					frame->cb_sgt, frame->cb_iova,
+					dma_dir);
 
 	tegra_vde_detach_and_put_dmabuf(vde, frame->y_dmabuf_attachment,
-					frame->y_sgt, dma_dir);
+					frame->y_sgt, frame->y_iova,
+					dma_dir);
 }
 
 static int tegra_vde_validate_frame(struct device *dev,
@@ -923,6 +992,8 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
 	struct sg_table *bitstream_sgt, *secure_sgt;
 	enum dma_data_direction dma_dir;
 	dma_addr_t bitstream_data_addr;
+	struct iova *bitstream_iova;
+	struct iova *secure_iova;
 	dma_addr_t secure_addr;
 	dma_addr_t bsev_ptr;
 	size_t lsize, csize;
@@ -948,6 +1019,7 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
 				      &bitstream_data_dmabuf_attachment,
 				      &bitstream_data_addr,
 				      &bitstream_sgt,
+				      &bitstream_iova,
 				      &bitstream_data_size,
 				      DMA_TO_DEVICE);
 	if (ret)
@@ -959,6 +1031,7 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
 					      &secure_attachment,
 					      &secure_addr,
 					      &secure_sgt,
+					      &secure_iova,
 					      &secure_size,
 					      DMA_TO_DEVICE);
 		if (ret)
@@ -1095,12 +1168,13 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
 release_bitstream_dmabuf:
 	if (secure_attachment)
 		tegra_vde_detach_and_put_dmabuf(vde, secure_attachment,
-						secure_sgt,
+						secure_sgt, secure_iova,
 						DMA_TO_DEVICE);
 
 	tegra_vde_detach_and_put_dmabuf(vde,
 					bitstream_data_dmabuf_attachment,
-					bitstream_sgt, DMA_TO_DEVICE);
+					bitstream_sgt, bitstream_iova,
+					DMA_TO_DEVICE);
 
 	return ret;
 }
@@ -1193,6 +1267,15 @@ static int tegra_vde_probe(struct platform_device *pdev)
 	struct tegra_vde *vde;
 	int irq, err;
 
+#if IS_ENABLED(CONFIG_ARM_DMA_USE_IOMMU)
+	if (dev->archdata.mapping) {
+		struct dma_iommu_mapping *mapping = to_dma_iommu_mapping(dev);
+
+		arm_iommu_detach_device(dev);
+		arm_iommu_release_mapping(mapping);
+	}
+#endif
+
 	vde = devm_kzalloc(dev, sizeof(*vde), GFP_KERNEL);
 	if (!vde)
 		return -ENOMEM;
@@ -1335,6 +1418,37 @@ static int tegra_vde_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	vde->group = iommu_group_get(dev);
+	if (vde->group) {
+		unsigned long order;
+
+		vde->domain = iommu_domain_alloc(&platform_bus_type);
+		if (!vde->domain) {
+			iommu_group_put(vde->group);
+			vde->group = NULL;
+		} else {
+			err = iova_cache_get();
+			if (err < 0)
+				goto free_domain;
+
+			order = __ffs(vde->domain->pgsize_bitmap);
+
+			init_iova_domain(&vde->iova, 1UL << order, 0);
+			vde->shift = iova_shift(&vde->iova);
+			vde->limit = 1 << (32 - vde->shift);
+
+			/*
+			 * VDE doesn't seem to like accessing the last page of
+			 * its 32-bit address space.
+			 */
+			vde->limit -= 1;
+
+			err = iommu_attach_group(vde->domain, vde->group);
+			if (err < 0)
+				goto put_cache;
+		}
+	}
+
 	mutex_init(&vde->lock);
 	init_completion(&vde->decode_completion);
 
@@ -1346,7 +1460,7 @@ static int tegra_vde_probe(struct platform_device *pdev)
 	err = misc_register(&vde->miscdev);
 	if (err) {
 		dev_err(dev, "Failed to register misc device: %d\n", err);
-		goto err_gen_free;
+		goto detach;
 	}
 
 	pm_runtime_enable(dev);
@@ -1364,7 +1478,21 @@ static int tegra_vde_probe(struct platform_device *pdev)
 err_misc_unreg:
 	misc_deregister(&vde->miscdev);
 
-err_gen_free:
+detach:
+	if (vde->domain)
+		iommu_detach_group(vde->domain, vde->group);
+
+put_cache:
+	if (vde->domain)
+		iova_cache_put();
+
+free_domain:
+	if (vde->domain)
+		iommu_domain_free(vde->domain);
+
+	if (vde->group)
+		iommu_group_put(vde->group);
+
 	gen_pool_free(vde->iram_pool, (unsigned long)vde->iram,
 		      gen_pool_size(vde->iram_pool));
 
@@ -1388,6 +1516,13 @@ static int tegra_vde_remove(struct platform_device *pdev)
 
 	misc_deregister(&vde->miscdev);
 
+	if (vde->domain) {
+		iommu_detach_group(vde->domain, vde->group);
+		iova_cache_put();
+		iommu_domain_free(vde->domain);
+		iommu_group_put(vde->group);
+	}
+
 	gen_pool_free(vde->iram_pool, (unsigned long)vde->iram,
 		      gen_pool_size(vde->iram_pool));
 
-- 
2.17.0
