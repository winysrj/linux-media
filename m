Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37279 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752437AbeAJSDf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 13:03:35 -0500
From: Christoph Hellwig <hch@lst.de>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Kong Lai <kong.lai@tundra.com>, linux-pci@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] tsi108_eth: use dma API properly
Date: Wed, 10 Jan 2018 19:03:21 +0100
Message-Id: <20180110180322.30186-4-hch@lst.de>
In-Reply-To: <20180110180322.30186-1-hch@lst.de>
References: <20180110180322.30186-1-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to pass a struct device to the dma API, even if some
architectures still support that for legacy reasons, and should not mix
it with the old PCI dma API.

Note that the driver also seems to never actually unmap its dma mappings,
but to fix that we'll need someone more familar with the driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/ethernet/tundra/tsi108_eth.c | 36 ++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index 0624b71ab5d4..edcd1e60b30d 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -152,6 +152,8 @@ struct tsi108_prv_data {
 	u32 msg_enable;			/* debug message level */
 	struct mii_if_info mii_if;
 	unsigned int init_media;
+
+	struct platform_device *pdev;
 };
 
 /* Structure for a device driver */
@@ -703,17 +705,18 @@ static int tsi108_send_packet(struct sk_buff * skb, struct net_device *dev)
 		data->txskbs[tx] = skb;
 
 		if (i == 0) {
-			data->txring[tx].buf0 = dma_map_single(NULL, skb->data,
-					skb_headlen(skb), DMA_TO_DEVICE);
+			data->txring[tx].buf0 = dma_map_single(&data->pdev->dev,
+					skb->data, skb_headlen(skb),
+					DMA_TO_DEVICE);
 			data->txring[tx].len = skb_headlen(skb);
 			misc |= TSI108_TX_SOF;
 		} else {
 			const skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
 
-			data->txring[tx].buf0 = skb_frag_dma_map(NULL, frag,
-								 0,
-								 skb_frag_size(frag),
-								 DMA_TO_DEVICE);
+			data->txring[tx].buf0 =
+				skb_frag_dma_map(&data->pdev->dev, frag,
+						0, skb_frag_size(frag),
+						DMA_TO_DEVICE);
 			data->txring[tx].len = skb_frag_size(frag);
 		}
 
@@ -808,9 +811,9 @@ static int tsi108_refill_rx(struct net_device *dev, int budget)
 		if (!skb)
 			break;
 
-		data->rxring[rx].buf0 = dma_map_single(NULL, skb->data,
-							TSI108_RX_SKB_SIZE,
-							DMA_FROM_DEVICE);
+		data->rxring[rx].buf0 = dma_map_single(&data->pdev->dev,
+				skb->data, TSI108_RX_SKB_SIZE,
+				DMA_FROM_DEVICE);
 
 		/* Sometimes the hardware sets blen to zero after packet
 		 * reception, even though the manual says that it's only ever
@@ -1308,15 +1311,15 @@ static int tsi108_open(struct net_device *dev)
 		       data->id, dev->irq, dev->name);
 	}
 
-	data->rxring = dma_zalloc_coherent(NULL, rxring_size, &data->rxdma,
-					   GFP_KERNEL);
+	data->rxring = dma_zalloc_coherent(&data->pdev->dev, rxring_size,
+			&data->rxdma, GFP_KERNEL);
 	if (!data->rxring)
 		return -ENOMEM;
 
-	data->txring = dma_zalloc_coherent(NULL, txring_size, &data->txdma,
-					   GFP_KERNEL);
+	data->txring = dma_zalloc_coherent(&data->pdev->dev, txring_size,
+			&data->txdma, GFP_KERNEL);
 	if (!data->txring) {
-		pci_free_consistent(NULL, rxring_size, data->rxring,
+		dma_free_coherent(&data->pdev->dev, rxring_size, data->rxring,
 				    data->rxdma);
 		return -ENOMEM;
 	}
@@ -1428,10 +1431,10 @@ static int tsi108_close(struct net_device *dev)
 		dev_kfree_skb(skb);
 	}
 
-	dma_free_coherent(0,
+	dma_free_coherent(&data->pdev->dev,
 			    TSI108_RXRING_LEN * sizeof(rx_desc),
 			    data->rxring, data->rxdma);
-	dma_free_coherent(0,
+	dma_free_coherent(&data->pdev->dev,
 			    TSI108_TXRING_LEN * sizeof(tx_desc),
 			    data->txring, data->txdma);
 
@@ -1576,6 +1579,7 @@ tsi108_init_one(struct platform_device *pdev)
 	printk("tsi108_eth%d: probe...\n", pdev->id);
 	data = netdev_priv(dev);
 	data->dev = dev;
+	data->pdev = pdev;
 
 	pr_debug("tsi108_eth%d:regs:phyresgs:phy:irq_num=0x%x:0x%x:0x%x:0x%x\n",
 			pdev->id, einfo->regs, einfo->phyregs,
-- 
2.14.2
