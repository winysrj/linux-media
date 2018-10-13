Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33512 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbeJMWys (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 Oct 2018 18:54:48 -0400
From: Christoph Hellwig <hch@lst.de>
To: linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] firmware: tegra: don't pass GFP_DMA32 to dma_alloc_coherent
Date: Sat, 13 Oct 2018 17:17:01 +0200
Message-Id: <20181013151707.32210-3-hch@lst.de>
In-Reply-To: <20181013151707.32210-1-hch@lst.de>
References: <20181013151707.32210-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DMA API does its own zone decisions based on the coherent_dma_mask.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/firmware/tegra/bpmp-debugfs.c | 11 +++++------
 drivers/firmware/tegra/bpmp.c         |  2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/tegra/bpmp-debugfs.c b/drivers/firmware/tegra/bpmp-debugfs.c
index f7f6a0a5cb07..567160897bac 100644
--- a/drivers/firmware/tegra/bpmp-debugfs.c
+++ b/drivers/firmware/tegra/bpmp-debugfs.c
@@ -218,12 +218,12 @@ static int debugfs_show(struct seq_file *m, void *p)
 		return -ENOENT;
 
 	namevirt = dma_alloc_coherent(bpmp->dev, namesize, &namephys,
-				      GFP_KERNEL | GFP_DMA32);
+				      GFP_KERNEL);
 	if (!namevirt)
 		return -ENOMEM;
 
 	datavirt = dma_alloc_coherent(bpmp->dev, datasize, &dataphys,
-				      GFP_KERNEL | GFP_DMA32);
+				      GFP_KERNEL);
 	if (!datavirt) {
 		ret = -ENOMEM;
 		goto free_namebuf;
@@ -269,12 +269,12 @@ static ssize_t debugfs_store(struct file *file, const char __user *buf,
 		return -ENOENT;
 
 	namevirt = dma_alloc_coherent(bpmp->dev, namesize, &namephys,
-				      GFP_KERNEL | GFP_DMA32);
+				      GFP_KERNEL);
 	if (!namevirt)
 		return -ENOMEM;
 
 	datavirt = dma_alloc_coherent(bpmp->dev, datasize, &dataphys,
-				      GFP_KERNEL | GFP_DMA32);
+				      GFP_KERNEL);
 	if (!datavirt) {
 		ret = -ENOMEM;
 		goto free_namebuf;
@@ -422,8 +422,7 @@ int tegra_bpmp_init_debugfs(struct tegra_bpmp *bpmp)
 	if (!root)
 		return -ENOMEM;
 
-	virt = dma_alloc_coherent(bpmp->dev, sz, &phys,
-				  GFP_KERNEL | GFP_DMA32);
+	virt = dma_alloc_coherent(bpmp->dev, sz, &phys, GFP_KERNEL);
 	if (!virt) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/drivers/firmware/tegra/bpmp.c b/drivers/firmware/tegra/bpmp.c
index 14a456afa379..e6d2356ccec3 100644
--- a/drivers/firmware/tegra/bpmp.c
+++ b/drivers/firmware/tegra/bpmp.c
@@ -531,7 +531,7 @@ static int tegra_bpmp_get_firmware_tag(struct tegra_bpmp *bpmp, char *tag,
 	int err;
 
 	virt = dma_alloc_coherent(bpmp->dev, MSG_DATA_MIN_SZ, &phys,
-				  GFP_KERNEL | GFP_DMA32);
+				  GFP_KERNEL);
 	if (!virt)
 		return -ENOMEM;
 
-- 
2.19.1
