Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33367 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbbFXKtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 06:49:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 4/7] [media] saa7134: fix page size on some archs
Date: Wed, 24 Jun 2015 07:49:08 -0300
Message-Id: <3e796e44eed2afe0a7d26d346338d2a158196dd6.1435142906.git.mchehab@osg.samsung.com>
In-Reply-To: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
References: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
In-Reply-To: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
References: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On some archs, like tile, the PAGE_SIZE is not 4K. In the case
of tile arch, it can be either 16KB or 64KB.

Due to that, a warning is produced:
	drivers/media/pci/saa7134/saa7134.h:678:43: warning: large integer implicitly truncated to unsigned type [-Woverflow]

This is actually an error, as it will write trach to the DMA size
registers. The logic at saa7134-ts already does the right thing:

	saa_writeb(SAA7134_TS_DMA0, ((dev->ts.nr_packets-1)&0xff));
	saa_writeb(SAA7134_TS_DMA1, (((dev->ts.nr_packets-1)>>8)&0xff));
	/* TSNOPIT=0, TSCOLAP=0 */
	saa_writeb(SAA7134_TS_DMA2,
		((((dev->ts.nr_packets-1)>>16)&0x3f) | 0x00));

So, fix the driver to take larger page sizes into account.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-go7007.c b/drivers/media/pci/saa7134/saa7134-go7007.c
index da7c4be4bed2..8a2abb34186b 100644
--- a/drivers/media/pci/saa7134/saa7134-go7007.c
+++ b/drivers/media/pci/saa7134/saa7134-go7007.c
@@ -289,9 +289,9 @@ static int saa7134_go7007_stream_start(struct go7007 *go)
 
 	/* Set up transfer block size */
 	saa_writeb(SAA7134_TS_PARALLEL_SERIAL, 128 - 1);
-	saa_writeb(SAA7134_TS_DMA0, (PAGE_SIZE >> 7) - 1);
-	saa_writeb(SAA7134_TS_DMA1, 0);
-	saa_writeb(SAA7134_TS_DMA2, 0);
+	saa_writeb(SAA7134_TS_DMA0, ((PAGE_SIZE >> 7) - 1) & 0xff);
+	saa_writeb(SAA7134_TS_DMA1, (PAGE_SIZE >> 15) & 0xff);
+	saa_writeb(SAA7134_TS_DMA2, (PAGE_SIZE >> 31) & 0x3f);
 
 	/* Enable video streaming mode */
 	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_VIDEO);
-- 
2.4.3

