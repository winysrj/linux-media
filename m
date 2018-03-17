Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:44203 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752662AbeCQP2e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Mar 2018 11:28:34 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/5] media: staging: tegra-vde: Align bitstream size to 16K
Date: Sat, 17 Mar 2018 18:28:11 +0300
Message-Id: <8b159c6ccf8ea2e052222ffc498cc9f782ac8d49.1521300358.git.digetx@gmail.com>
In-Reply-To: <cover.1521300358.git.digetx@gmail.com>
References: <cover.1521300358.git.digetx@gmail.com>
In-Reply-To: <cover.1521300358.git.digetx@gmail.com>
References: <cover.1521300358.git.digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've noticed that decoding fails sometime if size of bitstream buffer
isn't aligned to 16K, probably because HW fetches data from memory in
a 16K granularity and if the last chunk of data isn't aligned, HW reads
garbage data beyond the dmabuf and tries to parse it.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/staging/media/tegra-vde/tegra-vde.c | 40 ++++++++++++-----------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
index c47659e96089..c2ff2071b23c 100644
--- a/drivers/staging/media/tegra-vde/tegra-vde.c
+++ b/drivers/staging/media/tegra-vde/tegra-vde.c
@@ -440,7 +440,7 @@ static int tegra_vde_setup_hw_context(struct tegra_vde *vde,
 	VDE_WR(value, vde->sxe + 0x4C);
 
 	value = 0x03800000;
-	value |= min_t(size_t, bitstream_data_size, SZ_1M);
+	value |= bitstream_data_size & GENMASK(19, 15);
 
 	VDE_WR(value, vde->sxe + 0x68);
 
@@ -522,7 +522,8 @@ static void tegra_vde_detach_and_put_dmabuf(struct dma_buf_attachment *a,
 static int tegra_vde_attach_dmabuf(struct device *dev,
 				   int fd,
 				   unsigned long offset,
-				   unsigned int min_size,
+				   size_t min_size,
+				   size_t align_size,
 				   struct dma_buf_attachment **a,
 				   dma_addr_t *addr,
 				   struct sg_table **s,
@@ -540,9 +541,16 @@ static int tegra_vde_attach_dmabuf(struct device *dev,
 		return PTR_ERR(dmabuf);
 	}
 
+	if (dmabuf->size & (align_size - 1)) {
+		dev_err(dev, "Unaligned dmabuf 0x%zX, "
+			     "should be aligned to 0x%zX\n",
+			dmabuf->size, align_size);
+		return -EINVAL;
+	}
+
 	if ((u64)offset + min_size > dmabuf->size) {
 		dev_err(dev, "Too small dmabuf size %zu @0x%lX, "
-			     "should be at least %d\n",
+			     "should be at least %zu\n",
 			dmabuf->size, offset, min_size);
 		return -EINVAL;
 	}
@@ -596,7 +604,7 @@ static int tegra_vde_attach_dmabufs_to_frame(struct device *dev,
 	int err;
 
 	err = tegra_vde_attach_dmabuf(dev, src->y_fd,
-				      src->y_offset, csize * 4,
+				      src->y_offset, csize * 4, SZ_256,
 				      &frame->y_dmabuf_attachment,
 				      &frame->y_addr,
 				      &frame->y_sgt,
@@ -605,7 +613,7 @@ static int tegra_vde_attach_dmabufs_to_frame(struct device *dev,
 		return err;
 
 	err = tegra_vde_attach_dmabuf(dev, src->cb_fd,
-				      src->cb_offset, csize,
+				      src->cb_offset, csize, SZ_256,
 				      &frame->cb_dmabuf_attachment,
 				      &frame->cb_addr,
 				      &frame->cb_sgt,
@@ -614,7 +622,7 @@ static int tegra_vde_attach_dmabufs_to_frame(struct device *dev,
 		goto err_release_y;
 
 	err = tegra_vde_attach_dmabuf(dev, src->cr_fd,
-				      src->cr_offset, csize,
+				      src->cr_offset, csize, SZ_256,
 				      &frame->cr_dmabuf_attachment,
 				      &frame->cr_addr,
 				      &frame->cr_sgt,
@@ -628,7 +636,7 @@ static int tegra_vde_attach_dmabufs_to_frame(struct device *dev,
 	}
 
 	err = tegra_vde_attach_dmabuf(dev, src->aux_fd,
-				      src->aux_offset, csize,
+				      src->aux_offset, csize, SZ_256,
 				      &frame->aux_dmabuf_attachment,
 				      &frame->aux_addr,
 				      &frame->aux_sgt,
@@ -677,21 +685,6 @@ static int tegra_vde_validate_frame(struct device *dev,
 		return -EINVAL;
 	}
 
-	if (frame->y_offset & 0xFF) {
-		dev_err(dev, "Bad y_offset 0x%X\n", frame->y_offset);
-		return -EINVAL;
-	}
-
-	if (frame->cb_offset & 0xFF) {
-		dev_err(dev, "Bad cb_offset 0x%X\n", frame->cb_offset);
-		return -EINVAL;
-	}
-
-	if (frame->cr_offset & 0xFF) {
-		dev_err(dev, "Bad cr_offset 0x%X\n", frame->cr_offset);
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
@@ -792,7 +785,8 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
 		return ret;
 
 	ret = tegra_vde_attach_dmabuf(dev, ctx.bitstream_data_fd,
-				      ctx.bitstream_data_offset, 0,
+				      ctx.bitstream_data_offset,
+				      SZ_16K, SZ_16K,
 				      &bitstream_data_dmabuf_attachment,
 				      &bitstream_data_addr,
 				      &bitstream_sgt,
-- 
2.16.1
