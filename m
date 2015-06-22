Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbbFVP4k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 11:56:40 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kamil Debski <k.debski@samsung.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] [media] bdisp: prevent compiling on random arch
Date: Mon, 22 Jun 2015 12:56:00 -0300
Message-Id: <51f6dec49b0a241ba77ef60a0d9b22f88eb80af4.1434988554.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver requires support for DMA attrs function, and not
just DMA. Change the options accordingly to remove those errors:

/devel/v4l/to_next/drivers/media/platform/sti/bdisp/bdisp-hw.c: In function ‘bdisp_hw_free_nodes’:
/devel/v4l/to_next/drivers/media/platform/sti/bdisp/bdisp-hw.c:132:3: error: implicit declaration of function ‘dma_free_attrs’ [-Werror=implicit-function-declaration]
   dma_free_attrs(ctx->bdisp_dev->dev,
   ^
/devel/v4l/to_next/drivers/media/platform/sti/bdisp/bdisp-hw.c: In function ‘bdisp_hw_alloc_nodes’:
/devel/v4l/to_next/drivers/media/platform/sti/bdisp/bdisp-hw.c:157:9: error: implicit declaration of function ‘dma_alloc_attrs’ [-Werror=implicit-function-declaration]
  base = dma_alloc_attrs(dev, node_size * MAX_NB_NODE, &paddr,
         ^
/devel/v4l/to_next/drivers/media/platform/sti/bdisp/bdisp-hw.c:157:7: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
  base = dma_alloc_attrs(dev, node_size * MAX_NB_NODE, &paddr,
       ^
/devel/v4l/to_next/drivers/media/platform/sti/bdisp/bdisp-hw.c: In function ‘bdisp_hw_alloc_filters’:
/devel/v4l/to_next/drivers/media/platform/sti/bdisp/bdisp-hw.c:219:7: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
  base = dma_alloc_attrs(dev, size, &paddr, GFP_KERNEL | GFP_DMA, &attrs);

Also, get rid of bogus, unused and duplicated symbol declaration
for the config option done at bdisp/Kconfig.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

 delete mode 100644 drivers/media/platform/sti/bdisp/Kconfig

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 4776a8cb1071..a4e7d21c9e4c 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -216,7 +216,7 @@ config VIDEO_STI_BDISP
 	tristate "STMicroelectronics BDISP 2D blitter driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_STI || COMPILE_TEST
-	depends on HAS_DMA
+	depends on HAVE_DMA_ATTRS
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
diff --git a/drivers/media/platform/sti/bdisp/Kconfig b/drivers/media/platform/sti/bdisp/Kconfig
deleted file mode 100644
index afaf4a6ecc72..000000000000
--- a/drivers/media/platform/sti/bdisp/Kconfig
+++ /dev/null
@@ -1,9 +0,0 @@
-config VIDEO_STI_BDISP
-	tristate "STMicroelectronics BDISP 2D blitter driver"
-	depends on VIDEO_DEV && VIDEO_V4L2
-	select VIDEOBUF2_DMA_CONTIG
-	select V4L2_MEM2MEM_DEV
-	help
-	 This v4l2 mem2mem driver is a 2D blitter for STMicroelectronics SoC.
-	 To compile this driver as a module, choose M here: the module will
-	 be called bdisp.ko.
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
