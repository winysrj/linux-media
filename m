Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:49880 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1952438AbdDYSV3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 14:21:29 -0400
From: Logan Gunthorpe <logang@deltatee.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        megaraidlinux.pdl@broadcom.com, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, target-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dm-devel@redhat.com
Cc: Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 25 Apr 2017 12:21:04 -0600
Message-Id: <1493144468-22493-18-git-send-email-logang@deltatee.com>
In-Reply-To: <1493144468-22493-1-git-send-email-logang@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v2 17/21] mmc: spi: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We use the sg_map helper but it's slightly more complicated
as we only check for the error when the mapping actually gets used.
Such that if the mapping failed but wasn't needed then no
error occurs.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/mmc_spi.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 476e53d..d614f36 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -676,9 +676,15 @@ mmc_spi_writeblock(struct mmc_spi_host *host, struct spi_transfer *t,
 	struct scratch		*scratch = host->data;
 	u32			pattern;
 
-	if (host->mmc->use_spi_crc)
+	if (host->mmc->use_spi_crc) {
+		if (IS_ERR(t->tx_buf))
+			return PTR_ERR(t->tx_buf);
+
 		scratch->crc_val = cpu_to_be16(
 				crc_itu_t(0, t->tx_buf, t->len));
+		t->tx_buf += t->len;
+	}
+
 	if (host->dma_dev)
 		dma_sync_single_for_device(host->dma_dev,
 				host->data_dma, sizeof(*scratch),
@@ -743,7 +749,6 @@ mmc_spi_writeblock(struct mmc_spi_host *host, struct spi_transfer *t,
 		return status;
 	}
 
-	t->tx_buf += t->len;
 	if (host->dma_dev)
 		t->tx_dma += t->len;
 
@@ -809,6 +814,11 @@ mmc_spi_readblock(struct mmc_spi_host *host, struct spi_transfer *t,
 	}
 	leftover = status << 1;
 
+	if (bitshift || host->mmc->use_spi_crc) {
+		if (IS_ERR(t->rx_buf))
+			return PTR_ERR(t->rx_buf);
+	}
+
 	if (host->dma_dev) {
 		dma_sync_single_for_device(host->dma_dev,
 				host->data_dma, sizeof(*scratch),
@@ -860,9 +870,10 @@ mmc_spi_readblock(struct mmc_spi_host *host, struct spi_transfer *t,
 					scratch->crc_val, crc, t->len);
 			return -EILSEQ;
 		}
+
+		t->rx_buf += t->len;
 	}
 
-	t->rx_buf += t->len;
 	if (host->dma_dev)
 		t->rx_dma += t->len;
 
@@ -933,11 +944,11 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct mmc_command *cmd,
 		}
 
 		/* allow pio too; we don't allow highmem */
-		kmap_addr = kmap(sg_page(sg));
+		kmap_addr = sg_map(sg, 0, SG_KMAP);
 		if (direction == DMA_TO_DEVICE)
-			t->tx_buf = kmap_addr + sg->offset;
+			t->tx_buf = kmap_addr;
 		else
-			t->rx_buf = kmap_addr + sg->offset;
+			t->rx_buf = kmap_addr;
 
 		/* transfer each block, and update request status */
 		while (length) {
@@ -967,7 +978,8 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct mmc_command *cmd,
 		/* discard mappings */
 		if (direction == DMA_FROM_DEVICE)
 			flush_kernel_dcache_page(sg_page(sg));
-		kunmap(sg_page(sg));
+		if (!IS_ERR(kmap_addr))
+			sg_unmap(sg, kmap_addr, 0, SG_KMAP);
 		if (dma_dev)
 			dma_unmap_page(dma_dev, dma_addr, PAGE_SIZE, dir);
 
-- 
2.1.4
