Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58571 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaIWLAA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 07:00:00 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/2] [media] saa7134: Remove some casting warnings
Date: Tue, 23 Sep 2014 07:59:43 -0300
Message-Id: <37b38486a1497804b63482af58a945f0eee8893f.1411469967.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/saa7134/saa7134-go7007.c:247:17: warning: incorrect type in argument 1 (different base types)
drivers/media/pci/saa7134/saa7134-go7007.c:247:17:    expected unsigned int [unsigned] val
drivers/media/pci/saa7134/saa7134-go7007.c:247:17:    got restricted __le32 [usertype] <noident>
drivers/media/pci/saa7134/saa7134-go7007.c:252:17: warning: incorrect type in argument 1 (different base types)
drivers/media/pci/saa7134/saa7134-go7007.c:252:17:    expected unsigned int [unsigned] val
drivers/media/pci/saa7134/saa7134-go7007.c:252:17:    got restricted __le32 [usertype] <noident>
drivers/media/pci/saa7134/saa7134-go7007.c:299:9: warning: incorrect type in argument 1 (different base types)
drivers/media/pci/saa7134/saa7134-go7007.c:299:9:    expected unsigned int [unsigned] val
drivers/media/pci/saa7134/saa7134-go7007.c:299:9:    got restricted __le32 [usertype] <noident>
drivers/media/pci/saa7134/saa7134-go7007.c:300:9: warning: incorrect type in argument 1 (different base types)
drivers/media/pci/saa7134/saa7134-go7007.c:300:9:    expected unsigned int [unsigned] val
drivers/media/pci/saa7134/saa7134-go7007.c:300:9:    got restricted __le32 [usertype] <noident>

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-go7007.c b/drivers/media/pci/saa7134/saa7134-go7007.c
index 3e9ca4821b8c..d9af6f3dc8af 100644
--- a/drivers/media/pci/saa7134/saa7134-go7007.c
+++ b/drivers/media/pci/saa7134/saa7134-go7007.c
@@ -244,12 +244,12 @@ static void saa7134_go7007_irq_ts_done(struct saa7134_dev *dev,
 		dma_sync_single_for_cpu(&dev->pci->dev,
 					saa->bottom_dma, PAGE_SIZE, DMA_FROM_DEVICE);
 		go7007_parse_video_stream(go, saa->bottom, PAGE_SIZE);
-		saa_writel(SAA7134_RS_BA2(5), cpu_to_le32(saa->bottom_dma));
+		saa_writel(SAA7134_RS_BA2(5), (__force u32)cpu_to_le32(saa->bottom_dma));
 	} else {
 		dma_sync_single_for_cpu(&dev->pci->dev,
 					saa->top_dma, PAGE_SIZE, DMA_FROM_DEVICE);
 		go7007_parse_video_stream(go, saa->top, PAGE_SIZE);
-		saa_writel(SAA7134_RS_BA1(5), cpu_to_le32(saa->top_dma));
+		saa_writel(SAA7134_RS_BA1(5), (__force u32)cpu_to_le32(saa->top_dma));
 	}
 }
 
@@ -296,8 +296,8 @@ static int saa7134_go7007_stream_start(struct go7007 *go)
 	/* Enable video streaming mode */
 	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_VIDEO);
 
-	saa_writel(SAA7134_RS_BA1(5), cpu_to_le32(saa->top_dma));
-	saa_writel(SAA7134_RS_BA2(5), cpu_to_le32(saa->bottom_dma));
+	saa_writel(SAA7134_RS_BA1(5), (__force u32)cpu_to_le32(saa->top_dma));
+	saa_writel(SAA7134_RS_BA2(5), (__force u32)cpu_to_le32(saa->bottom_dma));
 	saa_writel(SAA7134_RS_PITCH(5), 128);
 	saa_writel(SAA7134_RS_CONTROL(5), SAA7134_RS_CONTROL_BURST_MAX);
 
-- 
1.9.3

